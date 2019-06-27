
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
  800043:	e8 df 01 00 00       	call   800227 <cprintf>

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
  800067:	e8 bb 01 00 00       	call   800227 <cprintf>
}
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	c9                   	leave  
  800070:	c3                   	ret    
		cprintf("eflags wrong\n");
  800071:	83 ec 0c             	sub    $0xc,%esp
  800074:	68 d1 25 80 00       	push   $0x8025d1
  800079:	e8 a9 01 00 00       	call   800227 <cprintf>
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
  800096:	e8 9f 0c 00 00       	call   800d3a <sys_getenvid>
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
  8000bb:	74 23                	je     8000e0 <libmain+0x5d>
		if(envs[i].env_id == find)
  8000bd:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  8000c3:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000c9:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000cc:	39 c1                	cmp    %eax,%ecx
  8000ce:	75 e2                	jne    8000b2 <libmain+0x2f>
  8000d0:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  8000d6:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000dc:	89 fe                	mov    %edi,%esi
  8000de:	eb d2                	jmp    8000b2 <libmain+0x2f>
  8000e0:	89 f0                	mov    %esi,%eax
  8000e2:	84 c0                	test   %al,%al
  8000e4:	74 06                	je     8000ec <libmain+0x69>
  8000e6:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000f0:	7e 0a                	jle    8000fc <libmain+0x79>
		binaryname = argv[0];
  8000f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000f5:	8b 00                	mov    (%eax),%eax
  8000f7:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8000fc:	a1 08 40 80 00       	mov    0x804008,%eax
  800101:	8b 40 48             	mov    0x48(%eax),%eax
  800104:	83 ec 08             	sub    $0x8,%esp
  800107:	50                   	push   %eax
  800108:	68 02 26 80 00       	push   $0x802602
  80010d:	e8 15 01 00 00       	call   800227 <cprintf>
	cprintf("before umain\n");
  800112:	c7 04 24 20 26 80 00 	movl   $0x802620,(%esp)
  800119:	e8 09 01 00 00       	call   800227 <cprintf>
	// call user main routine
	umain(argc, argv);
  80011e:	83 c4 08             	add    $0x8,%esp
  800121:	ff 75 0c             	pushl  0xc(%ebp)
  800124:	ff 75 08             	pushl  0x8(%ebp)
  800127:	e8 07 ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  80012c:	c7 04 24 2e 26 80 00 	movl   $0x80262e,(%esp)
  800133:	e8 ef 00 00 00       	call   800227 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800138:	a1 08 40 80 00       	mov    0x804008,%eax
  80013d:	8b 40 48             	mov    0x48(%eax),%eax
  800140:	83 c4 08             	add    $0x8,%esp
  800143:	50                   	push   %eax
  800144:	68 3b 26 80 00       	push   $0x80263b
  800149:	e8 d9 00 00 00       	call   800227 <cprintf>
	// exit gracefully
	exit();
  80014e:	e8 0b 00 00 00       	call   80015e <exit>
}
  800153:	83 c4 10             	add    $0x10,%esp
  800156:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800159:	5b                   	pop    %ebx
  80015a:	5e                   	pop    %esi
  80015b:	5f                   	pop    %edi
  80015c:	5d                   	pop    %ebp
  80015d:	c3                   	ret    

0080015e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80015e:	55                   	push   %ebp
  80015f:	89 e5                	mov    %esp,%ebp
  800161:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800164:	a1 08 40 80 00       	mov    0x804008,%eax
  800169:	8b 40 48             	mov    0x48(%eax),%eax
  80016c:	68 68 26 80 00       	push   $0x802668
  800171:	50                   	push   %eax
  800172:	68 5a 26 80 00       	push   $0x80265a
  800177:	e8 ab 00 00 00       	call   800227 <cprintf>
	close_all();
  80017c:	e8 c4 10 00 00       	call   801245 <close_all>
	sys_env_destroy(0);
  800181:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800188:	e8 6c 0b 00 00       	call   800cf9 <sys_env_destroy>
}
  80018d:	83 c4 10             	add    $0x10,%esp
  800190:	c9                   	leave  
  800191:	c3                   	ret    

00800192 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	53                   	push   %ebx
  800196:	83 ec 04             	sub    $0x4,%esp
  800199:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80019c:	8b 13                	mov    (%ebx),%edx
  80019e:	8d 42 01             	lea    0x1(%edx),%eax
  8001a1:	89 03                	mov    %eax,(%ebx)
  8001a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001a6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001aa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001af:	74 09                	je     8001ba <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001b1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001b8:	c9                   	leave  
  8001b9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001ba:	83 ec 08             	sub    $0x8,%esp
  8001bd:	68 ff 00 00 00       	push   $0xff
  8001c2:	8d 43 08             	lea    0x8(%ebx),%eax
  8001c5:	50                   	push   %eax
  8001c6:	e8 f1 0a 00 00       	call   800cbc <sys_cputs>
		b->idx = 0;
  8001cb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001d1:	83 c4 10             	add    $0x10,%esp
  8001d4:	eb db                	jmp    8001b1 <putch+0x1f>

008001d6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001d6:	55                   	push   %ebp
  8001d7:	89 e5                	mov    %esp,%ebp
  8001d9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001df:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001e6:	00 00 00 
	b.cnt = 0;
  8001e9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001f0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001f3:	ff 75 0c             	pushl  0xc(%ebp)
  8001f6:	ff 75 08             	pushl  0x8(%ebp)
  8001f9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001ff:	50                   	push   %eax
  800200:	68 92 01 80 00       	push   $0x800192
  800205:	e8 4a 01 00 00       	call   800354 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80020a:	83 c4 08             	add    $0x8,%esp
  80020d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800213:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800219:	50                   	push   %eax
  80021a:	e8 9d 0a 00 00       	call   800cbc <sys_cputs>

	return b.cnt;
}
  80021f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800225:	c9                   	leave  
  800226:	c3                   	ret    

00800227 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800227:	55                   	push   %ebp
  800228:	89 e5                	mov    %esp,%ebp
  80022a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80022d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800230:	50                   	push   %eax
  800231:	ff 75 08             	pushl  0x8(%ebp)
  800234:	e8 9d ff ff ff       	call   8001d6 <vcprintf>
	va_end(ap);

	return cnt;
}
  800239:	c9                   	leave  
  80023a:	c3                   	ret    

0080023b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80023b:	55                   	push   %ebp
  80023c:	89 e5                	mov    %esp,%ebp
  80023e:	57                   	push   %edi
  80023f:	56                   	push   %esi
  800240:	53                   	push   %ebx
  800241:	83 ec 1c             	sub    $0x1c,%esp
  800244:	89 c6                	mov    %eax,%esi
  800246:	89 d7                	mov    %edx,%edi
  800248:	8b 45 08             	mov    0x8(%ebp),%eax
  80024b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80024e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800251:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800254:	8b 45 10             	mov    0x10(%ebp),%eax
  800257:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80025a:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80025e:	74 2c                	je     80028c <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800260:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800263:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80026a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80026d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800270:	39 c2                	cmp    %eax,%edx
  800272:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800275:	73 43                	jae    8002ba <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800277:	83 eb 01             	sub    $0x1,%ebx
  80027a:	85 db                	test   %ebx,%ebx
  80027c:	7e 6c                	jle    8002ea <printnum+0xaf>
				putch(padc, putdat);
  80027e:	83 ec 08             	sub    $0x8,%esp
  800281:	57                   	push   %edi
  800282:	ff 75 18             	pushl  0x18(%ebp)
  800285:	ff d6                	call   *%esi
  800287:	83 c4 10             	add    $0x10,%esp
  80028a:	eb eb                	jmp    800277 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 20                	push   $0x20
  800291:	6a 00                	push   $0x0
  800293:	50                   	push   %eax
  800294:	ff 75 e4             	pushl  -0x1c(%ebp)
  800297:	ff 75 e0             	pushl  -0x20(%ebp)
  80029a:	89 fa                	mov    %edi,%edx
  80029c:	89 f0                	mov    %esi,%eax
  80029e:	e8 98 ff ff ff       	call   80023b <printnum>
		while (--width > 0)
  8002a3:	83 c4 20             	add    $0x20,%esp
  8002a6:	83 eb 01             	sub    $0x1,%ebx
  8002a9:	85 db                	test   %ebx,%ebx
  8002ab:	7e 65                	jle    800312 <printnum+0xd7>
			putch(padc, putdat);
  8002ad:	83 ec 08             	sub    $0x8,%esp
  8002b0:	57                   	push   %edi
  8002b1:	6a 20                	push   $0x20
  8002b3:	ff d6                	call   *%esi
  8002b5:	83 c4 10             	add    $0x10,%esp
  8002b8:	eb ec                	jmp    8002a6 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002ba:	83 ec 0c             	sub    $0xc,%esp
  8002bd:	ff 75 18             	pushl  0x18(%ebp)
  8002c0:	83 eb 01             	sub    $0x1,%ebx
  8002c3:	53                   	push   %ebx
  8002c4:	50                   	push   %eax
  8002c5:	83 ec 08             	sub    $0x8,%esp
  8002c8:	ff 75 dc             	pushl  -0x24(%ebp)
  8002cb:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d1:	ff 75 e0             	pushl  -0x20(%ebp)
  8002d4:	e8 87 20 00 00       	call   802360 <__udivdi3>
  8002d9:	83 c4 18             	add    $0x18,%esp
  8002dc:	52                   	push   %edx
  8002dd:	50                   	push   %eax
  8002de:	89 fa                	mov    %edi,%edx
  8002e0:	89 f0                	mov    %esi,%eax
  8002e2:	e8 54 ff ff ff       	call   80023b <printnum>
  8002e7:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002ea:	83 ec 08             	sub    $0x8,%esp
  8002ed:	57                   	push   %edi
  8002ee:	83 ec 04             	sub    $0x4,%esp
  8002f1:	ff 75 dc             	pushl  -0x24(%ebp)
  8002f4:	ff 75 d8             	pushl  -0x28(%ebp)
  8002f7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8002fd:	e8 6e 21 00 00       	call   802470 <__umoddi3>
  800302:	83 c4 14             	add    $0x14,%esp
  800305:	0f be 80 6d 26 80 00 	movsbl 0x80266d(%eax),%eax
  80030c:	50                   	push   %eax
  80030d:	ff d6                	call   *%esi
  80030f:	83 c4 10             	add    $0x10,%esp
	}
}
  800312:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800315:	5b                   	pop    %ebx
  800316:	5e                   	pop    %esi
  800317:	5f                   	pop    %edi
  800318:	5d                   	pop    %ebp
  800319:	c3                   	ret    

0080031a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80031a:	55                   	push   %ebp
  80031b:	89 e5                	mov    %esp,%ebp
  80031d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800320:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800324:	8b 10                	mov    (%eax),%edx
  800326:	3b 50 04             	cmp    0x4(%eax),%edx
  800329:	73 0a                	jae    800335 <sprintputch+0x1b>
		*b->buf++ = ch;
  80032b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80032e:	89 08                	mov    %ecx,(%eax)
  800330:	8b 45 08             	mov    0x8(%ebp),%eax
  800333:	88 02                	mov    %al,(%edx)
}
  800335:	5d                   	pop    %ebp
  800336:	c3                   	ret    

00800337 <printfmt>:
{
  800337:	55                   	push   %ebp
  800338:	89 e5                	mov    %esp,%ebp
  80033a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80033d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800340:	50                   	push   %eax
  800341:	ff 75 10             	pushl  0x10(%ebp)
  800344:	ff 75 0c             	pushl  0xc(%ebp)
  800347:	ff 75 08             	pushl  0x8(%ebp)
  80034a:	e8 05 00 00 00       	call   800354 <vprintfmt>
}
  80034f:	83 c4 10             	add    $0x10,%esp
  800352:	c9                   	leave  
  800353:	c3                   	ret    

