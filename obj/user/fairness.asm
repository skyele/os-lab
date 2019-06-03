
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
  80003b:	e8 c5 0c 00 00       	call   800d05 <sys_getenvid>
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
  800058:	68 71 25 80 00       	push   $0x802571
  80005d:	e8 90 01 00 00       	call   8001f2 <cprintf>
  800062:	83 c4 10             	add    $0x10,%esp
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  800065:	a1 c8 00 c0 ee       	mov    0xeec000c8,%eax
  80006a:	6a 00                	push   $0x0
  80006c:	6a 00                	push   $0x0
  80006e:	6a 00                	push   $0x0
  800070:	50                   	push   %eax
  800071:	e8 0b 10 00 00       	call   801081 <ipc_send>
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	eb ea                	jmp    800065 <umain+0x32>
			ipc_recv(&who, 0, 0);
  80007b:	8d 75 f4             	lea    -0xc(%ebp),%esi
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	6a 00                	push   $0x0
  800083:	6a 00                	push   $0x0
  800085:	56                   	push   %esi
  800086:	e8 8d 0f 00 00       	call   801018 <ipc_recv>
			cprintf("%x recv from %x\n", id, who);
  80008b:	83 c4 0c             	add    $0xc,%esp
  80008e:	ff 75 f4             	pushl  -0xc(%ebp)
  800091:	53                   	push   %ebx
  800092:	68 60 25 80 00       	push   $0x802560
  800097:	e8 56 01 00 00       	call   8001f2 <cprintf>
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
  8000b4:	e8 4c 0c 00 00       	call   800d05 <sys_getenvid>
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

	cprintf("call umain!\n");
  800118:	83 ec 0c             	sub    $0xc,%esp
  80011b:	68 88 25 80 00       	push   $0x802588
  800120:	e8 cd 00 00 00       	call   8001f2 <cprintf>
	// call user main routine
	umain(argc, argv);
  800125:	83 c4 08             	add    $0x8,%esp
  800128:	ff 75 0c             	pushl  0xc(%ebp)
  80012b:	ff 75 08             	pushl  0x8(%ebp)
  80012e:	e8 00 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800133:	e8 0b 00 00 00       	call   800143 <exit>
}
  800138:	83 c4 10             	add    $0x10,%esp
  80013b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80013e:	5b                   	pop    %ebx
  80013f:	5e                   	pop    %esi
  800140:	5f                   	pop    %edi
  800141:	5d                   	pop    %ebp
  800142:	c3                   	ret    

00800143 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800149:	e8 9e 11 00 00       	call   8012ec <close_all>
	sys_env_destroy(0);
  80014e:	83 ec 0c             	sub    $0xc,%esp
  800151:	6a 00                	push   $0x0
  800153:	e8 6c 0b 00 00       	call   800cc4 <sys_env_destroy>
}
  800158:	83 c4 10             	add    $0x10,%esp
  80015b:	c9                   	leave  
  80015c:	c3                   	ret    

0080015d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80015d:	55                   	push   %ebp
  80015e:	89 e5                	mov    %esp,%ebp
  800160:	53                   	push   %ebx
  800161:	83 ec 04             	sub    $0x4,%esp
  800164:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800167:	8b 13                	mov    (%ebx),%edx
  800169:	8d 42 01             	lea    0x1(%edx),%eax
  80016c:	89 03                	mov    %eax,(%ebx)
  80016e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800171:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800175:	3d ff 00 00 00       	cmp    $0xff,%eax
  80017a:	74 09                	je     800185 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80017c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800180:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800183:	c9                   	leave  
  800184:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800185:	83 ec 08             	sub    $0x8,%esp
  800188:	68 ff 00 00 00       	push   $0xff
  80018d:	8d 43 08             	lea    0x8(%ebx),%eax
  800190:	50                   	push   %eax
  800191:	e8 f1 0a 00 00       	call   800c87 <sys_cputs>
		b->idx = 0;
  800196:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80019c:	83 c4 10             	add    $0x10,%esp
  80019f:	eb db                	jmp    80017c <putch+0x1f>

008001a1 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001a1:	55                   	push   %ebp
  8001a2:	89 e5                	mov    %esp,%ebp
  8001a4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001aa:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001b1:	00 00 00 
	b.cnt = 0;
  8001b4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001bb:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001be:	ff 75 0c             	pushl  0xc(%ebp)
  8001c1:	ff 75 08             	pushl  0x8(%ebp)
  8001c4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001ca:	50                   	push   %eax
  8001cb:	68 5d 01 80 00       	push   $0x80015d
  8001d0:	e8 4a 01 00 00       	call   80031f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d5:	83 c4 08             	add    $0x8,%esp
  8001d8:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001de:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e4:	50                   	push   %eax
  8001e5:	e8 9d 0a 00 00       	call   800c87 <sys_cputs>

	return b.cnt;
}
  8001ea:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001f0:	c9                   	leave  
  8001f1:	c3                   	ret    

008001f2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f2:	55                   	push   %ebp
  8001f3:	89 e5                	mov    %esp,%ebp
  8001f5:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001f8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001fb:	50                   	push   %eax
  8001fc:	ff 75 08             	pushl  0x8(%ebp)
  8001ff:	e8 9d ff ff ff       	call   8001a1 <vcprintf>
	va_end(ap);

	return cnt;
}
  800204:	c9                   	leave  
  800205:	c3                   	ret    

00800206 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	57                   	push   %edi
  80020a:	56                   	push   %esi
  80020b:	53                   	push   %ebx
  80020c:	83 ec 1c             	sub    $0x1c,%esp
  80020f:	89 c6                	mov    %eax,%esi
  800211:	89 d7                	mov    %edx,%edi
  800213:	8b 45 08             	mov    0x8(%ebp),%eax
  800216:	8b 55 0c             	mov    0xc(%ebp),%edx
  800219:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80021c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80021f:	8b 45 10             	mov    0x10(%ebp),%eax
  800222:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800225:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800229:	74 2c                	je     800257 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80022b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80022e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800235:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800238:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80023b:	39 c2                	cmp    %eax,%edx
  80023d:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800240:	73 43                	jae    800285 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800242:	83 eb 01             	sub    $0x1,%ebx
  800245:	85 db                	test   %ebx,%ebx
  800247:	7e 6c                	jle    8002b5 <printnum+0xaf>
				putch(padc, putdat);
  800249:	83 ec 08             	sub    $0x8,%esp
  80024c:	57                   	push   %edi
  80024d:	ff 75 18             	pushl  0x18(%ebp)
  800250:	ff d6                	call   *%esi
  800252:	83 c4 10             	add    $0x10,%esp
  800255:	eb eb                	jmp    800242 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	6a 20                	push   $0x20
  80025c:	6a 00                	push   $0x0
  80025e:	50                   	push   %eax
  80025f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800262:	ff 75 e0             	pushl  -0x20(%ebp)
  800265:	89 fa                	mov    %edi,%edx
  800267:	89 f0                	mov    %esi,%eax
  800269:	e8 98 ff ff ff       	call   800206 <printnum>
		while (--width > 0)
  80026e:	83 c4 20             	add    $0x20,%esp
  800271:	83 eb 01             	sub    $0x1,%ebx
  800274:	85 db                	test   %ebx,%ebx
  800276:	7e 65                	jle    8002dd <printnum+0xd7>
			putch(padc, putdat);
  800278:	83 ec 08             	sub    $0x8,%esp
  80027b:	57                   	push   %edi
  80027c:	6a 20                	push   $0x20
  80027e:	ff d6                	call   *%esi
  800280:	83 c4 10             	add    $0x10,%esp
  800283:	eb ec                	jmp    800271 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800285:	83 ec 0c             	sub    $0xc,%esp
  800288:	ff 75 18             	pushl  0x18(%ebp)
  80028b:	83 eb 01             	sub    $0x1,%ebx
  80028e:	53                   	push   %ebx
  80028f:	50                   	push   %eax
  800290:	83 ec 08             	sub    $0x8,%esp
  800293:	ff 75 dc             	pushl  -0x24(%ebp)
  800296:	ff 75 d8             	pushl  -0x28(%ebp)
  800299:	ff 75 e4             	pushl  -0x1c(%ebp)
  80029c:	ff 75 e0             	pushl  -0x20(%ebp)
  80029f:	e8 6c 20 00 00       	call   802310 <__udivdi3>
  8002a4:	83 c4 18             	add    $0x18,%esp
  8002a7:	52                   	push   %edx
  8002a8:	50                   	push   %eax
  8002a9:	89 fa                	mov    %edi,%edx
  8002ab:	89 f0                	mov    %esi,%eax
  8002ad:	e8 54 ff ff ff       	call   800206 <printnum>
  8002b2:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002b5:	83 ec 08             	sub    $0x8,%esp
  8002b8:	57                   	push   %edi
  8002b9:	83 ec 04             	sub    $0x4,%esp
  8002bc:	ff 75 dc             	pushl  -0x24(%ebp)
  8002bf:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c5:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c8:	e8 53 21 00 00       	call   802420 <__umoddi3>
  8002cd:	83 c4 14             	add    $0x14,%esp
  8002d0:	0f be 80 9f 25 80 00 	movsbl 0x80259f(%eax),%eax
  8002d7:	50                   	push   %eax
  8002d8:	ff d6                	call   *%esi
  8002da:	83 c4 10             	add    $0x10,%esp
	}
}
  8002dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e0:	5b                   	pop    %ebx
  8002e1:	5e                   	pop    %esi
  8002e2:	5f                   	pop    %edi
  8002e3:	5d                   	pop    %ebp
  8002e4:	c3                   	ret    

008002e5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002e5:	55                   	push   %ebp
  8002e6:	89 e5                	mov    %esp,%ebp
  8002e8:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002eb:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002ef:	8b 10                	mov    (%eax),%edx
  8002f1:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f4:	73 0a                	jae    800300 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002f6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002f9:	89 08                	mov    %ecx,(%eax)
  8002fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fe:	88 02                	mov    %al,(%edx)
}
  800300:	5d                   	pop    %ebp
  800301:	c3                   	ret    

00800302 <printfmt>:
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800308:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80030b:	50                   	push   %eax
  80030c:	ff 75 10             	pushl  0x10(%ebp)
  80030f:	ff 75 0c             	pushl  0xc(%ebp)
  800312:	ff 75 08             	pushl  0x8(%ebp)
  800315:	e8 05 00 00 00       	call   80031f <vprintfmt>
}
  80031a:	83 c4 10             	add    $0x10,%esp
  80031d:	c9                   	leave  
  80031e:	c3                   	ret    

