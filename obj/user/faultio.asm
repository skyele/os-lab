
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
  80002c:	e8 3e 00 00 00       	call   80006f <libmain>
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
  800036:	83 ec 08             	sub    $0x8,%esp

static inline uint32_t
read_eflags(void)
{
	uint32_t eflags;
	asm volatile("pushfl; popl %0" : "=r" (eflags));
  800039:	9c                   	pushf  
  80003a:	58                   	pop    %eax
        int x, r;
	int nsecs = 1;
	int secno = 0;
	int diskno = 1;

	if (read_eflags() & FL_IOPL_3)
  80003b:	f6 c4 30             	test   $0x30,%ah
  80003e:	75 1d                	jne    80005d <umain+0x2a>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800040:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800045:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80004a:	ee                   	out    %al,(%dx)

	// this outb to select disk 1 should result in a general protection
	// fault, because user-level code shouldn't be able to use the io space.
	outb(0x1F6, 0xE0 | (1<<4));

        cprintf("%s: made it here --- bug\n");
  80004b:	83 ec 0c             	sub    $0xc,%esp
  80004e:	68 ee 11 80 00       	push   $0x8011ee
  800053:	e8 53 01 00 00       	call   8001ab <cprintf>
}
  800058:	83 c4 10             	add    $0x10,%esp
  80005b:	c9                   	leave  
  80005c:	c3                   	ret    
		cprintf("eflags wrong\n");
  80005d:	83 ec 0c             	sub    $0xc,%esp
  800060:	68 e0 11 80 00       	push   $0x8011e0
  800065:	e8 41 01 00 00       	call   8001ab <cprintf>
  80006a:	83 c4 10             	add    $0x10,%esp
  80006d:	eb d1                	jmp    800040 <umain+0xd>

0080006f <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80006f:	55                   	push   %ebp
  800070:	89 e5                	mov    %esp,%ebp
  800072:	57                   	push   %edi
  800073:	56                   	push   %esi
  800074:	53                   	push   %ebx
  800075:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800078:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  80007f:	00 00 00 
	envid_t find = sys_getenvid();
  800082:	e8 37 0c 00 00       	call   800cbe <sys_getenvid>
  800087:	8b 1d 04 20 80 00    	mov    0x802004,%ebx
  80008d:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800092:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800097:	bf 01 00 00 00       	mov    $0x1,%edi
  80009c:	eb 0b                	jmp    8000a9 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  80009e:	83 c2 01             	add    $0x1,%edx
  8000a1:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000a7:	74 21                	je     8000ca <libmain+0x5b>
		if(envs[i].env_id == find)
  8000a9:	89 d1                	mov    %edx,%ecx
  8000ab:	c1 e1 07             	shl    $0x7,%ecx
  8000ae:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000b4:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000b7:	39 c1                	cmp    %eax,%ecx
  8000b9:	75 e3                	jne    80009e <libmain+0x2f>
  8000bb:	89 d3                	mov    %edx,%ebx
  8000bd:	c1 e3 07             	shl    $0x7,%ebx
  8000c0:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000c6:	89 fe                	mov    %edi,%esi
  8000c8:	eb d4                	jmp    80009e <libmain+0x2f>
  8000ca:	89 f0                	mov    %esi,%eax
  8000cc:	84 c0                	test   %al,%al
  8000ce:	74 06                	je     8000d6 <libmain+0x67>
  8000d0:	89 1d 04 20 80 00    	mov    %ebx,0x802004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000da:	7e 0a                	jle    8000e6 <libmain+0x77>
		binaryname = argv[0];
  8000dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000df:	8b 00                	mov    (%eax),%eax
  8000e1:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000e6:	83 ec 08             	sub    $0x8,%esp
  8000e9:	ff 75 0c             	pushl  0xc(%ebp)
  8000ec:	ff 75 08             	pushl  0x8(%ebp)
  8000ef:	e8 3f ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000f4:	e8 0b 00 00 00       	call   800104 <exit>
}
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000ff:	5b                   	pop    %ebx
  800100:	5e                   	pop    %esi
  800101:	5f                   	pop    %edi
  800102:	5d                   	pop    %ebp
  800103:	c3                   	ret    

00800104 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800104:	55                   	push   %ebp
  800105:	89 e5                	mov    %esp,%ebp
  800107:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80010a:	6a 00                	push   $0x0
  80010c:	e8 6c 0b 00 00       	call   800c7d <sys_env_destroy>
}
  800111:	83 c4 10             	add    $0x10,%esp
  800114:	c9                   	leave  
  800115:	c3                   	ret    

00800116 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800116:	55                   	push   %ebp
  800117:	89 e5                	mov    %esp,%ebp
  800119:	53                   	push   %ebx
  80011a:	83 ec 04             	sub    $0x4,%esp
  80011d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800120:	8b 13                	mov    (%ebx),%edx
  800122:	8d 42 01             	lea    0x1(%edx),%eax
  800125:	89 03                	mov    %eax,(%ebx)
  800127:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80012a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80012e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800133:	74 09                	je     80013e <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800135:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800139:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80013c:	c9                   	leave  
  80013d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80013e:	83 ec 08             	sub    $0x8,%esp
  800141:	68 ff 00 00 00       	push   $0xff
  800146:	8d 43 08             	lea    0x8(%ebx),%eax
  800149:	50                   	push   %eax
  80014a:	e8 f1 0a 00 00       	call   800c40 <sys_cputs>
		b->idx = 0;
  80014f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800155:	83 c4 10             	add    $0x10,%esp
  800158:	eb db                	jmp    800135 <putch+0x1f>

0080015a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80015a:	55                   	push   %ebp
  80015b:	89 e5                	mov    %esp,%ebp
  80015d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800163:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80016a:	00 00 00 
	b.cnt = 0;
  80016d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800174:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800177:	ff 75 0c             	pushl  0xc(%ebp)
  80017a:	ff 75 08             	pushl  0x8(%ebp)
  80017d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800183:	50                   	push   %eax
  800184:	68 16 01 80 00       	push   $0x800116
  800189:	e8 4a 01 00 00       	call   8002d8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80018e:	83 c4 08             	add    $0x8,%esp
  800191:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800197:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80019d:	50                   	push   %eax
  80019e:	e8 9d 0a 00 00       	call   800c40 <sys_cputs>

	return b.cnt;
}
  8001a3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001a9:	c9                   	leave  
  8001aa:	c3                   	ret    

008001ab <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001ab:	55                   	push   %ebp
  8001ac:	89 e5                	mov    %esp,%ebp
  8001ae:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b1:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b4:	50                   	push   %eax
  8001b5:	ff 75 08             	pushl  0x8(%ebp)
  8001b8:	e8 9d ff ff ff       	call   80015a <vcprintf>
	va_end(ap);

	return cnt;
}
  8001bd:	c9                   	leave  
  8001be:	c3                   	ret    

008001bf <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001bf:	55                   	push   %ebp
  8001c0:	89 e5                	mov    %esp,%ebp
  8001c2:	57                   	push   %edi
  8001c3:	56                   	push   %esi
  8001c4:	53                   	push   %ebx
  8001c5:	83 ec 1c             	sub    $0x1c,%esp
  8001c8:	89 c6                	mov    %eax,%esi
  8001ca:	89 d7                	mov    %edx,%edi
  8001cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8001cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001d5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8001db:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001de:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001e2:	74 2c                	je     800210 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8001e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001e7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001f1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001f4:	39 c2                	cmp    %eax,%edx
  8001f6:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001f9:	73 43                	jae    80023e <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8001fb:	83 eb 01             	sub    $0x1,%ebx
  8001fe:	85 db                	test   %ebx,%ebx
  800200:	7e 6c                	jle    80026e <printnum+0xaf>
				putch(padc, putdat);
  800202:	83 ec 08             	sub    $0x8,%esp
  800205:	57                   	push   %edi
  800206:	ff 75 18             	pushl  0x18(%ebp)
  800209:	ff d6                	call   *%esi
  80020b:	83 c4 10             	add    $0x10,%esp
  80020e:	eb eb                	jmp    8001fb <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800210:	83 ec 0c             	sub    $0xc,%esp
  800213:	6a 20                	push   $0x20
  800215:	6a 00                	push   $0x0
  800217:	50                   	push   %eax
  800218:	ff 75 e4             	pushl  -0x1c(%ebp)
  80021b:	ff 75 e0             	pushl  -0x20(%ebp)
  80021e:	89 fa                	mov    %edi,%edx
  800220:	89 f0                	mov    %esi,%eax
  800222:	e8 98 ff ff ff       	call   8001bf <printnum>
		while (--width > 0)
  800227:	83 c4 20             	add    $0x20,%esp
  80022a:	83 eb 01             	sub    $0x1,%ebx
  80022d:	85 db                	test   %ebx,%ebx
  80022f:	7e 65                	jle    800296 <printnum+0xd7>
			putch(padc, putdat);
  800231:	83 ec 08             	sub    $0x8,%esp
  800234:	57                   	push   %edi
  800235:	6a 20                	push   $0x20
  800237:	ff d6                	call   *%esi
  800239:	83 c4 10             	add    $0x10,%esp
  80023c:	eb ec                	jmp    80022a <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	ff 75 18             	pushl  0x18(%ebp)
  800244:	83 eb 01             	sub    $0x1,%ebx
  800247:	53                   	push   %ebx
  800248:	50                   	push   %eax
  800249:	83 ec 08             	sub    $0x8,%esp
  80024c:	ff 75 dc             	pushl  -0x24(%ebp)
  80024f:	ff 75 d8             	pushl  -0x28(%ebp)
  800252:	ff 75 e4             	pushl  -0x1c(%ebp)
  800255:	ff 75 e0             	pushl  -0x20(%ebp)
  800258:	e8 33 0d 00 00       	call   800f90 <__udivdi3>
  80025d:	83 c4 18             	add    $0x18,%esp
  800260:	52                   	push   %edx
  800261:	50                   	push   %eax
  800262:	89 fa                	mov    %edi,%edx
  800264:	89 f0                	mov    %esi,%eax
  800266:	e8 54 ff ff ff       	call   8001bf <printnum>
  80026b:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80026e:	83 ec 08             	sub    $0x8,%esp
  800271:	57                   	push   %edi
  800272:	83 ec 04             	sub    $0x4,%esp
  800275:	ff 75 dc             	pushl  -0x24(%ebp)
  800278:	ff 75 d8             	pushl  -0x28(%ebp)
  80027b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027e:	ff 75 e0             	pushl  -0x20(%ebp)
  800281:	e8 1a 0e 00 00       	call   8010a0 <__umoddi3>
  800286:	83 c4 14             	add    $0x14,%esp
  800289:	0f be 80 12 12 80 00 	movsbl 0x801212(%eax),%eax
  800290:	50                   	push   %eax
  800291:	ff d6                	call   *%esi
  800293:	83 c4 10             	add    $0x10,%esp
	}
}
  800296:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800299:	5b                   	pop    %ebx
  80029a:	5e                   	pop    %esi
  80029b:	5f                   	pop    %edi
  80029c:	5d                   	pop    %ebp
  80029d:	c3                   	ret    