00800354 <vprintfmt>:
{
  800354:	55                   	push   %ebp
  800355:	89 e5                	mov    %esp,%ebp
  800357:	57                   	push   %edi
  800358:	56                   	push   %esi
  800359:	53                   	push   %ebx
  80035a:	83 ec 3c             	sub    $0x3c,%esp
  80035d:	8b 75 08             	mov    0x8(%ebp),%esi
  800360:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800363:	8b 7d 10             	mov    0x10(%ebp),%edi
  800366:	e9 32 04 00 00       	jmp    80079d <vprintfmt+0x449>
		padc = ' ';
  80036b:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80036f:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800376:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80037d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800384:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80038b:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800392:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800397:	8d 47 01             	lea    0x1(%edi),%eax
  80039a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80039d:	0f b6 17             	movzbl (%edi),%edx
  8003a0:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003a3:	3c 55                	cmp    $0x55,%al
  8003a5:	0f 87 12 05 00 00    	ja     8008bd <vprintfmt+0x569>
  8003ab:	0f b6 c0             	movzbl %al,%eax
  8003ae:	ff 24 85 40 28 80 00 	jmp    *0x802840(,%eax,4)
  8003b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003b8:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003bc:	eb d9                	jmp    800397 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003c1:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003c5:	eb d0                	jmp    800397 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003c7:	0f b6 d2             	movzbl %dl,%edx
  8003ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d2:	89 75 08             	mov    %esi,0x8(%ebp)
  8003d5:	eb 03                	jmp    8003da <vprintfmt+0x86>
  8003d7:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003da:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003dd:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003e1:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003e4:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003e7:	83 fe 09             	cmp    $0x9,%esi
  8003ea:	76 eb                	jbe    8003d7 <vprintfmt+0x83>
  8003ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ef:	8b 75 08             	mov    0x8(%ebp),%esi
  8003f2:	eb 14                	jmp    800408 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f7:	8b 00                	mov    (%eax),%eax
  8003f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ff:	8d 40 04             	lea    0x4(%eax),%eax
  800402:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800405:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800408:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80040c:	79 89                	jns    800397 <vprintfmt+0x43>
				width = precision, precision = -1;
  80040e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800411:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800414:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80041b:	e9 77 ff ff ff       	jmp    800397 <vprintfmt+0x43>
  800420:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800423:	85 c0                	test   %eax,%eax
  800425:	0f 48 c1             	cmovs  %ecx,%eax
  800428:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80042b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80042e:	e9 64 ff ff ff       	jmp    800397 <vprintfmt+0x43>
  800433:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800436:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80043d:	e9 55 ff ff ff       	jmp    800397 <vprintfmt+0x43>
			lflag++;
  800442:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800446:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800449:	e9 49 ff ff ff       	jmp    800397 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80044e:	8b 45 14             	mov    0x14(%ebp),%eax
  800451:	8d 78 04             	lea    0x4(%eax),%edi
  800454:	83 ec 08             	sub    $0x8,%esp
  800457:	53                   	push   %ebx
  800458:	ff 30                	pushl  (%eax)
  80045a:	ff d6                	call   *%esi
			break;
  80045c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80045f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800462:	e9 33 03 00 00       	jmp    80079a <vprintfmt+0x446>
			err = va_arg(ap, int);
  800467:	8b 45 14             	mov    0x14(%ebp),%eax
  80046a:	8d 78 04             	lea    0x4(%eax),%edi
  80046d:	8b 00                	mov    (%eax),%eax
  80046f:	99                   	cltd   
  800470:	31 d0                	xor    %edx,%eax
  800472:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800474:	83 f8 11             	cmp    $0x11,%eax
  800477:	7f 23                	jg     80049c <vprintfmt+0x148>
  800479:	8b 14 85 a0 29 80 00 	mov    0x8029a0(,%eax,4),%edx
  800480:	85 d2                	test   %edx,%edx
  800482:	74 18                	je     80049c <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800484:	52                   	push   %edx
  800485:	68 bd 2a 80 00       	push   $0x802abd
  80048a:	53                   	push   %ebx
  80048b:	56                   	push   %esi
  80048c:	e8 a6 fe ff ff       	call   800337 <printfmt>
  800491:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800494:	89 7d 14             	mov    %edi,0x14(%ebp)
  800497:	e9 fe 02 00 00       	jmp    80079a <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80049c:	50                   	push   %eax
  80049d:	68 85 26 80 00       	push   $0x802685
  8004a2:	53                   	push   %ebx
  8004a3:	56                   	push   %esi
  8004a4:	e8 8e fe ff ff       	call   800337 <printfmt>
  8004a9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004ac:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004af:	e9 e6 02 00 00       	jmp    80079a <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b7:	83 c0 04             	add    $0x4,%eax
  8004ba:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c0:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004c2:	85 c9                	test   %ecx,%ecx
  8004c4:	b8 7e 26 80 00       	mov    $0x80267e,%eax
  8004c9:	0f 45 c1             	cmovne %ecx,%eax
  8004cc:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004d3:	7e 06                	jle    8004db <vprintfmt+0x187>
  8004d5:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004d9:	75 0d                	jne    8004e8 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004db:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004de:	89 c7                	mov    %eax,%edi
  8004e0:	03 45 e0             	add    -0x20(%ebp),%eax
  8004e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004e6:	eb 53                	jmp    80053b <vprintfmt+0x1e7>
  8004e8:	83 ec 08             	sub    $0x8,%esp
  8004eb:	ff 75 d8             	pushl  -0x28(%ebp)
  8004ee:	50                   	push   %eax
  8004ef:	e8 71 04 00 00       	call   800965 <strnlen>
  8004f4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004f7:	29 c1                	sub    %eax,%ecx
  8004f9:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004fc:	83 c4 10             	add    $0x10,%esp
  8004ff:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800501:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800505:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800508:	eb 0f                	jmp    800519 <vprintfmt+0x1c5>
					putch(padc, putdat);
  80050a:	83 ec 08             	sub    $0x8,%esp
  80050d:	53                   	push   %ebx
  80050e:	ff 75 e0             	pushl  -0x20(%ebp)
  800511:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800513:	83 ef 01             	sub    $0x1,%edi
  800516:	83 c4 10             	add    $0x10,%esp
  800519:	85 ff                	test   %edi,%edi
  80051b:	7f ed                	jg     80050a <vprintfmt+0x1b6>
  80051d:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800520:	85 c9                	test   %ecx,%ecx
  800522:	b8 00 00 00 00       	mov    $0x0,%eax
  800527:	0f 49 c1             	cmovns %ecx,%eax
  80052a:	29 c1                	sub    %eax,%ecx
  80052c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80052f:	eb aa                	jmp    8004db <vprintfmt+0x187>
					putch(ch, putdat);
  800531:	83 ec 08             	sub    $0x8,%esp
  800534:	53                   	push   %ebx
  800535:	52                   	push   %edx
  800536:	ff d6                	call   *%esi
  800538:	83 c4 10             	add    $0x10,%esp
  80053b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80053e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800540:	83 c7 01             	add    $0x1,%edi
  800543:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800547:	0f be d0             	movsbl %al,%edx
  80054a:	85 d2                	test   %edx,%edx
  80054c:	74 4b                	je     800599 <vprintfmt+0x245>
  80054e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800552:	78 06                	js     80055a <vprintfmt+0x206>
  800554:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800558:	78 1e                	js     800578 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80055a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80055e:	74 d1                	je     800531 <vprintfmt+0x1dd>
  800560:	0f be c0             	movsbl %al,%eax
  800563:	83 e8 20             	sub    $0x20,%eax
  800566:	83 f8 5e             	cmp    $0x5e,%eax
  800569:	76 c6                	jbe    800531 <vprintfmt+0x1dd>
					putch('?', putdat);
  80056b:	83 ec 08             	sub    $0x8,%esp
  80056e:	53                   	push   %ebx
  80056f:	6a 3f                	push   $0x3f
  800571:	ff d6                	call   *%esi
  800573:	83 c4 10             	add    $0x10,%esp
  800576:	eb c3                	jmp    80053b <vprintfmt+0x1e7>
  800578:	89 cf                	mov    %ecx,%edi
  80057a:	eb 0e                	jmp    80058a <vprintfmt+0x236>
				putch(' ', putdat);
  80057c:	83 ec 08             	sub    $0x8,%esp
  80057f:	53                   	push   %ebx
  800580:	6a 20                	push   $0x20
  800582:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800584:	83 ef 01             	sub    $0x1,%edi
  800587:	83 c4 10             	add    $0x10,%esp
  80058a:	85 ff                	test   %edi,%edi
  80058c:	7f ee                	jg     80057c <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80058e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800591:	89 45 14             	mov    %eax,0x14(%ebp)
  800594:	e9 01 02 00 00       	jmp    80079a <vprintfmt+0x446>
  800599:	89 cf                	mov    %ecx,%edi
  80059b:	eb ed                	jmp    80058a <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80059d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005a0:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005a7:	e9 eb fd ff ff       	jmp    800397 <vprintfmt+0x43>
	if (lflag >= 2)
  8005ac:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005b0:	7f 21                	jg     8005d3 <vprintfmt+0x27f>
	else if (lflag)
  8005b2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005b6:	74 68                	je     800620 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bb:	8b 00                	mov    (%eax),%eax
  8005bd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005c0:	89 c1                	mov    %eax,%ecx
  8005c2:	c1 f9 1f             	sar    $0x1f,%ecx
  8005c5:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cb:	8d 40 04             	lea    0x4(%eax),%eax
  8005ce:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d1:	eb 17                	jmp    8005ea <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	8b 50 04             	mov    0x4(%eax),%edx
  8005d9:	8b 00                	mov    (%eax),%eax
  8005db:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005de:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e4:	8d 40 08             	lea    0x8(%eax),%eax
  8005e7:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005ea:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005ed:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f3:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005f6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005fa:	78 3f                	js     80063b <vprintfmt+0x2e7>
			base = 10;
  8005fc:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800601:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800605:	0f 84 71 01 00 00    	je     80077c <vprintfmt+0x428>
				putch('+', putdat);
  80060b:	83 ec 08             	sub    $0x8,%esp
  80060e:	53                   	push   %ebx
  80060f:	6a 2b                	push   $0x2b
  800611:	ff d6                	call   *%esi
  800613:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800616:	b8 0a 00 00 00       	mov    $0xa,%eax
  80061b:	e9 5c 01 00 00       	jmp    80077c <vprintfmt+0x428>
		return va_arg(*ap, int);
  800620:	8b 45 14             	mov    0x14(%ebp),%eax
  800623:	8b 00                	mov    (%eax),%eax
  800625:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800628:	89 c1                	mov    %eax,%ecx
  80062a:	c1 f9 1f             	sar    $0x1f,%ecx
  80062d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800630:	8b 45 14             	mov    0x14(%ebp),%eax
  800633:	8d 40 04             	lea    0x4(%eax),%eax
  800636:	89 45 14             	mov    %eax,0x14(%ebp)
  800639:	eb af                	jmp    8005ea <vprintfmt+0x296>
				putch('-', putdat);
  80063b:	83 ec 08             	sub    $0x8,%esp
  80063e:	53                   	push   %ebx
  80063f:	6a 2d                	push   $0x2d
  800641:	ff d6                	call   *%esi
				num = -(long long) num;
  800643:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800646:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800649:	f7 d8                	neg    %eax
  80064b:	83 d2 00             	adc    $0x0,%edx
  80064e:	f7 da                	neg    %edx
  800650:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800653:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800656:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800659:	b8 0a 00 00 00       	mov    $0xa,%eax
  80065e:	e9 19 01 00 00       	jmp    80077c <vprintfmt+0x428>
	if (lflag >= 2)
  800663:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800667:	7f 29                	jg     800692 <vprintfmt+0x33e>
	else if (lflag)
  800669:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80066d:	74 44                	je     8006b3 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80066f:	8b 45 14             	mov    0x14(%ebp),%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	ba 00 00 00 00       	mov    $0x0,%edx
  800679:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8d 40 04             	lea    0x4(%eax),%eax
  800685:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800688:	b8 0a 00 00 00       	mov    $0xa,%eax
  80068d:	e9 ea 00 00 00       	jmp    80077c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	8b 50 04             	mov    0x4(%eax),%edx
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	8d 40 08             	lea    0x8(%eax),%eax
  8006a6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006a9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ae:	e9 c9 00 00 00       	jmp    80077c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	8d 40 04             	lea    0x4(%eax),%eax
  8006c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006cc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d1:	e9 a6 00 00 00       	jmp    80077c <vprintfmt+0x428>
			putch('0', putdat);
  8006d6:	83 ec 08             	sub    $0x8,%esp
  8006d9:	53                   	push   %ebx
  8006da:	6a 30                	push   $0x30
  8006dc:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006de:	83 c4 10             	add    $0x10,%esp
  8006e1:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006e5:	7f 26                	jg     80070d <vprintfmt+0x3b9>
	else if (lflag)
  8006e7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006eb:	74 3e                	je     80072b <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	8d 40 04             	lea    0x4(%eax),%eax
  800703:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800706:	b8 08 00 00 00       	mov    $0x8,%eax
  80070b:	eb 6f                	jmp    80077c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80070d:	8b 45 14             	mov    0x14(%ebp),%eax
  800710:	8b 50 04             	mov    0x4(%eax),%edx
  800713:	8b 00                	mov    (%eax),%eax
  800715:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800718:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80071b:	8b 45 14             	mov    0x14(%ebp),%eax
  80071e:	8d 40 08             	lea    0x8(%eax),%eax
  800721:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800724:	b8 08 00 00 00       	mov    $0x8,%eax
  800729:	eb 51                	jmp    80077c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80072b:	8b 45 14             	mov    0x14(%ebp),%eax
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	ba 00 00 00 00       	mov    $0x0,%edx
  800735:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800738:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073b:	8b 45 14             	mov    0x14(%ebp),%eax
  80073e:	8d 40 04             	lea    0x4(%eax),%eax
  800741:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800744:	b8 08 00 00 00       	mov    $0x8,%eax
  800749:	eb 31                	jmp    80077c <vprintfmt+0x428>
			putch('0', putdat);
  80074b:	83 ec 08             	sub    $0x8,%esp
  80074e:	53                   	push   %ebx
  80074f:	6a 30                	push   $0x30
  800751:	ff d6                	call   *%esi
			putch('x', putdat);
  800753:	83 c4 08             	add    $0x8,%esp
  800756:	53                   	push   %ebx
  800757:	6a 78                	push   $0x78
  800759:	ff d6                	call   *%esi
			num = (unsigned long long)
  80075b:	8b 45 14             	mov    0x14(%ebp),%eax
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	ba 00 00 00 00       	mov    $0x0,%edx
  800765:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800768:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80076b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80076e:	8b 45 14             	mov    0x14(%ebp),%eax
  800771:	8d 40 04             	lea    0x4(%eax),%eax
  800774:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800777:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80077c:	83 ec 0c             	sub    $0xc,%esp
  80077f:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800783:	52                   	push   %edx
  800784:	ff 75 e0             	pushl  -0x20(%ebp)
  800787:	50                   	push   %eax
  800788:	ff 75 dc             	pushl  -0x24(%ebp)
  80078b:	ff 75 d8             	pushl  -0x28(%ebp)
  80078e:	89 da                	mov    %ebx,%edx
  800790:	89 f0                	mov    %esi,%eax
  800792:	e8 a4 fa ff ff       	call   80023b <printnum>
			break;
  800797:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80079a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80079d:	83 c7 01             	add    $0x1,%edi
  8007a0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007a4:	83 f8 25             	cmp    $0x25,%eax
  8007a7:	0f 84 be fb ff ff    	je     80036b <vprintfmt+0x17>
			if (ch == '\0')
  8007ad:	85 c0                	test   %eax,%eax
  8007af:	0f 84 28 01 00 00    	je     8008dd <vprintfmt+0x589>
			putch(ch, putdat);
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	53                   	push   %ebx
  8007b9:	50                   	push   %eax
  8007ba:	ff d6                	call   *%esi
  8007bc:	83 c4 10             	add    $0x10,%esp
  8007bf:	eb dc                	jmp    80079d <vprintfmt+0x449>
	if (lflag >= 2)
  8007c1:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007c5:	7f 26                	jg     8007ed <vprintfmt+0x499>
	else if (lflag)
  8007c7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007cb:	74 41                	je     80080e <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007da:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e0:	8d 40 04             	lea    0x4(%eax),%eax
  8007e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e6:	b8 10 00 00 00       	mov    $0x10,%eax
  8007eb:	eb 8f                	jmp    80077c <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f0:	8b 50 04             	mov    0x4(%eax),%edx
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fe:	8d 40 08             	lea    0x8(%eax),%eax
  800801:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800804:	b8 10 00 00 00       	mov    $0x10,%eax
  800809:	e9 6e ff ff ff       	jmp    80077c <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80080e:	8b 45 14             	mov    0x14(%ebp),%eax
  800811:	8b 00                	mov    (%eax),%eax
  800813:	ba 00 00 00 00       	mov    $0x0,%edx
  800818:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80081b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80081e:	8b 45 14             	mov    0x14(%ebp),%eax
  800821:	8d 40 04             	lea    0x4(%eax),%eax
  800824:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800827:	b8 10 00 00 00       	mov    $0x10,%eax
  80082c:	e9 4b ff ff ff       	jmp    80077c <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800831:	8b 45 14             	mov    0x14(%ebp),%eax
  800834:	83 c0 04             	add    $0x4,%eax
  800837:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80083a:	8b 45 14             	mov    0x14(%ebp),%eax
  80083d:	8b 00                	mov    (%eax),%eax
  80083f:	85 c0                	test   %eax,%eax
  800841:	74 14                	je     800857 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800843:	8b 13                	mov    (%ebx),%edx
  800845:	83 fa 7f             	cmp    $0x7f,%edx
  800848:	7f 37                	jg     800881 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80084a:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80084c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80084f:	89 45 14             	mov    %eax,0x14(%ebp)
  800852:	e9 43 ff ff ff       	jmp    80079a <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800857:	b8 0a 00 00 00       	mov    $0xa,%eax
  80085c:	bf a1 27 80 00       	mov    $0x8027a1,%edi
							putch(ch, putdat);
  800861:	83 ec 08             	sub    $0x8,%esp
  800864:	53                   	push   %ebx
  800865:	50                   	push   %eax
  800866:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800868:	83 c7 01             	add    $0x1,%edi
  80086b:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80086f:	83 c4 10             	add    $0x10,%esp
  800872:	85 c0                	test   %eax,%eax
  800874:	75 eb                	jne    800861 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800876:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800879:	89 45 14             	mov    %eax,0x14(%ebp)
  80087c:	e9 19 ff ff ff       	jmp    80079a <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800881:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800883:	b8 0a 00 00 00       	mov    $0xa,%eax
  800888:	bf d9 27 80 00       	mov    $0x8027d9,%edi
							putch(ch, putdat);
  80088d:	83 ec 08             	sub    $0x8,%esp
  800890:	53                   	push   %ebx
  800891:	50                   	push   %eax
  800892:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800894:	83 c7 01             	add    $0x1,%edi
  800897:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80089b:	83 c4 10             	add    $0x10,%esp
  80089e:	85 c0                	test   %eax,%eax
  8008a0:	75 eb                	jne    80088d <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008a5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a8:	e9 ed fe ff ff       	jmp    80079a <vprintfmt+0x446>
			putch(ch, putdat);
  8008ad:	83 ec 08             	sub    $0x8,%esp
  8008b0:	53                   	push   %ebx
  8008b1:	6a 25                	push   $0x25
  8008b3:	ff d6                	call   *%esi
			break;
  8008b5:	83 c4 10             	add    $0x10,%esp
  8008b8:	e9 dd fe ff ff       	jmp    80079a <vprintfmt+0x446>
			putch('%', putdat);
  8008bd:	83 ec 08             	sub    $0x8,%esp
  8008c0:	53                   	push   %ebx
  8008c1:	6a 25                	push   $0x25
  8008c3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008c5:	83 c4 10             	add    $0x10,%esp
  8008c8:	89 f8                	mov    %edi,%eax
  8008ca:	eb 03                	jmp    8008cf <vprintfmt+0x57b>
  8008cc:	83 e8 01             	sub    $0x1,%eax
  8008cf:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008d3:	75 f7                	jne    8008cc <vprintfmt+0x578>
  8008d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008d8:	e9 bd fe ff ff       	jmp    80079a <vprintfmt+0x446>
}
  8008dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008e0:	5b                   	pop    %ebx
  8008e1:	5e                   	pop    %esi
  8008e2:	5f                   	pop    %edi
  8008e3:	5d                   	pop    %ebp
  8008e4:	c3                   	ret    

008008e5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008e5:	55                   	push   %ebp
  8008e6:	89 e5                	mov    %esp,%ebp
  8008e8:	83 ec 18             	sub    $0x18,%esp
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008f4:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008f8:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800902:	85 c0                	test   %eax,%eax
  800904:	74 26                	je     80092c <vsnprintf+0x47>
  800906:	85 d2                	test   %edx,%edx
  800908:	7e 22                	jle    80092c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80090a:	ff 75 14             	pushl  0x14(%ebp)
  80090d:	ff 75 10             	pushl  0x10(%ebp)
  800910:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800913:	50                   	push   %eax
  800914:	68 1a 03 80 00       	push   $0x80031a
  800919:	e8 36 fa ff ff       	call   800354 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80091e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800921:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800927:	83 c4 10             	add    $0x10,%esp
}
  80092a:	c9                   	leave  
  80092b:	c3                   	ret    
		return -E_INVAL;
  80092c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800931:	eb f7                	jmp    80092a <vsnprintf+0x45>

00800933 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800939:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80093c:	50                   	push   %eax
  80093d:	ff 75 10             	pushl  0x10(%ebp)
  800940:	ff 75 0c             	pushl  0xc(%ebp)
  800943:	ff 75 08             	pushl  0x8(%ebp)
  800946:	e8 9a ff ff ff       	call   8008e5 <vsnprintf>
	va_end(ap);

	return rc;
}
  80094b:	c9                   	leave  
  80094c:	c3                   	ret    

0080094d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80094d:	55                   	push   %ebp
  80094e:	89 e5                	mov    %esp,%ebp
  800950:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800953:	b8 00 00 00 00       	mov    $0x0,%eax
  800958:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80095c:	74 05                	je     800963 <strlen+0x16>
		n++;
  80095e:	83 c0 01             	add    $0x1,%eax
  800961:	eb f5                	jmp    800958 <strlen+0xb>
	return n;
}
  800963:	5d                   	pop    %ebp
  800964:	c3                   	ret    

00800965 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800965:	55                   	push   %ebp
  800966:	89 e5                	mov    %esp,%ebp
  800968:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80096b:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80096e:	ba 00 00 00 00       	mov    $0x0,%edx
  800973:	39 c2                	cmp    %eax,%edx
  800975:	74 0d                	je     800984 <strnlen+0x1f>
  800977:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80097b:	74 05                	je     800982 <strnlen+0x1d>
		n++;
  80097d:	83 c2 01             	add    $0x1,%edx
  800980:	eb f1                	jmp    800973 <strnlen+0xe>
  800982:	89 d0                	mov    %edx,%eax
	return n;
}
  800984:	5d                   	pop    %ebp
  800985:	c3                   	ret    

00800986 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800986:	55                   	push   %ebp
  800987:	89 e5                	mov    %esp,%ebp
  800989:	53                   	push   %ebx
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800990:	ba 00 00 00 00       	mov    $0x0,%edx
  800995:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800999:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80099c:	83 c2 01             	add    $0x1,%edx
  80099f:	84 c9                	test   %cl,%cl
  8009a1:	75 f2                	jne    800995 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009a3:	5b                   	pop    %ebx
  8009a4:	5d                   	pop    %ebp
  8009a5:	c3                   	ret    

008009a6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009a6:	55                   	push   %ebp
  8009a7:	89 e5                	mov    %esp,%ebp
  8009a9:	53                   	push   %ebx
  8009aa:	83 ec 10             	sub    $0x10,%esp
  8009ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009b0:	53                   	push   %ebx
  8009b1:	e8 97 ff ff ff       	call   80094d <strlen>
  8009b6:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009b9:	ff 75 0c             	pushl  0xc(%ebp)
  8009bc:	01 d8                	add    %ebx,%eax
  8009be:	50                   	push   %eax
  8009bf:	e8 c2 ff ff ff       	call   800986 <strcpy>
	return dst;
}
  8009c4:	89 d8                	mov    %ebx,%eax
  8009c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009c9:	c9                   	leave  
  8009ca:	c3                   	ret    