0080031f <vprintfmt>:
{
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
  800322:	57                   	push   %edi
  800323:	56                   	push   %esi
  800324:	53                   	push   %ebx
  800325:	83 ec 3c             	sub    $0x3c,%esp
  800328:	8b 75 08             	mov    0x8(%ebp),%esi
  80032b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80032e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800331:	e9 32 04 00 00       	jmp    800768 <vprintfmt+0x449>
		padc = ' ';
  800336:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80033a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800341:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800348:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80034f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800356:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80035d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800362:	8d 47 01             	lea    0x1(%edi),%eax
  800365:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800368:	0f b6 17             	movzbl (%edi),%edx
  80036b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80036e:	3c 55                	cmp    $0x55,%al
  800370:	0f 87 12 05 00 00    	ja     800888 <vprintfmt+0x569>
  800376:	0f b6 c0             	movzbl %al,%eax
  800379:	ff 24 85 80 27 80 00 	jmp    *0x802780(,%eax,4)
  800380:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800383:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800387:	eb d9                	jmp    800362 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800389:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80038c:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800390:	eb d0                	jmp    800362 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800392:	0f b6 d2             	movzbl %dl,%edx
  800395:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800398:	b8 00 00 00 00       	mov    $0x0,%eax
  80039d:	89 75 08             	mov    %esi,0x8(%ebp)
  8003a0:	eb 03                	jmp    8003a5 <vprintfmt+0x86>
  8003a2:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003a5:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003a8:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003ac:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003af:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003b2:	83 fe 09             	cmp    $0x9,%esi
  8003b5:	76 eb                	jbe    8003a2 <vprintfmt+0x83>
  8003b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ba:	8b 75 08             	mov    0x8(%ebp),%esi
  8003bd:	eb 14                	jmp    8003d3 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c2:	8b 00                	mov    (%eax),%eax
  8003c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ca:	8d 40 04             	lea    0x4(%eax),%eax
  8003cd:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003d7:	79 89                	jns    800362 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003df:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003e6:	e9 77 ff ff ff       	jmp    800362 <vprintfmt+0x43>
  8003eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ee:	85 c0                	test   %eax,%eax
  8003f0:	0f 48 c1             	cmovs  %ecx,%eax
  8003f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003f9:	e9 64 ff ff ff       	jmp    800362 <vprintfmt+0x43>
  8003fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800401:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800408:	e9 55 ff ff ff       	jmp    800362 <vprintfmt+0x43>
			lflag++;
  80040d:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800411:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800414:	e9 49 ff ff ff       	jmp    800362 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800419:	8b 45 14             	mov    0x14(%ebp),%eax
  80041c:	8d 78 04             	lea    0x4(%eax),%edi
  80041f:	83 ec 08             	sub    $0x8,%esp
  800422:	53                   	push   %ebx
  800423:	ff 30                	pushl  (%eax)
  800425:	ff d6                	call   *%esi
			break;
  800427:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80042a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80042d:	e9 33 03 00 00       	jmp    800765 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800432:	8b 45 14             	mov    0x14(%ebp),%eax
  800435:	8d 78 04             	lea    0x4(%eax),%edi
  800438:	8b 00                	mov    (%eax),%eax
  80043a:	99                   	cltd   
  80043b:	31 d0                	xor    %edx,%eax
  80043d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80043f:	83 f8 10             	cmp    $0x10,%eax
  800442:	7f 23                	jg     800467 <vprintfmt+0x148>
  800444:	8b 14 85 e0 28 80 00 	mov    0x8028e0(,%eax,4),%edx
  80044b:	85 d2                	test   %edx,%edx
  80044d:	74 18                	je     800467 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80044f:	52                   	push   %edx
  800450:	68 19 2a 80 00       	push   $0x802a19
  800455:	53                   	push   %ebx
  800456:	56                   	push   %esi
  800457:	e8 a6 fe ff ff       	call   800302 <printfmt>
  80045c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800462:	e9 fe 02 00 00       	jmp    800765 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800467:	50                   	push   %eax
  800468:	68 b7 25 80 00       	push   $0x8025b7
  80046d:	53                   	push   %ebx
  80046e:	56                   	push   %esi
  80046f:	e8 8e fe ff ff       	call   800302 <printfmt>
  800474:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800477:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80047a:	e9 e6 02 00 00       	jmp    800765 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80047f:	8b 45 14             	mov    0x14(%ebp),%eax
  800482:	83 c0 04             	add    $0x4,%eax
  800485:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800488:	8b 45 14             	mov    0x14(%ebp),%eax
  80048b:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80048d:	85 c9                	test   %ecx,%ecx
  80048f:	b8 b0 25 80 00       	mov    $0x8025b0,%eax
  800494:	0f 45 c1             	cmovne %ecx,%eax
  800497:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80049a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80049e:	7e 06                	jle    8004a6 <vprintfmt+0x187>
  8004a0:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004a4:	75 0d                	jne    8004b3 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004a9:	89 c7                	mov    %eax,%edi
  8004ab:	03 45 e0             	add    -0x20(%ebp),%eax
  8004ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b1:	eb 53                	jmp    800506 <vprintfmt+0x1e7>
  8004b3:	83 ec 08             	sub    $0x8,%esp
  8004b6:	ff 75 d8             	pushl  -0x28(%ebp)
  8004b9:	50                   	push   %eax
  8004ba:	e8 71 04 00 00       	call   800930 <strnlen>
  8004bf:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c2:	29 c1                	sub    %eax,%ecx
  8004c4:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004c7:	83 c4 10             	add    $0x10,%esp
  8004ca:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004cc:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d3:	eb 0f                	jmp    8004e4 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004d5:	83 ec 08             	sub    $0x8,%esp
  8004d8:	53                   	push   %ebx
  8004d9:	ff 75 e0             	pushl  -0x20(%ebp)
  8004dc:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004de:	83 ef 01             	sub    $0x1,%edi
  8004e1:	83 c4 10             	add    $0x10,%esp
  8004e4:	85 ff                	test   %edi,%edi
  8004e6:	7f ed                	jg     8004d5 <vprintfmt+0x1b6>
  8004e8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004eb:	85 c9                	test   %ecx,%ecx
  8004ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f2:	0f 49 c1             	cmovns %ecx,%eax
  8004f5:	29 c1                	sub    %eax,%ecx
  8004f7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004fa:	eb aa                	jmp    8004a6 <vprintfmt+0x187>
					putch(ch, putdat);
  8004fc:	83 ec 08             	sub    $0x8,%esp
  8004ff:	53                   	push   %ebx
  800500:	52                   	push   %edx
  800501:	ff d6                	call   *%esi
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800509:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80050b:	83 c7 01             	add    $0x1,%edi
  80050e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800512:	0f be d0             	movsbl %al,%edx
  800515:	85 d2                	test   %edx,%edx
  800517:	74 4b                	je     800564 <vprintfmt+0x245>
  800519:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80051d:	78 06                	js     800525 <vprintfmt+0x206>
  80051f:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800523:	78 1e                	js     800543 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800525:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800529:	74 d1                	je     8004fc <vprintfmt+0x1dd>
  80052b:	0f be c0             	movsbl %al,%eax
  80052e:	83 e8 20             	sub    $0x20,%eax
  800531:	83 f8 5e             	cmp    $0x5e,%eax
  800534:	76 c6                	jbe    8004fc <vprintfmt+0x1dd>
					putch('?', putdat);
  800536:	83 ec 08             	sub    $0x8,%esp
  800539:	53                   	push   %ebx
  80053a:	6a 3f                	push   $0x3f
  80053c:	ff d6                	call   *%esi
  80053e:	83 c4 10             	add    $0x10,%esp
  800541:	eb c3                	jmp    800506 <vprintfmt+0x1e7>
  800543:	89 cf                	mov    %ecx,%edi
  800545:	eb 0e                	jmp    800555 <vprintfmt+0x236>
				putch(' ', putdat);
  800547:	83 ec 08             	sub    $0x8,%esp
  80054a:	53                   	push   %ebx
  80054b:	6a 20                	push   $0x20
  80054d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80054f:	83 ef 01             	sub    $0x1,%edi
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	85 ff                	test   %edi,%edi
  800557:	7f ee                	jg     800547 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800559:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80055c:	89 45 14             	mov    %eax,0x14(%ebp)
  80055f:	e9 01 02 00 00       	jmp    800765 <vprintfmt+0x446>
  800564:	89 cf                	mov    %ecx,%edi
  800566:	eb ed                	jmp    800555 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800568:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80056b:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800572:	e9 eb fd ff ff       	jmp    800362 <vprintfmt+0x43>
	if (lflag >= 2)
  800577:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80057b:	7f 21                	jg     80059e <vprintfmt+0x27f>
	else if (lflag)
  80057d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800581:	74 68                	je     8005eb <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800583:	8b 45 14             	mov    0x14(%ebp),%eax
  800586:	8b 00                	mov    (%eax),%eax
  800588:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80058b:	89 c1                	mov    %eax,%ecx
  80058d:	c1 f9 1f             	sar    $0x1f,%ecx
  800590:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800593:	8b 45 14             	mov    0x14(%ebp),%eax
  800596:	8d 40 04             	lea    0x4(%eax),%eax
  800599:	89 45 14             	mov    %eax,0x14(%ebp)
  80059c:	eb 17                	jmp    8005b5 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80059e:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a1:	8b 50 04             	mov    0x4(%eax),%edx
  8005a4:	8b 00                	mov    (%eax),%eax
  8005a6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8005af:	8d 40 08             	lea    0x8(%eax),%eax
  8005b2:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005b8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005be:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005c1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005c5:	78 3f                	js     800606 <vprintfmt+0x2e7>
			base = 10;
  8005c7:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005cc:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005d0:	0f 84 71 01 00 00    	je     800747 <vprintfmt+0x428>
				putch('+', putdat);
  8005d6:	83 ec 08             	sub    $0x8,%esp
  8005d9:	53                   	push   %ebx
  8005da:	6a 2b                	push   $0x2b
  8005dc:	ff d6                	call   *%esi
  8005de:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005e1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e6:	e9 5c 01 00 00       	jmp    800747 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ee:	8b 00                	mov    (%eax),%eax
  8005f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005f3:	89 c1                	mov    %eax,%ecx
  8005f5:	c1 f9 1f             	sar    $0x1f,%ecx
  8005f8:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fe:	8d 40 04             	lea    0x4(%eax),%eax
  800601:	89 45 14             	mov    %eax,0x14(%ebp)
  800604:	eb af                	jmp    8005b5 <vprintfmt+0x296>
				putch('-', putdat);
  800606:	83 ec 08             	sub    $0x8,%esp
  800609:	53                   	push   %ebx
  80060a:	6a 2d                	push   $0x2d
  80060c:	ff d6                	call   *%esi
				num = -(long long) num;
  80060e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800611:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800614:	f7 d8                	neg    %eax
  800616:	83 d2 00             	adc    $0x0,%edx
  800619:	f7 da                	neg    %edx
  80061b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800621:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800624:	b8 0a 00 00 00       	mov    $0xa,%eax
  800629:	e9 19 01 00 00       	jmp    800747 <vprintfmt+0x428>
	if (lflag >= 2)
  80062e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800632:	7f 29                	jg     80065d <vprintfmt+0x33e>
	else if (lflag)
  800634:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800638:	74 44                	je     80067e <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	ba 00 00 00 00       	mov    $0x0,%edx
  800644:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800647:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	8d 40 04             	lea    0x4(%eax),%eax
  800650:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800653:	b8 0a 00 00 00       	mov    $0xa,%eax
  800658:	e9 ea 00 00 00       	jmp    800747 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80065d:	8b 45 14             	mov    0x14(%ebp),%eax
  800660:	8b 50 04             	mov    0x4(%eax),%edx
  800663:	8b 00                	mov    (%eax),%eax
  800665:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800668:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80066b:	8b 45 14             	mov    0x14(%ebp),%eax
  80066e:	8d 40 08             	lea    0x8(%eax),%eax
  800671:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800674:	b8 0a 00 00 00       	mov    $0xa,%eax
  800679:	e9 c9 00 00 00       	jmp    800747 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	ba 00 00 00 00       	mov    $0x0,%edx
  800688:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80068e:	8b 45 14             	mov    0x14(%ebp),%eax
  800691:	8d 40 04             	lea    0x4(%eax),%eax
  800694:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800697:	b8 0a 00 00 00       	mov    $0xa,%eax
  80069c:	e9 a6 00 00 00       	jmp    800747 <vprintfmt+0x428>
			putch('0', putdat);
  8006a1:	83 ec 08             	sub    $0x8,%esp
  8006a4:	53                   	push   %ebx
  8006a5:	6a 30                	push   $0x30
  8006a7:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006a9:	83 c4 10             	add    $0x10,%esp
  8006ac:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006b0:	7f 26                	jg     8006d8 <vprintfmt+0x3b9>
	else if (lflag)
  8006b2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006b6:	74 3e                	je     8006f6 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bb:	8b 00                	mov    (%eax),%eax
  8006bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	8d 40 04             	lea    0x4(%eax),%eax
  8006ce:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006d1:	b8 08 00 00 00       	mov    $0x8,%eax
  8006d6:	eb 6f                	jmp    800747 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006db:	8b 50 04             	mov    0x4(%eax),%edx
  8006de:	8b 00                	mov    (%eax),%eax
  8006e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e9:	8d 40 08             	lea    0x8(%eax),%eax
  8006ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ef:	b8 08 00 00 00       	mov    $0x8,%eax
  8006f4:	eb 51                	jmp    800747 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f9:	8b 00                	mov    (%eax),%eax
  8006fb:	ba 00 00 00 00       	mov    $0x0,%edx
  800700:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800703:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800706:	8b 45 14             	mov    0x14(%ebp),%eax
  800709:	8d 40 04             	lea    0x4(%eax),%eax
  80070c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80070f:	b8 08 00 00 00       	mov    $0x8,%eax
  800714:	eb 31                	jmp    800747 <vprintfmt+0x428>
			putch('0', putdat);
  800716:	83 ec 08             	sub    $0x8,%esp
  800719:	53                   	push   %ebx
  80071a:	6a 30                	push   $0x30
  80071c:	ff d6                	call   *%esi
			putch('x', putdat);
  80071e:	83 c4 08             	add    $0x8,%esp
  800721:	53                   	push   %ebx
  800722:	6a 78                	push   $0x78
  800724:	ff d6                	call   *%esi
			num = (unsigned long long)
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	ba 00 00 00 00       	mov    $0x0,%edx
  800730:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800733:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800736:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800739:	8b 45 14             	mov    0x14(%ebp),%eax
  80073c:	8d 40 04             	lea    0x4(%eax),%eax
  80073f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800742:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800747:	83 ec 0c             	sub    $0xc,%esp
  80074a:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80074e:	52                   	push   %edx
  80074f:	ff 75 e0             	pushl  -0x20(%ebp)
  800752:	50                   	push   %eax
  800753:	ff 75 dc             	pushl  -0x24(%ebp)
  800756:	ff 75 d8             	pushl  -0x28(%ebp)
  800759:	89 da                	mov    %ebx,%edx
  80075b:	89 f0                	mov    %esi,%eax
  80075d:	e8 a4 fa ff ff       	call   800206 <printnum>
			break;
  800762:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800765:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800768:	83 c7 01             	add    $0x1,%edi
  80076b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80076f:	83 f8 25             	cmp    $0x25,%eax
  800772:	0f 84 be fb ff ff    	je     800336 <vprintfmt+0x17>
			if (ch == '\0')
  800778:	85 c0                	test   %eax,%eax
  80077a:	0f 84 28 01 00 00    	je     8008a8 <vprintfmt+0x589>
			putch(ch, putdat);
  800780:	83 ec 08             	sub    $0x8,%esp
  800783:	53                   	push   %ebx
  800784:	50                   	push   %eax
  800785:	ff d6                	call   *%esi
  800787:	83 c4 10             	add    $0x10,%esp
  80078a:	eb dc                	jmp    800768 <vprintfmt+0x449>
	if (lflag >= 2)
  80078c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800790:	7f 26                	jg     8007b8 <vprintfmt+0x499>
	else if (lflag)
  800792:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800796:	74 41                	je     8007d9 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800798:	8b 45 14             	mov    0x14(%ebp),%eax
  80079b:	8b 00                	mov    (%eax),%eax
  80079d:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ab:	8d 40 04             	lea    0x4(%eax),%eax
  8007ae:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b1:	b8 10 00 00 00       	mov    $0x10,%eax
  8007b6:	eb 8f                	jmp    800747 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bb:	8b 50 04             	mov    0x4(%eax),%edx
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c9:	8d 40 08             	lea    0x8(%eax),%eax
  8007cc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007cf:	b8 10 00 00 00       	mov    $0x10,%eax
  8007d4:	e9 6e ff ff ff       	jmp    800747 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	8b 00                	mov    (%eax),%eax
  8007de:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ec:	8d 40 04             	lea    0x4(%eax),%eax
  8007ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f2:	b8 10 00 00 00       	mov    $0x10,%eax
  8007f7:	e9 4b ff ff ff       	jmp    800747 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ff:	83 c0 04             	add    $0x4,%eax
  800802:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800805:	8b 45 14             	mov    0x14(%ebp),%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	85 c0                	test   %eax,%eax
  80080c:	74 14                	je     800822 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80080e:	8b 13                	mov    (%ebx),%edx
  800810:	83 fa 7f             	cmp    $0x7f,%edx
  800813:	7f 37                	jg     80084c <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800815:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800817:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80081a:	89 45 14             	mov    %eax,0x14(%ebp)
  80081d:	e9 43 ff ff ff       	jmp    800765 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800822:	b8 0a 00 00 00       	mov    $0xa,%eax
  800827:	bf d5 26 80 00       	mov    $0x8026d5,%edi
							putch(ch, putdat);
  80082c:	83 ec 08             	sub    $0x8,%esp
  80082f:	53                   	push   %ebx
  800830:	50                   	push   %eax
  800831:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800833:	83 c7 01             	add    $0x1,%edi
  800836:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80083a:	83 c4 10             	add    $0x10,%esp
  80083d:	85 c0                	test   %eax,%eax
  80083f:	75 eb                	jne    80082c <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800841:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800844:	89 45 14             	mov    %eax,0x14(%ebp)
  800847:	e9 19 ff ff ff       	jmp    800765 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80084c:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80084e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800853:	bf 0d 27 80 00       	mov    $0x80270d,%edi
							putch(ch, putdat);
  800858:	83 ec 08             	sub    $0x8,%esp
  80085b:	53                   	push   %ebx
  80085c:	50                   	push   %eax
  80085d:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80085f:	83 c7 01             	add    $0x1,%edi
  800862:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800866:	83 c4 10             	add    $0x10,%esp
  800869:	85 c0                	test   %eax,%eax
  80086b:	75 eb                	jne    800858 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80086d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800870:	89 45 14             	mov    %eax,0x14(%ebp)
  800873:	e9 ed fe ff ff       	jmp    800765 <vprintfmt+0x446>
			putch(ch, putdat);
  800878:	83 ec 08             	sub    $0x8,%esp
  80087b:	53                   	push   %ebx
  80087c:	6a 25                	push   $0x25
  80087e:	ff d6                	call   *%esi
			break;
  800880:	83 c4 10             	add    $0x10,%esp
  800883:	e9 dd fe ff ff       	jmp    800765 <vprintfmt+0x446>
			putch('%', putdat);
  800888:	83 ec 08             	sub    $0x8,%esp
  80088b:	53                   	push   %ebx
  80088c:	6a 25                	push   $0x25
  80088e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800890:	83 c4 10             	add    $0x10,%esp
  800893:	89 f8                	mov    %edi,%eax
  800895:	eb 03                	jmp    80089a <vprintfmt+0x57b>
  800897:	83 e8 01             	sub    $0x1,%eax
  80089a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80089e:	75 f7                	jne    800897 <vprintfmt+0x578>
  8008a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008a3:	e9 bd fe ff ff       	jmp    800765 <vprintfmt+0x446>
}
  8008a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008ab:	5b                   	pop    %ebx
  8008ac:	5e                   	pop    %esi
  8008ad:	5f                   	pop    %edi
  8008ae:	5d                   	pop    %ebp
  8008af:	c3                   	ret    

008008b0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
  8008b3:	83 ec 18             	sub    $0x18,%esp
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008bf:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008c3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008cd:	85 c0                	test   %eax,%eax
  8008cf:	74 26                	je     8008f7 <vsnprintf+0x47>
  8008d1:	85 d2                	test   %edx,%edx
  8008d3:	7e 22                	jle    8008f7 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008d5:	ff 75 14             	pushl  0x14(%ebp)
  8008d8:	ff 75 10             	pushl  0x10(%ebp)
  8008db:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008de:	50                   	push   %eax
  8008df:	68 e5 02 80 00       	push   $0x8002e5
  8008e4:	e8 36 fa ff ff       	call   80031f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ec:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008f2:	83 c4 10             	add    $0x10,%esp
}
  8008f5:	c9                   	leave  
  8008f6:	c3                   	ret    
		return -E_INVAL;
  8008f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008fc:	eb f7                	jmp    8008f5 <vsnprintf+0x45>

008008fe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800904:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800907:	50                   	push   %eax
  800908:	ff 75 10             	pushl  0x10(%ebp)
  80090b:	ff 75 0c             	pushl  0xc(%ebp)
  80090e:	ff 75 08             	pushl  0x8(%ebp)
  800911:	e8 9a ff ff ff       	call   8008b0 <vsnprintf>
	va_end(ap);

	return rc;
}
  800916:	c9                   	leave  
  800917:	c3                   	ret    

00800918 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80091e:	b8 00 00 00 00       	mov    $0x0,%eax
  800923:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800927:	74 05                	je     80092e <strlen+0x16>
		n++;
  800929:	83 c0 01             	add    $0x1,%eax
  80092c:	eb f5                	jmp    800923 <strlen+0xb>
	return n;
}
  80092e:	5d                   	pop    %ebp
  80092f:	c3                   	ret    

00800930 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800930:	55                   	push   %ebp
  800931:	89 e5                	mov    %esp,%ebp
  800933:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800936:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800939:	ba 00 00 00 00       	mov    $0x0,%edx
  80093e:	39 c2                	cmp    %eax,%edx
  800940:	74 0d                	je     80094f <strnlen+0x1f>
  800942:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800946:	74 05                	je     80094d <strnlen+0x1d>
		n++;
  800948:	83 c2 01             	add    $0x1,%edx
  80094b:	eb f1                	jmp    80093e <strnlen+0xe>
  80094d:	89 d0                	mov    %edx,%eax
	return n;
}
  80094f:	5d                   	pop    %ebp
  800950:	c3                   	ret    

00800951 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	53                   	push   %ebx
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80095b:	ba 00 00 00 00       	mov    $0x0,%edx
  800960:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800964:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800967:	83 c2 01             	add    $0x1,%edx
  80096a:	84 c9                	test   %cl,%cl
  80096c:	75 f2                	jne    800960 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80096e:	5b                   	pop    %ebx
  80096f:	5d                   	pop    %ebp
  800970:	c3                   	ret    

00800971 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
  800974:	53                   	push   %ebx
  800975:	83 ec 10             	sub    $0x10,%esp
  800978:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80097b:	53                   	push   %ebx
  80097c:	e8 97 ff ff ff       	call   800918 <strlen>
  800981:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800984:	ff 75 0c             	pushl  0xc(%ebp)
  800987:	01 d8                	add    %ebx,%eax
  800989:	50                   	push   %eax
  80098a:	e8 c2 ff ff ff       	call   800951 <strcpy>
	return dst;
}
  80098f:	89 d8                	mov    %ebx,%eax
  800991:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800994:	c9                   	leave  
  800995:	c3                   	ret    

00800996 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800996:	55                   	push   %ebp
  800997:	89 e5                	mov    %esp,%ebp
  800999:	56                   	push   %esi
  80099a:	53                   	push   %ebx
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009a1:	89 c6                	mov    %eax,%esi
  8009a3:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a6:	89 c2                	mov    %eax,%edx
  8009a8:	39 f2                	cmp    %esi,%edx
  8009aa:	74 11                	je     8009bd <strncpy+0x27>
		*dst++ = *src;
  8009ac:	83 c2 01             	add    $0x1,%edx
  8009af:	0f b6 19             	movzbl (%ecx),%ebx
  8009b2:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009b5:	80 fb 01             	cmp    $0x1,%bl
  8009b8:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009bb:	eb eb                	jmp    8009a8 <strncpy+0x12>
	}
	return ret;
}
  8009bd:	5b                   	pop    %ebx
  8009be:	5e                   	pop    %esi
  8009bf:	5d                   	pop    %ebp
  8009c0:	c3                   	ret    

008009c1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009c1:	55                   	push   %ebp
  8009c2:	89 e5                	mov    %esp,%ebp
  8009c4:	56                   	push   %esi
  8009c5:	53                   	push   %ebx
  8009c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8009c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009cc:	8b 55 10             	mov    0x10(%ebp),%edx
  8009cf:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009d1:	85 d2                	test   %edx,%edx
  8009d3:	74 21                	je     8009f6 <strlcpy+0x35>
  8009d5:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009d9:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009db:	39 c2                	cmp    %eax,%edx
  8009dd:	74 14                	je     8009f3 <strlcpy+0x32>
  8009df:	0f b6 19             	movzbl (%ecx),%ebx
  8009e2:	84 db                	test   %bl,%bl
  8009e4:	74 0b                	je     8009f1 <strlcpy+0x30>
			*dst++ = *src++;
  8009e6:	83 c1 01             	add    $0x1,%ecx
  8009e9:	83 c2 01             	add    $0x1,%edx
  8009ec:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009ef:	eb ea                	jmp    8009db <strlcpy+0x1a>
  8009f1:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009f3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009f6:	29 f0                	sub    %esi,%eax
}
  8009f8:	5b                   	pop    %ebx
  8009f9:	5e                   	pop    %esi
  8009fa:	5d                   	pop    %ebp
  8009fb:	c3                   	ret    

008009fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
  8009ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a02:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a05:	0f b6 01             	movzbl (%ecx),%eax
  800a08:	84 c0                	test   %al,%al
  800a0a:	74 0c                	je     800a18 <strcmp+0x1c>
  800a0c:	3a 02                	cmp    (%edx),%al
  800a0e:	75 08                	jne    800a18 <strcmp+0x1c>
		p++, q++;
  800a10:	83 c1 01             	add    $0x1,%ecx
  800a13:	83 c2 01             	add    $0x1,%edx
  800a16:	eb ed                	jmp    800a05 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a18:	0f b6 c0             	movzbl %al,%eax
  800a1b:	0f b6 12             	movzbl (%edx),%edx
  800a1e:	29 d0                	sub    %edx,%eax
}
  800a20:	5d                   	pop    %ebp
  800a21:	c3                   	ret    

00800a22 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
  800a25:	53                   	push   %ebx
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2c:	89 c3                	mov    %eax,%ebx
  800a2e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a31:	eb 06                	jmp    800a39 <strncmp+0x17>
		n--, p++, q++;
  800a33:	83 c0 01             	add    $0x1,%eax
  800a36:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a39:	39 d8                	cmp    %ebx,%eax
  800a3b:	74 16                	je     800a53 <strncmp+0x31>
  800a3d:	0f b6 08             	movzbl (%eax),%ecx
  800a40:	84 c9                	test   %cl,%cl
  800a42:	74 04                	je     800a48 <strncmp+0x26>
  800a44:	3a 0a                	cmp    (%edx),%cl
  800a46:	74 eb                	je     800a33 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a48:	0f b6 00             	movzbl (%eax),%eax
  800a4b:	0f b6 12             	movzbl (%edx),%edx
  800a4e:	29 d0                	sub    %edx,%eax
}
  800a50:	5b                   	pop    %ebx
  800a51:	5d                   	pop    %ebp
  800a52:	c3                   	ret    
		return 0;
  800a53:	b8 00 00 00 00       	mov    $0x0,%eax
  800a58:	eb f6                	jmp    800a50 <strncmp+0x2e>

