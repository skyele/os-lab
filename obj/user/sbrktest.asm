
obj/user/sbrktest.debug:     file format elf32-i386


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
  80002c:	e8 8a 00 00 00       	call   8000bb <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#define ALLOCATE_SIZE 4096
#define STRING_SIZE	  64

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 18             	sub    $0x18,%esp
	int i;
	uint32_t start, end;
	char *s;

	start = sys_sbrk(0);
  80003c:	6a 00                	push   $0x0
  80003e:	e8 ed 0e 00 00       	call   800f30 <sys_sbrk>
  800043:	89 c6                	mov    %eax,%esi
  800045:	89 c3                	mov    %eax,%ebx
	end = sys_sbrk(ALLOCATE_SIZE);
  800047:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  80004e:	e8 dd 0e 00 00       	call   800f30 <sys_sbrk>

	if (end - start < ALLOCATE_SIZE) {
  800053:	29 f0                	sub    %esi,%eax
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	3d ff 0f 00 00       	cmp    $0xfff,%eax
  80005d:	76 4a                	jbe    8000a9 <umain+0x76>
		cprintf("sbrk not correctly implemented\n");
	}

	s = (char *) start;
	for ( i = 0; i < STRING_SIZE; i++) {
  80005f:	b9 00 00 00 00       	mov    $0x0,%ecx
		s[i] = 'A' + (i % 26);
  800064:	bf 4f ec c4 4e       	mov    $0x4ec4ec4f,%edi
  800069:	89 c8                	mov    %ecx,%eax
  80006b:	f7 ef                	imul   %edi
  80006d:	c1 fa 03             	sar    $0x3,%edx
  800070:	89 c8                	mov    %ecx,%eax
  800072:	c1 f8 1f             	sar    $0x1f,%eax
  800075:	29 c2                	sub    %eax,%edx
  800077:	6b d2 1a             	imul   $0x1a,%edx,%edx
  80007a:	89 c8                	mov    %ecx,%eax
  80007c:	29 d0                	sub    %edx,%eax
  80007e:	83 c0 41             	add    $0x41,%eax
  800081:	88 04 19             	mov    %al,(%ecx,%ebx,1)
	for ( i = 0; i < STRING_SIZE; i++) {
  800084:	83 c1 01             	add    $0x1,%ecx
  800087:	83 f9 40             	cmp    $0x40,%ecx
  80008a:	75 dd                	jne    800069 <umain+0x36>
	}
	s[STRING_SIZE] = '\0';
  80008c:	c6 46 40 00          	movb   $0x0,0x40(%esi)

	cprintf("SBRK_TEST(%s)\n", s);
  800090:	83 ec 08             	sub    $0x8,%esp
  800093:	56                   	push   %esi
  800094:	68 80 25 80 00       	push   $0x802580
  800099:	e8 2f 01 00 00       	call   8001cd <cprintf>
}
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000a4:	5b                   	pop    %ebx
  8000a5:	5e                   	pop    %esi
  8000a6:	5f                   	pop    %edi
  8000a7:	5d                   	pop    %ebp
  8000a8:	c3                   	ret    
		cprintf("sbrk not correctly implemented\n");
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	68 60 25 80 00       	push   $0x802560
  8000b1:	e8 17 01 00 00       	call   8001cd <cprintf>
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	eb a4                	jmp    80005f <umain+0x2c>

008000bb <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000bb:	55                   	push   %ebp
  8000bc:	89 e5                	mov    %esp,%ebp
  8000be:	56                   	push   %esi
  8000bf:	53                   	push   %ebx
  8000c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000c3:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  8000c6:	e8 15 0c 00 00       	call   800ce0 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  8000cb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000d0:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8000d6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000db:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e0:	85 db                	test   %ebx,%ebx
  8000e2:	7e 07                	jle    8000eb <libmain+0x30>
		binaryname = argv[0];
  8000e4:	8b 06                	mov    (%esi),%eax
  8000e6:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000eb:	83 ec 08             	sub    $0x8,%esp
  8000ee:	56                   	push   %esi
  8000ef:	53                   	push   %ebx
  8000f0:	e8 3e ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000f5:	e8 0a 00 00 00       	call   800104 <exit>
}
  8000fa:	83 c4 10             	add    $0x10,%esp
  8000fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800100:	5b                   	pop    %ebx
  800101:	5e                   	pop    %esi
  800102:	5d                   	pop    %ebp
  800103:	c3                   	ret    

00800104 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800104:	55                   	push   %ebp
  800105:	89 e5                	mov    %esp,%ebp
  800107:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80010a:	a1 08 40 80 00       	mov    0x804008,%eax
  80010f:	8b 40 48             	mov    0x48(%eax),%eax
  800112:	68 a4 25 80 00       	push   $0x8025a4
  800117:	50                   	push   %eax
  800118:	68 99 25 80 00       	push   $0x802599
  80011d:	e8 ab 00 00 00       	call   8001cd <cprintf>
	close_all();
  800122:	e8 c4 10 00 00       	call   8011eb <close_all>
	sys_env_destroy(0);
  800127:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80012e:	e8 6c 0b 00 00       	call   800c9f <sys_env_destroy>
}
  800133:	83 c4 10             	add    $0x10,%esp
  800136:	c9                   	leave  
  800137:	c3                   	ret    

00800138 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	53                   	push   %ebx
  80013c:	83 ec 04             	sub    $0x4,%esp
  80013f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800142:	8b 13                	mov    (%ebx),%edx
  800144:	8d 42 01             	lea    0x1(%edx),%eax
  800147:	89 03                	mov    %eax,(%ebx)
  800149:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80014c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800150:	3d ff 00 00 00       	cmp    $0xff,%eax
  800155:	74 09                	je     800160 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800157:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80015b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80015e:	c9                   	leave  
  80015f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800160:	83 ec 08             	sub    $0x8,%esp
  800163:	68 ff 00 00 00       	push   $0xff
  800168:	8d 43 08             	lea    0x8(%ebx),%eax
  80016b:	50                   	push   %eax
  80016c:	e8 f1 0a 00 00       	call   800c62 <sys_cputs>
		b->idx = 0;
  800171:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800177:	83 c4 10             	add    $0x10,%esp
  80017a:	eb db                	jmp    800157 <putch+0x1f>

0080017c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800185:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80018c:	00 00 00 
	b.cnt = 0;
  80018f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800196:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800199:	ff 75 0c             	pushl  0xc(%ebp)
  80019c:	ff 75 08             	pushl  0x8(%ebp)
  80019f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001a5:	50                   	push   %eax
  8001a6:	68 38 01 80 00       	push   $0x800138
  8001ab:	e8 4a 01 00 00       	call   8002fa <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001b0:	83 c4 08             	add    $0x8,%esp
  8001b3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001b9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001bf:	50                   	push   %eax
  8001c0:	e8 9d 0a 00 00       	call   800c62 <sys_cputs>

	return b.cnt;
}
  8001c5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001cb:	c9                   	leave  
  8001cc:	c3                   	ret    

008001cd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001cd:	55                   	push   %ebp
  8001ce:	89 e5                	mov    %esp,%ebp
  8001d0:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001d3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001d6:	50                   	push   %eax
  8001d7:	ff 75 08             	pushl  0x8(%ebp)
  8001da:	e8 9d ff ff ff       	call   80017c <vcprintf>
	va_end(ap);

	return cnt;
}
  8001df:	c9                   	leave  
  8001e0:	c3                   	ret    

008001e1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001e1:	55                   	push   %ebp
  8001e2:	89 e5                	mov    %esp,%ebp
  8001e4:	57                   	push   %edi
  8001e5:	56                   	push   %esi
  8001e6:	53                   	push   %ebx
  8001e7:	83 ec 1c             	sub    $0x1c,%esp
  8001ea:	89 c6                	mov    %eax,%esi
  8001ec:	89 d7                	mov    %edx,%edi
  8001ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001f7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8001fd:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800200:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800204:	74 2c                	je     800232 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800206:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800209:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800210:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800213:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800216:	39 c2                	cmp    %eax,%edx
  800218:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80021b:	73 43                	jae    800260 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80021d:	83 eb 01             	sub    $0x1,%ebx
  800220:	85 db                	test   %ebx,%ebx
  800222:	7e 6c                	jle    800290 <printnum+0xaf>
				putch(padc, putdat);
  800224:	83 ec 08             	sub    $0x8,%esp
  800227:	57                   	push   %edi
  800228:	ff 75 18             	pushl  0x18(%ebp)
  80022b:	ff d6                	call   *%esi
  80022d:	83 c4 10             	add    $0x10,%esp
  800230:	eb eb                	jmp    80021d <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	6a 20                	push   $0x20
  800237:	6a 00                	push   $0x0
  800239:	50                   	push   %eax
  80023a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023d:	ff 75 e0             	pushl  -0x20(%ebp)
  800240:	89 fa                	mov    %edi,%edx
  800242:	89 f0                	mov    %esi,%eax
  800244:	e8 98 ff ff ff       	call   8001e1 <printnum>
		while (--width > 0)
  800249:	83 c4 20             	add    $0x20,%esp
  80024c:	83 eb 01             	sub    $0x1,%ebx
  80024f:	85 db                	test   %ebx,%ebx
  800251:	7e 65                	jle    8002b8 <printnum+0xd7>
			putch(padc, putdat);
  800253:	83 ec 08             	sub    $0x8,%esp
  800256:	57                   	push   %edi
  800257:	6a 20                	push   $0x20
  800259:	ff d6                	call   *%esi
  80025b:	83 c4 10             	add    $0x10,%esp
  80025e:	eb ec                	jmp    80024c <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	ff 75 18             	pushl  0x18(%ebp)
  800266:	83 eb 01             	sub    $0x1,%ebx
  800269:	53                   	push   %ebx
  80026a:	50                   	push   %eax
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	ff 75 dc             	pushl  -0x24(%ebp)
  800271:	ff 75 d8             	pushl  -0x28(%ebp)
  800274:	ff 75 e4             	pushl  -0x1c(%ebp)
  800277:	ff 75 e0             	pushl  -0x20(%ebp)
  80027a:	e8 91 20 00 00       	call   802310 <__udivdi3>
  80027f:	83 c4 18             	add    $0x18,%esp
  800282:	52                   	push   %edx
  800283:	50                   	push   %eax
  800284:	89 fa                	mov    %edi,%edx
  800286:	89 f0                	mov    %esi,%eax
  800288:	e8 54 ff ff ff       	call   8001e1 <printnum>
  80028d:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800290:	83 ec 08             	sub    $0x8,%esp
  800293:	57                   	push   %edi
  800294:	83 ec 04             	sub    $0x4,%esp
  800297:	ff 75 dc             	pushl  -0x24(%ebp)
  80029a:	ff 75 d8             	pushl  -0x28(%ebp)
  80029d:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a0:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a3:	e8 78 21 00 00       	call   802420 <__umoddi3>
  8002a8:	83 c4 14             	add    $0x14,%esp
  8002ab:	0f be 80 a9 25 80 00 	movsbl 0x8025a9(%eax),%eax
  8002b2:	50                   	push   %eax
  8002b3:	ff d6                	call   *%esi
  8002b5:	83 c4 10             	add    $0x10,%esp
	}
}
  8002b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002bb:	5b                   	pop    %ebx
  8002bc:	5e                   	pop    %esi
  8002bd:	5f                   	pop    %edi
  8002be:	5d                   	pop    %ebp
  8002bf:	c3                   	ret    

008002c0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002c6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002ca:	8b 10                	mov    (%eax),%edx
  8002cc:	3b 50 04             	cmp    0x4(%eax),%edx
  8002cf:	73 0a                	jae    8002db <sprintputch+0x1b>
		*b->buf++ = ch;
  8002d1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002d4:	89 08                	mov    %ecx,(%eax)
  8002d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d9:	88 02                	mov    %al,(%edx)
}
  8002db:	5d                   	pop    %ebp
  8002dc:	c3                   	ret    

008002dd <printfmt>:
{
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002e3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002e6:	50                   	push   %eax
  8002e7:	ff 75 10             	pushl  0x10(%ebp)
  8002ea:	ff 75 0c             	pushl  0xc(%ebp)
  8002ed:	ff 75 08             	pushl  0x8(%ebp)
  8002f0:	e8 05 00 00 00       	call   8002fa <vprintfmt>
}
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	c9                   	leave  
  8002f9:	c3                   	ret    

