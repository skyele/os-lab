
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
  80003b:	e8 16 0d 00 00       	call   800d56 <sys_getenvid>
  800040:	89 c3                	mov    %eax,%ebx

	if (thisenv == &envs[1]) {
  800042:	81 3d 08 40 80 00 80 	cmpl   $0xeec00080,0x804008
  800049:	00 c0 ee 
  80004c:	74 2d                	je     80007b <umain+0x48>
		while (1) {
			ipc_recv(&who, 0, 0);
			cprintf("%x recv from %x\n", id, who);
		}
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  80004e:	a1 c8 00 c0 ee       	mov    0xeec000c8,%eax
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	50                   	push   %eax
  800057:	53                   	push   %ebx
  800058:	68 f1 25 80 00       	push   $0x8025f1
  80005d:	e8 e1 01 00 00       	call   800243 <cprintf>
  800062:	83 c4 10             	add    $0x10,%esp
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  800065:	a1 c8 00 c0 ee       	mov    0xeec000c8,%eax
  80006a:	6a 00                	push   $0x0
  80006c:	6a 00                	push   $0x0
  80006e:	6a 00                	push   $0x0
  800070:	50                   	push   %eax
  800071:	e8 7c 10 00 00       	call   8010f2 <ipc_send>
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	eb ea                	jmp    800065 <umain+0x32>
			ipc_recv(&who, 0, 0);
  80007b:	8d 75 f4             	lea    -0xc(%ebp),%esi
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	6a 00                	push   $0x0
  800083:	6a 00                	push   $0x0
  800085:	56                   	push   %esi
  800086:	e8 fe 0f 00 00       	call   801089 <ipc_recv>
			cprintf("%x recv from %x\n", id, who);
  80008b:	83 c4 0c             	add    $0xc,%esp
  80008e:	ff 75 f4             	pushl  -0xc(%ebp)
  800091:	53                   	push   %ebx
  800092:	68 e0 25 80 00       	push   $0x8025e0
  800097:	e8 a7 01 00 00       	call   800243 <cprintf>
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
  8000b4:	e8 9d 0c 00 00       	call   800d56 <sys_getenvid>
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
  8000d9:	74 21                	je     8000fc <libmain+0x5b>
		if(envs[i].env_id == find)
  8000db:	89 d1                	mov    %edx,%ecx
  8000dd:	c1 e1 07             	shl    $0x7,%ecx
  8000e0:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000e6:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000e9:	39 c1                	cmp    %eax,%ecx
  8000eb:	75 e3                	jne    8000d0 <libmain+0x2f>
  8000ed:	89 d3                	mov    %edx,%ebx
  8000ef:	c1 e3 07             	shl    $0x7,%ebx
  8000f2:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000f8:	89 fe                	mov    %edi,%esi
  8000fa:	eb d4                	jmp    8000d0 <libmain+0x2f>
  8000fc:	89 f0                	mov    %esi,%eax
  8000fe:	84 c0                	test   %al,%al
  800100:	74 06                	je     800108 <libmain+0x67>
  800102:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800108:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80010c:	7e 0a                	jle    800118 <libmain+0x77>
		binaryname = argv[0];
  80010e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800111:	8b 00                	mov    (%eax),%eax
  800113:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800118:	a1 08 40 80 00       	mov    0x804008,%eax
  80011d:	8b 40 48             	mov    0x48(%eax),%eax
  800120:	83 ec 08             	sub    $0x8,%esp
  800123:	50                   	push   %eax
  800124:	68 08 26 80 00       	push   $0x802608
  800129:	e8 15 01 00 00       	call   800243 <cprintf>
	cprintf("before umain\n");
  80012e:	c7 04 24 26 26 80 00 	movl   $0x802626,(%esp)
  800135:	e8 09 01 00 00       	call   800243 <cprintf>
	// call user main routine
	umain(argc, argv);
  80013a:	83 c4 08             	add    $0x8,%esp
  80013d:	ff 75 0c             	pushl  0xc(%ebp)
  800140:	ff 75 08             	pushl  0x8(%ebp)
  800143:	e8 eb fe ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800148:	c7 04 24 34 26 80 00 	movl   $0x802634,(%esp)
  80014f:	e8 ef 00 00 00       	call   800243 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800154:	a1 08 40 80 00       	mov    0x804008,%eax
  800159:	8b 40 48             	mov    0x48(%eax),%eax
  80015c:	83 c4 08             	add    $0x8,%esp
  80015f:	50                   	push   %eax
  800160:	68 41 26 80 00       	push   $0x802641
  800165:	e8 d9 00 00 00       	call   800243 <cprintf>
	// exit gracefully
	exit();
  80016a:	e8 0b 00 00 00       	call   80017a <exit>
}
  80016f:	83 c4 10             	add    $0x10,%esp
  800172:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800175:	5b                   	pop    %ebx
  800176:	5e                   	pop    %esi
  800177:	5f                   	pop    %edi
  800178:	5d                   	pop    %ebp
  800179:	c3                   	ret    

0080017a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800180:	a1 08 40 80 00       	mov    0x804008,%eax
  800185:	8b 40 48             	mov    0x48(%eax),%eax
  800188:	68 6c 26 80 00       	push   $0x80266c
  80018d:	50                   	push   %eax
  80018e:	68 60 26 80 00       	push   $0x802660
  800193:	e8 ab 00 00 00       	call   800243 <cprintf>
	close_all();
  800198:	e8 c0 11 00 00       	call   80135d <close_all>
	sys_env_destroy(0);
  80019d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001a4:	e8 6c 0b 00 00       	call   800d15 <sys_env_destroy>
}
  8001a9:	83 c4 10             	add    $0x10,%esp
  8001ac:	c9                   	leave  
  8001ad:	c3                   	ret    

008001ae <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001ae:	55                   	push   %ebp
  8001af:	89 e5                	mov    %esp,%ebp
  8001b1:	53                   	push   %ebx
  8001b2:	83 ec 04             	sub    $0x4,%esp
  8001b5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001b8:	8b 13                	mov    (%ebx),%edx
  8001ba:	8d 42 01             	lea    0x1(%edx),%eax
  8001bd:	89 03                	mov    %eax,(%ebx)
  8001bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001c2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001c6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001cb:	74 09                	je     8001d6 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001cd:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001d4:	c9                   	leave  
  8001d5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001d6:	83 ec 08             	sub    $0x8,%esp
  8001d9:	68 ff 00 00 00       	push   $0xff
  8001de:	8d 43 08             	lea    0x8(%ebx),%eax
  8001e1:	50                   	push   %eax
  8001e2:	e8 f1 0a 00 00       	call   800cd8 <sys_cputs>
		b->idx = 0;
  8001e7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001ed:	83 c4 10             	add    $0x10,%esp
  8001f0:	eb db                	jmp    8001cd <putch+0x1f>

008001f2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001f2:	55                   	push   %ebp
  8001f3:	89 e5                	mov    %esp,%ebp
  8001f5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001fb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800202:	00 00 00 
	b.cnt = 0;
  800205:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80020c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80020f:	ff 75 0c             	pushl  0xc(%ebp)
  800212:	ff 75 08             	pushl  0x8(%ebp)
  800215:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80021b:	50                   	push   %eax
  80021c:	68 ae 01 80 00       	push   $0x8001ae
  800221:	e8 4a 01 00 00       	call   800370 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800226:	83 c4 08             	add    $0x8,%esp
  800229:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80022f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800235:	50                   	push   %eax
  800236:	e8 9d 0a 00 00       	call   800cd8 <sys_cputs>

	return b.cnt;
}
  80023b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800241:	c9                   	leave  
  800242:	c3                   	ret    

00800243 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800243:	55                   	push   %ebp
  800244:	89 e5                	mov    %esp,%ebp
  800246:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800249:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80024c:	50                   	push   %eax
  80024d:	ff 75 08             	pushl  0x8(%ebp)
  800250:	e8 9d ff ff ff       	call   8001f2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800255:	c9                   	leave  
  800256:	c3                   	ret    

00800257 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	57                   	push   %edi
  80025b:	56                   	push   %esi
  80025c:	53                   	push   %ebx
  80025d:	83 ec 1c             	sub    $0x1c,%esp
  800260:	89 c6                	mov    %eax,%esi
  800262:	89 d7                	mov    %edx,%edi
  800264:	8b 45 08             	mov    0x8(%ebp),%eax
  800267:	8b 55 0c             	mov    0xc(%ebp),%edx
  80026a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80026d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800270:	8b 45 10             	mov    0x10(%ebp),%eax
  800273:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800276:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80027a:	74 2c                	je     8002a8 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80027c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80027f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800286:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800289:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80028c:	39 c2                	cmp    %eax,%edx
  80028e:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800291:	73 43                	jae    8002d6 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800293:	83 eb 01             	sub    $0x1,%ebx
  800296:	85 db                	test   %ebx,%ebx
  800298:	7e 6c                	jle    800306 <printnum+0xaf>
				putch(padc, putdat);
  80029a:	83 ec 08             	sub    $0x8,%esp
  80029d:	57                   	push   %edi
  80029e:	ff 75 18             	pushl  0x18(%ebp)
  8002a1:	ff d6                	call   *%esi
  8002a3:	83 c4 10             	add    $0x10,%esp
  8002a6:	eb eb                	jmp    800293 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	6a 20                	push   $0x20
  8002ad:	6a 00                	push   $0x0
  8002af:	50                   	push   %eax
  8002b0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b3:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b6:	89 fa                	mov    %edi,%edx
  8002b8:	89 f0                	mov    %esi,%eax
  8002ba:	e8 98 ff ff ff       	call   800257 <printnum>
		while (--width > 0)
  8002bf:	83 c4 20             	add    $0x20,%esp
  8002c2:	83 eb 01             	sub    $0x1,%ebx
  8002c5:	85 db                	test   %ebx,%ebx
  8002c7:	7e 65                	jle    80032e <printnum+0xd7>
			putch(padc, putdat);
  8002c9:	83 ec 08             	sub    $0x8,%esp
  8002cc:	57                   	push   %edi
  8002cd:	6a 20                	push   $0x20
  8002cf:	ff d6                	call   *%esi
  8002d1:	83 c4 10             	add    $0x10,%esp
  8002d4:	eb ec                	jmp    8002c2 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	ff 75 18             	pushl  0x18(%ebp)
  8002dc:	83 eb 01             	sub    $0x1,%ebx
  8002df:	53                   	push   %ebx
  8002e0:	50                   	push   %eax
  8002e1:	83 ec 08             	sub    $0x8,%esp
  8002e4:	ff 75 dc             	pushl  -0x24(%ebp)
  8002e7:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ea:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ed:	ff 75 e0             	pushl  -0x20(%ebp)
  8002f0:	e8 8b 20 00 00       	call   802380 <__udivdi3>
  8002f5:	83 c4 18             	add    $0x18,%esp
  8002f8:	52                   	push   %edx
  8002f9:	50                   	push   %eax
  8002fa:	89 fa                	mov    %edi,%edx
  8002fc:	89 f0                	mov    %esi,%eax
  8002fe:	e8 54 ff ff ff       	call   800257 <printnum>
  800303:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800306:	83 ec 08             	sub    $0x8,%esp
  800309:	57                   	push   %edi
  80030a:	83 ec 04             	sub    $0x4,%esp
  80030d:	ff 75 dc             	pushl  -0x24(%ebp)
  800310:	ff 75 d8             	pushl  -0x28(%ebp)
  800313:	ff 75 e4             	pushl  -0x1c(%ebp)
  800316:	ff 75 e0             	pushl  -0x20(%ebp)
  800319:	e8 72 21 00 00       	call   802490 <__umoddi3>
  80031e:	83 c4 14             	add    $0x14,%esp
  800321:	0f be 80 71 26 80 00 	movsbl 0x802671(%eax),%eax
  800328:	50                   	push   %eax
  800329:	ff d6                	call   *%esi
  80032b:	83 c4 10             	add    $0x10,%esp
	}
}
  80032e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800331:	5b                   	pop    %ebx
  800332:	5e                   	pop    %esi
  800333:	5f                   	pop    %edi
  800334:	5d                   	pop    %ebp
  800335:	c3                   	ret    

00800336 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800336:	55                   	push   %ebp
  800337:	89 e5                	mov    %esp,%ebp
  800339:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80033c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800340:	8b 10                	mov    (%eax),%edx
  800342:	3b 50 04             	cmp    0x4(%eax),%edx
  800345:	73 0a                	jae    800351 <sprintputch+0x1b>
		*b->buf++ = ch;
  800347:	8d 4a 01             	lea    0x1(%edx),%ecx
  80034a:	89 08                	mov    %ecx,(%eax)
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	88 02                	mov    %al,(%edx)
}
  800351:	5d                   	pop    %ebp
  800352:	c3                   	ret    

00800353 <printfmt>:
{
  800353:	55                   	push   %ebp
  800354:	89 e5                	mov    %esp,%ebp
  800356:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800359:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80035c:	50                   	push   %eax
  80035d:	ff 75 10             	pushl  0x10(%ebp)
  800360:	ff 75 0c             	pushl  0xc(%ebp)
  800363:	ff 75 08             	pushl  0x8(%ebp)
  800366:	e8 05 00 00 00       	call   800370 <vprintfmt>
}
  80036b:	83 c4 10             	add    $0x10,%esp
  80036e:	c9                   	leave  
  80036f:	c3                   	ret    

