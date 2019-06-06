
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
  800039:	68 dc 25 80 00       	push   $0x8025dc
  80003e:	68 a0 25 80 00       	push   $0x8025a0
  800043:	e8 dd 01 00 00       	call   800225 <cprintf>

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
  800062:	68 bf 25 80 00       	push   $0x8025bf
  800067:	e8 b9 01 00 00       	call   800225 <cprintf>
}
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	c9                   	leave  
  800070:	c3                   	ret    
		cprintf("eflags wrong\n");
  800071:	83 ec 0c             	sub    $0xc,%esp
  800074:	68 b1 25 80 00       	push   $0x8025b1
  800079:	e8 a7 01 00 00       	call   800225 <cprintf>
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
  800096:	e8 9d 0c 00 00       	call   800d38 <sys_getenvid>
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

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8000fa:	a1 08 40 80 00       	mov    0x804008,%eax
  8000ff:	8b 40 48             	mov    0x48(%eax),%eax
  800102:	83 ec 08             	sub    $0x8,%esp
  800105:	50                   	push   %eax
  800106:	68 e2 25 80 00       	push   $0x8025e2
  80010b:	e8 15 01 00 00       	call   800225 <cprintf>
	cprintf("before umain\n");
  800110:	c7 04 24 00 26 80 00 	movl   $0x802600,(%esp)
  800117:	e8 09 01 00 00       	call   800225 <cprintf>
	// call user main routine
	umain(argc, argv);
  80011c:	83 c4 08             	add    $0x8,%esp
  80011f:	ff 75 0c             	pushl  0xc(%ebp)
  800122:	ff 75 08             	pushl  0x8(%ebp)
  800125:	e8 09 ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  80012a:	c7 04 24 0e 26 80 00 	movl   $0x80260e,(%esp)
  800131:	e8 ef 00 00 00       	call   800225 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800136:	a1 08 40 80 00       	mov    0x804008,%eax
  80013b:	8b 40 48             	mov    0x48(%eax),%eax
  80013e:	83 c4 08             	add    $0x8,%esp
  800141:	50                   	push   %eax
  800142:	68 1b 26 80 00       	push   $0x80261b
  800147:	e8 d9 00 00 00       	call   800225 <cprintf>
	// exit gracefully
	exit();
  80014c:	e8 0b 00 00 00       	call   80015c <exit>
}
  800151:	83 c4 10             	add    $0x10,%esp
  800154:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800157:	5b                   	pop    %ebx
  800158:	5e                   	pop    %esi
  800159:	5f                   	pop    %edi
  80015a:	5d                   	pop    %ebp
  80015b:	c3                   	ret    

0080015c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800162:	a1 08 40 80 00       	mov    0x804008,%eax
  800167:	8b 40 48             	mov    0x48(%eax),%eax
  80016a:	68 48 26 80 00       	push   $0x802648
  80016f:	50                   	push   %eax
  800170:	68 3a 26 80 00       	push   $0x80263a
  800175:	e8 ab 00 00 00       	call   800225 <cprintf>
	close_all();
  80017a:	e8 a4 10 00 00       	call   801223 <close_all>
	sys_env_destroy(0);
  80017f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800186:	e8 6c 0b 00 00       	call   800cf7 <sys_env_destroy>
}
  80018b:	83 c4 10             	add    $0x10,%esp
  80018e:	c9                   	leave  
  80018f:	c3                   	ret    

00800190 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800190:	55                   	push   %ebp
  800191:	89 e5                	mov    %esp,%ebp
  800193:	53                   	push   %ebx
  800194:	83 ec 04             	sub    $0x4,%esp
  800197:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80019a:	8b 13                	mov    (%ebx),%edx
  80019c:	8d 42 01             	lea    0x1(%edx),%eax
  80019f:	89 03                	mov    %eax,(%ebx)
  8001a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001a4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001a8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ad:	74 09                	je     8001b8 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001af:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001b6:	c9                   	leave  
  8001b7:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001b8:	83 ec 08             	sub    $0x8,%esp
  8001bb:	68 ff 00 00 00       	push   $0xff
  8001c0:	8d 43 08             	lea    0x8(%ebx),%eax
  8001c3:	50                   	push   %eax
  8001c4:	e8 f1 0a 00 00       	call   800cba <sys_cputs>
		b->idx = 0;
  8001c9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001cf:	83 c4 10             	add    $0x10,%esp
  8001d2:	eb db                	jmp    8001af <putch+0x1f>

008001d4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001d4:	55                   	push   %ebp
  8001d5:	89 e5                	mov    %esp,%ebp
  8001d7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001dd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001e4:	00 00 00 
	b.cnt = 0;
  8001e7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ee:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001f1:	ff 75 0c             	pushl  0xc(%ebp)
  8001f4:	ff 75 08             	pushl  0x8(%ebp)
  8001f7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001fd:	50                   	push   %eax
  8001fe:	68 90 01 80 00       	push   $0x800190
  800203:	e8 4a 01 00 00       	call   800352 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800208:	83 c4 08             	add    $0x8,%esp
  80020b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800211:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800217:	50                   	push   %eax
  800218:	e8 9d 0a 00 00       	call   800cba <sys_cputs>

	return b.cnt;
}
  80021d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800223:	c9                   	leave  
  800224:	c3                   	ret    

00800225 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80022b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80022e:	50                   	push   %eax
  80022f:	ff 75 08             	pushl  0x8(%ebp)
  800232:	e8 9d ff ff ff       	call   8001d4 <vcprintf>
	va_end(ap);

	return cnt;
}
  800237:	c9                   	leave  
  800238:	c3                   	ret    

00800239 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800239:	55                   	push   %ebp
  80023a:	89 e5                	mov    %esp,%ebp
  80023c:	57                   	push   %edi
  80023d:	56                   	push   %esi
  80023e:	53                   	push   %ebx
  80023f:	83 ec 1c             	sub    $0x1c,%esp
  800242:	89 c6                	mov    %eax,%esi
  800244:	89 d7                	mov    %edx,%edi
  800246:	8b 45 08             	mov    0x8(%ebp),%eax
  800249:	8b 55 0c             	mov    0xc(%ebp),%edx
  80024c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80024f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800252:	8b 45 10             	mov    0x10(%ebp),%eax
  800255:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800258:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80025c:	74 2c                	je     80028a <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80025e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800261:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800268:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80026b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80026e:	39 c2                	cmp    %eax,%edx
  800270:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800273:	73 43                	jae    8002b8 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800275:	83 eb 01             	sub    $0x1,%ebx
  800278:	85 db                	test   %ebx,%ebx
  80027a:	7e 6c                	jle    8002e8 <printnum+0xaf>
				putch(padc, putdat);
  80027c:	83 ec 08             	sub    $0x8,%esp
  80027f:	57                   	push   %edi
  800280:	ff 75 18             	pushl  0x18(%ebp)
  800283:	ff d6                	call   *%esi
  800285:	83 c4 10             	add    $0x10,%esp
  800288:	eb eb                	jmp    800275 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	6a 20                	push   $0x20
  80028f:	6a 00                	push   $0x0
  800291:	50                   	push   %eax
  800292:	ff 75 e4             	pushl  -0x1c(%ebp)
  800295:	ff 75 e0             	pushl  -0x20(%ebp)
  800298:	89 fa                	mov    %edi,%edx
  80029a:	89 f0                	mov    %esi,%eax
  80029c:	e8 98 ff ff ff       	call   800239 <printnum>
		while (--width > 0)
  8002a1:	83 c4 20             	add    $0x20,%esp
  8002a4:	83 eb 01             	sub    $0x1,%ebx
  8002a7:	85 db                	test   %ebx,%ebx
  8002a9:	7e 65                	jle    800310 <printnum+0xd7>
			putch(padc, putdat);
  8002ab:	83 ec 08             	sub    $0x8,%esp
  8002ae:	57                   	push   %edi
  8002af:	6a 20                	push   $0x20
  8002b1:	ff d6                	call   *%esi
  8002b3:	83 c4 10             	add    $0x10,%esp
  8002b6:	eb ec                	jmp    8002a4 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	ff 75 18             	pushl  0x18(%ebp)
  8002be:	83 eb 01             	sub    $0x1,%ebx
  8002c1:	53                   	push   %ebx
  8002c2:	50                   	push   %eax
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c9:	ff 75 d8             	pushl  -0x28(%ebp)
  8002cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8002d2:	e8 69 20 00 00       	call   802340 <__udivdi3>
  8002d7:	83 c4 18             	add    $0x18,%esp
  8002da:	52                   	push   %edx
  8002db:	50                   	push   %eax
  8002dc:	89 fa                	mov    %edi,%edx
  8002de:	89 f0                	mov    %esi,%eax
  8002e0:	e8 54 ff ff ff       	call   800239 <printnum>
  8002e5:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002e8:	83 ec 08             	sub    $0x8,%esp
  8002eb:	57                   	push   %edi
  8002ec:	83 ec 04             	sub    $0x4,%esp
  8002ef:	ff 75 dc             	pushl  -0x24(%ebp)
  8002f2:	ff 75 d8             	pushl  -0x28(%ebp)
  8002f5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f8:	ff 75 e0             	pushl  -0x20(%ebp)
  8002fb:	e8 50 21 00 00       	call   802450 <__umoddi3>
  800300:	83 c4 14             	add    $0x14,%esp
  800303:	0f be 80 4d 26 80 00 	movsbl 0x80264d(%eax),%eax
  80030a:	50                   	push   %eax
  80030b:	ff d6                	call   *%esi
  80030d:	83 c4 10             	add    $0x10,%esp
	}
}
  800310:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800313:	5b                   	pop    %ebx
  800314:	5e                   	pop    %esi
  800315:	5f                   	pop    %edi
  800316:	5d                   	pop    %ebp
  800317:	c3                   	ret    

00800318 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80031e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800322:	8b 10                	mov    (%eax),%edx
  800324:	3b 50 04             	cmp    0x4(%eax),%edx
  800327:	73 0a                	jae    800333 <sprintputch+0x1b>
		*b->buf++ = ch;
  800329:	8d 4a 01             	lea    0x1(%edx),%ecx
  80032c:	89 08                	mov    %ecx,(%eax)
  80032e:	8b 45 08             	mov    0x8(%ebp),%eax
  800331:	88 02                	mov    %al,(%edx)
}
  800333:	5d                   	pop    %ebp
  800334:	c3                   	ret    

00800335 <printfmt>:
{
  800335:	55                   	push   %ebp
  800336:	89 e5                	mov    %esp,%ebp
  800338:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80033b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80033e:	50                   	push   %eax
  80033f:	ff 75 10             	pushl  0x10(%ebp)
  800342:	ff 75 0c             	pushl  0xc(%ebp)
  800345:	ff 75 08             	pushl  0x8(%ebp)
  800348:	e8 05 00 00 00       	call   800352 <vprintfmt>
}
  80034d:	83 c4 10             	add    $0x10,%esp
  800350:	c9                   	leave  
  800351:	c3                   	ret    