008002fa <vprintfmt>:
{
  8002fa:	55                   	push   %ebp
  8002fb:	89 e5                	mov    %esp,%ebp
  8002fd:	57                   	push   %edi
  8002fe:	56                   	push   %esi
  8002ff:	53                   	push   %ebx
  800300:	83 ec 3c             	sub    $0x3c,%esp
  800303:	8b 75 08             	mov    0x8(%ebp),%esi
  800306:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800309:	8b 7d 10             	mov    0x10(%ebp),%edi
  80030c:	e9 32 04 00 00       	jmp    800743 <vprintfmt+0x449>
		padc = ' ';
  800311:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800315:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80031c:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800323:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80032a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800331:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800338:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80033d:	8d 47 01             	lea    0x1(%edi),%eax
  800340:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800343:	0f b6 17             	movzbl (%edi),%edx
  800346:	8d 42 dd             	lea    -0x23(%edx),%eax
  800349:	3c 55                	cmp    $0x55,%al
  80034b:	0f 87 12 05 00 00    	ja     800863 <vprintfmt+0x569>
  800351:	0f b6 c0             	movzbl %al,%eax
  800354:	ff 24 85 80 27 80 00 	jmp    *0x802780(,%eax,4)
  80035b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80035e:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800362:	eb d9                	jmp    80033d <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800364:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800367:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80036b:	eb d0                	jmp    80033d <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80036d:	0f b6 d2             	movzbl %dl,%edx
  800370:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800373:	b8 00 00 00 00       	mov    $0x0,%eax
  800378:	89 75 08             	mov    %esi,0x8(%ebp)
  80037b:	eb 03                	jmp    800380 <vprintfmt+0x86>
  80037d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800380:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800383:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800387:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80038a:	8d 72 d0             	lea    -0x30(%edx),%esi
  80038d:	83 fe 09             	cmp    $0x9,%esi
  800390:	76 eb                	jbe    80037d <vprintfmt+0x83>
  800392:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800395:	8b 75 08             	mov    0x8(%ebp),%esi
  800398:	eb 14                	jmp    8003ae <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80039a:	8b 45 14             	mov    0x14(%ebp),%eax
  80039d:	8b 00                	mov    (%eax),%eax
  80039f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a5:	8d 40 04             	lea    0x4(%eax),%eax
  8003a8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003ae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003b2:	79 89                	jns    80033d <vprintfmt+0x43>
				width = precision, precision = -1;
  8003b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ba:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003c1:	e9 77 ff ff ff       	jmp    80033d <vprintfmt+0x43>
  8003c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003c9:	85 c0                	test   %eax,%eax
  8003cb:	0f 48 c1             	cmovs  %ecx,%eax
  8003ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003d4:	e9 64 ff ff ff       	jmp    80033d <vprintfmt+0x43>
  8003d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003dc:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003e3:	e9 55 ff ff ff       	jmp    80033d <vprintfmt+0x43>
			lflag++;
  8003e8:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003ef:	e9 49 ff ff ff       	jmp    80033d <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f7:	8d 78 04             	lea    0x4(%eax),%edi
  8003fa:	83 ec 08             	sub    $0x8,%esp
  8003fd:	53                   	push   %ebx
  8003fe:	ff 30                	pushl  (%eax)
  800400:	ff d6                	call   *%esi
			break;
  800402:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800405:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800408:	e9 33 03 00 00       	jmp    800740 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80040d:	8b 45 14             	mov    0x14(%ebp),%eax
  800410:	8d 78 04             	lea    0x4(%eax),%edi
  800413:	8b 00                	mov    (%eax),%eax
  800415:	99                   	cltd   
  800416:	31 d0                	xor    %edx,%eax
  800418:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80041a:	83 f8 11             	cmp    $0x11,%eax
  80041d:	7f 23                	jg     800442 <vprintfmt+0x148>
  80041f:	8b 14 85 e0 28 80 00 	mov    0x8028e0(,%eax,4),%edx
  800426:	85 d2                	test   %edx,%edx
  800428:	74 18                	je     800442 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80042a:	52                   	push   %edx
  80042b:	68 fd 29 80 00       	push   $0x8029fd
  800430:	53                   	push   %ebx
  800431:	56                   	push   %esi
  800432:	e8 a6 fe ff ff       	call   8002dd <printfmt>
  800437:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80043a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80043d:	e9 fe 02 00 00       	jmp    800740 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800442:	50                   	push   %eax
  800443:	68 c1 25 80 00       	push   $0x8025c1
  800448:	53                   	push   %ebx
  800449:	56                   	push   %esi
  80044a:	e8 8e fe ff ff       	call   8002dd <printfmt>
  80044f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800452:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800455:	e9 e6 02 00 00       	jmp    800740 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80045a:	8b 45 14             	mov    0x14(%ebp),%eax
  80045d:	83 c0 04             	add    $0x4,%eax
  800460:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800463:	8b 45 14             	mov    0x14(%ebp),%eax
  800466:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800468:	85 c9                	test   %ecx,%ecx
  80046a:	b8 ba 25 80 00       	mov    $0x8025ba,%eax
  80046f:	0f 45 c1             	cmovne %ecx,%eax
  800472:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800475:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800479:	7e 06                	jle    800481 <vprintfmt+0x187>
  80047b:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80047f:	75 0d                	jne    80048e <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800481:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800484:	89 c7                	mov    %eax,%edi
  800486:	03 45 e0             	add    -0x20(%ebp),%eax
  800489:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80048c:	eb 53                	jmp    8004e1 <vprintfmt+0x1e7>
  80048e:	83 ec 08             	sub    $0x8,%esp
  800491:	ff 75 d8             	pushl  -0x28(%ebp)
  800494:	50                   	push   %eax
  800495:	e8 71 04 00 00       	call   80090b <strnlen>
  80049a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80049d:	29 c1                	sub    %eax,%ecx
  80049f:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004a2:	83 c4 10             	add    $0x10,%esp
  8004a5:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004a7:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ae:	eb 0f                	jmp    8004bf <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004b0:	83 ec 08             	sub    $0x8,%esp
  8004b3:	53                   	push   %ebx
  8004b4:	ff 75 e0             	pushl  -0x20(%ebp)
  8004b7:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b9:	83 ef 01             	sub    $0x1,%edi
  8004bc:	83 c4 10             	add    $0x10,%esp
  8004bf:	85 ff                	test   %edi,%edi
  8004c1:	7f ed                	jg     8004b0 <vprintfmt+0x1b6>
  8004c3:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004c6:	85 c9                	test   %ecx,%ecx
  8004c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8004cd:	0f 49 c1             	cmovns %ecx,%eax
  8004d0:	29 c1                	sub    %eax,%ecx
  8004d2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004d5:	eb aa                	jmp    800481 <vprintfmt+0x187>
					putch(ch, putdat);
  8004d7:	83 ec 08             	sub    $0x8,%esp
  8004da:	53                   	push   %ebx
  8004db:	52                   	push   %edx
  8004dc:	ff d6                	call   *%esi
  8004de:	83 c4 10             	add    $0x10,%esp
  8004e1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004e4:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004e6:	83 c7 01             	add    $0x1,%edi
  8004e9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004ed:	0f be d0             	movsbl %al,%edx
  8004f0:	85 d2                	test   %edx,%edx
  8004f2:	74 4b                	je     80053f <vprintfmt+0x245>
  8004f4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004f8:	78 06                	js     800500 <vprintfmt+0x206>
  8004fa:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004fe:	78 1e                	js     80051e <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800500:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800504:	74 d1                	je     8004d7 <vprintfmt+0x1dd>
  800506:	0f be c0             	movsbl %al,%eax
  800509:	83 e8 20             	sub    $0x20,%eax
  80050c:	83 f8 5e             	cmp    $0x5e,%eax
  80050f:	76 c6                	jbe    8004d7 <vprintfmt+0x1dd>
					putch('?', putdat);
  800511:	83 ec 08             	sub    $0x8,%esp
  800514:	53                   	push   %ebx
  800515:	6a 3f                	push   $0x3f
  800517:	ff d6                	call   *%esi
  800519:	83 c4 10             	add    $0x10,%esp
  80051c:	eb c3                	jmp    8004e1 <vprintfmt+0x1e7>
  80051e:	89 cf                	mov    %ecx,%edi
  800520:	eb 0e                	jmp    800530 <vprintfmt+0x236>
				putch(' ', putdat);
  800522:	83 ec 08             	sub    $0x8,%esp
  800525:	53                   	push   %ebx
  800526:	6a 20                	push   $0x20
  800528:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80052a:	83 ef 01             	sub    $0x1,%edi
  80052d:	83 c4 10             	add    $0x10,%esp
  800530:	85 ff                	test   %edi,%edi
  800532:	7f ee                	jg     800522 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800534:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800537:	89 45 14             	mov    %eax,0x14(%ebp)
  80053a:	e9 01 02 00 00       	jmp    800740 <vprintfmt+0x446>
  80053f:	89 cf                	mov    %ecx,%edi
  800541:	eb ed                	jmp    800530 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800543:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800546:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80054d:	e9 eb fd ff ff       	jmp    80033d <vprintfmt+0x43>
	if (lflag >= 2)
  800552:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800556:	7f 21                	jg     800579 <vprintfmt+0x27f>
	else if (lflag)
  800558:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80055c:	74 68                	je     8005c6 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80055e:	8b 45 14             	mov    0x14(%ebp),%eax
  800561:	8b 00                	mov    (%eax),%eax
  800563:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800566:	89 c1                	mov    %eax,%ecx
  800568:	c1 f9 1f             	sar    $0x1f,%ecx
  80056b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80056e:	8b 45 14             	mov    0x14(%ebp),%eax
  800571:	8d 40 04             	lea    0x4(%eax),%eax
  800574:	89 45 14             	mov    %eax,0x14(%ebp)
  800577:	eb 17                	jmp    800590 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800579:	8b 45 14             	mov    0x14(%ebp),%eax
  80057c:	8b 50 04             	mov    0x4(%eax),%edx
  80057f:	8b 00                	mov    (%eax),%eax
  800581:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800584:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	8d 40 08             	lea    0x8(%eax),%eax
  80058d:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800590:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800593:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800596:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800599:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80059c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005a0:	78 3f                	js     8005e1 <vprintfmt+0x2e7>
			base = 10;
  8005a2:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005a7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005ab:	0f 84 71 01 00 00    	je     800722 <vprintfmt+0x428>
				putch('+', putdat);
  8005b1:	83 ec 08             	sub    $0x8,%esp
  8005b4:	53                   	push   %ebx
  8005b5:	6a 2b                	push   $0x2b
  8005b7:	ff d6                	call   *%esi
  8005b9:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005bc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c1:	e9 5c 01 00 00       	jmp    800722 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	8b 00                	mov    (%eax),%eax
  8005cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005ce:	89 c1                	mov    %eax,%ecx
  8005d0:	c1 f9 1f             	sar    $0x1f,%ecx
  8005d3:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d9:	8d 40 04             	lea    0x4(%eax),%eax
  8005dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8005df:	eb af                	jmp    800590 <vprintfmt+0x296>
				putch('-', putdat);
  8005e1:	83 ec 08             	sub    $0x8,%esp
  8005e4:	53                   	push   %ebx
  8005e5:	6a 2d                	push   $0x2d
  8005e7:	ff d6                	call   *%esi
				num = -(long long) num;
  8005e9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005ec:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005ef:	f7 d8                	neg    %eax
  8005f1:	83 d2 00             	adc    $0x0,%edx
  8005f4:	f7 da                	neg    %edx
  8005f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005fc:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005ff:	b8 0a 00 00 00       	mov    $0xa,%eax
  800604:	e9 19 01 00 00       	jmp    800722 <vprintfmt+0x428>
	if (lflag >= 2)
  800609:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80060d:	7f 29                	jg     800638 <vprintfmt+0x33e>
	else if (lflag)
  80060f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800613:	74 44                	je     800659 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800615:	8b 45 14             	mov    0x14(%ebp),%eax
  800618:	8b 00                	mov    (%eax),%eax
  80061a:	ba 00 00 00 00       	mov    $0x0,%edx
  80061f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800622:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800625:	8b 45 14             	mov    0x14(%ebp),%eax
  800628:	8d 40 04             	lea    0x4(%eax),%eax
  80062b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800633:	e9 ea 00 00 00       	jmp    800722 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	8b 50 04             	mov    0x4(%eax),%edx
  80063e:	8b 00                	mov    (%eax),%eax
  800640:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800643:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8d 40 08             	lea    0x8(%eax),%eax
  80064c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80064f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800654:	e9 c9 00 00 00       	jmp    800722 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	8b 00                	mov    (%eax),%eax
  80065e:	ba 00 00 00 00       	mov    $0x0,%edx
  800663:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800666:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800669:	8b 45 14             	mov    0x14(%ebp),%eax
  80066c:	8d 40 04             	lea    0x4(%eax),%eax
  80066f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800672:	b8 0a 00 00 00       	mov    $0xa,%eax
  800677:	e9 a6 00 00 00       	jmp    800722 <vprintfmt+0x428>
			putch('0', putdat);
  80067c:	83 ec 08             	sub    $0x8,%esp
  80067f:	53                   	push   %ebx
  800680:	6a 30                	push   $0x30
  800682:	ff d6                	call   *%esi
	if (lflag >= 2)
  800684:	83 c4 10             	add    $0x10,%esp
  800687:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80068b:	7f 26                	jg     8006b3 <vprintfmt+0x3b9>
	else if (lflag)
  80068d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800691:	74 3e                	je     8006d1 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800693:	8b 45 14             	mov    0x14(%ebp),%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	ba 00 00 00 00       	mov    $0x0,%edx
  80069d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a6:	8d 40 04             	lea    0x4(%eax),%eax
  8006a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ac:	b8 08 00 00 00       	mov    $0x8,%eax
  8006b1:	eb 6f                	jmp    800722 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b6:	8b 50 04             	mov    0x4(%eax),%edx
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006be:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	8d 40 08             	lea    0x8(%eax),%eax
  8006c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ca:	b8 08 00 00 00       	mov    $0x8,%eax
  8006cf:	eb 51                	jmp    800722 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006de:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e4:	8d 40 04             	lea    0x4(%eax),%eax
  8006e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ea:	b8 08 00 00 00       	mov    $0x8,%eax
  8006ef:	eb 31                	jmp    800722 <vprintfmt+0x428>
			putch('0', putdat);
  8006f1:	83 ec 08             	sub    $0x8,%esp
  8006f4:	53                   	push   %ebx
  8006f5:	6a 30                	push   $0x30
  8006f7:	ff d6                	call   *%esi
			putch('x', putdat);
  8006f9:	83 c4 08             	add    $0x8,%esp
  8006fc:	53                   	push   %ebx
  8006fd:	6a 78                	push   $0x78
  8006ff:	ff d6                	call   *%esi
			num = (unsigned long long)
  800701:	8b 45 14             	mov    0x14(%ebp),%eax
  800704:	8b 00                	mov    (%eax),%eax
  800706:	ba 00 00 00 00       	mov    $0x0,%edx
  80070b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80070e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800711:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800714:	8b 45 14             	mov    0x14(%ebp),%eax
  800717:	8d 40 04             	lea    0x4(%eax),%eax
  80071a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800722:	83 ec 0c             	sub    $0xc,%esp
  800725:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800729:	52                   	push   %edx
  80072a:	ff 75 e0             	pushl  -0x20(%ebp)
  80072d:	50                   	push   %eax
  80072e:	ff 75 dc             	pushl  -0x24(%ebp)
  800731:	ff 75 d8             	pushl  -0x28(%ebp)
  800734:	89 da                	mov    %ebx,%edx
  800736:	89 f0                	mov    %esi,%eax
  800738:	e8 a4 fa ff ff       	call   8001e1 <printnum>
			break;
  80073d:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800740:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800743:	83 c7 01             	add    $0x1,%edi
  800746:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80074a:	83 f8 25             	cmp    $0x25,%eax
  80074d:	0f 84 be fb ff ff    	je     800311 <vprintfmt+0x17>
			if (ch == '\0')
  800753:	85 c0                	test   %eax,%eax
  800755:	0f 84 28 01 00 00    	je     800883 <vprintfmt+0x589>
			putch(ch, putdat);
  80075b:	83 ec 08             	sub    $0x8,%esp
  80075e:	53                   	push   %ebx
  80075f:	50                   	push   %eax
  800760:	ff d6                	call   *%esi
  800762:	83 c4 10             	add    $0x10,%esp
  800765:	eb dc                	jmp    800743 <vprintfmt+0x449>
	if (lflag >= 2)
  800767:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80076b:	7f 26                	jg     800793 <vprintfmt+0x499>
	else if (lflag)
  80076d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800771:	74 41                	je     8007b4 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	8b 00                	mov    (%eax),%eax
  800778:	ba 00 00 00 00       	mov    $0x0,%edx
  80077d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800780:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800783:	8b 45 14             	mov    0x14(%ebp),%eax
  800786:	8d 40 04             	lea    0x4(%eax),%eax
  800789:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80078c:	b8 10 00 00 00       	mov    $0x10,%eax
  800791:	eb 8f                	jmp    800722 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800793:	8b 45 14             	mov    0x14(%ebp),%eax
  800796:	8b 50 04             	mov    0x4(%eax),%edx
  800799:	8b 00                	mov    (%eax),%eax
  80079b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a4:	8d 40 08             	lea    0x8(%eax),%eax
  8007a7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007aa:	b8 10 00 00 00       	mov    $0x10,%eax
  8007af:	e9 6e ff ff ff       	jmp    800722 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	8b 00                	mov    (%eax),%eax
  8007b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c7:	8d 40 04             	lea    0x4(%eax),%eax
  8007ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007cd:	b8 10 00 00 00       	mov    $0x10,%eax
  8007d2:	e9 4b ff ff ff       	jmp    800722 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	83 c0 04             	add    $0x4,%eax
  8007dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	85 c0                	test   %eax,%eax
  8007e7:	74 14                	je     8007fd <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007e9:	8b 13                	mov    (%ebx),%edx
  8007eb:	83 fa 7f             	cmp    $0x7f,%edx
  8007ee:	7f 37                	jg     800827 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007f0:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007f5:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f8:	e9 43 ff ff ff       	jmp    800740 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8007fd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800802:	bf dd 26 80 00       	mov    $0x8026dd,%edi
							putch(ch, putdat);
  800807:	83 ec 08             	sub    $0x8,%esp
  80080a:	53                   	push   %ebx
  80080b:	50                   	push   %eax
  80080c:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80080e:	83 c7 01             	add    $0x1,%edi
  800811:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800815:	83 c4 10             	add    $0x10,%esp
  800818:	85 c0                	test   %eax,%eax
  80081a:	75 eb                	jne    800807 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80081c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80081f:	89 45 14             	mov    %eax,0x14(%ebp)
  800822:	e9 19 ff ff ff       	jmp    800740 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800827:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800829:	b8 0a 00 00 00       	mov    $0xa,%eax
  80082e:	bf 15 27 80 00       	mov    $0x802715,%edi
							putch(ch, putdat);
  800833:	83 ec 08             	sub    $0x8,%esp
  800836:	53                   	push   %ebx
  800837:	50                   	push   %eax
  800838:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80083a:	83 c7 01             	add    $0x1,%edi
  80083d:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800841:	83 c4 10             	add    $0x10,%esp
  800844:	85 c0                	test   %eax,%eax
  800846:	75 eb                	jne    800833 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800848:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80084b:	89 45 14             	mov    %eax,0x14(%ebp)
  80084e:	e9 ed fe ff ff       	jmp    800740 <vprintfmt+0x446>
			putch(ch, putdat);
  800853:	83 ec 08             	sub    $0x8,%esp
  800856:	53                   	push   %ebx
  800857:	6a 25                	push   $0x25
  800859:	ff d6                	call   *%esi
			break;
  80085b:	83 c4 10             	add    $0x10,%esp
  80085e:	e9 dd fe ff ff       	jmp    800740 <vprintfmt+0x446>
			putch('%', putdat);
  800863:	83 ec 08             	sub    $0x8,%esp
  800866:	53                   	push   %ebx
  800867:	6a 25                	push   $0x25
  800869:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80086b:	83 c4 10             	add    $0x10,%esp
  80086e:	89 f8                	mov    %edi,%eax
  800870:	eb 03                	jmp    800875 <vprintfmt+0x57b>
  800872:	83 e8 01             	sub    $0x1,%eax
  800875:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800879:	75 f7                	jne    800872 <vprintfmt+0x578>
  80087b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80087e:	e9 bd fe ff ff       	jmp    800740 <vprintfmt+0x446>
}
  800883:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800886:	5b                   	pop    %ebx
  800887:	5e                   	pop    %esi
  800888:	5f                   	pop    %edi
  800889:	5d                   	pop    %ebp
  80088a:	c3                   	ret    

0080088b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80088b:	55                   	push   %ebp
  80088c:	89 e5                	mov    %esp,%ebp
  80088e:	83 ec 18             	sub    $0x18,%esp
  800891:	8b 45 08             	mov    0x8(%ebp),%eax
  800894:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800897:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80089a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80089e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008a8:	85 c0                	test   %eax,%eax
  8008aa:	74 26                	je     8008d2 <vsnprintf+0x47>
  8008ac:	85 d2                	test   %edx,%edx
  8008ae:	7e 22                	jle    8008d2 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008b0:	ff 75 14             	pushl  0x14(%ebp)
  8008b3:	ff 75 10             	pushl  0x10(%ebp)
  8008b6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008b9:	50                   	push   %eax
  8008ba:	68 c0 02 80 00       	push   $0x8002c0
  8008bf:	e8 36 fa ff ff       	call   8002fa <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008cd:	83 c4 10             	add    $0x10,%esp
}
  8008d0:	c9                   	leave  
  8008d1:	c3                   	ret    
		return -E_INVAL;
  8008d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d7:	eb f7                	jmp    8008d0 <vsnprintf+0x45>

008008d9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008d9:	55                   	push   %ebp
  8008da:	89 e5                	mov    %esp,%ebp
  8008dc:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008df:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008e2:	50                   	push   %eax
  8008e3:	ff 75 10             	pushl  0x10(%ebp)
  8008e6:	ff 75 0c             	pushl  0xc(%ebp)
  8008e9:	ff 75 08             	pushl  0x8(%ebp)
  8008ec:	e8 9a ff ff ff       	call   80088b <vsnprintf>
	va_end(ap);

	return rc;
}
  8008f1:	c9                   	leave  
  8008f2:	c3                   	ret    

008008f3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008f3:	55                   	push   %ebp
  8008f4:	89 e5                	mov    %esp,%ebp
  8008f6:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8008fe:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800902:	74 05                	je     800909 <strlen+0x16>
		n++;
  800904:	83 c0 01             	add    $0x1,%eax
  800907:	eb f5                	jmp    8008fe <strlen+0xb>
	return n;
}
  800909:	5d                   	pop    %ebp
  80090a:	c3                   	ret    

0080090b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800911:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800914:	ba 00 00 00 00       	mov    $0x0,%edx
  800919:	39 c2                	cmp    %eax,%edx
  80091b:	74 0d                	je     80092a <strnlen+0x1f>
  80091d:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800921:	74 05                	je     800928 <strnlen+0x1d>
		n++;
  800923:	83 c2 01             	add    $0x1,%edx
  800926:	eb f1                	jmp    800919 <strnlen+0xe>
  800928:	89 d0                	mov    %edx,%eax
	return n;
}
  80092a:	5d                   	pop    %ebp
  80092b:	c3                   	ret    

0080092c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
  80092f:	53                   	push   %ebx
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800936:	ba 00 00 00 00       	mov    $0x0,%edx
  80093b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80093f:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800942:	83 c2 01             	add    $0x1,%edx
  800945:	84 c9                	test   %cl,%cl
  800947:	75 f2                	jne    80093b <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800949:	5b                   	pop    %ebx
  80094a:	5d                   	pop    %ebp
  80094b:	c3                   	ret    

0080094c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80094c:	55                   	push   %ebp
  80094d:	89 e5                	mov    %esp,%ebp
  80094f:	53                   	push   %ebx
  800950:	83 ec 10             	sub    $0x10,%esp
  800953:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800956:	53                   	push   %ebx
  800957:	e8 97 ff ff ff       	call   8008f3 <strlen>
  80095c:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80095f:	ff 75 0c             	pushl  0xc(%ebp)
  800962:	01 d8                	add    %ebx,%eax
  800964:	50                   	push   %eax
  800965:	e8 c2 ff ff ff       	call   80092c <strcpy>
	return dst;
}
  80096a:	89 d8                	mov    %ebx,%eax
  80096c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80096f:	c9                   	leave  
  800970:	c3                   	ret    

