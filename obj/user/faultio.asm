
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
  800039:	68 fc 25 80 00       	push   $0x8025fc
  80003e:	68 c0 25 80 00       	push   $0x8025c0
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
  800062:	68 df 25 80 00       	push   $0x8025df
  800067:	e8 b9 01 00 00       	call   800225 <cprintf>
}
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	c9                   	leave  
  800070:	c3                   	ret    
		cprintf("eflags wrong\n");
  800071:	83 ec 0c             	sub    $0xc,%esp
  800074:	68 d1 25 80 00       	push   $0x8025d1
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
  800106:	68 02 26 80 00       	push   $0x802602
  80010b:	e8 15 01 00 00       	call   800225 <cprintf>
	cprintf("before umain\n");
  800110:	c7 04 24 20 26 80 00 	movl   $0x802620,(%esp)
  800117:	e8 09 01 00 00       	call   800225 <cprintf>
	// call user main routine
	umain(argc, argv);
  80011c:	83 c4 08             	add    $0x8,%esp
  80011f:	ff 75 0c             	pushl  0xc(%ebp)
  800122:	ff 75 08             	pushl  0x8(%ebp)
  800125:	e8 09 ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  80012a:	c7 04 24 2e 26 80 00 	movl   $0x80262e,(%esp)
  800131:	e8 ef 00 00 00       	call   800225 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800136:	a1 08 40 80 00       	mov    0x804008,%eax
  80013b:	8b 40 48             	mov    0x48(%eax),%eax
  80013e:	83 c4 08             	add    $0x8,%esp
  800141:	50                   	push   %eax
  800142:	68 3b 26 80 00       	push   $0x80263b
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
  80016a:	68 68 26 80 00       	push   $0x802668
  80016f:	50                   	push   %eax
  800170:	68 5a 26 80 00       	push   $0x80265a
  800175:	e8 ab 00 00 00       	call   800225 <cprintf>
	close_all();
  80017a:	e8 c4 10 00 00       	call   801243 <close_all>
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
  8002d2:	e8 89 20 00 00       	call   802360 <__udivdi3>
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
  8002fb:	e8 70 21 00 00       	call   802470 <__umoddi3>
  800300:	83 c4 14             	add    $0x14,%esp
  800303:	0f be 80 6d 26 80 00 	movsbl 0x80266d(%eax),%eax
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
  8003ac:	ff 24 85 40 28 80 00 	jmp    *0x802840(,%eax,4)
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
  800477:	8b 14 85 a0 29 80 00 	mov    0x8029a0(,%eax,4),%edx
  80047e:	85 d2                	test   %edx,%edx
  800480:	74 18                	je     80049a <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800482:	52                   	push   %edx
  800483:	68 bd 2a 80 00       	push   $0x802abd
  800488:	53                   	push   %ebx
  800489:	56                   	push   %esi
  80048a:	e8 a6 fe ff ff       	call   800335 <printfmt>
  80048f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800492:	89 7d 14             	mov    %edi,0x14(%ebp)
  800495:	e9 fe 02 00 00       	jmp    800798 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80049a:	50                   	push   %eax
  80049b:	68 85 26 80 00       	push   $0x802685
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
  8004c2:	b8 7e 26 80 00       	mov    $0x80267e,%eax
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
  80085a:	bf a1 27 80 00       	mov    $0x8027a1,%edi
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
  800886:	bf d9 27 80 00       	mov    $0x8027d9,%edi
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
  800d27:	68 e8 29 80 00       	push   $0x8029e8
  800d2c:	6a 43                	push   $0x43
  800d2e:	68 05 2a 80 00       	push   $0x802a05
  800d33:	e8 89 14 00 00       	call   8021c1 <_panic>

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
  800da8:	68 e8 29 80 00       	push   $0x8029e8
  800dad:	6a 43                	push   $0x43
  800daf:	68 05 2a 80 00       	push   $0x802a05
  800db4:	e8 08 14 00 00       	call   8021c1 <_panic>

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
  800dea:	68 e8 29 80 00       	push   $0x8029e8
  800def:	6a 43                	push   $0x43
  800df1:	68 05 2a 80 00       	push   $0x802a05
  800df6:	e8 c6 13 00 00       	call   8021c1 <_panic>

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
  800e2c:	68 e8 29 80 00       	push   $0x8029e8
  800e31:	6a 43                	push   $0x43
  800e33:	68 05 2a 80 00       	push   $0x802a05
  800e38:	e8 84 13 00 00       	call   8021c1 <_panic>

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
  800e6e:	68 e8 29 80 00       	push   $0x8029e8
  800e73:	6a 43                	push   $0x43
  800e75:	68 05 2a 80 00       	push   $0x802a05
  800e7a:	e8 42 13 00 00       	call   8021c1 <_panic>

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
  800eb0:	68 e8 29 80 00       	push   $0x8029e8
  800eb5:	6a 43                	push   $0x43
  800eb7:	68 05 2a 80 00       	push   $0x802a05
  800ebc:	e8 00 13 00 00       	call   8021c1 <_panic>

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
  800ef2:	68 e8 29 80 00       	push   $0x8029e8
  800ef7:	6a 43                	push   $0x43
  800ef9:	68 05 2a 80 00       	push   $0x802a05
  800efe:	e8 be 12 00 00       	call   8021c1 <_panic>

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
  800f56:	68 e8 29 80 00       	push   $0x8029e8
  800f5b:	6a 43                	push   $0x43
  800f5d:	68 05 2a 80 00       	push   $0x802a05
  800f62:	e8 5a 12 00 00       	call   8021c1 <_panic>

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
  80103a:	68 e8 29 80 00       	push   $0x8029e8
  80103f:	6a 43                	push   $0x43
  801041:	68 05 2a 80 00       	push   $0x802a05
  801046:	e8 76 11 00 00       	call   8021c1 <_panic>

0080104b <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	57                   	push   %edi
  80104f:	56                   	push   %esi
  801050:	53                   	push   %ebx
	asm volatile("int %1\n"
  801051:	b9 00 00 00 00       	mov    $0x0,%ecx
  801056:	8b 55 08             	mov    0x8(%ebp),%edx
  801059:	b8 14 00 00 00       	mov    $0x14,%eax
  80105e:	89 cb                	mov    %ecx,%ebx
  801060:	89 cf                	mov    %ecx,%edi
  801062:	89 ce                	mov    %ecx,%esi
  801064:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801066:	5b                   	pop    %ebx
  801067:	5e                   	pop    %esi
  801068:	5f                   	pop    %edi
  801069:	5d                   	pop    %ebp
  80106a:	c3                   	ret    

0080106b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	05 00 00 00 30       	add    $0x30000000,%eax
  801076:	c1 e8 0c             	shr    $0xc,%eax
}
  801079:	5d                   	pop    %ebp
  80107a:	c3                   	ret    

0080107b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80107b:	55                   	push   %ebp
  80107c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801086:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80108b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801090:	5d                   	pop    %ebp
  801091:	c3                   	ret    

00801092 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80109a:	89 c2                	mov    %eax,%edx
  80109c:	c1 ea 16             	shr    $0x16,%edx
  80109f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010a6:	f6 c2 01             	test   $0x1,%dl
  8010a9:	74 2d                	je     8010d8 <fd_alloc+0x46>
  8010ab:	89 c2                	mov    %eax,%edx
  8010ad:	c1 ea 0c             	shr    $0xc,%edx
  8010b0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010b7:	f6 c2 01             	test   $0x1,%dl
  8010ba:	74 1c                	je     8010d8 <fd_alloc+0x46>
  8010bc:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010c1:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010c6:	75 d2                	jne    80109a <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8010d1:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010d6:	eb 0a                	jmp    8010e2 <fd_alloc+0x50>
			*fd_store = fd;
  8010d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010db:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010e2:	5d                   	pop    %ebp
  8010e3:	c3                   	ret    

008010e4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010e4:	55                   	push   %ebp
  8010e5:	89 e5                	mov    %esp,%ebp
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010ea:	83 f8 1f             	cmp    $0x1f,%eax
  8010ed:	77 30                	ja     80111f <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010ef:	c1 e0 0c             	shl    $0xc,%eax
  8010f2:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010f7:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010fd:	f6 c2 01             	test   $0x1,%dl
  801100:	74 24                	je     801126 <fd_lookup+0x42>
  801102:	89 c2                	mov    %eax,%edx
  801104:	c1 ea 0c             	shr    $0xc,%edx
  801107:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80110e:	f6 c2 01             	test   $0x1,%dl
  801111:	74 1a                	je     80112d <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801113:	8b 55 0c             	mov    0xc(%ebp),%edx
  801116:	89 02                	mov    %eax,(%edx)
	return 0;
  801118:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80111d:	5d                   	pop    %ebp
  80111e:	c3                   	ret    
		return -E_INVAL;
  80111f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801124:	eb f7                	jmp    80111d <fd_lookup+0x39>
		return -E_INVAL;
  801126:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80112b:	eb f0                	jmp    80111d <fd_lookup+0x39>
  80112d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801132:	eb e9                	jmp    80111d <fd_lookup+0x39>

00801134 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801134:	55                   	push   %ebp
  801135:	89 e5                	mov    %esp,%ebp
  801137:	83 ec 08             	sub    $0x8,%esp
  80113a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80113d:	ba 00 00 00 00       	mov    $0x0,%edx
  801142:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801147:	39 08                	cmp    %ecx,(%eax)
  801149:	74 38                	je     801183 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80114b:	83 c2 01             	add    $0x1,%edx
  80114e:	8b 04 95 90 2a 80 00 	mov    0x802a90(,%edx,4),%eax
  801155:	85 c0                	test   %eax,%eax
  801157:	75 ee                	jne    801147 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801159:	a1 08 40 80 00       	mov    0x804008,%eax
  80115e:	8b 40 48             	mov    0x48(%eax),%eax
  801161:	83 ec 04             	sub    $0x4,%esp
  801164:	51                   	push   %ecx
  801165:	50                   	push   %eax
  801166:	68 14 2a 80 00       	push   $0x802a14
  80116b:	e8 b5 f0 ff ff       	call   800225 <cprintf>
	*dev = 0;
  801170:	8b 45 0c             	mov    0xc(%ebp),%eax
  801173:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801179:	83 c4 10             	add    $0x10,%esp
  80117c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801181:	c9                   	leave  
  801182:	c3                   	ret    
			*dev = devtab[i];
  801183:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801186:	89 01                	mov    %eax,(%ecx)
			return 0;
  801188:	b8 00 00 00 00       	mov    $0x0,%eax
  80118d:	eb f2                	jmp    801181 <dev_lookup+0x4d>

0080118f <fd_close>:
{
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
  801192:	57                   	push   %edi
  801193:	56                   	push   %esi
  801194:	53                   	push   %ebx
  801195:	83 ec 24             	sub    $0x24,%esp
  801198:	8b 75 08             	mov    0x8(%ebp),%esi
  80119b:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80119e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011a1:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011a2:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011a8:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011ab:	50                   	push   %eax
  8011ac:	e8 33 ff ff ff       	call   8010e4 <fd_lookup>
  8011b1:	89 c3                	mov    %eax,%ebx
  8011b3:	83 c4 10             	add    $0x10,%esp
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	78 05                	js     8011bf <fd_close+0x30>
	    || fd != fd2)
  8011ba:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011bd:	74 16                	je     8011d5 <fd_close+0x46>
		return (must_exist ? r : 0);
  8011bf:	89 f8                	mov    %edi,%eax
  8011c1:	84 c0                	test   %al,%al
  8011c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c8:	0f 44 d8             	cmove  %eax,%ebx
}
  8011cb:	89 d8                	mov    %ebx,%eax
  8011cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d0:	5b                   	pop    %ebx
  8011d1:	5e                   	pop    %esi
  8011d2:	5f                   	pop    %edi
  8011d3:	5d                   	pop    %ebp
  8011d4:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011d5:	83 ec 08             	sub    $0x8,%esp
  8011d8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011db:	50                   	push   %eax
  8011dc:	ff 36                	pushl  (%esi)
  8011de:	e8 51 ff ff ff       	call   801134 <dev_lookup>
  8011e3:	89 c3                	mov    %eax,%ebx
  8011e5:	83 c4 10             	add    $0x10,%esp
  8011e8:	85 c0                	test   %eax,%eax
  8011ea:	78 1a                	js     801206 <fd_close+0x77>
		if (dev->dev_close)
  8011ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011ef:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011f2:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011f7:	85 c0                	test   %eax,%eax
  8011f9:	74 0b                	je     801206 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011fb:	83 ec 0c             	sub    $0xc,%esp
  8011fe:	56                   	push   %esi
  8011ff:	ff d0                	call   *%eax
  801201:	89 c3                	mov    %eax,%ebx
  801203:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801206:	83 ec 08             	sub    $0x8,%esp
  801209:	56                   	push   %esi
  80120a:	6a 00                	push   $0x0
  80120c:	e8 ea fb ff ff       	call   800dfb <sys_page_unmap>
	return r;
  801211:	83 c4 10             	add    $0x10,%esp
  801214:	eb b5                	jmp    8011cb <fd_close+0x3c>

