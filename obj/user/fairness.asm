
obj/user/fairness.debug:     file format elf32-i386


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
  80002c:	e8 70 00 00 00       	call   8000a1 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 10             	sub    $0x10,%esp
	envid_t who, id;

	id = sys_getenvid();
  80003b:	e8 18 0d 00 00       	call   800d58 <sys_getenvid>
  800040:	89 c3                	mov    %eax,%ebx

	if (thisenv == &envs[1]) {
  800042:	81 3d 08 40 80 00 84 	cmpl   $0xeec00084,0x804008
  800049:	00 c0 ee 
  80004c:	74 2d                	je     80007b <umain+0x48>
		while (1) {
			ipc_recv(&who, 0, 0);
			cprintf("%x recv from %x\n", id, who);
		}
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  80004e:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	50                   	push   %eax
  800057:	53                   	push   %ebx
  800058:	68 f1 25 80 00       	push   $0x8025f1
  80005d:	e8 e3 01 00 00       	call   800245 <cprintf>
  800062:	83 c4 10             	add    $0x10,%esp
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  800065:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  80006a:	6a 00                	push   $0x0
  80006c:	6a 00                	push   $0x0
  80006e:	6a 00                	push   $0x0
  800070:	50                   	push   %eax
  800071:	e8 7e 10 00 00       	call   8010f4 <ipc_send>
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	eb ea                	jmp    800065 <umain+0x32>
			ipc_recv(&who, 0, 0);
  80007b:	8d 75 f4             	lea    -0xc(%ebp),%esi
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	6a 00                	push   $0x0
  800083:	6a 00                	push   $0x0
  800085:	56                   	push   %esi
  800086:	e8 00 10 00 00       	call   80108b <ipc_recv>
			cprintf("%x recv from %x\n", id, who);
  80008b:	83 c4 0c             	add    $0xc,%esp
  80008e:	ff 75 f4             	pushl  -0xc(%ebp)
  800091:	53                   	push   %ebx
  800092:	68 e0 25 80 00       	push   $0x8025e0
  800097:	e8 a9 01 00 00       	call   800245 <cprintf>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	eb dd                	jmp    80007e <umain+0x4b>

008000a1 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8000a1:	55                   	push   %ebp
  8000a2:	89 e5                	mov    %esp,%ebp
  8000a4:	57                   	push   %edi
  8000a5:	56                   	push   %esi
  8000a6:	53                   	push   %ebx
  8000a7:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8000aa:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  8000b1:	00 00 00 
	envid_t find = sys_getenvid();
  8000b4:	e8 9f 0c 00 00       	call   800d58 <sys_getenvid>
  8000b9:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  8000bf:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8000c4:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8000c9:	bf 01 00 00 00       	mov    $0x1,%edi
  8000ce:	eb 0b                	jmp    8000db <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8000d0:	83 c2 01             	add    $0x1,%edx
  8000d3:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000d9:	74 23                	je     8000fe <libmain+0x5d>
		if(envs[i].env_id == find)
  8000db:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  8000e1:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000e7:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000ea:	39 c1                	cmp    %eax,%ecx
  8000ec:	75 e2                	jne    8000d0 <libmain+0x2f>
  8000ee:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  8000f4:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000fa:	89 fe                	mov    %edi,%esi
  8000fc:	eb d2                	jmp    8000d0 <libmain+0x2f>
  8000fe:	89 f0                	mov    %esi,%eax
  800100:	84 c0                	test   %al,%al
  800102:	74 06                	je     80010a <libmain+0x69>
  800104:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80010e:	7e 0a                	jle    80011a <libmain+0x79>
		binaryname = argv[0];
  800110:	8b 45 0c             	mov    0xc(%ebp),%eax
  800113:	8b 00                	mov    (%eax),%eax
  800115:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80011a:	a1 08 40 80 00       	mov    0x804008,%eax
  80011f:	8b 40 48             	mov    0x48(%eax),%eax
  800122:	83 ec 08             	sub    $0x8,%esp
  800125:	50                   	push   %eax
  800126:	68 08 26 80 00       	push   $0x802608
  80012b:	e8 15 01 00 00       	call   800245 <cprintf>
	cprintf("before umain\n");
  800130:	c7 04 24 26 26 80 00 	movl   $0x802626,(%esp)
  800137:	e8 09 01 00 00       	call   800245 <cprintf>
	// call user main routine
	umain(argc, argv);
  80013c:	83 c4 08             	add    $0x8,%esp
  80013f:	ff 75 0c             	pushl  0xc(%ebp)
  800142:	ff 75 08             	pushl  0x8(%ebp)
  800145:	e8 e9 fe ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  80014a:	c7 04 24 34 26 80 00 	movl   $0x802634,(%esp)
  800151:	e8 ef 00 00 00       	call   800245 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800156:	a1 08 40 80 00       	mov    0x804008,%eax
  80015b:	8b 40 48             	mov    0x48(%eax),%eax
  80015e:	83 c4 08             	add    $0x8,%esp
  800161:	50                   	push   %eax
  800162:	68 41 26 80 00       	push   $0x802641
  800167:	e8 d9 00 00 00       	call   800245 <cprintf>
	// exit gracefully
	exit();
  80016c:	e8 0b 00 00 00       	call   80017c <exit>
}
  800171:	83 c4 10             	add    $0x10,%esp
  800174:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800177:	5b                   	pop    %ebx
  800178:	5e                   	pop    %esi
  800179:	5f                   	pop    %edi
  80017a:	5d                   	pop    %ebp
  80017b:	c3                   	ret    

0080017c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800182:	a1 08 40 80 00       	mov    0x804008,%eax
  800187:	8b 40 48             	mov    0x48(%eax),%eax
  80018a:	68 6c 26 80 00       	push   $0x80266c
  80018f:	50                   	push   %eax
  800190:	68 60 26 80 00       	push   $0x802660
  800195:	e8 ab 00 00 00       	call   800245 <cprintf>
	close_all();
  80019a:	e8 c4 11 00 00       	call   801363 <close_all>
	sys_env_destroy(0);
  80019f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001a6:	e8 6c 0b 00 00       	call   800d17 <sys_env_destroy>
}
  8001ab:	83 c4 10             	add    $0x10,%esp
  8001ae:	c9                   	leave  
  8001af:	c3                   	ret    

008001b0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001b0:	55                   	push   %ebp
  8001b1:	89 e5                	mov    %esp,%ebp
  8001b3:	53                   	push   %ebx
  8001b4:	83 ec 04             	sub    $0x4,%esp
  8001b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001ba:	8b 13                	mov    (%ebx),%edx
  8001bc:	8d 42 01             	lea    0x1(%edx),%eax
  8001bf:	89 03                	mov    %eax,(%ebx)
  8001c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001c4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001c8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001cd:	74 09                	je     8001d8 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001cf:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001d6:	c9                   	leave  
  8001d7:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001d8:	83 ec 08             	sub    $0x8,%esp
  8001db:	68 ff 00 00 00       	push   $0xff
  8001e0:	8d 43 08             	lea    0x8(%ebx),%eax
  8001e3:	50                   	push   %eax
  8001e4:	e8 f1 0a 00 00       	call   800cda <sys_cputs>
		b->idx = 0;
  8001e9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001ef:	83 c4 10             	add    $0x10,%esp
  8001f2:	eb db                	jmp    8001cf <putch+0x1f>

008001f4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001f4:	55                   	push   %ebp
  8001f5:	89 e5                	mov    %esp,%ebp
  8001f7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001fd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800204:	00 00 00 
	b.cnt = 0;
  800207:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80020e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800211:	ff 75 0c             	pushl  0xc(%ebp)
  800214:	ff 75 08             	pushl  0x8(%ebp)
  800217:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80021d:	50                   	push   %eax
  80021e:	68 b0 01 80 00       	push   $0x8001b0
  800223:	e8 4a 01 00 00       	call   800372 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800228:	83 c4 08             	add    $0x8,%esp
  80022b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800231:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800237:	50                   	push   %eax
  800238:	e8 9d 0a 00 00       	call   800cda <sys_cputs>

	return b.cnt;
}
  80023d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800243:	c9                   	leave  
  800244:	c3                   	ret    

00800245 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800245:	55                   	push   %ebp
  800246:	89 e5                	mov    %esp,%ebp
  800248:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80024b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80024e:	50                   	push   %eax
  80024f:	ff 75 08             	pushl  0x8(%ebp)
  800252:	e8 9d ff ff ff       	call   8001f4 <vcprintf>
	va_end(ap);

	return cnt;
}
  800257:	c9                   	leave  
  800258:	c3                   	ret    

00800259 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800259:	55                   	push   %ebp
  80025a:	89 e5                	mov    %esp,%ebp
  80025c:	57                   	push   %edi
  80025d:	56                   	push   %esi
  80025e:	53                   	push   %ebx
  80025f:	83 ec 1c             	sub    $0x1c,%esp
  800262:	89 c6                	mov    %eax,%esi
  800264:	89 d7                	mov    %edx,%edi
  800266:	8b 45 08             	mov    0x8(%ebp),%eax
  800269:	8b 55 0c             	mov    0xc(%ebp),%edx
  80026c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80026f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800272:	8b 45 10             	mov    0x10(%ebp),%eax
  800275:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800278:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80027c:	74 2c                	je     8002aa <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80027e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800281:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800288:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80028b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80028e:	39 c2                	cmp    %eax,%edx
  800290:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800293:	73 43                	jae    8002d8 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800295:	83 eb 01             	sub    $0x1,%ebx
  800298:	85 db                	test   %ebx,%ebx
  80029a:	7e 6c                	jle    800308 <printnum+0xaf>
				putch(padc, putdat);
  80029c:	83 ec 08             	sub    $0x8,%esp
  80029f:	57                   	push   %edi
  8002a0:	ff 75 18             	pushl  0x18(%ebp)
  8002a3:	ff d6                	call   *%esi
  8002a5:	83 c4 10             	add    $0x10,%esp
  8002a8:	eb eb                	jmp    800295 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002aa:	83 ec 0c             	sub    $0xc,%esp
  8002ad:	6a 20                	push   $0x20
  8002af:	6a 00                	push   $0x0
  8002b1:	50                   	push   %eax
  8002b2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b5:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b8:	89 fa                	mov    %edi,%edx
  8002ba:	89 f0                	mov    %esi,%eax
  8002bc:	e8 98 ff ff ff       	call   800259 <printnum>
		while (--width > 0)
  8002c1:	83 c4 20             	add    $0x20,%esp
  8002c4:	83 eb 01             	sub    $0x1,%ebx
  8002c7:	85 db                	test   %ebx,%ebx
  8002c9:	7e 65                	jle    800330 <printnum+0xd7>
			putch(padc, putdat);
  8002cb:	83 ec 08             	sub    $0x8,%esp
  8002ce:	57                   	push   %edi
  8002cf:	6a 20                	push   $0x20
  8002d1:	ff d6                	call   *%esi
  8002d3:	83 c4 10             	add    $0x10,%esp
  8002d6:	eb ec                	jmp    8002c4 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d8:	83 ec 0c             	sub    $0xc,%esp
  8002db:	ff 75 18             	pushl  0x18(%ebp)
  8002de:	83 eb 01             	sub    $0x1,%ebx
  8002e1:	53                   	push   %ebx
  8002e2:	50                   	push   %eax
  8002e3:	83 ec 08             	sub    $0x8,%esp
  8002e6:	ff 75 dc             	pushl  -0x24(%ebp)
  8002e9:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ec:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ef:	ff 75 e0             	pushl  -0x20(%ebp)
  8002f2:	e8 89 20 00 00       	call   802380 <__udivdi3>
  8002f7:	83 c4 18             	add    $0x18,%esp
  8002fa:	52                   	push   %edx
  8002fb:	50                   	push   %eax
  8002fc:	89 fa                	mov    %edi,%edx
  8002fe:	89 f0                	mov    %esi,%eax
  800300:	e8 54 ff ff ff       	call   800259 <printnum>
  800305:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800308:	83 ec 08             	sub    $0x8,%esp
  80030b:	57                   	push   %edi
  80030c:	83 ec 04             	sub    $0x4,%esp
  80030f:	ff 75 dc             	pushl  -0x24(%ebp)
  800312:	ff 75 d8             	pushl  -0x28(%ebp)
  800315:	ff 75 e4             	pushl  -0x1c(%ebp)
  800318:	ff 75 e0             	pushl  -0x20(%ebp)
  80031b:	e8 70 21 00 00       	call   802490 <__umoddi3>
  800320:	83 c4 14             	add    $0x14,%esp
  800323:	0f be 80 71 26 80 00 	movsbl 0x802671(%eax),%eax
  80032a:	50                   	push   %eax
  80032b:	ff d6                	call   *%esi
  80032d:	83 c4 10             	add    $0x10,%esp
	}
}
  800330:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800333:	5b                   	pop    %ebx
  800334:	5e                   	pop    %esi
  800335:	5f                   	pop    %edi
  800336:	5d                   	pop    %ebp
  800337:	c3                   	ret    

00800338 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800338:	55                   	push   %ebp
  800339:	89 e5                	mov    %esp,%ebp
  80033b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80033e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800342:	8b 10                	mov    (%eax),%edx
  800344:	3b 50 04             	cmp    0x4(%eax),%edx
  800347:	73 0a                	jae    800353 <sprintputch+0x1b>
		*b->buf++ = ch;
  800349:	8d 4a 01             	lea    0x1(%edx),%ecx
  80034c:	89 08                	mov    %ecx,(%eax)
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	88 02                	mov    %al,(%edx)
}
  800353:	5d                   	pop    %ebp
  800354:	c3                   	ret    

00800355 <printfmt>:
{
  800355:	55                   	push   %ebp
  800356:	89 e5                	mov    %esp,%ebp
  800358:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80035b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80035e:	50                   	push   %eax
  80035f:	ff 75 10             	pushl  0x10(%ebp)
  800362:	ff 75 0c             	pushl  0xc(%ebp)
  800365:	ff 75 08             	pushl  0x8(%ebp)
  800368:	e8 05 00 00 00       	call   800372 <vprintfmt>
}
  80036d:	83 c4 10             	add    $0x10,%esp
  800370:	c9                   	leave  
  800371:	c3                   	ret    