00800971 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
  800974:	56                   	push   %esi
  800975:	53                   	push   %ebx
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80097c:	89 c6                	mov    %eax,%esi
  80097e:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800981:	89 c2                	mov    %eax,%edx
  800983:	39 f2                	cmp    %esi,%edx
  800985:	74 11                	je     800998 <strncpy+0x27>
		*dst++ = *src;
  800987:	83 c2 01             	add    $0x1,%edx
  80098a:	0f b6 19             	movzbl (%ecx),%ebx
  80098d:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800990:	80 fb 01             	cmp    $0x1,%bl
  800993:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800996:	eb eb                	jmp    800983 <strncpy+0x12>
	}
	return ret;
}
  800998:	5b                   	pop    %ebx
  800999:	5e                   	pop    %esi
  80099a:	5d                   	pop    %ebp
  80099b:	c3                   	ret    

0080099c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	56                   	push   %esi
  8009a0:	53                   	push   %ebx
  8009a1:	8b 75 08             	mov    0x8(%ebp),%esi
  8009a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009a7:	8b 55 10             	mov    0x10(%ebp),%edx
  8009aa:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009ac:	85 d2                	test   %edx,%edx
  8009ae:	74 21                	je     8009d1 <strlcpy+0x35>
  8009b0:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009b4:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009b6:	39 c2                	cmp    %eax,%edx
  8009b8:	74 14                	je     8009ce <strlcpy+0x32>
  8009ba:	0f b6 19             	movzbl (%ecx),%ebx
  8009bd:	84 db                	test   %bl,%bl
  8009bf:	74 0b                	je     8009cc <strlcpy+0x30>
			*dst++ = *src++;
  8009c1:	83 c1 01             	add    $0x1,%ecx
  8009c4:	83 c2 01             	add    $0x1,%edx
  8009c7:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009ca:	eb ea                	jmp    8009b6 <strlcpy+0x1a>
  8009cc:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009ce:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009d1:	29 f0                	sub    %esi,%eax
}
  8009d3:	5b                   	pop    %ebx
  8009d4:	5e                   	pop    %esi
  8009d5:	5d                   	pop    %ebp
  8009d6:	c3                   	ret    

008009d7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009d7:	55                   	push   %ebp
  8009d8:	89 e5                	mov    %esp,%ebp
  8009da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009dd:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009e0:	0f b6 01             	movzbl (%ecx),%eax
  8009e3:	84 c0                	test   %al,%al
  8009e5:	74 0c                	je     8009f3 <strcmp+0x1c>
  8009e7:	3a 02                	cmp    (%edx),%al
  8009e9:	75 08                	jne    8009f3 <strcmp+0x1c>
		p++, q++;
  8009eb:	83 c1 01             	add    $0x1,%ecx
  8009ee:	83 c2 01             	add    $0x1,%edx
  8009f1:	eb ed                	jmp    8009e0 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009f3:	0f b6 c0             	movzbl %al,%eax
  8009f6:	0f b6 12             	movzbl (%edx),%edx
  8009f9:	29 d0                	sub    %edx,%eax
}
  8009fb:	5d                   	pop    %ebp
  8009fc:	c3                   	ret    

008009fd <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	53                   	push   %ebx
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a07:	89 c3                	mov    %eax,%ebx
  800a09:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a0c:	eb 06                	jmp    800a14 <strncmp+0x17>
		n--, p++, q++;
  800a0e:	83 c0 01             	add    $0x1,%eax
  800a11:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a14:	39 d8                	cmp    %ebx,%eax
  800a16:	74 16                	je     800a2e <strncmp+0x31>
  800a18:	0f b6 08             	movzbl (%eax),%ecx
  800a1b:	84 c9                	test   %cl,%cl
  800a1d:	74 04                	je     800a23 <strncmp+0x26>
  800a1f:	3a 0a                	cmp    (%edx),%cl
  800a21:	74 eb                	je     800a0e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a23:	0f b6 00             	movzbl (%eax),%eax
  800a26:	0f b6 12             	movzbl (%edx),%edx
  800a29:	29 d0                	sub    %edx,%eax
}
  800a2b:	5b                   	pop    %ebx
  800a2c:	5d                   	pop    %ebp
  800a2d:	c3                   	ret    
		return 0;
  800a2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a33:	eb f6                	jmp    800a2b <strncmp+0x2e>

00800a35 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a35:	55                   	push   %ebp
  800a36:	89 e5                	mov    %esp,%ebp
  800a38:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a3f:	0f b6 10             	movzbl (%eax),%edx
  800a42:	84 d2                	test   %dl,%dl
  800a44:	74 09                	je     800a4f <strchr+0x1a>
		if (*s == c)
  800a46:	38 ca                	cmp    %cl,%dl
  800a48:	74 0a                	je     800a54 <strchr+0x1f>
	for (; *s; s++)
  800a4a:	83 c0 01             	add    $0x1,%eax
  800a4d:	eb f0                	jmp    800a3f <strchr+0xa>
			return (char *) s;
	return 0;
  800a4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a54:	5d                   	pop    %ebp
  800a55:	c3                   	ret    

00800a56 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a60:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a63:	38 ca                	cmp    %cl,%dl
  800a65:	74 09                	je     800a70 <strfind+0x1a>
  800a67:	84 d2                	test   %dl,%dl
  800a69:	74 05                	je     800a70 <strfind+0x1a>
	for (; *s; s++)
  800a6b:	83 c0 01             	add    $0x1,%eax
  800a6e:	eb f0                	jmp    800a60 <strfind+0xa>
			break;
	return (char *) s;
}
  800a70:	5d                   	pop    %ebp
  800a71:	c3                   	ret    

00800a72 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	57                   	push   %edi
  800a76:	56                   	push   %esi
  800a77:	53                   	push   %ebx
  800a78:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a7e:	85 c9                	test   %ecx,%ecx
  800a80:	74 31                	je     800ab3 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a82:	89 f8                	mov    %edi,%eax
  800a84:	09 c8                	or     %ecx,%eax
  800a86:	a8 03                	test   $0x3,%al
  800a88:	75 23                	jne    800aad <memset+0x3b>
		c &= 0xFF;
  800a8a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a8e:	89 d3                	mov    %edx,%ebx
  800a90:	c1 e3 08             	shl    $0x8,%ebx
  800a93:	89 d0                	mov    %edx,%eax
  800a95:	c1 e0 18             	shl    $0x18,%eax
  800a98:	89 d6                	mov    %edx,%esi
  800a9a:	c1 e6 10             	shl    $0x10,%esi
  800a9d:	09 f0                	or     %esi,%eax
  800a9f:	09 c2                	or     %eax,%edx
  800aa1:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800aa3:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800aa6:	89 d0                	mov    %edx,%eax
  800aa8:	fc                   	cld    
  800aa9:	f3 ab                	rep stos %eax,%es:(%edi)
  800aab:	eb 06                	jmp    800ab3 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800aad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab0:	fc                   	cld    
  800ab1:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ab3:	89 f8                	mov    %edi,%eax
  800ab5:	5b                   	pop    %ebx
  800ab6:	5e                   	pop    %esi
  800ab7:	5f                   	pop    %edi
  800ab8:	5d                   	pop    %ebp
  800ab9:	c3                   	ret    

00800aba <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
  800abd:	57                   	push   %edi
  800abe:	56                   	push   %esi
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ac5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ac8:	39 c6                	cmp    %eax,%esi
  800aca:	73 32                	jae    800afe <memmove+0x44>
  800acc:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800acf:	39 c2                	cmp    %eax,%edx
  800ad1:	76 2b                	jbe    800afe <memmove+0x44>
		s += n;
		d += n;
  800ad3:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad6:	89 fe                	mov    %edi,%esi
  800ad8:	09 ce                	or     %ecx,%esi
  800ada:	09 d6                	or     %edx,%esi
  800adc:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ae2:	75 0e                	jne    800af2 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ae4:	83 ef 04             	sub    $0x4,%edi
  800ae7:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aea:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aed:	fd                   	std    
  800aee:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af0:	eb 09                	jmp    800afb <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800af2:	83 ef 01             	sub    $0x1,%edi
  800af5:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800af8:	fd                   	std    
  800af9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800afb:	fc                   	cld    
  800afc:	eb 1a                	jmp    800b18 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800afe:	89 c2                	mov    %eax,%edx
  800b00:	09 ca                	or     %ecx,%edx
  800b02:	09 f2                	or     %esi,%edx
  800b04:	f6 c2 03             	test   $0x3,%dl
  800b07:	75 0a                	jne    800b13 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b09:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b0c:	89 c7                	mov    %eax,%edi
  800b0e:	fc                   	cld    
  800b0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b11:	eb 05                	jmp    800b18 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b13:	89 c7                	mov    %eax,%edi
  800b15:	fc                   	cld    
  800b16:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b18:	5e                   	pop    %esi
  800b19:	5f                   	pop    %edi
  800b1a:	5d                   	pop    %ebp
  800b1b:	c3                   	ret    

00800b1c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b22:	ff 75 10             	pushl  0x10(%ebp)
  800b25:	ff 75 0c             	pushl  0xc(%ebp)
  800b28:	ff 75 08             	pushl  0x8(%ebp)
  800b2b:	e8 8a ff ff ff       	call   800aba <memmove>
}
  800b30:	c9                   	leave  
  800b31:	c3                   	ret    

00800b32 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	56                   	push   %esi
  800b36:	53                   	push   %ebx
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3d:	89 c6                	mov    %eax,%esi
  800b3f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b42:	39 f0                	cmp    %esi,%eax
  800b44:	74 1c                	je     800b62 <memcmp+0x30>
		if (*s1 != *s2)
  800b46:	0f b6 08             	movzbl (%eax),%ecx
  800b49:	0f b6 1a             	movzbl (%edx),%ebx
  800b4c:	38 d9                	cmp    %bl,%cl
  800b4e:	75 08                	jne    800b58 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b50:	83 c0 01             	add    $0x1,%eax
  800b53:	83 c2 01             	add    $0x1,%edx
  800b56:	eb ea                	jmp    800b42 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b58:	0f b6 c1             	movzbl %cl,%eax
  800b5b:	0f b6 db             	movzbl %bl,%ebx
  800b5e:	29 d8                	sub    %ebx,%eax
  800b60:	eb 05                	jmp    800b67 <memcmp+0x35>
	}

	return 0;
  800b62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b67:	5b                   	pop    %ebx
  800b68:	5e                   	pop    %esi
  800b69:	5d                   	pop    %ebp
  800b6a:	c3                   	ret    

00800b6b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b74:	89 c2                	mov    %eax,%edx
  800b76:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b79:	39 d0                	cmp    %edx,%eax
  800b7b:	73 09                	jae    800b86 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b7d:	38 08                	cmp    %cl,(%eax)
  800b7f:	74 05                	je     800b86 <memfind+0x1b>
	for (; s < ends; s++)
  800b81:	83 c0 01             	add    $0x1,%eax
  800b84:	eb f3                	jmp    800b79 <memfind+0xe>
			break;
	return (void *) s;
}
  800b86:	5d                   	pop    %ebp
  800b87:	c3                   	ret    

00800b88 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
  800b8b:	57                   	push   %edi
  800b8c:	56                   	push   %esi
  800b8d:	53                   	push   %ebx
  800b8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b91:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b94:	eb 03                	jmp    800b99 <strtol+0x11>
		s++;
  800b96:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b99:	0f b6 01             	movzbl (%ecx),%eax
  800b9c:	3c 20                	cmp    $0x20,%al
  800b9e:	74 f6                	je     800b96 <strtol+0xe>
  800ba0:	3c 09                	cmp    $0x9,%al
  800ba2:	74 f2                	je     800b96 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ba4:	3c 2b                	cmp    $0x2b,%al
  800ba6:	74 2a                	je     800bd2 <strtol+0x4a>
	int neg = 0;
  800ba8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bad:	3c 2d                	cmp    $0x2d,%al
  800baf:	74 2b                	je     800bdc <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb1:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bb7:	75 0f                	jne    800bc8 <strtol+0x40>
  800bb9:	80 39 30             	cmpb   $0x30,(%ecx)
  800bbc:	74 28                	je     800be6 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bbe:	85 db                	test   %ebx,%ebx
  800bc0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bc5:	0f 44 d8             	cmove  %eax,%ebx
  800bc8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bcd:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bd0:	eb 50                	jmp    800c22 <strtol+0x9a>
		s++;
  800bd2:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bd5:	bf 00 00 00 00       	mov    $0x0,%edi
  800bda:	eb d5                	jmp    800bb1 <strtol+0x29>
		s++, neg = 1;
  800bdc:	83 c1 01             	add    $0x1,%ecx
  800bdf:	bf 01 00 00 00       	mov    $0x1,%edi
  800be4:	eb cb                	jmp    800bb1 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800be6:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bea:	74 0e                	je     800bfa <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bec:	85 db                	test   %ebx,%ebx
  800bee:	75 d8                	jne    800bc8 <strtol+0x40>
		s++, base = 8;
  800bf0:	83 c1 01             	add    $0x1,%ecx
  800bf3:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bf8:	eb ce                	jmp    800bc8 <strtol+0x40>
		s += 2, base = 16;
  800bfa:	83 c1 02             	add    $0x2,%ecx
  800bfd:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c02:	eb c4                	jmp    800bc8 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c04:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c07:	89 f3                	mov    %esi,%ebx
  800c09:	80 fb 19             	cmp    $0x19,%bl
  800c0c:	77 29                	ja     800c37 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c0e:	0f be d2             	movsbl %dl,%edx
  800c11:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c14:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c17:	7d 30                	jge    800c49 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c19:	83 c1 01             	add    $0x1,%ecx
  800c1c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c20:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c22:	0f b6 11             	movzbl (%ecx),%edx
  800c25:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c28:	89 f3                	mov    %esi,%ebx
  800c2a:	80 fb 09             	cmp    $0x9,%bl
  800c2d:	77 d5                	ja     800c04 <strtol+0x7c>
			dig = *s - '0';
  800c2f:	0f be d2             	movsbl %dl,%edx
  800c32:	83 ea 30             	sub    $0x30,%edx
  800c35:	eb dd                	jmp    800c14 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c37:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c3a:	89 f3                	mov    %esi,%ebx
  800c3c:	80 fb 19             	cmp    $0x19,%bl
  800c3f:	77 08                	ja     800c49 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c41:	0f be d2             	movsbl %dl,%edx
  800c44:	83 ea 37             	sub    $0x37,%edx
  800c47:	eb cb                	jmp    800c14 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4d:	74 05                	je     800c54 <strtol+0xcc>
		*endptr = (char *) s;
  800c4f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c52:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c54:	89 c2                	mov    %eax,%edx
  800c56:	f7 da                	neg    %edx
  800c58:	85 ff                	test   %edi,%edi
  800c5a:	0f 45 c2             	cmovne %edx,%eax
}
  800c5d:	5b                   	pop    %ebx
  800c5e:	5e                   	pop    %esi
  800c5f:	5f                   	pop    %edi
  800c60:	5d                   	pop    %ebp
  800c61:	c3                   	ret    

00800c62 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	57                   	push   %edi
  800c66:	56                   	push   %esi
  800c67:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c68:	b8 00 00 00 00       	mov    $0x0,%eax
  800c6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c73:	89 c3                	mov    %eax,%ebx
  800c75:	89 c7                	mov    %eax,%edi
  800c77:	89 c6                	mov    %eax,%esi
  800c79:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c7b:	5b                   	pop    %ebx
  800c7c:	5e                   	pop    %esi
  800c7d:	5f                   	pop    %edi
  800c7e:	5d                   	pop    %ebp
  800c7f:	c3                   	ret    

00800c80 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	57                   	push   %edi
  800c84:	56                   	push   %esi
  800c85:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c86:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8b:	b8 01 00 00 00       	mov    $0x1,%eax
  800c90:	89 d1                	mov    %edx,%ecx
  800c92:	89 d3                	mov    %edx,%ebx
  800c94:	89 d7                	mov    %edx,%edi
  800c96:	89 d6                	mov    %edx,%esi
  800c98:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c9a:	5b                   	pop    %ebx
  800c9b:	5e                   	pop    %esi
  800c9c:	5f                   	pop    %edi
  800c9d:	5d                   	pop    %ebp
  800c9e:	c3                   	ret    

00800c9f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c9f:	55                   	push   %ebp
  800ca0:	89 e5                	mov    %esp,%ebp
  800ca2:	57                   	push   %edi
  800ca3:	56                   	push   %esi
  800ca4:	53                   	push   %ebx
  800ca5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cad:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb0:	b8 03 00 00 00       	mov    $0x3,%eax
  800cb5:	89 cb                	mov    %ecx,%ebx
  800cb7:	89 cf                	mov    %ecx,%edi
  800cb9:	89 ce                	mov    %ecx,%esi
  800cbb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cbd:	85 c0                	test   %eax,%eax
  800cbf:	7f 08                	jg     800cc9 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc4:	5b                   	pop    %ebx
  800cc5:	5e                   	pop    %esi
  800cc6:	5f                   	pop    %edi
  800cc7:	5d                   	pop    %ebp
  800cc8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc9:	83 ec 0c             	sub    $0xc,%esp
  800ccc:	50                   	push   %eax
  800ccd:	6a 03                	push   $0x3
  800ccf:	68 28 29 80 00       	push   $0x802928
  800cd4:	6a 43                	push   $0x43
  800cd6:	68 45 29 80 00       	push   $0x802945
  800cdb:	e8 89 14 00 00       	call   802169 <_panic>

00800ce0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	57                   	push   %edi
  800ce4:	56                   	push   %esi
  800ce5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce6:	ba 00 00 00 00       	mov    $0x0,%edx
  800ceb:	b8 02 00 00 00       	mov    $0x2,%eax
  800cf0:	89 d1                	mov    %edx,%ecx
  800cf2:	89 d3                	mov    %edx,%ebx
  800cf4:	89 d7                	mov    %edx,%edi
  800cf6:	89 d6                	mov    %edx,%esi
  800cf8:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cfa:	5b                   	pop    %ebx
  800cfb:	5e                   	pop    %esi
  800cfc:	5f                   	pop    %edi
  800cfd:	5d                   	pop    %ebp
  800cfe:	c3                   	ret    

00800cff <sys_yield>:

void
sys_yield(void)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
  800d02:	57                   	push   %edi
  800d03:	56                   	push   %esi
  800d04:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d05:	ba 00 00 00 00       	mov    $0x0,%edx
  800d0a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d0f:	89 d1                	mov    %edx,%ecx
  800d11:	89 d3                	mov    %edx,%ebx
  800d13:	89 d7                	mov    %edx,%edi
  800d15:	89 d6                	mov    %edx,%esi
  800d17:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d19:	5b                   	pop    %ebx
  800d1a:	5e                   	pop    %esi
  800d1b:	5f                   	pop    %edi
  800d1c:	5d                   	pop    %ebp
  800d1d:	c3                   	ret    

00800d1e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	57                   	push   %edi
  800d22:	56                   	push   %esi
  800d23:	53                   	push   %ebx
  800d24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d27:	be 00 00 00 00       	mov    $0x0,%esi
  800d2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d32:	b8 04 00 00 00       	mov    $0x4,%eax
  800d37:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d3a:	89 f7                	mov    %esi,%edi
  800d3c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3e:	85 c0                	test   %eax,%eax
  800d40:	7f 08                	jg     800d4a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d45:	5b                   	pop    %ebx
  800d46:	5e                   	pop    %esi
  800d47:	5f                   	pop    %edi
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4a:	83 ec 0c             	sub    $0xc,%esp
  800d4d:	50                   	push   %eax
  800d4e:	6a 04                	push   $0x4
  800d50:	68 28 29 80 00       	push   $0x802928
  800d55:	6a 43                	push   $0x43
  800d57:	68 45 29 80 00       	push   $0x802945
  800d5c:	e8 08 14 00 00       	call   802169 <_panic>

00800d61 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d61:	55                   	push   %ebp
  800d62:	89 e5                	mov    %esp,%ebp
  800d64:	57                   	push   %edi
  800d65:	56                   	push   %esi
  800d66:	53                   	push   %ebx
  800d67:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d70:	b8 05 00 00 00       	mov    $0x5,%eax
  800d75:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d78:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d7b:	8b 75 18             	mov    0x18(%ebp),%esi
  800d7e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d80:	85 c0                	test   %eax,%eax
  800d82:	7f 08                	jg     800d8c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d87:	5b                   	pop    %ebx
  800d88:	5e                   	pop    %esi
  800d89:	5f                   	pop    %edi
  800d8a:	5d                   	pop    %ebp
  800d8b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8c:	83 ec 0c             	sub    $0xc,%esp
  800d8f:	50                   	push   %eax
  800d90:	6a 05                	push   $0x5
  800d92:	68 28 29 80 00       	push   $0x802928
  800d97:	6a 43                	push   $0x43
  800d99:	68 45 29 80 00       	push   $0x802945
  800d9e:	e8 c6 13 00 00       	call   802169 <_panic>

00800da3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	57                   	push   %edi
  800da7:	56                   	push   %esi
  800da8:	53                   	push   %ebx
  800da9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dac:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db1:	8b 55 08             	mov    0x8(%ebp),%edx
  800db4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db7:	b8 06 00 00 00       	mov    $0x6,%eax
  800dbc:	89 df                	mov    %ebx,%edi
  800dbe:	89 de                	mov    %ebx,%esi
  800dc0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc2:	85 c0                	test   %eax,%eax
  800dc4:	7f 08                	jg     800dce <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc9:	5b                   	pop    %ebx
  800dca:	5e                   	pop    %esi
  800dcb:	5f                   	pop    %edi
  800dcc:	5d                   	pop    %ebp
  800dcd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dce:	83 ec 0c             	sub    $0xc,%esp
  800dd1:	50                   	push   %eax
  800dd2:	6a 06                	push   $0x6
  800dd4:	68 28 29 80 00       	push   $0x802928
  800dd9:	6a 43                	push   $0x43
  800ddb:	68 45 29 80 00       	push   $0x802945
  800de0:	e8 84 13 00 00       	call   802169 <_panic>

00800de5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	57                   	push   %edi
  800de9:	56                   	push   %esi
  800dea:	53                   	push   %ebx
  800deb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dee:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df3:	8b 55 08             	mov    0x8(%ebp),%edx
  800df6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df9:	b8 08 00 00 00       	mov    $0x8,%eax
  800dfe:	89 df                	mov    %ebx,%edi
  800e00:	89 de                	mov    %ebx,%esi
  800e02:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e04:	85 c0                	test   %eax,%eax
  800e06:	7f 08                	jg     800e10 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0b:	5b                   	pop    %ebx
  800e0c:	5e                   	pop    %esi
  800e0d:	5f                   	pop    %edi
  800e0e:	5d                   	pop    %ebp
  800e0f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e10:	83 ec 0c             	sub    $0xc,%esp
  800e13:	50                   	push   %eax
  800e14:	6a 08                	push   $0x8
  800e16:	68 28 29 80 00       	push   $0x802928
  800e1b:	6a 43                	push   $0x43
  800e1d:	68 45 29 80 00       	push   $0x802945
  800e22:	e8 42 13 00 00       	call   802169 <_panic>

00800e27 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e27:	55                   	push   %ebp
  800e28:	89 e5                	mov    %esp,%ebp
  800e2a:	57                   	push   %edi
  800e2b:	56                   	push   %esi
  800e2c:	53                   	push   %ebx
  800e2d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e30:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e35:	8b 55 08             	mov    0x8(%ebp),%edx
  800e38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3b:	b8 09 00 00 00       	mov    $0x9,%eax
  800e40:	89 df                	mov    %ebx,%edi
  800e42:	89 de                	mov    %ebx,%esi
  800e44:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e46:	85 c0                	test   %eax,%eax
  800e48:	7f 08                	jg     800e52 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4d:	5b                   	pop    %ebx
  800e4e:	5e                   	pop    %esi
  800e4f:	5f                   	pop    %edi
  800e50:	5d                   	pop    %ebp
  800e51:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e52:	83 ec 0c             	sub    $0xc,%esp
  800e55:	50                   	push   %eax
  800e56:	6a 09                	push   $0x9
  800e58:	68 28 29 80 00       	push   $0x802928
  800e5d:	6a 43                	push   $0x43
  800e5f:	68 45 29 80 00       	push   $0x802945
  800e64:	e8 00 13 00 00       	call   802169 <_panic>

00800e69 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	57                   	push   %edi
  800e6d:	56                   	push   %esi
  800e6e:	53                   	push   %ebx
  800e6f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e72:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e77:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e82:	89 df                	mov    %ebx,%edi
  800e84:	89 de                	mov    %ebx,%esi
  800e86:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e88:	85 c0                	test   %eax,%eax
  800e8a:	7f 08                	jg     800e94 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8f:	5b                   	pop    %ebx
  800e90:	5e                   	pop    %esi
  800e91:	5f                   	pop    %edi
  800e92:	5d                   	pop    %ebp
  800e93:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e94:	83 ec 0c             	sub    $0xc,%esp
  800e97:	50                   	push   %eax
  800e98:	6a 0a                	push   $0xa
  800e9a:	68 28 29 80 00       	push   $0x802928
  800e9f:	6a 43                	push   $0x43
  800ea1:	68 45 29 80 00       	push   $0x802945
  800ea6:	e8 be 12 00 00       	call   802169 <_panic>

00800eab <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eab:	55                   	push   %ebp
  800eac:	89 e5                	mov    %esp,%ebp
  800eae:	57                   	push   %edi
  800eaf:	56                   	push   %esi
  800eb0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eb1:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb7:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ebc:	be 00 00 00 00       	mov    $0x0,%esi
  800ec1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ec4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ec7:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ec9:	5b                   	pop    %ebx
  800eca:	5e                   	pop    %esi
  800ecb:	5f                   	pop    %edi
  800ecc:	5d                   	pop    %ebp
  800ecd:	c3                   	ret    

00800ece <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ece:	55                   	push   %ebp
  800ecf:	89 e5                	mov    %esp,%ebp
  800ed1:	57                   	push   %edi
  800ed2:	56                   	push   %esi
  800ed3:	53                   	push   %ebx
  800ed4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800edc:	8b 55 08             	mov    0x8(%ebp),%edx
  800edf:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ee4:	89 cb                	mov    %ecx,%ebx
  800ee6:	89 cf                	mov    %ecx,%edi
  800ee8:	89 ce                	mov    %ecx,%esi
  800eea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eec:	85 c0                	test   %eax,%eax
  800eee:	7f 08                	jg     800ef8 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef3:	5b                   	pop    %ebx
  800ef4:	5e                   	pop    %esi
  800ef5:	5f                   	pop    %edi
  800ef6:	5d                   	pop    %ebp
  800ef7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef8:	83 ec 0c             	sub    $0xc,%esp
  800efb:	50                   	push   %eax
  800efc:	6a 0d                	push   $0xd
  800efe:	68 28 29 80 00       	push   $0x802928
  800f03:	6a 43                	push   $0x43
  800f05:	68 45 29 80 00       	push   $0x802945
  800f0a:	e8 5a 12 00 00       	call   802169 <_panic>

00800f0f <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f0f:	55                   	push   %ebp
  800f10:	89 e5                	mov    %esp,%ebp
  800f12:	57                   	push   %edi
  800f13:	56                   	push   %esi
  800f14:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f15:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f20:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f25:	89 df                	mov    %ebx,%edi
  800f27:	89 de                	mov    %ebx,%esi
  800f29:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f2b:	5b                   	pop    %ebx
  800f2c:	5e                   	pop    %esi
  800f2d:	5f                   	pop    %edi
  800f2e:	5d                   	pop    %ebp
  800f2f:	c3                   	ret    

00800f30 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
  800f33:	57                   	push   %edi
  800f34:	56                   	push   %esi
  800f35:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f36:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3e:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f43:	89 cb                	mov    %ecx,%ebx
  800f45:	89 cf                	mov    %ecx,%edi
  800f47:	89 ce                	mov    %ecx,%esi
  800f49:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f4b:	5b                   	pop    %ebx
  800f4c:	5e                   	pop    %esi
  800f4d:	5f                   	pop    %edi
  800f4e:	5d                   	pop    %ebp
  800f4f:	c3                   	ret    

00800f50 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
  800f53:	57                   	push   %edi
  800f54:	56                   	push   %esi
  800f55:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f56:	ba 00 00 00 00       	mov    $0x0,%edx
  800f5b:	b8 10 00 00 00       	mov    $0x10,%eax
  800f60:	89 d1                	mov    %edx,%ecx
  800f62:	89 d3                	mov    %edx,%ebx
  800f64:	89 d7                	mov    %edx,%edi
  800f66:	89 d6                	mov    %edx,%esi
  800f68:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f6a:	5b                   	pop    %ebx
  800f6b:	5e                   	pop    %esi
  800f6c:	5f                   	pop    %edi
  800f6d:	5d                   	pop    %ebp
  800f6e:	c3                   	ret    

00800f6f <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	57                   	push   %edi
  800f73:	56                   	push   %esi
  800f74:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f75:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f80:	b8 11 00 00 00       	mov    $0x11,%eax
  800f85:	89 df                	mov    %ebx,%edi
  800f87:	89 de                	mov    %ebx,%esi
  800f89:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f8b:	5b                   	pop    %ebx
  800f8c:	5e                   	pop    %esi
  800f8d:	5f                   	pop    %edi
  800f8e:	5d                   	pop    %ebp
  800f8f:	c3                   	ret    

00800f90 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f90:	55                   	push   %ebp
  800f91:	89 e5                	mov    %esp,%ebp
  800f93:	57                   	push   %edi
  800f94:	56                   	push   %esi
  800f95:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f96:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa1:	b8 12 00 00 00       	mov    $0x12,%eax
  800fa6:	89 df                	mov    %ebx,%edi
  800fa8:	89 de                	mov    %ebx,%esi
  800faa:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fac:	5b                   	pop    %ebx
  800fad:	5e                   	pop    %esi
  800fae:	5f                   	pop    %edi
  800faf:	5d                   	pop    %ebp
  800fb0:	c3                   	ret    

00800fb1 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fb1:	55                   	push   %ebp
  800fb2:	89 e5                	mov    %esp,%ebp
  800fb4:	57                   	push   %edi
  800fb5:	56                   	push   %esi
  800fb6:	53                   	push   %ebx
  800fb7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fba:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc5:	b8 13 00 00 00       	mov    $0x13,%eax
  800fca:	89 df                	mov    %ebx,%edi
  800fcc:	89 de                	mov    %ebx,%esi
  800fce:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fd0:	85 c0                	test   %eax,%eax
  800fd2:	7f 08                	jg     800fdc <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fd7:	5b                   	pop    %ebx
  800fd8:	5e                   	pop    %esi
  800fd9:	5f                   	pop    %edi
  800fda:	5d                   	pop    %ebp
  800fdb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fdc:	83 ec 0c             	sub    $0xc,%esp
  800fdf:	50                   	push   %eax
  800fe0:	6a 13                	push   $0x13
  800fe2:	68 28 29 80 00       	push   $0x802928
  800fe7:	6a 43                	push   $0x43
  800fe9:	68 45 29 80 00       	push   $0x802945
  800fee:	e8 76 11 00 00       	call   802169 <_panic>

00800ff3 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  800ff3:	55                   	push   %ebp
  800ff4:	89 e5                	mov    %esp,%ebp
  800ff6:	57                   	push   %edi
  800ff7:	56                   	push   %esi
  800ff8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ff9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ffe:	8b 55 08             	mov    0x8(%ebp),%edx
  801001:	b8 14 00 00 00       	mov    $0x14,%eax
  801006:	89 cb                	mov    %ecx,%ebx
  801008:	89 cf                	mov    %ecx,%edi
  80100a:	89 ce                	mov    %ecx,%esi
  80100c:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80100e:	5b                   	pop    %ebx
  80100f:	5e                   	pop    %esi
  801010:	5f                   	pop    %edi
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    

00801013 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801013:	55                   	push   %ebp
  801014:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	05 00 00 00 30       	add    $0x30000000,%eax
  80101e:	c1 e8 0c             	shr    $0xc,%eax
}
  801021:	5d                   	pop    %ebp
  801022:	c3                   	ret    

00801023 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801023:	55                   	push   %ebp
  801024:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80102e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801033:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801038:	5d                   	pop    %ebp
  801039:	c3                   	ret    

0080103a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801042:	89 c2                	mov    %eax,%edx
  801044:	c1 ea 16             	shr    $0x16,%edx
  801047:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80104e:	f6 c2 01             	test   $0x1,%dl
  801051:	74 2d                	je     801080 <fd_alloc+0x46>
  801053:	89 c2                	mov    %eax,%edx
  801055:	c1 ea 0c             	shr    $0xc,%edx
  801058:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80105f:	f6 c2 01             	test   $0x1,%dl
  801062:	74 1c                	je     801080 <fd_alloc+0x46>
  801064:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801069:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80106e:	75 d2                	jne    801042 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801079:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80107e:	eb 0a                	jmp    80108a <fd_alloc+0x50>
			*fd_store = fd;
  801080:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801083:	89 01                	mov    %eax,(%ecx)
			return 0;
  801085:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80108a:	5d                   	pop    %ebp
  80108b:	c3                   	ret    

0080108c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80108c:	55                   	push   %ebp
  80108d:	89 e5                	mov    %esp,%ebp
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801092:	83 f8 1f             	cmp    $0x1f,%eax
  801095:	77 30                	ja     8010c7 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801097:	c1 e0 0c             	shl    $0xc,%eax
  80109a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80109f:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010a5:	f6 c2 01             	test   $0x1,%dl
  8010a8:	74 24                	je     8010ce <fd_lookup+0x42>
  8010aa:	89 c2                	mov    %eax,%edx
  8010ac:	c1 ea 0c             	shr    $0xc,%edx
  8010af:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010b6:	f6 c2 01             	test   $0x1,%dl
  8010b9:	74 1a                	je     8010d5 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010be:	89 02                	mov    %eax,(%edx)
	return 0;
  8010c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010c5:	5d                   	pop    %ebp
  8010c6:	c3                   	ret    
		return -E_INVAL;
  8010c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010cc:	eb f7                	jmp    8010c5 <fd_lookup+0x39>
		return -E_INVAL;
  8010ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010d3:	eb f0                	jmp    8010c5 <fd_lookup+0x39>
  8010d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010da:	eb e9                	jmp    8010c5 <fd_lookup+0x39>

008010dc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
  8010df:	83 ec 08             	sub    $0x8,%esp
  8010e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ea:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010ef:	39 08                	cmp    %ecx,(%eax)
  8010f1:	74 38                	je     80112b <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8010f3:	83 c2 01             	add    $0x1,%edx
  8010f6:	8b 04 95 d0 29 80 00 	mov    0x8029d0(,%edx,4),%eax
  8010fd:	85 c0                	test   %eax,%eax
  8010ff:	75 ee                	jne    8010ef <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801101:	a1 08 40 80 00       	mov    0x804008,%eax
  801106:	8b 40 48             	mov    0x48(%eax),%eax
  801109:	83 ec 04             	sub    $0x4,%esp
  80110c:	51                   	push   %ecx
  80110d:	50                   	push   %eax
  80110e:	68 54 29 80 00       	push   $0x802954
  801113:	e8 b5 f0 ff ff       	call   8001cd <cprintf>
	*dev = 0;
  801118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801121:	83 c4 10             	add    $0x10,%esp
  801124:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801129:	c9                   	leave  
  80112a:	c3                   	ret    
			*dev = devtab[i];
  80112b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80112e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801130:	b8 00 00 00 00       	mov    $0x0,%eax
  801135:	eb f2                	jmp    801129 <dev_lookup+0x4d>