00801216 <close>:

int
close(int fdnum)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80121c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80121f:	50                   	push   %eax
  801220:	ff 75 08             	pushl  0x8(%ebp)
  801223:	e8 bc fe ff ff       	call   8010e4 <fd_lookup>
  801228:	83 c4 10             	add    $0x10,%esp
  80122b:	85 c0                	test   %eax,%eax
  80122d:	79 02                	jns    801231 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80122f:	c9                   	leave  
  801230:	c3                   	ret    
		return fd_close(fd, 1);
  801231:	83 ec 08             	sub    $0x8,%esp
  801234:	6a 01                	push   $0x1
  801236:	ff 75 f4             	pushl  -0xc(%ebp)
  801239:	e8 51 ff ff ff       	call   80118f <fd_close>
  80123e:	83 c4 10             	add    $0x10,%esp
  801241:	eb ec                	jmp    80122f <close+0x19>

00801243 <close_all>:

void
close_all(void)
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	53                   	push   %ebx
  801247:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80124a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80124f:	83 ec 0c             	sub    $0xc,%esp
  801252:	53                   	push   %ebx
  801253:	e8 be ff ff ff       	call   801216 <close>
	for (i = 0; i < MAXFD; i++)
  801258:	83 c3 01             	add    $0x1,%ebx
  80125b:	83 c4 10             	add    $0x10,%esp
  80125e:	83 fb 20             	cmp    $0x20,%ebx
  801261:	75 ec                	jne    80124f <close_all+0xc>
}
  801263:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801266:	c9                   	leave  
  801267:	c3                   	ret    

00801268 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801268:	55                   	push   %ebp
  801269:	89 e5                	mov    %esp,%ebp
  80126b:	57                   	push   %edi
  80126c:	56                   	push   %esi
  80126d:	53                   	push   %ebx
  80126e:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801271:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801274:	50                   	push   %eax
  801275:	ff 75 08             	pushl  0x8(%ebp)
  801278:	e8 67 fe ff ff       	call   8010e4 <fd_lookup>
  80127d:	89 c3                	mov    %eax,%ebx
  80127f:	83 c4 10             	add    $0x10,%esp
  801282:	85 c0                	test   %eax,%eax
  801284:	0f 88 81 00 00 00    	js     80130b <dup+0xa3>
		return r;
	close(newfdnum);
  80128a:	83 ec 0c             	sub    $0xc,%esp
  80128d:	ff 75 0c             	pushl  0xc(%ebp)
  801290:	e8 81 ff ff ff       	call   801216 <close>

	newfd = INDEX2FD(newfdnum);
  801295:	8b 75 0c             	mov    0xc(%ebp),%esi
  801298:	c1 e6 0c             	shl    $0xc,%esi
  80129b:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012a1:	83 c4 04             	add    $0x4,%esp
  8012a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012a7:	e8 cf fd ff ff       	call   80107b <fd2data>
  8012ac:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012ae:	89 34 24             	mov    %esi,(%esp)
  8012b1:	e8 c5 fd ff ff       	call   80107b <fd2data>
  8012b6:	83 c4 10             	add    $0x10,%esp
  8012b9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012bb:	89 d8                	mov    %ebx,%eax
  8012bd:	c1 e8 16             	shr    $0x16,%eax
  8012c0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012c7:	a8 01                	test   $0x1,%al
  8012c9:	74 11                	je     8012dc <dup+0x74>
  8012cb:	89 d8                	mov    %ebx,%eax
  8012cd:	c1 e8 0c             	shr    $0xc,%eax
  8012d0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012d7:	f6 c2 01             	test   $0x1,%dl
  8012da:	75 39                	jne    801315 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012df:	89 d0                	mov    %edx,%eax
  8012e1:	c1 e8 0c             	shr    $0xc,%eax
  8012e4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012eb:	83 ec 0c             	sub    $0xc,%esp
  8012ee:	25 07 0e 00 00       	and    $0xe07,%eax
  8012f3:	50                   	push   %eax
  8012f4:	56                   	push   %esi
  8012f5:	6a 00                	push   $0x0
  8012f7:	52                   	push   %edx
  8012f8:	6a 00                	push   $0x0
  8012fa:	e8 ba fa ff ff       	call   800db9 <sys_page_map>
  8012ff:	89 c3                	mov    %eax,%ebx
  801301:	83 c4 20             	add    $0x20,%esp
  801304:	85 c0                	test   %eax,%eax
  801306:	78 31                	js     801339 <dup+0xd1>
		goto err;

	return newfdnum;
  801308:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80130b:	89 d8                	mov    %ebx,%eax
  80130d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801310:	5b                   	pop    %ebx
  801311:	5e                   	pop    %esi
  801312:	5f                   	pop    %edi
  801313:	5d                   	pop    %ebp
  801314:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801315:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80131c:	83 ec 0c             	sub    $0xc,%esp
  80131f:	25 07 0e 00 00       	and    $0xe07,%eax
  801324:	50                   	push   %eax
  801325:	57                   	push   %edi
  801326:	6a 00                	push   $0x0
  801328:	53                   	push   %ebx
  801329:	6a 00                	push   $0x0
  80132b:	e8 89 fa ff ff       	call   800db9 <sys_page_map>
  801330:	89 c3                	mov    %eax,%ebx
  801332:	83 c4 20             	add    $0x20,%esp
  801335:	85 c0                	test   %eax,%eax
  801337:	79 a3                	jns    8012dc <dup+0x74>
	sys_page_unmap(0, newfd);
  801339:	83 ec 08             	sub    $0x8,%esp
  80133c:	56                   	push   %esi
  80133d:	6a 00                	push   $0x0
  80133f:	e8 b7 fa ff ff       	call   800dfb <sys_page_unmap>
	sys_page_unmap(0, nva);
  801344:	83 c4 08             	add    $0x8,%esp
  801347:	57                   	push   %edi
  801348:	6a 00                	push   $0x0
  80134a:	e8 ac fa ff ff       	call   800dfb <sys_page_unmap>
	return r;
  80134f:	83 c4 10             	add    $0x10,%esp
  801352:	eb b7                	jmp    80130b <dup+0xa3>

00801354 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	53                   	push   %ebx
  801358:	83 ec 1c             	sub    $0x1c,%esp
  80135b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80135e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801361:	50                   	push   %eax
  801362:	53                   	push   %ebx
  801363:	e8 7c fd ff ff       	call   8010e4 <fd_lookup>
  801368:	83 c4 10             	add    $0x10,%esp
  80136b:	85 c0                	test   %eax,%eax
  80136d:	78 3f                	js     8013ae <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80136f:	83 ec 08             	sub    $0x8,%esp
  801372:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801375:	50                   	push   %eax
  801376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801379:	ff 30                	pushl  (%eax)
  80137b:	e8 b4 fd ff ff       	call   801134 <dev_lookup>
  801380:	83 c4 10             	add    $0x10,%esp
  801383:	85 c0                	test   %eax,%eax
  801385:	78 27                	js     8013ae <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801387:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80138a:	8b 42 08             	mov    0x8(%edx),%eax
  80138d:	83 e0 03             	and    $0x3,%eax
  801390:	83 f8 01             	cmp    $0x1,%eax
  801393:	74 1e                	je     8013b3 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801398:	8b 40 08             	mov    0x8(%eax),%eax
  80139b:	85 c0                	test   %eax,%eax
  80139d:	74 35                	je     8013d4 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80139f:	83 ec 04             	sub    $0x4,%esp
  8013a2:	ff 75 10             	pushl  0x10(%ebp)
  8013a5:	ff 75 0c             	pushl  0xc(%ebp)
  8013a8:	52                   	push   %edx
  8013a9:	ff d0                	call   *%eax
  8013ab:	83 c4 10             	add    $0x10,%esp
}
  8013ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013b1:	c9                   	leave  
  8013b2:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013b3:	a1 08 40 80 00       	mov    0x804008,%eax
  8013b8:	8b 40 48             	mov    0x48(%eax),%eax
  8013bb:	83 ec 04             	sub    $0x4,%esp
  8013be:	53                   	push   %ebx
  8013bf:	50                   	push   %eax
  8013c0:	68 55 2a 80 00       	push   $0x802a55
  8013c5:	e8 5b ee ff ff       	call   800225 <cprintf>
		return -E_INVAL;
  8013ca:	83 c4 10             	add    $0x10,%esp
  8013cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013d2:	eb da                	jmp    8013ae <read+0x5a>
		return -E_NOT_SUPP;
  8013d4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013d9:	eb d3                	jmp    8013ae <read+0x5a>

008013db <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
  8013de:	57                   	push   %edi
  8013df:	56                   	push   %esi
  8013e0:	53                   	push   %ebx
  8013e1:	83 ec 0c             	sub    $0xc,%esp
  8013e4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013e7:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013ea:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013ef:	39 f3                	cmp    %esi,%ebx
  8013f1:	73 23                	jae    801416 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013f3:	83 ec 04             	sub    $0x4,%esp
  8013f6:	89 f0                	mov    %esi,%eax
  8013f8:	29 d8                	sub    %ebx,%eax
  8013fa:	50                   	push   %eax
  8013fb:	89 d8                	mov    %ebx,%eax
  8013fd:	03 45 0c             	add    0xc(%ebp),%eax
  801400:	50                   	push   %eax
  801401:	57                   	push   %edi
  801402:	e8 4d ff ff ff       	call   801354 <read>
		if (m < 0)
  801407:	83 c4 10             	add    $0x10,%esp
  80140a:	85 c0                	test   %eax,%eax
  80140c:	78 06                	js     801414 <readn+0x39>
			return m;
		if (m == 0)
  80140e:	74 06                	je     801416 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801410:	01 c3                	add    %eax,%ebx
  801412:	eb db                	jmp    8013ef <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801414:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801416:	89 d8                	mov    %ebx,%eax
  801418:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80141b:	5b                   	pop    %ebx
  80141c:	5e                   	pop    %esi
  80141d:	5f                   	pop    %edi
  80141e:	5d                   	pop    %ebp
  80141f:	c3                   	ret    

00801420 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
  801423:	53                   	push   %ebx
  801424:	83 ec 1c             	sub    $0x1c,%esp
  801427:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80142a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80142d:	50                   	push   %eax
  80142e:	53                   	push   %ebx
  80142f:	e8 b0 fc ff ff       	call   8010e4 <fd_lookup>
  801434:	83 c4 10             	add    $0x10,%esp
  801437:	85 c0                	test   %eax,%eax
  801439:	78 3a                	js     801475 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80143b:	83 ec 08             	sub    $0x8,%esp
  80143e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801441:	50                   	push   %eax
  801442:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801445:	ff 30                	pushl  (%eax)
  801447:	e8 e8 fc ff ff       	call   801134 <dev_lookup>
  80144c:	83 c4 10             	add    $0x10,%esp
  80144f:	85 c0                	test   %eax,%eax
  801451:	78 22                	js     801475 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801453:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801456:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80145a:	74 1e                	je     80147a <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80145c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80145f:	8b 52 0c             	mov    0xc(%edx),%edx
  801462:	85 d2                	test   %edx,%edx
  801464:	74 35                	je     80149b <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801466:	83 ec 04             	sub    $0x4,%esp
  801469:	ff 75 10             	pushl  0x10(%ebp)
  80146c:	ff 75 0c             	pushl  0xc(%ebp)
  80146f:	50                   	push   %eax
  801470:	ff d2                	call   *%edx
  801472:	83 c4 10             	add    $0x10,%esp
}
  801475:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801478:	c9                   	leave  
  801479:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80147a:	a1 08 40 80 00       	mov    0x804008,%eax
  80147f:	8b 40 48             	mov    0x48(%eax),%eax
  801482:	83 ec 04             	sub    $0x4,%esp
  801485:	53                   	push   %ebx
  801486:	50                   	push   %eax
  801487:	68 71 2a 80 00       	push   $0x802a71
  80148c:	e8 94 ed ff ff       	call   800225 <cprintf>
		return -E_INVAL;
  801491:	83 c4 10             	add    $0x10,%esp
  801494:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801499:	eb da                	jmp    801475 <write+0x55>
		return -E_NOT_SUPP;
  80149b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014a0:	eb d3                	jmp    801475 <write+0x55>