00800352 <vprintfmt>:
{
  800352:	55                   	push   %ebp
  800353:	89 e5                	mov    %esp,%ebp
  800355:	57                   	push   %edi
  800356:	56                   	push   %esi
  800357:	53                   	push   %ebx
  800358:	83 ec 3c             	sub    $0x3c,%esp
  80035b:	8b 75 08             	mov    0x8(%ebp),%esi
  80035e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800361:	8b 7d 10             	mov    0x10(%ebp),%edi
  800364:	e9 32 04 00 00       	jmp    80079b <vprintfmt+0x449>
		padc = ' ';
  800369:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80036d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800374:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80037b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800382:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800389:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800390:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800395:	8d 47 01             	lea    0x1(%edi),%eax
  800398:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80039b:	0f b6 17             	movzbl (%edi),%edx
  80039e:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003a1:	3c 55                	cmp    $0x55,%al
  8003a3:	0f 87 12 05 00 00    	ja     8008bb <vprintfmt+0x569>
  8003a9:	0f b6 c0             	movzbl %al,%eax
  8003ac:	ff 24 85 20 28 80 00 	jmp    *0x802820(,%eax,4)
  8003b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003b6:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003ba:	eb d9                	jmp    800395 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003bc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003bf:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003c3:	eb d0                	jmp    800395 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003c5:	0f b6 d2             	movzbl %dl,%edx
  8003c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d0:	89 75 08             	mov    %esi,0x8(%ebp)
  8003d3:	eb 03                	jmp    8003d8 <vprintfmt+0x86>
  8003d5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003d8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003db:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003df:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003e2:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003e5:	83 fe 09             	cmp    $0x9,%esi
  8003e8:	76 eb                	jbe    8003d5 <vprintfmt+0x83>
  8003ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ed:	8b 75 08             	mov    0x8(%ebp),%esi
  8003f0:	eb 14                	jmp    800406 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f5:	8b 00                	mov    (%eax),%eax
  8003f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fd:	8d 40 04             	lea    0x4(%eax),%eax
  800400:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800403:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800406:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80040a:	79 89                	jns    800395 <vprintfmt+0x43>
				width = precision, precision = -1;
  80040c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80040f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800412:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800419:	e9 77 ff ff ff       	jmp    800395 <vprintfmt+0x43>
  80041e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800421:	85 c0                	test   %eax,%eax
  800423:	0f 48 c1             	cmovs  %ecx,%eax
  800426:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800429:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80042c:	e9 64 ff ff ff       	jmp    800395 <vprintfmt+0x43>
  800431:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800434:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80043b:	e9 55 ff ff ff       	jmp    800395 <vprintfmt+0x43>
			lflag++;
  800440:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800444:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800447:	e9 49 ff ff ff       	jmp    800395 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80044c:	8b 45 14             	mov    0x14(%ebp),%eax
  80044f:	8d 78 04             	lea    0x4(%eax),%edi
  800452:	83 ec 08             	sub    $0x8,%esp
  800455:	53                   	push   %ebx
  800456:	ff 30                	pushl  (%eax)
  800458:	ff d6                	call   *%esi
			break;
  80045a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80045d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800460:	e9 33 03 00 00       	jmp    800798 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800465:	8b 45 14             	mov    0x14(%ebp),%eax
  800468:	8d 78 04             	lea    0x4(%eax),%edi
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	99                   	cltd   
  80046e:	31 d0                	xor    %edx,%eax
  800470:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800472:	83 f8 11             	cmp    $0x11,%eax
  800475:	7f 23                	jg     80049a <vprintfmt+0x148>
  800477:	8b 14 85 80 29 80 00 	mov    0x802980(,%eax,4),%edx
  80047e:	85 d2                	test   %edx,%edx
  800480:	74 18                	je     80049a <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800482:	52                   	push   %edx
  800483:	68 9d 2a 80 00       	push   $0x802a9d
  800488:	53                   	push   %ebx
  800489:	56                   	push   %esi
  80048a:	e8 a6 fe ff ff       	call   800335 <printfmt>
  80048f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800492:	89 7d 14             	mov    %edi,0x14(%ebp)
  800495:	e9 fe 02 00 00       	jmp    800798 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80049a:	50                   	push   %eax
  80049b:	68 65 26 80 00       	push   $0x802665
  8004a0:	53                   	push   %ebx
  8004a1:	56                   	push   %esi
  8004a2:	e8 8e fe ff ff       	call   800335 <printfmt>
  8004a7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004aa:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004ad:	e9 e6 02 00 00       	jmp    800798 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b5:	83 c0 04             	add    $0x4,%eax
  8004b8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004be:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004c0:	85 c9                	test   %ecx,%ecx
  8004c2:	b8 5e 26 80 00       	mov    $0x80265e,%eax
  8004c7:	0f 45 c1             	cmovne %ecx,%eax
  8004ca:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004cd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004d1:	7e 06                	jle    8004d9 <vprintfmt+0x187>
  8004d3:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004d7:	75 0d                	jne    8004e6 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004dc:	89 c7                	mov    %eax,%edi
  8004de:	03 45 e0             	add    -0x20(%ebp),%eax
  8004e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004e4:	eb 53                	jmp    800539 <vprintfmt+0x1e7>
  8004e6:	83 ec 08             	sub    $0x8,%esp
  8004e9:	ff 75 d8             	pushl  -0x28(%ebp)
  8004ec:	50                   	push   %eax
  8004ed:	e8 71 04 00 00       	call   800963 <strnlen>
  8004f2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004f5:	29 c1                	sub    %eax,%ecx
  8004f7:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004fa:	83 c4 10             	add    $0x10,%esp
  8004fd:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004ff:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800503:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800506:	eb 0f                	jmp    800517 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800508:	83 ec 08             	sub    $0x8,%esp
  80050b:	53                   	push   %ebx
  80050c:	ff 75 e0             	pushl  -0x20(%ebp)
  80050f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800511:	83 ef 01             	sub    $0x1,%edi
  800514:	83 c4 10             	add    $0x10,%esp
  800517:	85 ff                	test   %edi,%edi
  800519:	7f ed                	jg     800508 <vprintfmt+0x1b6>
  80051b:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80051e:	85 c9                	test   %ecx,%ecx
  800520:	b8 00 00 00 00       	mov    $0x0,%eax
  800525:	0f 49 c1             	cmovns %ecx,%eax
  800528:	29 c1                	sub    %eax,%ecx
  80052a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80052d:	eb aa                	jmp    8004d9 <vprintfmt+0x187>
					putch(ch, putdat);
  80052f:	83 ec 08             	sub    $0x8,%esp
  800532:	53                   	push   %ebx
  800533:	52                   	push   %edx
  800534:	ff d6                	call   *%esi
  800536:	83 c4 10             	add    $0x10,%esp
  800539:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80053c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80053e:	83 c7 01             	add    $0x1,%edi
  800541:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800545:	0f be d0             	movsbl %al,%edx
  800548:	85 d2                	test   %edx,%edx
  80054a:	74 4b                	je     800597 <vprintfmt+0x245>
  80054c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800550:	78 06                	js     800558 <vprintfmt+0x206>
  800552:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800556:	78 1e                	js     800576 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800558:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80055c:	74 d1                	je     80052f <vprintfmt+0x1dd>
  80055e:	0f be c0             	movsbl %al,%eax
  800561:	83 e8 20             	sub    $0x20,%eax
  800564:	83 f8 5e             	cmp    $0x5e,%eax
  800567:	76 c6                	jbe    80052f <vprintfmt+0x1dd>
					putch('?', putdat);
  800569:	83 ec 08             	sub    $0x8,%esp
  80056c:	53                   	push   %ebx
  80056d:	6a 3f                	push   $0x3f
  80056f:	ff d6                	call   *%esi
  800571:	83 c4 10             	add    $0x10,%esp
  800574:	eb c3                	jmp    800539 <vprintfmt+0x1e7>
  800576:	89 cf                	mov    %ecx,%edi
  800578:	eb 0e                	jmp    800588 <vprintfmt+0x236>
				putch(' ', putdat);
  80057a:	83 ec 08             	sub    $0x8,%esp
  80057d:	53                   	push   %ebx
  80057e:	6a 20                	push   $0x20
  800580:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800582:	83 ef 01             	sub    $0x1,%edi
  800585:	83 c4 10             	add    $0x10,%esp
  800588:	85 ff                	test   %edi,%edi
  80058a:	7f ee                	jg     80057a <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80058c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80058f:	89 45 14             	mov    %eax,0x14(%ebp)
  800592:	e9 01 02 00 00       	jmp    800798 <vprintfmt+0x446>
  800597:	89 cf                	mov    %ecx,%edi
  800599:	eb ed                	jmp    800588 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80059b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80059e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005a5:	e9 eb fd ff ff       	jmp    800395 <vprintfmt+0x43>
	if (lflag >= 2)
  8005aa:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005ae:	7f 21                	jg     8005d1 <vprintfmt+0x27f>
	else if (lflag)
  8005b0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005b4:	74 68                	je     80061e <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b9:	8b 00                	mov    (%eax),%eax
  8005bb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005be:	89 c1                	mov    %eax,%ecx
  8005c0:	c1 f9 1f             	sar    $0x1f,%ecx
  8005c3:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	8d 40 04             	lea    0x4(%eax),%eax
  8005cc:	89 45 14             	mov    %eax,0x14(%ebp)
  8005cf:	eb 17                	jmp    8005e8 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d4:	8b 50 04             	mov    0x4(%eax),%edx
  8005d7:	8b 00                	mov    (%eax),%eax
  8005d9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005dc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8d 40 08             	lea    0x8(%eax),%eax
  8005e5:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005eb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f1:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005f4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005f8:	78 3f                	js     800639 <vprintfmt+0x2e7>
			base = 10;
  8005fa:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005ff:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800603:	0f 84 71 01 00 00    	je     80077a <vprintfmt+0x428>
				putch('+', putdat);
  800609:	83 ec 08             	sub    $0x8,%esp
  80060c:	53                   	push   %ebx
  80060d:	6a 2b                	push   $0x2b
  80060f:	ff d6                	call   *%esi
  800611:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800614:	b8 0a 00 00 00       	mov    $0xa,%eax
  800619:	e9 5c 01 00 00       	jmp    80077a <vprintfmt+0x428>
		return va_arg(*ap, int);
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	8b 00                	mov    (%eax),%eax
  800623:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800626:	89 c1                	mov    %eax,%ecx
  800628:	c1 f9 1f             	sar    $0x1f,%ecx
  80062b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	8d 40 04             	lea    0x4(%eax),%eax
  800634:	89 45 14             	mov    %eax,0x14(%ebp)
  800637:	eb af                	jmp    8005e8 <vprintfmt+0x296>
				putch('-', putdat);
  800639:	83 ec 08             	sub    $0x8,%esp
  80063c:	53                   	push   %ebx
  80063d:	6a 2d                	push   $0x2d
  80063f:	ff d6                	call   *%esi
				num = -(long long) num;
  800641:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800644:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800647:	f7 d8                	neg    %eax
  800649:	83 d2 00             	adc    $0x0,%edx
  80064c:	f7 da                	neg    %edx
  80064e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800651:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800654:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800657:	b8 0a 00 00 00       	mov    $0xa,%eax
  80065c:	e9 19 01 00 00       	jmp    80077a <vprintfmt+0x428>
	if (lflag >= 2)
  800661:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800665:	7f 29                	jg     800690 <vprintfmt+0x33e>
	else if (lflag)
  800667:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80066b:	74 44                	je     8006b1 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	8b 00                	mov    (%eax),%eax
  800672:	ba 00 00 00 00       	mov    $0x0,%edx
  800677:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	8d 40 04             	lea    0x4(%eax),%eax
  800683:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800686:	b8 0a 00 00 00       	mov    $0xa,%eax
  80068b:	e9 ea 00 00 00       	jmp    80077a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	8b 50 04             	mov    0x4(%eax),%edx
  800696:	8b 00                	mov    (%eax),%eax
  800698:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80069e:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a1:	8d 40 08             	lea    0x8(%eax),%eax
  8006a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006a7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ac:	e9 c9 00 00 00       	jmp    80077a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	8b 00                	mov    (%eax),%eax
  8006b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006be:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	8d 40 04             	lea    0x4(%eax),%eax
  8006c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ca:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006cf:	e9 a6 00 00 00       	jmp    80077a <vprintfmt+0x428>
			putch('0', putdat);
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	53                   	push   %ebx
  8006d8:	6a 30                	push   $0x30
  8006da:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006dc:	83 c4 10             	add    $0x10,%esp
  8006df:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006e3:	7f 26                	jg     80070b <vprintfmt+0x3b9>
	else if (lflag)
  8006e5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006e9:	74 3e                	je     800729 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	8d 40 04             	lea    0x4(%eax),%eax
  800701:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800704:	b8 08 00 00 00       	mov    $0x8,%eax
  800709:	eb 6f                	jmp    80077a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	8b 50 04             	mov    0x4(%eax),%edx
  800711:	8b 00                	mov    (%eax),%eax
  800713:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800716:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800719:	8b 45 14             	mov    0x14(%ebp),%eax
  80071c:	8d 40 08             	lea    0x8(%eax),%eax
  80071f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800722:	b8 08 00 00 00       	mov    $0x8,%eax
  800727:	eb 51                	jmp    80077a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800729:	8b 45 14             	mov    0x14(%ebp),%eax
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	ba 00 00 00 00       	mov    $0x0,%edx
  800733:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800736:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800739:	8b 45 14             	mov    0x14(%ebp),%eax
  80073c:	8d 40 04             	lea    0x4(%eax),%eax
  80073f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800742:	b8 08 00 00 00       	mov    $0x8,%eax
  800747:	eb 31                	jmp    80077a <vprintfmt+0x428>
			putch('0', putdat);
  800749:	83 ec 08             	sub    $0x8,%esp
  80074c:	53                   	push   %ebx
  80074d:	6a 30                	push   $0x30
  80074f:	ff d6                	call   *%esi
			putch('x', putdat);
  800751:	83 c4 08             	add    $0x8,%esp
  800754:	53                   	push   %ebx
  800755:	6a 78                	push   $0x78
  800757:	ff d6                	call   *%esi
			num = (unsigned long long)
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	8b 00                	mov    (%eax),%eax
  80075e:	ba 00 00 00 00       	mov    $0x0,%edx
  800763:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800766:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800769:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80076c:	8b 45 14             	mov    0x14(%ebp),%eax
  80076f:	8d 40 04             	lea    0x4(%eax),%eax
  800772:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800775:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80077a:	83 ec 0c             	sub    $0xc,%esp
  80077d:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800781:	52                   	push   %edx
  800782:	ff 75 e0             	pushl  -0x20(%ebp)
  800785:	50                   	push   %eax
  800786:	ff 75 dc             	pushl  -0x24(%ebp)
  800789:	ff 75 d8             	pushl  -0x28(%ebp)
  80078c:	89 da                	mov    %ebx,%edx
  80078e:	89 f0                	mov    %esi,%eax
  800790:	e8 a4 fa ff ff       	call   800239 <printnum>
			break;
  800795:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800798:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80079b:	83 c7 01             	add    $0x1,%edi
  80079e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007a2:	83 f8 25             	cmp    $0x25,%eax
  8007a5:	0f 84 be fb ff ff    	je     800369 <vprintfmt+0x17>
			if (ch == '\0')
  8007ab:	85 c0                	test   %eax,%eax
  8007ad:	0f 84 28 01 00 00    	je     8008db <vprintfmt+0x589>
			putch(ch, putdat);
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	53                   	push   %ebx
  8007b7:	50                   	push   %eax
  8007b8:	ff d6                	call   *%esi
  8007ba:	83 c4 10             	add    $0x10,%esp
  8007bd:	eb dc                	jmp    80079b <vprintfmt+0x449>
	if (lflag >= 2)
  8007bf:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007c3:	7f 26                	jg     8007eb <vprintfmt+0x499>
	else if (lflag)
  8007c5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007c9:	74 41                	je     80080c <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ce:	8b 00                	mov    (%eax),%eax
  8007d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007db:	8b 45 14             	mov    0x14(%ebp),%eax
  8007de:	8d 40 04             	lea    0x4(%eax),%eax
  8007e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e4:	b8 10 00 00 00       	mov    $0x10,%eax
  8007e9:	eb 8f                	jmp    80077a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ee:	8b 50 04             	mov    0x4(%eax),%edx
  8007f1:	8b 00                	mov    (%eax),%eax
  8007f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	8d 40 08             	lea    0x8(%eax),%eax
  8007ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800802:	b8 10 00 00 00       	mov    $0x10,%eax
  800807:	e9 6e ff ff ff       	jmp    80077a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80080c:	8b 45 14             	mov    0x14(%ebp),%eax
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	ba 00 00 00 00       	mov    $0x0,%edx
  800816:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800819:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	8d 40 04             	lea    0x4(%eax),%eax
  800822:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800825:	b8 10 00 00 00       	mov    $0x10,%eax
  80082a:	e9 4b ff ff ff       	jmp    80077a <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80082f:	8b 45 14             	mov    0x14(%ebp),%eax
  800832:	83 c0 04             	add    $0x4,%eax
  800835:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	85 c0                	test   %eax,%eax
  80083f:	74 14                	je     800855 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800841:	8b 13                	mov    (%ebx),%edx
  800843:	83 fa 7f             	cmp    $0x7f,%edx
  800846:	7f 37                	jg     80087f <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800848:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80084a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80084d:	89 45 14             	mov    %eax,0x14(%ebp)
  800850:	e9 43 ff ff ff       	jmp    800798 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800855:	b8 0a 00 00 00       	mov    $0xa,%eax
  80085a:	bf 81 27 80 00       	mov    $0x802781,%edi
							putch(ch, putdat);
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	53                   	push   %ebx
  800863:	50                   	push   %eax
  800864:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800866:	83 c7 01             	add    $0x1,%edi
  800869:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80086d:	83 c4 10             	add    $0x10,%esp
  800870:	85 c0                	test   %eax,%eax
  800872:	75 eb                	jne    80085f <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800874:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800877:	89 45 14             	mov    %eax,0x14(%ebp)
  80087a:	e9 19 ff ff ff       	jmp    800798 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80087f:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800881:	b8 0a 00 00 00       	mov    $0xa,%eax
  800886:	bf b9 27 80 00       	mov    $0x8027b9,%edi
							putch(ch, putdat);
  80088b:	83 ec 08             	sub    $0x8,%esp
  80088e:	53                   	push   %ebx
  80088f:	50                   	push   %eax
  800890:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800892:	83 c7 01             	add    $0x1,%edi
  800895:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800899:	83 c4 10             	add    $0x10,%esp
  80089c:	85 c0                	test   %eax,%eax
  80089e:	75 eb                	jne    80088b <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008a3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a6:	e9 ed fe ff ff       	jmp    800798 <vprintfmt+0x446>
			putch(ch, putdat);
  8008ab:	83 ec 08             	sub    $0x8,%esp
  8008ae:	53                   	push   %ebx
  8008af:	6a 25                	push   $0x25
  8008b1:	ff d6                	call   *%esi
			break;
  8008b3:	83 c4 10             	add    $0x10,%esp
  8008b6:	e9 dd fe ff ff       	jmp    800798 <vprintfmt+0x446>
			putch('%', putdat);
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	53                   	push   %ebx
  8008bf:	6a 25                	push   $0x25
  8008c1:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008c3:	83 c4 10             	add    $0x10,%esp
  8008c6:	89 f8                	mov    %edi,%eax
  8008c8:	eb 03                	jmp    8008cd <vprintfmt+0x57b>
  8008ca:	83 e8 01             	sub    $0x1,%eax
  8008cd:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008d1:	75 f7                	jne    8008ca <vprintfmt+0x578>
  8008d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008d6:	e9 bd fe ff ff       	jmp    800798 <vprintfmt+0x446>
}
  8008db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008de:	5b                   	pop    %ebx
  8008df:	5e                   	pop    %esi
  8008e0:	5f                   	pop    %edi
  8008e1:	5d                   	pop    %ebp
  8008e2:	c3                   	ret    

008008e3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008e3:	55                   	push   %ebp
  8008e4:	89 e5                	mov    %esp,%ebp
  8008e6:	83 ec 18             	sub    $0x18,%esp
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008f2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008f6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800900:	85 c0                	test   %eax,%eax
  800902:	74 26                	je     80092a <vsnprintf+0x47>
  800904:	85 d2                	test   %edx,%edx
  800906:	7e 22                	jle    80092a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800908:	ff 75 14             	pushl  0x14(%ebp)
  80090b:	ff 75 10             	pushl  0x10(%ebp)
  80090e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800911:	50                   	push   %eax
  800912:	68 18 03 80 00       	push   $0x800318
  800917:	e8 36 fa ff ff       	call   800352 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80091c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80091f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800925:	83 c4 10             	add    $0x10,%esp
}
  800928:	c9                   	leave  
  800929:	c3                   	ret    
		return -E_INVAL;
  80092a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80092f:	eb f7                	jmp    800928 <vsnprintf+0x45>

00800931 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800931:	55                   	push   %ebp
  800932:	89 e5                	mov    %esp,%ebp
  800934:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800937:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80093a:	50                   	push   %eax
  80093b:	ff 75 10             	pushl  0x10(%ebp)
  80093e:	ff 75 0c             	pushl  0xc(%ebp)
  800941:	ff 75 08             	pushl  0x8(%ebp)
  800944:	e8 9a ff ff ff       	call   8008e3 <vsnprintf>
	va_end(ap);

	return rc;
}
  800949:	c9                   	leave  
  80094a:	c3                   	ret    

0080094b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80094b:	55                   	push   %ebp
  80094c:	89 e5                	mov    %esp,%ebp
  80094e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800951:	b8 00 00 00 00       	mov    $0x0,%eax
  800956:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80095a:	74 05                	je     800961 <strlen+0x16>
		n++;
  80095c:	83 c0 01             	add    $0x1,%eax
  80095f:	eb f5                	jmp    800956 <strlen+0xb>
	return n;
}
  800961:	5d                   	pop    %ebp
  800962:	c3                   	ret    

00800963 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800963:	55                   	push   %ebp
  800964:	89 e5                	mov    %esp,%ebp
  800966:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800969:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80096c:	ba 00 00 00 00       	mov    $0x0,%edx
  800971:	39 c2                	cmp    %eax,%edx
  800973:	74 0d                	je     800982 <strnlen+0x1f>
  800975:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800979:	74 05                	je     800980 <strnlen+0x1d>
		n++;
  80097b:	83 c2 01             	add    $0x1,%edx
  80097e:	eb f1                	jmp    800971 <strnlen+0xe>
  800980:	89 d0                	mov    %edx,%eax
	return n;
}
  800982:	5d                   	pop    %ebp
  800983:	c3                   	ret    

00800984 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	53                   	push   %ebx
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80098e:	ba 00 00 00 00       	mov    $0x0,%edx
  800993:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800997:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80099a:	83 c2 01             	add    $0x1,%edx
  80099d:	84 c9                	test   %cl,%cl
  80099f:	75 f2                	jne    800993 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009a1:	5b                   	pop    %ebx
  8009a2:	5d                   	pop    %ebp
  8009a3:	c3                   	ret    

008009a4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
  8009a7:	53                   	push   %ebx
  8009a8:	83 ec 10             	sub    $0x10,%esp
  8009ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009ae:	53                   	push   %ebx
  8009af:	e8 97 ff ff ff       	call   80094b <strlen>
  8009b4:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009b7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ba:	01 d8                	add    %ebx,%eax
  8009bc:	50                   	push   %eax
  8009bd:	e8 c2 ff ff ff       	call   800984 <strcpy>
	return dst;
}
  8009c2:	89 d8                	mov    %ebx,%eax
  8009c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009c7:	c9                   	leave  
  8009c8:	c3                   	ret    

008009c9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	56                   	push   %esi
  8009cd:	53                   	push   %ebx
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009d4:	89 c6                	mov    %eax,%esi
  8009d6:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009d9:	89 c2                	mov    %eax,%edx
  8009db:	39 f2                	cmp    %esi,%edx
  8009dd:	74 11                	je     8009f0 <strncpy+0x27>
		*dst++ = *src;
  8009df:	83 c2 01             	add    $0x1,%edx
  8009e2:	0f b6 19             	movzbl (%ecx),%ebx
  8009e5:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009e8:	80 fb 01             	cmp    $0x1,%bl
  8009eb:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009ee:	eb eb                	jmp    8009db <strncpy+0x12>
	}
	return ret;
}
  8009f0:	5b                   	pop    %ebx
  8009f1:	5e                   	pop    %esi
  8009f2:	5d                   	pop    %ebp
  8009f3:	c3                   	ret    

008009f4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009f4:	55                   	push   %ebp
  8009f5:	89 e5                	mov    %esp,%ebp
  8009f7:	56                   	push   %esi
  8009f8:	53                   	push   %ebx
  8009f9:	8b 75 08             	mov    0x8(%ebp),%esi
  8009fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ff:	8b 55 10             	mov    0x10(%ebp),%edx
  800a02:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a04:	85 d2                	test   %edx,%edx
  800a06:	74 21                	je     800a29 <strlcpy+0x35>
  800a08:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a0c:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a0e:	39 c2                	cmp    %eax,%edx
  800a10:	74 14                	je     800a26 <strlcpy+0x32>
  800a12:	0f b6 19             	movzbl (%ecx),%ebx
  800a15:	84 db                	test   %bl,%bl
  800a17:	74 0b                	je     800a24 <strlcpy+0x30>
			*dst++ = *src++;
  800a19:	83 c1 01             	add    $0x1,%ecx
  800a1c:	83 c2 01             	add    $0x1,%edx
  800a1f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a22:	eb ea                	jmp    800a0e <strlcpy+0x1a>
  800a24:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a26:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a29:	29 f0                	sub    %esi,%eax
}
  800a2b:	5b                   	pop    %ebx
  800a2c:	5e                   	pop    %esi
  800a2d:	5d                   	pop    %ebp
  800a2e:	c3                   	ret    

00800a2f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a35:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a38:	0f b6 01             	movzbl (%ecx),%eax
  800a3b:	84 c0                	test   %al,%al
  800a3d:	74 0c                	je     800a4b <strcmp+0x1c>
  800a3f:	3a 02                	cmp    (%edx),%al
  800a41:	75 08                	jne    800a4b <strcmp+0x1c>
		p++, q++;
  800a43:	83 c1 01             	add    $0x1,%ecx
  800a46:	83 c2 01             	add    $0x1,%edx
  800a49:	eb ed                	jmp    800a38 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a4b:	0f b6 c0             	movzbl %al,%eax
  800a4e:	0f b6 12             	movzbl (%edx),%edx
  800a51:	29 d0                	sub    %edx,%eax
}
  800a53:	5d                   	pop    %ebp
  800a54:	c3                   	ret    

00800a55 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a55:	55                   	push   %ebp
  800a56:	89 e5                	mov    %esp,%ebp
  800a58:	53                   	push   %ebx
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5f:	89 c3                	mov    %eax,%ebx
  800a61:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a64:	eb 06                	jmp    800a6c <strncmp+0x17>
		n--, p++, q++;
  800a66:	83 c0 01             	add    $0x1,%eax
  800a69:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a6c:	39 d8                	cmp    %ebx,%eax
  800a6e:	74 16                	je     800a86 <strncmp+0x31>
  800a70:	0f b6 08             	movzbl (%eax),%ecx
  800a73:	84 c9                	test   %cl,%cl
  800a75:	74 04                	je     800a7b <strncmp+0x26>
  800a77:	3a 0a                	cmp    (%edx),%cl
  800a79:	74 eb                	je     800a66 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a7b:	0f b6 00             	movzbl (%eax),%eax
  800a7e:	0f b6 12             	movzbl (%edx),%edx
  800a81:	29 d0                	sub    %edx,%eax
}
  800a83:	5b                   	pop    %ebx
  800a84:	5d                   	pop    %ebp
  800a85:	c3                   	ret    
		return 0;
  800a86:	b8 00 00 00 00       	mov    $0x0,%eax
  800a8b:	eb f6                	jmp    800a83 <strncmp+0x2e>