00800370 <vprintfmt>:
{
  800370:	55                   	push   %ebp
  800371:	89 e5                	mov    %esp,%ebp
  800373:	57                   	push   %edi
  800374:	56                   	push   %esi
  800375:	53                   	push   %ebx
  800376:	83 ec 3c             	sub    $0x3c,%esp
  800379:	8b 75 08             	mov    0x8(%ebp),%esi
  80037c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80037f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800382:	e9 32 04 00 00       	jmp    8007b9 <vprintfmt+0x449>
		padc = ' ';
  800387:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80038b:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800392:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800399:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003a0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003a7:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003ae:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003b3:	8d 47 01             	lea    0x1(%edi),%eax
  8003b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003b9:	0f b6 17             	movzbl (%edi),%edx
  8003bc:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003bf:	3c 55                	cmp    $0x55,%al
  8003c1:	0f 87 12 05 00 00    	ja     8008d9 <vprintfmt+0x569>
  8003c7:	0f b6 c0             	movzbl %al,%eax
  8003ca:	ff 24 85 40 28 80 00 	jmp    *0x802840(,%eax,4)
  8003d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003d4:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003d8:	eb d9                	jmp    8003b3 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003dd:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003e1:	eb d0                	jmp    8003b3 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003e3:	0f b6 d2             	movzbl %dl,%edx
  8003e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ee:	89 75 08             	mov    %esi,0x8(%ebp)
  8003f1:	eb 03                	jmp    8003f6 <vprintfmt+0x86>
  8003f3:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003f6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003f9:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003fd:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800400:	8d 72 d0             	lea    -0x30(%edx),%esi
  800403:	83 fe 09             	cmp    $0x9,%esi
  800406:	76 eb                	jbe    8003f3 <vprintfmt+0x83>
  800408:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80040b:	8b 75 08             	mov    0x8(%ebp),%esi
  80040e:	eb 14                	jmp    800424 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800410:	8b 45 14             	mov    0x14(%ebp),%eax
  800413:	8b 00                	mov    (%eax),%eax
  800415:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800418:	8b 45 14             	mov    0x14(%ebp),%eax
  80041b:	8d 40 04             	lea    0x4(%eax),%eax
  80041e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800421:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800424:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800428:	79 89                	jns    8003b3 <vprintfmt+0x43>
				width = precision, precision = -1;
  80042a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80042d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800430:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800437:	e9 77 ff ff ff       	jmp    8003b3 <vprintfmt+0x43>
  80043c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043f:	85 c0                	test   %eax,%eax
  800441:	0f 48 c1             	cmovs  %ecx,%eax
  800444:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800447:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80044a:	e9 64 ff ff ff       	jmp    8003b3 <vprintfmt+0x43>
  80044f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800452:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800459:	e9 55 ff ff ff       	jmp    8003b3 <vprintfmt+0x43>
			lflag++;
  80045e:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800462:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800465:	e9 49 ff ff ff       	jmp    8003b3 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80046a:	8b 45 14             	mov    0x14(%ebp),%eax
  80046d:	8d 78 04             	lea    0x4(%eax),%edi
  800470:	83 ec 08             	sub    $0x8,%esp
  800473:	53                   	push   %ebx
  800474:	ff 30                	pushl  (%eax)
  800476:	ff d6                	call   *%esi
			break;
  800478:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80047b:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80047e:	e9 33 03 00 00       	jmp    8007b6 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800483:	8b 45 14             	mov    0x14(%ebp),%eax
  800486:	8d 78 04             	lea    0x4(%eax),%edi
  800489:	8b 00                	mov    (%eax),%eax
  80048b:	99                   	cltd   
  80048c:	31 d0                	xor    %edx,%eax
  80048e:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800490:	83 f8 11             	cmp    $0x11,%eax
  800493:	7f 23                	jg     8004b8 <vprintfmt+0x148>
  800495:	8b 14 85 a0 29 80 00 	mov    0x8029a0(,%eax,4),%edx
  80049c:	85 d2                	test   %edx,%edx
  80049e:	74 18                	je     8004b8 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004a0:	52                   	push   %edx
  8004a1:	68 dd 2a 80 00       	push   $0x802add
  8004a6:	53                   	push   %ebx
  8004a7:	56                   	push   %esi
  8004a8:	e8 a6 fe ff ff       	call   800353 <printfmt>
  8004ad:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004b0:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004b3:	e9 fe 02 00 00       	jmp    8007b6 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004b8:	50                   	push   %eax
  8004b9:	68 89 26 80 00       	push   $0x802689
  8004be:	53                   	push   %ebx
  8004bf:	56                   	push   %esi
  8004c0:	e8 8e fe ff ff       	call   800353 <printfmt>
  8004c5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004c8:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004cb:	e9 e6 02 00 00       	jmp    8007b6 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d3:	83 c0 04             	add    $0x4,%eax
  8004d6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004dc:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004de:	85 c9                	test   %ecx,%ecx
  8004e0:	b8 82 26 80 00       	mov    $0x802682,%eax
  8004e5:	0f 45 c1             	cmovne %ecx,%eax
  8004e8:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004eb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004ef:	7e 06                	jle    8004f7 <vprintfmt+0x187>
  8004f1:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004f5:	75 0d                	jne    800504 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004fa:	89 c7                	mov    %eax,%edi
  8004fc:	03 45 e0             	add    -0x20(%ebp),%eax
  8004ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800502:	eb 53                	jmp    800557 <vprintfmt+0x1e7>
  800504:	83 ec 08             	sub    $0x8,%esp
  800507:	ff 75 d8             	pushl  -0x28(%ebp)
  80050a:	50                   	push   %eax
  80050b:	e8 71 04 00 00       	call   800981 <strnlen>
  800510:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800513:	29 c1                	sub    %eax,%ecx
  800515:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800518:	83 c4 10             	add    $0x10,%esp
  80051b:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80051d:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800521:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800524:	eb 0f                	jmp    800535 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800526:	83 ec 08             	sub    $0x8,%esp
  800529:	53                   	push   %ebx
  80052a:	ff 75 e0             	pushl  -0x20(%ebp)
  80052d:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80052f:	83 ef 01             	sub    $0x1,%edi
  800532:	83 c4 10             	add    $0x10,%esp
  800535:	85 ff                	test   %edi,%edi
  800537:	7f ed                	jg     800526 <vprintfmt+0x1b6>
  800539:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80053c:	85 c9                	test   %ecx,%ecx
  80053e:	b8 00 00 00 00       	mov    $0x0,%eax
  800543:	0f 49 c1             	cmovns %ecx,%eax
  800546:	29 c1                	sub    %eax,%ecx
  800548:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80054b:	eb aa                	jmp    8004f7 <vprintfmt+0x187>
					putch(ch, putdat);
  80054d:	83 ec 08             	sub    $0x8,%esp
  800550:	53                   	push   %ebx
  800551:	52                   	push   %edx
  800552:	ff d6                	call   *%esi
  800554:	83 c4 10             	add    $0x10,%esp
  800557:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80055a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80055c:	83 c7 01             	add    $0x1,%edi
  80055f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800563:	0f be d0             	movsbl %al,%edx
  800566:	85 d2                	test   %edx,%edx
  800568:	74 4b                	je     8005b5 <vprintfmt+0x245>
  80056a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80056e:	78 06                	js     800576 <vprintfmt+0x206>
  800570:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800574:	78 1e                	js     800594 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800576:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80057a:	74 d1                	je     80054d <vprintfmt+0x1dd>
  80057c:	0f be c0             	movsbl %al,%eax
  80057f:	83 e8 20             	sub    $0x20,%eax
  800582:	83 f8 5e             	cmp    $0x5e,%eax
  800585:	76 c6                	jbe    80054d <vprintfmt+0x1dd>
					putch('?', putdat);
  800587:	83 ec 08             	sub    $0x8,%esp
  80058a:	53                   	push   %ebx
  80058b:	6a 3f                	push   $0x3f
  80058d:	ff d6                	call   *%esi
  80058f:	83 c4 10             	add    $0x10,%esp
  800592:	eb c3                	jmp    800557 <vprintfmt+0x1e7>
  800594:	89 cf                	mov    %ecx,%edi
  800596:	eb 0e                	jmp    8005a6 <vprintfmt+0x236>
				putch(' ', putdat);
  800598:	83 ec 08             	sub    $0x8,%esp
  80059b:	53                   	push   %ebx
  80059c:	6a 20                	push   $0x20
  80059e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005a0:	83 ef 01             	sub    $0x1,%edi
  8005a3:	83 c4 10             	add    $0x10,%esp
  8005a6:	85 ff                	test   %edi,%edi
  8005a8:	7f ee                	jg     800598 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005aa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005ad:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b0:	e9 01 02 00 00       	jmp    8007b6 <vprintfmt+0x446>
  8005b5:	89 cf                	mov    %ecx,%edi
  8005b7:	eb ed                	jmp    8005a6 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005b9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005bc:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005c3:	e9 eb fd ff ff       	jmp    8003b3 <vprintfmt+0x43>
	if (lflag >= 2)
  8005c8:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005cc:	7f 21                	jg     8005ef <vprintfmt+0x27f>
	else if (lflag)
  8005ce:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005d2:	74 68                	je     80063c <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	8b 00                	mov    (%eax),%eax
  8005d9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005dc:	89 c1                	mov    %eax,%ecx
  8005de:	c1 f9 1f             	sar    $0x1f,%ecx
  8005e1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e7:	8d 40 04             	lea    0x4(%eax),%eax
  8005ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ed:	eb 17                	jmp    800606 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	8b 50 04             	mov    0x4(%eax),%edx
  8005f5:	8b 00                	mov    (%eax),%eax
  8005f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005fa:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	8d 40 08             	lea    0x8(%eax),%eax
  800603:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800606:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800609:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80060c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060f:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800612:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800616:	78 3f                	js     800657 <vprintfmt+0x2e7>
			base = 10;
  800618:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80061d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800621:	0f 84 71 01 00 00    	je     800798 <vprintfmt+0x428>
				putch('+', putdat);
  800627:	83 ec 08             	sub    $0x8,%esp
  80062a:	53                   	push   %ebx
  80062b:	6a 2b                	push   $0x2b
  80062d:	ff d6                	call   *%esi
  80062f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800632:	b8 0a 00 00 00       	mov    $0xa,%eax
  800637:	e9 5c 01 00 00       	jmp    800798 <vprintfmt+0x428>
		return va_arg(*ap, int);
  80063c:	8b 45 14             	mov    0x14(%ebp),%eax
  80063f:	8b 00                	mov    (%eax),%eax
  800641:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800644:	89 c1                	mov    %eax,%ecx
  800646:	c1 f9 1f             	sar    $0x1f,%ecx
  800649:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80064c:	8b 45 14             	mov    0x14(%ebp),%eax
  80064f:	8d 40 04             	lea    0x4(%eax),%eax
  800652:	89 45 14             	mov    %eax,0x14(%ebp)
  800655:	eb af                	jmp    800606 <vprintfmt+0x296>
				putch('-', putdat);
  800657:	83 ec 08             	sub    $0x8,%esp
  80065a:	53                   	push   %ebx
  80065b:	6a 2d                	push   $0x2d
  80065d:	ff d6                	call   *%esi
				num = -(long long) num;
  80065f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800662:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800665:	f7 d8                	neg    %eax
  800667:	83 d2 00             	adc    $0x0,%edx
  80066a:	f7 da                	neg    %edx
  80066c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800672:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800675:	b8 0a 00 00 00       	mov    $0xa,%eax
  80067a:	e9 19 01 00 00       	jmp    800798 <vprintfmt+0x428>
	if (lflag >= 2)
  80067f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800683:	7f 29                	jg     8006ae <vprintfmt+0x33e>
	else if (lflag)
  800685:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800689:	74 44                	je     8006cf <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80068b:	8b 45 14             	mov    0x14(%ebp),%eax
  80068e:	8b 00                	mov    (%eax),%eax
  800690:	ba 00 00 00 00       	mov    $0x0,%edx
  800695:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800698:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80069b:	8b 45 14             	mov    0x14(%ebp),%eax
  80069e:	8d 40 04             	lea    0x4(%eax),%eax
  8006a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006a4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a9:	e9 ea 00 00 00       	jmp    800798 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	8b 50 04             	mov    0x4(%eax),%edx
  8006b4:	8b 00                	mov    (%eax),%eax
  8006b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bf:	8d 40 08             	lea    0x8(%eax),%eax
  8006c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ca:	e9 c9 00 00 00       	jmp    800798 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	8d 40 04             	lea    0x4(%eax),%eax
  8006e5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ed:	e9 a6 00 00 00       	jmp    800798 <vprintfmt+0x428>
			putch('0', putdat);
  8006f2:	83 ec 08             	sub    $0x8,%esp
  8006f5:	53                   	push   %ebx
  8006f6:	6a 30                	push   $0x30
  8006f8:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006fa:	83 c4 10             	add    $0x10,%esp
  8006fd:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800701:	7f 26                	jg     800729 <vprintfmt+0x3b9>
	else if (lflag)
  800703:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800707:	74 3e                	je     800747 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800709:	8b 45 14             	mov    0x14(%ebp),%eax
  80070c:	8b 00                	mov    (%eax),%eax
  80070e:	ba 00 00 00 00       	mov    $0x0,%edx
  800713:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800716:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800719:	8b 45 14             	mov    0x14(%ebp),%eax
  80071c:	8d 40 04             	lea    0x4(%eax),%eax
  80071f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800722:	b8 08 00 00 00       	mov    $0x8,%eax
  800727:	eb 6f                	jmp    800798 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800729:	8b 45 14             	mov    0x14(%ebp),%eax
  80072c:	8b 50 04             	mov    0x4(%eax),%edx
  80072f:	8b 00                	mov    (%eax),%eax
  800731:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800734:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800737:	8b 45 14             	mov    0x14(%ebp),%eax
  80073a:	8d 40 08             	lea    0x8(%eax),%eax
  80073d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800740:	b8 08 00 00 00       	mov    $0x8,%eax
  800745:	eb 51                	jmp    800798 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800747:	8b 45 14             	mov    0x14(%ebp),%eax
  80074a:	8b 00                	mov    (%eax),%eax
  80074c:	ba 00 00 00 00       	mov    $0x0,%edx
  800751:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800754:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800757:	8b 45 14             	mov    0x14(%ebp),%eax
  80075a:	8d 40 04             	lea    0x4(%eax),%eax
  80075d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800760:	b8 08 00 00 00       	mov    $0x8,%eax
  800765:	eb 31                	jmp    800798 <vprintfmt+0x428>
			putch('0', putdat);
  800767:	83 ec 08             	sub    $0x8,%esp
  80076a:	53                   	push   %ebx
  80076b:	6a 30                	push   $0x30
  80076d:	ff d6                	call   *%esi
			putch('x', putdat);
  80076f:	83 c4 08             	add    $0x8,%esp
  800772:	53                   	push   %ebx
  800773:	6a 78                	push   $0x78
  800775:	ff d6                	call   *%esi
			num = (unsigned long long)
  800777:	8b 45 14             	mov    0x14(%ebp),%eax
  80077a:	8b 00                	mov    (%eax),%eax
  80077c:	ba 00 00 00 00       	mov    $0x0,%edx
  800781:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800784:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800787:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80078a:	8b 45 14             	mov    0x14(%ebp),%eax
  80078d:	8d 40 04             	lea    0x4(%eax),%eax
  800790:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800793:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800798:	83 ec 0c             	sub    $0xc,%esp
  80079b:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80079f:	52                   	push   %edx
  8007a0:	ff 75 e0             	pushl  -0x20(%ebp)
  8007a3:	50                   	push   %eax
  8007a4:	ff 75 dc             	pushl  -0x24(%ebp)
  8007a7:	ff 75 d8             	pushl  -0x28(%ebp)
  8007aa:	89 da                	mov    %ebx,%edx
  8007ac:	89 f0                	mov    %esi,%eax
  8007ae:	e8 a4 fa ff ff       	call   800257 <printnum>
			break;
  8007b3:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b9:	83 c7 01             	add    $0x1,%edi
  8007bc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007c0:	83 f8 25             	cmp    $0x25,%eax
  8007c3:	0f 84 be fb ff ff    	je     800387 <vprintfmt+0x17>
			if (ch == '\0')
  8007c9:	85 c0                	test   %eax,%eax
  8007cb:	0f 84 28 01 00 00    	je     8008f9 <vprintfmt+0x589>
			putch(ch, putdat);
  8007d1:	83 ec 08             	sub    $0x8,%esp
  8007d4:	53                   	push   %ebx
  8007d5:	50                   	push   %eax
  8007d6:	ff d6                	call   *%esi
  8007d8:	83 c4 10             	add    $0x10,%esp
  8007db:	eb dc                	jmp    8007b9 <vprintfmt+0x449>
	if (lflag >= 2)
  8007dd:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007e1:	7f 26                	jg     800809 <vprintfmt+0x499>
	else if (lflag)
  8007e3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007e7:	74 41                	je     80082a <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ec:	8b 00                	mov    (%eax),%eax
  8007ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	8d 40 04             	lea    0x4(%eax),%eax
  8007ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800802:	b8 10 00 00 00       	mov    $0x10,%eax
  800807:	eb 8f                	jmp    800798 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800809:	8b 45 14             	mov    0x14(%ebp),%eax
  80080c:	8b 50 04             	mov    0x4(%eax),%edx
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800814:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800817:	8b 45 14             	mov    0x14(%ebp),%eax
  80081a:	8d 40 08             	lea    0x8(%eax),%eax
  80081d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800820:	b8 10 00 00 00       	mov    $0x10,%eax
  800825:	e9 6e ff ff ff       	jmp    800798 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80082a:	8b 45 14             	mov    0x14(%ebp),%eax
  80082d:	8b 00                	mov    (%eax),%eax
  80082f:	ba 00 00 00 00       	mov    $0x0,%edx
  800834:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800837:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80083a:	8b 45 14             	mov    0x14(%ebp),%eax
  80083d:	8d 40 04             	lea    0x4(%eax),%eax
  800840:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800843:	b8 10 00 00 00       	mov    $0x10,%eax
  800848:	e9 4b ff ff ff       	jmp    800798 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80084d:	8b 45 14             	mov    0x14(%ebp),%eax
  800850:	83 c0 04             	add    $0x4,%eax
  800853:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800856:	8b 45 14             	mov    0x14(%ebp),%eax
  800859:	8b 00                	mov    (%eax),%eax
  80085b:	85 c0                	test   %eax,%eax
  80085d:	74 14                	je     800873 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80085f:	8b 13                	mov    (%ebx),%edx
  800861:	83 fa 7f             	cmp    $0x7f,%edx
  800864:	7f 37                	jg     80089d <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800866:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800868:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80086b:	89 45 14             	mov    %eax,0x14(%ebp)
  80086e:	e9 43 ff ff ff       	jmp    8007b6 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800873:	b8 0a 00 00 00       	mov    $0xa,%eax
  800878:	bf a5 27 80 00       	mov    $0x8027a5,%edi
							putch(ch, putdat);
  80087d:	83 ec 08             	sub    $0x8,%esp
  800880:	53                   	push   %ebx
  800881:	50                   	push   %eax
  800882:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800884:	83 c7 01             	add    $0x1,%edi
  800887:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80088b:	83 c4 10             	add    $0x10,%esp
  80088e:	85 c0                	test   %eax,%eax
  800890:	75 eb                	jne    80087d <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800892:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800895:	89 45 14             	mov    %eax,0x14(%ebp)
  800898:	e9 19 ff ff ff       	jmp    8007b6 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80089d:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80089f:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008a4:	bf dd 27 80 00       	mov    $0x8027dd,%edi
							putch(ch, putdat);
  8008a9:	83 ec 08             	sub    $0x8,%esp
  8008ac:	53                   	push   %ebx
  8008ad:	50                   	push   %eax
  8008ae:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008b0:	83 c7 01             	add    $0x1,%edi
  8008b3:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008b7:	83 c4 10             	add    $0x10,%esp
  8008ba:	85 c0                	test   %eax,%eax
  8008bc:	75 eb                	jne    8008a9 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c4:	e9 ed fe ff ff       	jmp    8007b6 <vprintfmt+0x446>
			putch(ch, putdat);
  8008c9:	83 ec 08             	sub    $0x8,%esp
  8008cc:	53                   	push   %ebx
  8008cd:	6a 25                	push   $0x25
  8008cf:	ff d6                	call   *%esi
			break;
  8008d1:	83 c4 10             	add    $0x10,%esp
  8008d4:	e9 dd fe ff ff       	jmp    8007b6 <vprintfmt+0x446>
			putch('%', putdat);
  8008d9:	83 ec 08             	sub    $0x8,%esp
  8008dc:	53                   	push   %ebx
  8008dd:	6a 25                	push   $0x25
  8008df:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008e1:	83 c4 10             	add    $0x10,%esp
  8008e4:	89 f8                	mov    %edi,%eax
  8008e6:	eb 03                	jmp    8008eb <vprintfmt+0x57b>
  8008e8:	83 e8 01             	sub    $0x1,%eax
  8008eb:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008ef:	75 f7                	jne    8008e8 <vprintfmt+0x578>
  8008f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f4:	e9 bd fe ff ff       	jmp    8007b6 <vprintfmt+0x446>
}
  8008f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008fc:	5b                   	pop    %ebx
  8008fd:	5e                   	pop    %esi
  8008fe:	5f                   	pop    %edi
  8008ff:	5d                   	pop    %ebp
  800900:	c3                   	ret    

00800901 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800901:	55                   	push   %ebp
  800902:	89 e5                	mov    %esp,%ebp
  800904:	83 ec 18             	sub    $0x18,%esp
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80090d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800910:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800914:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800917:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80091e:	85 c0                	test   %eax,%eax
  800920:	74 26                	je     800948 <vsnprintf+0x47>
  800922:	85 d2                	test   %edx,%edx
  800924:	7e 22                	jle    800948 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800926:	ff 75 14             	pushl  0x14(%ebp)
  800929:	ff 75 10             	pushl  0x10(%ebp)
  80092c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80092f:	50                   	push   %eax
  800930:	68 36 03 80 00       	push   $0x800336
  800935:	e8 36 fa ff ff       	call   800370 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80093a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80093d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800943:	83 c4 10             	add    $0x10,%esp
}
  800946:	c9                   	leave  
  800947:	c3                   	ret    
		return -E_INVAL;
  800948:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80094d:	eb f7                	jmp    800946 <vsnprintf+0x45>

0080094f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800955:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800958:	50                   	push   %eax
  800959:	ff 75 10             	pushl  0x10(%ebp)
  80095c:	ff 75 0c             	pushl  0xc(%ebp)
  80095f:	ff 75 08             	pushl  0x8(%ebp)
  800962:	e8 9a ff ff ff       	call   800901 <vsnprintf>
	va_end(ap);

	return rc;
}
  800967:	c9                   	leave  
  800968:	c3                   	ret    

00800969 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
  80096c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80096f:	b8 00 00 00 00       	mov    $0x0,%eax
  800974:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800978:	74 05                	je     80097f <strlen+0x16>
		n++;
  80097a:	83 c0 01             	add    $0x1,%eax
  80097d:	eb f5                	jmp    800974 <strlen+0xb>
	return n;
}
  80097f:	5d                   	pop    %ebp
  800980:	c3                   	ret    

00800981 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800981:	55                   	push   %ebp
  800982:	89 e5                	mov    %esp,%ebp
  800984:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800987:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80098a:	ba 00 00 00 00       	mov    $0x0,%edx
  80098f:	39 c2                	cmp    %eax,%edx
  800991:	74 0d                	je     8009a0 <strnlen+0x1f>
  800993:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800997:	74 05                	je     80099e <strnlen+0x1d>
		n++;
  800999:	83 c2 01             	add    $0x1,%edx
  80099c:	eb f1                	jmp    80098f <strnlen+0xe>
  80099e:	89 d0                	mov    %edx,%eax
	return n;
}
  8009a0:	5d                   	pop    %ebp
  8009a1:	c3                   	ret    