0080029e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80029e:	55                   	push   %ebp
  80029f:	89 e5                	mov    %esp,%ebp
  8002a1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002a4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002a8:	8b 10                	mov    (%eax),%edx
  8002aa:	3b 50 04             	cmp    0x4(%eax),%edx
  8002ad:	73 0a                	jae    8002b9 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002af:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002b2:	89 08                	mov    %ecx,(%eax)
  8002b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b7:	88 02                	mov    %al,(%edx)
}
  8002b9:	5d                   	pop    %ebp
  8002ba:	c3                   	ret    

008002bb <printfmt>:
{
  8002bb:	55                   	push   %ebp
  8002bc:	89 e5                	mov    %esp,%ebp
  8002be:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002c1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002c4:	50                   	push   %eax
  8002c5:	ff 75 10             	pushl  0x10(%ebp)
  8002c8:	ff 75 0c             	pushl  0xc(%ebp)
  8002cb:	ff 75 08             	pushl  0x8(%ebp)
  8002ce:	e8 05 00 00 00       	call   8002d8 <vprintfmt>
}
  8002d3:	83 c4 10             	add    $0x10,%esp
  8002d6:	c9                   	leave  
  8002d7:	c3                   	ret    

008002d8 <vprintfmt>:
{
  8002d8:	55                   	push   %ebp
  8002d9:	89 e5                	mov    %esp,%ebp
  8002db:	57                   	push   %edi
  8002dc:	56                   	push   %esi
  8002dd:	53                   	push   %ebx
  8002de:	83 ec 3c             	sub    $0x3c,%esp
  8002e1:	8b 75 08             	mov    0x8(%ebp),%esi
  8002e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002e7:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002ea:	e9 32 04 00 00       	jmp    800721 <vprintfmt+0x449>
		padc = ' ';
  8002ef:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8002f3:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8002fa:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800301:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800308:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80030f:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800316:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80031b:	8d 47 01             	lea    0x1(%edi),%eax
  80031e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800321:	0f b6 17             	movzbl (%edi),%edx
  800324:	8d 42 dd             	lea    -0x23(%edx),%eax
  800327:	3c 55                	cmp    $0x55,%al
  800329:	0f 87 12 05 00 00    	ja     800841 <vprintfmt+0x569>
  80032f:	0f b6 c0             	movzbl %al,%eax
  800332:	ff 24 85 00 14 80 00 	jmp    *0x801400(,%eax,4)
  800339:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80033c:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800340:	eb d9                	jmp    80031b <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800342:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800345:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800349:	eb d0                	jmp    80031b <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80034b:	0f b6 d2             	movzbl %dl,%edx
  80034e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800351:	b8 00 00 00 00       	mov    $0x0,%eax
  800356:	89 75 08             	mov    %esi,0x8(%ebp)
  800359:	eb 03                	jmp    80035e <vprintfmt+0x86>
  80035b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80035e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800361:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800365:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800368:	8d 72 d0             	lea    -0x30(%edx),%esi
  80036b:	83 fe 09             	cmp    $0x9,%esi
  80036e:	76 eb                	jbe    80035b <vprintfmt+0x83>
  800370:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800373:	8b 75 08             	mov    0x8(%ebp),%esi
  800376:	eb 14                	jmp    80038c <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800378:	8b 45 14             	mov    0x14(%ebp),%eax
  80037b:	8b 00                	mov    (%eax),%eax
  80037d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800380:	8b 45 14             	mov    0x14(%ebp),%eax
  800383:	8d 40 04             	lea    0x4(%eax),%eax
  800386:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800389:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80038c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800390:	79 89                	jns    80031b <vprintfmt+0x43>
				width = precision, precision = -1;
  800392:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800395:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800398:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80039f:	e9 77 ff ff ff       	jmp    80031b <vprintfmt+0x43>
  8003a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a7:	85 c0                	test   %eax,%eax
  8003a9:	0f 48 c1             	cmovs  %ecx,%eax
  8003ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003b2:	e9 64 ff ff ff       	jmp    80031b <vprintfmt+0x43>
  8003b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003ba:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003c1:	e9 55 ff ff ff       	jmp    80031b <vprintfmt+0x43>
			lflag++;
  8003c6:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003cd:	e9 49 ff ff ff       	jmp    80031b <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d5:	8d 78 04             	lea    0x4(%eax),%edi
  8003d8:	83 ec 08             	sub    $0x8,%esp
  8003db:	53                   	push   %ebx
  8003dc:	ff 30                	pushl  (%eax)
  8003de:	ff d6                	call   *%esi
			break;
  8003e0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003e3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003e6:	e9 33 03 00 00       	jmp    80071e <vprintfmt+0x446>
			err = va_arg(ap, int);
  8003eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ee:	8d 78 04             	lea    0x4(%eax),%edi
  8003f1:	8b 00                	mov    (%eax),%eax
  8003f3:	99                   	cltd   
  8003f4:	31 d0                	xor    %edx,%eax
  8003f6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003f8:	83 f8 0f             	cmp    $0xf,%eax
  8003fb:	7f 23                	jg     800420 <vprintfmt+0x148>
  8003fd:	8b 14 85 60 15 80 00 	mov    0x801560(,%eax,4),%edx
  800404:	85 d2                	test   %edx,%edx
  800406:	74 18                	je     800420 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800408:	52                   	push   %edx
  800409:	68 33 12 80 00       	push   $0x801233
  80040e:	53                   	push   %ebx
  80040f:	56                   	push   %esi
  800410:	e8 a6 fe ff ff       	call   8002bb <printfmt>
  800415:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800418:	89 7d 14             	mov    %edi,0x14(%ebp)
  80041b:	e9 fe 02 00 00       	jmp    80071e <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800420:	50                   	push   %eax
  800421:	68 2a 12 80 00       	push   $0x80122a
  800426:	53                   	push   %ebx
  800427:	56                   	push   %esi
  800428:	e8 8e fe ff ff       	call   8002bb <printfmt>
  80042d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800430:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800433:	e9 e6 02 00 00       	jmp    80071e <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800438:	8b 45 14             	mov    0x14(%ebp),%eax
  80043b:	83 c0 04             	add    $0x4,%eax
  80043e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800441:	8b 45 14             	mov    0x14(%ebp),%eax
  800444:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800446:	85 c9                	test   %ecx,%ecx
  800448:	b8 23 12 80 00       	mov    $0x801223,%eax
  80044d:	0f 45 c1             	cmovne %ecx,%eax
  800450:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800453:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800457:	7e 06                	jle    80045f <vprintfmt+0x187>
  800459:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80045d:	75 0d                	jne    80046c <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80045f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800462:	89 c7                	mov    %eax,%edi
  800464:	03 45 e0             	add    -0x20(%ebp),%eax
  800467:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80046a:	eb 53                	jmp    8004bf <vprintfmt+0x1e7>
  80046c:	83 ec 08             	sub    $0x8,%esp
  80046f:	ff 75 d8             	pushl  -0x28(%ebp)
  800472:	50                   	push   %eax
  800473:	e8 71 04 00 00       	call   8008e9 <strnlen>
  800478:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80047b:	29 c1                	sub    %eax,%ecx
  80047d:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800480:	83 c4 10             	add    $0x10,%esp
  800483:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800485:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800489:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80048c:	eb 0f                	jmp    80049d <vprintfmt+0x1c5>
					putch(padc, putdat);
  80048e:	83 ec 08             	sub    $0x8,%esp
  800491:	53                   	push   %ebx
  800492:	ff 75 e0             	pushl  -0x20(%ebp)
  800495:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800497:	83 ef 01             	sub    $0x1,%edi
  80049a:	83 c4 10             	add    $0x10,%esp
  80049d:	85 ff                	test   %edi,%edi
  80049f:	7f ed                	jg     80048e <vprintfmt+0x1b6>
  8004a1:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004a4:	85 c9                	test   %ecx,%ecx
  8004a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ab:	0f 49 c1             	cmovns %ecx,%eax
  8004ae:	29 c1                	sub    %eax,%ecx
  8004b0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004b3:	eb aa                	jmp    80045f <vprintfmt+0x187>
					putch(ch, putdat);
  8004b5:	83 ec 08             	sub    $0x8,%esp
  8004b8:	53                   	push   %ebx
  8004b9:	52                   	push   %edx
  8004ba:	ff d6                	call   *%esi
  8004bc:	83 c4 10             	add    $0x10,%esp
  8004bf:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c2:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004c4:	83 c7 01             	add    $0x1,%edi
  8004c7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004cb:	0f be d0             	movsbl %al,%edx
  8004ce:	85 d2                	test   %edx,%edx
  8004d0:	74 4b                	je     80051d <vprintfmt+0x245>
  8004d2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004d6:	78 06                	js     8004de <vprintfmt+0x206>
  8004d8:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004dc:	78 1e                	js     8004fc <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8004de:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004e2:	74 d1                	je     8004b5 <vprintfmt+0x1dd>
  8004e4:	0f be c0             	movsbl %al,%eax
  8004e7:	83 e8 20             	sub    $0x20,%eax
  8004ea:	83 f8 5e             	cmp    $0x5e,%eax
  8004ed:	76 c6                	jbe    8004b5 <vprintfmt+0x1dd>
					putch('?', putdat);
  8004ef:	83 ec 08             	sub    $0x8,%esp
  8004f2:	53                   	push   %ebx
  8004f3:	6a 3f                	push   $0x3f
  8004f5:	ff d6                	call   *%esi
  8004f7:	83 c4 10             	add    $0x10,%esp
  8004fa:	eb c3                	jmp    8004bf <vprintfmt+0x1e7>
  8004fc:	89 cf                	mov    %ecx,%edi
  8004fe:	eb 0e                	jmp    80050e <vprintfmt+0x236>
				putch(' ', putdat);
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	53                   	push   %ebx
  800504:	6a 20                	push   $0x20
  800506:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800508:	83 ef 01             	sub    $0x1,%edi
  80050b:	83 c4 10             	add    $0x10,%esp
  80050e:	85 ff                	test   %edi,%edi
  800510:	7f ee                	jg     800500 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800512:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800515:	89 45 14             	mov    %eax,0x14(%ebp)
  800518:	e9 01 02 00 00       	jmp    80071e <vprintfmt+0x446>
  80051d:	89 cf                	mov    %ecx,%edi
  80051f:	eb ed                	jmp    80050e <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800521:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800524:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80052b:	e9 eb fd ff ff       	jmp    80031b <vprintfmt+0x43>
	if (lflag >= 2)
  800530:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800534:	7f 21                	jg     800557 <vprintfmt+0x27f>
	else if (lflag)
  800536:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80053a:	74 68                	je     8005a4 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80053c:	8b 45 14             	mov    0x14(%ebp),%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800544:	89 c1                	mov    %eax,%ecx
  800546:	c1 f9 1f             	sar    $0x1f,%ecx
  800549:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80054c:	8b 45 14             	mov    0x14(%ebp),%eax
  80054f:	8d 40 04             	lea    0x4(%eax),%eax
  800552:	89 45 14             	mov    %eax,0x14(%ebp)
  800555:	eb 17                	jmp    80056e <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800557:	8b 45 14             	mov    0x14(%ebp),%eax
  80055a:	8b 50 04             	mov    0x4(%eax),%edx
  80055d:	8b 00                	mov    (%eax),%eax
  80055f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800562:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800565:	8b 45 14             	mov    0x14(%ebp),%eax
  800568:	8d 40 08             	lea    0x8(%eax),%eax
  80056b:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80056e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800571:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800574:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800577:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80057a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80057e:	78 3f                	js     8005bf <vprintfmt+0x2e7>
			base = 10;
  800580:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800585:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800589:	0f 84 71 01 00 00    	je     800700 <vprintfmt+0x428>
				putch('+', putdat);
  80058f:	83 ec 08             	sub    $0x8,%esp
  800592:	53                   	push   %ebx
  800593:	6a 2b                	push   $0x2b
  800595:	ff d6                	call   *%esi
  800597:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80059a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80059f:	e9 5c 01 00 00       	jmp    800700 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	8b 00                	mov    (%eax),%eax
  8005a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005ac:	89 c1                	mov    %eax,%ecx
  8005ae:	c1 f9 1f             	sar    $0x1f,%ecx
  8005b1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b7:	8d 40 04             	lea    0x4(%eax),%eax
  8005ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8005bd:	eb af                	jmp    80056e <vprintfmt+0x296>
				putch('-', putdat);
  8005bf:	83 ec 08             	sub    $0x8,%esp
  8005c2:	53                   	push   %ebx
  8005c3:	6a 2d                	push   $0x2d
  8005c5:	ff d6                	call   *%esi
				num = -(long long) num;
  8005c7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005ca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005cd:	f7 d8                	neg    %eax
  8005cf:	83 d2 00             	adc    $0x0,%edx
  8005d2:	f7 da                	neg    %edx
  8005d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005da:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005dd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e2:	e9 19 01 00 00       	jmp    800700 <vprintfmt+0x428>
	if (lflag >= 2)
  8005e7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005eb:	7f 29                	jg     800616 <vprintfmt+0x33e>
	else if (lflag)
  8005ed:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005f1:	74 44                	je     800637 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8005f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f6:	8b 00                	mov    (%eax),%eax
  8005f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800600:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800603:	8b 45 14             	mov    0x14(%ebp),%eax
  800606:	8d 40 04             	lea    0x4(%eax),%eax
  800609:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80060c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800611:	e9 ea 00 00 00       	jmp    800700 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800616:	8b 45 14             	mov    0x14(%ebp),%eax
  800619:	8b 50 04             	mov    0x4(%eax),%edx
  80061c:	8b 00                	mov    (%eax),%eax
  80061e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800621:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800624:	8b 45 14             	mov    0x14(%ebp),%eax
  800627:	8d 40 08             	lea    0x8(%eax),%eax
  80062a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800632:	e9 c9 00 00 00       	jmp    800700 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800637:	8b 45 14             	mov    0x14(%ebp),%eax
  80063a:	8b 00                	mov    (%eax),%eax
  80063c:	ba 00 00 00 00       	mov    $0x0,%edx
  800641:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800644:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800647:	8b 45 14             	mov    0x14(%ebp),%eax
  80064a:	8d 40 04             	lea    0x4(%eax),%eax
  80064d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800650:	b8 0a 00 00 00       	mov    $0xa,%eax
  800655:	e9 a6 00 00 00       	jmp    800700 <vprintfmt+0x428>
			putch('0', putdat);
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	53                   	push   %ebx
  80065e:	6a 30                	push   $0x30
  800660:	ff d6                	call   *%esi
	if (lflag >= 2)
  800662:	83 c4 10             	add    $0x10,%esp
  800665:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800669:	7f 26                	jg     800691 <vprintfmt+0x3b9>
	else if (lflag)
  80066b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80066f:	74 3e                	je     8006af <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8b 00                	mov    (%eax),%eax
  800676:	ba 00 00 00 00       	mov    $0x0,%edx
  80067b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800681:	8b 45 14             	mov    0x14(%ebp),%eax
  800684:	8d 40 04             	lea    0x4(%eax),%eax
  800687:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80068a:	b8 08 00 00 00       	mov    $0x8,%eax
  80068f:	eb 6f                	jmp    800700 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	8b 50 04             	mov    0x4(%eax),%edx
  800697:	8b 00                	mov    (%eax),%eax
  800699:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80069f:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a2:	8d 40 08             	lea    0x8(%eax),%eax
  8006a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006a8:	b8 08 00 00 00       	mov    $0x8,%eax
  8006ad:	eb 51                	jmp    800700 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c2:	8d 40 04             	lea    0x4(%eax),%eax
  8006c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006c8:	b8 08 00 00 00       	mov    $0x8,%eax
  8006cd:	eb 31                	jmp    800700 <vprintfmt+0x428>
			putch('0', putdat);
  8006cf:	83 ec 08             	sub    $0x8,%esp
  8006d2:	53                   	push   %ebx
  8006d3:	6a 30                	push   $0x30
  8006d5:	ff d6                	call   *%esi
			putch('x', putdat);
  8006d7:	83 c4 08             	add    $0x8,%esp
  8006da:	53                   	push   %ebx
  8006db:	6a 78                	push   $0x78
  8006dd:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ec:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006ef:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	8d 40 04             	lea    0x4(%eax),%eax
  8006f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006fb:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800700:	83 ec 0c             	sub    $0xc,%esp
  800703:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800707:	52                   	push   %edx
  800708:	ff 75 e0             	pushl  -0x20(%ebp)
  80070b:	50                   	push   %eax
  80070c:	ff 75 dc             	pushl  -0x24(%ebp)
  80070f:	ff 75 d8             	pushl  -0x28(%ebp)
  800712:	89 da                	mov    %ebx,%edx
  800714:	89 f0                	mov    %esi,%eax
  800716:	e8 a4 fa ff ff       	call   8001bf <printnum>
			break;
  80071b:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80071e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800721:	83 c7 01             	add    $0x1,%edi
  800724:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800728:	83 f8 25             	cmp    $0x25,%eax
  80072b:	0f 84 be fb ff ff    	je     8002ef <vprintfmt+0x17>
			if (ch == '\0')
  800731:	85 c0                	test   %eax,%eax
  800733:	0f 84 28 01 00 00    	je     800861 <vprintfmt+0x589>
			putch(ch, putdat);
  800739:	83 ec 08             	sub    $0x8,%esp
  80073c:	53                   	push   %ebx
  80073d:	50                   	push   %eax
  80073e:	ff d6                	call   *%esi
  800740:	83 c4 10             	add    $0x10,%esp
  800743:	eb dc                	jmp    800721 <vprintfmt+0x449>
	if (lflag >= 2)
  800745:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800749:	7f 26                	jg     800771 <vprintfmt+0x499>
	else if (lflag)
  80074b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80074f:	74 41                	je     800792 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	8b 00                	mov    (%eax),%eax
  800756:	ba 00 00 00 00       	mov    $0x0,%edx
  80075b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800761:	8b 45 14             	mov    0x14(%ebp),%eax
  800764:	8d 40 04             	lea    0x4(%eax),%eax
  800767:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80076a:	b8 10 00 00 00       	mov    $0x10,%eax
  80076f:	eb 8f                	jmp    800700 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800771:	8b 45 14             	mov    0x14(%ebp),%eax
  800774:	8b 50 04             	mov    0x4(%eax),%edx
  800777:	8b 00                	mov    (%eax),%eax
  800779:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077f:	8b 45 14             	mov    0x14(%ebp),%eax
  800782:	8d 40 08             	lea    0x8(%eax),%eax
  800785:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800788:	b8 10 00 00 00       	mov    $0x10,%eax
  80078d:	e9 6e ff ff ff       	jmp    800700 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800792:	8b 45 14             	mov    0x14(%ebp),%eax
  800795:	8b 00                	mov    (%eax),%eax
  800797:	ba 00 00 00 00       	mov    $0x0,%edx
  80079c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a5:	8d 40 04             	lea    0x4(%eax),%eax
  8007a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ab:	b8 10 00 00 00       	mov    $0x10,%eax
  8007b0:	e9 4b ff ff ff       	jmp    800700 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b8:	83 c0 04             	add    $0x4,%eax
  8007bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007be:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c1:	8b 00                	mov    (%eax),%eax
  8007c3:	85 c0                	test   %eax,%eax
  8007c5:	74 14                	je     8007db <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007c7:	8b 13                	mov    (%ebx),%edx
  8007c9:	83 fa 7f             	cmp    $0x7f,%edx
  8007cc:	7f 37                	jg     800805 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007ce:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d6:	e9 43 ff ff ff       	jmp    80071e <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8007db:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e0:	bf 49 13 80 00       	mov    $0x801349,%edi
							putch(ch, putdat);
  8007e5:	83 ec 08             	sub    $0x8,%esp
  8007e8:	53                   	push   %ebx
  8007e9:	50                   	push   %eax
  8007ea:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007ec:	83 c7 01             	add    $0x1,%edi
  8007ef:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007f3:	83 c4 10             	add    $0x10,%esp
  8007f6:	85 c0                	test   %eax,%eax
  8007f8:	75 eb                	jne    8007e5 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8007fa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007fd:	89 45 14             	mov    %eax,0x14(%ebp)
  800800:	e9 19 ff ff ff       	jmp    80071e <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800805:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800807:	b8 0a 00 00 00       	mov    $0xa,%eax
  80080c:	bf 81 13 80 00       	mov    $0x801381,%edi
							putch(ch, putdat);
  800811:	83 ec 08             	sub    $0x8,%esp
  800814:	53                   	push   %ebx
  800815:	50                   	push   %eax
  800816:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800818:	83 c7 01             	add    $0x1,%edi
  80081b:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80081f:	83 c4 10             	add    $0x10,%esp
  800822:	85 c0                	test   %eax,%eax
  800824:	75 eb                	jne    800811 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800826:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800829:	89 45 14             	mov    %eax,0x14(%ebp)
  80082c:	e9 ed fe ff ff       	jmp    80071e <vprintfmt+0x446>
			putch(ch, putdat);
  800831:	83 ec 08             	sub    $0x8,%esp
  800834:	53                   	push   %ebx
  800835:	6a 25                	push   $0x25
  800837:	ff d6                	call   *%esi
			break;
  800839:	83 c4 10             	add    $0x10,%esp
  80083c:	e9 dd fe ff ff       	jmp    80071e <vprintfmt+0x446>
			putch('%', putdat);
  800841:	83 ec 08             	sub    $0x8,%esp
  800844:	53                   	push   %ebx
  800845:	6a 25                	push   $0x25
  800847:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800849:	83 c4 10             	add    $0x10,%esp
  80084c:	89 f8                	mov    %edi,%eax
  80084e:	eb 03                	jmp    800853 <vprintfmt+0x57b>
  800850:	83 e8 01             	sub    $0x1,%eax
  800853:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800857:	75 f7                	jne    800850 <vprintfmt+0x578>
  800859:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80085c:	e9 bd fe ff ff       	jmp    80071e <vprintfmt+0x446>
}
  800861:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800864:	5b                   	pop    %ebx
  800865:	5e                   	pop    %esi
  800866:	5f                   	pop    %edi
  800867:	5d                   	pop    %ebp
  800868:	c3                   	ret    