00800a5a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a60:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a64:	0f b6 10             	movzbl (%eax),%edx
  800a67:	84 d2                	test   %dl,%dl
  800a69:	74 09                	je     800a74 <strchr+0x1a>
		if (*s == c)
  800a6b:	38 ca                	cmp    %cl,%dl
  800a6d:	74 0a                	je     800a79 <strchr+0x1f>
	for (; *s; s++)
  800a6f:	83 c0 01             	add    $0x1,%eax
  800a72:	eb f0                	jmp    800a64 <strchr+0xa>
			return (char *) s;
	return 0;
  800a74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a79:	5d                   	pop    %ebp
  800a7a:	c3                   	ret    

00800a7b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a85:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a88:	38 ca                	cmp    %cl,%dl
  800a8a:	74 09                	je     800a95 <strfind+0x1a>
  800a8c:	84 d2                	test   %dl,%dl
  800a8e:	74 05                	je     800a95 <strfind+0x1a>
	for (; *s; s++)
  800a90:	83 c0 01             	add    $0x1,%eax
  800a93:	eb f0                	jmp    800a85 <strfind+0xa>
			break;
	return (char *) s;
}
  800a95:	5d                   	pop    %ebp
  800a96:	c3                   	ret    

00800a97 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
  800a9a:	57                   	push   %edi
  800a9b:	56                   	push   %esi
  800a9c:	53                   	push   %ebx
  800a9d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aa0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aa3:	85 c9                	test   %ecx,%ecx
  800aa5:	74 31                	je     800ad8 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aa7:	89 f8                	mov    %edi,%eax
  800aa9:	09 c8                	or     %ecx,%eax
  800aab:	a8 03                	test   $0x3,%al
  800aad:	75 23                	jne    800ad2 <memset+0x3b>
		c &= 0xFF;
  800aaf:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ab3:	89 d3                	mov    %edx,%ebx
  800ab5:	c1 e3 08             	shl    $0x8,%ebx
  800ab8:	89 d0                	mov    %edx,%eax
  800aba:	c1 e0 18             	shl    $0x18,%eax
  800abd:	89 d6                	mov    %edx,%esi
  800abf:	c1 e6 10             	shl    $0x10,%esi
  800ac2:	09 f0                	or     %esi,%eax
  800ac4:	09 c2                	or     %eax,%edx
  800ac6:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ac8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800acb:	89 d0                	mov    %edx,%eax
  800acd:	fc                   	cld    
  800ace:	f3 ab                	rep stos %eax,%es:(%edi)
  800ad0:	eb 06                	jmp    800ad8 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ad2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad5:	fc                   	cld    
  800ad6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ad8:	89 f8                	mov    %edi,%eax
  800ada:	5b                   	pop    %ebx
  800adb:	5e                   	pop    %esi
  800adc:	5f                   	pop    %edi
  800add:	5d                   	pop    %ebp
  800ade:	c3                   	ret    

00800adf <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800adf:	55                   	push   %ebp
  800ae0:	89 e5                	mov    %esp,%ebp
  800ae2:	57                   	push   %edi
  800ae3:	56                   	push   %esi
  800ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aea:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aed:	39 c6                	cmp    %eax,%esi
  800aef:	73 32                	jae    800b23 <memmove+0x44>
  800af1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800af4:	39 c2                	cmp    %eax,%edx
  800af6:	76 2b                	jbe    800b23 <memmove+0x44>
		s += n;
		d += n;
  800af8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800afb:	89 fe                	mov    %edi,%esi
  800afd:	09 ce                	or     %ecx,%esi
  800aff:	09 d6                	or     %edx,%esi
  800b01:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b07:	75 0e                	jne    800b17 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b09:	83 ef 04             	sub    $0x4,%edi
  800b0c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b0f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b12:	fd                   	std    
  800b13:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b15:	eb 09                	jmp    800b20 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b17:	83 ef 01             	sub    $0x1,%edi
  800b1a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b1d:	fd                   	std    
  800b1e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b20:	fc                   	cld    
  800b21:	eb 1a                	jmp    800b3d <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b23:	89 c2                	mov    %eax,%edx
  800b25:	09 ca                	or     %ecx,%edx
  800b27:	09 f2                	or     %esi,%edx
  800b29:	f6 c2 03             	test   $0x3,%dl
  800b2c:	75 0a                	jne    800b38 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b2e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b31:	89 c7                	mov    %eax,%edi
  800b33:	fc                   	cld    
  800b34:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b36:	eb 05                	jmp    800b3d <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b38:	89 c7                	mov    %eax,%edi
  800b3a:	fc                   	cld    
  800b3b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b3d:	5e                   	pop    %esi
  800b3e:	5f                   	pop    %edi
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    

00800b41 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
  800b44:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b47:	ff 75 10             	pushl  0x10(%ebp)
  800b4a:	ff 75 0c             	pushl  0xc(%ebp)
  800b4d:	ff 75 08             	pushl  0x8(%ebp)
  800b50:	e8 8a ff ff ff       	call   800adf <memmove>
}
  800b55:	c9                   	leave  
  800b56:	c3                   	ret    

00800b57 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b57:	55                   	push   %ebp
  800b58:	89 e5                	mov    %esp,%ebp
  800b5a:	56                   	push   %esi
  800b5b:	53                   	push   %ebx
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b62:	89 c6                	mov    %eax,%esi
  800b64:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b67:	39 f0                	cmp    %esi,%eax
  800b69:	74 1c                	je     800b87 <memcmp+0x30>
		if (*s1 != *s2)
  800b6b:	0f b6 08             	movzbl (%eax),%ecx
  800b6e:	0f b6 1a             	movzbl (%edx),%ebx
  800b71:	38 d9                	cmp    %bl,%cl
  800b73:	75 08                	jne    800b7d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b75:	83 c0 01             	add    $0x1,%eax
  800b78:	83 c2 01             	add    $0x1,%edx
  800b7b:	eb ea                	jmp    800b67 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b7d:	0f b6 c1             	movzbl %cl,%eax
  800b80:	0f b6 db             	movzbl %bl,%ebx
  800b83:	29 d8                	sub    %ebx,%eax
  800b85:	eb 05                	jmp    800b8c <memcmp+0x35>
	}

	return 0;
  800b87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b8c:	5b                   	pop    %ebx
  800b8d:	5e                   	pop    %esi
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	8b 45 08             	mov    0x8(%ebp),%eax
  800b96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b99:	89 c2                	mov    %eax,%edx
  800b9b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b9e:	39 d0                	cmp    %edx,%eax
  800ba0:	73 09                	jae    800bab <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ba2:	38 08                	cmp    %cl,(%eax)
  800ba4:	74 05                	je     800bab <memfind+0x1b>
	for (; s < ends; s++)
  800ba6:	83 c0 01             	add    $0x1,%eax
  800ba9:	eb f3                	jmp    800b9e <memfind+0xe>
			break;
	return (void *) s;
}
  800bab:	5d                   	pop    %ebp
  800bac:	c3                   	ret    

00800bad <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	57                   	push   %edi
  800bb1:	56                   	push   %esi
  800bb2:	53                   	push   %ebx
  800bb3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bb6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bb9:	eb 03                	jmp    800bbe <strtol+0x11>
		s++;
  800bbb:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bbe:	0f b6 01             	movzbl (%ecx),%eax
  800bc1:	3c 20                	cmp    $0x20,%al
  800bc3:	74 f6                	je     800bbb <strtol+0xe>
  800bc5:	3c 09                	cmp    $0x9,%al
  800bc7:	74 f2                	je     800bbb <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bc9:	3c 2b                	cmp    $0x2b,%al
  800bcb:	74 2a                	je     800bf7 <strtol+0x4a>
	int neg = 0;
  800bcd:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bd2:	3c 2d                	cmp    $0x2d,%al
  800bd4:	74 2b                	je     800c01 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bd6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bdc:	75 0f                	jne    800bed <strtol+0x40>
  800bde:	80 39 30             	cmpb   $0x30,(%ecx)
  800be1:	74 28                	je     800c0b <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800be3:	85 db                	test   %ebx,%ebx
  800be5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bea:	0f 44 d8             	cmove  %eax,%ebx
  800bed:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf2:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bf5:	eb 50                	jmp    800c47 <strtol+0x9a>
		s++;
  800bf7:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bfa:	bf 00 00 00 00       	mov    $0x0,%edi
  800bff:	eb d5                	jmp    800bd6 <strtol+0x29>
		s++, neg = 1;
  800c01:	83 c1 01             	add    $0x1,%ecx
  800c04:	bf 01 00 00 00       	mov    $0x1,%edi
  800c09:	eb cb                	jmp    800bd6 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c0b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c0f:	74 0e                	je     800c1f <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c11:	85 db                	test   %ebx,%ebx
  800c13:	75 d8                	jne    800bed <strtol+0x40>
		s++, base = 8;
  800c15:	83 c1 01             	add    $0x1,%ecx
  800c18:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c1d:	eb ce                	jmp    800bed <strtol+0x40>
		s += 2, base = 16;
  800c1f:	83 c1 02             	add    $0x2,%ecx
  800c22:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c27:	eb c4                	jmp    800bed <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c29:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c2c:	89 f3                	mov    %esi,%ebx
  800c2e:	80 fb 19             	cmp    $0x19,%bl
  800c31:	77 29                	ja     800c5c <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c33:	0f be d2             	movsbl %dl,%edx
  800c36:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c39:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c3c:	7d 30                	jge    800c6e <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c3e:	83 c1 01             	add    $0x1,%ecx
  800c41:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c45:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c47:	0f b6 11             	movzbl (%ecx),%edx
  800c4a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c4d:	89 f3                	mov    %esi,%ebx
  800c4f:	80 fb 09             	cmp    $0x9,%bl
  800c52:	77 d5                	ja     800c29 <strtol+0x7c>
			dig = *s - '0';
  800c54:	0f be d2             	movsbl %dl,%edx
  800c57:	83 ea 30             	sub    $0x30,%edx
  800c5a:	eb dd                	jmp    800c39 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c5c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c5f:	89 f3                	mov    %esi,%ebx
  800c61:	80 fb 19             	cmp    $0x19,%bl
  800c64:	77 08                	ja     800c6e <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c66:	0f be d2             	movsbl %dl,%edx
  800c69:	83 ea 37             	sub    $0x37,%edx
  800c6c:	eb cb                	jmp    800c39 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c6e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c72:	74 05                	je     800c79 <strtol+0xcc>
		*endptr = (char *) s;
  800c74:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c77:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c79:	89 c2                	mov    %eax,%edx
  800c7b:	f7 da                	neg    %edx
  800c7d:	85 ff                	test   %edi,%edi
  800c7f:	0f 45 c2             	cmovne %edx,%eax
}
  800c82:	5b                   	pop    %ebx
  800c83:	5e                   	pop    %esi
  800c84:	5f                   	pop    %edi
  800c85:	5d                   	pop    %ebp
  800c86:	c3                   	ret    

00800c87 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	57                   	push   %edi
  800c8b:	56                   	push   %esi
  800c8c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c8d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c92:	8b 55 08             	mov    0x8(%ebp),%edx
  800c95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c98:	89 c3                	mov    %eax,%ebx
  800c9a:	89 c7                	mov    %eax,%edi
  800c9c:	89 c6                	mov    %eax,%esi
  800c9e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ca0:	5b                   	pop    %ebx
  800ca1:	5e                   	pop    %esi
  800ca2:	5f                   	pop    %edi
  800ca3:	5d                   	pop    %ebp
  800ca4:	c3                   	ret    

00800ca5 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	57                   	push   %edi
  800ca9:	56                   	push   %esi
  800caa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cab:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb0:	b8 01 00 00 00       	mov    $0x1,%eax
  800cb5:	89 d1                	mov    %edx,%ecx
  800cb7:	89 d3                	mov    %edx,%ebx
  800cb9:	89 d7                	mov    %edx,%edi
  800cbb:	89 d6                	mov    %edx,%esi
  800cbd:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cbf:	5b                   	pop    %ebx
  800cc0:	5e                   	pop    %esi
  800cc1:	5f                   	pop    %edi
  800cc2:	5d                   	pop    %ebp
  800cc3:	c3                   	ret    

00800cc4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	57                   	push   %edi
  800cc8:	56                   	push   %esi
  800cc9:	53                   	push   %ebx
  800cca:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ccd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd5:	b8 03 00 00 00       	mov    $0x3,%eax
  800cda:	89 cb                	mov    %ecx,%ebx
  800cdc:	89 cf                	mov    %ecx,%edi
  800cde:	89 ce                	mov    %ecx,%esi
  800ce0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce2:	85 c0                	test   %eax,%eax
  800ce4:	7f 08                	jg     800cee <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ce6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce9:	5b                   	pop    %ebx
  800cea:	5e                   	pop    %esi
  800ceb:	5f                   	pop    %edi
  800cec:	5d                   	pop    %ebp
  800ced:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cee:	83 ec 0c             	sub    $0xc,%esp
  800cf1:	50                   	push   %eax
  800cf2:	6a 03                	push   $0x3
  800cf4:	68 24 29 80 00       	push   $0x802924
  800cf9:	6a 43                	push   $0x43
  800cfb:	68 41 29 80 00       	push   $0x802941
  800d00:	e8 65 15 00 00       	call   80226a <_panic>

00800d05 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	57                   	push   %edi
  800d09:	56                   	push   %esi
  800d0a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d10:	b8 02 00 00 00       	mov    $0x2,%eax
  800d15:	89 d1                	mov    %edx,%ecx
  800d17:	89 d3                	mov    %edx,%ebx
  800d19:	89 d7                	mov    %edx,%edi
  800d1b:	89 d6                	mov    %edx,%esi
  800d1d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d1f:	5b                   	pop    %ebx
  800d20:	5e                   	pop    %esi
  800d21:	5f                   	pop    %edi
  800d22:	5d                   	pop    %ebp
  800d23:	c3                   	ret    

00800d24 <sys_yield>:

void
sys_yield(void)
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	57                   	push   %edi
  800d28:	56                   	push   %esi
  800d29:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d2a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d2f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d34:	89 d1                	mov    %edx,%ecx
  800d36:	89 d3                	mov    %edx,%ebx
  800d38:	89 d7                	mov    %edx,%edi
  800d3a:	89 d6                	mov    %edx,%esi
  800d3c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d3e:	5b                   	pop    %ebx
  800d3f:	5e                   	pop    %esi
  800d40:	5f                   	pop    %edi
  800d41:	5d                   	pop    %ebp
  800d42:	c3                   	ret    

00800d43 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	57                   	push   %edi
  800d47:	56                   	push   %esi
  800d48:	53                   	push   %ebx
  800d49:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4c:	be 00 00 00 00       	mov    $0x0,%esi
  800d51:	8b 55 08             	mov    0x8(%ebp),%edx
  800d54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d57:	b8 04 00 00 00       	mov    $0x4,%eax
  800d5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d5f:	89 f7                	mov    %esi,%edi
  800d61:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d63:	85 c0                	test   %eax,%eax
  800d65:	7f 08                	jg     800d6f <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6a:	5b                   	pop    %ebx
  800d6b:	5e                   	pop    %esi
  800d6c:	5f                   	pop    %edi
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6f:	83 ec 0c             	sub    $0xc,%esp
  800d72:	50                   	push   %eax
  800d73:	6a 04                	push   $0x4
  800d75:	68 24 29 80 00       	push   $0x802924
  800d7a:	6a 43                	push   $0x43
  800d7c:	68 41 29 80 00       	push   $0x802941
  800d81:	e8 e4 14 00 00       	call   80226a <_panic>

00800d86 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	57                   	push   %edi
  800d8a:	56                   	push   %esi
  800d8b:	53                   	push   %ebx
  800d8c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d95:	b8 05 00 00 00       	mov    $0x5,%eax
  800d9a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d9d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800da0:	8b 75 18             	mov    0x18(%ebp),%esi
  800da3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da5:	85 c0                	test   %eax,%eax
  800da7:	7f 08                	jg     800db1 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800da9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dac:	5b                   	pop    %ebx
  800dad:	5e                   	pop    %esi
  800dae:	5f                   	pop    %edi
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db1:	83 ec 0c             	sub    $0xc,%esp
  800db4:	50                   	push   %eax
  800db5:	6a 05                	push   $0x5
  800db7:	68 24 29 80 00       	push   $0x802924
  800dbc:	6a 43                	push   $0x43
  800dbe:	68 41 29 80 00       	push   $0x802941
  800dc3:	e8 a2 14 00 00       	call   80226a <_panic>

00800dc8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	57                   	push   %edi
  800dcc:	56                   	push   %esi
  800dcd:	53                   	push   %ebx
  800dce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ddc:	b8 06 00 00 00       	mov    $0x6,%eax
  800de1:	89 df                	mov    %ebx,%edi
  800de3:	89 de                	mov    %ebx,%esi
  800de5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de7:	85 c0                	test   %eax,%eax
  800de9:	7f 08                	jg     800df3 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800deb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dee:	5b                   	pop    %ebx
  800def:	5e                   	pop    %esi
  800df0:	5f                   	pop    %edi
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df3:	83 ec 0c             	sub    $0xc,%esp
  800df6:	50                   	push   %eax
  800df7:	6a 06                	push   $0x6
  800df9:	68 24 29 80 00       	push   $0x802924
  800dfe:	6a 43                	push   $0x43
  800e00:	68 41 29 80 00       	push   $0x802941
  800e05:	e8 60 14 00 00       	call   80226a <_panic>

00800e0a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	57                   	push   %edi
  800e0e:	56                   	push   %esi
  800e0f:	53                   	push   %ebx
  800e10:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e13:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e18:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1e:	b8 08 00 00 00       	mov    $0x8,%eax
  800e23:	89 df                	mov    %ebx,%edi
  800e25:	89 de                	mov    %ebx,%esi
  800e27:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e29:	85 c0                	test   %eax,%eax
  800e2b:	7f 08                	jg     800e35 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e30:	5b                   	pop    %ebx
  800e31:	5e                   	pop    %esi
  800e32:	5f                   	pop    %edi
  800e33:	5d                   	pop    %ebp
  800e34:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e35:	83 ec 0c             	sub    $0xc,%esp
  800e38:	50                   	push   %eax
  800e39:	6a 08                	push   $0x8
  800e3b:	68 24 29 80 00       	push   $0x802924
  800e40:	6a 43                	push   $0x43
  800e42:	68 41 29 80 00       	push   $0x802941
  800e47:	e8 1e 14 00 00       	call   80226a <_panic>

00800e4c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	57                   	push   %edi
  800e50:	56                   	push   %esi
  800e51:	53                   	push   %ebx
  800e52:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e55:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e60:	b8 09 00 00 00       	mov    $0x9,%eax
  800e65:	89 df                	mov    %ebx,%edi
  800e67:	89 de                	mov    %ebx,%esi
  800e69:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6b:	85 c0                	test   %eax,%eax
  800e6d:	7f 08                	jg     800e77 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e72:	5b                   	pop    %ebx
  800e73:	5e                   	pop    %esi
  800e74:	5f                   	pop    %edi
  800e75:	5d                   	pop    %ebp
  800e76:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e77:	83 ec 0c             	sub    $0xc,%esp
  800e7a:	50                   	push   %eax
  800e7b:	6a 09                	push   $0x9
  800e7d:	68 24 29 80 00       	push   $0x802924
  800e82:	6a 43                	push   $0x43
  800e84:	68 41 29 80 00       	push   $0x802941
  800e89:	e8 dc 13 00 00       	call   80226a <_panic>