008009cb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	56                   	push   %esi
  8009cf:	53                   	push   %ebx
  8009d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009d6:	89 c6                	mov    %eax,%esi
  8009d8:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009db:	89 c2                	mov    %eax,%edx
  8009dd:	39 f2                	cmp    %esi,%edx
  8009df:	74 11                	je     8009f2 <strncpy+0x27>
		*dst++ = *src;
  8009e1:	83 c2 01             	add    $0x1,%edx
  8009e4:	0f b6 19             	movzbl (%ecx),%ebx
  8009e7:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009ea:	80 fb 01             	cmp    $0x1,%bl
  8009ed:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009f0:	eb eb                	jmp    8009dd <strncpy+0x12>
	}
	return ret;
}
  8009f2:	5b                   	pop    %ebx
  8009f3:	5e                   	pop    %esi
  8009f4:	5d                   	pop    %ebp
  8009f5:	c3                   	ret    

008009f6 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
  8009f9:	56                   	push   %esi
  8009fa:	53                   	push   %ebx
  8009fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8009fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a01:	8b 55 10             	mov    0x10(%ebp),%edx
  800a04:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a06:	85 d2                	test   %edx,%edx
  800a08:	74 21                	je     800a2b <strlcpy+0x35>
  800a0a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a0e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a10:	39 c2                	cmp    %eax,%edx
  800a12:	74 14                	je     800a28 <strlcpy+0x32>
  800a14:	0f b6 19             	movzbl (%ecx),%ebx
  800a17:	84 db                	test   %bl,%bl
  800a19:	74 0b                	je     800a26 <strlcpy+0x30>
			*dst++ = *src++;
  800a1b:	83 c1 01             	add    $0x1,%ecx
  800a1e:	83 c2 01             	add    $0x1,%edx
  800a21:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a24:	eb ea                	jmp    800a10 <strlcpy+0x1a>
  800a26:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a28:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a2b:	29 f0                	sub    %esi,%eax
}
  800a2d:	5b                   	pop    %ebx
  800a2e:	5e                   	pop    %esi
  800a2f:	5d                   	pop    %ebp
  800a30:	c3                   	ret    

00800a31 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a31:	55                   	push   %ebp
  800a32:	89 e5                	mov    %esp,%ebp
  800a34:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a37:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a3a:	0f b6 01             	movzbl (%ecx),%eax
  800a3d:	84 c0                	test   %al,%al
  800a3f:	74 0c                	je     800a4d <strcmp+0x1c>
  800a41:	3a 02                	cmp    (%edx),%al
  800a43:	75 08                	jne    800a4d <strcmp+0x1c>
		p++, q++;
  800a45:	83 c1 01             	add    $0x1,%ecx
  800a48:	83 c2 01             	add    $0x1,%edx
  800a4b:	eb ed                	jmp    800a3a <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a4d:	0f b6 c0             	movzbl %al,%eax
  800a50:	0f b6 12             	movzbl (%edx),%edx
  800a53:	29 d0                	sub    %edx,%eax
}
  800a55:	5d                   	pop    %ebp
  800a56:	c3                   	ret    

00800a57 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a57:	55                   	push   %ebp
  800a58:	89 e5                	mov    %esp,%ebp
  800a5a:	53                   	push   %ebx
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a61:	89 c3                	mov    %eax,%ebx
  800a63:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a66:	eb 06                	jmp    800a6e <strncmp+0x17>
		n--, p++, q++;
  800a68:	83 c0 01             	add    $0x1,%eax
  800a6b:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a6e:	39 d8                	cmp    %ebx,%eax
  800a70:	74 16                	je     800a88 <strncmp+0x31>
  800a72:	0f b6 08             	movzbl (%eax),%ecx
  800a75:	84 c9                	test   %cl,%cl
  800a77:	74 04                	je     800a7d <strncmp+0x26>
  800a79:	3a 0a                	cmp    (%edx),%cl
  800a7b:	74 eb                	je     800a68 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a7d:	0f b6 00             	movzbl (%eax),%eax
  800a80:	0f b6 12             	movzbl (%edx),%edx
  800a83:	29 d0                	sub    %edx,%eax
}
  800a85:	5b                   	pop    %ebx
  800a86:	5d                   	pop    %ebp
  800a87:	c3                   	ret    
		return 0;
  800a88:	b8 00 00 00 00       	mov    $0x0,%eax
  800a8d:	eb f6                	jmp    800a85 <strncmp+0x2e>

00800a8f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a8f:	55                   	push   %ebp
  800a90:	89 e5                	mov    %esp,%ebp
  800a92:	8b 45 08             	mov    0x8(%ebp),%eax
  800a95:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a99:	0f b6 10             	movzbl (%eax),%edx
  800a9c:	84 d2                	test   %dl,%dl
  800a9e:	74 09                	je     800aa9 <strchr+0x1a>
		if (*s == c)
  800aa0:	38 ca                	cmp    %cl,%dl
  800aa2:	74 0a                	je     800aae <strchr+0x1f>
	for (; *s; s++)
  800aa4:	83 c0 01             	add    $0x1,%eax
  800aa7:	eb f0                	jmp    800a99 <strchr+0xa>
			return (char *) s;
	return 0;
  800aa9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aae:	5d                   	pop    %ebp
  800aaf:	c3                   	ret    

00800ab0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aba:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800abd:	38 ca                	cmp    %cl,%dl
  800abf:	74 09                	je     800aca <strfind+0x1a>
  800ac1:	84 d2                	test   %dl,%dl
  800ac3:	74 05                	je     800aca <strfind+0x1a>
	for (; *s; s++)
  800ac5:	83 c0 01             	add    $0x1,%eax
  800ac8:	eb f0                	jmp    800aba <strfind+0xa>
			break;
	return (char *) s;
}
  800aca:	5d                   	pop    %ebp
  800acb:	c3                   	ret    

00800acc <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	57                   	push   %edi
  800ad0:	56                   	push   %esi
  800ad1:	53                   	push   %ebx
  800ad2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ad5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ad8:	85 c9                	test   %ecx,%ecx
  800ada:	74 31                	je     800b0d <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800adc:	89 f8                	mov    %edi,%eax
  800ade:	09 c8                	or     %ecx,%eax
  800ae0:	a8 03                	test   $0x3,%al
  800ae2:	75 23                	jne    800b07 <memset+0x3b>
		c &= 0xFF;
  800ae4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ae8:	89 d3                	mov    %edx,%ebx
  800aea:	c1 e3 08             	shl    $0x8,%ebx
  800aed:	89 d0                	mov    %edx,%eax
  800aef:	c1 e0 18             	shl    $0x18,%eax
  800af2:	89 d6                	mov    %edx,%esi
  800af4:	c1 e6 10             	shl    $0x10,%esi
  800af7:	09 f0                	or     %esi,%eax
  800af9:	09 c2                	or     %eax,%edx
  800afb:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800afd:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b00:	89 d0                	mov    %edx,%eax
  800b02:	fc                   	cld    
  800b03:	f3 ab                	rep stos %eax,%es:(%edi)
  800b05:	eb 06                	jmp    800b0d <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0a:	fc                   	cld    
  800b0b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b0d:	89 f8                	mov    %edi,%eax
  800b0f:	5b                   	pop    %ebx
  800b10:	5e                   	pop    %esi
  800b11:	5f                   	pop    %edi
  800b12:	5d                   	pop    %ebp
  800b13:	c3                   	ret    

00800b14 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	57                   	push   %edi
  800b18:	56                   	push   %esi
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b1f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b22:	39 c6                	cmp    %eax,%esi
  800b24:	73 32                	jae    800b58 <memmove+0x44>
  800b26:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b29:	39 c2                	cmp    %eax,%edx
  800b2b:	76 2b                	jbe    800b58 <memmove+0x44>
		s += n;
		d += n;
  800b2d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b30:	89 fe                	mov    %edi,%esi
  800b32:	09 ce                	or     %ecx,%esi
  800b34:	09 d6                	or     %edx,%esi
  800b36:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b3c:	75 0e                	jne    800b4c <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b3e:	83 ef 04             	sub    $0x4,%edi
  800b41:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b44:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b47:	fd                   	std    
  800b48:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b4a:	eb 09                	jmp    800b55 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b4c:	83 ef 01             	sub    $0x1,%edi
  800b4f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b52:	fd                   	std    
  800b53:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b55:	fc                   	cld    
  800b56:	eb 1a                	jmp    800b72 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b58:	89 c2                	mov    %eax,%edx
  800b5a:	09 ca                	or     %ecx,%edx
  800b5c:	09 f2                	or     %esi,%edx
  800b5e:	f6 c2 03             	test   $0x3,%dl
  800b61:	75 0a                	jne    800b6d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b63:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b66:	89 c7                	mov    %eax,%edi
  800b68:	fc                   	cld    
  800b69:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b6b:	eb 05                	jmp    800b72 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b6d:	89 c7                	mov    %eax,%edi
  800b6f:	fc                   	cld    
  800b70:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b72:	5e                   	pop    %esi
  800b73:	5f                   	pop    %edi
  800b74:	5d                   	pop    %ebp
  800b75:	c3                   	ret    

00800b76 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
  800b79:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b7c:	ff 75 10             	pushl  0x10(%ebp)
  800b7f:	ff 75 0c             	pushl  0xc(%ebp)
  800b82:	ff 75 08             	pushl  0x8(%ebp)
  800b85:	e8 8a ff ff ff       	call   800b14 <memmove>
}
  800b8a:	c9                   	leave  
  800b8b:	c3                   	ret    

00800b8c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	56                   	push   %esi
  800b90:	53                   	push   %ebx
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b97:	89 c6                	mov    %eax,%esi
  800b99:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b9c:	39 f0                	cmp    %esi,%eax
  800b9e:	74 1c                	je     800bbc <memcmp+0x30>
		if (*s1 != *s2)
  800ba0:	0f b6 08             	movzbl (%eax),%ecx
  800ba3:	0f b6 1a             	movzbl (%edx),%ebx
  800ba6:	38 d9                	cmp    %bl,%cl
  800ba8:	75 08                	jne    800bb2 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800baa:	83 c0 01             	add    $0x1,%eax
  800bad:	83 c2 01             	add    $0x1,%edx
  800bb0:	eb ea                	jmp    800b9c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bb2:	0f b6 c1             	movzbl %cl,%eax
  800bb5:	0f b6 db             	movzbl %bl,%ebx
  800bb8:	29 d8                	sub    %ebx,%eax
  800bba:	eb 05                	jmp    800bc1 <memcmp+0x35>
	}

	return 0;
  800bbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    

00800bc5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bce:	89 c2                	mov    %eax,%edx
  800bd0:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bd3:	39 d0                	cmp    %edx,%eax
  800bd5:	73 09                	jae    800be0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bd7:	38 08                	cmp    %cl,(%eax)
  800bd9:	74 05                	je     800be0 <memfind+0x1b>
	for (; s < ends; s++)
  800bdb:	83 c0 01             	add    $0x1,%eax
  800bde:	eb f3                	jmp    800bd3 <memfind+0xe>
			break;
	return (void *) s;
}
  800be0:	5d                   	pop    %ebp
  800be1:	c3                   	ret    

00800be2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	57                   	push   %edi
  800be6:	56                   	push   %esi
  800be7:	53                   	push   %ebx
  800be8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800beb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bee:	eb 03                	jmp    800bf3 <strtol+0x11>
		s++;
  800bf0:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bf3:	0f b6 01             	movzbl (%ecx),%eax
  800bf6:	3c 20                	cmp    $0x20,%al
  800bf8:	74 f6                	je     800bf0 <strtol+0xe>
  800bfa:	3c 09                	cmp    $0x9,%al
  800bfc:	74 f2                	je     800bf0 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bfe:	3c 2b                	cmp    $0x2b,%al
  800c00:	74 2a                	je     800c2c <strtol+0x4a>
	int neg = 0;
  800c02:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c07:	3c 2d                	cmp    $0x2d,%al
  800c09:	74 2b                	je     800c36 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c0b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c11:	75 0f                	jne    800c22 <strtol+0x40>
  800c13:	80 39 30             	cmpb   $0x30,(%ecx)
  800c16:	74 28                	je     800c40 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c18:	85 db                	test   %ebx,%ebx
  800c1a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c1f:	0f 44 d8             	cmove  %eax,%ebx
  800c22:	b8 00 00 00 00       	mov    $0x0,%eax
  800c27:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c2a:	eb 50                	jmp    800c7c <strtol+0x9a>
		s++;
  800c2c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c2f:	bf 00 00 00 00       	mov    $0x0,%edi
  800c34:	eb d5                	jmp    800c0b <strtol+0x29>
		s++, neg = 1;
  800c36:	83 c1 01             	add    $0x1,%ecx
  800c39:	bf 01 00 00 00       	mov    $0x1,%edi
  800c3e:	eb cb                	jmp    800c0b <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c40:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c44:	74 0e                	je     800c54 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c46:	85 db                	test   %ebx,%ebx
  800c48:	75 d8                	jne    800c22 <strtol+0x40>
		s++, base = 8;
  800c4a:	83 c1 01             	add    $0x1,%ecx
  800c4d:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c52:	eb ce                	jmp    800c22 <strtol+0x40>
		s += 2, base = 16;
  800c54:	83 c1 02             	add    $0x2,%ecx
  800c57:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c5c:	eb c4                	jmp    800c22 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c5e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c61:	89 f3                	mov    %esi,%ebx
  800c63:	80 fb 19             	cmp    $0x19,%bl
  800c66:	77 29                	ja     800c91 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c68:	0f be d2             	movsbl %dl,%edx
  800c6b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c6e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c71:	7d 30                	jge    800ca3 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c73:	83 c1 01             	add    $0x1,%ecx
  800c76:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c7a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c7c:	0f b6 11             	movzbl (%ecx),%edx
  800c7f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c82:	89 f3                	mov    %esi,%ebx
  800c84:	80 fb 09             	cmp    $0x9,%bl
  800c87:	77 d5                	ja     800c5e <strtol+0x7c>
			dig = *s - '0';
  800c89:	0f be d2             	movsbl %dl,%edx
  800c8c:	83 ea 30             	sub    $0x30,%edx
  800c8f:	eb dd                	jmp    800c6e <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c91:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c94:	89 f3                	mov    %esi,%ebx
  800c96:	80 fb 19             	cmp    $0x19,%bl
  800c99:	77 08                	ja     800ca3 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c9b:	0f be d2             	movsbl %dl,%edx
  800c9e:	83 ea 37             	sub    $0x37,%edx
  800ca1:	eb cb                	jmp    800c6e <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ca3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca7:	74 05                	je     800cae <strtol+0xcc>
		*endptr = (char *) s;
  800ca9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cac:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cae:	89 c2                	mov    %eax,%edx
  800cb0:	f7 da                	neg    %edx
  800cb2:	85 ff                	test   %edi,%edi
  800cb4:	0f 45 c2             	cmovne %edx,%eax
}
  800cb7:	5b                   	pop    %ebx
  800cb8:	5e                   	pop    %esi
  800cb9:	5f                   	pop    %edi
  800cba:	5d                   	pop    %ebp
  800cbb:	c3                   	ret    

00800cbc <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	57                   	push   %edi
  800cc0:	56                   	push   %esi
  800cc1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc2:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ccd:	89 c3                	mov    %eax,%ebx
  800ccf:	89 c7                	mov    %eax,%edi
  800cd1:	89 c6                	mov    %eax,%esi
  800cd3:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cd5:	5b                   	pop    %ebx
  800cd6:	5e                   	pop    %esi
  800cd7:	5f                   	pop    %edi
  800cd8:	5d                   	pop    %ebp
  800cd9:	c3                   	ret    

00800cda <sys_cgetc>:

int
sys_cgetc(void)
{
  800cda:	55                   	push   %ebp
  800cdb:	89 e5                	mov    %esp,%ebp
  800cdd:	57                   	push   %edi
  800cde:	56                   	push   %esi
  800cdf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce5:	b8 01 00 00 00       	mov    $0x1,%eax
  800cea:	89 d1                	mov    %edx,%ecx
  800cec:	89 d3                	mov    %edx,%ebx
  800cee:	89 d7                	mov    %edx,%edi
  800cf0:	89 d6                	mov    %edx,%esi
  800cf2:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cf4:	5b                   	pop    %ebx
  800cf5:	5e                   	pop    %esi
  800cf6:	5f                   	pop    %edi
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	57                   	push   %edi
  800cfd:	56                   	push   %esi
  800cfe:	53                   	push   %ebx
  800cff:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d02:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d07:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0a:	b8 03 00 00 00       	mov    $0x3,%eax
  800d0f:	89 cb                	mov    %ecx,%ebx
  800d11:	89 cf                	mov    %ecx,%edi
  800d13:	89 ce                	mov    %ecx,%esi
  800d15:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d17:	85 c0                	test   %eax,%eax
  800d19:	7f 08                	jg     800d23 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1e:	5b                   	pop    %ebx
  800d1f:	5e                   	pop    %esi
  800d20:	5f                   	pop    %edi
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d23:	83 ec 0c             	sub    $0xc,%esp
  800d26:	50                   	push   %eax
  800d27:	6a 03                	push   $0x3
  800d29:	68 e8 29 80 00       	push   $0x8029e8
  800d2e:	6a 43                	push   $0x43
  800d30:	68 05 2a 80 00       	push   $0x802a05
  800d35:	e8 89 14 00 00       	call   8021c3 <_panic>

00800d3a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d3a:	55                   	push   %ebp
  800d3b:	89 e5                	mov    %esp,%ebp
  800d3d:	57                   	push   %edi
  800d3e:	56                   	push   %esi
  800d3f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d40:	ba 00 00 00 00       	mov    $0x0,%edx
  800d45:	b8 02 00 00 00       	mov    $0x2,%eax
  800d4a:	89 d1                	mov    %edx,%ecx
  800d4c:	89 d3                	mov    %edx,%ebx
  800d4e:	89 d7                	mov    %edx,%edi
  800d50:	89 d6                	mov    %edx,%esi
  800d52:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d54:	5b                   	pop    %ebx
  800d55:	5e                   	pop    %esi
  800d56:	5f                   	pop    %edi
  800d57:	5d                   	pop    %ebp
  800d58:	c3                   	ret    

00800d59 <sys_yield>:

void
sys_yield(void)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	57                   	push   %edi
  800d5d:	56                   	push   %esi
  800d5e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d5f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d64:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d69:	89 d1                	mov    %edx,%ecx
  800d6b:	89 d3                	mov    %edx,%ebx
  800d6d:	89 d7                	mov    %edx,%edi
  800d6f:	89 d6                	mov    %edx,%esi
  800d71:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d73:	5b                   	pop    %ebx
  800d74:	5e                   	pop    %esi
  800d75:	5f                   	pop    %edi
  800d76:	5d                   	pop    %ebp
  800d77:	c3                   	ret    

00800d78 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	57                   	push   %edi
  800d7c:	56                   	push   %esi
  800d7d:	53                   	push   %ebx
  800d7e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d81:	be 00 00 00 00       	mov    $0x0,%esi
  800d86:	8b 55 08             	mov    0x8(%ebp),%edx
  800d89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8c:	b8 04 00 00 00       	mov    $0x4,%eax
  800d91:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d94:	89 f7                	mov    %esi,%edi
  800d96:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d98:	85 c0                	test   %eax,%eax
  800d9a:	7f 08                	jg     800da4 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9f:	5b                   	pop    %ebx
  800da0:	5e                   	pop    %esi
  800da1:	5f                   	pop    %edi
  800da2:	5d                   	pop    %ebp
  800da3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da4:	83 ec 0c             	sub    $0xc,%esp
  800da7:	50                   	push   %eax
  800da8:	6a 04                	push   $0x4
  800daa:	68 e8 29 80 00       	push   $0x8029e8
  800daf:	6a 43                	push   $0x43
  800db1:	68 05 2a 80 00       	push   $0x802a05
  800db6:	e8 08 14 00 00       	call   8021c3 <_panic>

00800dbb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
  800dbe:	57                   	push   %edi
  800dbf:	56                   	push   %esi
  800dc0:	53                   	push   %ebx
  800dc1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dca:	b8 05 00 00 00       	mov    $0x5,%eax
  800dcf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dd5:	8b 75 18             	mov    0x18(%ebp),%esi
  800dd8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dda:	85 c0                	test   %eax,%eax
  800ddc:	7f 08                	jg     800de6 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dde:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de1:	5b                   	pop    %ebx
  800de2:	5e                   	pop    %esi
  800de3:	5f                   	pop    %edi
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de6:	83 ec 0c             	sub    $0xc,%esp
  800de9:	50                   	push   %eax
  800dea:	6a 05                	push   $0x5
  800dec:	68 e8 29 80 00       	push   $0x8029e8
  800df1:	6a 43                	push   $0x43
  800df3:	68 05 2a 80 00       	push   $0x802a05
  800df8:	e8 c6 13 00 00       	call   8021c3 <_panic>

00800dfd <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
  800e00:	57                   	push   %edi
  800e01:	56                   	push   %esi
  800e02:	53                   	push   %ebx
  800e03:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e06:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e11:	b8 06 00 00 00       	mov    $0x6,%eax
  800e16:	89 df                	mov    %ebx,%edi
  800e18:	89 de                	mov    %ebx,%esi
  800e1a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e1c:	85 c0                	test   %eax,%eax
  800e1e:	7f 08                	jg     800e28 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e23:	5b                   	pop    %ebx
  800e24:	5e                   	pop    %esi
  800e25:	5f                   	pop    %edi
  800e26:	5d                   	pop    %ebp
  800e27:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e28:	83 ec 0c             	sub    $0xc,%esp
  800e2b:	50                   	push   %eax
  800e2c:	6a 06                	push   $0x6
  800e2e:	68 e8 29 80 00       	push   $0x8029e8
  800e33:	6a 43                	push   $0x43
  800e35:	68 05 2a 80 00       	push   $0x802a05
  800e3a:	e8 84 13 00 00       	call   8021c3 <_panic>

00800e3f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
  800e42:	57                   	push   %edi
  800e43:	56                   	push   %esi
  800e44:	53                   	push   %ebx
  800e45:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e48:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e53:	b8 08 00 00 00       	mov    $0x8,%eax
  800e58:	89 df                	mov    %ebx,%edi
  800e5a:	89 de                	mov    %ebx,%esi
  800e5c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5e:	85 c0                	test   %eax,%eax
  800e60:	7f 08                	jg     800e6a <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e65:	5b                   	pop    %ebx
  800e66:	5e                   	pop    %esi
  800e67:	5f                   	pop    %edi
  800e68:	5d                   	pop    %ebp
  800e69:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6a:	83 ec 0c             	sub    $0xc,%esp
  800e6d:	50                   	push   %eax
  800e6e:	6a 08                	push   $0x8
  800e70:	68 e8 29 80 00       	push   $0x8029e8
  800e75:	6a 43                	push   $0x43
  800e77:	68 05 2a 80 00       	push   $0x802a05
  800e7c:	e8 42 13 00 00       	call   8021c3 <_panic>

00800e81 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e81:	55                   	push   %ebp
  800e82:	89 e5                	mov    %esp,%ebp
  800e84:	57                   	push   %edi
  800e85:	56                   	push   %esi
  800e86:	53                   	push   %ebx
  800e87:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e8a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e95:	b8 09 00 00 00       	mov    $0x9,%eax
  800e9a:	89 df                	mov    %ebx,%edi
  800e9c:	89 de                	mov    %ebx,%esi
  800e9e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea0:	85 c0                	test   %eax,%eax
  800ea2:	7f 08                	jg     800eac <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ea4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea7:	5b                   	pop    %ebx
  800ea8:	5e                   	pop    %esi
  800ea9:	5f                   	pop    %edi
  800eaa:	5d                   	pop    %ebp
  800eab:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eac:	83 ec 0c             	sub    $0xc,%esp
  800eaf:	50                   	push   %eax
  800eb0:	6a 09                	push   $0x9
  800eb2:	68 e8 29 80 00       	push   $0x8029e8
  800eb7:	6a 43                	push   $0x43
  800eb9:	68 05 2a 80 00       	push   $0x802a05
  800ebe:	e8 00 13 00 00       	call   8021c3 <_panic>

00800ec3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
  800ec6:	57                   	push   %edi
  800ec7:	56                   	push   %esi
  800ec8:	53                   	push   %ebx
  800ec9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ecc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800edc:	89 df                	mov    %ebx,%edi
  800ede:	89 de                	mov    %ebx,%esi
  800ee0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee2:	85 c0                	test   %eax,%eax
  800ee4:	7f 08                	jg     800eee <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ee6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee9:	5b                   	pop    %ebx
  800eea:	5e                   	pop    %esi
  800eeb:	5f                   	pop    %edi
  800eec:	5d                   	pop    %ebp
  800eed:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eee:	83 ec 0c             	sub    $0xc,%esp
  800ef1:	50                   	push   %eax
  800ef2:	6a 0a                	push   $0xa
  800ef4:	68 e8 29 80 00       	push   $0x8029e8
  800ef9:	6a 43                	push   $0x43
  800efb:	68 05 2a 80 00       	push   $0x802a05
  800f00:	e8 be 12 00 00       	call   8021c3 <_panic>

00800f05 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f05:	55                   	push   %ebp
  800f06:	89 e5                	mov    %esp,%ebp
  800f08:	57                   	push   %edi
  800f09:	56                   	push   %esi
  800f0a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f11:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f16:	be 00 00 00 00       	mov    $0x0,%esi
  800f1b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f1e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f21:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f23:	5b                   	pop    %ebx
  800f24:	5e                   	pop    %esi
  800f25:	5f                   	pop    %edi
  800f26:	5d                   	pop    %ebp
  800f27:	c3                   	ret    

00800f28 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f28:	55                   	push   %ebp
  800f29:	89 e5                	mov    %esp,%ebp
  800f2b:	57                   	push   %edi
  800f2c:	56                   	push   %esi
  800f2d:	53                   	push   %ebx
  800f2e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f31:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f36:	8b 55 08             	mov    0x8(%ebp),%edx
  800f39:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f3e:	89 cb                	mov    %ecx,%ebx
  800f40:	89 cf                	mov    %ecx,%edi
  800f42:	89 ce                	mov    %ecx,%esi
  800f44:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f46:	85 c0                	test   %eax,%eax
  800f48:	7f 08                	jg     800f52 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f4d:	5b                   	pop    %ebx
  800f4e:	5e                   	pop    %esi
  800f4f:	5f                   	pop    %edi
  800f50:	5d                   	pop    %ebp
  800f51:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f52:	83 ec 0c             	sub    $0xc,%esp
  800f55:	50                   	push   %eax
  800f56:	6a 0d                	push   $0xd
  800f58:	68 e8 29 80 00       	push   $0x8029e8
  800f5d:	6a 43                	push   $0x43
  800f5f:	68 05 2a 80 00       	push   $0x802a05
  800f64:	e8 5a 12 00 00       	call   8021c3 <_panic>

00800f69 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f69:	55                   	push   %ebp
  800f6a:	89 e5                	mov    %esp,%ebp
  800f6c:	57                   	push   %edi
  800f6d:	56                   	push   %esi
  800f6e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f6f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f74:	8b 55 08             	mov    0x8(%ebp),%edx
  800f77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7a:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f7f:	89 df                	mov    %ebx,%edi
  800f81:	89 de                	mov    %ebx,%esi
  800f83:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f85:	5b                   	pop    %ebx
  800f86:	5e                   	pop    %esi
  800f87:	5f                   	pop    %edi
  800f88:	5d                   	pop    %ebp
  800f89:	c3                   	ret    

00800f8a <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	57                   	push   %edi
  800f8e:	56                   	push   %esi
  800f8f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f90:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f95:	8b 55 08             	mov    0x8(%ebp),%edx
  800f98:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f9d:	89 cb                	mov    %ecx,%ebx
  800f9f:	89 cf                	mov    %ecx,%edi
  800fa1:	89 ce                	mov    %ecx,%esi
  800fa3:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fa5:	5b                   	pop    %ebx
  800fa6:	5e                   	pop    %esi
  800fa7:	5f                   	pop    %edi
  800fa8:	5d                   	pop    %ebp
  800fa9:	c3                   	ret    

00800faa <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	57                   	push   %edi
  800fae:	56                   	push   %esi
  800faf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fb0:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb5:	b8 10 00 00 00       	mov    $0x10,%eax
  800fba:	89 d1                	mov    %edx,%ecx
  800fbc:	89 d3                	mov    %edx,%ebx
  800fbe:	89 d7                	mov    %edx,%edi
  800fc0:	89 d6                	mov    %edx,%esi
  800fc2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fc4:	5b                   	pop    %ebx
  800fc5:	5e                   	pop    %esi
  800fc6:	5f                   	pop    %edi
  800fc7:	5d                   	pop    %ebp
  800fc8:	c3                   	ret    

00800fc9 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800fc9:	55                   	push   %ebp
  800fca:	89 e5                	mov    %esp,%ebp
  800fcc:	57                   	push   %edi
  800fcd:	56                   	push   %esi
  800fce:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fcf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fda:	b8 11 00 00 00       	mov    $0x11,%eax
  800fdf:	89 df                	mov    %ebx,%edi
  800fe1:	89 de                	mov    %ebx,%esi
  800fe3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fe5:	5b                   	pop    %ebx
  800fe6:	5e                   	pop    %esi
  800fe7:	5f                   	pop    %edi
  800fe8:	5d                   	pop    %ebp
  800fe9:	c3                   	ret    

00800fea <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	57                   	push   %edi
  800fee:	56                   	push   %esi
  800fef:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ff0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ffb:	b8 12 00 00 00       	mov    $0x12,%eax
  801000:	89 df                	mov    %ebx,%edi
  801002:	89 de                	mov    %ebx,%esi
  801004:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801006:	5b                   	pop    %ebx
  801007:	5e                   	pop    %esi
  801008:	5f                   	pop    %edi
  801009:	5d                   	pop    %ebp
  80100a:	c3                   	ret    

0080100b <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80100b:	55                   	push   %ebp
  80100c:	89 e5                	mov    %esp,%ebp
  80100e:	57                   	push   %edi
  80100f:	56                   	push   %esi
  801010:	53                   	push   %ebx
  801011:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801014:	bb 00 00 00 00       	mov    $0x0,%ebx
  801019:	8b 55 08             	mov    0x8(%ebp),%edx
  80101c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101f:	b8 13 00 00 00       	mov    $0x13,%eax
  801024:	89 df                	mov    %ebx,%edi
  801026:	89 de                	mov    %ebx,%esi
  801028:	cd 30                	int    $0x30
	if(check && ret > 0)
  80102a:	85 c0                	test   %eax,%eax
  80102c:	7f 08                	jg     801036 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80102e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801031:	5b                   	pop    %ebx
  801032:	5e                   	pop    %esi
  801033:	5f                   	pop    %edi
  801034:	5d                   	pop    %ebp
  801035:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801036:	83 ec 0c             	sub    $0xc,%esp
  801039:	50                   	push   %eax
  80103a:	6a 13                	push   $0x13
  80103c:	68 e8 29 80 00       	push   $0x8029e8
  801041:	6a 43                	push   $0x43
  801043:	68 05 2a 80 00       	push   $0x802a05
  801048:	e8 76 11 00 00       	call   8021c3 <_panic>

0080104d <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	57                   	push   %edi
  801051:	56                   	push   %esi
  801052:	53                   	push   %ebx
	asm volatile("int %1\n"
  801053:	b9 00 00 00 00       	mov    $0x0,%ecx
  801058:	8b 55 08             	mov    0x8(%ebp),%edx
  80105b:	b8 14 00 00 00       	mov    $0x14,%eax
  801060:	89 cb                	mov    %ecx,%ebx
  801062:	89 cf                	mov    %ecx,%edi
  801064:	89 ce                	mov    %ecx,%esi
  801066:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801068:	5b                   	pop    %ebx
  801069:	5e                   	pop    %esi
  80106a:	5f                   	pop    %edi
  80106b:	5d                   	pop    %ebp
  80106c:	c3                   	ret    

0080106d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80106d:	55                   	push   %ebp
  80106e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	05 00 00 00 30       	add    $0x30000000,%eax
  801078:	c1 e8 0c             	shr    $0xc,%eax
}
  80107b:	5d                   	pop    %ebp
  80107c:	c3                   	ret    

0080107d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801080:	8b 45 08             	mov    0x8(%ebp),%eax
  801083:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801088:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80108d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801092:	5d                   	pop    %ebp
  801093:	c3                   	ret    

00801094 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80109c:	89 c2                	mov    %eax,%edx
  80109e:	c1 ea 16             	shr    $0x16,%edx
  8010a1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010a8:	f6 c2 01             	test   $0x1,%dl
  8010ab:	74 2d                	je     8010da <fd_alloc+0x46>
  8010ad:	89 c2                	mov    %eax,%edx
  8010af:	c1 ea 0c             	shr    $0xc,%edx
  8010b2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010b9:	f6 c2 01             	test   $0x1,%dl
  8010bc:	74 1c                	je     8010da <fd_alloc+0x46>
  8010be:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010c3:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010c8:	75 d2                	jne    80109c <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8010d3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010d8:	eb 0a                	jmp    8010e4 <fd_alloc+0x50>
			*fd_store = fd;
  8010da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010dd:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010e4:	5d                   	pop    %ebp
  8010e5:	c3                   	ret    

008010e6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010ec:	83 f8 1f             	cmp    $0x1f,%eax
  8010ef:	77 30                	ja     801121 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010f1:	c1 e0 0c             	shl    $0xc,%eax
  8010f4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010f9:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010ff:	f6 c2 01             	test   $0x1,%dl
  801102:	74 24                	je     801128 <fd_lookup+0x42>
  801104:	89 c2                	mov    %eax,%edx
  801106:	c1 ea 0c             	shr    $0xc,%edx
  801109:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801110:	f6 c2 01             	test   $0x1,%dl
  801113:	74 1a                	je     80112f <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801115:	8b 55 0c             	mov    0xc(%ebp),%edx
  801118:	89 02                	mov    %eax,(%edx)
	return 0;
  80111a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80111f:	5d                   	pop    %ebp
  801120:	c3                   	ret    
		return -E_INVAL;
  801121:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801126:	eb f7                	jmp    80111f <fd_lookup+0x39>
		return -E_INVAL;
  801128:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80112d:	eb f0                	jmp    80111f <fd_lookup+0x39>
  80112f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801134:	eb e9                	jmp    80111f <fd_lookup+0x39>

00801136 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	83 ec 08             	sub    $0x8,%esp
  80113c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80113f:	ba 00 00 00 00       	mov    $0x0,%edx
  801144:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801149:	39 08                	cmp    %ecx,(%eax)
  80114b:	74 38                	je     801185 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80114d:	83 c2 01             	add    $0x1,%edx
  801150:	8b 04 95 90 2a 80 00 	mov    0x802a90(,%edx,4),%eax
  801157:	85 c0                	test   %eax,%eax
  801159:	75 ee                	jne    801149 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80115b:	a1 08 40 80 00       	mov    0x804008,%eax
  801160:	8b 40 48             	mov    0x48(%eax),%eax
  801163:	83 ec 04             	sub    $0x4,%esp
  801166:	51                   	push   %ecx
  801167:	50                   	push   %eax
  801168:	68 14 2a 80 00       	push   $0x802a14
  80116d:	e8 b5 f0 ff ff       	call   800227 <cprintf>
	*dev = 0;
  801172:	8b 45 0c             	mov    0xc(%ebp),%eax
  801175:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80117b:	83 c4 10             	add    $0x10,%esp
  80117e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801183:	c9                   	leave  
  801184:	c3                   	ret    
			*dev = devtab[i];
  801185:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801188:	89 01                	mov    %eax,(%ecx)
			return 0;
  80118a:	b8 00 00 00 00       	mov    $0x0,%eax
  80118f:	eb f2                	jmp    801183 <dev_lookup+0x4d>

00801191 <fd_close>:
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
  801194:	57                   	push   %edi
  801195:	56                   	push   %esi
  801196:	53                   	push   %ebx
  801197:	83 ec 24             	sub    $0x24,%esp
  80119a:	8b 75 08             	mov    0x8(%ebp),%esi
  80119d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011a0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011a3:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011a4:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011aa:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011ad:	50                   	push   %eax
  8011ae:	e8 33 ff ff ff       	call   8010e6 <fd_lookup>
  8011b3:	89 c3                	mov    %eax,%ebx
  8011b5:	83 c4 10             	add    $0x10,%esp
  8011b8:	85 c0                	test   %eax,%eax
  8011ba:	78 05                	js     8011c1 <fd_close+0x30>
	    || fd != fd2)
  8011bc:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011bf:	74 16                	je     8011d7 <fd_close+0x46>
		return (must_exist ? r : 0);
  8011c1:	89 f8                	mov    %edi,%eax
  8011c3:	84 c0                	test   %al,%al
  8011c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ca:	0f 44 d8             	cmove  %eax,%ebx
}
  8011cd:	89 d8                	mov    %ebx,%eax
  8011cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d2:	5b                   	pop    %ebx
  8011d3:	5e                   	pop    %esi
  8011d4:	5f                   	pop    %edi
  8011d5:	5d                   	pop    %ebp
  8011d6:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011d7:	83 ec 08             	sub    $0x8,%esp
  8011da:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011dd:	50                   	push   %eax
  8011de:	ff 36                	pushl  (%esi)
  8011e0:	e8 51 ff ff ff       	call   801136 <dev_lookup>
  8011e5:	89 c3                	mov    %eax,%ebx
  8011e7:	83 c4 10             	add    $0x10,%esp
  8011ea:	85 c0                	test   %eax,%eax
  8011ec:	78 1a                	js     801208 <fd_close+0x77>
		if (dev->dev_close)
  8011ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011f1:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011f4:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011f9:	85 c0                	test   %eax,%eax
  8011fb:	74 0b                	je     801208 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011fd:	83 ec 0c             	sub    $0xc,%esp
  801200:	56                   	push   %esi
  801201:	ff d0                	call   *%eax
  801203:	89 c3                	mov    %eax,%ebx
  801205:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801208:	83 ec 08             	sub    $0x8,%esp
  80120b:	56                   	push   %esi
  80120c:	6a 00                	push   $0x0
  80120e:	e8 ea fb ff ff       	call   800dfd <sys_page_unmap>
	return r;
  801213:	83 c4 10             	add    $0x10,%esp
  801216:	eb b5                	jmp    8011cd <fd_close+0x3c>