00800869 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800869:	55                   	push   %ebp
  80086a:	89 e5                	mov    %esp,%ebp
  80086c:	83 ec 18             	sub    $0x18,%esp
  80086f:	8b 45 08             	mov    0x8(%ebp),%eax
  800872:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800875:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800878:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80087c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80087f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800886:	85 c0                	test   %eax,%eax
  800888:	74 26                	je     8008b0 <vsnprintf+0x47>
  80088a:	85 d2                	test   %edx,%edx
  80088c:	7e 22                	jle    8008b0 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80088e:	ff 75 14             	pushl  0x14(%ebp)
  800891:	ff 75 10             	pushl  0x10(%ebp)
  800894:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800897:	50                   	push   %eax
  800898:	68 9e 02 80 00       	push   $0x80029e
  80089d:	e8 36 fa ff ff       	call   8002d8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ab:	83 c4 10             	add    $0x10,%esp
}
  8008ae:	c9                   	leave  
  8008af:	c3                   	ret    
		return -E_INVAL;
  8008b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008b5:	eb f7                	jmp    8008ae <vsnprintf+0x45>

008008b7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008b7:	55                   	push   %ebp
  8008b8:	89 e5                	mov    %esp,%ebp
  8008ba:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008bd:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008c0:	50                   	push   %eax
  8008c1:	ff 75 10             	pushl  0x10(%ebp)
  8008c4:	ff 75 0c             	pushl  0xc(%ebp)
  8008c7:	ff 75 08             	pushl  0x8(%ebp)
  8008ca:	e8 9a ff ff ff       	call   800869 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008cf:	c9                   	leave  
  8008d0:	c3                   	ret    

