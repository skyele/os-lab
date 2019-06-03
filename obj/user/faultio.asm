
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
	cprintf("in %s\n", __FUNCTION__);//just test
  800039:	68 68 25 80 00       	push   $0x802568
  80003e:	68 5b 2a 80 00       	push   $0x802a5b
  800043:	e8 8c 01 00 00       	call   8001d4 <cprintf>

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
  800062:	68 4e 25 80 00       	push   $0x80254e
  800067:	e8 68 01 00 00       	call   8001d4 <cprintf>
}
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	c9                   	leave  
  800070:	c3                   	ret    
		cprintf("eflags wrong\n");
  800071:	83 ec 0c             	sub    $0xc,%esp
  800074:	68 40 25 80 00       	push   $0x802540
  800079:	e8 56 01 00 00       	call   8001d4 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp
  800081:	eb d1                	jmp    800054 <umain+0x21>

00800083 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800083:	55                   	push   %ebp
  800084:	89 e5                	mov    %esp,%ebp
  800086:	57                   	push   %edi
  800087:	56                   	push   %esi
  800088:	53                   	push   %ebx
  800089:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80008c:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800093:	00 00 00 
	envid_t find = sys_getenvid();
  800096:	e8 4c 0c 00 00       	call   800ce7 <sys_getenvid>
  80009b:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  8000a1:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8000a6:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8000ab:	bf 01 00 00 00       	mov    $0x1,%edi
  8000b0:	eb 0b                	jmp    8000bd <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8000b2:	83 c2 01             	add    $0x1,%edx
  8000b5:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000bb:	74 21                	je     8000de <libmain+0x5b>
		if(envs[i].env_id == find)
  8000bd:	89 d1                	mov    %edx,%ecx
  8000bf:	c1 e1 07             	shl    $0x7,%ecx
  8000c2:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000c8:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000cb:	39 c1                	cmp    %eax,%ecx
  8000cd:	75 e3                	jne    8000b2 <libmain+0x2f>
  8000cf:	89 d3                	mov    %edx,%ebx
  8000d1:	c1 e3 07             	shl    $0x7,%ebx
  8000d4:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000da:	89 fe                	mov    %edi,%esi
  8000dc:	eb d4                	jmp    8000b2 <libmain+0x2f>
  8000de:	89 f0                	mov    %esi,%eax
  8000e0:	84 c0                	test   %al,%al
  8000e2:	74 06                	je     8000ea <libmain+0x67>
  8000e4:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000ee:	7e 0a                	jle    8000fa <libmain+0x77>
		binaryname = argv[0];
  8000f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000f3:	8b 00                	mov    (%eax),%eax
  8000f5:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("call umain!\n");
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	68 6e 25 80 00       	push   $0x80256e
  800102:	e8 cd 00 00 00       	call   8001d4 <cprintf>
	// call user main routine
	umain(argc, argv);
  800107:	83 c4 08             	add    $0x8,%esp
  80010a:	ff 75 0c             	pushl  0xc(%ebp)
  80010d:	ff 75 08             	pushl  0x8(%ebp)
  800110:	e8 1e ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800115:	e8 0b 00 00 00       	call   800125 <exit>
}
  80011a:	83 c4 10             	add    $0x10,%esp
  80011d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800120:	5b                   	pop    %ebx
  800121:	5e                   	pop    %esi
  800122:	5f                   	pop    %edi
  800123:	5d                   	pop    %ebp
  800124:	c3                   	ret    

00800125 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800125:	55                   	push   %ebp
  800126:	89 e5                	mov    %esp,%ebp
  800128:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80012b:	e8 a2 10 00 00       	call   8011d2 <close_all>
	sys_env_destroy(0);
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	6a 00                	push   $0x0
  800135:	e8 6c 0b 00 00       	call   800ca6 <sys_env_destroy>
}
  80013a:	83 c4 10             	add    $0x10,%esp
  80013d:	c9                   	leave  
  80013e:	c3                   	ret    

0080013f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80013f:	55                   	push   %ebp
  800140:	89 e5                	mov    %esp,%ebp
  800142:	53                   	push   %ebx
  800143:	83 ec 04             	sub    $0x4,%esp
  800146:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800149:	8b 13                	mov    (%ebx),%edx
  80014b:	8d 42 01             	lea    0x1(%edx),%eax
  80014e:	89 03                	mov    %eax,(%ebx)
  800150:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800153:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800157:	3d ff 00 00 00       	cmp    $0xff,%eax
  80015c:	74 09                	je     800167 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80015e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800162:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800165:	c9                   	leave  
  800166:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800167:	83 ec 08             	sub    $0x8,%esp
  80016a:	68 ff 00 00 00       	push   $0xff
  80016f:	8d 43 08             	lea    0x8(%ebx),%eax
  800172:	50                   	push   %eax
  800173:	e8 f1 0a 00 00       	call   800c69 <sys_cputs>
		b->idx = 0;
  800178:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80017e:	83 c4 10             	add    $0x10,%esp
  800181:	eb db                	jmp    80015e <putch+0x1f>

00800183 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800183:	55                   	push   %ebp
  800184:	89 e5                	mov    %esp,%ebp
  800186:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80018c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800193:	00 00 00 
	b.cnt = 0;
  800196:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80019d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001a0:	ff 75 0c             	pushl  0xc(%ebp)
  8001a3:	ff 75 08             	pushl  0x8(%ebp)
  8001a6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001ac:	50                   	push   %eax
  8001ad:	68 3f 01 80 00       	push   $0x80013f
  8001b2:	e8 4a 01 00 00       	call   800301 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001b7:	83 c4 08             	add    $0x8,%esp
  8001ba:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001c0:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001c6:	50                   	push   %eax
  8001c7:	e8 9d 0a 00 00       	call   800c69 <sys_cputs>

	return b.cnt;
}
  8001cc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001d2:	c9                   	leave  
  8001d3:	c3                   	ret    

008001d4 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001d4:	55                   	push   %ebp
  8001d5:	89 e5                	mov    %esp,%ebp
  8001d7:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001da:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001dd:	50                   	push   %eax
  8001de:	ff 75 08             	pushl  0x8(%ebp)
  8001e1:	e8 9d ff ff ff       	call   800183 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001e6:	c9                   	leave  
  8001e7:	c3                   	ret    

008001e8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001e8:	55                   	push   %ebp
  8001e9:	89 e5                	mov    %esp,%ebp
  8001eb:	57                   	push   %edi
  8001ec:	56                   	push   %esi
  8001ed:	53                   	push   %ebx
  8001ee:	83 ec 1c             	sub    $0x1c,%esp
  8001f1:	89 c6                	mov    %eax,%esi
  8001f3:	89 d7                	mov    %edx,%edi
  8001f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001fe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800201:	8b 45 10             	mov    0x10(%ebp),%eax
  800204:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800207:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80020b:	74 2c                	je     800239 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80020d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800210:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800217:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80021a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80021d:	39 c2                	cmp    %eax,%edx
  80021f:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800222:	73 43                	jae    800267 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800224:	83 eb 01             	sub    $0x1,%ebx
  800227:	85 db                	test   %ebx,%ebx
  800229:	7e 6c                	jle    800297 <printnum+0xaf>
				putch(padc, putdat);
  80022b:	83 ec 08             	sub    $0x8,%esp
  80022e:	57                   	push   %edi
  80022f:	ff 75 18             	pushl  0x18(%ebp)
  800232:	ff d6                	call   *%esi
  800234:	83 c4 10             	add    $0x10,%esp
  800237:	eb eb                	jmp    800224 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800239:	83 ec 0c             	sub    $0xc,%esp
  80023c:	6a 20                	push   $0x20
  80023e:	6a 00                	push   $0x0
  800240:	50                   	push   %eax
  800241:	ff 75 e4             	pushl  -0x1c(%ebp)
  800244:	ff 75 e0             	pushl  -0x20(%ebp)
  800247:	89 fa                	mov    %edi,%edx
  800249:	89 f0                	mov    %esi,%eax
  80024b:	e8 98 ff ff ff       	call   8001e8 <printnum>
		while (--width > 0)
  800250:	83 c4 20             	add    $0x20,%esp
  800253:	83 eb 01             	sub    $0x1,%ebx
  800256:	85 db                	test   %ebx,%ebx
  800258:	7e 65                	jle    8002bf <printnum+0xd7>
			putch(padc, putdat);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	57                   	push   %edi
  80025e:	6a 20                	push   $0x20
  800260:	ff d6                	call   *%esi
  800262:	83 c4 10             	add    $0x10,%esp
  800265:	eb ec                	jmp    800253 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	ff 75 18             	pushl  0x18(%ebp)
  80026d:	83 eb 01             	sub    $0x1,%ebx
  800270:	53                   	push   %ebx
  800271:	50                   	push   %eax
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	ff 75 dc             	pushl  -0x24(%ebp)
  800278:	ff 75 d8             	pushl  -0x28(%ebp)
  80027b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027e:	ff 75 e0             	pushl  -0x20(%ebp)
  800281:	e8 6a 20 00 00       	call   8022f0 <__udivdi3>
  800286:	83 c4 18             	add    $0x18,%esp
  800289:	52                   	push   %edx
  80028a:	50                   	push   %eax
  80028b:	89 fa                	mov    %edi,%edx
  80028d:	89 f0                	mov    %esi,%eax
  80028f:	e8 54 ff ff ff       	call   8001e8 <printnum>
  800294:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800297:	83 ec 08             	sub    $0x8,%esp
  80029a:	57                   	push   %edi
  80029b:	83 ec 04             	sub    $0x4,%esp
  80029e:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a1:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a7:	ff 75 e0             	pushl  -0x20(%ebp)
  8002aa:	e8 51 21 00 00       	call   802400 <__umoddi3>
  8002af:	83 c4 14             	add    $0x14,%esp
  8002b2:	0f be 80 85 25 80 00 	movsbl 0x802585(%eax),%eax
  8002b9:	50                   	push   %eax
  8002ba:	ff d6                	call   *%esi
  8002bc:	83 c4 10             	add    $0x10,%esp
	}
}
  8002bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c2:	5b                   	pop    %ebx
  8002c3:	5e                   	pop    %esi
  8002c4:	5f                   	pop    %edi
  8002c5:	5d                   	pop    %ebp
  8002c6:	c3                   	ret    

008002c7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002c7:	55                   	push   %ebp
  8002c8:	89 e5                	mov    %esp,%ebp
  8002ca:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002cd:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002d1:	8b 10                	mov    (%eax),%edx
  8002d3:	3b 50 04             	cmp    0x4(%eax),%edx
  8002d6:	73 0a                	jae    8002e2 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002d8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002db:	89 08                	mov    %ecx,(%eax)
  8002dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e0:	88 02                	mov    %al,(%edx)
}
  8002e2:	5d                   	pop    %ebp
  8002e3:	c3                   	ret    

008002e4 <printfmt>:
{
  8002e4:	55                   	push   %ebp
  8002e5:	89 e5                	mov    %esp,%ebp
  8002e7:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002ea:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002ed:	50                   	push   %eax
  8002ee:	ff 75 10             	pushl  0x10(%ebp)
  8002f1:	ff 75 0c             	pushl  0xc(%ebp)
  8002f4:	ff 75 08             	pushl  0x8(%ebp)
  8002f7:	e8 05 00 00 00       	call   800301 <vprintfmt>
}
  8002fc:	83 c4 10             	add    $0x10,%esp
  8002ff:	c9                   	leave  
  800300:	c3                   	ret    