00801218 <close>:

int
close(int fdnum)
{
  801218:	55                   	push   %ebp
  801219:	89 e5                	mov    %esp,%ebp
  80121b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80121e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801221:	50                   	push   %eax
  801222:	ff 75 08             	pushl  0x8(%ebp)
  801225:	e8 bc fe ff ff       	call   8010e6 <fd_lookup>
  80122a:	83 c4 10             	add    $0x10,%esp
  80122d:	85 c0                	test   %eax,%eax
  80122f:	79 02                	jns    801233 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801231:	c9                   	leave  
  801232:	c3                   	ret    
		return fd_close(fd, 1);
  801233:	83 ec 08             	sub    $0x8,%esp
  801236:	6a 01                	push   $0x1
  801238:	ff 75 f4             	pushl  -0xc(%ebp)
  80123b:	e8 51 ff ff ff       	call   801191 <fd_close>
  801240:	83 c4 10             	add    $0x10,%esp
  801243:	eb ec                	jmp    801231 <close+0x19>

00801245 <close_all>:

void
close_all(void)
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
  801248:	53                   	push   %ebx
  801249:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80124c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801251:	83 ec 0c             	sub    $0xc,%esp
  801254:	53                   	push   %ebx
  801255:	e8 be ff ff ff       	call   801218 <close>
	for (i = 0; i < MAXFD; i++)
  80125a:	83 c3 01             	add    $0x1,%ebx
  80125d:	83 c4 10             	add    $0x10,%esp
  801260:	83 fb 20             	cmp    $0x20,%ebx
  801263:	75 ec                	jne    801251 <close_all+0xc>
}
  801265:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801268:	c9                   	leave  
  801269:	c3                   	ret    

0080126a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80126a:	55                   	push   %ebp
  80126b:	89 e5                	mov    %esp,%ebp
  80126d:	57                   	push   %edi
  80126e:	56                   	push   %esi
  80126f:	53                   	push   %ebx
  801270:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801273:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801276:	50                   	push   %eax
  801277:	ff 75 08             	pushl  0x8(%ebp)
  80127a:	e8 67 fe ff ff       	call   8010e6 <fd_lookup>
  80127f:	89 c3                	mov    %eax,%ebx
  801281:	83 c4 10             	add    $0x10,%esp
  801284:	85 c0                	test   %eax,%eax
  801286:	0f 88 81 00 00 00    	js     80130d <dup+0xa3>
		return r;
	close(newfdnum);
  80128c:	83 ec 0c             	sub    $0xc,%esp
  80128f:	ff 75 0c             	pushl  0xc(%ebp)
  801292:	e8 81 ff ff ff       	call   801218 <close>

	newfd = INDEX2FD(newfdnum);
  801297:	8b 75 0c             	mov    0xc(%ebp),%esi
  80129a:	c1 e6 0c             	shl    $0xc,%esi
  80129d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012a3:	83 c4 04             	add    $0x4,%esp
  8012a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012a9:	e8 cf fd ff ff       	call   80107d <fd2data>
  8012ae:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012b0:	89 34 24             	mov    %esi,(%esp)
  8012b3:	e8 c5 fd ff ff       	call   80107d <fd2data>
  8012b8:	83 c4 10             	add    $0x10,%esp
  8012bb:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012bd:	89 d8                	mov    %ebx,%eax
  8012bf:	c1 e8 16             	shr    $0x16,%eax
  8012c2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012c9:	a8 01                	test   $0x1,%al
  8012cb:	74 11                	je     8012de <dup+0x74>
  8012cd:	89 d8                	mov    %ebx,%eax
  8012cf:	c1 e8 0c             	shr    $0xc,%eax
  8012d2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012d9:	f6 c2 01             	test   $0x1,%dl
  8012dc:	75 39                	jne    801317 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012e1:	89 d0                	mov    %edx,%eax
  8012e3:	c1 e8 0c             	shr    $0xc,%eax
  8012e6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012ed:	83 ec 0c             	sub    $0xc,%esp
  8012f0:	25 07 0e 00 00       	and    $0xe07,%eax
  8012f5:	50                   	push   %eax
  8012f6:	56                   	push   %esi
  8012f7:	6a 00                	push   $0x0
  8012f9:	52                   	push   %edx
  8012fa:	6a 00                	push   $0x0
  8012fc:	e8 ba fa ff ff       	call   800dbb <sys_page_map>
  801301:	89 c3                	mov    %eax,%ebx
  801303:	83 c4 20             	add    $0x20,%esp
  801306:	85 c0                	test   %eax,%eax
  801308:	78 31                	js     80133b <dup+0xd1>
		goto err;

	return newfdnum;
  80130a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80130d:	89 d8                	mov    %ebx,%eax
  80130f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801312:	5b                   	pop    %ebx
  801313:	5e                   	pop    %esi
  801314:	5f                   	pop    %edi
  801315:	5d                   	pop    %ebp
  801316:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801317:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80131e:	83 ec 0c             	sub    $0xc,%esp
  801321:	25 07 0e 00 00       	and    $0xe07,%eax
  801326:	50                   	push   %eax
  801327:	57                   	push   %edi
  801328:	6a 00                	push   $0x0
  80132a:	53                   	push   %ebx
  80132b:	6a 00                	push   $0x0
  80132d:	e8 89 fa ff ff       	call   800dbb <sys_page_map>
  801332:	89 c3                	mov    %eax,%ebx
  801334:	83 c4 20             	add    $0x20,%esp
  801337:	85 c0                	test   %eax,%eax
  801339:	79 a3                	jns    8012de <dup+0x74>
	sys_page_unmap(0, newfd);
  80133b:	83 ec 08             	sub    $0x8,%esp
  80133e:	56                   	push   %esi
  80133f:	6a 00                	push   $0x0
  801341:	e8 b7 fa ff ff       	call   800dfd <sys_page_unmap>
	sys_page_unmap(0, nva);
  801346:	83 c4 08             	add    $0x8,%esp
  801349:	57                   	push   %edi
  80134a:	6a 00                	push   $0x0
  80134c:	e8 ac fa ff ff       	call   800dfd <sys_page_unmap>
	return r;
  801351:	83 c4 10             	add    $0x10,%esp
  801354:	eb b7                	jmp    80130d <dup+0xa3>

00801356 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
  801359:	53                   	push   %ebx
  80135a:	83 ec 1c             	sub    $0x1c,%esp
  80135d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801360:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801363:	50                   	push   %eax
  801364:	53                   	push   %ebx
  801365:	e8 7c fd ff ff       	call   8010e6 <fd_lookup>
  80136a:	83 c4 10             	add    $0x10,%esp
  80136d:	85 c0                	test   %eax,%eax
  80136f:	78 3f                	js     8013b0 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801371:	83 ec 08             	sub    $0x8,%esp
  801374:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801377:	50                   	push   %eax
  801378:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80137b:	ff 30                	pushl  (%eax)
  80137d:	e8 b4 fd ff ff       	call   801136 <dev_lookup>
  801382:	83 c4 10             	add    $0x10,%esp
  801385:	85 c0                	test   %eax,%eax
  801387:	78 27                	js     8013b0 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801389:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80138c:	8b 42 08             	mov    0x8(%edx),%eax
  80138f:	83 e0 03             	and    $0x3,%eax
  801392:	83 f8 01             	cmp    $0x1,%eax
  801395:	74 1e                	je     8013b5 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80139a:	8b 40 08             	mov    0x8(%eax),%eax
  80139d:	85 c0                	test   %eax,%eax
  80139f:	74 35                	je     8013d6 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013a1:	83 ec 04             	sub    $0x4,%esp
  8013a4:	ff 75 10             	pushl  0x10(%ebp)
  8013a7:	ff 75 0c             	pushl  0xc(%ebp)
  8013aa:	52                   	push   %edx
  8013ab:	ff d0                	call   *%eax
  8013ad:	83 c4 10             	add    $0x10,%esp
}
  8013b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013b5:	a1 08 40 80 00       	mov    0x804008,%eax
  8013ba:	8b 40 48             	mov    0x48(%eax),%eax
  8013bd:	83 ec 04             	sub    $0x4,%esp
  8013c0:	53                   	push   %ebx
  8013c1:	50                   	push   %eax
  8013c2:	68 55 2a 80 00       	push   $0x802a55
  8013c7:	e8 5b ee ff ff       	call   800227 <cprintf>
		return -E_INVAL;
  8013cc:	83 c4 10             	add    $0x10,%esp
  8013cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013d4:	eb da                	jmp    8013b0 <read+0x5a>
		return -E_NOT_SUPP;
  8013d6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013db:	eb d3                	jmp    8013b0 <read+0x5a>

008013dd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
  8013e0:	57                   	push   %edi
  8013e1:	56                   	push   %esi
  8013e2:	53                   	push   %ebx
  8013e3:	83 ec 0c             	sub    $0xc,%esp
  8013e6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013e9:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013f1:	39 f3                	cmp    %esi,%ebx
  8013f3:	73 23                	jae    801418 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013f5:	83 ec 04             	sub    $0x4,%esp
  8013f8:	89 f0                	mov    %esi,%eax
  8013fa:	29 d8                	sub    %ebx,%eax
  8013fc:	50                   	push   %eax
  8013fd:	89 d8                	mov    %ebx,%eax
  8013ff:	03 45 0c             	add    0xc(%ebp),%eax
  801402:	50                   	push   %eax
  801403:	57                   	push   %edi
  801404:	e8 4d ff ff ff       	call   801356 <read>
		if (m < 0)
  801409:	83 c4 10             	add    $0x10,%esp
  80140c:	85 c0                	test   %eax,%eax
  80140e:	78 06                	js     801416 <readn+0x39>
			return m;
		if (m == 0)
  801410:	74 06                	je     801418 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801412:	01 c3                	add    %eax,%ebx
  801414:	eb db                	jmp    8013f1 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801416:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801418:	89 d8                	mov    %ebx,%eax
  80141a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80141d:	5b                   	pop    %ebx
  80141e:	5e                   	pop    %esi
  80141f:	5f                   	pop    %edi
  801420:	5d                   	pop    %ebp
  801421:	c3                   	ret    

00801422 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801422:	55                   	push   %ebp
  801423:	89 e5                	mov    %esp,%ebp
  801425:	53                   	push   %ebx
  801426:	83 ec 1c             	sub    $0x1c,%esp
  801429:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80142c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80142f:	50                   	push   %eax
  801430:	53                   	push   %ebx
  801431:	e8 b0 fc ff ff       	call   8010e6 <fd_lookup>
  801436:	83 c4 10             	add    $0x10,%esp
  801439:	85 c0                	test   %eax,%eax
  80143b:	78 3a                	js     801477 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80143d:	83 ec 08             	sub    $0x8,%esp
  801440:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801443:	50                   	push   %eax
  801444:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801447:	ff 30                	pushl  (%eax)
  801449:	e8 e8 fc ff ff       	call   801136 <dev_lookup>
  80144e:	83 c4 10             	add    $0x10,%esp
  801451:	85 c0                	test   %eax,%eax
  801453:	78 22                	js     801477 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801458:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80145c:	74 1e                	je     80147c <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80145e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801461:	8b 52 0c             	mov    0xc(%edx),%edx
  801464:	85 d2                	test   %edx,%edx
  801466:	74 35                	je     80149d <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801468:	83 ec 04             	sub    $0x4,%esp
  80146b:	ff 75 10             	pushl  0x10(%ebp)
  80146e:	ff 75 0c             	pushl  0xc(%ebp)
  801471:	50                   	push   %eax
  801472:	ff d2                	call   *%edx
  801474:	83 c4 10             	add    $0x10,%esp
}
  801477:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80147a:	c9                   	leave  
  80147b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80147c:	a1 08 40 80 00       	mov    0x804008,%eax
  801481:	8b 40 48             	mov    0x48(%eax),%eax
  801484:	83 ec 04             	sub    $0x4,%esp
  801487:	53                   	push   %ebx
  801488:	50                   	push   %eax
  801489:	68 71 2a 80 00       	push   $0x802a71
  80148e:	e8 94 ed ff ff       	call   800227 <cprintf>
		return -E_INVAL;
  801493:	83 c4 10             	add    $0x10,%esp
  801496:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80149b:	eb da                	jmp    801477 <write+0x55>
		return -E_NOT_SUPP;
  80149d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014a2:	eb d3                	jmp    801477 <write+0x55>

008014a4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
  8014a7:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ad:	50                   	push   %eax
  8014ae:	ff 75 08             	pushl  0x8(%ebp)
  8014b1:	e8 30 fc ff ff       	call   8010e6 <fd_lookup>
  8014b6:	83 c4 10             	add    $0x10,%esp
  8014b9:	85 c0                	test   %eax,%eax
  8014bb:	78 0e                	js     8014cb <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c3:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014cb:	c9                   	leave  
  8014cc:	c3                   	ret    

008014cd <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
  8014d0:	53                   	push   %ebx
  8014d1:	83 ec 1c             	sub    $0x1c,%esp
  8014d4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014da:	50                   	push   %eax
  8014db:	53                   	push   %ebx
  8014dc:	e8 05 fc ff ff       	call   8010e6 <fd_lookup>
  8014e1:	83 c4 10             	add    $0x10,%esp
  8014e4:	85 c0                	test   %eax,%eax
  8014e6:	78 37                	js     80151f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014e8:	83 ec 08             	sub    $0x8,%esp
  8014eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ee:	50                   	push   %eax
  8014ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f2:	ff 30                	pushl  (%eax)
  8014f4:	e8 3d fc ff ff       	call   801136 <dev_lookup>
  8014f9:	83 c4 10             	add    $0x10,%esp
  8014fc:	85 c0                	test   %eax,%eax
  8014fe:	78 1f                	js     80151f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801503:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801507:	74 1b                	je     801524 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801509:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150c:	8b 52 18             	mov    0x18(%edx),%edx
  80150f:	85 d2                	test   %edx,%edx
  801511:	74 32                	je     801545 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801513:	83 ec 08             	sub    $0x8,%esp
  801516:	ff 75 0c             	pushl  0xc(%ebp)
  801519:	50                   	push   %eax
  80151a:	ff d2                	call   *%edx
  80151c:	83 c4 10             	add    $0x10,%esp
}
  80151f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801522:	c9                   	leave  
  801523:	c3                   	ret    
			thisenv->env_id, fdnum);
  801524:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801529:	8b 40 48             	mov    0x48(%eax),%eax
  80152c:	83 ec 04             	sub    $0x4,%esp
  80152f:	53                   	push   %ebx
  801530:	50                   	push   %eax
  801531:	68 34 2a 80 00       	push   $0x802a34
  801536:	e8 ec ec ff ff       	call   800227 <cprintf>
		return -E_INVAL;
  80153b:	83 c4 10             	add    $0x10,%esp
  80153e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801543:	eb da                	jmp    80151f <ftruncate+0x52>
		return -E_NOT_SUPP;
  801545:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80154a:	eb d3                	jmp    80151f <ftruncate+0x52>

0080154c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
  80154f:	53                   	push   %ebx
  801550:	83 ec 1c             	sub    $0x1c,%esp
  801553:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801556:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801559:	50                   	push   %eax
  80155a:	ff 75 08             	pushl  0x8(%ebp)
  80155d:	e8 84 fb ff ff       	call   8010e6 <fd_lookup>
  801562:	83 c4 10             	add    $0x10,%esp
  801565:	85 c0                	test   %eax,%eax
  801567:	78 4b                	js     8015b4 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801569:	83 ec 08             	sub    $0x8,%esp
  80156c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80156f:	50                   	push   %eax
  801570:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801573:	ff 30                	pushl  (%eax)
  801575:	e8 bc fb ff ff       	call   801136 <dev_lookup>
  80157a:	83 c4 10             	add    $0x10,%esp
  80157d:	85 c0                	test   %eax,%eax
  80157f:	78 33                	js     8015b4 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801584:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801588:	74 2f                	je     8015b9 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80158a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80158d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801594:	00 00 00 
	stat->st_isdir = 0;
  801597:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80159e:	00 00 00 
	stat->st_dev = dev;
  8015a1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015a7:	83 ec 08             	sub    $0x8,%esp
  8015aa:	53                   	push   %ebx
  8015ab:	ff 75 f0             	pushl  -0x10(%ebp)
  8015ae:	ff 50 14             	call   *0x14(%eax)
  8015b1:	83 c4 10             	add    $0x10,%esp
}
  8015b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    
		return -E_NOT_SUPP;
  8015b9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015be:	eb f4                	jmp    8015b4 <fstat+0x68>