008009a2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	53                   	push   %ebx
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b1:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009b5:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009b8:	83 c2 01             	add    $0x1,%edx
  8009bb:	84 c9                	test   %cl,%cl
  8009bd:	75 f2                	jne    8009b1 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009bf:	5b                   	pop    %ebx
  8009c0:	5d                   	pop    %ebp
  8009c1:	c3                   	ret    

008009c2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	53                   	push   %ebx
  8009c6:	83 ec 10             	sub    $0x10,%esp
  8009c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009cc:	53                   	push   %ebx
  8009cd:	e8 97 ff ff ff       	call   800969 <strlen>
  8009d2:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009d5:	ff 75 0c             	pushl  0xc(%ebp)
  8009d8:	01 d8                	add    %ebx,%eax
  8009da:	50                   	push   %eax
  8009db:	e8 c2 ff ff ff       	call   8009a2 <strcpy>
	return dst;
}
  8009e0:	89 d8                	mov    %ebx,%eax
  8009e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009e5:	c9                   	leave  
  8009e6:	c3                   	ret    

008009e7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009e7:	55                   	push   %ebp
  8009e8:	89 e5                	mov    %esp,%ebp
  8009ea:	56                   	push   %esi
  8009eb:	53                   	push   %ebx
  8009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009f2:	89 c6                	mov    %eax,%esi
  8009f4:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009f7:	89 c2                	mov    %eax,%edx
  8009f9:	39 f2                	cmp    %esi,%edx
  8009fb:	74 11                	je     800a0e <strncpy+0x27>
		*dst++ = *src;
  8009fd:	83 c2 01             	add    $0x1,%edx
  800a00:	0f b6 19             	movzbl (%ecx),%ebx
  800a03:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a06:	80 fb 01             	cmp    $0x1,%bl
  800a09:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a0c:	eb eb                	jmp    8009f9 <strncpy+0x12>
	}
	return ret;
}
  800a0e:	5b                   	pop    %ebx
  800a0f:	5e                   	pop    %esi
  800a10:	5d                   	pop    %ebp
  800a11:	c3                   	ret    

00800a12 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a12:	55                   	push   %ebp
  800a13:	89 e5                	mov    %esp,%ebp
  800a15:	56                   	push   %esi
  800a16:	53                   	push   %ebx
  800a17:	8b 75 08             	mov    0x8(%ebp),%esi
  800a1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a1d:	8b 55 10             	mov    0x10(%ebp),%edx
  800a20:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a22:	85 d2                	test   %edx,%edx
  800a24:	74 21                	je     800a47 <strlcpy+0x35>
  800a26:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a2a:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a2c:	39 c2                	cmp    %eax,%edx
  800a2e:	74 14                	je     800a44 <strlcpy+0x32>
  800a30:	0f b6 19             	movzbl (%ecx),%ebx
  800a33:	84 db                	test   %bl,%bl
  800a35:	74 0b                	je     800a42 <strlcpy+0x30>
			*dst++ = *src++;
  800a37:	83 c1 01             	add    $0x1,%ecx
  800a3a:	83 c2 01             	add    $0x1,%edx
  800a3d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a40:	eb ea                	jmp    800a2c <strlcpy+0x1a>
  800a42:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a44:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a47:	29 f0                	sub    %esi,%eax
}
  800a49:	5b                   	pop    %ebx
  800a4a:	5e                   	pop    %esi
  800a4b:	5d                   	pop    %ebp
  800a4c:	c3                   	ret    

00800a4d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a53:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a56:	0f b6 01             	movzbl (%ecx),%eax
  800a59:	84 c0                	test   %al,%al
  800a5b:	74 0c                	je     800a69 <strcmp+0x1c>
  800a5d:	3a 02                	cmp    (%edx),%al
  800a5f:	75 08                	jne    800a69 <strcmp+0x1c>
		p++, q++;
  800a61:	83 c1 01             	add    $0x1,%ecx
  800a64:	83 c2 01             	add    $0x1,%edx
  800a67:	eb ed                	jmp    800a56 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a69:	0f b6 c0             	movzbl %al,%eax
  800a6c:	0f b6 12             	movzbl (%edx),%edx
  800a6f:	29 d0                	sub    %edx,%eax
}
  800a71:	5d                   	pop    %ebp
  800a72:	c3                   	ret    

00800a73 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a73:	55                   	push   %ebp
  800a74:	89 e5                	mov    %esp,%ebp
  800a76:	53                   	push   %ebx
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a7d:	89 c3                	mov    %eax,%ebx
  800a7f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a82:	eb 06                	jmp    800a8a <strncmp+0x17>
		n--, p++, q++;
  800a84:	83 c0 01             	add    $0x1,%eax
  800a87:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a8a:	39 d8                	cmp    %ebx,%eax
  800a8c:	74 16                	je     800aa4 <strncmp+0x31>
  800a8e:	0f b6 08             	movzbl (%eax),%ecx
  800a91:	84 c9                	test   %cl,%cl
  800a93:	74 04                	je     800a99 <strncmp+0x26>
  800a95:	3a 0a                	cmp    (%edx),%cl
  800a97:	74 eb                	je     800a84 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a99:	0f b6 00             	movzbl (%eax),%eax
  800a9c:	0f b6 12             	movzbl (%edx),%edx
  800a9f:	29 d0                	sub    %edx,%eax
}
  800aa1:	5b                   	pop    %ebx
  800aa2:	5d                   	pop    %ebp
  800aa3:	c3                   	ret    
		return 0;
  800aa4:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa9:	eb f6                	jmp    800aa1 <strncmp+0x2e>

00800aab <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ab5:	0f b6 10             	movzbl (%eax),%edx
  800ab8:	84 d2                	test   %dl,%dl
  800aba:	74 09                	je     800ac5 <strchr+0x1a>
		if (*s == c)
  800abc:	38 ca                	cmp    %cl,%dl
  800abe:	74 0a                	je     800aca <strchr+0x1f>
	for (; *s; s++)
  800ac0:	83 c0 01             	add    $0x1,%eax
  800ac3:	eb f0                	jmp    800ab5 <strchr+0xa>
			return (char *) s;
	return 0;
  800ac5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aca:	5d                   	pop    %ebp
  800acb:	c3                   	ret    

00800acc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ad6:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ad9:	38 ca                	cmp    %cl,%dl
  800adb:	74 09                	je     800ae6 <strfind+0x1a>
  800add:	84 d2                	test   %dl,%dl
  800adf:	74 05                	je     800ae6 <strfind+0x1a>
	for (; *s; s++)
  800ae1:	83 c0 01             	add    $0x1,%eax
  800ae4:	eb f0                	jmp    800ad6 <strfind+0xa>
			break;
	return (char *) s;
}
  800ae6:	5d                   	pop    %ebp
  800ae7:	c3                   	ret    

00800ae8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ae8:	55                   	push   %ebp
  800ae9:	89 e5                	mov    %esp,%ebp
  800aeb:	57                   	push   %edi
  800aec:	56                   	push   %esi
  800aed:	53                   	push   %ebx
  800aee:	8b 7d 08             	mov    0x8(%ebp),%edi
  800af1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800af4:	85 c9                	test   %ecx,%ecx
  800af6:	74 31                	je     800b29 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800af8:	89 f8                	mov    %edi,%eax
  800afa:	09 c8                	or     %ecx,%eax
  800afc:	a8 03                	test   $0x3,%al
  800afe:	75 23                	jne    800b23 <memset+0x3b>
		c &= 0xFF;
  800b00:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b04:	89 d3                	mov    %edx,%ebx
  800b06:	c1 e3 08             	shl    $0x8,%ebx
  800b09:	89 d0                	mov    %edx,%eax
  800b0b:	c1 e0 18             	shl    $0x18,%eax
  800b0e:	89 d6                	mov    %edx,%esi
  800b10:	c1 e6 10             	shl    $0x10,%esi
  800b13:	09 f0                	or     %esi,%eax
  800b15:	09 c2                	or     %eax,%edx
  800b17:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b19:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b1c:	89 d0                	mov    %edx,%eax
  800b1e:	fc                   	cld    
  800b1f:	f3 ab                	rep stos %eax,%es:(%edi)
  800b21:	eb 06                	jmp    800b29 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b26:	fc                   	cld    
  800b27:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b29:	89 f8                	mov    %edi,%eax
  800b2b:	5b                   	pop    %ebx
  800b2c:	5e                   	pop    %esi
  800b2d:	5f                   	pop    %edi
  800b2e:	5d                   	pop    %ebp
  800b2f:	c3                   	ret    

00800b30 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
  800b33:	57                   	push   %edi
  800b34:	56                   	push   %esi
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b3b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b3e:	39 c6                	cmp    %eax,%esi
  800b40:	73 32                	jae    800b74 <memmove+0x44>
  800b42:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b45:	39 c2                	cmp    %eax,%edx
  800b47:	76 2b                	jbe    800b74 <memmove+0x44>
		s += n;
		d += n;
  800b49:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b4c:	89 fe                	mov    %edi,%esi
  800b4e:	09 ce                	or     %ecx,%esi
  800b50:	09 d6                	or     %edx,%esi
  800b52:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b58:	75 0e                	jne    800b68 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b5a:	83 ef 04             	sub    $0x4,%edi
  800b5d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b60:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b63:	fd                   	std    
  800b64:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b66:	eb 09                	jmp    800b71 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b68:	83 ef 01             	sub    $0x1,%edi
  800b6b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b6e:	fd                   	std    
  800b6f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b71:	fc                   	cld    
  800b72:	eb 1a                	jmp    800b8e <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b74:	89 c2                	mov    %eax,%edx
  800b76:	09 ca                	or     %ecx,%edx
  800b78:	09 f2                	or     %esi,%edx
  800b7a:	f6 c2 03             	test   $0x3,%dl
  800b7d:	75 0a                	jne    800b89 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b7f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b82:	89 c7                	mov    %eax,%edi
  800b84:	fc                   	cld    
  800b85:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b87:	eb 05                	jmp    800b8e <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b89:	89 c7                	mov    %eax,%edi
  800b8b:	fc                   	cld    
  800b8c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b8e:	5e                   	pop    %esi
  800b8f:	5f                   	pop    %edi
  800b90:	5d                   	pop    %ebp
  800b91:	c3                   	ret    

00800b92 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b92:	55                   	push   %ebp
  800b93:	89 e5                	mov    %esp,%ebp
  800b95:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b98:	ff 75 10             	pushl  0x10(%ebp)
  800b9b:	ff 75 0c             	pushl  0xc(%ebp)
  800b9e:	ff 75 08             	pushl  0x8(%ebp)
  800ba1:	e8 8a ff ff ff       	call   800b30 <memmove>
}
  800ba6:	c9                   	leave  
  800ba7:	c3                   	ret    

00800ba8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ba8:	55                   	push   %ebp
  800ba9:	89 e5                	mov    %esp,%ebp
  800bab:	56                   	push   %esi
  800bac:	53                   	push   %ebx
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb3:	89 c6                	mov    %eax,%esi
  800bb5:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bb8:	39 f0                	cmp    %esi,%eax
  800bba:	74 1c                	je     800bd8 <memcmp+0x30>
		if (*s1 != *s2)
  800bbc:	0f b6 08             	movzbl (%eax),%ecx
  800bbf:	0f b6 1a             	movzbl (%edx),%ebx
  800bc2:	38 d9                	cmp    %bl,%cl
  800bc4:	75 08                	jne    800bce <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bc6:	83 c0 01             	add    $0x1,%eax
  800bc9:	83 c2 01             	add    $0x1,%edx
  800bcc:	eb ea                	jmp    800bb8 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bce:	0f b6 c1             	movzbl %cl,%eax
  800bd1:	0f b6 db             	movzbl %bl,%ebx
  800bd4:	29 d8                	sub    %ebx,%eax
  800bd6:	eb 05                	jmp    800bdd <memcmp+0x35>
	}

	return 0;
  800bd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bdd:	5b                   	pop    %ebx
  800bde:	5e                   	pop    %esi
  800bdf:	5d                   	pop    %ebp
  800be0:	c3                   	ret    

00800be1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bea:	89 c2                	mov    %eax,%edx
  800bec:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bef:	39 d0                	cmp    %edx,%eax
  800bf1:	73 09                	jae    800bfc <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bf3:	38 08                	cmp    %cl,(%eax)
  800bf5:	74 05                	je     800bfc <memfind+0x1b>
	for (; s < ends; s++)
  800bf7:	83 c0 01             	add    $0x1,%eax
  800bfa:	eb f3                	jmp    800bef <memfind+0xe>
			break;
	return (void *) s;
}
  800bfc:	5d                   	pop    %ebp
  800bfd:	c3                   	ret    

00800bfe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bfe:	55                   	push   %ebp
  800bff:	89 e5                	mov    %esp,%ebp
  800c01:	57                   	push   %edi
  800c02:	56                   	push   %esi
  800c03:	53                   	push   %ebx
  800c04:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c07:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c0a:	eb 03                	jmp    800c0f <strtol+0x11>
		s++;
  800c0c:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c0f:	0f b6 01             	movzbl (%ecx),%eax
  800c12:	3c 20                	cmp    $0x20,%al
  800c14:	74 f6                	je     800c0c <strtol+0xe>
  800c16:	3c 09                	cmp    $0x9,%al
  800c18:	74 f2                	je     800c0c <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c1a:	3c 2b                	cmp    $0x2b,%al
  800c1c:	74 2a                	je     800c48 <strtol+0x4a>
	int neg = 0;
  800c1e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c23:	3c 2d                	cmp    $0x2d,%al
  800c25:	74 2b                	je     800c52 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c27:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c2d:	75 0f                	jne    800c3e <strtol+0x40>
  800c2f:	80 39 30             	cmpb   $0x30,(%ecx)
  800c32:	74 28                	je     800c5c <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c34:	85 db                	test   %ebx,%ebx
  800c36:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c3b:	0f 44 d8             	cmove  %eax,%ebx
  800c3e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c43:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c46:	eb 50                	jmp    800c98 <strtol+0x9a>
		s++;
  800c48:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c4b:	bf 00 00 00 00       	mov    $0x0,%edi
  800c50:	eb d5                	jmp    800c27 <strtol+0x29>
		s++, neg = 1;
  800c52:	83 c1 01             	add    $0x1,%ecx
  800c55:	bf 01 00 00 00       	mov    $0x1,%edi
  800c5a:	eb cb                	jmp    800c27 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c5c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c60:	74 0e                	je     800c70 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c62:	85 db                	test   %ebx,%ebx
  800c64:	75 d8                	jne    800c3e <strtol+0x40>
		s++, base = 8;
  800c66:	83 c1 01             	add    $0x1,%ecx
  800c69:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c6e:	eb ce                	jmp    800c3e <strtol+0x40>
		s += 2, base = 16;
  800c70:	83 c1 02             	add    $0x2,%ecx
  800c73:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c78:	eb c4                	jmp    800c3e <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c7a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c7d:	89 f3                	mov    %esi,%ebx
  800c7f:	80 fb 19             	cmp    $0x19,%bl
  800c82:	77 29                	ja     800cad <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c84:	0f be d2             	movsbl %dl,%edx
  800c87:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c8a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c8d:	7d 30                	jge    800cbf <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c8f:	83 c1 01             	add    $0x1,%ecx
  800c92:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c96:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c98:	0f b6 11             	movzbl (%ecx),%edx
  800c9b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c9e:	89 f3                	mov    %esi,%ebx
  800ca0:	80 fb 09             	cmp    $0x9,%bl
  800ca3:	77 d5                	ja     800c7a <strtol+0x7c>
			dig = *s - '0';
  800ca5:	0f be d2             	movsbl %dl,%edx
  800ca8:	83 ea 30             	sub    $0x30,%edx
  800cab:	eb dd                	jmp    800c8a <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800cad:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cb0:	89 f3                	mov    %esi,%ebx
  800cb2:	80 fb 19             	cmp    $0x19,%bl
  800cb5:	77 08                	ja     800cbf <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cb7:	0f be d2             	movsbl %dl,%edx
  800cba:	83 ea 37             	sub    $0x37,%edx
  800cbd:	eb cb                	jmp    800c8a <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cbf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cc3:	74 05                	je     800cca <strtol+0xcc>
		*endptr = (char *) s;
  800cc5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cc8:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cca:	89 c2                	mov    %eax,%edx
  800ccc:	f7 da                	neg    %edx
  800cce:	85 ff                	test   %edi,%edi
  800cd0:	0f 45 c2             	cmovne %edx,%eax
}
  800cd3:	5b                   	pop    %ebx
  800cd4:	5e                   	pop    %esi
  800cd5:	5f                   	pop    %edi
  800cd6:	5d                   	pop    %ebp
  800cd7:	c3                   	ret    

00800cd8 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cd8:	55                   	push   %ebp
  800cd9:	89 e5                	mov    %esp,%ebp
  800cdb:	57                   	push   %edi
  800cdc:	56                   	push   %esi
  800cdd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cde:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce9:	89 c3                	mov    %eax,%ebx
  800ceb:	89 c7                	mov    %eax,%edi
  800ced:	89 c6                	mov    %eax,%esi
  800cef:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cf1:	5b                   	pop    %ebx
  800cf2:	5e                   	pop    %esi
  800cf3:	5f                   	pop    %edi
  800cf4:	5d                   	pop    %ebp
  800cf5:	c3                   	ret    

00800cf6 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	57                   	push   %edi
  800cfa:	56                   	push   %esi
  800cfb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cfc:	ba 00 00 00 00       	mov    $0x0,%edx
  800d01:	b8 01 00 00 00       	mov    $0x1,%eax
  800d06:	89 d1                	mov    %edx,%ecx
  800d08:	89 d3                	mov    %edx,%ebx
  800d0a:	89 d7                	mov    %edx,%edi
  800d0c:	89 d6                	mov    %edx,%esi
  800d0e:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d10:	5b                   	pop    %ebx
  800d11:	5e                   	pop    %esi
  800d12:	5f                   	pop    %edi
  800d13:	5d                   	pop    %ebp
  800d14:	c3                   	ret    

00800d15 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	57                   	push   %edi
  800d19:	56                   	push   %esi
  800d1a:	53                   	push   %ebx
  800d1b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d23:	8b 55 08             	mov    0x8(%ebp),%edx
  800d26:	b8 03 00 00 00       	mov    $0x3,%eax
  800d2b:	89 cb                	mov    %ecx,%ebx
  800d2d:	89 cf                	mov    %ecx,%edi
  800d2f:	89 ce                	mov    %ecx,%esi
  800d31:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d33:	85 c0                	test   %eax,%eax
  800d35:	7f 08                	jg     800d3f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3a:	5b                   	pop    %ebx
  800d3b:	5e                   	pop    %esi
  800d3c:	5f                   	pop    %edi
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3f:	83 ec 0c             	sub    $0xc,%esp
  800d42:	50                   	push   %eax
  800d43:	6a 03                	push   $0x3
  800d45:	68 e8 29 80 00       	push   $0x8029e8
  800d4a:	6a 43                	push   $0x43
  800d4c:	68 05 2a 80 00       	push   $0x802a05
  800d51:	e8 85 15 00 00       	call   8022db <_panic>