00801137 <fd_close>:
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	57                   	push   %edi
  80113b:	56                   	push   %esi
  80113c:	53                   	push   %ebx
  80113d:	83 ec 24             	sub    $0x24,%esp
  801140:	8b 75 08             	mov    0x8(%ebp),%esi
  801143:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801146:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801149:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80114a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801150:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801153:	50                   	push   %eax
  801154:	e8 33 ff ff ff       	call   80108c <fd_lookup>
  801159:	89 c3                	mov    %eax,%ebx
  80115b:	83 c4 10             	add    $0x10,%esp
  80115e:	85 c0                	test   %eax,%eax
  801160:	78 05                	js     801167 <fd_close+0x30>
	    || fd != fd2)
  801162:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801165:	74 16                	je     80117d <fd_close+0x46>
		return (must_exist ? r : 0);
  801167:	89 f8                	mov    %edi,%eax
  801169:	84 c0                	test   %al,%al
  80116b:	b8 00 00 00 00       	mov    $0x0,%eax
  801170:	0f 44 d8             	cmove  %eax,%ebx
}
  801173:	89 d8                	mov    %ebx,%eax
  801175:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801178:	5b                   	pop    %ebx
  801179:	5e                   	pop    %esi
  80117a:	5f                   	pop    %edi
  80117b:	5d                   	pop    %ebp
  80117c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80117d:	83 ec 08             	sub    $0x8,%esp
  801180:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801183:	50                   	push   %eax
  801184:	ff 36                	pushl  (%esi)
  801186:	e8 51 ff ff ff       	call   8010dc <dev_lookup>
  80118b:	89 c3                	mov    %eax,%ebx
  80118d:	83 c4 10             	add    $0x10,%esp
  801190:	85 c0                	test   %eax,%eax
  801192:	78 1a                	js     8011ae <fd_close+0x77>
		if (dev->dev_close)
  801194:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801197:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80119a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80119f:	85 c0                	test   %eax,%eax
  8011a1:	74 0b                	je     8011ae <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011a3:	83 ec 0c             	sub    $0xc,%esp
  8011a6:	56                   	push   %esi
  8011a7:	ff d0                	call   *%eax
  8011a9:	89 c3                	mov    %eax,%ebx
  8011ab:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011ae:	83 ec 08             	sub    $0x8,%esp
  8011b1:	56                   	push   %esi
  8011b2:	6a 00                	push   $0x0
  8011b4:	e8 ea fb ff ff       	call   800da3 <sys_page_unmap>
	return r;
  8011b9:	83 c4 10             	add    $0x10,%esp
  8011bc:	eb b5                	jmp    801173 <fd_close+0x3c>

008011be <close>:

int
close(int fdnum)
{
  8011be:	55                   	push   %ebp
  8011bf:	89 e5                	mov    %esp,%ebp
  8011c1:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011c7:	50                   	push   %eax
  8011c8:	ff 75 08             	pushl  0x8(%ebp)
  8011cb:	e8 bc fe ff ff       	call   80108c <fd_lookup>
  8011d0:	83 c4 10             	add    $0x10,%esp
  8011d3:	85 c0                	test   %eax,%eax
  8011d5:	79 02                	jns    8011d9 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011d7:	c9                   	leave  
  8011d8:	c3                   	ret    
		return fd_close(fd, 1);
  8011d9:	83 ec 08             	sub    $0x8,%esp
  8011dc:	6a 01                	push   $0x1
  8011de:	ff 75 f4             	pushl  -0xc(%ebp)
  8011e1:	e8 51 ff ff ff       	call   801137 <fd_close>
  8011e6:	83 c4 10             	add    $0x10,%esp
  8011e9:	eb ec                	jmp    8011d7 <close+0x19>

008011eb <close_all>:

void
close_all(void)
{
  8011eb:	55                   	push   %ebp
  8011ec:	89 e5                	mov    %esp,%ebp
  8011ee:	53                   	push   %ebx
  8011ef:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011f2:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011f7:	83 ec 0c             	sub    $0xc,%esp
  8011fa:	53                   	push   %ebx
  8011fb:	e8 be ff ff ff       	call   8011be <close>
	for (i = 0; i < MAXFD; i++)
  801200:	83 c3 01             	add    $0x1,%ebx
  801203:	83 c4 10             	add    $0x10,%esp
  801206:	83 fb 20             	cmp    $0x20,%ebx
  801209:	75 ec                	jne    8011f7 <close_all+0xc>
}
  80120b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80120e:	c9                   	leave  
  80120f:	c3                   	ret    

00801210 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
  801213:	57                   	push   %edi
  801214:	56                   	push   %esi
  801215:	53                   	push   %ebx
  801216:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801219:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80121c:	50                   	push   %eax
  80121d:	ff 75 08             	pushl  0x8(%ebp)
  801220:	e8 67 fe ff ff       	call   80108c <fd_lookup>
  801225:	89 c3                	mov    %eax,%ebx
  801227:	83 c4 10             	add    $0x10,%esp
  80122a:	85 c0                	test   %eax,%eax
  80122c:	0f 88 81 00 00 00    	js     8012b3 <dup+0xa3>
		return r;
	close(newfdnum);
  801232:	83 ec 0c             	sub    $0xc,%esp
  801235:	ff 75 0c             	pushl  0xc(%ebp)
  801238:	e8 81 ff ff ff       	call   8011be <close>

	newfd = INDEX2FD(newfdnum);
  80123d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801240:	c1 e6 0c             	shl    $0xc,%esi
  801243:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801249:	83 c4 04             	add    $0x4,%esp
  80124c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80124f:	e8 cf fd ff ff       	call   801023 <fd2data>
  801254:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801256:	89 34 24             	mov    %esi,(%esp)
  801259:	e8 c5 fd ff ff       	call   801023 <fd2data>
  80125e:	83 c4 10             	add    $0x10,%esp
  801261:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801263:	89 d8                	mov    %ebx,%eax
  801265:	c1 e8 16             	shr    $0x16,%eax
  801268:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80126f:	a8 01                	test   $0x1,%al
  801271:	74 11                	je     801284 <dup+0x74>
  801273:	89 d8                	mov    %ebx,%eax
  801275:	c1 e8 0c             	shr    $0xc,%eax
  801278:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80127f:	f6 c2 01             	test   $0x1,%dl
  801282:	75 39                	jne    8012bd <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801284:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801287:	89 d0                	mov    %edx,%eax
  801289:	c1 e8 0c             	shr    $0xc,%eax
  80128c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801293:	83 ec 0c             	sub    $0xc,%esp
  801296:	25 07 0e 00 00       	and    $0xe07,%eax
  80129b:	50                   	push   %eax
  80129c:	56                   	push   %esi
  80129d:	6a 00                	push   $0x0
  80129f:	52                   	push   %edx
  8012a0:	6a 00                	push   $0x0
  8012a2:	e8 ba fa ff ff       	call   800d61 <sys_page_map>
  8012a7:	89 c3                	mov    %eax,%ebx
  8012a9:	83 c4 20             	add    $0x20,%esp
  8012ac:	85 c0                	test   %eax,%eax
  8012ae:	78 31                	js     8012e1 <dup+0xd1>
		goto err;

	return newfdnum;
  8012b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012b3:	89 d8                	mov    %ebx,%eax
  8012b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012b8:	5b                   	pop    %ebx
  8012b9:	5e                   	pop    %esi
  8012ba:	5f                   	pop    %edi
  8012bb:	5d                   	pop    %ebp
  8012bc:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012bd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012c4:	83 ec 0c             	sub    $0xc,%esp
  8012c7:	25 07 0e 00 00       	and    $0xe07,%eax
  8012cc:	50                   	push   %eax
  8012cd:	57                   	push   %edi
  8012ce:	6a 00                	push   $0x0
  8012d0:	53                   	push   %ebx
  8012d1:	6a 00                	push   $0x0
  8012d3:	e8 89 fa ff ff       	call   800d61 <sys_page_map>
  8012d8:	89 c3                	mov    %eax,%ebx
  8012da:	83 c4 20             	add    $0x20,%esp
  8012dd:	85 c0                	test   %eax,%eax
  8012df:	79 a3                	jns    801284 <dup+0x74>
	sys_page_unmap(0, newfd);
  8012e1:	83 ec 08             	sub    $0x8,%esp
  8012e4:	56                   	push   %esi
  8012e5:	6a 00                	push   $0x0
  8012e7:	e8 b7 fa ff ff       	call   800da3 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012ec:	83 c4 08             	add    $0x8,%esp
  8012ef:	57                   	push   %edi
  8012f0:	6a 00                	push   $0x0
  8012f2:	e8 ac fa ff ff       	call   800da3 <sys_page_unmap>
	return r;
  8012f7:	83 c4 10             	add    $0x10,%esp
  8012fa:	eb b7                	jmp    8012b3 <dup+0xa3>

008012fc <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012fc:	55                   	push   %ebp
  8012fd:	89 e5                	mov    %esp,%ebp
  8012ff:	53                   	push   %ebx
  801300:	83 ec 1c             	sub    $0x1c,%esp
  801303:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801306:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801309:	50                   	push   %eax
  80130a:	53                   	push   %ebx
  80130b:	e8 7c fd ff ff       	call   80108c <fd_lookup>
  801310:	83 c4 10             	add    $0x10,%esp
  801313:	85 c0                	test   %eax,%eax
  801315:	78 3f                	js     801356 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801317:	83 ec 08             	sub    $0x8,%esp
  80131a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80131d:	50                   	push   %eax
  80131e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801321:	ff 30                	pushl  (%eax)
  801323:	e8 b4 fd ff ff       	call   8010dc <dev_lookup>
  801328:	83 c4 10             	add    $0x10,%esp
  80132b:	85 c0                	test   %eax,%eax
  80132d:	78 27                	js     801356 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80132f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801332:	8b 42 08             	mov    0x8(%edx),%eax
  801335:	83 e0 03             	and    $0x3,%eax
  801338:	83 f8 01             	cmp    $0x1,%eax
  80133b:	74 1e                	je     80135b <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80133d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801340:	8b 40 08             	mov    0x8(%eax),%eax
  801343:	85 c0                	test   %eax,%eax
  801345:	74 35                	je     80137c <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801347:	83 ec 04             	sub    $0x4,%esp
  80134a:	ff 75 10             	pushl  0x10(%ebp)
  80134d:	ff 75 0c             	pushl  0xc(%ebp)
  801350:	52                   	push   %edx
  801351:	ff d0                	call   *%eax
  801353:	83 c4 10             	add    $0x10,%esp
}
  801356:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801359:	c9                   	leave  
  80135a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80135b:	a1 08 40 80 00       	mov    0x804008,%eax
  801360:	8b 40 48             	mov    0x48(%eax),%eax
  801363:	83 ec 04             	sub    $0x4,%esp
  801366:	53                   	push   %ebx
  801367:	50                   	push   %eax
  801368:	68 95 29 80 00       	push   $0x802995
  80136d:	e8 5b ee ff ff       	call   8001cd <cprintf>
		return -E_INVAL;
  801372:	83 c4 10             	add    $0x10,%esp
  801375:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80137a:	eb da                	jmp    801356 <read+0x5a>
		return -E_NOT_SUPP;
  80137c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801381:	eb d3                	jmp    801356 <read+0x5a>

00801383 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
  801386:	57                   	push   %edi
  801387:	56                   	push   %esi
  801388:	53                   	push   %ebx
  801389:	83 ec 0c             	sub    $0xc,%esp
  80138c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80138f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801392:	bb 00 00 00 00       	mov    $0x0,%ebx
  801397:	39 f3                	cmp    %esi,%ebx
  801399:	73 23                	jae    8013be <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80139b:	83 ec 04             	sub    $0x4,%esp
  80139e:	89 f0                	mov    %esi,%eax
  8013a0:	29 d8                	sub    %ebx,%eax
  8013a2:	50                   	push   %eax
  8013a3:	89 d8                	mov    %ebx,%eax
  8013a5:	03 45 0c             	add    0xc(%ebp),%eax
  8013a8:	50                   	push   %eax
  8013a9:	57                   	push   %edi
  8013aa:	e8 4d ff ff ff       	call   8012fc <read>
		if (m < 0)
  8013af:	83 c4 10             	add    $0x10,%esp
  8013b2:	85 c0                	test   %eax,%eax
  8013b4:	78 06                	js     8013bc <readn+0x39>
			return m;
		if (m == 0)
  8013b6:	74 06                	je     8013be <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013b8:	01 c3                	add    %eax,%ebx
  8013ba:	eb db                	jmp    801397 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013bc:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013be:	89 d8                	mov    %ebx,%eax
  8013c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013c3:	5b                   	pop    %ebx
  8013c4:	5e                   	pop    %esi
  8013c5:	5f                   	pop    %edi
  8013c6:	5d                   	pop    %ebp
  8013c7:	c3                   	ret    

008013c8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
  8013cb:	53                   	push   %ebx
  8013cc:	83 ec 1c             	sub    $0x1c,%esp
  8013cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013d2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013d5:	50                   	push   %eax
  8013d6:	53                   	push   %ebx
  8013d7:	e8 b0 fc ff ff       	call   80108c <fd_lookup>
  8013dc:	83 c4 10             	add    $0x10,%esp
  8013df:	85 c0                	test   %eax,%eax
  8013e1:	78 3a                	js     80141d <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013e3:	83 ec 08             	sub    $0x8,%esp
  8013e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013e9:	50                   	push   %eax
  8013ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ed:	ff 30                	pushl  (%eax)
  8013ef:	e8 e8 fc ff ff       	call   8010dc <dev_lookup>
  8013f4:	83 c4 10             	add    $0x10,%esp
  8013f7:	85 c0                	test   %eax,%eax
  8013f9:	78 22                	js     80141d <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013fe:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801402:	74 1e                	je     801422 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801404:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801407:	8b 52 0c             	mov    0xc(%edx),%edx
  80140a:	85 d2                	test   %edx,%edx
  80140c:	74 35                	je     801443 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80140e:	83 ec 04             	sub    $0x4,%esp
  801411:	ff 75 10             	pushl  0x10(%ebp)
  801414:	ff 75 0c             	pushl  0xc(%ebp)
  801417:	50                   	push   %eax
  801418:	ff d2                	call   *%edx
  80141a:	83 c4 10             	add    $0x10,%esp
}
  80141d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801420:	c9                   	leave  
  801421:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801422:	a1 08 40 80 00       	mov    0x804008,%eax
  801427:	8b 40 48             	mov    0x48(%eax),%eax
  80142a:	83 ec 04             	sub    $0x4,%esp
  80142d:	53                   	push   %ebx
  80142e:	50                   	push   %eax
  80142f:	68 b1 29 80 00       	push   $0x8029b1
  801434:	e8 94 ed ff ff       	call   8001cd <cprintf>
		return -E_INVAL;
  801439:	83 c4 10             	add    $0x10,%esp
  80143c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801441:	eb da                	jmp    80141d <write+0x55>
		return -E_NOT_SUPP;
  801443:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801448:	eb d3                	jmp    80141d <write+0x55>

0080144a <seek>:

int
seek(int fdnum, off_t offset)
{
  80144a:	55                   	push   %ebp
  80144b:	89 e5                	mov    %esp,%ebp
  80144d:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801450:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801453:	50                   	push   %eax
  801454:	ff 75 08             	pushl  0x8(%ebp)
  801457:	e8 30 fc ff ff       	call   80108c <fd_lookup>
  80145c:	83 c4 10             	add    $0x10,%esp
  80145f:	85 c0                	test   %eax,%eax
  801461:	78 0e                	js     801471 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801463:	8b 55 0c             	mov    0xc(%ebp),%edx
  801466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801469:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80146c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801471:	c9                   	leave  
  801472:	c3                   	ret    

00801473 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
  801476:	53                   	push   %ebx
  801477:	83 ec 1c             	sub    $0x1c,%esp
  80147a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80147d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801480:	50                   	push   %eax
  801481:	53                   	push   %ebx
  801482:	e8 05 fc ff ff       	call   80108c <fd_lookup>
  801487:	83 c4 10             	add    $0x10,%esp
  80148a:	85 c0                	test   %eax,%eax
  80148c:	78 37                	js     8014c5 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80148e:	83 ec 08             	sub    $0x8,%esp
  801491:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801494:	50                   	push   %eax
  801495:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801498:	ff 30                	pushl  (%eax)
  80149a:	e8 3d fc ff ff       	call   8010dc <dev_lookup>
  80149f:	83 c4 10             	add    $0x10,%esp
  8014a2:	85 c0                	test   %eax,%eax
  8014a4:	78 1f                	js     8014c5 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014ad:	74 1b                	je     8014ca <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014b2:	8b 52 18             	mov    0x18(%edx),%edx
  8014b5:	85 d2                	test   %edx,%edx
  8014b7:	74 32                	je     8014eb <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014b9:	83 ec 08             	sub    $0x8,%esp
  8014bc:	ff 75 0c             	pushl  0xc(%ebp)
  8014bf:	50                   	push   %eax
  8014c0:	ff d2                	call   *%edx
  8014c2:	83 c4 10             	add    $0x10,%esp
}
  8014c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014c8:	c9                   	leave  
  8014c9:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014ca:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014cf:	8b 40 48             	mov    0x48(%eax),%eax
  8014d2:	83 ec 04             	sub    $0x4,%esp
  8014d5:	53                   	push   %ebx
  8014d6:	50                   	push   %eax
  8014d7:	68 74 29 80 00       	push   $0x802974
  8014dc:	e8 ec ec ff ff       	call   8001cd <cprintf>
		return -E_INVAL;
  8014e1:	83 c4 10             	add    $0x10,%esp
  8014e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014e9:	eb da                	jmp    8014c5 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014eb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014f0:	eb d3                	jmp    8014c5 <ftruncate+0x52>

008014f2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014f2:	55                   	push   %ebp
  8014f3:	89 e5                	mov    %esp,%ebp
  8014f5:	53                   	push   %ebx
  8014f6:	83 ec 1c             	sub    $0x1c,%esp
  8014f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014fc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014ff:	50                   	push   %eax
  801500:	ff 75 08             	pushl  0x8(%ebp)
  801503:	e8 84 fb ff ff       	call   80108c <fd_lookup>
  801508:	83 c4 10             	add    $0x10,%esp
  80150b:	85 c0                	test   %eax,%eax
  80150d:	78 4b                	js     80155a <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80150f:	83 ec 08             	sub    $0x8,%esp
  801512:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801515:	50                   	push   %eax
  801516:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801519:	ff 30                	pushl  (%eax)
  80151b:	e8 bc fb ff ff       	call   8010dc <dev_lookup>
  801520:	83 c4 10             	add    $0x10,%esp
  801523:	85 c0                	test   %eax,%eax
  801525:	78 33                	js     80155a <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80152a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80152e:	74 2f                	je     80155f <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801530:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801533:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80153a:	00 00 00 
	stat->st_isdir = 0;
  80153d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801544:	00 00 00 
	stat->st_dev = dev;
  801547:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80154d:	83 ec 08             	sub    $0x8,%esp
  801550:	53                   	push   %ebx
  801551:	ff 75 f0             	pushl  -0x10(%ebp)
  801554:	ff 50 14             	call   *0x14(%eax)
  801557:	83 c4 10             	add    $0x10,%esp
}
  80155a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80155d:	c9                   	leave  
  80155e:	c3                   	ret    
		return -E_NOT_SUPP;
  80155f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801564:	eb f4                	jmp    80155a <fstat+0x68>