00800a8d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a97:	0f b6 10             	movzbl (%eax),%edx
  800a9a:	84 d2                	test   %dl,%dl
  800a9c:	74 09                	je     800aa7 <strchr+0x1a>
		if (*s == c)
  800a9e:	38 ca                	cmp    %cl,%dl
  800aa0:	74 0a                	je     800aac <strchr+0x1f>
	for (; *s; s++)
  800aa2:	83 c0 01             	add    $0x1,%eax
  800aa5:	eb f0                	jmp    800a97 <strchr+0xa>
			return (char *) s;
	return 0;
  800aa7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aac:	5d                   	pop    %ebp
  800aad:	c3                   	ret    

00800aae <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ab8:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800abb:	38 ca                	cmp    %cl,%dl
  800abd:	74 09                	je     800ac8 <strfind+0x1a>
  800abf:	84 d2                	test   %dl,%dl
  800ac1:	74 05                	je     800ac8 <strfind+0x1a>
	for (; *s; s++)
  800ac3:	83 c0 01             	add    $0x1,%eax
  800ac6:	eb f0                	jmp    800ab8 <strfind+0xa>
			break;
	return (char *) s;
}
  800ac8:	5d                   	pop    %ebp
  800ac9:	c3                   	ret    

00800aca <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800aca:	55                   	push   %ebp
  800acb:	89 e5                	mov    %esp,%ebp
  800acd:	57                   	push   %edi
  800ace:	56                   	push   %esi
  800acf:	53                   	push   %ebx
  800ad0:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ad3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ad6:	85 c9                	test   %ecx,%ecx
  800ad8:	74 31                	je     800b0b <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ada:	89 f8                	mov    %edi,%eax
  800adc:	09 c8                	or     %ecx,%eax
  800ade:	a8 03                	test   $0x3,%al
  800ae0:	75 23                	jne    800b05 <memset+0x3b>
		c &= 0xFF;
  800ae2:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ae6:	89 d3                	mov    %edx,%ebx
  800ae8:	c1 e3 08             	shl    $0x8,%ebx
  800aeb:	89 d0                	mov    %edx,%eax
  800aed:	c1 e0 18             	shl    $0x18,%eax
  800af0:	89 d6                	mov    %edx,%esi
  800af2:	c1 e6 10             	shl    $0x10,%esi
  800af5:	09 f0                	or     %esi,%eax
  800af7:	09 c2                	or     %eax,%edx
  800af9:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800afb:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800afe:	89 d0                	mov    %edx,%eax
  800b00:	fc                   	cld    
  800b01:	f3 ab                	rep stos %eax,%es:(%edi)
  800b03:	eb 06                	jmp    800b0b <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b08:	fc                   	cld    
  800b09:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b0b:	89 f8                	mov    %edi,%eax
  800b0d:	5b                   	pop    %ebx
  800b0e:	5e                   	pop    %esi
  800b0f:	5f                   	pop    %edi
  800b10:	5d                   	pop    %ebp
  800b11:	c3                   	ret    

00800b12 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
  800b15:	57                   	push   %edi
  800b16:	56                   	push   %esi
  800b17:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b1d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b20:	39 c6                	cmp    %eax,%esi
  800b22:	73 32                	jae    800b56 <memmove+0x44>
  800b24:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b27:	39 c2                	cmp    %eax,%edx
  800b29:	76 2b                	jbe    800b56 <memmove+0x44>
		s += n;
		d += n;
  800b2b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b2e:	89 fe                	mov    %edi,%esi
  800b30:	09 ce                	or     %ecx,%esi
  800b32:	09 d6                	or     %edx,%esi
  800b34:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b3a:	75 0e                	jne    800b4a <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b3c:	83 ef 04             	sub    $0x4,%edi
  800b3f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b42:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b45:	fd                   	std    
  800b46:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b48:	eb 09                	jmp    800b53 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b4a:	83 ef 01             	sub    $0x1,%edi
  800b4d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b50:	fd                   	std    
  800b51:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b53:	fc                   	cld    
  800b54:	eb 1a                	jmp    800b70 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b56:	89 c2                	mov    %eax,%edx
  800b58:	09 ca                	or     %ecx,%edx
  800b5a:	09 f2                	or     %esi,%edx
  800b5c:	f6 c2 03             	test   $0x3,%dl
  800b5f:	75 0a                	jne    800b6b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b61:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b64:	89 c7                	mov    %eax,%edi
  800b66:	fc                   	cld    
  800b67:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b69:	eb 05                	jmp    800b70 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b6b:	89 c7                	mov    %eax,%edi
  800b6d:	fc                   	cld    
  800b6e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b70:	5e                   	pop    %esi
  800b71:	5f                   	pop    %edi
  800b72:	5d                   	pop    %ebp
  800b73:	c3                   	ret    

00800b74 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b7a:	ff 75 10             	pushl  0x10(%ebp)
  800b7d:	ff 75 0c             	pushl  0xc(%ebp)
  800b80:	ff 75 08             	pushl  0x8(%ebp)
  800b83:	e8 8a ff ff ff       	call   800b12 <memmove>
}
  800b88:	c9                   	leave  
  800b89:	c3                   	ret    

00800b8a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b8a:	55                   	push   %ebp
  800b8b:	89 e5                	mov    %esp,%ebp
  800b8d:	56                   	push   %esi
  800b8e:	53                   	push   %ebx
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b95:	89 c6                	mov    %eax,%esi
  800b97:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b9a:	39 f0                	cmp    %esi,%eax
  800b9c:	74 1c                	je     800bba <memcmp+0x30>
		if (*s1 != *s2)
  800b9e:	0f b6 08             	movzbl (%eax),%ecx
  800ba1:	0f b6 1a             	movzbl (%edx),%ebx
  800ba4:	38 d9                	cmp    %bl,%cl
  800ba6:	75 08                	jne    800bb0 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ba8:	83 c0 01             	add    $0x1,%eax
  800bab:	83 c2 01             	add    $0x1,%edx
  800bae:	eb ea                	jmp    800b9a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bb0:	0f b6 c1             	movzbl %cl,%eax
  800bb3:	0f b6 db             	movzbl %bl,%ebx
  800bb6:	29 d8                	sub    %ebx,%eax
  800bb8:	eb 05                	jmp    800bbf <memcmp+0x35>
	}

	return 0;
  800bba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bbf:	5b                   	pop    %ebx
  800bc0:	5e                   	pop    %esi
  800bc1:	5d                   	pop    %ebp
  800bc2:	c3                   	ret    

00800bc3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
  800bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bcc:	89 c2                	mov    %eax,%edx
  800bce:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bd1:	39 d0                	cmp    %edx,%eax
  800bd3:	73 09                	jae    800bde <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bd5:	38 08                	cmp    %cl,(%eax)
  800bd7:	74 05                	je     800bde <memfind+0x1b>
	for (; s < ends; s++)
  800bd9:	83 c0 01             	add    $0x1,%eax
  800bdc:	eb f3                	jmp    800bd1 <memfind+0xe>
			break;
	return (void *) s;
}
  800bde:	5d                   	pop    %ebp
  800bdf:	c3                   	ret    

00800be0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	57                   	push   %edi
  800be4:	56                   	push   %esi
  800be5:	53                   	push   %ebx
  800be6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800be9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bec:	eb 03                	jmp    800bf1 <strtol+0x11>
		s++;
  800bee:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bf1:	0f b6 01             	movzbl (%ecx),%eax
  800bf4:	3c 20                	cmp    $0x20,%al
  800bf6:	74 f6                	je     800bee <strtol+0xe>
  800bf8:	3c 09                	cmp    $0x9,%al
  800bfa:	74 f2                	je     800bee <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bfc:	3c 2b                	cmp    $0x2b,%al
  800bfe:	74 2a                	je     800c2a <strtol+0x4a>
	int neg = 0;
  800c00:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c05:	3c 2d                	cmp    $0x2d,%al
  800c07:	74 2b                	je     800c34 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c09:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c0f:	75 0f                	jne    800c20 <strtol+0x40>
  800c11:	80 39 30             	cmpb   $0x30,(%ecx)
  800c14:	74 28                	je     800c3e <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c16:	85 db                	test   %ebx,%ebx
  800c18:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c1d:	0f 44 d8             	cmove  %eax,%ebx
  800c20:	b8 00 00 00 00       	mov    $0x0,%eax
  800c25:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c28:	eb 50                	jmp    800c7a <strtol+0x9a>
		s++;
  800c2a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c2d:	bf 00 00 00 00       	mov    $0x0,%edi
  800c32:	eb d5                	jmp    800c09 <strtol+0x29>
		s++, neg = 1;
  800c34:	83 c1 01             	add    $0x1,%ecx
  800c37:	bf 01 00 00 00       	mov    $0x1,%edi
  800c3c:	eb cb                	jmp    800c09 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c3e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c42:	74 0e                	je     800c52 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c44:	85 db                	test   %ebx,%ebx
  800c46:	75 d8                	jne    800c20 <strtol+0x40>
		s++, base = 8;
  800c48:	83 c1 01             	add    $0x1,%ecx
  800c4b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c50:	eb ce                	jmp    800c20 <strtol+0x40>
		s += 2, base = 16;
  800c52:	83 c1 02             	add    $0x2,%ecx
  800c55:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c5a:	eb c4                	jmp    800c20 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c5c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c5f:	89 f3                	mov    %esi,%ebx
  800c61:	80 fb 19             	cmp    $0x19,%bl
  800c64:	77 29                	ja     800c8f <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c66:	0f be d2             	movsbl %dl,%edx
  800c69:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c6c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c6f:	7d 30                	jge    800ca1 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c71:	83 c1 01             	add    $0x1,%ecx
  800c74:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c78:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c7a:	0f b6 11             	movzbl (%ecx),%edx
  800c7d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c80:	89 f3                	mov    %esi,%ebx
  800c82:	80 fb 09             	cmp    $0x9,%bl
  800c85:	77 d5                	ja     800c5c <strtol+0x7c>
			dig = *s - '0';
  800c87:	0f be d2             	movsbl %dl,%edx
  800c8a:	83 ea 30             	sub    $0x30,%edx
  800c8d:	eb dd                	jmp    800c6c <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c8f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c92:	89 f3                	mov    %esi,%ebx
  800c94:	80 fb 19             	cmp    $0x19,%bl
  800c97:	77 08                	ja     800ca1 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c99:	0f be d2             	movsbl %dl,%edx
  800c9c:	83 ea 37             	sub    $0x37,%edx
  800c9f:	eb cb                	jmp    800c6c <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ca1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca5:	74 05                	je     800cac <strtol+0xcc>
		*endptr = (char *) s;
  800ca7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800caa:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cac:	89 c2                	mov    %eax,%edx
  800cae:	f7 da                	neg    %edx
  800cb0:	85 ff                	test   %edi,%edi
  800cb2:	0f 45 c2             	cmovne %edx,%eax
}
  800cb5:	5b                   	pop    %ebx
  800cb6:	5e                   	pop    %esi
  800cb7:	5f                   	pop    %edi
  800cb8:	5d                   	pop    %ebp
  800cb9:	c3                   	ret    

00800cba <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	57                   	push   %edi
  800cbe:	56                   	push   %esi
  800cbf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc0:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ccb:	89 c3                	mov    %eax,%ebx
  800ccd:	89 c7                	mov    %eax,%edi
  800ccf:	89 c6                	mov    %eax,%esi
  800cd1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cd3:	5b                   	pop    %ebx
  800cd4:	5e                   	pop    %esi
  800cd5:	5f                   	pop    %edi
  800cd6:	5d                   	pop    %ebp
  800cd7:	c3                   	ret    

00800cd8 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cd8:	55                   	push   %ebp
  800cd9:	89 e5                	mov    %esp,%ebp
  800cdb:	57                   	push   %edi
  800cdc:	56                   	push   %esi
  800cdd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cde:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce3:	b8 01 00 00 00       	mov    $0x1,%eax
  800ce8:	89 d1                	mov    %edx,%ecx
  800cea:	89 d3                	mov    %edx,%ebx
  800cec:	89 d7                	mov    %edx,%edi
  800cee:	89 d6                	mov    %edx,%esi
  800cf0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cf2:	5b                   	pop    %ebx
  800cf3:	5e                   	pop    %esi
  800cf4:	5f                   	pop    %edi
  800cf5:	5d                   	pop    %ebp
  800cf6:	c3                   	ret    

00800cf7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	57                   	push   %edi
  800cfb:	56                   	push   %esi
  800cfc:	53                   	push   %ebx
  800cfd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d00:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d05:	8b 55 08             	mov    0x8(%ebp),%edx
  800d08:	b8 03 00 00 00       	mov    $0x3,%eax
  800d0d:	89 cb                	mov    %ecx,%ebx
  800d0f:	89 cf                	mov    %ecx,%edi
  800d11:	89 ce                	mov    %ecx,%esi
  800d13:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d15:	85 c0                	test   %eax,%eax
  800d17:	7f 08                	jg     800d21 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1c:	5b                   	pop    %ebx
  800d1d:	5e                   	pop    %esi
  800d1e:	5f                   	pop    %edi
  800d1f:	5d                   	pop    %ebp
  800d20:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d21:	83 ec 0c             	sub    $0xc,%esp
  800d24:	50                   	push   %eax
  800d25:	6a 03                	push   $0x3
  800d27:	68 c8 29 80 00       	push   $0x8029c8
  800d2c:	6a 43                	push   $0x43
  800d2e:	68 e5 29 80 00       	push   $0x8029e5
  800d33:	e8 69 14 00 00       	call   8021a1 <_panic>

00800d38 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	57                   	push   %edi
  800d3c:	56                   	push   %esi
  800d3d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d3e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d43:	b8 02 00 00 00       	mov    $0x2,%eax
  800d48:	89 d1                	mov    %edx,%ecx
  800d4a:	89 d3                	mov    %edx,%ebx
  800d4c:	89 d7                	mov    %edx,%edi
  800d4e:	89 d6                	mov    %edx,%esi
  800d50:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d52:	5b                   	pop    %ebx
  800d53:	5e                   	pop    %esi
  800d54:	5f                   	pop    %edi
  800d55:	5d                   	pop    %ebp
  800d56:	c3                   	ret    

00800d57 <sys_yield>:

void
sys_yield(void)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	57                   	push   %edi
  800d5b:	56                   	push   %esi
  800d5c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d62:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d67:	89 d1                	mov    %edx,%ecx
  800d69:	89 d3                	mov    %edx,%ebx
  800d6b:	89 d7                	mov    %edx,%edi
  800d6d:	89 d6                	mov    %edx,%esi
  800d6f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d71:	5b                   	pop    %ebx
  800d72:	5e                   	pop    %esi
  800d73:	5f                   	pop    %edi
  800d74:	5d                   	pop    %ebp
  800d75:	c3                   	ret    

00800d76 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d76:	55                   	push   %ebp
  800d77:	89 e5                	mov    %esp,%ebp
  800d79:	57                   	push   %edi
  800d7a:	56                   	push   %esi
  800d7b:	53                   	push   %ebx
  800d7c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7f:	be 00 00 00 00       	mov    $0x0,%esi
  800d84:	8b 55 08             	mov    0x8(%ebp),%edx
  800d87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8a:	b8 04 00 00 00       	mov    $0x4,%eax
  800d8f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d92:	89 f7                	mov    %esi,%edi
  800d94:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d96:	85 c0                	test   %eax,%eax
  800d98:	7f 08                	jg     800da2 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9d:	5b                   	pop    %ebx
  800d9e:	5e                   	pop    %esi
  800d9f:	5f                   	pop    %edi
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da2:	83 ec 0c             	sub    $0xc,%esp
  800da5:	50                   	push   %eax
  800da6:	6a 04                	push   $0x4
  800da8:	68 c8 29 80 00       	push   $0x8029c8
  800dad:	6a 43                	push   $0x43
  800daf:	68 e5 29 80 00       	push   $0x8029e5
  800db4:	e8 e8 13 00 00       	call   8021a1 <_panic>

00800db9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	57                   	push   %edi
  800dbd:	56                   	push   %esi
  800dbe:	53                   	push   %ebx
  800dbf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc8:	b8 05 00 00 00       	mov    $0x5,%eax
  800dcd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dd3:	8b 75 18             	mov    0x18(%ebp),%esi
  800dd6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd8:	85 c0                	test   %eax,%eax
  800dda:	7f 08                	jg     800de4 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ddc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddf:	5b                   	pop    %ebx
  800de0:	5e                   	pop    %esi
  800de1:	5f                   	pop    %edi
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de4:	83 ec 0c             	sub    $0xc,%esp
  800de7:	50                   	push   %eax
  800de8:	6a 05                	push   $0x5
  800dea:	68 c8 29 80 00       	push   $0x8029c8
  800def:	6a 43                	push   $0x43
  800df1:	68 e5 29 80 00       	push   $0x8029e5
  800df6:	e8 a6 13 00 00       	call   8021a1 <_panic>

00800dfb <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	57                   	push   %edi
  800dff:	56                   	push   %esi
  800e00:	53                   	push   %ebx
  800e01:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e04:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e09:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0f:	b8 06 00 00 00       	mov    $0x6,%eax
  800e14:	89 df                	mov    %ebx,%edi
  800e16:	89 de                	mov    %ebx,%esi
  800e18:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e1a:	85 c0                	test   %eax,%eax
  800e1c:	7f 08                	jg     800e26 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e21:	5b                   	pop    %ebx
  800e22:	5e                   	pop    %esi
  800e23:	5f                   	pop    %edi
  800e24:	5d                   	pop    %ebp
  800e25:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e26:	83 ec 0c             	sub    $0xc,%esp
  800e29:	50                   	push   %eax
  800e2a:	6a 06                	push   $0x6
  800e2c:	68 c8 29 80 00       	push   $0x8029c8
  800e31:	6a 43                	push   $0x43
  800e33:	68 e5 29 80 00       	push   $0x8029e5
  800e38:	e8 64 13 00 00       	call   8021a1 <_panic>

00800e3d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	57                   	push   %edi
  800e41:	56                   	push   %esi
  800e42:	53                   	push   %ebx
  800e43:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e46:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e51:	b8 08 00 00 00       	mov    $0x8,%eax
  800e56:	89 df                	mov    %ebx,%edi
  800e58:	89 de                	mov    %ebx,%esi
  800e5a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5c:	85 c0                	test   %eax,%eax
  800e5e:	7f 08                	jg     800e68 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e63:	5b                   	pop    %ebx
  800e64:	5e                   	pop    %esi
  800e65:	5f                   	pop    %edi
  800e66:	5d                   	pop    %ebp
  800e67:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e68:	83 ec 0c             	sub    $0xc,%esp
  800e6b:	50                   	push   %eax
  800e6c:	6a 08                	push   $0x8
  800e6e:	68 c8 29 80 00       	push   $0x8029c8
  800e73:	6a 43                	push   $0x43
  800e75:	68 e5 29 80 00       	push   $0x8029e5
  800e7a:	e8 22 13 00 00       	call   8021a1 <_panic>

00800e7f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	57                   	push   %edi
  800e83:	56                   	push   %esi
  800e84:	53                   	push   %ebx
  800e85:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e88:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e93:	b8 09 00 00 00       	mov    $0x9,%eax
  800e98:	89 df                	mov    %ebx,%edi
  800e9a:	89 de                	mov    %ebx,%esi
  800e9c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e9e:	85 c0                	test   %eax,%eax
  800ea0:	7f 08                	jg     800eaa <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ea2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea5:	5b                   	pop    %ebx
  800ea6:	5e                   	pop    %esi
  800ea7:	5f                   	pop    %edi
  800ea8:	5d                   	pop    %ebp
  800ea9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eaa:	83 ec 0c             	sub    $0xc,%esp
  800ead:	50                   	push   %eax
  800eae:	6a 09                	push   $0x9
  800eb0:	68 c8 29 80 00       	push   $0x8029c8
  800eb5:	6a 43                	push   $0x43
  800eb7:	68 e5 29 80 00       	push   $0x8029e5
  800ebc:	e8 e0 12 00 00       	call   8021a1 <_panic>

