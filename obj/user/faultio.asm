
obj/user/faultio.debug:     file format elf32-i386


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
  80002c:	e8 52 00 00 00       	call   800083 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>
#include <inc/x86.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	cprintf("in faultio.c %s\n", __FUNCTION__);//just test
  800039:	68 5c 25 80 00       	push   $0x80255c
  80003e:	68 20 25 80 00       	push   $0x802520
  800043:	e8 4d 01 00 00       	call   800195 <cprintf>

static inline uint32_t
read_eflags(void)
{
	uint32_t eflags;
	asm volatile("pushfl; popl %0" : "=r" (eflags));
  800048:	9c                   	pushf  
  800049:	58                   	pop    %eax
  80004a:	9c                   	pushf  
  80004b:	58                   	pop    %eax
        int x, r;
	int nsecs = 1;
	int secno = 0;
	int diskno = 1;
	int t = read_eflags();
	if (read_eflags() & FL_IOPL_3)
  80004c:	83 c4 10             	add    $0x10,%esp
  80004f:	f6 c4 30             	test   $0x30,%ah
  800052:	75 1d                	jne    800071 <umain+0x3e>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800054:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800059:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80005e:	ee                   	out    %al,(%dx)
	// this outb to select disk 1 should result in a general protection
	// fault, because user-level code shouldn't be able to use the io space.
	outb(0x1F6, 0xE0 | (1<<4));

	// cprintf("the read_eflags is 0x%x -- FL_IOPL_3: 0x%x\n", read_eflags(), FL_IOPL_3);
        cprintf("%s: made it here --- bug\n");
  80005f:	83 ec 0c             	sub    $0xc,%esp
  800062:	68 3f 25 80 00       	push   $0x80253f
  800067:	e8 29 01 00 00       	call   800195 <cprintf>
}
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	c9                   	leave  
  800070:	c3                   	ret    
		cprintf("eflags wrong\n");
  800071:	83 ec 0c             	sub    $0xc,%esp
  800074:	68 31 25 80 00       	push   $0x802531
  800079:	e8 17 01 00 00       	call   800195 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp
  800081:	eb d1                	jmp    800054 <umain+0x21>

00800083 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800083:	55                   	push   %ebp
  800084:	89 e5                	mov    %esp,%ebp
  800086:	56                   	push   %esi
  800087:	53                   	push   %ebx
  800088:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80008b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  80008e:	e8 15 0c 00 00       	call   800ca8 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  800093:	25 ff 03 00 00       	and    $0x3ff,%eax
  800098:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80009e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000a3:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a8:	85 db                	test   %ebx,%ebx
  8000aa:	7e 07                	jle    8000b3 <libmain+0x30>
		binaryname = argv[0];
  8000ac:	8b 06                	mov    (%esi),%eax
  8000ae:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	56                   	push   %esi
  8000b7:	53                   	push   %ebx
  8000b8:	e8 76 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000bd:	e8 0a 00 00 00       	call   8000cc <exit>
}
  8000c2:	83 c4 10             	add    $0x10,%esp
  8000c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c8:	5b                   	pop    %ebx
  8000c9:	5e                   	pop    %esi
  8000ca:	5d                   	pop    %ebp
  8000cb:	c3                   	ret    

008000cc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000cc:	55                   	push   %ebp
  8000cd:	89 e5                	mov    %esp,%ebp
  8000cf:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8000d2:	a1 08 40 80 00       	mov    0x804008,%eax
  8000d7:	8b 40 48             	mov    0x48(%eax),%eax
  8000da:	68 78 25 80 00       	push   $0x802578
  8000df:	50                   	push   %eax
  8000e0:	68 6c 25 80 00       	push   $0x80256c
  8000e5:	e8 ab 00 00 00       	call   800195 <cprintf>
	close_all();
  8000ea:	e8 c4 10 00 00       	call   8011b3 <close_all>
	sys_env_destroy(0);
  8000ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000f6:	e8 6c 0b 00 00       	call   800c67 <sys_env_destroy>
}
  8000fb:	83 c4 10             	add    $0x10,%esp
  8000fe:	c9                   	leave  
  8000ff:	c3                   	ret    

00800100 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800100:	55                   	push   %ebp
  800101:	89 e5                	mov    %esp,%ebp
  800103:	53                   	push   %ebx
  800104:	83 ec 04             	sub    $0x4,%esp
  800107:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80010a:	8b 13                	mov    (%ebx),%edx
  80010c:	8d 42 01             	lea    0x1(%edx),%eax
  80010f:	89 03                	mov    %eax,(%ebx)
  800111:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800114:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800118:	3d ff 00 00 00       	cmp    $0xff,%eax
  80011d:	74 09                	je     800128 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80011f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800123:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800126:	c9                   	leave  
  800127:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800128:	83 ec 08             	sub    $0x8,%esp
  80012b:	68 ff 00 00 00       	push   $0xff
  800130:	8d 43 08             	lea    0x8(%ebx),%eax
  800133:	50                   	push   %eax
  800134:	e8 f1 0a 00 00       	call   800c2a <sys_cputs>
		b->idx = 0;
  800139:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80013f:	83 c4 10             	add    $0x10,%esp
  800142:	eb db                	jmp    80011f <putch+0x1f>

00800144 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800144:	55                   	push   %ebp
  800145:	89 e5                	mov    %esp,%ebp
  800147:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80014d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800154:	00 00 00 
	b.cnt = 0;
  800157:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80015e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800161:	ff 75 0c             	pushl  0xc(%ebp)
  800164:	ff 75 08             	pushl  0x8(%ebp)
  800167:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80016d:	50                   	push   %eax
  80016e:	68 00 01 80 00       	push   $0x800100
  800173:	e8 4a 01 00 00       	call   8002c2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800178:	83 c4 08             	add    $0x8,%esp
  80017b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800181:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800187:	50                   	push   %eax
  800188:	e8 9d 0a 00 00       	call   800c2a <sys_cputs>

	return b.cnt;
}
  80018d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800193:	c9                   	leave  
  800194:	c3                   	ret    

00800195 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800195:	55                   	push   %ebp
  800196:	89 e5                	mov    %esp,%ebp
  800198:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80019b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80019e:	50                   	push   %eax
  80019f:	ff 75 08             	pushl  0x8(%ebp)
  8001a2:	e8 9d ff ff ff       	call   800144 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001a7:	c9                   	leave  
  8001a8:	c3                   	ret    

008001a9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001a9:	55                   	push   %ebp
  8001aa:	89 e5                	mov    %esp,%ebp
  8001ac:	57                   	push   %edi
  8001ad:	56                   	push   %esi
  8001ae:	53                   	push   %ebx
  8001af:	83 ec 1c             	sub    $0x1c,%esp
  8001b2:	89 c6                	mov    %eax,%esi
  8001b4:	89 d7                	mov    %edx,%edi
  8001b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001bf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8001c5:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001c8:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001cc:	74 2c                	je     8001fa <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8001ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001d1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001d8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001db:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001de:	39 c2                	cmp    %eax,%edx
  8001e0:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001e3:	73 43                	jae    800228 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8001e5:	83 eb 01             	sub    $0x1,%ebx
  8001e8:	85 db                	test   %ebx,%ebx
  8001ea:	7e 6c                	jle    800258 <printnum+0xaf>
				putch(padc, putdat);
  8001ec:	83 ec 08             	sub    $0x8,%esp
  8001ef:	57                   	push   %edi
  8001f0:	ff 75 18             	pushl  0x18(%ebp)
  8001f3:	ff d6                	call   *%esi
  8001f5:	83 c4 10             	add    $0x10,%esp
  8001f8:	eb eb                	jmp    8001e5 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	6a 20                	push   $0x20
  8001ff:	6a 00                	push   $0x0
  800201:	50                   	push   %eax
  800202:	ff 75 e4             	pushl  -0x1c(%ebp)
  800205:	ff 75 e0             	pushl  -0x20(%ebp)
  800208:	89 fa                	mov    %edi,%edx
  80020a:	89 f0                	mov    %esi,%eax
  80020c:	e8 98 ff ff ff       	call   8001a9 <printnum>
		while (--width > 0)
  800211:	83 c4 20             	add    $0x20,%esp
  800214:	83 eb 01             	sub    $0x1,%ebx
  800217:	85 db                	test   %ebx,%ebx
  800219:	7e 65                	jle    800280 <printnum+0xd7>
			putch(padc, putdat);
  80021b:	83 ec 08             	sub    $0x8,%esp
  80021e:	57                   	push   %edi
  80021f:	6a 20                	push   $0x20
  800221:	ff d6                	call   *%esi
  800223:	83 c4 10             	add    $0x10,%esp
  800226:	eb ec                	jmp    800214 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800228:	83 ec 0c             	sub    $0xc,%esp
  80022b:	ff 75 18             	pushl  0x18(%ebp)
  80022e:	83 eb 01             	sub    $0x1,%ebx
  800231:	53                   	push   %ebx
  800232:	50                   	push   %eax
  800233:	83 ec 08             	sub    $0x8,%esp
  800236:	ff 75 dc             	pushl  -0x24(%ebp)
  800239:	ff 75 d8             	pushl  -0x28(%ebp)
  80023c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023f:	ff 75 e0             	pushl  -0x20(%ebp)
  800242:	e8 89 20 00 00       	call   8022d0 <__udivdi3>
  800247:	83 c4 18             	add    $0x18,%esp
  80024a:	52                   	push   %edx
  80024b:	50                   	push   %eax
  80024c:	89 fa                	mov    %edi,%edx
  80024e:	89 f0                	mov    %esi,%eax
  800250:	e8 54 ff ff ff       	call   8001a9 <printnum>
  800255:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800258:	83 ec 08             	sub    $0x8,%esp
  80025b:	57                   	push   %edi
  80025c:	83 ec 04             	sub    $0x4,%esp
  80025f:	ff 75 dc             	pushl  -0x24(%ebp)
  800262:	ff 75 d8             	pushl  -0x28(%ebp)
  800265:	ff 75 e4             	pushl  -0x1c(%ebp)
  800268:	ff 75 e0             	pushl  -0x20(%ebp)
  80026b:	e8 70 21 00 00       	call   8023e0 <__umoddi3>
  800270:	83 c4 14             	add    $0x14,%esp
  800273:	0f be 80 7d 25 80 00 	movsbl 0x80257d(%eax),%eax
  80027a:	50                   	push   %eax
  80027b:	ff d6                	call   *%esi
  80027d:	83 c4 10             	add    $0x10,%esp
	}
}
  800280:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800283:	5b                   	pop    %ebx
  800284:	5e                   	pop    %esi
  800285:	5f                   	pop    %edi
  800286:	5d                   	pop    %ebp
  800287:	c3                   	ret    

00800288 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800288:	55                   	push   %ebp
  800289:	89 e5                	mov    %esp,%ebp
  80028b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80028e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800292:	8b 10                	mov    (%eax),%edx
  800294:	3b 50 04             	cmp    0x4(%eax),%edx
  800297:	73 0a                	jae    8002a3 <sprintputch+0x1b>
		*b->buf++ = ch;
  800299:	8d 4a 01             	lea    0x1(%edx),%ecx
  80029c:	89 08                	mov    %ecx,(%eax)
  80029e:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a1:	88 02                	mov    %al,(%edx)
}
  8002a3:	5d                   	pop    %ebp
  8002a4:	c3                   	ret    