008014a2 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
  8014a5:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ab:	50                   	push   %eax
  8014ac:	ff 75 08             	pushl  0x8(%ebp)
  8014af:	e8 30 fc ff ff       	call   8010e4 <fd_lookup>
  8014b4:	83 c4 10             	add    $0x10,%esp
  8014b7:	85 c0                	test   %eax,%eax
  8014b9:	78 0e                	js     8014c9 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c1:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014c9:	c9                   	leave  
  8014ca:	c3                   	ret    

008014cb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
  8014ce:	53                   	push   %ebx
  8014cf:	83 ec 1c             	sub    $0x1c,%esp
  8014d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014d5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014d8:	50                   	push   %eax
  8014d9:	53                   	push   %ebx
  8014da:	e8 05 fc ff ff       	call   8010e4 <fd_lookup>
  8014df:	83 c4 10             	add    $0x10,%esp
  8014e2:	85 c0                	test   %eax,%eax
  8014e4:	78 37                	js     80151d <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014e6:	83 ec 08             	sub    $0x8,%esp
  8014e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ec:	50                   	push   %eax
  8014ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f0:	ff 30                	pushl  (%eax)
  8014f2:	e8 3d fc ff ff       	call   801134 <dev_lookup>
  8014f7:	83 c4 10             	add    $0x10,%esp
  8014fa:	85 c0                	test   %eax,%eax
  8014fc:	78 1f                	js     80151d <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801501:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801505:	74 1b                	je     801522 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801507:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150a:	8b 52 18             	mov    0x18(%edx),%edx
  80150d:	85 d2                	test   %edx,%edx
  80150f:	74 32                	je     801543 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801511:	83 ec 08             	sub    $0x8,%esp
  801514:	ff 75 0c             	pushl  0xc(%ebp)
  801517:	50                   	push   %eax
  801518:	ff d2                	call   *%edx
  80151a:	83 c4 10             	add    $0x10,%esp
}
  80151d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801520:	c9                   	leave  
  801521:	c3                   	ret    
			thisenv->env_id, fdnum);
  801522:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801527:	8b 40 48             	mov    0x48(%eax),%eax
  80152a:	83 ec 04             	sub    $0x4,%esp
  80152d:	53                   	push   %ebx
  80152e:	50                   	push   %eax
  80152f:	68 34 2a 80 00       	push   $0x802a34
  801534:	e8 ec ec ff ff       	call   800225 <cprintf>
		return -E_INVAL;
  801539:	83 c4 10             	add    $0x10,%esp
  80153c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801541:	eb da                	jmp    80151d <ftruncate+0x52>
		return -E_NOT_SUPP;
  801543:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801548:	eb d3                	jmp    80151d <ftruncate+0x52>

0080154a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80154a:	55                   	push   %ebp
  80154b:	89 e5                	mov    %esp,%ebp
  80154d:	53                   	push   %ebx
  80154e:	83 ec 1c             	sub    $0x1c,%esp
  801551:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801554:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801557:	50                   	push   %eax
  801558:	ff 75 08             	pushl  0x8(%ebp)
  80155b:	e8 84 fb ff ff       	call   8010e4 <fd_lookup>
  801560:	83 c4 10             	add    $0x10,%esp
  801563:	85 c0                	test   %eax,%eax
  801565:	78 4b                	js     8015b2 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801567:	83 ec 08             	sub    $0x8,%esp
  80156a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80156d:	50                   	push   %eax
  80156e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801571:	ff 30                	pushl  (%eax)
  801573:	e8 bc fb ff ff       	call   801134 <dev_lookup>
  801578:	83 c4 10             	add    $0x10,%esp
  80157b:	85 c0                	test   %eax,%eax
  80157d:	78 33                	js     8015b2 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80157f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801582:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801586:	74 2f                	je     8015b7 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801588:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80158b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801592:	00 00 00 
	stat->st_isdir = 0;
  801595:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80159c:	00 00 00 
	stat->st_dev = dev;
  80159f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015a5:	83 ec 08             	sub    $0x8,%esp
  8015a8:	53                   	push   %ebx
  8015a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8015ac:	ff 50 14             	call   *0x14(%eax)
  8015af:	83 c4 10             	add    $0x10,%esp
}
  8015b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015b5:	c9                   	leave  
  8015b6:	c3                   	ret    
		return -E_NOT_SUPP;
  8015b7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015bc:	eb f4                	jmp    8015b2 <fstat+0x68>

008015be <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
  8015c1:	56                   	push   %esi
  8015c2:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015c3:	83 ec 08             	sub    $0x8,%esp
  8015c6:	6a 00                	push   $0x0
  8015c8:	ff 75 08             	pushl  0x8(%ebp)
  8015cb:	e8 22 02 00 00       	call   8017f2 <open>
  8015d0:	89 c3                	mov    %eax,%ebx
  8015d2:	83 c4 10             	add    $0x10,%esp
  8015d5:	85 c0                	test   %eax,%eax
  8015d7:	78 1b                	js     8015f4 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015d9:	83 ec 08             	sub    $0x8,%esp
  8015dc:	ff 75 0c             	pushl  0xc(%ebp)
  8015df:	50                   	push   %eax
  8015e0:	e8 65 ff ff ff       	call   80154a <fstat>
  8015e5:	89 c6                	mov    %eax,%esi
	close(fd);
  8015e7:	89 1c 24             	mov    %ebx,(%esp)
  8015ea:	e8 27 fc ff ff       	call   801216 <close>
	return r;
  8015ef:	83 c4 10             	add    $0x10,%esp
  8015f2:	89 f3                	mov    %esi,%ebx
}
  8015f4:	89 d8                	mov    %ebx,%eax
  8015f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015f9:	5b                   	pop    %ebx
  8015fa:	5e                   	pop    %esi
  8015fb:	5d                   	pop    %ebp
  8015fc:	c3                   	ret    

008015fd <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
  801600:	56                   	push   %esi
  801601:	53                   	push   %ebx
  801602:	89 c6                	mov    %eax,%esi
  801604:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801606:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80160d:	74 27                	je     801636 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80160f:	6a 07                	push   $0x7
  801611:	68 00 50 80 00       	push   $0x805000
  801616:	56                   	push   %esi
  801617:	ff 35 00 40 80 00    	pushl  0x804000
  80161d:	e8 69 0c 00 00       	call   80228b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801622:	83 c4 0c             	add    $0xc,%esp
  801625:	6a 00                	push   $0x0
  801627:	53                   	push   %ebx
  801628:	6a 00                	push   $0x0
  80162a:	e8 f3 0b 00 00       	call   802222 <ipc_recv>
}
  80162f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801632:	5b                   	pop    %ebx
  801633:	5e                   	pop    %esi
  801634:	5d                   	pop    %ebp
  801635:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801636:	83 ec 0c             	sub    $0xc,%esp
  801639:	6a 01                	push   $0x1
  80163b:	e8 a3 0c 00 00       	call   8022e3 <ipc_find_env>
  801640:	a3 00 40 80 00       	mov    %eax,0x804000
  801645:	83 c4 10             	add    $0x10,%esp
  801648:	eb c5                	jmp    80160f <fsipc+0x12>

0080164a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
  80164d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	8b 40 0c             	mov    0xc(%eax),%eax
  801656:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80165b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165e:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801663:	ba 00 00 00 00       	mov    $0x0,%edx
  801668:	b8 02 00 00 00       	mov    $0x2,%eax
  80166d:	e8 8b ff ff ff       	call   8015fd <fsipc>
}
  801672:	c9                   	leave  
  801673:	c3                   	ret    

00801674 <devfile_flush>:
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
  801677:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	8b 40 0c             	mov    0xc(%eax),%eax
  801680:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801685:	ba 00 00 00 00       	mov    $0x0,%edx
  80168a:	b8 06 00 00 00       	mov    $0x6,%eax
  80168f:	e8 69 ff ff ff       	call   8015fd <fsipc>
}
  801694:	c9                   	leave  
  801695:	c3                   	ret    

00801696 <devfile_stat>:
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
  801699:	53                   	push   %ebx
  80169a:	83 ec 04             	sub    $0x4,%esp
  80169d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8016a6:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b0:	b8 05 00 00 00       	mov    $0x5,%eax
  8016b5:	e8 43 ff ff ff       	call   8015fd <fsipc>
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	78 2c                	js     8016ea <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016be:	83 ec 08             	sub    $0x8,%esp
  8016c1:	68 00 50 80 00       	push   $0x805000
  8016c6:	53                   	push   %ebx
  8016c7:	e8 b8 f2 ff ff       	call   800984 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016cc:	a1 80 50 80 00       	mov    0x805080,%eax
  8016d1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016d7:	a1 84 50 80 00       	mov    0x805084,%eax
  8016dc:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016e2:	83 c4 10             	add    $0x10,%esp
  8016e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ed:	c9                   	leave  
  8016ee:	c3                   	ret    

008016ef <devfile_write>:
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
  8016f2:	53                   	push   %ebx
  8016f3:	83 ec 08             	sub    $0x8,%esp
  8016f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ff:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801704:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80170a:	53                   	push   %ebx
  80170b:	ff 75 0c             	pushl  0xc(%ebp)
  80170e:	68 08 50 80 00       	push   $0x805008
  801713:	e8 5c f4 ff ff       	call   800b74 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801718:	ba 00 00 00 00       	mov    $0x0,%edx
  80171d:	b8 04 00 00 00       	mov    $0x4,%eax
  801722:	e8 d6 fe ff ff       	call   8015fd <fsipc>
  801727:	83 c4 10             	add    $0x10,%esp
  80172a:	85 c0                	test   %eax,%eax
  80172c:	78 0b                	js     801739 <devfile_write+0x4a>
	assert(r <= n);
  80172e:	39 d8                	cmp    %ebx,%eax
  801730:	77 0c                	ja     80173e <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801732:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801737:	7f 1e                	jg     801757 <devfile_write+0x68>
}
  801739:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    
	assert(r <= n);
  80173e:	68 a4 2a 80 00       	push   $0x802aa4
  801743:	68 ab 2a 80 00       	push   $0x802aab
  801748:	68 98 00 00 00       	push   $0x98
  80174d:	68 c0 2a 80 00       	push   $0x802ac0
  801752:	e8 6a 0a 00 00       	call   8021c1 <_panic>
	assert(r <= PGSIZE);
  801757:	68 cb 2a 80 00       	push   $0x802acb
  80175c:	68 ab 2a 80 00       	push   $0x802aab
  801761:	68 99 00 00 00       	push   $0x99
  801766:	68 c0 2a 80 00       	push   $0x802ac0
  80176b:	e8 51 0a 00 00       	call   8021c1 <_panic>

00801770 <devfile_read>:
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
  801773:	56                   	push   %esi
  801774:	53                   	push   %ebx
  801775:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	8b 40 0c             	mov    0xc(%eax),%eax
  80177e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801783:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801789:	ba 00 00 00 00       	mov    $0x0,%edx
  80178e:	b8 03 00 00 00       	mov    $0x3,%eax
  801793:	e8 65 fe ff ff       	call   8015fd <fsipc>
  801798:	89 c3                	mov    %eax,%ebx
  80179a:	85 c0                	test   %eax,%eax
  80179c:	78 1f                	js     8017bd <devfile_read+0x4d>
	assert(r <= n);
  80179e:	39 f0                	cmp    %esi,%eax
  8017a0:	77 24                	ja     8017c6 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017a2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017a7:	7f 33                	jg     8017dc <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017a9:	83 ec 04             	sub    $0x4,%esp
  8017ac:	50                   	push   %eax
  8017ad:	68 00 50 80 00       	push   $0x805000
  8017b2:	ff 75 0c             	pushl  0xc(%ebp)
  8017b5:	e8 58 f3 ff ff       	call   800b12 <memmove>
	return r;
  8017ba:	83 c4 10             	add    $0x10,%esp
}
  8017bd:	89 d8                	mov    %ebx,%eax
  8017bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017c2:	5b                   	pop    %ebx
  8017c3:	5e                   	pop    %esi
  8017c4:	5d                   	pop    %ebp
  8017c5:	c3                   	ret    
	assert(r <= n);
  8017c6:	68 a4 2a 80 00       	push   $0x802aa4
  8017cb:	68 ab 2a 80 00       	push   $0x802aab
  8017d0:	6a 7c                	push   $0x7c
  8017d2:	68 c0 2a 80 00       	push   $0x802ac0
  8017d7:	e8 e5 09 00 00       	call   8021c1 <_panic>
	assert(r <= PGSIZE);
  8017dc:	68 cb 2a 80 00       	push   $0x802acb
  8017e1:	68 ab 2a 80 00       	push   $0x802aab
  8017e6:	6a 7d                	push   $0x7d
  8017e8:	68 c0 2a 80 00       	push   $0x802ac0
  8017ed:	e8 cf 09 00 00       	call   8021c1 <_panic>