00800ec1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ec1:	55                   	push   %ebp
  800ec2:	89 e5                	mov    %esp,%ebp
  800ec4:	57                   	push   %edi
  800ec5:	56                   	push   %esi
  800ec6:	53                   	push   %ebx
  800ec7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eca:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ecf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eda:	89 df                	mov    %ebx,%edi
  800edc:	89 de                	mov    %ebx,%esi
  800ede:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee0:	85 c0                	test   %eax,%eax
  800ee2:	7f 08                	jg     800eec <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ee4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee7:	5b                   	pop    %ebx
  800ee8:	5e                   	pop    %esi
  800ee9:	5f                   	pop    %edi
  800eea:	5d                   	pop    %ebp
  800eeb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eec:	83 ec 0c             	sub    $0xc,%esp
  800eef:	50                   	push   %eax
  800ef0:	6a 0a                	push   $0xa
  800ef2:	68 c8 29 80 00       	push   $0x8029c8
  800ef7:	6a 43                	push   $0x43
  800ef9:	68 e5 29 80 00       	push   $0x8029e5
  800efe:	e8 9e 12 00 00       	call   8021a1 <_panic>

00800f03 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	57                   	push   %edi
  800f07:	56                   	push   %esi
  800f08:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f09:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f14:	be 00 00 00 00       	mov    $0x0,%esi
  800f19:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f1c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f1f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f21:	5b                   	pop    %ebx
  800f22:	5e                   	pop    %esi
  800f23:	5f                   	pop    %edi
  800f24:	5d                   	pop    %ebp
  800f25:	c3                   	ret    

00800f26 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	57                   	push   %edi
  800f2a:	56                   	push   %esi
  800f2b:	53                   	push   %ebx
  800f2c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f2f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f34:	8b 55 08             	mov    0x8(%ebp),%edx
  800f37:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f3c:	89 cb                	mov    %ecx,%ebx
  800f3e:	89 cf                	mov    %ecx,%edi
  800f40:	89 ce                	mov    %ecx,%esi
  800f42:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f44:	85 c0                	test   %eax,%eax
  800f46:	7f 08                	jg     800f50 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f4b:	5b                   	pop    %ebx
  800f4c:	5e                   	pop    %esi
  800f4d:	5f                   	pop    %edi
  800f4e:	5d                   	pop    %ebp
  800f4f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f50:	83 ec 0c             	sub    $0xc,%esp
  800f53:	50                   	push   %eax
  800f54:	6a 0d                	push   $0xd
  800f56:	68 c8 29 80 00       	push   $0x8029c8
  800f5b:	6a 43                	push   $0x43
  800f5d:	68 e5 29 80 00       	push   $0x8029e5
  800f62:	e8 3a 12 00 00       	call   8021a1 <_panic>

00800f67 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	57                   	push   %edi
  800f6b:	56                   	push   %esi
  800f6c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f72:	8b 55 08             	mov    0x8(%ebp),%edx
  800f75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f78:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f7d:	89 df                	mov    %ebx,%edi
  800f7f:	89 de                	mov    %ebx,%esi
  800f81:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f83:	5b                   	pop    %ebx
  800f84:	5e                   	pop    %esi
  800f85:	5f                   	pop    %edi
  800f86:	5d                   	pop    %ebp
  800f87:	c3                   	ret    

00800f88 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f88:	55                   	push   %ebp
  800f89:	89 e5                	mov    %esp,%ebp
  800f8b:	57                   	push   %edi
  800f8c:	56                   	push   %esi
  800f8d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f8e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f93:	8b 55 08             	mov    0x8(%ebp),%edx
  800f96:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f9b:	89 cb                	mov    %ecx,%ebx
  800f9d:	89 cf                	mov    %ecx,%edi
  800f9f:	89 ce                	mov    %ecx,%esi
  800fa1:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fa3:	5b                   	pop    %ebx
  800fa4:	5e                   	pop    %esi
  800fa5:	5f                   	pop    %edi
  800fa6:	5d                   	pop    %ebp
  800fa7:	c3                   	ret    

00800fa8 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fa8:	55                   	push   %ebp
  800fa9:	89 e5                	mov    %esp,%ebp
  800fab:	57                   	push   %edi
  800fac:	56                   	push   %esi
  800fad:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fae:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb3:	b8 10 00 00 00       	mov    $0x10,%eax
  800fb8:	89 d1                	mov    %edx,%ecx
  800fba:	89 d3                	mov    %edx,%ebx
  800fbc:	89 d7                	mov    %edx,%edi
  800fbe:	89 d6                	mov    %edx,%esi
  800fc0:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fc2:	5b                   	pop    %ebx
  800fc3:	5e                   	pop    %esi
  800fc4:	5f                   	pop    %edi
  800fc5:	5d                   	pop    %ebp
  800fc6:	c3                   	ret    

00800fc7 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800fc7:	55                   	push   %ebp
  800fc8:	89 e5                	mov    %esp,%ebp
  800fca:	57                   	push   %edi
  800fcb:	56                   	push   %esi
  800fcc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fcd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd8:	b8 11 00 00 00       	mov    $0x11,%eax
  800fdd:	89 df                	mov    %ebx,%edi
  800fdf:	89 de                	mov    %ebx,%esi
  800fe1:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fe3:	5b                   	pop    %ebx
  800fe4:	5e                   	pop    %esi
  800fe5:	5f                   	pop    %edi
  800fe6:	5d                   	pop    %ebp
  800fe7:	c3                   	ret    

00800fe8 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	57                   	push   %edi
  800fec:	56                   	push   %esi
  800fed:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fee:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff9:	b8 12 00 00 00       	mov    $0x12,%eax
  800ffe:	89 df                	mov    %ebx,%edi
  801000:	89 de                	mov    %ebx,%esi
  801002:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801004:	5b                   	pop    %ebx
  801005:	5e                   	pop    %esi
  801006:	5f                   	pop    %edi
  801007:	5d                   	pop    %ebp
  801008:	c3                   	ret    

00801009 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	57                   	push   %edi
  80100d:	56                   	push   %esi
  80100e:	53                   	push   %ebx
  80100f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801012:	bb 00 00 00 00       	mov    $0x0,%ebx
  801017:	8b 55 08             	mov    0x8(%ebp),%edx
  80101a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101d:	b8 13 00 00 00       	mov    $0x13,%eax
  801022:	89 df                	mov    %ebx,%edi
  801024:	89 de                	mov    %ebx,%esi
  801026:	cd 30                	int    $0x30
	if(check && ret > 0)
  801028:	85 c0                	test   %eax,%eax
  80102a:	7f 08                	jg     801034 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80102c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80102f:	5b                   	pop    %ebx
  801030:	5e                   	pop    %esi
  801031:	5f                   	pop    %edi
  801032:	5d                   	pop    %ebp
  801033:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801034:	83 ec 0c             	sub    $0xc,%esp
  801037:	50                   	push   %eax
  801038:	6a 13                	push   $0x13
  80103a:	68 c8 29 80 00       	push   $0x8029c8
  80103f:	6a 43                	push   $0x43
  801041:	68 e5 29 80 00       	push   $0x8029e5
  801046:	e8 56 11 00 00       	call   8021a1 <_panic>

0080104b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80104e:	8b 45 08             	mov    0x8(%ebp),%eax
  801051:	05 00 00 00 30       	add    $0x30000000,%eax
  801056:	c1 e8 0c             	shr    $0xc,%eax
}
  801059:	5d                   	pop    %ebp
  80105a:	c3                   	ret    

0080105b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801066:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80106b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801070:	5d                   	pop    %ebp
  801071:	c3                   	ret    

00801072 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
  801075:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80107a:	89 c2                	mov    %eax,%edx
  80107c:	c1 ea 16             	shr    $0x16,%edx
  80107f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801086:	f6 c2 01             	test   $0x1,%dl
  801089:	74 2d                	je     8010b8 <fd_alloc+0x46>
  80108b:	89 c2                	mov    %eax,%edx
  80108d:	c1 ea 0c             	shr    $0xc,%edx
  801090:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801097:	f6 c2 01             	test   $0x1,%dl
  80109a:	74 1c                	je     8010b8 <fd_alloc+0x46>
  80109c:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010a1:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010a6:	75 d2                	jne    80107a <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8010b1:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010b6:	eb 0a                	jmp    8010c2 <fd_alloc+0x50>
			*fd_store = fd;
  8010b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010bb:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010c2:	5d                   	pop    %ebp
  8010c3:	c3                   	ret    

008010c4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010ca:	83 f8 1f             	cmp    $0x1f,%eax
  8010cd:	77 30                	ja     8010ff <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010cf:	c1 e0 0c             	shl    $0xc,%eax
  8010d2:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010d7:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010dd:	f6 c2 01             	test   $0x1,%dl
  8010e0:	74 24                	je     801106 <fd_lookup+0x42>
  8010e2:	89 c2                	mov    %eax,%edx
  8010e4:	c1 ea 0c             	shr    $0xc,%edx
  8010e7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010ee:	f6 c2 01             	test   $0x1,%dl
  8010f1:	74 1a                	je     80110d <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f6:	89 02                	mov    %eax,(%edx)
	return 0;
  8010f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010fd:	5d                   	pop    %ebp
  8010fe:	c3                   	ret    
		return -E_INVAL;
  8010ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801104:	eb f7                	jmp    8010fd <fd_lookup+0x39>
		return -E_INVAL;
  801106:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80110b:	eb f0                	jmp    8010fd <fd_lookup+0x39>
  80110d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801112:	eb e9                	jmp    8010fd <fd_lookup+0x39>

00801114 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	83 ec 08             	sub    $0x8,%esp
  80111a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80111d:	ba 00 00 00 00       	mov    $0x0,%edx
  801122:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801127:	39 08                	cmp    %ecx,(%eax)
  801129:	74 38                	je     801163 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80112b:	83 c2 01             	add    $0x1,%edx
  80112e:	8b 04 95 70 2a 80 00 	mov    0x802a70(,%edx,4),%eax
  801135:	85 c0                	test   %eax,%eax
  801137:	75 ee                	jne    801127 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801139:	a1 08 40 80 00       	mov    0x804008,%eax
  80113e:	8b 40 48             	mov    0x48(%eax),%eax
  801141:	83 ec 04             	sub    $0x4,%esp
  801144:	51                   	push   %ecx
  801145:	50                   	push   %eax
  801146:	68 f4 29 80 00       	push   $0x8029f4
  80114b:	e8 d5 f0 ff ff       	call   800225 <cprintf>
	*dev = 0;
  801150:	8b 45 0c             	mov    0xc(%ebp),%eax
  801153:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801159:	83 c4 10             	add    $0x10,%esp
  80115c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801161:	c9                   	leave  
  801162:	c3                   	ret    
			*dev = devtab[i];
  801163:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801166:	89 01                	mov    %eax,(%ecx)
			return 0;
  801168:	b8 00 00 00 00       	mov    $0x0,%eax
  80116d:	eb f2                	jmp    801161 <dev_lookup+0x4d>

0080116f <fd_close>:
{
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	57                   	push   %edi
  801173:	56                   	push   %esi
  801174:	53                   	push   %ebx
  801175:	83 ec 24             	sub    $0x24,%esp
  801178:	8b 75 08             	mov    0x8(%ebp),%esi
  80117b:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80117e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801181:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801182:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801188:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80118b:	50                   	push   %eax
  80118c:	e8 33 ff ff ff       	call   8010c4 <fd_lookup>
  801191:	89 c3                	mov    %eax,%ebx
  801193:	83 c4 10             	add    $0x10,%esp
  801196:	85 c0                	test   %eax,%eax
  801198:	78 05                	js     80119f <fd_close+0x30>
	    || fd != fd2)
  80119a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80119d:	74 16                	je     8011b5 <fd_close+0x46>
		return (must_exist ? r : 0);
  80119f:	89 f8                	mov    %edi,%eax
  8011a1:	84 c0                	test   %al,%al
  8011a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a8:	0f 44 d8             	cmove  %eax,%ebx
}
  8011ab:	89 d8                	mov    %ebx,%eax
  8011ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011b0:	5b                   	pop    %ebx
  8011b1:	5e                   	pop    %esi
  8011b2:	5f                   	pop    %edi
  8011b3:	5d                   	pop    %ebp
  8011b4:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011b5:	83 ec 08             	sub    $0x8,%esp
  8011b8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011bb:	50                   	push   %eax
  8011bc:	ff 36                	pushl  (%esi)
  8011be:	e8 51 ff ff ff       	call   801114 <dev_lookup>
  8011c3:	89 c3                	mov    %eax,%ebx
  8011c5:	83 c4 10             	add    $0x10,%esp
  8011c8:	85 c0                	test   %eax,%eax
  8011ca:	78 1a                	js     8011e6 <fd_close+0x77>
		if (dev->dev_close)
  8011cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011cf:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011d2:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011d7:	85 c0                	test   %eax,%eax
  8011d9:	74 0b                	je     8011e6 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011db:	83 ec 0c             	sub    $0xc,%esp
  8011de:	56                   	push   %esi
  8011df:	ff d0                	call   *%eax
  8011e1:	89 c3                	mov    %eax,%ebx
  8011e3:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011e6:	83 ec 08             	sub    $0x8,%esp
  8011e9:	56                   	push   %esi
  8011ea:	6a 00                	push   $0x0
  8011ec:	e8 0a fc ff ff       	call   800dfb <sys_page_unmap>
	return r;
  8011f1:	83 c4 10             	add    $0x10,%esp
  8011f4:	eb b5                	jmp    8011ab <fd_close+0x3c>

008011f6 <close>:

int
close(int fdnum)
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
  8011f9:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011ff:	50                   	push   %eax
  801200:	ff 75 08             	pushl  0x8(%ebp)
  801203:	e8 bc fe ff ff       	call   8010c4 <fd_lookup>
  801208:	83 c4 10             	add    $0x10,%esp
  80120b:	85 c0                	test   %eax,%eax
  80120d:	79 02                	jns    801211 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80120f:	c9                   	leave  
  801210:	c3                   	ret    
		return fd_close(fd, 1);
  801211:	83 ec 08             	sub    $0x8,%esp
  801214:	6a 01                	push   $0x1
  801216:	ff 75 f4             	pushl  -0xc(%ebp)
  801219:	e8 51 ff ff ff       	call   80116f <fd_close>
  80121e:	83 c4 10             	add    $0x10,%esp
  801221:	eb ec                	jmp    80120f <close+0x19>

00801223 <close_all>:

void
close_all(void)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	53                   	push   %ebx
  801227:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80122a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80122f:	83 ec 0c             	sub    $0xc,%esp
  801232:	53                   	push   %ebx
  801233:	e8 be ff ff ff       	call   8011f6 <close>
	for (i = 0; i < MAXFD; i++)
  801238:	83 c3 01             	add    $0x1,%ebx
  80123b:	83 c4 10             	add    $0x10,%esp
  80123e:	83 fb 20             	cmp    $0x20,%ebx
  801241:	75 ec                	jne    80122f <close_all+0xc>
}
  801243:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801246:	c9                   	leave  
  801247:	c3                   	ret    

00801248 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801248:	55                   	push   %ebp
  801249:	89 e5                	mov    %esp,%ebp
  80124b:	57                   	push   %edi
  80124c:	56                   	push   %esi
  80124d:	53                   	push   %ebx
  80124e:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801251:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801254:	50                   	push   %eax
  801255:	ff 75 08             	pushl  0x8(%ebp)
  801258:	e8 67 fe ff ff       	call   8010c4 <fd_lookup>
  80125d:	89 c3                	mov    %eax,%ebx
  80125f:	83 c4 10             	add    $0x10,%esp
  801262:	85 c0                	test   %eax,%eax
  801264:	0f 88 81 00 00 00    	js     8012eb <dup+0xa3>
		return r;
	close(newfdnum);
  80126a:	83 ec 0c             	sub    $0xc,%esp
  80126d:	ff 75 0c             	pushl  0xc(%ebp)
  801270:	e8 81 ff ff ff       	call   8011f6 <close>

	newfd = INDEX2FD(newfdnum);
  801275:	8b 75 0c             	mov    0xc(%ebp),%esi
  801278:	c1 e6 0c             	shl    $0xc,%esi
  80127b:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801281:	83 c4 04             	add    $0x4,%esp
  801284:	ff 75 e4             	pushl  -0x1c(%ebp)
  801287:	e8 cf fd ff ff       	call   80105b <fd2data>
  80128c:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80128e:	89 34 24             	mov    %esi,(%esp)
  801291:	e8 c5 fd ff ff       	call   80105b <fd2data>
  801296:	83 c4 10             	add    $0x10,%esp
  801299:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80129b:	89 d8                	mov    %ebx,%eax
  80129d:	c1 e8 16             	shr    $0x16,%eax
  8012a0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012a7:	a8 01                	test   $0x1,%al
  8012a9:	74 11                	je     8012bc <dup+0x74>
  8012ab:	89 d8                	mov    %ebx,%eax
  8012ad:	c1 e8 0c             	shr    $0xc,%eax
  8012b0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012b7:	f6 c2 01             	test   $0x1,%dl
  8012ba:	75 39                	jne    8012f5 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012bf:	89 d0                	mov    %edx,%eax
  8012c1:	c1 e8 0c             	shr    $0xc,%eax
  8012c4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012cb:	83 ec 0c             	sub    $0xc,%esp
  8012ce:	25 07 0e 00 00       	and    $0xe07,%eax
  8012d3:	50                   	push   %eax
  8012d4:	56                   	push   %esi
  8012d5:	6a 00                	push   $0x0
  8012d7:	52                   	push   %edx
  8012d8:	6a 00                	push   $0x0
  8012da:	e8 da fa ff ff       	call   800db9 <sys_page_map>
  8012df:	89 c3                	mov    %eax,%ebx
  8012e1:	83 c4 20             	add    $0x20,%esp
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	78 31                	js     801319 <dup+0xd1>
		goto err;

	return newfdnum;
  8012e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012eb:	89 d8                	mov    %ebx,%eax
  8012ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012f0:	5b                   	pop    %ebx
  8012f1:	5e                   	pop    %esi
  8012f2:	5f                   	pop    %edi
  8012f3:	5d                   	pop    %ebp
  8012f4:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012f5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012fc:	83 ec 0c             	sub    $0xc,%esp
  8012ff:	25 07 0e 00 00       	and    $0xe07,%eax
  801304:	50                   	push   %eax
  801305:	57                   	push   %edi
  801306:	6a 00                	push   $0x0
  801308:	53                   	push   %ebx
  801309:	6a 00                	push   $0x0
  80130b:	e8 a9 fa ff ff       	call   800db9 <sys_page_map>
  801310:	89 c3                	mov    %eax,%ebx
  801312:	83 c4 20             	add    $0x20,%esp
  801315:	85 c0                	test   %eax,%eax
  801317:	79 a3                	jns    8012bc <dup+0x74>
	sys_page_unmap(0, newfd);
  801319:	83 ec 08             	sub    $0x8,%esp
  80131c:	56                   	push   %esi
  80131d:	6a 00                	push   $0x0
  80131f:	e8 d7 fa ff ff       	call   800dfb <sys_page_unmap>
	sys_page_unmap(0, nva);
  801324:	83 c4 08             	add    $0x8,%esp
  801327:	57                   	push   %edi
  801328:	6a 00                	push   $0x0
  80132a:	e8 cc fa ff ff       	call   800dfb <sys_page_unmap>
	return r;
  80132f:	83 c4 10             	add    $0x10,%esp
  801332:	eb b7                	jmp    8012eb <dup+0xa3>