008008d1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008d1:	55                   	push   %ebp
  8008d2:	89 e5                	mov    %esp,%ebp
  8008d4:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8008dc:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008e0:	74 05                	je     8008e7 <strlen+0x16>
		n++;
  8008e2:	83 c0 01             	add    $0x1,%eax
  8008e5:	eb f5                	jmp    8008dc <strlen+0xb>
	return n;
}
  8008e7:	5d                   	pop    %ebp
  8008e8:	c3                   	ret    

008008e9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008e9:	55                   	push   %ebp
  8008ea:	89 e5                	mov    %esp,%ebp
  8008ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ef:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f7:	39 c2                	cmp    %eax,%edx
  8008f9:	74 0d                	je     800908 <strnlen+0x1f>
  8008fb:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008ff:	74 05                	je     800906 <strnlen+0x1d>
		n++;
  800901:	83 c2 01             	add    $0x1,%edx
  800904:	eb f1                	jmp    8008f7 <strnlen+0xe>
  800906:	89 d0                	mov    %edx,%eax
	return n;
}
  800908:	5d                   	pop    %ebp
  800909:	c3                   	ret    

0080090a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	53                   	push   %ebx
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800914:	ba 00 00 00 00       	mov    $0x0,%edx
  800919:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80091d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800920:	83 c2 01             	add    $0x1,%edx
  800923:	84 c9                	test   %cl,%cl
  800925:	75 f2                	jne    800919 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800927:	5b                   	pop    %ebx
  800928:	5d                   	pop    %ebp
  800929:	c3                   	ret    

0080092a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	53                   	push   %ebx
  80092e:	83 ec 10             	sub    $0x10,%esp
  800931:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800934:	53                   	push   %ebx
  800935:	e8 97 ff ff ff       	call   8008d1 <strlen>
  80093a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80093d:	ff 75 0c             	pushl  0xc(%ebp)
  800940:	01 d8                	add    %ebx,%eax
  800942:	50                   	push   %eax
  800943:	e8 c2 ff ff ff       	call   80090a <strcpy>
	return dst;
}
  800948:	89 d8                	mov    %ebx,%eax
  80094a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80094d:	c9                   	leave  
  80094e:	c3                   	ret    

0080094f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	56                   	push   %esi
  800953:	53                   	push   %ebx
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80095a:	89 c6                	mov    %eax,%esi
  80095c:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80095f:	89 c2                	mov    %eax,%edx
  800961:	39 f2                	cmp    %esi,%edx
  800963:	74 11                	je     800976 <strncpy+0x27>
		*dst++ = *src;
  800965:	83 c2 01             	add    $0x1,%edx
  800968:	0f b6 19             	movzbl (%ecx),%ebx
  80096b:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80096e:	80 fb 01             	cmp    $0x1,%bl
  800971:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800974:	eb eb                	jmp    800961 <strncpy+0x12>
	}
	return ret;
}
  800976:	5b                   	pop    %ebx
  800977:	5e                   	pop    %esi
  800978:	5d                   	pop    %ebp
  800979:	c3                   	ret    

0080097a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	56                   	push   %esi
  80097e:	53                   	push   %ebx
  80097f:	8b 75 08             	mov    0x8(%ebp),%esi
  800982:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800985:	8b 55 10             	mov    0x10(%ebp),%edx
  800988:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80098a:	85 d2                	test   %edx,%edx
  80098c:	74 21                	je     8009af <strlcpy+0x35>
  80098e:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800992:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800994:	39 c2                	cmp    %eax,%edx
  800996:	74 14                	je     8009ac <strlcpy+0x32>
  800998:	0f b6 19             	movzbl (%ecx),%ebx
  80099b:	84 db                	test   %bl,%bl
  80099d:	74 0b                	je     8009aa <strlcpy+0x30>
			*dst++ = *src++;
  80099f:	83 c1 01             	add    $0x1,%ecx
  8009a2:	83 c2 01             	add    $0x1,%edx
  8009a5:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009a8:	eb ea                	jmp    800994 <strlcpy+0x1a>
  8009aa:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009ac:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009af:	29 f0                	sub    %esi,%eax
}
  8009b1:	5b                   	pop    %ebx
  8009b2:	5e                   	pop    %esi
  8009b3:	5d                   	pop    %ebp
  8009b4:	c3                   	ret    

008009b5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009b5:	55                   	push   %ebp
  8009b6:	89 e5                	mov    %esp,%ebp
  8009b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009bb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009be:	0f b6 01             	movzbl (%ecx),%eax
  8009c1:	84 c0                	test   %al,%al
  8009c3:	74 0c                	je     8009d1 <strcmp+0x1c>
  8009c5:	3a 02                	cmp    (%edx),%al
  8009c7:	75 08                	jne    8009d1 <strcmp+0x1c>
		p++, q++;
  8009c9:	83 c1 01             	add    $0x1,%ecx
  8009cc:	83 c2 01             	add    $0x1,%edx
  8009cf:	eb ed                	jmp    8009be <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d1:	0f b6 c0             	movzbl %al,%eax
  8009d4:	0f b6 12             	movzbl (%edx),%edx
  8009d7:	29 d0                	sub    %edx,%eax
}
  8009d9:	5d                   	pop    %ebp
  8009da:	c3                   	ret    