008017f2 <open>:
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
  8017f5:	56                   	push   %esi
  8017f6:	53                   	push   %ebx
  8017f7:	83 ec 1c             	sub    $0x1c,%esp
  8017fa:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017fd:	56                   	push   %esi
  8017fe:	e8 48 f1 ff ff       	call   80094b <strlen>
  801803:	83 c4 10             	add    $0x10,%esp
  801806:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80180b:	7f 6c                	jg     801879 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80180d:	83 ec 0c             	sub    $0xc,%esp
  801810:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801813:	50                   	push   %eax
  801814:	e8 79 f8 ff ff       	call   801092 <fd_alloc>
  801819:	89 c3                	mov    %eax,%ebx
  80181b:	83 c4 10             	add    $0x10,%esp
  80181e:	85 c0                	test   %eax,%eax
  801820:	78 3c                	js     80185e <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801822:	83 ec 08             	sub    $0x8,%esp
  801825:	56                   	push   %esi
  801826:	68 00 50 80 00       	push   $0x805000
  80182b:	e8 54 f1 ff ff       	call   800984 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801830:	8b 45 0c             	mov    0xc(%ebp),%eax
  801833:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801838:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80183b:	b8 01 00 00 00       	mov    $0x1,%eax
  801840:	e8 b8 fd ff ff       	call   8015fd <fsipc>
  801845:	89 c3                	mov    %eax,%ebx
  801847:	83 c4 10             	add    $0x10,%esp
  80184a:	85 c0                	test   %eax,%eax
  80184c:	78 19                	js     801867 <open+0x75>
	return fd2num(fd);
  80184e:	83 ec 0c             	sub    $0xc,%esp
  801851:	ff 75 f4             	pushl  -0xc(%ebp)
  801854:	e8 12 f8 ff ff       	call   80106b <fd2num>
  801859:	89 c3                	mov    %eax,%ebx
  80185b:	83 c4 10             	add    $0x10,%esp
}
  80185e:	89 d8                	mov    %ebx,%eax
  801860:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801863:	5b                   	pop    %ebx
  801864:	5e                   	pop    %esi
  801865:	5d                   	pop    %ebp
  801866:	c3                   	ret    
		fd_close(fd, 0);
  801867:	83 ec 08             	sub    $0x8,%esp
  80186a:	6a 00                	push   $0x0
  80186c:	ff 75 f4             	pushl  -0xc(%ebp)
  80186f:	e8 1b f9 ff ff       	call   80118f <fd_close>
		return r;
  801874:	83 c4 10             	add    $0x10,%esp
  801877:	eb e5                	jmp    80185e <open+0x6c>
		return -E_BAD_PATH;
  801879:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80187e:	eb de                	jmp    80185e <open+0x6c>

00801880 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801886:	ba 00 00 00 00       	mov    $0x0,%edx
  80188b:	b8 08 00 00 00       	mov    $0x8,%eax
  801890:	e8 68 fd ff ff       	call   8015fd <fsipc>
}
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
  80189a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80189d:	68 d7 2a 80 00       	push   $0x802ad7
  8018a2:	ff 75 0c             	pushl  0xc(%ebp)
  8018a5:	e8 da f0 ff ff       	call   800984 <strcpy>
	return 0;
}
  8018aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <devsock_close>:
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
  8018b4:	53                   	push   %ebx
  8018b5:	83 ec 10             	sub    $0x10,%esp
  8018b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018bb:	53                   	push   %ebx
  8018bc:	e8 5d 0a 00 00       	call   80231e <pageref>
  8018c1:	83 c4 10             	add    $0x10,%esp
		return 0;
  8018c4:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8018c9:	83 f8 01             	cmp    $0x1,%eax
  8018cc:	74 07                	je     8018d5 <devsock_close+0x24>
}
  8018ce:	89 d0                	mov    %edx,%eax
  8018d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8018d5:	83 ec 0c             	sub    $0xc,%esp
  8018d8:	ff 73 0c             	pushl  0xc(%ebx)
  8018db:	e8 b9 02 00 00       	call   801b99 <nsipc_close>
  8018e0:	89 c2                	mov    %eax,%edx
  8018e2:	83 c4 10             	add    $0x10,%esp
  8018e5:	eb e7                	jmp    8018ce <devsock_close+0x1d>

008018e7 <devsock_write>:
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
  8018ea:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018ed:	6a 00                	push   $0x0
  8018ef:	ff 75 10             	pushl  0x10(%ebp)
  8018f2:	ff 75 0c             	pushl  0xc(%ebp)
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	ff 70 0c             	pushl  0xc(%eax)
  8018fb:	e8 76 03 00 00       	call   801c76 <nsipc_send>
}
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <devsock_read>:
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801908:	6a 00                	push   $0x0
  80190a:	ff 75 10             	pushl  0x10(%ebp)
  80190d:	ff 75 0c             	pushl  0xc(%ebp)
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	ff 70 0c             	pushl  0xc(%eax)
  801916:	e8 ef 02 00 00       	call   801c0a <nsipc_recv>
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <fd2sockid>:
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801923:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801926:	52                   	push   %edx
  801927:	50                   	push   %eax
  801928:	e8 b7 f7 ff ff       	call   8010e4 <fd_lookup>
  80192d:	83 c4 10             	add    $0x10,%esp
  801930:	85 c0                	test   %eax,%eax
  801932:	78 10                	js     801944 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801937:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80193d:	39 08                	cmp    %ecx,(%eax)
  80193f:	75 05                	jne    801946 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801941:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    
		return -E_NOT_SUPP;
  801946:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80194b:	eb f7                	jmp    801944 <fd2sockid+0x27>

0080194d <alloc_sockfd>:
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	56                   	push   %esi
  801951:	53                   	push   %ebx
  801952:	83 ec 1c             	sub    $0x1c,%esp
  801955:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801957:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80195a:	50                   	push   %eax
  80195b:	e8 32 f7 ff ff       	call   801092 <fd_alloc>
  801960:	89 c3                	mov    %eax,%ebx
  801962:	83 c4 10             	add    $0x10,%esp
  801965:	85 c0                	test   %eax,%eax
  801967:	78 43                	js     8019ac <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801969:	83 ec 04             	sub    $0x4,%esp
  80196c:	68 07 04 00 00       	push   $0x407
  801971:	ff 75 f4             	pushl  -0xc(%ebp)
  801974:	6a 00                	push   $0x0
  801976:	e8 fb f3 ff ff       	call   800d76 <sys_page_alloc>
  80197b:	89 c3                	mov    %eax,%ebx
  80197d:	83 c4 10             	add    $0x10,%esp
  801980:	85 c0                	test   %eax,%eax
  801982:	78 28                	js     8019ac <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801987:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80198d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80198f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801992:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801999:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80199c:	83 ec 0c             	sub    $0xc,%esp
  80199f:	50                   	push   %eax
  8019a0:	e8 c6 f6 ff ff       	call   80106b <fd2num>
  8019a5:	89 c3                	mov    %eax,%ebx
  8019a7:	83 c4 10             	add    $0x10,%esp
  8019aa:	eb 0c                	jmp    8019b8 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8019ac:	83 ec 0c             	sub    $0xc,%esp
  8019af:	56                   	push   %esi
  8019b0:	e8 e4 01 00 00       	call   801b99 <nsipc_close>
		return r;
  8019b5:	83 c4 10             	add    $0x10,%esp
}
  8019b8:	89 d8                	mov    %ebx,%eax
  8019ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019bd:	5b                   	pop    %ebx
  8019be:	5e                   	pop    %esi
  8019bf:	5d                   	pop    %ebp
  8019c0:	c3                   	ret    

008019c1 <accept>:
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
  8019c4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	e8 4e ff ff ff       	call   80191d <fd2sockid>
  8019cf:	85 c0                	test   %eax,%eax
  8019d1:	78 1b                	js     8019ee <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019d3:	83 ec 04             	sub    $0x4,%esp
  8019d6:	ff 75 10             	pushl  0x10(%ebp)
  8019d9:	ff 75 0c             	pushl  0xc(%ebp)
  8019dc:	50                   	push   %eax
  8019dd:	e8 0e 01 00 00       	call   801af0 <nsipc_accept>
  8019e2:	83 c4 10             	add    $0x10,%esp
  8019e5:	85 c0                	test   %eax,%eax
  8019e7:	78 05                	js     8019ee <accept+0x2d>
	return alloc_sockfd(r);
  8019e9:	e8 5f ff ff ff       	call   80194d <alloc_sockfd>
}
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <bind>:
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
  8019f3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	e8 1f ff ff ff       	call   80191d <fd2sockid>
  8019fe:	85 c0                	test   %eax,%eax
  801a00:	78 12                	js     801a14 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801a02:	83 ec 04             	sub    $0x4,%esp
  801a05:	ff 75 10             	pushl  0x10(%ebp)
  801a08:	ff 75 0c             	pushl  0xc(%ebp)
  801a0b:	50                   	push   %eax
  801a0c:	e8 31 01 00 00       	call   801b42 <nsipc_bind>
  801a11:	83 c4 10             	add    $0x10,%esp
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <shutdown>:
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1f:	e8 f9 fe ff ff       	call   80191d <fd2sockid>
  801a24:	85 c0                	test   %eax,%eax
  801a26:	78 0f                	js     801a37 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a28:	83 ec 08             	sub    $0x8,%esp
  801a2b:	ff 75 0c             	pushl  0xc(%ebp)
  801a2e:	50                   	push   %eax
  801a2f:	e8 43 01 00 00       	call   801b77 <nsipc_shutdown>
  801a34:	83 c4 10             	add    $0x10,%esp
}
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

00801a39 <connect>:
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
  801a3c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a42:	e8 d6 fe ff ff       	call   80191d <fd2sockid>
  801a47:	85 c0                	test   %eax,%eax
  801a49:	78 12                	js     801a5d <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a4b:	83 ec 04             	sub    $0x4,%esp
  801a4e:	ff 75 10             	pushl  0x10(%ebp)
  801a51:	ff 75 0c             	pushl  0xc(%ebp)
  801a54:	50                   	push   %eax
  801a55:	e8 59 01 00 00       	call   801bb3 <nsipc_connect>
  801a5a:	83 c4 10             	add    $0x10,%esp
}
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <listen>:
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a65:	8b 45 08             	mov    0x8(%ebp),%eax
  801a68:	e8 b0 fe ff ff       	call   80191d <fd2sockid>
  801a6d:	85 c0                	test   %eax,%eax
  801a6f:	78 0f                	js     801a80 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a71:	83 ec 08             	sub    $0x8,%esp
  801a74:	ff 75 0c             	pushl  0xc(%ebp)
  801a77:	50                   	push   %eax
  801a78:	e8 6b 01 00 00       	call   801be8 <nsipc_listen>
  801a7d:	83 c4 10             	add    $0x10,%esp
}
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    