00800372 <vprintfmt>:
{
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	57                   	push   %edi
  800376:	56                   	push   %esi
  800377:	53                   	push   %ebx
  800378:	83 ec 3c             	sub    $0x3c,%esp
  80037b:	8b 75 08             	mov    0x8(%ebp),%esi
  80037e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800381:	8b 7d 10             	mov    0x10(%ebp),%edi
  800384:	e9 32 04 00 00       	jmp    8007bb <vprintfmt+0x449>
		padc = ' ';
  800389:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80038d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800394:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80039b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003a2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003a9:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003b0:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003b5:	8d 47 01             	lea    0x1(%edi),%eax
  8003b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003bb:	0f b6 17             	movzbl (%edi),%edx
  8003be:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003c1:	3c 55                	cmp    $0x55,%al
  8003c3:	0f 87 12 05 00 00    	ja     8008db <vprintfmt+0x569>
  8003c9:	0f b6 c0             	movzbl %al,%eax
  8003cc:	ff 24 85 40 28 80 00 	jmp    *0x802840(,%eax,4)
  8003d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003d6:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003da:	eb d9                	jmp    8003b5 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003df:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003e3:	eb d0                	jmp    8003b5 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003e5:	0f b6 d2             	movzbl %dl,%edx
  8003e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f0:	89 75 08             	mov    %esi,0x8(%ebp)
  8003f3:	eb 03                	jmp    8003f8 <vprintfmt+0x86>
  8003f5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003f8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003fb:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003ff:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800402:	8d 72 d0             	lea    -0x30(%edx),%esi
  800405:	83 fe 09             	cmp    $0x9,%esi
  800408:	76 eb                	jbe    8003f5 <vprintfmt+0x83>
  80040a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80040d:	8b 75 08             	mov    0x8(%ebp),%esi
  800410:	eb 14                	jmp    800426 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800412:	8b 45 14             	mov    0x14(%ebp),%eax
  800415:	8b 00                	mov    (%eax),%eax
  800417:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80041a:	8b 45 14             	mov    0x14(%ebp),%eax
  80041d:	8d 40 04             	lea    0x4(%eax),%eax
  800420:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800423:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800426:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80042a:	79 89                	jns    8003b5 <vprintfmt+0x43>
				width = precision, precision = -1;
  80042c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80042f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800432:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800439:	e9 77 ff ff ff       	jmp    8003b5 <vprintfmt+0x43>
  80043e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800441:	85 c0                	test   %eax,%eax
  800443:	0f 48 c1             	cmovs  %ecx,%eax
  800446:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800449:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80044c:	e9 64 ff ff ff       	jmp    8003b5 <vprintfmt+0x43>
  800451:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800454:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80045b:	e9 55 ff ff ff       	jmp    8003b5 <vprintfmt+0x43>
			lflag++;
  800460:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800464:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800467:	e9 49 ff ff ff       	jmp    8003b5 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80046c:	8b 45 14             	mov    0x14(%ebp),%eax
  80046f:	8d 78 04             	lea    0x4(%eax),%edi
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	53                   	push   %ebx
  800476:	ff 30                	pushl  (%eax)
  800478:	ff d6                	call   *%esi
			break;
  80047a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80047d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800480:	e9 33 03 00 00       	jmp    8007b8 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800485:	8b 45 14             	mov    0x14(%ebp),%eax
  800488:	8d 78 04             	lea    0x4(%eax),%edi
  80048b:	8b 00                	mov    (%eax),%eax
  80048d:	99                   	cltd   
  80048e:	31 d0                	xor    %edx,%eax
  800490:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800492:	83 f8 11             	cmp    $0x11,%eax
  800495:	7f 23                	jg     8004ba <vprintfmt+0x148>
  800497:	8b 14 85 a0 29 80 00 	mov    0x8029a0(,%eax,4),%edx
  80049e:	85 d2                	test   %edx,%edx
  8004a0:	74 18                	je     8004ba <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004a2:	52                   	push   %edx
  8004a3:	68 dd 2a 80 00       	push   $0x802add
  8004a8:	53                   	push   %ebx
  8004a9:	56                   	push   %esi
  8004aa:	e8 a6 fe ff ff       	call   800355 <printfmt>
  8004af:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004b2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004b5:	e9 fe 02 00 00       	jmp    8007b8 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004ba:	50                   	push   %eax
  8004bb:	68 89 26 80 00       	push   $0x802689
  8004c0:	53                   	push   %ebx
  8004c1:	56                   	push   %esi
  8004c2:	e8 8e fe ff ff       	call   800355 <printfmt>
  8004c7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004ca:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004cd:	e9 e6 02 00 00       	jmp    8007b8 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d5:	83 c0 04             	add    $0x4,%eax
  8004d8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004db:	8b 45 14             	mov    0x14(%ebp),%eax
  8004de:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004e0:	85 c9                	test   %ecx,%ecx
  8004e2:	b8 82 26 80 00       	mov    $0x802682,%eax
  8004e7:	0f 45 c1             	cmovne %ecx,%eax
  8004ea:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004ed:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004f1:	7e 06                	jle    8004f9 <vprintfmt+0x187>
  8004f3:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004f7:	75 0d                	jne    800506 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004fc:	89 c7                	mov    %eax,%edi
  8004fe:	03 45 e0             	add    -0x20(%ebp),%eax
  800501:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800504:	eb 53                	jmp    800559 <vprintfmt+0x1e7>
  800506:	83 ec 08             	sub    $0x8,%esp
  800509:	ff 75 d8             	pushl  -0x28(%ebp)
  80050c:	50                   	push   %eax
  80050d:	e8 71 04 00 00       	call   800983 <strnlen>
  800512:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800515:	29 c1                	sub    %eax,%ecx
  800517:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80051a:	83 c4 10             	add    $0x10,%esp
  80051d:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80051f:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800523:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800526:	eb 0f                	jmp    800537 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800528:	83 ec 08             	sub    $0x8,%esp
  80052b:	53                   	push   %ebx
  80052c:	ff 75 e0             	pushl  -0x20(%ebp)
  80052f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800531:	83 ef 01             	sub    $0x1,%edi
  800534:	83 c4 10             	add    $0x10,%esp
  800537:	85 ff                	test   %edi,%edi
  800539:	7f ed                	jg     800528 <vprintfmt+0x1b6>
  80053b:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80053e:	85 c9                	test   %ecx,%ecx
  800540:	b8 00 00 00 00       	mov    $0x0,%eax
  800545:	0f 49 c1             	cmovns %ecx,%eax
  800548:	29 c1                	sub    %eax,%ecx
  80054a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80054d:	eb aa                	jmp    8004f9 <vprintfmt+0x187>
					putch(ch, putdat);
  80054f:	83 ec 08             	sub    $0x8,%esp
  800552:	53                   	push   %ebx
  800553:	52                   	push   %edx
  800554:	ff d6                	call   *%esi
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80055c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80055e:	83 c7 01             	add    $0x1,%edi
  800561:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800565:	0f be d0             	movsbl %al,%edx
  800568:	85 d2                	test   %edx,%edx
  80056a:	74 4b                	je     8005b7 <vprintfmt+0x245>
  80056c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800570:	78 06                	js     800578 <vprintfmt+0x206>
  800572:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800576:	78 1e                	js     800596 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800578:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80057c:	74 d1                	je     80054f <vprintfmt+0x1dd>
  80057e:	0f be c0             	movsbl %al,%eax
  800581:	83 e8 20             	sub    $0x20,%eax
  800584:	83 f8 5e             	cmp    $0x5e,%eax
  800587:	76 c6                	jbe    80054f <vprintfmt+0x1dd>
					putch('?', putdat);
  800589:	83 ec 08             	sub    $0x8,%esp
  80058c:	53                   	push   %ebx
  80058d:	6a 3f                	push   $0x3f
  80058f:	ff d6                	call   *%esi
  800591:	83 c4 10             	add    $0x10,%esp
  800594:	eb c3                	jmp    800559 <vprintfmt+0x1e7>
  800596:	89 cf                	mov    %ecx,%edi
  800598:	eb 0e                	jmp    8005a8 <vprintfmt+0x236>
				putch(' ', putdat);
  80059a:	83 ec 08             	sub    $0x8,%esp
  80059d:	53                   	push   %ebx
  80059e:	6a 20                	push   $0x20
  8005a0:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005a2:	83 ef 01             	sub    $0x1,%edi
  8005a5:	83 c4 10             	add    $0x10,%esp
  8005a8:	85 ff                	test   %edi,%edi
  8005aa:	7f ee                	jg     80059a <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005ac:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005af:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b2:	e9 01 02 00 00       	jmp    8007b8 <vprintfmt+0x446>
  8005b7:	89 cf                	mov    %ecx,%edi
  8005b9:	eb ed                	jmp    8005a8 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005be:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005c5:	e9 eb fd ff ff       	jmp    8003b5 <vprintfmt+0x43>
	if (lflag >= 2)
  8005ca:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005ce:	7f 21                	jg     8005f1 <vprintfmt+0x27f>
	else if (lflag)
  8005d0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005d4:	74 68                	je     80063e <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d9:	8b 00                	mov    (%eax),%eax
  8005db:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005de:	89 c1                	mov    %eax,%ecx
  8005e0:	c1 f9 1f             	sar    $0x1f,%ecx
  8005e3:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e9:	8d 40 04             	lea    0x4(%eax),%eax
  8005ec:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ef:	eb 17                	jmp    800608 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f4:	8b 50 04             	mov    0x4(%eax),%edx
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005fc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800602:	8d 40 08             	lea    0x8(%eax),%eax
  800605:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800608:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80060b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80060e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800611:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800614:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800618:	78 3f                	js     800659 <vprintfmt+0x2e7>
			base = 10;
  80061a:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80061f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800623:	0f 84 71 01 00 00    	je     80079a <vprintfmt+0x428>
				putch('+', putdat);
  800629:	83 ec 08             	sub    $0x8,%esp
  80062c:	53                   	push   %ebx
  80062d:	6a 2b                	push   $0x2b
  80062f:	ff d6                	call   *%esi
  800631:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800634:	b8 0a 00 00 00       	mov    $0xa,%eax
  800639:	e9 5c 01 00 00       	jmp    80079a <vprintfmt+0x428>
		return va_arg(*ap, int);
  80063e:	8b 45 14             	mov    0x14(%ebp),%eax
  800641:	8b 00                	mov    (%eax),%eax
  800643:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800646:	89 c1                	mov    %eax,%ecx
  800648:	c1 f9 1f             	sar    $0x1f,%ecx
  80064b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80064e:	8b 45 14             	mov    0x14(%ebp),%eax
  800651:	8d 40 04             	lea    0x4(%eax),%eax
  800654:	89 45 14             	mov    %eax,0x14(%ebp)
  800657:	eb af                	jmp    800608 <vprintfmt+0x296>
				putch('-', putdat);
  800659:	83 ec 08             	sub    $0x8,%esp
  80065c:	53                   	push   %ebx
  80065d:	6a 2d                	push   $0x2d
  80065f:	ff d6                	call   *%esi
				num = -(long long) num;
  800661:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800664:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800667:	f7 d8                	neg    %eax
  800669:	83 d2 00             	adc    $0x0,%edx
  80066c:	f7 da                	neg    %edx
  80066e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800671:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800674:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800677:	b8 0a 00 00 00       	mov    $0xa,%eax
  80067c:	e9 19 01 00 00       	jmp    80079a <vprintfmt+0x428>
	if (lflag >= 2)
  800681:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800685:	7f 29                	jg     8006b0 <vprintfmt+0x33e>
	else if (lflag)
  800687:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80068b:	74 44                	je     8006d1 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80068d:	8b 45 14             	mov    0x14(%ebp),%eax
  800690:	8b 00                	mov    (%eax),%eax
  800692:	ba 00 00 00 00       	mov    $0x0,%edx
  800697:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	8d 40 04             	lea    0x4(%eax),%eax
  8006a3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006a6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ab:	e9 ea 00 00 00       	jmp    80079a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b3:	8b 50 04             	mov    0x4(%eax),%edx
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006be:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c1:	8d 40 08             	lea    0x8(%eax),%eax
  8006c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006cc:	e9 c9 00 00 00       	jmp    80079a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006de:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e4:	8d 40 04             	lea    0x4(%eax),%eax
  8006e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ea:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ef:	e9 a6 00 00 00       	jmp    80079a <vprintfmt+0x428>
			putch('0', putdat);
  8006f4:	83 ec 08             	sub    $0x8,%esp
  8006f7:	53                   	push   %ebx
  8006f8:	6a 30                	push   $0x30
  8006fa:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006fc:	83 c4 10             	add    $0x10,%esp
  8006ff:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800703:	7f 26                	jg     80072b <vprintfmt+0x3b9>
	else if (lflag)
  800705:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800709:	74 3e                	je     800749 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	8b 00                	mov    (%eax),%eax
  800710:	ba 00 00 00 00       	mov    $0x0,%edx
  800715:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800718:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80071b:	8b 45 14             	mov    0x14(%ebp),%eax
  80071e:	8d 40 04             	lea    0x4(%eax),%eax
  800721:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800724:	b8 08 00 00 00       	mov    $0x8,%eax
  800729:	eb 6f                	jmp    80079a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80072b:	8b 45 14             	mov    0x14(%ebp),%eax
  80072e:	8b 50 04             	mov    0x4(%eax),%edx
  800731:	8b 00                	mov    (%eax),%eax
  800733:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800736:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800739:	8b 45 14             	mov    0x14(%ebp),%eax
  80073c:	8d 40 08             	lea    0x8(%eax),%eax
  80073f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800742:	b8 08 00 00 00       	mov    $0x8,%eax
  800747:	eb 51                	jmp    80079a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800749:	8b 45 14             	mov    0x14(%ebp),%eax
  80074c:	8b 00                	mov    (%eax),%eax
  80074e:	ba 00 00 00 00       	mov    $0x0,%edx
  800753:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800756:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	8d 40 04             	lea    0x4(%eax),%eax
  80075f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800762:	b8 08 00 00 00       	mov    $0x8,%eax
  800767:	eb 31                	jmp    80079a <vprintfmt+0x428>
			putch('0', putdat);
  800769:	83 ec 08             	sub    $0x8,%esp
  80076c:	53                   	push   %ebx
  80076d:	6a 30                	push   $0x30
  80076f:	ff d6                	call   *%esi
			putch('x', putdat);
  800771:	83 c4 08             	add    $0x8,%esp
  800774:	53                   	push   %ebx
  800775:	6a 78                	push   $0x78
  800777:	ff d6                	call   *%esi
			num = (unsigned long long)
  800779:	8b 45 14             	mov    0x14(%ebp),%eax
  80077c:	8b 00                	mov    (%eax),%eax
  80077e:	ba 00 00 00 00       	mov    $0x0,%edx
  800783:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800786:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800789:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80078c:	8b 45 14             	mov    0x14(%ebp),%eax
  80078f:	8d 40 04             	lea    0x4(%eax),%eax
  800792:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800795:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80079a:	83 ec 0c             	sub    $0xc,%esp
  80079d:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007a1:	52                   	push   %edx
  8007a2:	ff 75 e0             	pushl  -0x20(%ebp)
  8007a5:	50                   	push   %eax
  8007a6:	ff 75 dc             	pushl  -0x24(%ebp)
  8007a9:	ff 75 d8             	pushl  -0x28(%ebp)
  8007ac:	89 da                	mov    %ebx,%edx
  8007ae:	89 f0                	mov    %esi,%eax
  8007b0:	e8 a4 fa ff ff       	call   800259 <printnum>
			break;
  8007b5:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007bb:	83 c7 01             	add    $0x1,%edi
  8007be:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007c2:	83 f8 25             	cmp    $0x25,%eax
  8007c5:	0f 84 be fb ff ff    	je     800389 <vprintfmt+0x17>
			if (ch == '\0')
  8007cb:	85 c0                	test   %eax,%eax
  8007cd:	0f 84 28 01 00 00    	je     8008fb <vprintfmt+0x589>
			putch(ch, putdat);
  8007d3:	83 ec 08             	sub    $0x8,%esp
  8007d6:	53                   	push   %ebx
  8007d7:	50                   	push   %eax
  8007d8:	ff d6                	call   *%esi
  8007da:	83 c4 10             	add    $0x10,%esp
  8007dd:	eb dc                	jmp    8007bb <vprintfmt+0x449>
	if (lflag >= 2)
  8007df:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007e3:	7f 26                	jg     80080b <vprintfmt+0x499>
	else if (lflag)
  8007e5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007e9:	74 41                	je     80082c <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ee:	8b 00                	mov    (%eax),%eax
  8007f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fe:	8d 40 04             	lea    0x4(%eax),%eax
  800801:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800804:	b8 10 00 00 00       	mov    $0x10,%eax
  800809:	eb 8f                	jmp    80079a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80080b:	8b 45 14             	mov    0x14(%ebp),%eax
  80080e:	8b 50 04             	mov    0x4(%eax),%edx
  800811:	8b 00                	mov    (%eax),%eax
  800813:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800816:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800819:	8b 45 14             	mov    0x14(%ebp),%eax
  80081c:	8d 40 08             	lea    0x8(%eax),%eax
  80081f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800822:	b8 10 00 00 00       	mov    $0x10,%eax
  800827:	e9 6e ff ff ff       	jmp    80079a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	8b 00                	mov    (%eax),%eax
  800831:	ba 00 00 00 00       	mov    $0x0,%edx
  800836:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800839:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80083c:	8b 45 14             	mov    0x14(%ebp),%eax
  80083f:	8d 40 04             	lea    0x4(%eax),%eax
  800842:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800845:	b8 10 00 00 00       	mov    $0x10,%eax
  80084a:	e9 4b ff ff ff       	jmp    80079a <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80084f:	8b 45 14             	mov    0x14(%ebp),%eax
  800852:	83 c0 04             	add    $0x4,%eax
  800855:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800858:	8b 45 14             	mov    0x14(%ebp),%eax
  80085b:	8b 00                	mov    (%eax),%eax
  80085d:	85 c0                	test   %eax,%eax
  80085f:	74 14                	je     800875 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800861:	8b 13                	mov    (%ebx),%edx
  800863:	83 fa 7f             	cmp    $0x7f,%edx
  800866:	7f 37                	jg     80089f <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800868:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80086a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80086d:	89 45 14             	mov    %eax,0x14(%ebp)
  800870:	e9 43 ff ff ff       	jmp    8007b8 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800875:	b8 0a 00 00 00       	mov    $0xa,%eax
  80087a:	bf a5 27 80 00       	mov    $0x8027a5,%edi
							putch(ch, putdat);
  80087f:	83 ec 08             	sub    $0x8,%esp
  800882:	53                   	push   %ebx
  800883:	50                   	push   %eax
  800884:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800886:	83 c7 01             	add    $0x1,%edi
  800889:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80088d:	83 c4 10             	add    $0x10,%esp
  800890:	85 c0                	test   %eax,%eax
  800892:	75 eb                	jne    80087f <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800894:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800897:	89 45 14             	mov    %eax,0x14(%ebp)
  80089a:	e9 19 ff ff ff       	jmp    8007b8 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80089f:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008a1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008a6:	bf dd 27 80 00       	mov    $0x8027dd,%edi
							putch(ch, putdat);
  8008ab:	83 ec 08             	sub    $0x8,%esp
  8008ae:	53                   	push   %ebx
  8008af:	50                   	push   %eax
  8008b0:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008b2:	83 c7 01             	add    $0x1,%edi
  8008b5:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008b9:	83 c4 10             	add    $0x10,%esp
  8008bc:	85 c0                	test   %eax,%eax
  8008be:	75 eb                	jne    8008ab <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c6:	e9 ed fe ff ff       	jmp    8007b8 <vprintfmt+0x446>
			putch(ch, putdat);
  8008cb:	83 ec 08             	sub    $0x8,%esp
  8008ce:	53                   	push   %ebx
  8008cf:	6a 25                	push   $0x25
  8008d1:	ff d6                	call   *%esi
			break;
  8008d3:	83 c4 10             	add    $0x10,%esp
  8008d6:	e9 dd fe ff ff       	jmp    8007b8 <vprintfmt+0x446>
			putch('%', putdat);
  8008db:	83 ec 08             	sub    $0x8,%esp
  8008de:	53                   	push   %ebx
  8008df:	6a 25                	push   $0x25
  8008e1:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008e3:	83 c4 10             	add    $0x10,%esp
  8008e6:	89 f8                	mov    %edi,%eax
  8008e8:	eb 03                	jmp    8008ed <vprintfmt+0x57b>
  8008ea:	83 e8 01             	sub    $0x1,%eax
  8008ed:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008f1:	75 f7                	jne    8008ea <vprintfmt+0x578>
  8008f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f6:	e9 bd fe ff ff       	jmp    8007b8 <vprintfmt+0x446>
}
  8008fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008fe:	5b                   	pop    %ebx
  8008ff:	5e                   	pop    %esi
  800900:	5f                   	pop    %edi
  800901:	5d                   	pop    %ebp
  800902:	c3                   	ret    

00800903 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800903:	55                   	push   %ebp
  800904:	89 e5                	mov    %esp,%ebp
  800906:	83 ec 18             	sub    $0x18,%esp
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80090f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800912:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800916:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800919:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800920:	85 c0                	test   %eax,%eax
  800922:	74 26                	je     80094a <vsnprintf+0x47>
  800924:	85 d2                	test   %edx,%edx
  800926:	7e 22                	jle    80094a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800928:	ff 75 14             	pushl  0x14(%ebp)
  80092b:	ff 75 10             	pushl  0x10(%ebp)
  80092e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800931:	50                   	push   %eax
  800932:	68 38 03 80 00       	push   $0x800338
  800937:	e8 36 fa ff ff       	call   800372 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80093c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80093f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800945:	83 c4 10             	add    $0x10,%esp
}
  800948:	c9                   	leave  
  800949:	c3                   	ret    
		return -E_INVAL;
  80094a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80094f:	eb f7                	jmp    800948 <vsnprintf+0x45>

00800951 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800957:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80095a:	50                   	push   %eax
  80095b:	ff 75 10             	pushl  0x10(%ebp)
  80095e:	ff 75 0c             	pushl  0xc(%ebp)
  800961:	ff 75 08             	pushl  0x8(%ebp)
  800964:	e8 9a ff ff ff       	call   800903 <vsnprintf>
	va_end(ap);

	return rc;
}
  800969:	c9                   	leave  
  80096a:	c3                   	ret    

0080096b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800971:	b8 00 00 00 00       	mov    $0x0,%eax
  800976:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80097a:	74 05                	je     800981 <strlen+0x16>
		n++;
  80097c:	83 c0 01             	add    $0x1,%eax
  80097f:	eb f5                	jmp    800976 <strlen+0xb>
	return n;
}
  800981:	5d                   	pop    %ebp
  800982:	c3                   	ret    

00800983 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800989:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80098c:	ba 00 00 00 00       	mov    $0x0,%edx
  800991:	39 c2                	cmp    %eax,%edx
  800993:	74 0d                	je     8009a2 <strnlen+0x1f>
  800995:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800999:	74 05                	je     8009a0 <strnlen+0x1d>
		n++;
  80099b:	83 c2 01             	add    $0x1,%edx
  80099e:	eb f1                	jmp    800991 <strnlen+0xe>
  8009a0:	89 d0                	mov    %edx,%eax
	return n;
}
  8009a2:	5d                   	pop    %ebp
  8009a3:	c3                   	ret    

008009a4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
  8009a7:	53                   	push   %ebx
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b3:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009b7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009ba:	83 c2 01             	add    $0x1,%edx
  8009bd:	84 c9                	test   %cl,%cl
  8009bf:	75 f2                	jne    8009b3 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009c1:	5b                   	pop    %ebx
  8009c2:	5d                   	pop    %ebp
  8009c3:	c3                   	ret    

008009c4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	53                   	push   %ebx
  8009c8:	83 ec 10             	sub    $0x10,%esp
  8009cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009ce:	53                   	push   %ebx
  8009cf:	e8 97 ff ff ff       	call   80096b <strlen>
  8009d4:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009d7:	ff 75 0c             	pushl  0xc(%ebp)
  8009da:	01 d8                	add    %ebx,%eax
  8009dc:	50                   	push   %eax
  8009dd:	e8 c2 ff ff ff       	call   8009a4 <strcpy>
	return dst;
}
  8009e2:	89 d8                	mov    %ebx,%eax
  8009e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e7:	c9                   	leave  
  8009e8:	c3                   	ret    

008009e9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009e9:	55                   	push   %ebp
  8009ea:	89 e5                	mov    %esp,%ebp
  8009ec:	56                   	push   %esi
  8009ed:	53                   	push   %ebx
  8009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009f4:	89 c6                	mov    %eax,%esi
  8009f6:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009f9:	89 c2                	mov    %eax,%edx
  8009fb:	39 f2                	cmp    %esi,%edx
  8009fd:	74 11                	je     800a10 <strncpy+0x27>
		*dst++ = *src;
  8009ff:	83 c2 01             	add    $0x1,%edx
  800a02:	0f b6 19             	movzbl (%ecx),%ebx
  800a05:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a08:	80 fb 01             	cmp    $0x1,%bl
  800a0b:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a0e:	eb eb                	jmp    8009fb <strncpy+0x12>
	}
	return ret;
}
  800a10:	5b                   	pop    %ebx
  800a11:	5e                   	pop    %esi
  800a12:	5d                   	pop    %ebp
  800a13:	c3                   	ret    