008015c0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	56                   	push   %esi
  8015c4:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015c5:	83 ec 08             	sub    $0x8,%esp
  8015c8:	6a 00                	push   $0x0
  8015ca:	ff 75 08             	pushl  0x8(%ebp)
  8015cd:	e8 22 02 00 00       	call   8017f4 <open>
  8015d2:	89 c3                	mov    %eax,%ebx
  8015d4:	83 c4 10             	add    $0x10,%esp
  8015d7:	85 c0                	test   %eax,%eax
  8015d9:	78 1b                	js     8015f6 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015db:	83 ec 08             	sub    $0x8,%esp
  8015de:	ff 75 0c             	pushl  0xc(%ebp)
  8015e1:	50                   	push   %eax
  8015e2:	e8 65 ff ff ff       	call   80154c <fstat>
  8015e7:	89 c6                	mov    %eax,%esi
	close(fd);
  8015e9:	89 1c 24             	mov    %ebx,(%esp)
  8015ec:	e8 27 fc ff ff       	call   801218 <close>
	return r;
  8015f1:	83 c4 10             	add    $0x10,%esp
  8015f4:	89 f3                	mov    %esi,%ebx
}
  8015f6:	89 d8                	mov    %ebx,%eax
  8015f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015fb:	5b                   	pop    %ebx
  8015fc:	5e                   	pop    %esi
  8015fd:	5d                   	pop    %ebp
  8015fe:	c3                   	ret    

008015ff <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	56                   	push   %esi
  801603:	53                   	push   %ebx
  801604:	89 c6                	mov    %eax,%esi
  801606:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801608:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80160f:	74 27                	je     801638 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801611:	6a 07                	push   $0x7
  801613:	68 00 50 80 00       	push   $0x805000
  801618:	56                   	push   %esi
  801619:	ff 35 00 40 80 00    	pushl  0x804000
  80161f:	e8 69 0c 00 00       	call   80228d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801624:	83 c4 0c             	add    $0xc,%esp
  801627:	6a 00                	push   $0x0
  801629:	53                   	push   %ebx
  80162a:	6a 00                	push   $0x0
  80162c:	e8 f3 0b 00 00       	call   802224 <ipc_recv>
}
  801631:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801634:	5b                   	pop    %ebx
  801635:	5e                   	pop    %esi
  801636:	5d                   	pop    %ebp
  801637:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801638:	83 ec 0c             	sub    $0xc,%esp
  80163b:	6a 01                	push   $0x1
  80163d:	e8 a3 0c 00 00       	call   8022e5 <ipc_find_env>
  801642:	a3 00 40 80 00       	mov    %eax,0x804000
  801647:	83 c4 10             	add    $0x10,%esp
  80164a:	eb c5                	jmp    801611 <fsipc+0x12>

0080164c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
  80164f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801652:	8b 45 08             	mov    0x8(%ebp),%eax
  801655:	8b 40 0c             	mov    0xc(%eax),%eax
  801658:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80165d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801660:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801665:	ba 00 00 00 00       	mov    $0x0,%edx
  80166a:	b8 02 00 00 00       	mov    $0x2,%eax
  80166f:	e8 8b ff ff ff       	call   8015ff <fsipc>
}
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <devfile_flush>:
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
  801679:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	8b 40 0c             	mov    0xc(%eax),%eax
  801682:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801687:	ba 00 00 00 00       	mov    $0x0,%edx
  80168c:	b8 06 00 00 00       	mov    $0x6,%eax
  801691:	e8 69 ff ff ff       	call   8015ff <fsipc>
}
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <devfile_stat>:
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	53                   	push   %ebx
  80169c:	83 ec 04             	sub    $0x4,%esp
  80169f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8016a8:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b2:	b8 05 00 00 00       	mov    $0x5,%eax
  8016b7:	e8 43 ff ff ff       	call   8015ff <fsipc>
  8016bc:	85 c0                	test   %eax,%eax
  8016be:	78 2c                	js     8016ec <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016c0:	83 ec 08             	sub    $0x8,%esp
  8016c3:	68 00 50 80 00       	push   $0x805000
  8016c8:	53                   	push   %ebx
  8016c9:	e8 b8 f2 ff ff       	call   800986 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016ce:	a1 80 50 80 00       	mov    0x805080,%eax
  8016d3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016d9:	a1 84 50 80 00       	mov    0x805084,%eax
  8016de:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016e4:	83 c4 10             	add    $0x10,%esp
  8016e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <devfile_write>:
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
  8016f4:	53                   	push   %ebx
  8016f5:	83 ec 08             	sub    $0x8,%esp
  8016f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	8b 40 0c             	mov    0xc(%eax),%eax
  801701:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801706:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80170c:	53                   	push   %ebx
  80170d:	ff 75 0c             	pushl  0xc(%ebp)
  801710:	68 08 50 80 00       	push   $0x805008
  801715:	e8 5c f4 ff ff       	call   800b76 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80171a:	ba 00 00 00 00       	mov    $0x0,%edx
  80171f:	b8 04 00 00 00       	mov    $0x4,%eax
  801724:	e8 d6 fe ff ff       	call   8015ff <fsipc>
  801729:	83 c4 10             	add    $0x10,%esp
  80172c:	85 c0                	test   %eax,%eax
  80172e:	78 0b                	js     80173b <devfile_write+0x4a>
	assert(r <= n);
  801730:	39 d8                	cmp    %ebx,%eax
  801732:	77 0c                	ja     801740 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801734:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801739:	7f 1e                	jg     801759 <devfile_write+0x68>
}
  80173b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    
	assert(r <= n);
  801740:	68 a4 2a 80 00       	push   $0x802aa4
  801745:	68 ab 2a 80 00       	push   $0x802aab
  80174a:	68 98 00 00 00       	push   $0x98
  80174f:	68 c0 2a 80 00       	push   $0x802ac0
  801754:	e8 6a 0a 00 00       	call   8021c3 <_panic>
	assert(r <= PGSIZE);
  801759:	68 cb 2a 80 00       	push   $0x802acb
  80175e:	68 ab 2a 80 00       	push   $0x802aab
  801763:	68 99 00 00 00       	push   $0x99
  801768:	68 c0 2a 80 00       	push   $0x802ac0
  80176d:	e8 51 0a 00 00       	call   8021c3 <_panic>

00801772 <devfile_read>:
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
  801775:	56                   	push   %esi
  801776:	53                   	push   %ebx
  801777:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80177a:	8b 45 08             	mov    0x8(%ebp),%eax
  80177d:	8b 40 0c             	mov    0xc(%eax),%eax
  801780:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801785:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80178b:	ba 00 00 00 00       	mov    $0x0,%edx
  801790:	b8 03 00 00 00       	mov    $0x3,%eax
  801795:	e8 65 fe ff ff       	call   8015ff <fsipc>
  80179a:	89 c3                	mov    %eax,%ebx
  80179c:	85 c0                	test   %eax,%eax
  80179e:	78 1f                	js     8017bf <devfile_read+0x4d>
	assert(r <= n);
  8017a0:	39 f0                	cmp    %esi,%eax
  8017a2:	77 24                	ja     8017c8 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017a4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017a9:	7f 33                	jg     8017de <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017ab:	83 ec 04             	sub    $0x4,%esp
  8017ae:	50                   	push   %eax
  8017af:	68 00 50 80 00       	push   $0x805000
  8017b4:	ff 75 0c             	pushl  0xc(%ebp)
  8017b7:	e8 58 f3 ff ff       	call   800b14 <memmove>
	return r;
  8017bc:	83 c4 10             	add    $0x10,%esp
}
  8017bf:	89 d8                	mov    %ebx,%eax
  8017c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017c4:	5b                   	pop    %ebx
  8017c5:	5e                   	pop    %esi
  8017c6:	5d                   	pop    %ebp
  8017c7:	c3                   	ret    
	assert(r <= n);
  8017c8:	68 a4 2a 80 00       	push   $0x802aa4
  8017cd:	68 ab 2a 80 00       	push   $0x802aab
  8017d2:	6a 7c                	push   $0x7c
  8017d4:	68 c0 2a 80 00       	push   $0x802ac0
  8017d9:	e8 e5 09 00 00       	call   8021c3 <_panic>
	assert(r <= PGSIZE);
  8017de:	68 cb 2a 80 00       	push   $0x802acb
  8017e3:	68 ab 2a 80 00       	push   $0x802aab
  8017e8:	6a 7d                	push   $0x7d
  8017ea:	68 c0 2a 80 00       	push   $0x802ac0
  8017ef:	e8 cf 09 00 00       	call   8021c3 <_panic>

008017f4 <open>:
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
  8017f7:	56                   	push   %esi
  8017f8:	53                   	push   %ebx
  8017f9:	83 ec 1c             	sub    $0x1c,%esp
  8017fc:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017ff:	56                   	push   %esi
  801800:	e8 48 f1 ff ff       	call   80094d <strlen>
  801805:	83 c4 10             	add    $0x10,%esp
  801808:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80180d:	7f 6c                	jg     80187b <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80180f:	83 ec 0c             	sub    $0xc,%esp
  801812:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801815:	50                   	push   %eax
  801816:	e8 79 f8 ff ff       	call   801094 <fd_alloc>
  80181b:	89 c3                	mov    %eax,%ebx
  80181d:	83 c4 10             	add    $0x10,%esp
  801820:	85 c0                	test   %eax,%eax
  801822:	78 3c                	js     801860 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801824:	83 ec 08             	sub    $0x8,%esp
  801827:	56                   	push   %esi
  801828:	68 00 50 80 00       	push   $0x805000
  80182d:	e8 54 f1 ff ff       	call   800986 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801832:	8b 45 0c             	mov    0xc(%ebp),%eax
  801835:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80183a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80183d:	b8 01 00 00 00       	mov    $0x1,%eax
  801842:	e8 b8 fd ff ff       	call   8015ff <fsipc>
  801847:	89 c3                	mov    %eax,%ebx
  801849:	83 c4 10             	add    $0x10,%esp
  80184c:	85 c0                	test   %eax,%eax
  80184e:	78 19                	js     801869 <open+0x75>
	return fd2num(fd);
  801850:	83 ec 0c             	sub    $0xc,%esp
  801853:	ff 75 f4             	pushl  -0xc(%ebp)
  801856:	e8 12 f8 ff ff       	call   80106d <fd2num>
  80185b:	89 c3                	mov    %eax,%ebx
  80185d:	83 c4 10             	add    $0x10,%esp
}
  801860:	89 d8                	mov    %ebx,%eax
  801862:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801865:	5b                   	pop    %ebx
  801866:	5e                   	pop    %esi
  801867:	5d                   	pop    %ebp
  801868:	c3                   	ret    
		fd_close(fd, 0);
  801869:	83 ec 08             	sub    $0x8,%esp
  80186c:	6a 00                	push   $0x0
  80186e:	ff 75 f4             	pushl  -0xc(%ebp)
  801871:	e8 1b f9 ff ff       	call   801191 <fd_close>
		return r;
  801876:	83 c4 10             	add    $0x10,%esp
  801879:	eb e5                	jmp    801860 <open+0x6c>
		return -E_BAD_PATH;
  80187b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801880:	eb de                	jmp    801860 <open+0x6c>

00801882 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801888:	ba 00 00 00 00       	mov    $0x0,%edx
  80188d:	b8 08 00 00 00       	mov    $0x8,%eax
  801892:	e8 68 fd ff ff       	call   8015ff <fsipc>
}
  801897:	c9                   	leave  
  801898:	c3                   	ret    

00801899 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
  80189c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80189f:	68 d7 2a 80 00       	push   $0x802ad7
  8018a4:	ff 75 0c             	pushl  0xc(%ebp)
  8018a7:	e8 da f0 ff ff       	call   800986 <strcpy>
	return 0;
}
  8018ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b1:	c9                   	leave  
  8018b2:	c3                   	ret    

008018b3 <devsock_close>:
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
  8018b6:	53                   	push   %ebx
  8018b7:	83 ec 10             	sub    $0x10,%esp
  8018ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018bd:	53                   	push   %ebx
  8018be:	e8 61 0a 00 00       	call   802324 <pageref>
  8018c3:	83 c4 10             	add    $0x10,%esp
		return 0;
  8018c6:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8018cb:	83 f8 01             	cmp    $0x1,%eax
  8018ce:	74 07                	je     8018d7 <devsock_close+0x24>
}
  8018d0:	89 d0                	mov    %edx,%eax
  8018d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8018d7:	83 ec 0c             	sub    $0xc,%esp
  8018da:	ff 73 0c             	pushl  0xc(%ebx)
  8018dd:	e8 b9 02 00 00       	call   801b9b <nsipc_close>
  8018e2:	89 c2                	mov    %eax,%edx
  8018e4:	83 c4 10             	add    $0x10,%esp
  8018e7:	eb e7                	jmp    8018d0 <devsock_close+0x1d>

008018e9 <devsock_write>:
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
  8018ec:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018ef:	6a 00                	push   $0x0
  8018f1:	ff 75 10             	pushl  0x10(%ebp)
  8018f4:	ff 75 0c             	pushl  0xc(%ebp)
  8018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fa:	ff 70 0c             	pushl  0xc(%eax)
  8018fd:	e8 76 03 00 00       	call   801c78 <nsipc_send>
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <devsock_read>:
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
  801907:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80190a:	6a 00                	push   $0x0
  80190c:	ff 75 10             	pushl  0x10(%ebp)
  80190f:	ff 75 0c             	pushl  0xc(%ebp)
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	ff 70 0c             	pushl  0xc(%eax)
  801918:	e8 ef 02 00 00       	call   801c0c <nsipc_recv>
}
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <fd2sockid>:
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
  801922:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801925:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801928:	52                   	push   %edx
  801929:	50                   	push   %eax
  80192a:	e8 b7 f7 ff ff       	call   8010e6 <fd_lookup>
  80192f:	83 c4 10             	add    $0x10,%esp
  801932:	85 c0                	test   %eax,%eax
  801934:	78 10                	js     801946 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801939:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80193f:	39 08                	cmp    %ecx,(%eax)
  801941:	75 05                	jne    801948 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801943:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801946:	c9                   	leave  
  801947:	c3                   	ret    
		return -E_NOT_SUPP;
  801948:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80194d:	eb f7                	jmp    801946 <fd2sockid+0x27>

0080194f <alloc_sockfd>:
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
  801952:	56                   	push   %esi
  801953:	53                   	push   %ebx
  801954:	83 ec 1c             	sub    $0x1c,%esp
  801957:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801959:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80195c:	50                   	push   %eax
  80195d:	e8 32 f7 ff ff       	call   801094 <fd_alloc>
  801962:	89 c3                	mov    %eax,%ebx
  801964:	83 c4 10             	add    $0x10,%esp
  801967:	85 c0                	test   %eax,%eax
  801969:	78 43                	js     8019ae <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80196b:	83 ec 04             	sub    $0x4,%esp
  80196e:	68 07 04 00 00       	push   $0x407
  801973:	ff 75 f4             	pushl  -0xc(%ebp)
  801976:	6a 00                	push   $0x0
  801978:	e8 fb f3 ff ff       	call   800d78 <sys_page_alloc>
  80197d:	89 c3                	mov    %eax,%ebx
  80197f:	83 c4 10             	add    $0x10,%esp
  801982:	85 c0                	test   %eax,%eax
  801984:	78 28                	js     8019ae <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801989:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80198f:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801994:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80199b:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80199e:	83 ec 0c             	sub    $0xc,%esp
  8019a1:	50                   	push   %eax
  8019a2:	e8 c6 f6 ff ff       	call   80106d <fd2num>
  8019a7:	89 c3                	mov    %eax,%ebx
  8019a9:	83 c4 10             	add    $0x10,%esp
  8019ac:	eb 0c                	jmp    8019ba <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8019ae:	83 ec 0c             	sub    $0xc,%esp
  8019b1:	56                   	push   %esi
  8019b2:	e8 e4 01 00 00       	call   801b9b <nsipc_close>
		return r;
  8019b7:	83 c4 10             	add    $0x10,%esp
}
  8019ba:	89 d8                	mov    %ebx,%eax
  8019bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019bf:	5b                   	pop    %ebx
  8019c0:	5e                   	pop    %esi
  8019c1:	5d                   	pop    %ebp
  8019c2:	c3                   	ret    