00800e8e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	57                   	push   %edi
  800e92:	56                   	push   %esi
  800e93:	53                   	push   %ebx
  800e94:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e97:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ea7:	89 df                	mov    %ebx,%edi
  800ea9:	89 de                	mov    %ebx,%esi
  800eab:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ead:	85 c0                	test   %eax,%eax
  800eaf:	7f 08                	jg     800eb9 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb4:	5b                   	pop    %ebx
  800eb5:	5e                   	pop    %esi
  800eb6:	5f                   	pop    %edi
  800eb7:	5d                   	pop    %ebp
  800eb8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb9:	83 ec 0c             	sub    $0xc,%esp
  800ebc:	50                   	push   %eax
  800ebd:	6a 0a                	push   $0xa
  800ebf:	68 24 29 80 00       	push   $0x802924
  800ec4:	6a 43                	push   $0x43
  800ec6:	68 41 29 80 00       	push   $0x802941
  800ecb:	e8 9a 13 00 00       	call   80226a <_panic>

00800ed0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	57                   	push   %edi
  800ed4:	56                   	push   %esi
  800ed5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edc:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ee1:	be 00 00 00 00       	mov    $0x0,%esi
  800ee6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eec:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eee:	5b                   	pop    %ebx
  800eef:	5e                   	pop    %esi
  800ef0:	5f                   	pop    %edi
  800ef1:	5d                   	pop    %ebp
  800ef2:	c3                   	ret    

00800ef3 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	57                   	push   %edi
  800ef7:	56                   	push   %esi
  800ef8:	53                   	push   %ebx
  800ef9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800efc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f01:	8b 55 08             	mov    0x8(%ebp),%edx
  800f04:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f09:	89 cb                	mov    %ecx,%ebx
  800f0b:	89 cf                	mov    %ecx,%edi
  800f0d:	89 ce                	mov    %ecx,%esi
  800f0f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f11:	85 c0                	test   %eax,%eax
  800f13:	7f 08                	jg     800f1d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f18:	5b                   	pop    %ebx
  800f19:	5e                   	pop    %esi
  800f1a:	5f                   	pop    %edi
  800f1b:	5d                   	pop    %ebp
  800f1c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1d:	83 ec 0c             	sub    $0xc,%esp
  800f20:	50                   	push   %eax
  800f21:	6a 0d                	push   $0xd
  800f23:	68 24 29 80 00       	push   $0x802924
  800f28:	6a 43                	push   $0x43
  800f2a:	68 41 29 80 00       	push   $0x802941
  800f2f:	e8 36 13 00 00       	call   80226a <_panic>

00800f34 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	57                   	push   %edi
  800f38:	56                   	push   %esi
  800f39:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f45:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f4a:	89 df                	mov    %ebx,%edi
  800f4c:	89 de                	mov    %ebx,%esi
  800f4e:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f50:	5b                   	pop    %ebx
  800f51:	5e                   	pop    %esi
  800f52:	5f                   	pop    %edi
  800f53:	5d                   	pop    %ebp
  800f54:	c3                   	ret    

00800f55 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	57                   	push   %edi
  800f59:	56                   	push   %esi
  800f5a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f5b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f60:	8b 55 08             	mov    0x8(%ebp),%edx
  800f63:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f68:	89 cb                	mov    %ecx,%ebx
  800f6a:	89 cf                	mov    %ecx,%edi
  800f6c:	89 ce                	mov    %ecx,%esi
  800f6e:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f70:	5b                   	pop    %ebx
  800f71:	5e                   	pop    %esi
  800f72:	5f                   	pop    %edi
  800f73:	5d                   	pop    %ebp
  800f74:	c3                   	ret    

00800f75 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f75:	55                   	push   %ebp
  800f76:	89 e5                	mov    %esp,%ebp
  800f78:	57                   	push   %edi
  800f79:	56                   	push   %esi
  800f7a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f80:	b8 10 00 00 00       	mov    $0x10,%eax
  800f85:	89 d1                	mov    %edx,%ecx
  800f87:	89 d3                	mov    %edx,%ebx
  800f89:	89 d7                	mov    %edx,%edi
  800f8b:	89 d6                	mov    %edx,%esi
  800f8d:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f8f:	5b                   	pop    %ebx
  800f90:	5e                   	pop    %esi
  800f91:	5f                   	pop    %edi
  800f92:	5d                   	pop    %ebp
  800f93:	c3                   	ret    

00800f94 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f94:	55                   	push   %ebp
  800f95:	89 e5                	mov    %esp,%ebp
  800f97:	57                   	push   %edi
  800f98:	56                   	push   %esi
  800f99:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f9a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa5:	b8 11 00 00 00       	mov    $0x11,%eax
  800faa:	89 df                	mov    %ebx,%edi
  800fac:	89 de                	mov    %ebx,%esi
  800fae:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fb0:	5b                   	pop    %ebx
  800fb1:	5e                   	pop    %esi
  800fb2:	5f                   	pop    %edi
  800fb3:	5d                   	pop    %ebp
  800fb4:	c3                   	ret    

00800fb5 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
  800fb8:	57                   	push   %edi
  800fb9:	56                   	push   %esi
  800fba:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fbb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc6:	b8 12 00 00 00       	mov    $0x12,%eax
  800fcb:	89 df                	mov    %ebx,%edi
  800fcd:	89 de                	mov    %ebx,%esi
  800fcf:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fd1:	5b                   	pop    %ebx
  800fd2:	5e                   	pop    %esi
  800fd3:	5f                   	pop    %edi
  800fd4:	5d                   	pop    %ebp
  800fd5:	c3                   	ret    

00800fd6 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fd6:	55                   	push   %ebp
  800fd7:	89 e5                	mov    %esp,%ebp
  800fd9:	57                   	push   %edi
  800fda:	56                   	push   %esi
  800fdb:	53                   	push   %ebx
  800fdc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fdf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fea:	b8 13 00 00 00       	mov    $0x13,%eax
  800fef:	89 df                	mov    %ebx,%edi
  800ff1:	89 de                	mov    %ebx,%esi
  800ff3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ff5:	85 c0                	test   %eax,%eax
  800ff7:	7f 08                	jg     801001 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ff9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ffc:	5b                   	pop    %ebx
  800ffd:	5e                   	pop    %esi
  800ffe:	5f                   	pop    %edi
  800fff:	5d                   	pop    %ebp
  801000:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801001:	83 ec 0c             	sub    $0xc,%esp
  801004:	50                   	push   %eax
  801005:	6a 13                	push   $0x13
  801007:	68 24 29 80 00       	push   $0x802924
  80100c:	6a 43                	push   $0x43
  80100e:	68 41 29 80 00       	push   $0x802941
  801013:	e8 52 12 00 00       	call   80226a <_panic>

00801018 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	56                   	push   %esi
  80101c:	53                   	push   %ebx
  80101d:	8b 75 08             	mov    0x8(%ebp),%esi
  801020:	8b 45 0c             	mov    0xc(%ebp),%eax
  801023:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  801026:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801028:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80102d:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  801030:	83 ec 0c             	sub    $0xc,%esp
  801033:	50                   	push   %eax
  801034:	e8 ba fe ff ff       	call   800ef3 <sys_ipc_recv>
	if(ret < 0){
  801039:	83 c4 10             	add    $0x10,%esp
  80103c:	85 c0                	test   %eax,%eax
  80103e:	78 2b                	js     80106b <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  801040:	85 f6                	test   %esi,%esi
  801042:	74 0a                	je     80104e <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  801044:	a1 08 40 80 00       	mov    0x804008,%eax
  801049:	8b 40 74             	mov    0x74(%eax),%eax
  80104c:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80104e:	85 db                	test   %ebx,%ebx
  801050:	74 0a                	je     80105c <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  801052:	a1 08 40 80 00       	mov    0x804008,%eax
  801057:	8b 40 78             	mov    0x78(%eax),%eax
  80105a:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  80105c:	a1 08 40 80 00       	mov    0x804008,%eax
  801061:	8b 40 70             	mov    0x70(%eax),%eax
}
  801064:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801067:	5b                   	pop    %ebx
  801068:	5e                   	pop    %esi
  801069:	5d                   	pop    %ebp
  80106a:	c3                   	ret    
		if(from_env_store)
  80106b:	85 f6                	test   %esi,%esi
  80106d:	74 06                	je     801075 <ipc_recv+0x5d>
			*from_env_store = 0;
  80106f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  801075:	85 db                	test   %ebx,%ebx
  801077:	74 eb                	je     801064 <ipc_recv+0x4c>
			*perm_store = 0;
  801079:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80107f:	eb e3                	jmp    801064 <ipc_recv+0x4c>

00801081 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
  801084:	57                   	push   %edi
  801085:	56                   	push   %esi
  801086:	53                   	push   %ebx
  801087:	83 ec 0c             	sub    $0xc,%esp
  80108a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80108d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801090:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  801093:	85 db                	test   %ebx,%ebx
  801095:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80109a:	0f 44 d8             	cmove  %eax,%ebx
  80109d:	eb 05                	jmp    8010a4 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80109f:	e8 80 fc ff ff       	call   800d24 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8010a4:	ff 75 14             	pushl  0x14(%ebp)
  8010a7:	53                   	push   %ebx
  8010a8:	56                   	push   %esi
  8010a9:	57                   	push   %edi
  8010aa:	e8 21 fe ff ff       	call   800ed0 <sys_ipc_try_send>
  8010af:	83 c4 10             	add    $0x10,%esp
  8010b2:	85 c0                	test   %eax,%eax
  8010b4:	74 1b                	je     8010d1 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8010b6:	79 e7                	jns    80109f <ipc_send+0x1e>
  8010b8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8010bb:	74 e2                	je     80109f <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8010bd:	83 ec 04             	sub    $0x4,%esp
  8010c0:	68 4f 29 80 00       	push   $0x80294f
  8010c5:	6a 48                	push   $0x48
  8010c7:	68 64 29 80 00       	push   $0x802964
  8010cc:	e8 99 11 00 00       	call   80226a <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8010d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010d4:	5b                   	pop    %ebx
  8010d5:	5e                   	pop    %esi
  8010d6:	5f                   	pop    %edi
  8010d7:	5d                   	pop    %ebp
  8010d8:	c3                   	ret    

008010d9 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8010df:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8010e4:	89 c2                	mov    %eax,%edx
  8010e6:	c1 e2 07             	shl    $0x7,%edx
  8010e9:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8010ef:	8b 52 50             	mov    0x50(%edx),%edx
  8010f2:	39 ca                	cmp    %ecx,%edx
  8010f4:	74 11                	je     801107 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8010f6:	83 c0 01             	add    $0x1,%eax
  8010f9:	3d 00 04 00 00       	cmp    $0x400,%eax
  8010fe:	75 e4                	jne    8010e4 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801100:	b8 00 00 00 00       	mov    $0x0,%eax
  801105:	eb 0b                	jmp    801112 <ipc_find_env+0x39>
			return envs[i].env_id;
  801107:	c1 e0 07             	shl    $0x7,%eax
  80110a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80110f:	8b 40 48             	mov    0x48(%eax),%eax
}
  801112:	5d                   	pop    %ebp
  801113:	c3                   	ret    

00801114 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	05 00 00 00 30       	add    $0x30000000,%eax
  80111f:	c1 e8 0c             	shr    $0xc,%eax
}
  801122:	5d                   	pop    %ebp
  801123:	c3                   	ret    

00801124 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801124:	55                   	push   %ebp
  801125:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
  80112a:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80112f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801134:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801139:	5d                   	pop    %ebp
  80113a:	c3                   	ret    

0080113b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80113b:	55                   	push   %ebp
  80113c:	89 e5                	mov    %esp,%ebp
  80113e:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801143:	89 c2                	mov    %eax,%edx
  801145:	c1 ea 16             	shr    $0x16,%edx
  801148:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80114f:	f6 c2 01             	test   $0x1,%dl
  801152:	74 2d                	je     801181 <fd_alloc+0x46>
  801154:	89 c2                	mov    %eax,%edx
  801156:	c1 ea 0c             	shr    $0xc,%edx
  801159:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801160:	f6 c2 01             	test   $0x1,%dl
  801163:	74 1c                	je     801181 <fd_alloc+0x46>
  801165:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80116a:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80116f:	75 d2                	jne    801143 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80117a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80117f:	eb 0a                	jmp    80118b <fd_alloc+0x50>
			*fd_store = fd;
  801181:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801184:	89 01                	mov    %eax,(%ecx)
			return 0;
  801186:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80118b:	5d                   	pop    %ebp
  80118c:	c3                   	ret    

0080118d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801193:	83 f8 1f             	cmp    $0x1f,%eax
  801196:	77 30                	ja     8011c8 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801198:	c1 e0 0c             	shl    $0xc,%eax
  80119b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011a0:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8011a6:	f6 c2 01             	test   $0x1,%dl
  8011a9:	74 24                	je     8011cf <fd_lookup+0x42>
  8011ab:	89 c2                	mov    %eax,%edx
  8011ad:	c1 ea 0c             	shr    $0xc,%edx
  8011b0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011b7:	f6 c2 01             	test   $0x1,%dl
  8011ba:	74 1a                	je     8011d6 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011bf:	89 02                	mov    %eax,(%edx)
	return 0;
  8011c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011c6:	5d                   	pop    %ebp
  8011c7:	c3                   	ret    
		return -E_INVAL;
  8011c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011cd:	eb f7                	jmp    8011c6 <fd_lookup+0x39>
		return -E_INVAL;
  8011cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011d4:	eb f0                	jmp    8011c6 <fd_lookup+0x39>
  8011d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011db:	eb e9                	jmp    8011c6 <fd_lookup+0x39>

008011dd <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	83 ec 08             	sub    $0x8,%esp
  8011e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8011e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8011eb:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011f0:	39 08                	cmp    %ecx,(%eax)
  8011f2:	74 38                	je     80122c <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8011f4:	83 c2 01             	add    $0x1,%edx
  8011f7:	8b 04 95 ec 29 80 00 	mov    0x8029ec(,%edx,4),%eax
  8011fe:	85 c0                	test   %eax,%eax
  801200:	75 ee                	jne    8011f0 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801202:	a1 08 40 80 00       	mov    0x804008,%eax
  801207:	8b 40 48             	mov    0x48(%eax),%eax
  80120a:	83 ec 04             	sub    $0x4,%esp
  80120d:	51                   	push   %ecx
  80120e:	50                   	push   %eax
  80120f:	68 70 29 80 00       	push   $0x802970
  801214:	e8 d9 ef ff ff       	call   8001f2 <cprintf>
	*dev = 0;
  801219:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801222:	83 c4 10             	add    $0x10,%esp
  801225:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80122a:	c9                   	leave  
  80122b:	c3                   	ret    
			*dev = devtab[i];
  80122c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80122f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801231:	b8 00 00 00 00       	mov    $0x0,%eax
  801236:	eb f2                	jmp    80122a <dev_lookup+0x4d>

00801238 <fd_close>:
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
  80123b:	57                   	push   %edi
  80123c:	56                   	push   %esi
  80123d:	53                   	push   %ebx
  80123e:	83 ec 24             	sub    $0x24,%esp
  801241:	8b 75 08             	mov    0x8(%ebp),%esi
  801244:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801247:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80124a:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80124b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801251:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801254:	50                   	push   %eax
  801255:	e8 33 ff ff ff       	call   80118d <fd_lookup>
  80125a:	89 c3                	mov    %eax,%ebx
  80125c:	83 c4 10             	add    $0x10,%esp
  80125f:	85 c0                	test   %eax,%eax
  801261:	78 05                	js     801268 <fd_close+0x30>
	    || fd != fd2)
  801263:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801266:	74 16                	je     80127e <fd_close+0x46>
		return (must_exist ? r : 0);
  801268:	89 f8                	mov    %edi,%eax
  80126a:	84 c0                	test   %al,%al
  80126c:	b8 00 00 00 00       	mov    $0x0,%eax
  801271:	0f 44 d8             	cmove  %eax,%ebx
}
  801274:	89 d8                	mov    %ebx,%eax
  801276:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801279:	5b                   	pop    %ebx
  80127a:	5e                   	pop    %esi
  80127b:	5f                   	pop    %edi
  80127c:	5d                   	pop    %ebp
  80127d:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80127e:	83 ec 08             	sub    $0x8,%esp
  801281:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801284:	50                   	push   %eax
  801285:	ff 36                	pushl  (%esi)
  801287:	e8 51 ff ff ff       	call   8011dd <dev_lookup>
  80128c:	89 c3                	mov    %eax,%ebx
  80128e:	83 c4 10             	add    $0x10,%esp
  801291:	85 c0                	test   %eax,%eax
  801293:	78 1a                	js     8012af <fd_close+0x77>
		if (dev->dev_close)
  801295:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801298:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80129b:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012a0:	85 c0                	test   %eax,%eax
  8012a2:	74 0b                	je     8012af <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8012a4:	83 ec 0c             	sub    $0xc,%esp
  8012a7:	56                   	push   %esi
  8012a8:	ff d0                	call   *%eax
  8012aa:	89 c3                	mov    %eax,%ebx
  8012ac:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012af:	83 ec 08             	sub    $0x8,%esp
  8012b2:	56                   	push   %esi
  8012b3:	6a 00                	push   $0x0
  8012b5:	e8 0e fb ff ff       	call   800dc8 <sys_page_unmap>
	return r;
  8012ba:	83 c4 10             	add    $0x10,%esp
  8012bd:	eb b5                	jmp    801274 <fd_close+0x3c>

008012bf <close>:

int
close(int fdnum)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c8:	50                   	push   %eax
  8012c9:	ff 75 08             	pushl  0x8(%ebp)
  8012cc:	e8 bc fe ff ff       	call   80118d <fd_lookup>
  8012d1:	83 c4 10             	add    $0x10,%esp
  8012d4:	85 c0                	test   %eax,%eax
  8012d6:	79 02                	jns    8012da <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8012d8:	c9                   	leave  
  8012d9:	c3                   	ret    
		return fd_close(fd, 1);
  8012da:	83 ec 08             	sub    $0x8,%esp
  8012dd:	6a 01                	push   $0x1
  8012df:	ff 75 f4             	pushl  -0xc(%ebp)
  8012e2:	e8 51 ff ff ff       	call   801238 <fd_close>
  8012e7:	83 c4 10             	add    $0x10,%esp
  8012ea:	eb ec                	jmp    8012d8 <close+0x19>

008012ec <close_all>:

void
close_all(void)
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
  8012ef:	53                   	push   %ebx
  8012f0:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012f3:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012f8:	83 ec 0c             	sub    $0xc,%esp
  8012fb:	53                   	push   %ebx
  8012fc:	e8 be ff ff ff       	call   8012bf <close>
	for (i = 0; i < MAXFD; i++)
  801301:	83 c3 01             	add    $0x1,%ebx
  801304:	83 c4 10             	add    $0x10,%esp
  801307:	83 fb 20             	cmp    $0x20,%ebx
  80130a:	75 ec                	jne    8012f8 <close_all+0xc>
}
  80130c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80130f:	c9                   	leave  
  801310:	c3                   	ret    