008002a5 <printfmt>:
{
  8002a5:	55                   	push   %ebp
  8002a6:	89 e5                	mov    %esp,%ebp
  8002a8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002ab:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002ae:	50                   	push   %eax
  8002af:	ff 75 10             	pushl  0x10(%ebp)
  8002b2:	ff 75 0c             	pushl  0xc(%ebp)
  8002b5:	ff 75 08             	pushl  0x8(%ebp)
  8002b8:	e8 05 00 00 00       	call   8002c2 <vprintfmt>
}
  8002bd:	83 c4 10             	add    $0x10,%esp
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <vprintfmt>:
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	57                   	push   %edi
  8002c6:	56                   	push   %esi
  8002c7:	53                   	push   %ebx
  8002c8:	83 ec 3c             	sub    $0x3c,%esp
  8002cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8002ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002d1:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002d4:	e9 32 04 00 00       	jmp    80070b <vprintfmt+0x449>
		padc = ' ';
  8002d9:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8002dd:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8002e4:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8002eb:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002f2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002f9:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800300:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800305:	8d 47 01             	lea    0x1(%edi),%eax
  800308:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80030b:	0f b6 17             	movzbl (%edi),%edx
  80030e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800311:	3c 55                	cmp    $0x55,%al
  800313:	0f 87 12 05 00 00    	ja     80082b <vprintfmt+0x569>
  800319:	0f b6 c0             	movzbl %al,%eax
  80031c:	ff 24 85 60 27 80 00 	jmp    *0x802760(,%eax,4)
  800323:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800326:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80032a:	eb d9                	jmp    800305 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80032c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80032f:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800333:	eb d0                	jmp    800305 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800335:	0f b6 d2             	movzbl %dl,%edx
  800338:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80033b:	b8 00 00 00 00       	mov    $0x0,%eax
  800340:	89 75 08             	mov    %esi,0x8(%ebp)
  800343:	eb 03                	jmp    800348 <vprintfmt+0x86>
  800345:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800348:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80034b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80034f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800352:	8d 72 d0             	lea    -0x30(%edx),%esi
  800355:	83 fe 09             	cmp    $0x9,%esi
  800358:	76 eb                	jbe    800345 <vprintfmt+0x83>
  80035a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80035d:	8b 75 08             	mov    0x8(%ebp),%esi
  800360:	eb 14                	jmp    800376 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800362:	8b 45 14             	mov    0x14(%ebp),%eax
  800365:	8b 00                	mov    (%eax),%eax
  800367:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80036a:	8b 45 14             	mov    0x14(%ebp),%eax
  80036d:	8d 40 04             	lea    0x4(%eax),%eax
  800370:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800373:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800376:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80037a:	79 89                	jns    800305 <vprintfmt+0x43>
				width = precision, precision = -1;
  80037c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80037f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800382:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800389:	e9 77 ff ff ff       	jmp    800305 <vprintfmt+0x43>
  80038e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800391:	85 c0                	test   %eax,%eax
  800393:	0f 48 c1             	cmovs  %ecx,%eax
  800396:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800399:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80039c:	e9 64 ff ff ff       	jmp    800305 <vprintfmt+0x43>
  8003a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003a4:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003ab:	e9 55 ff ff ff       	jmp    800305 <vprintfmt+0x43>
			lflag++;
  8003b0:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003b7:	e9 49 ff ff ff       	jmp    800305 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bf:	8d 78 04             	lea    0x4(%eax),%edi
  8003c2:	83 ec 08             	sub    $0x8,%esp
  8003c5:	53                   	push   %ebx
  8003c6:	ff 30                	pushl  (%eax)
  8003c8:	ff d6                	call   *%esi
			break;
  8003ca:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003cd:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003d0:	e9 33 03 00 00       	jmp    800708 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8003d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d8:	8d 78 04             	lea    0x4(%eax),%edi
  8003db:	8b 00                	mov    (%eax),%eax
  8003dd:	99                   	cltd   
  8003de:	31 d0                	xor    %edx,%eax
  8003e0:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003e2:	83 f8 11             	cmp    $0x11,%eax
  8003e5:	7f 23                	jg     80040a <vprintfmt+0x148>
  8003e7:	8b 14 85 c0 28 80 00 	mov    0x8028c0(,%eax,4),%edx
  8003ee:	85 d2                	test   %edx,%edx
  8003f0:	74 18                	je     80040a <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8003f2:	52                   	push   %edx
  8003f3:	68 dd 29 80 00       	push   $0x8029dd
  8003f8:	53                   	push   %ebx
  8003f9:	56                   	push   %esi
  8003fa:	e8 a6 fe ff ff       	call   8002a5 <printfmt>
  8003ff:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800402:	89 7d 14             	mov    %edi,0x14(%ebp)
  800405:	e9 fe 02 00 00       	jmp    800708 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80040a:	50                   	push   %eax
  80040b:	68 95 25 80 00       	push   $0x802595
  800410:	53                   	push   %ebx
  800411:	56                   	push   %esi
  800412:	e8 8e fe ff ff       	call   8002a5 <printfmt>
  800417:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80041a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80041d:	e9 e6 02 00 00       	jmp    800708 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800422:	8b 45 14             	mov    0x14(%ebp),%eax
  800425:	83 c0 04             	add    $0x4,%eax
  800428:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80042b:	8b 45 14             	mov    0x14(%ebp),%eax
  80042e:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800430:	85 c9                	test   %ecx,%ecx
  800432:	b8 8e 25 80 00       	mov    $0x80258e,%eax
  800437:	0f 45 c1             	cmovne %ecx,%eax
  80043a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80043d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800441:	7e 06                	jle    800449 <vprintfmt+0x187>
  800443:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800447:	75 0d                	jne    800456 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800449:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80044c:	89 c7                	mov    %eax,%edi
  80044e:	03 45 e0             	add    -0x20(%ebp),%eax
  800451:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800454:	eb 53                	jmp    8004a9 <vprintfmt+0x1e7>
  800456:	83 ec 08             	sub    $0x8,%esp
  800459:	ff 75 d8             	pushl  -0x28(%ebp)
  80045c:	50                   	push   %eax
  80045d:	e8 71 04 00 00       	call   8008d3 <strnlen>
  800462:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800465:	29 c1                	sub    %eax,%ecx
  800467:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80046a:	83 c4 10             	add    $0x10,%esp
  80046d:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80046f:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800473:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800476:	eb 0f                	jmp    800487 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800478:	83 ec 08             	sub    $0x8,%esp
  80047b:	53                   	push   %ebx
  80047c:	ff 75 e0             	pushl  -0x20(%ebp)
  80047f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800481:	83 ef 01             	sub    $0x1,%edi
  800484:	83 c4 10             	add    $0x10,%esp
  800487:	85 ff                	test   %edi,%edi
  800489:	7f ed                	jg     800478 <vprintfmt+0x1b6>
  80048b:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80048e:	85 c9                	test   %ecx,%ecx
  800490:	b8 00 00 00 00       	mov    $0x0,%eax
  800495:	0f 49 c1             	cmovns %ecx,%eax
  800498:	29 c1                	sub    %eax,%ecx
  80049a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80049d:	eb aa                	jmp    800449 <vprintfmt+0x187>
					putch(ch, putdat);
  80049f:	83 ec 08             	sub    $0x8,%esp
  8004a2:	53                   	push   %ebx
  8004a3:	52                   	push   %edx
  8004a4:	ff d6                	call   *%esi
  8004a6:	83 c4 10             	add    $0x10,%esp
  8004a9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ac:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004ae:	83 c7 01             	add    $0x1,%edi
  8004b1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004b5:	0f be d0             	movsbl %al,%edx
  8004b8:	85 d2                	test   %edx,%edx
  8004ba:	74 4b                	je     800507 <vprintfmt+0x245>
  8004bc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004c0:	78 06                	js     8004c8 <vprintfmt+0x206>
  8004c2:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004c6:	78 1e                	js     8004e6 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8004c8:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004cc:	74 d1                	je     80049f <vprintfmt+0x1dd>
  8004ce:	0f be c0             	movsbl %al,%eax
  8004d1:	83 e8 20             	sub    $0x20,%eax
  8004d4:	83 f8 5e             	cmp    $0x5e,%eax
  8004d7:	76 c6                	jbe    80049f <vprintfmt+0x1dd>
					putch('?', putdat);
  8004d9:	83 ec 08             	sub    $0x8,%esp
  8004dc:	53                   	push   %ebx
  8004dd:	6a 3f                	push   $0x3f
  8004df:	ff d6                	call   *%esi
  8004e1:	83 c4 10             	add    $0x10,%esp
  8004e4:	eb c3                	jmp    8004a9 <vprintfmt+0x1e7>
  8004e6:	89 cf                	mov    %ecx,%edi
  8004e8:	eb 0e                	jmp    8004f8 <vprintfmt+0x236>
				putch(' ', putdat);
  8004ea:	83 ec 08             	sub    $0x8,%esp
  8004ed:	53                   	push   %ebx
  8004ee:	6a 20                	push   $0x20
  8004f0:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004f2:	83 ef 01             	sub    $0x1,%edi
  8004f5:	83 c4 10             	add    $0x10,%esp
  8004f8:	85 ff                	test   %edi,%edi
  8004fa:	7f ee                	jg     8004ea <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8004fc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800502:	e9 01 02 00 00       	jmp    800708 <vprintfmt+0x446>
  800507:	89 cf                	mov    %ecx,%edi
  800509:	eb ed                	jmp    8004f8 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80050b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80050e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800515:	e9 eb fd ff ff       	jmp    800305 <vprintfmt+0x43>
	if (lflag >= 2)
  80051a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80051e:	7f 21                	jg     800541 <vprintfmt+0x27f>
	else if (lflag)
  800520:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800524:	74 68                	je     80058e <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800526:	8b 45 14             	mov    0x14(%ebp),%eax
  800529:	8b 00                	mov    (%eax),%eax
  80052b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80052e:	89 c1                	mov    %eax,%ecx
  800530:	c1 f9 1f             	sar    $0x1f,%ecx
  800533:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800536:	8b 45 14             	mov    0x14(%ebp),%eax
  800539:	8d 40 04             	lea    0x4(%eax),%eax
  80053c:	89 45 14             	mov    %eax,0x14(%ebp)
  80053f:	eb 17                	jmp    800558 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800541:	8b 45 14             	mov    0x14(%ebp),%eax
  800544:	8b 50 04             	mov    0x4(%eax),%edx
  800547:	8b 00                	mov    (%eax),%eax
  800549:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80054c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80054f:	8b 45 14             	mov    0x14(%ebp),%eax
  800552:	8d 40 08             	lea    0x8(%eax),%eax
  800555:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800558:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80055b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80055e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800561:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800564:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800568:	78 3f                	js     8005a9 <vprintfmt+0x2e7>
			base = 10;
  80056a:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80056f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800573:	0f 84 71 01 00 00    	je     8006ea <vprintfmt+0x428>
				putch('+', putdat);
  800579:	83 ec 08             	sub    $0x8,%esp
  80057c:	53                   	push   %ebx
  80057d:	6a 2b                	push   $0x2b
  80057f:	ff d6                	call   *%esi
  800581:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800584:	b8 0a 00 00 00       	mov    $0xa,%eax
  800589:	e9 5c 01 00 00       	jmp    8006ea <vprintfmt+0x428>
		return va_arg(*ap, int);
  80058e:	8b 45 14             	mov    0x14(%ebp),%eax
  800591:	8b 00                	mov    (%eax),%eax
  800593:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800596:	89 c1                	mov    %eax,%ecx
  800598:	c1 f9 1f             	sar    $0x1f,%ecx
  80059b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80059e:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a1:	8d 40 04             	lea    0x4(%eax),%eax
  8005a4:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a7:	eb af                	jmp    800558 <vprintfmt+0x296>
				putch('-', putdat);
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	53                   	push   %ebx
  8005ad:	6a 2d                	push   $0x2d
  8005af:	ff d6                	call   *%esi
				num = -(long long) num;
  8005b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005b4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005b7:	f7 d8                	neg    %eax
  8005b9:	83 d2 00             	adc    $0x0,%edx
  8005bc:	f7 da                	neg    %edx
  8005be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005c7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005cc:	e9 19 01 00 00       	jmp    8006ea <vprintfmt+0x428>
	if (lflag >= 2)
  8005d1:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005d5:	7f 29                	jg     800600 <vprintfmt+0x33e>
	else if (lflag)
  8005d7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005db:	74 44                	je     800621 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	8b 00                	mov    (%eax),%eax
  8005e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ea:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f0:	8d 40 04             	lea    0x4(%eax),%eax
  8005f3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005f6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005fb:	e9 ea 00 00 00       	jmp    8006ea <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800600:	8b 45 14             	mov    0x14(%ebp),%eax
  800603:	8b 50 04             	mov    0x4(%eax),%edx
  800606:	8b 00                	mov    (%eax),%eax
  800608:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	8d 40 08             	lea    0x8(%eax),%eax
  800614:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800617:	b8 0a 00 00 00       	mov    $0xa,%eax
  80061c:	e9 c9 00 00 00       	jmp    8006ea <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	8b 00                	mov    (%eax),%eax
  800626:	ba 00 00 00 00       	mov    $0x0,%edx
  80062b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	8d 40 04             	lea    0x4(%eax),%eax
  800637:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80063f:	e9 a6 00 00 00       	jmp    8006ea <vprintfmt+0x428>
			putch('0', putdat);
  800644:	83 ec 08             	sub    $0x8,%esp
  800647:	53                   	push   %ebx
  800648:	6a 30                	push   $0x30
  80064a:	ff d6                	call   *%esi
	if (lflag >= 2)
  80064c:	83 c4 10             	add    $0x10,%esp
  80064f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800653:	7f 26                	jg     80067b <vprintfmt+0x3b9>
	else if (lflag)
  800655:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800659:	74 3e                	je     800699 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	ba 00 00 00 00       	mov    $0x0,%edx
  800665:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800668:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80066b:	8b 45 14             	mov    0x14(%ebp),%eax
  80066e:	8d 40 04             	lea    0x4(%eax),%eax
  800671:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800674:	b8 08 00 00 00       	mov    $0x8,%eax
  800679:	eb 6f                	jmp    8006ea <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	8b 50 04             	mov    0x4(%eax),%edx
  800681:	8b 00                	mov    (%eax),%eax
  800683:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800686:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	8d 40 08             	lea    0x8(%eax),%eax
  80068f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800692:	b8 08 00 00 00       	mov    $0x8,%eax
  800697:	eb 51                	jmp    8006ea <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800699:	8b 45 14             	mov    0x14(%ebp),%eax
  80069c:	8b 00                	mov    (%eax),%eax
  80069e:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	8d 40 04             	lea    0x4(%eax),%eax
  8006af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006b2:	b8 08 00 00 00       	mov    $0x8,%eax
  8006b7:	eb 31                	jmp    8006ea <vprintfmt+0x428>
			putch('0', putdat);
  8006b9:	83 ec 08             	sub    $0x8,%esp
  8006bc:	53                   	push   %ebx
  8006bd:	6a 30                	push   $0x30
  8006bf:	ff d6                	call   *%esi
			putch('x', putdat);
  8006c1:	83 c4 08             	add    $0x8,%esp
  8006c4:	53                   	push   %ebx
  8006c5:	6a 78                	push   $0x78
  8006c7:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cc:	8b 00                	mov    (%eax),%eax
  8006ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006d9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006df:	8d 40 04             	lea    0x4(%eax),%eax
  8006e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006e5:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006ea:	83 ec 0c             	sub    $0xc,%esp
  8006ed:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8006f1:	52                   	push   %edx
  8006f2:	ff 75 e0             	pushl  -0x20(%ebp)
  8006f5:	50                   	push   %eax
  8006f6:	ff 75 dc             	pushl  -0x24(%ebp)
  8006f9:	ff 75 d8             	pushl  -0x28(%ebp)
  8006fc:	89 da                	mov    %ebx,%edx
  8006fe:	89 f0                	mov    %esi,%eax
  800700:	e8 a4 fa ff ff       	call   8001a9 <printnum>
			break;
  800705:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800708:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070b:	83 c7 01             	add    $0x1,%edi
  80070e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800712:	83 f8 25             	cmp    $0x25,%eax
  800715:	0f 84 be fb ff ff    	je     8002d9 <vprintfmt+0x17>
			if (ch == '\0')
  80071b:	85 c0                	test   %eax,%eax
  80071d:	0f 84 28 01 00 00    	je     80084b <vprintfmt+0x589>
			putch(ch, putdat);
  800723:	83 ec 08             	sub    $0x8,%esp
  800726:	53                   	push   %ebx
  800727:	50                   	push   %eax
  800728:	ff d6                	call   *%esi
  80072a:	83 c4 10             	add    $0x10,%esp
  80072d:	eb dc                	jmp    80070b <vprintfmt+0x449>
	if (lflag >= 2)
  80072f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800733:	7f 26                	jg     80075b <vprintfmt+0x499>
	else if (lflag)
  800735:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800739:	74 41                	je     80077c <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80073b:	8b 45 14             	mov    0x14(%ebp),%eax
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	ba 00 00 00 00       	mov    $0x0,%edx
  800745:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800748:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80074b:	8b 45 14             	mov    0x14(%ebp),%eax
  80074e:	8d 40 04             	lea    0x4(%eax),%eax
  800751:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800754:	b8 10 00 00 00       	mov    $0x10,%eax
  800759:	eb 8f                	jmp    8006ea <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80075b:	8b 45 14             	mov    0x14(%ebp),%eax
  80075e:	8b 50 04             	mov    0x4(%eax),%edx
  800761:	8b 00                	mov    (%eax),%eax
  800763:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800766:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800769:	8b 45 14             	mov    0x14(%ebp),%eax
  80076c:	8d 40 08             	lea    0x8(%eax),%eax
  80076f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800772:	b8 10 00 00 00       	mov    $0x10,%eax
  800777:	e9 6e ff ff ff       	jmp    8006ea <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	8b 00                	mov    (%eax),%eax
  800781:	ba 00 00 00 00       	mov    $0x0,%edx
  800786:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800789:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078c:	8b 45 14             	mov    0x14(%ebp),%eax
  80078f:	8d 40 04             	lea    0x4(%eax),%eax
  800792:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800795:	b8 10 00 00 00       	mov    $0x10,%eax
  80079a:	e9 4b ff ff ff       	jmp    8006ea <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80079f:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a2:	83 c0 04             	add    $0x4,%eax
  8007a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ab:	8b 00                	mov    (%eax),%eax
  8007ad:	85 c0                	test   %eax,%eax
  8007af:	74 14                	je     8007c5 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007b1:	8b 13                	mov    (%ebx),%edx
  8007b3:	83 fa 7f             	cmp    $0x7f,%edx
  8007b6:	7f 37                	jg     8007ef <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007b8:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007bd:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c0:	e9 43 ff ff ff       	jmp    800708 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8007c5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ca:	bf b1 26 80 00       	mov    $0x8026b1,%edi
							putch(ch, putdat);
  8007cf:	83 ec 08             	sub    $0x8,%esp
  8007d2:	53                   	push   %ebx
  8007d3:	50                   	push   %eax
  8007d4:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007d6:	83 c7 01             	add    $0x1,%edi
  8007d9:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007dd:	83 c4 10             	add    $0x10,%esp
  8007e0:	85 c0                	test   %eax,%eax
  8007e2:	75 eb                	jne    8007cf <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8007e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ea:	e9 19 ff ff ff       	jmp    800708 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8007ef:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8007f1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007f6:	bf e9 26 80 00       	mov    $0x8026e9,%edi
							putch(ch, putdat);
  8007fb:	83 ec 08             	sub    $0x8,%esp
  8007fe:	53                   	push   %ebx
  8007ff:	50                   	push   %eax
  800800:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800802:	83 c7 01             	add    $0x1,%edi
  800805:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800809:	83 c4 10             	add    $0x10,%esp
  80080c:	85 c0                	test   %eax,%eax
  80080e:	75 eb                	jne    8007fb <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800810:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
  800816:	e9 ed fe ff ff       	jmp    800708 <vprintfmt+0x446>
			putch(ch, putdat);
  80081b:	83 ec 08             	sub    $0x8,%esp
  80081e:	53                   	push   %ebx
  80081f:	6a 25                	push   $0x25
  800821:	ff d6                	call   *%esi
			break;
  800823:	83 c4 10             	add    $0x10,%esp
  800826:	e9 dd fe ff ff       	jmp    800708 <vprintfmt+0x446>
			putch('%', putdat);
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	53                   	push   %ebx
  80082f:	6a 25                	push   $0x25
  800831:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800833:	83 c4 10             	add    $0x10,%esp
  800836:	89 f8                	mov    %edi,%eax
  800838:	eb 03                	jmp    80083d <vprintfmt+0x57b>
  80083a:	83 e8 01             	sub    $0x1,%eax
  80083d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800841:	75 f7                	jne    80083a <vprintfmt+0x578>
  800843:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800846:	e9 bd fe ff ff       	jmp    800708 <vprintfmt+0x446>
}
  80084b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80084e:	5b                   	pop    %ebx
  80084f:	5e                   	pop    %esi
  800850:	5f                   	pop    %edi
  800851:	5d                   	pop    %ebp
  800852:	c3                   	ret    

00800853 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800853:	55                   	push   %ebp
  800854:	89 e5                	mov    %esp,%ebp
  800856:	83 ec 18             	sub    $0x18,%esp
  800859:	8b 45 08             	mov    0x8(%ebp),%eax
  80085c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80085f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800862:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800866:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800869:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800870:	85 c0                	test   %eax,%eax
  800872:	74 26                	je     80089a <vsnprintf+0x47>
  800874:	85 d2                	test   %edx,%edx
  800876:	7e 22                	jle    80089a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800878:	ff 75 14             	pushl  0x14(%ebp)
  80087b:	ff 75 10             	pushl  0x10(%ebp)
  80087e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800881:	50                   	push   %eax
  800882:	68 88 02 80 00       	push   $0x800288
  800887:	e8 36 fa ff ff       	call   8002c2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80088c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80088f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800895:	83 c4 10             	add    $0x10,%esp
}
  800898:	c9                   	leave  
  800899:	c3                   	ret    
		return -E_INVAL;
  80089a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80089f:	eb f7                	jmp    800898 <vsnprintf+0x45>

008008a1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008a1:	55                   	push   %ebp
  8008a2:	89 e5                	mov    %esp,%ebp
  8008a4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008a7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008aa:	50                   	push   %eax
  8008ab:	ff 75 10             	pushl  0x10(%ebp)
  8008ae:	ff 75 0c             	pushl  0xc(%ebp)
  8008b1:	ff 75 08             	pushl  0x8(%ebp)
  8008b4:	e8 9a ff ff ff       	call   800853 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008b9:	c9                   	leave  
  8008ba:	c3                   	ret    

008008bb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c6:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008ca:	74 05                	je     8008d1 <strlen+0x16>
		n++;
  8008cc:	83 c0 01             	add    $0x1,%eax
  8008cf:	eb f5                	jmp    8008c6 <strlen+0xb>
	return n;
}
  8008d1:	5d                   	pop    %ebp
  8008d2:	c3                   	ret    

008008d3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008d3:	55                   	push   %ebp
  8008d4:	89 e5                	mov    %esp,%ebp
  8008d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008d9:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e1:	39 c2                	cmp    %eax,%edx
  8008e3:	74 0d                	je     8008f2 <strnlen+0x1f>
  8008e5:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008e9:	74 05                	je     8008f0 <strnlen+0x1d>
		n++;
  8008eb:	83 c2 01             	add    $0x1,%edx
  8008ee:	eb f1                	jmp    8008e1 <strnlen+0xe>
  8008f0:	89 d0                	mov    %edx,%eax
	return n;
}
  8008f2:	5d                   	pop    %ebp
  8008f3:	c3                   	ret    

008008f4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	53                   	push   %ebx
  8008f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800903:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800907:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80090a:	83 c2 01             	add    $0x1,%edx
  80090d:	84 c9                	test   %cl,%cl
  80090f:	75 f2                	jne    800903 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800911:	5b                   	pop    %ebx
  800912:	5d                   	pop    %ebp
  800913:	c3                   	ret    

00800914 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800914:	55                   	push   %ebp
  800915:	89 e5                	mov    %esp,%ebp
  800917:	53                   	push   %ebx
  800918:	83 ec 10             	sub    $0x10,%esp
  80091b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80091e:	53                   	push   %ebx
  80091f:	e8 97 ff ff ff       	call   8008bb <strlen>
  800924:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800927:	ff 75 0c             	pushl  0xc(%ebp)
  80092a:	01 d8                	add    %ebx,%eax
  80092c:	50                   	push   %eax
  80092d:	e8 c2 ff ff ff       	call   8008f4 <strcpy>
	return dst;
}
  800932:	89 d8                	mov    %ebx,%eax
  800934:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800937:	c9                   	leave  
  800938:	c3                   	ret    

00800939 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	56                   	push   %esi
  80093d:	53                   	push   %ebx
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800944:	89 c6                	mov    %eax,%esi
  800946:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800949:	89 c2                	mov    %eax,%edx
  80094b:	39 f2                	cmp    %esi,%edx
  80094d:	74 11                	je     800960 <strncpy+0x27>
		*dst++ = *src;
  80094f:	83 c2 01             	add    $0x1,%edx
  800952:	0f b6 19             	movzbl (%ecx),%ebx
  800955:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800958:	80 fb 01             	cmp    $0x1,%bl
  80095b:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80095e:	eb eb                	jmp    80094b <strncpy+0x12>
	}
	return ret;
}
  800960:	5b                   	pop    %ebx
  800961:	5e                   	pop    %esi
  800962:	5d                   	pop    %ebp
  800963:	c3                   	ret    

00800964 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	56                   	push   %esi
  800968:	53                   	push   %ebx
  800969:	8b 75 08             	mov    0x8(%ebp),%esi
  80096c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80096f:	8b 55 10             	mov    0x10(%ebp),%edx
  800972:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800974:	85 d2                	test   %edx,%edx
  800976:	74 21                	je     800999 <strlcpy+0x35>
  800978:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80097c:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80097e:	39 c2                	cmp    %eax,%edx
  800980:	74 14                	je     800996 <strlcpy+0x32>
  800982:	0f b6 19             	movzbl (%ecx),%ebx
  800985:	84 db                	test   %bl,%bl
  800987:	74 0b                	je     800994 <strlcpy+0x30>
			*dst++ = *src++;
  800989:	83 c1 01             	add    $0x1,%ecx
  80098c:	83 c2 01             	add    $0x1,%edx
  80098f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800992:	eb ea                	jmp    80097e <strlcpy+0x1a>
  800994:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800996:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800999:	29 f0                	sub    %esi,%eax
}
  80099b:	5b                   	pop    %ebx
  80099c:	5e                   	pop    %esi
  80099d:	5d                   	pop    %ebp
  80099e:	c3                   	ret    

0080099f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80099f:	55                   	push   %ebp
  8009a0:	89 e5                	mov    %esp,%ebp
  8009a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a5:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009a8:	0f b6 01             	movzbl (%ecx),%eax
  8009ab:	84 c0                	test   %al,%al
  8009ad:	74 0c                	je     8009bb <strcmp+0x1c>
  8009af:	3a 02                	cmp    (%edx),%al
  8009b1:	75 08                	jne    8009bb <strcmp+0x1c>
		p++, q++;
  8009b3:	83 c1 01             	add    $0x1,%ecx
  8009b6:	83 c2 01             	add    $0x1,%edx
  8009b9:	eb ed                	jmp    8009a8 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009bb:	0f b6 c0             	movzbl %al,%eax
  8009be:	0f b6 12             	movzbl (%edx),%edx
  8009c1:	29 d0                	sub    %edx,%eax
}
  8009c3:	5d                   	pop    %ebp
  8009c4:	c3                   	ret    