00801a82 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
  801a85:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a88:	ff 75 10             	pushl  0x10(%ebp)
  801a8b:	ff 75 0c             	pushl  0xc(%ebp)
  801a8e:	ff 75 08             	pushl  0x8(%ebp)
  801a91:	e8 3e 02 00 00       	call   801cd4 <nsipc_socket>
  801a96:	83 c4 10             	add    $0x10,%esp
  801a99:	85 c0                	test   %eax,%eax
  801a9b:	78 05                	js     801aa2 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a9d:	e8 ab fe ff ff       	call   80194d <alloc_sockfd>
}
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	53                   	push   %ebx
  801aa8:	83 ec 04             	sub    $0x4,%esp
  801aab:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801aad:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801ab4:	74 26                	je     801adc <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ab6:	6a 07                	push   $0x7
  801ab8:	68 00 60 80 00       	push   $0x806000
  801abd:	53                   	push   %ebx
  801abe:	ff 35 04 40 80 00    	pushl  0x804004
  801ac4:	e8 c2 07 00 00       	call   80228b <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ac9:	83 c4 0c             	add    $0xc,%esp
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	e8 4b 07 00 00       	call   802222 <ipc_recv>
}
  801ad7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801adc:	83 ec 0c             	sub    $0xc,%esp
  801adf:	6a 02                	push   $0x2
  801ae1:	e8 fd 07 00 00       	call   8022e3 <ipc_find_env>
  801ae6:	a3 04 40 80 00       	mov    %eax,0x804004
  801aeb:	83 c4 10             	add    $0x10,%esp
  801aee:	eb c6                	jmp    801ab6 <nsipc+0x12>

00801af0 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	56                   	push   %esi
  801af4:	53                   	push   %ebx
  801af5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801af8:	8b 45 08             	mov    0x8(%ebp),%eax
  801afb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b00:	8b 06                	mov    (%esi),%eax
  801b02:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b07:	b8 01 00 00 00       	mov    $0x1,%eax
  801b0c:	e8 93 ff ff ff       	call   801aa4 <nsipc>
  801b11:	89 c3                	mov    %eax,%ebx
  801b13:	85 c0                	test   %eax,%eax
  801b15:	79 09                	jns    801b20 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b17:	89 d8                	mov    %ebx,%eax
  801b19:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b1c:	5b                   	pop    %ebx
  801b1d:	5e                   	pop    %esi
  801b1e:	5d                   	pop    %ebp
  801b1f:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b20:	83 ec 04             	sub    $0x4,%esp
  801b23:	ff 35 10 60 80 00    	pushl  0x806010
  801b29:	68 00 60 80 00       	push   $0x806000
  801b2e:	ff 75 0c             	pushl  0xc(%ebp)
  801b31:	e8 dc ef ff ff       	call   800b12 <memmove>
		*addrlen = ret->ret_addrlen;
  801b36:	a1 10 60 80 00       	mov    0x806010,%eax
  801b3b:	89 06                	mov    %eax,(%esi)
  801b3d:	83 c4 10             	add    $0x10,%esp
	return r;
  801b40:	eb d5                	jmp    801b17 <nsipc_accept+0x27>

00801b42 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
  801b45:	53                   	push   %ebx
  801b46:	83 ec 08             	sub    $0x8,%esp
  801b49:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4f:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b54:	53                   	push   %ebx
  801b55:	ff 75 0c             	pushl  0xc(%ebp)
  801b58:	68 04 60 80 00       	push   $0x806004
  801b5d:	e8 b0 ef ff ff       	call   800b12 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b62:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b68:	b8 02 00 00 00       	mov    $0x2,%eax
  801b6d:	e8 32 ff ff ff       	call   801aa4 <nsipc>
}
  801b72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b80:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b88:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b8d:	b8 03 00 00 00       	mov    $0x3,%eax
  801b92:	e8 0d ff ff ff       	call   801aa4 <nsipc>
}
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    

00801b99 <nsipc_close>:

int
nsipc_close(int s)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
  801b9c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba2:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ba7:	b8 04 00 00 00       	mov    $0x4,%eax
  801bac:	e8 f3 fe ff ff       	call   801aa4 <nsipc>
}
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
  801bb6:	53                   	push   %ebx
  801bb7:	83 ec 08             	sub    $0x8,%esp
  801bba:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc0:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801bc5:	53                   	push   %ebx
  801bc6:	ff 75 0c             	pushl  0xc(%ebp)
  801bc9:	68 04 60 80 00       	push   $0x806004
  801bce:	e8 3f ef ff ff       	call   800b12 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801bd3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801bd9:	b8 05 00 00 00       	mov    $0x5,%eax
  801bde:	e8 c1 fe ff ff       	call   801aa4 <nsipc>
}
  801be3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
  801beb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801bee:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf9:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bfe:	b8 06 00 00 00       	mov    $0x6,%eax
  801c03:	e8 9c fe ff ff       	call   801aa4 <nsipc>
}
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
  801c0d:	56                   	push   %esi
  801c0e:	53                   	push   %ebx
  801c0f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c12:	8b 45 08             	mov    0x8(%ebp),%eax
  801c15:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c1a:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c20:	8b 45 14             	mov    0x14(%ebp),%eax
  801c23:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c28:	b8 07 00 00 00       	mov    $0x7,%eax
  801c2d:	e8 72 fe ff ff       	call   801aa4 <nsipc>
  801c32:	89 c3                	mov    %eax,%ebx
  801c34:	85 c0                	test   %eax,%eax
  801c36:	78 1f                	js     801c57 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c38:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c3d:	7f 21                	jg     801c60 <nsipc_recv+0x56>
  801c3f:	39 c6                	cmp    %eax,%esi
  801c41:	7c 1d                	jl     801c60 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c43:	83 ec 04             	sub    $0x4,%esp
  801c46:	50                   	push   %eax
  801c47:	68 00 60 80 00       	push   $0x806000
  801c4c:	ff 75 0c             	pushl  0xc(%ebp)
  801c4f:	e8 be ee ff ff       	call   800b12 <memmove>
  801c54:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c57:	89 d8                	mov    %ebx,%eax
  801c59:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c5c:	5b                   	pop    %ebx
  801c5d:	5e                   	pop    %esi
  801c5e:	5d                   	pop    %ebp
  801c5f:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c60:	68 e3 2a 80 00       	push   $0x802ae3
  801c65:	68 ab 2a 80 00       	push   $0x802aab
  801c6a:	6a 62                	push   $0x62
  801c6c:	68 f8 2a 80 00       	push   $0x802af8
  801c71:	e8 4b 05 00 00       	call   8021c1 <_panic>

00801c76 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	53                   	push   %ebx
  801c7a:	83 ec 04             	sub    $0x4,%esp
  801c7d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c88:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c8e:	7f 2e                	jg     801cbe <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c90:	83 ec 04             	sub    $0x4,%esp
  801c93:	53                   	push   %ebx
  801c94:	ff 75 0c             	pushl  0xc(%ebp)
  801c97:	68 0c 60 80 00       	push   $0x80600c
  801c9c:	e8 71 ee ff ff       	call   800b12 <memmove>
	nsipcbuf.send.req_size = size;
  801ca1:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801ca7:	8b 45 14             	mov    0x14(%ebp),%eax
  801caa:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801caf:	b8 08 00 00 00       	mov    $0x8,%eax
  801cb4:	e8 eb fd ff ff       	call   801aa4 <nsipc>
}
  801cb9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    
	assert(size < 1600);
  801cbe:	68 04 2b 80 00       	push   $0x802b04
  801cc3:	68 ab 2a 80 00       	push   $0x802aab
  801cc8:	6a 6d                	push   $0x6d
  801cca:	68 f8 2a 80 00       	push   $0x802af8
  801ccf:	e8 ed 04 00 00       	call   8021c1 <_panic>

00801cd4 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
  801cd7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce5:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801cea:	8b 45 10             	mov    0x10(%ebp),%eax
  801ced:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801cf2:	b8 09 00 00 00       	mov    $0x9,%eax
  801cf7:	e8 a8 fd ff ff       	call   801aa4 <nsipc>
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	56                   	push   %esi
  801d02:	53                   	push   %ebx
  801d03:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d06:	83 ec 0c             	sub    $0xc,%esp
  801d09:	ff 75 08             	pushl  0x8(%ebp)
  801d0c:	e8 6a f3 ff ff       	call   80107b <fd2data>
  801d11:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d13:	83 c4 08             	add    $0x8,%esp
  801d16:	68 10 2b 80 00       	push   $0x802b10
  801d1b:	53                   	push   %ebx
  801d1c:	e8 63 ec ff ff       	call   800984 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d21:	8b 46 04             	mov    0x4(%esi),%eax
  801d24:	2b 06                	sub    (%esi),%eax
  801d26:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d2c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d33:	00 00 00 
	stat->st_dev = &devpipe;
  801d36:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d3d:	30 80 00 
	return 0;
}
  801d40:	b8 00 00 00 00       	mov    $0x0,%eax
  801d45:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d48:	5b                   	pop    %ebx
  801d49:	5e                   	pop    %esi
  801d4a:	5d                   	pop    %ebp
  801d4b:	c3                   	ret    

00801d4c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
  801d4f:	53                   	push   %ebx
  801d50:	83 ec 0c             	sub    $0xc,%esp
  801d53:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d56:	53                   	push   %ebx
  801d57:	6a 00                	push   $0x0
  801d59:	e8 9d f0 ff ff       	call   800dfb <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d5e:	89 1c 24             	mov    %ebx,(%esp)
  801d61:	e8 15 f3 ff ff       	call   80107b <fd2data>
  801d66:	83 c4 08             	add    $0x8,%esp
  801d69:	50                   	push   %eax
  801d6a:	6a 00                	push   $0x0
  801d6c:	e8 8a f0 ff ff       	call   800dfb <sys_page_unmap>
}
  801d71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <_pipeisclosed>:
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
  801d79:	57                   	push   %edi
  801d7a:	56                   	push   %esi
  801d7b:	53                   	push   %ebx
  801d7c:	83 ec 1c             	sub    $0x1c,%esp
  801d7f:	89 c7                	mov    %eax,%edi
  801d81:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d83:	a1 08 40 80 00       	mov    0x804008,%eax
  801d88:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d8b:	83 ec 0c             	sub    $0xc,%esp
  801d8e:	57                   	push   %edi
  801d8f:	e8 8a 05 00 00       	call   80231e <pageref>
  801d94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d97:	89 34 24             	mov    %esi,(%esp)
  801d9a:	e8 7f 05 00 00       	call   80231e <pageref>
		nn = thisenv->env_runs;
  801d9f:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801da5:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801da8:	83 c4 10             	add    $0x10,%esp
  801dab:	39 cb                	cmp    %ecx,%ebx
  801dad:	74 1b                	je     801dca <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801daf:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801db2:	75 cf                	jne    801d83 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801db4:	8b 42 58             	mov    0x58(%edx),%eax
  801db7:	6a 01                	push   $0x1
  801db9:	50                   	push   %eax
  801dba:	53                   	push   %ebx
  801dbb:	68 17 2b 80 00       	push   $0x802b17
  801dc0:	e8 60 e4 ff ff       	call   800225 <cprintf>
  801dc5:	83 c4 10             	add    $0x10,%esp
  801dc8:	eb b9                	jmp    801d83 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801dca:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dcd:	0f 94 c0             	sete   %al
  801dd0:	0f b6 c0             	movzbl %al,%eax
}
  801dd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dd6:	5b                   	pop    %ebx
  801dd7:	5e                   	pop    %esi
  801dd8:	5f                   	pop    %edi
  801dd9:	5d                   	pop    %ebp
  801dda:	c3                   	ret    

00801ddb <devpipe_write>:
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
  801dde:	57                   	push   %edi
  801ddf:	56                   	push   %esi
  801de0:	53                   	push   %ebx
  801de1:	83 ec 28             	sub    $0x28,%esp
  801de4:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801de7:	56                   	push   %esi
  801de8:	e8 8e f2 ff ff       	call   80107b <fd2data>
  801ded:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801def:	83 c4 10             	add    $0x10,%esp
  801df2:	bf 00 00 00 00       	mov    $0x0,%edi
  801df7:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801dfa:	74 4f                	je     801e4b <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801dfc:	8b 43 04             	mov    0x4(%ebx),%eax
  801dff:	8b 0b                	mov    (%ebx),%ecx
  801e01:	8d 51 20             	lea    0x20(%ecx),%edx
  801e04:	39 d0                	cmp    %edx,%eax
  801e06:	72 14                	jb     801e1c <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e08:	89 da                	mov    %ebx,%edx
  801e0a:	89 f0                	mov    %esi,%eax
  801e0c:	e8 65 ff ff ff       	call   801d76 <_pipeisclosed>
  801e11:	85 c0                	test   %eax,%eax
  801e13:	75 3b                	jne    801e50 <devpipe_write+0x75>
			sys_yield();
  801e15:	e8 3d ef ff ff       	call   800d57 <sys_yield>
  801e1a:	eb e0                	jmp    801dfc <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e1f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e23:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e26:	89 c2                	mov    %eax,%edx
  801e28:	c1 fa 1f             	sar    $0x1f,%edx
  801e2b:	89 d1                	mov    %edx,%ecx
  801e2d:	c1 e9 1b             	shr    $0x1b,%ecx
  801e30:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e33:	83 e2 1f             	and    $0x1f,%edx
  801e36:	29 ca                	sub    %ecx,%edx
  801e38:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e3c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e40:	83 c0 01             	add    $0x1,%eax
  801e43:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e46:	83 c7 01             	add    $0x1,%edi
  801e49:	eb ac                	jmp    801df7 <devpipe_write+0x1c>
	return i;
  801e4b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e4e:	eb 05                	jmp    801e55 <devpipe_write+0x7a>
				return 0;
  801e50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e55:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e58:	5b                   	pop    %ebx
  801e59:	5e                   	pop    %esi
  801e5a:	5f                   	pop    %edi
  801e5b:	5d                   	pop    %ebp
  801e5c:	c3                   	ret    