00800301 <vprintfmt>:
{
  800301:	55                   	push   %ebp
  800302:	89 e5                	mov    %esp,%ebp
  800304:	57                   	push   %edi
  800305:	56                   	push   %esi
  800306:	53                   	push   %ebx
  800307:	83 ec 3c             	sub    $0x3c,%esp
  80030a:	8b 75 08             	mov    0x8(%ebp),%esi
  80030d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800310:	8b 7d 10             	mov    0x10(%ebp),%edi
  800313:	e9 32 04 00 00       	jmp    80074a <vprintfmt+0x449>
		padc = ' ';
  800318:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80031c:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800323:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80032a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800331:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800338:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80033f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800344:	8d 47 01             	lea    0x1(%edi),%eax
  800347:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80034a:	0f b6 17             	movzbl (%edi),%edx
  80034d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800350:	3c 55                	cmp    $0x55,%al
  800352:	0f 87 12 05 00 00    	ja     80086a <vprintfmt+0x569>
  800358:	0f b6 c0             	movzbl %al,%eax
  80035b:	ff 24 85 60 27 80 00 	jmp    *0x802760(,%eax,4)
  800362:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800365:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800369:	eb d9                	jmp    800344 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80036b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80036e:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800372:	eb d0                	jmp    800344 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800374:	0f b6 d2             	movzbl %dl,%edx
  800377:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80037a:	b8 00 00 00 00       	mov    $0x0,%eax
  80037f:	89 75 08             	mov    %esi,0x8(%ebp)
  800382:	eb 03                	jmp    800387 <vprintfmt+0x86>
  800384:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800387:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80038a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80038e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800391:	8d 72 d0             	lea    -0x30(%edx),%esi
  800394:	83 fe 09             	cmp    $0x9,%esi
  800397:	76 eb                	jbe    800384 <vprintfmt+0x83>
  800399:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80039c:	8b 75 08             	mov    0x8(%ebp),%esi
  80039f:	eb 14                	jmp    8003b5 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a4:	8b 00                	mov    (%eax),%eax
  8003a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ac:	8d 40 04             	lea    0x4(%eax),%eax
  8003af:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003b9:	79 89                	jns    800344 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003c1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003c8:	e9 77 ff ff ff       	jmp    800344 <vprintfmt+0x43>
  8003cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d0:	85 c0                	test   %eax,%eax
  8003d2:	0f 48 c1             	cmovs  %ecx,%eax
  8003d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003db:	e9 64 ff ff ff       	jmp    800344 <vprintfmt+0x43>
  8003e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003e3:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003ea:	e9 55 ff ff ff       	jmp    800344 <vprintfmt+0x43>
			lflag++;
  8003ef:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003f6:	e9 49 ff ff ff       	jmp    800344 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fe:	8d 78 04             	lea    0x4(%eax),%edi
  800401:	83 ec 08             	sub    $0x8,%esp
  800404:	53                   	push   %ebx
  800405:	ff 30                	pushl  (%eax)
  800407:	ff d6                	call   *%esi
			break;
  800409:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80040c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80040f:	e9 33 03 00 00       	jmp    800747 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800414:	8b 45 14             	mov    0x14(%ebp),%eax
  800417:	8d 78 04             	lea    0x4(%eax),%edi
  80041a:	8b 00                	mov    (%eax),%eax
  80041c:	99                   	cltd   
  80041d:	31 d0                	xor    %edx,%eax
  80041f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800421:	83 f8 10             	cmp    $0x10,%eax
  800424:	7f 23                	jg     800449 <vprintfmt+0x148>
  800426:	8b 14 85 c0 28 80 00 	mov    0x8028c0(,%eax,4),%edx
  80042d:	85 d2                	test   %edx,%edx
  80042f:	74 18                	je     800449 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800431:	52                   	push   %edx
  800432:	68 d9 29 80 00       	push   $0x8029d9
  800437:	53                   	push   %ebx
  800438:	56                   	push   %esi
  800439:	e8 a6 fe ff ff       	call   8002e4 <printfmt>
  80043e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800441:	89 7d 14             	mov    %edi,0x14(%ebp)
  800444:	e9 fe 02 00 00       	jmp    800747 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800449:	50                   	push   %eax
  80044a:	68 9d 25 80 00       	push   $0x80259d
  80044f:	53                   	push   %ebx
  800450:	56                   	push   %esi
  800451:	e8 8e fe ff ff       	call   8002e4 <printfmt>
  800456:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800459:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80045c:	e9 e6 02 00 00       	jmp    800747 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800461:	8b 45 14             	mov    0x14(%ebp),%eax
  800464:	83 c0 04             	add    $0x4,%eax
  800467:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80046a:	8b 45 14             	mov    0x14(%ebp),%eax
  80046d:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80046f:	85 c9                	test   %ecx,%ecx
  800471:	b8 96 25 80 00       	mov    $0x802596,%eax
  800476:	0f 45 c1             	cmovne %ecx,%eax
  800479:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80047c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800480:	7e 06                	jle    800488 <vprintfmt+0x187>
  800482:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800486:	75 0d                	jne    800495 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800488:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80048b:	89 c7                	mov    %eax,%edi
  80048d:	03 45 e0             	add    -0x20(%ebp),%eax
  800490:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800493:	eb 53                	jmp    8004e8 <vprintfmt+0x1e7>
  800495:	83 ec 08             	sub    $0x8,%esp
  800498:	ff 75 d8             	pushl  -0x28(%ebp)
  80049b:	50                   	push   %eax
  80049c:	e8 71 04 00 00       	call   800912 <strnlen>
  8004a1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004a4:	29 c1                	sub    %eax,%ecx
  8004a6:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004a9:	83 c4 10             	add    $0x10,%esp
  8004ac:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004ae:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b5:	eb 0f                	jmp    8004c6 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004b7:	83 ec 08             	sub    $0x8,%esp
  8004ba:	53                   	push   %ebx
  8004bb:	ff 75 e0             	pushl  -0x20(%ebp)
  8004be:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c0:	83 ef 01             	sub    $0x1,%edi
  8004c3:	83 c4 10             	add    $0x10,%esp
  8004c6:	85 ff                	test   %edi,%edi
  8004c8:	7f ed                	jg     8004b7 <vprintfmt+0x1b6>
  8004ca:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004cd:	85 c9                	test   %ecx,%ecx
  8004cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d4:	0f 49 c1             	cmovns %ecx,%eax
  8004d7:	29 c1                	sub    %eax,%ecx
  8004d9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004dc:	eb aa                	jmp    800488 <vprintfmt+0x187>
					putch(ch, putdat);
  8004de:	83 ec 08             	sub    $0x8,%esp
  8004e1:	53                   	push   %ebx
  8004e2:	52                   	push   %edx
  8004e3:	ff d6                	call   *%esi
  8004e5:	83 c4 10             	add    $0x10,%esp
  8004e8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004eb:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004ed:	83 c7 01             	add    $0x1,%edi
  8004f0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004f4:	0f be d0             	movsbl %al,%edx
  8004f7:	85 d2                	test   %edx,%edx
  8004f9:	74 4b                	je     800546 <vprintfmt+0x245>
  8004fb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004ff:	78 06                	js     800507 <vprintfmt+0x206>
  800501:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800505:	78 1e                	js     800525 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800507:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80050b:	74 d1                	je     8004de <vprintfmt+0x1dd>
  80050d:	0f be c0             	movsbl %al,%eax
  800510:	83 e8 20             	sub    $0x20,%eax
  800513:	83 f8 5e             	cmp    $0x5e,%eax
  800516:	76 c6                	jbe    8004de <vprintfmt+0x1dd>
					putch('?', putdat);
  800518:	83 ec 08             	sub    $0x8,%esp
  80051b:	53                   	push   %ebx
  80051c:	6a 3f                	push   $0x3f
  80051e:	ff d6                	call   *%esi
  800520:	83 c4 10             	add    $0x10,%esp
  800523:	eb c3                	jmp    8004e8 <vprintfmt+0x1e7>
  800525:	89 cf                	mov    %ecx,%edi
  800527:	eb 0e                	jmp    800537 <vprintfmt+0x236>
				putch(' ', putdat);
  800529:	83 ec 08             	sub    $0x8,%esp
  80052c:	53                   	push   %ebx
  80052d:	6a 20                	push   $0x20
  80052f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800531:	83 ef 01             	sub    $0x1,%edi
  800534:	83 c4 10             	add    $0x10,%esp
  800537:	85 ff                	test   %edi,%edi
  800539:	7f ee                	jg     800529 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80053b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80053e:	89 45 14             	mov    %eax,0x14(%ebp)
  800541:	e9 01 02 00 00       	jmp    800747 <vprintfmt+0x446>
  800546:	89 cf                	mov    %ecx,%edi
  800548:	eb ed                	jmp    800537 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80054a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80054d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800554:	e9 eb fd ff ff       	jmp    800344 <vprintfmt+0x43>
	if (lflag >= 2)
  800559:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80055d:	7f 21                	jg     800580 <vprintfmt+0x27f>
	else if (lflag)
  80055f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800563:	74 68                	je     8005cd <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800565:	8b 45 14             	mov    0x14(%ebp),%eax
  800568:	8b 00                	mov    (%eax),%eax
  80056a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80056d:	89 c1                	mov    %eax,%ecx
  80056f:	c1 f9 1f             	sar    $0x1f,%ecx
  800572:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800575:	8b 45 14             	mov    0x14(%ebp),%eax
  800578:	8d 40 04             	lea    0x4(%eax),%eax
  80057b:	89 45 14             	mov    %eax,0x14(%ebp)
  80057e:	eb 17                	jmp    800597 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800580:	8b 45 14             	mov    0x14(%ebp),%eax
  800583:	8b 50 04             	mov    0x4(%eax),%edx
  800586:	8b 00                	mov    (%eax),%eax
  800588:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80058b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80058e:	8b 45 14             	mov    0x14(%ebp),%eax
  800591:	8d 40 08             	lea    0x8(%eax),%eax
  800594:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800597:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80059a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80059d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005a3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005a7:	78 3f                	js     8005e8 <vprintfmt+0x2e7>
			base = 10;
  8005a9:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005ae:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005b2:	0f 84 71 01 00 00    	je     800729 <vprintfmt+0x428>
				putch('+', putdat);
  8005b8:	83 ec 08             	sub    $0x8,%esp
  8005bb:	53                   	push   %ebx
  8005bc:	6a 2b                	push   $0x2b
  8005be:	ff d6                	call   *%esi
  8005c0:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005c3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c8:	e9 5c 01 00 00       	jmp    800729 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005d5:	89 c1                	mov    %eax,%ecx
  8005d7:	c1 f9 1f             	sar    $0x1f,%ecx
  8005da:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	8d 40 04             	lea    0x4(%eax),%eax
  8005e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e6:	eb af                	jmp    800597 <vprintfmt+0x296>
				putch('-', putdat);
  8005e8:	83 ec 08             	sub    $0x8,%esp
  8005eb:	53                   	push   %ebx
  8005ec:	6a 2d                	push   $0x2d
  8005ee:	ff d6                	call   *%esi
				num = -(long long) num;
  8005f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005f3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005f6:	f7 d8                	neg    %eax
  8005f8:	83 d2 00             	adc    $0x0,%edx
  8005fb:	f7 da                	neg    %edx
  8005fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800600:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800603:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800606:	b8 0a 00 00 00       	mov    $0xa,%eax
  80060b:	e9 19 01 00 00       	jmp    800729 <vprintfmt+0x428>
	if (lflag >= 2)
  800610:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800614:	7f 29                	jg     80063f <vprintfmt+0x33e>
	else if (lflag)
  800616:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80061a:	74 44                	je     800660 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80061c:	8b 45 14             	mov    0x14(%ebp),%eax
  80061f:	8b 00                	mov    (%eax),%eax
  800621:	ba 00 00 00 00       	mov    $0x0,%edx
  800626:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800629:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80062c:	8b 45 14             	mov    0x14(%ebp),%eax
  80062f:	8d 40 04             	lea    0x4(%eax),%eax
  800632:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800635:	b8 0a 00 00 00       	mov    $0xa,%eax
  80063a:	e9 ea 00 00 00       	jmp    800729 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8b 50 04             	mov    0x4(%eax),%edx
  800645:	8b 00                	mov    (%eax),%eax
  800647:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064d:	8b 45 14             	mov    0x14(%ebp),%eax
  800650:	8d 40 08             	lea    0x8(%eax),%eax
  800653:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800656:	b8 0a 00 00 00       	mov    $0xa,%eax
  80065b:	e9 c9 00 00 00       	jmp    800729 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	ba 00 00 00 00       	mov    $0x0,%edx
  80066a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8d 40 04             	lea    0x4(%eax),%eax
  800676:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800679:	b8 0a 00 00 00       	mov    $0xa,%eax
  80067e:	e9 a6 00 00 00       	jmp    800729 <vprintfmt+0x428>
			putch('0', putdat);
  800683:	83 ec 08             	sub    $0x8,%esp
  800686:	53                   	push   %ebx
  800687:	6a 30                	push   $0x30
  800689:	ff d6                	call   *%esi
	if (lflag >= 2)
  80068b:	83 c4 10             	add    $0x10,%esp
  80068e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800692:	7f 26                	jg     8006ba <vprintfmt+0x3b9>
	else if (lflag)
  800694:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800698:	74 3e                	je     8006d8 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	8d 40 04             	lea    0x4(%eax),%eax
  8006b0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006b3:	b8 08 00 00 00       	mov    $0x8,%eax
  8006b8:	eb 6f                	jmp    800729 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bd:	8b 50 04             	mov    0x4(%eax),%edx
  8006c0:	8b 00                	mov    (%eax),%eax
  8006c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	8d 40 08             	lea    0x8(%eax),%eax
  8006ce:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006d1:	b8 08 00 00 00       	mov    $0x8,%eax
  8006d6:	eb 51                	jmp    800729 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006eb:	8d 40 04             	lea    0x4(%eax),%eax
  8006ee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006f1:	b8 08 00 00 00       	mov    $0x8,%eax
  8006f6:	eb 31                	jmp    800729 <vprintfmt+0x428>
			putch('0', putdat);
  8006f8:	83 ec 08             	sub    $0x8,%esp
  8006fb:	53                   	push   %ebx
  8006fc:	6a 30                	push   $0x30
  8006fe:	ff d6                	call   *%esi
			putch('x', putdat);
  800700:	83 c4 08             	add    $0x8,%esp
  800703:	53                   	push   %ebx
  800704:	6a 78                	push   $0x78
  800706:	ff d6                	call   *%esi
			num = (unsigned long long)
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	ba 00 00 00 00       	mov    $0x0,%edx
  800712:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800715:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800718:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80071b:	8b 45 14             	mov    0x14(%ebp),%eax
  80071e:	8d 40 04             	lea    0x4(%eax),%eax
  800721:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800724:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800729:	83 ec 0c             	sub    $0xc,%esp
  80072c:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800730:	52                   	push   %edx
  800731:	ff 75 e0             	pushl  -0x20(%ebp)
  800734:	50                   	push   %eax
  800735:	ff 75 dc             	pushl  -0x24(%ebp)
  800738:	ff 75 d8             	pushl  -0x28(%ebp)
  80073b:	89 da                	mov    %ebx,%edx
  80073d:	89 f0                	mov    %esi,%eax
  80073f:	e8 a4 fa ff ff       	call   8001e8 <printnum>
			break;
  800744:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800747:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80074a:	83 c7 01             	add    $0x1,%edi
  80074d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800751:	83 f8 25             	cmp    $0x25,%eax
  800754:	0f 84 be fb ff ff    	je     800318 <vprintfmt+0x17>
			if (ch == '\0')
  80075a:	85 c0                	test   %eax,%eax
  80075c:	0f 84 28 01 00 00    	je     80088a <vprintfmt+0x589>
			putch(ch, putdat);
  800762:	83 ec 08             	sub    $0x8,%esp
  800765:	53                   	push   %ebx
  800766:	50                   	push   %eax
  800767:	ff d6                	call   *%esi
  800769:	83 c4 10             	add    $0x10,%esp
  80076c:	eb dc                	jmp    80074a <vprintfmt+0x449>
	if (lflag >= 2)
  80076e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800772:	7f 26                	jg     80079a <vprintfmt+0x499>
	else if (lflag)
  800774:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800778:	74 41                	je     8007bb <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	ba 00 00 00 00       	mov    $0x0,%edx
  800784:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800787:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078a:	8b 45 14             	mov    0x14(%ebp),%eax
  80078d:	8d 40 04             	lea    0x4(%eax),%eax
  800790:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800793:	b8 10 00 00 00       	mov    $0x10,%eax
  800798:	eb 8f                	jmp    800729 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80079a:	8b 45 14             	mov    0x14(%ebp),%eax
  80079d:	8b 50 04             	mov    0x4(%eax),%edx
  8007a0:	8b 00                	mov    (%eax),%eax
  8007a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ab:	8d 40 08             	lea    0x8(%eax),%eax
  8007ae:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b1:	b8 10 00 00 00       	mov    $0x10,%eax
  8007b6:	e9 6e ff ff ff       	jmp    800729 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ce:	8d 40 04             	lea    0x4(%eax),%eax
  8007d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d4:	b8 10 00 00 00       	mov    $0x10,%eax
  8007d9:	e9 4b ff ff ff       	jmp    800729 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007de:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e1:	83 c0 04             	add    $0x4,%eax
  8007e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ea:	8b 00                	mov    (%eax),%eax
  8007ec:	85 c0                	test   %eax,%eax
  8007ee:	74 14                	je     800804 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007f0:	8b 13                	mov    (%ebx),%edx
  8007f2:	83 fa 7f             	cmp    $0x7f,%edx
  8007f5:	7f 37                	jg     80082e <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007f7:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ff:	e9 43 ff ff ff       	jmp    800747 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800804:	b8 0a 00 00 00       	mov    $0xa,%eax
  800809:	bf b9 26 80 00       	mov    $0x8026b9,%edi
							putch(ch, putdat);
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	53                   	push   %ebx
  800812:	50                   	push   %eax
  800813:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800815:	83 c7 01             	add    $0x1,%edi
  800818:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80081c:	83 c4 10             	add    $0x10,%esp
  80081f:	85 c0                	test   %eax,%eax
  800821:	75 eb                	jne    80080e <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800823:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800826:	89 45 14             	mov    %eax,0x14(%ebp)
  800829:	e9 19 ff ff ff       	jmp    800747 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80082e:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800830:	b8 0a 00 00 00       	mov    $0xa,%eax
  800835:	bf f1 26 80 00       	mov    $0x8026f1,%edi
							putch(ch, putdat);
  80083a:	83 ec 08             	sub    $0x8,%esp
  80083d:	53                   	push   %ebx
  80083e:	50                   	push   %eax
  80083f:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800841:	83 c7 01             	add    $0x1,%edi
  800844:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800848:	83 c4 10             	add    $0x10,%esp
  80084b:	85 c0                	test   %eax,%eax
  80084d:	75 eb                	jne    80083a <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80084f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800852:	89 45 14             	mov    %eax,0x14(%ebp)
  800855:	e9 ed fe ff ff       	jmp    800747 <vprintfmt+0x446>
			putch(ch, putdat);
  80085a:	83 ec 08             	sub    $0x8,%esp
  80085d:	53                   	push   %ebx
  80085e:	6a 25                	push   $0x25
  800860:	ff d6                	call   *%esi
			break;
  800862:	83 c4 10             	add    $0x10,%esp
  800865:	e9 dd fe ff ff       	jmp    800747 <vprintfmt+0x446>
			putch('%', putdat);
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	53                   	push   %ebx
  80086e:	6a 25                	push   $0x25
  800870:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800872:	83 c4 10             	add    $0x10,%esp
  800875:	89 f8                	mov    %edi,%eax
  800877:	eb 03                	jmp    80087c <vprintfmt+0x57b>
  800879:	83 e8 01             	sub    $0x1,%eax
  80087c:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800880:	75 f7                	jne    800879 <vprintfmt+0x578>
  800882:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800885:	e9 bd fe ff ff       	jmp    800747 <vprintfmt+0x446>
}
  80088a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80088d:	5b                   	pop    %ebx
  80088e:	5e                   	pop    %esi
  80088f:	5f                   	pop    %edi
  800890:	5d                   	pop    %ebp
  800891:	c3                   	ret    

00800892 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800892:	55                   	push   %ebp
  800893:	89 e5                	mov    %esp,%ebp
  800895:	83 ec 18             	sub    $0x18,%esp
  800898:	8b 45 08             	mov    0x8(%ebp),%eax
  80089b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80089e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008a1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008a5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008af:	85 c0                	test   %eax,%eax
  8008b1:	74 26                	je     8008d9 <vsnprintf+0x47>
  8008b3:	85 d2                	test   %edx,%edx
  8008b5:	7e 22                	jle    8008d9 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008b7:	ff 75 14             	pushl  0x14(%ebp)
  8008ba:	ff 75 10             	pushl  0x10(%ebp)
  8008bd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008c0:	50                   	push   %eax
  8008c1:	68 c7 02 80 00       	push   $0x8002c7
  8008c6:	e8 36 fa ff ff       	call   800301 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ce:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008d4:	83 c4 10             	add    $0x10,%esp
}
  8008d7:	c9                   	leave  
  8008d8:	c3                   	ret    
		return -E_INVAL;
  8008d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008de:	eb f7                	jmp    8008d7 <vsnprintf+0x45>

008008e0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
  8008e3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008e6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008e9:	50                   	push   %eax
  8008ea:	ff 75 10             	pushl  0x10(%ebp)
  8008ed:	ff 75 0c             	pushl  0xc(%ebp)
  8008f0:	ff 75 08             	pushl  0x8(%ebp)
  8008f3:	e8 9a ff ff ff       	call   800892 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008f8:	c9                   	leave  
  8008f9:	c3                   	ret    

008008fa <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800900:	b8 00 00 00 00       	mov    $0x0,%eax
  800905:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800909:	74 05                	je     800910 <strlen+0x16>
		n++;
  80090b:	83 c0 01             	add    $0x1,%eax
  80090e:	eb f5                	jmp    800905 <strlen+0xb>
	return n;
}
  800910:	5d                   	pop    %ebp
  800911:	c3                   	ret    

00800912 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800918:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80091b:	ba 00 00 00 00       	mov    $0x0,%edx
  800920:	39 c2                	cmp    %eax,%edx
  800922:	74 0d                	je     800931 <strnlen+0x1f>
  800924:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800928:	74 05                	je     80092f <strnlen+0x1d>
		n++;
  80092a:	83 c2 01             	add    $0x1,%edx
  80092d:	eb f1                	jmp    800920 <strnlen+0xe>
  80092f:	89 d0                	mov    %edx,%eax
	return n;
}
  800931:	5d                   	pop    %ebp
  800932:	c3                   	ret    

00800933 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	53                   	push   %ebx
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80093d:	ba 00 00 00 00       	mov    $0x0,%edx
  800942:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800946:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800949:	83 c2 01             	add    $0x1,%edx
  80094c:	84 c9                	test   %cl,%cl
  80094e:	75 f2                	jne    800942 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800950:	5b                   	pop    %ebx
  800951:	5d                   	pop    %ebp
  800952:	c3                   	ret    

00800953 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800953:	55                   	push   %ebp
  800954:	89 e5                	mov    %esp,%ebp
  800956:	53                   	push   %ebx
  800957:	83 ec 10             	sub    $0x10,%esp
  80095a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80095d:	53                   	push   %ebx
  80095e:	e8 97 ff ff ff       	call   8008fa <strlen>
  800963:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800966:	ff 75 0c             	pushl  0xc(%ebp)
  800969:	01 d8                	add    %ebx,%eax
  80096b:	50                   	push   %eax
  80096c:	e8 c2 ff ff ff       	call   800933 <strcpy>
	return dst;
}
  800971:	89 d8                	mov    %ebx,%eax
  800973:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800976:	c9                   	leave  
  800977:	c3                   	ret    

00800978 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800978:	55                   	push   %ebp
  800979:	89 e5                	mov    %esp,%ebp
  80097b:	56                   	push   %esi
  80097c:	53                   	push   %ebx
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800983:	89 c6                	mov    %eax,%esi
  800985:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800988:	89 c2                	mov    %eax,%edx
  80098a:	39 f2                	cmp    %esi,%edx
  80098c:	74 11                	je     80099f <strncpy+0x27>
		*dst++ = *src;
  80098e:	83 c2 01             	add    $0x1,%edx
  800991:	0f b6 19             	movzbl (%ecx),%ebx
  800994:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800997:	80 fb 01             	cmp    $0x1,%bl
  80099a:	83 d9 ff             	sbb    $0xffffffff,%ecx
  80099d:	eb eb                	jmp    80098a <strncpy+0x12>
	}
	return ret;
}
  80099f:	5b                   	pop    %ebx
  8009a0:	5e                   	pop    %esi
  8009a1:	5d                   	pop    %ebp
  8009a2:	c3                   	ret    

008009a3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009a3:	55                   	push   %ebp
  8009a4:	89 e5                	mov    %esp,%ebp
  8009a6:	56                   	push   %esi
  8009a7:	53                   	push   %ebx
  8009a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ae:	8b 55 10             	mov    0x10(%ebp),%edx
  8009b1:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009b3:	85 d2                	test   %edx,%edx
  8009b5:	74 21                	je     8009d8 <strlcpy+0x35>
  8009b7:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009bb:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009bd:	39 c2                	cmp    %eax,%edx
  8009bf:	74 14                	je     8009d5 <strlcpy+0x32>
  8009c1:	0f b6 19             	movzbl (%ecx),%ebx
  8009c4:	84 db                	test   %bl,%bl
  8009c6:	74 0b                	je     8009d3 <strlcpy+0x30>
			*dst++ = *src++;
  8009c8:	83 c1 01             	add    $0x1,%ecx
  8009cb:	83 c2 01             	add    $0x1,%edx
  8009ce:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009d1:	eb ea                	jmp    8009bd <strlcpy+0x1a>
  8009d3:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009d5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009d8:	29 f0                	sub    %esi,%eax
}
  8009da:	5b                   	pop    %ebx
  8009db:	5e                   	pop    %esi
  8009dc:	5d                   	pop    %ebp
  8009dd:	c3                   	ret    

008009de <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009de:	55                   	push   %ebp
  8009df:	89 e5                	mov    %esp,%ebp
  8009e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009e4:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009e7:	0f b6 01             	movzbl (%ecx),%eax
  8009ea:	84 c0                	test   %al,%al
  8009ec:	74 0c                	je     8009fa <strcmp+0x1c>
  8009ee:	3a 02                	cmp    (%edx),%al
  8009f0:	75 08                	jne    8009fa <strcmp+0x1c>
		p++, q++;
  8009f2:	83 c1 01             	add    $0x1,%ecx
  8009f5:	83 c2 01             	add    $0x1,%edx
  8009f8:	eb ed                	jmp    8009e7 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009fa:	0f b6 c0             	movzbl %al,%eax
  8009fd:	0f b6 12             	movzbl (%edx),%edx
  800a00:	29 d0                	sub    %edx,%eax
}
  800a02:	5d                   	pop    %ebp
  800a03:	c3                   	ret    

00800a04 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	53                   	push   %ebx
  800a08:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a0e:	89 c3                	mov    %eax,%ebx
  800a10:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a13:	eb 06                	jmp    800a1b <strncmp+0x17>
		n--, p++, q++;
  800a15:	83 c0 01             	add    $0x1,%eax
  800a18:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a1b:	39 d8                	cmp    %ebx,%eax
  800a1d:	74 16                	je     800a35 <strncmp+0x31>
  800a1f:	0f b6 08             	movzbl (%eax),%ecx
  800a22:	84 c9                	test   %cl,%cl
  800a24:	74 04                	je     800a2a <strncmp+0x26>
  800a26:	3a 0a                	cmp    (%edx),%cl
  800a28:	74 eb                	je     800a15 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a2a:	0f b6 00             	movzbl (%eax),%eax
  800a2d:	0f b6 12             	movzbl (%edx),%edx
  800a30:	29 d0                	sub    %edx,%eax
}
  800a32:	5b                   	pop    %ebx
  800a33:	5d                   	pop    %ebp
  800a34:	c3                   	ret    
		return 0;
  800a35:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3a:	eb f6                	jmp    800a32 <strncmp+0x2e>