008009c5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009c5:	55                   	push   %ebp
  8009c6:	89 e5                	mov    %esp,%ebp
  8009c8:	53                   	push   %ebx
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009cf:	89 c3                	mov    %eax,%ebx
  8009d1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009d4:	eb 06                	jmp    8009dc <strncmp+0x17>
		n--, p++, q++;
  8009d6:	83 c0 01             	add    $0x1,%eax
  8009d9:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009dc:	39 d8                	cmp    %ebx,%eax
  8009de:	74 16                	je     8009f6 <strncmp+0x31>
  8009e0:	0f b6 08             	movzbl (%eax),%ecx
  8009e3:	84 c9                	test   %cl,%cl
  8009e5:	74 04                	je     8009eb <strncmp+0x26>
  8009e7:	3a 0a                	cmp    (%edx),%cl
  8009e9:	74 eb                	je     8009d6 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009eb:	0f b6 00             	movzbl (%eax),%eax
  8009ee:	0f b6 12             	movzbl (%edx),%edx
  8009f1:	29 d0                	sub    %edx,%eax
}
  8009f3:	5b                   	pop    %ebx
  8009f4:	5d                   	pop    %ebp
  8009f5:	c3                   	ret    
		return 0;
  8009f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009fb:	eb f6                	jmp    8009f3 <strncmp+0x2e>

008009fd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a07:	0f b6 10             	movzbl (%eax),%edx
  800a0a:	84 d2                	test   %dl,%dl
  800a0c:	74 09                	je     800a17 <strchr+0x1a>
		if (*s == c)
  800a0e:	38 ca                	cmp    %cl,%dl
  800a10:	74 0a                	je     800a1c <strchr+0x1f>
	for (; *s; s++)
  800a12:	83 c0 01             	add    $0x1,%eax
  800a15:	eb f0                	jmp    800a07 <strchr+0xa>
			return (char *) s;
	return 0;
  800a17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a1c:	5d                   	pop    %ebp
  800a1d:	c3                   	ret    

00800a1e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a28:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a2b:	38 ca                	cmp    %cl,%dl
  800a2d:	74 09                	je     800a38 <strfind+0x1a>
  800a2f:	84 d2                	test   %dl,%dl
  800a31:	74 05                	je     800a38 <strfind+0x1a>
	for (; *s; s++)
  800a33:	83 c0 01             	add    $0x1,%eax
  800a36:	eb f0                	jmp    800a28 <strfind+0xa>
			break;
	return (char *) s;
}
  800a38:	5d                   	pop    %ebp
  800a39:	c3                   	ret    

00800a3a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	57                   	push   %edi
  800a3e:	56                   	push   %esi
  800a3f:	53                   	push   %ebx
  800a40:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a43:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a46:	85 c9                	test   %ecx,%ecx
  800a48:	74 31                	je     800a7b <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a4a:	89 f8                	mov    %edi,%eax
  800a4c:	09 c8                	or     %ecx,%eax
  800a4e:	a8 03                	test   $0x3,%al
  800a50:	75 23                	jne    800a75 <memset+0x3b>
		c &= 0xFF;
  800a52:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a56:	89 d3                	mov    %edx,%ebx
  800a58:	c1 e3 08             	shl    $0x8,%ebx
  800a5b:	89 d0                	mov    %edx,%eax
  800a5d:	c1 e0 18             	shl    $0x18,%eax
  800a60:	89 d6                	mov    %edx,%esi
  800a62:	c1 e6 10             	shl    $0x10,%esi
  800a65:	09 f0                	or     %esi,%eax
  800a67:	09 c2                	or     %eax,%edx
  800a69:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a6b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a6e:	89 d0                	mov    %edx,%eax
  800a70:	fc                   	cld    
  800a71:	f3 ab                	rep stos %eax,%es:(%edi)
  800a73:	eb 06                	jmp    800a7b <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a78:	fc                   	cld    
  800a79:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a7b:	89 f8                	mov    %edi,%eax
  800a7d:	5b                   	pop    %ebx
  800a7e:	5e                   	pop    %esi
  800a7f:	5f                   	pop    %edi
  800a80:	5d                   	pop    %ebp
  800a81:	c3                   	ret    

00800a82 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a82:	55                   	push   %ebp
  800a83:	89 e5                	mov    %esp,%ebp
  800a85:	57                   	push   %edi
  800a86:	56                   	push   %esi
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a8d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a90:	39 c6                	cmp    %eax,%esi
  800a92:	73 32                	jae    800ac6 <memmove+0x44>
  800a94:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a97:	39 c2                	cmp    %eax,%edx
  800a99:	76 2b                	jbe    800ac6 <memmove+0x44>
		s += n;
		d += n;
  800a9b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a9e:	89 fe                	mov    %edi,%esi
  800aa0:	09 ce                	or     %ecx,%esi
  800aa2:	09 d6                	or     %edx,%esi
  800aa4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aaa:	75 0e                	jne    800aba <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aac:	83 ef 04             	sub    $0x4,%edi
  800aaf:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ab2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ab5:	fd                   	std    
  800ab6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ab8:	eb 09                	jmp    800ac3 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aba:	83 ef 01             	sub    $0x1,%edi
  800abd:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ac0:	fd                   	std    
  800ac1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ac3:	fc                   	cld    
  800ac4:	eb 1a                	jmp    800ae0 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ac6:	89 c2                	mov    %eax,%edx
  800ac8:	09 ca                	or     %ecx,%edx
  800aca:	09 f2                	or     %esi,%edx
  800acc:	f6 c2 03             	test   $0x3,%dl
  800acf:	75 0a                	jne    800adb <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ad1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ad4:	89 c7                	mov    %eax,%edi
  800ad6:	fc                   	cld    
  800ad7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad9:	eb 05                	jmp    800ae0 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800adb:	89 c7                	mov    %eax,%edi
  800add:	fc                   	cld    
  800ade:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ae0:	5e                   	pop    %esi
  800ae1:	5f                   	pop    %edi
  800ae2:	5d                   	pop    %ebp
  800ae3:	c3                   	ret    

00800ae4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ae4:	55                   	push   %ebp
  800ae5:	89 e5                	mov    %esp,%ebp
  800ae7:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800aea:	ff 75 10             	pushl  0x10(%ebp)
  800aed:	ff 75 0c             	pushl  0xc(%ebp)
  800af0:	ff 75 08             	pushl  0x8(%ebp)
  800af3:	e8 8a ff ff ff       	call   800a82 <memmove>
}
  800af8:	c9                   	leave  
  800af9:	c3                   	ret    

00800afa <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	56                   	push   %esi
  800afe:	53                   	push   %ebx
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b05:	89 c6                	mov    %eax,%esi
  800b07:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b0a:	39 f0                	cmp    %esi,%eax
  800b0c:	74 1c                	je     800b2a <memcmp+0x30>
		if (*s1 != *s2)
  800b0e:	0f b6 08             	movzbl (%eax),%ecx
  800b11:	0f b6 1a             	movzbl (%edx),%ebx
  800b14:	38 d9                	cmp    %bl,%cl
  800b16:	75 08                	jne    800b20 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b18:	83 c0 01             	add    $0x1,%eax
  800b1b:	83 c2 01             	add    $0x1,%edx
  800b1e:	eb ea                	jmp    800b0a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b20:	0f b6 c1             	movzbl %cl,%eax
  800b23:	0f b6 db             	movzbl %bl,%ebx
  800b26:	29 d8                	sub    %ebx,%eax
  800b28:	eb 05                	jmp    800b2f <memcmp+0x35>
	}

	return 0;
  800b2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b2f:	5b                   	pop    %ebx
  800b30:	5e                   	pop    %esi
  800b31:	5d                   	pop    %ebp
  800b32:	c3                   	ret    

00800b33 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b33:	55                   	push   %ebp
  800b34:	89 e5                	mov    %esp,%ebp
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b3c:	89 c2                	mov    %eax,%edx
  800b3e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b41:	39 d0                	cmp    %edx,%eax
  800b43:	73 09                	jae    800b4e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b45:	38 08                	cmp    %cl,(%eax)
  800b47:	74 05                	je     800b4e <memfind+0x1b>
	for (; s < ends; s++)
  800b49:	83 c0 01             	add    $0x1,%eax
  800b4c:	eb f3                	jmp    800b41 <memfind+0xe>
			break;
	return (void *) s;
}
  800b4e:	5d                   	pop    %ebp
  800b4f:	c3                   	ret    

00800b50 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	57                   	push   %edi
  800b54:	56                   	push   %esi
  800b55:	53                   	push   %ebx
  800b56:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b59:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b5c:	eb 03                	jmp    800b61 <strtol+0x11>
		s++;
  800b5e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b61:	0f b6 01             	movzbl (%ecx),%eax
  800b64:	3c 20                	cmp    $0x20,%al
  800b66:	74 f6                	je     800b5e <strtol+0xe>
  800b68:	3c 09                	cmp    $0x9,%al
  800b6a:	74 f2                	je     800b5e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b6c:	3c 2b                	cmp    $0x2b,%al
  800b6e:	74 2a                	je     800b9a <strtol+0x4a>
	int neg = 0;
  800b70:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b75:	3c 2d                	cmp    $0x2d,%al
  800b77:	74 2b                	je     800ba4 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b79:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b7f:	75 0f                	jne    800b90 <strtol+0x40>
  800b81:	80 39 30             	cmpb   $0x30,(%ecx)
  800b84:	74 28                	je     800bae <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b86:	85 db                	test   %ebx,%ebx
  800b88:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b8d:	0f 44 d8             	cmove  %eax,%ebx
  800b90:	b8 00 00 00 00       	mov    $0x0,%eax
  800b95:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b98:	eb 50                	jmp    800bea <strtol+0x9a>
		s++;
  800b9a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b9d:	bf 00 00 00 00       	mov    $0x0,%edi
  800ba2:	eb d5                	jmp    800b79 <strtol+0x29>
		s++, neg = 1;
  800ba4:	83 c1 01             	add    $0x1,%ecx
  800ba7:	bf 01 00 00 00       	mov    $0x1,%edi
  800bac:	eb cb                	jmp    800b79 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bae:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bb2:	74 0e                	je     800bc2 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bb4:	85 db                	test   %ebx,%ebx
  800bb6:	75 d8                	jne    800b90 <strtol+0x40>
		s++, base = 8;
  800bb8:	83 c1 01             	add    $0x1,%ecx
  800bbb:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bc0:	eb ce                	jmp    800b90 <strtol+0x40>
		s += 2, base = 16;
  800bc2:	83 c1 02             	add    $0x2,%ecx
  800bc5:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bca:	eb c4                	jmp    800b90 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bcc:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bcf:	89 f3                	mov    %esi,%ebx
  800bd1:	80 fb 19             	cmp    $0x19,%bl
  800bd4:	77 29                	ja     800bff <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bd6:	0f be d2             	movsbl %dl,%edx
  800bd9:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bdc:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bdf:	7d 30                	jge    800c11 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800be1:	83 c1 01             	add    $0x1,%ecx
  800be4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800be8:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bea:	0f b6 11             	movzbl (%ecx),%edx
  800bed:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bf0:	89 f3                	mov    %esi,%ebx
  800bf2:	80 fb 09             	cmp    $0x9,%bl
  800bf5:	77 d5                	ja     800bcc <strtol+0x7c>
			dig = *s - '0';
  800bf7:	0f be d2             	movsbl %dl,%edx
  800bfa:	83 ea 30             	sub    $0x30,%edx
  800bfd:	eb dd                	jmp    800bdc <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bff:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c02:	89 f3                	mov    %esi,%ebx
  800c04:	80 fb 19             	cmp    $0x19,%bl
  800c07:	77 08                	ja     800c11 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c09:	0f be d2             	movsbl %dl,%edx
  800c0c:	83 ea 37             	sub    $0x37,%edx
  800c0f:	eb cb                	jmp    800bdc <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c11:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c15:	74 05                	je     800c1c <strtol+0xcc>
		*endptr = (char *) s;
  800c17:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c1a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c1c:	89 c2                	mov    %eax,%edx
  800c1e:	f7 da                	neg    %edx
  800c20:	85 ff                	test   %edi,%edi
  800c22:	0f 45 c2             	cmovne %edx,%eax
}
  800c25:	5b                   	pop    %ebx
  800c26:	5e                   	pop    %esi
  800c27:	5f                   	pop    %edi
  800c28:	5d                   	pop    %ebp
  800c29:	c3                   	ret    

00800c2a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	57                   	push   %edi
  800c2e:	56                   	push   %esi
  800c2f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c30:	b8 00 00 00 00       	mov    $0x0,%eax
  800c35:	8b 55 08             	mov    0x8(%ebp),%edx
  800c38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3b:	89 c3                	mov    %eax,%ebx
  800c3d:	89 c7                	mov    %eax,%edi
  800c3f:	89 c6                	mov    %eax,%esi
  800c41:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c43:	5b                   	pop    %ebx
  800c44:	5e                   	pop    %esi
  800c45:	5f                   	pop    %edi
  800c46:	5d                   	pop    %ebp
  800c47:	c3                   	ret    

00800c48 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	57                   	push   %edi
  800c4c:	56                   	push   %esi
  800c4d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c53:	b8 01 00 00 00       	mov    $0x1,%eax
  800c58:	89 d1                	mov    %edx,%ecx
  800c5a:	89 d3                	mov    %edx,%ebx
  800c5c:	89 d7                	mov    %edx,%edi
  800c5e:	89 d6                	mov    %edx,%esi
  800c60:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c62:	5b                   	pop    %ebx
  800c63:	5e                   	pop    %esi
  800c64:	5f                   	pop    %edi
  800c65:	5d                   	pop    %ebp
  800c66:	c3                   	ret    

00800c67 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	57                   	push   %edi
  800c6b:	56                   	push   %esi
  800c6c:	53                   	push   %ebx
  800c6d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c70:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c75:	8b 55 08             	mov    0x8(%ebp),%edx
  800c78:	b8 03 00 00 00       	mov    $0x3,%eax
  800c7d:	89 cb                	mov    %ecx,%ebx
  800c7f:	89 cf                	mov    %ecx,%edi
  800c81:	89 ce                	mov    %ecx,%esi
  800c83:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c85:	85 c0                	test   %eax,%eax
  800c87:	7f 08                	jg     800c91 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c8c:	5b                   	pop    %ebx
  800c8d:	5e                   	pop    %esi
  800c8e:	5f                   	pop    %edi
  800c8f:	5d                   	pop    %ebp
  800c90:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c91:	83 ec 0c             	sub    $0xc,%esp
  800c94:	50                   	push   %eax
  800c95:	6a 03                	push   $0x3
  800c97:	68 08 29 80 00       	push   $0x802908
  800c9c:	6a 43                	push   $0x43
  800c9e:	68 25 29 80 00       	push   $0x802925
  800ca3:	e8 89 14 00 00       	call   802131 <_panic>

00800ca8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
  800cab:	57                   	push   %edi
  800cac:	56                   	push   %esi
  800cad:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cae:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb3:	b8 02 00 00 00       	mov    $0x2,%eax
  800cb8:	89 d1                	mov    %edx,%ecx
  800cba:	89 d3                	mov    %edx,%ebx
  800cbc:	89 d7                	mov    %edx,%edi
  800cbe:	89 d6                	mov    %edx,%esi
  800cc0:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cc2:	5b                   	pop    %ebx
  800cc3:	5e                   	pop    %esi
  800cc4:	5f                   	pop    %edi
  800cc5:	5d                   	pop    %ebp
  800cc6:	c3                   	ret    

00800cc7 <sys_yield>:

void
sys_yield(void)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	57                   	push   %edi
  800ccb:	56                   	push   %esi
  800ccc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ccd:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd2:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cd7:	89 d1                	mov    %edx,%ecx
  800cd9:	89 d3                	mov    %edx,%ebx
  800cdb:	89 d7                	mov    %edx,%edi
  800cdd:	89 d6                	mov    %edx,%esi
  800cdf:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ce1:	5b                   	pop    %ebx
  800ce2:	5e                   	pop    %esi
  800ce3:	5f                   	pop    %edi
  800ce4:	5d                   	pop    %ebp
  800ce5:	c3                   	ret    

00800ce6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ce6:	55                   	push   %ebp
  800ce7:	89 e5                	mov    %esp,%ebp
  800ce9:	57                   	push   %edi
  800cea:	56                   	push   %esi
  800ceb:	53                   	push   %ebx
  800cec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cef:	be 00 00 00 00       	mov    $0x0,%esi
  800cf4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfa:	b8 04 00 00 00       	mov    $0x4,%eax
  800cff:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d02:	89 f7                	mov    %esi,%edi
  800d04:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d06:	85 c0                	test   %eax,%eax
  800d08:	7f 08                	jg     800d12 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0d:	5b                   	pop    %ebx
  800d0e:	5e                   	pop    %esi
  800d0f:	5f                   	pop    %edi
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d12:	83 ec 0c             	sub    $0xc,%esp
  800d15:	50                   	push   %eax
  800d16:	6a 04                	push   $0x4
  800d18:	68 08 29 80 00       	push   $0x802908
  800d1d:	6a 43                	push   $0x43
  800d1f:	68 25 29 80 00       	push   $0x802925
  800d24:	e8 08 14 00 00       	call   802131 <_panic>

00800d29 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	57                   	push   %edi
  800d2d:	56                   	push   %esi
  800d2e:	53                   	push   %ebx
  800d2f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d32:	8b 55 08             	mov    0x8(%ebp),%edx
  800d35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d38:	b8 05 00 00 00       	mov    $0x5,%eax
  800d3d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d40:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d43:	8b 75 18             	mov    0x18(%ebp),%esi
  800d46:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d48:	85 c0                	test   %eax,%eax
  800d4a:	7f 08                	jg     800d54 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4f:	5b                   	pop    %ebx
  800d50:	5e                   	pop    %esi
  800d51:	5f                   	pop    %edi
  800d52:	5d                   	pop    %ebp
  800d53:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d54:	83 ec 0c             	sub    $0xc,%esp
  800d57:	50                   	push   %eax
  800d58:	6a 05                	push   $0x5
  800d5a:	68 08 29 80 00       	push   $0x802908
  800d5f:	6a 43                	push   $0x43
  800d61:	68 25 29 80 00       	push   $0x802925
  800d66:	e8 c6 13 00 00       	call   802131 <_panic>

00800d6b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
  800d6e:	57                   	push   %edi
  800d6f:	56                   	push   %esi
  800d70:	53                   	push   %ebx
  800d71:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d74:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d79:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7f:	b8 06 00 00 00       	mov    $0x6,%eax
  800d84:	89 df                	mov    %ebx,%edi
  800d86:	89 de                	mov    %ebx,%esi
  800d88:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8a:	85 c0                	test   %eax,%eax
  800d8c:	7f 08                	jg     800d96 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d91:	5b                   	pop    %ebx
  800d92:	5e                   	pop    %esi
  800d93:	5f                   	pop    %edi
  800d94:	5d                   	pop    %ebp
  800d95:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d96:	83 ec 0c             	sub    $0xc,%esp
  800d99:	50                   	push   %eax
  800d9a:	6a 06                	push   $0x6
  800d9c:	68 08 29 80 00       	push   $0x802908
  800da1:	6a 43                	push   $0x43
  800da3:	68 25 29 80 00       	push   $0x802925
  800da8:	e8 84 13 00 00       	call   802131 <_panic>

00800dad <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	57                   	push   %edi
  800db1:	56                   	push   %esi
  800db2:	53                   	push   %ebx
  800db3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc1:	b8 08 00 00 00       	mov    $0x8,%eax
  800dc6:	89 df                	mov    %ebx,%edi
  800dc8:	89 de                	mov    %ebx,%esi
  800dca:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dcc:	85 c0                	test   %eax,%eax
  800dce:	7f 08                	jg     800dd8 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd3:	5b                   	pop    %ebx
  800dd4:	5e                   	pop    %esi
  800dd5:	5f                   	pop    %edi
  800dd6:	5d                   	pop    %ebp
  800dd7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd8:	83 ec 0c             	sub    $0xc,%esp
  800ddb:	50                   	push   %eax
  800ddc:	6a 08                	push   $0x8
  800dde:	68 08 29 80 00       	push   $0x802908
  800de3:	6a 43                	push   $0x43
  800de5:	68 25 29 80 00       	push   $0x802925
  800dea:	e8 42 13 00 00       	call   802131 <_panic>