00801566 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
  801569:	56                   	push   %esi
  80156a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80156b:	83 ec 08             	sub    $0x8,%esp
  80156e:	6a 00                	push   $0x0
  801570:	ff 75 08             	pushl  0x8(%ebp)
  801573:	e8 22 02 00 00       	call   80179a <open>
  801578:	89 c3                	mov    %eax,%ebx
  80157a:	83 c4 10             	add    $0x10,%esp
  80157d:	85 c0                	test   %eax,%eax
  80157f:	78 1b                	js     80159c <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801581:	83 ec 08             	sub    $0x8,%esp
  801584:	ff 75 0c             	pushl  0xc(%ebp)
  801587:	50                   	push   %eax
  801588:	e8 65 ff ff ff       	call   8014f2 <fstat>
  80158d:	89 c6                	mov    %eax,%esi
	close(fd);
  80158f:	89 1c 24             	mov    %ebx,(%esp)
  801592:	e8 27 fc ff ff       	call   8011be <close>
	return r;
  801597:	83 c4 10             	add    $0x10,%esp
  80159a:	89 f3                	mov    %esi,%ebx
}
  80159c:	89 d8                	mov    %ebx,%eax
  80159e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015a1:	5b                   	pop    %ebx
  8015a2:	5e                   	pop    %esi
  8015a3:	5d                   	pop    %ebp
  8015a4:	c3                   	ret    

008015a5 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
  8015a8:	56                   	push   %esi
  8015a9:	53                   	push   %ebx
  8015aa:	89 c6                	mov    %eax,%esi
  8015ac:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015ae:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015b5:	74 27                	je     8015de <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015b7:	6a 07                	push   $0x7
  8015b9:	68 00 50 80 00       	push   $0x805000
  8015be:	56                   	push   %esi
  8015bf:	ff 35 00 40 80 00    	pushl  0x804000
  8015c5:	e8 69 0c 00 00       	call   802233 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015ca:	83 c4 0c             	add    $0xc,%esp
  8015cd:	6a 00                	push   $0x0
  8015cf:	53                   	push   %ebx
  8015d0:	6a 00                	push   $0x0
  8015d2:	e8 f3 0b 00 00       	call   8021ca <ipc_recv>
}
  8015d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015da:	5b                   	pop    %ebx
  8015db:	5e                   	pop    %esi
  8015dc:	5d                   	pop    %ebp
  8015dd:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015de:	83 ec 0c             	sub    $0xc,%esp
  8015e1:	6a 01                	push   $0x1
  8015e3:	e8 a3 0c 00 00       	call   80228b <ipc_find_env>
  8015e8:	a3 00 40 80 00       	mov    %eax,0x804000
  8015ed:	83 c4 10             	add    $0x10,%esp
  8015f0:	eb c5                	jmp    8015b7 <fsipc+0x12>

008015f2 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8015fe:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801603:	8b 45 0c             	mov    0xc(%ebp),%eax
  801606:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80160b:	ba 00 00 00 00       	mov    $0x0,%edx
  801610:	b8 02 00 00 00       	mov    $0x2,%eax
  801615:	e8 8b ff ff ff       	call   8015a5 <fsipc>
}
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <devfile_flush>:
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801622:	8b 45 08             	mov    0x8(%ebp),%eax
  801625:	8b 40 0c             	mov    0xc(%eax),%eax
  801628:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80162d:	ba 00 00 00 00       	mov    $0x0,%edx
  801632:	b8 06 00 00 00       	mov    $0x6,%eax
  801637:	e8 69 ff ff ff       	call   8015a5 <fsipc>
}
  80163c:	c9                   	leave  
  80163d:	c3                   	ret    

0080163e <devfile_stat>:
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
  801641:	53                   	push   %ebx
  801642:	83 ec 04             	sub    $0x4,%esp
  801645:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801648:	8b 45 08             	mov    0x8(%ebp),%eax
  80164b:	8b 40 0c             	mov    0xc(%eax),%eax
  80164e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801653:	ba 00 00 00 00       	mov    $0x0,%edx
  801658:	b8 05 00 00 00       	mov    $0x5,%eax
  80165d:	e8 43 ff ff ff       	call   8015a5 <fsipc>
  801662:	85 c0                	test   %eax,%eax
  801664:	78 2c                	js     801692 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801666:	83 ec 08             	sub    $0x8,%esp
  801669:	68 00 50 80 00       	push   $0x805000
  80166e:	53                   	push   %ebx
  80166f:	e8 b8 f2 ff ff       	call   80092c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801674:	a1 80 50 80 00       	mov    0x805080,%eax
  801679:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80167f:	a1 84 50 80 00       	mov    0x805084,%eax
  801684:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80168a:	83 c4 10             	add    $0x10,%esp
  80168d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801692:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801695:	c9                   	leave  
  801696:	c3                   	ret    

00801697 <devfile_write>:
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
  80169a:	53                   	push   %ebx
  80169b:	83 ec 08             	sub    $0x8,%esp
  80169e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8016a7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016ac:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016b2:	53                   	push   %ebx
  8016b3:	ff 75 0c             	pushl  0xc(%ebp)
  8016b6:	68 08 50 80 00       	push   $0x805008
  8016bb:	e8 5c f4 ff ff       	call   800b1c <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c5:	b8 04 00 00 00       	mov    $0x4,%eax
  8016ca:	e8 d6 fe ff ff       	call   8015a5 <fsipc>
  8016cf:	83 c4 10             	add    $0x10,%esp
  8016d2:	85 c0                	test   %eax,%eax
  8016d4:	78 0b                	js     8016e1 <devfile_write+0x4a>
	assert(r <= n);
  8016d6:	39 d8                	cmp    %ebx,%eax
  8016d8:	77 0c                	ja     8016e6 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016da:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016df:	7f 1e                	jg     8016ff <devfile_write+0x68>
}
  8016e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e4:	c9                   	leave  
  8016e5:	c3                   	ret    
	assert(r <= n);
  8016e6:	68 e4 29 80 00       	push   $0x8029e4
  8016eb:	68 eb 29 80 00       	push   $0x8029eb
  8016f0:	68 98 00 00 00       	push   $0x98
  8016f5:	68 00 2a 80 00       	push   $0x802a00
  8016fa:	e8 6a 0a 00 00       	call   802169 <_panic>
	assert(r <= PGSIZE);
  8016ff:	68 0b 2a 80 00       	push   $0x802a0b
  801704:	68 eb 29 80 00       	push   $0x8029eb
  801709:	68 99 00 00 00       	push   $0x99
  80170e:	68 00 2a 80 00       	push   $0x802a00
  801713:	e8 51 0a 00 00       	call   802169 <_panic>

00801718 <devfile_read>:
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
  80171b:	56                   	push   %esi
  80171c:	53                   	push   %ebx
  80171d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801720:	8b 45 08             	mov    0x8(%ebp),%eax
  801723:	8b 40 0c             	mov    0xc(%eax),%eax
  801726:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80172b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801731:	ba 00 00 00 00       	mov    $0x0,%edx
  801736:	b8 03 00 00 00       	mov    $0x3,%eax
  80173b:	e8 65 fe ff ff       	call   8015a5 <fsipc>
  801740:	89 c3                	mov    %eax,%ebx
  801742:	85 c0                	test   %eax,%eax
  801744:	78 1f                	js     801765 <devfile_read+0x4d>
	assert(r <= n);
  801746:	39 f0                	cmp    %esi,%eax
  801748:	77 24                	ja     80176e <devfile_read+0x56>
	assert(r <= PGSIZE);
  80174a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80174f:	7f 33                	jg     801784 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801751:	83 ec 04             	sub    $0x4,%esp
  801754:	50                   	push   %eax
  801755:	68 00 50 80 00       	push   $0x805000
  80175a:	ff 75 0c             	pushl  0xc(%ebp)
  80175d:	e8 58 f3 ff ff       	call   800aba <memmove>
	return r;
  801762:	83 c4 10             	add    $0x10,%esp
}
  801765:	89 d8                	mov    %ebx,%eax
  801767:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80176a:	5b                   	pop    %ebx
  80176b:	5e                   	pop    %esi
  80176c:	5d                   	pop    %ebp
  80176d:	c3                   	ret    
	assert(r <= n);
  80176e:	68 e4 29 80 00       	push   $0x8029e4
  801773:	68 eb 29 80 00       	push   $0x8029eb
  801778:	6a 7c                	push   $0x7c
  80177a:	68 00 2a 80 00       	push   $0x802a00
  80177f:	e8 e5 09 00 00       	call   802169 <_panic>
	assert(r <= PGSIZE);
  801784:	68 0b 2a 80 00       	push   $0x802a0b
  801789:	68 eb 29 80 00       	push   $0x8029eb
  80178e:	6a 7d                	push   $0x7d
  801790:	68 00 2a 80 00       	push   $0x802a00
  801795:	e8 cf 09 00 00       	call   802169 <_panic>

0080179a <open>:
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	56                   	push   %esi
  80179e:	53                   	push   %ebx
  80179f:	83 ec 1c             	sub    $0x1c,%esp
  8017a2:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017a5:	56                   	push   %esi
  8017a6:	e8 48 f1 ff ff       	call   8008f3 <strlen>
  8017ab:	83 c4 10             	add    $0x10,%esp
  8017ae:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017b3:	7f 6c                	jg     801821 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017b5:	83 ec 0c             	sub    $0xc,%esp
  8017b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017bb:	50                   	push   %eax
  8017bc:	e8 79 f8 ff ff       	call   80103a <fd_alloc>
  8017c1:	89 c3                	mov    %eax,%ebx
  8017c3:	83 c4 10             	add    $0x10,%esp
  8017c6:	85 c0                	test   %eax,%eax
  8017c8:	78 3c                	js     801806 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017ca:	83 ec 08             	sub    $0x8,%esp
  8017cd:	56                   	push   %esi
  8017ce:	68 00 50 80 00       	push   $0x805000
  8017d3:	e8 54 f1 ff ff       	call   80092c <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017db:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8017e8:	e8 b8 fd ff ff       	call   8015a5 <fsipc>
  8017ed:	89 c3                	mov    %eax,%ebx
  8017ef:	83 c4 10             	add    $0x10,%esp
  8017f2:	85 c0                	test   %eax,%eax
  8017f4:	78 19                	js     80180f <open+0x75>
	return fd2num(fd);
  8017f6:	83 ec 0c             	sub    $0xc,%esp
  8017f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8017fc:	e8 12 f8 ff ff       	call   801013 <fd2num>
  801801:	89 c3                	mov    %eax,%ebx
  801803:	83 c4 10             	add    $0x10,%esp
}
  801806:	89 d8                	mov    %ebx,%eax
  801808:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80180b:	5b                   	pop    %ebx
  80180c:	5e                   	pop    %esi
  80180d:	5d                   	pop    %ebp
  80180e:	c3                   	ret    
		fd_close(fd, 0);
  80180f:	83 ec 08             	sub    $0x8,%esp
  801812:	6a 00                	push   $0x0
  801814:	ff 75 f4             	pushl  -0xc(%ebp)
  801817:	e8 1b f9 ff ff       	call   801137 <fd_close>
		return r;
  80181c:	83 c4 10             	add    $0x10,%esp
  80181f:	eb e5                	jmp    801806 <open+0x6c>
		return -E_BAD_PATH;
  801821:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801826:	eb de                	jmp    801806 <open+0x6c>

00801828 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
  80182b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80182e:	ba 00 00 00 00       	mov    $0x0,%edx
  801833:	b8 08 00 00 00       	mov    $0x8,%eax
  801838:	e8 68 fd ff ff       	call   8015a5 <fsipc>
}
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    

0080183f <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801845:	68 17 2a 80 00       	push   $0x802a17
  80184a:	ff 75 0c             	pushl  0xc(%ebp)
  80184d:	e8 da f0 ff ff       	call   80092c <strcpy>
	return 0;
}
  801852:	b8 00 00 00 00       	mov    $0x0,%eax
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <devsock_close>:
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
  80185c:	53                   	push   %ebx
  80185d:	83 ec 10             	sub    $0x10,%esp
  801860:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801863:	53                   	push   %ebx
  801864:	e8 61 0a 00 00       	call   8022ca <pageref>
  801869:	83 c4 10             	add    $0x10,%esp
		return 0;
  80186c:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801871:	83 f8 01             	cmp    $0x1,%eax
  801874:	74 07                	je     80187d <devsock_close+0x24>
}
  801876:	89 d0                	mov    %edx,%eax
  801878:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80187d:	83 ec 0c             	sub    $0xc,%esp
  801880:	ff 73 0c             	pushl  0xc(%ebx)
  801883:	e8 b9 02 00 00       	call   801b41 <nsipc_close>
  801888:	89 c2                	mov    %eax,%edx
  80188a:	83 c4 10             	add    $0x10,%esp
  80188d:	eb e7                	jmp    801876 <devsock_close+0x1d>

0080188f <devsock_write>:
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
  801892:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801895:	6a 00                	push   $0x0
  801897:	ff 75 10             	pushl  0x10(%ebp)
  80189a:	ff 75 0c             	pushl  0xc(%ebp)
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	ff 70 0c             	pushl  0xc(%eax)
  8018a3:	e8 76 03 00 00       	call   801c1e <nsipc_send>
}
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    

008018aa <devsock_read>:
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018b0:	6a 00                	push   $0x0
  8018b2:	ff 75 10             	pushl  0x10(%ebp)
  8018b5:	ff 75 0c             	pushl  0xc(%ebp)
  8018b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bb:	ff 70 0c             	pushl  0xc(%eax)
  8018be:	e8 ef 02 00 00       	call   801bb2 <nsipc_recv>
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <fd2sockid>:
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
  8018c8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018cb:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018ce:	52                   	push   %edx
  8018cf:	50                   	push   %eax
  8018d0:	e8 b7 f7 ff ff       	call   80108c <fd_lookup>
  8018d5:	83 c4 10             	add    $0x10,%esp
  8018d8:	85 c0                	test   %eax,%eax
  8018da:	78 10                	js     8018ec <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018df:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018e5:	39 08                	cmp    %ecx,(%eax)
  8018e7:	75 05                	jne    8018ee <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018e9:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8018ec:	c9                   	leave  
  8018ed:	c3                   	ret    
		return -E_NOT_SUPP;
  8018ee:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018f3:	eb f7                	jmp    8018ec <fd2sockid+0x27>

008018f5 <alloc_sockfd>:
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
  8018f8:	56                   	push   %esi
  8018f9:	53                   	push   %ebx
  8018fa:	83 ec 1c             	sub    $0x1c,%esp
  8018fd:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8018ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801902:	50                   	push   %eax
  801903:	e8 32 f7 ff ff       	call   80103a <fd_alloc>
  801908:	89 c3                	mov    %eax,%ebx
  80190a:	83 c4 10             	add    $0x10,%esp
  80190d:	85 c0                	test   %eax,%eax
  80190f:	78 43                	js     801954 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801911:	83 ec 04             	sub    $0x4,%esp
  801914:	68 07 04 00 00       	push   $0x407
  801919:	ff 75 f4             	pushl  -0xc(%ebp)
  80191c:	6a 00                	push   $0x0
  80191e:	e8 fb f3 ff ff       	call   800d1e <sys_page_alloc>
  801923:	89 c3                	mov    %eax,%ebx
  801925:	83 c4 10             	add    $0x10,%esp
  801928:	85 c0                	test   %eax,%eax
  80192a:	78 28                	js     801954 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80192c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80192f:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801935:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80193a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801941:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801944:	83 ec 0c             	sub    $0xc,%esp
  801947:	50                   	push   %eax
  801948:	e8 c6 f6 ff ff       	call   801013 <fd2num>
  80194d:	89 c3                	mov    %eax,%ebx
  80194f:	83 c4 10             	add    $0x10,%esp
  801952:	eb 0c                	jmp    801960 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801954:	83 ec 0c             	sub    $0xc,%esp
  801957:	56                   	push   %esi
  801958:	e8 e4 01 00 00       	call   801b41 <nsipc_close>
		return r;
  80195d:	83 c4 10             	add    $0x10,%esp
}
  801960:	89 d8                	mov    %ebx,%eax
  801962:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801965:	5b                   	pop    %ebx
  801966:	5e                   	pop    %esi
  801967:	5d                   	pop    %ebp
  801968:	c3                   	ret    

00801969 <accept>:
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80196f:	8b 45 08             	mov    0x8(%ebp),%eax
  801972:	e8 4e ff ff ff       	call   8018c5 <fd2sockid>
  801977:	85 c0                	test   %eax,%eax
  801979:	78 1b                	js     801996 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80197b:	83 ec 04             	sub    $0x4,%esp
  80197e:	ff 75 10             	pushl  0x10(%ebp)
  801981:	ff 75 0c             	pushl  0xc(%ebp)
  801984:	50                   	push   %eax
  801985:	e8 0e 01 00 00       	call   801a98 <nsipc_accept>
  80198a:	83 c4 10             	add    $0x10,%esp
  80198d:	85 c0                	test   %eax,%eax
  80198f:	78 05                	js     801996 <accept+0x2d>
	return alloc_sockfd(r);
  801991:	e8 5f ff ff ff       	call   8018f5 <alloc_sockfd>
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <bind>:
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
  80199b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	e8 1f ff ff ff       	call   8018c5 <fd2sockid>
  8019a6:	85 c0                	test   %eax,%eax
  8019a8:	78 12                	js     8019bc <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019aa:	83 ec 04             	sub    $0x4,%esp
  8019ad:	ff 75 10             	pushl  0x10(%ebp)
  8019b0:	ff 75 0c             	pushl  0xc(%ebp)
  8019b3:	50                   	push   %eax
  8019b4:	e8 31 01 00 00       	call   801aea <nsipc_bind>
  8019b9:	83 c4 10             	add    $0x10,%esp
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <shutdown>:
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c7:	e8 f9 fe ff ff       	call   8018c5 <fd2sockid>
  8019cc:	85 c0                	test   %eax,%eax
  8019ce:	78 0f                	js     8019df <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019d0:	83 ec 08             	sub    $0x8,%esp
  8019d3:	ff 75 0c             	pushl  0xc(%ebp)
  8019d6:	50                   	push   %eax
  8019d7:	e8 43 01 00 00       	call   801b1f <nsipc_shutdown>
  8019dc:	83 c4 10             	add    $0x10,%esp
}
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <connect>:
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ea:	e8 d6 fe ff ff       	call   8018c5 <fd2sockid>
  8019ef:	85 c0                	test   %eax,%eax
  8019f1:	78 12                	js     801a05 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8019f3:	83 ec 04             	sub    $0x4,%esp
  8019f6:	ff 75 10             	pushl  0x10(%ebp)
  8019f9:	ff 75 0c             	pushl  0xc(%ebp)
  8019fc:	50                   	push   %eax
  8019fd:	e8 59 01 00 00       	call   801b5b <nsipc_connect>
  801a02:	83 c4 10             	add    $0x10,%esp
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <listen>:
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a10:	e8 b0 fe ff ff       	call   8018c5 <fd2sockid>
  801a15:	85 c0                	test   %eax,%eax
  801a17:	78 0f                	js     801a28 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a19:	83 ec 08             	sub    $0x8,%esp
  801a1c:	ff 75 0c             	pushl  0xc(%ebp)
  801a1f:	50                   	push   %eax
  801a20:	e8 6b 01 00 00       	call   801b90 <nsipc_listen>
  801a25:	83 c4 10             	add    $0x10,%esp
}
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <socket>:

int
socket(int domain, int type, int protocol)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
  801a2d:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a30:	ff 75 10             	pushl  0x10(%ebp)
  801a33:	ff 75 0c             	pushl  0xc(%ebp)
  801a36:	ff 75 08             	pushl  0x8(%ebp)
  801a39:	e8 3e 02 00 00       	call   801c7c <nsipc_socket>
  801a3e:	83 c4 10             	add    $0x10,%esp
  801a41:	85 c0                	test   %eax,%eax
  801a43:	78 05                	js     801a4a <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a45:	e8 ab fe ff ff       	call   8018f5 <alloc_sockfd>
}
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	53                   	push   %ebx
  801a50:	83 ec 04             	sub    $0x4,%esp
  801a53:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a55:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a5c:	74 26                	je     801a84 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a5e:	6a 07                	push   $0x7
  801a60:	68 00 60 80 00       	push   $0x806000
  801a65:	53                   	push   %ebx
  801a66:	ff 35 04 40 80 00    	pushl  0x804004
  801a6c:	e8 c2 07 00 00       	call   802233 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a71:	83 c4 0c             	add    $0xc,%esp
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	e8 4b 07 00 00       	call   8021ca <ipc_recv>
}
  801a7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a84:	83 ec 0c             	sub    $0xc,%esp
  801a87:	6a 02                	push   $0x2
  801a89:	e8 fd 07 00 00       	call   80228b <ipc_find_env>
  801a8e:	a3 04 40 80 00       	mov    %eax,0x804004
  801a93:	83 c4 10             	add    $0x10,%esp
  801a96:	eb c6                	jmp    801a5e <nsipc+0x12>

00801a98 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
  801a9b:	56                   	push   %esi
  801a9c:	53                   	push   %ebx
  801a9d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801aa8:	8b 06                	mov    (%esi),%eax
  801aaa:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801aaf:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab4:	e8 93 ff ff ff       	call   801a4c <nsipc>
  801ab9:	89 c3                	mov    %eax,%ebx
  801abb:	85 c0                	test   %eax,%eax
  801abd:	79 09                	jns    801ac8 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801abf:	89 d8                	mov    %ebx,%eax
  801ac1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ac4:	5b                   	pop    %ebx
  801ac5:	5e                   	pop    %esi
  801ac6:	5d                   	pop    %ebp
  801ac7:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ac8:	83 ec 04             	sub    $0x4,%esp
  801acb:	ff 35 10 60 80 00    	pushl  0x806010
  801ad1:	68 00 60 80 00       	push   $0x806000
  801ad6:	ff 75 0c             	pushl  0xc(%ebp)
  801ad9:	e8 dc ef ff ff       	call   800aba <memmove>
		*addrlen = ret->ret_addrlen;
  801ade:	a1 10 60 80 00       	mov    0x806010,%eax
  801ae3:	89 06                	mov    %eax,(%esi)
  801ae5:	83 c4 10             	add    $0x10,%esp
	return r;
  801ae8:	eb d5                	jmp    801abf <nsipc_accept+0x27>

00801aea <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
  801aed:	53                   	push   %ebx
  801aee:	83 ec 08             	sub    $0x8,%esp
  801af1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801af4:	8b 45 08             	mov    0x8(%ebp),%eax
  801af7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801afc:	53                   	push   %ebx
  801afd:	ff 75 0c             	pushl  0xc(%ebp)
  801b00:	68 04 60 80 00       	push   $0x806004
  801b05:	e8 b0 ef ff ff       	call   800aba <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b0a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b10:	b8 02 00 00 00       	mov    $0x2,%eax
  801b15:	e8 32 ff ff ff       	call   801a4c <nsipc>
}
  801b1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
  801b22:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b25:	8b 45 08             	mov    0x8(%ebp),%eax
  801b28:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b30:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b35:	b8 03 00 00 00       	mov    $0x3,%eax
  801b3a:	e8 0d ff ff ff       	call   801a4c <nsipc>
}
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    

00801b41 <nsipc_close>:

int
nsipc_close(int s)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
  801b44:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b47:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4a:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b4f:	b8 04 00 00 00       	mov    $0x4,%eax
  801b54:	e8 f3 fe ff ff       	call   801a4c <nsipc>
}
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	53                   	push   %ebx
  801b5f:	83 ec 08             	sub    $0x8,%esp
  801b62:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b65:	8b 45 08             	mov    0x8(%ebp),%eax
  801b68:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b6d:	53                   	push   %ebx
  801b6e:	ff 75 0c             	pushl  0xc(%ebp)
  801b71:	68 04 60 80 00       	push   $0x806004
  801b76:	e8 3f ef ff ff       	call   800aba <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b7b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b81:	b8 05 00 00 00       	mov    $0x5,%eax
  801b86:	e8 c1 fe ff ff       	call   801a4c <nsipc>
}
  801b8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba1:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801ba6:	b8 06 00 00 00       	mov    $0x6,%eax
  801bab:	e8 9c fe ff ff       	call   801a4c <nsipc>
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
  801bb5:	56                   	push   %esi
  801bb6:	53                   	push   %ebx
  801bb7:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bba:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbd:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bc2:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801bc8:	8b 45 14             	mov    0x14(%ebp),%eax
  801bcb:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bd0:	b8 07 00 00 00       	mov    $0x7,%eax
  801bd5:	e8 72 fe ff ff       	call   801a4c <nsipc>
  801bda:	89 c3                	mov    %eax,%ebx
  801bdc:	85 c0                	test   %eax,%eax
  801bde:	78 1f                	js     801bff <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801be0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801be5:	7f 21                	jg     801c08 <nsipc_recv+0x56>
  801be7:	39 c6                	cmp    %eax,%esi
  801be9:	7c 1d                	jl     801c08 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801beb:	83 ec 04             	sub    $0x4,%esp
  801bee:	50                   	push   %eax
  801bef:	68 00 60 80 00       	push   $0x806000
  801bf4:	ff 75 0c             	pushl  0xc(%ebp)
  801bf7:	e8 be ee ff ff       	call   800aba <memmove>
  801bfc:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801bff:	89 d8                	mov    %ebx,%eax
  801c01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c04:	5b                   	pop    %ebx
  801c05:	5e                   	pop    %esi
  801c06:	5d                   	pop    %ebp
  801c07:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c08:	68 23 2a 80 00       	push   $0x802a23
  801c0d:	68 eb 29 80 00       	push   $0x8029eb
  801c12:	6a 62                	push   $0x62
  801c14:	68 38 2a 80 00       	push   $0x802a38
  801c19:	e8 4b 05 00 00       	call   802169 <_panic>

00801c1e <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
  801c21:	53                   	push   %ebx
  801c22:	83 ec 04             	sub    $0x4,%esp
  801c25:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c28:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c30:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c36:	7f 2e                	jg     801c66 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c38:	83 ec 04             	sub    $0x4,%esp
  801c3b:	53                   	push   %ebx
  801c3c:	ff 75 0c             	pushl  0xc(%ebp)
  801c3f:	68 0c 60 80 00       	push   $0x80600c
  801c44:	e8 71 ee ff ff       	call   800aba <memmove>
	nsipcbuf.send.req_size = size;
  801c49:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c4f:	8b 45 14             	mov    0x14(%ebp),%eax
  801c52:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c57:	b8 08 00 00 00       	mov    $0x8,%eax
  801c5c:	e8 eb fd ff ff       	call   801a4c <nsipc>
}
  801c61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    
	assert(size < 1600);
  801c66:	68 44 2a 80 00       	push   $0x802a44
  801c6b:	68 eb 29 80 00       	push   $0x8029eb
  801c70:	6a 6d                	push   $0x6d
  801c72:	68 38 2a 80 00       	push   $0x802a38
  801c77:	e8 ed 04 00 00       	call   802169 <_panic>

00801c7c <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
  801c7f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c82:	8b 45 08             	mov    0x8(%ebp),%eax
  801c85:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c8d:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c92:	8b 45 10             	mov    0x10(%ebp),%eax
  801c95:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c9a:	b8 09 00 00 00       	mov    $0x9,%eax
  801c9f:	e8 a8 fd ff ff       	call   801a4c <nsipc>
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	56                   	push   %esi
  801caa:	53                   	push   %ebx
  801cab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cae:	83 ec 0c             	sub    $0xc,%esp
  801cb1:	ff 75 08             	pushl  0x8(%ebp)
  801cb4:	e8 6a f3 ff ff       	call   801023 <fd2data>
  801cb9:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cbb:	83 c4 08             	add    $0x8,%esp
  801cbe:	68 50 2a 80 00       	push   $0x802a50
  801cc3:	53                   	push   %ebx
  801cc4:	e8 63 ec ff ff       	call   80092c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cc9:	8b 46 04             	mov    0x4(%esi),%eax
  801ccc:	2b 06                	sub    (%esi),%eax
  801cce:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cd4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cdb:	00 00 00 
	stat->st_dev = &devpipe;
  801cde:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801ce5:	30 80 00 
	return 0;
}
  801ce8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ced:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cf0:	5b                   	pop    %ebx
  801cf1:	5e                   	pop    %esi
  801cf2:	5d                   	pop    %ebp
  801cf3:	c3                   	ret    

00801cf4 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
  801cf7:	53                   	push   %ebx
  801cf8:	83 ec 0c             	sub    $0xc,%esp
  801cfb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801cfe:	53                   	push   %ebx
  801cff:	6a 00                	push   $0x0
  801d01:	e8 9d f0 ff ff       	call   800da3 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d06:	89 1c 24             	mov    %ebx,(%esp)
  801d09:	e8 15 f3 ff ff       	call   801023 <fd2data>
  801d0e:	83 c4 08             	add    $0x8,%esp
  801d11:	50                   	push   %eax
  801d12:	6a 00                	push   $0x0
  801d14:	e8 8a f0 ff ff       	call   800da3 <sys_page_unmap>
}
  801d19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d1c:	c9                   	leave  
  801d1d:	c3                   	ret    

00801d1e <_pipeisclosed>:
{
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
  801d21:	57                   	push   %edi
  801d22:	56                   	push   %esi
  801d23:	53                   	push   %ebx
  801d24:	83 ec 1c             	sub    $0x1c,%esp
  801d27:	89 c7                	mov    %eax,%edi
  801d29:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d2b:	a1 08 40 80 00       	mov    0x804008,%eax
  801d30:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d33:	83 ec 0c             	sub    $0xc,%esp
  801d36:	57                   	push   %edi
  801d37:	e8 8e 05 00 00       	call   8022ca <pageref>
  801d3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d3f:	89 34 24             	mov    %esi,(%esp)
  801d42:	e8 83 05 00 00       	call   8022ca <pageref>
		nn = thisenv->env_runs;
  801d47:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d4d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d50:	83 c4 10             	add    $0x10,%esp
  801d53:	39 cb                	cmp    %ecx,%ebx
  801d55:	74 1b                	je     801d72 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d57:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d5a:	75 cf                	jne    801d2b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d5c:	8b 42 58             	mov    0x58(%edx),%eax
  801d5f:	6a 01                	push   $0x1
  801d61:	50                   	push   %eax
  801d62:	53                   	push   %ebx
  801d63:	68 57 2a 80 00       	push   $0x802a57
  801d68:	e8 60 e4 ff ff       	call   8001cd <cprintf>
  801d6d:	83 c4 10             	add    $0x10,%esp
  801d70:	eb b9                	jmp    801d2b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d72:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d75:	0f 94 c0             	sete   %al
  801d78:	0f b6 c0             	movzbl %al,%eax
}
  801d7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d7e:	5b                   	pop    %ebx
  801d7f:	5e                   	pop    %esi
  801d80:	5f                   	pop    %edi
  801d81:	5d                   	pop    %ebp
  801d82:	c3                   	ret    

00801d83 <devpipe_write>:
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
  801d86:	57                   	push   %edi
  801d87:	56                   	push   %esi
  801d88:	53                   	push   %ebx
  801d89:	83 ec 28             	sub    $0x28,%esp
  801d8c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d8f:	56                   	push   %esi
  801d90:	e8 8e f2 ff ff       	call   801023 <fd2data>
  801d95:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d97:	83 c4 10             	add    $0x10,%esp
  801d9a:	bf 00 00 00 00       	mov    $0x0,%edi
  801d9f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801da2:	74 4f                	je     801df3 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801da4:	8b 43 04             	mov    0x4(%ebx),%eax
  801da7:	8b 0b                	mov    (%ebx),%ecx
  801da9:	8d 51 20             	lea    0x20(%ecx),%edx
  801dac:	39 d0                	cmp    %edx,%eax
  801dae:	72 14                	jb     801dc4 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801db0:	89 da                	mov    %ebx,%edx
  801db2:	89 f0                	mov    %esi,%eax
  801db4:	e8 65 ff ff ff       	call   801d1e <_pipeisclosed>
  801db9:	85 c0                	test   %eax,%eax
  801dbb:	75 3b                	jne    801df8 <devpipe_write+0x75>
			sys_yield();
  801dbd:	e8 3d ef ff ff       	call   800cff <sys_yield>
  801dc2:	eb e0                	jmp    801da4 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dc7:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801dcb:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801dce:	89 c2                	mov    %eax,%edx
  801dd0:	c1 fa 1f             	sar    $0x1f,%edx
  801dd3:	89 d1                	mov    %edx,%ecx
  801dd5:	c1 e9 1b             	shr    $0x1b,%ecx
  801dd8:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ddb:	83 e2 1f             	and    $0x1f,%edx
  801dde:	29 ca                	sub    %ecx,%edx
  801de0:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801de4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801de8:	83 c0 01             	add    $0x1,%eax
  801deb:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801dee:	83 c7 01             	add    $0x1,%edi
  801df1:	eb ac                	jmp    801d9f <devpipe_write+0x1c>
	return i;
  801df3:	8b 45 10             	mov    0x10(%ebp),%eax
  801df6:	eb 05                	jmp    801dfd <devpipe_write+0x7a>
				return 0;
  801df8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e00:	5b                   	pop    %ebx
  801e01:	5e                   	pop    %esi
  801e02:	5f                   	pop    %edi
  801e03:	5d                   	pop    %ebp
  801e04:	c3                   	ret    

00801e05 <devpipe_read>:
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
  801e08:	57                   	push   %edi
  801e09:	56                   	push   %esi
  801e0a:	53                   	push   %ebx
  801e0b:	83 ec 18             	sub    $0x18,%esp
  801e0e:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e11:	57                   	push   %edi
  801e12:	e8 0c f2 ff ff       	call   801023 <fd2data>
  801e17:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e19:	83 c4 10             	add    $0x10,%esp
  801e1c:	be 00 00 00 00       	mov    $0x0,%esi
  801e21:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e24:	75 14                	jne    801e3a <devpipe_read+0x35>
	return i;
  801e26:	8b 45 10             	mov    0x10(%ebp),%eax
  801e29:	eb 02                	jmp    801e2d <devpipe_read+0x28>
				return i;
  801e2b:	89 f0                	mov    %esi,%eax
}
  801e2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e30:	5b                   	pop    %ebx
  801e31:	5e                   	pop    %esi
  801e32:	5f                   	pop    %edi
  801e33:	5d                   	pop    %ebp
  801e34:	c3                   	ret    
			sys_yield();
  801e35:	e8 c5 ee ff ff       	call   800cff <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e3a:	8b 03                	mov    (%ebx),%eax
  801e3c:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e3f:	75 18                	jne    801e59 <devpipe_read+0x54>
			if (i > 0)
  801e41:	85 f6                	test   %esi,%esi
  801e43:	75 e6                	jne    801e2b <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e45:	89 da                	mov    %ebx,%edx
  801e47:	89 f8                	mov    %edi,%eax
  801e49:	e8 d0 fe ff ff       	call   801d1e <_pipeisclosed>
  801e4e:	85 c0                	test   %eax,%eax
  801e50:	74 e3                	je     801e35 <devpipe_read+0x30>
				return 0;
  801e52:	b8 00 00 00 00       	mov    $0x0,%eax
  801e57:	eb d4                	jmp    801e2d <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e59:	99                   	cltd   
  801e5a:	c1 ea 1b             	shr    $0x1b,%edx
  801e5d:	01 d0                	add    %edx,%eax
  801e5f:	83 e0 1f             	and    $0x1f,%eax
  801e62:	29 d0                	sub    %edx,%eax
  801e64:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e6c:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e6f:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e72:	83 c6 01             	add    $0x1,%esi
  801e75:	eb aa                	jmp    801e21 <devpipe_read+0x1c>