00801311 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
  801314:	57                   	push   %edi
  801315:	56                   	push   %esi
  801316:	53                   	push   %ebx
  801317:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80131a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80131d:	50                   	push   %eax
  80131e:	ff 75 08             	pushl  0x8(%ebp)
  801321:	e8 67 fe ff ff       	call   80118d <fd_lookup>
  801326:	89 c3                	mov    %eax,%ebx
  801328:	83 c4 10             	add    $0x10,%esp
  80132b:	85 c0                	test   %eax,%eax
  80132d:	0f 88 81 00 00 00    	js     8013b4 <dup+0xa3>
		return r;
	close(newfdnum);
  801333:	83 ec 0c             	sub    $0xc,%esp
  801336:	ff 75 0c             	pushl  0xc(%ebp)
  801339:	e8 81 ff ff ff       	call   8012bf <close>

	newfd = INDEX2FD(newfdnum);
  80133e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801341:	c1 e6 0c             	shl    $0xc,%esi
  801344:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80134a:	83 c4 04             	add    $0x4,%esp
  80134d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801350:	e8 cf fd ff ff       	call   801124 <fd2data>
  801355:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801357:	89 34 24             	mov    %esi,(%esp)
  80135a:	e8 c5 fd ff ff       	call   801124 <fd2data>
  80135f:	83 c4 10             	add    $0x10,%esp
  801362:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801364:	89 d8                	mov    %ebx,%eax
  801366:	c1 e8 16             	shr    $0x16,%eax
  801369:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801370:	a8 01                	test   $0x1,%al
  801372:	74 11                	je     801385 <dup+0x74>
  801374:	89 d8                	mov    %ebx,%eax
  801376:	c1 e8 0c             	shr    $0xc,%eax
  801379:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801380:	f6 c2 01             	test   $0x1,%dl
  801383:	75 39                	jne    8013be <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801385:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801388:	89 d0                	mov    %edx,%eax
  80138a:	c1 e8 0c             	shr    $0xc,%eax
  80138d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801394:	83 ec 0c             	sub    $0xc,%esp
  801397:	25 07 0e 00 00       	and    $0xe07,%eax
  80139c:	50                   	push   %eax
  80139d:	56                   	push   %esi
  80139e:	6a 00                	push   $0x0
  8013a0:	52                   	push   %edx
  8013a1:	6a 00                	push   $0x0
  8013a3:	e8 de f9 ff ff       	call   800d86 <sys_page_map>
  8013a8:	89 c3                	mov    %eax,%ebx
  8013aa:	83 c4 20             	add    $0x20,%esp
  8013ad:	85 c0                	test   %eax,%eax
  8013af:	78 31                	js     8013e2 <dup+0xd1>
		goto err;

	return newfdnum;
  8013b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013b4:	89 d8                	mov    %ebx,%eax
  8013b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013b9:	5b                   	pop    %ebx
  8013ba:	5e                   	pop    %esi
  8013bb:	5f                   	pop    %edi
  8013bc:	5d                   	pop    %ebp
  8013bd:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013be:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013c5:	83 ec 0c             	sub    $0xc,%esp
  8013c8:	25 07 0e 00 00       	and    $0xe07,%eax
  8013cd:	50                   	push   %eax
  8013ce:	57                   	push   %edi
  8013cf:	6a 00                	push   $0x0
  8013d1:	53                   	push   %ebx
  8013d2:	6a 00                	push   $0x0
  8013d4:	e8 ad f9 ff ff       	call   800d86 <sys_page_map>
  8013d9:	89 c3                	mov    %eax,%ebx
  8013db:	83 c4 20             	add    $0x20,%esp
  8013de:	85 c0                	test   %eax,%eax
  8013e0:	79 a3                	jns    801385 <dup+0x74>
	sys_page_unmap(0, newfd);
  8013e2:	83 ec 08             	sub    $0x8,%esp
  8013e5:	56                   	push   %esi
  8013e6:	6a 00                	push   $0x0
  8013e8:	e8 db f9 ff ff       	call   800dc8 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013ed:	83 c4 08             	add    $0x8,%esp
  8013f0:	57                   	push   %edi
  8013f1:	6a 00                	push   $0x0
  8013f3:	e8 d0 f9 ff ff       	call   800dc8 <sys_page_unmap>
	return r;
  8013f8:	83 c4 10             	add    $0x10,%esp
  8013fb:	eb b7                	jmp    8013b4 <dup+0xa3>

008013fd <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
  801400:	53                   	push   %ebx
  801401:	83 ec 1c             	sub    $0x1c,%esp
  801404:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801407:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80140a:	50                   	push   %eax
  80140b:	53                   	push   %ebx
  80140c:	e8 7c fd ff ff       	call   80118d <fd_lookup>
  801411:	83 c4 10             	add    $0x10,%esp
  801414:	85 c0                	test   %eax,%eax
  801416:	78 3f                	js     801457 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801418:	83 ec 08             	sub    $0x8,%esp
  80141b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80141e:	50                   	push   %eax
  80141f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801422:	ff 30                	pushl  (%eax)
  801424:	e8 b4 fd ff ff       	call   8011dd <dev_lookup>
  801429:	83 c4 10             	add    $0x10,%esp
  80142c:	85 c0                	test   %eax,%eax
  80142e:	78 27                	js     801457 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801430:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801433:	8b 42 08             	mov    0x8(%edx),%eax
  801436:	83 e0 03             	and    $0x3,%eax
  801439:	83 f8 01             	cmp    $0x1,%eax
  80143c:	74 1e                	je     80145c <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80143e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801441:	8b 40 08             	mov    0x8(%eax),%eax
  801444:	85 c0                	test   %eax,%eax
  801446:	74 35                	je     80147d <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801448:	83 ec 04             	sub    $0x4,%esp
  80144b:	ff 75 10             	pushl  0x10(%ebp)
  80144e:	ff 75 0c             	pushl  0xc(%ebp)
  801451:	52                   	push   %edx
  801452:	ff d0                	call   *%eax
  801454:	83 c4 10             	add    $0x10,%esp
}
  801457:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80145c:	a1 08 40 80 00       	mov    0x804008,%eax
  801461:	8b 40 48             	mov    0x48(%eax),%eax
  801464:	83 ec 04             	sub    $0x4,%esp
  801467:	53                   	push   %ebx
  801468:	50                   	push   %eax
  801469:	68 b1 29 80 00       	push   $0x8029b1
  80146e:	e8 7f ed ff ff       	call   8001f2 <cprintf>
		return -E_INVAL;
  801473:	83 c4 10             	add    $0x10,%esp
  801476:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80147b:	eb da                	jmp    801457 <read+0x5a>
		return -E_NOT_SUPP;
  80147d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801482:	eb d3                	jmp    801457 <read+0x5a>

00801484 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	57                   	push   %edi
  801488:	56                   	push   %esi
  801489:	53                   	push   %ebx
  80148a:	83 ec 0c             	sub    $0xc,%esp
  80148d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801490:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801493:	bb 00 00 00 00       	mov    $0x0,%ebx
  801498:	39 f3                	cmp    %esi,%ebx
  80149a:	73 23                	jae    8014bf <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80149c:	83 ec 04             	sub    $0x4,%esp
  80149f:	89 f0                	mov    %esi,%eax
  8014a1:	29 d8                	sub    %ebx,%eax
  8014a3:	50                   	push   %eax
  8014a4:	89 d8                	mov    %ebx,%eax
  8014a6:	03 45 0c             	add    0xc(%ebp),%eax
  8014a9:	50                   	push   %eax
  8014aa:	57                   	push   %edi
  8014ab:	e8 4d ff ff ff       	call   8013fd <read>
		if (m < 0)
  8014b0:	83 c4 10             	add    $0x10,%esp
  8014b3:	85 c0                	test   %eax,%eax
  8014b5:	78 06                	js     8014bd <readn+0x39>
			return m;
		if (m == 0)
  8014b7:	74 06                	je     8014bf <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8014b9:	01 c3                	add    %eax,%ebx
  8014bb:	eb db                	jmp    801498 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014bd:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014bf:	89 d8                	mov    %ebx,%eax
  8014c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014c4:	5b                   	pop    %ebx
  8014c5:	5e                   	pop    %esi
  8014c6:	5f                   	pop    %edi
  8014c7:	5d                   	pop    %ebp
  8014c8:	c3                   	ret    

008014c9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
  8014cc:	53                   	push   %ebx
  8014cd:	83 ec 1c             	sub    $0x1c,%esp
  8014d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014d3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014d6:	50                   	push   %eax
  8014d7:	53                   	push   %ebx
  8014d8:	e8 b0 fc ff ff       	call   80118d <fd_lookup>
  8014dd:	83 c4 10             	add    $0x10,%esp
  8014e0:	85 c0                	test   %eax,%eax
  8014e2:	78 3a                	js     80151e <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014e4:	83 ec 08             	sub    $0x8,%esp
  8014e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ea:	50                   	push   %eax
  8014eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ee:	ff 30                	pushl  (%eax)
  8014f0:	e8 e8 fc ff ff       	call   8011dd <dev_lookup>
  8014f5:	83 c4 10             	add    $0x10,%esp
  8014f8:	85 c0                	test   %eax,%eax
  8014fa:	78 22                	js     80151e <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ff:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801503:	74 1e                	je     801523 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801505:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801508:	8b 52 0c             	mov    0xc(%edx),%edx
  80150b:	85 d2                	test   %edx,%edx
  80150d:	74 35                	je     801544 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80150f:	83 ec 04             	sub    $0x4,%esp
  801512:	ff 75 10             	pushl  0x10(%ebp)
  801515:	ff 75 0c             	pushl  0xc(%ebp)
  801518:	50                   	push   %eax
  801519:	ff d2                	call   *%edx
  80151b:	83 c4 10             	add    $0x10,%esp
}
  80151e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801521:	c9                   	leave  
  801522:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801523:	a1 08 40 80 00       	mov    0x804008,%eax
  801528:	8b 40 48             	mov    0x48(%eax),%eax
  80152b:	83 ec 04             	sub    $0x4,%esp
  80152e:	53                   	push   %ebx
  80152f:	50                   	push   %eax
  801530:	68 cd 29 80 00       	push   $0x8029cd
  801535:	e8 b8 ec ff ff       	call   8001f2 <cprintf>
		return -E_INVAL;
  80153a:	83 c4 10             	add    $0x10,%esp
  80153d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801542:	eb da                	jmp    80151e <write+0x55>
		return -E_NOT_SUPP;
  801544:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801549:	eb d3                	jmp    80151e <write+0x55>

0080154b <seek>:

int
seek(int fdnum, off_t offset)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
  80154e:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801551:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801554:	50                   	push   %eax
  801555:	ff 75 08             	pushl  0x8(%ebp)
  801558:	e8 30 fc ff ff       	call   80118d <fd_lookup>
  80155d:	83 c4 10             	add    $0x10,%esp
  801560:	85 c0                	test   %eax,%eax
  801562:	78 0e                	js     801572 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801564:	8b 55 0c             	mov    0xc(%ebp),%edx
  801567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80156d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
  801577:	53                   	push   %ebx
  801578:	83 ec 1c             	sub    $0x1c,%esp
  80157b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80157e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801581:	50                   	push   %eax
  801582:	53                   	push   %ebx
  801583:	e8 05 fc ff ff       	call   80118d <fd_lookup>
  801588:	83 c4 10             	add    $0x10,%esp
  80158b:	85 c0                	test   %eax,%eax
  80158d:	78 37                	js     8015c6 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80158f:	83 ec 08             	sub    $0x8,%esp
  801592:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801595:	50                   	push   %eax
  801596:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801599:	ff 30                	pushl  (%eax)
  80159b:	e8 3d fc ff ff       	call   8011dd <dev_lookup>
  8015a0:	83 c4 10             	add    $0x10,%esp
  8015a3:	85 c0                	test   %eax,%eax
  8015a5:	78 1f                	js     8015c6 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015aa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015ae:	74 1b                	je     8015cb <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b3:	8b 52 18             	mov    0x18(%edx),%edx
  8015b6:	85 d2                	test   %edx,%edx
  8015b8:	74 32                	je     8015ec <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015ba:	83 ec 08             	sub    $0x8,%esp
  8015bd:	ff 75 0c             	pushl  0xc(%ebp)
  8015c0:	50                   	push   %eax
  8015c1:	ff d2                	call   *%edx
  8015c3:	83 c4 10             	add    $0x10,%esp
}
  8015c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015c9:	c9                   	leave  
  8015ca:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015cb:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015d0:	8b 40 48             	mov    0x48(%eax),%eax
  8015d3:	83 ec 04             	sub    $0x4,%esp
  8015d6:	53                   	push   %ebx
  8015d7:	50                   	push   %eax
  8015d8:	68 90 29 80 00       	push   $0x802990
  8015dd:	e8 10 ec ff ff       	call   8001f2 <cprintf>
		return -E_INVAL;
  8015e2:	83 c4 10             	add    $0x10,%esp
  8015e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ea:	eb da                	jmp    8015c6 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8015ec:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015f1:	eb d3                	jmp    8015c6 <ftruncate+0x52>

008015f3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
  8015f6:	53                   	push   %ebx
  8015f7:	83 ec 1c             	sub    $0x1c,%esp
  8015fa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015fd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801600:	50                   	push   %eax
  801601:	ff 75 08             	pushl  0x8(%ebp)
  801604:	e8 84 fb ff ff       	call   80118d <fd_lookup>
  801609:	83 c4 10             	add    $0x10,%esp
  80160c:	85 c0                	test   %eax,%eax
  80160e:	78 4b                	js     80165b <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801610:	83 ec 08             	sub    $0x8,%esp
  801613:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801616:	50                   	push   %eax
  801617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161a:	ff 30                	pushl  (%eax)
  80161c:	e8 bc fb ff ff       	call   8011dd <dev_lookup>
  801621:	83 c4 10             	add    $0x10,%esp
  801624:	85 c0                	test   %eax,%eax
  801626:	78 33                	js     80165b <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80162f:	74 2f                	je     801660 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801631:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801634:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80163b:	00 00 00 
	stat->st_isdir = 0;
  80163e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801645:	00 00 00 
	stat->st_dev = dev;
  801648:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80164e:	83 ec 08             	sub    $0x8,%esp
  801651:	53                   	push   %ebx
  801652:	ff 75 f0             	pushl  -0x10(%ebp)
  801655:	ff 50 14             	call   *0x14(%eax)
  801658:	83 c4 10             	add    $0x10,%esp
}
  80165b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80165e:	c9                   	leave  
  80165f:	c3                   	ret    
		return -E_NOT_SUPP;
  801660:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801665:	eb f4                	jmp    80165b <fstat+0x68>

00801667 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
  80166a:	56                   	push   %esi
  80166b:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80166c:	83 ec 08             	sub    $0x8,%esp
  80166f:	6a 00                	push   $0x0
  801671:	ff 75 08             	pushl  0x8(%ebp)
  801674:	e8 22 02 00 00       	call   80189b <open>
  801679:	89 c3                	mov    %eax,%ebx
  80167b:	83 c4 10             	add    $0x10,%esp
  80167e:	85 c0                	test   %eax,%eax
  801680:	78 1b                	js     80169d <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801682:	83 ec 08             	sub    $0x8,%esp
  801685:	ff 75 0c             	pushl  0xc(%ebp)
  801688:	50                   	push   %eax
  801689:	e8 65 ff ff ff       	call   8015f3 <fstat>
  80168e:	89 c6                	mov    %eax,%esi
	close(fd);
  801690:	89 1c 24             	mov    %ebx,(%esp)
  801693:	e8 27 fc ff ff       	call   8012bf <close>
	return r;
  801698:	83 c4 10             	add    $0x10,%esp
  80169b:	89 f3                	mov    %esi,%ebx
}
  80169d:	89 d8                	mov    %ebx,%eax
  80169f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016a2:	5b                   	pop    %ebx
  8016a3:	5e                   	pop    %esi
  8016a4:	5d                   	pop    %ebp
  8016a5:	c3                   	ret    

008016a6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
  8016a9:	56                   	push   %esi
  8016aa:	53                   	push   %ebx
  8016ab:	89 c6                	mov    %eax,%esi
  8016ad:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016af:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016b6:	74 27                	je     8016df <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016b8:	6a 07                	push   $0x7
  8016ba:	68 00 50 80 00       	push   $0x805000
  8016bf:	56                   	push   %esi
  8016c0:	ff 35 00 40 80 00    	pushl  0x804000
  8016c6:	e8 b6 f9 ff ff       	call   801081 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016cb:	83 c4 0c             	add    $0xc,%esp
  8016ce:	6a 00                	push   $0x0
  8016d0:	53                   	push   %ebx
  8016d1:	6a 00                	push   $0x0
  8016d3:	e8 40 f9 ff ff       	call   801018 <ipc_recv>
}
  8016d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016db:	5b                   	pop    %ebx
  8016dc:	5e                   	pop    %esi
  8016dd:	5d                   	pop    %ebp
  8016de:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016df:	83 ec 0c             	sub    $0xc,%esp
  8016e2:	6a 01                	push   $0x1
  8016e4:	e8 f0 f9 ff ff       	call   8010d9 <ipc_find_env>
  8016e9:	a3 00 40 80 00       	mov    %eax,0x804000
  8016ee:	83 c4 10             	add    $0x10,%esp
  8016f1:	eb c5                	jmp    8016b8 <fsipc+0x12>

008016f3 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
  8016f6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ff:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801704:	8b 45 0c             	mov    0xc(%ebp),%eax
  801707:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80170c:	ba 00 00 00 00       	mov    $0x0,%edx
  801711:	b8 02 00 00 00       	mov    $0x2,%eax
  801716:	e8 8b ff ff ff       	call   8016a6 <fsipc>
}
  80171b:	c9                   	leave  
  80171c:	c3                   	ret    

0080171d <devfile_flush>:
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
  801720:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	8b 40 0c             	mov    0xc(%eax),%eax
  801729:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80172e:	ba 00 00 00 00       	mov    $0x0,%edx
  801733:	b8 06 00 00 00       	mov    $0x6,%eax
  801738:	e8 69 ff ff ff       	call   8016a6 <fsipc>
}
  80173d:	c9                   	leave  
  80173e:	c3                   	ret    

0080173f <devfile_stat>:
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
  801742:	53                   	push   %ebx
  801743:	83 ec 04             	sub    $0x4,%esp
  801746:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	8b 40 0c             	mov    0xc(%eax),%eax
  80174f:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801754:	ba 00 00 00 00       	mov    $0x0,%edx
  801759:	b8 05 00 00 00       	mov    $0x5,%eax
  80175e:	e8 43 ff ff ff       	call   8016a6 <fsipc>
  801763:	85 c0                	test   %eax,%eax
  801765:	78 2c                	js     801793 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801767:	83 ec 08             	sub    $0x8,%esp
  80176a:	68 00 50 80 00       	push   $0x805000
  80176f:	53                   	push   %ebx
  801770:	e8 dc f1 ff ff       	call   800951 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801775:	a1 80 50 80 00       	mov    0x805080,%eax
  80177a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801780:	a1 84 50 80 00       	mov    0x805084,%eax
  801785:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80178b:	83 c4 10             	add    $0x10,%esp
  80178e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801793:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <devfile_write>:
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	53                   	push   %ebx
  80179c:	83 ec 08             	sub    $0x8,%esp
  80179f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8017a8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8017ad:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8017b3:	53                   	push   %ebx
  8017b4:	ff 75 0c             	pushl  0xc(%ebp)
  8017b7:	68 08 50 80 00       	push   $0x805008
  8017bc:	e8 80 f3 ff ff       	call   800b41 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c6:	b8 04 00 00 00       	mov    $0x4,%eax
  8017cb:	e8 d6 fe ff ff       	call   8016a6 <fsipc>
  8017d0:	83 c4 10             	add    $0x10,%esp
  8017d3:	85 c0                	test   %eax,%eax
  8017d5:	78 0b                	js     8017e2 <devfile_write+0x4a>
	assert(r <= n);
  8017d7:	39 d8                	cmp    %ebx,%eax
  8017d9:	77 0c                	ja     8017e7 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8017db:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017e0:	7f 1e                	jg     801800 <devfile_write+0x68>
}
  8017e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    
	assert(r <= n);
  8017e7:	68 00 2a 80 00       	push   $0x802a00
  8017ec:	68 07 2a 80 00       	push   $0x802a07
  8017f1:	68 98 00 00 00       	push   $0x98
  8017f6:	68 1c 2a 80 00       	push   $0x802a1c
  8017fb:	e8 6a 0a 00 00       	call   80226a <_panic>
	assert(r <= PGSIZE);
  801800:	68 27 2a 80 00       	push   $0x802a27
  801805:	68 07 2a 80 00       	push   $0x802a07
  80180a:	68 99 00 00 00       	push   $0x99
  80180f:	68 1c 2a 80 00       	push   $0x802a1c
  801814:	e8 51 0a 00 00       	call   80226a <_panic>