00800a3c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a46:	0f b6 10             	movzbl (%eax),%edx
  800a49:	84 d2                	test   %dl,%dl
  800a4b:	74 09                	je     800a56 <strchr+0x1a>
		if (*s == c)
  800a4d:	38 ca                	cmp    %cl,%dl
  800a4f:	74 0a                	je     800a5b <strchr+0x1f>
	for (; *s; s++)
  800a51:	83 c0 01             	add    $0x1,%eax
  800a54:	eb f0                	jmp    800a46 <strchr+0xa>
			return (char *) s;
	return 0;
  800a56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a5b:	5d                   	pop    %ebp
  800a5c:	c3                   	ret    

00800a5d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a5d:	55                   	push   %ebp
  800a5e:	89 e5                	mov    %esp,%ebp
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a67:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a6a:	38 ca                	cmp    %cl,%dl
  800a6c:	74 09                	je     800a77 <strfind+0x1a>
  800a6e:	84 d2                	test   %dl,%dl
  800a70:	74 05                	je     800a77 <strfind+0x1a>
	for (; *s; s++)
  800a72:	83 c0 01             	add    $0x1,%eax
  800a75:	eb f0                	jmp    800a67 <strfind+0xa>
			break;
	return (char *) s;
}
  800a77:	5d                   	pop    %ebp
  800a78:	c3                   	ret    

00800a79 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a79:	55                   	push   %ebp
  800a7a:	89 e5                	mov    %esp,%ebp
  800a7c:	57                   	push   %edi
  800a7d:	56                   	push   %esi
  800a7e:	53                   	push   %ebx
  800a7f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a82:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a85:	85 c9                	test   %ecx,%ecx
  800a87:	74 31                	je     800aba <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a89:	89 f8                	mov    %edi,%eax
  800a8b:	09 c8                	or     %ecx,%eax
  800a8d:	a8 03                	test   $0x3,%al
  800a8f:	75 23                	jne    800ab4 <memset+0x3b>
		c &= 0xFF;
  800a91:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a95:	89 d3                	mov    %edx,%ebx
  800a97:	c1 e3 08             	shl    $0x8,%ebx
  800a9a:	89 d0                	mov    %edx,%eax
  800a9c:	c1 e0 18             	shl    $0x18,%eax
  800a9f:	89 d6                	mov    %edx,%esi
  800aa1:	c1 e6 10             	shl    $0x10,%esi
  800aa4:	09 f0                	or     %esi,%eax
  800aa6:	09 c2                	or     %eax,%edx
  800aa8:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800aaa:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800aad:	89 d0                	mov    %edx,%eax
  800aaf:	fc                   	cld    
  800ab0:	f3 ab                	rep stos %eax,%es:(%edi)
  800ab2:	eb 06                	jmp    800aba <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ab4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab7:	fc                   	cld    
  800ab8:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aba:	89 f8                	mov    %edi,%eax
  800abc:	5b                   	pop    %ebx
  800abd:	5e                   	pop    %esi
  800abe:	5f                   	pop    %edi
  800abf:	5d                   	pop    %ebp
  800ac0:	c3                   	ret    

00800ac1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ac1:	55                   	push   %ebp
  800ac2:	89 e5                	mov    %esp,%ebp
  800ac4:	57                   	push   %edi
  800ac5:	56                   	push   %esi
  800ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800acc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800acf:	39 c6                	cmp    %eax,%esi
  800ad1:	73 32                	jae    800b05 <memmove+0x44>
  800ad3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ad6:	39 c2                	cmp    %eax,%edx
  800ad8:	76 2b                	jbe    800b05 <memmove+0x44>
		s += n;
		d += n;
  800ada:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800add:	89 fe                	mov    %edi,%esi
  800adf:	09 ce                	or     %ecx,%esi
  800ae1:	09 d6                	or     %edx,%esi
  800ae3:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ae9:	75 0e                	jne    800af9 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aeb:	83 ef 04             	sub    $0x4,%edi
  800aee:	8d 72 fc             	lea    -0x4(%edx),%esi
  800af1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800af4:	fd                   	std    
  800af5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af7:	eb 09                	jmp    800b02 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800af9:	83 ef 01             	sub    $0x1,%edi
  800afc:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aff:	fd                   	std    
  800b00:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b02:	fc                   	cld    
  800b03:	eb 1a                	jmp    800b1f <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b05:	89 c2                	mov    %eax,%edx
  800b07:	09 ca                	or     %ecx,%edx
  800b09:	09 f2                	or     %esi,%edx
  800b0b:	f6 c2 03             	test   $0x3,%dl
  800b0e:	75 0a                	jne    800b1a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b10:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b13:	89 c7                	mov    %eax,%edi
  800b15:	fc                   	cld    
  800b16:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b18:	eb 05                	jmp    800b1f <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b1a:	89 c7                	mov    %eax,%edi
  800b1c:	fc                   	cld    
  800b1d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b1f:	5e                   	pop    %esi
  800b20:	5f                   	pop    %edi
  800b21:	5d                   	pop    %ebp
  800b22:	c3                   	ret    

00800b23 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b23:	55                   	push   %ebp
  800b24:	89 e5                	mov    %esp,%ebp
  800b26:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b29:	ff 75 10             	pushl  0x10(%ebp)
  800b2c:	ff 75 0c             	pushl  0xc(%ebp)
  800b2f:	ff 75 08             	pushl  0x8(%ebp)
  800b32:	e8 8a ff ff ff       	call   800ac1 <memmove>
}
  800b37:	c9                   	leave  
  800b38:	c3                   	ret    

00800b39 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b39:	55                   	push   %ebp
  800b3a:	89 e5                	mov    %esp,%ebp
  800b3c:	56                   	push   %esi
  800b3d:	53                   	push   %ebx
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b44:	89 c6                	mov    %eax,%esi
  800b46:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b49:	39 f0                	cmp    %esi,%eax
  800b4b:	74 1c                	je     800b69 <memcmp+0x30>
		if (*s1 != *s2)
  800b4d:	0f b6 08             	movzbl (%eax),%ecx
  800b50:	0f b6 1a             	movzbl (%edx),%ebx
  800b53:	38 d9                	cmp    %bl,%cl
  800b55:	75 08                	jne    800b5f <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b57:	83 c0 01             	add    $0x1,%eax
  800b5a:	83 c2 01             	add    $0x1,%edx
  800b5d:	eb ea                	jmp    800b49 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b5f:	0f b6 c1             	movzbl %cl,%eax
  800b62:	0f b6 db             	movzbl %bl,%ebx
  800b65:	29 d8                	sub    %ebx,%eax
  800b67:	eb 05                	jmp    800b6e <memcmp+0x35>
	}

	return 0;
  800b69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b6e:	5b                   	pop    %ebx
  800b6f:	5e                   	pop    %esi
  800b70:	5d                   	pop    %ebp
  800b71:	c3                   	ret    

00800b72 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b7b:	89 c2                	mov    %eax,%edx
  800b7d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b80:	39 d0                	cmp    %edx,%eax
  800b82:	73 09                	jae    800b8d <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b84:	38 08                	cmp    %cl,(%eax)
  800b86:	74 05                	je     800b8d <memfind+0x1b>
	for (; s < ends; s++)
  800b88:	83 c0 01             	add    $0x1,%eax
  800b8b:	eb f3                	jmp    800b80 <memfind+0xe>
			break;
	return (void *) s;
}
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    

00800b8f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	57                   	push   %edi
  800b93:	56                   	push   %esi
  800b94:	53                   	push   %ebx
  800b95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b98:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b9b:	eb 03                	jmp    800ba0 <strtol+0x11>
		s++;
  800b9d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ba0:	0f b6 01             	movzbl (%ecx),%eax
  800ba3:	3c 20                	cmp    $0x20,%al
  800ba5:	74 f6                	je     800b9d <strtol+0xe>
  800ba7:	3c 09                	cmp    $0x9,%al
  800ba9:	74 f2                	je     800b9d <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bab:	3c 2b                	cmp    $0x2b,%al
  800bad:	74 2a                	je     800bd9 <strtol+0x4a>
	int neg = 0;
  800baf:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bb4:	3c 2d                	cmp    $0x2d,%al
  800bb6:	74 2b                	je     800be3 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb8:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bbe:	75 0f                	jne    800bcf <strtol+0x40>
  800bc0:	80 39 30             	cmpb   $0x30,(%ecx)
  800bc3:	74 28                	je     800bed <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bc5:	85 db                	test   %ebx,%ebx
  800bc7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bcc:	0f 44 d8             	cmove  %eax,%ebx
  800bcf:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bd7:	eb 50                	jmp    800c29 <strtol+0x9a>
		s++;
  800bd9:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bdc:	bf 00 00 00 00       	mov    $0x0,%edi
  800be1:	eb d5                	jmp    800bb8 <strtol+0x29>
		s++, neg = 1;
  800be3:	83 c1 01             	add    $0x1,%ecx
  800be6:	bf 01 00 00 00       	mov    $0x1,%edi
  800beb:	eb cb                	jmp    800bb8 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bed:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bf1:	74 0e                	je     800c01 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bf3:	85 db                	test   %ebx,%ebx
  800bf5:	75 d8                	jne    800bcf <strtol+0x40>
		s++, base = 8;
  800bf7:	83 c1 01             	add    $0x1,%ecx
  800bfa:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bff:	eb ce                	jmp    800bcf <strtol+0x40>
		s += 2, base = 16;
  800c01:	83 c1 02             	add    $0x2,%ecx
  800c04:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c09:	eb c4                	jmp    800bcf <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c0b:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c0e:	89 f3                	mov    %esi,%ebx
  800c10:	80 fb 19             	cmp    $0x19,%bl
  800c13:	77 29                	ja     800c3e <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c15:	0f be d2             	movsbl %dl,%edx
  800c18:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c1b:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c1e:	7d 30                	jge    800c50 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c20:	83 c1 01             	add    $0x1,%ecx
  800c23:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c27:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c29:	0f b6 11             	movzbl (%ecx),%edx
  800c2c:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c2f:	89 f3                	mov    %esi,%ebx
  800c31:	80 fb 09             	cmp    $0x9,%bl
  800c34:	77 d5                	ja     800c0b <strtol+0x7c>
			dig = *s - '0';
  800c36:	0f be d2             	movsbl %dl,%edx
  800c39:	83 ea 30             	sub    $0x30,%edx
  800c3c:	eb dd                	jmp    800c1b <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c3e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c41:	89 f3                	mov    %esi,%ebx
  800c43:	80 fb 19             	cmp    $0x19,%bl
  800c46:	77 08                	ja     800c50 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c48:	0f be d2             	movsbl %dl,%edx
  800c4b:	83 ea 37             	sub    $0x37,%edx
  800c4e:	eb cb                	jmp    800c1b <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c54:	74 05                	je     800c5b <strtol+0xcc>
		*endptr = (char *) s;
  800c56:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c59:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c5b:	89 c2                	mov    %eax,%edx
  800c5d:	f7 da                	neg    %edx
  800c5f:	85 ff                	test   %edi,%edi
  800c61:	0f 45 c2             	cmovne %edx,%eax
}
  800c64:	5b                   	pop    %ebx
  800c65:	5e                   	pop    %esi
  800c66:	5f                   	pop    %edi
  800c67:	5d                   	pop    %ebp
  800c68:	c3                   	ret    

00800c69 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	57                   	push   %edi
  800c6d:	56                   	push   %esi
  800c6e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c74:	8b 55 08             	mov    0x8(%ebp),%edx
  800c77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7a:	89 c3                	mov    %eax,%ebx
  800c7c:	89 c7                	mov    %eax,%edi
  800c7e:	89 c6                	mov    %eax,%esi
  800c80:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c82:	5b                   	pop    %ebx
  800c83:	5e                   	pop    %esi
  800c84:	5f                   	pop    %edi
  800c85:	5d                   	pop    %ebp
  800c86:	c3                   	ret    

00800c87 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	57                   	push   %edi
  800c8b:	56                   	push   %esi
  800c8c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c92:	b8 01 00 00 00       	mov    $0x1,%eax
  800c97:	89 d1                	mov    %edx,%ecx
  800c99:	89 d3                	mov    %edx,%ebx
  800c9b:	89 d7                	mov    %edx,%edi
  800c9d:	89 d6                	mov    %edx,%esi
  800c9f:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ca1:	5b                   	pop    %ebx
  800ca2:	5e                   	pop    %esi
  800ca3:	5f                   	pop    %edi
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    

00800ca6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	57                   	push   %edi
  800caa:	56                   	push   %esi
  800cab:	53                   	push   %ebx
  800cac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800caf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb7:	b8 03 00 00 00       	mov    $0x3,%eax
  800cbc:	89 cb                	mov    %ecx,%ebx
  800cbe:	89 cf                	mov    %ecx,%edi
  800cc0:	89 ce                	mov    %ecx,%esi
  800cc2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc4:	85 c0                	test   %eax,%eax
  800cc6:	7f 08                	jg     800cd0 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ccb:	5b                   	pop    %ebx
  800ccc:	5e                   	pop    %esi
  800ccd:	5f                   	pop    %edi
  800cce:	5d                   	pop    %ebp
  800ccf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd0:	83 ec 0c             	sub    $0xc,%esp
  800cd3:	50                   	push   %eax
  800cd4:	6a 03                	push   $0x3
  800cd6:	68 04 29 80 00       	push   $0x802904
  800cdb:	6a 43                	push   $0x43
  800cdd:	68 21 29 80 00       	push   $0x802921
  800ce2:	e8 69 14 00 00       	call   802150 <_panic>

00800ce7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	57                   	push   %edi
  800ceb:	56                   	push   %esi
  800cec:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ced:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf2:	b8 02 00 00 00       	mov    $0x2,%eax
  800cf7:	89 d1                	mov    %edx,%ecx
  800cf9:	89 d3                	mov    %edx,%ebx
  800cfb:	89 d7                	mov    %edx,%edi
  800cfd:	89 d6                	mov    %edx,%esi
  800cff:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d01:	5b                   	pop    %ebx
  800d02:	5e                   	pop    %esi
  800d03:	5f                   	pop    %edi
  800d04:	5d                   	pop    %ebp
  800d05:	c3                   	ret    

00800d06 <sys_yield>:

void
sys_yield(void)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	57                   	push   %edi
  800d0a:	56                   	push   %esi
  800d0b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d11:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d16:	89 d1                	mov    %edx,%ecx
  800d18:	89 d3                	mov    %edx,%ebx
  800d1a:	89 d7                	mov    %edx,%edi
  800d1c:	89 d6                	mov    %edx,%esi
  800d1e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d20:	5b                   	pop    %ebx
  800d21:	5e                   	pop    %esi
  800d22:	5f                   	pop    %edi
  800d23:	5d                   	pop    %ebp
  800d24:	c3                   	ret    

00800d25 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	57                   	push   %edi
  800d29:	56                   	push   %esi
  800d2a:	53                   	push   %ebx
  800d2b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d2e:	be 00 00 00 00       	mov    $0x0,%esi
  800d33:	8b 55 08             	mov    0x8(%ebp),%edx
  800d36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d39:	b8 04 00 00 00       	mov    $0x4,%eax
  800d3e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d41:	89 f7                	mov    %esi,%edi
  800d43:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d45:	85 c0                	test   %eax,%eax
  800d47:	7f 08                	jg     800d51 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4c:	5b                   	pop    %ebx
  800d4d:	5e                   	pop    %esi
  800d4e:	5f                   	pop    %edi
  800d4f:	5d                   	pop    %ebp
  800d50:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d51:	83 ec 0c             	sub    $0xc,%esp
  800d54:	50                   	push   %eax
  800d55:	6a 04                	push   $0x4
  800d57:	68 04 29 80 00       	push   $0x802904
  800d5c:	6a 43                	push   $0x43
  800d5e:	68 21 29 80 00       	push   $0x802921
  800d63:	e8 e8 13 00 00       	call   802150 <_panic>

00800d68 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
  800d6b:	57                   	push   %edi
  800d6c:	56                   	push   %esi
  800d6d:	53                   	push   %ebx
  800d6e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d71:	8b 55 08             	mov    0x8(%ebp),%edx
  800d74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d77:	b8 05 00 00 00       	mov    $0x5,%eax
  800d7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d82:	8b 75 18             	mov    0x18(%ebp),%esi
  800d85:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d87:	85 c0                	test   %eax,%eax
  800d89:	7f 08                	jg     800d93 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8e:	5b                   	pop    %ebx
  800d8f:	5e                   	pop    %esi
  800d90:	5f                   	pop    %edi
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d93:	83 ec 0c             	sub    $0xc,%esp
  800d96:	50                   	push   %eax
  800d97:	6a 05                	push   $0x5
  800d99:	68 04 29 80 00       	push   $0x802904
  800d9e:	6a 43                	push   $0x43
  800da0:	68 21 29 80 00       	push   $0x802921
  800da5:	e8 a6 13 00 00       	call   802150 <_panic>

00800daa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	57                   	push   %edi
  800dae:	56                   	push   %esi
  800daf:	53                   	push   %ebx
  800db0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbe:	b8 06 00 00 00       	mov    $0x6,%eax
  800dc3:	89 df                	mov    %ebx,%edi
  800dc5:	89 de                	mov    %ebx,%esi
  800dc7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc9:	85 c0                	test   %eax,%eax
  800dcb:	7f 08                	jg     800dd5 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd0:	5b                   	pop    %ebx
  800dd1:	5e                   	pop    %esi
  800dd2:	5f                   	pop    %edi
  800dd3:	5d                   	pop    %ebp
  800dd4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd5:	83 ec 0c             	sub    $0xc,%esp
  800dd8:	50                   	push   %eax
  800dd9:	6a 06                	push   $0x6
  800ddb:	68 04 29 80 00       	push   $0x802904
  800de0:	6a 43                	push   $0x43
  800de2:	68 21 29 80 00       	push   $0x802921
  800de7:	e8 64 13 00 00       	call   802150 <_panic>

00800dec <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	57                   	push   %edi
  800df0:	56                   	push   %esi
  800df1:	53                   	push   %ebx
  800df2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfa:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e00:	b8 08 00 00 00       	mov    $0x8,%eax
  800e05:	89 df                	mov    %ebx,%edi
  800e07:	89 de                	mov    %ebx,%esi
  800e09:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0b:	85 c0                	test   %eax,%eax
  800e0d:	7f 08                	jg     800e17 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e12:	5b                   	pop    %ebx
  800e13:	5e                   	pop    %esi
  800e14:	5f                   	pop    %edi
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e17:	83 ec 0c             	sub    $0xc,%esp
  800e1a:	50                   	push   %eax
  800e1b:	6a 08                	push   $0x8
  800e1d:	68 04 29 80 00       	push   $0x802904
  800e22:	6a 43                	push   $0x43
  800e24:	68 21 29 80 00       	push   $0x802921
  800e29:	e8 22 13 00 00       	call   802150 <_panic>