00801334 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801334:	55                   	push   %ebp
  801335:	89 e5                	mov    %esp,%ebp
  801337:	53                   	push   %ebx
  801338:	83 ec 1c             	sub    $0x1c,%esp
  80133b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80133e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801341:	50                   	push   %eax
  801342:	53                   	push   %ebx
  801343:	e8 7c fd ff ff       	call   8010c4 <fd_lookup>
  801348:	83 c4 10             	add    $0x10,%esp
  80134b:	85 c0                	test   %eax,%eax
  80134d:	78 3f                	js     80138e <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80134f:	83 ec 08             	sub    $0x8,%esp
  801352:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801355:	50                   	push   %eax
  801356:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801359:	ff 30                	pushl  (%eax)
  80135b:	e8 b4 fd ff ff       	call   801114 <dev_lookup>
  801360:	83 c4 10             	add    $0x10,%esp
  801363:	85 c0                	test   %eax,%eax
  801365:	78 27                	js     80138e <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801367:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80136a:	8b 42 08             	mov    0x8(%edx),%eax
  80136d:	83 e0 03             	and    $0x3,%eax
  801370:	83 f8 01             	cmp    $0x1,%eax
  801373:	74 1e                	je     801393 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801378:	8b 40 08             	mov    0x8(%eax),%eax
  80137b:	85 c0                	test   %eax,%eax
  80137d:	74 35                	je     8013b4 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80137f:	83 ec 04             	sub    $0x4,%esp
  801382:	ff 75 10             	pushl  0x10(%ebp)
  801385:	ff 75 0c             	pushl  0xc(%ebp)
  801388:	52                   	push   %edx
  801389:	ff d0                	call   *%eax
  80138b:	83 c4 10             	add    $0x10,%esp
}
  80138e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801391:	c9                   	leave  
  801392:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801393:	a1 08 40 80 00       	mov    0x804008,%eax
  801398:	8b 40 48             	mov    0x48(%eax),%eax
  80139b:	83 ec 04             	sub    $0x4,%esp
  80139e:	53                   	push   %ebx
  80139f:	50                   	push   %eax
  8013a0:	68 35 2a 80 00       	push   $0x802a35
  8013a5:	e8 7b ee ff ff       	call   800225 <cprintf>
		return -E_INVAL;
  8013aa:	83 c4 10             	add    $0x10,%esp
  8013ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013b2:	eb da                	jmp    80138e <read+0x5a>
		return -E_NOT_SUPP;
  8013b4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013b9:	eb d3                	jmp    80138e <read+0x5a>

008013bb <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	57                   	push   %edi
  8013bf:	56                   	push   %esi
  8013c0:	53                   	push   %ebx
  8013c1:	83 ec 0c             	sub    $0xc,%esp
  8013c4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013c7:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013ca:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013cf:	39 f3                	cmp    %esi,%ebx
  8013d1:	73 23                	jae    8013f6 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013d3:	83 ec 04             	sub    $0x4,%esp
  8013d6:	89 f0                	mov    %esi,%eax
  8013d8:	29 d8                	sub    %ebx,%eax
  8013da:	50                   	push   %eax
  8013db:	89 d8                	mov    %ebx,%eax
  8013dd:	03 45 0c             	add    0xc(%ebp),%eax
  8013e0:	50                   	push   %eax
  8013e1:	57                   	push   %edi
  8013e2:	e8 4d ff ff ff       	call   801334 <read>
		if (m < 0)
  8013e7:	83 c4 10             	add    $0x10,%esp
  8013ea:	85 c0                	test   %eax,%eax
  8013ec:	78 06                	js     8013f4 <readn+0x39>
			return m;
		if (m == 0)
  8013ee:	74 06                	je     8013f6 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013f0:	01 c3                	add    %eax,%ebx
  8013f2:	eb db                	jmp    8013cf <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013f4:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013f6:	89 d8                	mov    %ebx,%eax
  8013f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013fb:	5b                   	pop    %ebx
  8013fc:	5e                   	pop    %esi
  8013fd:	5f                   	pop    %edi
  8013fe:	5d                   	pop    %ebp
  8013ff:	c3                   	ret    

00801400 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
  801403:	53                   	push   %ebx
  801404:	83 ec 1c             	sub    $0x1c,%esp
  801407:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80140a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80140d:	50                   	push   %eax
  80140e:	53                   	push   %ebx
  80140f:	e8 b0 fc ff ff       	call   8010c4 <fd_lookup>
  801414:	83 c4 10             	add    $0x10,%esp
  801417:	85 c0                	test   %eax,%eax
  801419:	78 3a                	js     801455 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80141b:	83 ec 08             	sub    $0x8,%esp
  80141e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801421:	50                   	push   %eax
  801422:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801425:	ff 30                	pushl  (%eax)
  801427:	e8 e8 fc ff ff       	call   801114 <dev_lookup>
  80142c:	83 c4 10             	add    $0x10,%esp
  80142f:	85 c0                	test   %eax,%eax
  801431:	78 22                	js     801455 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801433:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801436:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80143a:	74 1e                	je     80145a <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80143c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80143f:	8b 52 0c             	mov    0xc(%edx),%edx
  801442:	85 d2                	test   %edx,%edx
  801444:	74 35                	je     80147b <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801446:	83 ec 04             	sub    $0x4,%esp
  801449:	ff 75 10             	pushl  0x10(%ebp)
  80144c:	ff 75 0c             	pushl  0xc(%ebp)
  80144f:	50                   	push   %eax
  801450:	ff d2                	call   *%edx
  801452:	83 c4 10             	add    $0x10,%esp
}
  801455:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801458:	c9                   	leave  
  801459:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80145a:	a1 08 40 80 00       	mov    0x804008,%eax
  80145f:	8b 40 48             	mov    0x48(%eax),%eax
  801462:	83 ec 04             	sub    $0x4,%esp
  801465:	53                   	push   %ebx
  801466:	50                   	push   %eax
  801467:	68 51 2a 80 00       	push   $0x802a51
  80146c:	e8 b4 ed ff ff       	call   800225 <cprintf>
		return -E_INVAL;
  801471:	83 c4 10             	add    $0x10,%esp
  801474:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801479:	eb da                	jmp    801455 <write+0x55>
		return -E_NOT_SUPP;
  80147b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801480:	eb d3                	jmp    801455 <write+0x55>

00801482 <seek>:

int
seek(int fdnum, off_t offset)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
  801485:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801488:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80148b:	50                   	push   %eax
  80148c:	ff 75 08             	pushl  0x8(%ebp)
  80148f:	e8 30 fc ff ff       	call   8010c4 <fd_lookup>
  801494:	83 c4 10             	add    $0x10,%esp
  801497:	85 c0                	test   %eax,%eax
  801499:	78 0e                	js     8014a9 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80149b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a1:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    

008014ab <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
  8014ae:	53                   	push   %ebx
  8014af:	83 ec 1c             	sub    $0x1c,%esp
  8014b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014b5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014b8:	50                   	push   %eax
  8014b9:	53                   	push   %ebx
  8014ba:	e8 05 fc ff ff       	call   8010c4 <fd_lookup>
  8014bf:	83 c4 10             	add    $0x10,%esp
  8014c2:	85 c0                	test   %eax,%eax
  8014c4:	78 37                	js     8014fd <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014c6:	83 ec 08             	sub    $0x8,%esp
  8014c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014cc:	50                   	push   %eax
  8014cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d0:	ff 30                	pushl  (%eax)
  8014d2:	e8 3d fc ff ff       	call   801114 <dev_lookup>
  8014d7:	83 c4 10             	add    $0x10,%esp
  8014da:	85 c0                	test   %eax,%eax
  8014dc:	78 1f                	js     8014fd <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014e5:	74 1b                	je     801502 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ea:	8b 52 18             	mov    0x18(%edx),%edx
  8014ed:	85 d2                	test   %edx,%edx
  8014ef:	74 32                	je     801523 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014f1:	83 ec 08             	sub    $0x8,%esp
  8014f4:	ff 75 0c             	pushl  0xc(%ebp)
  8014f7:	50                   	push   %eax
  8014f8:	ff d2                	call   *%edx
  8014fa:	83 c4 10             	add    $0x10,%esp
}
  8014fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801500:	c9                   	leave  
  801501:	c3                   	ret    
			thisenv->env_id, fdnum);
  801502:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801507:	8b 40 48             	mov    0x48(%eax),%eax
  80150a:	83 ec 04             	sub    $0x4,%esp
  80150d:	53                   	push   %ebx
  80150e:	50                   	push   %eax
  80150f:	68 14 2a 80 00       	push   $0x802a14
  801514:	e8 0c ed ff ff       	call   800225 <cprintf>
		return -E_INVAL;
  801519:	83 c4 10             	add    $0x10,%esp
  80151c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801521:	eb da                	jmp    8014fd <ftruncate+0x52>
		return -E_NOT_SUPP;
  801523:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801528:	eb d3                	jmp    8014fd <ftruncate+0x52>

0080152a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
  80152d:	53                   	push   %ebx
  80152e:	83 ec 1c             	sub    $0x1c,%esp
  801531:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801534:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801537:	50                   	push   %eax
  801538:	ff 75 08             	pushl  0x8(%ebp)
  80153b:	e8 84 fb ff ff       	call   8010c4 <fd_lookup>
  801540:	83 c4 10             	add    $0x10,%esp
  801543:	85 c0                	test   %eax,%eax
  801545:	78 4b                	js     801592 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801547:	83 ec 08             	sub    $0x8,%esp
  80154a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80154d:	50                   	push   %eax
  80154e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801551:	ff 30                	pushl  (%eax)
  801553:	e8 bc fb ff ff       	call   801114 <dev_lookup>
  801558:	83 c4 10             	add    $0x10,%esp
  80155b:	85 c0                	test   %eax,%eax
  80155d:	78 33                	js     801592 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80155f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801562:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801566:	74 2f                	je     801597 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801568:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80156b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801572:	00 00 00 
	stat->st_isdir = 0;
  801575:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80157c:	00 00 00 
	stat->st_dev = dev;
  80157f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801585:	83 ec 08             	sub    $0x8,%esp
  801588:	53                   	push   %ebx
  801589:	ff 75 f0             	pushl  -0x10(%ebp)
  80158c:	ff 50 14             	call   *0x14(%eax)
  80158f:	83 c4 10             	add    $0x10,%esp
}
  801592:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801595:	c9                   	leave  
  801596:	c3                   	ret    
		return -E_NOT_SUPP;
  801597:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80159c:	eb f4                	jmp    801592 <fstat+0x68>

0080159e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
  8015a1:	56                   	push   %esi
  8015a2:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015a3:	83 ec 08             	sub    $0x8,%esp
  8015a6:	6a 00                	push   $0x0
  8015a8:	ff 75 08             	pushl  0x8(%ebp)
  8015ab:	e8 22 02 00 00       	call   8017d2 <open>
  8015b0:	89 c3                	mov    %eax,%ebx
  8015b2:	83 c4 10             	add    $0x10,%esp
  8015b5:	85 c0                	test   %eax,%eax
  8015b7:	78 1b                	js     8015d4 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015b9:	83 ec 08             	sub    $0x8,%esp
  8015bc:	ff 75 0c             	pushl  0xc(%ebp)
  8015bf:	50                   	push   %eax
  8015c0:	e8 65 ff ff ff       	call   80152a <fstat>
  8015c5:	89 c6                	mov    %eax,%esi
	close(fd);
  8015c7:	89 1c 24             	mov    %ebx,(%esp)
  8015ca:	e8 27 fc ff ff       	call   8011f6 <close>
	return r;
  8015cf:	83 c4 10             	add    $0x10,%esp
  8015d2:	89 f3                	mov    %esi,%ebx
}
  8015d4:	89 d8                	mov    %ebx,%eax
  8015d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015d9:	5b                   	pop    %ebx
  8015da:	5e                   	pop    %esi
  8015db:	5d                   	pop    %ebp
  8015dc:	c3                   	ret    

008015dd <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
  8015e0:	56                   	push   %esi
  8015e1:	53                   	push   %ebx
  8015e2:	89 c6                	mov    %eax,%esi
  8015e4:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015e6:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015ed:	74 27                	je     801616 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015ef:	6a 07                	push   $0x7
  8015f1:	68 00 50 80 00       	push   $0x805000
  8015f6:	56                   	push   %esi
  8015f7:	ff 35 00 40 80 00    	pushl  0x804000
  8015fd:	e8 69 0c 00 00       	call   80226b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801602:	83 c4 0c             	add    $0xc,%esp
  801605:	6a 00                	push   $0x0
  801607:	53                   	push   %ebx
  801608:	6a 00                	push   $0x0
  80160a:	e8 f3 0b 00 00       	call   802202 <ipc_recv>
}
  80160f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801612:	5b                   	pop    %ebx
  801613:	5e                   	pop    %esi
  801614:	5d                   	pop    %ebp
  801615:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801616:	83 ec 0c             	sub    $0xc,%esp
  801619:	6a 01                	push   $0x1
  80161b:	e8 a3 0c 00 00       	call   8022c3 <ipc_find_env>
  801620:	a3 00 40 80 00       	mov    %eax,0x804000
  801625:	83 c4 10             	add    $0x10,%esp
  801628:	eb c5                	jmp    8015ef <fsipc+0x12>

0080162a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801630:	8b 45 08             	mov    0x8(%ebp),%eax
  801633:	8b 40 0c             	mov    0xc(%eax),%eax
  801636:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80163b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163e:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801643:	ba 00 00 00 00       	mov    $0x0,%edx
  801648:	b8 02 00 00 00       	mov    $0x2,%eax
  80164d:	e8 8b ff ff ff       	call   8015dd <fsipc>
}
  801652:	c9                   	leave  
  801653:	c3                   	ret    

00801654 <devfile_flush>:
{
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
  801657:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80165a:	8b 45 08             	mov    0x8(%ebp),%eax
  80165d:	8b 40 0c             	mov    0xc(%eax),%eax
  801660:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801665:	ba 00 00 00 00       	mov    $0x0,%edx
  80166a:	b8 06 00 00 00       	mov    $0x6,%eax
  80166f:	e8 69 ff ff ff       	call   8015dd <fsipc>
}
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <devfile_stat>:
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
  801679:	53                   	push   %ebx
  80167a:	83 ec 04             	sub    $0x4,%esp
  80167d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	8b 40 0c             	mov    0xc(%eax),%eax
  801686:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80168b:	ba 00 00 00 00       	mov    $0x0,%edx
  801690:	b8 05 00 00 00       	mov    $0x5,%eax
  801695:	e8 43 ff ff ff       	call   8015dd <fsipc>
  80169a:	85 c0                	test   %eax,%eax
  80169c:	78 2c                	js     8016ca <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80169e:	83 ec 08             	sub    $0x8,%esp
  8016a1:	68 00 50 80 00       	push   $0x805000
  8016a6:	53                   	push   %ebx
  8016a7:	e8 d8 f2 ff ff       	call   800984 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016ac:	a1 80 50 80 00       	mov    0x805080,%eax
  8016b1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016b7:	a1 84 50 80 00       	mov    0x805084,%eax
  8016bc:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016c2:	83 c4 10             	add    $0x10,%esp
  8016c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <devfile_write>:
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	53                   	push   %ebx
  8016d3:	83 ec 08             	sub    $0x8,%esp
  8016d6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8016df:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016e4:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016ea:	53                   	push   %ebx
  8016eb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ee:	68 08 50 80 00       	push   $0x805008
  8016f3:	e8 7c f4 ff ff       	call   800b74 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8016fd:	b8 04 00 00 00       	mov    $0x4,%eax
  801702:	e8 d6 fe ff ff       	call   8015dd <fsipc>
  801707:	83 c4 10             	add    $0x10,%esp
  80170a:	85 c0                	test   %eax,%eax
  80170c:	78 0b                	js     801719 <devfile_write+0x4a>
	assert(r <= n);
  80170e:	39 d8                	cmp    %ebx,%eax
  801710:	77 0c                	ja     80171e <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801712:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801717:	7f 1e                	jg     801737 <devfile_write+0x68>
}
  801719:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    
	assert(r <= n);
  80171e:	68 84 2a 80 00       	push   $0x802a84
  801723:	68 8b 2a 80 00       	push   $0x802a8b
  801728:	68 98 00 00 00       	push   $0x98
  80172d:	68 a0 2a 80 00       	push   $0x802aa0
  801732:	e8 6a 0a 00 00       	call   8021a1 <_panic>
	assert(r <= PGSIZE);
  801737:	68 ab 2a 80 00       	push   $0x802aab
  80173c:	68 8b 2a 80 00       	push   $0x802a8b
  801741:	68 99 00 00 00       	push   $0x99
  801746:	68 a0 2a 80 00       	push   $0x802aa0
  80174b:	e8 51 0a 00 00       	call   8021a1 <_panic>

00801750 <devfile_read>:
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	56                   	push   %esi
  801754:	53                   	push   %ebx
  801755:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	8b 40 0c             	mov    0xc(%eax),%eax
  80175e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801763:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801769:	ba 00 00 00 00       	mov    $0x0,%edx
  80176e:	b8 03 00 00 00       	mov    $0x3,%eax
  801773:	e8 65 fe ff ff       	call   8015dd <fsipc>
  801778:	89 c3                	mov    %eax,%ebx
  80177a:	85 c0                	test   %eax,%eax
  80177c:	78 1f                	js     80179d <devfile_read+0x4d>
	assert(r <= n);
  80177e:	39 f0                	cmp    %esi,%eax
  801780:	77 24                	ja     8017a6 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801782:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801787:	7f 33                	jg     8017bc <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801789:	83 ec 04             	sub    $0x4,%esp
  80178c:	50                   	push   %eax
  80178d:	68 00 50 80 00       	push   $0x805000
  801792:	ff 75 0c             	pushl  0xc(%ebp)
  801795:	e8 78 f3 ff ff       	call   800b12 <memmove>
	return r;
  80179a:	83 c4 10             	add    $0x10,%esp
}
  80179d:	89 d8                	mov    %ebx,%eax
  80179f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017a2:	5b                   	pop    %ebx
  8017a3:	5e                   	pop    %esi
  8017a4:	5d                   	pop    %ebp
  8017a5:	c3                   	ret    
	assert(r <= n);
  8017a6:	68 84 2a 80 00       	push   $0x802a84
  8017ab:	68 8b 2a 80 00       	push   $0x802a8b
  8017b0:	6a 7c                	push   $0x7c
  8017b2:	68 a0 2a 80 00       	push   $0x802aa0
  8017b7:	e8 e5 09 00 00       	call   8021a1 <_panic>
	assert(r <= PGSIZE);
  8017bc:	68 ab 2a 80 00       	push   $0x802aab
  8017c1:	68 8b 2a 80 00       	push   $0x802a8b
  8017c6:	6a 7d                	push   $0x7d
  8017c8:	68 a0 2a 80 00       	push   $0x802aa0
  8017cd:	e8 cf 09 00 00       	call   8021a1 <_panic>