00800d56 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d56:	55                   	push   %ebp
  800d57:	89 e5                	mov    %esp,%ebp
  800d59:	57                   	push   %edi
  800d5a:	56                   	push   %esi
  800d5b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d5c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d61:	b8 02 00 00 00       	mov    $0x2,%eax
  800d66:	89 d1                	mov    %edx,%ecx
  800d68:	89 d3                	mov    %edx,%ebx
  800d6a:	89 d7                	mov    %edx,%edi
  800d6c:	89 d6                	mov    %edx,%esi
  800d6e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d70:	5b                   	pop    %ebx
  800d71:	5e                   	pop    %esi
  800d72:	5f                   	pop    %edi
  800d73:	5d                   	pop    %ebp
  800d74:	c3                   	ret    

00800d75 <sys_yield>:

void
sys_yield(void)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	57                   	push   %edi
  800d79:	56                   	push   %esi
  800d7a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d80:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d85:	89 d1                	mov    %edx,%ecx
  800d87:	89 d3                	mov    %edx,%ebx
  800d89:	89 d7                	mov    %edx,%edi
  800d8b:	89 d6                	mov    %edx,%esi
  800d8d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d8f:	5b                   	pop    %ebx
  800d90:	5e                   	pop    %esi
  800d91:	5f                   	pop    %edi
  800d92:	5d                   	pop    %ebp
  800d93:	c3                   	ret    

00800d94 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
  800d97:	57                   	push   %edi
  800d98:	56                   	push   %esi
  800d99:	53                   	push   %ebx
  800d9a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d9d:	be 00 00 00 00       	mov    $0x0,%esi
  800da2:	8b 55 08             	mov    0x8(%ebp),%edx
  800da5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da8:	b8 04 00 00 00       	mov    $0x4,%eax
  800dad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800db0:	89 f7                	mov    %esi,%edi
  800db2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db4:	85 c0                	test   %eax,%eax
  800db6:	7f 08                	jg     800dc0 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800db8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbb:	5b                   	pop    %ebx
  800dbc:	5e                   	pop    %esi
  800dbd:	5f                   	pop    %edi
  800dbe:	5d                   	pop    %ebp
  800dbf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc0:	83 ec 0c             	sub    $0xc,%esp
  800dc3:	50                   	push   %eax
  800dc4:	6a 04                	push   $0x4
  800dc6:	68 e8 29 80 00       	push   $0x8029e8
  800dcb:	6a 43                	push   $0x43
  800dcd:	68 05 2a 80 00       	push   $0x802a05
  800dd2:	e8 04 15 00 00       	call   8022db <_panic>

00800dd7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dd7:	55                   	push   %ebp
  800dd8:	89 e5                	mov    %esp,%ebp
  800dda:	57                   	push   %edi
  800ddb:	56                   	push   %esi
  800ddc:	53                   	push   %ebx
  800ddd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de0:	8b 55 08             	mov    0x8(%ebp),%edx
  800de3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de6:	b8 05 00 00 00       	mov    $0x5,%eax
  800deb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dee:	8b 7d 14             	mov    0x14(%ebp),%edi
  800df1:	8b 75 18             	mov    0x18(%ebp),%esi
  800df4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df6:	85 c0                	test   %eax,%eax
  800df8:	7f 08                	jg     800e02 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dfd:	5b                   	pop    %ebx
  800dfe:	5e                   	pop    %esi
  800dff:	5f                   	pop    %edi
  800e00:	5d                   	pop    %ebp
  800e01:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e02:	83 ec 0c             	sub    $0xc,%esp
  800e05:	50                   	push   %eax
  800e06:	6a 05                	push   $0x5
  800e08:	68 e8 29 80 00       	push   $0x8029e8
  800e0d:	6a 43                	push   $0x43
  800e0f:	68 05 2a 80 00       	push   $0x802a05
  800e14:	e8 c2 14 00 00       	call   8022db <_panic>

00800e19 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	57                   	push   %edi
  800e1d:	56                   	push   %esi
  800e1e:	53                   	push   %ebx
  800e1f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e22:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e27:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2d:	b8 06 00 00 00       	mov    $0x6,%eax
  800e32:	89 df                	mov    %ebx,%edi
  800e34:	89 de                	mov    %ebx,%esi
  800e36:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e38:	85 c0                	test   %eax,%eax
  800e3a:	7f 08                	jg     800e44 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e3f:	5b                   	pop    %ebx
  800e40:	5e                   	pop    %esi
  800e41:	5f                   	pop    %edi
  800e42:	5d                   	pop    %ebp
  800e43:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e44:	83 ec 0c             	sub    $0xc,%esp
  800e47:	50                   	push   %eax
  800e48:	6a 06                	push   $0x6
  800e4a:	68 e8 29 80 00       	push   $0x8029e8
  800e4f:	6a 43                	push   $0x43
  800e51:	68 05 2a 80 00       	push   $0x802a05
  800e56:	e8 80 14 00 00       	call   8022db <_panic>

00800e5b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	57                   	push   %edi
  800e5f:	56                   	push   %esi
  800e60:	53                   	push   %ebx
  800e61:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e64:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e69:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6f:	b8 08 00 00 00       	mov    $0x8,%eax
  800e74:	89 df                	mov    %ebx,%edi
  800e76:	89 de                	mov    %ebx,%esi
  800e78:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7a:	85 c0                	test   %eax,%eax
  800e7c:	7f 08                	jg     800e86 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e81:	5b                   	pop    %ebx
  800e82:	5e                   	pop    %esi
  800e83:	5f                   	pop    %edi
  800e84:	5d                   	pop    %ebp
  800e85:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e86:	83 ec 0c             	sub    $0xc,%esp
  800e89:	50                   	push   %eax
  800e8a:	6a 08                	push   $0x8
  800e8c:	68 e8 29 80 00       	push   $0x8029e8
  800e91:	6a 43                	push   $0x43
  800e93:	68 05 2a 80 00       	push   $0x802a05
  800e98:	e8 3e 14 00 00       	call   8022db <_panic>

00800e9d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e9d:	55                   	push   %ebp
  800e9e:	89 e5                	mov    %esp,%ebp
  800ea0:	57                   	push   %edi
  800ea1:	56                   	push   %esi
  800ea2:	53                   	push   %ebx
  800ea3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eab:	8b 55 08             	mov    0x8(%ebp),%edx
  800eae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb1:	b8 09 00 00 00       	mov    $0x9,%eax
  800eb6:	89 df                	mov    %ebx,%edi
  800eb8:	89 de                	mov    %ebx,%esi
  800eba:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebc:	85 c0                	test   %eax,%eax
  800ebe:	7f 08                	jg     800ec8 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ec0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec3:	5b                   	pop    %ebx
  800ec4:	5e                   	pop    %esi
  800ec5:	5f                   	pop    %edi
  800ec6:	5d                   	pop    %ebp
  800ec7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec8:	83 ec 0c             	sub    $0xc,%esp
  800ecb:	50                   	push   %eax
  800ecc:	6a 09                	push   $0x9
  800ece:	68 e8 29 80 00       	push   $0x8029e8
  800ed3:	6a 43                	push   $0x43
  800ed5:	68 05 2a 80 00       	push   $0x802a05
  800eda:	e8 fc 13 00 00       	call   8022db <_panic>

00800edf <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800edf:	55                   	push   %ebp
  800ee0:	89 e5                	mov    %esp,%ebp
  800ee2:	57                   	push   %edi
  800ee3:	56                   	push   %esi
  800ee4:	53                   	push   %ebx
  800ee5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eed:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ef8:	89 df                	mov    %ebx,%edi
  800efa:	89 de                	mov    %ebx,%esi
  800efc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800efe:	85 c0                	test   %eax,%eax
  800f00:	7f 08                	jg     800f0a <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f02:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f05:	5b                   	pop    %ebx
  800f06:	5e                   	pop    %esi
  800f07:	5f                   	pop    %edi
  800f08:	5d                   	pop    %ebp
  800f09:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f0a:	83 ec 0c             	sub    $0xc,%esp
  800f0d:	50                   	push   %eax
  800f0e:	6a 0a                	push   $0xa
  800f10:	68 e8 29 80 00       	push   $0x8029e8
  800f15:	6a 43                	push   $0x43
  800f17:	68 05 2a 80 00       	push   $0x802a05
  800f1c:	e8 ba 13 00 00       	call   8022db <_panic>

00800f21 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
  800f24:	57                   	push   %edi
  800f25:	56                   	push   %esi
  800f26:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f27:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f32:	be 00 00 00 00       	mov    $0x0,%esi
  800f37:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f3a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f3d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f3f:	5b                   	pop    %ebx
  800f40:	5e                   	pop    %esi
  800f41:	5f                   	pop    %edi
  800f42:	5d                   	pop    %ebp
  800f43:	c3                   	ret    

00800f44 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f44:	55                   	push   %ebp
  800f45:	89 e5                	mov    %esp,%ebp
  800f47:	57                   	push   %edi
  800f48:	56                   	push   %esi
  800f49:	53                   	push   %ebx
  800f4a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f4d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f52:	8b 55 08             	mov    0x8(%ebp),%edx
  800f55:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f5a:	89 cb                	mov    %ecx,%ebx
  800f5c:	89 cf                	mov    %ecx,%edi
  800f5e:	89 ce                	mov    %ecx,%esi
  800f60:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f62:	85 c0                	test   %eax,%eax
  800f64:	7f 08                	jg     800f6e <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f69:	5b                   	pop    %ebx
  800f6a:	5e                   	pop    %esi
  800f6b:	5f                   	pop    %edi
  800f6c:	5d                   	pop    %ebp
  800f6d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f6e:	83 ec 0c             	sub    $0xc,%esp
  800f71:	50                   	push   %eax
  800f72:	6a 0d                	push   $0xd
  800f74:	68 e8 29 80 00       	push   $0x8029e8
  800f79:	6a 43                	push   $0x43
  800f7b:	68 05 2a 80 00       	push   $0x802a05
  800f80:	e8 56 13 00 00       	call   8022db <_panic>

00800f85 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	57                   	push   %edi
  800f89:	56                   	push   %esi
  800f8a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f8b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f90:	8b 55 08             	mov    0x8(%ebp),%edx
  800f93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f96:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f9b:	89 df                	mov    %ebx,%edi
  800f9d:	89 de                	mov    %ebx,%esi
  800f9f:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fa1:	5b                   	pop    %ebx
  800fa2:	5e                   	pop    %esi
  800fa3:	5f                   	pop    %edi
  800fa4:	5d                   	pop    %ebp
  800fa5:	c3                   	ret    

00800fa6 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fa6:	55                   	push   %ebp
  800fa7:	89 e5                	mov    %esp,%ebp
  800fa9:	57                   	push   %edi
  800faa:	56                   	push   %esi
  800fab:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fac:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fb1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb4:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fb9:	89 cb                	mov    %ecx,%ebx
  800fbb:	89 cf                	mov    %ecx,%edi
  800fbd:	89 ce                	mov    %ecx,%esi
  800fbf:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fc1:	5b                   	pop    %ebx
  800fc2:	5e                   	pop    %esi
  800fc3:	5f                   	pop    %edi
  800fc4:	5d                   	pop    %ebp
  800fc5:	c3                   	ret    

00800fc6 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fc6:	55                   	push   %ebp
  800fc7:	89 e5                	mov    %esp,%ebp
  800fc9:	57                   	push   %edi
  800fca:	56                   	push   %esi
  800fcb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fcc:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd1:	b8 10 00 00 00       	mov    $0x10,%eax
  800fd6:	89 d1                	mov    %edx,%ecx
  800fd8:	89 d3                	mov    %edx,%ebx
  800fda:	89 d7                	mov    %edx,%edi
  800fdc:	89 d6                	mov    %edx,%esi
  800fde:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fe0:	5b                   	pop    %ebx
  800fe1:	5e                   	pop    %esi
  800fe2:	5f                   	pop    %edi
  800fe3:	5d                   	pop    %ebp
  800fe4:	c3                   	ret    

00800fe5 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
  800fe8:	57                   	push   %edi
  800fe9:	56                   	push   %esi
  800fea:	53                   	push   %ebx
	asm volatile("int %1\n"
  800feb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff6:	b8 11 00 00 00       	mov    $0x11,%eax
  800ffb:	89 df                	mov    %ebx,%edi
  800ffd:	89 de                	mov    %ebx,%esi
  800fff:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801001:	5b                   	pop    %ebx
  801002:	5e                   	pop    %esi
  801003:	5f                   	pop    %edi
  801004:	5d                   	pop    %ebp
  801005:	c3                   	ret    

00801006 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
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
  801017:	b8 12 00 00 00       	mov    $0x12,%eax
  80101c:	89 df                	mov    %ebx,%edi
  80101e:	89 de                	mov    %ebx,%esi
  801020:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801022:	5b                   	pop    %ebx
  801023:	5e                   	pop    %esi
  801024:	5f                   	pop    %edi
  801025:	5d                   	pop    %ebp
  801026:	c3                   	ret    

00801027 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801027:	55                   	push   %ebp
  801028:	89 e5                	mov    %esp,%ebp
  80102a:	57                   	push   %edi
  80102b:	56                   	push   %esi
  80102c:	53                   	push   %ebx
  80102d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801030:	bb 00 00 00 00       	mov    $0x0,%ebx
  801035:	8b 55 08             	mov    0x8(%ebp),%edx
  801038:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103b:	b8 13 00 00 00       	mov    $0x13,%eax
  801040:	89 df                	mov    %ebx,%edi
  801042:	89 de                	mov    %ebx,%esi
  801044:	cd 30                	int    $0x30
	if(check && ret > 0)
  801046:	85 c0                	test   %eax,%eax
  801048:	7f 08                	jg     801052 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80104a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80104d:	5b                   	pop    %ebx
  80104e:	5e                   	pop    %esi
  80104f:	5f                   	pop    %edi
  801050:	5d                   	pop    %ebp
  801051:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801052:	83 ec 0c             	sub    $0xc,%esp
  801055:	50                   	push   %eax
  801056:	6a 13                	push   $0x13
  801058:	68 e8 29 80 00       	push   $0x8029e8
  80105d:	6a 43                	push   $0x43
  80105f:	68 05 2a 80 00       	push   $0x802a05
  801064:	e8 72 12 00 00       	call   8022db <_panic>

00801069 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801069:	55                   	push   %ebp
  80106a:	89 e5                	mov    %esp,%ebp
  80106c:	57                   	push   %edi
  80106d:	56                   	push   %esi
  80106e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80106f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801074:	8b 55 08             	mov    0x8(%ebp),%edx
  801077:	b8 14 00 00 00       	mov    $0x14,%eax
  80107c:	89 cb                	mov    %ecx,%ebx
  80107e:	89 cf                	mov    %ecx,%edi
  801080:	89 ce                	mov    %ecx,%esi
  801082:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801084:	5b                   	pop    %ebx
  801085:	5e                   	pop    %esi
  801086:	5f                   	pop    %edi
  801087:	5d                   	pop    %ebp
  801088:	c3                   	ret    

00801089 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801089:	55                   	push   %ebp
  80108a:	89 e5                	mov    %esp,%ebp
  80108c:	56                   	push   %esi
  80108d:	53                   	push   %ebx
  80108e:	8b 75 08             	mov    0x8(%ebp),%esi
  801091:	8b 45 0c             	mov    0xc(%ebp),%eax
  801094:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  801097:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801099:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80109e:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8010a1:	83 ec 0c             	sub    $0xc,%esp
  8010a4:	50                   	push   %eax
  8010a5:	e8 9a fe ff ff       	call   800f44 <sys_ipc_recv>
	if(ret < 0){
  8010aa:	83 c4 10             	add    $0x10,%esp
  8010ad:	85 c0                	test   %eax,%eax
  8010af:	78 2b                	js     8010dc <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8010b1:	85 f6                	test   %esi,%esi
  8010b3:	74 0a                	je     8010bf <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8010b5:	a1 08 40 80 00       	mov    0x804008,%eax
  8010ba:	8b 40 74             	mov    0x74(%eax),%eax
  8010bd:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8010bf:	85 db                	test   %ebx,%ebx
  8010c1:	74 0a                	je     8010cd <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8010c3:	a1 08 40 80 00       	mov    0x804008,%eax
  8010c8:	8b 40 78             	mov    0x78(%eax),%eax
  8010cb:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8010cd:	a1 08 40 80 00       	mov    0x804008,%eax
  8010d2:	8b 40 70             	mov    0x70(%eax),%eax
}
  8010d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010d8:	5b                   	pop    %ebx
  8010d9:	5e                   	pop    %esi
  8010da:	5d                   	pop    %ebp
  8010db:	c3                   	ret    
		if(from_env_store)
  8010dc:	85 f6                	test   %esi,%esi
  8010de:	74 06                	je     8010e6 <ipc_recv+0x5d>
			*from_env_store = 0;
  8010e0:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8010e6:	85 db                	test   %ebx,%ebx
  8010e8:	74 eb                	je     8010d5 <ipc_recv+0x4c>
			*perm_store = 0;
  8010ea:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8010f0:	eb e3                	jmp    8010d5 <ipc_recv+0x4c>

008010f2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8010f2:	55                   	push   %ebp
  8010f3:	89 e5                	mov    %esp,%ebp
  8010f5:	57                   	push   %edi
  8010f6:	56                   	push   %esi
  8010f7:	53                   	push   %ebx
  8010f8:	83 ec 0c             	sub    $0xc,%esp
  8010fb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010fe:	8b 75 0c             	mov    0xc(%ebp),%esi
  801101:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801104:	85 db                	test   %ebx,%ebx
  801106:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80110b:	0f 44 d8             	cmove  %eax,%ebx
  80110e:	eb 05                	jmp    801115 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  801110:	e8 60 fc ff ff       	call   800d75 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  801115:	ff 75 14             	pushl  0x14(%ebp)
  801118:	53                   	push   %ebx
  801119:	56                   	push   %esi
  80111a:	57                   	push   %edi
  80111b:	e8 01 fe ff ff       	call   800f21 <sys_ipc_try_send>
  801120:	83 c4 10             	add    $0x10,%esp
  801123:	85 c0                	test   %eax,%eax
  801125:	74 1b                	je     801142 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  801127:	79 e7                	jns    801110 <ipc_send+0x1e>
  801129:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80112c:	74 e2                	je     801110 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80112e:	83 ec 04             	sub    $0x4,%esp
  801131:	68 13 2a 80 00       	push   $0x802a13
  801136:	6a 46                	push   $0x46
  801138:	68 28 2a 80 00       	push   $0x802a28
  80113d:	e8 99 11 00 00       	call   8022db <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801142:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801145:	5b                   	pop    %ebx
  801146:	5e                   	pop    %esi
  801147:	5f                   	pop    %edi
  801148:	5d                   	pop    %ebp
  801149:	c3                   	ret    

0080114a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801150:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801155:	89 c2                	mov    %eax,%edx
  801157:	c1 e2 07             	shl    $0x7,%edx
  80115a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801160:	8b 52 50             	mov    0x50(%edx),%edx
  801163:	39 ca                	cmp    %ecx,%edx
  801165:	74 11                	je     801178 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  801167:	83 c0 01             	add    $0x1,%eax
  80116a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80116f:	75 e4                	jne    801155 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801171:	b8 00 00 00 00       	mov    $0x0,%eax
  801176:	eb 0b                	jmp    801183 <ipc_find_env+0x39>
			return envs[i].env_id;
  801178:	c1 e0 07             	shl    $0x7,%eax
  80117b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801180:	8b 40 48             	mov    0x48(%eax),%eax
}
  801183:	5d                   	pop    %ebp
  801184:	c3                   	ret    