00800def <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
  800df2:	57                   	push   %edi
  800df3:	56                   	push   %esi
  800df4:	53                   	push   %ebx
  800df5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfd:	8b 55 08             	mov    0x8(%ebp),%edx
  800e00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e03:	b8 09 00 00 00       	mov    $0x9,%eax
  800e08:	89 df                	mov    %ebx,%edi
  800e0a:	89 de                	mov    %ebx,%esi
  800e0c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0e:	85 c0                	test   %eax,%eax
  800e10:	7f 08                	jg     800e1a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e15:	5b                   	pop    %ebx
  800e16:	5e                   	pop    %esi
  800e17:	5f                   	pop    %edi
  800e18:	5d                   	pop    %ebp
  800e19:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1a:	83 ec 0c             	sub    $0xc,%esp
  800e1d:	50                   	push   %eax
  800e1e:	6a 09                	push   $0x9
  800e20:	68 08 29 80 00       	push   $0x802908
  800e25:	6a 43                	push   $0x43
  800e27:	68 25 29 80 00       	push   $0x802925
  800e2c:	e8 00 13 00 00       	call   802131 <_panic>

00800e31 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
  800e34:	57                   	push   %edi
  800e35:	56                   	push   %esi
  800e36:	53                   	push   %ebx
  800e37:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e45:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e4a:	89 df                	mov    %ebx,%edi
  800e4c:	89 de                	mov    %ebx,%esi
  800e4e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e50:	85 c0                	test   %eax,%eax
  800e52:	7f 08                	jg     800e5c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e57:	5b                   	pop    %ebx
  800e58:	5e                   	pop    %esi
  800e59:	5f                   	pop    %edi
  800e5a:	5d                   	pop    %ebp
  800e5b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5c:	83 ec 0c             	sub    $0xc,%esp
  800e5f:	50                   	push   %eax
  800e60:	6a 0a                	push   $0xa
  800e62:	68 08 29 80 00       	push   $0x802908
  800e67:	6a 43                	push   $0x43
  800e69:	68 25 29 80 00       	push   $0x802925
  800e6e:	e8 be 12 00 00       	call   802131 <_panic>

00800e73 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e73:	55                   	push   %ebp
  800e74:	89 e5                	mov    %esp,%ebp
  800e76:	57                   	push   %edi
  800e77:	56                   	push   %esi
  800e78:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e79:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e84:	be 00 00 00 00       	mov    $0x0,%esi
  800e89:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e8c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e8f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e91:	5b                   	pop    %ebx
  800e92:	5e                   	pop    %esi
  800e93:	5f                   	pop    %edi
  800e94:	5d                   	pop    %ebp
  800e95:	c3                   	ret    

00800e96 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	57                   	push   %edi
  800e9a:	56                   	push   %esi
  800e9b:	53                   	push   %ebx
  800e9c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e9f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ea4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eac:	89 cb                	mov    %ecx,%ebx
  800eae:	89 cf                	mov    %ecx,%edi
  800eb0:	89 ce                	mov    %ecx,%esi
  800eb2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb4:	85 c0                	test   %eax,%eax
  800eb6:	7f 08                	jg     800ec0 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800eb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ebb:	5b                   	pop    %ebx
  800ebc:	5e                   	pop    %esi
  800ebd:	5f                   	pop    %edi
  800ebe:	5d                   	pop    %ebp
  800ebf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec0:	83 ec 0c             	sub    $0xc,%esp
  800ec3:	50                   	push   %eax
  800ec4:	6a 0d                	push   $0xd
  800ec6:	68 08 29 80 00       	push   $0x802908
  800ecb:	6a 43                	push   $0x43
  800ecd:	68 25 29 80 00       	push   $0x802925
  800ed2:	e8 5a 12 00 00       	call   802131 <_panic>

00800ed7 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800ed7:	55                   	push   %ebp
  800ed8:	89 e5                	mov    %esp,%ebp
  800eda:	57                   	push   %edi
  800edb:	56                   	push   %esi
  800edc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800edd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee8:	b8 0e 00 00 00       	mov    $0xe,%eax
  800eed:	89 df                	mov    %ebx,%edi
  800eef:	89 de                	mov    %ebx,%esi
  800ef1:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ef3:	5b                   	pop    %ebx
  800ef4:	5e                   	pop    %esi
  800ef5:	5f                   	pop    %edi
  800ef6:	5d                   	pop    %ebp
  800ef7:	c3                   	ret    

00800ef8 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	57                   	push   %edi
  800efc:	56                   	push   %esi
  800efd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800efe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f03:	8b 55 08             	mov    0x8(%ebp),%edx
  800f06:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f0b:	89 cb                	mov    %ecx,%ebx
  800f0d:	89 cf                	mov    %ecx,%edi
  800f0f:	89 ce                	mov    %ecx,%esi
  800f11:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f13:	5b                   	pop    %ebx
  800f14:	5e                   	pop    %esi
  800f15:	5f                   	pop    %edi
  800f16:	5d                   	pop    %ebp
  800f17:	c3                   	ret    

00800f18 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	57                   	push   %edi
  800f1c:	56                   	push   %esi
  800f1d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f1e:	ba 00 00 00 00       	mov    $0x0,%edx
  800f23:	b8 10 00 00 00       	mov    $0x10,%eax
  800f28:	89 d1                	mov    %edx,%ecx
  800f2a:	89 d3                	mov    %edx,%ebx
  800f2c:	89 d7                	mov    %edx,%edi
  800f2e:	89 d6                	mov    %edx,%esi
  800f30:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f32:	5b                   	pop    %ebx
  800f33:	5e                   	pop    %esi
  800f34:	5f                   	pop    %edi
  800f35:	5d                   	pop    %ebp
  800f36:	c3                   	ret    

00800f37 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	57                   	push   %edi
  800f3b:	56                   	push   %esi
  800f3c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f42:	8b 55 08             	mov    0x8(%ebp),%edx
  800f45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f48:	b8 11 00 00 00       	mov    $0x11,%eax
  800f4d:	89 df                	mov    %ebx,%edi
  800f4f:	89 de                	mov    %ebx,%esi
  800f51:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f53:	5b                   	pop    %ebx
  800f54:	5e                   	pop    %esi
  800f55:	5f                   	pop    %edi
  800f56:	5d                   	pop    %ebp
  800f57:	c3                   	ret    

00800f58 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f58:	55                   	push   %ebp
  800f59:	89 e5                	mov    %esp,%ebp
  800f5b:	57                   	push   %edi
  800f5c:	56                   	push   %esi
  800f5d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f5e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f63:	8b 55 08             	mov    0x8(%ebp),%edx
  800f66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f69:	b8 12 00 00 00       	mov    $0x12,%eax
  800f6e:	89 df                	mov    %ebx,%edi
  800f70:	89 de                	mov    %ebx,%esi
  800f72:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f74:	5b                   	pop    %ebx
  800f75:	5e                   	pop    %esi
  800f76:	5f                   	pop    %edi
  800f77:	5d                   	pop    %ebp
  800f78:	c3                   	ret    

00800f79 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	57                   	push   %edi
  800f7d:	56                   	push   %esi
  800f7e:	53                   	push   %ebx
  800f7f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f82:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f87:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8d:	b8 13 00 00 00       	mov    $0x13,%eax
  800f92:	89 df                	mov    %ebx,%edi
  800f94:	89 de                	mov    %ebx,%esi
  800f96:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f98:	85 c0                	test   %eax,%eax
  800f9a:	7f 08                	jg     800fa4 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f9f:	5b                   	pop    %ebx
  800fa0:	5e                   	pop    %esi
  800fa1:	5f                   	pop    %edi
  800fa2:	5d                   	pop    %ebp
  800fa3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa4:	83 ec 0c             	sub    $0xc,%esp
  800fa7:	50                   	push   %eax
  800fa8:	6a 13                	push   $0x13
  800faa:	68 08 29 80 00       	push   $0x802908
  800faf:	6a 43                	push   $0x43
  800fb1:	68 25 29 80 00       	push   $0x802925
  800fb6:	e8 76 11 00 00       	call   802131 <_panic>

00800fbb <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  800fbb:	55                   	push   %ebp
  800fbc:	89 e5                	mov    %esp,%ebp
  800fbe:	57                   	push   %edi
  800fbf:	56                   	push   %esi
  800fc0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc9:	b8 14 00 00 00       	mov    $0x14,%eax
  800fce:	89 cb                	mov    %ecx,%ebx
  800fd0:	89 cf                	mov    %ecx,%edi
  800fd2:	89 ce                	mov    %ecx,%esi
  800fd4:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  800fd6:	5b                   	pop    %ebx
  800fd7:	5e                   	pop    %esi
  800fd8:	5f                   	pop    %edi
  800fd9:	5d                   	pop    %ebp
  800fda:	c3                   	ret    

00800fdb <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fdb:	55                   	push   %ebp
  800fdc:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	05 00 00 00 30       	add    $0x30000000,%eax
  800fe6:	c1 e8 0c             	shr    $0xc,%eax
}
  800fe9:	5d                   	pop    %ebp
  800fea:	c3                   	ret    

00800feb <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800ff6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ffb:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801000:	5d                   	pop    %ebp
  801001:	c3                   	ret    

00801002 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801002:	55                   	push   %ebp
  801003:	89 e5                	mov    %esp,%ebp
  801005:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80100a:	89 c2                	mov    %eax,%edx
  80100c:	c1 ea 16             	shr    $0x16,%edx
  80100f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801016:	f6 c2 01             	test   $0x1,%dl
  801019:	74 2d                	je     801048 <fd_alloc+0x46>
  80101b:	89 c2                	mov    %eax,%edx
  80101d:	c1 ea 0c             	shr    $0xc,%edx
  801020:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801027:	f6 c2 01             	test   $0x1,%dl
  80102a:	74 1c                	je     801048 <fd_alloc+0x46>
  80102c:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801031:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801036:	75 d2                	jne    80100a <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801041:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801046:	eb 0a                	jmp    801052 <fd_alloc+0x50>
			*fd_store = fd;
  801048:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80104b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80104d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801052:	5d                   	pop    %ebp
  801053:	c3                   	ret    

00801054 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80105a:	83 f8 1f             	cmp    $0x1f,%eax
  80105d:	77 30                	ja     80108f <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80105f:	c1 e0 0c             	shl    $0xc,%eax
  801062:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801067:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80106d:	f6 c2 01             	test   $0x1,%dl
  801070:	74 24                	je     801096 <fd_lookup+0x42>
  801072:	89 c2                	mov    %eax,%edx
  801074:	c1 ea 0c             	shr    $0xc,%edx
  801077:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80107e:	f6 c2 01             	test   $0x1,%dl
  801081:	74 1a                	je     80109d <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801083:	8b 55 0c             	mov    0xc(%ebp),%edx
  801086:	89 02                	mov    %eax,(%edx)
	return 0;
  801088:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80108d:	5d                   	pop    %ebp
  80108e:	c3                   	ret    
		return -E_INVAL;
  80108f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801094:	eb f7                	jmp    80108d <fd_lookup+0x39>
		return -E_INVAL;
  801096:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80109b:	eb f0                	jmp    80108d <fd_lookup+0x39>
  80109d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010a2:	eb e9                	jmp    80108d <fd_lookup+0x39>

008010a4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010a4:	55                   	push   %ebp
  8010a5:	89 e5                	mov    %esp,%ebp
  8010a7:	83 ec 08             	sub    $0x8,%esp
  8010aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8010b2:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010b7:	39 08                	cmp    %ecx,(%eax)
  8010b9:	74 38                	je     8010f3 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8010bb:	83 c2 01             	add    $0x1,%edx
  8010be:	8b 04 95 b0 29 80 00 	mov    0x8029b0(,%edx,4),%eax
  8010c5:	85 c0                	test   %eax,%eax
  8010c7:	75 ee                	jne    8010b7 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010c9:	a1 08 40 80 00       	mov    0x804008,%eax
  8010ce:	8b 40 48             	mov    0x48(%eax),%eax
  8010d1:	83 ec 04             	sub    $0x4,%esp
  8010d4:	51                   	push   %ecx
  8010d5:	50                   	push   %eax
  8010d6:	68 34 29 80 00       	push   $0x802934
  8010db:	e8 b5 f0 ff ff       	call   800195 <cprintf>
	*dev = 0;
  8010e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010e9:	83 c4 10             	add    $0x10,%esp
  8010ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010f1:	c9                   	leave  
  8010f2:	c3                   	ret    
			*dev = devtab[i];
  8010f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fd:	eb f2                	jmp    8010f1 <dev_lookup+0x4d>

008010ff <fd_close>:
{
  8010ff:	55                   	push   %ebp
  801100:	89 e5                	mov    %esp,%ebp
  801102:	57                   	push   %edi
  801103:	56                   	push   %esi
  801104:	53                   	push   %ebx
  801105:	83 ec 24             	sub    $0x24,%esp
  801108:	8b 75 08             	mov    0x8(%ebp),%esi
  80110b:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80110e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801111:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801112:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801118:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80111b:	50                   	push   %eax
  80111c:	e8 33 ff ff ff       	call   801054 <fd_lookup>
  801121:	89 c3                	mov    %eax,%ebx
  801123:	83 c4 10             	add    $0x10,%esp
  801126:	85 c0                	test   %eax,%eax
  801128:	78 05                	js     80112f <fd_close+0x30>
	    || fd != fd2)
  80112a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80112d:	74 16                	je     801145 <fd_close+0x46>
		return (must_exist ? r : 0);
  80112f:	89 f8                	mov    %edi,%eax
  801131:	84 c0                	test   %al,%al
  801133:	b8 00 00 00 00       	mov    $0x0,%eax
  801138:	0f 44 d8             	cmove  %eax,%ebx
}
  80113b:	89 d8                	mov    %ebx,%eax
  80113d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801140:	5b                   	pop    %ebx
  801141:	5e                   	pop    %esi
  801142:	5f                   	pop    %edi
  801143:	5d                   	pop    %ebp
  801144:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801145:	83 ec 08             	sub    $0x8,%esp
  801148:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80114b:	50                   	push   %eax
  80114c:	ff 36                	pushl  (%esi)
  80114e:	e8 51 ff ff ff       	call   8010a4 <dev_lookup>
  801153:	89 c3                	mov    %eax,%ebx
  801155:	83 c4 10             	add    $0x10,%esp
  801158:	85 c0                	test   %eax,%eax
  80115a:	78 1a                	js     801176 <fd_close+0x77>
		if (dev->dev_close)
  80115c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80115f:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801162:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801167:	85 c0                	test   %eax,%eax
  801169:	74 0b                	je     801176 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80116b:	83 ec 0c             	sub    $0xc,%esp
  80116e:	56                   	push   %esi
  80116f:	ff d0                	call   *%eax
  801171:	89 c3                	mov    %eax,%ebx
  801173:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801176:	83 ec 08             	sub    $0x8,%esp
  801179:	56                   	push   %esi
  80117a:	6a 00                	push   $0x0
  80117c:	e8 ea fb ff ff       	call   800d6b <sys_page_unmap>
	return r;
  801181:	83 c4 10             	add    $0x10,%esp
  801184:	eb b5                	jmp    80113b <fd_close+0x3c>

00801186 <close>:

int
close(int fdnum)
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
  801189:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80118c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80118f:	50                   	push   %eax
  801190:	ff 75 08             	pushl  0x8(%ebp)
  801193:	e8 bc fe ff ff       	call   801054 <fd_lookup>
  801198:	83 c4 10             	add    $0x10,%esp
  80119b:	85 c0                	test   %eax,%eax
  80119d:	79 02                	jns    8011a1 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80119f:	c9                   	leave  
  8011a0:	c3                   	ret    
		return fd_close(fd, 1);
  8011a1:	83 ec 08             	sub    $0x8,%esp
  8011a4:	6a 01                	push   $0x1
  8011a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8011a9:	e8 51 ff ff ff       	call   8010ff <fd_close>
  8011ae:	83 c4 10             	add    $0x10,%esp
  8011b1:	eb ec                	jmp    80119f <close+0x19>

008011b3 <close_all>:

void
close_all(void)
{
  8011b3:	55                   	push   %ebp
  8011b4:	89 e5                	mov    %esp,%ebp
  8011b6:	53                   	push   %ebx
  8011b7:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011ba:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011bf:	83 ec 0c             	sub    $0xc,%esp
  8011c2:	53                   	push   %ebx
  8011c3:	e8 be ff ff ff       	call   801186 <close>
	for (i = 0; i < MAXFD; i++)
  8011c8:	83 c3 01             	add    $0x1,%ebx
  8011cb:	83 c4 10             	add    $0x10,%esp
  8011ce:	83 fb 20             	cmp    $0x20,%ebx
  8011d1:	75 ec                	jne    8011bf <close_all+0xc>
}
  8011d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011d6:	c9                   	leave  
  8011d7:	c3                   	ret    

008011d8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
  8011db:	57                   	push   %edi
  8011dc:	56                   	push   %esi
  8011dd:	53                   	push   %ebx
  8011de:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011e1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011e4:	50                   	push   %eax
  8011e5:	ff 75 08             	pushl  0x8(%ebp)
  8011e8:	e8 67 fe ff ff       	call   801054 <fd_lookup>
  8011ed:	89 c3                	mov    %eax,%ebx
  8011ef:	83 c4 10             	add    $0x10,%esp
  8011f2:	85 c0                	test   %eax,%eax
  8011f4:	0f 88 81 00 00 00    	js     80127b <dup+0xa3>
		return r;
	close(newfdnum);
  8011fa:	83 ec 0c             	sub    $0xc,%esp
  8011fd:	ff 75 0c             	pushl  0xc(%ebp)
  801200:	e8 81 ff ff ff       	call   801186 <close>

	newfd = INDEX2FD(newfdnum);
  801205:	8b 75 0c             	mov    0xc(%ebp),%esi
  801208:	c1 e6 0c             	shl    $0xc,%esi
  80120b:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801211:	83 c4 04             	add    $0x4,%esp
  801214:	ff 75 e4             	pushl  -0x1c(%ebp)
  801217:	e8 cf fd ff ff       	call   800feb <fd2data>
  80121c:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80121e:	89 34 24             	mov    %esi,(%esp)
  801221:	e8 c5 fd ff ff       	call   800feb <fd2data>
  801226:	83 c4 10             	add    $0x10,%esp
  801229:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80122b:	89 d8                	mov    %ebx,%eax
  80122d:	c1 e8 16             	shr    $0x16,%eax
  801230:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801237:	a8 01                	test   $0x1,%al
  801239:	74 11                	je     80124c <dup+0x74>
  80123b:	89 d8                	mov    %ebx,%eax
  80123d:	c1 e8 0c             	shr    $0xc,%eax
  801240:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801247:	f6 c2 01             	test   $0x1,%dl
  80124a:	75 39                	jne    801285 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80124c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80124f:	89 d0                	mov    %edx,%eax
  801251:	c1 e8 0c             	shr    $0xc,%eax
  801254:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80125b:	83 ec 0c             	sub    $0xc,%esp
  80125e:	25 07 0e 00 00       	and    $0xe07,%eax
  801263:	50                   	push   %eax
  801264:	56                   	push   %esi
  801265:	6a 00                	push   $0x0
  801267:	52                   	push   %edx
  801268:	6a 00                	push   $0x0
  80126a:	e8 ba fa ff ff       	call   800d29 <sys_page_map>
  80126f:	89 c3                	mov    %eax,%ebx
  801271:	83 c4 20             	add    $0x20,%esp
  801274:	85 c0                	test   %eax,%eax
  801276:	78 31                	js     8012a9 <dup+0xd1>
		goto err;

	return newfdnum;
  801278:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80127b:	89 d8                	mov    %ebx,%eax
  80127d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801280:	5b                   	pop    %ebx
  801281:	5e                   	pop    %esi
  801282:	5f                   	pop    %edi
  801283:	5d                   	pop    %ebp
  801284:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801285:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80128c:	83 ec 0c             	sub    $0xc,%esp
  80128f:	25 07 0e 00 00       	and    $0xe07,%eax
  801294:	50                   	push   %eax
  801295:	57                   	push   %edi
  801296:	6a 00                	push   $0x0
  801298:	53                   	push   %ebx
  801299:	6a 00                	push   $0x0
  80129b:	e8 89 fa ff ff       	call   800d29 <sys_page_map>
  8012a0:	89 c3                	mov    %eax,%ebx
  8012a2:	83 c4 20             	add    $0x20,%esp
  8012a5:	85 c0                	test   %eax,%eax
  8012a7:	79 a3                	jns    80124c <dup+0x74>
	sys_page_unmap(0, newfd);
  8012a9:	83 ec 08             	sub    $0x8,%esp
  8012ac:	56                   	push   %esi
  8012ad:	6a 00                	push   $0x0
  8012af:	e8 b7 fa ff ff       	call   800d6b <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012b4:	83 c4 08             	add    $0x8,%esp
  8012b7:	57                   	push   %edi
  8012b8:	6a 00                	push   $0x0
  8012ba:	e8 ac fa ff ff       	call   800d6b <sys_page_unmap>
	return r;
  8012bf:	83 c4 10             	add    $0x10,%esp
  8012c2:	eb b7                	jmp    80127b <dup+0xa3>