00800e2e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	57                   	push   %edi
  800e32:	56                   	push   %esi
  800e33:	53                   	push   %ebx
  800e34:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e37:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e42:	b8 09 00 00 00       	mov    $0x9,%eax
  800e47:	89 df                	mov    %ebx,%edi
  800e49:	89 de                	mov    %ebx,%esi
  800e4b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e4d:	85 c0                	test   %eax,%eax
  800e4f:	7f 08                	jg     800e59 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e54:	5b                   	pop    %ebx
  800e55:	5e                   	pop    %esi
  800e56:	5f                   	pop    %edi
  800e57:	5d                   	pop    %ebp
  800e58:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e59:	83 ec 0c             	sub    $0xc,%esp
  800e5c:	50                   	push   %eax
  800e5d:	6a 09                	push   $0x9
  800e5f:	68 04 29 80 00       	push   $0x802904
  800e64:	6a 43                	push   $0x43
  800e66:	68 21 29 80 00       	push   $0x802921
  800e6b:	e8 e0 12 00 00       	call   802150 <_panic>

00800e70 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	57                   	push   %edi
  800e74:	56                   	push   %esi
  800e75:	53                   	push   %ebx
  800e76:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e79:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e84:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e89:	89 df                	mov    %ebx,%edi
  800e8b:	89 de                	mov    %ebx,%esi
  800e8d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e8f:	85 c0                	test   %eax,%eax
  800e91:	7f 08                	jg     800e9b <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e96:	5b                   	pop    %ebx
  800e97:	5e                   	pop    %esi
  800e98:	5f                   	pop    %edi
  800e99:	5d                   	pop    %ebp
  800e9a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9b:	83 ec 0c             	sub    $0xc,%esp
  800e9e:	50                   	push   %eax
  800e9f:	6a 0a                	push   $0xa
  800ea1:	68 04 29 80 00       	push   $0x802904
  800ea6:	6a 43                	push   $0x43
  800ea8:	68 21 29 80 00       	push   $0x802921
  800ead:	e8 9e 12 00 00       	call   802150 <_panic>

00800eb2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eb2:	55                   	push   %ebp
  800eb3:	89 e5                	mov    %esp,%ebp
  800eb5:	57                   	push   %edi
  800eb6:	56                   	push   %esi
  800eb7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebe:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ec3:	be 00 00 00 00       	mov    $0x0,%esi
  800ec8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ecb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ece:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ed0:	5b                   	pop    %ebx
  800ed1:	5e                   	pop    %esi
  800ed2:	5f                   	pop    %edi
  800ed3:	5d                   	pop    %ebp
  800ed4:	c3                   	ret    

00800ed5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ed5:	55                   	push   %ebp
  800ed6:	89 e5                	mov    %esp,%ebp
  800ed8:	57                   	push   %edi
  800ed9:	56                   	push   %esi
  800eda:	53                   	push   %ebx
  800edb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ede:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee6:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eeb:	89 cb                	mov    %ecx,%ebx
  800eed:	89 cf                	mov    %ecx,%edi
  800eef:	89 ce                	mov    %ecx,%esi
  800ef1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef3:	85 c0                	test   %eax,%eax
  800ef5:	7f 08                	jg     800eff <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ef7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800efa:	5b                   	pop    %ebx
  800efb:	5e                   	pop    %esi
  800efc:	5f                   	pop    %edi
  800efd:	5d                   	pop    %ebp
  800efe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eff:	83 ec 0c             	sub    $0xc,%esp
  800f02:	50                   	push   %eax
  800f03:	6a 0d                	push   $0xd
  800f05:	68 04 29 80 00       	push   $0x802904
  800f0a:	6a 43                	push   $0x43
  800f0c:	68 21 29 80 00       	push   $0x802921
  800f11:	e8 3a 12 00 00       	call   802150 <_panic>

00800f16 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f16:	55                   	push   %ebp
  800f17:	89 e5                	mov    %esp,%ebp
  800f19:	57                   	push   %edi
  800f1a:	56                   	push   %esi
  800f1b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f1c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f21:	8b 55 08             	mov    0x8(%ebp),%edx
  800f24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f27:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f2c:	89 df                	mov    %ebx,%edi
  800f2e:	89 de                	mov    %ebx,%esi
  800f30:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f32:	5b                   	pop    %ebx
  800f33:	5e                   	pop    %esi
  800f34:	5f                   	pop    %edi
  800f35:	5d                   	pop    %ebp
  800f36:	c3                   	ret    

00800f37 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	57                   	push   %edi
  800f3b:	56                   	push   %esi
  800f3c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f42:	8b 55 08             	mov    0x8(%ebp),%edx
  800f45:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f4a:	89 cb                	mov    %ecx,%ebx
  800f4c:	89 cf                	mov    %ecx,%edi
  800f4e:	89 ce                	mov    %ecx,%esi
  800f50:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f52:	5b                   	pop    %ebx
  800f53:	5e                   	pop    %esi
  800f54:	5f                   	pop    %edi
  800f55:	5d                   	pop    %ebp
  800f56:	c3                   	ret    

00800f57 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f57:	55                   	push   %ebp
  800f58:	89 e5                	mov    %esp,%ebp
  800f5a:	57                   	push   %edi
  800f5b:	56                   	push   %esi
  800f5c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f62:	b8 10 00 00 00       	mov    $0x10,%eax
  800f67:	89 d1                	mov    %edx,%ecx
  800f69:	89 d3                	mov    %edx,%ebx
  800f6b:	89 d7                	mov    %edx,%edi
  800f6d:	89 d6                	mov    %edx,%esi
  800f6f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f71:	5b                   	pop    %ebx
  800f72:	5e                   	pop    %esi
  800f73:	5f                   	pop    %edi
  800f74:	5d                   	pop    %ebp
  800f75:	c3                   	ret    

00800f76 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	57                   	push   %edi
  800f7a:	56                   	push   %esi
  800f7b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f7c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f81:	8b 55 08             	mov    0x8(%ebp),%edx
  800f84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f87:	b8 11 00 00 00       	mov    $0x11,%eax
  800f8c:	89 df                	mov    %ebx,%edi
  800f8e:	89 de                	mov    %ebx,%esi
  800f90:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f92:	5b                   	pop    %ebx
  800f93:	5e                   	pop    %esi
  800f94:	5f                   	pop    %edi
  800f95:	5d                   	pop    %ebp
  800f96:	c3                   	ret    

00800f97 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	57                   	push   %edi
  800f9b:	56                   	push   %esi
  800f9c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f9d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa8:	b8 12 00 00 00       	mov    $0x12,%eax
  800fad:	89 df                	mov    %ebx,%edi
  800faf:	89 de                	mov    %ebx,%esi
  800fb1:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fb3:	5b                   	pop    %ebx
  800fb4:	5e                   	pop    %esi
  800fb5:	5f                   	pop    %edi
  800fb6:	5d                   	pop    %ebp
  800fb7:	c3                   	ret    

00800fb8 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fb8:	55                   	push   %ebp
  800fb9:	89 e5                	mov    %esp,%ebp
  800fbb:	57                   	push   %edi
  800fbc:	56                   	push   %esi
  800fbd:	53                   	push   %ebx
  800fbe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fc1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fcc:	b8 13 00 00 00       	mov    $0x13,%eax
  800fd1:	89 df                	mov    %ebx,%edi
  800fd3:	89 de                	mov    %ebx,%esi
  800fd5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fd7:	85 c0                	test   %eax,%eax
  800fd9:	7f 08                	jg     800fe3 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fde:	5b                   	pop    %ebx
  800fdf:	5e                   	pop    %esi
  800fe0:	5f                   	pop    %edi
  800fe1:	5d                   	pop    %ebp
  800fe2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe3:	83 ec 0c             	sub    $0xc,%esp
  800fe6:	50                   	push   %eax
  800fe7:	6a 13                	push   $0x13
  800fe9:	68 04 29 80 00       	push   $0x802904
  800fee:	6a 43                	push   $0x43
  800ff0:	68 21 29 80 00       	push   $0x802921
  800ff5:	e8 56 11 00 00       	call   802150 <_panic>

00800ffa <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800ffa:	55                   	push   %ebp
  800ffb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	05 00 00 00 30       	add    $0x30000000,%eax
  801005:	c1 e8 0c             	shr    $0xc,%eax
}
  801008:	5d                   	pop    %ebp
  801009:	c3                   	ret    

0080100a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80100a:	55                   	push   %ebp
  80100b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801015:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80101a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80101f:	5d                   	pop    %ebp
  801020:	c3                   	ret    

00801021 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
  801024:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801029:	89 c2                	mov    %eax,%edx
  80102b:	c1 ea 16             	shr    $0x16,%edx
  80102e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801035:	f6 c2 01             	test   $0x1,%dl
  801038:	74 2d                	je     801067 <fd_alloc+0x46>
  80103a:	89 c2                	mov    %eax,%edx
  80103c:	c1 ea 0c             	shr    $0xc,%edx
  80103f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801046:	f6 c2 01             	test   $0x1,%dl
  801049:	74 1c                	je     801067 <fd_alloc+0x46>
  80104b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801050:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801055:	75 d2                	jne    801029 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801060:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801065:	eb 0a                	jmp    801071 <fd_alloc+0x50>
			*fd_store = fd;
  801067:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80106a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80106c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    

00801073 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801079:	83 f8 1f             	cmp    $0x1f,%eax
  80107c:	77 30                	ja     8010ae <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80107e:	c1 e0 0c             	shl    $0xc,%eax
  801081:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801086:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80108c:	f6 c2 01             	test   $0x1,%dl
  80108f:	74 24                	je     8010b5 <fd_lookup+0x42>
  801091:	89 c2                	mov    %eax,%edx
  801093:	c1 ea 0c             	shr    $0xc,%edx
  801096:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80109d:	f6 c2 01             	test   $0x1,%dl
  8010a0:	74 1a                	je     8010bc <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a5:	89 02                	mov    %eax,(%edx)
	return 0;
  8010a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ac:	5d                   	pop    %ebp
  8010ad:	c3                   	ret    
		return -E_INVAL;
  8010ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010b3:	eb f7                	jmp    8010ac <fd_lookup+0x39>
		return -E_INVAL;
  8010b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010ba:	eb f0                	jmp    8010ac <fd_lookup+0x39>
  8010bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010c1:	eb e9                	jmp    8010ac <fd_lookup+0x39>

008010c3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010c3:	55                   	push   %ebp
  8010c4:	89 e5                	mov    %esp,%ebp
  8010c6:	83 ec 08             	sub    $0x8,%esp
  8010c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8010d1:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010d6:	39 08                	cmp    %ecx,(%eax)
  8010d8:	74 38                	je     801112 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8010da:	83 c2 01             	add    $0x1,%edx
  8010dd:	8b 04 95 ac 29 80 00 	mov    0x8029ac(,%edx,4),%eax
  8010e4:	85 c0                	test   %eax,%eax
  8010e6:	75 ee                	jne    8010d6 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010e8:	a1 08 40 80 00       	mov    0x804008,%eax
  8010ed:	8b 40 48             	mov    0x48(%eax),%eax
  8010f0:	83 ec 04             	sub    $0x4,%esp
  8010f3:	51                   	push   %ecx
  8010f4:	50                   	push   %eax
  8010f5:	68 30 29 80 00       	push   $0x802930
  8010fa:	e8 d5 f0 ff ff       	call   8001d4 <cprintf>
	*dev = 0;
  8010ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801102:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801108:	83 c4 10             	add    $0x10,%esp
  80110b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801110:	c9                   	leave  
  801111:	c3                   	ret    
			*dev = devtab[i];
  801112:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801115:	89 01                	mov    %eax,(%ecx)
			return 0;
  801117:	b8 00 00 00 00       	mov    $0x0,%eax
  80111c:	eb f2                	jmp    801110 <dev_lookup+0x4d>

0080111e <fd_close>:
{
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
  801121:	57                   	push   %edi
  801122:	56                   	push   %esi
  801123:	53                   	push   %ebx
  801124:	83 ec 24             	sub    $0x24,%esp
  801127:	8b 75 08             	mov    0x8(%ebp),%esi
  80112a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80112d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801130:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801131:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801137:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80113a:	50                   	push   %eax
  80113b:	e8 33 ff ff ff       	call   801073 <fd_lookup>
  801140:	89 c3                	mov    %eax,%ebx
  801142:	83 c4 10             	add    $0x10,%esp
  801145:	85 c0                	test   %eax,%eax
  801147:	78 05                	js     80114e <fd_close+0x30>
	    || fd != fd2)
  801149:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80114c:	74 16                	je     801164 <fd_close+0x46>
		return (must_exist ? r : 0);
  80114e:	89 f8                	mov    %edi,%eax
  801150:	84 c0                	test   %al,%al
  801152:	b8 00 00 00 00       	mov    $0x0,%eax
  801157:	0f 44 d8             	cmove  %eax,%ebx
}
  80115a:	89 d8                	mov    %ebx,%eax
  80115c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80115f:	5b                   	pop    %ebx
  801160:	5e                   	pop    %esi
  801161:	5f                   	pop    %edi
  801162:	5d                   	pop    %ebp
  801163:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801164:	83 ec 08             	sub    $0x8,%esp
  801167:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80116a:	50                   	push   %eax
  80116b:	ff 36                	pushl  (%esi)
  80116d:	e8 51 ff ff ff       	call   8010c3 <dev_lookup>
  801172:	89 c3                	mov    %eax,%ebx
  801174:	83 c4 10             	add    $0x10,%esp
  801177:	85 c0                	test   %eax,%eax
  801179:	78 1a                	js     801195 <fd_close+0x77>
		if (dev->dev_close)
  80117b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80117e:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801181:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801186:	85 c0                	test   %eax,%eax
  801188:	74 0b                	je     801195 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80118a:	83 ec 0c             	sub    $0xc,%esp
  80118d:	56                   	push   %esi
  80118e:	ff d0                	call   *%eax
  801190:	89 c3                	mov    %eax,%ebx
  801192:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801195:	83 ec 08             	sub    $0x8,%esp
  801198:	56                   	push   %esi
  801199:	6a 00                	push   $0x0
  80119b:	e8 0a fc ff ff       	call   800daa <sys_page_unmap>
	return r;
  8011a0:	83 c4 10             	add    $0x10,%esp
  8011a3:	eb b5                	jmp    80115a <fd_close+0x3c>

008011a5 <close>:

int
close(int fdnum)
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011ae:	50                   	push   %eax
  8011af:	ff 75 08             	pushl  0x8(%ebp)
  8011b2:	e8 bc fe ff ff       	call   801073 <fd_lookup>
  8011b7:	83 c4 10             	add    $0x10,%esp
  8011ba:	85 c0                	test   %eax,%eax
  8011bc:	79 02                	jns    8011c0 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011be:	c9                   	leave  
  8011bf:	c3                   	ret    
		return fd_close(fd, 1);
  8011c0:	83 ec 08             	sub    $0x8,%esp
  8011c3:	6a 01                	push   $0x1
  8011c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8011c8:	e8 51 ff ff ff       	call   80111e <fd_close>
  8011cd:	83 c4 10             	add    $0x10,%esp
  8011d0:	eb ec                	jmp    8011be <close+0x19>

008011d2 <close_all>:

void
close_all(void)
{
  8011d2:	55                   	push   %ebp
  8011d3:	89 e5                	mov    %esp,%ebp
  8011d5:	53                   	push   %ebx
  8011d6:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011d9:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011de:	83 ec 0c             	sub    $0xc,%esp
  8011e1:	53                   	push   %ebx
  8011e2:	e8 be ff ff ff       	call   8011a5 <close>
	for (i = 0; i < MAXFD; i++)
  8011e7:	83 c3 01             	add    $0x1,%ebx
  8011ea:	83 c4 10             	add    $0x10,%esp
  8011ed:	83 fb 20             	cmp    $0x20,%ebx
  8011f0:	75 ec                	jne    8011de <close_all+0xc>
}
  8011f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011f5:	c9                   	leave  
  8011f6:	c3                   	ret    

008011f7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	57                   	push   %edi
  8011fb:	56                   	push   %esi
  8011fc:	53                   	push   %ebx
  8011fd:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801200:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801203:	50                   	push   %eax
  801204:	ff 75 08             	pushl  0x8(%ebp)
  801207:	e8 67 fe ff ff       	call   801073 <fd_lookup>
  80120c:	89 c3                	mov    %eax,%ebx
  80120e:	83 c4 10             	add    $0x10,%esp
  801211:	85 c0                	test   %eax,%eax
  801213:	0f 88 81 00 00 00    	js     80129a <dup+0xa3>
		return r;
	close(newfdnum);
  801219:	83 ec 0c             	sub    $0xc,%esp
  80121c:	ff 75 0c             	pushl  0xc(%ebp)
  80121f:	e8 81 ff ff ff       	call   8011a5 <close>

	newfd = INDEX2FD(newfdnum);
  801224:	8b 75 0c             	mov    0xc(%ebp),%esi
  801227:	c1 e6 0c             	shl    $0xc,%esi
  80122a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801230:	83 c4 04             	add    $0x4,%esp
  801233:	ff 75 e4             	pushl  -0x1c(%ebp)
  801236:	e8 cf fd ff ff       	call   80100a <fd2data>
  80123b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80123d:	89 34 24             	mov    %esi,(%esp)
  801240:	e8 c5 fd ff ff       	call   80100a <fd2data>
  801245:	83 c4 10             	add    $0x10,%esp
  801248:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80124a:	89 d8                	mov    %ebx,%eax
  80124c:	c1 e8 16             	shr    $0x16,%eax
  80124f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801256:	a8 01                	test   $0x1,%al
  801258:	74 11                	je     80126b <dup+0x74>
  80125a:	89 d8                	mov    %ebx,%eax
  80125c:	c1 e8 0c             	shr    $0xc,%eax
  80125f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801266:	f6 c2 01             	test   $0x1,%dl
  801269:	75 39                	jne    8012a4 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80126b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80126e:	89 d0                	mov    %edx,%eax
  801270:	c1 e8 0c             	shr    $0xc,%eax
  801273:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80127a:	83 ec 0c             	sub    $0xc,%esp
  80127d:	25 07 0e 00 00       	and    $0xe07,%eax
  801282:	50                   	push   %eax
  801283:	56                   	push   %esi
  801284:	6a 00                	push   $0x0
  801286:	52                   	push   %edx
  801287:	6a 00                	push   $0x0
  801289:	e8 da fa ff ff       	call   800d68 <sys_page_map>
  80128e:	89 c3                	mov    %eax,%ebx
  801290:	83 c4 20             	add    $0x20,%esp
  801293:	85 c0                	test   %eax,%eax
  801295:	78 31                	js     8012c8 <dup+0xd1>
		goto err;

	return newfdnum;
  801297:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80129a:	89 d8                	mov    %ebx,%eax
  80129c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80129f:	5b                   	pop    %ebx
  8012a0:	5e                   	pop    %esi
  8012a1:	5f                   	pop    %edi
  8012a2:	5d                   	pop    %ebp
  8012a3:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012a4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012ab:	83 ec 0c             	sub    $0xc,%esp
  8012ae:	25 07 0e 00 00       	and    $0xe07,%eax
  8012b3:	50                   	push   %eax
  8012b4:	57                   	push   %edi
  8012b5:	6a 00                	push   $0x0
  8012b7:	53                   	push   %ebx
  8012b8:	6a 00                	push   $0x0
  8012ba:	e8 a9 fa ff ff       	call   800d68 <sys_page_map>
  8012bf:	89 c3                	mov    %eax,%ebx
  8012c1:	83 c4 20             	add    $0x20,%esp
  8012c4:	85 c0                	test   %eax,%eax
  8012c6:	79 a3                	jns    80126b <dup+0x74>
	sys_page_unmap(0, newfd);
  8012c8:	83 ec 08             	sub    $0x8,%esp
  8012cb:	56                   	push   %esi
  8012cc:	6a 00                	push   $0x0
  8012ce:	e8 d7 fa ff ff       	call   800daa <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012d3:	83 c4 08             	add    $0x8,%esp
  8012d6:	57                   	push   %edi
  8012d7:	6a 00                	push   $0x0
  8012d9:	e8 cc fa ff ff       	call   800daa <sys_page_unmap>
	return r;
  8012de:	83 c4 10             	add    $0x10,%esp
  8012e1:	eb b7                	jmp    80129a <dup+0xa3>