008009db <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	53                   	push   %ebx
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e5:	89 c3                	mov    %eax,%ebx
  8009e7:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009ea:	eb 06                	jmp    8009f2 <strncmp+0x17>
		n--, p++, q++;
  8009ec:	83 c0 01             	add    $0x1,%eax
  8009ef:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009f2:	39 d8                	cmp    %ebx,%eax
  8009f4:	74 16                	je     800a0c <strncmp+0x31>
  8009f6:	0f b6 08             	movzbl (%eax),%ecx
  8009f9:	84 c9                	test   %cl,%cl
  8009fb:	74 04                	je     800a01 <strncmp+0x26>
  8009fd:	3a 0a                	cmp    (%edx),%cl
  8009ff:	74 eb                	je     8009ec <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a01:	0f b6 00             	movzbl (%eax),%eax
  800a04:	0f b6 12             	movzbl (%edx),%edx
  800a07:	29 d0                	sub    %edx,%eax
}
  800a09:	5b                   	pop    %ebx
  800a0a:	5d                   	pop    %ebp
  800a0b:	c3                   	ret    
		return 0;
  800a0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a11:	eb f6                	jmp    800a09 <strncmp+0x2e>

00800a13 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a13:	55                   	push   %ebp
  800a14:	89 e5                	mov    %esp,%ebp
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a1d:	0f b6 10             	movzbl (%eax),%edx
  800a20:	84 d2                	test   %dl,%dl
  800a22:	74 09                	je     800a2d <strchr+0x1a>
		if (*s == c)
  800a24:	38 ca                	cmp    %cl,%dl
  800a26:	74 0a                	je     800a32 <strchr+0x1f>
	for (; *s; s++)
  800a28:	83 c0 01             	add    $0x1,%eax
  800a2b:	eb f0                	jmp    800a1d <strchr+0xa>
			return (char *) s;
	return 0;
  800a2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    

00800a34 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a3e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a41:	38 ca                	cmp    %cl,%dl
  800a43:	74 09                	je     800a4e <strfind+0x1a>
  800a45:	84 d2                	test   %dl,%dl
  800a47:	74 05                	je     800a4e <strfind+0x1a>
	for (; *s; s++)
  800a49:	83 c0 01             	add    $0x1,%eax
  800a4c:	eb f0                	jmp    800a3e <strfind+0xa>
			break;
	return (char *) s;
}
  800a4e:	5d                   	pop    %ebp
  800a4f:	c3                   	ret    

00800a50 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	57                   	push   %edi
  800a54:	56                   	push   %esi
  800a55:	53                   	push   %ebx
  800a56:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a59:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a5c:	85 c9                	test   %ecx,%ecx
  800a5e:	74 31                	je     800a91 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a60:	89 f8                	mov    %edi,%eax
  800a62:	09 c8                	or     %ecx,%eax
  800a64:	a8 03                	test   $0x3,%al
  800a66:	75 23                	jne    800a8b <memset+0x3b>
		c &= 0xFF;
  800a68:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a6c:	89 d3                	mov    %edx,%ebx
  800a6e:	c1 e3 08             	shl    $0x8,%ebx
  800a71:	89 d0                	mov    %edx,%eax
  800a73:	c1 e0 18             	shl    $0x18,%eax
  800a76:	89 d6                	mov    %edx,%esi
  800a78:	c1 e6 10             	shl    $0x10,%esi
  800a7b:	09 f0                	or     %esi,%eax
  800a7d:	09 c2                	or     %eax,%edx
  800a7f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a81:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a84:	89 d0                	mov    %edx,%eax
  800a86:	fc                   	cld    
  800a87:	f3 ab                	rep stos %eax,%es:(%edi)
  800a89:	eb 06                	jmp    800a91 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8e:	fc                   	cld    
  800a8f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a91:	89 f8                	mov    %edi,%eax
  800a93:	5b                   	pop    %ebx
  800a94:	5e                   	pop    %esi
  800a95:	5f                   	pop    %edi
  800a96:	5d                   	pop    %ebp
  800a97:	c3                   	ret    

00800a98 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
  800a9b:	57                   	push   %edi
  800a9c:	56                   	push   %esi
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aa3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aa6:	39 c6                	cmp    %eax,%esi
  800aa8:	73 32                	jae    800adc <memmove+0x44>
  800aaa:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aad:	39 c2                	cmp    %eax,%edx
  800aaf:	76 2b                	jbe    800adc <memmove+0x44>
		s += n;
		d += n;
  800ab1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab4:	89 fe                	mov    %edi,%esi
  800ab6:	09 ce                	or     %ecx,%esi
  800ab8:	09 d6                	or     %edx,%esi
  800aba:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ac0:	75 0e                	jne    800ad0 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ac2:	83 ef 04             	sub    $0x4,%edi
  800ac5:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ac8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800acb:	fd                   	std    
  800acc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ace:	eb 09                	jmp    800ad9 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ad0:	83 ef 01             	sub    $0x1,%edi
  800ad3:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ad6:	fd                   	std    
  800ad7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ad9:	fc                   	cld    
  800ada:	eb 1a                	jmp    800af6 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800adc:	89 c2                	mov    %eax,%edx
  800ade:	09 ca                	or     %ecx,%edx
  800ae0:	09 f2                	or     %esi,%edx
  800ae2:	f6 c2 03             	test   $0x3,%dl
  800ae5:	75 0a                	jne    800af1 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ae7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800aea:	89 c7                	mov    %eax,%edi
  800aec:	fc                   	cld    
  800aed:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aef:	eb 05                	jmp    800af6 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800af1:	89 c7                	mov    %eax,%edi
  800af3:	fc                   	cld    
  800af4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800af6:	5e                   	pop    %esi
  800af7:	5f                   	pop    %edi
  800af8:	5d                   	pop    %ebp
  800af9:	c3                   	ret    

00800afa <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b00:	ff 75 10             	pushl  0x10(%ebp)
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	ff 75 08             	pushl  0x8(%ebp)
  800b09:	e8 8a ff ff ff       	call   800a98 <memmove>
}
  800b0e:	c9                   	leave  
  800b0f:	c3                   	ret    

00800b10 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	56                   	push   %esi
  800b14:	53                   	push   %ebx
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1b:	89 c6                	mov    %eax,%esi
  800b1d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b20:	39 f0                	cmp    %esi,%eax
  800b22:	74 1c                	je     800b40 <memcmp+0x30>
		if (*s1 != *s2)
  800b24:	0f b6 08             	movzbl (%eax),%ecx
  800b27:	0f b6 1a             	movzbl (%edx),%ebx
  800b2a:	38 d9                	cmp    %bl,%cl
  800b2c:	75 08                	jne    800b36 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b2e:	83 c0 01             	add    $0x1,%eax
  800b31:	83 c2 01             	add    $0x1,%edx
  800b34:	eb ea                	jmp    800b20 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b36:	0f b6 c1             	movzbl %cl,%eax
  800b39:	0f b6 db             	movzbl %bl,%ebx
  800b3c:	29 d8                	sub    %ebx,%eax
  800b3e:	eb 05                	jmp    800b45 <memcmp+0x35>
	}

	return 0;
  800b40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b45:	5b                   	pop    %ebx
  800b46:	5e                   	pop    %esi
  800b47:	5d                   	pop    %ebp
  800b48:	c3                   	ret    

00800b49 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b49:	55                   	push   %ebp
  800b4a:	89 e5                	mov    %esp,%ebp
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b52:	89 c2                	mov    %eax,%edx
  800b54:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b57:	39 d0                	cmp    %edx,%eax
  800b59:	73 09                	jae    800b64 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b5b:	38 08                	cmp    %cl,(%eax)
  800b5d:	74 05                	je     800b64 <memfind+0x1b>
	for (; s < ends; s++)
  800b5f:	83 c0 01             	add    $0x1,%eax
  800b62:	eb f3                	jmp    800b57 <memfind+0xe>
			break;
	return (void *) s;
}
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	57                   	push   %edi
  800b6a:	56                   	push   %esi
  800b6b:	53                   	push   %ebx
  800b6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b6f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b72:	eb 03                	jmp    800b77 <strtol+0x11>
		s++;
  800b74:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b77:	0f b6 01             	movzbl (%ecx),%eax
  800b7a:	3c 20                	cmp    $0x20,%al
  800b7c:	74 f6                	je     800b74 <strtol+0xe>
  800b7e:	3c 09                	cmp    $0x9,%al
  800b80:	74 f2                	je     800b74 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b82:	3c 2b                	cmp    $0x2b,%al
  800b84:	74 2a                	je     800bb0 <strtol+0x4a>
	int neg = 0;
  800b86:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b8b:	3c 2d                	cmp    $0x2d,%al
  800b8d:	74 2b                	je     800bba <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b8f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b95:	75 0f                	jne    800ba6 <strtol+0x40>
  800b97:	80 39 30             	cmpb   $0x30,(%ecx)
  800b9a:	74 28                	je     800bc4 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b9c:	85 db                	test   %ebx,%ebx
  800b9e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ba3:	0f 44 d8             	cmove  %eax,%ebx
  800ba6:	b8 00 00 00 00       	mov    $0x0,%eax
  800bab:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bae:	eb 50                	jmp    800c00 <strtol+0x9a>
		s++;
  800bb0:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bb3:	bf 00 00 00 00       	mov    $0x0,%edi
  800bb8:	eb d5                	jmp    800b8f <strtol+0x29>
		s++, neg = 1;
  800bba:	83 c1 01             	add    $0x1,%ecx
  800bbd:	bf 01 00 00 00       	mov    $0x1,%edi
  800bc2:	eb cb                	jmp    800b8f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bc4:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bc8:	74 0e                	je     800bd8 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bca:	85 db                	test   %ebx,%ebx
  800bcc:	75 d8                	jne    800ba6 <strtol+0x40>
		s++, base = 8;
  800bce:	83 c1 01             	add    $0x1,%ecx
  800bd1:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bd6:	eb ce                	jmp    800ba6 <strtol+0x40>
		s += 2, base = 16;
  800bd8:	83 c1 02             	add    $0x2,%ecx
  800bdb:	bb 10 00 00 00       	mov    $0x10,%ebx
  800be0:	eb c4                	jmp    800ba6 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800be2:	8d 72 9f             	lea    -0x61(%edx),%esi
  800be5:	89 f3                	mov    %esi,%ebx
  800be7:	80 fb 19             	cmp    $0x19,%bl
  800bea:	77 29                	ja     800c15 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bec:	0f be d2             	movsbl %dl,%edx
  800bef:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bf2:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bf5:	7d 30                	jge    800c27 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bf7:	83 c1 01             	add    $0x1,%ecx
  800bfa:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bfe:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c00:	0f b6 11             	movzbl (%ecx),%edx
  800c03:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c06:	89 f3                	mov    %esi,%ebx
  800c08:	80 fb 09             	cmp    $0x9,%bl
  800c0b:	77 d5                	ja     800be2 <strtol+0x7c>
			dig = *s - '0';
  800c0d:	0f be d2             	movsbl %dl,%edx
  800c10:	83 ea 30             	sub    $0x30,%edx
  800c13:	eb dd                	jmp    800bf2 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c15:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c18:	89 f3                	mov    %esi,%ebx
  800c1a:	80 fb 19             	cmp    $0x19,%bl
  800c1d:	77 08                	ja     800c27 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c1f:	0f be d2             	movsbl %dl,%edx
  800c22:	83 ea 37             	sub    $0x37,%edx
  800c25:	eb cb                	jmp    800bf2 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c2b:	74 05                	je     800c32 <strtol+0xcc>
		*endptr = (char *) s;
  800c2d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c30:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c32:	89 c2                	mov    %eax,%edx
  800c34:	f7 da                	neg    %edx
  800c36:	85 ff                	test   %edi,%edi
  800c38:	0f 45 c2             	cmovne %edx,%eax
}
  800c3b:	5b                   	pop    %ebx
  800c3c:	5e                   	pop    %esi
  800c3d:	5f                   	pop    %edi
  800c3e:	5d                   	pop    %ebp
  800c3f:	c3                   	ret    