00801e5d <devpipe_read>:
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
  801e60:	57                   	push   %edi
  801e61:	56                   	push   %esi
  801e62:	53                   	push   %ebx
  801e63:	83 ec 18             	sub    $0x18,%esp
  801e66:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e69:	57                   	push   %edi
  801e6a:	e8 0c f2 ff ff       	call   80107b <fd2data>
  801e6f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e71:	83 c4 10             	add    $0x10,%esp
  801e74:	be 00 00 00 00       	mov    $0x0,%esi
  801e79:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e7c:	75 14                	jne    801e92 <devpipe_read+0x35>
	return i;
  801e7e:	8b 45 10             	mov    0x10(%ebp),%eax
  801e81:	eb 02                	jmp    801e85 <devpipe_read+0x28>
				return i;
  801e83:	89 f0                	mov    %esi,%eax
}
  801e85:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e88:	5b                   	pop    %ebx
  801e89:	5e                   	pop    %esi
  801e8a:	5f                   	pop    %edi
  801e8b:	5d                   	pop    %ebp
  801e8c:	c3                   	ret    
			sys_yield();
  801e8d:	e8 c5 ee ff ff       	call   800d57 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e92:	8b 03                	mov    (%ebx),%eax
  801e94:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e97:	75 18                	jne    801eb1 <devpipe_read+0x54>
			if (i > 0)
  801e99:	85 f6                	test   %esi,%esi
  801e9b:	75 e6                	jne    801e83 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e9d:	89 da                	mov    %ebx,%edx
  801e9f:	89 f8                	mov    %edi,%eax
  801ea1:	e8 d0 fe ff ff       	call   801d76 <_pipeisclosed>
  801ea6:	85 c0                	test   %eax,%eax
  801ea8:	74 e3                	je     801e8d <devpipe_read+0x30>
				return 0;
  801eaa:	b8 00 00 00 00       	mov    $0x0,%eax
  801eaf:	eb d4                	jmp    801e85 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801eb1:	99                   	cltd   
  801eb2:	c1 ea 1b             	shr    $0x1b,%edx
  801eb5:	01 d0                	add    %edx,%eax
  801eb7:	83 e0 1f             	and    $0x1f,%eax
  801eba:	29 d0                	sub    %edx,%eax
  801ebc:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ec1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ec4:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ec7:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801eca:	83 c6 01             	add    $0x1,%esi
  801ecd:	eb aa                	jmp    801e79 <devpipe_read+0x1c>

00801ecf <pipe>:
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
  801ed2:	56                   	push   %esi
  801ed3:	53                   	push   %ebx
  801ed4:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ed7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eda:	50                   	push   %eax
  801edb:	e8 b2 f1 ff ff       	call   801092 <fd_alloc>
  801ee0:	89 c3                	mov    %eax,%ebx
  801ee2:	83 c4 10             	add    $0x10,%esp
  801ee5:	85 c0                	test   %eax,%eax
  801ee7:	0f 88 23 01 00 00    	js     802010 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eed:	83 ec 04             	sub    $0x4,%esp
  801ef0:	68 07 04 00 00       	push   $0x407
  801ef5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ef8:	6a 00                	push   $0x0
  801efa:	e8 77 ee ff ff       	call   800d76 <sys_page_alloc>
  801eff:	89 c3                	mov    %eax,%ebx
  801f01:	83 c4 10             	add    $0x10,%esp
  801f04:	85 c0                	test   %eax,%eax
  801f06:	0f 88 04 01 00 00    	js     802010 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f0c:	83 ec 0c             	sub    $0xc,%esp
  801f0f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f12:	50                   	push   %eax
  801f13:	e8 7a f1 ff ff       	call   801092 <fd_alloc>
  801f18:	89 c3                	mov    %eax,%ebx
  801f1a:	83 c4 10             	add    $0x10,%esp
  801f1d:	85 c0                	test   %eax,%eax
  801f1f:	0f 88 db 00 00 00    	js     802000 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f25:	83 ec 04             	sub    $0x4,%esp
  801f28:	68 07 04 00 00       	push   $0x407
  801f2d:	ff 75 f0             	pushl  -0x10(%ebp)
  801f30:	6a 00                	push   $0x0
  801f32:	e8 3f ee ff ff       	call   800d76 <sys_page_alloc>
  801f37:	89 c3                	mov    %eax,%ebx
  801f39:	83 c4 10             	add    $0x10,%esp
  801f3c:	85 c0                	test   %eax,%eax
  801f3e:	0f 88 bc 00 00 00    	js     802000 <pipe+0x131>
	va = fd2data(fd0);
  801f44:	83 ec 0c             	sub    $0xc,%esp
  801f47:	ff 75 f4             	pushl  -0xc(%ebp)
  801f4a:	e8 2c f1 ff ff       	call   80107b <fd2data>
  801f4f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f51:	83 c4 0c             	add    $0xc,%esp
  801f54:	68 07 04 00 00       	push   $0x407
  801f59:	50                   	push   %eax
  801f5a:	6a 00                	push   $0x0
  801f5c:	e8 15 ee ff ff       	call   800d76 <sys_page_alloc>
  801f61:	89 c3                	mov    %eax,%ebx
  801f63:	83 c4 10             	add    $0x10,%esp
  801f66:	85 c0                	test   %eax,%eax
  801f68:	0f 88 82 00 00 00    	js     801ff0 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f6e:	83 ec 0c             	sub    $0xc,%esp
  801f71:	ff 75 f0             	pushl  -0x10(%ebp)
  801f74:	e8 02 f1 ff ff       	call   80107b <fd2data>
  801f79:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f80:	50                   	push   %eax
  801f81:	6a 00                	push   $0x0
  801f83:	56                   	push   %esi
  801f84:	6a 00                	push   $0x0
  801f86:	e8 2e ee ff ff       	call   800db9 <sys_page_map>
  801f8b:	89 c3                	mov    %eax,%ebx
  801f8d:	83 c4 20             	add    $0x20,%esp
  801f90:	85 c0                	test   %eax,%eax
  801f92:	78 4e                	js     801fe2 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f94:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f9c:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa1:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801fa8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fab:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801fad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801fb7:	83 ec 0c             	sub    $0xc,%esp
  801fba:	ff 75 f4             	pushl  -0xc(%ebp)
  801fbd:	e8 a9 f0 ff ff       	call   80106b <fd2num>
  801fc2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fc5:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fc7:	83 c4 04             	add    $0x4,%esp
  801fca:	ff 75 f0             	pushl  -0x10(%ebp)
  801fcd:	e8 99 f0 ff ff       	call   80106b <fd2num>
  801fd2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fd5:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fd8:	83 c4 10             	add    $0x10,%esp
  801fdb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fe0:	eb 2e                	jmp    802010 <pipe+0x141>
	sys_page_unmap(0, va);
  801fe2:	83 ec 08             	sub    $0x8,%esp
  801fe5:	56                   	push   %esi
  801fe6:	6a 00                	push   $0x0
  801fe8:	e8 0e ee ff ff       	call   800dfb <sys_page_unmap>
  801fed:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ff0:	83 ec 08             	sub    $0x8,%esp
  801ff3:	ff 75 f0             	pushl  -0x10(%ebp)
  801ff6:	6a 00                	push   $0x0
  801ff8:	e8 fe ed ff ff       	call   800dfb <sys_page_unmap>
  801ffd:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802000:	83 ec 08             	sub    $0x8,%esp
  802003:	ff 75 f4             	pushl  -0xc(%ebp)
  802006:	6a 00                	push   $0x0
  802008:	e8 ee ed ff ff       	call   800dfb <sys_page_unmap>
  80200d:	83 c4 10             	add    $0x10,%esp
}
  802010:	89 d8                	mov    %ebx,%eax
  802012:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802015:	5b                   	pop    %ebx
  802016:	5e                   	pop    %esi
  802017:	5d                   	pop    %ebp
  802018:	c3                   	ret    

00802019 <pipeisclosed>:
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
  80201c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80201f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802022:	50                   	push   %eax
  802023:	ff 75 08             	pushl  0x8(%ebp)
  802026:	e8 b9 f0 ff ff       	call   8010e4 <fd_lookup>
  80202b:	83 c4 10             	add    $0x10,%esp
  80202e:	85 c0                	test   %eax,%eax
  802030:	78 18                	js     80204a <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802032:	83 ec 0c             	sub    $0xc,%esp
  802035:	ff 75 f4             	pushl  -0xc(%ebp)
  802038:	e8 3e f0 ff ff       	call   80107b <fd2data>
	return _pipeisclosed(fd, p);
  80203d:	89 c2                	mov    %eax,%edx
  80203f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802042:	e8 2f fd ff ff       	call   801d76 <_pipeisclosed>
  802047:	83 c4 10             	add    $0x10,%esp
}
  80204a:	c9                   	leave  
  80204b:	c3                   	ret    

0080204c <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80204c:	b8 00 00 00 00       	mov    $0x0,%eax
  802051:	c3                   	ret    

00802052 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802052:	55                   	push   %ebp
  802053:	89 e5                	mov    %esp,%ebp
  802055:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802058:	68 2f 2b 80 00       	push   $0x802b2f
  80205d:	ff 75 0c             	pushl  0xc(%ebp)
  802060:	e8 1f e9 ff ff       	call   800984 <strcpy>
	return 0;
}
  802065:	b8 00 00 00 00       	mov    $0x0,%eax
  80206a:	c9                   	leave  
  80206b:	c3                   	ret    

0080206c <devcons_write>:
{
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
  80206f:	57                   	push   %edi
  802070:	56                   	push   %esi
  802071:	53                   	push   %ebx
  802072:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802078:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80207d:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802083:	3b 75 10             	cmp    0x10(%ebp),%esi
  802086:	73 31                	jae    8020b9 <devcons_write+0x4d>
		m = n - tot;
  802088:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80208b:	29 f3                	sub    %esi,%ebx
  80208d:	83 fb 7f             	cmp    $0x7f,%ebx
  802090:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802095:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802098:	83 ec 04             	sub    $0x4,%esp
  80209b:	53                   	push   %ebx
  80209c:	89 f0                	mov    %esi,%eax
  80209e:	03 45 0c             	add    0xc(%ebp),%eax
  8020a1:	50                   	push   %eax
  8020a2:	57                   	push   %edi
  8020a3:	e8 6a ea ff ff       	call   800b12 <memmove>
		sys_cputs(buf, m);
  8020a8:	83 c4 08             	add    $0x8,%esp
  8020ab:	53                   	push   %ebx
  8020ac:	57                   	push   %edi
  8020ad:	e8 08 ec ff ff       	call   800cba <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020b2:	01 de                	add    %ebx,%esi
  8020b4:	83 c4 10             	add    $0x10,%esp
  8020b7:	eb ca                	jmp    802083 <devcons_write+0x17>
}
  8020b9:	89 f0                	mov    %esi,%eax
  8020bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020be:	5b                   	pop    %ebx
  8020bf:	5e                   	pop    %esi
  8020c0:	5f                   	pop    %edi
  8020c1:	5d                   	pop    %ebp
  8020c2:	c3                   	ret    