00801185 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801185:	55                   	push   %ebp
  801186:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	05 00 00 00 30       	add    $0x30000000,%eax
  801190:	c1 e8 0c             	shr    $0xc,%eax
}
  801193:	5d                   	pop    %ebp
  801194:	c3                   	ret    

00801195 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801195:	55                   	push   %ebp
  801196:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011a0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011a5:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011aa:	5d                   	pop    %ebp
  8011ab:	c3                   	ret    

008011ac <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011b4:	89 c2                	mov    %eax,%edx
  8011b6:	c1 ea 16             	shr    $0x16,%edx
  8011b9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011c0:	f6 c2 01             	test   $0x1,%dl
  8011c3:	74 2d                	je     8011f2 <fd_alloc+0x46>
  8011c5:	89 c2                	mov    %eax,%edx
  8011c7:	c1 ea 0c             	shr    $0xc,%edx
  8011ca:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011d1:	f6 c2 01             	test   $0x1,%dl
  8011d4:	74 1c                	je     8011f2 <fd_alloc+0x46>
  8011d6:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011db:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011e0:	75 d2                	jne    8011b4 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8011eb:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011f0:	eb 0a                	jmp    8011fc <fd_alloc+0x50>
			*fd_store = fd;
  8011f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011f5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011fc:	5d                   	pop    %ebp
  8011fd:	c3                   	ret    

008011fe <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
  801201:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801204:	83 f8 1f             	cmp    $0x1f,%eax
  801207:	77 30                	ja     801239 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801209:	c1 e0 0c             	shl    $0xc,%eax
  80120c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801211:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801217:	f6 c2 01             	test   $0x1,%dl
  80121a:	74 24                	je     801240 <fd_lookup+0x42>
  80121c:	89 c2                	mov    %eax,%edx
  80121e:	c1 ea 0c             	shr    $0xc,%edx
  801221:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801228:	f6 c2 01             	test   $0x1,%dl
  80122b:	74 1a                	je     801247 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80122d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801230:	89 02                	mov    %eax,(%edx)
	return 0;
  801232:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801237:	5d                   	pop    %ebp
  801238:	c3                   	ret    
		return -E_INVAL;
  801239:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80123e:	eb f7                	jmp    801237 <fd_lookup+0x39>
		return -E_INVAL;
  801240:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801245:	eb f0                	jmp    801237 <fd_lookup+0x39>
  801247:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80124c:	eb e9                	jmp    801237 <fd_lookup+0x39>

0080124e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	83 ec 08             	sub    $0x8,%esp
  801254:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801257:	ba 00 00 00 00       	mov    $0x0,%edx
  80125c:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801261:	39 08                	cmp    %ecx,(%eax)
  801263:	74 38                	je     80129d <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801265:	83 c2 01             	add    $0x1,%edx
  801268:	8b 04 95 b0 2a 80 00 	mov    0x802ab0(,%edx,4),%eax
  80126f:	85 c0                	test   %eax,%eax
  801271:	75 ee                	jne    801261 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801273:	a1 08 40 80 00       	mov    0x804008,%eax
  801278:	8b 40 48             	mov    0x48(%eax),%eax
  80127b:	83 ec 04             	sub    $0x4,%esp
  80127e:	51                   	push   %ecx
  80127f:	50                   	push   %eax
  801280:	68 34 2a 80 00       	push   $0x802a34
  801285:	e8 b9 ef ff ff       	call   800243 <cprintf>
	*dev = 0;
  80128a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801293:	83 c4 10             	add    $0x10,%esp
  801296:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80129b:	c9                   	leave  
  80129c:	c3                   	ret    
			*dev = devtab[i];
  80129d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a7:	eb f2                	jmp    80129b <dev_lookup+0x4d>

008012a9 <fd_close>:
{
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
  8012ac:	57                   	push   %edi
  8012ad:	56                   	push   %esi
  8012ae:	53                   	push   %ebx
  8012af:	83 ec 24             	sub    $0x24,%esp
  8012b2:	8b 75 08             	mov    0x8(%ebp),%esi
  8012b5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012b8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012bb:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012bc:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012c2:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012c5:	50                   	push   %eax
  8012c6:	e8 33 ff ff ff       	call   8011fe <fd_lookup>
  8012cb:	89 c3                	mov    %eax,%ebx
  8012cd:	83 c4 10             	add    $0x10,%esp
  8012d0:	85 c0                	test   %eax,%eax
  8012d2:	78 05                	js     8012d9 <fd_close+0x30>
	    || fd != fd2)
  8012d4:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012d7:	74 16                	je     8012ef <fd_close+0x46>
		return (must_exist ? r : 0);
  8012d9:	89 f8                	mov    %edi,%eax
  8012db:	84 c0                	test   %al,%al
  8012dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e2:	0f 44 d8             	cmove  %eax,%ebx
}
  8012e5:	89 d8                	mov    %ebx,%eax
  8012e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012ea:	5b                   	pop    %ebx
  8012eb:	5e                   	pop    %esi
  8012ec:	5f                   	pop    %edi
  8012ed:	5d                   	pop    %ebp
  8012ee:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012ef:	83 ec 08             	sub    $0x8,%esp
  8012f2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012f5:	50                   	push   %eax
  8012f6:	ff 36                	pushl  (%esi)
  8012f8:	e8 51 ff ff ff       	call   80124e <dev_lookup>
  8012fd:	89 c3                	mov    %eax,%ebx
  8012ff:	83 c4 10             	add    $0x10,%esp
  801302:	85 c0                	test   %eax,%eax
  801304:	78 1a                	js     801320 <fd_close+0x77>
		if (dev->dev_close)
  801306:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801309:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80130c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801311:	85 c0                	test   %eax,%eax
  801313:	74 0b                	je     801320 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801315:	83 ec 0c             	sub    $0xc,%esp
  801318:	56                   	push   %esi
  801319:	ff d0                	call   *%eax
  80131b:	89 c3                	mov    %eax,%ebx
  80131d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801320:	83 ec 08             	sub    $0x8,%esp
  801323:	56                   	push   %esi
  801324:	6a 00                	push   $0x0
  801326:	e8 ee fa ff ff       	call   800e19 <sys_page_unmap>
	return r;
  80132b:	83 c4 10             	add    $0x10,%esp
  80132e:	eb b5                	jmp    8012e5 <fd_close+0x3c>

00801330 <close>:

int
close(int fdnum)
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
  801333:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801336:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801339:	50                   	push   %eax
  80133a:	ff 75 08             	pushl  0x8(%ebp)
  80133d:	e8 bc fe ff ff       	call   8011fe <fd_lookup>
  801342:	83 c4 10             	add    $0x10,%esp
  801345:	85 c0                	test   %eax,%eax
  801347:	79 02                	jns    80134b <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801349:	c9                   	leave  
  80134a:	c3                   	ret    
		return fd_close(fd, 1);
  80134b:	83 ec 08             	sub    $0x8,%esp
  80134e:	6a 01                	push   $0x1
  801350:	ff 75 f4             	pushl  -0xc(%ebp)
  801353:	e8 51 ff ff ff       	call   8012a9 <fd_close>
  801358:	83 c4 10             	add    $0x10,%esp
  80135b:	eb ec                	jmp    801349 <close+0x19>

0080135d <close_all>:

void
close_all(void)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	53                   	push   %ebx
  801361:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801364:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801369:	83 ec 0c             	sub    $0xc,%esp
  80136c:	53                   	push   %ebx
  80136d:	e8 be ff ff ff       	call   801330 <close>
	for (i = 0; i < MAXFD; i++)
  801372:	83 c3 01             	add    $0x1,%ebx
  801375:	83 c4 10             	add    $0x10,%esp
  801378:	83 fb 20             	cmp    $0x20,%ebx
  80137b:	75 ec                	jne    801369 <close_all+0xc>
}
  80137d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801380:	c9                   	leave  
  801381:	c3                   	ret    

00801382 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801382:	55                   	push   %ebp
  801383:	89 e5                	mov    %esp,%ebp
  801385:	57                   	push   %edi
  801386:	56                   	push   %esi
  801387:	53                   	push   %ebx
  801388:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80138b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80138e:	50                   	push   %eax
  80138f:	ff 75 08             	pushl  0x8(%ebp)
  801392:	e8 67 fe ff ff       	call   8011fe <fd_lookup>
  801397:	89 c3                	mov    %eax,%ebx
  801399:	83 c4 10             	add    $0x10,%esp
  80139c:	85 c0                	test   %eax,%eax
  80139e:	0f 88 81 00 00 00    	js     801425 <dup+0xa3>
		return r;
	close(newfdnum);
  8013a4:	83 ec 0c             	sub    $0xc,%esp
  8013a7:	ff 75 0c             	pushl  0xc(%ebp)
  8013aa:	e8 81 ff ff ff       	call   801330 <close>

	newfd = INDEX2FD(newfdnum);
  8013af:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013b2:	c1 e6 0c             	shl    $0xc,%esi
  8013b5:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013bb:	83 c4 04             	add    $0x4,%esp
  8013be:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013c1:	e8 cf fd ff ff       	call   801195 <fd2data>
  8013c6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013c8:	89 34 24             	mov    %esi,(%esp)
  8013cb:	e8 c5 fd ff ff       	call   801195 <fd2data>
  8013d0:	83 c4 10             	add    $0x10,%esp
  8013d3:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013d5:	89 d8                	mov    %ebx,%eax
  8013d7:	c1 e8 16             	shr    $0x16,%eax
  8013da:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013e1:	a8 01                	test   $0x1,%al
  8013e3:	74 11                	je     8013f6 <dup+0x74>
  8013e5:	89 d8                	mov    %ebx,%eax
  8013e7:	c1 e8 0c             	shr    $0xc,%eax
  8013ea:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013f1:	f6 c2 01             	test   $0x1,%dl
  8013f4:	75 39                	jne    80142f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013f9:	89 d0                	mov    %edx,%eax
  8013fb:	c1 e8 0c             	shr    $0xc,%eax
  8013fe:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801405:	83 ec 0c             	sub    $0xc,%esp
  801408:	25 07 0e 00 00       	and    $0xe07,%eax
  80140d:	50                   	push   %eax
  80140e:	56                   	push   %esi
  80140f:	6a 00                	push   $0x0
  801411:	52                   	push   %edx
  801412:	6a 00                	push   $0x0
  801414:	e8 be f9 ff ff       	call   800dd7 <sys_page_map>
  801419:	89 c3                	mov    %eax,%ebx
  80141b:	83 c4 20             	add    $0x20,%esp
  80141e:	85 c0                	test   %eax,%eax
  801420:	78 31                	js     801453 <dup+0xd1>
		goto err;

	return newfdnum;
  801422:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801425:	89 d8                	mov    %ebx,%eax
  801427:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80142a:	5b                   	pop    %ebx
  80142b:	5e                   	pop    %esi
  80142c:	5f                   	pop    %edi
  80142d:	5d                   	pop    %ebp
  80142e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80142f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801436:	83 ec 0c             	sub    $0xc,%esp
  801439:	25 07 0e 00 00       	and    $0xe07,%eax
  80143e:	50                   	push   %eax
  80143f:	57                   	push   %edi
  801440:	6a 00                	push   $0x0
  801442:	53                   	push   %ebx
  801443:	6a 00                	push   $0x0
  801445:	e8 8d f9 ff ff       	call   800dd7 <sys_page_map>
  80144a:	89 c3                	mov    %eax,%ebx
  80144c:	83 c4 20             	add    $0x20,%esp
  80144f:	85 c0                	test   %eax,%eax
  801451:	79 a3                	jns    8013f6 <dup+0x74>
	sys_page_unmap(0, newfd);
  801453:	83 ec 08             	sub    $0x8,%esp
  801456:	56                   	push   %esi
  801457:	6a 00                	push   $0x0
  801459:	e8 bb f9 ff ff       	call   800e19 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80145e:	83 c4 08             	add    $0x8,%esp
  801461:	57                   	push   %edi
  801462:	6a 00                	push   $0x0
  801464:	e8 b0 f9 ff ff       	call   800e19 <sys_page_unmap>
	return r;
  801469:	83 c4 10             	add    $0x10,%esp
  80146c:	eb b7                	jmp    801425 <dup+0xa3>

0080146e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
  801471:	53                   	push   %ebx
  801472:	83 ec 1c             	sub    $0x1c,%esp
  801475:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801478:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80147b:	50                   	push   %eax
  80147c:	53                   	push   %ebx
  80147d:	e8 7c fd ff ff       	call   8011fe <fd_lookup>
  801482:	83 c4 10             	add    $0x10,%esp
  801485:	85 c0                	test   %eax,%eax
  801487:	78 3f                	js     8014c8 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801489:	83 ec 08             	sub    $0x8,%esp
  80148c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80148f:	50                   	push   %eax
  801490:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801493:	ff 30                	pushl  (%eax)
  801495:	e8 b4 fd ff ff       	call   80124e <dev_lookup>
  80149a:	83 c4 10             	add    $0x10,%esp
  80149d:	85 c0                	test   %eax,%eax
  80149f:	78 27                	js     8014c8 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014a4:	8b 42 08             	mov    0x8(%edx),%eax
  8014a7:	83 e0 03             	and    $0x3,%eax
  8014aa:	83 f8 01             	cmp    $0x1,%eax
  8014ad:	74 1e                	je     8014cd <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b2:	8b 40 08             	mov    0x8(%eax),%eax
  8014b5:	85 c0                	test   %eax,%eax
  8014b7:	74 35                	je     8014ee <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014b9:	83 ec 04             	sub    $0x4,%esp
  8014bc:	ff 75 10             	pushl  0x10(%ebp)
  8014bf:	ff 75 0c             	pushl  0xc(%ebp)
  8014c2:	52                   	push   %edx
  8014c3:	ff d0                	call   *%eax
  8014c5:	83 c4 10             	add    $0x10,%esp
}
  8014c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014cb:	c9                   	leave  
  8014cc:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014cd:	a1 08 40 80 00       	mov    0x804008,%eax
  8014d2:	8b 40 48             	mov    0x48(%eax),%eax
  8014d5:	83 ec 04             	sub    $0x4,%esp
  8014d8:	53                   	push   %ebx
  8014d9:	50                   	push   %eax
  8014da:	68 75 2a 80 00       	push   $0x802a75
  8014df:	e8 5f ed ff ff       	call   800243 <cprintf>
		return -E_INVAL;
  8014e4:	83 c4 10             	add    $0x10,%esp
  8014e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014ec:	eb da                	jmp    8014c8 <read+0x5a>
		return -E_NOT_SUPP;
  8014ee:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014f3:	eb d3                	jmp    8014c8 <read+0x5a>

008014f5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
  8014f8:	57                   	push   %edi
  8014f9:	56                   	push   %esi
  8014fa:	53                   	push   %ebx
  8014fb:	83 ec 0c             	sub    $0xc,%esp
  8014fe:	8b 7d 08             	mov    0x8(%ebp),%edi
  801501:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801504:	bb 00 00 00 00       	mov    $0x0,%ebx
  801509:	39 f3                	cmp    %esi,%ebx
  80150b:	73 23                	jae    801530 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80150d:	83 ec 04             	sub    $0x4,%esp
  801510:	89 f0                	mov    %esi,%eax
  801512:	29 d8                	sub    %ebx,%eax
  801514:	50                   	push   %eax
  801515:	89 d8                	mov    %ebx,%eax
  801517:	03 45 0c             	add    0xc(%ebp),%eax
  80151a:	50                   	push   %eax
  80151b:	57                   	push   %edi
  80151c:	e8 4d ff ff ff       	call   80146e <read>
		if (m < 0)
  801521:	83 c4 10             	add    $0x10,%esp
  801524:	85 c0                	test   %eax,%eax
  801526:	78 06                	js     80152e <readn+0x39>
			return m;
		if (m == 0)
  801528:	74 06                	je     801530 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80152a:	01 c3                	add    %eax,%ebx
  80152c:	eb db                	jmp    801509 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80152e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801530:	89 d8                	mov    %ebx,%eax
  801532:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801535:	5b                   	pop    %ebx
  801536:	5e                   	pop    %esi
  801537:	5f                   	pop    %edi
  801538:	5d                   	pop    %ebp
  801539:	c3                   	ret    

0080153a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	53                   	push   %ebx
  80153e:	83 ec 1c             	sub    $0x1c,%esp
  801541:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801544:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801547:	50                   	push   %eax
  801548:	53                   	push   %ebx
  801549:	e8 b0 fc ff ff       	call   8011fe <fd_lookup>
  80154e:	83 c4 10             	add    $0x10,%esp
  801551:	85 c0                	test   %eax,%eax
  801553:	78 3a                	js     80158f <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801555:	83 ec 08             	sub    $0x8,%esp
  801558:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80155b:	50                   	push   %eax
  80155c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155f:	ff 30                	pushl  (%eax)
  801561:	e8 e8 fc ff ff       	call   80124e <dev_lookup>
  801566:	83 c4 10             	add    $0x10,%esp
  801569:	85 c0                	test   %eax,%eax
  80156b:	78 22                	js     80158f <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80156d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801570:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801574:	74 1e                	je     801594 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801576:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801579:	8b 52 0c             	mov    0xc(%edx),%edx
  80157c:	85 d2                	test   %edx,%edx
  80157e:	74 35                	je     8015b5 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801580:	83 ec 04             	sub    $0x4,%esp
  801583:	ff 75 10             	pushl  0x10(%ebp)
  801586:	ff 75 0c             	pushl  0xc(%ebp)
  801589:	50                   	push   %eax
  80158a:	ff d2                	call   *%edx
  80158c:	83 c4 10             	add    $0x10,%esp
}
  80158f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801592:	c9                   	leave  
  801593:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801594:	a1 08 40 80 00       	mov    0x804008,%eax
  801599:	8b 40 48             	mov    0x48(%eax),%eax
  80159c:	83 ec 04             	sub    $0x4,%esp
  80159f:	53                   	push   %ebx
  8015a0:	50                   	push   %eax
  8015a1:	68 91 2a 80 00       	push   $0x802a91
  8015a6:	e8 98 ec ff ff       	call   800243 <cprintf>
		return -E_INVAL;
  8015ab:	83 c4 10             	add    $0x10,%esp
  8015ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015b3:	eb da                	jmp    80158f <write+0x55>
		return -E_NOT_SUPP;
  8015b5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015ba:	eb d3                	jmp    80158f <write+0x55>