008012e3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
  8012e6:	53                   	push   %ebx
  8012e7:	83 ec 1c             	sub    $0x1c,%esp
  8012ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012f0:	50                   	push   %eax
  8012f1:	53                   	push   %ebx
  8012f2:	e8 7c fd ff ff       	call   801073 <fd_lookup>
  8012f7:	83 c4 10             	add    $0x10,%esp
  8012fa:	85 c0                	test   %eax,%eax
  8012fc:	78 3f                	js     80133d <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012fe:	83 ec 08             	sub    $0x8,%esp
  801301:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801304:	50                   	push   %eax
  801305:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801308:	ff 30                	pushl  (%eax)
  80130a:	e8 b4 fd ff ff       	call   8010c3 <dev_lookup>
  80130f:	83 c4 10             	add    $0x10,%esp
  801312:	85 c0                	test   %eax,%eax
  801314:	78 27                	js     80133d <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801316:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801319:	8b 42 08             	mov    0x8(%edx),%eax
  80131c:	83 e0 03             	and    $0x3,%eax
  80131f:	83 f8 01             	cmp    $0x1,%eax
  801322:	74 1e                	je     801342 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801327:	8b 40 08             	mov    0x8(%eax),%eax
  80132a:	85 c0                	test   %eax,%eax
  80132c:	74 35                	je     801363 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80132e:	83 ec 04             	sub    $0x4,%esp
  801331:	ff 75 10             	pushl  0x10(%ebp)
  801334:	ff 75 0c             	pushl  0xc(%ebp)
  801337:	52                   	push   %edx
  801338:	ff d0                	call   *%eax
  80133a:	83 c4 10             	add    $0x10,%esp
}
  80133d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801340:	c9                   	leave  
  801341:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801342:	a1 08 40 80 00       	mov    0x804008,%eax
  801347:	8b 40 48             	mov    0x48(%eax),%eax
  80134a:	83 ec 04             	sub    $0x4,%esp
  80134d:	53                   	push   %ebx
  80134e:	50                   	push   %eax
  80134f:	68 71 29 80 00       	push   $0x802971
  801354:	e8 7b ee ff ff       	call   8001d4 <cprintf>
		return -E_INVAL;
  801359:	83 c4 10             	add    $0x10,%esp
  80135c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801361:	eb da                	jmp    80133d <read+0x5a>
		return -E_NOT_SUPP;
  801363:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801368:	eb d3                	jmp    80133d <read+0x5a>

0080136a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	57                   	push   %edi
  80136e:	56                   	push   %esi
  80136f:	53                   	push   %ebx
  801370:	83 ec 0c             	sub    $0xc,%esp
  801373:	8b 7d 08             	mov    0x8(%ebp),%edi
  801376:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801379:	bb 00 00 00 00       	mov    $0x0,%ebx
  80137e:	39 f3                	cmp    %esi,%ebx
  801380:	73 23                	jae    8013a5 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801382:	83 ec 04             	sub    $0x4,%esp
  801385:	89 f0                	mov    %esi,%eax
  801387:	29 d8                	sub    %ebx,%eax
  801389:	50                   	push   %eax
  80138a:	89 d8                	mov    %ebx,%eax
  80138c:	03 45 0c             	add    0xc(%ebp),%eax
  80138f:	50                   	push   %eax
  801390:	57                   	push   %edi
  801391:	e8 4d ff ff ff       	call   8012e3 <read>
		if (m < 0)
  801396:	83 c4 10             	add    $0x10,%esp
  801399:	85 c0                	test   %eax,%eax
  80139b:	78 06                	js     8013a3 <readn+0x39>
			return m;
		if (m == 0)
  80139d:	74 06                	je     8013a5 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80139f:	01 c3                	add    %eax,%ebx
  8013a1:	eb db                	jmp    80137e <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013a3:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013a5:	89 d8                	mov    %ebx,%eax
  8013a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013aa:	5b                   	pop    %ebx
  8013ab:	5e                   	pop    %esi
  8013ac:	5f                   	pop    %edi
  8013ad:	5d                   	pop    %ebp
  8013ae:	c3                   	ret    

008013af <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013af:	55                   	push   %ebp
  8013b0:	89 e5                	mov    %esp,%ebp
  8013b2:	53                   	push   %ebx
  8013b3:	83 ec 1c             	sub    $0x1c,%esp
  8013b6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013bc:	50                   	push   %eax
  8013bd:	53                   	push   %ebx
  8013be:	e8 b0 fc ff ff       	call   801073 <fd_lookup>
  8013c3:	83 c4 10             	add    $0x10,%esp
  8013c6:	85 c0                	test   %eax,%eax
  8013c8:	78 3a                	js     801404 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013ca:	83 ec 08             	sub    $0x8,%esp
  8013cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d0:	50                   	push   %eax
  8013d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d4:	ff 30                	pushl  (%eax)
  8013d6:	e8 e8 fc ff ff       	call   8010c3 <dev_lookup>
  8013db:	83 c4 10             	add    $0x10,%esp
  8013de:	85 c0                	test   %eax,%eax
  8013e0:	78 22                	js     801404 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013e9:	74 1e                	je     801409 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ee:	8b 52 0c             	mov    0xc(%edx),%edx
  8013f1:	85 d2                	test   %edx,%edx
  8013f3:	74 35                	je     80142a <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013f5:	83 ec 04             	sub    $0x4,%esp
  8013f8:	ff 75 10             	pushl  0x10(%ebp)
  8013fb:	ff 75 0c             	pushl  0xc(%ebp)
  8013fe:	50                   	push   %eax
  8013ff:	ff d2                	call   *%edx
  801401:	83 c4 10             	add    $0x10,%esp
}
  801404:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801407:	c9                   	leave  
  801408:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801409:	a1 08 40 80 00       	mov    0x804008,%eax
  80140e:	8b 40 48             	mov    0x48(%eax),%eax
  801411:	83 ec 04             	sub    $0x4,%esp
  801414:	53                   	push   %ebx
  801415:	50                   	push   %eax
  801416:	68 8d 29 80 00       	push   $0x80298d
  80141b:	e8 b4 ed ff ff       	call   8001d4 <cprintf>
		return -E_INVAL;
  801420:	83 c4 10             	add    $0x10,%esp
  801423:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801428:	eb da                	jmp    801404 <write+0x55>
		return -E_NOT_SUPP;
  80142a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80142f:	eb d3                	jmp    801404 <write+0x55>

00801431 <seek>:

int
seek(int fdnum, off_t offset)
{
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
  801434:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801437:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143a:	50                   	push   %eax
  80143b:	ff 75 08             	pushl  0x8(%ebp)
  80143e:	e8 30 fc ff ff       	call   801073 <fd_lookup>
  801443:	83 c4 10             	add    $0x10,%esp
  801446:	85 c0                	test   %eax,%eax
  801448:	78 0e                	js     801458 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80144a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801450:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801453:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801458:	c9                   	leave  
  801459:	c3                   	ret    

0080145a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
  80145d:	53                   	push   %ebx
  80145e:	83 ec 1c             	sub    $0x1c,%esp
  801461:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801464:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801467:	50                   	push   %eax
  801468:	53                   	push   %ebx
  801469:	e8 05 fc ff ff       	call   801073 <fd_lookup>
  80146e:	83 c4 10             	add    $0x10,%esp
  801471:	85 c0                	test   %eax,%eax
  801473:	78 37                	js     8014ac <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801475:	83 ec 08             	sub    $0x8,%esp
  801478:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80147b:	50                   	push   %eax
  80147c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80147f:	ff 30                	pushl  (%eax)
  801481:	e8 3d fc ff ff       	call   8010c3 <dev_lookup>
  801486:	83 c4 10             	add    $0x10,%esp
  801489:	85 c0                	test   %eax,%eax
  80148b:	78 1f                	js     8014ac <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80148d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801490:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801494:	74 1b                	je     8014b1 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801496:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801499:	8b 52 18             	mov    0x18(%edx),%edx
  80149c:	85 d2                	test   %edx,%edx
  80149e:	74 32                	je     8014d2 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014a0:	83 ec 08             	sub    $0x8,%esp
  8014a3:	ff 75 0c             	pushl  0xc(%ebp)
  8014a6:	50                   	push   %eax
  8014a7:	ff d2                	call   *%edx
  8014a9:	83 c4 10             	add    $0x10,%esp
}
  8014ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014b1:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014b6:	8b 40 48             	mov    0x48(%eax),%eax
  8014b9:	83 ec 04             	sub    $0x4,%esp
  8014bc:	53                   	push   %ebx
  8014bd:	50                   	push   %eax
  8014be:	68 50 29 80 00       	push   $0x802950
  8014c3:	e8 0c ed ff ff       	call   8001d4 <cprintf>
		return -E_INVAL;
  8014c8:	83 c4 10             	add    $0x10,%esp
  8014cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014d0:	eb da                	jmp    8014ac <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014d2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014d7:	eb d3                	jmp    8014ac <ftruncate+0x52>

008014d9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
  8014dc:	53                   	push   %ebx
  8014dd:	83 ec 1c             	sub    $0x1c,%esp
  8014e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014e6:	50                   	push   %eax
  8014e7:	ff 75 08             	pushl  0x8(%ebp)
  8014ea:	e8 84 fb ff ff       	call   801073 <fd_lookup>
  8014ef:	83 c4 10             	add    $0x10,%esp
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	78 4b                	js     801541 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014f6:	83 ec 08             	sub    $0x8,%esp
  8014f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014fc:	50                   	push   %eax
  8014fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801500:	ff 30                	pushl  (%eax)
  801502:	e8 bc fb ff ff       	call   8010c3 <dev_lookup>
  801507:	83 c4 10             	add    $0x10,%esp
  80150a:	85 c0                	test   %eax,%eax
  80150c:	78 33                	js     801541 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80150e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801511:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801515:	74 2f                	je     801546 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801517:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80151a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801521:	00 00 00 
	stat->st_isdir = 0;
  801524:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80152b:	00 00 00 
	stat->st_dev = dev;
  80152e:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801534:	83 ec 08             	sub    $0x8,%esp
  801537:	53                   	push   %ebx
  801538:	ff 75 f0             	pushl  -0x10(%ebp)
  80153b:	ff 50 14             	call   *0x14(%eax)
  80153e:	83 c4 10             	add    $0x10,%esp
}
  801541:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801544:	c9                   	leave  
  801545:	c3                   	ret    
		return -E_NOT_SUPP;
  801546:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80154b:	eb f4                	jmp    801541 <fstat+0x68>

0080154d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
  801550:	56                   	push   %esi
  801551:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801552:	83 ec 08             	sub    $0x8,%esp
  801555:	6a 00                	push   $0x0
  801557:	ff 75 08             	pushl  0x8(%ebp)
  80155a:	e8 22 02 00 00       	call   801781 <open>
  80155f:	89 c3                	mov    %eax,%ebx
  801561:	83 c4 10             	add    $0x10,%esp
  801564:	85 c0                	test   %eax,%eax
  801566:	78 1b                	js     801583 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801568:	83 ec 08             	sub    $0x8,%esp
  80156b:	ff 75 0c             	pushl  0xc(%ebp)
  80156e:	50                   	push   %eax
  80156f:	e8 65 ff ff ff       	call   8014d9 <fstat>
  801574:	89 c6                	mov    %eax,%esi
	close(fd);
  801576:	89 1c 24             	mov    %ebx,(%esp)
  801579:	e8 27 fc ff ff       	call   8011a5 <close>
	return r;
  80157e:	83 c4 10             	add    $0x10,%esp
  801581:	89 f3                	mov    %esi,%ebx
}
  801583:	89 d8                	mov    %ebx,%eax
  801585:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801588:	5b                   	pop    %ebx
  801589:	5e                   	pop    %esi
  80158a:	5d                   	pop    %ebp
  80158b:	c3                   	ret    

0080158c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
  80158f:	56                   	push   %esi
  801590:	53                   	push   %ebx
  801591:	89 c6                	mov    %eax,%esi
  801593:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801595:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80159c:	74 27                	je     8015c5 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80159e:	6a 07                	push   $0x7
  8015a0:	68 00 50 80 00       	push   $0x805000
  8015a5:	56                   	push   %esi
  8015a6:	ff 35 00 40 80 00    	pushl  0x804000
  8015ac:	e8 69 0c 00 00       	call   80221a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015b1:	83 c4 0c             	add    $0xc,%esp
  8015b4:	6a 00                	push   $0x0
  8015b6:	53                   	push   %ebx
  8015b7:	6a 00                	push   $0x0
  8015b9:	e8 f3 0b 00 00       	call   8021b1 <ipc_recv>
}
  8015be:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015c1:	5b                   	pop    %ebx
  8015c2:	5e                   	pop    %esi
  8015c3:	5d                   	pop    %ebp
  8015c4:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015c5:	83 ec 0c             	sub    $0xc,%esp
  8015c8:	6a 01                	push   $0x1
  8015ca:	e8 a3 0c 00 00       	call   802272 <ipc_find_env>
  8015cf:	a3 00 40 80 00       	mov    %eax,0x804000
  8015d4:	83 c4 10             	add    $0x10,%esp
  8015d7:	eb c5                	jmp    80159e <fsipc+0x12>

008015d9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
  8015dc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8015e5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ed:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f7:	b8 02 00 00 00       	mov    $0x2,%eax
  8015fc:	e8 8b ff ff ff       	call   80158c <fsipc>
}
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <devfile_flush>:
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801609:	8b 45 08             	mov    0x8(%ebp),%eax
  80160c:	8b 40 0c             	mov    0xc(%eax),%eax
  80160f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801614:	ba 00 00 00 00       	mov    $0x0,%edx
  801619:	b8 06 00 00 00       	mov    $0x6,%eax
  80161e:	e8 69 ff ff ff       	call   80158c <fsipc>
}
  801623:	c9                   	leave  
  801624:	c3                   	ret    

00801625 <devfile_stat>:
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
  801628:	53                   	push   %ebx
  801629:	83 ec 04             	sub    $0x4,%esp
  80162c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	8b 40 0c             	mov    0xc(%eax),%eax
  801635:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80163a:	ba 00 00 00 00       	mov    $0x0,%edx
  80163f:	b8 05 00 00 00       	mov    $0x5,%eax
  801644:	e8 43 ff ff ff       	call   80158c <fsipc>
  801649:	85 c0                	test   %eax,%eax
  80164b:	78 2c                	js     801679 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80164d:	83 ec 08             	sub    $0x8,%esp
  801650:	68 00 50 80 00       	push   $0x805000
  801655:	53                   	push   %ebx
  801656:	e8 d8 f2 ff ff       	call   800933 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80165b:	a1 80 50 80 00       	mov    0x805080,%eax
  801660:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801666:	a1 84 50 80 00       	mov    0x805084,%eax
  80166b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801671:	83 c4 10             	add    $0x10,%esp
  801674:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801679:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167c:	c9                   	leave  
  80167d:	c3                   	ret    

0080167e <devfile_write>:
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
  801681:	53                   	push   %ebx
  801682:	83 ec 08             	sub    $0x8,%esp
  801685:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	8b 40 0c             	mov    0xc(%eax),%eax
  80168e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801693:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801699:	53                   	push   %ebx
  80169a:	ff 75 0c             	pushl  0xc(%ebp)
  80169d:	68 08 50 80 00       	push   $0x805008
  8016a2:	e8 7c f4 ff ff       	call   800b23 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ac:	b8 04 00 00 00       	mov    $0x4,%eax
  8016b1:	e8 d6 fe ff ff       	call   80158c <fsipc>
  8016b6:	83 c4 10             	add    $0x10,%esp
  8016b9:	85 c0                	test   %eax,%eax
  8016bb:	78 0b                	js     8016c8 <devfile_write+0x4a>
	assert(r <= n);
  8016bd:	39 d8                	cmp    %ebx,%eax
  8016bf:	77 0c                	ja     8016cd <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016c1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016c6:	7f 1e                	jg     8016e6 <devfile_write+0x68>
}
  8016c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016cb:	c9                   	leave  
  8016cc:	c3                   	ret    
	assert(r <= n);
  8016cd:	68 c0 29 80 00       	push   $0x8029c0
  8016d2:	68 c7 29 80 00       	push   $0x8029c7
  8016d7:	68 98 00 00 00       	push   $0x98
  8016dc:	68 dc 29 80 00       	push   $0x8029dc
  8016e1:	e8 6a 0a 00 00       	call   802150 <_panic>
	assert(r <= PGSIZE);
  8016e6:	68 e7 29 80 00       	push   $0x8029e7
  8016eb:	68 c7 29 80 00       	push   $0x8029c7
  8016f0:	68 99 00 00 00       	push   $0x99
  8016f5:	68 dc 29 80 00       	push   $0x8029dc
  8016fa:	e8 51 0a 00 00       	call   802150 <_panic>

008016ff <devfile_read>:
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
  801702:	56                   	push   %esi
  801703:	53                   	push   %ebx
  801704:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801707:	8b 45 08             	mov    0x8(%ebp),%eax
  80170a:	8b 40 0c             	mov    0xc(%eax),%eax
  80170d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801712:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801718:	ba 00 00 00 00       	mov    $0x0,%edx
  80171d:	b8 03 00 00 00       	mov    $0x3,%eax
  801722:	e8 65 fe ff ff       	call   80158c <fsipc>
  801727:	89 c3                	mov    %eax,%ebx
  801729:	85 c0                	test   %eax,%eax
  80172b:	78 1f                	js     80174c <devfile_read+0x4d>
	assert(r <= n);
  80172d:	39 f0                	cmp    %esi,%eax
  80172f:	77 24                	ja     801755 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801731:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801736:	7f 33                	jg     80176b <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801738:	83 ec 04             	sub    $0x4,%esp
  80173b:	50                   	push   %eax
  80173c:	68 00 50 80 00       	push   $0x805000
  801741:	ff 75 0c             	pushl  0xc(%ebp)
  801744:	e8 78 f3 ff ff       	call   800ac1 <memmove>
	return r;
  801749:	83 c4 10             	add    $0x10,%esp
}
  80174c:	89 d8                	mov    %ebx,%eax
  80174e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801751:	5b                   	pop    %ebx
  801752:	5e                   	pop    %esi
  801753:	5d                   	pop    %ebp
  801754:	c3                   	ret    
	assert(r <= n);
  801755:	68 c0 29 80 00       	push   $0x8029c0
  80175a:	68 c7 29 80 00       	push   $0x8029c7
  80175f:	6a 7c                	push   $0x7c
  801761:	68 dc 29 80 00       	push   $0x8029dc
  801766:	e8 e5 09 00 00       	call   802150 <_panic>
	assert(r <= PGSIZE);
  80176b:	68 e7 29 80 00       	push   $0x8029e7
  801770:	68 c7 29 80 00       	push   $0x8029c7
  801775:	6a 7d                	push   $0x7d
  801777:	68 dc 29 80 00       	push   $0x8029dc
  80177c:	e8 cf 09 00 00       	call   802150 <_panic>