00801e77 <pipe>:
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
  801e7a:	56                   	push   %esi
  801e7b:	53                   	push   %ebx
  801e7c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e7f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e82:	50                   	push   %eax
  801e83:	e8 b2 f1 ff ff       	call   80103a <fd_alloc>
  801e88:	89 c3                	mov    %eax,%ebx
  801e8a:	83 c4 10             	add    $0x10,%esp
  801e8d:	85 c0                	test   %eax,%eax
  801e8f:	0f 88 23 01 00 00    	js     801fb8 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e95:	83 ec 04             	sub    $0x4,%esp
  801e98:	68 07 04 00 00       	push   $0x407
  801e9d:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea0:	6a 00                	push   $0x0
  801ea2:	e8 77 ee ff ff       	call   800d1e <sys_page_alloc>
  801ea7:	89 c3                	mov    %eax,%ebx
  801ea9:	83 c4 10             	add    $0x10,%esp
  801eac:	85 c0                	test   %eax,%eax
  801eae:	0f 88 04 01 00 00    	js     801fb8 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801eb4:	83 ec 0c             	sub    $0xc,%esp
  801eb7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801eba:	50                   	push   %eax
  801ebb:	e8 7a f1 ff ff       	call   80103a <fd_alloc>
  801ec0:	89 c3                	mov    %eax,%ebx
  801ec2:	83 c4 10             	add    $0x10,%esp
  801ec5:	85 c0                	test   %eax,%eax
  801ec7:	0f 88 db 00 00 00    	js     801fa8 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ecd:	83 ec 04             	sub    $0x4,%esp
  801ed0:	68 07 04 00 00       	push   $0x407
  801ed5:	ff 75 f0             	pushl  -0x10(%ebp)
  801ed8:	6a 00                	push   $0x0
  801eda:	e8 3f ee ff ff       	call   800d1e <sys_page_alloc>
  801edf:	89 c3                	mov    %eax,%ebx
  801ee1:	83 c4 10             	add    $0x10,%esp
  801ee4:	85 c0                	test   %eax,%eax
  801ee6:	0f 88 bc 00 00 00    	js     801fa8 <pipe+0x131>
	va = fd2data(fd0);
  801eec:	83 ec 0c             	sub    $0xc,%esp
  801eef:	ff 75 f4             	pushl  -0xc(%ebp)
  801ef2:	e8 2c f1 ff ff       	call   801023 <fd2data>
  801ef7:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ef9:	83 c4 0c             	add    $0xc,%esp
  801efc:	68 07 04 00 00       	push   $0x407
  801f01:	50                   	push   %eax
  801f02:	6a 00                	push   $0x0
  801f04:	e8 15 ee ff ff       	call   800d1e <sys_page_alloc>
  801f09:	89 c3                	mov    %eax,%ebx
  801f0b:	83 c4 10             	add    $0x10,%esp
  801f0e:	85 c0                	test   %eax,%eax
  801f10:	0f 88 82 00 00 00    	js     801f98 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f16:	83 ec 0c             	sub    $0xc,%esp
  801f19:	ff 75 f0             	pushl  -0x10(%ebp)
  801f1c:	e8 02 f1 ff ff       	call   801023 <fd2data>
  801f21:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f28:	50                   	push   %eax
  801f29:	6a 00                	push   $0x0
  801f2b:	56                   	push   %esi
  801f2c:	6a 00                	push   $0x0
  801f2e:	e8 2e ee ff ff       	call   800d61 <sys_page_map>
  801f33:	89 c3                	mov    %eax,%ebx
  801f35:	83 c4 20             	add    $0x20,%esp
  801f38:	85 c0                	test   %eax,%eax
  801f3a:	78 4e                	js     801f8a <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f3c:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f44:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f49:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f50:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f53:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f58:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f5f:	83 ec 0c             	sub    $0xc,%esp
  801f62:	ff 75 f4             	pushl  -0xc(%ebp)
  801f65:	e8 a9 f0 ff ff       	call   801013 <fd2num>
  801f6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f6d:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f6f:	83 c4 04             	add    $0x4,%esp
  801f72:	ff 75 f0             	pushl  -0x10(%ebp)
  801f75:	e8 99 f0 ff ff       	call   801013 <fd2num>
  801f7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f7d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f80:	83 c4 10             	add    $0x10,%esp
  801f83:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f88:	eb 2e                	jmp    801fb8 <pipe+0x141>
	sys_page_unmap(0, va);
  801f8a:	83 ec 08             	sub    $0x8,%esp
  801f8d:	56                   	push   %esi
  801f8e:	6a 00                	push   $0x0
  801f90:	e8 0e ee ff ff       	call   800da3 <sys_page_unmap>
  801f95:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f98:	83 ec 08             	sub    $0x8,%esp
  801f9b:	ff 75 f0             	pushl  -0x10(%ebp)
  801f9e:	6a 00                	push   $0x0
  801fa0:	e8 fe ed ff ff       	call   800da3 <sys_page_unmap>
  801fa5:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fa8:	83 ec 08             	sub    $0x8,%esp
  801fab:	ff 75 f4             	pushl  -0xc(%ebp)
  801fae:	6a 00                	push   $0x0
  801fb0:	e8 ee ed ff ff       	call   800da3 <sys_page_unmap>
  801fb5:	83 c4 10             	add    $0x10,%esp
}
  801fb8:	89 d8                	mov    %ebx,%eax
  801fba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fbd:	5b                   	pop    %ebx
  801fbe:	5e                   	pop    %esi
  801fbf:	5d                   	pop    %ebp
  801fc0:	c3                   	ret    

00801fc1 <pipeisclosed>:
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
  801fc4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fc7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fca:	50                   	push   %eax
  801fcb:	ff 75 08             	pushl  0x8(%ebp)
  801fce:	e8 b9 f0 ff ff       	call   80108c <fd_lookup>
  801fd3:	83 c4 10             	add    $0x10,%esp
  801fd6:	85 c0                	test   %eax,%eax
  801fd8:	78 18                	js     801ff2 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fda:	83 ec 0c             	sub    $0xc,%esp
  801fdd:	ff 75 f4             	pushl  -0xc(%ebp)
  801fe0:	e8 3e f0 ff ff       	call   801023 <fd2data>
	return _pipeisclosed(fd, p);
  801fe5:	89 c2                	mov    %eax,%edx
  801fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fea:	e8 2f fd ff ff       	call   801d1e <_pipeisclosed>
  801fef:	83 c4 10             	add    $0x10,%esp
}
  801ff2:	c9                   	leave  
  801ff3:	c3                   	ret    

00801ff4 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801ff4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff9:	c3                   	ret    

00801ffa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801ffa:	55                   	push   %ebp
  801ffb:	89 e5                	mov    %esp,%ebp
  801ffd:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802000:	68 6f 2a 80 00       	push   $0x802a6f
  802005:	ff 75 0c             	pushl  0xc(%ebp)
  802008:	e8 1f e9 ff ff       	call   80092c <strcpy>
	return 0;
}
  80200d:	b8 00 00 00 00       	mov    $0x0,%eax
  802012:	c9                   	leave  
  802013:	c3                   	ret    

00802014 <devcons_write>:
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
  802017:	57                   	push   %edi
  802018:	56                   	push   %esi
  802019:	53                   	push   %ebx
  80201a:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802020:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802025:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80202b:	3b 75 10             	cmp    0x10(%ebp),%esi
  80202e:	73 31                	jae    802061 <devcons_write+0x4d>
		m = n - tot;
  802030:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802033:	29 f3                	sub    %esi,%ebx
  802035:	83 fb 7f             	cmp    $0x7f,%ebx
  802038:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80203d:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802040:	83 ec 04             	sub    $0x4,%esp
  802043:	53                   	push   %ebx
  802044:	89 f0                	mov    %esi,%eax
  802046:	03 45 0c             	add    0xc(%ebp),%eax
  802049:	50                   	push   %eax
  80204a:	57                   	push   %edi
  80204b:	e8 6a ea ff ff       	call   800aba <memmove>
		sys_cputs(buf, m);
  802050:	83 c4 08             	add    $0x8,%esp
  802053:	53                   	push   %ebx
  802054:	57                   	push   %edi
  802055:	e8 08 ec ff ff       	call   800c62 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80205a:	01 de                	add    %ebx,%esi
  80205c:	83 c4 10             	add    $0x10,%esp
  80205f:	eb ca                	jmp    80202b <devcons_write+0x17>
}
  802061:	89 f0                	mov    %esi,%eax
  802063:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802066:	5b                   	pop    %ebx
  802067:	5e                   	pop    %esi
  802068:	5f                   	pop    %edi
  802069:	5d                   	pop    %ebp
  80206a:	c3                   	ret    

0080206b <devcons_read>:
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	83 ec 08             	sub    $0x8,%esp
  802071:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802076:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80207a:	74 21                	je     80209d <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80207c:	e8 ff eb ff ff       	call   800c80 <sys_cgetc>
  802081:	85 c0                	test   %eax,%eax
  802083:	75 07                	jne    80208c <devcons_read+0x21>
		sys_yield();
  802085:	e8 75 ec ff ff       	call   800cff <sys_yield>
  80208a:	eb f0                	jmp    80207c <devcons_read+0x11>
	if (c < 0)
  80208c:	78 0f                	js     80209d <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80208e:	83 f8 04             	cmp    $0x4,%eax
  802091:	74 0c                	je     80209f <devcons_read+0x34>
	*(char*)vbuf = c;
  802093:	8b 55 0c             	mov    0xc(%ebp),%edx
  802096:	88 02                	mov    %al,(%edx)
	return 1;
  802098:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80209d:	c9                   	leave  
  80209e:	c3                   	ret    
		return 0;
  80209f:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a4:	eb f7                	jmp    80209d <devcons_read+0x32>

008020a6 <cputchar>:
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
  8020a9:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8020af:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020b2:	6a 01                	push   $0x1
  8020b4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020b7:	50                   	push   %eax
  8020b8:	e8 a5 eb ff ff       	call   800c62 <sys_cputs>
}
  8020bd:	83 c4 10             	add    $0x10,%esp
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    

008020c2 <getchar>:
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
  8020c5:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020c8:	6a 01                	push   $0x1
  8020ca:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020cd:	50                   	push   %eax
  8020ce:	6a 00                	push   $0x0
  8020d0:	e8 27 f2 ff ff       	call   8012fc <read>
	if (r < 0)
  8020d5:	83 c4 10             	add    $0x10,%esp
  8020d8:	85 c0                	test   %eax,%eax
  8020da:	78 06                	js     8020e2 <getchar+0x20>
	if (r < 1)
  8020dc:	74 06                	je     8020e4 <getchar+0x22>
	return c;
  8020de:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    
		return -E_EOF;
  8020e4:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020e9:	eb f7                	jmp    8020e2 <getchar+0x20>

008020eb <iscons>:
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
  8020ee:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020f4:	50                   	push   %eax
  8020f5:	ff 75 08             	pushl  0x8(%ebp)
  8020f8:	e8 8f ef ff ff       	call   80108c <fd_lookup>
  8020fd:	83 c4 10             	add    $0x10,%esp
  802100:	85 c0                	test   %eax,%eax
  802102:	78 11                	js     802115 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802107:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80210d:	39 10                	cmp    %edx,(%eax)
  80210f:	0f 94 c0             	sete   %al
  802112:	0f b6 c0             	movzbl %al,%eax
}
  802115:	c9                   	leave  
  802116:	c3                   	ret    

00802117 <opencons>:
{
  802117:	55                   	push   %ebp
  802118:	89 e5                	mov    %esp,%ebp
  80211a:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80211d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802120:	50                   	push   %eax
  802121:	e8 14 ef ff ff       	call   80103a <fd_alloc>
  802126:	83 c4 10             	add    $0x10,%esp
  802129:	85 c0                	test   %eax,%eax
  80212b:	78 3a                	js     802167 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80212d:	83 ec 04             	sub    $0x4,%esp
  802130:	68 07 04 00 00       	push   $0x407
  802135:	ff 75 f4             	pushl  -0xc(%ebp)
  802138:	6a 00                	push   $0x0
  80213a:	e8 df eb ff ff       	call   800d1e <sys_page_alloc>
  80213f:	83 c4 10             	add    $0x10,%esp
  802142:	85 c0                	test   %eax,%eax
  802144:	78 21                	js     802167 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802146:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802149:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80214f:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802151:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802154:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80215b:	83 ec 0c             	sub    $0xc,%esp
  80215e:	50                   	push   %eax
  80215f:	e8 af ee ff ff       	call   801013 <fd2num>
  802164:	83 c4 10             	add    $0x10,%esp
}
  802167:	c9                   	leave  
  802168:	c3                   	ret    

00802169 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802169:	55                   	push   %ebp
  80216a:	89 e5                	mov    %esp,%ebp
  80216c:	56                   	push   %esi
  80216d:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80216e:	a1 08 40 80 00       	mov    0x804008,%eax
  802173:	8b 40 48             	mov    0x48(%eax),%eax
  802176:	83 ec 04             	sub    $0x4,%esp
  802179:	68 a0 2a 80 00       	push   $0x802aa0
  80217e:	50                   	push   %eax
  80217f:	68 99 25 80 00       	push   $0x802599
  802184:	e8 44 e0 ff ff       	call   8001cd <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802189:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80218c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802192:	e8 49 eb ff ff       	call   800ce0 <sys_getenvid>
  802197:	83 c4 04             	add    $0x4,%esp
  80219a:	ff 75 0c             	pushl  0xc(%ebp)
  80219d:	ff 75 08             	pushl  0x8(%ebp)
  8021a0:	56                   	push   %esi
  8021a1:	50                   	push   %eax
  8021a2:	68 7c 2a 80 00       	push   $0x802a7c
  8021a7:	e8 21 e0 ff ff       	call   8001cd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021ac:	83 c4 18             	add    $0x18,%esp
  8021af:	53                   	push   %ebx
  8021b0:	ff 75 10             	pushl  0x10(%ebp)
  8021b3:	e8 c4 df ff ff       	call   80017c <vcprintf>
	cprintf("\n");
  8021b8:	c7 04 24 ba 2a 80 00 	movl   $0x802aba,(%esp)
  8021bf:	e8 09 e0 ff ff       	call   8001cd <cprintf>
  8021c4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021c7:	cc                   	int3   
  8021c8:	eb fd                	jmp    8021c7 <_panic+0x5e>

008021ca <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
  8021cd:	56                   	push   %esi
  8021ce:	53                   	push   %ebx
  8021cf:	8b 75 08             	mov    0x8(%ebp),%esi
  8021d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8021d8:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021da:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021df:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8021e2:	83 ec 0c             	sub    $0xc,%esp
  8021e5:	50                   	push   %eax
  8021e6:	e8 e3 ec ff ff       	call   800ece <sys_ipc_recv>
	if(ret < 0){
  8021eb:	83 c4 10             	add    $0x10,%esp
  8021ee:	85 c0                	test   %eax,%eax
  8021f0:	78 2b                	js     80221d <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8021f2:	85 f6                	test   %esi,%esi
  8021f4:	74 0a                	je     802200 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8021f6:	a1 08 40 80 00       	mov    0x804008,%eax
  8021fb:	8b 40 78             	mov    0x78(%eax),%eax
  8021fe:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802200:	85 db                	test   %ebx,%ebx
  802202:	74 0a                	je     80220e <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802204:	a1 08 40 80 00       	mov    0x804008,%eax
  802209:	8b 40 7c             	mov    0x7c(%eax),%eax
  80220c:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80220e:	a1 08 40 80 00       	mov    0x804008,%eax
  802213:	8b 40 74             	mov    0x74(%eax),%eax
}
  802216:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802219:	5b                   	pop    %ebx
  80221a:	5e                   	pop    %esi
  80221b:	5d                   	pop    %ebp
  80221c:	c3                   	ret    
		if(from_env_store)
  80221d:	85 f6                	test   %esi,%esi
  80221f:	74 06                	je     802227 <ipc_recv+0x5d>
			*from_env_store = 0;
  802221:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802227:	85 db                	test   %ebx,%ebx
  802229:	74 eb                	je     802216 <ipc_recv+0x4c>
			*perm_store = 0;
  80222b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802231:	eb e3                	jmp    802216 <ipc_recv+0x4c>

00802233 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
  802236:	57                   	push   %edi
  802237:	56                   	push   %esi
  802238:	53                   	push   %ebx
  802239:	83 ec 0c             	sub    $0xc,%esp
  80223c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80223f:	8b 75 0c             	mov    0xc(%ebp),%esi
  802242:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802245:	85 db                	test   %ebx,%ebx
  802247:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80224c:	0f 44 d8             	cmove  %eax,%ebx
  80224f:	eb 05                	jmp    802256 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802251:	e8 a9 ea ff ff       	call   800cff <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802256:	ff 75 14             	pushl  0x14(%ebp)
  802259:	53                   	push   %ebx
  80225a:	56                   	push   %esi
  80225b:	57                   	push   %edi
  80225c:	e8 4a ec ff ff       	call   800eab <sys_ipc_try_send>
  802261:	83 c4 10             	add    $0x10,%esp
  802264:	85 c0                	test   %eax,%eax
  802266:	74 1b                	je     802283 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802268:	79 e7                	jns    802251 <ipc_send+0x1e>
  80226a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80226d:	74 e2                	je     802251 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80226f:	83 ec 04             	sub    $0x4,%esp
  802272:	68 a7 2a 80 00       	push   $0x802aa7
  802277:	6a 46                	push   $0x46
  802279:	68 bc 2a 80 00       	push   $0x802abc
  80227e:	e8 e6 fe ff ff       	call   802169 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802283:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802286:	5b                   	pop    %ebx
  802287:	5e                   	pop    %esi
  802288:	5f                   	pop    %edi
  802289:	5d                   	pop    %ebp
  80228a:	c3                   	ret    

0080228b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80228b:	55                   	push   %ebp
  80228c:	89 e5                	mov    %esp,%ebp
  80228e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802291:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802296:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80229c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022a2:	8b 52 50             	mov    0x50(%edx),%edx
  8022a5:	39 ca                	cmp    %ecx,%edx
  8022a7:	74 11                	je     8022ba <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8022a9:	83 c0 01             	add    $0x1,%eax
  8022ac:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022b1:	75 e3                	jne    802296 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b8:	eb 0e                	jmp    8022c8 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8022ba:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8022c0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022c5:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022c8:	5d                   	pop    %ebp
  8022c9:	c3                   	ret    

008022ca <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
  8022cd:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022d0:	89 d0                	mov    %edx,%eax
  8022d2:	c1 e8 16             	shr    $0x16,%eax
  8022d5:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022dc:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022e1:	f6 c1 01             	test   $0x1,%cl
  8022e4:	74 1d                	je     802303 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022e6:	c1 ea 0c             	shr    $0xc,%edx
  8022e9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022f0:	f6 c2 01             	test   $0x1,%dl
  8022f3:	74 0e                	je     802303 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022f5:	c1 ea 0c             	shr    $0xc,%edx
  8022f8:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022ff:	ef 
  802300:	0f b7 c0             	movzwl %ax,%eax
}
  802303:	5d                   	pop    %ebp
  802304:	c3                   	ret    
  802305:	66 90                	xchg   %ax,%ax
  802307:	66 90                	xchg   %ax,%ax
  802309:	66 90                	xchg   %ax,%ax
  80230b:	66 90                	xchg   %ax,%ax
  80230d:	66 90                	xchg   %ax,%ax
  80230f:	90                   	nop

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