00800a14 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	56                   	push   %esi
  800a18:	53                   	push   %ebx
  800a19:	8b 75 08             	mov    0x8(%ebp),%esi
  800a1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a1f:	8b 55 10             	mov    0x10(%ebp),%edx
  800a22:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a24:	85 d2                	test   %edx,%edx
  800a26:	74 21                	je     800a49 <strlcpy+0x35>
  800a28:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a2c:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a2e:	39 c2                	cmp    %eax,%edx
  800a30:	74 14                	je     800a46 <strlcpy+0x32>
  800a32:	0f b6 19             	movzbl (%ecx),%ebx
  800a35:	84 db                	test   %bl,%bl
  800a37:	74 0b                	je     800a44 <strlcpy+0x30>
			*dst++ = *src++;
  800a39:	83 c1 01             	add    $0x1,%ecx
  800a3c:	83 c2 01             	add    $0x1,%edx
  800a3f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a42:	eb ea                	jmp    800a2e <strlcpy+0x1a>
  800a44:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a46:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a49:	29 f0                	sub    %esi,%eax
}
  800a4b:	5b                   	pop    %ebx
  800a4c:	5e                   	pop    %esi
  800a4d:	5d                   	pop    %ebp
  800a4e:	c3                   	ret    

00800a4f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a55:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a58:	0f b6 01             	movzbl (%ecx),%eax
  800a5b:	84 c0                	test   %al,%al
  800a5d:	74 0c                	je     800a6b <strcmp+0x1c>
  800a5f:	3a 02                	cmp    (%edx),%al
  800a61:	75 08                	jne    800a6b <strcmp+0x1c>
		p++, q++;
  800a63:	83 c1 01             	add    $0x1,%ecx
  800a66:	83 c2 01             	add    $0x1,%edx
  800a69:	eb ed                	jmp    800a58 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a6b:	0f b6 c0             	movzbl %al,%eax
  800a6e:	0f b6 12             	movzbl (%edx),%edx
  800a71:	29 d0                	sub    %edx,%eax
}
  800a73:	5d                   	pop    %ebp
  800a74:	c3                   	ret    

00800a75 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	53                   	push   %ebx
  800a79:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a7f:	89 c3                	mov    %eax,%ebx
  800a81:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a84:	eb 06                	jmp    800a8c <strncmp+0x17>
		n--, p++, q++;
  800a86:	83 c0 01             	add    $0x1,%eax
  800a89:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a8c:	39 d8                	cmp    %ebx,%eax
  800a8e:	74 16                	je     800aa6 <strncmp+0x31>
  800a90:	0f b6 08             	movzbl (%eax),%ecx
  800a93:	84 c9                	test   %cl,%cl
  800a95:	74 04                	je     800a9b <strncmp+0x26>
  800a97:	3a 0a                	cmp    (%edx),%cl
  800a99:	74 eb                	je     800a86 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a9b:	0f b6 00             	movzbl (%eax),%eax
  800a9e:	0f b6 12             	movzbl (%edx),%edx
  800aa1:	29 d0                	sub    %edx,%eax
}
  800aa3:	5b                   	pop    %ebx
  800aa4:	5d                   	pop    %ebp
  800aa5:	c3                   	ret    
		return 0;
  800aa6:	b8 00 00 00 00       	mov    $0x0,%eax
  800aab:	eb f6                	jmp    800aa3 <strncmp+0x2e>

00800aad <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aad:	55                   	push   %ebp
  800aae:	89 e5                	mov    %esp,%ebp
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ab7:	0f b6 10             	movzbl (%eax),%edx
  800aba:	84 d2                	test   %dl,%dl
  800abc:	74 09                	je     800ac7 <strchr+0x1a>
		if (*s == c)
  800abe:	38 ca                	cmp    %cl,%dl
  800ac0:	74 0a                	je     800acc <strchr+0x1f>
	for (; *s; s++)
  800ac2:	83 c0 01             	add    $0x1,%eax
  800ac5:	eb f0                	jmp    800ab7 <strchr+0xa>
			return (char *) s;
	return 0;
  800ac7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800acc:	5d                   	pop    %ebp
  800acd:	c3                   	ret    

00800ace <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ace:	55                   	push   %ebp
  800acf:	89 e5                	mov    %esp,%ebp
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ad8:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800adb:	38 ca                	cmp    %cl,%dl
  800add:	74 09                	je     800ae8 <strfind+0x1a>
  800adf:	84 d2                	test   %dl,%dl
  800ae1:	74 05                	je     800ae8 <strfind+0x1a>
	for (; *s; s++)
  800ae3:	83 c0 01             	add    $0x1,%eax
  800ae6:	eb f0                	jmp    800ad8 <strfind+0xa>
			break;
	return (char *) s;
}
  800ae8:	5d                   	pop    %ebp
  800ae9:	c3                   	ret    

00800aea <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800aea:	55                   	push   %ebp
  800aeb:	89 e5                	mov    %esp,%ebp
  800aed:	57                   	push   %edi
  800aee:	56                   	push   %esi
  800aef:	53                   	push   %ebx
  800af0:	8b 7d 08             	mov    0x8(%ebp),%edi
  800af3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800af6:	85 c9                	test   %ecx,%ecx
  800af8:	74 31                	je     800b2b <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800afa:	89 f8                	mov    %edi,%eax
  800afc:	09 c8                	or     %ecx,%eax
  800afe:	a8 03                	test   $0x3,%al
  800b00:	75 23                	jne    800b25 <memset+0x3b>
		c &= 0xFF;
  800b02:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b06:	89 d3                	mov    %edx,%ebx
  800b08:	c1 e3 08             	shl    $0x8,%ebx
  800b0b:	89 d0                	mov    %edx,%eax
  800b0d:	c1 e0 18             	shl    $0x18,%eax
  800b10:	89 d6                	mov    %edx,%esi
  800b12:	c1 e6 10             	shl    $0x10,%esi
  800b15:	09 f0                	or     %esi,%eax
  800b17:	09 c2                	or     %eax,%edx
  800b19:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b1b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b1e:	89 d0                	mov    %edx,%eax
  800b20:	fc                   	cld    
  800b21:	f3 ab                	rep stos %eax,%es:(%edi)
  800b23:	eb 06                	jmp    800b2b <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b28:	fc                   	cld    
  800b29:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b2b:	89 f8                	mov    %edi,%eax
  800b2d:	5b                   	pop    %ebx
  800b2e:	5e                   	pop    %esi
  800b2f:	5f                   	pop    %edi
  800b30:	5d                   	pop    %ebp
  800b31:	c3                   	ret    

00800b32 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	57                   	push   %edi
  800b36:	56                   	push   %esi
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b40:	39 c6                	cmp    %eax,%esi
  800b42:	73 32                	jae    800b76 <memmove+0x44>
  800b44:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b47:	39 c2                	cmp    %eax,%edx
  800b49:	76 2b                	jbe    800b76 <memmove+0x44>
		s += n;
		d += n;
  800b4b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b4e:	89 fe                	mov    %edi,%esi
  800b50:	09 ce                	or     %ecx,%esi
  800b52:	09 d6                	or     %edx,%esi
  800b54:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b5a:	75 0e                	jne    800b6a <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b5c:	83 ef 04             	sub    $0x4,%edi
  800b5f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b62:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b65:	fd                   	std    
  800b66:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b68:	eb 09                	jmp    800b73 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b6a:	83 ef 01             	sub    $0x1,%edi
  800b6d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b70:	fd                   	std    
  800b71:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b73:	fc                   	cld    
  800b74:	eb 1a                	jmp    800b90 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b76:	89 c2                	mov    %eax,%edx
  800b78:	09 ca                	or     %ecx,%edx
  800b7a:	09 f2                	or     %esi,%edx
  800b7c:	f6 c2 03             	test   $0x3,%dl
  800b7f:	75 0a                	jne    800b8b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b81:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b84:	89 c7                	mov    %eax,%edi
  800b86:	fc                   	cld    
  800b87:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b89:	eb 05                	jmp    800b90 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b8b:	89 c7                	mov    %eax,%edi
  800b8d:	fc                   	cld    
  800b8e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b90:	5e                   	pop    %esi
  800b91:	5f                   	pop    %edi
  800b92:	5d                   	pop    %ebp
  800b93:	c3                   	ret    

00800b94 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b9a:	ff 75 10             	pushl  0x10(%ebp)
  800b9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ba0:	ff 75 08             	pushl  0x8(%ebp)
  800ba3:	e8 8a ff ff ff       	call   800b32 <memmove>
}
  800ba8:	c9                   	leave  
  800ba9:	c3                   	ret    

00800baa <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	56                   	push   %esi
  800bae:	53                   	push   %ebx
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb5:	89 c6                	mov    %eax,%esi
  800bb7:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bba:	39 f0                	cmp    %esi,%eax
  800bbc:	74 1c                	je     800bda <memcmp+0x30>
		if (*s1 != *s2)
  800bbe:	0f b6 08             	movzbl (%eax),%ecx
  800bc1:	0f b6 1a             	movzbl (%edx),%ebx
  800bc4:	38 d9                	cmp    %bl,%cl
  800bc6:	75 08                	jne    800bd0 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bc8:	83 c0 01             	add    $0x1,%eax
  800bcb:	83 c2 01             	add    $0x1,%edx
  800bce:	eb ea                	jmp    800bba <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bd0:	0f b6 c1             	movzbl %cl,%eax
  800bd3:	0f b6 db             	movzbl %bl,%ebx
  800bd6:	29 d8                	sub    %ebx,%eax
  800bd8:	eb 05                	jmp    800bdf <memcmp+0x35>
	}

	return 0;
  800bda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bdf:	5b                   	pop    %ebx
  800be0:	5e                   	pop    %esi
  800be1:	5d                   	pop    %ebp
  800be2:	c3                   	ret    

00800be3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bec:	89 c2                	mov    %eax,%edx
  800bee:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bf1:	39 d0                	cmp    %edx,%eax
  800bf3:	73 09                	jae    800bfe <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bf5:	38 08                	cmp    %cl,(%eax)
  800bf7:	74 05                	je     800bfe <memfind+0x1b>
	for (; s < ends; s++)
  800bf9:	83 c0 01             	add    $0x1,%eax
  800bfc:	eb f3                	jmp    800bf1 <memfind+0xe>
			break;
	return (void *) s;
}
  800bfe:	5d                   	pop    %ebp
  800bff:	c3                   	ret    

00800c00 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c00:	55                   	push   %ebp
  800c01:	89 e5                	mov    %esp,%ebp
  800c03:	57                   	push   %edi
  800c04:	56                   	push   %esi
  800c05:	53                   	push   %ebx
  800c06:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c09:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c0c:	eb 03                	jmp    800c11 <strtol+0x11>
		s++;
  800c0e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c11:	0f b6 01             	movzbl (%ecx),%eax
  800c14:	3c 20                	cmp    $0x20,%al
  800c16:	74 f6                	je     800c0e <strtol+0xe>
  800c18:	3c 09                	cmp    $0x9,%al
  800c1a:	74 f2                	je     800c0e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c1c:	3c 2b                	cmp    $0x2b,%al
  800c1e:	74 2a                	je     800c4a <strtol+0x4a>
	int neg = 0;
  800c20:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c25:	3c 2d                	cmp    $0x2d,%al
  800c27:	74 2b                	je     800c54 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c29:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c2f:	75 0f                	jne    800c40 <strtol+0x40>
  800c31:	80 39 30             	cmpb   $0x30,(%ecx)
  800c34:	74 28                	je     800c5e <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c36:	85 db                	test   %ebx,%ebx
  800c38:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c3d:	0f 44 d8             	cmove  %eax,%ebx
  800c40:	b8 00 00 00 00       	mov    $0x0,%eax
  800c45:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c48:	eb 50                	jmp    800c9a <strtol+0x9a>
		s++;
  800c4a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c4d:	bf 00 00 00 00       	mov    $0x0,%edi
  800c52:	eb d5                	jmp    800c29 <strtol+0x29>
		s++, neg = 1;
  800c54:	83 c1 01             	add    $0x1,%ecx
  800c57:	bf 01 00 00 00       	mov    $0x1,%edi
  800c5c:	eb cb                	jmp    800c29 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c5e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c62:	74 0e                	je     800c72 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c64:	85 db                	test   %ebx,%ebx
  800c66:	75 d8                	jne    800c40 <strtol+0x40>
		s++, base = 8;
  800c68:	83 c1 01             	add    $0x1,%ecx
  800c6b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c70:	eb ce                	jmp    800c40 <strtol+0x40>
		s += 2, base = 16;
  800c72:	83 c1 02             	add    $0x2,%ecx
  800c75:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c7a:	eb c4                	jmp    800c40 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c7c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c7f:	89 f3                	mov    %esi,%ebx
  800c81:	80 fb 19             	cmp    $0x19,%bl
  800c84:	77 29                	ja     800caf <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c86:	0f be d2             	movsbl %dl,%edx
  800c89:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c8c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c8f:	7d 30                	jge    800cc1 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c91:	83 c1 01             	add    $0x1,%ecx
  800c94:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c98:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c9a:	0f b6 11             	movzbl (%ecx),%edx
  800c9d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ca0:	89 f3                	mov    %esi,%ebx
  800ca2:	80 fb 09             	cmp    $0x9,%bl
  800ca5:	77 d5                	ja     800c7c <strtol+0x7c>
			dig = *s - '0';
  800ca7:	0f be d2             	movsbl %dl,%edx
  800caa:	83 ea 30             	sub    $0x30,%edx
  800cad:	eb dd                	jmp    800c8c <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800caf:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cb2:	89 f3                	mov    %esi,%ebx
  800cb4:	80 fb 19             	cmp    $0x19,%bl
  800cb7:	77 08                	ja     800cc1 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cb9:	0f be d2             	movsbl %dl,%edx
  800cbc:	83 ea 37             	sub    $0x37,%edx
  800cbf:	eb cb                	jmp    800c8c <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cc1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cc5:	74 05                	je     800ccc <strtol+0xcc>
		*endptr = (char *) s;
  800cc7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cca:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ccc:	89 c2                	mov    %eax,%edx
  800cce:	f7 da                	neg    %edx
  800cd0:	85 ff                	test   %edi,%edi
  800cd2:	0f 45 c2             	cmovne %edx,%eax
}
  800cd5:	5b                   	pop    %ebx
  800cd6:	5e                   	pop    %esi
  800cd7:	5f                   	pop    %edi
  800cd8:	5d                   	pop    %ebp
  800cd9:	c3                   	ret    

00800cda <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cda:	55                   	push   %ebp
  800cdb:	89 e5                	mov    %esp,%ebp
  800cdd:	57                   	push   %edi
  800cde:	56                   	push   %esi
  800cdf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ceb:	89 c3                	mov    %eax,%ebx
  800ced:	89 c7                	mov    %eax,%edi
  800cef:	89 c6                	mov    %eax,%esi
  800cf1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cf3:	5b                   	pop    %ebx
  800cf4:	5e                   	pop    %esi
  800cf5:	5f                   	pop    %edi
  800cf6:	5d                   	pop    %ebp
  800cf7:	c3                   	ret    

00800cf8 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
  800cfb:	57                   	push   %edi
  800cfc:	56                   	push   %esi
  800cfd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cfe:	ba 00 00 00 00       	mov    $0x0,%edx
  800d03:	b8 01 00 00 00       	mov    $0x1,%eax
  800d08:	89 d1                	mov    %edx,%ecx
  800d0a:	89 d3                	mov    %edx,%ebx
  800d0c:	89 d7                	mov    %edx,%edi
  800d0e:	89 d6                	mov    %edx,%esi
  800d10:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d12:	5b                   	pop    %ebx
  800d13:	5e                   	pop    %esi
  800d14:	5f                   	pop    %edi
  800d15:	5d                   	pop    %ebp
  800d16:	c3                   	ret    

00800d17 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	57                   	push   %edi
  800d1b:	56                   	push   %esi
  800d1c:	53                   	push   %ebx
  800d1d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d20:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d25:	8b 55 08             	mov    0x8(%ebp),%edx
  800d28:	b8 03 00 00 00       	mov    $0x3,%eax
  800d2d:	89 cb                	mov    %ecx,%ebx
  800d2f:	89 cf                	mov    %ecx,%edi
  800d31:	89 ce                	mov    %ecx,%esi
  800d33:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d35:	85 c0                	test   %eax,%eax
  800d37:	7f 08                	jg     800d41 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3c:	5b                   	pop    %ebx
  800d3d:	5e                   	pop    %esi
  800d3e:	5f                   	pop    %edi
  800d3f:	5d                   	pop    %ebp
  800d40:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d41:	83 ec 0c             	sub    $0xc,%esp
  800d44:	50                   	push   %eax
  800d45:	6a 03                	push   $0x3
  800d47:	68 e8 29 80 00       	push   $0x8029e8
  800d4c:	6a 43                	push   $0x43
  800d4e:	68 05 2a 80 00       	push   $0x802a05
  800d53:	e8 89 15 00 00       	call   8022e1 <_panic>

00800d58 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	57                   	push   %edi
  800d5c:	56                   	push   %esi
  800d5d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d63:	b8 02 00 00 00       	mov    $0x2,%eax
  800d68:	89 d1                	mov    %edx,%ecx
  800d6a:	89 d3                	mov    %edx,%ebx
  800d6c:	89 d7                	mov    %edx,%edi
  800d6e:	89 d6                	mov    %edx,%esi
  800d70:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d72:	5b                   	pop    %ebx
  800d73:	5e                   	pop    %esi
  800d74:	5f                   	pop    %edi
  800d75:	5d                   	pop    %ebp
  800d76:	c3                   	ret    

00800d77 <sys_yield>:

void
sys_yield(void)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	57                   	push   %edi
  800d7b:	56                   	push   %esi
  800d7c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d82:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d87:	89 d1                	mov    %edx,%ecx
  800d89:	89 d3                	mov    %edx,%ebx
  800d8b:	89 d7                	mov    %edx,%edi
  800d8d:	89 d6                	mov    %edx,%esi
  800d8f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d91:	5b                   	pop    %ebx
  800d92:	5e                   	pop    %esi
  800d93:	5f                   	pop    %edi
  800d94:	5d                   	pop    %ebp
  800d95:	c3                   	ret    

00800d96 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	57                   	push   %edi
  800d9a:	56                   	push   %esi
  800d9b:	53                   	push   %ebx
  800d9c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d9f:	be 00 00 00 00       	mov    $0x0,%esi
  800da4:	8b 55 08             	mov    0x8(%ebp),%edx
  800da7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800daa:	b8 04 00 00 00       	mov    $0x4,%eax
  800daf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800db2:	89 f7                	mov    %esi,%edi
  800db4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db6:	85 c0                	test   %eax,%eax
  800db8:	7f 08                	jg     800dc2 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800dc6:	6a 04                	push   $0x4
  800dc8:	68 e8 29 80 00       	push   $0x8029e8
  800dcd:	6a 43                	push   $0x43
  800dcf:	68 05 2a 80 00       	push   $0x802a05
  800dd4:	e8 08 15 00 00       	call   8022e1 <_panic>

00800dd9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
  800ddc:	57                   	push   %edi
  800ddd:	56                   	push   %esi
  800dde:	53                   	push   %ebx
  800ddf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de2:	8b 55 08             	mov    0x8(%ebp),%edx
  800de5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de8:	b8 05 00 00 00       	mov    $0x5,%eax
  800ded:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800df3:	8b 75 18             	mov    0x18(%ebp),%esi
  800df6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	7f 08                	jg     800e04 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800e08:	6a 05                	push   $0x5
  800e0a:	68 e8 29 80 00       	push   $0x8029e8
  800e0f:	6a 43                	push   $0x43
  800e11:	68 05 2a 80 00       	push   $0x802a05
  800e16:	e8 c6 14 00 00       	call   8022e1 <_panic>

00800e1b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  800e2f:	b8 06 00 00 00       	mov    $0x6,%eax
  800e34:	89 df                	mov    %ebx,%edi
  800e36:	89 de                	mov    %ebx,%esi
  800e38:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3a:	85 c0                	test   %eax,%eax
  800e3c:	7f 08                	jg     800e46 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800e4a:	6a 06                	push   $0x6
  800e4c:	68 e8 29 80 00       	push   $0x8029e8
  800e51:	6a 43                	push   $0x43
  800e53:	68 05 2a 80 00       	push   $0x802a05
  800e58:	e8 84 14 00 00       	call   8022e1 <_panic>