008012c4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012c4:	55                   	push   %ebp
  8012c5:	89 e5                	mov    %esp,%ebp
  8012c7:	53                   	push   %ebx
  8012c8:	83 ec 1c             	sub    $0x1c,%esp
  8012cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012ce:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012d1:	50                   	push   %eax
  8012d2:	53                   	push   %ebx
  8012d3:	e8 7c fd ff ff       	call   801054 <fd_lookup>
  8012d8:	83 c4 10             	add    $0x10,%esp
  8012db:	85 c0                	test   %eax,%eax
  8012dd:	78 3f                	js     80131e <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012df:	83 ec 08             	sub    $0x8,%esp
  8012e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e5:	50                   	push   %eax
  8012e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e9:	ff 30                	pushl  (%eax)
  8012eb:	e8 b4 fd ff ff       	call   8010a4 <dev_lookup>
  8012f0:	83 c4 10             	add    $0x10,%esp
  8012f3:	85 c0                	test   %eax,%eax
  8012f5:	78 27                	js     80131e <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012fa:	8b 42 08             	mov    0x8(%edx),%eax
  8012fd:	83 e0 03             	and    $0x3,%eax
  801300:	83 f8 01             	cmp    $0x1,%eax
  801303:	74 1e                	je     801323 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801308:	8b 40 08             	mov    0x8(%eax),%eax
  80130b:	85 c0                	test   %eax,%eax
  80130d:	74 35                	je     801344 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80130f:	83 ec 04             	sub    $0x4,%esp
  801312:	ff 75 10             	pushl  0x10(%ebp)
  801315:	ff 75 0c             	pushl  0xc(%ebp)
  801318:	52                   	push   %edx
  801319:	ff d0                	call   *%eax
  80131b:	83 c4 10             	add    $0x10,%esp
}
  80131e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801321:	c9                   	leave  
  801322:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801323:	a1 08 40 80 00       	mov    0x804008,%eax
  801328:	8b 40 48             	mov    0x48(%eax),%eax
  80132b:	83 ec 04             	sub    $0x4,%esp
  80132e:	53                   	push   %ebx
  80132f:	50                   	push   %eax
  801330:	68 75 29 80 00       	push   $0x802975
  801335:	e8 5b ee ff ff       	call   800195 <cprintf>
		return -E_INVAL;
  80133a:	83 c4 10             	add    $0x10,%esp
  80133d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801342:	eb da                	jmp    80131e <read+0x5a>
		return -E_NOT_SUPP;
  801344:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801349:	eb d3                	jmp    80131e <read+0x5a>

0080134b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
  80134e:	57                   	push   %edi
  80134f:	56                   	push   %esi
  801350:	53                   	push   %ebx
  801351:	83 ec 0c             	sub    $0xc,%esp
  801354:	8b 7d 08             	mov    0x8(%ebp),%edi
  801357:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80135a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80135f:	39 f3                	cmp    %esi,%ebx
  801361:	73 23                	jae    801386 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801363:	83 ec 04             	sub    $0x4,%esp
  801366:	89 f0                	mov    %esi,%eax
  801368:	29 d8                	sub    %ebx,%eax
  80136a:	50                   	push   %eax
  80136b:	89 d8                	mov    %ebx,%eax
  80136d:	03 45 0c             	add    0xc(%ebp),%eax
  801370:	50                   	push   %eax
  801371:	57                   	push   %edi
  801372:	e8 4d ff ff ff       	call   8012c4 <read>
		if (m < 0)
  801377:	83 c4 10             	add    $0x10,%esp
  80137a:	85 c0                	test   %eax,%eax
  80137c:	78 06                	js     801384 <readn+0x39>
			return m;
		if (m == 0)
  80137e:	74 06                	je     801386 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801380:	01 c3                	add    %eax,%ebx
  801382:	eb db                	jmp    80135f <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801384:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801386:	89 d8                	mov    %ebx,%eax
  801388:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80138b:	5b                   	pop    %ebx
  80138c:	5e                   	pop    %esi
  80138d:	5f                   	pop    %edi
  80138e:	5d                   	pop    %ebp
  80138f:	c3                   	ret    

00801390 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
  801393:	53                   	push   %ebx
  801394:	83 ec 1c             	sub    $0x1c,%esp
  801397:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80139a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80139d:	50                   	push   %eax
  80139e:	53                   	push   %ebx
  80139f:	e8 b0 fc ff ff       	call   801054 <fd_lookup>
  8013a4:	83 c4 10             	add    $0x10,%esp
  8013a7:	85 c0                	test   %eax,%eax
  8013a9:	78 3a                	js     8013e5 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013ab:	83 ec 08             	sub    $0x8,%esp
  8013ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013b1:	50                   	push   %eax
  8013b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b5:	ff 30                	pushl  (%eax)
  8013b7:	e8 e8 fc ff ff       	call   8010a4 <dev_lookup>
  8013bc:	83 c4 10             	add    $0x10,%esp
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	78 22                	js     8013e5 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013ca:	74 1e                	je     8013ea <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013cf:	8b 52 0c             	mov    0xc(%edx),%edx
  8013d2:	85 d2                	test   %edx,%edx
  8013d4:	74 35                	je     80140b <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013d6:	83 ec 04             	sub    $0x4,%esp
  8013d9:	ff 75 10             	pushl  0x10(%ebp)
  8013dc:	ff 75 0c             	pushl  0xc(%ebp)
  8013df:	50                   	push   %eax
  8013e0:	ff d2                	call   *%edx
  8013e2:	83 c4 10             	add    $0x10,%esp
}
  8013e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013e8:	c9                   	leave  
  8013e9:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013ea:	a1 08 40 80 00       	mov    0x804008,%eax
  8013ef:	8b 40 48             	mov    0x48(%eax),%eax
  8013f2:	83 ec 04             	sub    $0x4,%esp
  8013f5:	53                   	push   %ebx
  8013f6:	50                   	push   %eax
  8013f7:	68 91 29 80 00       	push   $0x802991
  8013fc:	e8 94 ed ff ff       	call   800195 <cprintf>
		return -E_INVAL;
  801401:	83 c4 10             	add    $0x10,%esp
  801404:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801409:	eb da                	jmp    8013e5 <write+0x55>
		return -E_NOT_SUPP;
  80140b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801410:	eb d3                	jmp    8013e5 <write+0x55>

00801412 <seek>:

int
seek(int fdnum, off_t offset)
{
  801412:	55                   	push   %ebp
  801413:	89 e5                	mov    %esp,%ebp
  801415:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801418:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80141b:	50                   	push   %eax
  80141c:	ff 75 08             	pushl  0x8(%ebp)
  80141f:	e8 30 fc ff ff       	call   801054 <fd_lookup>
  801424:	83 c4 10             	add    $0x10,%esp
  801427:	85 c0                	test   %eax,%eax
  801429:	78 0e                	js     801439 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80142b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80142e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801431:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801434:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801439:	c9                   	leave  
  80143a:	c3                   	ret    

0080143b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80143b:	55                   	push   %ebp
  80143c:	89 e5                	mov    %esp,%ebp
  80143e:	53                   	push   %ebx
  80143f:	83 ec 1c             	sub    $0x1c,%esp
  801442:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801445:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801448:	50                   	push   %eax
  801449:	53                   	push   %ebx
  80144a:	e8 05 fc ff ff       	call   801054 <fd_lookup>
  80144f:	83 c4 10             	add    $0x10,%esp
  801452:	85 c0                	test   %eax,%eax
  801454:	78 37                	js     80148d <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801456:	83 ec 08             	sub    $0x8,%esp
  801459:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80145c:	50                   	push   %eax
  80145d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801460:	ff 30                	pushl  (%eax)
  801462:	e8 3d fc ff ff       	call   8010a4 <dev_lookup>
  801467:	83 c4 10             	add    $0x10,%esp
  80146a:	85 c0                	test   %eax,%eax
  80146c:	78 1f                	js     80148d <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80146e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801471:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801475:	74 1b                	je     801492 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801477:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80147a:	8b 52 18             	mov    0x18(%edx),%edx
  80147d:	85 d2                	test   %edx,%edx
  80147f:	74 32                	je     8014b3 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801481:	83 ec 08             	sub    $0x8,%esp
  801484:	ff 75 0c             	pushl  0xc(%ebp)
  801487:	50                   	push   %eax
  801488:	ff d2                	call   *%edx
  80148a:	83 c4 10             	add    $0x10,%esp
}
  80148d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801490:	c9                   	leave  
  801491:	c3                   	ret    
			thisenv->env_id, fdnum);
  801492:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801497:	8b 40 48             	mov    0x48(%eax),%eax
  80149a:	83 ec 04             	sub    $0x4,%esp
  80149d:	53                   	push   %ebx
  80149e:	50                   	push   %eax
  80149f:	68 54 29 80 00       	push   $0x802954
  8014a4:	e8 ec ec ff ff       	call   800195 <cprintf>
		return -E_INVAL;
  8014a9:	83 c4 10             	add    $0x10,%esp
  8014ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014b1:	eb da                	jmp    80148d <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014b3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014b8:	eb d3                	jmp    80148d <ftruncate+0x52>

008014ba <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
  8014bd:	53                   	push   %ebx
  8014be:	83 ec 1c             	sub    $0x1c,%esp
  8014c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014c7:	50                   	push   %eax
  8014c8:	ff 75 08             	pushl  0x8(%ebp)
  8014cb:	e8 84 fb ff ff       	call   801054 <fd_lookup>
  8014d0:	83 c4 10             	add    $0x10,%esp
  8014d3:	85 c0                	test   %eax,%eax
  8014d5:	78 4b                	js     801522 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014d7:	83 ec 08             	sub    $0x8,%esp
  8014da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014dd:	50                   	push   %eax
  8014de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e1:	ff 30                	pushl  (%eax)
  8014e3:	e8 bc fb ff ff       	call   8010a4 <dev_lookup>
  8014e8:	83 c4 10             	add    $0x10,%esp
  8014eb:	85 c0                	test   %eax,%eax
  8014ed:	78 33                	js     801522 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f2:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014f6:	74 2f                	je     801527 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014f8:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014fb:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801502:	00 00 00 
	stat->st_isdir = 0;
  801505:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80150c:	00 00 00 
	stat->st_dev = dev;
  80150f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801515:	83 ec 08             	sub    $0x8,%esp
  801518:	53                   	push   %ebx
  801519:	ff 75 f0             	pushl  -0x10(%ebp)
  80151c:	ff 50 14             	call   *0x14(%eax)
  80151f:	83 c4 10             	add    $0x10,%esp
}
  801522:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801525:	c9                   	leave  
  801526:	c3                   	ret    
		return -E_NOT_SUPP;
  801527:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80152c:	eb f4                	jmp    801522 <fstat+0x68>

0080152e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	56                   	push   %esi
  801532:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801533:	83 ec 08             	sub    $0x8,%esp
  801536:	6a 00                	push   $0x0
  801538:	ff 75 08             	pushl  0x8(%ebp)
  80153b:	e8 22 02 00 00       	call   801762 <open>
  801540:	89 c3                	mov    %eax,%ebx
  801542:	83 c4 10             	add    $0x10,%esp
  801545:	85 c0                	test   %eax,%eax
  801547:	78 1b                	js     801564 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801549:	83 ec 08             	sub    $0x8,%esp
  80154c:	ff 75 0c             	pushl  0xc(%ebp)
  80154f:	50                   	push   %eax
  801550:	e8 65 ff ff ff       	call   8014ba <fstat>
  801555:	89 c6                	mov    %eax,%esi
	close(fd);
  801557:	89 1c 24             	mov    %ebx,(%esp)
  80155a:	e8 27 fc ff ff       	call   801186 <close>
	return r;
  80155f:	83 c4 10             	add    $0x10,%esp
  801562:	89 f3                	mov    %esi,%ebx
}
  801564:	89 d8                	mov    %ebx,%eax
  801566:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801569:	5b                   	pop    %ebx
  80156a:	5e                   	pop    %esi
  80156b:	5d                   	pop    %ebp
  80156c:	c3                   	ret    

0080156d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80156d:	55                   	push   %ebp
  80156e:	89 e5                	mov    %esp,%ebp
  801570:	56                   	push   %esi
  801571:	53                   	push   %ebx
  801572:	89 c6                	mov    %eax,%esi
  801574:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801576:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80157d:	74 27                	je     8015a6 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80157f:	6a 07                	push   $0x7
  801581:	68 00 50 80 00       	push   $0x805000
  801586:	56                   	push   %esi
  801587:	ff 35 00 40 80 00    	pushl  0x804000
  80158d:	e8 69 0c 00 00       	call   8021fb <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801592:	83 c4 0c             	add    $0xc,%esp
  801595:	6a 00                	push   $0x0
  801597:	53                   	push   %ebx
  801598:	6a 00                	push   $0x0
  80159a:	e8 f3 0b 00 00       	call   802192 <ipc_recv>
}
  80159f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015a2:	5b                   	pop    %ebx
  8015a3:	5e                   	pop    %esi
  8015a4:	5d                   	pop    %ebp
  8015a5:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015a6:	83 ec 0c             	sub    $0xc,%esp
  8015a9:	6a 01                	push   $0x1
  8015ab:	e8 a3 0c 00 00       	call   802253 <ipc_find_env>
  8015b0:	a3 00 40 80 00       	mov    %eax,0x804000
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	eb c5                	jmp    80157f <fsipc+0x12>

008015ba <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
  8015bd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8015c6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ce:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d8:	b8 02 00 00 00       	mov    $0x2,%eax
  8015dd:	e8 8b ff ff ff       	call   80156d <fsipc>
}
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <devfile_flush>:
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8015f0:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015fa:	b8 06 00 00 00       	mov    $0x6,%eax
  8015ff:	e8 69 ff ff ff       	call   80156d <fsipc>
}
  801604:	c9                   	leave  
  801605:	c3                   	ret    

00801606 <devfile_stat>:
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
  801609:	53                   	push   %ebx
  80160a:	83 ec 04             	sub    $0x4,%esp
  80160d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	8b 40 0c             	mov    0xc(%eax),%eax
  801616:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80161b:	ba 00 00 00 00       	mov    $0x0,%edx
  801620:	b8 05 00 00 00       	mov    $0x5,%eax
  801625:	e8 43 ff ff ff       	call   80156d <fsipc>
  80162a:	85 c0                	test   %eax,%eax
  80162c:	78 2c                	js     80165a <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80162e:	83 ec 08             	sub    $0x8,%esp
  801631:	68 00 50 80 00       	push   $0x805000
  801636:	53                   	push   %ebx
  801637:	e8 b8 f2 ff ff       	call   8008f4 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80163c:	a1 80 50 80 00       	mov    0x805080,%eax
  801641:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801647:	a1 84 50 80 00       	mov    0x805084,%eax
  80164c:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801652:	83 c4 10             	add    $0x10,%esp
  801655:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80165a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    

0080165f <devfile_write>:
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
  801662:	53                   	push   %ebx
  801663:	83 ec 08             	sub    $0x8,%esp
  801666:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801669:	8b 45 08             	mov    0x8(%ebp),%eax
  80166c:	8b 40 0c             	mov    0xc(%eax),%eax
  80166f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801674:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80167a:	53                   	push   %ebx
  80167b:	ff 75 0c             	pushl  0xc(%ebp)
  80167e:	68 08 50 80 00       	push   $0x805008
  801683:	e8 5c f4 ff ff       	call   800ae4 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801688:	ba 00 00 00 00       	mov    $0x0,%edx
  80168d:	b8 04 00 00 00       	mov    $0x4,%eax
  801692:	e8 d6 fe ff ff       	call   80156d <fsipc>
  801697:	83 c4 10             	add    $0x10,%esp
  80169a:	85 c0                	test   %eax,%eax
  80169c:	78 0b                	js     8016a9 <devfile_write+0x4a>
	assert(r <= n);
  80169e:	39 d8                	cmp    %ebx,%eax
  8016a0:	77 0c                	ja     8016ae <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016a2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016a7:	7f 1e                	jg     8016c7 <devfile_write+0x68>
}
  8016a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ac:	c9                   	leave  
  8016ad:	c3                   	ret    
	assert(r <= n);
  8016ae:	68 c4 29 80 00       	push   $0x8029c4
  8016b3:	68 cb 29 80 00       	push   $0x8029cb
  8016b8:	68 98 00 00 00       	push   $0x98
  8016bd:	68 e0 29 80 00       	push   $0x8029e0
  8016c2:	e8 6a 0a 00 00       	call   802131 <_panic>
	assert(r <= PGSIZE);
  8016c7:	68 eb 29 80 00       	push   $0x8029eb
  8016cc:	68 cb 29 80 00       	push   $0x8029cb
  8016d1:	68 99 00 00 00       	push   $0x99
  8016d6:	68 e0 29 80 00       	push   $0x8029e0
  8016db:	e8 51 0a 00 00       	call   802131 <_panic>

008016e0 <devfile_read>:
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
  8016e3:	56                   	push   %esi
  8016e4:	53                   	push   %ebx
  8016e5:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ee:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016f3:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8016fe:	b8 03 00 00 00       	mov    $0x3,%eax
  801703:	e8 65 fe ff ff       	call   80156d <fsipc>
  801708:	89 c3                	mov    %eax,%ebx
  80170a:	85 c0                	test   %eax,%eax
  80170c:	78 1f                	js     80172d <devfile_read+0x4d>
	assert(r <= n);
  80170e:	39 f0                	cmp    %esi,%eax
  801710:	77 24                	ja     801736 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801712:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801717:	7f 33                	jg     80174c <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801719:	83 ec 04             	sub    $0x4,%esp
  80171c:	50                   	push   %eax
  80171d:	68 00 50 80 00       	push   $0x805000
  801722:	ff 75 0c             	pushl  0xc(%ebp)
  801725:	e8 58 f3 ff ff       	call   800a82 <memmove>
	return r;
  80172a:	83 c4 10             	add    $0x10,%esp
}
  80172d:	89 d8                	mov    %ebx,%eax
  80172f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801732:	5b                   	pop    %ebx
  801733:	5e                   	pop    %esi
  801734:	5d                   	pop    %ebp
  801735:	c3                   	ret    
	assert(r <= n);
  801736:	68 c4 29 80 00       	push   $0x8029c4
  80173b:	68 cb 29 80 00       	push   $0x8029cb
  801740:	6a 7c                	push   $0x7c
  801742:	68 e0 29 80 00       	push   $0x8029e0
  801747:	e8 e5 09 00 00       	call   802131 <_panic>
	assert(r <= PGSIZE);
  80174c:	68 eb 29 80 00       	push   $0x8029eb
  801751:	68 cb 29 80 00       	push   $0x8029cb
  801756:	6a 7d                	push   $0x7d
  801758:	68 e0 29 80 00       	push   $0x8029e0
  80175d:	e8 cf 09 00 00       	call   802131 <_panic>