00801781 <open>:
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	56                   	push   %esi
  801785:	53                   	push   %ebx
  801786:	83 ec 1c             	sub    $0x1c,%esp
  801789:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80178c:	56                   	push   %esi
  80178d:	e8 68 f1 ff ff       	call   8008fa <strlen>
  801792:	83 c4 10             	add    $0x10,%esp
  801795:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80179a:	7f 6c                	jg     801808 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80179c:	83 ec 0c             	sub    $0xc,%esp
  80179f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a2:	50                   	push   %eax
  8017a3:	e8 79 f8 ff ff       	call   801021 <fd_alloc>
  8017a8:	89 c3                	mov    %eax,%ebx
  8017aa:	83 c4 10             	add    $0x10,%esp
  8017ad:	85 c0                	test   %eax,%eax
  8017af:	78 3c                	js     8017ed <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017b1:	83 ec 08             	sub    $0x8,%esp
  8017b4:	56                   	push   %esi
  8017b5:	68 00 50 80 00       	push   $0x805000
  8017ba:	e8 74 f1 ff ff       	call   800933 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c2:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8017cf:	e8 b8 fd ff ff       	call   80158c <fsipc>
  8017d4:	89 c3                	mov    %eax,%ebx
  8017d6:	83 c4 10             	add    $0x10,%esp
  8017d9:	85 c0                	test   %eax,%eax
  8017db:	78 19                	js     8017f6 <open+0x75>
	return fd2num(fd);
  8017dd:	83 ec 0c             	sub    $0xc,%esp
  8017e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8017e3:	e8 12 f8 ff ff       	call   800ffa <fd2num>
  8017e8:	89 c3                	mov    %eax,%ebx
  8017ea:	83 c4 10             	add    $0x10,%esp
}
  8017ed:	89 d8                	mov    %ebx,%eax
  8017ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017f2:	5b                   	pop    %ebx
  8017f3:	5e                   	pop    %esi
  8017f4:	5d                   	pop    %ebp
  8017f5:	c3                   	ret    
		fd_close(fd, 0);
  8017f6:	83 ec 08             	sub    $0x8,%esp
  8017f9:	6a 00                	push   $0x0
  8017fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8017fe:	e8 1b f9 ff ff       	call   80111e <fd_close>
		return r;
  801803:	83 c4 10             	add    $0x10,%esp
  801806:	eb e5                	jmp    8017ed <open+0x6c>
		return -E_BAD_PATH;
  801808:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80180d:	eb de                	jmp    8017ed <open+0x6c>

0080180f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
  801812:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801815:	ba 00 00 00 00       	mov    $0x0,%edx
  80181a:	b8 08 00 00 00       	mov    $0x8,%eax
  80181f:	e8 68 fd ff ff       	call   80158c <fsipc>
}
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80182c:	68 f3 29 80 00       	push   $0x8029f3
  801831:	ff 75 0c             	pushl  0xc(%ebp)
  801834:	e8 fa f0 ff ff       	call   800933 <strcpy>
	return 0;
}
  801839:	b8 00 00 00 00       	mov    $0x0,%eax
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <devsock_close>:
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	53                   	push   %ebx
  801844:	83 ec 10             	sub    $0x10,%esp
  801847:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80184a:	53                   	push   %ebx
  80184b:	e8 5d 0a 00 00       	call   8022ad <pageref>
  801850:	83 c4 10             	add    $0x10,%esp
		return 0;
  801853:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801858:	83 f8 01             	cmp    $0x1,%eax
  80185b:	74 07                	je     801864 <devsock_close+0x24>
}
  80185d:	89 d0                	mov    %edx,%eax
  80185f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801862:	c9                   	leave  
  801863:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801864:	83 ec 0c             	sub    $0xc,%esp
  801867:	ff 73 0c             	pushl  0xc(%ebx)
  80186a:	e8 b9 02 00 00       	call   801b28 <nsipc_close>
  80186f:	89 c2                	mov    %eax,%edx
  801871:	83 c4 10             	add    $0x10,%esp
  801874:	eb e7                	jmp    80185d <devsock_close+0x1d>

00801876 <devsock_write>:
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80187c:	6a 00                	push   $0x0
  80187e:	ff 75 10             	pushl  0x10(%ebp)
  801881:	ff 75 0c             	pushl  0xc(%ebp)
  801884:	8b 45 08             	mov    0x8(%ebp),%eax
  801887:	ff 70 0c             	pushl  0xc(%eax)
  80188a:	e8 76 03 00 00       	call   801c05 <nsipc_send>
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <devsock_read>:
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801897:	6a 00                	push   $0x0
  801899:	ff 75 10             	pushl  0x10(%ebp)
  80189c:	ff 75 0c             	pushl  0xc(%ebp)
  80189f:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a2:	ff 70 0c             	pushl  0xc(%eax)
  8018a5:	e8 ef 02 00 00       	call   801b99 <nsipc_recv>
}
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <fd2sockid>:
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018b2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018b5:	52                   	push   %edx
  8018b6:	50                   	push   %eax
  8018b7:	e8 b7 f7 ff ff       	call   801073 <fd_lookup>
  8018bc:	83 c4 10             	add    $0x10,%esp
  8018bf:	85 c0                	test   %eax,%eax
  8018c1:	78 10                	js     8018d3 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c6:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018cc:	39 08                	cmp    %ecx,(%eax)
  8018ce:	75 05                	jne    8018d5 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018d0:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    
		return -E_NOT_SUPP;
  8018d5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018da:	eb f7                	jmp    8018d3 <fd2sockid+0x27>

008018dc <alloc_sockfd>:
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	56                   	push   %esi
  8018e0:	53                   	push   %ebx
  8018e1:	83 ec 1c             	sub    $0x1c,%esp
  8018e4:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8018e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e9:	50                   	push   %eax
  8018ea:	e8 32 f7 ff ff       	call   801021 <fd_alloc>
  8018ef:	89 c3                	mov    %eax,%ebx
  8018f1:	83 c4 10             	add    $0x10,%esp
  8018f4:	85 c0                	test   %eax,%eax
  8018f6:	78 43                	js     80193b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018f8:	83 ec 04             	sub    $0x4,%esp
  8018fb:	68 07 04 00 00       	push   $0x407
  801900:	ff 75 f4             	pushl  -0xc(%ebp)
  801903:	6a 00                	push   $0x0
  801905:	e8 1b f4 ff ff       	call   800d25 <sys_page_alloc>
  80190a:	89 c3                	mov    %eax,%ebx
  80190c:	83 c4 10             	add    $0x10,%esp
  80190f:	85 c0                	test   %eax,%eax
  801911:	78 28                	js     80193b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801916:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80191c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80191e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801921:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801928:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80192b:	83 ec 0c             	sub    $0xc,%esp
  80192e:	50                   	push   %eax
  80192f:	e8 c6 f6 ff ff       	call   800ffa <fd2num>
  801934:	89 c3                	mov    %eax,%ebx
  801936:	83 c4 10             	add    $0x10,%esp
  801939:	eb 0c                	jmp    801947 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80193b:	83 ec 0c             	sub    $0xc,%esp
  80193e:	56                   	push   %esi
  80193f:	e8 e4 01 00 00       	call   801b28 <nsipc_close>
		return r;
  801944:	83 c4 10             	add    $0x10,%esp
}
  801947:	89 d8                	mov    %ebx,%eax
  801949:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80194c:	5b                   	pop    %ebx
  80194d:	5e                   	pop    %esi
  80194e:	5d                   	pop    %ebp
  80194f:	c3                   	ret    

00801950 <accept>:
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801956:	8b 45 08             	mov    0x8(%ebp),%eax
  801959:	e8 4e ff ff ff       	call   8018ac <fd2sockid>
  80195e:	85 c0                	test   %eax,%eax
  801960:	78 1b                	js     80197d <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801962:	83 ec 04             	sub    $0x4,%esp
  801965:	ff 75 10             	pushl  0x10(%ebp)
  801968:	ff 75 0c             	pushl  0xc(%ebp)
  80196b:	50                   	push   %eax
  80196c:	e8 0e 01 00 00       	call   801a7f <nsipc_accept>
  801971:	83 c4 10             	add    $0x10,%esp
  801974:	85 c0                	test   %eax,%eax
  801976:	78 05                	js     80197d <accept+0x2d>
	return alloc_sockfd(r);
  801978:	e8 5f ff ff ff       	call   8018dc <alloc_sockfd>
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <bind>:
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801985:	8b 45 08             	mov    0x8(%ebp),%eax
  801988:	e8 1f ff ff ff       	call   8018ac <fd2sockid>
  80198d:	85 c0                	test   %eax,%eax
  80198f:	78 12                	js     8019a3 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801991:	83 ec 04             	sub    $0x4,%esp
  801994:	ff 75 10             	pushl  0x10(%ebp)
  801997:	ff 75 0c             	pushl  0xc(%ebp)
  80199a:	50                   	push   %eax
  80199b:	e8 31 01 00 00       	call   801ad1 <nsipc_bind>
  8019a0:	83 c4 10             	add    $0x10,%esp
}
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <shutdown>:
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
  8019a8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ae:	e8 f9 fe ff ff       	call   8018ac <fd2sockid>
  8019b3:	85 c0                	test   %eax,%eax
  8019b5:	78 0f                	js     8019c6 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019b7:	83 ec 08             	sub    $0x8,%esp
  8019ba:	ff 75 0c             	pushl  0xc(%ebp)
  8019bd:	50                   	push   %eax
  8019be:	e8 43 01 00 00       	call   801b06 <nsipc_shutdown>
  8019c3:	83 c4 10             	add    $0x10,%esp
}
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <connect>:
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d1:	e8 d6 fe ff ff       	call   8018ac <fd2sockid>
  8019d6:	85 c0                	test   %eax,%eax
  8019d8:	78 12                	js     8019ec <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8019da:	83 ec 04             	sub    $0x4,%esp
  8019dd:	ff 75 10             	pushl  0x10(%ebp)
  8019e0:	ff 75 0c             	pushl  0xc(%ebp)
  8019e3:	50                   	push   %eax
  8019e4:	e8 59 01 00 00       	call   801b42 <nsipc_connect>
  8019e9:	83 c4 10             	add    $0x10,%esp
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <listen>:
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
  8019f1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f7:	e8 b0 fe ff ff       	call   8018ac <fd2sockid>
  8019fc:	85 c0                	test   %eax,%eax
  8019fe:	78 0f                	js     801a0f <listen+0x21>
	return nsipc_listen(r, backlog);
  801a00:	83 ec 08             	sub    $0x8,%esp
  801a03:	ff 75 0c             	pushl  0xc(%ebp)
  801a06:	50                   	push   %eax
  801a07:	e8 6b 01 00 00       	call   801b77 <nsipc_listen>
  801a0c:	83 c4 10             	add    $0x10,%esp
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a17:	ff 75 10             	pushl  0x10(%ebp)
  801a1a:	ff 75 0c             	pushl  0xc(%ebp)
  801a1d:	ff 75 08             	pushl  0x8(%ebp)
  801a20:	e8 3e 02 00 00       	call   801c63 <nsipc_socket>
  801a25:	83 c4 10             	add    $0x10,%esp
  801a28:	85 c0                	test   %eax,%eax
  801a2a:	78 05                	js     801a31 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a2c:	e8 ab fe ff ff       	call   8018dc <alloc_sockfd>
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
  801a36:	53                   	push   %ebx
  801a37:	83 ec 04             	sub    $0x4,%esp
  801a3a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a3c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a43:	74 26                	je     801a6b <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a45:	6a 07                	push   $0x7
  801a47:	68 00 60 80 00       	push   $0x806000
  801a4c:	53                   	push   %ebx
  801a4d:	ff 35 04 40 80 00    	pushl  0x804004
  801a53:	e8 c2 07 00 00       	call   80221a <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a58:	83 c4 0c             	add    $0xc,%esp
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	e8 4b 07 00 00       	call   8021b1 <ipc_recv>
}
  801a66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a69:	c9                   	leave  
  801a6a:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a6b:	83 ec 0c             	sub    $0xc,%esp
  801a6e:	6a 02                	push   $0x2
  801a70:	e8 fd 07 00 00       	call   802272 <ipc_find_env>
  801a75:	a3 04 40 80 00       	mov    %eax,0x804004
  801a7a:	83 c4 10             	add    $0x10,%esp
  801a7d:	eb c6                	jmp    801a45 <nsipc+0x12>

00801a7f <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
  801a82:	56                   	push   %esi
  801a83:	53                   	push   %ebx
  801a84:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a8f:	8b 06                	mov    (%esi),%eax
  801a91:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a96:	b8 01 00 00 00       	mov    $0x1,%eax
  801a9b:	e8 93 ff ff ff       	call   801a33 <nsipc>
  801aa0:	89 c3                	mov    %eax,%ebx
  801aa2:	85 c0                	test   %eax,%eax
  801aa4:	79 09                	jns    801aaf <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801aa6:	89 d8                	mov    %ebx,%eax
  801aa8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aab:	5b                   	pop    %ebx
  801aac:	5e                   	pop    %esi
  801aad:	5d                   	pop    %ebp
  801aae:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801aaf:	83 ec 04             	sub    $0x4,%esp
  801ab2:	ff 35 10 60 80 00    	pushl  0x806010
  801ab8:	68 00 60 80 00       	push   $0x806000
  801abd:	ff 75 0c             	pushl  0xc(%ebp)
  801ac0:	e8 fc ef ff ff       	call   800ac1 <memmove>
		*addrlen = ret->ret_addrlen;
  801ac5:	a1 10 60 80 00       	mov    0x806010,%eax
  801aca:	89 06                	mov    %eax,(%esi)
  801acc:	83 c4 10             	add    $0x10,%esp
	return r;
  801acf:	eb d5                	jmp    801aa6 <nsipc_accept+0x27>

00801ad1 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
  801ad4:	53                   	push   %ebx
  801ad5:	83 ec 08             	sub    $0x8,%esp
  801ad8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801adb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ade:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ae3:	53                   	push   %ebx
  801ae4:	ff 75 0c             	pushl  0xc(%ebp)
  801ae7:	68 04 60 80 00       	push   $0x806004
  801aec:	e8 d0 ef ff ff       	call   800ac1 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801af1:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801af7:	b8 02 00 00 00       	mov    $0x2,%eax
  801afc:	e8 32 ff ff ff       	call   801a33 <nsipc>
}
  801b01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
  801b09:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b17:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b1c:	b8 03 00 00 00       	mov    $0x3,%eax
  801b21:	e8 0d ff ff ff       	call   801a33 <nsipc>
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <nsipc_close>:

int
nsipc_close(int s)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
  801b2b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b31:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b36:	b8 04 00 00 00       	mov    $0x4,%eax
  801b3b:	e8 f3 fe ff ff       	call   801a33 <nsipc>
}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
  801b45:	53                   	push   %ebx
  801b46:	83 ec 08             	sub    $0x8,%esp
  801b49:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4f:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b54:	53                   	push   %ebx
  801b55:	ff 75 0c             	pushl  0xc(%ebp)
  801b58:	68 04 60 80 00       	push   $0x806004
  801b5d:	e8 5f ef ff ff       	call   800ac1 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b62:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b68:	b8 05 00 00 00       	mov    $0x5,%eax
  801b6d:	e8 c1 fe ff ff       	call   801a33 <nsipc>
}
  801b72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b80:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b88:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b8d:	b8 06 00 00 00       	mov    $0x6,%eax
  801b92:	e8 9c fe ff ff       	call   801a33 <nsipc>
}
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    

00801b99 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
  801b9c:	56                   	push   %esi
  801b9d:	53                   	push   %ebx
  801b9e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801ba9:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801baf:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb2:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bb7:	b8 07 00 00 00       	mov    $0x7,%eax
  801bbc:	e8 72 fe ff ff       	call   801a33 <nsipc>
  801bc1:	89 c3                	mov    %eax,%ebx
  801bc3:	85 c0                	test   %eax,%eax
  801bc5:	78 1f                	js     801be6 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801bc7:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801bcc:	7f 21                	jg     801bef <nsipc_recv+0x56>
  801bce:	39 c6                	cmp    %eax,%esi
  801bd0:	7c 1d                	jl     801bef <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801bd2:	83 ec 04             	sub    $0x4,%esp
  801bd5:	50                   	push   %eax
  801bd6:	68 00 60 80 00       	push   $0x806000
  801bdb:	ff 75 0c             	pushl  0xc(%ebp)
  801bde:	e8 de ee ff ff       	call   800ac1 <memmove>
  801be3:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801be6:	89 d8                	mov    %ebx,%eax
  801be8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801beb:	5b                   	pop    %ebx
  801bec:	5e                   	pop    %esi
  801bed:	5d                   	pop    %ebp
  801bee:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801bef:	68 ff 29 80 00       	push   $0x8029ff
  801bf4:	68 c7 29 80 00       	push   $0x8029c7
  801bf9:	6a 62                	push   $0x62
  801bfb:	68 14 2a 80 00       	push   $0x802a14
  801c00:	e8 4b 05 00 00       	call   802150 <_panic>

00801c05 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	53                   	push   %ebx
  801c09:	83 ec 04             	sub    $0x4,%esp
  801c0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c12:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c17:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c1d:	7f 2e                	jg     801c4d <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c1f:	83 ec 04             	sub    $0x4,%esp
  801c22:	53                   	push   %ebx
  801c23:	ff 75 0c             	pushl  0xc(%ebp)
  801c26:	68 0c 60 80 00       	push   $0x80600c
  801c2b:	e8 91 ee ff ff       	call   800ac1 <memmove>
	nsipcbuf.send.req_size = size;
  801c30:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c36:	8b 45 14             	mov    0x14(%ebp),%eax
  801c39:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c3e:	b8 08 00 00 00       	mov    $0x8,%eax
  801c43:	e8 eb fd ff ff       	call   801a33 <nsipc>
}
  801c48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    
	assert(size < 1600);
  801c4d:	68 20 2a 80 00       	push   $0x802a20
  801c52:	68 c7 29 80 00       	push   $0x8029c7
  801c57:	6a 6d                	push   $0x6d
  801c59:	68 14 2a 80 00       	push   $0x802a14
  801c5e:	e8 ed 04 00 00       	call   802150 <_panic>

00801c63 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c74:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c79:	8b 45 10             	mov    0x10(%ebp),%eax
  801c7c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c81:	b8 09 00 00 00       	mov    $0x9,%eax
  801c86:	e8 a8 fd ff ff       	call   801a33 <nsipc>
}
  801c8b:	c9                   	leave  
  801c8c:	c3                   	ret    

00801c8d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
  801c90:	56                   	push   %esi
  801c91:	53                   	push   %ebx
  801c92:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c95:	83 ec 0c             	sub    $0xc,%esp
  801c98:	ff 75 08             	pushl  0x8(%ebp)
  801c9b:	e8 6a f3 ff ff       	call   80100a <fd2data>
  801ca0:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ca2:	83 c4 08             	add    $0x8,%esp
  801ca5:	68 2c 2a 80 00       	push   $0x802a2c
  801caa:	53                   	push   %ebx
  801cab:	e8 83 ec ff ff       	call   800933 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cb0:	8b 46 04             	mov    0x4(%esi),%eax
  801cb3:	2b 06                	sub    (%esi),%eax
  801cb5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cbb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cc2:	00 00 00 
	stat->st_dev = &devpipe;
  801cc5:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801ccc:	30 80 00 
	return 0;
}
  801ccf:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cd7:	5b                   	pop    %ebx
  801cd8:	5e                   	pop    %esi
  801cd9:	5d                   	pop    %ebp
  801cda:	c3                   	ret    

00801cdb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
  801cde:	53                   	push   %ebx
  801cdf:	83 ec 0c             	sub    $0xc,%esp
  801ce2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ce5:	53                   	push   %ebx
  801ce6:	6a 00                	push   $0x0
  801ce8:	e8 bd f0 ff ff       	call   800daa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ced:	89 1c 24             	mov    %ebx,(%esp)
  801cf0:	e8 15 f3 ff ff       	call   80100a <fd2data>
  801cf5:	83 c4 08             	add    $0x8,%esp
  801cf8:	50                   	push   %eax
  801cf9:	6a 00                	push   $0x0
  801cfb:	e8 aa f0 ff ff       	call   800daa <sys_page_unmap>
}
  801d00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    