008017d2 <open>:
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
  8017d5:	56                   	push   %esi
  8017d6:	53                   	push   %ebx
  8017d7:	83 ec 1c             	sub    $0x1c,%esp
  8017da:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017dd:	56                   	push   %esi
  8017de:	e8 68 f1 ff ff       	call   80094b <strlen>
  8017e3:	83 c4 10             	add    $0x10,%esp
  8017e6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017eb:	7f 6c                	jg     801859 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017ed:	83 ec 0c             	sub    $0xc,%esp
  8017f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017f3:	50                   	push   %eax
  8017f4:	e8 79 f8 ff ff       	call   801072 <fd_alloc>
  8017f9:	89 c3                	mov    %eax,%ebx
  8017fb:	83 c4 10             	add    $0x10,%esp
  8017fe:	85 c0                	test   %eax,%eax
  801800:	78 3c                	js     80183e <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801802:	83 ec 08             	sub    $0x8,%esp
  801805:	56                   	push   %esi
  801806:	68 00 50 80 00       	push   $0x805000
  80180b:	e8 74 f1 ff ff       	call   800984 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801810:	8b 45 0c             	mov    0xc(%ebp),%eax
  801813:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801818:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80181b:	b8 01 00 00 00       	mov    $0x1,%eax
  801820:	e8 b8 fd ff ff       	call   8015dd <fsipc>
  801825:	89 c3                	mov    %eax,%ebx
  801827:	83 c4 10             	add    $0x10,%esp
  80182a:	85 c0                	test   %eax,%eax
  80182c:	78 19                	js     801847 <open+0x75>
	return fd2num(fd);
  80182e:	83 ec 0c             	sub    $0xc,%esp
  801831:	ff 75 f4             	pushl  -0xc(%ebp)
  801834:	e8 12 f8 ff ff       	call   80104b <fd2num>
  801839:	89 c3                	mov    %eax,%ebx
  80183b:	83 c4 10             	add    $0x10,%esp
}
  80183e:	89 d8                	mov    %ebx,%eax
  801840:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801843:	5b                   	pop    %ebx
  801844:	5e                   	pop    %esi
  801845:	5d                   	pop    %ebp
  801846:	c3                   	ret    
		fd_close(fd, 0);
  801847:	83 ec 08             	sub    $0x8,%esp
  80184a:	6a 00                	push   $0x0
  80184c:	ff 75 f4             	pushl  -0xc(%ebp)
  80184f:	e8 1b f9 ff ff       	call   80116f <fd_close>
		return r;
  801854:	83 c4 10             	add    $0x10,%esp
  801857:	eb e5                	jmp    80183e <open+0x6c>
		return -E_BAD_PATH;
  801859:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80185e:	eb de                	jmp    80183e <open+0x6c>

00801860 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801866:	ba 00 00 00 00       	mov    $0x0,%edx
  80186b:	b8 08 00 00 00       	mov    $0x8,%eax
  801870:	e8 68 fd ff ff       	call   8015dd <fsipc>
}
  801875:	c9                   	leave  
  801876:	c3                   	ret    

00801877 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
  80187a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80187d:	68 b7 2a 80 00       	push   $0x802ab7
  801882:	ff 75 0c             	pushl  0xc(%ebp)
  801885:	e8 fa f0 ff ff       	call   800984 <strcpy>
	return 0;
}
  80188a:	b8 00 00 00 00       	mov    $0x0,%eax
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <devsock_close>:
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	53                   	push   %ebx
  801895:	83 ec 10             	sub    $0x10,%esp
  801898:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80189b:	53                   	push   %ebx
  80189c:	e8 5d 0a 00 00       	call   8022fe <pageref>
  8018a1:	83 c4 10             	add    $0x10,%esp
		return 0;
  8018a4:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8018a9:	83 f8 01             	cmp    $0x1,%eax
  8018ac:	74 07                	je     8018b5 <devsock_close+0x24>
}
  8018ae:	89 d0                	mov    %edx,%eax
  8018b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018b3:	c9                   	leave  
  8018b4:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8018b5:	83 ec 0c             	sub    $0xc,%esp
  8018b8:	ff 73 0c             	pushl  0xc(%ebx)
  8018bb:	e8 b9 02 00 00       	call   801b79 <nsipc_close>
  8018c0:	89 c2                	mov    %eax,%edx
  8018c2:	83 c4 10             	add    $0x10,%esp
  8018c5:	eb e7                	jmp    8018ae <devsock_close+0x1d>

008018c7 <devsock_write>:
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
  8018ca:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018cd:	6a 00                	push   $0x0
  8018cf:	ff 75 10             	pushl  0x10(%ebp)
  8018d2:	ff 75 0c             	pushl  0xc(%ebp)
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d8:	ff 70 0c             	pushl  0xc(%eax)
  8018db:	e8 76 03 00 00       	call   801c56 <nsipc_send>
}
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <devsock_read>:
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018e8:	6a 00                	push   $0x0
  8018ea:	ff 75 10             	pushl  0x10(%ebp)
  8018ed:	ff 75 0c             	pushl  0xc(%ebp)
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	ff 70 0c             	pushl  0xc(%eax)
  8018f6:	e8 ef 02 00 00       	call   801bea <nsipc_recv>
}
  8018fb:	c9                   	leave  
  8018fc:	c3                   	ret    

008018fd <fd2sockid>:
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
  801900:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801903:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801906:	52                   	push   %edx
  801907:	50                   	push   %eax
  801908:	e8 b7 f7 ff ff       	call   8010c4 <fd_lookup>
  80190d:	83 c4 10             	add    $0x10,%esp
  801910:	85 c0                	test   %eax,%eax
  801912:	78 10                	js     801924 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801917:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80191d:	39 08                	cmp    %ecx,(%eax)
  80191f:	75 05                	jne    801926 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801921:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801924:	c9                   	leave  
  801925:	c3                   	ret    
		return -E_NOT_SUPP;
  801926:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80192b:	eb f7                	jmp    801924 <fd2sockid+0x27>

0080192d <alloc_sockfd>:
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
  801930:	56                   	push   %esi
  801931:	53                   	push   %ebx
  801932:	83 ec 1c             	sub    $0x1c,%esp
  801935:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801937:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80193a:	50                   	push   %eax
  80193b:	e8 32 f7 ff ff       	call   801072 <fd_alloc>
  801940:	89 c3                	mov    %eax,%ebx
  801942:	83 c4 10             	add    $0x10,%esp
  801945:	85 c0                	test   %eax,%eax
  801947:	78 43                	js     80198c <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801949:	83 ec 04             	sub    $0x4,%esp
  80194c:	68 07 04 00 00       	push   $0x407
  801951:	ff 75 f4             	pushl  -0xc(%ebp)
  801954:	6a 00                	push   $0x0
  801956:	e8 1b f4 ff ff       	call   800d76 <sys_page_alloc>
  80195b:	89 c3                	mov    %eax,%ebx
  80195d:	83 c4 10             	add    $0x10,%esp
  801960:	85 c0                	test   %eax,%eax
  801962:	78 28                	js     80198c <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801967:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80196d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80196f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801972:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801979:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80197c:	83 ec 0c             	sub    $0xc,%esp
  80197f:	50                   	push   %eax
  801980:	e8 c6 f6 ff ff       	call   80104b <fd2num>
  801985:	89 c3                	mov    %eax,%ebx
  801987:	83 c4 10             	add    $0x10,%esp
  80198a:	eb 0c                	jmp    801998 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80198c:	83 ec 0c             	sub    $0xc,%esp
  80198f:	56                   	push   %esi
  801990:	e8 e4 01 00 00       	call   801b79 <nsipc_close>
		return r;
  801995:	83 c4 10             	add    $0x10,%esp
}
  801998:	89 d8                	mov    %ebx,%eax
  80199a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80199d:	5b                   	pop    %ebx
  80199e:	5e                   	pop    %esi
  80199f:	5d                   	pop    %ebp
  8019a0:	c3                   	ret    

008019a1 <accept>:
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
  8019a4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019aa:	e8 4e ff ff ff       	call   8018fd <fd2sockid>
  8019af:	85 c0                	test   %eax,%eax
  8019b1:	78 1b                	js     8019ce <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019b3:	83 ec 04             	sub    $0x4,%esp
  8019b6:	ff 75 10             	pushl  0x10(%ebp)
  8019b9:	ff 75 0c             	pushl  0xc(%ebp)
  8019bc:	50                   	push   %eax
  8019bd:	e8 0e 01 00 00       	call   801ad0 <nsipc_accept>
  8019c2:	83 c4 10             	add    $0x10,%esp
  8019c5:	85 c0                	test   %eax,%eax
  8019c7:	78 05                	js     8019ce <accept+0x2d>
	return alloc_sockfd(r);
  8019c9:	e8 5f ff ff ff       	call   80192d <alloc_sockfd>
}
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <bind>:
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
  8019d3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	e8 1f ff ff ff       	call   8018fd <fd2sockid>
  8019de:	85 c0                	test   %eax,%eax
  8019e0:	78 12                	js     8019f4 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019e2:	83 ec 04             	sub    $0x4,%esp
  8019e5:	ff 75 10             	pushl  0x10(%ebp)
  8019e8:	ff 75 0c             	pushl  0xc(%ebp)
  8019eb:	50                   	push   %eax
  8019ec:	e8 31 01 00 00       	call   801b22 <nsipc_bind>
  8019f1:	83 c4 10             	add    $0x10,%esp
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <shutdown>:
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
  8019f9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ff:	e8 f9 fe ff ff       	call   8018fd <fd2sockid>
  801a04:	85 c0                	test   %eax,%eax
  801a06:	78 0f                	js     801a17 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a08:	83 ec 08             	sub    $0x8,%esp
  801a0b:	ff 75 0c             	pushl  0xc(%ebp)
  801a0e:	50                   	push   %eax
  801a0f:	e8 43 01 00 00       	call   801b57 <nsipc_shutdown>
  801a14:	83 c4 10             	add    $0x10,%esp
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <connect>:
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
  801a1c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	e8 d6 fe ff ff       	call   8018fd <fd2sockid>
  801a27:	85 c0                	test   %eax,%eax
  801a29:	78 12                	js     801a3d <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a2b:	83 ec 04             	sub    $0x4,%esp
  801a2e:	ff 75 10             	pushl  0x10(%ebp)
  801a31:	ff 75 0c             	pushl  0xc(%ebp)
  801a34:	50                   	push   %eax
  801a35:	e8 59 01 00 00       	call   801b93 <nsipc_connect>
  801a3a:	83 c4 10             	add    $0x10,%esp
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <listen>:
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a45:	8b 45 08             	mov    0x8(%ebp),%eax
  801a48:	e8 b0 fe ff ff       	call   8018fd <fd2sockid>
  801a4d:	85 c0                	test   %eax,%eax
  801a4f:	78 0f                	js     801a60 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a51:	83 ec 08             	sub    $0x8,%esp
  801a54:	ff 75 0c             	pushl  0xc(%ebp)
  801a57:	50                   	push   %eax
  801a58:	e8 6b 01 00 00       	call   801bc8 <nsipc_listen>
  801a5d:	83 c4 10             	add    $0x10,%esp
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
  801a65:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a68:	ff 75 10             	pushl  0x10(%ebp)
  801a6b:	ff 75 0c             	pushl  0xc(%ebp)
  801a6e:	ff 75 08             	pushl  0x8(%ebp)
  801a71:	e8 3e 02 00 00       	call   801cb4 <nsipc_socket>
  801a76:	83 c4 10             	add    $0x10,%esp
  801a79:	85 c0                	test   %eax,%eax
  801a7b:	78 05                	js     801a82 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a7d:	e8 ab fe ff ff       	call   80192d <alloc_sockfd>
}
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
  801a87:	53                   	push   %ebx
  801a88:	83 ec 04             	sub    $0x4,%esp
  801a8b:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a8d:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a94:	74 26                	je     801abc <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a96:	6a 07                	push   $0x7
  801a98:	68 00 60 80 00       	push   $0x806000
  801a9d:	53                   	push   %ebx
  801a9e:	ff 35 04 40 80 00    	pushl  0x804004
  801aa4:	e8 c2 07 00 00       	call   80226b <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801aa9:	83 c4 0c             	add    $0xc,%esp
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	e8 4b 07 00 00       	call   802202 <ipc_recv>
}
  801ab7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801abc:	83 ec 0c             	sub    $0xc,%esp
  801abf:	6a 02                	push   $0x2
  801ac1:	e8 fd 07 00 00       	call   8022c3 <ipc_find_env>
  801ac6:	a3 04 40 80 00       	mov    %eax,0x804004
  801acb:	83 c4 10             	add    $0x10,%esp
  801ace:	eb c6                	jmp    801a96 <nsipc+0x12>

00801ad0 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
  801ad3:	56                   	push   %esi
  801ad4:	53                   	push   %ebx
  801ad5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  801adb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ae0:	8b 06                	mov    (%esi),%eax
  801ae2:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ae7:	b8 01 00 00 00       	mov    $0x1,%eax
  801aec:	e8 93 ff ff ff       	call   801a84 <nsipc>
  801af1:	89 c3                	mov    %eax,%ebx
  801af3:	85 c0                	test   %eax,%eax
  801af5:	79 09                	jns    801b00 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801af7:	89 d8                	mov    %ebx,%eax
  801af9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801afc:	5b                   	pop    %ebx
  801afd:	5e                   	pop    %esi
  801afe:	5d                   	pop    %ebp
  801aff:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b00:	83 ec 04             	sub    $0x4,%esp
  801b03:	ff 35 10 60 80 00    	pushl  0x806010
  801b09:	68 00 60 80 00       	push   $0x806000
  801b0e:	ff 75 0c             	pushl  0xc(%ebp)
  801b11:	e8 fc ef ff ff       	call   800b12 <memmove>
		*addrlen = ret->ret_addrlen;
  801b16:	a1 10 60 80 00       	mov    0x806010,%eax
  801b1b:	89 06                	mov    %eax,(%esi)
  801b1d:	83 c4 10             	add    $0x10,%esp
	return r;
  801b20:	eb d5                	jmp    801af7 <nsipc_accept+0x27>

00801b22 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
  801b25:	53                   	push   %ebx
  801b26:	83 ec 08             	sub    $0x8,%esp
  801b29:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b34:	53                   	push   %ebx
  801b35:	ff 75 0c             	pushl  0xc(%ebp)
  801b38:	68 04 60 80 00       	push   $0x806004
  801b3d:	e8 d0 ef ff ff       	call   800b12 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b42:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b48:	b8 02 00 00 00       	mov    $0x2,%eax
  801b4d:	e8 32 ff ff ff       	call   801a84 <nsipc>
}
  801b52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
  801b5a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b68:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b6d:	b8 03 00 00 00       	mov    $0x3,%eax
  801b72:	e8 0d ff ff ff       	call   801a84 <nsipc>
}
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <nsipc_close>:

int
nsipc_close(int s)
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
  801b7c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b87:	b8 04 00 00 00       	mov    $0x4,%eax
  801b8c:	e8 f3 fe ff ff       	call   801a84 <nsipc>
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
  801b96:	53                   	push   %ebx
  801b97:	83 ec 08             	sub    $0x8,%esp
  801b9a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba0:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ba5:	53                   	push   %ebx
  801ba6:	ff 75 0c             	pushl  0xc(%ebp)
  801ba9:	68 04 60 80 00       	push   $0x806004
  801bae:	e8 5f ef ff ff       	call   800b12 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801bb3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801bb9:	b8 05 00 00 00       	mov    $0x5,%eax
  801bbe:	e8 c1 fe ff ff       	call   801a84 <nsipc>
}
  801bc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
  801bcb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801bce:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801bd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd9:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bde:	b8 06 00 00 00       	mov    $0x6,%eax
  801be3:	e8 9c fe ff ff       	call   801a84 <nsipc>
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
  801bed:	56                   	push   %esi
  801bee:	53                   	push   %ebx
  801bef:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bfa:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c00:	8b 45 14             	mov    0x14(%ebp),%eax
  801c03:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c08:	b8 07 00 00 00       	mov    $0x7,%eax
  801c0d:	e8 72 fe ff ff       	call   801a84 <nsipc>
  801c12:	89 c3                	mov    %eax,%ebx
  801c14:	85 c0                	test   %eax,%eax
  801c16:	78 1f                	js     801c37 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c18:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c1d:	7f 21                	jg     801c40 <nsipc_recv+0x56>
  801c1f:	39 c6                	cmp    %eax,%esi
  801c21:	7c 1d                	jl     801c40 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c23:	83 ec 04             	sub    $0x4,%esp
  801c26:	50                   	push   %eax
  801c27:	68 00 60 80 00       	push   $0x806000
  801c2c:	ff 75 0c             	pushl  0xc(%ebp)
  801c2f:	e8 de ee ff ff       	call   800b12 <memmove>
  801c34:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c37:	89 d8                	mov    %ebx,%eax
  801c39:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c3c:	5b                   	pop    %ebx
  801c3d:	5e                   	pop    %esi
  801c3e:	5d                   	pop    %ebp
  801c3f:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c40:	68 c3 2a 80 00       	push   $0x802ac3
  801c45:	68 8b 2a 80 00       	push   $0x802a8b
  801c4a:	6a 62                	push   $0x62
  801c4c:	68 d8 2a 80 00       	push   $0x802ad8
  801c51:	e8 4b 05 00 00       	call   8021a1 <_panic>

00801c56 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
  801c59:	53                   	push   %ebx
  801c5a:	83 ec 04             	sub    $0x4,%esp
  801c5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c60:	8b 45 08             	mov    0x8(%ebp),%eax
  801c63:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c68:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c6e:	7f 2e                	jg     801c9e <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c70:	83 ec 04             	sub    $0x4,%esp
  801c73:	53                   	push   %ebx
  801c74:	ff 75 0c             	pushl  0xc(%ebp)
  801c77:	68 0c 60 80 00       	push   $0x80600c
  801c7c:	e8 91 ee ff ff       	call   800b12 <memmove>
	nsipcbuf.send.req_size = size;
  801c81:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c87:	8b 45 14             	mov    0x14(%ebp),%eax
  801c8a:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c8f:	b8 08 00 00 00       	mov    $0x8,%eax
  801c94:	e8 eb fd ff ff       	call   801a84 <nsipc>
}
  801c99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    
	assert(size < 1600);
  801c9e:	68 e4 2a 80 00       	push   $0x802ae4
  801ca3:	68 8b 2a 80 00       	push   $0x802a8b
  801ca8:	6a 6d                	push   $0x6d
  801caa:	68 d8 2a 80 00       	push   $0x802ad8
  801caf:	e8 ed 04 00 00       	call   8021a1 <_panic>

00801cb4 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
  801cb7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801cba:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbd:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc5:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801cca:	8b 45 10             	mov    0x10(%ebp),%eax
  801ccd:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801cd2:	b8 09 00 00 00       	mov    $0x9,%eax
  801cd7:	e8 a8 fd ff ff       	call   801a84 <nsipc>
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	56                   	push   %esi
  801ce2:	53                   	push   %ebx
  801ce3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ce6:	83 ec 0c             	sub    $0xc,%esp
  801ce9:	ff 75 08             	pushl  0x8(%ebp)
  801cec:	e8 6a f3 ff ff       	call   80105b <fd2data>
  801cf1:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cf3:	83 c4 08             	add    $0x8,%esp
  801cf6:	68 f0 2a 80 00       	push   $0x802af0
  801cfb:	53                   	push   %ebx
  801cfc:	e8 83 ec ff ff       	call   800984 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d01:	8b 46 04             	mov    0x4(%esi),%eax
  801d04:	2b 06                	sub    (%esi),%eax
  801d06:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d0c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d13:	00 00 00 
	stat->st_dev = &devpipe;
  801d16:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d1d:	30 80 00 
	return 0;
}
  801d20:	b8 00 00 00 00       	mov    $0x0,%eax
  801d25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d28:	5b                   	pop    %ebx
  801d29:	5e                   	pop    %esi
  801d2a:	5d                   	pop    %ebp
  801d2b:	c3                   	ret    