00800e5d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  800e71:	b8 08 00 00 00       	mov    $0x8,%eax
  800e76:	89 df                	mov    %ebx,%edi
  800e78:	89 de                	mov    %ebx,%esi
  800e7a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7c:	85 c0                	test   %eax,%eax
  800e7e:	7f 08                	jg     800e88 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800e8c:	6a 08                	push   $0x8
  800e8e:	68 e8 29 80 00       	push   $0x8029e8
  800e93:	6a 43                	push   $0x43
  800e95:	68 05 2a 80 00       	push   $0x802a05
  800e9a:	e8 42 14 00 00       	call   8022e1 <_panic>

00800e9f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
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
  800eb3:	b8 09 00 00 00       	mov    $0x9,%eax
  800eb8:	89 df                	mov    %ebx,%edi
  800eba:	89 de                	mov    %ebx,%esi
  800ebc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebe:	85 c0                	test   %eax,%eax
  800ec0:	7f 08                	jg     800eca <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
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
  800ece:	6a 09                	push   $0x9
  800ed0:	68 e8 29 80 00       	push   $0x8029e8
  800ed5:	6a 43                	push   $0x43
  800ed7:	68 05 2a 80 00       	push   $0x802a05
  800edc:	e8 00 14 00 00       	call   8022e1 <_panic>

00800ee1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ee1:	55                   	push   %ebp
  800ee2:	89 e5                	mov    %esp,%ebp
  800ee4:	57                   	push   %edi
  800ee5:	56                   	push   %esi
  800ee6:	53                   	push   %ebx
  800ee7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eea:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eef:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800efa:	89 df                	mov    %ebx,%edi
  800efc:	89 de                	mov    %ebx,%esi
  800efe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f00:	85 c0                	test   %eax,%eax
  800f02:	7f 08                	jg     800f0c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f04:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f07:	5b                   	pop    %ebx
  800f08:	5e                   	pop    %esi
  800f09:	5f                   	pop    %edi
  800f0a:	5d                   	pop    %ebp
  800f0b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f0c:	83 ec 0c             	sub    $0xc,%esp
  800f0f:	50                   	push   %eax
  800f10:	6a 0a                	push   $0xa
  800f12:	68 e8 29 80 00       	push   $0x8029e8
  800f17:	6a 43                	push   $0x43
  800f19:	68 05 2a 80 00       	push   $0x802a05
  800f1e:	e8 be 13 00 00       	call   8022e1 <_panic>

00800f23 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
  800f26:	57                   	push   %edi
  800f27:	56                   	push   %esi
  800f28:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f29:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f34:	be 00 00 00 00       	mov    $0x0,%esi
  800f39:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f3c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f3f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f41:	5b                   	pop    %ebx
  800f42:	5e                   	pop    %esi
  800f43:	5f                   	pop    %edi
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    

00800f46 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	57                   	push   %edi
  800f4a:	56                   	push   %esi
  800f4b:	53                   	push   %ebx
  800f4c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f4f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f54:	8b 55 08             	mov    0x8(%ebp),%edx
  800f57:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f5c:	89 cb                	mov    %ecx,%ebx
  800f5e:	89 cf                	mov    %ecx,%edi
  800f60:	89 ce                	mov    %ecx,%esi
  800f62:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f64:	85 c0                	test   %eax,%eax
  800f66:	7f 08                	jg     800f70 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f6b:	5b                   	pop    %ebx
  800f6c:	5e                   	pop    %esi
  800f6d:	5f                   	pop    %edi
  800f6e:	5d                   	pop    %ebp
  800f6f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f70:	83 ec 0c             	sub    $0xc,%esp
  800f73:	50                   	push   %eax
  800f74:	6a 0d                	push   $0xd
  800f76:	68 e8 29 80 00       	push   $0x8029e8
  800f7b:	6a 43                	push   $0x43
  800f7d:	68 05 2a 80 00       	push   $0x802a05
  800f82:	e8 5a 13 00 00       	call   8022e1 <_panic>

00800f87 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f87:	55                   	push   %ebp
  800f88:	89 e5                	mov    %esp,%ebp
  800f8a:	57                   	push   %edi
  800f8b:	56                   	push   %esi
  800f8c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f92:	8b 55 08             	mov    0x8(%ebp),%edx
  800f95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f98:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f9d:	89 df                	mov    %ebx,%edi
  800f9f:	89 de                	mov    %ebx,%esi
  800fa1:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fa3:	5b                   	pop    %ebx
  800fa4:	5e                   	pop    %esi
  800fa5:	5f                   	pop    %edi
  800fa6:	5d                   	pop    %ebp
  800fa7:	c3                   	ret    

00800fa8 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fa8:	55                   	push   %ebp
  800fa9:	89 e5                	mov    %esp,%ebp
  800fab:	57                   	push   %edi
  800fac:	56                   	push   %esi
  800fad:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fae:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb6:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fbb:	89 cb                	mov    %ecx,%ebx
  800fbd:	89 cf                	mov    %ecx,%edi
  800fbf:	89 ce                	mov    %ecx,%esi
  800fc1:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fc3:	5b                   	pop    %ebx
  800fc4:	5e                   	pop    %esi
  800fc5:	5f                   	pop    %edi
  800fc6:	5d                   	pop    %ebp
  800fc7:	c3                   	ret    

00800fc8 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fc8:	55                   	push   %ebp
  800fc9:	89 e5                	mov    %esp,%ebp
  800fcb:	57                   	push   %edi
  800fcc:	56                   	push   %esi
  800fcd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fce:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd3:	b8 10 00 00 00       	mov    $0x10,%eax
  800fd8:	89 d1                	mov    %edx,%ecx
  800fda:	89 d3                	mov    %edx,%ebx
  800fdc:	89 d7                	mov    %edx,%edi
  800fde:	89 d6                	mov    %edx,%esi
  800fe0:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fe2:	5b                   	pop    %ebx
  800fe3:	5e                   	pop    %esi
  800fe4:	5f                   	pop    %edi
  800fe5:	5d                   	pop    %ebp
  800fe6:	c3                   	ret    

00800fe7 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800fe7:	55                   	push   %ebp
  800fe8:	89 e5                	mov    %esp,%ebp
  800fea:	57                   	push   %edi
  800feb:	56                   	push   %esi
  800fec:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fed:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff8:	b8 11 00 00 00       	mov    $0x11,%eax
  800ffd:	89 df                	mov    %ebx,%edi
  800fff:	89 de                	mov    %ebx,%esi
  801001:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801003:	5b                   	pop    %ebx
  801004:	5e                   	pop    %esi
  801005:	5f                   	pop    %edi
  801006:	5d                   	pop    %ebp
  801007:	c3                   	ret    

00801008 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801008:	55                   	push   %ebp
  801009:	89 e5                	mov    %esp,%ebp
  80100b:	57                   	push   %edi
  80100c:	56                   	push   %esi
  80100d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80100e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801013:	8b 55 08             	mov    0x8(%ebp),%edx
  801016:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801019:	b8 12 00 00 00       	mov    $0x12,%eax
  80101e:	89 df                	mov    %ebx,%edi
  801020:	89 de                	mov    %ebx,%esi
  801022:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801024:	5b                   	pop    %ebx
  801025:	5e                   	pop    %esi
  801026:	5f                   	pop    %edi
  801027:	5d                   	pop    %ebp
  801028:	c3                   	ret    

00801029 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	57                   	push   %edi
  80102d:	56                   	push   %esi
  80102e:	53                   	push   %ebx
  80102f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801032:	bb 00 00 00 00       	mov    $0x0,%ebx
  801037:	8b 55 08             	mov    0x8(%ebp),%edx
  80103a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103d:	b8 13 00 00 00       	mov    $0x13,%eax
  801042:	89 df                	mov    %ebx,%edi
  801044:	89 de                	mov    %ebx,%esi
  801046:	cd 30                	int    $0x30
	if(check && ret > 0)
  801048:	85 c0                	test   %eax,%eax
  80104a:	7f 08                	jg     801054 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80104c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80104f:	5b                   	pop    %ebx
  801050:	5e                   	pop    %esi
  801051:	5f                   	pop    %edi
  801052:	5d                   	pop    %ebp
  801053:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801054:	83 ec 0c             	sub    $0xc,%esp
  801057:	50                   	push   %eax
  801058:	6a 13                	push   $0x13
  80105a:	68 e8 29 80 00       	push   $0x8029e8
  80105f:	6a 43                	push   $0x43
  801061:	68 05 2a 80 00       	push   $0x802a05
  801066:	e8 76 12 00 00       	call   8022e1 <_panic>

0080106b <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	57                   	push   %edi
  80106f:	56                   	push   %esi
  801070:	53                   	push   %ebx
	asm volatile("int %1\n"
  801071:	b9 00 00 00 00       	mov    $0x0,%ecx
  801076:	8b 55 08             	mov    0x8(%ebp),%edx
  801079:	b8 14 00 00 00       	mov    $0x14,%eax
  80107e:	89 cb                	mov    %ecx,%ebx
  801080:	89 cf                	mov    %ecx,%edi
  801082:	89 ce                	mov    %ecx,%esi
  801084:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801086:	5b                   	pop    %ebx
  801087:	5e                   	pop    %esi
  801088:	5f                   	pop    %edi
  801089:	5d                   	pop    %ebp
  80108a:	c3                   	ret    

0080108b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80108b:	55                   	push   %ebp
  80108c:	89 e5                	mov    %esp,%ebp
  80108e:	56                   	push   %esi
  80108f:	53                   	push   %ebx
  801090:	8b 75 08             	mov    0x8(%ebp),%esi
  801093:	8b 45 0c             	mov    0xc(%ebp),%eax
  801096:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  801099:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80109b:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8010a0:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8010a3:	83 ec 0c             	sub    $0xc,%esp
  8010a6:	50                   	push   %eax
  8010a7:	e8 9a fe ff ff       	call   800f46 <sys_ipc_recv>
	if(ret < 0){
  8010ac:	83 c4 10             	add    $0x10,%esp
  8010af:	85 c0                	test   %eax,%eax
  8010b1:	78 2b                	js     8010de <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8010b3:	85 f6                	test   %esi,%esi
  8010b5:	74 0a                	je     8010c1 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8010b7:	a1 08 40 80 00       	mov    0x804008,%eax
  8010bc:	8b 40 78             	mov    0x78(%eax),%eax
  8010bf:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8010c1:	85 db                	test   %ebx,%ebx
  8010c3:	74 0a                	je     8010cf <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8010c5:	a1 08 40 80 00       	mov    0x804008,%eax
  8010ca:	8b 40 7c             	mov    0x7c(%eax),%eax
  8010cd:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8010cf:	a1 08 40 80 00       	mov    0x804008,%eax
  8010d4:	8b 40 74             	mov    0x74(%eax),%eax
}
  8010d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010da:	5b                   	pop    %ebx
  8010db:	5e                   	pop    %esi
  8010dc:	5d                   	pop    %ebp
  8010dd:	c3                   	ret    
		if(from_env_store)
  8010de:	85 f6                	test   %esi,%esi
  8010e0:	74 06                	je     8010e8 <ipc_recv+0x5d>
			*from_env_store = 0;
  8010e2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8010e8:	85 db                	test   %ebx,%ebx
  8010ea:	74 eb                	je     8010d7 <ipc_recv+0x4c>
			*perm_store = 0;
  8010ec:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8010f2:	eb e3                	jmp    8010d7 <ipc_recv+0x4c>

008010f4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	57                   	push   %edi
  8010f8:	56                   	push   %esi
  8010f9:	53                   	push   %ebx
  8010fa:	83 ec 0c             	sub    $0xc,%esp
  8010fd:	8b 7d 08             	mov    0x8(%ebp),%edi
  801100:	8b 75 0c             	mov    0xc(%ebp),%esi
  801103:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801106:	85 db                	test   %ebx,%ebx
  801108:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80110d:	0f 44 d8             	cmove  %eax,%ebx
  801110:	eb 05                	jmp    801117 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801112:	e8 60 fc ff ff       	call   800d77 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801117:	ff 75 14             	pushl  0x14(%ebp)
  80111a:	53                   	push   %ebx
  80111b:	56                   	push   %esi
  80111c:	57                   	push   %edi
  80111d:	e8 01 fe ff ff       	call   800f23 <sys_ipc_try_send>
  801122:	83 c4 10             	add    $0x10,%esp
  801125:	85 c0                	test   %eax,%eax
  801127:	74 1b                	je     801144 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801129:	79 e7                	jns    801112 <ipc_send+0x1e>
  80112b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80112e:	74 e2                	je     801112 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801130:	83 ec 04             	sub    $0x4,%esp
  801133:	68 13 2a 80 00       	push   $0x802a13
  801138:	6a 46                	push   $0x46
  80113a:	68 28 2a 80 00       	push   $0x802a28
  80113f:	e8 9d 11 00 00       	call   8022e1 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801144:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801147:	5b                   	pop    %ebx
  801148:	5e                   	pop    %esi
  801149:	5f                   	pop    %edi
  80114a:	5d                   	pop    %ebp
  80114b:	c3                   	ret    

0080114c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801152:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801157:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80115d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801163:	8b 52 50             	mov    0x50(%edx),%edx
  801166:	39 ca                	cmp    %ecx,%edx
  801168:	74 11                	je     80117b <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80116a:	83 c0 01             	add    $0x1,%eax
  80116d:	3d 00 04 00 00       	cmp    $0x400,%eax
  801172:	75 e3                	jne    801157 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801174:	b8 00 00 00 00       	mov    $0x0,%eax
  801179:	eb 0e                	jmp    801189 <ipc_find_env+0x3d>
			return envs[i].env_id;
  80117b:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  801181:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801186:	8b 40 48             	mov    0x48(%eax),%eax
}
  801189:	5d                   	pop    %ebp
  80118a:	c3                   	ret    

0080118b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
  801191:	05 00 00 00 30       	add    $0x30000000,%eax
  801196:	c1 e8 0c             	shr    $0xc,%eax
}
  801199:	5d                   	pop    %ebp
  80119a:	c3                   	ret    

0080119b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011ab:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011b0:	5d                   	pop    %ebp
  8011b1:	c3                   	ret    

008011b2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011b2:	55                   	push   %ebp
  8011b3:	89 e5                	mov    %esp,%ebp
  8011b5:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011ba:	89 c2                	mov    %eax,%edx
  8011bc:	c1 ea 16             	shr    $0x16,%edx
  8011bf:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011c6:	f6 c2 01             	test   $0x1,%dl
  8011c9:	74 2d                	je     8011f8 <fd_alloc+0x46>
  8011cb:	89 c2                	mov    %eax,%edx
  8011cd:	c1 ea 0c             	shr    $0xc,%edx
  8011d0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011d7:	f6 c2 01             	test   $0x1,%dl
  8011da:	74 1c                	je     8011f8 <fd_alloc+0x46>
  8011dc:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011e1:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011e6:	75 d2                	jne    8011ba <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8011f1:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011f6:	eb 0a                	jmp    801202 <fd_alloc+0x50>
			*fd_store = fd;
  8011f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011fb:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801202:	5d                   	pop    %ebp
  801203:	c3                   	ret    

00801204 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801204:	55                   	push   %ebp
  801205:	89 e5                	mov    %esp,%ebp
  801207:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80120a:	83 f8 1f             	cmp    $0x1f,%eax
  80120d:	77 30                	ja     80123f <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80120f:	c1 e0 0c             	shl    $0xc,%eax
  801212:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801217:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80121d:	f6 c2 01             	test   $0x1,%dl
  801220:	74 24                	je     801246 <fd_lookup+0x42>
  801222:	89 c2                	mov    %eax,%edx
  801224:	c1 ea 0c             	shr    $0xc,%edx
  801227:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80122e:	f6 c2 01             	test   $0x1,%dl
  801231:	74 1a                	je     80124d <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801233:	8b 55 0c             	mov    0xc(%ebp),%edx
  801236:	89 02                	mov    %eax,(%edx)
	return 0;
  801238:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80123d:	5d                   	pop    %ebp
  80123e:	c3                   	ret    
		return -E_INVAL;
  80123f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801244:	eb f7                	jmp    80123d <fd_lookup+0x39>
		return -E_INVAL;
  801246:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80124b:	eb f0                	jmp    80123d <fd_lookup+0x39>
  80124d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801252:	eb e9                	jmp    80123d <fd_lookup+0x39>

00801254 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
  801257:	83 ec 08             	sub    $0x8,%esp
  80125a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80125d:	ba 00 00 00 00       	mov    $0x0,%edx
  801262:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801267:	39 08                	cmp    %ecx,(%eax)
  801269:	74 38                	je     8012a3 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80126b:	83 c2 01             	add    $0x1,%edx
  80126e:	8b 04 95 b0 2a 80 00 	mov    0x802ab0(,%edx,4),%eax
  801275:	85 c0                	test   %eax,%eax
  801277:	75 ee                	jne    801267 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801279:	a1 08 40 80 00       	mov    0x804008,%eax
  80127e:	8b 40 48             	mov    0x48(%eax),%eax
  801281:	83 ec 04             	sub    $0x4,%esp
  801284:	51                   	push   %ecx
  801285:	50                   	push   %eax
  801286:	68 34 2a 80 00       	push   $0x802a34
  80128b:	e8 b5 ef ff ff       	call   800245 <cprintf>
	*dev = 0;
  801290:	8b 45 0c             	mov    0xc(%ebp),%eax
  801293:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801299:	83 c4 10             	add    $0x10,%esp
  80129c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012a1:	c9                   	leave  
  8012a2:	c3                   	ret    
			*dev = devtab[i];
  8012a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ad:	eb f2                	jmp    8012a1 <dev_lookup+0x4d>

008012af <fd_close>:
{
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
  8012b2:	57                   	push   %edi
  8012b3:	56                   	push   %esi
  8012b4:	53                   	push   %ebx
  8012b5:	83 ec 24             	sub    $0x24,%esp
  8012b8:	8b 75 08             	mov    0x8(%ebp),%esi
  8012bb:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012be:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012c1:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012c2:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012c8:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012cb:	50                   	push   %eax
  8012cc:	e8 33 ff ff ff       	call   801204 <fd_lookup>
  8012d1:	89 c3                	mov    %eax,%ebx
  8012d3:	83 c4 10             	add    $0x10,%esp
  8012d6:	85 c0                	test   %eax,%eax
  8012d8:	78 05                	js     8012df <fd_close+0x30>
	    || fd != fd2)
  8012da:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012dd:	74 16                	je     8012f5 <fd_close+0x46>
		return (must_exist ? r : 0);
  8012df:	89 f8                	mov    %edi,%eax
  8012e1:	84 c0                	test   %al,%al
  8012e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e8:	0f 44 d8             	cmove  %eax,%ebx
}
  8012eb:	89 d8                	mov    %ebx,%eax
  8012ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012f0:	5b                   	pop    %ebx
  8012f1:	5e                   	pop    %esi
  8012f2:	5f                   	pop    %edi
  8012f3:	5d                   	pop    %ebp
  8012f4:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012f5:	83 ec 08             	sub    $0x8,%esp
  8012f8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012fb:	50                   	push   %eax
  8012fc:	ff 36                	pushl  (%esi)
  8012fe:	e8 51 ff ff ff       	call   801254 <dev_lookup>
  801303:	89 c3                	mov    %eax,%ebx
  801305:	83 c4 10             	add    $0x10,%esp
  801308:	85 c0                	test   %eax,%eax
  80130a:	78 1a                	js     801326 <fd_close+0x77>
		if (dev->dev_close)
  80130c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80130f:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801312:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801317:	85 c0                	test   %eax,%eax
  801319:	74 0b                	je     801326 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80131b:	83 ec 0c             	sub    $0xc,%esp
  80131e:	56                   	push   %esi
  80131f:	ff d0                	call   *%eax
  801321:	89 c3                	mov    %eax,%ebx
  801323:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801326:	83 ec 08             	sub    $0x8,%esp
  801329:	56                   	push   %esi
  80132a:	6a 00                	push   $0x0
  80132c:	e8 ea fa ff ff       	call   800e1b <sys_page_unmap>
	return r;
  801331:	83 c4 10             	add    $0x10,%esp
  801334:	eb b5                	jmp    8012eb <fd_close+0x3c>

00801336 <close>:

int
close(int fdnum)
{
  801336:	55                   	push   %ebp
  801337:	89 e5                	mov    %esp,%ebp
  801339:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80133c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80133f:	50                   	push   %eax
  801340:	ff 75 08             	pushl  0x8(%ebp)
  801343:	e8 bc fe ff ff       	call   801204 <fd_lookup>
  801348:	83 c4 10             	add    $0x10,%esp
  80134b:	85 c0                	test   %eax,%eax
  80134d:	79 02                	jns    801351 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80134f:	c9                   	leave  
  801350:	c3                   	ret    
		return fd_close(fd, 1);
  801351:	83 ec 08             	sub    $0x8,%esp
  801354:	6a 01                	push   $0x1
  801356:	ff 75 f4             	pushl  -0xc(%ebp)
  801359:	e8 51 ff ff ff       	call   8012af <fd_close>
  80135e:	83 c4 10             	add    $0x10,%esp
  801361:	eb ec                	jmp    80134f <close+0x19>

00801363 <close_all>:

void
close_all(void)
{
  801363:	55                   	push   %ebp
  801364:	89 e5                	mov    %esp,%ebp
  801366:	53                   	push   %ebx
  801367:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80136a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80136f:	83 ec 0c             	sub    $0xc,%esp
  801372:	53                   	push   %ebx
  801373:	e8 be ff ff ff       	call   801336 <close>
	for (i = 0; i < MAXFD; i++)
  801378:	83 c3 01             	add    $0x1,%ebx
  80137b:	83 c4 10             	add    $0x10,%esp
  80137e:	83 fb 20             	cmp    $0x20,%ebx
  801381:	75 ec                	jne    80136f <close_all+0xc>
}
  801383:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801386:	c9                   	leave  
  801387:	c3                   	ret    

00801388 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
  80138b:	57                   	push   %edi
  80138c:	56                   	push   %esi
  80138d:	53                   	push   %ebx
  80138e:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801391:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801394:	50                   	push   %eax
  801395:	ff 75 08             	pushl  0x8(%ebp)
  801398:	e8 67 fe ff ff       	call   801204 <fd_lookup>
  80139d:	89 c3                	mov    %eax,%ebx
  80139f:	83 c4 10             	add    $0x10,%esp
  8013a2:	85 c0                	test   %eax,%eax
  8013a4:	0f 88 81 00 00 00    	js     80142b <dup+0xa3>
		return r;
	close(newfdnum);
  8013aa:	83 ec 0c             	sub    $0xc,%esp
  8013ad:	ff 75 0c             	pushl  0xc(%ebp)
  8013b0:	e8 81 ff ff ff       	call   801336 <close>

	newfd = INDEX2FD(newfdnum);
  8013b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013b8:	c1 e6 0c             	shl    $0xc,%esi
  8013bb:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013c1:	83 c4 04             	add    $0x4,%esp
  8013c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013c7:	e8 cf fd ff ff       	call   80119b <fd2data>
  8013cc:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013ce:	89 34 24             	mov    %esi,(%esp)
  8013d1:	e8 c5 fd ff ff       	call   80119b <fd2data>
  8013d6:	83 c4 10             	add    $0x10,%esp
  8013d9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013db:	89 d8                	mov    %ebx,%eax
  8013dd:	c1 e8 16             	shr    $0x16,%eax
  8013e0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013e7:	a8 01                	test   $0x1,%al
  8013e9:	74 11                	je     8013fc <dup+0x74>
  8013eb:	89 d8                	mov    %ebx,%eax
  8013ed:	c1 e8 0c             	shr    $0xc,%eax
  8013f0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013f7:	f6 c2 01             	test   $0x1,%dl
  8013fa:	75 39                	jne    801435 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013ff:	89 d0                	mov    %edx,%eax
  801401:	c1 e8 0c             	shr    $0xc,%eax
  801404:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80140b:	83 ec 0c             	sub    $0xc,%esp
  80140e:	25 07 0e 00 00       	and    $0xe07,%eax
  801413:	50                   	push   %eax
  801414:	56                   	push   %esi
  801415:	6a 00                	push   $0x0
  801417:	52                   	push   %edx
  801418:	6a 00                	push   $0x0
  80141a:	e8 ba f9 ff ff       	call   800dd9 <sys_page_map>
  80141f:	89 c3                	mov    %eax,%ebx
  801421:	83 c4 20             	add    $0x20,%esp
  801424:	85 c0                	test   %eax,%eax
  801426:	78 31                	js     801459 <dup+0xd1>
		goto err;

	return newfdnum;
  801428:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80142b:	89 d8                	mov    %ebx,%eax
  80142d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801430:	5b                   	pop    %ebx
  801431:	5e                   	pop    %esi
  801432:	5f                   	pop    %edi
  801433:	5d                   	pop    %ebp
  801434:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801435:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80143c:	83 ec 0c             	sub    $0xc,%esp
  80143f:	25 07 0e 00 00       	and    $0xe07,%eax
  801444:	50                   	push   %eax
  801445:	57                   	push   %edi
  801446:	6a 00                	push   $0x0
  801448:	53                   	push   %ebx
  801449:	6a 00                	push   $0x0
  80144b:	e8 89 f9 ff ff       	call   800dd9 <sys_page_map>
  801450:	89 c3                	mov    %eax,%ebx
  801452:	83 c4 20             	add    $0x20,%esp
  801455:	85 c0                	test   %eax,%eax
  801457:	79 a3                	jns    8013fc <dup+0x74>
	sys_page_unmap(0, newfd);
  801459:	83 ec 08             	sub    $0x8,%esp
  80145c:	56                   	push   %esi
  80145d:	6a 00                	push   $0x0
  80145f:	e8 b7 f9 ff ff       	call   800e1b <sys_page_unmap>
	sys_page_unmap(0, nva);
  801464:	83 c4 08             	add    $0x8,%esp
  801467:	57                   	push   %edi
  801468:	6a 00                	push   $0x0
  80146a:	e8 ac f9 ff ff       	call   800e1b <sys_page_unmap>
	return r;
  80146f:	83 c4 10             	add    $0x10,%esp
  801472:	eb b7                	jmp    80142b <dup+0xa3>

00801474 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
  801477:	53                   	push   %ebx
  801478:	83 ec 1c             	sub    $0x1c,%esp
  80147b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80147e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801481:	50                   	push   %eax
  801482:	53                   	push   %ebx
  801483:	e8 7c fd ff ff       	call   801204 <fd_lookup>
  801488:	83 c4 10             	add    $0x10,%esp
  80148b:	85 c0                	test   %eax,%eax
  80148d:	78 3f                	js     8014ce <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80148f:	83 ec 08             	sub    $0x8,%esp
  801492:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801495:	50                   	push   %eax
  801496:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801499:	ff 30                	pushl  (%eax)
  80149b:	e8 b4 fd ff ff       	call   801254 <dev_lookup>
  8014a0:	83 c4 10             	add    $0x10,%esp
  8014a3:	85 c0                	test   %eax,%eax
  8014a5:	78 27                	js     8014ce <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014aa:	8b 42 08             	mov    0x8(%edx),%eax
  8014ad:	83 e0 03             	and    $0x3,%eax
  8014b0:	83 f8 01             	cmp    $0x1,%eax
  8014b3:	74 1e                	je     8014d3 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b8:	8b 40 08             	mov    0x8(%eax),%eax
  8014bb:	85 c0                	test   %eax,%eax
  8014bd:	74 35                	je     8014f4 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014bf:	83 ec 04             	sub    $0x4,%esp
  8014c2:	ff 75 10             	pushl  0x10(%ebp)
  8014c5:	ff 75 0c             	pushl  0xc(%ebp)
  8014c8:	52                   	push   %edx
  8014c9:	ff d0                	call   *%eax
  8014cb:	83 c4 10             	add    $0x10,%esp
}
  8014ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d1:	c9                   	leave  
  8014d2:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014d3:	a1 08 40 80 00       	mov    0x804008,%eax
  8014d8:	8b 40 48             	mov    0x48(%eax),%eax
  8014db:	83 ec 04             	sub    $0x4,%esp
  8014de:	53                   	push   %ebx
  8014df:	50                   	push   %eax
  8014e0:	68 75 2a 80 00       	push   $0x802a75
  8014e5:	e8 5b ed ff ff       	call   800245 <cprintf>
		return -E_INVAL;
  8014ea:	83 c4 10             	add    $0x10,%esp
  8014ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f2:	eb da                	jmp    8014ce <read+0x5a>
		return -E_NOT_SUPP;
  8014f4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014f9:	eb d3                	jmp    8014ce <read+0x5a>

008014fb <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	57                   	push   %edi
  8014ff:	56                   	push   %esi
  801500:	53                   	push   %ebx
  801501:	83 ec 0c             	sub    $0xc,%esp
  801504:	8b 7d 08             	mov    0x8(%ebp),%edi
  801507:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80150a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80150f:	39 f3                	cmp    %esi,%ebx
  801511:	73 23                	jae    801536 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801513:	83 ec 04             	sub    $0x4,%esp
  801516:	89 f0                	mov    %esi,%eax
  801518:	29 d8                	sub    %ebx,%eax
  80151a:	50                   	push   %eax
  80151b:	89 d8                	mov    %ebx,%eax
  80151d:	03 45 0c             	add    0xc(%ebp),%eax
  801520:	50                   	push   %eax
  801521:	57                   	push   %edi
  801522:	e8 4d ff ff ff       	call   801474 <read>
		if (m < 0)
  801527:	83 c4 10             	add    $0x10,%esp
  80152a:	85 c0                	test   %eax,%eax
  80152c:	78 06                	js     801534 <readn+0x39>
			return m;
		if (m == 0)
  80152e:	74 06                	je     801536 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801530:	01 c3                	add    %eax,%ebx
  801532:	eb db                	jmp    80150f <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801534:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801536:	89 d8                	mov    %ebx,%eax
  801538:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80153b:	5b                   	pop    %ebx
  80153c:	5e                   	pop    %esi
  80153d:	5f                   	pop    %edi
  80153e:	5d                   	pop    %ebp
  80153f:	c3                   	ret    

00801540 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
  801543:	53                   	push   %ebx
  801544:	83 ec 1c             	sub    $0x1c,%esp
  801547:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80154a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80154d:	50                   	push   %eax
  80154e:	53                   	push   %ebx
  80154f:	e8 b0 fc ff ff       	call   801204 <fd_lookup>
  801554:	83 c4 10             	add    $0x10,%esp
  801557:	85 c0                	test   %eax,%eax
  801559:	78 3a                	js     801595 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80155b:	83 ec 08             	sub    $0x8,%esp
  80155e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801561:	50                   	push   %eax
  801562:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801565:	ff 30                	pushl  (%eax)
  801567:	e8 e8 fc ff ff       	call   801254 <dev_lookup>
  80156c:	83 c4 10             	add    $0x10,%esp
  80156f:	85 c0                	test   %eax,%eax
  801571:	78 22                	js     801595 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801573:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801576:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80157a:	74 1e                	je     80159a <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80157c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80157f:	8b 52 0c             	mov    0xc(%edx),%edx
  801582:	85 d2                	test   %edx,%edx
  801584:	74 35                	je     8015bb <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801586:	83 ec 04             	sub    $0x4,%esp
  801589:	ff 75 10             	pushl  0x10(%ebp)
  80158c:	ff 75 0c             	pushl  0xc(%ebp)
  80158f:	50                   	push   %eax
  801590:	ff d2                	call   *%edx
  801592:	83 c4 10             	add    $0x10,%esp
}
  801595:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801598:	c9                   	leave  
  801599:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80159a:	a1 08 40 80 00       	mov    0x804008,%eax
  80159f:	8b 40 48             	mov    0x48(%eax),%eax
  8015a2:	83 ec 04             	sub    $0x4,%esp
  8015a5:	53                   	push   %ebx
  8015a6:	50                   	push   %eax
  8015a7:	68 91 2a 80 00       	push   $0x802a91
  8015ac:	e8 94 ec ff ff       	call   800245 <cprintf>
		return -E_INVAL;
  8015b1:	83 c4 10             	add    $0x10,%esp
  8015b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015b9:	eb da                	jmp    801595 <write+0x55>
		return -E_NOT_SUPP;
  8015bb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015c0:	eb d3                	jmp    801595 <write+0x55>

008015c2 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
  8015c5:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015cb:	50                   	push   %eax
  8015cc:	ff 75 08             	pushl  0x8(%ebp)
  8015cf:	e8 30 fc ff ff       	call   801204 <fd_lookup>
  8015d4:	83 c4 10             	add    $0x10,%esp
  8015d7:	85 c0                	test   %eax,%eax
  8015d9:	78 0e                	js     8015e9 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e1:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e9:	c9                   	leave  
  8015ea:	c3                   	ret    

008015eb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
  8015ee:	53                   	push   %ebx
  8015ef:	83 ec 1c             	sub    $0x1c,%esp
  8015f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015f5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015f8:	50                   	push   %eax
  8015f9:	53                   	push   %ebx
  8015fa:	e8 05 fc ff ff       	call   801204 <fd_lookup>
  8015ff:	83 c4 10             	add    $0x10,%esp
  801602:	85 c0                	test   %eax,%eax
  801604:	78 37                	js     80163d <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801606:	83 ec 08             	sub    $0x8,%esp
  801609:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80160c:	50                   	push   %eax
  80160d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801610:	ff 30                	pushl  (%eax)
  801612:	e8 3d fc ff ff       	call   801254 <dev_lookup>
  801617:	83 c4 10             	add    $0x10,%esp
  80161a:	85 c0                	test   %eax,%eax
  80161c:	78 1f                	js     80163d <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80161e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801621:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801625:	74 1b                	je     801642 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801627:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80162a:	8b 52 18             	mov    0x18(%edx),%edx
  80162d:	85 d2                	test   %edx,%edx
  80162f:	74 32                	je     801663 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801631:	83 ec 08             	sub    $0x8,%esp
  801634:	ff 75 0c             	pushl  0xc(%ebp)
  801637:	50                   	push   %eax
  801638:	ff d2                	call   *%edx
  80163a:	83 c4 10             	add    $0x10,%esp
}
  80163d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801640:	c9                   	leave  
  801641:	c3                   	ret    
			thisenv->env_id, fdnum);
  801642:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801647:	8b 40 48             	mov    0x48(%eax),%eax
  80164a:	83 ec 04             	sub    $0x4,%esp
  80164d:	53                   	push   %ebx
  80164e:	50                   	push   %eax
  80164f:	68 54 2a 80 00       	push   $0x802a54
  801654:	e8 ec eb ff ff       	call   800245 <cprintf>
		return -E_INVAL;
  801659:	83 c4 10             	add    $0x10,%esp
  80165c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801661:	eb da                	jmp    80163d <ftruncate+0x52>
		return -E_NOT_SUPP;
  801663:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801668:	eb d3                	jmp    80163d <ftruncate+0x52>

0080166a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
  80166d:	53                   	push   %ebx
  80166e:	83 ec 1c             	sub    $0x1c,%esp
  801671:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801674:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801677:	50                   	push   %eax
  801678:	ff 75 08             	pushl  0x8(%ebp)
  80167b:	e8 84 fb ff ff       	call   801204 <fd_lookup>
  801680:	83 c4 10             	add    $0x10,%esp
  801683:	85 c0                	test   %eax,%eax
  801685:	78 4b                	js     8016d2 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801687:	83 ec 08             	sub    $0x8,%esp
  80168a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80168d:	50                   	push   %eax
  80168e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801691:	ff 30                	pushl  (%eax)
  801693:	e8 bc fb ff ff       	call   801254 <dev_lookup>
  801698:	83 c4 10             	add    $0x10,%esp
  80169b:	85 c0                	test   %eax,%eax
  80169d:	78 33                	js     8016d2 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80169f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a2:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016a6:	74 2f                	je     8016d7 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016a8:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016ab:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016b2:	00 00 00 
	stat->st_isdir = 0;
  8016b5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016bc:	00 00 00 
	stat->st_dev = dev;
  8016bf:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016c5:	83 ec 08             	sub    $0x8,%esp
  8016c8:	53                   	push   %ebx
  8016c9:	ff 75 f0             	pushl  -0x10(%ebp)
  8016cc:	ff 50 14             	call   *0x14(%eax)
  8016cf:	83 c4 10             	add    $0x10,%esp
}
  8016d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    
		return -E_NOT_SUPP;
  8016d7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016dc:	eb f4                	jmp    8016d2 <fstat+0x68>

008016de <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
  8016e1:	56                   	push   %esi
  8016e2:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016e3:	83 ec 08             	sub    $0x8,%esp
  8016e6:	6a 00                	push   $0x0
  8016e8:	ff 75 08             	pushl  0x8(%ebp)
  8016eb:	e8 22 02 00 00       	call   801912 <open>
  8016f0:	89 c3                	mov    %eax,%ebx
  8016f2:	83 c4 10             	add    $0x10,%esp
  8016f5:	85 c0                	test   %eax,%eax
  8016f7:	78 1b                	js     801714 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016f9:	83 ec 08             	sub    $0x8,%esp
  8016fc:	ff 75 0c             	pushl  0xc(%ebp)
  8016ff:	50                   	push   %eax
  801700:	e8 65 ff ff ff       	call   80166a <fstat>
  801705:	89 c6                	mov    %eax,%esi
	close(fd);
  801707:	89 1c 24             	mov    %ebx,(%esp)
  80170a:	e8 27 fc ff ff       	call   801336 <close>
	return r;
  80170f:	83 c4 10             	add    $0x10,%esp
  801712:	89 f3                	mov    %esi,%ebx
}
  801714:	89 d8                	mov    %ebx,%eax
  801716:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801719:	5b                   	pop    %ebx
  80171a:	5e                   	pop    %esi
  80171b:	5d                   	pop    %ebp
  80171c:	c3                   	ret    

0080171d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
  801720:	56                   	push   %esi
  801721:	53                   	push   %ebx
  801722:	89 c6                	mov    %eax,%esi
  801724:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801726:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80172d:	74 27                	je     801756 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80172f:	6a 07                	push   $0x7
  801731:	68 00 50 80 00       	push   $0x805000
  801736:	56                   	push   %esi
  801737:	ff 35 00 40 80 00    	pushl  0x804000
  80173d:	e8 b2 f9 ff ff       	call   8010f4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801742:	83 c4 0c             	add    $0xc,%esp
  801745:	6a 00                	push   $0x0
  801747:	53                   	push   %ebx
  801748:	6a 00                	push   $0x0
  80174a:	e8 3c f9 ff ff       	call   80108b <ipc_recv>
}
  80174f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801752:	5b                   	pop    %ebx
  801753:	5e                   	pop    %esi
  801754:	5d                   	pop    %ebp
  801755:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801756:	83 ec 0c             	sub    $0xc,%esp
  801759:	6a 01                	push   $0x1
  80175b:	e8 ec f9 ff ff       	call   80114c <ipc_find_env>
  801760:	a3 00 40 80 00       	mov    %eax,0x804000
  801765:	83 c4 10             	add    $0x10,%esp
  801768:	eb c5                	jmp    80172f <fsipc+0x12>

0080176a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
  80176d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801770:	8b 45 08             	mov    0x8(%ebp),%eax
  801773:	8b 40 0c             	mov    0xc(%eax),%eax
  801776:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80177b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177e:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801783:	ba 00 00 00 00       	mov    $0x0,%edx
  801788:	b8 02 00 00 00       	mov    $0x2,%eax
  80178d:	e8 8b ff ff ff       	call   80171d <fsipc>
}
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <devfile_flush>:
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
  801797:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	8b 40 0c             	mov    0xc(%eax),%eax
  8017a0:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017aa:	b8 06 00 00 00       	mov    $0x6,%eax
  8017af:	e8 69 ff ff ff       	call   80171d <fsipc>
}
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    