008015bc <seek>:

int
seek(int fdnum, off_t offset)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
  8015bf:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c5:	50                   	push   %eax
  8015c6:	ff 75 08             	pushl  0x8(%ebp)
  8015c9:	e8 30 fc ff ff       	call   8011fe <fd_lookup>
  8015ce:	83 c4 10             	add    $0x10,%esp
  8015d1:	85 c0                	test   %eax,%eax
  8015d3:	78 0e                	js     8015e3 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015db:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e3:	c9                   	leave  
  8015e4:	c3                   	ret    

008015e5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
  8015e8:	53                   	push   %ebx
  8015e9:	83 ec 1c             	sub    $0x1c,%esp
  8015ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015f2:	50                   	push   %eax
  8015f3:	53                   	push   %ebx
  8015f4:	e8 05 fc ff ff       	call   8011fe <fd_lookup>
  8015f9:	83 c4 10             	add    $0x10,%esp
  8015fc:	85 c0                	test   %eax,%eax
  8015fe:	78 37                	js     801637 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801600:	83 ec 08             	sub    $0x8,%esp
  801603:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801606:	50                   	push   %eax
  801607:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160a:	ff 30                	pushl  (%eax)
  80160c:	e8 3d fc ff ff       	call   80124e <dev_lookup>
  801611:	83 c4 10             	add    $0x10,%esp
  801614:	85 c0                	test   %eax,%eax
  801616:	78 1f                	js     801637 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801618:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80161f:	74 1b                	je     80163c <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801621:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801624:	8b 52 18             	mov    0x18(%edx),%edx
  801627:	85 d2                	test   %edx,%edx
  801629:	74 32                	je     80165d <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80162b:	83 ec 08             	sub    $0x8,%esp
  80162e:	ff 75 0c             	pushl  0xc(%ebp)
  801631:	50                   	push   %eax
  801632:	ff d2                	call   *%edx
  801634:	83 c4 10             	add    $0x10,%esp
}
  801637:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    
			thisenv->env_id, fdnum);
  80163c:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801641:	8b 40 48             	mov    0x48(%eax),%eax
  801644:	83 ec 04             	sub    $0x4,%esp
  801647:	53                   	push   %ebx
  801648:	50                   	push   %eax
  801649:	68 54 2a 80 00       	push   $0x802a54
  80164e:	e8 f0 eb ff ff       	call   800243 <cprintf>
		return -E_INVAL;
  801653:	83 c4 10             	add    $0x10,%esp
  801656:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80165b:	eb da                	jmp    801637 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80165d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801662:	eb d3                	jmp    801637 <ftruncate+0x52>

00801664 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
  801667:	53                   	push   %ebx
  801668:	83 ec 1c             	sub    $0x1c,%esp
  80166b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80166e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801671:	50                   	push   %eax
  801672:	ff 75 08             	pushl  0x8(%ebp)
  801675:	e8 84 fb ff ff       	call   8011fe <fd_lookup>
  80167a:	83 c4 10             	add    $0x10,%esp
  80167d:	85 c0                	test   %eax,%eax
  80167f:	78 4b                	js     8016cc <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801681:	83 ec 08             	sub    $0x8,%esp
  801684:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801687:	50                   	push   %eax
  801688:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168b:	ff 30                	pushl  (%eax)
  80168d:	e8 bc fb ff ff       	call   80124e <dev_lookup>
  801692:	83 c4 10             	add    $0x10,%esp
  801695:	85 c0                	test   %eax,%eax
  801697:	78 33                	js     8016cc <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016a0:	74 2f                	je     8016d1 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016a2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016a5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016ac:	00 00 00 
	stat->st_isdir = 0;
  8016af:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016b6:	00 00 00 
	stat->st_dev = dev;
  8016b9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016bf:	83 ec 08             	sub    $0x8,%esp
  8016c2:	53                   	push   %ebx
  8016c3:	ff 75 f0             	pushl  -0x10(%ebp)
  8016c6:	ff 50 14             	call   *0x14(%eax)
  8016c9:	83 c4 10             	add    $0x10,%esp
}
  8016cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    
		return -E_NOT_SUPP;
  8016d1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016d6:	eb f4                	jmp    8016cc <fstat+0x68>

008016d8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
  8016db:	56                   	push   %esi
  8016dc:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016dd:	83 ec 08             	sub    $0x8,%esp
  8016e0:	6a 00                	push   $0x0
  8016e2:	ff 75 08             	pushl  0x8(%ebp)
  8016e5:	e8 22 02 00 00       	call   80190c <open>
  8016ea:	89 c3                	mov    %eax,%ebx
  8016ec:	83 c4 10             	add    $0x10,%esp
  8016ef:	85 c0                	test   %eax,%eax
  8016f1:	78 1b                	js     80170e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016f3:	83 ec 08             	sub    $0x8,%esp
  8016f6:	ff 75 0c             	pushl  0xc(%ebp)
  8016f9:	50                   	push   %eax
  8016fa:	e8 65 ff ff ff       	call   801664 <fstat>
  8016ff:	89 c6                	mov    %eax,%esi
	close(fd);
  801701:	89 1c 24             	mov    %ebx,(%esp)
  801704:	e8 27 fc ff ff       	call   801330 <close>
	return r;
  801709:	83 c4 10             	add    $0x10,%esp
  80170c:	89 f3                	mov    %esi,%ebx
}
  80170e:	89 d8                	mov    %ebx,%eax
  801710:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801713:	5b                   	pop    %ebx
  801714:	5e                   	pop    %esi
  801715:	5d                   	pop    %ebp
  801716:	c3                   	ret    

00801717 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	56                   	push   %esi
  80171b:	53                   	push   %ebx
  80171c:	89 c6                	mov    %eax,%esi
  80171e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801720:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801727:	74 27                	je     801750 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801729:	6a 07                	push   $0x7
  80172b:	68 00 50 80 00       	push   $0x805000
  801730:	56                   	push   %esi
  801731:	ff 35 00 40 80 00    	pushl  0x804000
  801737:	e8 b6 f9 ff ff       	call   8010f2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80173c:	83 c4 0c             	add    $0xc,%esp
  80173f:	6a 00                	push   $0x0
  801741:	53                   	push   %ebx
  801742:	6a 00                	push   $0x0
  801744:	e8 40 f9 ff ff       	call   801089 <ipc_recv>
}
  801749:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80174c:	5b                   	pop    %ebx
  80174d:	5e                   	pop    %esi
  80174e:	5d                   	pop    %ebp
  80174f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801750:	83 ec 0c             	sub    $0xc,%esp
  801753:	6a 01                	push   $0x1
  801755:	e8 f0 f9 ff ff       	call   80114a <ipc_find_env>
  80175a:	a3 00 40 80 00       	mov    %eax,0x804000
  80175f:	83 c4 10             	add    $0x10,%esp
  801762:	eb c5                	jmp    801729 <fsipc+0x12>

00801764 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
  801767:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	8b 40 0c             	mov    0xc(%eax),%eax
  801770:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801775:	8b 45 0c             	mov    0xc(%ebp),%eax
  801778:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80177d:	ba 00 00 00 00       	mov    $0x0,%edx
  801782:	b8 02 00 00 00       	mov    $0x2,%eax
  801787:	e8 8b ff ff ff       	call   801717 <fsipc>
}
  80178c:	c9                   	leave  
  80178d:	c3                   	ret    

0080178e <devfile_flush>:
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	8b 40 0c             	mov    0xc(%eax),%eax
  80179a:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80179f:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a4:	b8 06 00 00 00       	mov    $0x6,%eax
  8017a9:	e8 69 ff ff ff       	call   801717 <fsipc>
}
  8017ae:	c9                   	leave  
  8017af:	c3                   	ret    

008017b0 <devfile_stat>:
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
  8017b3:	53                   	push   %ebx
  8017b4:	83 ec 04             	sub    $0x4,%esp
  8017b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8017c0:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ca:	b8 05 00 00 00       	mov    $0x5,%eax
  8017cf:	e8 43 ff ff ff       	call   801717 <fsipc>
  8017d4:	85 c0                	test   %eax,%eax
  8017d6:	78 2c                	js     801804 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017d8:	83 ec 08             	sub    $0x8,%esp
  8017db:	68 00 50 80 00       	push   $0x805000
  8017e0:	53                   	push   %ebx
  8017e1:	e8 bc f1 ff ff       	call   8009a2 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017e6:	a1 80 50 80 00       	mov    0x805080,%eax
  8017eb:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017f1:	a1 84 50 80 00       	mov    0x805084,%eax
  8017f6:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017fc:	83 c4 10             	add    $0x10,%esp
  8017ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801804:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801807:	c9                   	leave  
  801808:	c3                   	ret    

00801809 <devfile_write>:
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
  80180c:	53                   	push   %ebx
  80180d:	83 ec 08             	sub    $0x8,%esp
  801810:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	8b 40 0c             	mov    0xc(%eax),%eax
  801819:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80181e:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801824:	53                   	push   %ebx
  801825:	ff 75 0c             	pushl  0xc(%ebp)
  801828:	68 08 50 80 00       	push   $0x805008
  80182d:	e8 60 f3 ff ff       	call   800b92 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801832:	ba 00 00 00 00       	mov    $0x0,%edx
  801837:	b8 04 00 00 00       	mov    $0x4,%eax
  80183c:	e8 d6 fe ff ff       	call   801717 <fsipc>
  801841:	83 c4 10             	add    $0x10,%esp
  801844:	85 c0                	test   %eax,%eax
  801846:	78 0b                	js     801853 <devfile_write+0x4a>
	assert(r <= n);
  801848:	39 d8                	cmp    %ebx,%eax
  80184a:	77 0c                	ja     801858 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80184c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801851:	7f 1e                	jg     801871 <devfile_write+0x68>
}
  801853:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801856:	c9                   	leave  
  801857:	c3                   	ret    
	assert(r <= n);
  801858:	68 c4 2a 80 00       	push   $0x802ac4
  80185d:	68 cb 2a 80 00       	push   $0x802acb
  801862:	68 98 00 00 00       	push   $0x98
  801867:	68 e0 2a 80 00       	push   $0x802ae0
  80186c:	e8 6a 0a 00 00       	call   8022db <_panic>
	assert(r <= PGSIZE);
  801871:	68 eb 2a 80 00       	push   $0x802aeb
  801876:	68 cb 2a 80 00       	push   $0x802acb
  80187b:	68 99 00 00 00       	push   $0x99
  801880:	68 e0 2a 80 00       	push   $0x802ae0
  801885:	e8 51 0a 00 00       	call   8022db <_panic>

0080188a <devfile_read>:
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
  80188d:	56                   	push   %esi
  80188e:	53                   	push   %ebx
  80188f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801892:	8b 45 08             	mov    0x8(%ebp),%eax
  801895:	8b 40 0c             	mov    0xc(%eax),%eax
  801898:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80189d:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a8:	b8 03 00 00 00       	mov    $0x3,%eax
  8018ad:	e8 65 fe ff ff       	call   801717 <fsipc>
  8018b2:	89 c3                	mov    %eax,%ebx
  8018b4:	85 c0                	test   %eax,%eax
  8018b6:	78 1f                	js     8018d7 <devfile_read+0x4d>
	assert(r <= n);
  8018b8:	39 f0                	cmp    %esi,%eax
  8018ba:	77 24                	ja     8018e0 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018bc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018c1:	7f 33                	jg     8018f6 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018c3:	83 ec 04             	sub    $0x4,%esp
  8018c6:	50                   	push   %eax
  8018c7:	68 00 50 80 00       	push   $0x805000
  8018cc:	ff 75 0c             	pushl  0xc(%ebp)
  8018cf:	e8 5c f2 ff ff       	call   800b30 <memmove>
	return r;
  8018d4:	83 c4 10             	add    $0x10,%esp
}
  8018d7:	89 d8                	mov    %ebx,%eax
  8018d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018dc:	5b                   	pop    %ebx
  8018dd:	5e                   	pop    %esi
  8018de:	5d                   	pop    %ebp
  8018df:	c3                   	ret    
	assert(r <= n);
  8018e0:	68 c4 2a 80 00       	push   $0x802ac4
  8018e5:	68 cb 2a 80 00       	push   $0x802acb
  8018ea:	6a 7c                	push   $0x7c
  8018ec:	68 e0 2a 80 00       	push   $0x802ae0
  8018f1:	e8 e5 09 00 00       	call   8022db <_panic>
	assert(r <= PGSIZE);
  8018f6:	68 eb 2a 80 00       	push   $0x802aeb
  8018fb:	68 cb 2a 80 00       	push   $0x802acb
  801900:	6a 7d                	push   $0x7d
  801902:	68 e0 2a 80 00       	push   $0x802ae0
  801907:	e8 cf 09 00 00       	call   8022db <_panic>

0080190c <open>:
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
  80190f:	56                   	push   %esi
  801910:	53                   	push   %ebx
  801911:	83 ec 1c             	sub    $0x1c,%esp
  801914:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801917:	56                   	push   %esi
  801918:	e8 4c f0 ff ff       	call   800969 <strlen>
  80191d:	83 c4 10             	add    $0x10,%esp
  801920:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801925:	7f 6c                	jg     801993 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801927:	83 ec 0c             	sub    $0xc,%esp
  80192a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80192d:	50                   	push   %eax
  80192e:	e8 79 f8 ff ff       	call   8011ac <fd_alloc>
  801933:	89 c3                	mov    %eax,%ebx
  801935:	83 c4 10             	add    $0x10,%esp
  801938:	85 c0                	test   %eax,%eax
  80193a:	78 3c                	js     801978 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80193c:	83 ec 08             	sub    $0x8,%esp
  80193f:	56                   	push   %esi
  801940:	68 00 50 80 00       	push   $0x805000
  801945:	e8 58 f0 ff ff       	call   8009a2 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80194a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80194d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801952:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801955:	b8 01 00 00 00       	mov    $0x1,%eax
  80195a:	e8 b8 fd ff ff       	call   801717 <fsipc>
  80195f:	89 c3                	mov    %eax,%ebx
  801961:	83 c4 10             	add    $0x10,%esp
  801964:	85 c0                	test   %eax,%eax
  801966:	78 19                	js     801981 <open+0x75>
	return fd2num(fd);
  801968:	83 ec 0c             	sub    $0xc,%esp
  80196b:	ff 75 f4             	pushl  -0xc(%ebp)
  80196e:	e8 12 f8 ff ff       	call   801185 <fd2num>
  801973:	89 c3                	mov    %eax,%ebx
  801975:	83 c4 10             	add    $0x10,%esp
}
  801978:	89 d8                	mov    %ebx,%eax
  80197a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80197d:	5b                   	pop    %ebx
  80197e:	5e                   	pop    %esi
  80197f:	5d                   	pop    %ebp
  801980:	c3                   	ret    
		fd_close(fd, 0);
  801981:	83 ec 08             	sub    $0x8,%esp
  801984:	6a 00                	push   $0x0
  801986:	ff 75 f4             	pushl  -0xc(%ebp)
  801989:	e8 1b f9 ff ff       	call   8012a9 <fd_close>
		return r;
  80198e:	83 c4 10             	add    $0x10,%esp
  801991:	eb e5                	jmp    801978 <open+0x6c>
		return -E_BAD_PATH;
  801993:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801998:	eb de                	jmp    801978 <open+0x6c>

0080199a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a5:	b8 08 00 00 00       	mov    $0x8,%eax
  8019aa:	e8 68 fd ff ff       	call   801717 <fsipc>
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8019b7:	68 f7 2a 80 00       	push   $0x802af7
  8019bc:	ff 75 0c             	pushl  0xc(%ebp)
  8019bf:	e8 de ef ff ff       	call   8009a2 <strcpy>
	return 0;
}
  8019c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c9:	c9                   	leave  
  8019ca:	c3                   	ret    

008019cb <devsock_close>:
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
  8019ce:	53                   	push   %ebx
  8019cf:	83 ec 10             	sub    $0x10,%esp
  8019d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8019d5:	53                   	push   %ebx
  8019d6:	e8 61 09 00 00       	call   80233c <pageref>
  8019db:	83 c4 10             	add    $0x10,%esp
		return 0;
  8019de:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8019e3:	83 f8 01             	cmp    $0x1,%eax
  8019e6:	74 07                	je     8019ef <devsock_close+0x24>
}
  8019e8:	89 d0                	mov    %edx,%eax
  8019ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8019ef:	83 ec 0c             	sub    $0xc,%esp
  8019f2:	ff 73 0c             	pushl  0xc(%ebx)
  8019f5:	e8 b9 02 00 00       	call   801cb3 <nsipc_close>
  8019fa:	89 c2                	mov    %eax,%edx
  8019fc:	83 c4 10             	add    $0x10,%esp
  8019ff:	eb e7                	jmp    8019e8 <devsock_close+0x1d>

00801a01 <devsock_write>:
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a07:	6a 00                	push   $0x0
  801a09:	ff 75 10             	pushl  0x10(%ebp)
  801a0c:	ff 75 0c             	pushl  0xc(%ebp)
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	ff 70 0c             	pushl  0xc(%eax)
  801a15:	e8 76 03 00 00       	call   801d90 <nsipc_send>
}
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <devsock_read>:
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
  801a1f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a22:	6a 00                	push   $0x0
  801a24:	ff 75 10             	pushl  0x10(%ebp)
  801a27:	ff 75 0c             	pushl  0xc(%ebp)
  801a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2d:	ff 70 0c             	pushl  0xc(%eax)
  801a30:	e8 ef 02 00 00       	call   801d24 <nsipc_recv>
}
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <fd2sockid>:
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
  801a3a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a3d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a40:	52                   	push   %edx
  801a41:	50                   	push   %eax
  801a42:	e8 b7 f7 ff ff       	call   8011fe <fd_lookup>
  801a47:	83 c4 10             	add    $0x10,%esp
  801a4a:	85 c0                	test   %eax,%eax
  801a4c:	78 10                	js     801a5e <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a51:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a57:	39 08                	cmp    %ecx,(%eax)
  801a59:	75 05                	jne    801a60 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a5b:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    
		return -E_NOT_SUPP;
  801a60:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a65:	eb f7                	jmp    801a5e <fd2sockid+0x27>