00801819 <devfile_read>:
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	56                   	push   %esi
  80181d:	53                   	push   %ebx
  80181e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	8b 40 0c             	mov    0xc(%eax),%eax
  801827:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80182c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801832:	ba 00 00 00 00       	mov    $0x0,%edx
  801837:	b8 03 00 00 00       	mov    $0x3,%eax
  80183c:	e8 65 fe ff ff       	call   8016a6 <fsipc>
  801841:	89 c3                	mov    %eax,%ebx
  801843:	85 c0                	test   %eax,%eax
  801845:	78 1f                	js     801866 <devfile_read+0x4d>
	assert(r <= n);
  801847:	39 f0                	cmp    %esi,%eax
  801849:	77 24                	ja     80186f <devfile_read+0x56>
	assert(r <= PGSIZE);
  80184b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801850:	7f 33                	jg     801885 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801852:	83 ec 04             	sub    $0x4,%esp
  801855:	50                   	push   %eax
  801856:	68 00 50 80 00       	push   $0x805000
  80185b:	ff 75 0c             	pushl  0xc(%ebp)
  80185e:	e8 7c f2 ff ff       	call   800adf <memmove>
	return r;
  801863:	83 c4 10             	add    $0x10,%esp
}
  801866:	89 d8                	mov    %ebx,%eax
  801868:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80186b:	5b                   	pop    %ebx
  80186c:	5e                   	pop    %esi
  80186d:	5d                   	pop    %ebp
  80186e:	c3                   	ret    
	assert(r <= n);
  80186f:	68 00 2a 80 00       	push   $0x802a00
  801874:	68 07 2a 80 00       	push   $0x802a07
  801879:	6a 7c                	push   $0x7c
  80187b:	68 1c 2a 80 00       	push   $0x802a1c
  801880:	e8 e5 09 00 00       	call   80226a <_panic>
	assert(r <= PGSIZE);
  801885:	68 27 2a 80 00       	push   $0x802a27
  80188a:	68 07 2a 80 00       	push   $0x802a07
  80188f:	6a 7d                	push   $0x7d
  801891:	68 1c 2a 80 00       	push   $0x802a1c
  801896:	e8 cf 09 00 00       	call   80226a <_panic>

0080189b <open>:
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
  80189e:	56                   	push   %esi
  80189f:	53                   	push   %ebx
  8018a0:	83 ec 1c             	sub    $0x1c,%esp
  8018a3:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018a6:	56                   	push   %esi
  8018a7:	e8 6c f0 ff ff       	call   800918 <strlen>
  8018ac:	83 c4 10             	add    $0x10,%esp
  8018af:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018b4:	7f 6c                	jg     801922 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018b6:	83 ec 0c             	sub    $0xc,%esp
  8018b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018bc:	50                   	push   %eax
  8018bd:	e8 79 f8 ff ff       	call   80113b <fd_alloc>
  8018c2:	89 c3                	mov    %eax,%ebx
  8018c4:	83 c4 10             	add    $0x10,%esp
  8018c7:	85 c0                	test   %eax,%eax
  8018c9:	78 3c                	js     801907 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8018cb:	83 ec 08             	sub    $0x8,%esp
  8018ce:	56                   	push   %esi
  8018cf:	68 00 50 80 00       	push   $0x805000
  8018d4:	e8 78 f0 ff ff       	call   800951 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018dc:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e4:	b8 01 00 00 00       	mov    $0x1,%eax
  8018e9:	e8 b8 fd ff ff       	call   8016a6 <fsipc>
  8018ee:	89 c3                	mov    %eax,%ebx
  8018f0:	83 c4 10             	add    $0x10,%esp
  8018f3:	85 c0                	test   %eax,%eax
  8018f5:	78 19                	js     801910 <open+0x75>
	return fd2num(fd);
  8018f7:	83 ec 0c             	sub    $0xc,%esp
  8018fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8018fd:	e8 12 f8 ff ff       	call   801114 <fd2num>
  801902:	89 c3                	mov    %eax,%ebx
  801904:	83 c4 10             	add    $0x10,%esp
}
  801907:	89 d8                	mov    %ebx,%eax
  801909:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80190c:	5b                   	pop    %ebx
  80190d:	5e                   	pop    %esi
  80190e:	5d                   	pop    %ebp
  80190f:	c3                   	ret    
		fd_close(fd, 0);
  801910:	83 ec 08             	sub    $0x8,%esp
  801913:	6a 00                	push   $0x0
  801915:	ff 75 f4             	pushl  -0xc(%ebp)
  801918:	e8 1b f9 ff ff       	call   801238 <fd_close>
		return r;
  80191d:	83 c4 10             	add    $0x10,%esp
  801920:	eb e5                	jmp    801907 <open+0x6c>
		return -E_BAD_PATH;
  801922:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801927:	eb de                	jmp    801907 <open+0x6c>

00801929 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
  80192c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80192f:	ba 00 00 00 00       	mov    $0x0,%edx
  801934:	b8 08 00 00 00       	mov    $0x8,%eax
  801939:	e8 68 fd ff ff       	call   8016a6 <fsipc>
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801946:	68 33 2a 80 00       	push   $0x802a33
  80194b:	ff 75 0c             	pushl  0xc(%ebp)
  80194e:	e8 fe ef ff ff       	call   800951 <strcpy>
	return 0;
}
  801953:	b8 00 00 00 00       	mov    $0x0,%eax
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <devsock_close>:
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
  80195d:	53                   	push   %ebx
  80195e:	83 ec 10             	sub    $0x10,%esp
  801961:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801964:	53                   	push   %ebx
  801965:	e8 61 09 00 00       	call   8022cb <pageref>
  80196a:	83 c4 10             	add    $0x10,%esp
		return 0;
  80196d:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801972:	83 f8 01             	cmp    $0x1,%eax
  801975:	74 07                	je     80197e <devsock_close+0x24>
}
  801977:	89 d0                	mov    %edx,%eax
  801979:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80197e:	83 ec 0c             	sub    $0xc,%esp
  801981:	ff 73 0c             	pushl  0xc(%ebx)
  801984:	e8 b9 02 00 00       	call   801c42 <nsipc_close>
  801989:	89 c2                	mov    %eax,%edx
  80198b:	83 c4 10             	add    $0x10,%esp
  80198e:	eb e7                	jmp    801977 <devsock_close+0x1d>

00801990 <devsock_write>:
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
  801993:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801996:	6a 00                	push   $0x0
  801998:	ff 75 10             	pushl  0x10(%ebp)
  80199b:	ff 75 0c             	pushl  0xc(%ebp)
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	ff 70 0c             	pushl  0xc(%eax)
  8019a4:	e8 76 03 00 00       	call   801d1f <nsipc_send>
}
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    

008019ab <devsock_read>:
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
  8019ae:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019b1:	6a 00                	push   $0x0
  8019b3:	ff 75 10             	pushl  0x10(%ebp)
  8019b6:	ff 75 0c             	pushl  0xc(%ebp)
  8019b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bc:	ff 70 0c             	pushl  0xc(%eax)
  8019bf:	e8 ef 02 00 00       	call   801cb3 <nsipc_recv>
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <fd2sockid>:
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
  8019c9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8019cc:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8019cf:	52                   	push   %edx
  8019d0:	50                   	push   %eax
  8019d1:	e8 b7 f7 ff ff       	call   80118d <fd_lookup>
  8019d6:	83 c4 10             	add    $0x10,%esp
  8019d9:	85 c0                	test   %eax,%eax
  8019db:	78 10                	js     8019ed <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8019dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e0:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8019e6:	39 08                	cmp    %ecx,(%eax)
  8019e8:	75 05                	jne    8019ef <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8019ea:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    
		return -E_NOT_SUPP;
  8019ef:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019f4:	eb f7                	jmp    8019ed <fd2sockid+0x27>

008019f6 <alloc_sockfd>:
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
  8019f9:	56                   	push   %esi
  8019fa:	53                   	push   %ebx
  8019fb:	83 ec 1c             	sub    $0x1c,%esp
  8019fe:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a00:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a03:	50                   	push   %eax
  801a04:	e8 32 f7 ff ff       	call   80113b <fd_alloc>
  801a09:	89 c3                	mov    %eax,%ebx
  801a0b:	83 c4 10             	add    $0x10,%esp
  801a0e:	85 c0                	test   %eax,%eax
  801a10:	78 43                	js     801a55 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a12:	83 ec 04             	sub    $0x4,%esp
  801a15:	68 07 04 00 00       	push   $0x407
  801a1a:	ff 75 f4             	pushl  -0xc(%ebp)
  801a1d:	6a 00                	push   $0x0
  801a1f:	e8 1f f3 ff ff       	call   800d43 <sys_page_alloc>
  801a24:	89 c3                	mov    %eax,%ebx
  801a26:	83 c4 10             	add    $0x10,%esp
  801a29:	85 c0                	test   %eax,%eax
  801a2b:	78 28                	js     801a55 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a30:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a36:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a3b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a42:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a45:	83 ec 0c             	sub    $0xc,%esp
  801a48:	50                   	push   %eax
  801a49:	e8 c6 f6 ff ff       	call   801114 <fd2num>
  801a4e:	89 c3                	mov    %eax,%ebx
  801a50:	83 c4 10             	add    $0x10,%esp
  801a53:	eb 0c                	jmp    801a61 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a55:	83 ec 0c             	sub    $0xc,%esp
  801a58:	56                   	push   %esi
  801a59:	e8 e4 01 00 00       	call   801c42 <nsipc_close>
		return r;
  801a5e:	83 c4 10             	add    $0x10,%esp
}
  801a61:	89 d8                	mov    %ebx,%eax
  801a63:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a66:	5b                   	pop    %ebx
  801a67:	5e                   	pop    %esi
  801a68:	5d                   	pop    %ebp
  801a69:	c3                   	ret    

00801a6a <accept>:
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
  801a6d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a70:	8b 45 08             	mov    0x8(%ebp),%eax
  801a73:	e8 4e ff ff ff       	call   8019c6 <fd2sockid>
  801a78:	85 c0                	test   %eax,%eax
  801a7a:	78 1b                	js     801a97 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a7c:	83 ec 04             	sub    $0x4,%esp
  801a7f:	ff 75 10             	pushl  0x10(%ebp)
  801a82:	ff 75 0c             	pushl  0xc(%ebp)
  801a85:	50                   	push   %eax
  801a86:	e8 0e 01 00 00       	call   801b99 <nsipc_accept>
  801a8b:	83 c4 10             	add    $0x10,%esp
  801a8e:	85 c0                	test   %eax,%eax
  801a90:	78 05                	js     801a97 <accept+0x2d>
	return alloc_sockfd(r);
  801a92:	e8 5f ff ff ff       	call   8019f6 <alloc_sockfd>
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <bind>:
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa2:	e8 1f ff ff ff       	call   8019c6 <fd2sockid>
  801aa7:	85 c0                	test   %eax,%eax
  801aa9:	78 12                	js     801abd <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801aab:	83 ec 04             	sub    $0x4,%esp
  801aae:	ff 75 10             	pushl  0x10(%ebp)
  801ab1:	ff 75 0c             	pushl  0xc(%ebp)
  801ab4:	50                   	push   %eax
  801ab5:	e8 31 01 00 00       	call   801beb <nsipc_bind>
  801aba:	83 c4 10             	add    $0x10,%esp
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <shutdown>:
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	e8 f9 fe ff ff       	call   8019c6 <fd2sockid>
  801acd:	85 c0                	test   %eax,%eax
  801acf:	78 0f                	js     801ae0 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801ad1:	83 ec 08             	sub    $0x8,%esp
  801ad4:	ff 75 0c             	pushl  0xc(%ebp)
  801ad7:	50                   	push   %eax
  801ad8:	e8 43 01 00 00       	call   801c20 <nsipc_shutdown>
  801add:	83 c4 10             	add    $0x10,%esp
}
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <connect>:
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aeb:	e8 d6 fe ff ff       	call   8019c6 <fd2sockid>
  801af0:	85 c0                	test   %eax,%eax
  801af2:	78 12                	js     801b06 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801af4:	83 ec 04             	sub    $0x4,%esp
  801af7:	ff 75 10             	pushl  0x10(%ebp)
  801afa:	ff 75 0c             	pushl  0xc(%ebp)
  801afd:	50                   	push   %eax
  801afe:	e8 59 01 00 00       	call   801c5c <nsipc_connect>
  801b03:	83 c4 10             	add    $0x10,%esp
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <listen>:
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
  801b0b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b11:	e8 b0 fe ff ff       	call   8019c6 <fd2sockid>
  801b16:	85 c0                	test   %eax,%eax
  801b18:	78 0f                	js     801b29 <listen+0x21>
	return nsipc_listen(r, backlog);
  801b1a:	83 ec 08             	sub    $0x8,%esp
  801b1d:	ff 75 0c             	pushl  0xc(%ebp)
  801b20:	50                   	push   %eax
  801b21:	e8 6b 01 00 00       	call   801c91 <nsipc_listen>
  801b26:	83 c4 10             	add    $0x10,%esp
}
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <socket>:

int
socket(int domain, int type, int protocol)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
  801b2e:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b31:	ff 75 10             	pushl  0x10(%ebp)
  801b34:	ff 75 0c             	pushl  0xc(%ebp)
  801b37:	ff 75 08             	pushl  0x8(%ebp)
  801b3a:	e8 3e 02 00 00       	call   801d7d <nsipc_socket>
  801b3f:	83 c4 10             	add    $0x10,%esp
  801b42:	85 c0                	test   %eax,%eax
  801b44:	78 05                	js     801b4b <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801b46:	e8 ab fe ff ff       	call   8019f6 <alloc_sockfd>
}
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
  801b50:	53                   	push   %ebx
  801b51:	83 ec 04             	sub    $0x4,%esp
  801b54:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b56:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b5d:	74 26                	je     801b85 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b5f:	6a 07                	push   $0x7
  801b61:	68 00 60 80 00       	push   $0x806000
  801b66:	53                   	push   %ebx
  801b67:	ff 35 04 40 80 00    	pushl  0x804004
  801b6d:	e8 0f f5 ff ff       	call   801081 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b72:	83 c4 0c             	add    $0xc,%esp
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	e8 98 f4 ff ff       	call   801018 <ipc_recv>
}
  801b80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b85:	83 ec 0c             	sub    $0xc,%esp
  801b88:	6a 02                	push   $0x2
  801b8a:	e8 4a f5 ff ff       	call   8010d9 <ipc_find_env>
  801b8f:	a3 04 40 80 00       	mov    %eax,0x804004
  801b94:	83 c4 10             	add    $0x10,%esp
  801b97:	eb c6                	jmp    801b5f <nsipc+0x12>

00801b99 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
  801b9c:	56                   	push   %esi
  801b9d:	53                   	push   %ebx
  801b9e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ba9:	8b 06                	mov    (%esi),%eax
  801bab:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801bb0:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb5:	e8 93 ff ff ff       	call   801b4d <nsipc>
  801bba:	89 c3                	mov    %eax,%ebx
  801bbc:	85 c0                	test   %eax,%eax
  801bbe:	79 09                	jns    801bc9 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801bc0:	89 d8                	mov    %ebx,%eax
  801bc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bc5:	5b                   	pop    %ebx
  801bc6:	5e                   	pop    %esi
  801bc7:	5d                   	pop    %ebp
  801bc8:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801bc9:	83 ec 04             	sub    $0x4,%esp
  801bcc:	ff 35 10 60 80 00    	pushl  0x806010
  801bd2:	68 00 60 80 00       	push   $0x806000
  801bd7:	ff 75 0c             	pushl  0xc(%ebp)
  801bda:	e8 00 ef ff ff       	call   800adf <memmove>
		*addrlen = ret->ret_addrlen;
  801bdf:	a1 10 60 80 00       	mov    0x806010,%eax
  801be4:	89 06                	mov    %eax,(%esi)
  801be6:	83 c4 10             	add    $0x10,%esp
	return r;
  801be9:	eb d5                	jmp    801bc0 <nsipc_accept+0x27>

00801beb <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
  801bee:	53                   	push   %ebx
  801bef:	83 ec 08             	sub    $0x8,%esp
  801bf2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf8:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801bfd:	53                   	push   %ebx
  801bfe:	ff 75 0c             	pushl  0xc(%ebp)
  801c01:	68 04 60 80 00       	push   $0x806004
  801c06:	e8 d4 ee ff ff       	call   800adf <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c0b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c11:	b8 02 00 00 00       	mov    $0x2,%eax
  801c16:	e8 32 ff ff ff       	call   801b4d <nsipc>
}
  801c1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
  801c23:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c26:	8b 45 08             	mov    0x8(%ebp),%eax
  801c29:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c31:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801c36:	b8 03 00 00 00       	mov    $0x3,%eax
  801c3b:	e8 0d ff ff ff       	call   801b4d <nsipc>
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <nsipc_close>:

int
nsipc_close(int s)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
  801c45:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c48:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c50:	b8 04 00 00 00       	mov    $0x4,%eax
  801c55:	e8 f3 fe ff ff       	call   801b4d <nsipc>
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
  801c5f:	53                   	push   %ebx
  801c60:	83 ec 08             	sub    $0x8,%esp
  801c63:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c6e:	53                   	push   %ebx
  801c6f:	ff 75 0c             	pushl  0xc(%ebp)
  801c72:	68 04 60 80 00       	push   $0x806004
  801c77:	e8 63 ee ff ff       	call   800adf <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c7c:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c82:	b8 05 00 00 00       	mov    $0x5,%eax
  801c87:	e8 c1 fe ff ff       	call   801b4d <nsipc>
}
  801c8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
  801c94:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c97:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca2:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801ca7:	b8 06 00 00 00       	mov    $0x6,%eax
  801cac:	e8 9c fe ff ff       	call   801b4d <nsipc>
}
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	56                   	push   %esi
  801cb7:	53                   	push   %ebx
  801cb8:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbe:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801cc3:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801cc9:	8b 45 14             	mov    0x14(%ebp),%eax
  801ccc:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801cd1:	b8 07 00 00 00       	mov    $0x7,%eax
  801cd6:	e8 72 fe ff ff       	call   801b4d <nsipc>
  801cdb:	89 c3                	mov    %eax,%ebx
  801cdd:	85 c0                	test   %eax,%eax
  801cdf:	78 1f                	js     801d00 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801ce1:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801ce6:	7f 21                	jg     801d09 <nsipc_recv+0x56>
  801ce8:	39 c6                	cmp    %eax,%esi
  801cea:	7c 1d                	jl     801d09 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801cec:	83 ec 04             	sub    $0x4,%esp
  801cef:	50                   	push   %eax
  801cf0:	68 00 60 80 00       	push   $0x806000
  801cf5:	ff 75 0c             	pushl  0xc(%ebp)
  801cf8:	e8 e2 ed ff ff       	call   800adf <memmove>
  801cfd:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d00:	89 d8                	mov    %ebx,%eax
  801d02:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d05:	5b                   	pop    %ebx
  801d06:	5e                   	pop    %esi
  801d07:	5d                   	pop    %ebp
  801d08:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d09:	68 3f 2a 80 00       	push   $0x802a3f
  801d0e:	68 07 2a 80 00       	push   $0x802a07
  801d13:	6a 62                	push   $0x62
  801d15:	68 54 2a 80 00       	push   $0x802a54
  801d1a:	e8 4b 05 00 00       	call   80226a <_panic>