008020c3 <devcons_read>:
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	83 ec 08             	sub    $0x8,%esp
  8020c9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020d2:	74 21                	je     8020f5 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8020d4:	e8 ff eb ff ff       	call   800cd8 <sys_cgetc>
  8020d9:	85 c0                	test   %eax,%eax
  8020db:	75 07                	jne    8020e4 <devcons_read+0x21>
		sys_yield();
  8020dd:	e8 75 ec ff ff       	call   800d57 <sys_yield>
  8020e2:	eb f0                	jmp    8020d4 <devcons_read+0x11>
	if (c < 0)
  8020e4:	78 0f                	js     8020f5 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020e6:	83 f8 04             	cmp    $0x4,%eax
  8020e9:	74 0c                	je     8020f7 <devcons_read+0x34>
	*(char*)vbuf = c;
  8020eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ee:	88 02                	mov    %al,(%edx)
	return 1;
  8020f0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020f5:	c9                   	leave  
  8020f6:	c3                   	ret    
		return 0;
  8020f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020fc:	eb f7                	jmp    8020f5 <devcons_read+0x32>

008020fe <cputchar>:
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
  802101:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80210a:	6a 01                	push   $0x1
  80210c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80210f:	50                   	push   %eax
  802110:	e8 a5 eb ff ff       	call   800cba <sys_cputs>
}
  802115:	83 c4 10             	add    $0x10,%esp
  802118:	c9                   	leave  
  802119:	c3                   	ret    

0080211a <getchar>:
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
  80211d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802120:	6a 01                	push   $0x1
  802122:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802125:	50                   	push   %eax
  802126:	6a 00                	push   $0x0
  802128:	e8 27 f2 ff ff       	call   801354 <read>
	if (r < 0)
  80212d:	83 c4 10             	add    $0x10,%esp
  802130:	85 c0                	test   %eax,%eax
  802132:	78 06                	js     80213a <getchar+0x20>
	if (r < 1)
  802134:	74 06                	je     80213c <getchar+0x22>
	return c;
  802136:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80213a:	c9                   	leave  
  80213b:	c3                   	ret    
		return -E_EOF;
  80213c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802141:	eb f7                	jmp    80213a <getchar+0x20>

00802143 <iscons>:
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
  802146:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802149:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80214c:	50                   	push   %eax
  80214d:	ff 75 08             	pushl  0x8(%ebp)
  802150:	e8 8f ef ff ff       	call   8010e4 <fd_lookup>
  802155:	83 c4 10             	add    $0x10,%esp
  802158:	85 c0                	test   %eax,%eax
  80215a:	78 11                	js     80216d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80215c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215f:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802165:	39 10                	cmp    %edx,(%eax)
  802167:	0f 94 c0             	sete   %al
  80216a:	0f b6 c0             	movzbl %al,%eax
}
  80216d:	c9                   	leave  
  80216e:	c3                   	ret    

0080216f <opencons>:
{
  80216f:	55                   	push   %ebp
  802170:	89 e5                	mov    %esp,%ebp
  802172:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802175:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802178:	50                   	push   %eax
  802179:	e8 14 ef ff ff       	call   801092 <fd_alloc>
  80217e:	83 c4 10             	add    $0x10,%esp
  802181:	85 c0                	test   %eax,%eax
  802183:	78 3a                	js     8021bf <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802185:	83 ec 04             	sub    $0x4,%esp
  802188:	68 07 04 00 00       	push   $0x407
  80218d:	ff 75 f4             	pushl  -0xc(%ebp)
  802190:	6a 00                	push   $0x0
  802192:	e8 df eb ff ff       	call   800d76 <sys_page_alloc>
  802197:	83 c4 10             	add    $0x10,%esp
  80219a:	85 c0                	test   %eax,%eax
  80219c:	78 21                	js     8021bf <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80219e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a1:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021a7:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ac:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021b3:	83 ec 0c             	sub    $0xc,%esp
  8021b6:	50                   	push   %eax
  8021b7:	e8 af ee ff ff       	call   80106b <fd2num>
  8021bc:	83 c4 10             	add    $0x10,%esp
}
  8021bf:	c9                   	leave  
  8021c0:	c3                   	ret    

008021c1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8021c1:	55                   	push   %ebp
  8021c2:	89 e5                	mov    %esp,%ebp
  8021c4:	56                   	push   %esi
  8021c5:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8021c6:	a1 08 40 80 00       	mov    0x804008,%eax
  8021cb:	8b 40 48             	mov    0x48(%eax),%eax
  8021ce:	83 ec 04             	sub    $0x4,%esp
  8021d1:	68 60 2b 80 00       	push   $0x802b60
  8021d6:	50                   	push   %eax
  8021d7:	68 5a 26 80 00       	push   $0x80265a
  8021dc:	e8 44 e0 ff ff       	call   800225 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8021e1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021e4:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021ea:	e8 49 eb ff ff       	call   800d38 <sys_getenvid>
  8021ef:	83 c4 04             	add    $0x4,%esp
  8021f2:	ff 75 0c             	pushl  0xc(%ebp)
  8021f5:	ff 75 08             	pushl  0x8(%ebp)
  8021f8:	56                   	push   %esi
  8021f9:	50                   	push   %eax
  8021fa:	68 3c 2b 80 00       	push   $0x802b3c
  8021ff:	e8 21 e0 ff ff       	call   800225 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802204:	83 c4 18             	add    $0x18,%esp
  802207:	53                   	push   %ebx
  802208:	ff 75 10             	pushl  0x10(%ebp)
  80220b:	e8 c4 df ff ff       	call   8001d4 <vcprintf>
	cprintf("\n");
  802210:	c7 04 24 1e 26 80 00 	movl   $0x80261e,(%esp)
  802217:	e8 09 e0 ff ff       	call   800225 <cprintf>
  80221c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80221f:	cc                   	int3   
  802220:	eb fd                	jmp    80221f <_panic+0x5e>

00802222 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802222:	55                   	push   %ebp
  802223:	89 e5                	mov    %esp,%ebp
  802225:	56                   	push   %esi
  802226:	53                   	push   %ebx
  802227:	8b 75 08             	mov    0x8(%ebp),%esi
  80222a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80222d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802230:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802232:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802237:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80223a:	83 ec 0c             	sub    $0xc,%esp
  80223d:	50                   	push   %eax
  80223e:	e8 e3 ec ff ff       	call   800f26 <sys_ipc_recv>
	if(ret < 0){
  802243:	83 c4 10             	add    $0x10,%esp
  802246:	85 c0                	test   %eax,%eax
  802248:	78 2b                	js     802275 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80224a:	85 f6                	test   %esi,%esi
  80224c:	74 0a                	je     802258 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80224e:	a1 08 40 80 00       	mov    0x804008,%eax
  802253:	8b 40 74             	mov    0x74(%eax),%eax
  802256:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802258:	85 db                	test   %ebx,%ebx
  80225a:	74 0a                	je     802266 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80225c:	a1 08 40 80 00       	mov    0x804008,%eax
  802261:	8b 40 78             	mov    0x78(%eax),%eax
  802264:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802266:	a1 08 40 80 00       	mov    0x804008,%eax
  80226b:	8b 40 70             	mov    0x70(%eax),%eax
}
  80226e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802271:	5b                   	pop    %ebx
  802272:	5e                   	pop    %esi
  802273:	5d                   	pop    %ebp
  802274:	c3                   	ret    
		if(from_env_store)
  802275:	85 f6                	test   %esi,%esi
  802277:	74 06                	je     80227f <ipc_recv+0x5d>
			*from_env_store = 0;
  802279:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80227f:	85 db                	test   %ebx,%ebx
  802281:	74 eb                	je     80226e <ipc_recv+0x4c>
			*perm_store = 0;
  802283:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802289:	eb e3                	jmp    80226e <ipc_recv+0x4c>

0080228b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80228b:	55                   	push   %ebp
  80228c:	89 e5                	mov    %esp,%ebp
  80228e:	57                   	push   %edi
  80228f:	56                   	push   %esi
  802290:	53                   	push   %ebx
  802291:	83 ec 0c             	sub    $0xc,%esp
  802294:	8b 7d 08             	mov    0x8(%ebp),%edi
  802297:	8b 75 0c             	mov    0xc(%ebp),%esi
  80229a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80229d:	85 db                	test   %ebx,%ebx
  80229f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8022a4:	0f 44 d8             	cmove  %eax,%ebx
  8022a7:	eb 05                	jmp    8022ae <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8022a9:	e8 a9 ea ff ff       	call   800d57 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8022ae:	ff 75 14             	pushl  0x14(%ebp)
  8022b1:	53                   	push   %ebx
  8022b2:	56                   	push   %esi
  8022b3:	57                   	push   %edi
  8022b4:	e8 4a ec ff ff       	call   800f03 <sys_ipc_try_send>
  8022b9:	83 c4 10             	add    $0x10,%esp
  8022bc:	85 c0                	test   %eax,%eax
  8022be:	74 1b                	je     8022db <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8022c0:	79 e7                	jns    8022a9 <ipc_send+0x1e>
  8022c2:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022c5:	74 e2                	je     8022a9 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8022c7:	83 ec 04             	sub    $0x4,%esp
  8022ca:	68 67 2b 80 00       	push   $0x802b67
  8022cf:	6a 46                	push   $0x46
  8022d1:	68 7c 2b 80 00       	push   $0x802b7c
  8022d6:	e8 e6 fe ff ff       	call   8021c1 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8022db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022de:	5b                   	pop    %ebx
  8022df:	5e                   	pop    %esi
  8022e0:	5f                   	pop    %edi
  8022e1:	5d                   	pop    %ebp
  8022e2:	c3                   	ret    

008022e3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022e3:	55                   	push   %ebp
  8022e4:	89 e5                	mov    %esp,%ebp
  8022e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022e9:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022ee:	89 c2                	mov    %eax,%edx
  8022f0:	c1 e2 07             	shl    $0x7,%edx
  8022f3:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022f9:	8b 52 50             	mov    0x50(%edx),%edx
  8022fc:	39 ca                	cmp    %ecx,%edx
  8022fe:	74 11                	je     802311 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802300:	83 c0 01             	add    $0x1,%eax
  802303:	3d 00 04 00 00       	cmp    $0x400,%eax
  802308:	75 e4                	jne    8022ee <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80230a:	b8 00 00 00 00       	mov    $0x0,%eax
  80230f:	eb 0b                	jmp    80231c <ipc_find_env+0x39>
			return envs[i].env_id;
  802311:	c1 e0 07             	shl    $0x7,%eax
  802314:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802319:	8b 40 48             	mov    0x48(%eax),%eax
}
  80231c:	5d                   	pop    %ebp
  80231d:	c3                   	ret    

0080231e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80231e:	55                   	push   %ebp
  80231f:	89 e5                	mov    %esp,%ebp
  802321:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802324:	89 d0                	mov    %edx,%eax
  802326:	c1 e8 16             	shr    $0x16,%eax
  802329:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802330:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802335:	f6 c1 01             	test   $0x1,%cl
  802338:	74 1d                	je     802357 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80233a:	c1 ea 0c             	shr    $0xc,%edx
  80233d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802344:	f6 c2 01             	test   $0x1,%dl
  802347:	74 0e                	je     802357 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802349:	c1 ea 0c             	shr    $0xc,%edx
  80234c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802353:	ef 
  802354:	0f b7 c0             	movzwl %ax,%eax
}
  802357:	5d                   	pop    %ebp
  802358:	c3                   	ret    
  802359:	66 90                	xchg   %ax,%ax
  80235b:	66 90                	xchg   %ax,%ax
  80235d:	66 90                	xchg   %ax,%ax
  80235f:	90                   	nop