00800c40 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	57                   	push   %edi
  800c44:	56                   	push   %esi
  800c45:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c46:	b8 00 00 00 00       	mov    $0x0,%eax
  800c4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c51:	89 c3                	mov    %eax,%ebx
  800c53:	89 c7                	mov    %eax,%edi
  800c55:	89 c6                	mov    %eax,%esi
  800c57:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c59:	5b                   	pop    %ebx
  800c5a:	5e                   	pop    %esi
  800c5b:	5f                   	pop    %edi
  800c5c:	5d                   	pop    %ebp
  800c5d:	c3                   	ret    

00800c5e <sys_cgetc>:

int
sys_cgetc(void)
{
  800c5e:	55                   	push   %ebp
  800c5f:	89 e5                	mov    %esp,%ebp
  800c61:	57                   	push   %edi
  800c62:	56                   	push   %esi
  800c63:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c64:	ba 00 00 00 00       	mov    $0x0,%edx
  800c69:	b8 01 00 00 00       	mov    $0x1,%eax
  800c6e:	89 d1                	mov    %edx,%ecx
  800c70:	89 d3                	mov    %edx,%ebx
  800c72:	89 d7                	mov    %edx,%edi
  800c74:	89 d6                	mov    %edx,%esi
  800c76:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c78:	5b                   	pop    %ebx
  800c79:	5e                   	pop    %esi
  800c7a:	5f                   	pop    %edi
  800c7b:	5d                   	pop    %ebp
  800c7c:	c3                   	ret    

00800c7d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c7d:	55                   	push   %ebp
  800c7e:	89 e5                	mov    %esp,%ebp
  800c80:	57                   	push   %edi
  800c81:	56                   	push   %esi
  800c82:	53                   	push   %ebx
  800c83:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c86:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8e:	b8 03 00 00 00       	mov    $0x3,%eax
  800c93:	89 cb                	mov    %ecx,%ebx
  800c95:	89 cf                	mov    %ecx,%edi
  800c97:	89 ce                	mov    %ecx,%esi
  800c99:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c9b:	85 c0                	test   %eax,%eax
  800c9d:	7f 08                	jg     800ca7 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca2:	5b                   	pop    %ebx
  800ca3:	5e                   	pop    %esi
  800ca4:	5f                   	pop    %edi
  800ca5:	5d                   	pop    %ebp
  800ca6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca7:	83 ec 0c             	sub    $0xc,%esp
  800caa:	50                   	push   %eax
  800cab:	6a 03                	push   $0x3
  800cad:	68 a0 15 80 00       	push   $0x8015a0
  800cb2:	6a 43                	push   $0x43
  800cb4:	68 bd 15 80 00       	push   $0x8015bd
  800cb9:	e8 70 02 00 00       	call   800f2e <_panic>

00800cbe <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
  800cc1:	57                   	push   %edi
  800cc2:	56                   	push   %esi
  800cc3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc4:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc9:	b8 02 00 00 00       	mov    $0x2,%eax
  800cce:	89 d1                	mov    %edx,%ecx
  800cd0:	89 d3                	mov    %edx,%ebx
  800cd2:	89 d7                	mov    %edx,%edi
  800cd4:	89 d6                	mov    %edx,%esi
  800cd6:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cd8:	5b                   	pop    %ebx
  800cd9:	5e                   	pop    %esi
  800cda:	5f                   	pop    %edi
  800cdb:	5d                   	pop    %ebp
  800cdc:	c3                   	ret    

00800cdd <sys_yield>:

void
sys_yield(void)
{
  800cdd:	55                   	push   %ebp
  800cde:	89 e5                	mov    %esp,%ebp
  800ce0:	57                   	push   %edi
  800ce1:	56                   	push   %esi
  800ce2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce8:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ced:	89 d1                	mov    %edx,%ecx
  800cef:	89 d3                	mov    %edx,%ebx
  800cf1:	89 d7                	mov    %edx,%edi
  800cf3:	89 d6                	mov    %edx,%esi
  800cf5:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cf7:	5b                   	pop    %ebx
  800cf8:	5e                   	pop    %esi
  800cf9:	5f                   	pop    %edi
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    

00800cfc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	57                   	push   %edi
  800d00:	56                   	push   %esi
  800d01:	53                   	push   %ebx
  800d02:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d05:	be 00 00 00 00       	mov    $0x0,%esi
  800d0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d10:	b8 04 00 00 00       	mov    $0x4,%eax
  800d15:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d18:	89 f7                	mov    %esi,%edi
  800d1a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d1c:	85 c0                	test   %eax,%eax
  800d1e:	7f 08                	jg     800d28 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d23:	5b                   	pop    %ebx
  800d24:	5e                   	pop    %esi
  800d25:	5f                   	pop    %edi
  800d26:	5d                   	pop    %ebp
  800d27:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d28:	83 ec 0c             	sub    $0xc,%esp
  800d2b:	50                   	push   %eax
  800d2c:	6a 04                	push   $0x4
  800d2e:	68 a0 15 80 00       	push   $0x8015a0
  800d33:	6a 43                	push   $0x43
  800d35:	68 bd 15 80 00       	push   $0x8015bd
  800d3a:	e8 ef 01 00 00       	call   800f2e <_panic>

00800d3f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	57                   	push   %edi
  800d43:	56                   	push   %esi
  800d44:	53                   	push   %ebx
  800d45:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d48:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4e:	b8 05 00 00 00       	mov    $0x5,%eax
  800d53:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d56:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d59:	8b 75 18             	mov    0x18(%ebp),%esi
  800d5c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5e:	85 c0                	test   %eax,%eax
  800d60:	7f 08                	jg     800d6a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d65:	5b                   	pop    %ebx
  800d66:	5e                   	pop    %esi
  800d67:	5f                   	pop    %edi
  800d68:	5d                   	pop    %ebp
  800d69:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6a:	83 ec 0c             	sub    $0xc,%esp
  800d6d:	50                   	push   %eax
  800d6e:	6a 05                	push   $0x5
  800d70:	68 a0 15 80 00       	push   $0x8015a0
  800d75:	6a 43                	push   $0x43
  800d77:	68 bd 15 80 00       	push   $0x8015bd
  800d7c:	e8 ad 01 00 00       	call   800f2e <_panic>

00800d81 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	57                   	push   %edi
  800d85:	56                   	push   %esi
  800d86:	53                   	push   %ebx
  800d87:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d95:	b8 06 00 00 00       	mov    $0x6,%eax
  800d9a:	89 df                	mov    %ebx,%edi
  800d9c:	89 de                	mov    %ebx,%esi
  800d9e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da0:	85 c0                	test   %eax,%eax
  800da2:	7f 08                	jg     800dac <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800da4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da7:	5b                   	pop    %ebx
  800da8:	5e                   	pop    %esi
  800da9:	5f                   	pop    %edi
  800daa:	5d                   	pop    %ebp
  800dab:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dac:	83 ec 0c             	sub    $0xc,%esp
  800daf:	50                   	push   %eax
  800db0:	6a 06                	push   $0x6
  800db2:	68 a0 15 80 00       	push   $0x8015a0
  800db7:	6a 43                	push   $0x43
  800db9:	68 bd 15 80 00       	push   $0x8015bd
  800dbe:	e8 6b 01 00 00       	call   800f2e <_panic>

00800dc3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	57                   	push   %edi
  800dc7:	56                   	push   %esi
  800dc8:	53                   	push   %ebx
  800dc9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dcc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd7:	b8 08 00 00 00       	mov    $0x8,%eax
  800ddc:	89 df                	mov    %ebx,%edi
  800dde:	89 de                	mov    %ebx,%esi
  800de0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de2:	85 c0                	test   %eax,%eax
  800de4:	7f 08                	jg     800dee <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800de6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de9:	5b                   	pop    %ebx
  800dea:	5e                   	pop    %esi
  800deb:	5f                   	pop    %edi
  800dec:	5d                   	pop    %ebp
  800ded:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dee:	83 ec 0c             	sub    $0xc,%esp
  800df1:	50                   	push   %eax
  800df2:	6a 08                	push   $0x8
  800df4:	68 a0 15 80 00       	push   $0x8015a0
  800df9:	6a 43                	push   $0x43
  800dfb:	68 bd 15 80 00       	push   $0x8015bd
  800e00:	e8 29 01 00 00       	call   800f2e <_panic>

00800e05 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
  800e08:	57                   	push   %edi
  800e09:	56                   	push   %esi
  800e0a:	53                   	push   %ebx
  800e0b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e13:	8b 55 08             	mov    0x8(%ebp),%edx
  800e16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e19:	b8 09 00 00 00       	mov    $0x9,%eax
  800e1e:	89 df                	mov    %ebx,%edi
  800e20:	89 de                	mov    %ebx,%esi
  800e22:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e24:	85 c0                	test   %eax,%eax
  800e26:	7f 08                	jg     800e30 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2b:	5b                   	pop    %ebx
  800e2c:	5e                   	pop    %esi
  800e2d:	5f                   	pop    %edi
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e30:	83 ec 0c             	sub    $0xc,%esp
  800e33:	50                   	push   %eax
  800e34:	6a 09                	push   $0x9
  800e36:	68 a0 15 80 00       	push   $0x8015a0
  800e3b:	6a 43                	push   $0x43
  800e3d:	68 bd 15 80 00       	push   $0x8015bd
  800e42:	e8 e7 00 00 00       	call   800f2e <_panic>

00800e47 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e47:	55                   	push   %ebp
  800e48:	89 e5                	mov    %esp,%ebp
  800e4a:	57                   	push   %edi
  800e4b:	56                   	push   %esi
  800e4c:	53                   	push   %ebx
  800e4d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e50:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e55:	8b 55 08             	mov    0x8(%ebp),%edx
  800e58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e60:	89 df                	mov    %ebx,%edi
  800e62:	89 de                	mov    %ebx,%esi
  800e64:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e66:	85 c0                	test   %eax,%eax
  800e68:	7f 08                	jg     800e72 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6d:	5b                   	pop    %ebx
  800e6e:	5e                   	pop    %esi
  800e6f:	5f                   	pop    %edi
  800e70:	5d                   	pop    %ebp
  800e71:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e72:	83 ec 0c             	sub    $0xc,%esp
  800e75:	50                   	push   %eax
  800e76:	6a 0a                	push   $0xa
  800e78:	68 a0 15 80 00       	push   $0x8015a0
  800e7d:	6a 43                	push   $0x43
  800e7f:	68 bd 15 80 00       	push   $0x8015bd
  800e84:	e8 a5 00 00 00       	call   800f2e <_panic>

00800e89 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	57                   	push   %edi
  800e8d:	56                   	push   %esi
  800e8e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e95:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e9a:	be 00 00 00 00       	mov    $0x0,%esi
  800e9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ea2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ea5:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ea7:	5b                   	pop    %ebx
  800ea8:	5e                   	pop    %esi
  800ea9:	5f                   	pop    %edi
  800eaa:	5d                   	pop    %ebp
  800eab:	c3                   	ret    

00800eac <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
  800eaf:	57                   	push   %edi
  800eb0:	56                   	push   %esi
  800eb1:	53                   	push   %ebx
  800eb2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eba:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebd:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ec2:	89 cb                	mov    %ecx,%ebx
  800ec4:	89 cf                	mov    %ecx,%edi
  800ec6:	89 ce                	mov    %ecx,%esi
  800ec8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eca:	85 c0                	test   %eax,%eax
  800ecc:	7f 08                	jg     800ed6 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ece:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed1:	5b                   	pop    %ebx
  800ed2:	5e                   	pop    %esi
  800ed3:	5f                   	pop    %edi
  800ed4:	5d                   	pop    %ebp
  800ed5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed6:	83 ec 0c             	sub    $0xc,%esp
  800ed9:	50                   	push   %eax
  800eda:	6a 0d                	push   $0xd
  800edc:	68 a0 15 80 00       	push   $0x8015a0
  800ee1:	6a 43                	push   $0x43
  800ee3:	68 bd 15 80 00       	push   $0x8015bd
  800ee8:	e8 41 00 00 00       	call   800f2e <_panic>

00800eed <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	57                   	push   %edi
  800ef1:	56                   	push   %esi
  800ef2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ef3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef8:	8b 55 08             	mov    0x8(%ebp),%edx
  800efb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efe:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f03:	89 df                	mov    %ebx,%edi
  800f05:	89 de                	mov    %ebx,%esi
  800f07:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f09:	5b                   	pop    %ebx
  800f0a:	5e                   	pop    %esi
  800f0b:	5f                   	pop    %edi
  800f0c:	5d                   	pop    %ebp
  800f0d:	c3                   	ret    

00800f0e <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	57                   	push   %edi
  800f12:	56                   	push   %esi
  800f13:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f14:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f19:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1c:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f21:	89 cb                	mov    %ecx,%ebx
  800f23:	89 cf                	mov    %ecx,%edi
  800f25:	89 ce                	mov    %ecx,%esi
  800f27:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f29:	5b                   	pop    %ebx
  800f2a:	5e                   	pop    %esi
  800f2b:	5f                   	pop    %edi
  800f2c:	5d                   	pop    %ebp
  800f2d:	c3                   	ret    

00800f2e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	56                   	push   %esi
  800f32:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800f33:	a1 04 20 80 00       	mov    0x802004,%eax
  800f38:	8b 40 48             	mov    0x48(%eax),%eax
  800f3b:	83 ec 04             	sub    $0x4,%esp
  800f3e:	68 fc 15 80 00       	push   $0x8015fc
  800f43:	50                   	push   %eax
  800f44:	68 cb 15 80 00       	push   $0x8015cb
  800f49:	e8 5d f2 ff ff       	call   8001ab <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800f4e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800f51:	8b 35 00 20 80 00    	mov    0x802000,%esi
  800f57:	e8 62 fd ff ff       	call   800cbe <sys_getenvid>
  800f5c:	83 c4 04             	add    $0x4,%esp
  800f5f:	ff 75 0c             	pushl  0xc(%ebp)
  800f62:	ff 75 08             	pushl  0x8(%ebp)
  800f65:	56                   	push   %esi
  800f66:	50                   	push   %eax
  800f67:	68 d8 15 80 00       	push   $0x8015d8
  800f6c:	e8 3a f2 ff ff       	call   8001ab <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800f71:	83 c4 18             	add    $0x18,%esp
  800f74:	53                   	push   %ebx
  800f75:	ff 75 10             	pushl  0x10(%ebp)
  800f78:	e8 dd f1 ff ff       	call   80015a <vcprintf>
	cprintf("\n");
  800f7d:	c7 04 24 ec 11 80 00 	movl   $0x8011ec,(%esp)
  800f84:	e8 22 f2 ff ff       	call   8001ab <cprintf>
  800f89:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800f8c:	cc                   	int3   
  800f8d:	eb fd                	jmp    800f8c <_panic+0x5e>
  800f8f:	90                   	nop

00800f90 <__udivdi3>:
  800f90:	55                   	push   %ebp
  800f91:	57                   	push   %edi
  800f92:	56                   	push   %esi
  800f93:	53                   	push   %ebx
  800f94:	83 ec 1c             	sub    $0x1c,%esp
  800f97:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  800f9b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  800f9f:	8b 74 24 34          	mov    0x34(%esp),%esi
  800fa3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  800fa7:	85 d2                	test   %edx,%edx
  800fa9:	75 4d                	jne    800ff8 <__udivdi3+0x68>
  800fab:	39 f3                	cmp    %esi,%ebx
  800fad:	76 19                	jbe    800fc8 <__udivdi3+0x38>
  800faf:	31 ff                	xor    %edi,%edi
  800fb1:	89 e8                	mov    %ebp,%eax
  800fb3:	89 f2                	mov    %esi,%edx
  800fb5:	f7 f3                	div    %ebx
  800fb7:	89 fa                	mov    %edi,%edx
  800fb9:	83 c4 1c             	add    $0x1c,%esp
  800fbc:	5b                   	pop    %ebx
  800fbd:	5e                   	pop    %esi
  800fbe:	5f                   	pop    %edi
  800fbf:	5d                   	pop    %ebp
  800fc0:	c3                   	ret    
  800fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800fc8:	89 d9                	mov    %ebx,%ecx
  800fca:	85 db                	test   %ebx,%ebx
  800fcc:	75 0b                	jne    800fd9 <__udivdi3+0x49>
  800fce:	b8 01 00 00 00       	mov    $0x1,%eax
  800fd3:	31 d2                	xor    %edx,%edx
  800fd5:	f7 f3                	div    %ebx
  800fd7:	89 c1                	mov    %eax,%ecx
  800fd9:	31 d2                	xor    %edx,%edx
  800fdb:	89 f0                	mov    %esi,%eax
  800fdd:	f7 f1                	div    %ecx
  800fdf:	89 c6                	mov    %eax,%esi
  800fe1:	89 e8                	mov    %ebp,%eax
  800fe3:	89 f7                	mov    %esi,%edi
  800fe5:	f7 f1                	div    %ecx
  800fe7:	89 fa                	mov    %edi,%edx
  800fe9:	83 c4 1c             	add    $0x1c,%esp
  800fec:	5b                   	pop    %ebx
  800fed:	5e                   	pop    %esi
  800fee:	5f                   	pop    %edi
  800fef:	5d                   	pop    %ebp
  800ff0:	c3                   	ret    
  800ff1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800ff8:	39 f2                	cmp    %esi,%edx
  800ffa:	77 1c                	ja     801018 <__udivdi3+0x88>
  800ffc:	0f bd fa             	bsr    %edx,%edi
  800fff:	83 f7 1f             	xor    $0x1f,%edi
  801002:	75 2c                	jne    801030 <__udivdi3+0xa0>
  801004:	39 f2                	cmp    %esi,%edx
  801006:	72 06                	jb     80100e <__udivdi3+0x7e>
  801008:	31 c0                	xor    %eax,%eax
  80100a:	39 eb                	cmp    %ebp,%ebx
  80100c:	77 a9                	ja     800fb7 <__udivdi3+0x27>
  80100e:	b8 01 00 00 00       	mov    $0x1,%eax
  801013:	eb a2                	jmp    800fb7 <__udivdi3+0x27>
  801015:	8d 76 00             	lea    0x0(%esi),%esi
  801018:	31 ff                	xor    %edi,%edi
  80101a:	31 c0                	xor    %eax,%eax
  80101c:	89 fa                	mov    %edi,%edx
  80101e:	83 c4 1c             	add    $0x1c,%esp
  801021:	5b                   	pop    %ebx
  801022:	5e                   	pop    %esi
  801023:	5f                   	pop    %edi
  801024:	5d                   	pop    %ebp
  801025:	c3                   	ret    
  801026:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80102d:	8d 76 00             	lea    0x0(%esi),%esi
  801030:	89 f9                	mov    %edi,%ecx
  801032:	b8 20 00 00 00       	mov    $0x20,%eax
  801037:	29 f8                	sub    %edi,%eax
  801039:	d3 e2                	shl    %cl,%edx
  80103b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80103f:	89 c1                	mov    %eax,%ecx
  801041:	89 da                	mov    %ebx,%edx
  801043:	d3 ea                	shr    %cl,%edx
  801045:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801049:	09 d1                	or     %edx,%ecx
  80104b:	89 f2                	mov    %esi,%edx
  80104d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801051:	89 f9                	mov    %edi,%ecx
  801053:	d3 e3                	shl    %cl,%ebx
  801055:	89 c1                	mov    %eax,%ecx
  801057:	d3 ea                	shr    %cl,%edx
  801059:	89 f9                	mov    %edi,%ecx
  80105b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80105f:	89 eb                	mov    %ebp,%ebx
  801061:	d3 e6                	shl    %cl,%esi
  801063:	89 c1                	mov    %eax,%ecx
  801065:	d3 eb                	shr    %cl,%ebx
  801067:	09 de                	or     %ebx,%esi
  801069:	89 f0                	mov    %esi,%eax
  80106b:	f7 74 24 08          	divl   0x8(%esp)
  80106f:	89 d6                	mov    %edx,%esi
  801071:	89 c3                	mov    %eax,%ebx
  801073:	f7 64 24 0c          	mull   0xc(%esp)
  801077:	39 d6                	cmp    %edx,%esi
  801079:	72 15                	jb     801090 <__udivdi3+0x100>
  80107b:	89 f9                	mov    %edi,%ecx
  80107d:	d3 e5                	shl    %cl,%ebp
  80107f:	39 c5                	cmp    %eax,%ebp
  801081:	73 04                	jae    801087 <__udivdi3+0xf7>
  801083:	39 d6                	cmp    %edx,%esi
  801085:	74 09                	je     801090 <__udivdi3+0x100>
  801087:	89 d8                	mov    %ebx,%eax
  801089:	31 ff                	xor    %edi,%edi
  80108b:	e9 27 ff ff ff       	jmp    800fb7 <__udivdi3+0x27>
  801090:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801093:	31 ff                	xor    %edi,%edi
  801095:	e9 1d ff ff ff       	jmp    800fb7 <__udivdi3+0x27>
  80109a:	66 90                	xchg   %ax,%ax
  80109c:	66 90                	xchg   %ax,%ax
  80109e:	66 90                	xchg   %ax,%ax

008010a0 <__umoddi3>:
  8010a0:	55                   	push   %ebp
  8010a1:	57                   	push   %edi
  8010a2:	56                   	push   %esi
  8010a3:	53                   	push   %ebx
  8010a4:	83 ec 1c             	sub    $0x1c,%esp
  8010a7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8010ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8010af:	8b 74 24 30          	mov    0x30(%esp),%esi
  8010b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8010b7:	89 da                	mov    %ebx,%edx
  8010b9:	85 c0                	test   %eax,%eax
  8010bb:	75 43                	jne    801100 <__umoddi3+0x60>
  8010bd:	39 df                	cmp    %ebx,%edi
  8010bf:	76 17                	jbe    8010d8 <__umoddi3+0x38>
  8010c1:	89 f0                	mov    %esi,%eax
  8010c3:	f7 f7                	div    %edi
  8010c5:	89 d0                	mov    %edx,%eax
  8010c7:	31 d2                	xor    %edx,%edx
  8010c9:	83 c4 1c             	add    $0x1c,%esp
  8010cc:	5b                   	pop    %ebx
  8010cd:	5e                   	pop    %esi
  8010ce:	5f                   	pop    %edi
  8010cf:	5d                   	pop    %ebp
  8010d0:	c3                   	ret    
  8010d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010d8:	89 fd                	mov    %edi,%ebp
  8010da:	85 ff                	test   %edi,%edi
  8010dc:	75 0b                	jne    8010e9 <__umoddi3+0x49>
  8010de:	b8 01 00 00 00       	mov    $0x1,%eax
  8010e3:	31 d2                	xor    %edx,%edx
  8010e5:	f7 f7                	div    %edi
  8010e7:	89 c5                	mov    %eax,%ebp
  8010e9:	89 d8                	mov    %ebx,%eax
  8010eb:	31 d2                	xor    %edx,%edx
  8010ed:	f7 f5                	div    %ebp
  8010ef:	89 f0                	mov    %esi,%eax
  8010f1:	f7 f5                	div    %ebp
  8010f3:	89 d0                	mov    %edx,%eax
  8010f5:	eb d0                	jmp    8010c7 <__umoddi3+0x27>
  8010f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010fe:	66 90                	xchg   %ax,%ax
  801100:	89 f1                	mov    %esi,%ecx
  801102:	39 d8                	cmp    %ebx,%eax
  801104:	76 0a                	jbe    801110 <__umoddi3+0x70>
  801106:	89 f0                	mov    %esi,%eax
  801108:	83 c4 1c             	add    $0x1c,%esp
  80110b:	5b                   	pop    %ebx
  80110c:	5e                   	pop    %esi
  80110d:	5f                   	pop    %edi
  80110e:	5d                   	pop    %ebp
  80110f:	c3                   	ret    
  801110:	0f bd e8             	bsr    %eax,%ebp
  801113:	83 f5 1f             	xor    $0x1f,%ebp
  801116:	75 20                	jne    801138 <__umoddi3+0x98>
  801118:	39 d8                	cmp    %ebx,%eax
  80111a:	0f 82 b0 00 00 00    	jb     8011d0 <__umoddi3+0x130>
  801120:	39 f7                	cmp    %esi,%edi
  801122:	0f 86 a8 00 00 00    	jbe    8011d0 <__umoddi3+0x130>
  801128:	89 c8                	mov    %ecx,%eax
  80112a:	83 c4 1c             	add    $0x1c,%esp
  80112d:	5b                   	pop    %ebx
  80112e:	5e                   	pop    %esi
  80112f:	5f                   	pop    %edi
  801130:	5d                   	pop    %ebp
  801131:	c3                   	ret    
  801132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801138:	89 e9                	mov    %ebp,%ecx
  80113a:	ba 20 00 00 00       	mov    $0x20,%edx
  80113f:	29 ea                	sub    %ebp,%edx
  801141:	d3 e0                	shl    %cl,%eax
  801143:	89 44 24 08          	mov    %eax,0x8(%esp)
  801147:	89 d1                	mov    %edx,%ecx
  801149:	89 f8                	mov    %edi,%eax
  80114b:	d3 e8                	shr    %cl,%eax
  80114d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801151:	89 54 24 04          	mov    %edx,0x4(%esp)
  801155:	8b 54 24 04          	mov    0x4(%esp),%edx
  801159:	09 c1                	or     %eax,%ecx
  80115b:	89 d8                	mov    %ebx,%eax
  80115d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801161:	89 e9                	mov    %ebp,%ecx
  801163:	d3 e7                	shl    %cl,%edi
  801165:	89 d1                	mov    %edx,%ecx
  801167:	d3 e8                	shr    %cl,%eax
  801169:	89 e9                	mov    %ebp,%ecx
  80116b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80116f:	d3 e3                	shl    %cl,%ebx
  801171:	89 c7                	mov    %eax,%edi
  801173:	89 d1                	mov    %edx,%ecx
  801175:	89 f0                	mov    %esi,%eax
  801177:	d3 e8                	shr    %cl,%eax
  801179:	89 e9                	mov    %ebp,%ecx
  80117b:	89 fa                	mov    %edi,%edx
  80117d:	d3 e6                	shl    %cl,%esi
  80117f:	09 d8                	or     %ebx,%eax
  801181:	f7 74 24 08          	divl   0x8(%esp)
  801185:	89 d1                	mov    %edx,%ecx
  801187:	89 f3                	mov    %esi,%ebx
  801189:	f7 64 24 0c          	mull   0xc(%esp)
  80118d:	89 c6                	mov    %eax,%esi
  80118f:	89 d7                	mov    %edx,%edi
  801191:	39 d1                	cmp    %edx,%ecx
  801193:	72 06                	jb     80119b <__umoddi3+0xfb>
  801195:	75 10                	jne    8011a7 <__umoddi3+0x107>
  801197:	39 c3                	cmp    %eax,%ebx
  801199:	73 0c                	jae    8011a7 <__umoddi3+0x107>
  80119b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80119f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8011a3:	89 d7                	mov    %edx,%edi
  8011a5:	89 c6                	mov    %eax,%esi
  8011a7:	89 ca                	mov    %ecx,%edx
  8011a9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8011ae:	29 f3                	sub    %esi,%ebx
  8011b0:	19 fa                	sbb    %edi,%edx
  8011b2:	89 d0                	mov    %edx,%eax
  8011b4:	d3 e0                	shl    %cl,%eax
  8011b6:	89 e9                	mov    %ebp,%ecx
  8011b8:	d3 eb                	shr    %cl,%ebx
  8011ba:	d3 ea                	shr    %cl,%edx
  8011bc:	09 d8                	or     %ebx,%eax
  8011be:	83 c4 1c             	add    $0x1c,%esp
  8011c1:	5b                   	pop    %ebx
  8011c2:	5e                   	pop    %esi
  8011c3:	5f                   	pop    %edi
  8011c4:	5d                   	pop    %ebp
  8011c5:	c3                   	ret    
  8011c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011cd:	8d 76 00             	lea    0x0(%esi),%esi
  8011d0:	89 da                	mov    %ebx,%edx
  8011d2:	29 fe                	sub    %edi,%esi
  8011d4:	19 c2                	sbb    %eax,%edx
  8011d6:	89 f1                	mov    %esi,%ecx
  8011d8:	89 c8                	mov    %ecx,%eax
  8011da:	e9 4b ff ff ff       	jmp    80112a <__umoddi3+0x8a>