00801d2c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
  801d2f:	53                   	push   %ebx
  801d30:	83 ec 0c             	sub    $0xc,%esp
  801d33:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d36:	53                   	push   %ebx
  801d37:	6a 00                	push   $0x0
  801d39:	e8 bd f0 ff ff       	call   800dfb <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d3e:	89 1c 24             	mov    %ebx,(%esp)
  801d41:	e8 15 f3 ff ff       	call   80105b <fd2data>
  801d46:	83 c4 08             	add    $0x8,%esp
  801d49:	50                   	push   %eax
  801d4a:	6a 00                	push   $0x0
  801d4c:	e8 aa f0 ff ff       	call   800dfb <sys_page_unmap>
}
  801d51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <_pipeisclosed>:
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
  801d59:	57                   	push   %edi
  801d5a:	56                   	push   %esi
  801d5b:	53                   	push   %ebx
  801d5c:	83 ec 1c             	sub    $0x1c,%esp
  801d5f:	89 c7                	mov    %eax,%edi
  801d61:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d63:	a1 08 40 80 00       	mov    0x804008,%eax
  801d68:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d6b:	83 ec 0c             	sub    $0xc,%esp
  801d6e:	57                   	push   %edi
  801d6f:	e8 8a 05 00 00       	call   8022fe <pageref>
  801d74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d77:	89 34 24             	mov    %esi,(%esp)
  801d7a:	e8 7f 05 00 00       	call   8022fe <pageref>
		nn = thisenv->env_runs;
  801d7f:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d85:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d88:	83 c4 10             	add    $0x10,%esp
  801d8b:	39 cb                	cmp    %ecx,%ebx
  801d8d:	74 1b                	je     801daa <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d8f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d92:	75 cf                	jne    801d63 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d94:	8b 42 58             	mov    0x58(%edx),%eax
  801d97:	6a 01                	push   $0x1
  801d99:	50                   	push   %eax
  801d9a:	53                   	push   %ebx
  801d9b:	68 f7 2a 80 00       	push   $0x802af7
  801da0:	e8 80 e4 ff ff       	call   800225 <cprintf>
  801da5:	83 c4 10             	add    $0x10,%esp
  801da8:	eb b9                	jmp    801d63 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801daa:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dad:	0f 94 c0             	sete   %al
  801db0:	0f b6 c0             	movzbl %al,%eax
}
  801db3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801db6:	5b                   	pop    %ebx
  801db7:	5e                   	pop    %esi
  801db8:	5f                   	pop    %edi
  801db9:	5d                   	pop    %ebp
  801dba:	c3                   	ret    

00801dbb <devpipe_write>:
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
  801dbe:	57                   	push   %edi
  801dbf:	56                   	push   %esi
  801dc0:	53                   	push   %ebx
  801dc1:	83 ec 28             	sub    $0x28,%esp
  801dc4:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801dc7:	56                   	push   %esi
  801dc8:	e8 8e f2 ff ff       	call   80105b <fd2data>
  801dcd:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dcf:	83 c4 10             	add    $0x10,%esp
  801dd2:	bf 00 00 00 00       	mov    $0x0,%edi
  801dd7:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801dda:	74 4f                	je     801e2b <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ddc:	8b 43 04             	mov    0x4(%ebx),%eax
  801ddf:	8b 0b                	mov    (%ebx),%ecx
  801de1:	8d 51 20             	lea    0x20(%ecx),%edx
  801de4:	39 d0                	cmp    %edx,%eax
  801de6:	72 14                	jb     801dfc <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801de8:	89 da                	mov    %ebx,%edx
  801dea:	89 f0                	mov    %esi,%eax
  801dec:	e8 65 ff ff ff       	call   801d56 <_pipeisclosed>
  801df1:	85 c0                	test   %eax,%eax
  801df3:	75 3b                	jne    801e30 <devpipe_write+0x75>
			sys_yield();
  801df5:	e8 5d ef ff ff       	call   800d57 <sys_yield>
  801dfa:	eb e0                	jmp    801ddc <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dff:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e03:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e06:	89 c2                	mov    %eax,%edx
  801e08:	c1 fa 1f             	sar    $0x1f,%edx
  801e0b:	89 d1                	mov    %edx,%ecx
  801e0d:	c1 e9 1b             	shr    $0x1b,%ecx
  801e10:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e13:	83 e2 1f             	and    $0x1f,%edx
  801e16:	29 ca                	sub    %ecx,%edx
  801e18:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e1c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e20:	83 c0 01             	add    $0x1,%eax
  801e23:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e26:	83 c7 01             	add    $0x1,%edi
  801e29:	eb ac                	jmp    801dd7 <devpipe_write+0x1c>
	return i;
  801e2b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e2e:	eb 05                	jmp    801e35 <devpipe_write+0x7a>
				return 0;
  801e30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e38:	5b                   	pop    %ebx
  801e39:	5e                   	pop    %esi
  801e3a:	5f                   	pop    %edi
  801e3b:	5d                   	pop    %ebp
  801e3c:	c3                   	ret    

00801e3d <devpipe_read>:
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
  801e40:	57                   	push   %edi
  801e41:	56                   	push   %esi
  801e42:	53                   	push   %ebx
  801e43:	83 ec 18             	sub    $0x18,%esp
  801e46:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e49:	57                   	push   %edi
  801e4a:	e8 0c f2 ff ff       	call   80105b <fd2data>
  801e4f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e51:	83 c4 10             	add    $0x10,%esp
  801e54:	be 00 00 00 00       	mov    $0x0,%esi
  801e59:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e5c:	75 14                	jne    801e72 <devpipe_read+0x35>
	return i;
  801e5e:	8b 45 10             	mov    0x10(%ebp),%eax
  801e61:	eb 02                	jmp    801e65 <devpipe_read+0x28>
				return i;
  801e63:	89 f0                	mov    %esi,%eax
}
  801e65:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e68:	5b                   	pop    %ebx
  801e69:	5e                   	pop    %esi
  801e6a:	5f                   	pop    %edi
  801e6b:	5d                   	pop    %ebp
  801e6c:	c3                   	ret    
			sys_yield();
  801e6d:	e8 e5 ee ff ff       	call   800d57 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e72:	8b 03                	mov    (%ebx),%eax
  801e74:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e77:	75 18                	jne    801e91 <devpipe_read+0x54>
			if (i > 0)
  801e79:	85 f6                	test   %esi,%esi
  801e7b:	75 e6                	jne    801e63 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e7d:	89 da                	mov    %ebx,%edx
  801e7f:	89 f8                	mov    %edi,%eax
  801e81:	e8 d0 fe ff ff       	call   801d56 <_pipeisclosed>
  801e86:	85 c0                	test   %eax,%eax
  801e88:	74 e3                	je     801e6d <devpipe_read+0x30>
				return 0;
  801e8a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8f:	eb d4                	jmp    801e65 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e91:	99                   	cltd   
  801e92:	c1 ea 1b             	shr    $0x1b,%edx
  801e95:	01 d0                	add    %edx,%eax
  801e97:	83 e0 1f             	and    $0x1f,%eax
  801e9a:	29 d0                	sub    %edx,%eax
  801e9c:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ea1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ea4:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ea7:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801eaa:	83 c6 01             	add    $0x1,%esi
  801ead:	eb aa                	jmp    801e59 <devpipe_read+0x1c>

00801eaf <pipe>:
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
  801eb2:	56                   	push   %esi
  801eb3:	53                   	push   %ebx
  801eb4:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801eb7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eba:	50                   	push   %eax
  801ebb:	e8 b2 f1 ff ff       	call   801072 <fd_alloc>
  801ec0:	89 c3                	mov    %eax,%ebx
  801ec2:	83 c4 10             	add    $0x10,%esp
  801ec5:	85 c0                	test   %eax,%eax
  801ec7:	0f 88 23 01 00 00    	js     801ff0 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ecd:	83 ec 04             	sub    $0x4,%esp
  801ed0:	68 07 04 00 00       	push   $0x407
  801ed5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ed8:	6a 00                	push   $0x0
  801eda:	e8 97 ee ff ff       	call   800d76 <sys_page_alloc>
  801edf:	89 c3                	mov    %eax,%ebx
  801ee1:	83 c4 10             	add    $0x10,%esp
  801ee4:	85 c0                	test   %eax,%eax
  801ee6:	0f 88 04 01 00 00    	js     801ff0 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801eec:	83 ec 0c             	sub    $0xc,%esp
  801eef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ef2:	50                   	push   %eax
  801ef3:	e8 7a f1 ff ff       	call   801072 <fd_alloc>
  801ef8:	89 c3                	mov    %eax,%ebx
  801efa:	83 c4 10             	add    $0x10,%esp
  801efd:	85 c0                	test   %eax,%eax
  801eff:	0f 88 db 00 00 00    	js     801fe0 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f05:	83 ec 04             	sub    $0x4,%esp
  801f08:	68 07 04 00 00       	push   $0x407
  801f0d:	ff 75 f0             	pushl  -0x10(%ebp)
  801f10:	6a 00                	push   $0x0
  801f12:	e8 5f ee ff ff       	call   800d76 <sys_page_alloc>
  801f17:	89 c3                	mov    %eax,%ebx
  801f19:	83 c4 10             	add    $0x10,%esp
  801f1c:	85 c0                	test   %eax,%eax
  801f1e:	0f 88 bc 00 00 00    	js     801fe0 <pipe+0x131>
	va = fd2data(fd0);
  801f24:	83 ec 0c             	sub    $0xc,%esp
  801f27:	ff 75 f4             	pushl  -0xc(%ebp)
  801f2a:	e8 2c f1 ff ff       	call   80105b <fd2data>
  801f2f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f31:	83 c4 0c             	add    $0xc,%esp
  801f34:	68 07 04 00 00       	push   $0x407
  801f39:	50                   	push   %eax
  801f3a:	6a 00                	push   $0x0
  801f3c:	e8 35 ee ff ff       	call   800d76 <sys_page_alloc>
  801f41:	89 c3                	mov    %eax,%ebx
  801f43:	83 c4 10             	add    $0x10,%esp
  801f46:	85 c0                	test   %eax,%eax
  801f48:	0f 88 82 00 00 00    	js     801fd0 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f4e:	83 ec 0c             	sub    $0xc,%esp
  801f51:	ff 75 f0             	pushl  -0x10(%ebp)
  801f54:	e8 02 f1 ff ff       	call   80105b <fd2data>
  801f59:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f60:	50                   	push   %eax
  801f61:	6a 00                	push   $0x0
  801f63:	56                   	push   %esi
  801f64:	6a 00                	push   $0x0
  801f66:	e8 4e ee ff ff       	call   800db9 <sys_page_map>
  801f6b:	89 c3                	mov    %eax,%ebx
  801f6d:	83 c4 20             	add    $0x20,%esp
  801f70:	85 c0                	test   %eax,%eax
  801f72:	78 4e                	js     801fc2 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f74:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f7c:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f81:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f8b:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f90:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f97:	83 ec 0c             	sub    $0xc,%esp
  801f9a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f9d:	e8 a9 f0 ff ff       	call   80104b <fd2num>
  801fa2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fa5:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fa7:	83 c4 04             	add    $0x4,%esp
  801faa:	ff 75 f0             	pushl  -0x10(%ebp)
  801fad:	e8 99 f0 ff ff       	call   80104b <fd2num>
  801fb2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fb5:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fb8:	83 c4 10             	add    $0x10,%esp
  801fbb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fc0:	eb 2e                	jmp    801ff0 <pipe+0x141>
	sys_page_unmap(0, va);
  801fc2:	83 ec 08             	sub    $0x8,%esp
  801fc5:	56                   	push   %esi
  801fc6:	6a 00                	push   $0x0
  801fc8:	e8 2e ee ff ff       	call   800dfb <sys_page_unmap>
  801fcd:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fd0:	83 ec 08             	sub    $0x8,%esp
  801fd3:	ff 75 f0             	pushl  -0x10(%ebp)
  801fd6:	6a 00                	push   $0x0
  801fd8:	e8 1e ee ff ff       	call   800dfb <sys_page_unmap>
  801fdd:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fe0:	83 ec 08             	sub    $0x8,%esp
  801fe3:	ff 75 f4             	pushl  -0xc(%ebp)
  801fe6:	6a 00                	push   $0x0
  801fe8:	e8 0e ee ff ff       	call   800dfb <sys_page_unmap>
  801fed:	83 c4 10             	add    $0x10,%esp
}
  801ff0:	89 d8                	mov    %ebx,%eax
  801ff2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ff5:	5b                   	pop    %ebx
  801ff6:	5e                   	pop    %esi
  801ff7:	5d                   	pop    %ebp
  801ff8:	c3                   	ret    

00801ff9 <pipeisclosed>:
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802002:	50                   	push   %eax
  802003:	ff 75 08             	pushl  0x8(%ebp)
  802006:	e8 b9 f0 ff ff       	call   8010c4 <fd_lookup>
  80200b:	83 c4 10             	add    $0x10,%esp
  80200e:	85 c0                	test   %eax,%eax
  802010:	78 18                	js     80202a <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802012:	83 ec 0c             	sub    $0xc,%esp
  802015:	ff 75 f4             	pushl  -0xc(%ebp)
  802018:	e8 3e f0 ff ff       	call   80105b <fd2data>
	return _pipeisclosed(fd, p);
  80201d:	89 c2                	mov    %eax,%edx
  80201f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802022:	e8 2f fd ff ff       	call   801d56 <_pipeisclosed>
  802027:	83 c4 10             	add    $0x10,%esp
}
  80202a:	c9                   	leave  
  80202b:	c3                   	ret    

0080202c <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80202c:	b8 00 00 00 00       	mov    $0x0,%eax
  802031:	c3                   	ret    

00802032 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
  802035:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802038:	68 0f 2b 80 00       	push   $0x802b0f
  80203d:	ff 75 0c             	pushl  0xc(%ebp)
  802040:	e8 3f e9 ff ff       	call   800984 <strcpy>
	return 0;
}
  802045:	b8 00 00 00 00       	mov    $0x0,%eax
  80204a:	c9                   	leave  
  80204b:	c3                   	ret    

0080204c <devcons_write>:
{
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
  80204f:	57                   	push   %edi
  802050:	56                   	push   %esi
  802051:	53                   	push   %ebx
  802052:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802058:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80205d:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802063:	3b 75 10             	cmp    0x10(%ebp),%esi
  802066:	73 31                	jae    802099 <devcons_write+0x4d>
		m = n - tot;
  802068:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80206b:	29 f3                	sub    %esi,%ebx
  80206d:	83 fb 7f             	cmp    $0x7f,%ebx
  802070:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802075:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802078:	83 ec 04             	sub    $0x4,%esp
  80207b:	53                   	push   %ebx
  80207c:	89 f0                	mov    %esi,%eax
  80207e:	03 45 0c             	add    0xc(%ebp),%eax
  802081:	50                   	push   %eax
  802082:	57                   	push   %edi
  802083:	e8 8a ea ff ff       	call   800b12 <memmove>
		sys_cputs(buf, m);
  802088:	83 c4 08             	add    $0x8,%esp
  80208b:	53                   	push   %ebx
  80208c:	57                   	push   %edi
  80208d:	e8 28 ec ff ff       	call   800cba <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802092:	01 de                	add    %ebx,%esi
  802094:	83 c4 10             	add    $0x10,%esp
  802097:	eb ca                	jmp    802063 <devcons_write+0x17>
}
  802099:	89 f0                	mov    %esi,%eax
  80209b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80209e:	5b                   	pop    %ebx
  80209f:	5e                   	pop    %esi
  8020a0:	5f                   	pop    %edi
  8020a1:	5d                   	pop    %ebp
  8020a2:	c3                   	ret    