008017b6 <devfile_stat>:
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
  8017b9:	53                   	push   %ebx
  8017ba:	83 ec 04             	sub    $0x4,%esp
  8017bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8017c6:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d0:	b8 05 00 00 00       	mov    $0x5,%eax
  8017d5:	e8 43 ff ff ff       	call   80171d <fsipc>
  8017da:	85 c0                	test   %eax,%eax
  8017dc:	78 2c                	js     80180a <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017de:	83 ec 08             	sub    $0x8,%esp
  8017e1:	68 00 50 80 00       	push   $0x805000
  8017e6:	53                   	push   %ebx
  8017e7:	e8 b8 f1 ff ff       	call   8009a4 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017ec:	a1 80 50 80 00       	mov    0x805080,%eax
  8017f1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017f7:	a1 84 50 80 00       	mov    0x805084,%eax
  8017fc:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801802:	83 c4 10             	add    $0x10,%esp
  801805:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80180a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80180d:	c9                   	leave  
  80180e:	c3                   	ret    

0080180f <devfile_write>:
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
  801812:	53                   	push   %ebx
  801813:	83 ec 08             	sub    $0x8,%esp
  801816:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	8b 40 0c             	mov    0xc(%eax),%eax
  80181f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801824:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80182a:	53                   	push   %ebx
  80182b:	ff 75 0c             	pushl  0xc(%ebp)
  80182e:	68 08 50 80 00       	push   $0x805008
  801833:	e8 5c f3 ff ff       	call   800b94 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801838:	ba 00 00 00 00       	mov    $0x0,%edx
  80183d:	b8 04 00 00 00       	mov    $0x4,%eax
  801842:	e8 d6 fe ff ff       	call   80171d <fsipc>
  801847:	83 c4 10             	add    $0x10,%esp
  80184a:	85 c0                	test   %eax,%eax
  80184c:	78 0b                	js     801859 <devfile_write+0x4a>
	assert(r <= n);
  80184e:	39 d8                	cmp    %ebx,%eax
  801850:	77 0c                	ja     80185e <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801852:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801857:	7f 1e                	jg     801877 <devfile_write+0x68>
}
  801859:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    
	assert(r <= n);
  80185e:	68 c4 2a 80 00       	push   $0x802ac4
  801863:	68 cb 2a 80 00       	push   $0x802acb
  801868:	68 98 00 00 00       	push   $0x98
  80186d:	68 e0 2a 80 00       	push   $0x802ae0
  801872:	e8 6a 0a 00 00       	call   8022e1 <_panic>
	assert(r <= PGSIZE);
  801877:	68 eb 2a 80 00       	push   $0x802aeb
  80187c:	68 cb 2a 80 00       	push   $0x802acb
  801881:	68 99 00 00 00       	push   $0x99
  801886:	68 e0 2a 80 00       	push   $0x802ae0
  80188b:	e8 51 0a 00 00       	call   8022e1 <_panic>

00801890 <devfile_read>:
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	56                   	push   %esi
  801894:	53                   	push   %ebx
  801895:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801898:	8b 45 08             	mov    0x8(%ebp),%eax
  80189b:	8b 40 0c             	mov    0xc(%eax),%eax
  80189e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018a3:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ae:	b8 03 00 00 00       	mov    $0x3,%eax
  8018b3:	e8 65 fe ff ff       	call   80171d <fsipc>
  8018b8:	89 c3                	mov    %eax,%ebx
  8018ba:	85 c0                	test   %eax,%eax
  8018bc:	78 1f                	js     8018dd <devfile_read+0x4d>
	assert(r <= n);
  8018be:	39 f0                	cmp    %esi,%eax
  8018c0:	77 24                	ja     8018e6 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018c2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018c7:	7f 33                	jg     8018fc <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018c9:	83 ec 04             	sub    $0x4,%esp
  8018cc:	50                   	push   %eax
  8018cd:	68 00 50 80 00       	push   $0x805000
  8018d2:	ff 75 0c             	pushl  0xc(%ebp)
  8018d5:	e8 58 f2 ff ff       	call   800b32 <memmove>
	return r;
  8018da:	83 c4 10             	add    $0x10,%esp
}
  8018dd:	89 d8                	mov    %ebx,%eax
  8018df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e2:	5b                   	pop    %ebx
  8018e3:	5e                   	pop    %esi
  8018e4:	5d                   	pop    %ebp
  8018e5:	c3                   	ret    
	assert(r <= n);
  8018e6:	68 c4 2a 80 00       	push   $0x802ac4
  8018eb:	68 cb 2a 80 00       	push   $0x802acb
  8018f0:	6a 7c                	push   $0x7c
  8018f2:	68 e0 2a 80 00       	push   $0x802ae0
  8018f7:	e8 e5 09 00 00       	call   8022e1 <_panic>
	assert(r <= PGSIZE);
  8018fc:	68 eb 2a 80 00       	push   $0x802aeb
  801901:	68 cb 2a 80 00       	push   $0x802acb
  801906:	6a 7d                	push   $0x7d
  801908:	68 e0 2a 80 00       	push   $0x802ae0
  80190d:	e8 cf 09 00 00       	call   8022e1 <_panic>

00801912 <open>:
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
  801915:	56                   	push   %esi
  801916:	53                   	push   %ebx
  801917:	83 ec 1c             	sub    $0x1c,%esp
  80191a:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80191d:	56                   	push   %esi
  80191e:	e8 48 f0 ff ff       	call   80096b <strlen>
  801923:	83 c4 10             	add    $0x10,%esp
  801926:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80192b:	7f 6c                	jg     801999 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80192d:	83 ec 0c             	sub    $0xc,%esp
  801930:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801933:	50                   	push   %eax
  801934:	e8 79 f8 ff ff       	call   8011b2 <fd_alloc>
  801939:	89 c3                	mov    %eax,%ebx
  80193b:	83 c4 10             	add    $0x10,%esp
  80193e:	85 c0                	test   %eax,%eax
  801940:	78 3c                	js     80197e <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801942:	83 ec 08             	sub    $0x8,%esp
  801945:	56                   	push   %esi
  801946:	68 00 50 80 00       	push   $0x805000
  80194b:	e8 54 f0 ff ff       	call   8009a4 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801950:	8b 45 0c             	mov    0xc(%ebp),%eax
  801953:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801958:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80195b:	b8 01 00 00 00       	mov    $0x1,%eax
  801960:	e8 b8 fd ff ff       	call   80171d <fsipc>
  801965:	89 c3                	mov    %eax,%ebx
  801967:	83 c4 10             	add    $0x10,%esp
  80196a:	85 c0                	test   %eax,%eax
  80196c:	78 19                	js     801987 <open+0x75>
	return fd2num(fd);
  80196e:	83 ec 0c             	sub    $0xc,%esp
  801971:	ff 75 f4             	pushl  -0xc(%ebp)
  801974:	e8 12 f8 ff ff       	call   80118b <fd2num>
  801979:	89 c3                	mov    %eax,%ebx
  80197b:	83 c4 10             	add    $0x10,%esp
}
  80197e:	89 d8                	mov    %ebx,%eax
  801980:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801983:	5b                   	pop    %ebx
  801984:	5e                   	pop    %esi
  801985:	5d                   	pop    %ebp
  801986:	c3                   	ret    
		fd_close(fd, 0);
  801987:	83 ec 08             	sub    $0x8,%esp
  80198a:	6a 00                	push   $0x0
  80198c:	ff 75 f4             	pushl  -0xc(%ebp)
  80198f:	e8 1b f9 ff ff       	call   8012af <fd_close>
		return r;
  801994:	83 c4 10             	add    $0x10,%esp
  801997:	eb e5                	jmp    80197e <open+0x6c>
		return -E_BAD_PATH;
  801999:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80199e:	eb de                	jmp    80197e <open+0x6c>

008019a0 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ab:	b8 08 00 00 00       	mov    $0x8,%eax
  8019b0:	e8 68 fd ff ff       	call   80171d <fsipc>
}
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
  8019ba:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8019bd:	68 f7 2a 80 00       	push   $0x802af7
  8019c2:	ff 75 0c             	pushl  0xc(%ebp)
  8019c5:	e8 da ef ff ff       	call   8009a4 <strcpy>
	return 0;
}
  8019ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <devsock_close>:
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
  8019d4:	53                   	push   %ebx
  8019d5:	83 ec 10             	sub    $0x10,%esp
  8019d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8019db:	53                   	push   %ebx
  8019dc:	e8 61 09 00 00       	call   802342 <pageref>
  8019e1:	83 c4 10             	add    $0x10,%esp
		return 0;
  8019e4:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8019e9:	83 f8 01             	cmp    $0x1,%eax
  8019ec:	74 07                	je     8019f5 <devsock_close+0x24>
}
  8019ee:	89 d0                	mov    %edx,%eax
  8019f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8019f5:	83 ec 0c             	sub    $0xc,%esp
  8019f8:	ff 73 0c             	pushl  0xc(%ebx)
  8019fb:	e8 b9 02 00 00       	call   801cb9 <nsipc_close>
  801a00:	89 c2                	mov    %eax,%edx
  801a02:	83 c4 10             	add    $0x10,%esp
  801a05:	eb e7                	jmp    8019ee <devsock_close+0x1d>

00801a07 <devsock_write>:
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a0d:	6a 00                	push   $0x0
  801a0f:	ff 75 10             	pushl  0x10(%ebp)
  801a12:	ff 75 0c             	pushl  0xc(%ebp)
  801a15:	8b 45 08             	mov    0x8(%ebp),%eax
  801a18:	ff 70 0c             	pushl  0xc(%eax)
  801a1b:	e8 76 03 00 00       	call   801d96 <nsipc_send>
}
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <devsock_read>:
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
  801a25:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a28:	6a 00                	push   $0x0
  801a2a:	ff 75 10             	pushl  0x10(%ebp)
  801a2d:	ff 75 0c             	pushl  0xc(%ebp)
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	ff 70 0c             	pushl  0xc(%eax)
  801a36:	e8 ef 02 00 00       	call   801d2a <nsipc_recv>
}
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <fd2sockid>:
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
  801a40:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a43:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a46:	52                   	push   %edx
  801a47:	50                   	push   %eax
  801a48:	e8 b7 f7 ff ff       	call   801204 <fd_lookup>
  801a4d:	83 c4 10             	add    $0x10,%esp
  801a50:	85 c0                	test   %eax,%eax
  801a52:	78 10                	js     801a64 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a57:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a5d:	39 08                	cmp    %ecx,(%eax)
  801a5f:	75 05                	jne    801a66 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a61:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    
		return -E_NOT_SUPP;
  801a66:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a6b:	eb f7                	jmp    801a64 <fd2sockid+0x27>

00801a6d <alloc_sockfd>:
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
  801a70:	56                   	push   %esi
  801a71:	53                   	push   %ebx
  801a72:	83 ec 1c             	sub    $0x1c,%esp
  801a75:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a77:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a7a:	50                   	push   %eax
  801a7b:	e8 32 f7 ff ff       	call   8011b2 <fd_alloc>
  801a80:	89 c3                	mov    %eax,%ebx
  801a82:	83 c4 10             	add    $0x10,%esp
  801a85:	85 c0                	test   %eax,%eax
  801a87:	78 43                	js     801acc <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a89:	83 ec 04             	sub    $0x4,%esp
  801a8c:	68 07 04 00 00       	push   $0x407
  801a91:	ff 75 f4             	pushl  -0xc(%ebp)
  801a94:	6a 00                	push   $0x0
  801a96:	e8 fb f2 ff ff       	call   800d96 <sys_page_alloc>
  801a9b:	89 c3                	mov    %eax,%ebx
  801a9d:	83 c4 10             	add    $0x10,%esp
  801aa0:	85 c0                	test   %eax,%eax
  801aa2:	78 28                	js     801acc <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa7:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801aad:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ab9:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801abc:	83 ec 0c             	sub    $0xc,%esp
  801abf:	50                   	push   %eax
  801ac0:	e8 c6 f6 ff ff       	call   80118b <fd2num>
  801ac5:	89 c3                	mov    %eax,%ebx
  801ac7:	83 c4 10             	add    $0x10,%esp
  801aca:	eb 0c                	jmp    801ad8 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801acc:	83 ec 0c             	sub    $0xc,%esp
  801acf:	56                   	push   %esi
  801ad0:	e8 e4 01 00 00       	call   801cb9 <nsipc_close>
		return r;
  801ad5:	83 c4 10             	add    $0x10,%esp
}
  801ad8:	89 d8                	mov    %ebx,%eax
  801ada:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801add:	5b                   	pop    %ebx
  801ade:	5e                   	pop    %esi
  801adf:	5d                   	pop    %ebp
  801ae0:	c3                   	ret    

00801ae1 <accept>:
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aea:	e8 4e ff ff ff       	call   801a3d <fd2sockid>
  801aef:	85 c0                	test   %eax,%eax
  801af1:	78 1b                	js     801b0e <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801af3:	83 ec 04             	sub    $0x4,%esp
  801af6:	ff 75 10             	pushl  0x10(%ebp)
  801af9:	ff 75 0c             	pushl  0xc(%ebp)
  801afc:	50                   	push   %eax
  801afd:	e8 0e 01 00 00       	call   801c10 <nsipc_accept>
  801b02:	83 c4 10             	add    $0x10,%esp
  801b05:	85 c0                	test   %eax,%eax
  801b07:	78 05                	js     801b0e <accept+0x2d>
	return alloc_sockfd(r);
  801b09:	e8 5f ff ff ff       	call   801a6d <alloc_sockfd>
}
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <bind>:
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
  801b13:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b16:	8b 45 08             	mov    0x8(%ebp),%eax
  801b19:	e8 1f ff ff ff       	call   801a3d <fd2sockid>
  801b1e:	85 c0                	test   %eax,%eax
  801b20:	78 12                	js     801b34 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801b22:	83 ec 04             	sub    $0x4,%esp
  801b25:	ff 75 10             	pushl  0x10(%ebp)
  801b28:	ff 75 0c             	pushl  0xc(%ebp)
  801b2b:	50                   	push   %eax
  801b2c:	e8 31 01 00 00       	call   801c62 <nsipc_bind>
  801b31:	83 c4 10             	add    $0x10,%esp
}
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <shutdown>:
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
  801b39:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3f:	e8 f9 fe ff ff       	call   801a3d <fd2sockid>
  801b44:	85 c0                	test   %eax,%eax
  801b46:	78 0f                	js     801b57 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801b48:	83 ec 08             	sub    $0x8,%esp
  801b4b:	ff 75 0c             	pushl  0xc(%ebp)
  801b4e:	50                   	push   %eax
  801b4f:	e8 43 01 00 00       	call   801c97 <nsipc_shutdown>
  801b54:	83 c4 10             	add    $0x10,%esp
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <connect>:
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b62:	e8 d6 fe ff ff       	call   801a3d <fd2sockid>
  801b67:	85 c0                	test   %eax,%eax
  801b69:	78 12                	js     801b7d <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b6b:	83 ec 04             	sub    $0x4,%esp
  801b6e:	ff 75 10             	pushl  0x10(%ebp)
  801b71:	ff 75 0c             	pushl  0xc(%ebp)
  801b74:	50                   	push   %eax
  801b75:	e8 59 01 00 00       	call   801cd3 <nsipc_connect>
  801b7a:	83 c4 10             	add    $0x10,%esp
}
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <listen>:
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b85:	8b 45 08             	mov    0x8(%ebp),%eax
  801b88:	e8 b0 fe ff ff       	call   801a3d <fd2sockid>
  801b8d:	85 c0                	test   %eax,%eax
  801b8f:	78 0f                	js     801ba0 <listen+0x21>
	return nsipc_listen(r, backlog);
  801b91:	83 ec 08             	sub    $0x8,%esp
  801b94:	ff 75 0c             	pushl  0xc(%ebp)
  801b97:	50                   	push   %eax
  801b98:	e8 6b 01 00 00       	call   801d08 <nsipc_listen>
  801b9d:	83 c4 10             	add    $0x10,%esp
}
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <socket>:

int
socket(int domain, int type, int protocol)
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
  801ba5:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ba8:	ff 75 10             	pushl  0x10(%ebp)
  801bab:	ff 75 0c             	pushl  0xc(%ebp)
  801bae:	ff 75 08             	pushl  0x8(%ebp)
  801bb1:	e8 3e 02 00 00       	call   801df4 <nsipc_socket>
  801bb6:	83 c4 10             	add    $0x10,%esp
  801bb9:	85 c0                	test   %eax,%eax
  801bbb:	78 05                	js     801bc2 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801bbd:	e8 ab fe ff ff       	call   801a6d <alloc_sockfd>
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
  801bc7:	53                   	push   %ebx
  801bc8:	83 ec 04             	sub    $0x4,%esp
  801bcb:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801bcd:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801bd4:	74 26                	je     801bfc <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801bd6:	6a 07                	push   $0x7
  801bd8:	68 00 60 80 00       	push   $0x806000
  801bdd:	53                   	push   %ebx
  801bde:	ff 35 04 40 80 00    	pushl  0x804004
  801be4:	e8 0b f5 ff ff       	call   8010f4 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801be9:	83 c4 0c             	add    $0xc,%esp
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	e8 94 f4 ff ff       	call   80108b <ipc_recv>
}
  801bf7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801bfc:	83 ec 0c             	sub    $0xc,%esp
  801bff:	6a 02                	push   $0x2
  801c01:	e8 46 f5 ff ff       	call   80114c <ipc_find_env>
  801c06:	a3 04 40 80 00       	mov    %eax,0x804004
  801c0b:	83 c4 10             	add    $0x10,%esp
  801c0e:	eb c6                	jmp    801bd6 <nsipc+0x12>

00801c10 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	56                   	push   %esi
  801c14:	53                   	push   %ebx
  801c15:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c18:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c20:	8b 06                	mov    (%esi),%eax
  801c22:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c27:	b8 01 00 00 00       	mov    $0x1,%eax
  801c2c:	e8 93 ff ff ff       	call   801bc4 <nsipc>
  801c31:	89 c3                	mov    %eax,%ebx
  801c33:	85 c0                	test   %eax,%eax
  801c35:	79 09                	jns    801c40 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801c37:	89 d8                	mov    %ebx,%eax
  801c39:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c3c:	5b                   	pop    %ebx
  801c3d:	5e                   	pop    %esi
  801c3e:	5d                   	pop    %ebp
  801c3f:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c40:	83 ec 04             	sub    $0x4,%esp
  801c43:	ff 35 10 60 80 00    	pushl  0x806010
  801c49:	68 00 60 80 00       	push   $0x806000
  801c4e:	ff 75 0c             	pushl  0xc(%ebp)
  801c51:	e8 dc ee ff ff       	call   800b32 <memmove>
		*addrlen = ret->ret_addrlen;
  801c56:	a1 10 60 80 00       	mov    0x806010,%eax
  801c5b:	89 06                	mov    %eax,(%esi)
  801c5d:	83 c4 10             	add    $0x10,%esp
	return r;
  801c60:	eb d5                	jmp    801c37 <nsipc_accept+0x27>

00801c62 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	53                   	push   %ebx
  801c66:	83 ec 08             	sub    $0x8,%esp
  801c69:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6f:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c74:	53                   	push   %ebx
  801c75:	ff 75 0c             	pushl  0xc(%ebp)
  801c78:	68 04 60 80 00       	push   $0x806004
  801c7d:	e8 b0 ee ff ff       	call   800b32 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c82:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c88:	b8 02 00 00 00       	mov    $0x2,%eax
  801c8d:	e8 32 ff ff ff       	call   801bc4 <nsipc>
}
  801c92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
  801c9a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801ca5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca8:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801cad:	b8 03 00 00 00       	mov    $0x3,%eax
  801cb2:	e8 0d ff ff ff       	call   801bc4 <nsipc>
}
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <nsipc_close>:

int
nsipc_close(int s)
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc2:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801cc7:	b8 04 00 00 00       	mov    $0x4,%eax
  801ccc:	e8 f3 fe ff ff       	call   801bc4 <nsipc>
}
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    