00801a67 <alloc_sockfd>:
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	56                   	push   %esi
  801a6b:	53                   	push   %ebx
  801a6c:	83 ec 1c             	sub    $0x1c,%esp
  801a6f:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a71:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a74:	50                   	push   %eax
  801a75:	e8 32 f7 ff ff       	call   8011ac <fd_alloc>
  801a7a:	89 c3                	mov    %eax,%ebx
  801a7c:	83 c4 10             	add    $0x10,%esp
  801a7f:	85 c0                	test   %eax,%eax
  801a81:	78 43                	js     801ac6 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a83:	83 ec 04             	sub    $0x4,%esp
  801a86:	68 07 04 00 00       	push   $0x407
  801a8b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a8e:	6a 00                	push   $0x0
  801a90:	e8 ff f2 ff ff       	call   800d94 <sys_page_alloc>
  801a95:	89 c3                	mov    %eax,%ebx
  801a97:	83 c4 10             	add    $0x10,%esp
  801a9a:	85 c0                	test   %eax,%eax
  801a9c:	78 28                	js     801ac6 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa1:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801aa7:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aac:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ab3:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ab6:	83 ec 0c             	sub    $0xc,%esp
  801ab9:	50                   	push   %eax
  801aba:	e8 c6 f6 ff ff       	call   801185 <fd2num>
  801abf:	89 c3                	mov    %eax,%ebx
  801ac1:	83 c4 10             	add    $0x10,%esp
  801ac4:	eb 0c                	jmp    801ad2 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801ac6:	83 ec 0c             	sub    $0xc,%esp
  801ac9:	56                   	push   %esi
  801aca:	e8 e4 01 00 00       	call   801cb3 <nsipc_close>
		return r;
  801acf:	83 c4 10             	add    $0x10,%esp
}
  801ad2:	89 d8                	mov    %ebx,%eax
  801ad4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ad7:	5b                   	pop    %ebx
  801ad8:	5e                   	pop    %esi
  801ad9:	5d                   	pop    %ebp
  801ada:	c3                   	ret    

00801adb <accept>:
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	e8 4e ff ff ff       	call   801a37 <fd2sockid>
  801ae9:	85 c0                	test   %eax,%eax
  801aeb:	78 1b                	js     801b08 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801aed:	83 ec 04             	sub    $0x4,%esp
  801af0:	ff 75 10             	pushl  0x10(%ebp)
  801af3:	ff 75 0c             	pushl  0xc(%ebp)
  801af6:	50                   	push   %eax
  801af7:	e8 0e 01 00 00       	call   801c0a <nsipc_accept>
  801afc:	83 c4 10             	add    $0x10,%esp
  801aff:	85 c0                	test   %eax,%eax
  801b01:	78 05                	js     801b08 <accept+0x2d>
	return alloc_sockfd(r);
  801b03:	e8 5f ff ff ff       	call   801a67 <alloc_sockfd>
}
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <bind>:
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	e8 1f ff ff ff       	call   801a37 <fd2sockid>
  801b18:	85 c0                	test   %eax,%eax
  801b1a:	78 12                	js     801b2e <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801b1c:	83 ec 04             	sub    $0x4,%esp
  801b1f:	ff 75 10             	pushl  0x10(%ebp)
  801b22:	ff 75 0c             	pushl  0xc(%ebp)
  801b25:	50                   	push   %eax
  801b26:	e8 31 01 00 00       	call   801c5c <nsipc_bind>
  801b2b:	83 c4 10             	add    $0x10,%esp
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <shutdown>:
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b36:	8b 45 08             	mov    0x8(%ebp),%eax
  801b39:	e8 f9 fe ff ff       	call   801a37 <fd2sockid>
  801b3e:	85 c0                	test   %eax,%eax
  801b40:	78 0f                	js     801b51 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801b42:	83 ec 08             	sub    $0x8,%esp
  801b45:	ff 75 0c             	pushl  0xc(%ebp)
  801b48:	50                   	push   %eax
  801b49:	e8 43 01 00 00       	call   801c91 <nsipc_shutdown>
  801b4e:	83 c4 10             	add    $0x10,%esp
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <connect>:
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b59:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5c:	e8 d6 fe ff ff       	call   801a37 <fd2sockid>
  801b61:	85 c0                	test   %eax,%eax
  801b63:	78 12                	js     801b77 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b65:	83 ec 04             	sub    $0x4,%esp
  801b68:	ff 75 10             	pushl  0x10(%ebp)
  801b6b:	ff 75 0c             	pushl  0xc(%ebp)
  801b6e:	50                   	push   %eax
  801b6f:	e8 59 01 00 00       	call   801ccd <nsipc_connect>
  801b74:	83 c4 10             	add    $0x10,%esp
}
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <listen>:
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
  801b7c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	e8 b0 fe ff ff       	call   801a37 <fd2sockid>
  801b87:	85 c0                	test   %eax,%eax
  801b89:	78 0f                	js     801b9a <listen+0x21>
	return nsipc_listen(r, backlog);
  801b8b:	83 ec 08             	sub    $0x8,%esp
  801b8e:	ff 75 0c             	pushl  0xc(%ebp)
  801b91:	50                   	push   %eax
  801b92:	e8 6b 01 00 00       	call   801d02 <nsipc_listen>
  801b97:	83 c4 10             	add    $0x10,%esp
}
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <socket>:

int
socket(int domain, int type, int protocol)
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
  801b9f:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ba2:	ff 75 10             	pushl  0x10(%ebp)
  801ba5:	ff 75 0c             	pushl  0xc(%ebp)
  801ba8:	ff 75 08             	pushl  0x8(%ebp)
  801bab:	e8 3e 02 00 00       	call   801dee <nsipc_socket>
  801bb0:	83 c4 10             	add    $0x10,%esp
  801bb3:	85 c0                	test   %eax,%eax
  801bb5:	78 05                	js     801bbc <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801bb7:	e8 ab fe ff ff       	call   801a67 <alloc_sockfd>
}
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    

00801bbe <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
  801bc1:	53                   	push   %ebx
  801bc2:	83 ec 04             	sub    $0x4,%esp
  801bc5:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801bc7:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801bce:	74 26                	je     801bf6 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801bd0:	6a 07                	push   $0x7
  801bd2:	68 00 60 80 00       	push   $0x806000
  801bd7:	53                   	push   %ebx
  801bd8:	ff 35 04 40 80 00    	pushl  0x804004
  801bde:	e8 0f f5 ff ff       	call   8010f2 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801be3:	83 c4 0c             	add    $0xc,%esp
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	e8 98 f4 ff ff       	call   801089 <ipc_recv>
}
  801bf1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801bf6:	83 ec 0c             	sub    $0xc,%esp
  801bf9:	6a 02                	push   $0x2
  801bfb:	e8 4a f5 ff ff       	call   80114a <ipc_find_env>
  801c00:	a3 04 40 80 00       	mov    %eax,0x804004
  801c05:	83 c4 10             	add    $0x10,%esp
  801c08:	eb c6                	jmp    801bd0 <nsipc+0x12>

00801c0a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
  801c0d:	56                   	push   %esi
  801c0e:	53                   	push   %ebx
  801c0f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c12:	8b 45 08             	mov    0x8(%ebp),%eax
  801c15:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c1a:	8b 06                	mov    (%esi),%eax
  801c1c:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c21:	b8 01 00 00 00       	mov    $0x1,%eax
  801c26:	e8 93 ff ff ff       	call   801bbe <nsipc>
  801c2b:	89 c3                	mov    %eax,%ebx
  801c2d:	85 c0                	test   %eax,%eax
  801c2f:	79 09                	jns    801c3a <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801c31:	89 d8                	mov    %ebx,%eax
  801c33:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c36:	5b                   	pop    %ebx
  801c37:	5e                   	pop    %esi
  801c38:	5d                   	pop    %ebp
  801c39:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c3a:	83 ec 04             	sub    $0x4,%esp
  801c3d:	ff 35 10 60 80 00    	pushl  0x806010
  801c43:	68 00 60 80 00       	push   $0x806000
  801c48:	ff 75 0c             	pushl  0xc(%ebp)
  801c4b:	e8 e0 ee ff ff       	call   800b30 <memmove>
		*addrlen = ret->ret_addrlen;
  801c50:	a1 10 60 80 00       	mov    0x806010,%eax
  801c55:	89 06                	mov    %eax,(%esi)
  801c57:	83 c4 10             	add    $0x10,%esp
	return r;
  801c5a:	eb d5                	jmp    801c31 <nsipc_accept+0x27>

00801c5c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
  801c5f:	53                   	push   %ebx
  801c60:	83 ec 08             	sub    $0x8,%esp
  801c63:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c6e:	53                   	push   %ebx
  801c6f:	ff 75 0c             	pushl  0xc(%ebp)
  801c72:	68 04 60 80 00       	push   $0x806004
  801c77:	e8 b4 ee ff ff       	call   800b30 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c7c:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c82:	b8 02 00 00 00       	mov    $0x2,%eax
  801c87:	e8 32 ff ff ff       	call   801bbe <nsipc>
}
  801c8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
  801c94:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c97:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca2:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ca7:	b8 03 00 00 00       	mov    $0x3,%eax
  801cac:	e8 0d ff ff ff       	call   801bbe <nsipc>
}
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <nsipc_close>:

int
nsipc_close(int s)
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbc:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801cc1:	b8 04 00 00 00       	mov    $0x4,%eax
  801cc6:	e8 f3 fe ff ff       	call   801bbe <nsipc>
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
  801cd0:	53                   	push   %ebx
  801cd1:	83 ec 08             	sub    $0x8,%esp
  801cd4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cda:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801cdf:	53                   	push   %ebx
  801ce0:	ff 75 0c             	pushl  0xc(%ebp)
  801ce3:	68 04 60 80 00       	push   $0x806004
  801ce8:	e8 43 ee ff ff       	call   800b30 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801ced:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801cf3:	b8 05 00 00 00       	mov    $0x5,%eax
  801cf8:	e8 c1 fe ff ff       	call   801bbe <nsipc>
}
  801cfd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
  801d05:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d08:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d13:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d18:	b8 06 00 00 00       	mov    $0x6,%eax
  801d1d:	e8 9c fe ff ff       	call   801bbe <nsipc>
}
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
  801d27:	56                   	push   %esi
  801d28:	53                   	push   %ebx
  801d29:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d34:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d3a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d3d:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d42:	b8 07 00 00 00       	mov    $0x7,%eax
  801d47:	e8 72 fe ff ff       	call   801bbe <nsipc>
  801d4c:	89 c3                	mov    %eax,%ebx
  801d4e:	85 c0                	test   %eax,%eax
  801d50:	78 1f                	js     801d71 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d52:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d57:	7f 21                	jg     801d7a <nsipc_recv+0x56>
  801d59:	39 c6                	cmp    %eax,%esi
  801d5b:	7c 1d                	jl     801d7a <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d5d:	83 ec 04             	sub    $0x4,%esp
  801d60:	50                   	push   %eax
  801d61:	68 00 60 80 00       	push   $0x806000
  801d66:	ff 75 0c             	pushl  0xc(%ebp)
  801d69:	e8 c2 ed ff ff       	call   800b30 <memmove>
  801d6e:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d71:	89 d8                	mov    %ebx,%eax
  801d73:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d76:	5b                   	pop    %ebx
  801d77:	5e                   	pop    %esi
  801d78:	5d                   	pop    %ebp
  801d79:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d7a:	68 03 2b 80 00       	push   $0x802b03
  801d7f:	68 cb 2a 80 00       	push   $0x802acb
  801d84:	6a 62                	push   $0x62
  801d86:	68 18 2b 80 00       	push   $0x802b18
  801d8b:	e8 4b 05 00 00       	call   8022db <_panic>

00801d90 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	53                   	push   %ebx
  801d94:	83 ec 04             	sub    $0x4,%esp
  801d97:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9d:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801da2:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801da8:	7f 2e                	jg     801dd8 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801daa:	83 ec 04             	sub    $0x4,%esp
  801dad:	53                   	push   %ebx
  801dae:	ff 75 0c             	pushl  0xc(%ebp)
  801db1:	68 0c 60 80 00       	push   $0x80600c
  801db6:	e8 75 ed ff ff       	call   800b30 <memmove>
	nsipcbuf.send.req_size = size;
  801dbb:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801dc1:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc4:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801dc9:	b8 08 00 00 00       	mov    $0x8,%eax
  801dce:	e8 eb fd ff ff       	call   801bbe <nsipc>
}
  801dd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dd6:	c9                   	leave  
  801dd7:	c3                   	ret    
	assert(size < 1600);
  801dd8:	68 24 2b 80 00       	push   $0x802b24
  801ddd:	68 cb 2a 80 00       	push   $0x802acb
  801de2:	6a 6d                	push   $0x6d
  801de4:	68 18 2b 80 00       	push   $0x802b18
  801de9:	e8 ed 04 00 00       	call   8022db <_panic>

00801dee <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
  801df1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801df4:	8b 45 08             	mov    0x8(%ebp),%eax
  801df7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dff:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e04:	8b 45 10             	mov    0x10(%ebp),%eax
  801e07:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e0c:	b8 09 00 00 00       	mov    $0x9,%eax
  801e11:	e8 a8 fd ff ff       	call   801bbe <nsipc>
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	56                   	push   %esi
  801e1c:	53                   	push   %ebx
  801e1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e20:	83 ec 0c             	sub    $0xc,%esp
  801e23:	ff 75 08             	pushl  0x8(%ebp)
  801e26:	e8 6a f3 ff ff       	call   801195 <fd2data>
  801e2b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e2d:	83 c4 08             	add    $0x8,%esp
  801e30:	68 30 2b 80 00       	push   $0x802b30
  801e35:	53                   	push   %ebx
  801e36:	e8 67 eb ff ff       	call   8009a2 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e3b:	8b 46 04             	mov    0x4(%esi),%eax
  801e3e:	2b 06                	sub    (%esi),%eax
  801e40:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e46:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e4d:	00 00 00 
	stat->st_dev = &devpipe;
  801e50:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801e57:	30 80 00 
	return 0;
}
  801e5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e62:	5b                   	pop    %ebx
  801e63:	5e                   	pop    %esi
  801e64:	5d                   	pop    %ebp
  801e65:	c3                   	ret    

00801e66 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	53                   	push   %ebx
  801e6a:	83 ec 0c             	sub    $0xc,%esp
  801e6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e70:	53                   	push   %ebx
  801e71:	6a 00                	push   $0x0
  801e73:	e8 a1 ef ff ff       	call   800e19 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e78:	89 1c 24             	mov    %ebx,(%esp)
  801e7b:	e8 15 f3 ff ff       	call   801195 <fd2data>
  801e80:	83 c4 08             	add    $0x8,%esp
  801e83:	50                   	push   %eax
  801e84:	6a 00                	push   $0x0
  801e86:	e8 8e ef ff ff       	call   800e19 <sys_page_unmap>
}
  801e8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e8e:	c9                   	leave  
  801e8f:	c3                   	ret    

00801e90 <_pipeisclosed>:
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	57                   	push   %edi
  801e94:	56                   	push   %esi
  801e95:	53                   	push   %ebx
  801e96:	83 ec 1c             	sub    $0x1c,%esp
  801e99:	89 c7                	mov    %eax,%edi
  801e9b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e9d:	a1 08 40 80 00       	mov    0x804008,%eax
  801ea2:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ea5:	83 ec 0c             	sub    $0xc,%esp
  801ea8:	57                   	push   %edi
  801ea9:	e8 8e 04 00 00       	call   80233c <pageref>
  801eae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801eb1:	89 34 24             	mov    %esi,(%esp)
  801eb4:	e8 83 04 00 00       	call   80233c <pageref>
		nn = thisenv->env_runs;
  801eb9:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ebf:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ec2:	83 c4 10             	add    $0x10,%esp
  801ec5:	39 cb                	cmp    %ecx,%ebx
  801ec7:	74 1b                	je     801ee4 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ec9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ecc:	75 cf                	jne    801e9d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ece:	8b 42 58             	mov    0x58(%edx),%eax
  801ed1:	6a 01                	push   $0x1
  801ed3:	50                   	push   %eax
  801ed4:	53                   	push   %ebx
  801ed5:	68 37 2b 80 00       	push   $0x802b37
  801eda:	e8 64 e3 ff ff       	call   800243 <cprintf>
  801edf:	83 c4 10             	add    $0x10,%esp
  801ee2:	eb b9                	jmp    801e9d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801ee4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ee7:	0f 94 c0             	sete   %al
  801eea:	0f b6 c0             	movzbl %al,%eax
}
  801eed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ef0:	5b                   	pop    %ebx
  801ef1:	5e                   	pop    %esi
  801ef2:	5f                   	pop    %edi
  801ef3:	5d                   	pop    %ebp
  801ef4:	c3                   	ret    

00801ef5 <devpipe_write>:
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
  801ef8:	57                   	push   %edi
  801ef9:	56                   	push   %esi
  801efa:	53                   	push   %ebx
  801efb:	83 ec 28             	sub    $0x28,%esp
  801efe:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f01:	56                   	push   %esi
  801f02:	e8 8e f2 ff ff       	call   801195 <fd2data>
  801f07:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f09:	83 c4 10             	add    $0x10,%esp
  801f0c:	bf 00 00 00 00       	mov    $0x0,%edi
  801f11:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f14:	74 4f                	je     801f65 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f16:	8b 43 04             	mov    0x4(%ebx),%eax
  801f19:	8b 0b                	mov    (%ebx),%ecx
  801f1b:	8d 51 20             	lea    0x20(%ecx),%edx
  801f1e:	39 d0                	cmp    %edx,%eax
  801f20:	72 14                	jb     801f36 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801f22:	89 da                	mov    %ebx,%edx
  801f24:	89 f0                	mov    %esi,%eax
  801f26:	e8 65 ff ff ff       	call   801e90 <_pipeisclosed>
  801f2b:	85 c0                	test   %eax,%eax
  801f2d:	75 3b                	jne    801f6a <devpipe_write+0x75>
			sys_yield();
  801f2f:	e8 41 ee ff ff       	call   800d75 <sys_yield>
  801f34:	eb e0                	jmp    801f16 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f39:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f3d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f40:	89 c2                	mov    %eax,%edx
  801f42:	c1 fa 1f             	sar    $0x1f,%edx
  801f45:	89 d1                	mov    %edx,%ecx
  801f47:	c1 e9 1b             	shr    $0x1b,%ecx
  801f4a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801f4d:	83 e2 1f             	and    $0x1f,%edx
  801f50:	29 ca                	sub    %ecx,%edx
  801f52:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f56:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f5a:	83 c0 01             	add    $0x1,%eax
  801f5d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f60:	83 c7 01             	add    $0x1,%edi
  801f63:	eb ac                	jmp    801f11 <devpipe_write+0x1c>
	return i;
  801f65:	8b 45 10             	mov    0x10(%ebp),%eax
  801f68:	eb 05                	jmp    801f6f <devpipe_write+0x7a>
				return 0;
  801f6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f72:	5b                   	pop    %ebx
  801f73:	5e                   	pop    %esi
  801f74:	5f                   	pop    %edi
  801f75:	5d                   	pop    %ebp
  801f76:	c3                   	ret    