008020a3 <devcons_read>:
{
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
  8020a6:	83 ec 08             	sub    $0x8,%esp
  8020a9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020ae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020b2:	74 21                	je     8020d5 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8020b4:	e8 1f ec ff ff       	call   800cd8 <sys_cgetc>
  8020b9:	85 c0                	test   %eax,%eax
  8020bb:	75 07                	jne    8020c4 <devcons_read+0x21>
		sys_yield();
  8020bd:	e8 95 ec ff ff       	call   800d57 <sys_yield>
  8020c2:	eb f0                	jmp    8020b4 <devcons_read+0x11>
	if (c < 0)
  8020c4:	78 0f                	js     8020d5 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020c6:	83 f8 04             	cmp    $0x4,%eax
  8020c9:	74 0c                	je     8020d7 <devcons_read+0x34>
	*(char*)vbuf = c;
  8020cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ce:	88 02                	mov    %al,(%edx)
	return 1;
  8020d0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020d5:	c9                   	leave  
  8020d6:	c3                   	ret    
		return 0;
  8020d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020dc:	eb f7                	jmp    8020d5 <devcons_read+0x32>

008020de <cputchar>:
{
  8020de:	55                   	push   %ebp
  8020df:	89 e5                	mov    %esp,%ebp
  8020e1:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e7:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020ea:	6a 01                	push   $0x1
  8020ec:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020ef:	50                   	push   %eax
  8020f0:	e8 c5 eb ff ff       	call   800cba <sys_cputs>
}
  8020f5:	83 c4 10             	add    $0x10,%esp
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <getchar>:
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
  8020fd:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802100:	6a 01                	push   $0x1
  802102:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802105:	50                   	push   %eax
  802106:	6a 00                	push   $0x0
  802108:	e8 27 f2 ff ff       	call   801334 <read>
	if (r < 0)
  80210d:	83 c4 10             	add    $0x10,%esp
  802110:	85 c0                	test   %eax,%eax
  802112:	78 06                	js     80211a <getchar+0x20>
	if (r < 1)
  802114:	74 06                	je     80211c <getchar+0x22>
	return c;
  802116:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80211a:	c9                   	leave  
  80211b:	c3                   	ret    
		return -E_EOF;
  80211c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802121:	eb f7                	jmp    80211a <getchar+0x20>

00802123 <iscons>:
{
  802123:	55                   	push   %ebp
  802124:	89 e5                	mov    %esp,%ebp
  802126:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802129:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80212c:	50                   	push   %eax
  80212d:	ff 75 08             	pushl  0x8(%ebp)
  802130:	e8 8f ef ff ff       	call   8010c4 <fd_lookup>
  802135:	83 c4 10             	add    $0x10,%esp
  802138:	85 c0                	test   %eax,%eax
  80213a:	78 11                	js     80214d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80213c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213f:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802145:	39 10                	cmp    %edx,(%eax)
  802147:	0f 94 c0             	sete   %al
  80214a:	0f b6 c0             	movzbl %al,%eax
}
  80214d:	c9                   	leave  
  80214e:	c3                   	ret    

0080214f <opencons>:
{
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
  802152:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802155:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802158:	50                   	push   %eax
  802159:	e8 14 ef ff ff       	call   801072 <fd_alloc>
  80215e:	83 c4 10             	add    $0x10,%esp
  802161:	85 c0                	test   %eax,%eax
  802163:	78 3a                	js     80219f <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802165:	83 ec 04             	sub    $0x4,%esp
  802168:	68 07 04 00 00       	push   $0x407
  80216d:	ff 75 f4             	pushl  -0xc(%ebp)
  802170:	6a 00                	push   $0x0
  802172:	e8 ff eb ff ff       	call   800d76 <sys_page_alloc>
  802177:	83 c4 10             	add    $0x10,%esp
  80217a:	85 c0                	test   %eax,%eax
  80217c:	78 21                	js     80219f <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80217e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802181:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802187:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802193:	83 ec 0c             	sub    $0xc,%esp
  802196:	50                   	push   %eax
  802197:	e8 af ee ff ff       	call   80104b <fd2num>
  80219c:	83 c4 10             	add    $0x10,%esp
}
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
  8021a4:	56                   	push   %esi
  8021a5:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8021a6:	a1 08 40 80 00       	mov    0x804008,%eax
  8021ab:	8b 40 48             	mov    0x48(%eax),%eax
  8021ae:	83 ec 04             	sub    $0x4,%esp
  8021b1:	68 40 2b 80 00       	push   $0x802b40
  8021b6:	50                   	push   %eax
  8021b7:	68 3a 26 80 00       	push   $0x80263a
  8021bc:	e8 64 e0 ff ff       	call   800225 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8021c1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021c4:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021ca:	e8 69 eb ff ff       	call   800d38 <sys_getenvid>
  8021cf:	83 c4 04             	add    $0x4,%esp
  8021d2:	ff 75 0c             	pushl  0xc(%ebp)
  8021d5:	ff 75 08             	pushl  0x8(%ebp)
  8021d8:	56                   	push   %esi
  8021d9:	50                   	push   %eax
  8021da:	68 1c 2b 80 00       	push   $0x802b1c
  8021df:	e8 41 e0 ff ff       	call   800225 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021e4:	83 c4 18             	add    $0x18,%esp
  8021e7:	53                   	push   %ebx
  8021e8:	ff 75 10             	pushl  0x10(%ebp)
  8021eb:	e8 e4 df ff ff       	call   8001d4 <vcprintf>
	cprintf("\n");
  8021f0:	c7 04 24 fe 25 80 00 	movl   $0x8025fe,(%esp)
  8021f7:	e8 29 e0 ff ff       	call   800225 <cprintf>
  8021fc:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021ff:	cc                   	int3   
  802200:	eb fd                	jmp    8021ff <_panic+0x5e>

00802202 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
  802205:	56                   	push   %esi
  802206:	53                   	push   %ebx
  802207:	8b 75 08             	mov    0x8(%ebp),%esi
  80220a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802210:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802212:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802217:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80221a:	83 ec 0c             	sub    $0xc,%esp
  80221d:	50                   	push   %eax
  80221e:	e8 03 ed ff ff       	call   800f26 <sys_ipc_recv>
	if(ret < 0){
  802223:	83 c4 10             	add    $0x10,%esp
  802226:	85 c0                	test   %eax,%eax
  802228:	78 2b                	js     802255 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80222a:	85 f6                	test   %esi,%esi
  80222c:	74 0a                	je     802238 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80222e:	a1 08 40 80 00       	mov    0x804008,%eax
  802233:	8b 40 74             	mov    0x74(%eax),%eax
  802236:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802238:	85 db                	test   %ebx,%ebx
  80223a:	74 0a                	je     802246 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80223c:	a1 08 40 80 00       	mov    0x804008,%eax
  802241:	8b 40 78             	mov    0x78(%eax),%eax
  802244:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802246:	a1 08 40 80 00       	mov    0x804008,%eax
  80224b:	8b 40 70             	mov    0x70(%eax),%eax
}
  80224e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802251:	5b                   	pop    %ebx
  802252:	5e                   	pop    %esi
  802253:	5d                   	pop    %ebp
  802254:	c3                   	ret    
		if(from_env_store)
  802255:	85 f6                	test   %esi,%esi
  802257:	74 06                	je     80225f <ipc_recv+0x5d>
			*from_env_store = 0;
  802259:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80225f:	85 db                	test   %ebx,%ebx
  802261:	74 eb                	je     80224e <ipc_recv+0x4c>
			*perm_store = 0;
  802263:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802269:	eb e3                	jmp    80224e <ipc_recv+0x4c>

0080226b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80226b:	55                   	push   %ebp
  80226c:	89 e5                	mov    %esp,%ebp
  80226e:	57                   	push   %edi
  80226f:	56                   	push   %esi
  802270:	53                   	push   %ebx
  802271:	83 ec 0c             	sub    $0xc,%esp
  802274:	8b 7d 08             	mov    0x8(%ebp),%edi
  802277:	8b 75 0c             	mov    0xc(%ebp),%esi
  80227a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80227d:	85 db                	test   %ebx,%ebx
  80227f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802284:	0f 44 d8             	cmove  %eax,%ebx
  802287:	eb 05                	jmp    80228e <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802289:	e8 c9 ea ff ff       	call   800d57 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80228e:	ff 75 14             	pushl  0x14(%ebp)
  802291:	53                   	push   %ebx
  802292:	56                   	push   %esi
  802293:	57                   	push   %edi
  802294:	e8 6a ec ff ff       	call   800f03 <sys_ipc_try_send>
  802299:	83 c4 10             	add    $0x10,%esp
  80229c:	85 c0                	test   %eax,%eax
  80229e:	74 1b                	je     8022bb <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8022a0:	79 e7                	jns    802289 <ipc_send+0x1e>
  8022a2:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022a5:	74 e2                	je     802289 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8022a7:	83 ec 04             	sub    $0x4,%esp
  8022aa:	68 47 2b 80 00       	push   $0x802b47
  8022af:	6a 46                	push   $0x46
  8022b1:	68 5c 2b 80 00       	push   $0x802b5c
  8022b6:	e8 e6 fe ff ff       	call   8021a1 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8022bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022be:	5b                   	pop    %ebx
  8022bf:	5e                   	pop    %esi
  8022c0:	5f                   	pop    %edi
  8022c1:	5d                   	pop    %ebp
  8022c2:	c3                   	ret    

008022c3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022c3:	55                   	push   %ebp
  8022c4:	89 e5                	mov    %esp,%ebp
  8022c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022c9:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022ce:	89 c2                	mov    %eax,%edx
  8022d0:	c1 e2 07             	shl    $0x7,%edx
  8022d3:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022d9:	8b 52 50             	mov    0x50(%edx),%edx
  8022dc:	39 ca                	cmp    %ecx,%edx
  8022de:	74 11                	je     8022f1 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8022e0:	83 c0 01             	add    $0x1,%eax
  8022e3:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022e8:	75 e4                	jne    8022ce <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ef:	eb 0b                	jmp    8022fc <ipc_find_env+0x39>
			return envs[i].env_id;
  8022f1:	c1 e0 07             	shl    $0x7,%eax
  8022f4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022f9:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022fc:	5d                   	pop    %ebp
  8022fd:	c3                   	ret    

008022fe <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
  802301:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802304:	89 d0                	mov    %edx,%eax
  802306:	c1 e8 16             	shr    $0x16,%eax
  802309:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802310:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802315:	f6 c1 01             	test   $0x1,%cl
  802318:	74 1d                	je     802337 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80231a:	c1 ea 0c             	shr    $0xc,%edx
  80231d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802324:	f6 c2 01             	test   $0x1,%dl
  802327:	74 0e                	je     802337 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802329:	c1 ea 0c             	shr    $0xc,%edx
  80232c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802333:	ef 
  802334:	0f b7 c0             	movzwl %ax,%eax
}
  802337:	5d                   	pop    %ebp
  802338:	c3                   	ret    
  802339:	66 90                	xchg   %ax,%ax
  80233b:	66 90                	xchg   %ax,%ax
  80233d:	66 90                	xchg   %ax,%ax
  80233f:	90                   	nop

00802340 <__udivdi3>:
  802340:	55                   	push   %ebp
  802341:	57                   	push   %edi
  802342:	56                   	push   %esi
  802343:	53                   	push   %ebx
  802344:	83 ec 1c             	sub    $0x1c,%esp
  802347:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80234b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80234f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802353:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802357:	85 d2                	test   %edx,%edx
  802359:	75 4d                	jne    8023a8 <__udivdi3+0x68>
  80235b:	39 f3                	cmp    %esi,%ebx
  80235d:	76 19                	jbe    802378 <__udivdi3+0x38>
  80235f:	31 ff                	xor    %edi,%edi
  802361:	89 e8                	mov    %ebp,%eax
  802363:	89 f2                	mov    %esi,%edx
  802365:	f7 f3                	div    %ebx
  802367:	89 fa                	mov    %edi,%edx
  802369:	83 c4 1c             	add    $0x1c,%esp
  80236c:	5b                   	pop    %ebx
  80236d:	5e                   	pop    %esi
  80236e:	5f                   	pop    %edi
  80236f:	5d                   	pop    %ebp
  802370:	c3                   	ret    
  802371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802378:	89 d9                	mov    %ebx,%ecx
  80237a:	85 db                	test   %ebx,%ebx
  80237c:	75 0b                	jne    802389 <__udivdi3+0x49>
  80237e:	b8 01 00 00 00       	mov    $0x1,%eax
  802383:	31 d2                	xor    %edx,%edx
  802385:	f7 f3                	div    %ebx
  802387:	89 c1                	mov    %eax,%ecx
  802389:	31 d2                	xor    %edx,%edx
  80238b:	89 f0                	mov    %esi,%eax
  80238d:	f7 f1                	div    %ecx
  80238f:	89 c6                	mov    %eax,%esi
  802391:	89 e8                	mov    %ebp,%eax
  802393:	89 f7                	mov    %esi,%edi
  802395:	f7 f1                	div    %ecx
  802397:	89 fa                	mov    %edi,%edx
  802399:	83 c4 1c             	add    $0x1c,%esp
  80239c:	5b                   	pop    %ebx
  80239d:	5e                   	pop    %esi
  80239e:	5f                   	pop    %edi
  80239f:	5d                   	pop    %ebp
  8023a0:	c3                   	ret    
  8023a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023a8:	39 f2                	cmp    %esi,%edx
  8023aa:	77 1c                	ja     8023c8 <__udivdi3+0x88>
  8023ac:	0f bd fa             	bsr    %edx,%edi
  8023af:	83 f7 1f             	xor    $0x1f,%edi
  8023b2:	75 2c                	jne    8023e0 <__udivdi3+0xa0>
  8023b4:	39 f2                	cmp    %esi,%edx
  8023b6:	72 06                	jb     8023be <__udivdi3+0x7e>
  8023b8:	31 c0                	xor    %eax,%eax
  8023ba:	39 eb                	cmp    %ebp,%ebx
  8023bc:	77 a9                	ja     802367 <__udivdi3+0x27>
  8023be:	b8 01 00 00 00       	mov    $0x1,%eax
  8023c3:	eb a2                	jmp    802367 <__udivdi3+0x27>
  8023c5:	8d 76 00             	lea    0x0(%esi),%esi
  8023c8:	31 ff                	xor    %edi,%edi
  8023ca:	31 c0                	xor    %eax,%eax
  8023cc:	89 fa                	mov    %edi,%edx
  8023ce:	83 c4 1c             	add    $0x1c,%esp
  8023d1:	5b                   	pop    %ebx
  8023d2:	5e                   	pop    %esi
  8023d3:	5f                   	pop    %edi
  8023d4:	5d                   	pop    %ebp
  8023d5:	c3                   	ret    
  8023d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023dd:	8d 76 00             	lea    0x0(%esi),%esi
  8023e0:	89 f9                	mov    %edi,%ecx
  8023e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023e7:	29 f8                	sub    %edi,%eax
  8023e9:	d3 e2                	shl    %cl,%edx
  8023eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023ef:	89 c1                	mov    %eax,%ecx
  8023f1:	89 da                	mov    %ebx,%edx
  8023f3:	d3 ea                	shr    %cl,%edx
  8023f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023f9:	09 d1                	or     %edx,%ecx
  8023fb:	89 f2                	mov    %esi,%edx
  8023fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802401:	89 f9                	mov    %edi,%ecx
  802403:	d3 e3                	shl    %cl,%ebx
  802405:	89 c1                	mov    %eax,%ecx
  802407:	d3 ea                	shr    %cl,%edx
  802409:	89 f9                	mov    %edi,%ecx
  80240b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80240f:	89 eb                	mov    %ebp,%ebx
  802411:	d3 e6                	shl    %cl,%esi
  802413:	89 c1                	mov    %eax,%ecx
  802415:	d3 eb                	shr    %cl,%ebx
  802417:	09 de                	or     %ebx,%esi
  802419:	89 f0                	mov    %esi,%eax
  80241b:	f7 74 24 08          	divl   0x8(%esp)
  80241f:	89 d6                	mov    %edx,%esi
  802421:	89 c3                	mov    %eax,%ebx
  802423:	f7 64 24 0c          	mull   0xc(%esp)
  802427:	39 d6                	cmp    %edx,%esi
  802429:	72 15                	jb     802440 <__udivdi3+0x100>
  80242b:	89 f9                	mov    %edi,%ecx
  80242d:	d3 e5                	shl    %cl,%ebp
  80242f:	39 c5                	cmp    %eax,%ebp
  802431:	73 04                	jae    802437 <__udivdi3+0xf7>
  802433:	39 d6                	cmp    %edx,%esi
  802435:	74 09                	je     802440 <__udivdi3+0x100>
  802437:	89 d8                	mov    %ebx,%eax
  802439:	31 ff                	xor    %edi,%edi
  80243b:	e9 27 ff ff ff       	jmp    802367 <__udivdi3+0x27>
  802440:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802443:	31 ff                	xor    %edi,%edi
  802445:	e9 1d ff ff ff       	jmp    802367 <__udivdi3+0x27>
  80244a:	66 90                	xchg   %ax,%ax
  80244c:	66 90                	xchg   %ax,%ax
  80244e:	66 90                	xchg   %ax,%ax

00802450 <__umoddi3>:
  802450:	55                   	push   %ebp
  802451:	57                   	push   %edi
  802452:	56                   	push   %esi
  802453:	53                   	push   %ebx
  802454:	83 ec 1c             	sub    $0x1c,%esp
  802457:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80245b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80245f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802463:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802467:	89 da                	mov    %ebx,%edx
  802469:	85 c0                	test   %eax,%eax
  80246b:	75 43                	jne    8024b0 <__umoddi3+0x60>
  80246d:	39 df                	cmp    %ebx,%edi
  80246f:	76 17                	jbe    802488 <__umoddi3+0x38>
  802471:	89 f0                	mov    %esi,%eax
  802473:	f7 f7                	div    %edi
  802475:	89 d0                	mov    %edx,%eax
  802477:	31 d2                	xor    %edx,%edx
  802479:	83 c4 1c             	add    $0x1c,%esp
  80247c:	5b                   	pop    %ebx
  80247d:	5e                   	pop    %esi
  80247e:	5f                   	pop    %edi
  80247f:	5d                   	pop    %ebp
  802480:	c3                   	ret    
  802481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802488:	89 fd                	mov    %edi,%ebp
  80248a:	85 ff                	test   %edi,%edi
  80248c:	75 0b                	jne    802499 <__umoddi3+0x49>
  80248e:	b8 01 00 00 00       	mov    $0x1,%eax
  802493:	31 d2                	xor    %edx,%edx
  802495:	f7 f7                	div    %edi
  802497:	89 c5                	mov    %eax,%ebp
  802499:	89 d8                	mov    %ebx,%eax
  80249b:	31 d2                	xor    %edx,%edx
  80249d:	f7 f5                	div    %ebp
  80249f:	89 f0                	mov    %esi,%eax
  8024a1:	f7 f5                	div    %ebp
  8024a3:	89 d0                	mov    %edx,%eax
  8024a5:	eb d0                	jmp    802477 <__umoddi3+0x27>
  8024a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024ae:	66 90                	xchg   %ax,%ax
  8024b0:	89 f1                	mov    %esi,%ecx
  8024b2:	39 d8                	cmp    %ebx,%eax
  8024b4:	76 0a                	jbe    8024c0 <__umoddi3+0x70>
  8024b6:	89 f0                	mov    %esi,%eax
  8024b8:	83 c4 1c             	add    $0x1c,%esp
  8024bb:	5b                   	pop    %ebx
  8024bc:	5e                   	pop    %esi
  8024bd:	5f                   	pop    %edi
  8024be:	5d                   	pop    %ebp
  8024bf:	c3                   	ret    
  8024c0:	0f bd e8             	bsr    %eax,%ebp
  8024c3:	83 f5 1f             	xor    $0x1f,%ebp
  8024c6:	75 20                	jne    8024e8 <__umoddi3+0x98>
  8024c8:	39 d8                	cmp    %ebx,%eax
  8024ca:	0f 82 b0 00 00 00    	jb     802580 <__umoddi3+0x130>
  8024d0:	39 f7                	cmp    %esi,%edi
  8024d2:	0f 86 a8 00 00 00    	jbe    802580 <__umoddi3+0x130>
  8024d8:	89 c8                	mov    %ecx,%eax
  8024da:	83 c4 1c             	add    $0x1c,%esp
  8024dd:	5b                   	pop    %ebx
  8024de:	5e                   	pop    %esi
  8024df:	5f                   	pop    %edi
  8024e0:	5d                   	pop    %ebp
  8024e1:	c3                   	ret    
  8024e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024e8:	89 e9                	mov    %ebp,%ecx
  8024ea:	ba 20 00 00 00       	mov    $0x20,%edx
  8024ef:	29 ea                	sub    %ebp,%edx
  8024f1:	d3 e0                	shl    %cl,%eax
  8024f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024f7:	89 d1                	mov    %edx,%ecx
  8024f9:	89 f8                	mov    %edi,%eax
  8024fb:	d3 e8                	shr    %cl,%eax
  8024fd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802501:	89 54 24 04          	mov    %edx,0x4(%esp)
  802505:	8b 54 24 04          	mov    0x4(%esp),%edx
  802509:	09 c1                	or     %eax,%ecx
  80250b:	89 d8                	mov    %ebx,%eax
  80250d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802511:	89 e9                	mov    %ebp,%ecx
  802513:	d3 e7                	shl    %cl,%edi
  802515:	89 d1                	mov    %edx,%ecx
  802517:	d3 e8                	shr    %cl,%eax
  802519:	89 e9                	mov    %ebp,%ecx
  80251b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80251f:	d3 e3                	shl    %cl,%ebx
  802521:	89 c7                	mov    %eax,%edi
  802523:	89 d1                	mov    %edx,%ecx
  802525:	89 f0                	mov    %esi,%eax
  802527:	d3 e8                	shr    %cl,%eax
  802529:	89 e9                	mov    %ebp,%ecx
  80252b:	89 fa                	mov    %edi,%edx
  80252d:	d3 e6                	shl    %cl,%esi
  80252f:	09 d8                	or     %ebx,%eax
  802531:	f7 74 24 08          	divl   0x8(%esp)
  802535:	89 d1                	mov    %edx,%ecx
  802537:	89 f3                	mov    %esi,%ebx
  802539:	f7 64 24 0c          	mull   0xc(%esp)
  80253d:	89 c6                	mov    %eax,%esi
  80253f:	89 d7                	mov    %edx,%edi
  802541:	39 d1                	cmp    %edx,%ecx
  802543:	72 06                	jb     80254b <__umoddi3+0xfb>
  802545:	75 10                	jne    802557 <__umoddi3+0x107>
  802547:	39 c3                	cmp    %eax,%ebx
  802549:	73 0c                	jae    802557 <__umoddi3+0x107>
  80254b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80254f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802553:	89 d7                	mov    %edx,%edi
  802555:	89 c6                	mov    %eax,%esi
  802557:	89 ca                	mov    %ecx,%edx
  802559:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80255e:	29 f3                	sub    %esi,%ebx
  802560:	19 fa                	sbb    %edi,%edx
  802562:	89 d0                	mov    %edx,%eax
  802564:	d3 e0                	shl    %cl,%eax
  802566:	89 e9                	mov    %ebp,%ecx
  802568:	d3 eb                	shr    %cl,%ebx
  80256a:	d3 ea                	shr    %cl,%edx
  80256c:	09 d8                	or     %ebx,%eax
  80256e:	83 c4 1c             	add    $0x1c,%esp
  802571:	5b                   	pop    %ebx
  802572:	5e                   	pop    %esi
  802573:	5f                   	pop    %edi
  802574:	5d                   	pop    %ebp
  802575:	c3                   	ret    
  802576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80257d:	8d 76 00             	lea    0x0(%esi),%esi
  802580:	89 da                	mov    %ebx,%edx
  802582:	29 fe                	sub    %edi,%esi
  802584:	19 c2                	sbb    %eax,%edx
  802586:	89 f1                	mov    %esi,%ecx
  802588:	89 c8                	mov    %ecx,%eax
  80258a:	e9 4b ff ff ff       	jmp    8024da <__umoddi3+0x8a>