00801cd3 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	53                   	push   %ebx
  801cd7:	83 ec 08             	sub    $0x8,%esp
  801cda:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce0:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ce5:	53                   	push   %ebx
  801ce6:	ff 75 0c             	pushl  0xc(%ebp)
  801ce9:	68 04 60 80 00       	push   $0x806004
  801cee:	e8 3f ee ff ff       	call   800b32 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801cf3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801cf9:	b8 05 00 00 00       	mov    $0x5,%eax
  801cfe:	e8 c1 fe ff ff       	call   801bc4 <nsipc>
}
  801d03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
  801d0b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d11:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d19:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d1e:	b8 06 00 00 00       	mov    $0x6,%eax
  801d23:	e8 9c fe ff ff       	call   801bc4 <nsipc>
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	56                   	push   %esi
  801d2e:	53                   	push   %ebx
  801d2f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d32:	8b 45 08             	mov    0x8(%ebp),%eax
  801d35:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d3a:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d40:	8b 45 14             	mov    0x14(%ebp),%eax
  801d43:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d48:	b8 07 00 00 00       	mov    $0x7,%eax
  801d4d:	e8 72 fe ff ff       	call   801bc4 <nsipc>
  801d52:	89 c3                	mov    %eax,%ebx
  801d54:	85 c0                	test   %eax,%eax
  801d56:	78 1f                	js     801d77 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d58:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d5d:	7f 21                	jg     801d80 <nsipc_recv+0x56>
  801d5f:	39 c6                	cmp    %eax,%esi
  801d61:	7c 1d                	jl     801d80 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d63:	83 ec 04             	sub    $0x4,%esp
  801d66:	50                   	push   %eax
  801d67:	68 00 60 80 00       	push   $0x806000
  801d6c:	ff 75 0c             	pushl  0xc(%ebp)
  801d6f:	e8 be ed ff ff       	call   800b32 <memmove>
  801d74:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d77:	89 d8                	mov    %ebx,%eax
  801d79:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d7c:	5b                   	pop    %ebx
  801d7d:	5e                   	pop    %esi
  801d7e:	5d                   	pop    %ebp
  801d7f:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d80:	68 03 2b 80 00       	push   $0x802b03
  801d85:	68 cb 2a 80 00       	push   $0x802acb
  801d8a:	6a 62                	push   $0x62
  801d8c:	68 18 2b 80 00       	push   $0x802b18
  801d91:	e8 4b 05 00 00       	call   8022e1 <_panic>

00801d96 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	53                   	push   %ebx
  801d9a:	83 ec 04             	sub    $0x4,%esp
  801d9d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801da8:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801dae:	7f 2e                	jg     801dde <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801db0:	83 ec 04             	sub    $0x4,%esp
  801db3:	53                   	push   %ebx
  801db4:	ff 75 0c             	pushl  0xc(%ebp)
  801db7:	68 0c 60 80 00       	push   $0x80600c
  801dbc:	e8 71 ed ff ff       	call   800b32 <memmove>
	nsipcbuf.send.req_size = size;
  801dc1:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801dc7:	8b 45 14             	mov    0x14(%ebp),%eax
  801dca:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801dcf:	b8 08 00 00 00       	mov    $0x8,%eax
  801dd4:	e8 eb fd ff ff       	call   801bc4 <nsipc>
}
  801dd9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ddc:	c9                   	leave  
  801ddd:	c3                   	ret    
	assert(size < 1600);
  801dde:	68 24 2b 80 00       	push   $0x802b24
  801de3:	68 cb 2a 80 00       	push   $0x802acb
  801de8:	6a 6d                	push   $0x6d
  801dea:	68 18 2b 80 00       	push   $0x802b18
  801def:	e8 ed 04 00 00       	call   8022e1 <_panic>

00801df4 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
  801df7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfd:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e05:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e0a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e0d:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e12:	b8 09 00 00 00       	mov    $0x9,%eax
  801e17:	e8 a8 fd ff ff       	call   801bc4 <nsipc>
}
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
  801e21:	56                   	push   %esi
  801e22:	53                   	push   %ebx
  801e23:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e26:	83 ec 0c             	sub    $0xc,%esp
  801e29:	ff 75 08             	pushl  0x8(%ebp)
  801e2c:	e8 6a f3 ff ff       	call   80119b <fd2data>
  801e31:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e33:	83 c4 08             	add    $0x8,%esp
  801e36:	68 30 2b 80 00       	push   $0x802b30
  801e3b:	53                   	push   %ebx
  801e3c:	e8 63 eb ff ff       	call   8009a4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e41:	8b 46 04             	mov    0x4(%esi),%eax
  801e44:	2b 06                	sub    (%esi),%eax
  801e46:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e4c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e53:	00 00 00 
	stat->st_dev = &devpipe;
  801e56:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801e5d:	30 80 00 
	return 0;
}
  801e60:	b8 00 00 00 00       	mov    $0x0,%eax
  801e65:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e68:	5b                   	pop    %ebx
  801e69:	5e                   	pop    %esi
  801e6a:	5d                   	pop    %ebp
  801e6b:	c3                   	ret    

00801e6c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
  801e6f:	53                   	push   %ebx
  801e70:	83 ec 0c             	sub    $0xc,%esp
  801e73:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e76:	53                   	push   %ebx
  801e77:	6a 00                	push   $0x0
  801e79:	e8 9d ef ff ff       	call   800e1b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e7e:	89 1c 24             	mov    %ebx,(%esp)
  801e81:	e8 15 f3 ff ff       	call   80119b <fd2data>
  801e86:	83 c4 08             	add    $0x8,%esp
  801e89:	50                   	push   %eax
  801e8a:	6a 00                	push   $0x0
  801e8c:	e8 8a ef ff ff       	call   800e1b <sys_page_unmap>
}
  801e91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e94:	c9                   	leave  
  801e95:	c3                   	ret    

00801e96 <_pipeisclosed>:
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
  801e99:	57                   	push   %edi
  801e9a:	56                   	push   %esi
  801e9b:	53                   	push   %ebx
  801e9c:	83 ec 1c             	sub    $0x1c,%esp
  801e9f:	89 c7                	mov    %eax,%edi
  801ea1:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ea3:	a1 08 40 80 00       	mov    0x804008,%eax
  801ea8:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801eab:	83 ec 0c             	sub    $0xc,%esp
  801eae:	57                   	push   %edi
  801eaf:	e8 8e 04 00 00       	call   802342 <pageref>
  801eb4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801eb7:	89 34 24             	mov    %esi,(%esp)
  801eba:	e8 83 04 00 00       	call   802342 <pageref>
		nn = thisenv->env_runs;
  801ebf:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ec5:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ec8:	83 c4 10             	add    $0x10,%esp
  801ecb:	39 cb                	cmp    %ecx,%ebx
  801ecd:	74 1b                	je     801eea <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ecf:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ed2:	75 cf                	jne    801ea3 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ed4:	8b 42 58             	mov    0x58(%edx),%eax
  801ed7:	6a 01                	push   $0x1
  801ed9:	50                   	push   %eax
  801eda:	53                   	push   %ebx
  801edb:	68 37 2b 80 00       	push   $0x802b37
  801ee0:	e8 60 e3 ff ff       	call   800245 <cprintf>
  801ee5:	83 c4 10             	add    $0x10,%esp
  801ee8:	eb b9                	jmp    801ea3 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801eea:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801eed:	0f 94 c0             	sete   %al
  801ef0:	0f b6 c0             	movzbl %al,%eax
}
  801ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ef6:	5b                   	pop    %ebx
  801ef7:	5e                   	pop    %esi
  801ef8:	5f                   	pop    %edi
  801ef9:	5d                   	pop    %ebp
  801efa:	c3                   	ret    

00801efb <devpipe_write>:
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
  801efe:	57                   	push   %edi
  801eff:	56                   	push   %esi
  801f00:	53                   	push   %ebx
  801f01:	83 ec 28             	sub    $0x28,%esp
  801f04:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f07:	56                   	push   %esi
  801f08:	e8 8e f2 ff ff       	call   80119b <fd2data>
  801f0d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f0f:	83 c4 10             	add    $0x10,%esp
  801f12:	bf 00 00 00 00       	mov    $0x0,%edi
  801f17:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f1a:	74 4f                	je     801f6b <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f1c:	8b 43 04             	mov    0x4(%ebx),%eax
  801f1f:	8b 0b                	mov    (%ebx),%ecx
  801f21:	8d 51 20             	lea    0x20(%ecx),%edx
  801f24:	39 d0                	cmp    %edx,%eax
  801f26:	72 14                	jb     801f3c <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801f28:	89 da                	mov    %ebx,%edx
  801f2a:	89 f0                	mov    %esi,%eax
  801f2c:	e8 65 ff ff ff       	call   801e96 <_pipeisclosed>
  801f31:	85 c0                	test   %eax,%eax
  801f33:	75 3b                	jne    801f70 <devpipe_write+0x75>
			sys_yield();
  801f35:	e8 3d ee ff ff       	call   800d77 <sys_yield>
  801f3a:	eb e0                	jmp    801f1c <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f3f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f43:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f46:	89 c2                	mov    %eax,%edx
  801f48:	c1 fa 1f             	sar    $0x1f,%edx
  801f4b:	89 d1                	mov    %edx,%ecx
  801f4d:	c1 e9 1b             	shr    $0x1b,%ecx
  801f50:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801f53:	83 e2 1f             	and    $0x1f,%edx
  801f56:	29 ca                	sub    %ecx,%edx
  801f58:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f5c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f60:	83 c0 01             	add    $0x1,%eax
  801f63:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f66:	83 c7 01             	add    $0x1,%edi
  801f69:	eb ac                	jmp    801f17 <devpipe_write+0x1c>
	return i;
  801f6b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f6e:	eb 05                	jmp    801f75 <devpipe_write+0x7a>
				return 0;
  801f70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f78:	5b                   	pop    %ebx
  801f79:	5e                   	pop    %esi
  801f7a:	5f                   	pop    %edi
  801f7b:	5d                   	pop    %ebp
  801f7c:	c3                   	ret    

00801f7d <devpipe_read>:
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
  801f80:	57                   	push   %edi
  801f81:	56                   	push   %esi
  801f82:	53                   	push   %ebx
  801f83:	83 ec 18             	sub    $0x18,%esp
  801f86:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f89:	57                   	push   %edi
  801f8a:	e8 0c f2 ff ff       	call   80119b <fd2data>
  801f8f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f91:	83 c4 10             	add    $0x10,%esp
  801f94:	be 00 00 00 00       	mov    $0x0,%esi
  801f99:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f9c:	75 14                	jne    801fb2 <devpipe_read+0x35>
	return i;
  801f9e:	8b 45 10             	mov    0x10(%ebp),%eax
  801fa1:	eb 02                	jmp    801fa5 <devpipe_read+0x28>
				return i;
  801fa3:	89 f0                	mov    %esi,%eax
}
  801fa5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fa8:	5b                   	pop    %ebx
  801fa9:	5e                   	pop    %esi
  801faa:	5f                   	pop    %edi
  801fab:	5d                   	pop    %ebp
  801fac:	c3                   	ret    
			sys_yield();
  801fad:	e8 c5 ed ff ff       	call   800d77 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801fb2:	8b 03                	mov    (%ebx),%eax
  801fb4:	3b 43 04             	cmp    0x4(%ebx),%eax
  801fb7:	75 18                	jne    801fd1 <devpipe_read+0x54>
			if (i > 0)
  801fb9:	85 f6                	test   %esi,%esi
  801fbb:	75 e6                	jne    801fa3 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801fbd:	89 da                	mov    %ebx,%edx
  801fbf:	89 f8                	mov    %edi,%eax
  801fc1:	e8 d0 fe ff ff       	call   801e96 <_pipeisclosed>
  801fc6:	85 c0                	test   %eax,%eax
  801fc8:	74 e3                	je     801fad <devpipe_read+0x30>
				return 0;
  801fca:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcf:	eb d4                	jmp    801fa5 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801fd1:	99                   	cltd   
  801fd2:	c1 ea 1b             	shr    $0x1b,%edx
  801fd5:	01 d0                	add    %edx,%eax
  801fd7:	83 e0 1f             	and    $0x1f,%eax
  801fda:	29 d0                	sub    %edx,%eax
  801fdc:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801fe1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fe4:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801fe7:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801fea:	83 c6 01             	add    $0x1,%esi
  801fed:	eb aa                	jmp    801f99 <devpipe_read+0x1c>

00801fef <pipe>:
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
  801ff2:	56                   	push   %esi
  801ff3:	53                   	push   %ebx
  801ff4:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ff7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ffa:	50                   	push   %eax
  801ffb:	e8 b2 f1 ff ff       	call   8011b2 <fd_alloc>
  802000:	89 c3                	mov    %eax,%ebx
  802002:	83 c4 10             	add    $0x10,%esp
  802005:	85 c0                	test   %eax,%eax
  802007:	0f 88 23 01 00 00    	js     802130 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80200d:	83 ec 04             	sub    $0x4,%esp
  802010:	68 07 04 00 00       	push   $0x407
  802015:	ff 75 f4             	pushl  -0xc(%ebp)
  802018:	6a 00                	push   $0x0
  80201a:	e8 77 ed ff ff       	call   800d96 <sys_page_alloc>
  80201f:	89 c3                	mov    %eax,%ebx
  802021:	83 c4 10             	add    $0x10,%esp
  802024:	85 c0                	test   %eax,%eax
  802026:	0f 88 04 01 00 00    	js     802130 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80202c:	83 ec 0c             	sub    $0xc,%esp
  80202f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802032:	50                   	push   %eax
  802033:	e8 7a f1 ff ff       	call   8011b2 <fd_alloc>
  802038:	89 c3                	mov    %eax,%ebx
  80203a:	83 c4 10             	add    $0x10,%esp
  80203d:	85 c0                	test   %eax,%eax
  80203f:	0f 88 db 00 00 00    	js     802120 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802045:	83 ec 04             	sub    $0x4,%esp
  802048:	68 07 04 00 00       	push   $0x407
  80204d:	ff 75 f0             	pushl  -0x10(%ebp)
  802050:	6a 00                	push   $0x0
  802052:	e8 3f ed ff ff       	call   800d96 <sys_page_alloc>
  802057:	89 c3                	mov    %eax,%ebx
  802059:	83 c4 10             	add    $0x10,%esp
  80205c:	85 c0                	test   %eax,%eax
  80205e:	0f 88 bc 00 00 00    	js     802120 <pipe+0x131>
	va = fd2data(fd0);
  802064:	83 ec 0c             	sub    $0xc,%esp
  802067:	ff 75 f4             	pushl  -0xc(%ebp)
  80206a:	e8 2c f1 ff ff       	call   80119b <fd2data>
  80206f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802071:	83 c4 0c             	add    $0xc,%esp
  802074:	68 07 04 00 00       	push   $0x407
  802079:	50                   	push   %eax
  80207a:	6a 00                	push   $0x0
  80207c:	e8 15 ed ff ff       	call   800d96 <sys_page_alloc>
  802081:	89 c3                	mov    %eax,%ebx
  802083:	83 c4 10             	add    $0x10,%esp
  802086:	85 c0                	test   %eax,%eax
  802088:	0f 88 82 00 00 00    	js     802110 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80208e:	83 ec 0c             	sub    $0xc,%esp
  802091:	ff 75 f0             	pushl  -0x10(%ebp)
  802094:	e8 02 f1 ff ff       	call   80119b <fd2data>
  802099:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8020a0:	50                   	push   %eax
  8020a1:	6a 00                	push   $0x0
  8020a3:	56                   	push   %esi
  8020a4:	6a 00                	push   $0x0
  8020a6:	e8 2e ed ff ff       	call   800dd9 <sys_page_map>
  8020ab:	89 c3                	mov    %eax,%ebx
  8020ad:	83 c4 20             	add    $0x20,%esp
  8020b0:	85 c0                	test   %eax,%eax
  8020b2:	78 4e                	js     802102 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8020b4:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8020b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020bc:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8020be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c1:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8020c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020cb:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8020cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8020d7:	83 ec 0c             	sub    $0xc,%esp
  8020da:	ff 75 f4             	pushl  -0xc(%ebp)
  8020dd:	e8 a9 f0 ff ff       	call   80118b <fd2num>
  8020e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020e5:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8020e7:	83 c4 04             	add    $0x4,%esp
  8020ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8020ed:	e8 99 f0 ff ff       	call   80118b <fd2num>
  8020f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020f5:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8020f8:	83 c4 10             	add    $0x10,%esp
  8020fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  802100:	eb 2e                	jmp    802130 <pipe+0x141>
	sys_page_unmap(0, va);
  802102:	83 ec 08             	sub    $0x8,%esp
  802105:	56                   	push   %esi
  802106:	6a 00                	push   $0x0
  802108:	e8 0e ed ff ff       	call   800e1b <sys_page_unmap>
  80210d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802110:	83 ec 08             	sub    $0x8,%esp
  802113:	ff 75 f0             	pushl  -0x10(%ebp)
  802116:	6a 00                	push   $0x0
  802118:	e8 fe ec ff ff       	call   800e1b <sys_page_unmap>
  80211d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802120:	83 ec 08             	sub    $0x8,%esp
  802123:	ff 75 f4             	pushl  -0xc(%ebp)
  802126:	6a 00                	push   $0x0
  802128:	e8 ee ec ff ff       	call   800e1b <sys_page_unmap>
  80212d:	83 c4 10             	add    $0x10,%esp
}
  802130:	89 d8                	mov    %ebx,%eax
  802132:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802135:	5b                   	pop    %ebx
  802136:	5e                   	pop    %esi
  802137:	5d                   	pop    %ebp
  802138:	c3                   	ret    

00802139 <pipeisclosed>:
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
  80213c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80213f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802142:	50                   	push   %eax
  802143:	ff 75 08             	pushl  0x8(%ebp)
  802146:	e8 b9 f0 ff ff       	call   801204 <fd_lookup>
  80214b:	83 c4 10             	add    $0x10,%esp
  80214e:	85 c0                	test   %eax,%eax
  802150:	78 18                	js     80216a <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802152:	83 ec 0c             	sub    $0xc,%esp
  802155:	ff 75 f4             	pushl  -0xc(%ebp)
  802158:	e8 3e f0 ff ff       	call   80119b <fd2data>
	return _pipeisclosed(fd, p);
  80215d:	89 c2                	mov    %eax,%edx
  80215f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802162:	e8 2f fd ff ff       	call   801e96 <_pipeisclosed>
  802167:	83 c4 10             	add    $0x10,%esp
}
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    

0080216c <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80216c:	b8 00 00 00 00       	mov    $0x0,%eax
  802171:	c3                   	ret    

00802172 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
  802175:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802178:	68 4f 2b 80 00       	push   $0x802b4f
  80217d:	ff 75 0c             	pushl  0xc(%ebp)
  802180:	e8 1f e8 ff ff       	call   8009a4 <strcpy>
	return 0;
}
  802185:	b8 00 00 00 00       	mov    $0x0,%eax
  80218a:	c9                   	leave  
  80218b:	c3                   	ret    

0080218c <devcons_write>:
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
  80218f:	57                   	push   %edi
  802190:	56                   	push   %esi
  802191:	53                   	push   %ebx
  802192:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802198:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80219d:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8021a3:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021a6:	73 31                	jae    8021d9 <devcons_write+0x4d>
		m = n - tot;
  8021a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8021ab:	29 f3                	sub    %esi,%ebx
  8021ad:	83 fb 7f             	cmp    $0x7f,%ebx
  8021b0:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8021b5:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8021b8:	83 ec 04             	sub    $0x4,%esp
  8021bb:	53                   	push   %ebx
  8021bc:	89 f0                	mov    %esi,%eax
  8021be:	03 45 0c             	add    0xc(%ebp),%eax
  8021c1:	50                   	push   %eax
  8021c2:	57                   	push   %edi
  8021c3:	e8 6a e9 ff ff       	call   800b32 <memmove>
		sys_cputs(buf, m);
  8021c8:	83 c4 08             	add    $0x8,%esp
  8021cb:	53                   	push   %ebx
  8021cc:	57                   	push   %edi
  8021cd:	e8 08 eb ff ff       	call   800cda <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8021d2:	01 de                	add    %ebx,%esi
  8021d4:	83 c4 10             	add    $0x10,%esp
  8021d7:	eb ca                	jmp    8021a3 <devcons_write+0x17>
}
  8021d9:	89 f0                	mov    %esi,%eax
  8021db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021de:	5b                   	pop    %ebx
  8021df:	5e                   	pop    %esi
  8021e0:	5f                   	pop    %edi
  8021e1:	5d                   	pop    %ebp
  8021e2:	c3                   	ret    