00801762 <open>:
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	56                   	push   %esi
  801766:	53                   	push   %ebx
  801767:	83 ec 1c             	sub    $0x1c,%esp
  80176a:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80176d:	56                   	push   %esi
  80176e:	e8 48 f1 ff ff       	call   8008bb <strlen>
  801773:	83 c4 10             	add    $0x10,%esp
  801776:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80177b:	7f 6c                	jg     8017e9 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80177d:	83 ec 0c             	sub    $0xc,%esp
  801780:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801783:	50                   	push   %eax
  801784:	e8 79 f8 ff ff       	call   801002 <fd_alloc>
  801789:	89 c3                	mov    %eax,%ebx
  80178b:	83 c4 10             	add    $0x10,%esp
  80178e:	85 c0                	test   %eax,%eax
  801790:	78 3c                	js     8017ce <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801792:	83 ec 08             	sub    $0x8,%esp
  801795:	56                   	push   %esi
  801796:	68 00 50 80 00       	push   $0x805000
  80179b:	e8 54 f1 ff ff       	call   8008f4 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a3:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8017b0:	e8 b8 fd ff ff       	call   80156d <fsipc>
  8017b5:	89 c3                	mov    %eax,%ebx
  8017b7:	83 c4 10             	add    $0x10,%esp
  8017ba:	85 c0                	test   %eax,%eax
  8017bc:	78 19                	js     8017d7 <open+0x75>
	return fd2num(fd);
  8017be:	83 ec 0c             	sub    $0xc,%esp
  8017c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8017c4:	e8 12 f8 ff ff       	call   800fdb <fd2num>
  8017c9:	89 c3                	mov    %eax,%ebx
  8017cb:	83 c4 10             	add    $0x10,%esp
}
  8017ce:	89 d8                	mov    %ebx,%eax
  8017d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017d3:	5b                   	pop    %ebx
  8017d4:	5e                   	pop    %esi
  8017d5:	5d                   	pop    %ebp
  8017d6:	c3                   	ret    
		fd_close(fd, 0);
  8017d7:	83 ec 08             	sub    $0x8,%esp
  8017da:	6a 00                	push   $0x0
  8017dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8017df:	e8 1b f9 ff ff       	call   8010ff <fd_close>
		return r;
  8017e4:	83 c4 10             	add    $0x10,%esp
  8017e7:	eb e5                	jmp    8017ce <open+0x6c>
		return -E_BAD_PATH;
  8017e9:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017ee:	eb de                	jmp    8017ce <open+0x6c>

008017f0 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8017fb:	b8 08 00 00 00       	mov    $0x8,%eax
  801800:	e8 68 fd ff ff       	call   80156d <fsipc>
}
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80180d:	68 f7 29 80 00       	push   $0x8029f7
  801812:	ff 75 0c             	pushl  0xc(%ebp)
  801815:	e8 da f0 ff ff       	call   8008f4 <strcpy>
	return 0;
}
  80181a:	b8 00 00 00 00       	mov    $0x0,%eax
  80181f:	c9                   	leave  
  801820:	c3                   	ret    

00801821 <devsock_close>:
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	53                   	push   %ebx
  801825:	83 ec 10             	sub    $0x10,%esp
  801828:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80182b:	53                   	push   %ebx
  80182c:	e8 61 0a 00 00       	call   802292 <pageref>
  801831:	83 c4 10             	add    $0x10,%esp
		return 0;
  801834:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801839:	83 f8 01             	cmp    $0x1,%eax
  80183c:	74 07                	je     801845 <devsock_close+0x24>
}
  80183e:	89 d0                	mov    %edx,%eax
  801840:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801843:	c9                   	leave  
  801844:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801845:	83 ec 0c             	sub    $0xc,%esp
  801848:	ff 73 0c             	pushl  0xc(%ebx)
  80184b:	e8 b9 02 00 00       	call   801b09 <nsipc_close>
  801850:	89 c2                	mov    %eax,%edx
  801852:	83 c4 10             	add    $0x10,%esp
  801855:	eb e7                	jmp    80183e <devsock_close+0x1d>

00801857 <devsock_write>:
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80185d:	6a 00                	push   $0x0
  80185f:	ff 75 10             	pushl  0x10(%ebp)
  801862:	ff 75 0c             	pushl  0xc(%ebp)
  801865:	8b 45 08             	mov    0x8(%ebp),%eax
  801868:	ff 70 0c             	pushl  0xc(%eax)
  80186b:	e8 76 03 00 00       	call   801be6 <nsipc_send>
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <devsock_read>:
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801878:	6a 00                	push   $0x0
  80187a:	ff 75 10             	pushl  0x10(%ebp)
  80187d:	ff 75 0c             	pushl  0xc(%ebp)
  801880:	8b 45 08             	mov    0x8(%ebp),%eax
  801883:	ff 70 0c             	pushl  0xc(%eax)
  801886:	e8 ef 02 00 00       	call   801b7a <nsipc_recv>
}
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <fd2sockid>:
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
  801890:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801893:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801896:	52                   	push   %edx
  801897:	50                   	push   %eax
  801898:	e8 b7 f7 ff ff       	call   801054 <fd_lookup>
  80189d:	83 c4 10             	add    $0x10,%esp
  8018a0:	85 c0                	test   %eax,%eax
  8018a2:	78 10                	js     8018b4 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a7:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018ad:	39 08                	cmp    %ecx,(%eax)
  8018af:	75 05                	jne    8018b6 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018b1:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    
		return -E_NOT_SUPP;
  8018b6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018bb:	eb f7                	jmp    8018b4 <fd2sockid+0x27>

008018bd <alloc_sockfd>:
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
  8018c0:	56                   	push   %esi
  8018c1:	53                   	push   %ebx
  8018c2:	83 ec 1c             	sub    $0x1c,%esp
  8018c5:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8018c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ca:	50                   	push   %eax
  8018cb:	e8 32 f7 ff ff       	call   801002 <fd_alloc>
  8018d0:	89 c3                	mov    %eax,%ebx
  8018d2:	83 c4 10             	add    $0x10,%esp
  8018d5:	85 c0                	test   %eax,%eax
  8018d7:	78 43                	js     80191c <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018d9:	83 ec 04             	sub    $0x4,%esp
  8018dc:	68 07 04 00 00       	push   $0x407
  8018e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e4:	6a 00                	push   $0x0
  8018e6:	e8 fb f3 ff ff       	call   800ce6 <sys_page_alloc>
  8018eb:	89 c3                	mov    %eax,%ebx
  8018ed:	83 c4 10             	add    $0x10,%esp
  8018f0:	85 c0                	test   %eax,%eax
  8018f2:	78 28                	js     80191c <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8018f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f7:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018fd:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8018ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801902:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801909:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80190c:	83 ec 0c             	sub    $0xc,%esp
  80190f:	50                   	push   %eax
  801910:	e8 c6 f6 ff ff       	call   800fdb <fd2num>
  801915:	89 c3                	mov    %eax,%ebx
  801917:	83 c4 10             	add    $0x10,%esp
  80191a:	eb 0c                	jmp    801928 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80191c:	83 ec 0c             	sub    $0xc,%esp
  80191f:	56                   	push   %esi
  801920:	e8 e4 01 00 00       	call   801b09 <nsipc_close>
		return r;
  801925:	83 c4 10             	add    $0x10,%esp
}
  801928:	89 d8                	mov    %ebx,%eax
  80192a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80192d:	5b                   	pop    %ebx
  80192e:	5e                   	pop    %esi
  80192f:	5d                   	pop    %ebp
  801930:	c3                   	ret    

00801931 <accept>:
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801937:	8b 45 08             	mov    0x8(%ebp),%eax
  80193a:	e8 4e ff ff ff       	call   80188d <fd2sockid>
  80193f:	85 c0                	test   %eax,%eax
  801941:	78 1b                	js     80195e <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801943:	83 ec 04             	sub    $0x4,%esp
  801946:	ff 75 10             	pushl  0x10(%ebp)
  801949:	ff 75 0c             	pushl  0xc(%ebp)
  80194c:	50                   	push   %eax
  80194d:	e8 0e 01 00 00       	call   801a60 <nsipc_accept>
  801952:	83 c4 10             	add    $0x10,%esp
  801955:	85 c0                	test   %eax,%eax
  801957:	78 05                	js     80195e <accept+0x2d>
	return alloc_sockfd(r);
  801959:	e8 5f ff ff ff       	call   8018bd <alloc_sockfd>
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <bind>:
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801966:	8b 45 08             	mov    0x8(%ebp),%eax
  801969:	e8 1f ff ff ff       	call   80188d <fd2sockid>
  80196e:	85 c0                	test   %eax,%eax
  801970:	78 12                	js     801984 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801972:	83 ec 04             	sub    $0x4,%esp
  801975:	ff 75 10             	pushl  0x10(%ebp)
  801978:	ff 75 0c             	pushl  0xc(%ebp)
  80197b:	50                   	push   %eax
  80197c:	e8 31 01 00 00       	call   801ab2 <nsipc_bind>
  801981:	83 c4 10             	add    $0x10,%esp
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <shutdown>:
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	e8 f9 fe ff ff       	call   80188d <fd2sockid>
  801994:	85 c0                	test   %eax,%eax
  801996:	78 0f                	js     8019a7 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801998:	83 ec 08             	sub    $0x8,%esp
  80199b:	ff 75 0c             	pushl  0xc(%ebp)
  80199e:	50                   	push   %eax
  80199f:	e8 43 01 00 00       	call   801ae7 <nsipc_shutdown>
  8019a4:	83 c4 10             	add    $0x10,%esp
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <connect>:
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	e8 d6 fe ff ff       	call   80188d <fd2sockid>
  8019b7:	85 c0                	test   %eax,%eax
  8019b9:	78 12                	js     8019cd <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8019bb:	83 ec 04             	sub    $0x4,%esp
  8019be:	ff 75 10             	pushl  0x10(%ebp)
  8019c1:	ff 75 0c             	pushl  0xc(%ebp)
  8019c4:	50                   	push   %eax
  8019c5:	e8 59 01 00 00       	call   801b23 <nsipc_connect>
  8019ca:	83 c4 10             	add    $0x10,%esp
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <listen>:
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
  8019d2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	e8 b0 fe ff ff       	call   80188d <fd2sockid>
  8019dd:	85 c0                	test   %eax,%eax
  8019df:	78 0f                	js     8019f0 <listen+0x21>
	return nsipc_listen(r, backlog);
  8019e1:	83 ec 08             	sub    $0x8,%esp
  8019e4:	ff 75 0c             	pushl  0xc(%ebp)
  8019e7:	50                   	push   %eax
  8019e8:	e8 6b 01 00 00       	call   801b58 <nsipc_listen>
  8019ed:	83 c4 10             	add    $0x10,%esp
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <socket>:

int
socket(int domain, int type, int protocol)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019f8:	ff 75 10             	pushl  0x10(%ebp)
  8019fb:	ff 75 0c             	pushl  0xc(%ebp)
  8019fe:	ff 75 08             	pushl  0x8(%ebp)
  801a01:	e8 3e 02 00 00       	call   801c44 <nsipc_socket>
  801a06:	83 c4 10             	add    $0x10,%esp
  801a09:	85 c0                	test   %eax,%eax
  801a0b:	78 05                	js     801a12 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a0d:	e8 ab fe ff ff       	call   8018bd <alloc_sockfd>
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	53                   	push   %ebx
  801a18:	83 ec 04             	sub    $0x4,%esp
  801a1b:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a1d:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a24:	74 26                	je     801a4c <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a26:	6a 07                	push   $0x7
  801a28:	68 00 60 80 00       	push   $0x806000
  801a2d:	53                   	push   %ebx
  801a2e:	ff 35 04 40 80 00    	pushl  0x804004
  801a34:	e8 c2 07 00 00       	call   8021fb <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a39:	83 c4 0c             	add    $0xc,%esp
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	e8 4b 07 00 00       	call   802192 <ipc_recv>
}
  801a47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a4c:	83 ec 0c             	sub    $0xc,%esp
  801a4f:	6a 02                	push   $0x2
  801a51:	e8 fd 07 00 00       	call   802253 <ipc_find_env>
  801a56:	a3 04 40 80 00       	mov    %eax,0x804004
  801a5b:	83 c4 10             	add    $0x10,%esp
  801a5e:	eb c6                	jmp    801a26 <nsipc+0x12>

00801a60 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	56                   	push   %esi
  801a64:	53                   	push   %ebx
  801a65:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a70:	8b 06                	mov    (%esi),%eax
  801a72:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a77:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7c:	e8 93 ff ff ff       	call   801a14 <nsipc>
  801a81:	89 c3                	mov    %eax,%ebx
  801a83:	85 c0                	test   %eax,%eax
  801a85:	79 09                	jns    801a90 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a87:	89 d8                	mov    %ebx,%eax
  801a89:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a8c:	5b                   	pop    %ebx
  801a8d:	5e                   	pop    %esi
  801a8e:	5d                   	pop    %ebp
  801a8f:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a90:	83 ec 04             	sub    $0x4,%esp
  801a93:	ff 35 10 60 80 00    	pushl  0x806010
  801a99:	68 00 60 80 00       	push   $0x806000
  801a9e:	ff 75 0c             	pushl  0xc(%ebp)
  801aa1:	e8 dc ef ff ff       	call   800a82 <memmove>
		*addrlen = ret->ret_addrlen;
  801aa6:	a1 10 60 80 00       	mov    0x806010,%eax
  801aab:	89 06                	mov    %eax,(%esi)
  801aad:	83 c4 10             	add    $0x10,%esp
	return r;
  801ab0:	eb d5                	jmp    801a87 <nsipc_accept+0x27>

00801ab2 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
  801ab5:	53                   	push   %ebx
  801ab6:	83 ec 08             	sub    $0x8,%esp
  801ab9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801abc:	8b 45 08             	mov    0x8(%ebp),%eax
  801abf:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ac4:	53                   	push   %ebx
  801ac5:	ff 75 0c             	pushl  0xc(%ebp)
  801ac8:	68 04 60 80 00       	push   $0x806004
  801acd:	e8 b0 ef ff ff       	call   800a82 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ad2:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801ad8:	b8 02 00 00 00       	mov    $0x2,%eax
  801add:	e8 32 ff ff ff       	call   801a14 <nsipc>
}
  801ae2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
  801aea:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801aed:	8b 45 08             	mov    0x8(%ebp),%eax
  801af0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801af5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af8:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801afd:	b8 03 00 00 00       	mov    $0x3,%eax
  801b02:	e8 0d ff ff ff       	call   801a14 <nsipc>
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <nsipc_close>:

int
nsipc_close(int s)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b12:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b17:	b8 04 00 00 00       	mov    $0x4,%eax
  801b1c:	e8 f3 fe ff ff       	call   801a14 <nsipc>
}
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
  801b26:	53                   	push   %ebx
  801b27:	83 ec 08             	sub    $0x8,%esp
  801b2a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b30:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b35:	53                   	push   %ebx
  801b36:	ff 75 0c             	pushl  0xc(%ebp)
  801b39:	68 04 60 80 00       	push   $0x806004
  801b3e:	e8 3f ef ff ff       	call   800a82 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b43:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b49:	b8 05 00 00 00       	mov    $0x5,%eax
  801b4e:	e8 c1 fe ff ff       	call   801a14 <nsipc>
}
  801b53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
  801b5b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b61:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b69:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b6e:	b8 06 00 00 00       	mov    $0x6,%eax
  801b73:	e8 9c fe ff ff       	call   801a14 <nsipc>
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
  801b7d:	56                   	push   %esi
  801b7e:	53                   	push   %ebx
  801b7f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b8a:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b90:	8b 45 14             	mov    0x14(%ebp),%eax
  801b93:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b98:	b8 07 00 00 00       	mov    $0x7,%eax
  801b9d:	e8 72 fe ff ff       	call   801a14 <nsipc>
  801ba2:	89 c3                	mov    %eax,%ebx
  801ba4:	85 c0                	test   %eax,%eax
  801ba6:	78 1f                	js     801bc7 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801ba8:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801bad:	7f 21                	jg     801bd0 <nsipc_recv+0x56>
  801baf:	39 c6                	cmp    %eax,%esi
  801bb1:	7c 1d                	jl     801bd0 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801bb3:	83 ec 04             	sub    $0x4,%esp
  801bb6:	50                   	push   %eax
  801bb7:	68 00 60 80 00       	push   $0x806000
  801bbc:	ff 75 0c             	pushl  0xc(%ebp)
  801bbf:	e8 be ee ff ff       	call   800a82 <memmove>
  801bc4:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801bc7:	89 d8                	mov    %ebx,%eax
  801bc9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bcc:	5b                   	pop    %ebx
  801bcd:	5e                   	pop    %esi
  801bce:	5d                   	pop    %ebp
  801bcf:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801bd0:	68 03 2a 80 00       	push   $0x802a03
  801bd5:	68 cb 29 80 00       	push   $0x8029cb
  801bda:	6a 62                	push   $0x62
  801bdc:	68 18 2a 80 00       	push   $0x802a18
  801be1:	e8 4b 05 00 00       	call   802131 <_panic>

00801be6 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	53                   	push   %ebx
  801bea:	83 ec 04             	sub    $0x4,%esp
  801bed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf3:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801bf8:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801bfe:	7f 2e                	jg     801c2e <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c00:	83 ec 04             	sub    $0x4,%esp
  801c03:	53                   	push   %ebx
  801c04:	ff 75 0c             	pushl  0xc(%ebp)
  801c07:	68 0c 60 80 00       	push   $0x80600c
  801c0c:	e8 71 ee ff ff       	call   800a82 <memmove>
	nsipcbuf.send.req_size = size;
  801c11:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c17:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1a:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c1f:	b8 08 00 00 00       	mov    $0x8,%eax
  801c24:	e8 eb fd ff ff       	call   801a14 <nsipc>
}
  801c29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c2c:	c9                   	leave  
  801c2d:	c3                   	ret    
	assert(size < 1600);
  801c2e:	68 24 2a 80 00       	push   $0x802a24
  801c33:	68 cb 29 80 00       	push   $0x8029cb
  801c38:	6a 6d                	push   $0x6d
  801c3a:	68 18 2a 80 00       	push   $0x802a18
  801c3f:	e8 ed 04 00 00       	call   802131 <_panic>

00801c44 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c55:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c5a:	8b 45 10             	mov    0x10(%ebp),%eax
  801c5d:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c62:	b8 09 00 00 00       	mov    $0x9,%eax
  801c67:	e8 a8 fd ff ff       	call   801a14 <nsipc>
}
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
  801c71:	56                   	push   %esi
  801c72:	53                   	push   %ebx
  801c73:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c76:	83 ec 0c             	sub    $0xc,%esp
  801c79:	ff 75 08             	pushl  0x8(%ebp)
  801c7c:	e8 6a f3 ff ff       	call   800feb <fd2data>
  801c81:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c83:	83 c4 08             	add    $0x8,%esp
  801c86:	68 30 2a 80 00       	push   $0x802a30
  801c8b:	53                   	push   %ebx
  801c8c:	e8 63 ec ff ff       	call   8008f4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c91:	8b 46 04             	mov    0x4(%esi),%eax
  801c94:	2b 06                	sub    (%esi),%eax
  801c96:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c9c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ca3:	00 00 00 
	stat->st_dev = &devpipe;
  801ca6:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801cad:	30 80 00 
	return 0;
}
  801cb0:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cb8:	5b                   	pop    %ebx
  801cb9:	5e                   	pop    %esi
  801cba:	5d                   	pop    %ebp
  801cbb:	c3                   	ret    