00801d05 <_pipeisclosed>:
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
  801d08:	57                   	push   %edi
  801d09:	56                   	push   %esi
  801d0a:	53                   	push   %ebx
  801d0b:	83 ec 1c             	sub    $0x1c,%esp
  801d0e:	89 c7                	mov    %eax,%edi
  801d10:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d12:	a1 08 40 80 00       	mov    0x804008,%eax
  801d17:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d1a:	83 ec 0c             	sub    $0xc,%esp
  801d1d:	57                   	push   %edi
  801d1e:	e8 8a 05 00 00       	call   8022ad <pageref>
  801d23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d26:	89 34 24             	mov    %esi,(%esp)
  801d29:	e8 7f 05 00 00       	call   8022ad <pageref>
		nn = thisenv->env_runs;
  801d2e:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d34:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d37:	83 c4 10             	add    $0x10,%esp
  801d3a:	39 cb                	cmp    %ecx,%ebx
  801d3c:	74 1b                	je     801d59 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d3e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d41:	75 cf                	jne    801d12 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d43:	8b 42 58             	mov    0x58(%edx),%eax
  801d46:	6a 01                	push   $0x1
  801d48:	50                   	push   %eax
  801d49:	53                   	push   %ebx
  801d4a:	68 33 2a 80 00       	push   $0x802a33
  801d4f:	e8 80 e4 ff ff       	call   8001d4 <cprintf>
  801d54:	83 c4 10             	add    $0x10,%esp
  801d57:	eb b9                	jmp    801d12 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d59:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d5c:	0f 94 c0             	sete   %al
  801d5f:	0f b6 c0             	movzbl %al,%eax
}
  801d62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d65:	5b                   	pop    %ebx
  801d66:	5e                   	pop    %esi
  801d67:	5f                   	pop    %edi
  801d68:	5d                   	pop    %ebp
  801d69:	c3                   	ret    

00801d6a <devpipe_write>:
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
  801d6d:	57                   	push   %edi
  801d6e:	56                   	push   %esi
  801d6f:	53                   	push   %ebx
  801d70:	83 ec 28             	sub    $0x28,%esp
  801d73:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d76:	56                   	push   %esi
  801d77:	e8 8e f2 ff ff       	call   80100a <fd2data>
  801d7c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d7e:	83 c4 10             	add    $0x10,%esp
  801d81:	bf 00 00 00 00       	mov    $0x0,%edi
  801d86:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d89:	74 4f                	je     801dda <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d8b:	8b 43 04             	mov    0x4(%ebx),%eax
  801d8e:	8b 0b                	mov    (%ebx),%ecx
  801d90:	8d 51 20             	lea    0x20(%ecx),%edx
  801d93:	39 d0                	cmp    %edx,%eax
  801d95:	72 14                	jb     801dab <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d97:	89 da                	mov    %ebx,%edx
  801d99:	89 f0                	mov    %esi,%eax
  801d9b:	e8 65 ff ff ff       	call   801d05 <_pipeisclosed>
  801da0:	85 c0                	test   %eax,%eax
  801da2:	75 3b                	jne    801ddf <devpipe_write+0x75>
			sys_yield();
  801da4:	e8 5d ef ff ff       	call   800d06 <sys_yield>
  801da9:	eb e0                	jmp    801d8b <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dae:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801db2:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801db5:	89 c2                	mov    %eax,%edx
  801db7:	c1 fa 1f             	sar    $0x1f,%edx
  801dba:	89 d1                	mov    %edx,%ecx
  801dbc:	c1 e9 1b             	shr    $0x1b,%ecx
  801dbf:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801dc2:	83 e2 1f             	and    $0x1f,%edx
  801dc5:	29 ca                	sub    %ecx,%edx
  801dc7:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801dcb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801dcf:	83 c0 01             	add    $0x1,%eax
  801dd2:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801dd5:	83 c7 01             	add    $0x1,%edi
  801dd8:	eb ac                	jmp    801d86 <devpipe_write+0x1c>
	return i;
  801dda:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddd:	eb 05                	jmp    801de4 <devpipe_write+0x7a>
				return 0;
  801ddf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801de7:	5b                   	pop    %ebx
  801de8:	5e                   	pop    %esi
  801de9:	5f                   	pop    %edi
  801dea:	5d                   	pop    %ebp
  801deb:	c3                   	ret    

00801dec <devpipe_read>:
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	57                   	push   %edi
  801df0:	56                   	push   %esi
  801df1:	53                   	push   %ebx
  801df2:	83 ec 18             	sub    $0x18,%esp
  801df5:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801df8:	57                   	push   %edi
  801df9:	e8 0c f2 ff ff       	call   80100a <fd2data>
  801dfe:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e00:	83 c4 10             	add    $0x10,%esp
  801e03:	be 00 00 00 00       	mov    $0x0,%esi
  801e08:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e0b:	75 14                	jne    801e21 <devpipe_read+0x35>
	return i;
  801e0d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e10:	eb 02                	jmp    801e14 <devpipe_read+0x28>
				return i;
  801e12:	89 f0                	mov    %esi,%eax
}
  801e14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e17:	5b                   	pop    %ebx
  801e18:	5e                   	pop    %esi
  801e19:	5f                   	pop    %edi
  801e1a:	5d                   	pop    %ebp
  801e1b:	c3                   	ret    
			sys_yield();
  801e1c:	e8 e5 ee ff ff       	call   800d06 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e21:	8b 03                	mov    (%ebx),%eax
  801e23:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e26:	75 18                	jne    801e40 <devpipe_read+0x54>
			if (i > 0)
  801e28:	85 f6                	test   %esi,%esi
  801e2a:	75 e6                	jne    801e12 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e2c:	89 da                	mov    %ebx,%edx
  801e2e:	89 f8                	mov    %edi,%eax
  801e30:	e8 d0 fe ff ff       	call   801d05 <_pipeisclosed>
  801e35:	85 c0                	test   %eax,%eax
  801e37:	74 e3                	je     801e1c <devpipe_read+0x30>
				return 0;
  801e39:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3e:	eb d4                	jmp    801e14 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e40:	99                   	cltd   
  801e41:	c1 ea 1b             	shr    $0x1b,%edx
  801e44:	01 d0                	add    %edx,%eax
  801e46:	83 e0 1f             	and    $0x1f,%eax
  801e49:	29 d0                	sub    %edx,%eax
  801e4b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e53:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e56:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e59:	83 c6 01             	add    $0x1,%esi
  801e5c:	eb aa                	jmp    801e08 <devpipe_read+0x1c>

00801e5e <pipe>:
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
  801e61:	56                   	push   %esi
  801e62:	53                   	push   %ebx
  801e63:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e66:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e69:	50                   	push   %eax
  801e6a:	e8 b2 f1 ff ff       	call   801021 <fd_alloc>
  801e6f:	89 c3                	mov    %eax,%ebx
  801e71:	83 c4 10             	add    $0x10,%esp
  801e74:	85 c0                	test   %eax,%eax
  801e76:	0f 88 23 01 00 00    	js     801f9f <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e7c:	83 ec 04             	sub    $0x4,%esp
  801e7f:	68 07 04 00 00       	push   $0x407
  801e84:	ff 75 f4             	pushl  -0xc(%ebp)
  801e87:	6a 00                	push   $0x0
  801e89:	e8 97 ee ff ff       	call   800d25 <sys_page_alloc>
  801e8e:	89 c3                	mov    %eax,%ebx
  801e90:	83 c4 10             	add    $0x10,%esp
  801e93:	85 c0                	test   %eax,%eax
  801e95:	0f 88 04 01 00 00    	js     801f9f <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e9b:	83 ec 0c             	sub    $0xc,%esp
  801e9e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ea1:	50                   	push   %eax
  801ea2:	e8 7a f1 ff ff       	call   801021 <fd_alloc>
  801ea7:	89 c3                	mov    %eax,%ebx
  801ea9:	83 c4 10             	add    $0x10,%esp
  801eac:	85 c0                	test   %eax,%eax
  801eae:	0f 88 db 00 00 00    	js     801f8f <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eb4:	83 ec 04             	sub    $0x4,%esp
  801eb7:	68 07 04 00 00       	push   $0x407
  801ebc:	ff 75 f0             	pushl  -0x10(%ebp)
  801ebf:	6a 00                	push   $0x0
  801ec1:	e8 5f ee ff ff       	call   800d25 <sys_page_alloc>
  801ec6:	89 c3                	mov    %eax,%ebx
  801ec8:	83 c4 10             	add    $0x10,%esp
  801ecb:	85 c0                	test   %eax,%eax
  801ecd:	0f 88 bc 00 00 00    	js     801f8f <pipe+0x131>
	va = fd2data(fd0);
  801ed3:	83 ec 0c             	sub    $0xc,%esp
  801ed6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ed9:	e8 2c f1 ff ff       	call   80100a <fd2data>
  801ede:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ee0:	83 c4 0c             	add    $0xc,%esp
  801ee3:	68 07 04 00 00       	push   $0x407
  801ee8:	50                   	push   %eax
  801ee9:	6a 00                	push   $0x0
  801eeb:	e8 35 ee ff ff       	call   800d25 <sys_page_alloc>
  801ef0:	89 c3                	mov    %eax,%ebx
  801ef2:	83 c4 10             	add    $0x10,%esp
  801ef5:	85 c0                	test   %eax,%eax
  801ef7:	0f 88 82 00 00 00    	js     801f7f <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801efd:	83 ec 0c             	sub    $0xc,%esp
  801f00:	ff 75 f0             	pushl  -0x10(%ebp)
  801f03:	e8 02 f1 ff ff       	call   80100a <fd2data>
  801f08:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f0f:	50                   	push   %eax
  801f10:	6a 00                	push   $0x0
  801f12:	56                   	push   %esi
  801f13:	6a 00                	push   $0x0
  801f15:	e8 4e ee ff ff       	call   800d68 <sys_page_map>
  801f1a:	89 c3                	mov    %eax,%ebx
  801f1c:	83 c4 20             	add    $0x20,%esp
  801f1f:	85 c0                	test   %eax,%eax
  801f21:	78 4e                	js     801f71 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f23:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f2b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f30:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f37:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f3a:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f46:	83 ec 0c             	sub    $0xc,%esp
  801f49:	ff 75 f4             	pushl  -0xc(%ebp)
  801f4c:	e8 a9 f0 ff ff       	call   800ffa <fd2num>
  801f51:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f54:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f56:	83 c4 04             	add    $0x4,%esp
  801f59:	ff 75 f0             	pushl  -0x10(%ebp)
  801f5c:	e8 99 f0 ff ff       	call   800ffa <fd2num>
  801f61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f64:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f67:	83 c4 10             	add    $0x10,%esp
  801f6a:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f6f:	eb 2e                	jmp    801f9f <pipe+0x141>
	sys_page_unmap(0, va);
  801f71:	83 ec 08             	sub    $0x8,%esp
  801f74:	56                   	push   %esi
  801f75:	6a 00                	push   $0x0
  801f77:	e8 2e ee ff ff       	call   800daa <sys_page_unmap>
  801f7c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f7f:	83 ec 08             	sub    $0x8,%esp
  801f82:	ff 75 f0             	pushl  -0x10(%ebp)
  801f85:	6a 00                	push   $0x0
  801f87:	e8 1e ee ff ff       	call   800daa <sys_page_unmap>
  801f8c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f8f:	83 ec 08             	sub    $0x8,%esp
  801f92:	ff 75 f4             	pushl  -0xc(%ebp)
  801f95:	6a 00                	push   $0x0
  801f97:	e8 0e ee ff ff       	call   800daa <sys_page_unmap>
  801f9c:	83 c4 10             	add    $0x10,%esp
}
  801f9f:	89 d8                	mov    %ebx,%eax
  801fa1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fa4:	5b                   	pop    %ebx
  801fa5:	5e                   	pop    %esi
  801fa6:	5d                   	pop    %ebp
  801fa7:	c3                   	ret    

00801fa8 <pipeisclosed>:
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
  801fab:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fb1:	50                   	push   %eax
  801fb2:	ff 75 08             	pushl  0x8(%ebp)
  801fb5:	e8 b9 f0 ff ff       	call   801073 <fd_lookup>
  801fba:	83 c4 10             	add    $0x10,%esp
  801fbd:	85 c0                	test   %eax,%eax
  801fbf:	78 18                	js     801fd9 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fc1:	83 ec 0c             	sub    $0xc,%esp
  801fc4:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc7:	e8 3e f0 ff ff       	call   80100a <fd2data>
	return _pipeisclosed(fd, p);
  801fcc:	89 c2                	mov    %eax,%edx
  801fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd1:	e8 2f fd ff ff       	call   801d05 <_pipeisclosed>
  801fd6:	83 c4 10             	add    $0x10,%esp
}
  801fd9:	c9                   	leave  
  801fda:	c3                   	ret    

00801fdb <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801fdb:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe0:	c3                   	ret    

00801fe1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
  801fe4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fe7:	68 4b 2a 80 00       	push   $0x802a4b
  801fec:	ff 75 0c             	pushl  0xc(%ebp)
  801fef:	e8 3f e9 ff ff       	call   800933 <strcpy>
	return 0;
}
  801ff4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff9:	c9                   	leave  
  801ffa:	c3                   	ret    

00801ffb <devcons_write>:
{
  801ffb:	55                   	push   %ebp
  801ffc:	89 e5                	mov    %esp,%ebp
  801ffe:	57                   	push   %edi
  801fff:	56                   	push   %esi
  802000:	53                   	push   %ebx
  802001:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802007:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80200c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802012:	3b 75 10             	cmp    0x10(%ebp),%esi
  802015:	73 31                	jae    802048 <devcons_write+0x4d>
		m = n - tot;
  802017:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80201a:	29 f3                	sub    %esi,%ebx
  80201c:	83 fb 7f             	cmp    $0x7f,%ebx
  80201f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802024:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802027:	83 ec 04             	sub    $0x4,%esp
  80202a:	53                   	push   %ebx
  80202b:	89 f0                	mov    %esi,%eax
  80202d:	03 45 0c             	add    0xc(%ebp),%eax
  802030:	50                   	push   %eax
  802031:	57                   	push   %edi
  802032:	e8 8a ea ff ff       	call   800ac1 <memmove>
		sys_cputs(buf, m);
  802037:	83 c4 08             	add    $0x8,%esp
  80203a:	53                   	push   %ebx
  80203b:	57                   	push   %edi
  80203c:	e8 28 ec ff ff       	call   800c69 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802041:	01 de                	add    %ebx,%esi
  802043:	83 c4 10             	add    $0x10,%esp
  802046:	eb ca                	jmp    802012 <devcons_write+0x17>
}
  802048:	89 f0                	mov    %esi,%eax
  80204a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80204d:	5b                   	pop    %ebx
  80204e:	5e                   	pop    %esi
  80204f:	5f                   	pop    %edi
  802050:	5d                   	pop    %ebp
  802051:	c3                   	ret    

00802052 <devcons_read>:
{
  802052:	55                   	push   %ebp
  802053:	89 e5                	mov    %esp,%ebp
  802055:	83 ec 08             	sub    $0x8,%esp
  802058:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80205d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802061:	74 21                	je     802084 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802063:	e8 1f ec ff ff       	call   800c87 <sys_cgetc>
  802068:	85 c0                	test   %eax,%eax
  80206a:	75 07                	jne    802073 <devcons_read+0x21>
		sys_yield();
  80206c:	e8 95 ec ff ff       	call   800d06 <sys_yield>
  802071:	eb f0                	jmp    802063 <devcons_read+0x11>
	if (c < 0)
  802073:	78 0f                	js     802084 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802075:	83 f8 04             	cmp    $0x4,%eax
  802078:	74 0c                	je     802086 <devcons_read+0x34>
	*(char*)vbuf = c;
  80207a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207d:	88 02                	mov    %al,(%edx)
	return 1;
  80207f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    
		return 0;
  802086:	b8 00 00 00 00       	mov    $0x0,%eax
  80208b:	eb f7                	jmp    802084 <devcons_read+0x32>

0080208d <cputchar>:
{
  80208d:	55                   	push   %ebp
  80208e:	89 e5                	mov    %esp,%ebp
  802090:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802093:	8b 45 08             	mov    0x8(%ebp),%eax
  802096:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802099:	6a 01                	push   $0x1
  80209b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80209e:	50                   	push   %eax
  80209f:	e8 c5 eb ff ff       	call   800c69 <sys_cputs>
}
  8020a4:	83 c4 10             	add    $0x10,%esp
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    

008020a9 <getchar>:
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
  8020ac:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020af:	6a 01                	push   $0x1
  8020b1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020b4:	50                   	push   %eax
  8020b5:	6a 00                	push   $0x0
  8020b7:	e8 27 f2 ff ff       	call   8012e3 <read>
	if (r < 0)
  8020bc:	83 c4 10             	add    $0x10,%esp
  8020bf:	85 c0                	test   %eax,%eax
  8020c1:	78 06                	js     8020c9 <getchar+0x20>
	if (r < 1)
  8020c3:	74 06                	je     8020cb <getchar+0x22>
	return c;
  8020c5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    
		return -E_EOF;
  8020cb:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020d0:	eb f7                	jmp    8020c9 <getchar+0x20>

008020d2 <iscons>:
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
  8020d5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020db:	50                   	push   %eax
  8020dc:	ff 75 08             	pushl  0x8(%ebp)
  8020df:	e8 8f ef ff ff       	call   801073 <fd_lookup>
  8020e4:	83 c4 10             	add    $0x10,%esp
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	78 11                	js     8020fc <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ee:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020f4:	39 10                	cmp    %edx,(%eax)
  8020f6:	0f 94 c0             	sete   %al
  8020f9:	0f b6 c0             	movzbl %al,%eax
}
  8020fc:	c9                   	leave  
  8020fd:	c3                   	ret    

008020fe <opencons>:
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
  802101:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802104:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802107:	50                   	push   %eax
  802108:	e8 14 ef ff ff       	call   801021 <fd_alloc>
  80210d:	83 c4 10             	add    $0x10,%esp
  802110:	85 c0                	test   %eax,%eax
  802112:	78 3a                	js     80214e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802114:	83 ec 04             	sub    $0x4,%esp
  802117:	68 07 04 00 00       	push   $0x407
  80211c:	ff 75 f4             	pushl  -0xc(%ebp)
  80211f:	6a 00                	push   $0x0
  802121:	e8 ff eb ff ff       	call   800d25 <sys_page_alloc>
  802126:	83 c4 10             	add    $0x10,%esp
  802129:	85 c0                	test   %eax,%eax
  80212b:	78 21                	js     80214e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80212d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802130:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802136:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802138:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802142:	83 ec 0c             	sub    $0xc,%esp
  802145:	50                   	push   %eax
  802146:	e8 af ee ff ff       	call   800ffa <fd2num>
  80214b:	83 c4 10             	add    $0x10,%esp
}
  80214e:	c9                   	leave  
  80214f:	c3                   	ret    