008019c3 <accept>:
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cc:	e8 4e ff ff ff       	call   80191f <fd2sockid>
  8019d1:	85 c0                	test   %eax,%eax
  8019d3:	78 1b                	js     8019f0 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019d5:	83 ec 04             	sub    $0x4,%esp
  8019d8:	ff 75 10             	pushl  0x10(%ebp)
  8019db:	ff 75 0c             	pushl  0xc(%ebp)
  8019de:	50                   	push   %eax
  8019df:	e8 0e 01 00 00       	call   801af2 <nsipc_accept>
  8019e4:	83 c4 10             	add    $0x10,%esp
  8019e7:	85 c0                	test   %eax,%eax
  8019e9:	78 05                	js     8019f0 <accept+0x2d>
	return alloc_sockfd(r);
  8019eb:	e8 5f ff ff ff       	call   80194f <alloc_sockfd>
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <bind>:
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	e8 1f ff ff ff       	call   80191f <fd2sockid>
  801a00:	85 c0                	test   %eax,%eax
  801a02:	78 12                	js     801a16 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801a04:	83 ec 04             	sub    $0x4,%esp
  801a07:	ff 75 10             	pushl  0x10(%ebp)
  801a0a:	ff 75 0c             	pushl  0xc(%ebp)
  801a0d:	50                   	push   %eax
  801a0e:	e8 31 01 00 00       	call   801b44 <nsipc_bind>
  801a13:	83 c4 10             	add    $0x10,%esp
}
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <shutdown>:
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
  801a1b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a21:	e8 f9 fe ff ff       	call   80191f <fd2sockid>
  801a26:	85 c0                	test   %eax,%eax
  801a28:	78 0f                	js     801a39 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a2a:	83 ec 08             	sub    $0x8,%esp
  801a2d:	ff 75 0c             	pushl  0xc(%ebp)
  801a30:	50                   	push   %eax
  801a31:	e8 43 01 00 00       	call   801b79 <nsipc_shutdown>
  801a36:	83 c4 10             	add    $0x10,%esp
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <connect>:
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
  801a3e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a41:	8b 45 08             	mov    0x8(%ebp),%eax
  801a44:	e8 d6 fe ff ff       	call   80191f <fd2sockid>
  801a49:	85 c0                	test   %eax,%eax
  801a4b:	78 12                	js     801a5f <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a4d:	83 ec 04             	sub    $0x4,%esp
  801a50:	ff 75 10             	pushl  0x10(%ebp)
  801a53:	ff 75 0c             	pushl  0xc(%ebp)
  801a56:	50                   	push   %eax
  801a57:	e8 59 01 00 00       	call   801bb5 <nsipc_connect>
  801a5c:	83 c4 10             	add    $0x10,%esp
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <listen>:
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	e8 b0 fe ff ff       	call   80191f <fd2sockid>
  801a6f:	85 c0                	test   %eax,%eax
  801a71:	78 0f                	js     801a82 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a73:	83 ec 08             	sub    $0x8,%esp
  801a76:	ff 75 0c             	pushl  0xc(%ebp)
  801a79:	50                   	push   %eax
  801a7a:	e8 6b 01 00 00       	call   801bea <nsipc_listen>
  801a7f:	83 c4 10             	add    $0x10,%esp
}
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
  801a87:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a8a:	ff 75 10             	pushl  0x10(%ebp)
  801a8d:	ff 75 0c             	pushl  0xc(%ebp)
  801a90:	ff 75 08             	pushl  0x8(%ebp)
  801a93:	e8 3e 02 00 00       	call   801cd6 <nsipc_socket>
  801a98:	83 c4 10             	add    $0x10,%esp
  801a9b:	85 c0                	test   %eax,%eax
  801a9d:	78 05                	js     801aa4 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a9f:	e8 ab fe ff ff       	call   80194f <alloc_sockfd>
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
  801aa9:	53                   	push   %ebx
  801aaa:	83 ec 04             	sub    $0x4,%esp
  801aad:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801aaf:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801ab6:	74 26                	je     801ade <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ab8:	6a 07                	push   $0x7
  801aba:	68 00 60 80 00       	push   $0x806000
  801abf:	53                   	push   %ebx
  801ac0:	ff 35 04 40 80 00    	pushl  0x804004
  801ac6:	e8 c2 07 00 00       	call   80228d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801acb:	83 c4 0c             	add    $0xc,%esp
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	e8 4b 07 00 00       	call   802224 <ipc_recv>
}
  801ad9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801adc:	c9                   	leave  
  801add:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ade:	83 ec 0c             	sub    $0xc,%esp
  801ae1:	6a 02                	push   $0x2
  801ae3:	e8 fd 07 00 00       	call   8022e5 <ipc_find_env>
  801ae8:	a3 04 40 80 00       	mov    %eax,0x804004
  801aed:	83 c4 10             	add    $0x10,%esp
  801af0:	eb c6                	jmp    801ab8 <nsipc+0x12>

00801af2 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
  801af5:	56                   	push   %esi
  801af6:	53                   	push   %ebx
  801af7:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801afa:	8b 45 08             	mov    0x8(%ebp),%eax
  801afd:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b02:	8b 06                	mov    (%esi),%eax
  801b04:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b09:	b8 01 00 00 00       	mov    $0x1,%eax
  801b0e:	e8 93 ff ff ff       	call   801aa6 <nsipc>
  801b13:	89 c3                	mov    %eax,%ebx
  801b15:	85 c0                	test   %eax,%eax
  801b17:	79 09                	jns    801b22 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b19:	89 d8                	mov    %ebx,%eax
  801b1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b1e:	5b                   	pop    %ebx
  801b1f:	5e                   	pop    %esi
  801b20:	5d                   	pop    %ebp
  801b21:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b22:	83 ec 04             	sub    $0x4,%esp
  801b25:	ff 35 10 60 80 00    	pushl  0x806010
  801b2b:	68 00 60 80 00       	push   $0x806000
  801b30:	ff 75 0c             	pushl  0xc(%ebp)
  801b33:	e8 dc ef ff ff       	call   800b14 <memmove>
		*addrlen = ret->ret_addrlen;
  801b38:	a1 10 60 80 00       	mov    0x806010,%eax
  801b3d:	89 06                	mov    %eax,(%esi)
  801b3f:	83 c4 10             	add    $0x10,%esp
	return r;
  801b42:	eb d5                	jmp    801b19 <nsipc_accept+0x27>

00801b44 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
  801b47:	53                   	push   %ebx
  801b48:	83 ec 08             	sub    $0x8,%esp
  801b4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b51:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b56:	53                   	push   %ebx
  801b57:	ff 75 0c             	pushl  0xc(%ebp)
  801b5a:	68 04 60 80 00       	push   $0x806004
  801b5f:	e8 b0 ef ff ff       	call   800b14 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b64:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b6a:	b8 02 00 00 00       	mov    $0x2,%eax
  801b6f:	e8 32 ff ff ff       	call   801aa6 <nsipc>
}
  801b74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
  801b7c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b87:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b8f:	b8 03 00 00 00       	mov    $0x3,%eax
  801b94:	e8 0d ff ff ff       	call   801aa6 <nsipc>
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <nsipc_close>:

int
nsipc_close(int s)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ba9:	b8 04 00 00 00       	mov    $0x4,%eax
  801bae:	e8 f3 fe ff ff       	call   801aa6 <nsipc>
}
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
  801bb8:	53                   	push   %ebx
  801bb9:	83 ec 08             	sub    $0x8,%esp
  801bbc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801bc7:	53                   	push   %ebx
  801bc8:	ff 75 0c             	pushl  0xc(%ebp)
  801bcb:	68 04 60 80 00       	push   $0x806004
  801bd0:	e8 3f ef ff ff       	call   800b14 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801bd5:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801bdb:	b8 05 00 00 00       	mov    $0x5,%eax
  801be0:	e8 c1 fe ff ff       	call   801aa6 <nsipc>
}
  801be5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
  801bed:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bfb:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c00:	b8 06 00 00 00       	mov    $0x6,%eax
  801c05:	e8 9c fe ff ff       	call   801aa6 <nsipc>
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
  801c0f:	56                   	push   %esi
  801c10:	53                   	push   %ebx
  801c11:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c14:	8b 45 08             	mov    0x8(%ebp),%eax
  801c17:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c1c:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c22:	8b 45 14             	mov    0x14(%ebp),%eax
  801c25:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c2a:	b8 07 00 00 00       	mov    $0x7,%eax
  801c2f:	e8 72 fe ff ff       	call   801aa6 <nsipc>
  801c34:	89 c3                	mov    %eax,%ebx
  801c36:	85 c0                	test   %eax,%eax
  801c38:	78 1f                	js     801c59 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c3a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c3f:	7f 21                	jg     801c62 <nsipc_recv+0x56>
  801c41:	39 c6                	cmp    %eax,%esi
  801c43:	7c 1d                	jl     801c62 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c45:	83 ec 04             	sub    $0x4,%esp
  801c48:	50                   	push   %eax
  801c49:	68 00 60 80 00       	push   $0x806000
  801c4e:	ff 75 0c             	pushl  0xc(%ebp)
  801c51:	e8 be ee ff ff       	call   800b14 <memmove>
  801c56:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c59:	89 d8                	mov    %ebx,%eax
  801c5b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c5e:	5b                   	pop    %ebx
  801c5f:	5e                   	pop    %esi
  801c60:	5d                   	pop    %ebp
  801c61:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c62:	68 e3 2a 80 00       	push   $0x802ae3
  801c67:	68 ab 2a 80 00       	push   $0x802aab
  801c6c:	6a 62                	push   $0x62
  801c6e:	68 f8 2a 80 00       	push   $0x802af8
  801c73:	e8 4b 05 00 00       	call   8021c3 <_panic>

00801c78 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
  801c7b:	53                   	push   %ebx
  801c7c:	83 ec 04             	sub    $0x4,%esp
  801c7f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c82:	8b 45 08             	mov    0x8(%ebp),%eax
  801c85:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c8a:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c90:	7f 2e                	jg     801cc0 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c92:	83 ec 04             	sub    $0x4,%esp
  801c95:	53                   	push   %ebx
  801c96:	ff 75 0c             	pushl  0xc(%ebp)
  801c99:	68 0c 60 80 00       	push   $0x80600c
  801c9e:	e8 71 ee ff ff       	call   800b14 <memmove>
	nsipcbuf.send.req_size = size;
  801ca3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801ca9:	8b 45 14             	mov    0x14(%ebp),%eax
  801cac:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801cb1:	b8 08 00 00 00       	mov    $0x8,%eax
  801cb6:	e8 eb fd ff ff       	call   801aa6 <nsipc>
}
  801cbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    
	assert(size < 1600);
  801cc0:	68 04 2b 80 00       	push   $0x802b04
  801cc5:	68 ab 2a 80 00       	push   $0x802aab
  801cca:	6a 6d                	push   $0x6d
  801ccc:	68 f8 2a 80 00       	push   $0x802af8
  801cd1:	e8 ed 04 00 00       	call   8021c3 <_panic>

00801cd6 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
  801cd9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce7:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801cec:	8b 45 10             	mov    0x10(%ebp),%eax
  801cef:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801cf4:	b8 09 00 00 00       	mov    $0x9,%eax
  801cf9:	e8 a8 fd ff ff       	call   801aa6 <nsipc>
}
  801cfe:	c9                   	leave  
  801cff:	c3                   	ret    

00801d00 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
  801d03:	56                   	push   %esi
  801d04:	53                   	push   %ebx
  801d05:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d08:	83 ec 0c             	sub    $0xc,%esp
  801d0b:	ff 75 08             	pushl  0x8(%ebp)
  801d0e:	e8 6a f3 ff ff       	call   80107d <fd2data>
  801d13:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d15:	83 c4 08             	add    $0x8,%esp
  801d18:	68 10 2b 80 00       	push   $0x802b10
  801d1d:	53                   	push   %ebx
  801d1e:	e8 63 ec ff ff       	call   800986 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d23:	8b 46 04             	mov    0x4(%esi),%eax
  801d26:	2b 06                	sub    (%esi),%eax
  801d28:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d2e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d35:	00 00 00 
	stat->st_dev = &devpipe;
  801d38:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d3f:	30 80 00 
	return 0;
}
  801d42:	b8 00 00 00 00       	mov    $0x0,%eax
  801d47:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d4a:	5b                   	pop    %ebx
  801d4b:	5e                   	pop    %esi
  801d4c:	5d                   	pop    %ebp
  801d4d:	c3                   	ret    

00801d4e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
  801d51:	53                   	push   %ebx
  801d52:	83 ec 0c             	sub    $0xc,%esp
  801d55:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d58:	53                   	push   %ebx
  801d59:	6a 00                	push   $0x0
  801d5b:	e8 9d f0 ff ff       	call   800dfd <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d60:	89 1c 24             	mov    %ebx,(%esp)
  801d63:	e8 15 f3 ff ff       	call   80107d <fd2data>
  801d68:	83 c4 08             	add    $0x8,%esp
  801d6b:	50                   	push   %eax
  801d6c:	6a 00                	push   $0x0
  801d6e:	e8 8a f0 ff ff       	call   800dfd <sys_page_unmap>
}
  801d73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <_pipeisclosed>:
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
  801d7b:	57                   	push   %edi
  801d7c:	56                   	push   %esi
  801d7d:	53                   	push   %ebx
  801d7e:	83 ec 1c             	sub    $0x1c,%esp
  801d81:	89 c7                	mov    %eax,%edi
  801d83:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d85:	a1 08 40 80 00       	mov    0x804008,%eax
  801d8a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d8d:	83 ec 0c             	sub    $0xc,%esp
  801d90:	57                   	push   %edi
  801d91:	e8 8e 05 00 00       	call   802324 <pageref>
  801d96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d99:	89 34 24             	mov    %esi,(%esp)
  801d9c:	e8 83 05 00 00       	call   802324 <pageref>
		nn = thisenv->env_runs;
  801da1:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801da7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801daa:	83 c4 10             	add    $0x10,%esp
  801dad:	39 cb                	cmp    %ecx,%ebx
  801daf:	74 1b                	je     801dcc <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801db1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801db4:	75 cf                	jne    801d85 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801db6:	8b 42 58             	mov    0x58(%edx),%eax
  801db9:	6a 01                	push   $0x1
  801dbb:	50                   	push   %eax
  801dbc:	53                   	push   %ebx
  801dbd:	68 17 2b 80 00       	push   $0x802b17
  801dc2:	e8 60 e4 ff ff       	call   800227 <cprintf>
  801dc7:	83 c4 10             	add    $0x10,%esp
  801dca:	eb b9                	jmp    801d85 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801dcc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dcf:	0f 94 c0             	sete   %al
  801dd2:	0f b6 c0             	movzbl %al,%eax
}
  801dd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dd8:	5b                   	pop    %ebx
  801dd9:	5e                   	pop    %esi
  801dda:	5f                   	pop    %edi
  801ddb:	5d                   	pop    %ebp
  801ddc:	c3                   	ret    

00801ddd <devpipe_write>:
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
  801de0:	57                   	push   %edi
  801de1:	56                   	push   %esi
  801de2:	53                   	push   %ebx
  801de3:	83 ec 28             	sub    $0x28,%esp
  801de6:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801de9:	56                   	push   %esi
  801dea:	e8 8e f2 ff ff       	call   80107d <fd2data>
  801def:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801df1:	83 c4 10             	add    $0x10,%esp
  801df4:	bf 00 00 00 00       	mov    $0x0,%edi
  801df9:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801dfc:	74 4f                	je     801e4d <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801dfe:	8b 43 04             	mov    0x4(%ebx),%eax
  801e01:	8b 0b                	mov    (%ebx),%ecx
  801e03:	8d 51 20             	lea    0x20(%ecx),%edx
  801e06:	39 d0                	cmp    %edx,%eax
  801e08:	72 14                	jb     801e1e <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e0a:	89 da                	mov    %ebx,%edx
  801e0c:	89 f0                	mov    %esi,%eax
  801e0e:	e8 65 ff ff ff       	call   801d78 <_pipeisclosed>
  801e13:	85 c0                	test   %eax,%eax
  801e15:	75 3b                	jne    801e52 <devpipe_write+0x75>
			sys_yield();
  801e17:	e8 3d ef ff ff       	call   800d59 <sys_yield>
  801e1c:	eb e0                	jmp    801dfe <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e21:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e25:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e28:	89 c2                	mov    %eax,%edx
  801e2a:	c1 fa 1f             	sar    $0x1f,%edx
  801e2d:	89 d1                	mov    %edx,%ecx
  801e2f:	c1 e9 1b             	shr    $0x1b,%ecx
  801e32:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e35:	83 e2 1f             	and    $0x1f,%edx
  801e38:	29 ca                	sub    %ecx,%edx
  801e3a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e3e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e42:	83 c0 01             	add    $0x1,%eax
  801e45:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e48:	83 c7 01             	add    $0x1,%edi
  801e4b:	eb ac                	jmp    801df9 <devpipe_write+0x1c>
	return i;
  801e4d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e50:	eb 05                	jmp    801e57 <devpipe_write+0x7a>
				return 0;
  801e52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e5a:	5b                   	pop    %ebx
  801e5b:	5e                   	pop    %esi
  801e5c:	5f                   	pop    %edi
  801e5d:	5d                   	pop    %ebp
  801e5e:	c3                   	ret    

00801e5f <devpipe_read>:
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
  801e62:	57                   	push   %edi
  801e63:	56                   	push   %esi
  801e64:	53                   	push   %ebx
  801e65:	83 ec 18             	sub    $0x18,%esp
  801e68:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e6b:	57                   	push   %edi
  801e6c:	e8 0c f2 ff ff       	call   80107d <fd2data>
  801e71:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e73:	83 c4 10             	add    $0x10,%esp
  801e76:	be 00 00 00 00       	mov    $0x0,%esi
  801e7b:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e7e:	75 14                	jne    801e94 <devpipe_read+0x35>
	return i;
  801e80:	8b 45 10             	mov    0x10(%ebp),%eax
  801e83:	eb 02                	jmp    801e87 <devpipe_read+0x28>
				return i;
  801e85:	89 f0                	mov    %esi,%eax
}
  801e87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e8a:	5b                   	pop    %ebx
  801e8b:	5e                   	pop    %esi
  801e8c:	5f                   	pop    %edi
  801e8d:	5d                   	pop    %ebp
  801e8e:	c3                   	ret    
			sys_yield();
  801e8f:	e8 c5 ee ff ff       	call   800d59 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e94:	8b 03                	mov    (%ebx),%eax
  801e96:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e99:	75 18                	jne    801eb3 <devpipe_read+0x54>
			if (i > 0)
  801e9b:	85 f6                	test   %esi,%esi
  801e9d:	75 e6                	jne    801e85 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e9f:	89 da                	mov    %ebx,%edx
  801ea1:	89 f8                	mov    %edi,%eax
  801ea3:	e8 d0 fe ff ff       	call   801d78 <_pipeisclosed>
  801ea8:	85 c0                	test   %eax,%eax
  801eaa:	74 e3                	je     801e8f <devpipe_read+0x30>
				return 0;
  801eac:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb1:	eb d4                	jmp    801e87 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801eb3:	99                   	cltd   
  801eb4:	c1 ea 1b             	shr    $0x1b,%edx
  801eb7:	01 d0                	add    %edx,%eax
  801eb9:	83 e0 1f             	and    $0x1f,%eax
  801ebc:	29 d0                	sub    %edx,%eax
  801ebe:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ec3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ec6:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ec9:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801ecc:	83 c6 01             	add    $0x1,%esi
  801ecf:	eb aa                	jmp    801e7b <devpipe_read+0x1c>