00801d1f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
  801d22:	53                   	push   %ebx
  801d23:	83 ec 04             	sub    $0x4,%esp
  801d26:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d29:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2c:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d31:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d37:	7f 2e                	jg     801d67 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d39:	83 ec 04             	sub    $0x4,%esp
  801d3c:	53                   	push   %ebx
  801d3d:	ff 75 0c             	pushl  0xc(%ebp)
  801d40:	68 0c 60 80 00       	push   $0x80600c
  801d45:	e8 95 ed ff ff       	call   800adf <memmove>
	nsipcbuf.send.req_size = size;
  801d4a:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d50:	8b 45 14             	mov    0x14(%ebp),%eax
  801d53:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d58:	b8 08 00 00 00       	mov    $0x8,%eax
  801d5d:	e8 eb fd ff ff       	call   801b4d <nsipc>
}
  801d62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d65:	c9                   	leave  
  801d66:	c3                   	ret    
	assert(size < 1600);
  801d67:	68 60 2a 80 00       	push   $0x802a60
  801d6c:	68 07 2a 80 00       	push   $0x802a07
  801d71:	6a 6d                	push   $0x6d
  801d73:	68 54 2a 80 00       	push   $0x802a54
  801d78:	e8 ed 04 00 00       	call   80226a <_panic>

00801d7d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
  801d80:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d83:	8b 45 08             	mov    0x8(%ebp),%eax
  801d86:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8e:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d93:	8b 45 10             	mov    0x10(%ebp),%eax
  801d96:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d9b:	b8 09 00 00 00       	mov    $0x9,%eax
  801da0:	e8 a8 fd ff ff       	call   801b4d <nsipc>
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
  801daa:	56                   	push   %esi
  801dab:	53                   	push   %ebx
  801dac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801daf:	83 ec 0c             	sub    $0xc,%esp
  801db2:	ff 75 08             	pushl  0x8(%ebp)
  801db5:	e8 6a f3 ff ff       	call   801124 <fd2data>
  801dba:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801dbc:	83 c4 08             	add    $0x8,%esp
  801dbf:	68 6c 2a 80 00       	push   $0x802a6c
  801dc4:	53                   	push   %ebx
  801dc5:	e8 87 eb ff ff       	call   800951 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801dca:	8b 46 04             	mov    0x4(%esi),%eax
  801dcd:	2b 06                	sub    (%esi),%eax
  801dcf:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801dd5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ddc:	00 00 00 
	stat->st_dev = &devpipe;
  801ddf:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801de6:	30 80 00 
	return 0;
}
  801de9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801df1:	5b                   	pop    %ebx
  801df2:	5e                   	pop    %esi
  801df3:	5d                   	pop    %ebp
  801df4:	c3                   	ret    

00801df5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
  801df8:	53                   	push   %ebx
  801df9:	83 ec 0c             	sub    $0xc,%esp
  801dfc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801dff:	53                   	push   %ebx
  801e00:	6a 00                	push   $0x0
  801e02:	e8 c1 ef ff ff       	call   800dc8 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e07:	89 1c 24             	mov    %ebx,(%esp)
  801e0a:	e8 15 f3 ff ff       	call   801124 <fd2data>
  801e0f:	83 c4 08             	add    $0x8,%esp
  801e12:	50                   	push   %eax
  801e13:	6a 00                	push   $0x0
  801e15:	e8 ae ef ff ff       	call   800dc8 <sys_page_unmap>
}
  801e1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e1d:	c9                   	leave  
  801e1e:	c3                   	ret    

00801e1f <_pipeisclosed>:
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
  801e22:	57                   	push   %edi
  801e23:	56                   	push   %esi
  801e24:	53                   	push   %ebx
  801e25:	83 ec 1c             	sub    $0x1c,%esp
  801e28:	89 c7                	mov    %eax,%edi
  801e2a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e2c:	a1 08 40 80 00       	mov    0x804008,%eax
  801e31:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e34:	83 ec 0c             	sub    $0xc,%esp
  801e37:	57                   	push   %edi
  801e38:	e8 8e 04 00 00       	call   8022cb <pageref>
  801e3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e40:	89 34 24             	mov    %esi,(%esp)
  801e43:	e8 83 04 00 00       	call   8022cb <pageref>
		nn = thisenv->env_runs;
  801e48:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801e4e:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e51:	83 c4 10             	add    $0x10,%esp
  801e54:	39 cb                	cmp    %ecx,%ebx
  801e56:	74 1b                	je     801e73 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e58:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e5b:	75 cf                	jne    801e2c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e5d:	8b 42 58             	mov    0x58(%edx),%eax
  801e60:	6a 01                	push   $0x1
  801e62:	50                   	push   %eax
  801e63:	53                   	push   %ebx
  801e64:	68 73 2a 80 00       	push   $0x802a73
  801e69:	e8 84 e3 ff ff       	call   8001f2 <cprintf>
  801e6e:	83 c4 10             	add    $0x10,%esp
  801e71:	eb b9                	jmp    801e2c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e73:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e76:	0f 94 c0             	sete   %al
  801e79:	0f b6 c0             	movzbl %al,%eax
}
  801e7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e7f:	5b                   	pop    %ebx
  801e80:	5e                   	pop    %esi
  801e81:	5f                   	pop    %edi
  801e82:	5d                   	pop    %ebp
  801e83:	c3                   	ret    

00801e84 <devpipe_write>:
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	57                   	push   %edi
  801e88:	56                   	push   %esi
  801e89:	53                   	push   %ebx
  801e8a:	83 ec 28             	sub    $0x28,%esp
  801e8d:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e90:	56                   	push   %esi
  801e91:	e8 8e f2 ff ff       	call   801124 <fd2data>
  801e96:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e98:	83 c4 10             	add    $0x10,%esp
  801e9b:	bf 00 00 00 00       	mov    $0x0,%edi
  801ea0:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ea3:	74 4f                	je     801ef4 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ea5:	8b 43 04             	mov    0x4(%ebx),%eax
  801ea8:	8b 0b                	mov    (%ebx),%ecx
  801eaa:	8d 51 20             	lea    0x20(%ecx),%edx
  801ead:	39 d0                	cmp    %edx,%eax
  801eaf:	72 14                	jb     801ec5 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801eb1:	89 da                	mov    %ebx,%edx
  801eb3:	89 f0                	mov    %esi,%eax
  801eb5:	e8 65 ff ff ff       	call   801e1f <_pipeisclosed>
  801eba:	85 c0                	test   %eax,%eax
  801ebc:	75 3b                	jne    801ef9 <devpipe_write+0x75>
			sys_yield();
  801ebe:	e8 61 ee ff ff       	call   800d24 <sys_yield>
  801ec3:	eb e0                	jmp    801ea5 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ec5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ec8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ecc:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ecf:	89 c2                	mov    %eax,%edx
  801ed1:	c1 fa 1f             	sar    $0x1f,%edx
  801ed4:	89 d1                	mov    %edx,%ecx
  801ed6:	c1 e9 1b             	shr    $0x1b,%ecx
  801ed9:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801edc:	83 e2 1f             	and    $0x1f,%edx
  801edf:	29 ca                	sub    %ecx,%edx
  801ee1:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ee5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ee9:	83 c0 01             	add    $0x1,%eax
  801eec:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801eef:	83 c7 01             	add    $0x1,%edi
  801ef2:	eb ac                	jmp    801ea0 <devpipe_write+0x1c>
	return i;
  801ef4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef7:	eb 05                	jmp    801efe <devpipe_write+0x7a>
				return 0;
  801ef9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f01:	5b                   	pop    %ebx
  801f02:	5e                   	pop    %esi
  801f03:	5f                   	pop    %edi
  801f04:	5d                   	pop    %ebp
  801f05:	c3                   	ret    

00801f06 <devpipe_read>:
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
  801f09:	57                   	push   %edi
  801f0a:	56                   	push   %esi
  801f0b:	53                   	push   %ebx
  801f0c:	83 ec 18             	sub    $0x18,%esp
  801f0f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f12:	57                   	push   %edi
  801f13:	e8 0c f2 ff ff       	call   801124 <fd2data>
  801f18:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f1a:	83 c4 10             	add    $0x10,%esp
  801f1d:	be 00 00 00 00       	mov    $0x0,%esi
  801f22:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f25:	75 14                	jne    801f3b <devpipe_read+0x35>
	return i;
  801f27:	8b 45 10             	mov    0x10(%ebp),%eax
  801f2a:	eb 02                	jmp    801f2e <devpipe_read+0x28>
				return i;
  801f2c:	89 f0                	mov    %esi,%eax
}
  801f2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f31:	5b                   	pop    %ebx
  801f32:	5e                   	pop    %esi
  801f33:	5f                   	pop    %edi
  801f34:	5d                   	pop    %ebp
  801f35:	c3                   	ret    
			sys_yield();
  801f36:	e8 e9 ed ff ff       	call   800d24 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801f3b:	8b 03                	mov    (%ebx),%eax
  801f3d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f40:	75 18                	jne    801f5a <devpipe_read+0x54>
			if (i > 0)
  801f42:	85 f6                	test   %esi,%esi
  801f44:	75 e6                	jne    801f2c <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801f46:	89 da                	mov    %ebx,%edx
  801f48:	89 f8                	mov    %edi,%eax
  801f4a:	e8 d0 fe ff ff       	call   801e1f <_pipeisclosed>
  801f4f:	85 c0                	test   %eax,%eax
  801f51:	74 e3                	je     801f36 <devpipe_read+0x30>
				return 0;
  801f53:	b8 00 00 00 00       	mov    $0x0,%eax
  801f58:	eb d4                	jmp    801f2e <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f5a:	99                   	cltd   
  801f5b:	c1 ea 1b             	shr    $0x1b,%edx
  801f5e:	01 d0                	add    %edx,%eax
  801f60:	83 e0 1f             	and    $0x1f,%eax
  801f63:	29 d0                	sub    %edx,%eax
  801f65:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f6d:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f70:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f73:	83 c6 01             	add    $0x1,%esi
  801f76:	eb aa                	jmp    801f22 <devpipe_read+0x1c>

00801f78 <pipe>:
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	56                   	push   %esi
  801f7c:	53                   	push   %ebx
  801f7d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f80:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f83:	50                   	push   %eax
  801f84:	e8 b2 f1 ff ff       	call   80113b <fd_alloc>
  801f89:	89 c3                	mov    %eax,%ebx
  801f8b:	83 c4 10             	add    $0x10,%esp
  801f8e:	85 c0                	test   %eax,%eax
  801f90:	0f 88 23 01 00 00    	js     8020b9 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f96:	83 ec 04             	sub    $0x4,%esp
  801f99:	68 07 04 00 00       	push   $0x407
  801f9e:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa1:	6a 00                	push   $0x0
  801fa3:	e8 9b ed ff ff       	call   800d43 <sys_page_alloc>
  801fa8:	89 c3                	mov    %eax,%ebx
  801faa:	83 c4 10             	add    $0x10,%esp
  801fad:	85 c0                	test   %eax,%eax
  801faf:	0f 88 04 01 00 00    	js     8020b9 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801fb5:	83 ec 0c             	sub    $0xc,%esp
  801fb8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fbb:	50                   	push   %eax
  801fbc:	e8 7a f1 ff ff       	call   80113b <fd_alloc>
  801fc1:	89 c3                	mov    %eax,%ebx
  801fc3:	83 c4 10             	add    $0x10,%esp
  801fc6:	85 c0                	test   %eax,%eax
  801fc8:	0f 88 db 00 00 00    	js     8020a9 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fce:	83 ec 04             	sub    $0x4,%esp
  801fd1:	68 07 04 00 00       	push   $0x407
  801fd6:	ff 75 f0             	pushl  -0x10(%ebp)
  801fd9:	6a 00                	push   $0x0
  801fdb:	e8 63 ed ff ff       	call   800d43 <sys_page_alloc>
  801fe0:	89 c3                	mov    %eax,%ebx
  801fe2:	83 c4 10             	add    $0x10,%esp
  801fe5:	85 c0                	test   %eax,%eax
  801fe7:	0f 88 bc 00 00 00    	js     8020a9 <pipe+0x131>
	va = fd2data(fd0);
  801fed:	83 ec 0c             	sub    $0xc,%esp
  801ff0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff3:	e8 2c f1 ff ff       	call   801124 <fd2data>
  801ff8:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ffa:	83 c4 0c             	add    $0xc,%esp
  801ffd:	68 07 04 00 00       	push   $0x407
  802002:	50                   	push   %eax
  802003:	6a 00                	push   $0x0
  802005:	e8 39 ed ff ff       	call   800d43 <sys_page_alloc>
  80200a:	89 c3                	mov    %eax,%ebx
  80200c:	83 c4 10             	add    $0x10,%esp
  80200f:	85 c0                	test   %eax,%eax
  802011:	0f 88 82 00 00 00    	js     802099 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802017:	83 ec 0c             	sub    $0xc,%esp
  80201a:	ff 75 f0             	pushl  -0x10(%ebp)
  80201d:	e8 02 f1 ff ff       	call   801124 <fd2data>
  802022:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802029:	50                   	push   %eax
  80202a:	6a 00                	push   $0x0
  80202c:	56                   	push   %esi
  80202d:	6a 00                	push   $0x0
  80202f:	e8 52 ed ff ff       	call   800d86 <sys_page_map>
  802034:	89 c3                	mov    %eax,%ebx
  802036:	83 c4 20             	add    $0x20,%esp
  802039:	85 c0                	test   %eax,%eax
  80203b:	78 4e                	js     80208b <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80203d:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802042:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802045:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802047:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802051:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802054:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802056:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802059:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802060:	83 ec 0c             	sub    $0xc,%esp
  802063:	ff 75 f4             	pushl  -0xc(%ebp)
  802066:	e8 a9 f0 ff ff       	call   801114 <fd2num>
  80206b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80206e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802070:	83 c4 04             	add    $0x4,%esp
  802073:	ff 75 f0             	pushl  -0x10(%ebp)
  802076:	e8 99 f0 ff ff       	call   801114 <fd2num>
  80207b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80207e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802081:	83 c4 10             	add    $0x10,%esp
  802084:	bb 00 00 00 00       	mov    $0x0,%ebx
  802089:	eb 2e                	jmp    8020b9 <pipe+0x141>
	sys_page_unmap(0, va);
  80208b:	83 ec 08             	sub    $0x8,%esp
  80208e:	56                   	push   %esi
  80208f:	6a 00                	push   $0x0
  802091:	e8 32 ed ff ff       	call   800dc8 <sys_page_unmap>
  802096:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802099:	83 ec 08             	sub    $0x8,%esp
  80209c:	ff 75 f0             	pushl  -0x10(%ebp)
  80209f:	6a 00                	push   $0x0
  8020a1:	e8 22 ed ff ff       	call   800dc8 <sys_page_unmap>
  8020a6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8020a9:	83 ec 08             	sub    $0x8,%esp
  8020ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8020af:	6a 00                	push   $0x0
  8020b1:	e8 12 ed ff ff       	call   800dc8 <sys_page_unmap>
  8020b6:	83 c4 10             	add    $0x10,%esp
}
  8020b9:	89 d8                	mov    %ebx,%eax
  8020bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020be:	5b                   	pop    %ebx
  8020bf:	5e                   	pop    %esi
  8020c0:	5d                   	pop    %ebp
  8020c1:	c3                   	ret    

008020c2 <pipeisclosed>:
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
  8020c5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020cb:	50                   	push   %eax
  8020cc:	ff 75 08             	pushl  0x8(%ebp)
  8020cf:	e8 b9 f0 ff ff       	call   80118d <fd_lookup>
  8020d4:	83 c4 10             	add    $0x10,%esp
  8020d7:	85 c0                	test   %eax,%eax
  8020d9:	78 18                	js     8020f3 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8020db:	83 ec 0c             	sub    $0xc,%esp
  8020de:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e1:	e8 3e f0 ff ff       	call   801124 <fd2data>
	return _pipeisclosed(fd, p);
  8020e6:	89 c2                	mov    %eax,%edx
  8020e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020eb:	e8 2f fd ff ff       	call   801e1f <_pipeisclosed>
  8020f0:	83 c4 10             	add    $0x10,%esp
}
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8020f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020fa:	c3                   	ret    

008020fb <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
  8020fe:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802101:	68 8b 2a 80 00       	push   $0x802a8b
  802106:	ff 75 0c             	pushl  0xc(%ebp)
  802109:	e8 43 e8 ff ff       	call   800951 <strcpy>
	return 0;
}
  80210e:	b8 00 00 00 00       	mov    $0x0,%eax
  802113:	c9                   	leave  
  802114:	c3                   	ret    

00802115 <devcons_write>:
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
  802118:	57                   	push   %edi
  802119:	56                   	push   %esi
  80211a:	53                   	push   %ebx
  80211b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802121:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802126:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80212c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80212f:	73 31                	jae    802162 <devcons_write+0x4d>
		m = n - tot;
  802131:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802134:	29 f3                	sub    %esi,%ebx
  802136:	83 fb 7f             	cmp    $0x7f,%ebx
  802139:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80213e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802141:	83 ec 04             	sub    $0x4,%esp
  802144:	53                   	push   %ebx
  802145:	89 f0                	mov    %esi,%eax
  802147:	03 45 0c             	add    0xc(%ebp),%eax
  80214a:	50                   	push   %eax
  80214b:	57                   	push   %edi
  80214c:	e8 8e e9 ff ff       	call   800adf <memmove>
		sys_cputs(buf, m);
  802151:	83 c4 08             	add    $0x8,%esp
  802154:	53                   	push   %ebx
  802155:	57                   	push   %edi
  802156:	e8 2c eb ff ff       	call   800c87 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80215b:	01 de                	add    %ebx,%esi
  80215d:	83 c4 10             	add    $0x10,%esp
  802160:	eb ca                	jmp    80212c <devcons_write+0x17>
}
  802162:	89 f0                	mov    %esi,%eax
  802164:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802167:	5b                   	pop    %ebx
  802168:	5e                   	pop    %esi
  802169:	5f                   	pop    %edi
  80216a:	5d                   	pop    %ebp
  80216b:	c3                   	ret    