00801f77 <devpipe_read>:
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
  801f7a:	57                   	push   %edi
  801f7b:	56                   	push   %esi
  801f7c:	53                   	push   %ebx
  801f7d:	83 ec 18             	sub    $0x18,%esp
  801f80:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f83:	57                   	push   %edi
  801f84:	e8 0c f2 ff ff       	call   801195 <fd2data>
  801f89:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f8b:	83 c4 10             	add    $0x10,%esp
  801f8e:	be 00 00 00 00       	mov    $0x0,%esi
  801f93:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f96:	75 14                	jne    801fac <devpipe_read+0x35>
	return i;
  801f98:	8b 45 10             	mov    0x10(%ebp),%eax
  801f9b:	eb 02                	jmp    801f9f <devpipe_read+0x28>
				return i;
  801f9d:	89 f0                	mov    %esi,%eax
}
  801f9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fa2:	5b                   	pop    %ebx
  801fa3:	5e                   	pop    %esi
  801fa4:	5f                   	pop    %edi
  801fa5:	5d                   	pop    %ebp
  801fa6:	c3                   	ret    
			sys_yield();
  801fa7:	e8 c9 ed ff ff       	call   800d75 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801fac:	8b 03                	mov    (%ebx),%eax
  801fae:	3b 43 04             	cmp    0x4(%ebx),%eax
  801fb1:	75 18                	jne    801fcb <devpipe_read+0x54>
			if (i > 0)
  801fb3:	85 f6                	test   %esi,%esi
  801fb5:	75 e6                	jne    801f9d <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801fb7:	89 da                	mov    %ebx,%edx
  801fb9:	89 f8                	mov    %edi,%eax
  801fbb:	e8 d0 fe ff ff       	call   801e90 <_pipeisclosed>
  801fc0:	85 c0                	test   %eax,%eax
  801fc2:	74 e3                	je     801fa7 <devpipe_read+0x30>
				return 0;
  801fc4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc9:	eb d4                	jmp    801f9f <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801fcb:	99                   	cltd   
  801fcc:	c1 ea 1b             	shr    $0x1b,%edx
  801fcf:	01 d0                	add    %edx,%eax
  801fd1:	83 e0 1f             	and    $0x1f,%eax
  801fd4:	29 d0                	sub    %edx,%eax
  801fd6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801fdb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fde:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801fe1:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801fe4:	83 c6 01             	add    $0x1,%esi
  801fe7:	eb aa                	jmp    801f93 <devpipe_read+0x1c>

00801fe9 <pipe>:
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	56                   	push   %esi
  801fed:	53                   	push   %ebx
  801fee:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ff1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ff4:	50                   	push   %eax
  801ff5:	e8 b2 f1 ff ff       	call   8011ac <fd_alloc>
  801ffa:	89 c3                	mov    %eax,%ebx
  801ffc:	83 c4 10             	add    $0x10,%esp
  801fff:	85 c0                	test   %eax,%eax
  802001:	0f 88 23 01 00 00    	js     80212a <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802007:	83 ec 04             	sub    $0x4,%esp
  80200a:	68 07 04 00 00       	push   $0x407
  80200f:	ff 75 f4             	pushl  -0xc(%ebp)
  802012:	6a 00                	push   $0x0
  802014:	e8 7b ed ff ff       	call   800d94 <sys_page_alloc>
  802019:	89 c3                	mov    %eax,%ebx
  80201b:	83 c4 10             	add    $0x10,%esp
  80201e:	85 c0                	test   %eax,%eax
  802020:	0f 88 04 01 00 00    	js     80212a <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802026:	83 ec 0c             	sub    $0xc,%esp
  802029:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80202c:	50                   	push   %eax
  80202d:	e8 7a f1 ff ff       	call   8011ac <fd_alloc>
  802032:	89 c3                	mov    %eax,%ebx
  802034:	83 c4 10             	add    $0x10,%esp
  802037:	85 c0                	test   %eax,%eax
  802039:	0f 88 db 00 00 00    	js     80211a <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80203f:	83 ec 04             	sub    $0x4,%esp
  802042:	68 07 04 00 00       	push   $0x407
  802047:	ff 75 f0             	pushl  -0x10(%ebp)
  80204a:	6a 00                	push   $0x0
  80204c:	e8 43 ed ff ff       	call   800d94 <sys_page_alloc>
  802051:	89 c3                	mov    %eax,%ebx
  802053:	83 c4 10             	add    $0x10,%esp
  802056:	85 c0                	test   %eax,%eax
  802058:	0f 88 bc 00 00 00    	js     80211a <pipe+0x131>
	va = fd2data(fd0);
  80205e:	83 ec 0c             	sub    $0xc,%esp
  802061:	ff 75 f4             	pushl  -0xc(%ebp)
  802064:	e8 2c f1 ff ff       	call   801195 <fd2data>
  802069:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80206b:	83 c4 0c             	add    $0xc,%esp
  80206e:	68 07 04 00 00       	push   $0x407
  802073:	50                   	push   %eax
  802074:	6a 00                	push   $0x0
  802076:	e8 19 ed ff ff       	call   800d94 <sys_page_alloc>
  80207b:	89 c3                	mov    %eax,%ebx
  80207d:	83 c4 10             	add    $0x10,%esp
  802080:	85 c0                	test   %eax,%eax
  802082:	0f 88 82 00 00 00    	js     80210a <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802088:	83 ec 0c             	sub    $0xc,%esp
  80208b:	ff 75 f0             	pushl  -0x10(%ebp)
  80208e:	e8 02 f1 ff ff       	call   801195 <fd2data>
  802093:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80209a:	50                   	push   %eax
  80209b:	6a 00                	push   $0x0
  80209d:	56                   	push   %esi
  80209e:	6a 00                	push   $0x0
  8020a0:	e8 32 ed ff ff       	call   800dd7 <sys_page_map>
  8020a5:	89 c3                	mov    %eax,%ebx
  8020a7:	83 c4 20             	add    $0x20,%esp
  8020aa:	85 c0                	test   %eax,%eax
  8020ac:	78 4e                	js     8020fc <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8020ae:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8020b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b6:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8020b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020bb:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8020c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020c5:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8020c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ca:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8020d1:	83 ec 0c             	sub    $0xc,%esp
  8020d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8020d7:	e8 a9 f0 ff ff       	call   801185 <fd2num>
  8020dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020df:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8020e1:	83 c4 04             	add    $0x4,%esp
  8020e4:	ff 75 f0             	pushl  -0x10(%ebp)
  8020e7:	e8 99 f0 ff ff       	call   801185 <fd2num>
  8020ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020ef:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8020f2:	83 c4 10             	add    $0x10,%esp
  8020f5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020fa:	eb 2e                	jmp    80212a <pipe+0x141>
	sys_page_unmap(0, va);
  8020fc:	83 ec 08             	sub    $0x8,%esp
  8020ff:	56                   	push   %esi
  802100:	6a 00                	push   $0x0
  802102:	e8 12 ed ff ff       	call   800e19 <sys_page_unmap>
  802107:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80210a:	83 ec 08             	sub    $0x8,%esp
  80210d:	ff 75 f0             	pushl  -0x10(%ebp)
  802110:	6a 00                	push   $0x0
  802112:	e8 02 ed ff ff       	call   800e19 <sys_page_unmap>
  802117:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80211a:	83 ec 08             	sub    $0x8,%esp
  80211d:	ff 75 f4             	pushl  -0xc(%ebp)
  802120:	6a 00                	push   $0x0
  802122:	e8 f2 ec ff ff       	call   800e19 <sys_page_unmap>
  802127:	83 c4 10             	add    $0x10,%esp
}
  80212a:	89 d8                	mov    %ebx,%eax
  80212c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80212f:	5b                   	pop    %ebx
  802130:	5e                   	pop    %esi
  802131:	5d                   	pop    %ebp
  802132:	c3                   	ret    

00802133 <pipeisclosed>:
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
  802136:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802139:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80213c:	50                   	push   %eax
  80213d:	ff 75 08             	pushl  0x8(%ebp)
  802140:	e8 b9 f0 ff ff       	call   8011fe <fd_lookup>
  802145:	83 c4 10             	add    $0x10,%esp
  802148:	85 c0                	test   %eax,%eax
  80214a:	78 18                	js     802164 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80214c:	83 ec 0c             	sub    $0xc,%esp
  80214f:	ff 75 f4             	pushl  -0xc(%ebp)
  802152:	e8 3e f0 ff ff       	call   801195 <fd2data>
	return _pipeisclosed(fd, p);
  802157:	89 c2                	mov    %eax,%edx
  802159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215c:	e8 2f fd ff ff       	call   801e90 <_pipeisclosed>
  802161:	83 c4 10             	add    $0x10,%esp
}
  802164:	c9                   	leave  
  802165:	c3                   	ret    

00802166 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802166:	b8 00 00 00 00       	mov    $0x0,%eax
  80216b:	c3                   	ret    

0080216c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
  80216f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802172:	68 4f 2b 80 00       	push   $0x802b4f
  802177:	ff 75 0c             	pushl  0xc(%ebp)
  80217a:	e8 23 e8 ff ff       	call   8009a2 <strcpy>
	return 0;
}
  80217f:	b8 00 00 00 00       	mov    $0x0,%eax
  802184:	c9                   	leave  
  802185:	c3                   	ret    

00802186 <devcons_write>:
{
  802186:	55                   	push   %ebp
  802187:	89 e5                	mov    %esp,%ebp
  802189:	57                   	push   %edi
  80218a:	56                   	push   %esi
  80218b:	53                   	push   %ebx
  80218c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802192:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802197:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80219d:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021a0:	73 31                	jae    8021d3 <devcons_write+0x4d>
		m = n - tot;
  8021a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8021a5:	29 f3                	sub    %esi,%ebx
  8021a7:	83 fb 7f             	cmp    $0x7f,%ebx
  8021aa:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8021af:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8021b2:	83 ec 04             	sub    $0x4,%esp
  8021b5:	53                   	push   %ebx
  8021b6:	89 f0                	mov    %esi,%eax
  8021b8:	03 45 0c             	add    0xc(%ebp),%eax
  8021bb:	50                   	push   %eax
  8021bc:	57                   	push   %edi
  8021bd:	e8 6e e9 ff ff       	call   800b30 <memmove>
		sys_cputs(buf, m);
  8021c2:	83 c4 08             	add    $0x8,%esp
  8021c5:	53                   	push   %ebx
  8021c6:	57                   	push   %edi
  8021c7:	e8 0c eb ff ff       	call   800cd8 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8021cc:	01 de                	add    %ebx,%esi
  8021ce:	83 c4 10             	add    $0x10,%esp
  8021d1:	eb ca                	jmp    80219d <devcons_write+0x17>
}
  8021d3:	89 f0                	mov    %esi,%eax
  8021d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021d8:	5b                   	pop    %ebx
  8021d9:	5e                   	pop    %esi
  8021da:	5f                   	pop    %edi
  8021db:	5d                   	pop    %ebp
  8021dc:	c3                   	ret    

008021dd <devcons_read>:
{
  8021dd:	55                   	push   %ebp
  8021de:	89 e5                	mov    %esp,%ebp
  8021e0:	83 ec 08             	sub    $0x8,%esp
  8021e3:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8021e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021ec:	74 21                	je     80220f <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8021ee:	e8 03 eb ff ff       	call   800cf6 <sys_cgetc>
  8021f3:	85 c0                	test   %eax,%eax
  8021f5:	75 07                	jne    8021fe <devcons_read+0x21>
		sys_yield();
  8021f7:	e8 79 eb ff ff       	call   800d75 <sys_yield>
  8021fc:	eb f0                	jmp    8021ee <devcons_read+0x11>
	if (c < 0)
  8021fe:	78 0f                	js     80220f <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802200:	83 f8 04             	cmp    $0x4,%eax
  802203:	74 0c                	je     802211 <devcons_read+0x34>
	*(char*)vbuf = c;
  802205:	8b 55 0c             	mov    0xc(%ebp),%edx
  802208:	88 02                	mov    %al,(%edx)
	return 1;
  80220a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80220f:	c9                   	leave  
  802210:	c3                   	ret    
		return 0;
  802211:	b8 00 00 00 00       	mov    $0x0,%eax
  802216:	eb f7                	jmp    80220f <devcons_read+0x32>

00802218 <cputchar>:
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
  80221b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802224:	6a 01                	push   $0x1
  802226:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802229:	50                   	push   %eax
  80222a:	e8 a9 ea ff ff       	call   800cd8 <sys_cputs>
}
  80222f:	83 c4 10             	add    $0x10,%esp
  802232:	c9                   	leave  
  802233:	c3                   	ret    

00802234 <getchar>:
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
  802237:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80223a:	6a 01                	push   $0x1
  80223c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80223f:	50                   	push   %eax
  802240:	6a 00                	push   $0x0
  802242:	e8 27 f2 ff ff       	call   80146e <read>
	if (r < 0)
  802247:	83 c4 10             	add    $0x10,%esp
  80224a:	85 c0                	test   %eax,%eax
  80224c:	78 06                	js     802254 <getchar+0x20>
	if (r < 1)
  80224e:	74 06                	je     802256 <getchar+0x22>
	return c;
  802250:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802254:	c9                   	leave  
  802255:	c3                   	ret    
		return -E_EOF;
  802256:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80225b:	eb f7                	jmp    802254 <getchar+0x20>

0080225d <iscons>:
{
  80225d:	55                   	push   %ebp
  80225e:	89 e5                	mov    %esp,%ebp
  802260:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802263:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802266:	50                   	push   %eax
  802267:	ff 75 08             	pushl  0x8(%ebp)
  80226a:	e8 8f ef ff ff       	call   8011fe <fd_lookup>
  80226f:	83 c4 10             	add    $0x10,%esp
  802272:	85 c0                	test   %eax,%eax
  802274:	78 11                	js     802287 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802279:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80227f:	39 10                	cmp    %edx,(%eax)
  802281:	0f 94 c0             	sete   %al
  802284:	0f b6 c0             	movzbl %al,%eax
}
  802287:	c9                   	leave  
  802288:	c3                   	ret    

00802289 <opencons>:
{
  802289:	55                   	push   %ebp
  80228a:	89 e5                	mov    %esp,%ebp
  80228c:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80228f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802292:	50                   	push   %eax
  802293:	e8 14 ef ff ff       	call   8011ac <fd_alloc>
  802298:	83 c4 10             	add    $0x10,%esp
  80229b:	85 c0                	test   %eax,%eax
  80229d:	78 3a                	js     8022d9 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80229f:	83 ec 04             	sub    $0x4,%esp
  8022a2:	68 07 04 00 00       	push   $0x407
  8022a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8022aa:	6a 00                	push   $0x0
  8022ac:	e8 e3 ea ff ff       	call   800d94 <sys_page_alloc>
  8022b1:	83 c4 10             	add    $0x10,%esp
  8022b4:	85 c0                	test   %eax,%eax
  8022b6:	78 21                	js     8022d9 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8022b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bb:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022c1:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022cd:	83 ec 0c             	sub    $0xc,%esp
  8022d0:	50                   	push   %eax
  8022d1:	e8 af ee ff ff       	call   801185 <fd2num>
  8022d6:	83 c4 10             	add    $0x10,%esp
}
  8022d9:	c9                   	leave  
  8022da:	c3                   	ret    

008022db <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8022db:	55                   	push   %ebp
  8022dc:	89 e5                	mov    %esp,%ebp
  8022de:	56                   	push   %esi
  8022df:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8022e0:	a1 08 40 80 00       	mov    0x804008,%eax
  8022e5:	8b 40 48             	mov    0x48(%eax),%eax
  8022e8:	83 ec 04             	sub    $0x4,%esp
  8022eb:	68 80 2b 80 00       	push   $0x802b80
  8022f0:	50                   	push   %eax
  8022f1:	68 60 26 80 00       	push   $0x802660
  8022f6:	e8 48 df ff ff       	call   800243 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8022fb:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8022fe:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802304:	e8 4d ea ff ff       	call   800d56 <sys_getenvid>
  802309:	83 c4 04             	add    $0x4,%esp
  80230c:	ff 75 0c             	pushl  0xc(%ebp)
  80230f:	ff 75 08             	pushl  0x8(%ebp)
  802312:	56                   	push   %esi
  802313:	50                   	push   %eax
  802314:	68 5c 2b 80 00       	push   $0x802b5c
  802319:	e8 25 df ff ff       	call   800243 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80231e:	83 c4 18             	add    $0x18,%esp
  802321:	53                   	push   %ebx
  802322:	ff 75 10             	pushl  0x10(%ebp)
  802325:	e8 c8 de ff ff       	call   8001f2 <vcprintf>
	cprintf("\n");
  80232a:	c7 04 24 24 26 80 00 	movl   $0x802624,(%esp)
  802331:	e8 0d df ff ff       	call   800243 <cprintf>
  802336:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802339:	cc                   	int3   
  80233a:	eb fd                	jmp    802339 <_panic+0x5e>

0080233c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
  80233f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802342:	89 d0                	mov    %edx,%eax
  802344:	c1 e8 16             	shr    $0x16,%eax
  802347:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80234e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802353:	f6 c1 01             	test   $0x1,%cl
  802356:	74 1d                	je     802375 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802358:	c1 ea 0c             	shr    $0xc,%edx
  80235b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802362:	f6 c2 01             	test   $0x1,%dl
  802365:	74 0e                	je     802375 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802367:	c1 ea 0c             	shr    $0xc,%edx
  80236a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802371:	ef 
  802372:	0f b7 c0             	movzwl %ax,%eax
}
  802375:	5d                   	pop    %ebp
  802376:	c3                   	ret    
  802377:	66 90                	xchg   %ax,%ax
  802379:	66 90                	xchg   %ax,%ax
  80237b:	66 90                	xchg   %ax,%ax
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