00801cbc <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	53                   	push   %ebx
  801cc0:	83 ec 0c             	sub    $0xc,%esp
  801cc3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801cc6:	53                   	push   %ebx
  801cc7:	6a 00                	push   $0x0
  801cc9:	e8 9d f0 ff ff       	call   800d6b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801cce:	89 1c 24             	mov    %ebx,(%esp)
  801cd1:	e8 15 f3 ff ff       	call   800feb <fd2data>
  801cd6:	83 c4 08             	add    $0x8,%esp
  801cd9:	50                   	push   %eax
  801cda:	6a 00                	push   $0x0
  801cdc:	e8 8a f0 ff ff       	call   800d6b <sys_page_unmap>
}
  801ce1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <_pipeisclosed>:
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
  801ce9:	57                   	push   %edi
  801cea:	56                   	push   %esi
  801ceb:	53                   	push   %ebx
  801cec:	83 ec 1c             	sub    $0x1c,%esp
  801cef:	89 c7                	mov    %eax,%edi
  801cf1:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cf3:	a1 08 40 80 00       	mov    0x804008,%eax
  801cf8:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cfb:	83 ec 0c             	sub    $0xc,%esp
  801cfe:	57                   	push   %edi
  801cff:	e8 8e 05 00 00       	call   802292 <pageref>
  801d04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d07:	89 34 24             	mov    %esi,(%esp)
  801d0a:	e8 83 05 00 00       	call   802292 <pageref>
		nn = thisenv->env_runs;
  801d0f:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d15:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d18:	83 c4 10             	add    $0x10,%esp
  801d1b:	39 cb                	cmp    %ecx,%ebx
  801d1d:	74 1b                	je     801d3a <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d1f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d22:	75 cf                	jne    801cf3 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d24:	8b 42 58             	mov    0x58(%edx),%eax
  801d27:	6a 01                	push   $0x1
  801d29:	50                   	push   %eax
  801d2a:	53                   	push   %ebx
  801d2b:	68 37 2a 80 00       	push   $0x802a37
  801d30:	e8 60 e4 ff ff       	call   800195 <cprintf>
  801d35:	83 c4 10             	add    $0x10,%esp
  801d38:	eb b9                	jmp    801cf3 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d3a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d3d:	0f 94 c0             	sete   %al
  801d40:	0f b6 c0             	movzbl %al,%eax
}
  801d43:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d46:	5b                   	pop    %ebx
  801d47:	5e                   	pop    %esi
  801d48:	5f                   	pop    %edi
  801d49:	5d                   	pop    %ebp
  801d4a:	c3                   	ret    

00801d4b <devpipe_write>:
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	57                   	push   %edi
  801d4f:	56                   	push   %esi
  801d50:	53                   	push   %ebx
  801d51:	83 ec 28             	sub    $0x28,%esp
  801d54:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d57:	56                   	push   %esi
  801d58:	e8 8e f2 ff ff       	call   800feb <fd2data>
  801d5d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d5f:	83 c4 10             	add    $0x10,%esp
  801d62:	bf 00 00 00 00       	mov    $0x0,%edi
  801d67:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d6a:	74 4f                	je     801dbb <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d6c:	8b 43 04             	mov    0x4(%ebx),%eax
  801d6f:	8b 0b                	mov    (%ebx),%ecx
  801d71:	8d 51 20             	lea    0x20(%ecx),%edx
  801d74:	39 d0                	cmp    %edx,%eax
  801d76:	72 14                	jb     801d8c <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d78:	89 da                	mov    %ebx,%edx
  801d7a:	89 f0                	mov    %esi,%eax
  801d7c:	e8 65 ff ff ff       	call   801ce6 <_pipeisclosed>
  801d81:	85 c0                	test   %eax,%eax
  801d83:	75 3b                	jne    801dc0 <devpipe_write+0x75>
			sys_yield();
  801d85:	e8 3d ef ff ff       	call   800cc7 <sys_yield>
  801d8a:	eb e0                	jmp    801d6c <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d8f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d93:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d96:	89 c2                	mov    %eax,%edx
  801d98:	c1 fa 1f             	sar    $0x1f,%edx
  801d9b:	89 d1                	mov    %edx,%ecx
  801d9d:	c1 e9 1b             	shr    $0x1b,%ecx
  801da0:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801da3:	83 e2 1f             	and    $0x1f,%edx
  801da6:	29 ca                	sub    %ecx,%edx
  801da8:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801dac:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801db0:	83 c0 01             	add    $0x1,%eax
  801db3:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801db6:	83 c7 01             	add    $0x1,%edi
  801db9:	eb ac                	jmp    801d67 <devpipe_write+0x1c>
	return i;
  801dbb:	8b 45 10             	mov    0x10(%ebp),%eax
  801dbe:	eb 05                	jmp    801dc5 <devpipe_write+0x7a>
				return 0;
  801dc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dc8:	5b                   	pop    %ebx
  801dc9:	5e                   	pop    %esi
  801dca:	5f                   	pop    %edi
  801dcb:	5d                   	pop    %ebp
  801dcc:	c3                   	ret    

00801dcd <devpipe_read>:
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
  801dd0:	57                   	push   %edi
  801dd1:	56                   	push   %esi
  801dd2:	53                   	push   %ebx
  801dd3:	83 ec 18             	sub    $0x18,%esp
  801dd6:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801dd9:	57                   	push   %edi
  801dda:	e8 0c f2 ff ff       	call   800feb <fd2data>
  801ddf:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801de1:	83 c4 10             	add    $0x10,%esp
  801de4:	be 00 00 00 00       	mov    $0x0,%esi
  801de9:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dec:	75 14                	jne    801e02 <devpipe_read+0x35>
	return i;
  801dee:	8b 45 10             	mov    0x10(%ebp),%eax
  801df1:	eb 02                	jmp    801df5 <devpipe_read+0x28>
				return i;
  801df3:	89 f0                	mov    %esi,%eax
}
  801df5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801df8:	5b                   	pop    %ebx
  801df9:	5e                   	pop    %esi
  801dfa:	5f                   	pop    %edi
  801dfb:	5d                   	pop    %ebp
  801dfc:	c3                   	ret    
			sys_yield();
  801dfd:	e8 c5 ee ff ff       	call   800cc7 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e02:	8b 03                	mov    (%ebx),%eax
  801e04:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e07:	75 18                	jne    801e21 <devpipe_read+0x54>
			if (i > 0)
  801e09:	85 f6                	test   %esi,%esi
  801e0b:	75 e6                	jne    801df3 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e0d:	89 da                	mov    %ebx,%edx
  801e0f:	89 f8                	mov    %edi,%eax
  801e11:	e8 d0 fe ff ff       	call   801ce6 <_pipeisclosed>
  801e16:	85 c0                	test   %eax,%eax
  801e18:	74 e3                	je     801dfd <devpipe_read+0x30>
				return 0;
  801e1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1f:	eb d4                	jmp    801df5 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e21:	99                   	cltd   
  801e22:	c1 ea 1b             	shr    $0x1b,%edx
  801e25:	01 d0                	add    %edx,%eax
  801e27:	83 e0 1f             	and    $0x1f,%eax
  801e2a:	29 d0                	sub    %edx,%eax
  801e2c:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e34:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e37:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e3a:	83 c6 01             	add    $0x1,%esi
  801e3d:	eb aa                	jmp    801de9 <devpipe_read+0x1c>

00801e3f <pipe>:
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
  801e42:	56                   	push   %esi
  801e43:	53                   	push   %ebx
  801e44:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e47:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e4a:	50                   	push   %eax
  801e4b:	e8 b2 f1 ff ff       	call   801002 <fd_alloc>
  801e50:	89 c3                	mov    %eax,%ebx
  801e52:	83 c4 10             	add    $0x10,%esp
  801e55:	85 c0                	test   %eax,%eax
  801e57:	0f 88 23 01 00 00    	js     801f80 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e5d:	83 ec 04             	sub    $0x4,%esp
  801e60:	68 07 04 00 00       	push   $0x407
  801e65:	ff 75 f4             	pushl  -0xc(%ebp)
  801e68:	6a 00                	push   $0x0
  801e6a:	e8 77 ee ff ff       	call   800ce6 <sys_page_alloc>
  801e6f:	89 c3                	mov    %eax,%ebx
  801e71:	83 c4 10             	add    $0x10,%esp
  801e74:	85 c0                	test   %eax,%eax
  801e76:	0f 88 04 01 00 00    	js     801f80 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e7c:	83 ec 0c             	sub    $0xc,%esp
  801e7f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e82:	50                   	push   %eax
  801e83:	e8 7a f1 ff ff       	call   801002 <fd_alloc>
  801e88:	89 c3                	mov    %eax,%ebx
  801e8a:	83 c4 10             	add    $0x10,%esp
  801e8d:	85 c0                	test   %eax,%eax
  801e8f:	0f 88 db 00 00 00    	js     801f70 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e95:	83 ec 04             	sub    $0x4,%esp
  801e98:	68 07 04 00 00       	push   $0x407
  801e9d:	ff 75 f0             	pushl  -0x10(%ebp)
  801ea0:	6a 00                	push   $0x0
  801ea2:	e8 3f ee ff ff       	call   800ce6 <sys_page_alloc>
  801ea7:	89 c3                	mov    %eax,%ebx
  801ea9:	83 c4 10             	add    $0x10,%esp
  801eac:	85 c0                	test   %eax,%eax
  801eae:	0f 88 bc 00 00 00    	js     801f70 <pipe+0x131>
	va = fd2data(fd0);
  801eb4:	83 ec 0c             	sub    $0xc,%esp
  801eb7:	ff 75 f4             	pushl  -0xc(%ebp)
  801eba:	e8 2c f1 ff ff       	call   800feb <fd2data>
  801ebf:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ec1:	83 c4 0c             	add    $0xc,%esp
  801ec4:	68 07 04 00 00       	push   $0x407
  801ec9:	50                   	push   %eax
  801eca:	6a 00                	push   $0x0
  801ecc:	e8 15 ee ff ff       	call   800ce6 <sys_page_alloc>
  801ed1:	89 c3                	mov    %eax,%ebx
  801ed3:	83 c4 10             	add    $0x10,%esp
  801ed6:	85 c0                	test   %eax,%eax
  801ed8:	0f 88 82 00 00 00    	js     801f60 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ede:	83 ec 0c             	sub    $0xc,%esp
  801ee1:	ff 75 f0             	pushl  -0x10(%ebp)
  801ee4:	e8 02 f1 ff ff       	call   800feb <fd2data>
  801ee9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ef0:	50                   	push   %eax
  801ef1:	6a 00                	push   $0x0
  801ef3:	56                   	push   %esi
  801ef4:	6a 00                	push   $0x0
  801ef6:	e8 2e ee ff ff       	call   800d29 <sys_page_map>
  801efb:	89 c3                	mov    %eax,%ebx
  801efd:	83 c4 20             	add    $0x20,%esp
  801f00:	85 c0                	test   %eax,%eax
  801f02:	78 4e                	js     801f52 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f04:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f0c:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f11:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f18:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f1b:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f20:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f27:	83 ec 0c             	sub    $0xc,%esp
  801f2a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f2d:	e8 a9 f0 ff ff       	call   800fdb <fd2num>
  801f32:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f35:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f37:	83 c4 04             	add    $0x4,%esp
  801f3a:	ff 75 f0             	pushl  -0x10(%ebp)
  801f3d:	e8 99 f0 ff ff       	call   800fdb <fd2num>
  801f42:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f45:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f48:	83 c4 10             	add    $0x10,%esp
  801f4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f50:	eb 2e                	jmp    801f80 <pipe+0x141>
	sys_page_unmap(0, va);
  801f52:	83 ec 08             	sub    $0x8,%esp
  801f55:	56                   	push   %esi
  801f56:	6a 00                	push   $0x0
  801f58:	e8 0e ee ff ff       	call   800d6b <sys_page_unmap>
  801f5d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f60:	83 ec 08             	sub    $0x8,%esp
  801f63:	ff 75 f0             	pushl  -0x10(%ebp)
  801f66:	6a 00                	push   $0x0
  801f68:	e8 fe ed ff ff       	call   800d6b <sys_page_unmap>
  801f6d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f70:	83 ec 08             	sub    $0x8,%esp
  801f73:	ff 75 f4             	pushl  -0xc(%ebp)
  801f76:	6a 00                	push   $0x0
  801f78:	e8 ee ed ff ff       	call   800d6b <sys_page_unmap>
  801f7d:	83 c4 10             	add    $0x10,%esp
}
  801f80:	89 d8                	mov    %ebx,%eax
  801f82:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f85:	5b                   	pop    %ebx
  801f86:	5e                   	pop    %esi
  801f87:	5d                   	pop    %ebp
  801f88:	c3                   	ret    

00801f89 <pipeisclosed>:
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f8f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f92:	50                   	push   %eax
  801f93:	ff 75 08             	pushl  0x8(%ebp)
  801f96:	e8 b9 f0 ff ff       	call   801054 <fd_lookup>
  801f9b:	83 c4 10             	add    $0x10,%esp
  801f9e:	85 c0                	test   %eax,%eax
  801fa0:	78 18                	js     801fba <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fa2:	83 ec 0c             	sub    $0xc,%esp
  801fa5:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa8:	e8 3e f0 ff ff       	call   800feb <fd2data>
	return _pipeisclosed(fd, p);
  801fad:	89 c2                	mov    %eax,%edx
  801faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb2:	e8 2f fd ff ff       	call   801ce6 <_pipeisclosed>
  801fb7:	83 c4 10             	add    $0x10,%esp
}
  801fba:	c9                   	leave  
  801fbb:	c3                   	ret    

00801fbc <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801fbc:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc1:	c3                   	ret    

00801fc2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fc2:	55                   	push   %ebp
  801fc3:	89 e5                	mov    %esp,%ebp
  801fc5:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fc8:	68 4f 2a 80 00       	push   $0x802a4f
  801fcd:	ff 75 0c             	pushl  0xc(%ebp)
  801fd0:	e8 1f e9 ff ff       	call   8008f4 <strcpy>
	return 0;
}
  801fd5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fda:	c9                   	leave  
  801fdb:	c3                   	ret    

00801fdc <devcons_write>:
{
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
  801fdf:	57                   	push   %edi
  801fe0:	56                   	push   %esi
  801fe1:	53                   	push   %ebx
  801fe2:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fe8:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fed:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801ff3:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ff6:	73 31                	jae    802029 <devcons_write+0x4d>
		m = n - tot;
  801ff8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ffb:	29 f3                	sub    %esi,%ebx
  801ffd:	83 fb 7f             	cmp    $0x7f,%ebx
  802000:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802005:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802008:	83 ec 04             	sub    $0x4,%esp
  80200b:	53                   	push   %ebx
  80200c:	89 f0                	mov    %esi,%eax
  80200e:	03 45 0c             	add    0xc(%ebp),%eax
  802011:	50                   	push   %eax
  802012:	57                   	push   %edi
  802013:	e8 6a ea ff ff       	call   800a82 <memmove>
		sys_cputs(buf, m);
  802018:	83 c4 08             	add    $0x8,%esp
  80201b:	53                   	push   %ebx
  80201c:	57                   	push   %edi
  80201d:	e8 08 ec ff ff       	call   800c2a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802022:	01 de                	add    %ebx,%esi
  802024:	83 c4 10             	add    $0x10,%esp
  802027:	eb ca                	jmp    801ff3 <devcons_write+0x17>
}
  802029:	89 f0                	mov    %esi,%eax
  80202b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80202e:	5b                   	pop    %ebx
  80202f:	5e                   	pop    %esi
  802030:	5f                   	pop    %edi
  802031:	5d                   	pop    %ebp
  802032:	c3                   	ret    

00802033 <devcons_read>:
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
  802036:	83 ec 08             	sub    $0x8,%esp
  802039:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80203e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802042:	74 21                	je     802065 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802044:	e8 ff eb ff ff       	call   800c48 <sys_cgetc>
  802049:	85 c0                	test   %eax,%eax
  80204b:	75 07                	jne    802054 <devcons_read+0x21>
		sys_yield();
  80204d:	e8 75 ec ff ff       	call   800cc7 <sys_yield>
  802052:	eb f0                	jmp    802044 <devcons_read+0x11>
	if (c < 0)
  802054:	78 0f                	js     802065 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802056:	83 f8 04             	cmp    $0x4,%eax
  802059:	74 0c                	je     802067 <devcons_read+0x34>
	*(char*)vbuf = c;
  80205b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205e:	88 02                	mov    %al,(%edx)
	return 1;
  802060:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    
		return 0;
  802067:	b8 00 00 00 00       	mov    $0x0,%eax
  80206c:	eb f7                	jmp    802065 <devcons_read+0x32>

0080206e <cputchar>:
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
  802071:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802074:	8b 45 08             	mov    0x8(%ebp),%eax
  802077:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80207a:	6a 01                	push   $0x1
  80207c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80207f:	50                   	push   %eax
  802080:	e8 a5 eb ff ff       	call   800c2a <sys_cputs>
}
  802085:	83 c4 10             	add    $0x10,%esp
  802088:	c9                   	leave  
  802089:	c3                   	ret    

0080208a <getchar>:
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802090:	6a 01                	push   $0x1
  802092:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802095:	50                   	push   %eax
  802096:	6a 00                	push   $0x0
  802098:	e8 27 f2 ff ff       	call   8012c4 <read>
	if (r < 0)
  80209d:	83 c4 10             	add    $0x10,%esp
  8020a0:	85 c0                	test   %eax,%eax
  8020a2:	78 06                	js     8020aa <getchar+0x20>
	if (r < 1)
  8020a4:	74 06                	je     8020ac <getchar+0x22>
	return c;
  8020a6:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020aa:	c9                   	leave  
  8020ab:	c3                   	ret    
		return -E_EOF;
  8020ac:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020b1:	eb f7                	jmp    8020aa <getchar+0x20>

008020b3 <iscons>:
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020bc:	50                   	push   %eax
  8020bd:	ff 75 08             	pushl  0x8(%ebp)
  8020c0:	e8 8f ef ff ff       	call   801054 <fd_lookup>
  8020c5:	83 c4 10             	add    $0x10,%esp
  8020c8:	85 c0                	test   %eax,%eax
  8020ca:	78 11                	js     8020dd <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cf:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020d5:	39 10                	cmp    %edx,(%eax)
  8020d7:	0f 94 c0             	sete   %al
  8020da:	0f b6 c0             	movzbl %al,%eax
}
  8020dd:	c9                   	leave  
  8020de:	c3                   	ret    

008020df <opencons>:
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
  8020e2:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020e8:	50                   	push   %eax
  8020e9:	e8 14 ef ff ff       	call   801002 <fd_alloc>
  8020ee:	83 c4 10             	add    $0x10,%esp
  8020f1:	85 c0                	test   %eax,%eax
  8020f3:	78 3a                	js     80212f <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020f5:	83 ec 04             	sub    $0x4,%esp
  8020f8:	68 07 04 00 00       	push   $0x407
  8020fd:	ff 75 f4             	pushl  -0xc(%ebp)
  802100:	6a 00                	push   $0x0
  802102:	e8 df eb ff ff       	call   800ce6 <sys_page_alloc>
  802107:	83 c4 10             	add    $0x10,%esp
  80210a:	85 c0                	test   %eax,%eax
  80210c:	78 21                	js     80212f <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80210e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802111:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802117:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802123:	83 ec 0c             	sub    $0xc,%esp
  802126:	50                   	push   %eax
  802127:	e8 af ee ff ff       	call   800fdb <fd2num>
  80212c:	83 c4 10             	add    $0x10,%esp
}
  80212f:	c9                   	leave  
  802130:	c3                   	ret    