0080216c <devcons_read>:
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
  80216f:	83 ec 08             	sub    $0x8,%esp
  802172:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802177:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80217b:	74 21                	je     80219e <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80217d:	e8 23 eb ff ff       	call   800ca5 <sys_cgetc>
  802182:	85 c0                	test   %eax,%eax
  802184:	75 07                	jne    80218d <devcons_read+0x21>
		sys_yield();
  802186:	e8 99 eb ff ff       	call   800d24 <sys_yield>
  80218b:	eb f0                	jmp    80217d <devcons_read+0x11>
	if (c < 0)
  80218d:	78 0f                	js     80219e <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80218f:	83 f8 04             	cmp    $0x4,%eax
  802192:	74 0c                	je     8021a0 <devcons_read+0x34>
	*(char*)vbuf = c;
  802194:	8b 55 0c             	mov    0xc(%ebp),%edx
  802197:	88 02                	mov    %al,(%edx)
	return 1;
  802199:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    
		return 0;
  8021a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a5:	eb f7                	jmp    80219e <devcons_read+0x32>

008021a7 <cputchar>:
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
  8021aa:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8021ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b0:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8021b3:	6a 01                	push   $0x1
  8021b5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021b8:	50                   	push   %eax
  8021b9:	e8 c9 ea ff ff       	call   800c87 <sys_cputs>
}
  8021be:	83 c4 10             	add    $0x10,%esp
  8021c1:	c9                   	leave  
  8021c2:	c3                   	ret    

008021c3 <getchar>:
{
  8021c3:	55                   	push   %ebp
  8021c4:	89 e5                	mov    %esp,%ebp
  8021c6:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8021c9:	6a 01                	push   $0x1
  8021cb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021ce:	50                   	push   %eax
  8021cf:	6a 00                	push   $0x0
  8021d1:	e8 27 f2 ff ff       	call   8013fd <read>
	if (r < 0)
  8021d6:	83 c4 10             	add    $0x10,%esp
  8021d9:	85 c0                	test   %eax,%eax
  8021db:	78 06                	js     8021e3 <getchar+0x20>
	if (r < 1)
  8021dd:	74 06                	je     8021e5 <getchar+0x22>
	return c;
  8021df:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8021e3:	c9                   	leave  
  8021e4:	c3                   	ret    
		return -E_EOF;
  8021e5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8021ea:	eb f7                	jmp    8021e3 <getchar+0x20>

008021ec <iscons>:
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
  8021ef:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021f5:	50                   	push   %eax
  8021f6:	ff 75 08             	pushl  0x8(%ebp)
  8021f9:	e8 8f ef ff ff       	call   80118d <fd_lookup>
  8021fe:	83 c4 10             	add    $0x10,%esp
  802201:	85 c0                	test   %eax,%eax
  802203:	78 11                	js     802216 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802208:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80220e:	39 10                	cmp    %edx,(%eax)
  802210:	0f 94 c0             	sete   %al
  802213:	0f b6 c0             	movzbl %al,%eax
}
  802216:	c9                   	leave  
  802217:	c3                   	ret    

00802218 <opencons>:
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
  80221b:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80221e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802221:	50                   	push   %eax
  802222:	e8 14 ef ff ff       	call   80113b <fd_alloc>
  802227:	83 c4 10             	add    $0x10,%esp
  80222a:	85 c0                	test   %eax,%eax
  80222c:	78 3a                	js     802268 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80222e:	83 ec 04             	sub    $0x4,%esp
  802231:	68 07 04 00 00       	push   $0x407
  802236:	ff 75 f4             	pushl  -0xc(%ebp)
  802239:	6a 00                	push   $0x0
  80223b:	e8 03 eb ff ff       	call   800d43 <sys_page_alloc>
  802240:	83 c4 10             	add    $0x10,%esp
  802243:	85 c0                	test   %eax,%eax
  802245:	78 21                	js     802268 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224a:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802250:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802252:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802255:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80225c:	83 ec 0c             	sub    $0xc,%esp
  80225f:	50                   	push   %eax
  802260:	e8 af ee ff ff       	call   801114 <fd2num>
  802265:	83 c4 10             	add    $0x10,%esp
}
  802268:	c9                   	leave  
  802269:	c3                   	ret    

0080226a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
  80226d:	56                   	push   %esi
  80226e:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80226f:	a1 08 40 80 00       	mov    0x804008,%eax
  802274:	8b 40 48             	mov    0x48(%eax),%eax
  802277:	83 ec 04             	sub    $0x4,%esp
  80227a:	68 c8 2a 80 00       	push   $0x802ac8
  80227f:	50                   	push   %eax
  802280:	68 97 2a 80 00       	push   $0x802a97
  802285:	e8 68 df ff ff       	call   8001f2 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80228a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80228d:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802293:	e8 6d ea ff ff       	call   800d05 <sys_getenvid>
  802298:	83 c4 04             	add    $0x4,%esp
  80229b:	ff 75 0c             	pushl  0xc(%ebp)
  80229e:	ff 75 08             	pushl  0x8(%ebp)
  8022a1:	56                   	push   %esi
  8022a2:	50                   	push   %eax
  8022a3:	68 a4 2a 80 00       	push   $0x802aa4
  8022a8:	e8 45 df ff ff       	call   8001f2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8022ad:	83 c4 18             	add    $0x18,%esp
  8022b0:	53                   	push   %ebx
  8022b1:	ff 75 10             	pushl  0x10(%ebp)
  8022b4:	e8 e8 de ff ff       	call   8001a1 <vcprintf>
	cprintf("\n");
  8022b9:	c7 04 24 93 25 80 00 	movl   $0x802593,(%esp)
  8022c0:	e8 2d df ff ff       	call   8001f2 <cprintf>
  8022c5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8022c8:	cc                   	int3   
  8022c9:	eb fd                	jmp    8022c8 <_panic+0x5e>

008022cb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
  8022ce:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022d1:	89 d0                	mov    %edx,%eax
  8022d3:	c1 e8 16             	shr    $0x16,%eax
  8022d6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022dd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022e2:	f6 c1 01             	test   $0x1,%cl
  8022e5:	74 1d                	je     802304 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022e7:	c1 ea 0c             	shr    $0xc,%edx
  8022ea:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022f1:	f6 c2 01             	test   $0x1,%dl
  8022f4:	74 0e                	je     802304 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022f6:	c1 ea 0c             	shr    $0xc,%edx
  8022f9:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802300:	ef 
  802301:	0f b7 c0             	movzwl %ax,%eax
}
  802304:	5d                   	pop    %ebp
  802305:	c3                   	ret    
  802306:	66 90                	xchg   %ax,%ax
  802308:	66 90                	xchg   %ax,%ax
  80230a:	66 90                	xchg   %ax,%ax
  80230c:	66 90                	xchg   %ax,%ax
  80230e:	66 90                	xchg   %ax,%ax

00802310 <__udivdi3>:
  802310:	55                   	push   %ebp
  802311:	57                   	push   %edi
  802312:	56                   	push   %esi
  802313:	53                   	push   %ebx
  802314:	83 ec 1c             	sub    $0x1c,%esp
  802317:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80231b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80231f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802323:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802327:	85 d2                	test   %edx,%edx
  802329:	75 4d                	jne    802378 <__udivdi3+0x68>
  80232b:	39 f3                	cmp    %esi,%ebx
  80232d:	76 19                	jbe    802348 <__udivdi3+0x38>
  80232f:	31 ff                	xor    %edi,%edi
  802331:	89 e8                	mov    %ebp,%eax
  802333:	89 f2                	mov    %esi,%edx
  802335:	f7 f3                	div    %ebx
  802337:	89 fa                	mov    %edi,%edx
  802339:	83 c4 1c             	add    $0x1c,%esp
  80233c:	5b                   	pop    %ebx
  80233d:	5e                   	pop    %esi
  80233e:	5f                   	pop    %edi
  80233f:	5d                   	pop    %ebp
  802340:	c3                   	ret    
  802341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802348:	89 d9                	mov    %ebx,%ecx
  80234a:	85 db                	test   %ebx,%ebx
  80234c:	75 0b                	jne    802359 <__udivdi3+0x49>
  80234e:	b8 01 00 00 00       	mov    $0x1,%eax
  802353:	31 d2                	xor    %edx,%edx
  802355:	f7 f3                	div    %ebx
  802357:	89 c1                	mov    %eax,%ecx
  802359:	31 d2                	xor    %edx,%edx
  80235b:	89 f0                	mov    %esi,%eax
  80235d:	f7 f1                	div    %ecx
  80235f:	89 c6                	mov    %eax,%esi
  802361:	89 e8                	mov    %ebp,%eax
  802363:	89 f7                	mov    %esi,%edi
  802365:	f7 f1                	div    %ecx
  802367:	89 fa                	mov    %edi,%edx
  802369:	83 c4 1c             	add    $0x1c,%esp
  80236c:	5b                   	pop    %ebx
  80236d:	5e                   	pop    %esi
  80236e:	5f                   	pop    %edi
  80236f:	5d                   	pop    %ebp
  802370:	c3                   	ret    
  802371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802378:	39 f2                	cmp    %esi,%edx
  80237a:	77 1c                	ja     802398 <__udivdi3+0x88>
  80237c:	0f bd fa             	bsr    %edx,%edi
  80237f:	83 f7 1f             	xor    $0x1f,%edi
  802382:	75 2c                	jne    8023b0 <__udivdi3+0xa0>
  802384:	39 f2                	cmp    %esi,%edx
  802386:	72 06                	jb     80238e <__udivdi3+0x7e>
  802388:	31 c0                	xor    %eax,%eax
  80238a:	39 eb                	cmp    %ebp,%ebx
  80238c:	77 a9                	ja     802337 <__udivdi3+0x27>
  80238e:	b8 01 00 00 00       	mov    $0x1,%eax
  802393:	eb a2                	jmp    802337 <__udivdi3+0x27>
  802395:	8d 76 00             	lea    0x0(%esi),%esi
  802398:	31 ff                	xor    %edi,%edi
  80239a:	31 c0                	xor    %eax,%eax
  80239c:	89 fa                	mov    %edi,%edx
  80239e:	83 c4 1c             	add    $0x1c,%esp
  8023a1:	5b                   	pop    %ebx
  8023a2:	5e                   	pop    %esi
  8023a3:	5f                   	pop    %edi
  8023a4:	5d                   	pop    %ebp
  8023a5:	c3                   	ret    
  8023a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023ad:	8d 76 00             	lea    0x0(%esi),%esi
  8023b0:	89 f9                	mov    %edi,%ecx
  8023b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023b7:	29 f8                	sub    %edi,%eax
  8023b9:	d3 e2                	shl    %cl,%edx
  8023bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023bf:	89 c1                	mov    %eax,%ecx
  8023c1:	89 da                	mov    %ebx,%edx
  8023c3:	d3 ea                	shr    %cl,%edx
  8023c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023c9:	09 d1                	or     %edx,%ecx
  8023cb:	89 f2                	mov    %esi,%edx
  8023cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023d1:	89 f9                	mov    %edi,%ecx
  8023d3:	d3 e3                	shl    %cl,%ebx
  8023d5:	89 c1                	mov    %eax,%ecx
  8023d7:	d3 ea                	shr    %cl,%edx
  8023d9:	89 f9                	mov    %edi,%ecx
  8023db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023df:	89 eb                	mov    %ebp,%ebx
  8023e1:	d3 e6                	shl    %cl,%esi
  8023e3:	89 c1                	mov    %eax,%ecx
  8023e5:	d3 eb                	shr    %cl,%ebx
  8023e7:	09 de                	or     %ebx,%esi
  8023e9:	89 f0                	mov    %esi,%eax
  8023eb:	f7 74 24 08          	divl   0x8(%esp)
  8023ef:	89 d6                	mov    %edx,%esi
  8023f1:	89 c3                	mov    %eax,%ebx
  8023f3:	f7 64 24 0c          	mull   0xc(%esp)
  8023f7:	39 d6                	cmp    %edx,%esi
  8023f9:	72 15                	jb     802410 <__udivdi3+0x100>
  8023fb:	89 f9                	mov    %edi,%ecx
  8023fd:	d3 e5                	shl    %cl,%ebp
  8023ff:	39 c5                	cmp    %eax,%ebp
  802401:	73 04                	jae    802407 <__udivdi3+0xf7>
  802403:	39 d6                	cmp    %edx,%esi
  802405:	74 09                	je     802410 <__udivdi3+0x100>
  802407:	89 d8                	mov    %ebx,%eax
  802409:	31 ff                	xor    %edi,%edi
  80240b:	e9 27 ff ff ff       	jmp    802337 <__udivdi3+0x27>
  802410:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802413:	31 ff                	xor    %edi,%edi
  802415:	e9 1d ff ff ff       	jmp    802337 <__udivdi3+0x27>
  80241a:	66 90                	xchg   %ax,%ax
  80241c:	66 90                	xchg   %ax,%ax
  80241e:	66 90                	xchg   %ax,%ax

00802420 <__umoddi3>:
  802420:	55                   	push   %ebp
  802421:	57                   	push   %edi
  802422:	56                   	push   %esi
  802423:	53                   	push   %ebx
  802424:	83 ec 1c             	sub    $0x1c,%esp
  802427:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80242b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80242f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802433:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802437:	89 da                	mov    %ebx,%edx
  802439:	85 c0                	test   %eax,%eax
  80243b:	75 43                	jne    802480 <__umoddi3+0x60>
  80243d:	39 df                	cmp    %ebx,%edi
  80243f:	76 17                	jbe    802458 <__umoddi3+0x38>
  802441:	89 f0                	mov    %esi,%eax
  802443:	f7 f7                	div    %edi
  802445:	89 d0                	mov    %edx,%eax
  802447:	31 d2                	xor    %edx,%edx
  802449:	83 c4 1c             	add    $0x1c,%esp
  80244c:	5b                   	pop    %ebx
  80244d:	5e                   	pop    %esi
  80244e:	5f                   	pop    %edi
  80244f:	5d                   	pop    %ebp
  802450:	c3                   	ret    
  802451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802458:	89 fd                	mov    %edi,%ebp
  80245a:	85 ff                	test   %edi,%edi
  80245c:	75 0b                	jne    802469 <__umoddi3+0x49>
  80245e:	b8 01 00 00 00       	mov    $0x1,%eax
  802463:	31 d2                	xor    %edx,%edx
  802465:	f7 f7                	div    %edi
  802467:	89 c5                	mov    %eax,%ebp
  802469:	89 d8                	mov    %ebx,%eax
  80246b:	31 d2                	xor    %edx,%edx
  80246d:	f7 f5                	div    %ebp
  80246f:	89 f0                	mov    %esi,%eax
  802471:	f7 f5                	div    %ebp
  802473:	89 d0                	mov    %edx,%eax
  802475:	eb d0                	jmp    802447 <__umoddi3+0x27>
  802477:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80247e:	66 90                	xchg   %ax,%ax
  802480:	89 f1                	mov    %esi,%ecx
  802482:	39 d8                	cmp    %ebx,%eax
  802484:	76 0a                	jbe    802490 <__umoddi3+0x70>
  802486:	89 f0                	mov    %esi,%eax
  802488:	83 c4 1c             	add    $0x1c,%esp
  80248b:	5b                   	pop    %ebx
  80248c:	5e                   	pop    %esi
  80248d:	5f                   	pop    %edi
  80248e:	5d                   	pop    %ebp
  80248f:	c3                   	ret    
  802490:	0f bd e8             	bsr    %eax,%ebp
  802493:	83 f5 1f             	xor    $0x1f,%ebp
  802496:	75 20                	jne    8024b8 <__umoddi3+0x98>
  802498:	39 d8                	cmp    %ebx,%eax
  80249a:	0f 82 b0 00 00 00    	jb     802550 <__umoddi3+0x130>
  8024a0:	39 f7                	cmp    %esi,%edi
  8024a2:	0f 86 a8 00 00 00    	jbe    802550 <__umoddi3+0x130>
  8024a8:	89 c8                	mov    %ecx,%eax
  8024aa:	83 c4 1c             	add    $0x1c,%esp
  8024ad:	5b                   	pop    %ebx
  8024ae:	5e                   	pop    %esi
  8024af:	5f                   	pop    %edi
  8024b0:	5d                   	pop    %ebp
  8024b1:	c3                   	ret    
  8024b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024b8:	89 e9                	mov    %ebp,%ecx
  8024ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8024bf:	29 ea                	sub    %ebp,%edx
  8024c1:	d3 e0                	shl    %cl,%eax
  8024c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024c7:	89 d1                	mov    %edx,%ecx
  8024c9:	89 f8                	mov    %edi,%eax
  8024cb:	d3 e8                	shr    %cl,%eax
  8024cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024d9:	09 c1                	or     %eax,%ecx
  8024db:	89 d8                	mov    %ebx,%eax
  8024dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024e1:	89 e9                	mov    %ebp,%ecx
  8024e3:	d3 e7                	shl    %cl,%edi
  8024e5:	89 d1                	mov    %edx,%ecx
  8024e7:	d3 e8                	shr    %cl,%eax
  8024e9:	89 e9                	mov    %ebp,%ecx
  8024eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024ef:	d3 e3                	shl    %cl,%ebx
  8024f1:	89 c7                	mov    %eax,%edi
  8024f3:	89 d1                	mov    %edx,%ecx
  8024f5:	89 f0                	mov    %esi,%eax
  8024f7:	d3 e8                	shr    %cl,%eax
  8024f9:	89 e9                	mov    %ebp,%ecx
  8024fb:	89 fa                	mov    %edi,%edx
  8024fd:	d3 e6                	shl    %cl,%esi
  8024ff:	09 d8                	or     %ebx,%eax
  802501:	f7 74 24 08          	divl   0x8(%esp)
  802505:	89 d1                	mov    %edx,%ecx
  802507:	89 f3                	mov    %esi,%ebx
  802509:	f7 64 24 0c          	mull   0xc(%esp)
  80250d:	89 c6                	mov    %eax,%esi
  80250f:	89 d7                	mov    %edx,%edi
  802511:	39 d1                	cmp    %edx,%ecx
  802513:	72 06                	jb     80251b <__umoddi3+0xfb>
  802515:	75 10                	jne    802527 <__umoddi3+0x107>
  802517:	39 c3                	cmp    %eax,%ebx
  802519:	73 0c                	jae    802527 <__umoddi3+0x107>
  80251b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80251f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802523:	89 d7                	mov    %edx,%edi
  802525:	89 c6                	mov    %eax,%esi
  802527:	89 ca                	mov    %ecx,%edx
  802529:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80252e:	29 f3                	sub    %esi,%ebx
  802530:	19 fa                	sbb    %edi,%edx
  802532:	89 d0                	mov    %edx,%eax
  802534:	d3 e0                	shl    %cl,%eax
  802536:	89 e9                	mov    %ebp,%ecx
  802538:	d3 eb                	shr    %cl,%ebx
  80253a:	d3 ea                	shr    %cl,%edx
  80253c:	09 d8                	or     %ebx,%eax
  80253e:	83 c4 1c             	add    $0x1c,%esp
  802541:	5b                   	pop    %ebx
  802542:	5e                   	pop    %esi
  802543:	5f                   	pop    %edi
  802544:	5d                   	pop    %ebp
  802545:	c3                   	ret    
  802546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80254d:	8d 76 00             	lea    0x0(%esi),%esi
  802550:	89 da                	mov    %ebx,%edx
  802552:	29 fe                	sub    %edi,%esi
  802554:	19 c2                	sbb    %eax,%edx
  802556:	89 f1                	mov    %esi,%ecx
  802558:	89 c8                	mov    %ecx,%eax
  80255a:	e9 4b ff ff ff       	jmp    8024aa <__umoddi3+0x8a>