00802360 <__udivdi3>:
  802360:	55                   	push   %ebp
  802361:	57                   	push   %edi
  802362:	56                   	push   %esi
  802363:	53                   	push   %ebx
  802364:	83 ec 1c             	sub    $0x1c,%esp
  802367:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80236b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80236f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802373:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802377:	85 d2                	test   %edx,%edx
  802379:	75 4d                	jne    8023c8 <__udivdi3+0x68>
  80237b:	39 f3                	cmp    %esi,%ebx
  80237d:	76 19                	jbe    802398 <__udivdi3+0x38>
  80237f:	31 ff                	xor    %edi,%edi
  802381:	89 e8                	mov    %ebp,%eax
  802383:	89 f2                	mov    %esi,%edx
  802385:	f7 f3                	div    %ebx
  802387:	89 fa                	mov    %edi,%edx
  802389:	83 c4 1c             	add    $0x1c,%esp
  80238c:	5b                   	pop    %ebx
  80238d:	5e                   	pop    %esi
  80238e:	5f                   	pop    %edi
  80238f:	5d                   	pop    %ebp
  802390:	c3                   	ret    
  802391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802398:	89 d9                	mov    %ebx,%ecx
  80239a:	85 db                	test   %ebx,%ebx
  80239c:	75 0b                	jne    8023a9 <__udivdi3+0x49>
  80239e:	b8 01 00 00 00       	mov    $0x1,%eax
  8023a3:	31 d2                	xor    %edx,%edx
  8023a5:	f7 f3                	div    %ebx
  8023a7:	89 c1                	mov    %eax,%ecx
  8023a9:	31 d2                	xor    %edx,%edx
  8023ab:	89 f0                	mov    %esi,%eax
  8023ad:	f7 f1                	div    %ecx
  8023af:	89 c6                	mov    %eax,%esi
  8023b1:	89 e8                	mov    %ebp,%eax
  8023b3:	89 f7                	mov    %esi,%edi
  8023b5:	f7 f1                	div    %ecx
  8023b7:	89 fa                	mov    %edi,%edx
  8023b9:	83 c4 1c             	add    $0x1c,%esp
  8023bc:	5b                   	pop    %ebx
  8023bd:	5e                   	pop    %esi
  8023be:	5f                   	pop    %edi
  8023bf:	5d                   	pop    %ebp
  8023c0:	c3                   	ret    
  8023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023c8:	39 f2                	cmp    %esi,%edx
  8023ca:	77 1c                	ja     8023e8 <__udivdi3+0x88>
  8023cc:	0f bd fa             	bsr    %edx,%edi
  8023cf:	83 f7 1f             	xor    $0x1f,%edi
  8023d2:	75 2c                	jne    802400 <__udivdi3+0xa0>
  8023d4:	39 f2                	cmp    %esi,%edx
  8023d6:	72 06                	jb     8023de <__udivdi3+0x7e>
  8023d8:	31 c0                	xor    %eax,%eax
  8023da:	39 eb                	cmp    %ebp,%ebx
  8023dc:	77 a9                	ja     802387 <__udivdi3+0x27>
  8023de:	b8 01 00 00 00       	mov    $0x1,%eax
  8023e3:	eb a2                	jmp    802387 <__udivdi3+0x27>
  8023e5:	8d 76 00             	lea    0x0(%esi),%esi
  8023e8:	31 ff                	xor    %edi,%edi
  8023ea:	31 c0                	xor    %eax,%eax
  8023ec:	89 fa                	mov    %edi,%edx
  8023ee:	83 c4 1c             	add    $0x1c,%esp
  8023f1:	5b                   	pop    %ebx
  8023f2:	5e                   	pop    %esi
  8023f3:	5f                   	pop    %edi
  8023f4:	5d                   	pop    %ebp
  8023f5:	c3                   	ret    
  8023f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023fd:	8d 76 00             	lea    0x0(%esi),%esi
  802400:	89 f9                	mov    %edi,%ecx
  802402:	b8 20 00 00 00       	mov    $0x20,%eax
  802407:	29 f8                	sub    %edi,%eax
  802409:	d3 e2                	shl    %cl,%edx
  80240b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80240f:	89 c1                	mov    %eax,%ecx
  802411:	89 da                	mov    %ebx,%edx
  802413:	d3 ea                	shr    %cl,%edx
  802415:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802419:	09 d1                	or     %edx,%ecx
  80241b:	89 f2                	mov    %esi,%edx
  80241d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802421:	89 f9                	mov    %edi,%ecx
  802423:	d3 e3                	shl    %cl,%ebx
  802425:	89 c1                	mov    %eax,%ecx
  802427:	d3 ea                	shr    %cl,%edx
  802429:	89 f9                	mov    %edi,%ecx
  80242b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80242f:	89 eb                	mov    %ebp,%ebx
  802431:	d3 e6                	shl    %cl,%esi
  802433:	89 c1                	mov    %eax,%ecx
  802435:	d3 eb                	shr    %cl,%ebx
  802437:	09 de                	or     %ebx,%esi
  802439:	89 f0                	mov    %esi,%eax
  80243b:	f7 74 24 08          	divl   0x8(%esp)
  80243f:	89 d6                	mov    %edx,%esi
  802441:	89 c3                	mov    %eax,%ebx
  802443:	f7 64 24 0c          	mull   0xc(%esp)
  802447:	39 d6                	cmp    %edx,%esi
  802449:	72 15                	jb     802460 <__udivdi3+0x100>
  80244b:	89 f9                	mov    %edi,%ecx
  80244d:	d3 e5                	shl    %cl,%ebp
  80244f:	39 c5                	cmp    %eax,%ebp
  802451:	73 04                	jae    802457 <__udivdi3+0xf7>
  802453:	39 d6                	cmp    %edx,%esi
  802455:	74 09                	je     802460 <__udivdi3+0x100>
  802457:	89 d8                	mov    %ebx,%eax
  802459:	31 ff                	xor    %edi,%edi
  80245b:	e9 27 ff ff ff       	jmp    802387 <__udivdi3+0x27>
  802460:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802463:	31 ff                	xor    %edi,%edi
  802465:	e9 1d ff ff ff       	jmp    802387 <__udivdi3+0x27>
  80246a:	66 90                	xchg   %ax,%ax
  80246c:	66 90                	xchg   %ax,%ax
  80246e:	66 90                	xchg   %ax,%ax

00802470 <__umoddi3>:
  802470:	55                   	push   %ebp
  802471:	57                   	push   %edi
  802472:	56                   	push   %esi
  802473:	53                   	push   %ebx
  802474:	83 ec 1c             	sub    $0x1c,%esp
  802477:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80247b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80247f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802483:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802487:	89 da                	mov    %ebx,%edx
  802489:	85 c0                	test   %eax,%eax
  80248b:	75 43                	jne    8024d0 <__umoddi3+0x60>
  80248d:	39 df                	cmp    %ebx,%edi
  80248f:	76 17                	jbe    8024a8 <__umoddi3+0x38>
  802491:	89 f0                	mov    %esi,%eax
  802493:	f7 f7                	div    %edi
  802495:	89 d0                	mov    %edx,%eax
  802497:	31 d2                	xor    %edx,%edx
  802499:	83 c4 1c             	add    $0x1c,%esp
  80249c:	5b                   	pop    %ebx
  80249d:	5e                   	pop    %esi
  80249e:	5f                   	pop    %edi
  80249f:	5d                   	pop    %ebp
  8024a0:	c3                   	ret    
  8024a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024a8:	89 fd                	mov    %edi,%ebp
  8024aa:	85 ff                	test   %edi,%edi
  8024ac:	75 0b                	jne    8024b9 <__umoddi3+0x49>
  8024ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8024b3:	31 d2                	xor    %edx,%edx
  8024b5:	f7 f7                	div    %edi
  8024b7:	89 c5                	mov    %eax,%ebp
  8024b9:	89 d8                	mov    %ebx,%eax
  8024bb:	31 d2                	xor    %edx,%edx
  8024bd:	f7 f5                	div    %ebp
  8024bf:	89 f0                	mov    %esi,%eax
  8024c1:	f7 f5                	div    %ebp
  8024c3:	89 d0                	mov    %edx,%eax
  8024c5:	eb d0                	jmp    802497 <__umoddi3+0x27>
  8024c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024ce:	66 90                	xchg   %ax,%ax
  8024d0:	89 f1                	mov    %esi,%ecx
  8024d2:	39 d8                	cmp    %ebx,%eax
  8024d4:	76 0a                	jbe    8024e0 <__umoddi3+0x70>
  8024d6:	89 f0                	mov    %esi,%eax
  8024d8:	83 c4 1c             	add    $0x1c,%esp
  8024db:	5b                   	pop    %ebx
  8024dc:	5e                   	pop    %esi
  8024dd:	5f                   	pop    %edi
  8024de:	5d                   	pop    %ebp
  8024df:	c3                   	ret    
  8024e0:	0f bd e8             	bsr    %eax,%ebp
  8024e3:	83 f5 1f             	xor    $0x1f,%ebp
  8024e6:	75 20                	jne    802508 <__umoddi3+0x98>
  8024e8:	39 d8                	cmp    %ebx,%eax
  8024ea:	0f 82 b0 00 00 00    	jb     8025a0 <__umoddi3+0x130>
  8024f0:	39 f7                	cmp    %esi,%edi
  8024f2:	0f 86 a8 00 00 00    	jbe    8025a0 <__umoddi3+0x130>
  8024f8:	89 c8                	mov    %ecx,%eax
  8024fa:	83 c4 1c             	add    $0x1c,%esp
  8024fd:	5b                   	pop    %ebx
  8024fe:	5e                   	pop    %esi
  8024ff:	5f                   	pop    %edi
  802500:	5d                   	pop    %ebp
  802501:	c3                   	ret    
  802502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802508:	89 e9                	mov    %ebp,%ecx
  80250a:	ba 20 00 00 00       	mov    $0x20,%edx
  80250f:	29 ea                	sub    %ebp,%edx
  802511:	d3 e0                	shl    %cl,%eax
  802513:	89 44 24 08          	mov    %eax,0x8(%esp)
  802517:	89 d1                	mov    %edx,%ecx
  802519:	89 f8                	mov    %edi,%eax
  80251b:	d3 e8                	shr    %cl,%eax
  80251d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802521:	89 54 24 04          	mov    %edx,0x4(%esp)
  802525:	8b 54 24 04          	mov    0x4(%esp),%edx
  802529:	09 c1                	or     %eax,%ecx
  80252b:	89 d8                	mov    %ebx,%eax
  80252d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802531:	89 e9                	mov    %ebp,%ecx
  802533:	d3 e7                	shl    %cl,%edi
  802535:	89 d1                	mov    %edx,%ecx
  802537:	d3 e8                	shr    %cl,%eax
  802539:	89 e9                	mov    %ebp,%ecx
  80253b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80253f:	d3 e3                	shl    %cl,%ebx
  802541:	89 c7                	mov    %eax,%edi
  802543:	89 d1                	mov    %edx,%ecx
  802545:	89 f0                	mov    %esi,%eax
  802547:	d3 e8                	shr    %cl,%eax
  802549:	89 e9                	mov    %ebp,%ecx
  80254b:	89 fa                	mov    %edi,%edx
  80254d:	d3 e6                	shl    %cl,%esi
  80254f:	09 d8                	or     %ebx,%eax
  802551:	f7 74 24 08          	divl   0x8(%esp)
  802555:	89 d1                	mov    %edx,%ecx
  802557:	89 f3                	mov    %esi,%ebx
  802559:	f7 64 24 0c          	mull   0xc(%esp)
  80255d:	89 c6                	mov    %eax,%esi
  80255f:	89 d7                	mov    %edx,%edi
  802561:	39 d1                	cmp    %edx,%ecx
  802563:	72 06                	jb     80256b <__umoddi3+0xfb>
  802565:	75 10                	jne    802577 <__umoddi3+0x107>
  802567:	39 c3                	cmp    %eax,%ebx
  802569:	73 0c                	jae    802577 <__umoddi3+0x107>
  80256b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80256f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802573:	89 d7                	mov    %edx,%edi
  802575:	89 c6                	mov    %eax,%esi
  802577:	89 ca                	mov    %ecx,%edx
  802579:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80257e:	29 f3                	sub    %esi,%ebx
  802580:	19 fa                	sbb    %edi,%edx
  802582:	89 d0                	mov    %edx,%eax
  802584:	d3 e0                	shl    %cl,%eax
  802586:	89 e9                	mov    %ebp,%ecx
  802588:	d3 eb                	shr    %cl,%ebx
  80258a:	d3 ea                	shr    %cl,%edx
  80258c:	09 d8                	or     %ebx,%eax
  80258e:	83 c4 1c             	add    $0x1c,%esp
  802591:	5b                   	pop    %ebx
  802592:	5e                   	pop    %esi
  802593:	5f                   	pop    %edi
  802594:	5d                   	pop    %ebp
  802595:	c3                   	ret    
  802596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80259d:	8d 76 00             	lea    0x0(%esi),%esi
  8025a0:	89 da                	mov    %ebx,%edx
  8025a2:	29 fe                	sub    %edi,%esi
  8025a4:	19 c2                	sbb    %eax,%edx
  8025a6:	89 f1                	mov    %esi,%ecx
  8025a8:	89 c8                	mov    %ecx,%eax
  8025aa:	e9 4b ff ff ff       	jmp    8024fa <__umoddi3+0x8a>