00802150 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
  802153:	56                   	push   %esi
  802154:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802155:	a1 08 40 80 00       	mov    0x804008,%eax
  80215a:	8b 40 48             	mov    0x48(%eax),%eax
  80215d:	83 ec 04             	sub    $0x4,%esp
  802160:	68 88 2a 80 00       	push   $0x802a88
  802165:	50                   	push   %eax
  802166:	68 57 2a 80 00       	push   $0x802a57
  80216b:	e8 64 e0 ff ff       	call   8001d4 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802170:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802173:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802179:	e8 69 eb ff ff       	call   800ce7 <sys_getenvid>
  80217e:	83 c4 04             	add    $0x4,%esp
  802181:	ff 75 0c             	pushl  0xc(%ebp)
  802184:	ff 75 08             	pushl  0x8(%ebp)
  802187:	56                   	push   %esi
  802188:	50                   	push   %eax
  802189:	68 64 2a 80 00       	push   $0x802a64
  80218e:	e8 41 e0 ff ff       	call   8001d4 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802193:	83 c4 18             	add    $0x18,%esp
  802196:	53                   	push   %ebx
  802197:	ff 75 10             	pushl  0x10(%ebp)
  80219a:	e8 e4 df ff ff       	call   800183 <vcprintf>
	cprintf("\n");
  80219f:	c7 04 24 79 25 80 00 	movl   $0x802579,(%esp)
  8021a6:	e8 29 e0 ff ff       	call   8001d4 <cprintf>
  8021ab:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021ae:	cc                   	int3   
  8021af:	eb fd                	jmp    8021ae <_panic+0x5e>

008021b1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021b1:	55                   	push   %ebp
  8021b2:	89 e5                	mov    %esp,%ebp
  8021b4:	56                   	push   %esi
  8021b5:	53                   	push   %ebx
  8021b6:	8b 75 08             	mov    0x8(%ebp),%esi
  8021b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8021bf:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021c1:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021c6:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8021c9:	83 ec 0c             	sub    $0xc,%esp
  8021cc:	50                   	push   %eax
  8021cd:	e8 03 ed ff ff       	call   800ed5 <sys_ipc_recv>
	if(ret < 0){
  8021d2:	83 c4 10             	add    $0x10,%esp
  8021d5:	85 c0                	test   %eax,%eax
  8021d7:	78 2b                	js     802204 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8021d9:	85 f6                	test   %esi,%esi
  8021db:	74 0a                	je     8021e7 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8021dd:	a1 08 40 80 00       	mov    0x804008,%eax
  8021e2:	8b 40 74             	mov    0x74(%eax),%eax
  8021e5:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8021e7:	85 db                	test   %ebx,%ebx
  8021e9:	74 0a                	je     8021f5 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8021eb:	a1 08 40 80 00       	mov    0x804008,%eax
  8021f0:	8b 40 78             	mov    0x78(%eax),%eax
  8021f3:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8021f5:	a1 08 40 80 00       	mov    0x804008,%eax
  8021fa:	8b 40 70             	mov    0x70(%eax),%eax
}
  8021fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802200:	5b                   	pop    %ebx
  802201:	5e                   	pop    %esi
  802202:	5d                   	pop    %ebp
  802203:	c3                   	ret    
		if(from_env_store)
  802204:	85 f6                	test   %esi,%esi
  802206:	74 06                	je     80220e <ipc_recv+0x5d>
			*from_env_store = 0;
  802208:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80220e:	85 db                	test   %ebx,%ebx
  802210:	74 eb                	je     8021fd <ipc_recv+0x4c>
			*perm_store = 0;
  802212:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802218:	eb e3                	jmp    8021fd <ipc_recv+0x4c>

0080221a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
  80221d:	57                   	push   %edi
  80221e:	56                   	push   %esi
  80221f:	53                   	push   %ebx
  802220:	83 ec 0c             	sub    $0xc,%esp
  802223:	8b 7d 08             	mov    0x8(%ebp),%edi
  802226:	8b 75 0c             	mov    0xc(%ebp),%esi
  802229:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80222c:	85 db                	test   %ebx,%ebx
  80222e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802233:	0f 44 d8             	cmove  %eax,%ebx
  802236:	eb 05                	jmp    80223d <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802238:	e8 c9 ea ff ff       	call   800d06 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80223d:	ff 75 14             	pushl  0x14(%ebp)
  802240:	53                   	push   %ebx
  802241:	56                   	push   %esi
  802242:	57                   	push   %edi
  802243:	e8 6a ec ff ff       	call   800eb2 <sys_ipc_try_send>
  802248:	83 c4 10             	add    $0x10,%esp
  80224b:	85 c0                	test   %eax,%eax
  80224d:	74 1b                	je     80226a <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80224f:	79 e7                	jns    802238 <ipc_send+0x1e>
  802251:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802254:	74 e2                	je     802238 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802256:	83 ec 04             	sub    $0x4,%esp
  802259:	68 8f 2a 80 00       	push   $0x802a8f
  80225e:	6a 48                	push   $0x48
  802260:	68 a4 2a 80 00       	push   $0x802aa4
  802265:	e8 e6 fe ff ff       	call   802150 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80226a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80226d:	5b                   	pop    %ebx
  80226e:	5e                   	pop    %esi
  80226f:	5f                   	pop    %edi
  802270:	5d                   	pop    %ebp
  802271:	c3                   	ret    

00802272 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802272:	55                   	push   %ebp
  802273:	89 e5                	mov    %esp,%ebp
  802275:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802278:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80227d:	89 c2                	mov    %eax,%edx
  80227f:	c1 e2 07             	shl    $0x7,%edx
  802282:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802288:	8b 52 50             	mov    0x50(%edx),%edx
  80228b:	39 ca                	cmp    %ecx,%edx
  80228d:	74 11                	je     8022a0 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  80228f:	83 c0 01             	add    $0x1,%eax
  802292:	3d 00 04 00 00       	cmp    $0x400,%eax
  802297:	75 e4                	jne    80227d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802299:	b8 00 00 00 00       	mov    $0x0,%eax
  80229e:	eb 0b                	jmp    8022ab <ipc_find_env+0x39>
			return envs[i].env_id;
  8022a0:	c1 e0 07             	shl    $0x7,%eax
  8022a3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022a8:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022ab:	5d                   	pop    %ebp
  8022ac:	c3                   	ret    

008022ad <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
  8022b0:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022b3:	89 d0                	mov    %edx,%eax
  8022b5:	c1 e8 16             	shr    $0x16,%eax
  8022b8:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022bf:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022c4:	f6 c1 01             	test   $0x1,%cl
  8022c7:	74 1d                	je     8022e6 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022c9:	c1 ea 0c             	shr    $0xc,%edx
  8022cc:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022d3:	f6 c2 01             	test   $0x1,%dl
  8022d6:	74 0e                	je     8022e6 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022d8:	c1 ea 0c             	shr    $0xc,%edx
  8022db:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022e2:	ef 
  8022e3:	0f b7 c0             	movzwl %ax,%eax
}
  8022e6:	5d                   	pop    %ebp
  8022e7:	c3                   	ret    
  8022e8:	66 90                	xchg   %ax,%ax
  8022ea:	66 90                	xchg   %ax,%ax
  8022ec:	66 90                	xchg   %ax,%ax
  8022ee:	66 90                	xchg   %ax,%ax

008022f0 <__udivdi3>:
  8022f0:	55                   	push   %ebp
  8022f1:	57                   	push   %edi
  8022f2:	56                   	push   %esi
  8022f3:	53                   	push   %ebx
  8022f4:	83 ec 1c             	sub    $0x1c,%esp
  8022f7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022fb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  802303:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802307:	85 d2                	test   %edx,%edx
  802309:	75 4d                	jne    802358 <__udivdi3+0x68>
  80230b:	39 f3                	cmp    %esi,%ebx
  80230d:	76 19                	jbe    802328 <__udivdi3+0x38>
  80230f:	31 ff                	xor    %edi,%edi
  802311:	89 e8                	mov    %ebp,%eax
  802313:	89 f2                	mov    %esi,%edx
  802315:	f7 f3                	div    %ebx
  802317:	89 fa                	mov    %edi,%edx
  802319:	83 c4 1c             	add    $0x1c,%esp
  80231c:	5b                   	pop    %ebx
  80231d:	5e                   	pop    %esi
  80231e:	5f                   	pop    %edi
  80231f:	5d                   	pop    %ebp
  802320:	c3                   	ret    
  802321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802328:	89 d9                	mov    %ebx,%ecx
  80232a:	85 db                	test   %ebx,%ebx
  80232c:	75 0b                	jne    802339 <__udivdi3+0x49>
  80232e:	b8 01 00 00 00       	mov    $0x1,%eax
  802333:	31 d2                	xor    %edx,%edx
  802335:	f7 f3                	div    %ebx
  802337:	89 c1                	mov    %eax,%ecx
  802339:	31 d2                	xor    %edx,%edx
  80233b:	89 f0                	mov    %esi,%eax
  80233d:	f7 f1                	div    %ecx
  80233f:	89 c6                	mov    %eax,%esi
  802341:	89 e8                	mov    %ebp,%eax
  802343:	89 f7                	mov    %esi,%edi
  802345:	f7 f1                	div    %ecx
  802347:	89 fa                	mov    %edi,%edx
  802349:	83 c4 1c             	add    $0x1c,%esp
  80234c:	5b                   	pop    %ebx
  80234d:	5e                   	pop    %esi
  80234e:	5f                   	pop    %edi
  80234f:	5d                   	pop    %ebp
  802350:	c3                   	ret    
  802351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802358:	39 f2                	cmp    %esi,%edx
  80235a:	77 1c                	ja     802378 <__udivdi3+0x88>
  80235c:	0f bd fa             	bsr    %edx,%edi
  80235f:	83 f7 1f             	xor    $0x1f,%edi
  802362:	75 2c                	jne    802390 <__udivdi3+0xa0>
  802364:	39 f2                	cmp    %esi,%edx
  802366:	72 06                	jb     80236e <__udivdi3+0x7e>
  802368:	31 c0                	xor    %eax,%eax
  80236a:	39 eb                	cmp    %ebp,%ebx
  80236c:	77 a9                	ja     802317 <__udivdi3+0x27>
  80236e:	b8 01 00 00 00       	mov    $0x1,%eax
  802373:	eb a2                	jmp    802317 <__udivdi3+0x27>
  802375:	8d 76 00             	lea    0x0(%esi),%esi
  802378:	31 ff                	xor    %edi,%edi
  80237a:	31 c0                	xor    %eax,%eax
  80237c:	89 fa                	mov    %edi,%edx
  80237e:	83 c4 1c             	add    $0x1c,%esp
  802381:	5b                   	pop    %ebx
  802382:	5e                   	pop    %esi
  802383:	5f                   	pop    %edi
  802384:	5d                   	pop    %ebp
  802385:	c3                   	ret    
  802386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80238d:	8d 76 00             	lea    0x0(%esi),%esi
  802390:	89 f9                	mov    %edi,%ecx
  802392:	b8 20 00 00 00       	mov    $0x20,%eax
  802397:	29 f8                	sub    %edi,%eax
  802399:	d3 e2                	shl    %cl,%edx
  80239b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80239f:	89 c1                	mov    %eax,%ecx
  8023a1:	89 da                	mov    %ebx,%edx
  8023a3:	d3 ea                	shr    %cl,%edx
  8023a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023a9:	09 d1                	or     %edx,%ecx
  8023ab:	89 f2                	mov    %esi,%edx
  8023ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023b1:	89 f9                	mov    %edi,%ecx
  8023b3:	d3 e3                	shl    %cl,%ebx
  8023b5:	89 c1                	mov    %eax,%ecx
  8023b7:	d3 ea                	shr    %cl,%edx
  8023b9:	89 f9                	mov    %edi,%ecx
  8023bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023bf:	89 eb                	mov    %ebp,%ebx
  8023c1:	d3 e6                	shl    %cl,%esi
  8023c3:	89 c1                	mov    %eax,%ecx
  8023c5:	d3 eb                	shr    %cl,%ebx
  8023c7:	09 de                	or     %ebx,%esi
  8023c9:	89 f0                	mov    %esi,%eax
  8023cb:	f7 74 24 08          	divl   0x8(%esp)
  8023cf:	89 d6                	mov    %edx,%esi
  8023d1:	89 c3                	mov    %eax,%ebx
  8023d3:	f7 64 24 0c          	mull   0xc(%esp)
  8023d7:	39 d6                	cmp    %edx,%esi
  8023d9:	72 15                	jb     8023f0 <__udivdi3+0x100>
  8023db:	89 f9                	mov    %edi,%ecx
  8023dd:	d3 e5                	shl    %cl,%ebp
  8023df:	39 c5                	cmp    %eax,%ebp
  8023e1:	73 04                	jae    8023e7 <__udivdi3+0xf7>
  8023e3:	39 d6                	cmp    %edx,%esi
  8023e5:	74 09                	je     8023f0 <__udivdi3+0x100>
  8023e7:	89 d8                	mov    %ebx,%eax
  8023e9:	31 ff                	xor    %edi,%edi
  8023eb:	e9 27 ff ff ff       	jmp    802317 <__udivdi3+0x27>
  8023f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023f3:	31 ff                	xor    %edi,%edi
  8023f5:	e9 1d ff ff ff       	jmp    802317 <__udivdi3+0x27>
  8023fa:	66 90                	xchg   %ax,%ax
  8023fc:	66 90                	xchg   %ax,%ax
  8023fe:	66 90                	xchg   %ax,%ax

00802400 <__umoddi3>:
  802400:	55                   	push   %ebp
  802401:	57                   	push   %edi
  802402:	56                   	push   %esi
  802403:	53                   	push   %ebx
  802404:	83 ec 1c             	sub    $0x1c,%esp
  802407:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80240b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80240f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802413:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802417:	89 da                	mov    %ebx,%edx
  802419:	85 c0                	test   %eax,%eax
  80241b:	75 43                	jne    802460 <__umoddi3+0x60>
  80241d:	39 df                	cmp    %ebx,%edi
  80241f:	76 17                	jbe    802438 <__umoddi3+0x38>
  802421:	89 f0                	mov    %esi,%eax
  802423:	f7 f7                	div    %edi
  802425:	89 d0                	mov    %edx,%eax
  802427:	31 d2                	xor    %edx,%edx
  802429:	83 c4 1c             	add    $0x1c,%esp
  80242c:	5b                   	pop    %ebx
  80242d:	5e                   	pop    %esi
  80242e:	5f                   	pop    %edi
  80242f:	5d                   	pop    %ebp
  802430:	c3                   	ret    
  802431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802438:	89 fd                	mov    %edi,%ebp
  80243a:	85 ff                	test   %edi,%edi
  80243c:	75 0b                	jne    802449 <__umoddi3+0x49>
  80243e:	b8 01 00 00 00       	mov    $0x1,%eax
  802443:	31 d2                	xor    %edx,%edx
  802445:	f7 f7                	div    %edi
  802447:	89 c5                	mov    %eax,%ebp
  802449:	89 d8                	mov    %ebx,%eax
  80244b:	31 d2                	xor    %edx,%edx
  80244d:	f7 f5                	div    %ebp
  80244f:	89 f0                	mov    %esi,%eax
  802451:	f7 f5                	div    %ebp
  802453:	89 d0                	mov    %edx,%eax
  802455:	eb d0                	jmp    802427 <__umoddi3+0x27>
  802457:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80245e:	66 90                	xchg   %ax,%ax
  802460:	89 f1                	mov    %esi,%ecx
  802462:	39 d8                	cmp    %ebx,%eax
  802464:	76 0a                	jbe    802470 <__umoddi3+0x70>
  802466:	89 f0                	mov    %esi,%eax
  802468:	83 c4 1c             	add    $0x1c,%esp
  80246b:	5b                   	pop    %ebx
  80246c:	5e                   	pop    %esi
  80246d:	5f                   	pop    %edi
  80246e:	5d                   	pop    %ebp
  80246f:	c3                   	ret    
  802470:	0f bd e8             	bsr    %eax,%ebp
  802473:	83 f5 1f             	xor    $0x1f,%ebp
  802476:	75 20                	jne    802498 <__umoddi3+0x98>
  802478:	39 d8                	cmp    %ebx,%eax
  80247a:	0f 82 b0 00 00 00    	jb     802530 <__umoddi3+0x130>
  802480:	39 f7                	cmp    %esi,%edi
  802482:	0f 86 a8 00 00 00    	jbe    802530 <__umoddi3+0x130>
  802488:	89 c8                	mov    %ecx,%eax
  80248a:	83 c4 1c             	add    $0x1c,%esp
  80248d:	5b                   	pop    %ebx
  80248e:	5e                   	pop    %esi
  80248f:	5f                   	pop    %edi
  802490:	5d                   	pop    %ebp
  802491:	c3                   	ret    
  802492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802498:	89 e9                	mov    %ebp,%ecx
  80249a:	ba 20 00 00 00       	mov    $0x20,%edx
  80249f:	29 ea                	sub    %ebp,%edx
  8024a1:	d3 e0                	shl    %cl,%eax
  8024a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024a7:	89 d1                	mov    %edx,%ecx
  8024a9:	89 f8                	mov    %edi,%eax
  8024ab:	d3 e8                	shr    %cl,%eax
  8024ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024b5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024b9:	09 c1                	or     %eax,%ecx
  8024bb:	89 d8                	mov    %ebx,%eax
  8024bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024c1:	89 e9                	mov    %ebp,%ecx
  8024c3:	d3 e7                	shl    %cl,%edi
  8024c5:	89 d1                	mov    %edx,%ecx
  8024c7:	d3 e8                	shr    %cl,%eax
  8024c9:	89 e9                	mov    %ebp,%ecx
  8024cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024cf:	d3 e3                	shl    %cl,%ebx
  8024d1:	89 c7                	mov    %eax,%edi
  8024d3:	89 d1                	mov    %edx,%ecx
  8024d5:	89 f0                	mov    %esi,%eax
  8024d7:	d3 e8                	shr    %cl,%eax
  8024d9:	89 e9                	mov    %ebp,%ecx
  8024db:	89 fa                	mov    %edi,%edx
  8024dd:	d3 e6                	shl    %cl,%esi
  8024df:	09 d8                	or     %ebx,%eax
  8024e1:	f7 74 24 08          	divl   0x8(%esp)
  8024e5:	89 d1                	mov    %edx,%ecx
  8024e7:	89 f3                	mov    %esi,%ebx
  8024e9:	f7 64 24 0c          	mull   0xc(%esp)
  8024ed:	89 c6                	mov    %eax,%esi
  8024ef:	89 d7                	mov    %edx,%edi
  8024f1:	39 d1                	cmp    %edx,%ecx
  8024f3:	72 06                	jb     8024fb <__umoddi3+0xfb>
  8024f5:	75 10                	jne    802507 <__umoddi3+0x107>
  8024f7:	39 c3                	cmp    %eax,%ebx
  8024f9:	73 0c                	jae    802507 <__umoddi3+0x107>
  8024fb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024ff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802503:	89 d7                	mov    %edx,%edi
  802505:	89 c6                	mov    %eax,%esi
  802507:	89 ca                	mov    %ecx,%edx
  802509:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80250e:	29 f3                	sub    %esi,%ebx
  802510:	19 fa                	sbb    %edi,%edx
  802512:	89 d0                	mov    %edx,%eax
  802514:	d3 e0                	shl    %cl,%eax
  802516:	89 e9                	mov    %ebp,%ecx
  802518:	d3 eb                	shr    %cl,%ebx
  80251a:	d3 ea                	shr    %cl,%edx
  80251c:	09 d8                	or     %ebx,%eax
  80251e:	83 c4 1c             	add    $0x1c,%esp
  802521:	5b                   	pop    %ebx
  802522:	5e                   	pop    %esi
  802523:	5f                   	pop    %edi
  802524:	5d                   	pop    %ebp
  802525:	c3                   	ret    
  802526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80252d:	8d 76 00             	lea    0x0(%esi),%esi
  802530:	89 da                	mov    %ebx,%edx
  802532:	29 fe                	sub    %edi,%esi
  802534:	19 c2                	sbb    %eax,%edx
  802536:	89 f1                	mov    %esi,%ecx
  802538:	89 c8                	mov    %ecx,%eax
  80253a:	e9 4b ff ff ff       	jmp    80248a <__umoddi3+0x8a>