008021e3 <devcons_read>:
{
  8021e3:	55                   	push   %ebp
  8021e4:	89 e5                	mov    %esp,%ebp
  8021e6:	83 ec 08             	sub    $0x8,%esp
  8021e9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8021ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021f2:	74 21                	je     802215 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8021f4:	e8 ff ea ff ff       	call   800cf8 <sys_cgetc>
  8021f9:	85 c0                	test   %eax,%eax
  8021fb:	75 07                	jne    802204 <devcons_read+0x21>
		sys_yield();
  8021fd:	e8 75 eb ff ff       	call   800d77 <sys_yield>
  802202:	eb f0                	jmp    8021f4 <devcons_read+0x11>
	if (c < 0)
  802204:	78 0f                	js     802215 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802206:	83 f8 04             	cmp    $0x4,%eax
  802209:	74 0c                	je     802217 <devcons_read+0x34>
	*(char*)vbuf = c;
  80220b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80220e:	88 02                	mov    %al,(%edx)
	return 1;
  802210:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802215:	c9                   	leave  
  802216:	c3                   	ret    
		return 0;
  802217:	b8 00 00 00 00       	mov    $0x0,%eax
  80221c:	eb f7                	jmp    802215 <devcons_read+0x32>

0080221e <cputchar>:
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
  802221:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802224:	8b 45 08             	mov    0x8(%ebp),%eax
  802227:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80222a:	6a 01                	push   $0x1
  80222c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80222f:	50                   	push   %eax
  802230:	e8 a5 ea ff ff       	call   800cda <sys_cputs>
}
  802235:	83 c4 10             	add    $0x10,%esp
  802238:	c9                   	leave  
  802239:	c3                   	ret    

0080223a <getchar>:
{
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
  80223d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802240:	6a 01                	push   $0x1
  802242:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802245:	50                   	push   %eax
  802246:	6a 00                	push   $0x0
  802248:	e8 27 f2 ff ff       	call   801474 <read>
	if (r < 0)
  80224d:	83 c4 10             	add    $0x10,%esp
  802250:	85 c0                	test   %eax,%eax
  802252:	78 06                	js     80225a <getchar+0x20>
	if (r < 1)
  802254:	74 06                	je     80225c <getchar+0x22>
	return c;
  802256:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80225a:	c9                   	leave  
  80225b:	c3                   	ret    
		return -E_EOF;
  80225c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802261:	eb f7                	jmp    80225a <getchar+0x20>

00802263 <iscons>:
{
  802263:	55                   	push   %ebp
  802264:	89 e5                	mov    %esp,%ebp
  802266:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802269:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80226c:	50                   	push   %eax
  80226d:	ff 75 08             	pushl  0x8(%ebp)
  802270:	e8 8f ef ff ff       	call   801204 <fd_lookup>
  802275:	83 c4 10             	add    $0x10,%esp
  802278:	85 c0                	test   %eax,%eax
  80227a:	78 11                	js     80228d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80227c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227f:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802285:	39 10                	cmp    %edx,(%eax)
  802287:	0f 94 c0             	sete   %al
  80228a:	0f b6 c0             	movzbl %al,%eax
}
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    

0080228f <opencons>:
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
  802292:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802295:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802298:	50                   	push   %eax
  802299:	e8 14 ef ff ff       	call   8011b2 <fd_alloc>
  80229e:	83 c4 10             	add    $0x10,%esp
  8022a1:	85 c0                	test   %eax,%eax
  8022a3:	78 3a                	js     8022df <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022a5:	83 ec 04             	sub    $0x4,%esp
  8022a8:	68 07 04 00 00       	push   $0x407
  8022ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8022b0:	6a 00                	push   $0x0
  8022b2:	e8 df ea ff ff       	call   800d96 <sys_page_alloc>
  8022b7:	83 c4 10             	add    $0x10,%esp
  8022ba:	85 c0                	test   %eax,%eax
  8022bc:	78 21                	js     8022df <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8022be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c1:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022c7:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022d3:	83 ec 0c             	sub    $0xc,%esp
  8022d6:	50                   	push   %eax
  8022d7:	e8 af ee ff ff       	call   80118b <fd2num>
  8022dc:	83 c4 10             	add    $0x10,%esp
}
  8022df:	c9                   	leave  
  8022e0:	c3                   	ret    

008022e1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8022e1:	55                   	push   %ebp
  8022e2:	89 e5                	mov    %esp,%ebp
  8022e4:	56                   	push   %esi
  8022e5:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8022e6:	a1 08 40 80 00       	mov    0x804008,%eax
  8022eb:	8b 40 48             	mov    0x48(%eax),%eax
  8022ee:	83 ec 04             	sub    $0x4,%esp
  8022f1:	68 80 2b 80 00       	push   $0x802b80
  8022f6:	50                   	push   %eax
  8022f7:	68 60 26 80 00       	push   $0x802660
  8022fc:	e8 44 df ff ff       	call   800245 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802301:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802304:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80230a:	e8 49 ea ff ff       	call   800d58 <sys_getenvid>
  80230f:	83 c4 04             	add    $0x4,%esp
  802312:	ff 75 0c             	pushl  0xc(%ebp)
  802315:	ff 75 08             	pushl  0x8(%ebp)
  802318:	56                   	push   %esi
  802319:	50                   	push   %eax
  80231a:	68 5c 2b 80 00       	push   $0x802b5c
  80231f:	e8 21 df ff ff       	call   800245 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802324:	83 c4 18             	add    $0x18,%esp
  802327:	53                   	push   %ebx
  802328:	ff 75 10             	pushl  0x10(%ebp)
  80232b:	e8 c4 de ff ff       	call   8001f4 <vcprintf>
	cprintf("\n");
  802330:	c7 04 24 24 26 80 00 	movl   $0x802624,(%esp)
  802337:	e8 09 df ff ff       	call   800245 <cprintf>
  80233c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80233f:	cc                   	int3   
  802340:	eb fd                	jmp    80233f <_panic+0x5e>

00802342 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802342:	55                   	push   %ebp
  802343:	89 e5                	mov    %esp,%ebp
  802345:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802348:	89 d0                	mov    %edx,%eax
  80234a:	c1 e8 16             	shr    $0x16,%eax
  80234d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802354:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802359:	f6 c1 01             	test   $0x1,%cl
  80235c:	74 1d                	je     80237b <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80235e:	c1 ea 0c             	shr    $0xc,%edx
  802361:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802368:	f6 c2 01             	test   $0x1,%dl
  80236b:	74 0e                	je     80237b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80236d:	c1 ea 0c             	shr    $0xc,%edx
  802370:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802377:	ef 
  802378:	0f b7 c0             	movzwl %ax,%eax
}
  80237b:	5d                   	pop    %ebp
  80237c:	c3                   	ret    
  80237d:	66 90                	xchg   %ax,%ax
  80237f:	90                   	nop

00802380 <__udivdi3>:
  802380:	55                   	push   %ebp
  802381:	57                   	push   %edi
  802382:	56                   	push   %esi
  802383:	53                   	push   %ebx
  802384:	83 ec 1c             	sub    $0x1c,%esp
  802387:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80238b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80238f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802393:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802397:	85 d2                	test   %edx,%edx
  802399:	75 4d                	jne    8023e8 <__udivdi3+0x68>
  80239b:	39 f3                	cmp    %esi,%ebx
  80239d:	76 19                	jbe    8023b8 <__udivdi3+0x38>
  80239f:	31 ff                	xor    %edi,%edi
  8023a1:	89 e8                	mov    %ebp,%eax
  8023a3:	89 f2                	mov    %esi,%edx
  8023a5:	f7 f3                	div    %ebx
  8023a7:	89 fa                	mov    %edi,%edx
  8023a9:	83 c4 1c             	add    $0x1c,%esp
  8023ac:	5b                   	pop    %ebx
  8023ad:	5e                   	pop    %esi
  8023ae:	5f                   	pop    %edi
  8023af:	5d                   	pop    %ebp
  8023b0:	c3                   	ret    
  8023b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023b8:	89 d9                	mov    %ebx,%ecx
  8023ba:	85 db                	test   %ebx,%ebx
  8023bc:	75 0b                	jne    8023c9 <__udivdi3+0x49>
  8023be:	b8 01 00 00 00       	mov    $0x1,%eax
  8023c3:	31 d2                	xor    %edx,%edx
  8023c5:	f7 f3                	div    %ebx
  8023c7:	89 c1                	mov    %eax,%ecx
  8023c9:	31 d2                	xor    %edx,%edx
  8023cb:	89 f0                	mov    %esi,%eax
  8023cd:	f7 f1                	div    %ecx
  8023cf:	89 c6                	mov    %eax,%esi
  8023d1:	89 e8                	mov    %ebp,%eax
  8023d3:	89 f7                	mov    %esi,%edi
  8023d5:	f7 f1                	div    %ecx
  8023d7:	89 fa                	mov    %edi,%edx
  8023d9:	83 c4 1c             	add    $0x1c,%esp
  8023dc:	5b                   	pop    %ebx
  8023dd:	5e                   	pop    %esi
  8023de:	5f                   	pop    %edi
  8023df:	5d                   	pop    %ebp
  8023e0:	c3                   	ret    
  8023e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023e8:	39 f2                	cmp    %esi,%edx
  8023ea:	77 1c                	ja     802408 <__udivdi3+0x88>
  8023ec:	0f bd fa             	bsr    %edx,%edi
  8023ef:	83 f7 1f             	xor    $0x1f,%edi
  8023f2:	75 2c                	jne    802420 <__udivdi3+0xa0>
  8023f4:	39 f2                	cmp    %esi,%edx
  8023f6:	72 06                	jb     8023fe <__udivdi3+0x7e>
  8023f8:	31 c0                	xor    %eax,%eax
  8023fa:	39 eb                	cmp    %ebp,%ebx
  8023fc:	77 a9                	ja     8023a7 <__udivdi3+0x27>
  8023fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802403:	eb a2                	jmp    8023a7 <__udivdi3+0x27>
  802405:	8d 76 00             	lea    0x0(%esi),%esi
  802408:	31 ff                	xor    %edi,%edi
  80240a:	31 c0                	xor    %eax,%eax
  80240c:	89 fa                	mov    %edi,%edx
  80240e:	83 c4 1c             	add    $0x1c,%esp
  802411:	5b                   	pop    %ebx
  802412:	5e                   	pop    %esi
  802413:	5f                   	pop    %edi
  802414:	5d                   	pop    %ebp
  802415:	c3                   	ret    
  802416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80241d:	8d 76 00             	lea    0x0(%esi),%esi
  802420:	89 f9                	mov    %edi,%ecx
  802422:	b8 20 00 00 00       	mov    $0x20,%eax
  802427:	29 f8                	sub    %edi,%eax
  802429:	d3 e2                	shl    %cl,%edx
  80242b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80242f:	89 c1                	mov    %eax,%ecx
  802431:	89 da                	mov    %ebx,%edx
  802433:	d3 ea                	shr    %cl,%edx
  802435:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802439:	09 d1                	or     %edx,%ecx
  80243b:	89 f2                	mov    %esi,%edx
  80243d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802441:	89 f9                	mov    %edi,%ecx
  802443:	d3 e3                	shl    %cl,%ebx
  802445:	89 c1                	mov    %eax,%ecx
  802447:	d3 ea                	shr    %cl,%edx
  802449:	89 f9                	mov    %edi,%ecx
  80244b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80244f:	89 eb                	mov    %ebp,%ebx
  802451:	d3 e6                	shl    %cl,%esi
  802453:	89 c1                	mov    %eax,%ecx
  802455:	d3 eb                	shr    %cl,%ebx
  802457:	09 de                	or     %ebx,%esi
  802459:	89 f0                	mov    %esi,%eax
  80245b:	f7 74 24 08          	divl   0x8(%esp)
  80245f:	89 d6                	mov    %edx,%esi
  802461:	89 c3                	mov    %eax,%ebx
  802463:	f7 64 24 0c          	mull   0xc(%esp)
  802467:	39 d6                	cmp    %edx,%esi
  802469:	72 15                	jb     802480 <__udivdi3+0x100>
  80246b:	89 f9                	mov    %edi,%ecx
  80246d:	d3 e5                	shl    %cl,%ebp
  80246f:	39 c5                	cmp    %eax,%ebp
  802471:	73 04                	jae    802477 <__udivdi3+0xf7>
  802473:	39 d6                	cmp    %edx,%esi
  802475:	74 09                	je     802480 <__udivdi3+0x100>
  802477:	89 d8                	mov    %ebx,%eax
  802479:	31 ff                	xor    %edi,%edi
  80247b:	e9 27 ff ff ff       	jmp    8023a7 <__udivdi3+0x27>
  802480:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802483:	31 ff                	xor    %edi,%edi
  802485:	e9 1d ff ff ff       	jmp    8023a7 <__udivdi3+0x27>
  80248a:	66 90                	xchg   %ax,%ax
  80248c:	66 90                	xchg   %ax,%ax
  80248e:	66 90                	xchg   %ax,%ax

00802490 <__umoddi3>:
  802490:	55                   	push   %ebp
  802491:	57                   	push   %edi
  802492:	56                   	push   %esi
  802493:	53                   	push   %ebx
  802494:	83 ec 1c             	sub    $0x1c,%esp
  802497:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80249b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80249f:	8b 74 24 30          	mov    0x30(%esp),%esi
  8024a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024a7:	89 da                	mov    %ebx,%edx
  8024a9:	85 c0                	test   %eax,%eax
  8024ab:	75 43                	jne    8024f0 <__umoddi3+0x60>
  8024ad:	39 df                	cmp    %ebx,%edi
  8024af:	76 17                	jbe    8024c8 <__umoddi3+0x38>
  8024b1:	89 f0                	mov    %esi,%eax
  8024b3:	f7 f7                	div    %edi
  8024b5:	89 d0                	mov    %edx,%eax
  8024b7:	31 d2                	xor    %edx,%edx
  8024b9:	83 c4 1c             	add    $0x1c,%esp
  8024bc:	5b                   	pop    %ebx
  8024bd:	5e                   	pop    %esi
  8024be:	5f                   	pop    %edi
  8024bf:	5d                   	pop    %ebp
  8024c0:	c3                   	ret    
  8024c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024c8:	89 fd                	mov    %edi,%ebp
  8024ca:	85 ff                	test   %edi,%edi
  8024cc:	75 0b                	jne    8024d9 <__umoddi3+0x49>
  8024ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8024d3:	31 d2                	xor    %edx,%edx
  8024d5:	f7 f7                	div    %edi
  8024d7:	89 c5                	mov    %eax,%ebp
  8024d9:	89 d8                	mov    %ebx,%eax
  8024db:	31 d2                	xor    %edx,%edx
  8024dd:	f7 f5                	div    %ebp
  8024df:	89 f0                	mov    %esi,%eax
  8024e1:	f7 f5                	div    %ebp
  8024e3:	89 d0                	mov    %edx,%eax
  8024e5:	eb d0                	jmp    8024b7 <__umoddi3+0x27>
  8024e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024ee:	66 90                	xchg   %ax,%ax
  8024f0:	89 f1                	mov    %esi,%ecx
  8024f2:	39 d8                	cmp    %ebx,%eax
  8024f4:	76 0a                	jbe    802500 <__umoddi3+0x70>
  8024f6:	89 f0                	mov    %esi,%eax
  8024f8:	83 c4 1c             	add    $0x1c,%esp
  8024fb:	5b                   	pop    %ebx
  8024fc:	5e                   	pop    %esi
  8024fd:	5f                   	pop    %edi
  8024fe:	5d                   	pop    %ebp
  8024ff:	c3                   	ret    
  802500:	0f bd e8             	bsr    %eax,%ebp
  802503:	83 f5 1f             	xor    $0x1f,%ebp
  802506:	75 20                	jne    802528 <__umoddi3+0x98>
  802508:	39 d8                	cmp    %ebx,%eax
  80250a:	0f 82 b0 00 00 00    	jb     8025c0 <__umoddi3+0x130>
  802510:	39 f7                	cmp    %esi,%edi
  802512:	0f 86 a8 00 00 00    	jbe    8025c0 <__umoddi3+0x130>
  802518:	89 c8                	mov    %ecx,%eax
  80251a:	83 c4 1c             	add    $0x1c,%esp
  80251d:	5b                   	pop    %ebx
  80251e:	5e                   	pop    %esi
  80251f:	5f                   	pop    %edi
  802520:	5d                   	pop    %ebp
  802521:	c3                   	ret    
  802522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802528:	89 e9                	mov    %ebp,%ecx
  80252a:	ba 20 00 00 00       	mov    $0x20,%edx
  80252f:	29 ea                	sub    %ebp,%edx
  802531:	d3 e0                	shl    %cl,%eax
  802533:	89 44 24 08          	mov    %eax,0x8(%esp)
  802537:	89 d1                	mov    %edx,%ecx
  802539:	89 f8                	mov    %edi,%eax
  80253b:	d3 e8                	shr    %cl,%eax
  80253d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802541:	89 54 24 04          	mov    %edx,0x4(%esp)
  802545:	8b 54 24 04          	mov    0x4(%esp),%edx
  802549:	09 c1                	or     %eax,%ecx
  80254b:	89 d8                	mov    %ebx,%eax
  80254d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802551:	89 e9                	mov    %ebp,%ecx
  802553:	d3 e7                	shl    %cl,%edi
  802555:	89 d1                	mov    %edx,%ecx
  802557:	d3 e8                	shr    %cl,%eax
  802559:	89 e9                	mov    %ebp,%ecx
  80255b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80255f:	d3 e3                	shl    %cl,%ebx
  802561:	89 c7                	mov    %eax,%edi
  802563:	89 d1                	mov    %edx,%ecx
  802565:	89 f0                	mov    %esi,%eax
  802567:	d3 e8                	shr    %cl,%eax
  802569:	89 e9                	mov    %ebp,%ecx
  80256b:	89 fa                	mov    %edi,%edx
  80256d:	d3 e6                	shl    %cl,%esi
  80256f:	09 d8                	or     %ebx,%eax
  802571:	f7 74 24 08          	divl   0x8(%esp)
  802575:	89 d1                	mov    %edx,%ecx
  802577:	89 f3                	mov    %esi,%ebx
  802579:	f7 64 24 0c          	mull   0xc(%esp)
  80257d:	89 c6                	mov    %eax,%esi
  80257f:	89 d7                	mov    %edx,%edi
  802581:	39 d1                	cmp    %edx,%ecx
  802583:	72 06                	jb     80258b <__umoddi3+0xfb>
  802585:	75 10                	jne    802597 <__umoddi3+0x107>
  802587:	39 c3                	cmp    %eax,%ebx
  802589:	73 0c                	jae    802597 <__umoddi3+0x107>
  80258b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80258f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802593:	89 d7                	mov    %edx,%edi
  802595:	89 c6                	mov    %eax,%esi
  802597:	89 ca                	mov    %ecx,%edx
  802599:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80259e:	29 f3                	sub    %esi,%ebx
  8025a0:	19 fa                	sbb    %edi,%edx
  8025a2:	89 d0                	mov    %edx,%eax
  8025a4:	d3 e0                	shl    %cl,%eax
  8025a6:	89 e9                	mov    %ebp,%ecx
  8025a8:	d3 eb                	shr    %cl,%ebx
  8025aa:	d3 ea                	shr    %cl,%edx
  8025ac:	09 d8                	or     %ebx,%eax
  8025ae:	83 c4 1c             	add    $0x1c,%esp
  8025b1:	5b                   	pop    %ebx
  8025b2:	5e                   	pop    %esi
  8025b3:	5f                   	pop    %edi
  8025b4:	5d                   	pop    %ebp
  8025b5:	c3                   	ret    
  8025b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025bd:	8d 76 00             	lea    0x0(%esi),%esi
  8025c0:	89 da                	mov    %ebx,%edx
  8025c2:	29 fe                	sub    %edi,%esi
  8025c4:	19 c2                	sbb    %eax,%edx
  8025c6:	89 f1                	mov    %esi,%ecx
  8025c8:	89 c8                	mov    %ecx,%eax
  8025ca:	e9 4b ff ff ff       	jmp    80251a <__umoddi3+0x8a>