00801ed1 <pipe>:
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
  801ed4:	56                   	push   %esi
  801ed5:	53                   	push   %ebx
  801ed6:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ed9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801edc:	50                   	push   %eax
  801edd:	e8 b2 f1 ff ff       	call   801094 <fd_alloc>
  801ee2:	89 c3                	mov    %eax,%ebx
  801ee4:	83 c4 10             	add    $0x10,%esp
  801ee7:	85 c0                	test   %eax,%eax
  801ee9:	0f 88 23 01 00 00    	js     802012 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eef:	83 ec 04             	sub    $0x4,%esp
  801ef2:	68 07 04 00 00       	push   $0x407
  801ef7:	ff 75 f4             	pushl  -0xc(%ebp)
  801efa:	6a 00                	push   $0x0
  801efc:	e8 77 ee ff ff       	call   800d78 <sys_page_alloc>
  801f01:	89 c3                	mov    %eax,%ebx
  801f03:	83 c4 10             	add    $0x10,%esp
  801f06:	85 c0                	test   %eax,%eax
  801f08:	0f 88 04 01 00 00    	js     802012 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f0e:	83 ec 0c             	sub    $0xc,%esp
  801f11:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f14:	50                   	push   %eax
  801f15:	e8 7a f1 ff ff       	call   801094 <fd_alloc>
  801f1a:	89 c3                	mov    %eax,%ebx
  801f1c:	83 c4 10             	add    $0x10,%esp
  801f1f:	85 c0                	test   %eax,%eax
  801f21:	0f 88 db 00 00 00    	js     802002 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f27:	83 ec 04             	sub    $0x4,%esp
  801f2a:	68 07 04 00 00       	push   $0x407
  801f2f:	ff 75 f0             	pushl  -0x10(%ebp)
  801f32:	6a 00                	push   $0x0
  801f34:	e8 3f ee ff ff       	call   800d78 <sys_page_alloc>
  801f39:	89 c3                	mov    %eax,%ebx
  801f3b:	83 c4 10             	add    $0x10,%esp
  801f3e:	85 c0                	test   %eax,%eax
  801f40:	0f 88 bc 00 00 00    	js     802002 <pipe+0x131>
	va = fd2data(fd0);
  801f46:	83 ec 0c             	sub    $0xc,%esp
  801f49:	ff 75 f4             	pushl  -0xc(%ebp)
  801f4c:	e8 2c f1 ff ff       	call   80107d <fd2data>
  801f51:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f53:	83 c4 0c             	add    $0xc,%esp
  801f56:	68 07 04 00 00       	push   $0x407
  801f5b:	50                   	push   %eax
  801f5c:	6a 00                	push   $0x0
  801f5e:	e8 15 ee ff ff       	call   800d78 <sys_page_alloc>
  801f63:	89 c3                	mov    %eax,%ebx
  801f65:	83 c4 10             	add    $0x10,%esp
  801f68:	85 c0                	test   %eax,%eax
  801f6a:	0f 88 82 00 00 00    	js     801ff2 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f70:	83 ec 0c             	sub    $0xc,%esp
  801f73:	ff 75 f0             	pushl  -0x10(%ebp)
  801f76:	e8 02 f1 ff ff       	call   80107d <fd2data>
  801f7b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f82:	50                   	push   %eax
  801f83:	6a 00                	push   $0x0
  801f85:	56                   	push   %esi
  801f86:	6a 00                	push   $0x0
  801f88:	e8 2e ee ff ff       	call   800dbb <sys_page_map>
  801f8d:	89 c3                	mov    %eax,%ebx
  801f8f:	83 c4 20             	add    $0x20,%esp
  801f92:	85 c0                	test   %eax,%eax
  801f94:	78 4e                	js     801fe4 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f96:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f9e:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801fa0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa3:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801faa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fad:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801faf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801fb9:	83 ec 0c             	sub    $0xc,%esp
  801fbc:	ff 75 f4             	pushl  -0xc(%ebp)
  801fbf:	e8 a9 f0 ff ff       	call   80106d <fd2num>
  801fc4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fc7:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fc9:	83 c4 04             	add    $0x4,%esp
  801fcc:	ff 75 f0             	pushl  -0x10(%ebp)
  801fcf:	e8 99 f0 ff ff       	call   80106d <fd2num>
  801fd4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fd7:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fda:	83 c4 10             	add    $0x10,%esp
  801fdd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fe2:	eb 2e                	jmp    802012 <pipe+0x141>
	sys_page_unmap(0, va);
  801fe4:	83 ec 08             	sub    $0x8,%esp
  801fe7:	56                   	push   %esi
  801fe8:	6a 00                	push   $0x0
  801fea:	e8 0e ee ff ff       	call   800dfd <sys_page_unmap>
  801fef:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ff2:	83 ec 08             	sub    $0x8,%esp
  801ff5:	ff 75 f0             	pushl  -0x10(%ebp)
  801ff8:	6a 00                	push   $0x0
  801ffa:	e8 fe ed ff ff       	call   800dfd <sys_page_unmap>
  801fff:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802002:	83 ec 08             	sub    $0x8,%esp
  802005:	ff 75 f4             	pushl  -0xc(%ebp)
  802008:	6a 00                	push   $0x0
  80200a:	e8 ee ed ff ff       	call   800dfd <sys_page_unmap>
  80200f:	83 c4 10             	add    $0x10,%esp
}
  802012:	89 d8                	mov    %ebx,%eax
  802014:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802017:	5b                   	pop    %ebx
  802018:	5e                   	pop    %esi
  802019:	5d                   	pop    %ebp
  80201a:	c3                   	ret    

0080201b <pipeisclosed>:
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802021:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802024:	50                   	push   %eax
  802025:	ff 75 08             	pushl  0x8(%ebp)
  802028:	e8 b9 f0 ff ff       	call   8010e6 <fd_lookup>
  80202d:	83 c4 10             	add    $0x10,%esp
  802030:	85 c0                	test   %eax,%eax
  802032:	78 18                	js     80204c <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802034:	83 ec 0c             	sub    $0xc,%esp
  802037:	ff 75 f4             	pushl  -0xc(%ebp)
  80203a:	e8 3e f0 ff ff       	call   80107d <fd2data>
	return _pipeisclosed(fd, p);
  80203f:	89 c2                	mov    %eax,%edx
  802041:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802044:	e8 2f fd ff ff       	call   801d78 <_pipeisclosed>
  802049:	83 c4 10             	add    $0x10,%esp
}
  80204c:	c9                   	leave  
  80204d:	c3                   	ret    

0080204e <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80204e:	b8 00 00 00 00       	mov    $0x0,%eax
  802053:	c3                   	ret    

00802054 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
  802057:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80205a:	68 2f 2b 80 00       	push   $0x802b2f
  80205f:	ff 75 0c             	pushl  0xc(%ebp)
  802062:	e8 1f e9 ff ff       	call   800986 <strcpy>
	return 0;
}
  802067:	b8 00 00 00 00       	mov    $0x0,%eax
  80206c:	c9                   	leave  
  80206d:	c3                   	ret    

0080206e <devcons_write>:
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
  802071:	57                   	push   %edi
  802072:	56                   	push   %esi
  802073:	53                   	push   %ebx
  802074:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80207a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80207f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802085:	3b 75 10             	cmp    0x10(%ebp),%esi
  802088:	73 31                	jae    8020bb <devcons_write+0x4d>
		m = n - tot;
  80208a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80208d:	29 f3                	sub    %esi,%ebx
  80208f:	83 fb 7f             	cmp    $0x7f,%ebx
  802092:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802097:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80209a:	83 ec 04             	sub    $0x4,%esp
  80209d:	53                   	push   %ebx
  80209e:	89 f0                	mov    %esi,%eax
  8020a0:	03 45 0c             	add    0xc(%ebp),%eax
  8020a3:	50                   	push   %eax
  8020a4:	57                   	push   %edi
  8020a5:	e8 6a ea ff ff       	call   800b14 <memmove>
		sys_cputs(buf, m);
  8020aa:	83 c4 08             	add    $0x8,%esp
  8020ad:	53                   	push   %ebx
  8020ae:	57                   	push   %edi
  8020af:	e8 08 ec ff ff       	call   800cbc <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020b4:	01 de                	add    %ebx,%esi
  8020b6:	83 c4 10             	add    $0x10,%esp
  8020b9:	eb ca                	jmp    802085 <devcons_write+0x17>
}
  8020bb:	89 f0                	mov    %esi,%eax
  8020bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020c0:	5b                   	pop    %ebx
  8020c1:	5e                   	pop    %esi
  8020c2:	5f                   	pop    %edi
  8020c3:	5d                   	pop    %ebp
  8020c4:	c3                   	ret    

008020c5 <devcons_read>:
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
  8020c8:	83 ec 08             	sub    $0x8,%esp
  8020cb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020d4:	74 21                	je     8020f7 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8020d6:	e8 ff eb ff ff       	call   800cda <sys_cgetc>
  8020db:	85 c0                	test   %eax,%eax
  8020dd:	75 07                	jne    8020e6 <devcons_read+0x21>
		sys_yield();
  8020df:	e8 75 ec ff ff       	call   800d59 <sys_yield>
  8020e4:	eb f0                	jmp    8020d6 <devcons_read+0x11>
	if (c < 0)
  8020e6:	78 0f                	js     8020f7 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020e8:	83 f8 04             	cmp    $0x4,%eax
  8020eb:	74 0c                	je     8020f9 <devcons_read+0x34>
	*(char*)vbuf = c;
  8020ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f0:	88 02                	mov    %al,(%edx)
	return 1;
  8020f2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020f7:	c9                   	leave  
  8020f8:	c3                   	ret    
		return 0;
  8020f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020fe:	eb f7                	jmp    8020f7 <devcons_read+0x32>

00802100 <cputchar>:
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802106:	8b 45 08             	mov    0x8(%ebp),%eax
  802109:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80210c:	6a 01                	push   $0x1
  80210e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802111:	50                   	push   %eax
  802112:	e8 a5 eb ff ff       	call   800cbc <sys_cputs>
}
  802117:	83 c4 10             	add    $0x10,%esp
  80211a:	c9                   	leave  
  80211b:	c3                   	ret    

0080211c <getchar>:
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
  80211f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802122:	6a 01                	push   $0x1
  802124:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802127:	50                   	push   %eax
  802128:	6a 00                	push   $0x0
  80212a:	e8 27 f2 ff ff       	call   801356 <read>
	if (r < 0)
  80212f:	83 c4 10             	add    $0x10,%esp
  802132:	85 c0                	test   %eax,%eax
  802134:	78 06                	js     80213c <getchar+0x20>
	if (r < 1)
  802136:	74 06                	je     80213e <getchar+0x22>
	return c;
  802138:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80213c:	c9                   	leave  
  80213d:	c3                   	ret    
		return -E_EOF;
  80213e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802143:	eb f7                	jmp    80213c <getchar+0x20>

00802145 <iscons>:
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
  802148:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80214b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80214e:	50                   	push   %eax
  80214f:	ff 75 08             	pushl  0x8(%ebp)
  802152:	e8 8f ef ff ff       	call   8010e6 <fd_lookup>
  802157:	83 c4 10             	add    $0x10,%esp
  80215a:	85 c0                	test   %eax,%eax
  80215c:	78 11                	js     80216f <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80215e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802161:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802167:	39 10                	cmp    %edx,(%eax)
  802169:	0f 94 c0             	sete   %al
  80216c:	0f b6 c0             	movzbl %al,%eax
}
  80216f:	c9                   	leave  
  802170:	c3                   	ret    

00802171 <opencons>:
{
  802171:	55                   	push   %ebp
  802172:	89 e5                	mov    %esp,%ebp
  802174:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802177:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80217a:	50                   	push   %eax
  80217b:	e8 14 ef ff ff       	call   801094 <fd_alloc>
  802180:	83 c4 10             	add    $0x10,%esp
  802183:	85 c0                	test   %eax,%eax
  802185:	78 3a                	js     8021c1 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802187:	83 ec 04             	sub    $0x4,%esp
  80218a:	68 07 04 00 00       	push   $0x407
  80218f:	ff 75 f4             	pushl  -0xc(%ebp)
  802192:	6a 00                	push   $0x0
  802194:	e8 df eb ff ff       	call   800d78 <sys_page_alloc>
  802199:	83 c4 10             	add    $0x10,%esp
  80219c:	85 c0                	test   %eax,%eax
  80219e:	78 21                	js     8021c1 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8021a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021a9:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ae:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021b5:	83 ec 0c             	sub    $0xc,%esp
  8021b8:	50                   	push   %eax
  8021b9:	e8 af ee ff ff       	call   80106d <fd2num>
  8021be:	83 c4 10             	add    $0x10,%esp
}
  8021c1:	c9                   	leave  
  8021c2:	c3                   	ret    

008021c3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8021c3:	55                   	push   %ebp
  8021c4:	89 e5                	mov    %esp,%ebp
  8021c6:	56                   	push   %esi
  8021c7:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8021c8:	a1 08 40 80 00       	mov    0x804008,%eax
  8021cd:	8b 40 48             	mov    0x48(%eax),%eax
  8021d0:	83 ec 04             	sub    $0x4,%esp
  8021d3:	68 60 2b 80 00       	push   $0x802b60
  8021d8:	50                   	push   %eax
  8021d9:	68 5a 26 80 00       	push   $0x80265a
  8021de:	e8 44 e0 ff ff       	call   800227 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8021e3:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021e6:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021ec:	e8 49 eb ff ff       	call   800d3a <sys_getenvid>
  8021f1:	83 c4 04             	add    $0x4,%esp
  8021f4:	ff 75 0c             	pushl  0xc(%ebp)
  8021f7:	ff 75 08             	pushl  0x8(%ebp)
  8021fa:	56                   	push   %esi
  8021fb:	50                   	push   %eax
  8021fc:	68 3c 2b 80 00       	push   $0x802b3c
  802201:	e8 21 e0 ff ff       	call   800227 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802206:	83 c4 18             	add    $0x18,%esp
  802209:	53                   	push   %ebx
  80220a:	ff 75 10             	pushl  0x10(%ebp)
  80220d:	e8 c4 df ff ff       	call   8001d6 <vcprintf>
	cprintf("\n");
  802212:	c7 04 24 1e 26 80 00 	movl   $0x80261e,(%esp)
  802219:	e8 09 e0 ff ff       	call   800227 <cprintf>
  80221e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802221:	cc                   	int3   
  802222:	eb fd                	jmp    802221 <_panic+0x5e>

00802224 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
  802227:	56                   	push   %esi
  802228:	53                   	push   %ebx
  802229:	8b 75 08             	mov    0x8(%ebp),%esi
  80222c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80222f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802232:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802234:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802239:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80223c:	83 ec 0c             	sub    $0xc,%esp
  80223f:	50                   	push   %eax
  802240:	e8 e3 ec ff ff       	call   800f28 <sys_ipc_recv>
	if(ret < 0){
  802245:	83 c4 10             	add    $0x10,%esp
  802248:	85 c0                	test   %eax,%eax
  80224a:	78 2b                	js     802277 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80224c:	85 f6                	test   %esi,%esi
  80224e:	74 0a                	je     80225a <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802250:	a1 08 40 80 00       	mov    0x804008,%eax
  802255:	8b 40 78             	mov    0x78(%eax),%eax
  802258:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80225a:	85 db                	test   %ebx,%ebx
  80225c:	74 0a                	je     802268 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80225e:	a1 08 40 80 00       	mov    0x804008,%eax
  802263:	8b 40 7c             	mov    0x7c(%eax),%eax
  802266:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802268:	a1 08 40 80 00       	mov    0x804008,%eax
  80226d:	8b 40 74             	mov    0x74(%eax),%eax
}
  802270:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802273:	5b                   	pop    %ebx
  802274:	5e                   	pop    %esi
  802275:	5d                   	pop    %ebp
  802276:	c3                   	ret    
		if(from_env_store)
  802277:	85 f6                	test   %esi,%esi
  802279:	74 06                	je     802281 <ipc_recv+0x5d>
			*from_env_store = 0;
  80227b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802281:	85 db                	test   %ebx,%ebx
  802283:	74 eb                	je     802270 <ipc_recv+0x4c>
			*perm_store = 0;
  802285:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80228b:	eb e3                	jmp    802270 <ipc_recv+0x4c>

0080228d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
  802290:	57                   	push   %edi
  802291:	56                   	push   %esi
  802292:	53                   	push   %ebx
  802293:	83 ec 0c             	sub    $0xc,%esp
  802296:	8b 7d 08             	mov    0x8(%ebp),%edi
  802299:	8b 75 0c             	mov    0xc(%ebp),%esi
  80229c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80229f:	85 db                	test   %ebx,%ebx
  8022a1:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8022a6:	0f 44 d8             	cmove  %eax,%ebx
  8022a9:	eb 05                	jmp    8022b0 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8022ab:	e8 a9 ea ff ff       	call   800d59 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8022b0:	ff 75 14             	pushl  0x14(%ebp)
  8022b3:	53                   	push   %ebx
  8022b4:	56                   	push   %esi
  8022b5:	57                   	push   %edi
  8022b6:	e8 4a ec ff ff       	call   800f05 <sys_ipc_try_send>
  8022bb:	83 c4 10             	add    $0x10,%esp
  8022be:	85 c0                	test   %eax,%eax
  8022c0:	74 1b                	je     8022dd <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8022c2:	79 e7                	jns    8022ab <ipc_send+0x1e>
  8022c4:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022c7:	74 e2                	je     8022ab <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8022c9:	83 ec 04             	sub    $0x4,%esp
  8022cc:	68 67 2b 80 00       	push   $0x802b67
  8022d1:	6a 46                	push   $0x46
  8022d3:	68 7c 2b 80 00       	push   $0x802b7c
  8022d8:	e8 e6 fe ff ff       	call   8021c3 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8022dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022e0:	5b                   	pop    %ebx
  8022e1:	5e                   	pop    %esi
  8022e2:	5f                   	pop    %edi
  8022e3:	5d                   	pop    %ebp
  8022e4:	c3                   	ret    

008022e5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
  8022e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022eb:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022f0:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8022f6:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022fc:	8b 52 50             	mov    0x50(%edx),%edx
  8022ff:	39 ca                	cmp    %ecx,%edx
  802301:	74 11                	je     802314 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802303:	83 c0 01             	add    $0x1,%eax
  802306:	3d 00 04 00 00       	cmp    $0x400,%eax
  80230b:	75 e3                	jne    8022f0 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80230d:	b8 00 00 00 00       	mov    $0x0,%eax
  802312:	eb 0e                	jmp    802322 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802314:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80231a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80231f:	8b 40 48             	mov    0x48(%eax),%eax
}
  802322:	5d                   	pop    %ebp
  802323:	c3                   	ret    

00802324 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
  802327:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80232a:	89 d0                	mov    %edx,%eax
  80232c:	c1 e8 16             	shr    $0x16,%eax
  80232f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802336:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80233b:	f6 c1 01             	test   $0x1,%cl
  80233e:	74 1d                	je     80235d <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802340:	c1 ea 0c             	shr    $0xc,%edx
  802343:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80234a:	f6 c2 01             	test   $0x1,%dl
  80234d:	74 0e                	je     80235d <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80234f:	c1 ea 0c             	shr    $0xc,%edx
  802352:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802359:	ef 
  80235a:	0f b7 c0             	movzwl %ax,%eax
}
  80235d:	5d                   	pop    %ebp
  80235e:	c3                   	ret    
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