00802131 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
  802134:	56                   	push   %esi
  802135:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802136:	a1 08 40 80 00       	mov    0x804008,%eax
  80213b:	8b 40 48             	mov    0x48(%eax),%eax
  80213e:	83 ec 04             	sub    $0x4,%esp
  802141:	68 80 2a 80 00       	push   $0x802a80
  802146:	50                   	push   %eax
  802147:	68 6c 25 80 00       	push   $0x80256c
  80214c:	e8 44 e0 ff ff       	call   800195 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802151:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802154:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80215a:	e8 49 eb ff ff       	call   800ca8 <sys_getenvid>
  80215f:	83 c4 04             	add    $0x4,%esp
  802162:	ff 75 0c             	pushl  0xc(%ebp)
  802165:	ff 75 08             	pushl  0x8(%ebp)
  802168:	56                   	push   %esi
  802169:	50                   	push   %eax
  80216a:	68 5c 2a 80 00       	push   $0x802a5c
  80216f:	e8 21 e0 ff ff       	call   800195 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802174:	83 c4 18             	add    $0x18,%esp
  802177:	53                   	push   %ebx
  802178:	ff 75 10             	pushl  0x10(%ebp)
  80217b:	e8 c4 df ff ff       	call   800144 <vcprintf>
	cprintf("\n");
  802180:	c7 04 24 9a 2a 80 00 	movl   $0x802a9a,(%esp)
  802187:	e8 09 e0 ff ff       	call   800195 <cprintf>
  80218c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80218f:	cc                   	int3   
  802190:	eb fd                	jmp    80218f <_panic+0x5e>

00802192 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
  802195:	56                   	push   %esi
  802196:	53                   	push   %ebx
  802197:	8b 75 08             	mov    0x8(%ebp),%esi
  80219a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80219d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8021a0:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021a2:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021a7:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8021aa:	83 ec 0c             	sub    $0xc,%esp
  8021ad:	50                   	push   %eax
  8021ae:	e8 e3 ec ff ff       	call   800e96 <sys_ipc_recv>
	if(ret < 0){
  8021b3:	83 c4 10             	add    $0x10,%esp
  8021b6:	85 c0                	test   %eax,%eax
  8021b8:	78 2b                	js     8021e5 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8021ba:	85 f6                	test   %esi,%esi
  8021bc:	74 0a                	je     8021c8 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8021be:	a1 08 40 80 00       	mov    0x804008,%eax
  8021c3:	8b 40 78             	mov    0x78(%eax),%eax
  8021c6:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8021c8:	85 db                	test   %ebx,%ebx
  8021ca:	74 0a                	je     8021d6 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8021cc:	a1 08 40 80 00       	mov    0x804008,%eax
  8021d1:	8b 40 7c             	mov    0x7c(%eax),%eax
  8021d4:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8021d6:	a1 08 40 80 00       	mov    0x804008,%eax
  8021db:	8b 40 74             	mov    0x74(%eax),%eax
}
  8021de:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021e1:	5b                   	pop    %ebx
  8021e2:	5e                   	pop    %esi
  8021e3:	5d                   	pop    %ebp
  8021e4:	c3                   	ret    
		if(from_env_store)
  8021e5:	85 f6                	test   %esi,%esi
  8021e7:	74 06                	je     8021ef <ipc_recv+0x5d>
			*from_env_store = 0;
  8021e9:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8021ef:	85 db                	test   %ebx,%ebx
  8021f1:	74 eb                	je     8021de <ipc_recv+0x4c>
			*perm_store = 0;
  8021f3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021f9:	eb e3                	jmp    8021de <ipc_recv+0x4c>

008021fb <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
  8021fe:	57                   	push   %edi
  8021ff:	56                   	push   %esi
  802200:	53                   	push   %ebx
  802201:	83 ec 0c             	sub    $0xc,%esp
  802204:	8b 7d 08             	mov    0x8(%ebp),%edi
  802207:	8b 75 0c             	mov    0xc(%ebp),%esi
  80220a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80220d:	85 db                	test   %ebx,%ebx
  80220f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802214:	0f 44 d8             	cmove  %eax,%ebx
  802217:	eb 05                	jmp    80221e <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802219:	e8 a9 ea ff ff       	call   800cc7 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80221e:	ff 75 14             	pushl  0x14(%ebp)
  802221:	53                   	push   %ebx
  802222:	56                   	push   %esi
  802223:	57                   	push   %edi
  802224:	e8 4a ec ff ff       	call   800e73 <sys_ipc_try_send>
  802229:	83 c4 10             	add    $0x10,%esp
  80222c:	85 c0                	test   %eax,%eax
  80222e:	74 1b                	je     80224b <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802230:	79 e7                	jns    802219 <ipc_send+0x1e>
  802232:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802235:	74 e2                	je     802219 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802237:	83 ec 04             	sub    $0x4,%esp
  80223a:	68 87 2a 80 00       	push   $0x802a87
  80223f:	6a 46                	push   $0x46
  802241:	68 9c 2a 80 00       	push   $0x802a9c
  802246:	e8 e6 fe ff ff       	call   802131 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80224b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80224e:	5b                   	pop    %ebx
  80224f:	5e                   	pop    %esi
  802250:	5f                   	pop    %edi
  802251:	5d                   	pop    %ebp
  802252:	c3                   	ret    

00802253 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
  802256:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802259:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80225e:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802264:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80226a:	8b 52 50             	mov    0x50(%edx),%edx
  80226d:	39 ca                	cmp    %ecx,%edx
  80226f:	74 11                	je     802282 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802271:	83 c0 01             	add    $0x1,%eax
  802274:	3d 00 04 00 00       	cmp    $0x400,%eax
  802279:	75 e3                	jne    80225e <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80227b:	b8 00 00 00 00       	mov    $0x0,%eax
  802280:	eb 0e                	jmp    802290 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802282:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802288:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80228d:	8b 40 48             	mov    0x48(%eax),%eax
}
  802290:	5d                   	pop    %ebp
  802291:	c3                   	ret    

00802292 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802292:	55                   	push   %ebp
  802293:	89 e5                	mov    %esp,%ebp
  802295:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802298:	89 d0                	mov    %edx,%eax
  80229a:	c1 e8 16             	shr    $0x16,%eax
  80229d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022a4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022a9:	f6 c1 01             	test   $0x1,%cl
  8022ac:	74 1d                	je     8022cb <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022ae:	c1 ea 0c             	shr    $0xc,%edx
  8022b1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022b8:	f6 c2 01             	test   $0x1,%dl
  8022bb:	74 0e                	je     8022cb <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022bd:	c1 ea 0c             	shr    $0xc,%edx
  8022c0:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022c7:	ef 
  8022c8:	0f b7 c0             	movzwl %ax,%eax
}
  8022cb:	5d                   	pop    %ebp
  8022cc:	c3                   	ret    
  8022cd:	66 90                	xchg   %ax,%ax
  8022cf:	90                   	nop

008022d0 <__udivdi3>:
  8022d0:	55                   	push   %ebp
  8022d1:	57                   	push   %edi
  8022d2:	56                   	push   %esi
  8022d3:	53                   	push   %ebx
  8022d4:	83 ec 1c             	sub    $0x1c,%esp
  8022d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022db:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022e3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8022e7:	85 d2                	test   %edx,%edx
  8022e9:	75 4d                	jne    802338 <__udivdi3+0x68>
  8022eb:	39 f3                	cmp    %esi,%ebx
  8022ed:	76 19                	jbe    802308 <__udivdi3+0x38>
  8022ef:	31 ff                	xor    %edi,%edi
  8022f1:	89 e8                	mov    %ebp,%eax
  8022f3:	89 f2                	mov    %esi,%edx
  8022f5:	f7 f3                	div    %ebx
  8022f7:	89 fa                	mov    %edi,%edx
  8022f9:	83 c4 1c             	add    $0x1c,%esp
  8022fc:	5b                   	pop    %ebx
  8022fd:	5e                   	pop    %esi
  8022fe:	5f                   	pop    %edi
  8022ff:	5d                   	pop    %ebp
  802300:	c3                   	ret    
  802301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802308:	89 d9                	mov    %ebx,%ecx
  80230a:	85 db                	test   %ebx,%ebx
  80230c:	75 0b                	jne    802319 <__udivdi3+0x49>
  80230e:	b8 01 00 00 00       	mov    $0x1,%eax
  802313:	31 d2                	xor    %edx,%edx
  802315:	f7 f3                	div    %ebx
  802317:	89 c1                	mov    %eax,%ecx
  802319:	31 d2                	xor    %edx,%edx
  80231b:	89 f0                	mov    %esi,%eax
  80231d:	f7 f1                	div    %ecx
  80231f:	89 c6                	mov    %eax,%esi
  802321:	89 e8                	mov    %ebp,%eax
  802323:	89 f7                	mov    %esi,%edi
  802325:	f7 f1                	div    %ecx
  802327:	89 fa                	mov    %edi,%edx
  802329:	83 c4 1c             	add    $0x1c,%esp
  80232c:	5b                   	pop    %ebx
  80232d:	5e                   	pop    %esi
  80232e:	5f                   	pop    %edi
  80232f:	5d                   	pop    %ebp
  802330:	c3                   	ret    
  802331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802338:	39 f2                	cmp    %esi,%edx
  80233a:	77 1c                	ja     802358 <__udivdi3+0x88>
  80233c:	0f bd fa             	bsr    %edx,%edi
  80233f:	83 f7 1f             	xor    $0x1f,%edi
  802342:	75 2c                	jne    802370 <__udivdi3+0xa0>
  802344:	39 f2                	cmp    %esi,%edx
  802346:	72 06                	jb     80234e <__udivdi3+0x7e>
  802348:	31 c0                	xor    %eax,%eax
  80234a:	39 eb                	cmp    %ebp,%ebx
  80234c:	77 a9                	ja     8022f7 <__udivdi3+0x27>
  80234e:	b8 01 00 00 00       	mov    $0x1,%eax
  802353:	eb a2                	jmp    8022f7 <__udivdi3+0x27>
  802355:	8d 76 00             	lea    0x0(%esi),%esi
  802358:	31 ff                	xor    %edi,%edi
  80235a:	31 c0                	xor    %eax,%eax
  80235c:	89 fa                	mov    %edi,%edx
  80235e:	83 c4 1c             	add    $0x1c,%esp
  802361:	5b                   	pop    %ebx
  802362:	5e                   	pop    %esi
  802363:	5f                   	pop    %edi
  802364:	5d                   	pop    %ebp
  802365:	c3                   	ret    
  802366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80236d:	8d 76 00             	lea    0x0(%esi),%esi
  802370:	89 f9                	mov    %edi,%ecx
  802372:	b8 20 00 00 00       	mov    $0x20,%eax
  802377:	29 f8                	sub    %edi,%eax
  802379:	d3 e2                	shl    %cl,%edx
  80237b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80237f:	89 c1                	mov    %eax,%ecx
  802381:	89 da                	mov    %ebx,%edx
  802383:	d3 ea                	shr    %cl,%edx
  802385:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802389:	09 d1                	or     %edx,%ecx
  80238b:	89 f2                	mov    %esi,%edx
  80238d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802391:	89 f9                	mov    %edi,%ecx
  802393:	d3 e3                	shl    %cl,%ebx
  802395:	89 c1                	mov    %eax,%ecx
  802397:	d3 ea                	shr    %cl,%edx
  802399:	89 f9                	mov    %edi,%ecx
  80239b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80239f:	89 eb                	mov    %ebp,%ebx
  8023a1:	d3 e6                	shl    %cl,%esi
  8023a3:	89 c1                	mov    %eax,%ecx
  8023a5:	d3 eb                	shr    %cl,%ebx
  8023a7:	09 de                	or     %ebx,%esi
  8023a9:	89 f0                	mov    %esi,%eax
  8023ab:	f7 74 24 08          	divl   0x8(%esp)
  8023af:	89 d6                	mov    %edx,%esi
  8023b1:	89 c3                	mov    %eax,%ebx
  8023b3:	f7 64 24 0c          	mull   0xc(%esp)
  8023b7:	39 d6                	cmp    %edx,%esi
  8023b9:	72 15                	jb     8023d0 <__udivdi3+0x100>
  8023bb:	89 f9                	mov    %edi,%ecx
  8023bd:	d3 e5                	shl    %cl,%ebp
  8023bf:	39 c5                	cmp    %eax,%ebp
  8023c1:	73 04                	jae    8023c7 <__udivdi3+0xf7>
  8023c3:	39 d6                	cmp    %edx,%esi
  8023c5:	74 09                	je     8023d0 <__udivdi3+0x100>
  8023c7:	89 d8                	mov    %ebx,%eax
  8023c9:	31 ff                	xor    %edi,%edi
  8023cb:	e9 27 ff ff ff       	jmp    8022f7 <__udivdi3+0x27>
  8023d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023d3:	31 ff                	xor    %edi,%edi
  8023d5:	e9 1d ff ff ff       	jmp    8022f7 <__udivdi3+0x27>
  8023da:	66 90                	xchg   %ax,%ax
  8023dc:	66 90                	xchg   %ax,%ax
  8023de:	66 90                	xchg   %ax,%ax

008023e0 <__umoddi3>:
  8023e0:	55                   	push   %ebp
  8023e1:	57                   	push   %edi
  8023e2:	56                   	push   %esi
  8023e3:	53                   	push   %ebx
  8023e4:	83 ec 1c             	sub    $0x1c,%esp
  8023e7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8023eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023f7:	89 da                	mov    %ebx,%edx
  8023f9:	85 c0                	test   %eax,%eax
  8023fb:	75 43                	jne    802440 <__umoddi3+0x60>
  8023fd:	39 df                	cmp    %ebx,%edi
  8023ff:	76 17                	jbe    802418 <__umoddi3+0x38>
  802401:	89 f0                	mov    %esi,%eax
  802403:	f7 f7                	div    %edi
  802405:	89 d0                	mov    %edx,%eax
  802407:	31 d2                	xor    %edx,%edx
  802409:	83 c4 1c             	add    $0x1c,%esp
  80240c:	5b                   	pop    %ebx
  80240d:	5e                   	pop    %esi
  80240e:	5f                   	pop    %edi
  80240f:	5d                   	pop    %ebp
  802410:	c3                   	ret    
  802411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802418:	89 fd                	mov    %edi,%ebp
  80241a:	85 ff                	test   %edi,%edi
  80241c:	75 0b                	jne    802429 <__umoddi3+0x49>
  80241e:	b8 01 00 00 00       	mov    $0x1,%eax
  802423:	31 d2                	xor    %edx,%edx
  802425:	f7 f7                	div    %edi
  802427:	89 c5                	mov    %eax,%ebp
  802429:	89 d8                	mov    %ebx,%eax
  80242b:	31 d2                	xor    %edx,%edx
  80242d:	f7 f5                	div    %ebp
  80242f:	89 f0                	mov    %esi,%eax
  802431:	f7 f5                	div    %ebp
  802433:	89 d0                	mov    %edx,%eax
  802435:	eb d0                	jmp    802407 <__umoddi3+0x27>
  802437:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80243e:	66 90                	xchg   %ax,%ax
  802440:	89 f1                	mov    %esi,%ecx
  802442:	39 d8                	cmp    %ebx,%eax
  802444:	76 0a                	jbe    802450 <__umoddi3+0x70>
  802446:	89 f0                	mov    %esi,%eax
  802448:	83 c4 1c             	add    $0x1c,%esp
  80244b:	5b                   	pop    %ebx
  80244c:	5e                   	pop    %esi
  80244d:	5f                   	pop    %edi
  80244e:	5d                   	pop    %ebp
  80244f:	c3                   	ret    
  802450:	0f bd e8             	bsr    %eax,%ebp
  802453:	83 f5 1f             	xor    $0x1f,%ebp
  802456:	75 20                	jne    802478 <__umoddi3+0x98>
  802458:	39 d8                	cmp    %ebx,%eax
  80245a:	0f 82 b0 00 00 00    	jb     802510 <__umoddi3+0x130>
  802460:	39 f7                	cmp    %esi,%edi
  802462:	0f 86 a8 00 00 00    	jbe    802510 <__umoddi3+0x130>
  802468:	89 c8                	mov    %ecx,%eax
  80246a:	83 c4 1c             	add    $0x1c,%esp
  80246d:	5b                   	pop    %ebx
  80246e:	5e                   	pop    %esi
  80246f:	5f                   	pop    %edi
  802470:	5d                   	pop    %ebp
  802471:	c3                   	ret    
  802472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802478:	89 e9                	mov    %ebp,%ecx
  80247a:	ba 20 00 00 00       	mov    $0x20,%edx
  80247f:	29 ea                	sub    %ebp,%edx
  802481:	d3 e0                	shl    %cl,%eax
  802483:	89 44 24 08          	mov    %eax,0x8(%esp)
  802487:	89 d1                	mov    %edx,%ecx
  802489:	89 f8                	mov    %edi,%eax
  80248b:	d3 e8                	shr    %cl,%eax
  80248d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802491:	89 54 24 04          	mov    %edx,0x4(%esp)
  802495:	8b 54 24 04          	mov    0x4(%esp),%edx
  802499:	09 c1                	or     %eax,%ecx
  80249b:	89 d8                	mov    %ebx,%eax
  80249d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024a1:	89 e9                	mov    %ebp,%ecx
  8024a3:	d3 e7                	shl    %cl,%edi
  8024a5:	89 d1                	mov    %edx,%ecx
  8024a7:	d3 e8                	shr    %cl,%eax
  8024a9:	89 e9                	mov    %ebp,%ecx
  8024ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024af:	d3 e3                	shl    %cl,%ebx
  8024b1:	89 c7                	mov    %eax,%edi
  8024b3:	89 d1                	mov    %edx,%ecx
  8024b5:	89 f0                	mov    %esi,%eax
  8024b7:	d3 e8                	shr    %cl,%eax
  8024b9:	89 e9                	mov    %ebp,%ecx
  8024bb:	89 fa                	mov    %edi,%edx
  8024bd:	d3 e6                	shl    %cl,%esi
  8024bf:	09 d8                	or     %ebx,%eax
  8024c1:	f7 74 24 08          	divl   0x8(%esp)
  8024c5:	89 d1                	mov    %edx,%ecx
  8024c7:	89 f3                	mov    %esi,%ebx
  8024c9:	f7 64 24 0c          	mull   0xc(%esp)
  8024cd:	89 c6                	mov    %eax,%esi
  8024cf:	89 d7                	mov    %edx,%edi
  8024d1:	39 d1                	cmp    %edx,%ecx
  8024d3:	72 06                	jb     8024db <__umoddi3+0xfb>
  8024d5:	75 10                	jne    8024e7 <__umoddi3+0x107>
  8024d7:	39 c3                	cmp    %eax,%ebx
  8024d9:	73 0c                	jae    8024e7 <__umoddi3+0x107>
  8024db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8024e3:	89 d7                	mov    %edx,%edi
  8024e5:	89 c6                	mov    %eax,%esi
  8024e7:	89 ca                	mov    %ecx,%edx
  8024e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024ee:	29 f3                	sub    %esi,%ebx
  8024f0:	19 fa                	sbb    %edi,%edx
  8024f2:	89 d0                	mov    %edx,%eax
  8024f4:	d3 e0                	shl    %cl,%eax
  8024f6:	89 e9                	mov    %ebp,%ecx
  8024f8:	d3 eb                	shr    %cl,%ebx
  8024fa:	d3 ea                	shr    %cl,%edx
  8024fc:	09 d8                	or     %ebx,%eax
  8024fe:	83 c4 1c             	add    $0x1c,%esp
  802501:	5b                   	pop    %ebx
  802502:	5e                   	pop    %esi
  802503:	5f                   	pop    %edi
  802504:	5d                   	pop    %ebp
  802505:	c3                   	ret    
  802506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80250d:	8d 76 00             	lea    0x0(%esi),%esi
  802510:	89 da                	mov    %ebx,%edx
  802512:	29 fe                	sub    %edi,%esi
  802514:	19 c2                	sbb    %eax,%edx
  802516:	89 f1                	mov    %esi,%ecx
  802518:	89 c8                	mov    %ecx,%eax
  80251a:	e9 4b ff ff ff       	jmp    80246a <__umoddi3+0x8a>
