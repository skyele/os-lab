
obj/user/testbss.debug:     file format elf32-i386


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
  80002c:	e8 ab 00 00 00       	call   8000dc <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	int i;

	cprintf("Making sure bss works right...\n");
  800039:	68 80 25 80 00       	push   $0x802580
  80003e:	e8 0c 02 00 00       	call   80024f <cprintf>
  800043:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < ARRAYSIZE; i++)
  800046:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
  80004b:	83 3c 85 20 40 80 00 	cmpl   $0x0,0x804020(,%eax,4)
  800052:	00 
  800053:	75 63                	jne    8000b8 <umain+0x85>
	for (i = 0; i < ARRAYSIZE; i++)
  800055:	83 c0 01             	add    $0x1,%eax
  800058:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80005d:	75 ec                	jne    80004b <umain+0x18>
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
  80005f:	b8 00 00 00 00       	mov    $0x0,%eax
		bigarray[i] = i;
  800064:	89 04 85 20 40 80 00 	mov    %eax,0x804020(,%eax,4)
	for (i = 0; i < ARRAYSIZE; i++)
  80006b:	83 c0 01             	add    $0x1,%eax
  80006e:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800073:	75 ef                	jne    800064 <umain+0x31>
	for (i = 0; i < ARRAYSIZE; i++)
  800075:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != i)
  80007a:	39 04 85 20 40 80 00 	cmp    %eax,0x804020(,%eax,4)
  800081:	75 47                	jne    8000ca <umain+0x97>
	for (i = 0; i < ARRAYSIZE; i++)
  800083:	83 c0 01             	add    $0x1,%eax
  800086:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80008b:	75 ed                	jne    80007a <umain+0x47>
			panic("bigarray[%d] didn't hold its value!\n", i);

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  80008d:	83 ec 0c             	sub    $0xc,%esp
  800090:	68 c8 25 80 00       	push   $0x8025c8
  800095:	e8 b5 01 00 00       	call   80024f <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  80009a:	c7 05 20 50 c0 00 00 	movl   $0x0,0xc05020
  8000a1:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  8000a4:	83 c4 0c             	add    $0xc,%esp
  8000a7:	68 27 26 80 00       	push   $0x802627
  8000ac:	6a 1a                	push   $0x1a
  8000ae:	68 18 26 80 00       	push   $0x802618
  8000b3:	e8 a1 00 00 00       	call   800159 <_panic>
			panic("bigarray[%d] isn't cleared!\n", i);
  8000b8:	50                   	push   %eax
  8000b9:	68 fb 25 80 00       	push   $0x8025fb
  8000be:	6a 11                	push   $0x11
  8000c0:	68 18 26 80 00       	push   $0x802618
  8000c5:	e8 8f 00 00 00       	call   800159 <_panic>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000ca:	50                   	push   %eax
  8000cb:	68 a0 25 80 00       	push   $0x8025a0
  8000d0:	6a 16                	push   $0x16
  8000d2:	68 18 26 80 00       	push   $0x802618
  8000d7:	e8 7d 00 00 00       	call   800159 <_panic>

008000dc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000dc:	55                   	push   %ebp
  8000dd:	89 e5                	mov    %esp,%ebp
  8000df:	56                   	push   %esi
  8000e0:	53                   	push   %ebx
  8000e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000e4:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  8000e7:	e8 76 0c 00 00       	call   800d62 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  8000ec:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f1:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8000f7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000fc:	a3 20 40 c0 00       	mov    %eax,0xc04020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800101:	85 db                	test   %ebx,%ebx
  800103:	7e 07                	jle    80010c <libmain+0x30>
		binaryname = argv[0];
  800105:	8b 06                	mov    (%esi),%eax
  800107:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80010c:	83 ec 08             	sub    $0x8,%esp
  80010f:	56                   	push   %esi
  800110:	53                   	push   %ebx
  800111:	e8 1d ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800116:	e8 0a 00 00 00       	call   800125 <exit>
}
  80011b:	83 c4 10             	add    $0x10,%esp
  80011e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800121:	5b                   	pop    %ebx
  800122:	5e                   	pop    %esi
  800123:	5d                   	pop    %ebp
  800124:	c3                   	ret    

00800125 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800125:	55                   	push   %ebp
  800126:	89 e5                	mov    %esp,%ebp
  800128:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80012b:	a1 20 40 c0 00       	mov    0xc04020,%eax
  800130:	8b 40 48             	mov    0x48(%eax),%eax
  800133:	68 54 26 80 00       	push   $0x802654
  800138:	50                   	push   %eax
  800139:	68 48 26 80 00       	push   $0x802648
  80013e:	e8 0c 01 00 00       	call   80024f <cprintf>
	close_all();
  800143:	e8 25 11 00 00       	call   80126d <close_all>
	sys_env_destroy(0);
  800148:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80014f:	e8 cd 0b 00 00       	call   800d21 <sys_env_destroy>
}
  800154:	83 c4 10             	add    $0x10,%esp
  800157:	c9                   	leave  
  800158:	c3                   	ret    

00800159 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800159:	55                   	push   %ebp
  80015a:	89 e5                	mov    %esp,%ebp
  80015c:	56                   	push   %esi
  80015d:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80015e:	a1 20 40 c0 00       	mov    0xc04020,%eax
  800163:	8b 40 48             	mov    0x48(%eax),%eax
  800166:	83 ec 04             	sub    $0x4,%esp
  800169:	68 80 26 80 00       	push   $0x802680
  80016e:	50                   	push   %eax
  80016f:	68 48 26 80 00       	push   $0x802648
  800174:	e8 d6 00 00 00       	call   80024f <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800179:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80017c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800182:	e8 db 0b 00 00       	call   800d62 <sys_getenvid>
  800187:	83 c4 04             	add    $0x4,%esp
  80018a:	ff 75 0c             	pushl  0xc(%ebp)
  80018d:	ff 75 08             	pushl  0x8(%ebp)
  800190:	56                   	push   %esi
  800191:	50                   	push   %eax
  800192:	68 5c 26 80 00       	push   $0x80265c
  800197:	e8 b3 00 00 00       	call   80024f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80019c:	83 c4 18             	add    $0x18,%esp
  80019f:	53                   	push   %ebx
  8001a0:	ff 75 10             	pushl  0x10(%ebp)
  8001a3:	e8 56 00 00 00       	call   8001fe <vcprintf>
	cprintf("\n");
  8001a8:	c7 04 24 16 26 80 00 	movl   $0x802616,(%esp)
  8001af:	e8 9b 00 00 00       	call   80024f <cprintf>
  8001b4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001b7:	cc                   	int3   
  8001b8:	eb fd                	jmp    8001b7 <_panic+0x5e>

008001ba <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001ba:	55                   	push   %ebp
  8001bb:	89 e5                	mov    %esp,%ebp
  8001bd:	53                   	push   %ebx
  8001be:	83 ec 04             	sub    $0x4,%esp
  8001c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001c4:	8b 13                	mov    (%ebx),%edx
  8001c6:	8d 42 01             	lea    0x1(%edx),%eax
  8001c9:	89 03                	mov    %eax,(%ebx)
  8001cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ce:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001d2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001d7:	74 09                	je     8001e2 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001d9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001e0:	c9                   	leave  
  8001e1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001e2:	83 ec 08             	sub    $0x8,%esp
  8001e5:	68 ff 00 00 00       	push   $0xff
  8001ea:	8d 43 08             	lea    0x8(%ebx),%eax
  8001ed:	50                   	push   %eax
  8001ee:	e8 f1 0a 00 00       	call   800ce4 <sys_cputs>
		b->idx = 0;
  8001f3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001f9:	83 c4 10             	add    $0x10,%esp
  8001fc:	eb db                	jmp    8001d9 <putch+0x1f>

008001fe <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001fe:	55                   	push   %ebp
  8001ff:	89 e5                	mov    %esp,%ebp
  800201:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800207:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80020e:	00 00 00 
	b.cnt = 0;
  800211:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800218:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80021b:	ff 75 0c             	pushl  0xc(%ebp)
  80021e:	ff 75 08             	pushl  0x8(%ebp)
  800221:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800227:	50                   	push   %eax
  800228:	68 ba 01 80 00       	push   $0x8001ba
  80022d:	e8 4a 01 00 00       	call   80037c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800232:	83 c4 08             	add    $0x8,%esp
  800235:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80023b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800241:	50                   	push   %eax
  800242:	e8 9d 0a 00 00       	call   800ce4 <sys_cputs>

	return b.cnt;
}
  800247:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80024d:	c9                   	leave  
  80024e:	c3                   	ret    

0080024f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80024f:	55                   	push   %ebp
  800250:	89 e5                	mov    %esp,%ebp
  800252:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800255:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800258:	50                   	push   %eax
  800259:	ff 75 08             	pushl  0x8(%ebp)
  80025c:	e8 9d ff ff ff       	call   8001fe <vcprintf>
	va_end(ap);

	return cnt;
}
  800261:	c9                   	leave  
  800262:	c3                   	ret    

00800263 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	57                   	push   %edi
  800267:	56                   	push   %esi
  800268:	53                   	push   %ebx
  800269:	83 ec 1c             	sub    $0x1c,%esp
  80026c:	89 c6                	mov    %eax,%esi
  80026e:	89 d7                	mov    %edx,%edi
  800270:	8b 45 08             	mov    0x8(%ebp),%eax
  800273:	8b 55 0c             	mov    0xc(%ebp),%edx
  800276:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800279:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80027c:	8b 45 10             	mov    0x10(%ebp),%eax
  80027f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800282:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800286:	74 2c                	je     8002b4 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800288:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80028b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800292:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800295:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800298:	39 c2                	cmp    %eax,%edx
  80029a:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80029d:	73 43                	jae    8002e2 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80029f:	83 eb 01             	sub    $0x1,%ebx
  8002a2:	85 db                	test   %ebx,%ebx
  8002a4:	7e 6c                	jle    800312 <printnum+0xaf>
				putch(padc, putdat);
  8002a6:	83 ec 08             	sub    $0x8,%esp
  8002a9:	57                   	push   %edi
  8002aa:	ff 75 18             	pushl  0x18(%ebp)
  8002ad:	ff d6                	call   *%esi
  8002af:	83 c4 10             	add    $0x10,%esp
  8002b2:	eb eb                	jmp    80029f <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002b4:	83 ec 0c             	sub    $0xc,%esp
  8002b7:	6a 20                	push   $0x20
  8002b9:	6a 00                	push   $0x0
  8002bb:	50                   	push   %eax
  8002bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bf:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c2:	89 fa                	mov    %edi,%edx
  8002c4:	89 f0                	mov    %esi,%eax
  8002c6:	e8 98 ff ff ff       	call   800263 <printnum>
		while (--width > 0)
  8002cb:	83 c4 20             	add    $0x20,%esp
  8002ce:	83 eb 01             	sub    $0x1,%ebx
  8002d1:	85 db                	test   %ebx,%ebx
  8002d3:	7e 65                	jle    80033a <printnum+0xd7>
			putch(padc, putdat);
  8002d5:	83 ec 08             	sub    $0x8,%esp
  8002d8:	57                   	push   %edi
  8002d9:	6a 20                	push   $0x20
  8002db:	ff d6                	call   *%esi
  8002dd:	83 c4 10             	add    $0x10,%esp
  8002e0:	eb ec                	jmp    8002ce <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002e2:	83 ec 0c             	sub    $0xc,%esp
  8002e5:	ff 75 18             	pushl  0x18(%ebp)
  8002e8:	83 eb 01             	sub    $0x1,%ebx
  8002eb:	53                   	push   %ebx
  8002ec:	50                   	push   %eax
  8002ed:	83 ec 08             	sub    $0x8,%esp
  8002f0:	ff 75 dc             	pushl  -0x24(%ebp)
  8002f3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002f6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f9:	ff 75 e0             	pushl  -0x20(%ebp)
  8002fc:	e8 2f 20 00 00       	call   802330 <__udivdi3>
  800301:	83 c4 18             	add    $0x18,%esp
  800304:	52                   	push   %edx
  800305:	50                   	push   %eax
  800306:	89 fa                	mov    %edi,%edx
  800308:	89 f0                	mov    %esi,%eax
  80030a:	e8 54 ff ff ff       	call   800263 <printnum>
  80030f:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800312:	83 ec 08             	sub    $0x8,%esp
  800315:	57                   	push   %edi
  800316:	83 ec 04             	sub    $0x4,%esp
  800319:	ff 75 dc             	pushl  -0x24(%ebp)
  80031c:	ff 75 d8             	pushl  -0x28(%ebp)
  80031f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800322:	ff 75 e0             	pushl  -0x20(%ebp)
  800325:	e8 16 21 00 00       	call   802440 <__umoddi3>
  80032a:	83 c4 14             	add    $0x14,%esp
  80032d:	0f be 80 87 26 80 00 	movsbl 0x802687(%eax),%eax
  800334:	50                   	push   %eax
  800335:	ff d6                	call   *%esi
  800337:	83 c4 10             	add    $0x10,%esp
	}
}
  80033a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80033d:	5b                   	pop    %ebx
  80033e:	5e                   	pop    %esi
  80033f:	5f                   	pop    %edi
  800340:	5d                   	pop    %ebp
  800341:	c3                   	ret    

00800342 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800342:	55                   	push   %ebp
  800343:	89 e5                	mov    %esp,%ebp
  800345:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800348:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80034c:	8b 10                	mov    (%eax),%edx
  80034e:	3b 50 04             	cmp    0x4(%eax),%edx
  800351:	73 0a                	jae    80035d <sprintputch+0x1b>
		*b->buf++ = ch;
  800353:	8d 4a 01             	lea    0x1(%edx),%ecx
  800356:	89 08                	mov    %ecx,(%eax)
  800358:	8b 45 08             	mov    0x8(%ebp),%eax
  80035b:	88 02                	mov    %al,(%edx)
}
  80035d:	5d                   	pop    %ebp
  80035e:	c3                   	ret    

0080035f <printfmt>:
{
  80035f:	55                   	push   %ebp
  800360:	89 e5                	mov    %esp,%ebp
  800362:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800365:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800368:	50                   	push   %eax
  800369:	ff 75 10             	pushl  0x10(%ebp)
  80036c:	ff 75 0c             	pushl  0xc(%ebp)
  80036f:	ff 75 08             	pushl  0x8(%ebp)
  800372:	e8 05 00 00 00       	call   80037c <vprintfmt>
}
  800377:	83 c4 10             	add    $0x10,%esp
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <vprintfmt>:
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	57                   	push   %edi
  800380:	56                   	push   %esi
  800381:	53                   	push   %ebx
  800382:	83 ec 3c             	sub    $0x3c,%esp
  800385:	8b 75 08             	mov    0x8(%ebp),%esi
  800388:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80038b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80038e:	e9 32 04 00 00       	jmp    8007c5 <vprintfmt+0x449>
		padc = ' ';
  800393:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800397:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80039e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003a5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003ac:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003b3:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003ba:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003bf:	8d 47 01             	lea    0x1(%edi),%eax
  8003c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003c5:	0f b6 17             	movzbl (%edi),%edx
  8003c8:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003cb:	3c 55                	cmp    $0x55,%al
  8003cd:	0f 87 12 05 00 00    	ja     8008e5 <vprintfmt+0x569>
  8003d3:	0f b6 c0             	movzbl %al,%eax
  8003d6:	ff 24 85 60 28 80 00 	jmp    *0x802860(,%eax,4)
  8003dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003e0:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003e4:	eb d9                	jmp    8003bf <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003e9:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003ed:	eb d0                	jmp    8003bf <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003ef:	0f b6 d2             	movzbl %dl,%edx
  8003f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fa:	89 75 08             	mov    %esi,0x8(%ebp)
  8003fd:	eb 03                	jmp    800402 <vprintfmt+0x86>
  8003ff:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800402:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800405:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800409:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80040c:	8d 72 d0             	lea    -0x30(%edx),%esi
  80040f:	83 fe 09             	cmp    $0x9,%esi
  800412:	76 eb                	jbe    8003ff <vprintfmt+0x83>
  800414:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800417:	8b 75 08             	mov    0x8(%ebp),%esi
  80041a:	eb 14                	jmp    800430 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80041c:	8b 45 14             	mov    0x14(%ebp),%eax
  80041f:	8b 00                	mov    (%eax),%eax
  800421:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800424:	8b 45 14             	mov    0x14(%ebp),%eax
  800427:	8d 40 04             	lea    0x4(%eax),%eax
  80042a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80042d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800430:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800434:	79 89                	jns    8003bf <vprintfmt+0x43>
				width = precision, precision = -1;
  800436:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800439:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80043c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800443:	e9 77 ff ff ff       	jmp    8003bf <vprintfmt+0x43>
  800448:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80044b:	85 c0                	test   %eax,%eax
  80044d:	0f 48 c1             	cmovs  %ecx,%eax
  800450:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800453:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800456:	e9 64 ff ff ff       	jmp    8003bf <vprintfmt+0x43>
  80045b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80045e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800465:	e9 55 ff ff ff       	jmp    8003bf <vprintfmt+0x43>
			lflag++;
  80046a:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80046e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800471:	e9 49 ff ff ff       	jmp    8003bf <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800476:	8b 45 14             	mov    0x14(%ebp),%eax
  800479:	8d 78 04             	lea    0x4(%eax),%edi
  80047c:	83 ec 08             	sub    $0x8,%esp
  80047f:	53                   	push   %ebx
  800480:	ff 30                	pushl  (%eax)
  800482:	ff d6                	call   *%esi
			break;
  800484:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800487:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80048a:	e9 33 03 00 00       	jmp    8007c2 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80048f:	8b 45 14             	mov    0x14(%ebp),%eax
  800492:	8d 78 04             	lea    0x4(%eax),%edi
  800495:	8b 00                	mov    (%eax),%eax
  800497:	99                   	cltd   
  800498:	31 d0                	xor    %edx,%eax
  80049a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80049c:	83 f8 11             	cmp    $0x11,%eax
  80049f:	7f 23                	jg     8004c4 <vprintfmt+0x148>
  8004a1:	8b 14 85 c0 29 80 00 	mov    0x8029c0(,%eax,4),%edx
  8004a8:	85 d2                	test   %edx,%edx
  8004aa:	74 18                	je     8004c4 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004ac:	52                   	push   %edx
  8004ad:	68 e1 2a 80 00       	push   $0x802ae1
  8004b2:	53                   	push   %ebx
  8004b3:	56                   	push   %esi
  8004b4:	e8 a6 fe ff ff       	call   80035f <printfmt>
  8004b9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004bc:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004bf:	e9 fe 02 00 00       	jmp    8007c2 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004c4:	50                   	push   %eax
  8004c5:	68 9f 26 80 00       	push   $0x80269f
  8004ca:	53                   	push   %ebx
  8004cb:	56                   	push   %esi
  8004cc:	e8 8e fe ff ff       	call   80035f <printfmt>
  8004d1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004d4:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004d7:	e9 e6 02 00 00       	jmp    8007c2 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004df:	83 c0 04             	add    $0x4,%eax
  8004e2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e8:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004ea:	85 c9                	test   %ecx,%ecx
  8004ec:	b8 98 26 80 00       	mov    $0x802698,%eax
  8004f1:	0f 45 c1             	cmovne %ecx,%eax
  8004f4:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004f7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004fb:	7e 06                	jle    800503 <vprintfmt+0x187>
  8004fd:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800501:	75 0d                	jne    800510 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800503:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800506:	89 c7                	mov    %eax,%edi
  800508:	03 45 e0             	add    -0x20(%ebp),%eax
  80050b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80050e:	eb 53                	jmp    800563 <vprintfmt+0x1e7>
  800510:	83 ec 08             	sub    $0x8,%esp
  800513:	ff 75 d8             	pushl  -0x28(%ebp)
  800516:	50                   	push   %eax
  800517:	e8 71 04 00 00       	call   80098d <strnlen>
  80051c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80051f:	29 c1                	sub    %eax,%ecx
  800521:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800524:	83 c4 10             	add    $0x10,%esp
  800527:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800529:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80052d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800530:	eb 0f                	jmp    800541 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800532:	83 ec 08             	sub    $0x8,%esp
  800535:	53                   	push   %ebx
  800536:	ff 75 e0             	pushl  -0x20(%ebp)
  800539:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80053b:	83 ef 01             	sub    $0x1,%edi
  80053e:	83 c4 10             	add    $0x10,%esp
  800541:	85 ff                	test   %edi,%edi
  800543:	7f ed                	jg     800532 <vprintfmt+0x1b6>
  800545:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800548:	85 c9                	test   %ecx,%ecx
  80054a:	b8 00 00 00 00       	mov    $0x0,%eax
  80054f:	0f 49 c1             	cmovns %ecx,%eax
  800552:	29 c1                	sub    %eax,%ecx
  800554:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800557:	eb aa                	jmp    800503 <vprintfmt+0x187>
					putch(ch, putdat);
  800559:	83 ec 08             	sub    $0x8,%esp
  80055c:	53                   	push   %ebx
  80055d:	52                   	push   %edx
  80055e:	ff d6                	call   *%esi
  800560:	83 c4 10             	add    $0x10,%esp
  800563:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800566:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800568:	83 c7 01             	add    $0x1,%edi
  80056b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80056f:	0f be d0             	movsbl %al,%edx
  800572:	85 d2                	test   %edx,%edx
  800574:	74 4b                	je     8005c1 <vprintfmt+0x245>
  800576:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80057a:	78 06                	js     800582 <vprintfmt+0x206>
  80057c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800580:	78 1e                	js     8005a0 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800582:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800586:	74 d1                	je     800559 <vprintfmt+0x1dd>
  800588:	0f be c0             	movsbl %al,%eax
  80058b:	83 e8 20             	sub    $0x20,%eax
  80058e:	83 f8 5e             	cmp    $0x5e,%eax
  800591:	76 c6                	jbe    800559 <vprintfmt+0x1dd>
					putch('?', putdat);
  800593:	83 ec 08             	sub    $0x8,%esp
  800596:	53                   	push   %ebx
  800597:	6a 3f                	push   $0x3f
  800599:	ff d6                	call   *%esi
  80059b:	83 c4 10             	add    $0x10,%esp
  80059e:	eb c3                	jmp    800563 <vprintfmt+0x1e7>
  8005a0:	89 cf                	mov    %ecx,%edi
  8005a2:	eb 0e                	jmp    8005b2 <vprintfmt+0x236>
				putch(' ', putdat);
  8005a4:	83 ec 08             	sub    $0x8,%esp
  8005a7:	53                   	push   %ebx
  8005a8:	6a 20                	push   $0x20
  8005aa:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005ac:	83 ef 01             	sub    $0x1,%edi
  8005af:	83 c4 10             	add    $0x10,%esp
  8005b2:	85 ff                	test   %edi,%edi
  8005b4:	7f ee                	jg     8005a4 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005b6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005b9:	89 45 14             	mov    %eax,0x14(%ebp)
  8005bc:	e9 01 02 00 00       	jmp    8007c2 <vprintfmt+0x446>
  8005c1:	89 cf                	mov    %ecx,%edi
  8005c3:	eb ed                	jmp    8005b2 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005c8:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005cf:	e9 eb fd ff ff       	jmp    8003bf <vprintfmt+0x43>
	if (lflag >= 2)
  8005d4:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005d8:	7f 21                	jg     8005fb <vprintfmt+0x27f>
	else if (lflag)
  8005da:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005de:	74 68                	je     800648 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	8b 00                	mov    (%eax),%eax
  8005e5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005e8:	89 c1                	mov    %eax,%ecx
  8005ea:	c1 f9 1f             	sar    $0x1f,%ecx
  8005ed:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f3:	8d 40 04             	lea    0x4(%eax),%eax
  8005f6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f9:	eb 17                	jmp    800612 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fe:	8b 50 04             	mov    0x4(%eax),%edx
  800601:	8b 00                	mov    (%eax),%eax
  800603:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800606:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800609:	8b 45 14             	mov    0x14(%ebp),%eax
  80060c:	8d 40 08             	lea    0x8(%eax),%eax
  80060f:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800612:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800615:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800618:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061b:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80061e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800622:	78 3f                	js     800663 <vprintfmt+0x2e7>
			base = 10;
  800624:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800629:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80062d:	0f 84 71 01 00 00    	je     8007a4 <vprintfmt+0x428>
				putch('+', putdat);
  800633:	83 ec 08             	sub    $0x8,%esp
  800636:	53                   	push   %ebx
  800637:	6a 2b                	push   $0x2b
  800639:	ff d6                	call   *%esi
  80063b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80063e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800643:	e9 5c 01 00 00       	jmp    8007a4 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	8b 00                	mov    (%eax),%eax
  80064d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800650:	89 c1                	mov    %eax,%ecx
  800652:	c1 f9 1f             	sar    $0x1f,%ecx
  800655:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	8d 40 04             	lea    0x4(%eax),%eax
  80065e:	89 45 14             	mov    %eax,0x14(%ebp)
  800661:	eb af                	jmp    800612 <vprintfmt+0x296>
				putch('-', putdat);
  800663:	83 ec 08             	sub    $0x8,%esp
  800666:	53                   	push   %ebx
  800667:	6a 2d                	push   $0x2d
  800669:	ff d6                	call   *%esi
				num = -(long long) num;
  80066b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80066e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800671:	f7 d8                	neg    %eax
  800673:	83 d2 00             	adc    $0x0,%edx
  800676:	f7 da                	neg    %edx
  800678:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800681:	b8 0a 00 00 00       	mov    $0xa,%eax
  800686:	e9 19 01 00 00       	jmp    8007a4 <vprintfmt+0x428>
	if (lflag >= 2)
  80068b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80068f:	7f 29                	jg     8006ba <vprintfmt+0x33e>
	else if (lflag)
  800691:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800695:	74 44                	je     8006db <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8b 00                	mov    (%eax),%eax
  80069c:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	8d 40 04             	lea    0x4(%eax),%eax
  8006ad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006b0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b5:	e9 ea 00 00 00       	jmp    8007a4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bd:	8b 50 04             	mov    0x4(%eax),%edx
  8006c0:	8b 00                	mov    (%eax),%eax
  8006c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	8d 40 08             	lea    0x8(%eax),%eax
  8006ce:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006d1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d6:	e9 c9 00 00 00       	jmp    8007a4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	8b 00                	mov    (%eax),%eax
  8006e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	8d 40 04             	lea    0x4(%eax),%eax
  8006f1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006f4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006f9:	e9 a6 00 00 00       	jmp    8007a4 <vprintfmt+0x428>
			putch('0', putdat);
  8006fe:	83 ec 08             	sub    $0x8,%esp
  800701:	53                   	push   %ebx
  800702:	6a 30                	push   $0x30
  800704:	ff d6                	call   *%esi
	if (lflag >= 2)
  800706:	83 c4 10             	add    $0x10,%esp
  800709:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80070d:	7f 26                	jg     800735 <vprintfmt+0x3b9>
	else if (lflag)
  80070f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800713:	74 3e                	je     800753 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	ba 00 00 00 00       	mov    $0x0,%edx
  80071f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800722:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800725:	8b 45 14             	mov    0x14(%ebp),%eax
  800728:	8d 40 04             	lea    0x4(%eax),%eax
  80072b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80072e:	b8 08 00 00 00       	mov    $0x8,%eax
  800733:	eb 6f                	jmp    8007a4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800735:	8b 45 14             	mov    0x14(%ebp),%eax
  800738:	8b 50 04             	mov    0x4(%eax),%edx
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800740:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800743:	8b 45 14             	mov    0x14(%ebp),%eax
  800746:	8d 40 08             	lea    0x8(%eax),%eax
  800749:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80074c:	b8 08 00 00 00       	mov    $0x8,%eax
  800751:	eb 51                	jmp    8007a4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800753:	8b 45 14             	mov    0x14(%ebp),%eax
  800756:	8b 00                	mov    (%eax),%eax
  800758:	ba 00 00 00 00       	mov    $0x0,%edx
  80075d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800760:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800763:	8b 45 14             	mov    0x14(%ebp),%eax
  800766:	8d 40 04             	lea    0x4(%eax),%eax
  800769:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80076c:	b8 08 00 00 00       	mov    $0x8,%eax
  800771:	eb 31                	jmp    8007a4 <vprintfmt+0x428>
			putch('0', putdat);
  800773:	83 ec 08             	sub    $0x8,%esp
  800776:	53                   	push   %ebx
  800777:	6a 30                	push   $0x30
  800779:	ff d6                	call   *%esi
			putch('x', putdat);
  80077b:	83 c4 08             	add    $0x8,%esp
  80077e:	53                   	push   %ebx
  80077f:	6a 78                	push   $0x78
  800781:	ff d6                	call   *%esi
			num = (unsigned long long)
  800783:	8b 45 14             	mov    0x14(%ebp),%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	ba 00 00 00 00       	mov    $0x0,%edx
  80078d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800790:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800793:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800796:	8b 45 14             	mov    0x14(%ebp),%eax
  800799:	8d 40 04             	lea    0x4(%eax),%eax
  80079c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007a4:	83 ec 0c             	sub    $0xc,%esp
  8007a7:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007ab:	52                   	push   %edx
  8007ac:	ff 75 e0             	pushl  -0x20(%ebp)
  8007af:	50                   	push   %eax
  8007b0:	ff 75 dc             	pushl  -0x24(%ebp)
  8007b3:	ff 75 d8             	pushl  -0x28(%ebp)
  8007b6:	89 da                	mov    %ebx,%edx
  8007b8:	89 f0                	mov    %esi,%eax
  8007ba:	e8 a4 fa ff ff       	call   800263 <printnum>
			break;
  8007bf:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c5:	83 c7 01             	add    $0x1,%edi
  8007c8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007cc:	83 f8 25             	cmp    $0x25,%eax
  8007cf:	0f 84 be fb ff ff    	je     800393 <vprintfmt+0x17>
			if (ch == '\0')
  8007d5:	85 c0                	test   %eax,%eax
  8007d7:	0f 84 28 01 00 00    	je     800905 <vprintfmt+0x589>
			putch(ch, putdat);
  8007dd:	83 ec 08             	sub    $0x8,%esp
  8007e0:	53                   	push   %ebx
  8007e1:	50                   	push   %eax
  8007e2:	ff d6                	call   *%esi
  8007e4:	83 c4 10             	add    $0x10,%esp
  8007e7:	eb dc                	jmp    8007c5 <vprintfmt+0x449>
	if (lflag >= 2)
  8007e9:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007ed:	7f 26                	jg     800815 <vprintfmt+0x499>
	else if (lflag)
  8007ef:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007f3:	74 41                	je     800836 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f8:	8b 00                	mov    (%eax),%eax
  8007fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800802:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800805:	8b 45 14             	mov    0x14(%ebp),%eax
  800808:	8d 40 04             	lea    0x4(%eax),%eax
  80080b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80080e:	b8 10 00 00 00       	mov    $0x10,%eax
  800813:	eb 8f                	jmp    8007a4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800815:	8b 45 14             	mov    0x14(%ebp),%eax
  800818:	8b 50 04             	mov    0x4(%eax),%edx
  80081b:	8b 00                	mov    (%eax),%eax
  80081d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800820:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800823:	8b 45 14             	mov    0x14(%ebp),%eax
  800826:	8d 40 08             	lea    0x8(%eax),%eax
  800829:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80082c:	b8 10 00 00 00       	mov    $0x10,%eax
  800831:	e9 6e ff ff ff       	jmp    8007a4 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800836:	8b 45 14             	mov    0x14(%ebp),%eax
  800839:	8b 00                	mov    (%eax),%eax
  80083b:	ba 00 00 00 00       	mov    $0x0,%edx
  800840:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800843:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	8d 40 04             	lea    0x4(%eax),%eax
  80084c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80084f:	b8 10 00 00 00       	mov    $0x10,%eax
  800854:	e9 4b ff ff ff       	jmp    8007a4 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	83 c0 04             	add    $0x4,%eax
  80085f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800862:	8b 45 14             	mov    0x14(%ebp),%eax
  800865:	8b 00                	mov    (%eax),%eax
  800867:	85 c0                	test   %eax,%eax
  800869:	74 14                	je     80087f <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80086b:	8b 13                	mov    (%ebx),%edx
  80086d:	83 fa 7f             	cmp    $0x7f,%edx
  800870:	7f 37                	jg     8008a9 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800872:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800874:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800877:	89 45 14             	mov    %eax,0x14(%ebp)
  80087a:	e9 43 ff ff ff       	jmp    8007c2 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80087f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800884:	bf bd 27 80 00       	mov    $0x8027bd,%edi
							putch(ch, putdat);
  800889:	83 ec 08             	sub    $0x8,%esp
  80088c:	53                   	push   %ebx
  80088d:	50                   	push   %eax
  80088e:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800890:	83 c7 01             	add    $0x1,%edi
  800893:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800897:	83 c4 10             	add    $0x10,%esp
  80089a:	85 c0                	test   %eax,%eax
  80089c:	75 eb                	jne    800889 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80089e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008a1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a4:	e9 19 ff ff ff       	jmp    8007c2 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008a9:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008ab:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008b0:	bf f5 27 80 00       	mov    $0x8027f5,%edi
							putch(ch, putdat);
  8008b5:	83 ec 08             	sub    $0x8,%esp
  8008b8:	53                   	push   %ebx
  8008b9:	50                   	push   %eax
  8008ba:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008bc:	83 c7 01             	add    $0x1,%edi
  8008bf:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008c3:	83 c4 10             	add    $0x10,%esp
  8008c6:	85 c0                	test   %eax,%eax
  8008c8:	75 eb                	jne    8008b5 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d0:	e9 ed fe ff ff       	jmp    8007c2 <vprintfmt+0x446>
			putch(ch, putdat);
  8008d5:	83 ec 08             	sub    $0x8,%esp
  8008d8:	53                   	push   %ebx
  8008d9:	6a 25                	push   $0x25
  8008db:	ff d6                	call   *%esi
			break;
  8008dd:	83 c4 10             	add    $0x10,%esp
  8008e0:	e9 dd fe ff ff       	jmp    8007c2 <vprintfmt+0x446>
			putch('%', putdat);
  8008e5:	83 ec 08             	sub    $0x8,%esp
  8008e8:	53                   	push   %ebx
  8008e9:	6a 25                	push   $0x25
  8008eb:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008ed:	83 c4 10             	add    $0x10,%esp
  8008f0:	89 f8                	mov    %edi,%eax
  8008f2:	eb 03                	jmp    8008f7 <vprintfmt+0x57b>
  8008f4:	83 e8 01             	sub    $0x1,%eax
  8008f7:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008fb:	75 f7                	jne    8008f4 <vprintfmt+0x578>
  8008fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800900:	e9 bd fe ff ff       	jmp    8007c2 <vprintfmt+0x446>
}
  800905:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800908:	5b                   	pop    %ebx
  800909:	5e                   	pop    %esi
  80090a:	5f                   	pop    %edi
  80090b:	5d                   	pop    %ebp
  80090c:	c3                   	ret    

0080090d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80090d:	55                   	push   %ebp
  80090e:	89 e5                	mov    %esp,%ebp
  800910:	83 ec 18             	sub    $0x18,%esp
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800919:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80091c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800920:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800923:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80092a:	85 c0                	test   %eax,%eax
  80092c:	74 26                	je     800954 <vsnprintf+0x47>
  80092e:	85 d2                	test   %edx,%edx
  800930:	7e 22                	jle    800954 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800932:	ff 75 14             	pushl  0x14(%ebp)
  800935:	ff 75 10             	pushl  0x10(%ebp)
  800938:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80093b:	50                   	push   %eax
  80093c:	68 42 03 80 00       	push   $0x800342
  800941:	e8 36 fa ff ff       	call   80037c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800946:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800949:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80094c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80094f:	83 c4 10             	add    $0x10,%esp
}
  800952:	c9                   	leave  
  800953:	c3                   	ret    
		return -E_INVAL;
  800954:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800959:	eb f7                	jmp    800952 <vsnprintf+0x45>

0080095b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800961:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800964:	50                   	push   %eax
  800965:	ff 75 10             	pushl  0x10(%ebp)
  800968:	ff 75 0c             	pushl  0xc(%ebp)
  80096b:	ff 75 08             	pushl  0x8(%ebp)
  80096e:	e8 9a ff ff ff       	call   80090d <vsnprintf>
	va_end(ap);

	return rc;
}
  800973:	c9                   	leave  
  800974:	c3                   	ret    

00800975 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800975:	55                   	push   %ebp
  800976:	89 e5                	mov    %esp,%ebp
  800978:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80097b:	b8 00 00 00 00       	mov    $0x0,%eax
  800980:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800984:	74 05                	je     80098b <strlen+0x16>
		n++;
  800986:	83 c0 01             	add    $0x1,%eax
  800989:	eb f5                	jmp    800980 <strlen+0xb>
	return n;
}
  80098b:	5d                   	pop    %ebp
  80098c:	c3                   	ret    

0080098d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80098d:	55                   	push   %ebp
  80098e:	89 e5                	mov    %esp,%ebp
  800990:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800993:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800996:	ba 00 00 00 00       	mov    $0x0,%edx
  80099b:	39 c2                	cmp    %eax,%edx
  80099d:	74 0d                	je     8009ac <strnlen+0x1f>
  80099f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009a3:	74 05                	je     8009aa <strnlen+0x1d>
		n++;
  8009a5:	83 c2 01             	add    $0x1,%edx
  8009a8:	eb f1                	jmp    80099b <strnlen+0xe>
  8009aa:	89 d0                	mov    %edx,%eax
	return n;
}
  8009ac:	5d                   	pop    %ebp
  8009ad:	c3                   	ret    

008009ae <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009ae:	55                   	push   %ebp
  8009af:	89 e5                	mov    %esp,%ebp
  8009b1:	53                   	push   %ebx
  8009b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8009bd:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009c1:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009c4:	83 c2 01             	add    $0x1,%edx
  8009c7:	84 c9                	test   %cl,%cl
  8009c9:	75 f2                	jne    8009bd <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009cb:	5b                   	pop    %ebx
  8009cc:	5d                   	pop    %ebp
  8009cd:	c3                   	ret    

008009ce <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009ce:	55                   	push   %ebp
  8009cf:	89 e5                	mov    %esp,%ebp
  8009d1:	53                   	push   %ebx
  8009d2:	83 ec 10             	sub    $0x10,%esp
  8009d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009d8:	53                   	push   %ebx
  8009d9:	e8 97 ff ff ff       	call   800975 <strlen>
  8009de:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009e1:	ff 75 0c             	pushl  0xc(%ebp)
  8009e4:	01 d8                	add    %ebx,%eax
  8009e6:	50                   	push   %eax
  8009e7:	e8 c2 ff ff ff       	call   8009ae <strcpy>
	return dst;
}
  8009ec:	89 d8                	mov    %ebx,%eax
  8009ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009f1:	c9                   	leave  
  8009f2:	c3                   	ret    

008009f3 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009f3:	55                   	push   %ebp
  8009f4:	89 e5                	mov    %esp,%ebp
  8009f6:	56                   	push   %esi
  8009f7:	53                   	push   %ebx
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009fe:	89 c6                	mov    %eax,%esi
  800a00:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a03:	89 c2                	mov    %eax,%edx
  800a05:	39 f2                	cmp    %esi,%edx
  800a07:	74 11                	je     800a1a <strncpy+0x27>
		*dst++ = *src;
  800a09:	83 c2 01             	add    $0x1,%edx
  800a0c:	0f b6 19             	movzbl (%ecx),%ebx
  800a0f:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a12:	80 fb 01             	cmp    $0x1,%bl
  800a15:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a18:	eb eb                	jmp    800a05 <strncpy+0x12>
	}
	return ret;
}
  800a1a:	5b                   	pop    %ebx
  800a1b:	5e                   	pop    %esi
  800a1c:	5d                   	pop    %ebp
  800a1d:	c3                   	ret    

00800a1e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	56                   	push   %esi
  800a22:	53                   	push   %ebx
  800a23:	8b 75 08             	mov    0x8(%ebp),%esi
  800a26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a29:	8b 55 10             	mov    0x10(%ebp),%edx
  800a2c:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a2e:	85 d2                	test   %edx,%edx
  800a30:	74 21                	je     800a53 <strlcpy+0x35>
  800a32:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a36:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a38:	39 c2                	cmp    %eax,%edx
  800a3a:	74 14                	je     800a50 <strlcpy+0x32>
  800a3c:	0f b6 19             	movzbl (%ecx),%ebx
  800a3f:	84 db                	test   %bl,%bl
  800a41:	74 0b                	je     800a4e <strlcpy+0x30>
			*dst++ = *src++;
  800a43:	83 c1 01             	add    $0x1,%ecx
  800a46:	83 c2 01             	add    $0x1,%edx
  800a49:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a4c:	eb ea                	jmp    800a38 <strlcpy+0x1a>
  800a4e:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a50:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a53:	29 f0                	sub    %esi,%eax
}
  800a55:	5b                   	pop    %ebx
  800a56:	5e                   	pop    %esi
  800a57:	5d                   	pop    %ebp
  800a58:	c3                   	ret    

00800a59 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a5f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a62:	0f b6 01             	movzbl (%ecx),%eax
  800a65:	84 c0                	test   %al,%al
  800a67:	74 0c                	je     800a75 <strcmp+0x1c>
  800a69:	3a 02                	cmp    (%edx),%al
  800a6b:	75 08                	jne    800a75 <strcmp+0x1c>
		p++, q++;
  800a6d:	83 c1 01             	add    $0x1,%ecx
  800a70:	83 c2 01             	add    $0x1,%edx
  800a73:	eb ed                	jmp    800a62 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a75:	0f b6 c0             	movzbl %al,%eax
  800a78:	0f b6 12             	movzbl (%edx),%edx
  800a7b:	29 d0                	sub    %edx,%eax
}
  800a7d:	5d                   	pop    %ebp
  800a7e:	c3                   	ret    

00800a7f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a7f:	55                   	push   %ebp
  800a80:	89 e5                	mov    %esp,%ebp
  800a82:	53                   	push   %ebx
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a89:	89 c3                	mov    %eax,%ebx
  800a8b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a8e:	eb 06                	jmp    800a96 <strncmp+0x17>
		n--, p++, q++;
  800a90:	83 c0 01             	add    $0x1,%eax
  800a93:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a96:	39 d8                	cmp    %ebx,%eax
  800a98:	74 16                	je     800ab0 <strncmp+0x31>
  800a9a:	0f b6 08             	movzbl (%eax),%ecx
  800a9d:	84 c9                	test   %cl,%cl
  800a9f:	74 04                	je     800aa5 <strncmp+0x26>
  800aa1:	3a 0a                	cmp    (%edx),%cl
  800aa3:	74 eb                	je     800a90 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aa5:	0f b6 00             	movzbl (%eax),%eax
  800aa8:	0f b6 12             	movzbl (%edx),%edx
  800aab:	29 d0                	sub    %edx,%eax
}
  800aad:	5b                   	pop    %ebx
  800aae:	5d                   	pop    %ebp
  800aaf:	c3                   	ret    
		return 0;
  800ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab5:	eb f6                	jmp    800aad <strncmp+0x2e>

00800ab7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ac1:	0f b6 10             	movzbl (%eax),%edx
  800ac4:	84 d2                	test   %dl,%dl
  800ac6:	74 09                	je     800ad1 <strchr+0x1a>
		if (*s == c)
  800ac8:	38 ca                	cmp    %cl,%dl
  800aca:	74 0a                	je     800ad6 <strchr+0x1f>
	for (; *s; s++)
  800acc:	83 c0 01             	add    $0x1,%eax
  800acf:	eb f0                	jmp    800ac1 <strchr+0xa>
			return (char *) s;
	return 0;
  800ad1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ad6:	5d                   	pop    %ebp
  800ad7:	c3                   	ret    

00800ad8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ad8:	55                   	push   %ebp
  800ad9:	89 e5                	mov    %esp,%ebp
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ae2:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ae5:	38 ca                	cmp    %cl,%dl
  800ae7:	74 09                	je     800af2 <strfind+0x1a>
  800ae9:	84 d2                	test   %dl,%dl
  800aeb:	74 05                	je     800af2 <strfind+0x1a>
	for (; *s; s++)
  800aed:	83 c0 01             	add    $0x1,%eax
  800af0:	eb f0                	jmp    800ae2 <strfind+0xa>
			break;
	return (char *) s;
}
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	57                   	push   %edi
  800af8:	56                   	push   %esi
  800af9:	53                   	push   %ebx
  800afa:	8b 7d 08             	mov    0x8(%ebp),%edi
  800afd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b00:	85 c9                	test   %ecx,%ecx
  800b02:	74 31                	je     800b35 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b04:	89 f8                	mov    %edi,%eax
  800b06:	09 c8                	or     %ecx,%eax
  800b08:	a8 03                	test   $0x3,%al
  800b0a:	75 23                	jne    800b2f <memset+0x3b>
		c &= 0xFF;
  800b0c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b10:	89 d3                	mov    %edx,%ebx
  800b12:	c1 e3 08             	shl    $0x8,%ebx
  800b15:	89 d0                	mov    %edx,%eax
  800b17:	c1 e0 18             	shl    $0x18,%eax
  800b1a:	89 d6                	mov    %edx,%esi
  800b1c:	c1 e6 10             	shl    $0x10,%esi
  800b1f:	09 f0                	or     %esi,%eax
  800b21:	09 c2                	or     %eax,%edx
  800b23:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b25:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b28:	89 d0                	mov    %edx,%eax
  800b2a:	fc                   	cld    
  800b2b:	f3 ab                	rep stos %eax,%es:(%edi)
  800b2d:	eb 06                	jmp    800b35 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b32:	fc                   	cld    
  800b33:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b35:	89 f8                	mov    %edi,%eax
  800b37:	5b                   	pop    %ebx
  800b38:	5e                   	pop    %esi
  800b39:	5f                   	pop    %edi
  800b3a:	5d                   	pop    %ebp
  800b3b:	c3                   	ret    

00800b3c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	57                   	push   %edi
  800b40:	56                   	push   %esi
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b47:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b4a:	39 c6                	cmp    %eax,%esi
  800b4c:	73 32                	jae    800b80 <memmove+0x44>
  800b4e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b51:	39 c2                	cmp    %eax,%edx
  800b53:	76 2b                	jbe    800b80 <memmove+0x44>
		s += n;
		d += n;
  800b55:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b58:	89 fe                	mov    %edi,%esi
  800b5a:	09 ce                	or     %ecx,%esi
  800b5c:	09 d6                	or     %edx,%esi
  800b5e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b64:	75 0e                	jne    800b74 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b66:	83 ef 04             	sub    $0x4,%edi
  800b69:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b6c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b6f:	fd                   	std    
  800b70:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b72:	eb 09                	jmp    800b7d <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b74:	83 ef 01             	sub    $0x1,%edi
  800b77:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b7a:	fd                   	std    
  800b7b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b7d:	fc                   	cld    
  800b7e:	eb 1a                	jmp    800b9a <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b80:	89 c2                	mov    %eax,%edx
  800b82:	09 ca                	or     %ecx,%edx
  800b84:	09 f2                	or     %esi,%edx
  800b86:	f6 c2 03             	test   $0x3,%dl
  800b89:	75 0a                	jne    800b95 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b8b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b8e:	89 c7                	mov    %eax,%edi
  800b90:	fc                   	cld    
  800b91:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b93:	eb 05                	jmp    800b9a <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b95:	89 c7                	mov    %eax,%edi
  800b97:	fc                   	cld    
  800b98:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b9a:	5e                   	pop    %esi
  800b9b:	5f                   	pop    %edi
  800b9c:	5d                   	pop    %ebp
  800b9d:	c3                   	ret    

00800b9e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b9e:	55                   	push   %ebp
  800b9f:	89 e5                	mov    %esp,%ebp
  800ba1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ba4:	ff 75 10             	pushl  0x10(%ebp)
  800ba7:	ff 75 0c             	pushl  0xc(%ebp)
  800baa:	ff 75 08             	pushl  0x8(%ebp)
  800bad:	e8 8a ff ff ff       	call   800b3c <memmove>
}
  800bb2:	c9                   	leave  
  800bb3:	c3                   	ret    

00800bb4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	56                   	push   %esi
  800bb8:	53                   	push   %ebx
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbf:	89 c6                	mov    %eax,%esi
  800bc1:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bc4:	39 f0                	cmp    %esi,%eax
  800bc6:	74 1c                	je     800be4 <memcmp+0x30>
		if (*s1 != *s2)
  800bc8:	0f b6 08             	movzbl (%eax),%ecx
  800bcb:	0f b6 1a             	movzbl (%edx),%ebx
  800bce:	38 d9                	cmp    %bl,%cl
  800bd0:	75 08                	jne    800bda <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bd2:	83 c0 01             	add    $0x1,%eax
  800bd5:	83 c2 01             	add    $0x1,%edx
  800bd8:	eb ea                	jmp    800bc4 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bda:	0f b6 c1             	movzbl %cl,%eax
  800bdd:	0f b6 db             	movzbl %bl,%ebx
  800be0:	29 d8                	sub    %ebx,%eax
  800be2:	eb 05                	jmp    800be9 <memcmp+0x35>
	}

	return 0;
  800be4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800be9:	5b                   	pop    %ebx
  800bea:	5e                   	pop    %esi
  800beb:	5d                   	pop    %ebp
  800bec:	c3                   	ret    

00800bed <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bf6:	89 c2                	mov    %eax,%edx
  800bf8:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bfb:	39 d0                	cmp    %edx,%eax
  800bfd:	73 09                	jae    800c08 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bff:	38 08                	cmp    %cl,(%eax)
  800c01:	74 05                	je     800c08 <memfind+0x1b>
	for (; s < ends; s++)
  800c03:	83 c0 01             	add    $0x1,%eax
  800c06:	eb f3                	jmp    800bfb <memfind+0xe>
			break;
	return (void *) s;
}
  800c08:	5d                   	pop    %ebp
  800c09:	c3                   	ret    

00800c0a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	57                   	push   %edi
  800c0e:	56                   	push   %esi
  800c0f:	53                   	push   %ebx
  800c10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c13:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c16:	eb 03                	jmp    800c1b <strtol+0x11>
		s++;
  800c18:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c1b:	0f b6 01             	movzbl (%ecx),%eax
  800c1e:	3c 20                	cmp    $0x20,%al
  800c20:	74 f6                	je     800c18 <strtol+0xe>
  800c22:	3c 09                	cmp    $0x9,%al
  800c24:	74 f2                	je     800c18 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c26:	3c 2b                	cmp    $0x2b,%al
  800c28:	74 2a                	je     800c54 <strtol+0x4a>
	int neg = 0;
  800c2a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c2f:	3c 2d                	cmp    $0x2d,%al
  800c31:	74 2b                	je     800c5e <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c33:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c39:	75 0f                	jne    800c4a <strtol+0x40>
  800c3b:	80 39 30             	cmpb   $0x30,(%ecx)
  800c3e:	74 28                	je     800c68 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c40:	85 db                	test   %ebx,%ebx
  800c42:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c47:	0f 44 d8             	cmove  %eax,%ebx
  800c4a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c4f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c52:	eb 50                	jmp    800ca4 <strtol+0x9a>
		s++;
  800c54:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c57:	bf 00 00 00 00       	mov    $0x0,%edi
  800c5c:	eb d5                	jmp    800c33 <strtol+0x29>
		s++, neg = 1;
  800c5e:	83 c1 01             	add    $0x1,%ecx
  800c61:	bf 01 00 00 00       	mov    $0x1,%edi
  800c66:	eb cb                	jmp    800c33 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c68:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c6c:	74 0e                	je     800c7c <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c6e:	85 db                	test   %ebx,%ebx
  800c70:	75 d8                	jne    800c4a <strtol+0x40>
		s++, base = 8;
  800c72:	83 c1 01             	add    $0x1,%ecx
  800c75:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c7a:	eb ce                	jmp    800c4a <strtol+0x40>
		s += 2, base = 16;
  800c7c:	83 c1 02             	add    $0x2,%ecx
  800c7f:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c84:	eb c4                	jmp    800c4a <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c86:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c89:	89 f3                	mov    %esi,%ebx
  800c8b:	80 fb 19             	cmp    $0x19,%bl
  800c8e:	77 29                	ja     800cb9 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c90:	0f be d2             	movsbl %dl,%edx
  800c93:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c96:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c99:	7d 30                	jge    800ccb <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c9b:	83 c1 01             	add    $0x1,%ecx
  800c9e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ca2:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ca4:	0f b6 11             	movzbl (%ecx),%edx
  800ca7:	8d 72 d0             	lea    -0x30(%edx),%esi
  800caa:	89 f3                	mov    %esi,%ebx
  800cac:	80 fb 09             	cmp    $0x9,%bl
  800caf:	77 d5                	ja     800c86 <strtol+0x7c>
			dig = *s - '0';
  800cb1:	0f be d2             	movsbl %dl,%edx
  800cb4:	83 ea 30             	sub    $0x30,%edx
  800cb7:	eb dd                	jmp    800c96 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800cb9:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cbc:	89 f3                	mov    %esi,%ebx
  800cbe:	80 fb 19             	cmp    $0x19,%bl
  800cc1:	77 08                	ja     800ccb <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cc3:	0f be d2             	movsbl %dl,%edx
  800cc6:	83 ea 37             	sub    $0x37,%edx
  800cc9:	eb cb                	jmp    800c96 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ccb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ccf:	74 05                	je     800cd6 <strtol+0xcc>
		*endptr = (char *) s;
  800cd1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cd4:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cd6:	89 c2                	mov    %eax,%edx
  800cd8:	f7 da                	neg    %edx
  800cda:	85 ff                	test   %edi,%edi
  800cdc:	0f 45 c2             	cmovne %edx,%eax
}
  800cdf:	5b                   	pop    %ebx
  800ce0:	5e                   	pop    %esi
  800ce1:	5f                   	pop    %edi
  800ce2:	5d                   	pop    %ebp
  800ce3:	c3                   	ret    

00800ce4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	57                   	push   %edi
  800ce8:	56                   	push   %esi
  800ce9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cea:	b8 00 00 00 00       	mov    $0x0,%eax
  800cef:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf5:	89 c3                	mov    %eax,%ebx
  800cf7:	89 c7                	mov    %eax,%edi
  800cf9:	89 c6                	mov    %eax,%esi
  800cfb:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cfd:	5b                   	pop    %ebx
  800cfe:	5e                   	pop    %esi
  800cff:	5f                   	pop    %edi
  800d00:	5d                   	pop    %ebp
  800d01:	c3                   	ret    

00800d02 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	57                   	push   %edi
  800d06:	56                   	push   %esi
  800d07:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d08:	ba 00 00 00 00       	mov    $0x0,%edx
  800d0d:	b8 01 00 00 00       	mov    $0x1,%eax
  800d12:	89 d1                	mov    %edx,%ecx
  800d14:	89 d3                	mov    %edx,%ebx
  800d16:	89 d7                	mov    %edx,%edi
  800d18:	89 d6                	mov    %edx,%esi
  800d1a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d1c:	5b                   	pop    %ebx
  800d1d:	5e                   	pop    %esi
  800d1e:	5f                   	pop    %edi
  800d1f:	5d                   	pop    %ebp
  800d20:	c3                   	ret    

00800d21 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d21:	55                   	push   %ebp
  800d22:	89 e5                	mov    %esp,%ebp
  800d24:	57                   	push   %edi
  800d25:	56                   	push   %esi
  800d26:	53                   	push   %ebx
  800d27:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d2a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d32:	b8 03 00 00 00       	mov    $0x3,%eax
  800d37:	89 cb                	mov    %ecx,%ebx
  800d39:	89 cf                	mov    %ecx,%edi
  800d3b:	89 ce                	mov    %ecx,%esi
  800d3d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3f:	85 c0                	test   %eax,%eax
  800d41:	7f 08                	jg     800d4b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d43:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d46:	5b                   	pop    %ebx
  800d47:	5e                   	pop    %esi
  800d48:	5f                   	pop    %edi
  800d49:	5d                   	pop    %ebp
  800d4a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4b:	83 ec 0c             	sub    $0xc,%esp
  800d4e:	50                   	push   %eax
  800d4f:	6a 03                	push   $0x3
  800d51:	68 08 2a 80 00       	push   $0x802a08
  800d56:	6a 43                	push   $0x43
  800d58:	68 25 2a 80 00       	push   $0x802a25
  800d5d:	e8 f7 f3 ff ff       	call   800159 <_panic>

00800d62 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	57                   	push   %edi
  800d66:	56                   	push   %esi
  800d67:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d68:	ba 00 00 00 00       	mov    $0x0,%edx
  800d6d:	b8 02 00 00 00       	mov    $0x2,%eax
  800d72:	89 d1                	mov    %edx,%ecx
  800d74:	89 d3                	mov    %edx,%ebx
  800d76:	89 d7                	mov    %edx,%edi
  800d78:	89 d6                	mov    %edx,%esi
  800d7a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d7c:	5b                   	pop    %ebx
  800d7d:	5e                   	pop    %esi
  800d7e:	5f                   	pop    %edi
  800d7f:	5d                   	pop    %ebp
  800d80:	c3                   	ret    

00800d81 <sys_yield>:

void
sys_yield(void)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	57                   	push   %edi
  800d85:	56                   	push   %esi
  800d86:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d87:	ba 00 00 00 00       	mov    $0x0,%edx
  800d8c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d91:	89 d1                	mov    %edx,%ecx
  800d93:	89 d3                	mov    %edx,%ebx
  800d95:	89 d7                	mov    %edx,%edi
  800d97:	89 d6                	mov    %edx,%esi
  800d99:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d9b:	5b                   	pop    %ebx
  800d9c:	5e                   	pop    %esi
  800d9d:	5f                   	pop    %edi
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    

00800da0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	57                   	push   %edi
  800da4:	56                   	push   %esi
  800da5:	53                   	push   %ebx
  800da6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da9:	be 00 00 00 00       	mov    $0x0,%esi
  800dae:	8b 55 08             	mov    0x8(%ebp),%edx
  800db1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db4:	b8 04 00 00 00       	mov    $0x4,%eax
  800db9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dbc:	89 f7                	mov    %esi,%edi
  800dbe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc0:	85 c0                	test   %eax,%eax
  800dc2:	7f 08                	jg     800dcc <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc7:	5b                   	pop    %ebx
  800dc8:	5e                   	pop    %esi
  800dc9:	5f                   	pop    %edi
  800dca:	5d                   	pop    %ebp
  800dcb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dcc:	83 ec 0c             	sub    $0xc,%esp
  800dcf:	50                   	push   %eax
  800dd0:	6a 04                	push   $0x4
  800dd2:	68 08 2a 80 00       	push   $0x802a08
  800dd7:	6a 43                	push   $0x43
  800dd9:	68 25 2a 80 00       	push   $0x802a25
  800dde:	e8 76 f3 ff ff       	call   800159 <_panic>

00800de3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	57                   	push   %edi
  800de7:	56                   	push   %esi
  800de8:	53                   	push   %ebx
  800de9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dec:	8b 55 08             	mov    0x8(%ebp),%edx
  800def:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df2:	b8 05 00 00 00       	mov    $0x5,%eax
  800df7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dfa:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dfd:	8b 75 18             	mov    0x18(%ebp),%esi
  800e00:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e02:	85 c0                	test   %eax,%eax
  800e04:	7f 08                	jg     800e0e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e09:	5b                   	pop    %ebx
  800e0a:	5e                   	pop    %esi
  800e0b:	5f                   	pop    %edi
  800e0c:	5d                   	pop    %ebp
  800e0d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0e:	83 ec 0c             	sub    $0xc,%esp
  800e11:	50                   	push   %eax
  800e12:	6a 05                	push   $0x5
  800e14:	68 08 2a 80 00       	push   $0x802a08
  800e19:	6a 43                	push   $0x43
  800e1b:	68 25 2a 80 00       	push   $0x802a25
  800e20:	e8 34 f3 ff ff       	call   800159 <_panic>

00800e25 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	57                   	push   %edi
  800e29:	56                   	push   %esi
  800e2a:	53                   	push   %ebx
  800e2b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e2e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e33:	8b 55 08             	mov    0x8(%ebp),%edx
  800e36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e39:	b8 06 00 00 00       	mov    $0x6,%eax
  800e3e:	89 df                	mov    %ebx,%edi
  800e40:	89 de                	mov    %ebx,%esi
  800e42:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e44:	85 c0                	test   %eax,%eax
  800e46:	7f 08                	jg     800e50 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4b:	5b                   	pop    %ebx
  800e4c:	5e                   	pop    %esi
  800e4d:	5f                   	pop    %edi
  800e4e:	5d                   	pop    %ebp
  800e4f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e50:	83 ec 0c             	sub    $0xc,%esp
  800e53:	50                   	push   %eax
  800e54:	6a 06                	push   $0x6
  800e56:	68 08 2a 80 00       	push   $0x802a08
  800e5b:	6a 43                	push   $0x43
  800e5d:	68 25 2a 80 00       	push   $0x802a25
  800e62:	e8 f2 f2 ff ff       	call   800159 <_panic>

00800e67 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	57                   	push   %edi
  800e6b:	56                   	push   %esi
  800e6c:	53                   	push   %ebx
  800e6d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e70:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e75:	8b 55 08             	mov    0x8(%ebp),%edx
  800e78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7b:	b8 08 00 00 00       	mov    $0x8,%eax
  800e80:	89 df                	mov    %ebx,%edi
  800e82:	89 de                	mov    %ebx,%esi
  800e84:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e86:	85 c0                	test   %eax,%eax
  800e88:	7f 08                	jg     800e92 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8d:	5b                   	pop    %ebx
  800e8e:	5e                   	pop    %esi
  800e8f:	5f                   	pop    %edi
  800e90:	5d                   	pop    %ebp
  800e91:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e92:	83 ec 0c             	sub    $0xc,%esp
  800e95:	50                   	push   %eax
  800e96:	6a 08                	push   $0x8
  800e98:	68 08 2a 80 00       	push   $0x802a08
  800e9d:	6a 43                	push   $0x43
  800e9f:	68 25 2a 80 00       	push   $0x802a25
  800ea4:	e8 b0 f2 ff ff       	call   800159 <_panic>

00800ea9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ea9:	55                   	push   %ebp
  800eaa:	89 e5                	mov    %esp,%ebp
  800eac:	57                   	push   %edi
  800ead:	56                   	push   %esi
  800eae:	53                   	push   %ebx
  800eaf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebd:	b8 09 00 00 00       	mov    $0x9,%eax
  800ec2:	89 df                	mov    %ebx,%edi
  800ec4:	89 de                	mov    %ebx,%esi
  800ec6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec8:	85 c0                	test   %eax,%eax
  800eca:	7f 08                	jg     800ed4 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ecc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ecf:	5b                   	pop    %ebx
  800ed0:	5e                   	pop    %esi
  800ed1:	5f                   	pop    %edi
  800ed2:	5d                   	pop    %ebp
  800ed3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed4:	83 ec 0c             	sub    $0xc,%esp
  800ed7:	50                   	push   %eax
  800ed8:	6a 09                	push   $0x9
  800eda:	68 08 2a 80 00       	push   $0x802a08
  800edf:	6a 43                	push   $0x43
  800ee1:	68 25 2a 80 00       	push   $0x802a25
  800ee6:	e8 6e f2 ff ff       	call   800159 <_panic>

00800eeb <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800eeb:	55                   	push   %ebp
  800eec:	89 e5                	mov    %esp,%ebp
  800eee:	57                   	push   %edi
  800eef:	56                   	push   %esi
  800ef0:	53                   	push   %ebx
  800ef1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef9:	8b 55 08             	mov    0x8(%ebp),%edx
  800efc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eff:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f04:	89 df                	mov    %ebx,%edi
  800f06:	89 de                	mov    %ebx,%esi
  800f08:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f0a:	85 c0                	test   %eax,%eax
  800f0c:	7f 08                	jg     800f16 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f11:	5b                   	pop    %ebx
  800f12:	5e                   	pop    %esi
  800f13:	5f                   	pop    %edi
  800f14:	5d                   	pop    %ebp
  800f15:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f16:	83 ec 0c             	sub    $0xc,%esp
  800f19:	50                   	push   %eax
  800f1a:	6a 0a                	push   $0xa
  800f1c:	68 08 2a 80 00       	push   $0x802a08
  800f21:	6a 43                	push   $0x43
  800f23:	68 25 2a 80 00       	push   $0x802a25
  800f28:	e8 2c f2 ff ff       	call   800159 <_panic>

00800f2d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
  800f30:	57                   	push   %edi
  800f31:	56                   	push   %esi
  800f32:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f33:	8b 55 08             	mov    0x8(%ebp),%edx
  800f36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f39:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f3e:	be 00 00 00 00       	mov    $0x0,%esi
  800f43:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f46:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f49:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f4b:	5b                   	pop    %ebx
  800f4c:	5e                   	pop    %esi
  800f4d:	5f                   	pop    %edi
  800f4e:	5d                   	pop    %ebp
  800f4f:	c3                   	ret    

00800f50 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
  800f53:	57                   	push   %edi
  800f54:	56                   	push   %esi
  800f55:	53                   	push   %ebx
  800f56:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f59:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f61:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f66:	89 cb                	mov    %ecx,%ebx
  800f68:	89 cf                	mov    %ecx,%edi
  800f6a:	89 ce                	mov    %ecx,%esi
  800f6c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f6e:	85 c0                	test   %eax,%eax
  800f70:	7f 08                	jg     800f7a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f75:	5b                   	pop    %ebx
  800f76:	5e                   	pop    %esi
  800f77:	5f                   	pop    %edi
  800f78:	5d                   	pop    %ebp
  800f79:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7a:	83 ec 0c             	sub    $0xc,%esp
  800f7d:	50                   	push   %eax
  800f7e:	6a 0d                	push   $0xd
  800f80:	68 08 2a 80 00       	push   $0x802a08
  800f85:	6a 43                	push   $0x43
  800f87:	68 25 2a 80 00       	push   $0x802a25
  800f8c:	e8 c8 f1 ff ff       	call   800159 <_panic>

00800f91 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	57                   	push   %edi
  800f95:	56                   	push   %esi
  800f96:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f97:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa2:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fa7:	89 df                	mov    %ebx,%edi
  800fa9:	89 de                	mov    %ebx,%esi
  800fab:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fad:	5b                   	pop    %ebx
  800fae:	5e                   	pop    %esi
  800faf:	5f                   	pop    %edi
  800fb0:	5d                   	pop    %ebp
  800fb1:	c3                   	ret    

00800fb2 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fb2:	55                   	push   %ebp
  800fb3:	89 e5                	mov    %esp,%ebp
  800fb5:	57                   	push   %edi
  800fb6:	56                   	push   %esi
  800fb7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fb8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc0:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fc5:	89 cb                	mov    %ecx,%ebx
  800fc7:	89 cf                	mov    %ecx,%edi
  800fc9:	89 ce                	mov    %ecx,%esi
  800fcb:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fcd:	5b                   	pop    %ebx
  800fce:	5e                   	pop    %esi
  800fcf:	5f                   	pop    %edi
  800fd0:	5d                   	pop    %ebp
  800fd1:	c3                   	ret    

00800fd2 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	57                   	push   %edi
  800fd6:	56                   	push   %esi
  800fd7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fd8:	ba 00 00 00 00       	mov    $0x0,%edx
  800fdd:	b8 10 00 00 00       	mov    $0x10,%eax
  800fe2:	89 d1                	mov    %edx,%ecx
  800fe4:	89 d3                	mov    %edx,%ebx
  800fe6:	89 d7                	mov    %edx,%edi
  800fe8:	89 d6                	mov    %edx,%esi
  800fea:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fec:	5b                   	pop    %ebx
  800fed:	5e                   	pop    %esi
  800fee:	5f                   	pop    %edi
  800fef:	5d                   	pop    %ebp
  800ff0:	c3                   	ret    

00800ff1 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
  800ff4:	57                   	push   %edi
  800ff5:	56                   	push   %esi
  800ff6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ff7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ffc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801002:	b8 11 00 00 00       	mov    $0x11,%eax
  801007:	89 df                	mov    %ebx,%edi
  801009:	89 de                	mov    %ebx,%esi
  80100b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80100d:	5b                   	pop    %ebx
  80100e:	5e                   	pop    %esi
  80100f:	5f                   	pop    %edi
  801010:	5d                   	pop    %ebp
  801011:	c3                   	ret    

00801012 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
  801015:	57                   	push   %edi
  801016:	56                   	push   %esi
  801017:	53                   	push   %ebx
	asm volatile("int %1\n"
  801018:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101d:	8b 55 08             	mov    0x8(%ebp),%edx
  801020:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801023:	b8 12 00 00 00       	mov    $0x12,%eax
  801028:	89 df                	mov    %ebx,%edi
  80102a:	89 de                	mov    %ebx,%esi
  80102c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80102e:	5b                   	pop    %ebx
  80102f:	5e                   	pop    %esi
  801030:	5f                   	pop    %edi
  801031:	5d                   	pop    %ebp
  801032:	c3                   	ret    

00801033 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	57                   	push   %edi
  801037:	56                   	push   %esi
  801038:	53                   	push   %ebx
  801039:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80103c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801041:	8b 55 08             	mov    0x8(%ebp),%edx
  801044:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801047:	b8 13 00 00 00       	mov    $0x13,%eax
  80104c:	89 df                	mov    %ebx,%edi
  80104e:	89 de                	mov    %ebx,%esi
  801050:	cd 30                	int    $0x30
	if(check && ret > 0)
  801052:	85 c0                	test   %eax,%eax
  801054:	7f 08                	jg     80105e <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801056:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801059:	5b                   	pop    %ebx
  80105a:	5e                   	pop    %esi
  80105b:	5f                   	pop    %edi
  80105c:	5d                   	pop    %ebp
  80105d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80105e:	83 ec 0c             	sub    $0xc,%esp
  801061:	50                   	push   %eax
  801062:	6a 13                	push   $0x13
  801064:	68 08 2a 80 00       	push   $0x802a08
  801069:	6a 43                	push   $0x43
  80106b:	68 25 2a 80 00       	push   $0x802a25
  801070:	e8 e4 f0 ff ff       	call   800159 <_panic>

00801075 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801075:	55                   	push   %ebp
  801076:	89 e5                	mov    %esp,%ebp
  801078:	57                   	push   %edi
  801079:	56                   	push   %esi
  80107a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80107b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801080:	8b 55 08             	mov    0x8(%ebp),%edx
  801083:	b8 14 00 00 00       	mov    $0x14,%eax
  801088:	89 cb                	mov    %ecx,%ebx
  80108a:	89 cf                	mov    %ecx,%edi
  80108c:	89 ce                	mov    %ecx,%esi
  80108e:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801090:	5b                   	pop    %ebx
  801091:	5e                   	pop    %esi
  801092:	5f                   	pop    %edi
  801093:	5d                   	pop    %ebp
  801094:	c3                   	ret    

00801095 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	05 00 00 00 30       	add    $0x30000000,%eax
  8010a0:	c1 e8 0c             	shr    $0xc,%eax
}
  8010a3:	5d                   	pop    %ebp
  8010a4:	c3                   	ret    

008010a5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ab:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010b0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010b5:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010ba:	5d                   	pop    %ebp
  8010bb:	c3                   	ret    

008010bc <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010bc:	55                   	push   %ebp
  8010bd:	89 e5                	mov    %esp,%ebp
  8010bf:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010c4:	89 c2                	mov    %eax,%edx
  8010c6:	c1 ea 16             	shr    $0x16,%edx
  8010c9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010d0:	f6 c2 01             	test   $0x1,%dl
  8010d3:	74 2d                	je     801102 <fd_alloc+0x46>
  8010d5:	89 c2                	mov    %eax,%edx
  8010d7:	c1 ea 0c             	shr    $0xc,%edx
  8010da:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010e1:	f6 c2 01             	test   $0x1,%dl
  8010e4:	74 1c                	je     801102 <fd_alloc+0x46>
  8010e6:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010eb:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010f0:	75 d2                	jne    8010c4 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8010fb:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801100:	eb 0a                	jmp    80110c <fd_alloc+0x50>
			*fd_store = fd;
  801102:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801105:	89 01                	mov    %eax,(%ecx)
			return 0;
  801107:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80110c:	5d                   	pop    %ebp
  80110d:	c3                   	ret    

0080110e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801114:	83 f8 1f             	cmp    $0x1f,%eax
  801117:	77 30                	ja     801149 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801119:	c1 e0 0c             	shl    $0xc,%eax
  80111c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801121:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801127:	f6 c2 01             	test   $0x1,%dl
  80112a:	74 24                	je     801150 <fd_lookup+0x42>
  80112c:	89 c2                	mov    %eax,%edx
  80112e:	c1 ea 0c             	shr    $0xc,%edx
  801131:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801138:	f6 c2 01             	test   $0x1,%dl
  80113b:	74 1a                	je     801157 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80113d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801140:	89 02                	mov    %eax,(%edx)
	return 0;
  801142:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801147:	5d                   	pop    %ebp
  801148:	c3                   	ret    
		return -E_INVAL;
  801149:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80114e:	eb f7                	jmp    801147 <fd_lookup+0x39>
		return -E_INVAL;
  801150:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801155:	eb f0                	jmp    801147 <fd_lookup+0x39>
  801157:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80115c:	eb e9                	jmp    801147 <fd_lookup+0x39>

0080115e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80115e:	55                   	push   %ebp
  80115f:	89 e5                	mov    %esp,%ebp
  801161:	83 ec 08             	sub    $0x8,%esp
  801164:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801167:	ba 00 00 00 00       	mov    $0x0,%edx
  80116c:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801171:	39 08                	cmp    %ecx,(%eax)
  801173:	74 38                	je     8011ad <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801175:	83 c2 01             	add    $0x1,%edx
  801178:	8b 04 95 b4 2a 80 00 	mov    0x802ab4(,%edx,4),%eax
  80117f:	85 c0                	test   %eax,%eax
  801181:	75 ee                	jne    801171 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801183:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801188:	8b 40 48             	mov    0x48(%eax),%eax
  80118b:	83 ec 04             	sub    $0x4,%esp
  80118e:	51                   	push   %ecx
  80118f:	50                   	push   %eax
  801190:	68 34 2a 80 00       	push   $0x802a34
  801195:	e8 b5 f0 ff ff       	call   80024f <cprintf>
	*dev = 0;
  80119a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011a3:	83 c4 10             	add    $0x10,%esp
  8011a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011ab:	c9                   	leave  
  8011ac:	c3                   	ret    
			*dev = devtab[i];
  8011ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8011b7:	eb f2                	jmp    8011ab <dev_lookup+0x4d>

008011b9 <fd_close>:
{
  8011b9:	55                   	push   %ebp
  8011ba:	89 e5                	mov    %esp,%ebp
  8011bc:	57                   	push   %edi
  8011bd:	56                   	push   %esi
  8011be:	53                   	push   %ebx
  8011bf:	83 ec 24             	sub    $0x24,%esp
  8011c2:	8b 75 08             	mov    0x8(%ebp),%esi
  8011c5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011c8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011cb:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011cc:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011d2:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011d5:	50                   	push   %eax
  8011d6:	e8 33 ff ff ff       	call   80110e <fd_lookup>
  8011db:	89 c3                	mov    %eax,%ebx
  8011dd:	83 c4 10             	add    $0x10,%esp
  8011e0:	85 c0                	test   %eax,%eax
  8011e2:	78 05                	js     8011e9 <fd_close+0x30>
	    || fd != fd2)
  8011e4:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011e7:	74 16                	je     8011ff <fd_close+0x46>
		return (must_exist ? r : 0);
  8011e9:	89 f8                	mov    %edi,%eax
  8011eb:	84 c0                	test   %al,%al
  8011ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f2:	0f 44 d8             	cmove  %eax,%ebx
}
  8011f5:	89 d8                	mov    %ebx,%eax
  8011f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011fa:	5b                   	pop    %ebx
  8011fb:	5e                   	pop    %esi
  8011fc:	5f                   	pop    %edi
  8011fd:	5d                   	pop    %ebp
  8011fe:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011ff:	83 ec 08             	sub    $0x8,%esp
  801202:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801205:	50                   	push   %eax
  801206:	ff 36                	pushl  (%esi)
  801208:	e8 51 ff ff ff       	call   80115e <dev_lookup>
  80120d:	89 c3                	mov    %eax,%ebx
  80120f:	83 c4 10             	add    $0x10,%esp
  801212:	85 c0                	test   %eax,%eax
  801214:	78 1a                	js     801230 <fd_close+0x77>
		if (dev->dev_close)
  801216:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801219:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80121c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801221:	85 c0                	test   %eax,%eax
  801223:	74 0b                	je     801230 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801225:	83 ec 0c             	sub    $0xc,%esp
  801228:	56                   	push   %esi
  801229:	ff d0                	call   *%eax
  80122b:	89 c3                	mov    %eax,%ebx
  80122d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801230:	83 ec 08             	sub    $0x8,%esp
  801233:	56                   	push   %esi
  801234:	6a 00                	push   $0x0
  801236:	e8 ea fb ff ff       	call   800e25 <sys_page_unmap>
	return r;
  80123b:	83 c4 10             	add    $0x10,%esp
  80123e:	eb b5                	jmp    8011f5 <fd_close+0x3c>

00801240 <close>:

int
close(int fdnum)
{
  801240:	55                   	push   %ebp
  801241:	89 e5                	mov    %esp,%ebp
  801243:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801246:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801249:	50                   	push   %eax
  80124a:	ff 75 08             	pushl  0x8(%ebp)
  80124d:	e8 bc fe ff ff       	call   80110e <fd_lookup>
  801252:	83 c4 10             	add    $0x10,%esp
  801255:	85 c0                	test   %eax,%eax
  801257:	79 02                	jns    80125b <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801259:	c9                   	leave  
  80125a:	c3                   	ret    
		return fd_close(fd, 1);
  80125b:	83 ec 08             	sub    $0x8,%esp
  80125e:	6a 01                	push   $0x1
  801260:	ff 75 f4             	pushl  -0xc(%ebp)
  801263:	e8 51 ff ff ff       	call   8011b9 <fd_close>
  801268:	83 c4 10             	add    $0x10,%esp
  80126b:	eb ec                	jmp    801259 <close+0x19>

0080126d <close_all>:

void
close_all(void)
{
  80126d:	55                   	push   %ebp
  80126e:	89 e5                	mov    %esp,%ebp
  801270:	53                   	push   %ebx
  801271:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801274:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801279:	83 ec 0c             	sub    $0xc,%esp
  80127c:	53                   	push   %ebx
  80127d:	e8 be ff ff ff       	call   801240 <close>
	for (i = 0; i < MAXFD; i++)
  801282:	83 c3 01             	add    $0x1,%ebx
  801285:	83 c4 10             	add    $0x10,%esp
  801288:	83 fb 20             	cmp    $0x20,%ebx
  80128b:	75 ec                	jne    801279 <close_all+0xc>
}
  80128d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801290:	c9                   	leave  
  801291:	c3                   	ret    

00801292 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
  801295:	57                   	push   %edi
  801296:	56                   	push   %esi
  801297:	53                   	push   %ebx
  801298:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80129b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80129e:	50                   	push   %eax
  80129f:	ff 75 08             	pushl  0x8(%ebp)
  8012a2:	e8 67 fe ff ff       	call   80110e <fd_lookup>
  8012a7:	89 c3                	mov    %eax,%ebx
  8012a9:	83 c4 10             	add    $0x10,%esp
  8012ac:	85 c0                	test   %eax,%eax
  8012ae:	0f 88 81 00 00 00    	js     801335 <dup+0xa3>
		return r;
	close(newfdnum);
  8012b4:	83 ec 0c             	sub    $0xc,%esp
  8012b7:	ff 75 0c             	pushl  0xc(%ebp)
  8012ba:	e8 81 ff ff ff       	call   801240 <close>

	newfd = INDEX2FD(newfdnum);
  8012bf:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012c2:	c1 e6 0c             	shl    $0xc,%esi
  8012c5:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012cb:	83 c4 04             	add    $0x4,%esp
  8012ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012d1:	e8 cf fd ff ff       	call   8010a5 <fd2data>
  8012d6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012d8:	89 34 24             	mov    %esi,(%esp)
  8012db:	e8 c5 fd ff ff       	call   8010a5 <fd2data>
  8012e0:	83 c4 10             	add    $0x10,%esp
  8012e3:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012e5:	89 d8                	mov    %ebx,%eax
  8012e7:	c1 e8 16             	shr    $0x16,%eax
  8012ea:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012f1:	a8 01                	test   $0x1,%al
  8012f3:	74 11                	je     801306 <dup+0x74>
  8012f5:	89 d8                	mov    %ebx,%eax
  8012f7:	c1 e8 0c             	shr    $0xc,%eax
  8012fa:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801301:	f6 c2 01             	test   $0x1,%dl
  801304:	75 39                	jne    80133f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801306:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801309:	89 d0                	mov    %edx,%eax
  80130b:	c1 e8 0c             	shr    $0xc,%eax
  80130e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801315:	83 ec 0c             	sub    $0xc,%esp
  801318:	25 07 0e 00 00       	and    $0xe07,%eax
  80131d:	50                   	push   %eax
  80131e:	56                   	push   %esi
  80131f:	6a 00                	push   $0x0
  801321:	52                   	push   %edx
  801322:	6a 00                	push   $0x0
  801324:	e8 ba fa ff ff       	call   800de3 <sys_page_map>
  801329:	89 c3                	mov    %eax,%ebx
  80132b:	83 c4 20             	add    $0x20,%esp
  80132e:	85 c0                	test   %eax,%eax
  801330:	78 31                	js     801363 <dup+0xd1>
		goto err;

	return newfdnum;
  801332:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801335:	89 d8                	mov    %ebx,%eax
  801337:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80133a:	5b                   	pop    %ebx
  80133b:	5e                   	pop    %esi
  80133c:	5f                   	pop    %edi
  80133d:	5d                   	pop    %ebp
  80133e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80133f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801346:	83 ec 0c             	sub    $0xc,%esp
  801349:	25 07 0e 00 00       	and    $0xe07,%eax
  80134e:	50                   	push   %eax
  80134f:	57                   	push   %edi
  801350:	6a 00                	push   $0x0
  801352:	53                   	push   %ebx
  801353:	6a 00                	push   $0x0
  801355:	e8 89 fa ff ff       	call   800de3 <sys_page_map>
  80135a:	89 c3                	mov    %eax,%ebx
  80135c:	83 c4 20             	add    $0x20,%esp
  80135f:	85 c0                	test   %eax,%eax
  801361:	79 a3                	jns    801306 <dup+0x74>
	sys_page_unmap(0, newfd);
  801363:	83 ec 08             	sub    $0x8,%esp
  801366:	56                   	push   %esi
  801367:	6a 00                	push   $0x0
  801369:	e8 b7 fa ff ff       	call   800e25 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80136e:	83 c4 08             	add    $0x8,%esp
  801371:	57                   	push   %edi
  801372:	6a 00                	push   $0x0
  801374:	e8 ac fa ff ff       	call   800e25 <sys_page_unmap>
	return r;
  801379:	83 c4 10             	add    $0x10,%esp
  80137c:	eb b7                	jmp    801335 <dup+0xa3>

0080137e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
  801381:	53                   	push   %ebx
  801382:	83 ec 1c             	sub    $0x1c,%esp
  801385:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801388:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80138b:	50                   	push   %eax
  80138c:	53                   	push   %ebx
  80138d:	e8 7c fd ff ff       	call   80110e <fd_lookup>
  801392:	83 c4 10             	add    $0x10,%esp
  801395:	85 c0                	test   %eax,%eax
  801397:	78 3f                	js     8013d8 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801399:	83 ec 08             	sub    $0x8,%esp
  80139c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80139f:	50                   	push   %eax
  8013a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a3:	ff 30                	pushl  (%eax)
  8013a5:	e8 b4 fd ff ff       	call   80115e <dev_lookup>
  8013aa:	83 c4 10             	add    $0x10,%esp
  8013ad:	85 c0                	test   %eax,%eax
  8013af:	78 27                	js     8013d8 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013b4:	8b 42 08             	mov    0x8(%edx),%eax
  8013b7:	83 e0 03             	and    $0x3,%eax
  8013ba:	83 f8 01             	cmp    $0x1,%eax
  8013bd:	74 1e                	je     8013dd <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c2:	8b 40 08             	mov    0x8(%eax),%eax
  8013c5:	85 c0                	test   %eax,%eax
  8013c7:	74 35                	je     8013fe <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013c9:	83 ec 04             	sub    $0x4,%esp
  8013cc:	ff 75 10             	pushl  0x10(%ebp)
  8013cf:	ff 75 0c             	pushl  0xc(%ebp)
  8013d2:	52                   	push   %edx
  8013d3:	ff d0                	call   *%eax
  8013d5:	83 c4 10             	add    $0x10,%esp
}
  8013d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013db:	c9                   	leave  
  8013dc:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013dd:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8013e2:	8b 40 48             	mov    0x48(%eax),%eax
  8013e5:	83 ec 04             	sub    $0x4,%esp
  8013e8:	53                   	push   %ebx
  8013e9:	50                   	push   %eax
  8013ea:	68 78 2a 80 00       	push   $0x802a78
  8013ef:	e8 5b ee ff ff       	call   80024f <cprintf>
		return -E_INVAL;
  8013f4:	83 c4 10             	add    $0x10,%esp
  8013f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013fc:	eb da                	jmp    8013d8 <read+0x5a>
		return -E_NOT_SUPP;
  8013fe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801403:	eb d3                	jmp    8013d8 <read+0x5a>

00801405 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
  801408:	57                   	push   %edi
  801409:	56                   	push   %esi
  80140a:	53                   	push   %ebx
  80140b:	83 ec 0c             	sub    $0xc,%esp
  80140e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801411:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801414:	bb 00 00 00 00       	mov    $0x0,%ebx
  801419:	39 f3                	cmp    %esi,%ebx
  80141b:	73 23                	jae    801440 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80141d:	83 ec 04             	sub    $0x4,%esp
  801420:	89 f0                	mov    %esi,%eax
  801422:	29 d8                	sub    %ebx,%eax
  801424:	50                   	push   %eax
  801425:	89 d8                	mov    %ebx,%eax
  801427:	03 45 0c             	add    0xc(%ebp),%eax
  80142a:	50                   	push   %eax
  80142b:	57                   	push   %edi
  80142c:	e8 4d ff ff ff       	call   80137e <read>
		if (m < 0)
  801431:	83 c4 10             	add    $0x10,%esp
  801434:	85 c0                	test   %eax,%eax
  801436:	78 06                	js     80143e <readn+0x39>
			return m;
		if (m == 0)
  801438:	74 06                	je     801440 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80143a:	01 c3                	add    %eax,%ebx
  80143c:	eb db                	jmp    801419 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80143e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801440:	89 d8                	mov    %ebx,%eax
  801442:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801445:	5b                   	pop    %ebx
  801446:	5e                   	pop    %esi
  801447:	5f                   	pop    %edi
  801448:	5d                   	pop    %ebp
  801449:	c3                   	ret    

0080144a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80144a:	55                   	push   %ebp
  80144b:	89 e5                	mov    %esp,%ebp
  80144d:	53                   	push   %ebx
  80144e:	83 ec 1c             	sub    $0x1c,%esp
  801451:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801454:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801457:	50                   	push   %eax
  801458:	53                   	push   %ebx
  801459:	e8 b0 fc ff ff       	call   80110e <fd_lookup>
  80145e:	83 c4 10             	add    $0x10,%esp
  801461:	85 c0                	test   %eax,%eax
  801463:	78 3a                	js     80149f <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801465:	83 ec 08             	sub    $0x8,%esp
  801468:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80146b:	50                   	push   %eax
  80146c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80146f:	ff 30                	pushl  (%eax)
  801471:	e8 e8 fc ff ff       	call   80115e <dev_lookup>
  801476:	83 c4 10             	add    $0x10,%esp
  801479:	85 c0                	test   %eax,%eax
  80147b:	78 22                	js     80149f <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80147d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801480:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801484:	74 1e                	je     8014a4 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801486:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801489:	8b 52 0c             	mov    0xc(%edx),%edx
  80148c:	85 d2                	test   %edx,%edx
  80148e:	74 35                	je     8014c5 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801490:	83 ec 04             	sub    $0x4,%esp
  801493:	ff 75 10             	pushl  0x10(%ebp)
  801496:	ff 75 0c             	pushl  0xc(%ebp)
  801499:	50                   	push   %eax
  80149a:	ff d2                	call   *%edx
  80149c:	83 c4 10             	add    $0x10,%esp
}
  80149f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014a2:	c9                   	leave  
  8014a3:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014a4:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8014a9:	8b 40 48             	mov    0x48(%eax),%eax
  8014ac:	83 ec 04             	sub    $0x4,%esp
  8014af:	53                   	push   %ebx
  8014b0:	50                   	push   %eax
  8014b1:	68 94 2a 80 00       	push   $0x802a94
  8014b6:	e8 94 ed ff ff       	call   80024f <cprintf>
		return -E_INVAL;
  8014bb:	83 c4 10             	add    $0x10,%esp
  8014be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014c3:	eb da                	jmp    80149f <write+0x55>
		return -E_NOT_SUPP;
  8014c5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014ca:	eb d3                	jmp    80149f <write+0x55>

008014cc <seek>:

int
seek(int fdnum, off_t offset)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d5:	50                   	push   %eax
  8014d6:	ff 75 08             	pushl  0x8(%ebp)
  8014d9:	e8 30 fc ff ff       	call   80110e <fd_lookup>
  8014de:	83 c4 10             	add    $0x10,%esp
  8014e1:	85 c0                	test   %eax,%eax
  8014e3:	78 0e                	js     8014f3 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014eb:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014f3:	c9                   	leave  
  8014f4:	c3                   	ret    

008014f5 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
  8014f8:	53                   	push   %ebx
  8014f9:	83 ec 1c             	sub    $0x1c,%esp
  8014fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ff:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801502:	50                   	push   %eax
  801503:	53                   	push   %ebx
  801504:	e8 05 fc ff ff       	call   80110e <fd_lookup>
  801509:	83 c4 10             	add    $0x10,%esp
  80150c:	85 c0                	test   %eax,%eax
  80150e:	78 37                	js     801547 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801510:	83 ec 08             	sub    $0x8,%esp
  801513:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801516:	50                   	push   %eax
  801517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151a:	ff 30                	pushl  (%eax)
  80151c:	e8 3d fc ff ff       	call   80115e <dev_lookup>
  801521:	83 c4 10             	add    $0x10,%esp
  801524:	85 c0                	test   %eax,%eax
  801526:	78 1f                	js     801547 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801528:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80152f:	74 1b                	je     80154c <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801531:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801534:	8b 52 18             	mov    0x18(%edx),%edx
  801537:	85 d2                	test   %edx,%edx
  801539:	74 32                	je     80156d <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80153b:	83 ec 08             	sub    $0x8,%esp
  80153e:	ff 75 0c             	pushl  0xc(%ebp)
  801541:	50                   	push   %eax
  801542:	ff d2                	call   *%edx
  801544:	83 c4 10             	add    $0x10,%esp
}
  801547:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80154a:	c9                   	leave  
  80154b:	c3                   	ret    
			thisenv->env_id, fdnum);
  80154c:	a1 20 40 c0 00       	mov    0xc04020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801551:	8b 40 48             	mov    0x48(%eax),%eax
  801554:	83 ec 04             	sub    $0x4,%esp
  801557:	53                   	push   %ebx
  801558:	50                   	push   %eax
  801559:	68 54 2a 80 00       	push   $0x802a54
  80155e:	e8 ec ec ff ff       	call   80024f <cprintf>
		return -E_INVAL;
  801563:	83 c4 10             	add    $0x10,%esp
  801566:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80156b:	eb da                	jmp    801547 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80156d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801572:	eb d3                	jmp    801547 <ftruncate+0x52>

00801574 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
  801577:	53                   	push   %ebx
  801578:	83 ec 1c             	sub    $0x1c,%esp
  80157b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80157e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801581:	50                   	push   %eax
  801582:	ff 75 08             	pushl  0x8(%ebp)
  801585:	e8 84 fb ff ff       	call   80110e <fd_lookup>
  80158a:	83 c4 10             	add    $0x10,%esp
  80158d:	85 c0                	test   %eax,%eax
  80158f:	78 4b                	js     8015dc <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801591:	83 ec 08             	sub    $0x8,%esp
  801594:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801597:	50                   	push   %eax
  801598:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159b:	ff 30                	pushl  (%eax)
  80159d:	e8 bc fb ff ff       	call   80115e <dev_lookup>
  8015a2:	83 c4 10             	add    $0x10,%esp
  8015a5:	85 c0                	test   %eax,%eax
  8015a7:	78 33                	js     8015dc <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ac:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015b0:	74 2f                	je     8015e1 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015b2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015b5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015bc:	00 00 00 
	stat->st_isdir = 0;
  8015bf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015c6:	00 00 00 
	stat->st_dev = dev;
  8015c9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015cf:	83 ec 08             	sub    $0x8,%esp
  8015d2:	53                   	push   %ebx
  8015d3:	ff 75 f0             	pushl  -0x10(%ebp)
  8015d6:	ff 50 14             	call   *0x14(%eax)
  8015d9:	83 c4 10             	add    $0x10,%esp
}
  8015dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015df:	c9                   	leave  
  8015e0:	c3                   	ret    
		return -E_NOT_SUPP;
  8015e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015e6:	eb f4                	jmp    8015dc <fstat+0x68>

008015e8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015e8:	55                   	push   %ebp
  8015e9:	89 e5                	mov    %esp,%ebp
  8015eb:	56                   	push   %esi
  8015ec:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015ed:	83 ec 08             	sub    $0x8,%esp
  8015f0:	6a 00                	push   $0x0
  8015f2:	ff 75 08             	pushl  0x8(%ebp)
  8015f5:	e8 22 02 00 00       	call   80181c <open>
  8015fa:	89 c3                	mov    %eax,%ebx
  8015fc:	83 c4 10             	add    $0x10,%esp
  8015ff:	85 c0                	test   %eax,%eax
  801601:	78 1b                	js     80161e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801603:	83 ec 08             	sub    $0x8,%esp
  801606:	ff 75 0c             	pushl  0xc(%ebp)
  801609:	50                   	push   %eax
  80160a:	e8 65 ff ff ff       	call   801574 <fstat>
  80160f:	89 c6                	mov    %eax,%esi
	close(fd);
  801611:	89 1c 24             	mov    %ebx,(%esp)
  801614:	e8 27 fc ff ff       	call   801240 <close>
	return r;
  801619:	83 c4 10             	add    $0x10,%esp
  80161c:	89 f3                	mov    %esi,%ebx
}
  80161e:	89 d8                	mov    %ebx,%eax
  801620:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801623:	5b                   	pop    %ebx
  801624:	5e                   	pop    %esi
  801625:	5d                   	pop    %ebp
  801626:	c3                   	ret    

00801627 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
  80162a:	56                   	push   %esi
  80162b:	53                   	push   %ebx
  80162c:	89 c6                	mov    %eax,%esi
  80162e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801630:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801637:	74 27                	je     801660 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801639:	6a 07                	push   $0x7
  80163b:	68 00 50 c0 00       	push   $0xc05000
  801640:	56                   	push   %esi
  801641:	ff 35 00 40 80 00    	pushl  0x804000
  801647:	e8 08 0c 00 00       	call   802254 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80164c:	83 c4 0c             	add    $0xc,%esp
  80164f:	6a 00                	push   $0x0
  801651:	53                   	push   %ebx
  801652:	6a 00                	push   $0x0
  801654:	e8 92 0b 00 00       	call   8021eb <ipc_recv>
}
  801659:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80165c:	5b                   	pop    %ebx
  80165d:	5e                   	pop    %esi
  80165e:	5d                   	pop    %ebp
  80165f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801660:	83 ec 0c             	sub    $0xc,%esp
  801663:	6a 01                	push   $0x1
  801665:	e8 42 0c 00 00       	call   8022ac <ipc_find_env>
  80166a:	a3 00 40 80 00       	mov    %eax,0x804000
  80166f:	83 c4 10             	add    $0x10,%esp
  801672:	eb c5                	jmp    801639 <fsipc+0x12>

00801674 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
  801677:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	8b 40 0c             	mov    0xc(%eax),%eax
  801680:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.set_size.req_size = newsize;
  801685:	8b 45 0c             	mov    0xc(%ebp),%eax
  801688:	a3 04 50 c0 00       	mov    %eax,0xc05004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80168d:	ba 00 00 00 00       	mov    $0x0,%edx
  801692:	b8 02 00 00 00       	mov    $0x2,%eax
  801697:	e8 8b ff ff ff       	call   801627 <fsipc>
}
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <devfile_flush>:
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8016aa:	a3 00 50 c0 00       	mov    %eax,0xc05000
	return fsipc(FSREQ_FLUSH, NULL);
  8016af:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b4:	b8 06 00 00 00       	mov    $0x6,%eax
  8016b9:	e8 69 ff ff ff       	call   801627 <fsipc>
}
  8016be:	c9                   	leave  
  8016bf:	c3                   	ret    

008016c0 <devfile_stat>:
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	53                   	push   %ebx
  8016c4:	83 ec 04             	sub    $0x4,%esp
  8016c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8016d0:	a3 00 50 c0 00       	mov    %eax,0xc05000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8016da:	b8 05 00 00 00       	mov    $0x5,%eax
  8016df:	e8 43 ff ff ff       	call   801627 <fsipc>
  8016e4:	85 c0                	test   %eax,%eax
  8016e6:	78 2c                	js     801714 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016e8:	83 ec 08             	sub    $0x8,%esp
  8016eb:	68 00 50 c0 00       	push   $0xc05000
  8016f0:	53                   	push   %ebx
  8016f1:	e8 b8 f2 ff ff       	call   8009ae <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016f6:	a1 80 50 c0 00       	mov    0xc05080,%eax
  8016fb:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801701:	a1 84 50 c0 00       	mov    0xc05084,%eax
  801706:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80170c:	83 c4 10             	add    $0x10,%esp
  80170f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801714:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801717:	c9                   	leave  
  801718:	c3                   	ret    

00801719 <devfile_write>:
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	53                   	push   %ebx
  80171d:	83 ec 08             	sub    $0x8,%esp
  801720:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	8b 40 0c             	mov    0xc(%eax),%eax
  801729:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.write.req_n = n;
  80172e:	89 1d 04 50 c0 00    	mov    %ebx,0xc05004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801734:	53                   	push   %ebx
  801735:	ff 75 0c             	pushl  0xc(%ebp)
  801738:	68 08 50 c0 00       	push   $0xc05008
  80173d:	e8 5c f4 ff ff       	call   800b9e <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801742:	ba 00 00 00 00       	mov    $0x0,%edx
  801747:	b8 04 00 00 00       	mov    $0x4,%eax
  80174c:	e8 d6 fe ff ff       	call   801627 <fsipc>
  801751:	83 c4 10             	add    $0x10,%esp
  801754:	85 c0                	test   %eax,%eax
  801756:	78 0b                	js     801763 <devfile_write+0x4a>
	assert(r <= n);
  801758:	39 d8                	cmp    %ebx,%eax
  80175a:	77 0c                	ja     801768 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80175c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801761:	7f 1e                	jg     801781 <devfile_write+0x68>
}
  801763:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801766:	c9                   	leave  
  801767:	c3                   	ret    
	assert(r <= n);
  801768:	68 c8 2a 80 00       	push   $0x802ac8
  80176d:	68 cf 2a 80 00       	push   $0x802acf
  801772:	68 98 00 00 00       	push   $0x98
  801777:	68 e4 2a 80 00       	push   $0x802ae4
  80177c:	e8 d8 e9 ff ff       	call   800159 <_panic>
	assert(r <= PGSIZE);
  801781:	68 ef 2a 80 00       	push   $0x802aef
  801786:	68 cf 2a 80 00       	push   $0x802acf
  80178b:	68 99 00 00 00       	push   $0x99
  801790:	68 e4 2a 80 00       	push   $0x802ae4
  801795:	e8 bf e9 ff ff       	call   800159 <_panic>

0080179a <devfile_read>:
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	56                   	push   %esi
  80179e:	53                   	push   %ebx
  80179f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8017a8:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.read.req_n = n;
  8017ad:	89 35 04 50 c0 00    	mov    %esi,0xc05004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b8:	b8 03 00 00 00       	mov    $0x3,%eax
  8017bd:	e8 65 fe ff ff       	call   801627 <fsipc>
  8017c2:	89 c3                	mov    %eax,%ebx
  8017c4:	85 c0                	test   %eax,%eax
  8017c6:	78 1f                	js     8017e7 <devfile_read+0x4d>
	assert(r <= n);
  8017c8:	39 f0                	cmp    %esi,%eax
  8017ca:	77 24                	ja     8017f0 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017cc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017d1:	7f 33                	jg     801806 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017d3:	83 ec 04             	sub    $0x4,%esp
  8017d6:	50                   	push   %eax
  8017d7:	68 00 50 c0 00       	push   $0xc05000
  8017dc:	ff 75 0c             	pushl  0xc(%ebp)
  8017df:	e8 58 f3 ff ff       	call   800b3c <memmove>
	return r;
  8017e4:	83 c4 10             	add    $0x10,%esp
}
  8017e7:	89 d8                	mov    %ebx,%eax
  8017e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ec:	5b                   	pop    %ebx
  8017ed:	5e                   	pop    %esi
  8017ee:	5d                   	pop    %ebp
  8017ef:	c3                   	ret    
	assert(r <= n);
  8017f0:	68 c8 2a 80 00       	push   $0x802ac8
  8017f5:	68 cf 2a 80 00       	push   $0x802acf
  8017fa:	6a 7c                	push   $0x7c
  8017fc:	68 e4 2a 80 00       	push   $0x802ae4
  801801:	e8 53 e9 ff ff       	call   800159 <_panic>
	assert(r <= PGSIZE);
  801806:	68 ef 2a 80 00       	push   $0x802aef
  80180b:	68 cf 2a 80 00       	push   $0x802acf
  801810:	6a 7d                	push   $0x7d
  801812:	68 e4 2a 80 00       	push   $0x802ae4
  801817:	e8 3d e9 ff ff       	call   800159 <_panic>

0080181c <open>:
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	56                   	push   %esi
  801820:	53                   	push   %ebx
  801821:	83 ec 1c             	sub    $0x1c,%esp
  801824:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801827:	56                   	push   %esi
  801828:	e8 48 f1 ff ff       	call   800975 <strlen>
  80182d:	83 c4 10             	add    $0x10,%esp
  801830:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801835:	7f 6c                	jg     8018a3 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801837:	83 ec 0c             	sub    $0xc,%esp
  80183a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80183d:	50                   	push   %eax
  80183e:	e8 79 f8 ff ff       	call   8010bc <fd_alloc>
  801843:	89 c3                	mov    %eax,%ebx
  801845:	83 c4 10             	add    $0x10,%esp
  801848:	85 c0                	test   %eax,%eax
  80184a:	78 3c                	js     801888 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80184c:	83 ec 08             	sub    $0x8,%esp
  80184f:	56                   	push   %esi
  801850:	68 00 50 c0 00       	push   $0xc05000
  801855:	e8 54 f1 ff ff       	call   8009ae <strcpy>
	fsipcbuf.open.req_omode = mode;
  80185a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185d:	a3 00 54 c0 00       	mov    %eax,0xc05400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801862:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801865:	b8 01 00 00 00       	mov    $0x1,%eax
  80186a:	e8 b8 fd ff ff       	call   801627 <fsipc>
  80186f:	89 c3                	mov    %eax,%ebx
  801871:	83 c4 10             	add    $0x10,%esp
  801874:	85 c0                	test   %eax,%eax
  801876:	78 19                	js     801891 <open+0x75>
	return fd2num(fd);
  801878:	83 ec 0c             	sub    $0xc,%esp
  80187b:	ff 75 f4             	pushl  -0xc(%ebp)
  80187e:	e8 12 f8 ff ff       	call   801095 <fd2num>
  801883:	89 c3                	mov    %eax,%ebx
  801885:	83 c4 10             	add    $0x10,%esp
}
  801888:	89 d8                	mov    %ebx,%eax
  80188a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80188d:	5b                   	pop    %ebx
  80188e:	5e                   	pop    %esi
  80188f:	5d                   	pop    %ebp
  801890:	c3                   	ret    
		fd_close(fd, 0);
  801891:	83 ec 08             	sub    $0x8,%esp
  801894:	6a 00                	push   $0x0
  801896:	ff 75 f4             	pushl  -0xc(%ebp)
  801899:	e8 1b f9 ff ff       	call   8011b9 <fd_close>
		return r;
  80189e:	83 c4 10             	add    $0x10,%esp
  8018a1:	eb e5                	jmp    801888 <open+0x6c>
		return -E_BAD_PATH;
  8018a3:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018a8:	eb de                	jmp    801888 <open+0x6c>

008018aa <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b5:	b8 08 00 00 00       	mov    $0x8,%eax
  8018ba:	e8 68 fd ff ff       	call   801627 <fsipc>
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8018c7:	68 fb 2a 80 00       	push   $0x802afb
  8018cc:	ff 75 0c             	pushl  0xc(%ebp)
  8018cf:	e8 da f0 ff ff       	call   8009ae <strcpy>
	return 0;
}
  8018d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <devsock_close>:
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	53                   	push   %ebx
  8018df:	83 ec 10             	sub    $0x10,%esp
  8018e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018e5:	53                   	push   %ebx
  8018e6:	e8 00 0a 00 00       	call   8022eb <pageref>
  8018eb:	83 c4 10             	add    $0x10,%esp
		return 0;
  8018ee:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8018f3:	83 f8 01             	cmp    $0x1,%eax
  8018f6:	74 07                	je     8018ff <devsock_close+0x24>
}
  8018f8:	89 d0                	mov    %edx,%eax
  8018fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8018ff:	83 ec 0c             	sub    $0xc,%esp
  801902:	ff 73 0c             	pushl  0xc(%ebx)
  801905:	e8 b9 02 00 00       	call   801bc3 <nsipc_close>
  80190a:	89 c2                	mov    %eax,%edx
  80190c:	83 c4 10             	add    $0x10,%esp
  80190f:	eb e7                	jmp    8018f8 <devsock_close+0x1d>

00801911 <devsock_write>:
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
  801914:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801917:	6a 00                	push   $0x0
  801919:	ff 75 10             	pushl  0x10(%ebp)
  80191c:	ff 75 0c             	pushl  0xc(%ebp)
  80191f:	8b 45 08             	mov    0x8(%ebp),%eax
  801922:	ff 70 0c             	pushl  0xc(%eax)
  801925:	e8 76 03 00 00       	call   801ca0 <nsipc_send>
}
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    

0080192c <devsock_read>:
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
  80192f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801932:	6a 00                	push   $0x0
  801934:	ff 75 10             	pushl  0x10(%ebp)
  801937:	ff 75 0c             	pushl  0xc(%ebp)
  80193a:	8b 45 08             	mov    0x8(%ebp),%eax
  80193d:	ff 70 0c             	pushl  0xc(%eax)
  801940:	e8 ef 02 00 00       	call   801c34 <nsipc_recv>
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <fd2sockid>:
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80194d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801950:	52                   	push   %edx
  801951:	50                   	push   %eax
  801952:	e8 b7 f7 ff ff       	call   80110e <fd_lookup>
  801957:	83 c4 10             	add    $0x10,%esp
  80195a:	85 c0                	test   %eax,%eax
  80195c:	78 10                	js     80196e <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80195e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801961:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801967:	39 08                	cmp    %ecx,(%eax)
  801969:	75 05                	jne    801970 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80196b:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    
		return -E_NOT_SUPP;
  801970:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801975:	eb f7                	jmp    80196e <fd2sockid+0x27>

00801977 <alloc_sockfd>:
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	56                   	push   %esi
  80197b:	53                   	push   %ebx
  80197c:	83 ec 1c             	sub    $0x1c,%esp
  80197f:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801981:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801984:	50                   	push   %eax
  801985:	e8 32 f7 ff ff       	call   8010bc <fd_alloc>
  80198a:	89 c3                	mov    %eax,%ebx
  80198c:	83 c4 10             	add    $0x10,%esp
  80198f:	85 c0                	test   %eax,%eax
  801991:	78 43                	js     8019d6 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801993:	83 ec 04             	sub    $0x4,%esp
  801996:	68 07 04 00 00       	push   $0x407
  80199b:	ff 75 f4             	pushl  -0xc(%ebp)
  80199e:	6a 00                	push   $0x0
  8019a0:	e8 fb f3 ff ff       	call   800da0 <sys_page_alloc>
  8019a5:	89 c3                	mov    %eax,%ebx
  8019a7:	83 c4 10             	add    $0x10,%esp
  8019aa:	85 c0                	test   %eax,%eax
  8019ac:	78 28                	js     8019d6 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8019ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b1:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019b7:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8019b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019bc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8019c3:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8019c6:	83 ec 0c             	sub    $0xc,%esp
  8019c9:	50                   	push   %eax
  8019ca:	e8 c6 f6 ff ff       	call   801095 <fd2num>
  8019cf:	89 c3                	mov    %eax,%ebx
  8019d1:	83 c4 10             	add    $0x10,%esp
  8019d4:	eb 0c                	jmp    8019e2 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8019d6:	83 ec 0c             	sub    $0xc,%esp
  8019d9:	56                   	push   %esi
  8019da:	e8 e4 01 00 00       	call   801bc3 <nsipc_close>
		return r;
  8019df:	83 c4 10             	add    $0x10,%esp
}
  8019e2:	89 d8                	mov    %ebx,%eax
  8019e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019e7:	5b                   	pop    %ebx
  8019e8:	5e                   	pop    %esi
  8019e9:	5d                   	pop    %ebp
  8019ea:	c3                   	ret    

008019eb <accept>:
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	e8 4e ff ff ff       	call   801947 <fd2sockid>
  8019f9:	85 c0                	test   %eax,%eax
  8019fb:	78 1b                	js     801a18 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019fd:	83 ec 04             	sub    $0x4,%esp
  801a00:	ff 75 10             	pushl  0x10(%ebp)
  801a03:	ff 75 0c             	pushl  0xc(%ebp)
  801a06:	50                   	push   %eax
  801a07:	e8 0e 01 00 00       	call   801b1a <nsipc_accept>
  801a0c:	83 c4 10             	add    $0x10,%esp
  801a0f:	85 c0                	test   %eax,%eax
  801a11:	78 05                	js     801a18 <accept+0x2d>
	return alloc_sockfd(r);
  801a13:	e8 5f ff ff ff       	call   801977 <alloc_sockfd>
}
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    

00801a1a <bind>:
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
  801a1d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	e8 1f ff ff ff       	call   801947 <fd2sockid>
  801a28:	85 c0                	test   %eax,%eax
  801a2a:	78 12                	js     801a3e <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801a2c:	83 ec 04             	sub    $0x4,%esp
  801a2f:	ff 75 10             	pushl  0x10(%ebp)
  801a32:	ff 75 0c             	pushl  0xc(%ebp)
  801a35:	50                   	push   %eax
  801a36:	e8 31 01 00 00       	call   801b6c <nsipc_bind>
  801a3b:	83 c4 10             	add    $0x10,%esp
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <shutdown>:
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	e8 f9 fe ff ff       	call   801947 <fd2sockid>
  801a4e:	85 c0                	test   %eax,%eax
  801a50:	78 0f                	js     801a61 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a52:	83 ec 08             	sub    $0x8,%esp
  801a55:	ff 75 0c             	pushl  0xc(%ebp)
  801a58:	50                   	push   %eax
  801a59:	e8 43 01 00 00       	call   801ba1 <nsipc_shutdown>
  801a5e:	83 c4 10             	add    $0x10,%esp
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <connect>:
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	e8 d6 fe ff ff       	call   801947 <fd2sockid>
  801a71:	85 c0                	test   %eax,%eax
  801a73:	78 12                	js     801a87 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a75:	83 ec 04             	sub    $0x4,%esp
  801a78:	ff 75 10             	pushl  0x10(%ebp)
  801a7b:	ff 75 0c             	pushl  0xc(%ebp)
  801a7e:	50                   	push   %eax
  801a7f:	e8 59 01 00 00       	call   801bdd <nsipc_connect>
  801a84:	83 c4 10             	add    $0x10,%esp
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <listen>:
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a92:	e8 b0 fe ff ff       	call   801947 <fd2sockid>
  801a97:	85 c0                	test   %eax,%eax
  801a99:	78 0f                	js     801aaa <listen+0x21>
	return nsipc_listen(r, backlog);
  801a9b:	83 ec 08             	sub    $0x8,%esp
  801a9e:	ff 75 0c             	pushl  0xc(%ebp)
  801aa1:	50                   	push   %eax
  801aa2:	e8 6b 01 00 00       	call   801c12 <nsipc_listen>
  801aa7:	83 c4 10             	add    $0x10,%esp
}
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <socket>:

int
socket(int domain, int type, int protocol)
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
  801aaf:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ab2:	ff 75 10             	pushl  0x10(%ebp)
  801ab5:	ff 75 0c             	pushl  0xc(%ebp)
  801ab8:	ff 75 08             	pushl  0x8(%ebp)
  801abb:	e8 3e 02 00 00       	call   801cfe <nsipc_socket>
  801ac0:	83 c4 10             	add    $0x10,%esp
  801ac3:	85 c0                	test   %eax,%eax
  801ac5:	78 05                	js     801acc <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801ac7:	e8 ab fe ff ff       	call   801977 <alloc_sockfd>
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
  801ad1:	53                   	push   %ebx
  801ad2:	83 ec 04             	sub    $0x4,%esp
  801ad5:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801ad7:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801ade:	74 26                	je     801b06 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ae0:	6a 07                	push   $0x7
  801ae2:	68 00 60 c0 00       	push   $0xc06000
  801ae7:	53                   	push   %ebx
  801ae8:	ff 35 04 40 80 00    	pushl  0x804004
  801aee:	e8 61 07 00 00       	call   802254 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801af3:	83 c4 0c             	add    $0xc,%esp
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	e8 ea 06 00 00       	call   8021eb <ipc_recv>
}
  801b01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b06:	83 ec 0c             	sub    $0xc,%esp
  801b09:	6a 02                	push   $0x2
  801b0b:	e8 9c 07 00 00       	call   8022ac <ipc_find_env>
  801b10:	a3 04 40 80 00       	mov    %eax,0x804004
  801b15:	83 c4 10             	add    $0x10,%esp
  801b18:	eb c6                	jmp    801ae0 <nsipc+0x12>

00801b1a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
  801b1d:	56                   	push   %esi
  801b1e:	53                   	push   %ebx
  801b1f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b22:	8b 45 08             	mov    0x8(%ebp),%eax
  801b25:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b2a:	8b 06                	mov    (%esi),%eax
  801b2c:	a3 04 60 c0 00       	mov    %eax,0xc06004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b31:	b8 01 00 00 00       	mov    $0x1,%eax
  801b36:	e8 93 ff ff ff       	call   801ace <nsipc>
  801b3b:	89 c3                	mov    %eax,%ebx
  801b3d:	85 c0                	test   %eax,%eax
  801b3f:	79 09                	jns    801b4a <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b41:	89 d8                	mov    %ebx,%eax
  801b43:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b46:	5b                   	pop    %ebx
  801b47:	5e                   	pop    %esi
  801b48:	5d                   	pop    %ebp
  801b49:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b4a:	83 ec 04             	sub    $0x4,%esp
  801b4d:	ff 35 10 60 c0 00    	pushl  0xc06010
  801b53:	68 00 60 c0 00       	push   $0xc06000
  801b58:	ff 75 0c             	pushl  0xc(%ebp)
  801b5b:	e8 dc ef ff ff       	call   800b3c <memmove>
		*addrlen = ret->ret_addrlen;
  801b60:	a1 10 60 c0 00       	mov    0xc06010,%eax
  801b65:	89 06                	mov    %eax,(%esi)
  801b67:	83 c4 10             	add    $0x10,%esp
	return r;
  801b6a:	eb d5                	jmp    801b41 <nsipc_accept+0x27>

00801b6c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
  801b6f:	53                   	push   %ebx
  801b70:	83 ec 08             	sub    $0x8,%esp
  801b73:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	a3 00 60 c0 00       	mov    %eax,0xc06000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b7e:	53                   	push   %ebx
  801b7f:	ff 75 0c             	pushl  0xc(%ebp)
  801b82:	68 04 60 c0 00       	push   $0xc06004
  801b87:	e8 b0 ef ff ff       	call   800b3c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b8c:	89 1d 14 60 c0 00    	mov    %ebx,0xc06014
	return nsipc(NSREQ_BIND);
  801b92:	b8 02 00 00 00       	mov    $0x2,%eax
  801b97:	e8 32 ff ff ff       	call   801ace <nsipc>
}
  801b9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.shutdown.req_how = how;
  801baf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb2:	a3 04 60 c0 00       	mov    %eax,0xc06004
	return nsipc(NSREQ_SHUTDOWN);
  801bb7:	b8 03 00 00 00       	mov    $0x3,%eax
  801bbc:	e8 0d ff ff ff       	call   801ace <nsipc>
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <nsipc_close>:

int
nsipc_close(int s)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	a3 00 60 c0 00       	mov    %eax,0xc06000
	return nsipc(NSREQ_CLOSE);
  801bd1:	b8 04 00 00 00       	mov    $0x4,%eax
  801bd6:	e8 f3 fe ff ff       	call   801ace <nsipc>
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	53                   	push   %ebx
  801be1:	83 ec 08             	sub    $0x8,%esp
  801be4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801be7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bea:	a3 00 60 c0 00       	mov    %eax,0xc06000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801bef:	53                   	push   %ebx
  801bf0:	ff 75 0c             	pushl  0xc(%ebp)
  801bf3:	68 04 60 c0 00       	push   $0xc06004
  801bf8:	e8 3f ef ff ff       	call   800b3c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801bfd:	89 1d 14 60 c0 00    	mov    %ebx,0xc06014
	return nsipc(NSREQ_CONNECT);
  801c03:	b8 05 00 00 00       	mov    $0x5,%eax
  801c08:	e8 c1 fe ff ff       	call   801ace <nsipc>
}
  801c0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
  801c15:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c18:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1b:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.listen.req_backlog = backlog;
  801c20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c23:	a3 04 60 c0 00       	mov    %eax,0xc06004
	return nsipc(NSREQ_LISTEN);
  801c28:	b8 06 00 00 00       	mov    $0x6,%eax
  801c2d:	e8 9c fe ff ff       	call   801ace <nsipc>
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	56                   	push   %esi
  801c38:	53                   	push   %ebx
  801c39:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.recv.req_len = len;
  801c44:	89 35 04 60 c0 00    	mov    %esi,0xc06004
	nsipcbuf.recv.req_flags = flags;
  801c4a:	8b 45 14             	mov    0x14(%ebp),%eax
  801c4d:	a3 08 60 c0 00       	mov    %eax,0xc06008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c52:	b8 07 00 00 00       	mov    $0x7,%eax
  801c57:	e8 72 fe ff ff       	call   801ace <nsipc>
  801c5c:	89 c3                	mov    %eax,%ebx
  801c5e:	85 c0                	test   %eax,%eax
  801c60:	78 1f                	js     801c81 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c62:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c67:	7f 21                	jg     801c8a <nsipc_recv+0x56>
  801c69:	39 c6                	cmp    %eax,%esi
  801c6b:	7c 1d                	jl     801c8a <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c6d:	83 ec 04             	sub    $0x4,%esp
  801c70:	50                   	push   %eax
  801c71:	68 00 60 c0 00       	push   $0xc06000
  801c76:	ff 75 0c             	pushl  0xc(%ebp)
  801c79:	e8 be ee ff ff       	call   800b3c <memmove>
  801c7e:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c81:	89 d8                	mov    %ebx,%eax
  801c83:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c86:	5b                   	pop    %ebx
  801c87:	5e                   	pop    %esi
  801c88:	5d                   	pop    %ebp
  801c89:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c8a:	68 07 2b 80 00       	push   $0x802b07
  801c8f:	68 cf 2a 80 00       	push   $0x802acf
  801c94:	6a 62                	push   $0x62
  801c96:	68 1c 2b 80 00       	push   $0x802b1c
  801c9b:	e8 b9 e4 ff ff       	call   800159 <_panic>

00801ca0 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	53                   	push   %ebx
  801ca4:	83 ec 04             	sub    $0x4,%esp
  801ca7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801caa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cad:	a3 00 60 c0 00       	mov    %eax,0xc06000
	assert(size < 1600);
  801cb2:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801cb8:	7f 2e                	jg     801ce8 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801cba:	83 ec 04             	sub    $0x4,%esp
  801cbd:	53                   	push   %ebx
  801cbe:	ff 75 0c             	pushl  0xc(%ebp)
  801cc1:	68 0c 60 c0 00       	push   $0xc0600c
  801cc6:	e8 71 ee ff ff       	call   800b3c <memmove>
	nsipcbuf.send.req_size = size;
  801ccb:	89 1d 04 60 c0 00    	mov    %ebx,0xc06004
	nsipcbuf.send.req_flags = flags;
  801cd1:	8b 45 14             	mov    0x14(%ebp),%eax
  801cd4:	a3 08 60 c0 00       	mov    %eax,0xc06008
	return nsipc(NSREQ_SEND);
  801cd9:	b8 08 00 00 00       	mov    $0x8,%eax
  801cde:	e8 eb fd ff ff       	call   801ace <nsipc>
}
  801ce3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    
	assert(size < 1600);
  801ce8:	68 28 2b 80 00       	push   $0x802b28
  801ced:	68 cf 2a 80 00       	push   $0x802acf
  801cf2:	6a 6d                	push   $0x6d
  801cf4:	68 1c 2b 80 00       	push   $0x802b1c
  801cf9:	e8 5b e4 ff ff       	call   800159 <_panic>

00801cfe <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d04:	8b 45 08             	mov    0x8(%ebp),%eax
  801d07:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.socket.req_type = type;
  801d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d0f:	a3 04 60 c0 00       	mov    %eax,0xc06004
	nsipcbuf.socket.req_protocol = protocol;
  801d14:	8b 45 10             	mov    0x10(%ebp),%eax
  801d17:	a3 08 60 c0 00       	mov    %eax,0xc06008
	return nsipc(NSREQ_SOCKET);
  801d1c:	b8 09 00 00 00       	mov    $0x9,%eax
  801d21:	e8 a8 fd ff ff       	call   801ace <nsipc>
}
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	56                   	push   %esi
  801d2c:	53                   	push   %ebx
  801d2d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d30:	83 ec 0c             	sub    $0xc,%esp
  801d33:	ff 75 08             	pushl  0x8(%ebp)
  801d36:	e8 6a f3 ff ff       	call   8010a5 <fd2data>
  801d3b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d3d:	83 c4 08             	add    $0x8,%esp
  801d40:	68 34 2b 80 00       	push   $0x802b34
  801d45:	53                   	push   %ebx
  801d46:	e8 63 ec ff ff       	call   8009ae <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d4b:	8b 46 04             	mov    0x4(%esi),%eax
  801d4e:	2b 06                	sub    (%esi),%eax
  801d50:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d56:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d5d:	00 00 00 
	stat->st_dev = &devpipe;
  801d60:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d67:	30 80 00 
	return 0;
}
  801d6a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d72:	5b                   	pop    %ebx
  801d73:	5e                   	pop    %esi
  801d74:	5d                   	pop    %ebp
  801d75:	c3                   	ret    

00801d76 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
  801d79:	53                   	push   %ebx
  801d7a:	83 ec 0c             	sub    $0xc,%esp
  801d7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d80:	53                   	push   %ebx
  801d81:	6a 00                	push   $0x0
  801d83:	e8 9d f0 ff ff       	call   800e25 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d88:	89 1c 24             	mov    %ebx,(%esp)
  801d8b:	e8 15 f3 ff ff       	call   8010a5 <fd2data>
  801d90:	83 c4 08             	add    $0x8,%esp
  801d93:	50                   	push   %eax
  801d94:	6a 00                	push   $0x0
  801d96:	e8 8a f0 ff ff       	call   800e25 <sys_page_unmap>
}
  801d9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <_pipeisclosed>:
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
  801da3:	57                   	push   %edi
  801da4:	56                   	push   %esi
  801da5:	53                   	push   %ebx
  801da6:	83 ec 1c             	sub    $0x1c,%esp
  801da9:	89 c7                	mov    %eax,%edi
  801dab:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801dad:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801db2:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801db5:	83 ec 0c             	sub    $0xc,%esp
  801db8:	57                   	push   %edi
  801db9:	e8 2d 05 00 00       	call   8022eb <pageref>
  801dbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801dc1:	89 34 24             	mov    %esi,(%esp)
  801dc4:	e8 22 05 00 00       	call   8022eb <pageref>
		nn = thisenv->env_runs;
  801dc9:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  801dcf:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801dd2:	83 c4 10             	add    $0x10,%esp
  801dd5:	39 cb                	cmp    %ecx,%ebx
  801dd7:	74 1b                	je     801df4 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801dd9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ddc:	75 cf                	jne    801dad <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801dde:	8b 42 58             	mov    0x58(%edx),%eax
  801de1:	6a 01                	push   $0x1
  801de3:	50                   	push   %eax
  801de4:	53                   	push   %ebx
  801de5:	68 3b 2b 80 00       	push   $0x802b3b
  801dea:	e8 60 e4 ff ff       	call   80024f <cprintf>
  801def:	83 c4 10             	add    $0x10,%esp
  801df2:	eb b9                	jmp    801dad <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801df4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801df7:	0f 94 c0             	sete   %al
  801dfa:	0f b6 c0             	movzbl %al,%eax
}
  801dfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e00:	5b                   	pop    %ebx
  801e01:	5e                   	pop    %esi
  801e02:	5f                   	pop    %edi
  801e03:	5d                   	pop    %ebp
  801e04:	c3                   	ret    

00801e05 <devpipe_write>:
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
  801e08:	57                   	push   %edi
  801e09:	56                   	push   %esi
  801e0a:	53                   	push   %ebx
  801e0b:	83 ec 28             	sub    $0x28,%esp
  801e0e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e11:	56                   	push   %esi
  801e12:	e8 8e f2 ff ff       	call   8010a5 <fd2data>
  801e17:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e19:	83 c4 10             	add    $0x10,%esp
  801e1c:	bf 00 00 00 00       	mov    $0x0,%edi
  801e21:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e24:	74 4f                	je     801e75 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e26:	8b 43 04             	mov    0x4(%ebx),%eax
  801e29:	8b 0b                	mov    (%ebx),%ecx
  801e2b:	8d 51 20             	lea    0x20(%ecx),%edx
  801e2e:	39 d0                	cmp    %edx,%eax
  801e30:	72 14                	jb     801e46 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e32:	89 da                	mov    %ebx,%edx
  801e34:	89 f0                	mov    %esi,%eax
  801e36:	e8 65 ff ff ff       	call   801da0 <_pipeisclosed>
  801e3b:	85 c0                	test   %eax,%eax
  801e3d:	75 3b                	jne    801e7a <devpipe_write+0x75>
			sys_yield();
  801e3f:	e8 3d ef ff ff       	call   800d81 <sys_yield>
  801e44:	eb e0                	jmp    801e26 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e49:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e4d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e50:	89 c2                	mov    %eax,%edx
  801e52:	c1 fa 1f             	sar    $0x1f,%edx
  801e55:	89 d1                	mov    %edx,%ecx
  801e57:	c1 e9 1b             	shr    $0x1b,%ecx
  801e5a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e5d:	83 e2 1f             	and    $0x1f,%edx
  801e60:	29 ca                	sub    %ecx,%edx
  801e62:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e66:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e6a:	83 c0 01             	add    $0x1,%eax
  801e6d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e70:	83 c7 01             	add    $0x1,%edi
  801e73:	eb ac                	jmp    801e21 <devpipe_write+0x1c>
	return i;
  801e75:	8b 45 10             	mov    0x10(%ebp),%eax
  801e78:	eb 05                	jmp    801e7f <devpipe_write+0x7a>
				return 0;
  801e7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e82:	5b                   	pop    %ebx
  801e83:	5e                   	pop    %esi
  801e84:	5f                   	pop    %edi
  801e85:	5d                   	pop    %ebp
  801e86:	c3                   	ret    

00801e87 <devpipe_read>:
{
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
  801e8a:	57                   	push   %edi
  801e8b:	56                   	push   %esi
  801e8c:	53                   	push   %ebx
  801e8d:	83 ec 18             	sub    $0x18,%esp
  801e90:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e93:	57                   	push   %edi
  801e94:	e8 0c f2 ff ff       	call   8010a5 <fd2data>
  801e99:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e9b:	83 c4 10             	add    $0x10,%esp
  801e9e:	be 00 00 00 00       	mov    $0x0,%esi
  801ea3:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ea6:	75 14                	jne    801ebc <devpipe_read+0x35>
	return i;
  801ea8:	8b 45 10             	mov    0x10(%ebp),%eax
  801eab:	eb 02                	jmp    801eaf <devpipe_read+0x28>
				return i;
  801ead:	89 f0                	mov    %esi,%eax
}
  801eaf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eb2:	5b                   	pop    %ebx
  801eb3:	5e                   	pop    %esi
  801eb4:	5f                   	pop    %edi
  801eb5:	5d                   	pop    %ebp
  801eb6:	c3                   	ret    
			sys_yield();
  801eb7:	e8 c5 ee ff ff       	call   800d81 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801ebc:	8b 03                	mov    (%ebx),%eax
  801ebe:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ec1:	75 18                	jne    801edb <devpipe_read+0x54>
			if (i > 0)
  801ec3:	85 f6                	test   %esi,%esi
  801ec5:	75 e6                	jne    801ead <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801ec7:	89 da                	mov    %ebx,%edx
  801ec9:	89 f8                	mov    %edi,%eax
  801ecb:	e8 d0 fe ff ff       	call   801da0 <_pipeisclosed>
  801ed0:	85 c0                	test   %eax,%eax
  801ed2:	74 e3                	je     801eb7 <devpipe_read+0x30>
				return 0;
  801ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed9:	eb d4                	jmp    801eaf <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801edb:	99                   	cltd   
  801edc:	c1 ea 1b             	shr    $0x1b,%edx
  801edf:	01 d0                	add    %edx,%eax
  801ee1:	83 e0 1f             	and    $0x1f,%eax
  801ee4:	29 d0                	sub    %edx,%eax
  801ee6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801eeb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801eee:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ef1:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801ef4:	83 c6 01             	add    $0x1,%esi
  801ef7:	eb aa                	jmp    801ea3 <devpipe_read+0x1c>

00801ef9 <pipe>:
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
  801efc:	56                   	push   %esi
  801efd:	53                   	push   %ebx
  801efe:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f04:	50                   	push   %eax
  801f05:	e8 b2 f1 ff ff       	call   8010bc <fd_alloc>
  801f0a:	89 c3                	mov    %eax,%ebx
  801f0c:	83 c4 10             	add    $0x10,%esp
  801f0f:	85 c0                	test   %eax,%eax
  801f11:	0f 88 23 01 00 00    	js     80203a <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f17:	83 ec 04             	sub    $0x4,%esp
  801f1a:	68 07 04 00 00       	push   $0x407
  801f1f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f22:	6a 00                	push   $0x0
  801f24:	e8 77 ee ff ff       	call   800da0 <sys_page_alloc>
  801f29:	89 c3                	mov    %eax,%ebx
  801f2b:	83 c4 10             	add    $0x10,%esp
  801f2e:	85 c0                	test   %eax,%eax
  801f30:	0f 88 04 01 00 00    	js     80203a <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f36:	83 ec 0c             	sub    $0xc,%esp
  801f39:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f3c:	50                   	push   %eax
  801f3d:	e8 7a f1 ff ff       	call   8010bc <fd_alloc>
  801f42:	89 c3                	mov    %eax,%ebx
  801f44:	83 c4 10             	add    $0x10,%esp
  801f47:	85 c0                	test   %eax,%eax
  801f49:	0f 88 db 00 00 00    	js     80202a <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f4f:	83 ec 04             	sub    $0x4,%esp
  801f52:	68 07 04 00 00       	push   $0x407
  801f57:	ff 75 f0             	pushl  -0x10(%ebp)
  801f5a:	6a 00                	push   $0x0
  801f5c:	e8 3f ee ff ff       	call   800da0 <sys_page_alloc>
  801f61:	89 c3                	mov    %eax,%ebx
  801f63:	83 c4 10             	add    $0x10,%esp
  801f66:	85 c0                	test   %eax,%eax
  801f68:	0f 88 bc 00 00 00    	js     80202a <pipe+0x131>
	va = fd2data(fd0);
  801f6e:	83 ec 0c             	sub    $0xc,%esp
  801f71:	ff 75 f4             	pushl  -0xc(%ebp)
  801f74:	e8 2c f1 ff ff       	call   8010a5 <fd2data>
  801f79:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f7b:	83 c4 0c             	add    $0xc,%esp
  801f7e:	68 07 04 00 00       	push   $0x407
  801f83:	50                   	push   %eax
  801f84:	6a 00                	push   $0x0
  801f86:	e8 15 ee ff ff       	call   800da0 <sys_page_alloc>
  801f8b:	89 c3                	mov    %eax,%ebx
  801f8d:	83 c4 10             	add    $0x10,%esp
  801f90:	85 c0                	test   %eax,%eax
  801f92:	0f 88 82 00 00 00    	js     80201a <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f98:	83 ec 0c             	sub    $0xc,%esp
  801f9b:	ff 75 f0             	pushl  -0x10(%ebp)
  801f9e:	e8 02 f1 ff ff       	call   8010a5 <fd2data>
  801fa3:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801faa:	50                   	push   %eax
  801fab:	6a 00                	push   $0x0
  801fad:	56                   	push   %esi
  801fae:	6a 00                	push   $0x0
  801fb0:	e8 2e ee ff ff       	call   800de3 <sys_page_map>
  801fb5:	89 c3                	mov    %eax,%ebx
  801fb7:	83 c4 20             	add    $0x20,%esp
  801fba:	85 c0                	test   %eax,%eax
  801fbc:	78 4e                	js     80200c <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801fbe:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801fc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc6:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801fc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fcb:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801fd2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fd5:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801fd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fda:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801fe1:	83 ec 0c             	sub    $0xc,%esp
  801fe4:	ff 75 f4             	pushl  -0xc(%ebp)
  801fe7:	e8 a9 f0 ff ff       	call   801095 <fd2num>
  801fec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fef:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ff1:	83 c4 04             	add    $0x4,%esp
  801ff4:	ff 75 f0             	pushl  -0x10(%ebp)
  801ff7:	e8 99 f0 ff ff       	call   801095 <fd2num>
  801ffc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fff:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802002:	83 c4 10             	add    $0x10,%esp
  802005:	bb 00 00 00 00       	mov    $0x0,%ebx
  80200a:	eb 2e                	jmp    80203a <pipe+0x141>
	sys_page_unmap(0, va);
  80200c:	83 ec 08             	sub    $0x8,%esp
  80200f:	56                   	push   %esi
  802010:	6a 00                	push   $0x0
  802012:	e8 0e ee ff ff       	call   800e25 <sys_page_unmap>
  802017:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80201a:	83 ec 08             	sub    $0x8,%esp
  80201d:	ff 75 f0             	pushl  -0x10(%ebp)
  802020:	6a 00                	push   $0x0
  802022:	e8 fe ed ff ff       	call   800e25 <sys_page_unmap>
  802027:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80202a:	83 ec 08             	sub    $0x8,%esp
  80202d:	ff 75 f4             	pushl  -0xc(%ebp)
  802030:	6a 00                	push   $0x0
  802032:	e8 ee ed ff ff       	call   800e25 <sys_page_unmap>
  802037:	83 c4 10             	add    $0x10,%esp
}
  80203a:	89 d8                	mov    %ebx,%eax
  80203c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80203f:	5b                   	pop    %ebx
  802040:	5e                   	pop    %esi
  802041:	5d                   	pop    %ebp
  802042:	c3                   	ret    

00802043 <pipeisclosed>:
{
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
  802046:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802049:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80204c:	50                   	push   %eax
  80204d:	ff 75 08             	pushl  0x8(%ebp)
  802050:	e8 b9 f0 ff ff       	call   80110e <fd_lookup>
  802055:	83 c4 10             	add    $0x10,%esp
  802058:	85 c0                	test   %eax,%eax
  80205a:	78 18                	js     802074 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80205c:	83 ec 0c             	sub    $0xc,%esp
  80205f:	ff 75 f4             	pushl  -0xc(%ebp)
  802062:	e8 3e f0 ff ff       	call   8010a5 <fd2data>
	return _pipeisclosed(fd, p);
  802067:	89 c2                	mov    %eax,%edx
  802069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206c:	e8 2f fd ff ff       	call   801da0 <_pipeisclosed>
  802071:	83 c4 10             	add    $0x10,%esp
}
  802074:	c9                   	leave  
  802075:	c3                   	ret    

00802076 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802076:	b8 00 00 00 00       	mov    $0x0,%eax
  80207b:	c3                   	ret    

0080207c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
  80207f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802082:	68 53 2b 80 00       	push   $0x802b53
  802087:	ff 75 0c             	pushl  0xc(%ebp)
  80208a:	e8 1f e9 ff ff       	call   8009ae <strcpy>
	return 0;
}
  80208f:	b8 00 00 00 00       	mov    $0x0,%eax
  802094:	c9                   	leave  
  802095:	c3                   	ret    

00802096 <devcons_write>:
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
  802099:	57                   	push   %edi
  80209a:	56                   	push   %esi
  80209b:	53                   	push   %ebx
  80209c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8020a2:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8020a7:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8020ad:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020b0:	73 31                	jae    8020e3 <devcons_write+0x4d>
		m = n - tot;
  8020b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020b5:	29 f3                	sub    %esi,%ebx
  8020b7:	83 fb 7f             	cmp    $0x7f,%ebx
  8020ba:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8020bf:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8020c2:	83 ec 04             	sub    $0x4,%esp
  8020c5:	53                   	push   %ebx
  8020c6:	89 f0                	mov    %esi,%eax
  8020c8:	03 45 0c             	add    0xc(%ebp),%eax
  8020cb:	50                   	push   %eax
  8020cc:	57                   	push   %edi
  8020cd:	e8 6a ea ff ff       	call   800b3c <memmove>
		sys_cputs(buf, m);
  8020d2:	83 c4 08             	add    $0x8,%esp
  8020d5:	53                   	push   %ebx
  8020d6:	57                   	push   %edi
  8020d7:	e8 08 ec ff ff       	call   800ce4 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020dc:	01 de                	add    %ebx,%esi
  8020de:	83 c4 10             	add    $0x10,%esp
  8020e1:	eb ca                	jmp    8020ad <devcons_write+0x17>
}
  8020e3:	89 f0                	mov    %esi,%eax
  8020e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020e8:	5b                   	pop    %ebx
  8020e9:	5e                   	pop    %esi
  8020ea:	5f                   	pop    %edi
  8020eb:	5d                   	pop    %ebp
  8020ec:	c3                   	ret    

008020ed <devcons_read>:
{
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
  8020f0:	83 ec 08             	sub    $0x8,%esp
  8020f3:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020fc:	74 21                	je     80211f <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8020fe:	e8 ff eb ff ff       	call   800d02 <sys_cgetc>
  802103:	85 c0                	test   %eax,%eax
  802105:	75 07                	jne    80210e <devcons_read+0x21>
		sys_yield();
  802107:	e8 75 ec ff ff       	call   800d81 <sys_yield>
  80210c:	eb f0                	jmp    8020fe <devcons_read+0x11>
	if (c < 0)
  80210e:	78 0f                	js     80211f <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802110:	83 f8 04             	cmp    $0x4,%eax
  802113:	74 0c                	je     802121 <devcons_read+0x34>
	*(char*)vbuf = c;
  802115:	8b 55 0c             	mov    0xc(%ebp),%edx
  802118:	88 02                	mov    %al,(%edx)
	return 1;
  80211a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80211f:	c9                   	leave  
  802120:	c3                   	ret    
		return 0;
  802121:	b8 00 00 00 00       	mov    $0x0,%eax
  802126:	eb f7                	jmp    80211f <devcons_read+0x32>

00802128 <cputchar>:
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
  80212b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80212e:	8b 45 08             	mov    0x8(%ebp),%eax
  802131:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802134:	6a 01                	push   $0x1
  802136:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802139:	50                   	push   %eax
  80213a:	e8 a5 eb ff ff       	call   800ce4 <sys_cputs>
}
  80213f:	83 c4 10             	add    $0x10,%esp
  802142:	c9                   	leave  
  802143:	c3                   	ret    

00802144 <getchar>:
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
  802147:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80214a:	6a 01                	push   $0x1
  80214c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80214f:	50                   	push   %eax
  802150:	6a 00                	push   $0x0
  802152:	e8 27 f2 ff ff       	call   80137e <read>
	if (r < 0)
  802157:	83 c4 10             	add    $0x10,%esp
  80215a:	85 c0                	test   %eax,%eax
  80215c:	78 06                	js     802164 <getchar+0x20>
	if (r < 1)
  80215e:	74 06                	je     802166 <getchar+0x22>
	return c;
  802160:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802164:	c9                   	leave  
  802165:	c3                   	ret    
		return -E_EOF;
  802166:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80216b:	eb f7                	jmp    802164 <getchar+0x20>

0080216d <iscons>:
{
  80216d:	55                   	push   %ebp
  80216e:	89 e5                	mov    %esp,%ebp
  802170:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802173:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802176:	50                   	push   %eax
  802177:	ff 75 08             	pushl  0x8(%ebp)
  80217a:	e8 8f ef ff ff       	call   80110e <fd_lookup>
  80217f:	83 c4 10             	add    $0x10,%esp
  802182:	85 c0                	test   %eax,%eax
  802184:	78 11                	js     802197 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802189:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80218f:	39 10                	cmp    %edx,(%eax)
  802191:	0f 94 c0             	sete   %al
  802194:	0f b6 c0             	movzbl %al,%eax
}
  802197:	c9                   	leave  
  802198:	c3                   	ret    

00802199 <opencons>:
{
  802199:	55                   	push   %ebp
  80219a:	89 e5                	mov    %esp,%ebp
  80219c:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80219f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021a2:	50                   	push   %eax
  8021a3:	e8 14 ef ff ff       	call   8010bc <fd_alloc>
  8021a8:	83 c4 10             	add    $0x10,%esp
  8021ab:	85 c0                	test   %eax,%eax
  8021ad:	78 3a                	js     8021e9 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021af:	83 ec 04             	sub    $0x4,%esp
  8021b2:	68 07 04 00 00       	push   $0x407
  8021b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8021ba:	6a 00                	push   $0x0
  8021bc:	e8 df eb ff ff       	call   800da0 <sys_page_alloc>
  8021c1:	83 c4 10             	add    $0x10,%esp
  8021c4:	85 c0                	test   %eax,%eax
  8021c6:	78 21                	js     8021e9 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8021c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cb:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021d1:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021dd:	83 ec 0c             	sub    $0xc,%esp
  8021e0:	50                   	push   %eax
  8021e1:	e8 af ee ff ff       	call   801095 <fd2num>
  8021e6:	83 c4 10             	add    $0x10,%esp
}
  8021e9:	c9                   	leave  
  8021ea:	c3                   	ret    

008021eb <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	56                   	push   %esi
  8021ef:	53                   	push   %ebx
  8021f0:	8b 75 08             	mov    0x8(%ebp),%esi
  8021f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8021f9:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021fb:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802200:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802203:	83 ec 0c             	sub    $0xc,%esp
  802206:	50                   	push   %eax
  802207:	e8 44 ed ff ff       	call   800f50 <sys_ipc_recv>
	if(ret < 0){
  80220c:	83 c4 10             	add    $0x10,%esp
  80220f:	85 c0                	test   %eax,%eax
  802211:	78 2b                	js     80223e <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802213:	85 f6                	test   %esi,%esi
  802215:	74 0a                	je     802221 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802217:	a1 20 40 c0 00       	mov    0xc04020,%eax
  80221c:	8b 40 78             	mov    0x78(%eax),%eax
  80221f:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802221:	85 db                	test   %ebx,%ebx
  802223:	74 0a                	je     80222f <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802225:	a1 20 40 c0 00       	mov    0xc04020,%eax
  80222a:	8b 40 7c             	mov    0x7c(%eax),%eax
  80222d:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80222f:	a1 20 40 c0 00       	mov    0xc04020,%eax
  802234:	8b 40 74             	mov    0x74(%eax),%eax
}
  802237:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80223a:	5b                   	pop    %ebx
  80223b:	5e                   	pop    %esi
  80223c:	5d                   	pop    %ebp
  80223d:	c3                   	ret    
		if(from_env_store)
  80223e:	85 f6                	test   %esi,%esi
  802240:	74 06                	je     802248 <ipc_recv+0x5d>
			*from_env_store = 0;
  802242:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802248:	85 db                	test   %ebx,%ebx
  80224a:	74 eb                	je     802237 <ipc_recv+0x4c>
			*perm_store = 0;
  80224c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802252:	eb e3                	jmp    802237 <ipc_recv+0x4c>

00802254 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
  802257:	57                   	push   %edi
  802258:	56                   	push   %esi
  802259:	53                   	push   %ebx
  80225a:	83 ec 0c             	sub    $0xc,%esp
  80225d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802260:	8b 75 0c             	mov    0xc(%ebp),%esi
  802263:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802266:	85 db                	test   %ebx,%ebx
  802268:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80226d:	0f 44 d8             	cmove  %eax,%ebx
  802270:	eb 05                	jmp    802277 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802272:	e8 0a eb ff ff       	call   800d81 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802277:	ff 75 14             	pushl  0x14(%ebp)
  80227a:	53                   	push   %ebx
  80227b:	56                   	push   %esi
  80227c:	57                   	push   %edi
  80227d:	e8 ab ec ff ff       	call   800f2d <sys_ipc_try_send>
  802282:	83 c4 10             	add    $0x10,%esp
  802285:	85 c0                	test   %eax,%eax
  802287:	74 1b                	je     8022a4 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802289:	79 e7                	jns    802272 <ipc_send+0x1e>
  80228b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80228e:	74 e2                	je     802272 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802290:	83 ec 04             	sub    $0x4,%esp
  802293:	68 5f 2b 80 00       	push   $0x802b5f
  802298:	6a 46                	push   $0x46
  80229a:	68 74 2b 80 00       	push   $0x802b74
  80229f:	e8 b5 de ff ff       	call   800159 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8022a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022a7:	5b                   	pop    %ebx
  8022a8:	5e                   	pop    %esi
  8022a9:	5f                   	pop    %edi
  8022aa:	5d                   	pop    %ebp
  8022ab:	c3                   	ret    

008022ac <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022ac:	55                   	push   %ebp
  8022ad:	89 e5                	mov    %esp,%ebp
  8022af:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022b2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022b7:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8022bd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022c3:	8b 52 50             	mov    0x50(%edx),%edx
  8022c6:	39 ca                	cmp    %ecx,%edx
  8022c8:	74 11                	je     8022db <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8022ca:	83 c0 01             	add    $0x1,%eax
  8022cd:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022d2:	75 e3                	jne    8022b7 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d9:	eb 0e                	jmp    8022e9 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8022db:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8022e1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022e6:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022e9:	5d                   	pop    %ebp
  8022ea:	c3                   	ret    

008022eb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022eb:	55                   	push   %ebp
  8022ec:	89 e5                	mov    %esp,%ebp
  8022ee:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022f1:	89 d0                	mov    %edx,%eax
  8022f3:	c1 e8 16             	shr    $0x16,%eax
  8022f6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022fd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802302:	f6 c1 01             	test   $0x1,%cl
  802305:	74 1d                	je     802324 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802307:	c1 ea 0c             	shr    $0xc,%edx
  80230a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802311:	f6 c2 01             	test   $0x1,%dl
  802314:	74 0e                	je     802324 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802316:	c1 ea 0c             	shr    $0xc,%edx
  802319:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802320:	ef 
  802321:	0f b7 c0             	movzwl %ax,%eax
}
  802324:	5d                   	pop    %ebp
  802325:	c3                   	ret    
  802326:	66 90                	xchg   %ax,%ax
  802328:	66 90                	xchg   %ax,%ax
  80232a:	66 90                	xchg   %ax,%ax
  80232c:	66 90                	xchg   %ax,%ax
  80232e:	66 90                	xchg   %ax,%ax

00802330 <__udivdi3>:
  802330:	55                   	push   %ebp
  802331:	57                   	push   %edi
  802332:	56                   	push   %esi
  802333:	53                   	push   %ebx
  802334:	83 ec 1c             	sub    $0x1c,%esp
  802337:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80233b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80233f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802343:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802347:	85 d2                	test   %edx,%edx
  802349:	75 4d                	jne    802398 <__udivdi3+0x68>
  80234b:	39 f3                	cmp    %esi,%ebx
  80234d:	76 19                	jbe    802368 <__udivdi3+0x38>
  80234f:	31 ff                	xor    %edi,%edi
  802351:	89 e8                	mov    %ebp,%eax
  802353:	89 f2                	mov    %esi,%edx
  802355:	f7 f3                	div    %ebx
  802357:	89 fa                	mov    %edi,%edx
  802359:	83 c4 1c             	add    $0x1c,%esp
  80235c:	5b                   	pop    %ebx
  80235d:	5e                   	pop    %esi
  80235e:	5f                   	pop    %edi
  80235f:	5d                   	pop    %ebp
  802360:	c3                   	ret    
  802361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802368:	89 d9                	mov    %ebx,%ecx
  80236a:	85 db                	test   %ebx,%ebx
  80236c:	75 0b                	jne    802379 <__udivdi3+0x49>
  80236e:	b8 01 00 00 00       	mov    $0x1,%eax
  802373:	31 d2                	xor    %edx,%edx
  802375:	f7 f3                	div    %ebx
  802377:	89 c1                	mov    %eax,%ecx
  802379:	31 d2                	xor    %edx,%edx
  80237b:	89 f0                	mov    %esi,%eax
  80237d:	f7 f1                	div    %ecx
  80237f:	89 c6                	mov    %eax,%esi
  802381:	89 e8                	mov    %ebp,%eax
  802383:	89 f7                	mov    %esi,%edi
  802385:	f7 f1                	div    %ecx
  802387:	89 fa                	mov    %edi,%edx
  802389:	83 c4 1c             	add    $0x1c,%esp
  80238c:	5b                   	pop    %ebx
  80238d:	5e                   	pop    %esi
  80238e:	5f                   	pop    %edi
  80238f:	5d                   	pop    %ebp
  802390:	c3                   	ret    
  802391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802398:	39 f2                	cmp    %esi,%edx
  80239a:	77 1c                	ja     8023b8 <__udivdi3+0x88>
  80239c:	0f bd fa             	bsr    %edx,%edi
  80239f:	83 f7 1f             	xor    $0x1f,%edi
  8023a2:	75 2c                	jne    8023d0 <__udivdi3+0xa0>
  8023a4:	39 f2                	cmp    %esi,%edx
  8023a6:	72 06                	jb     8023ae <__udivdi3+0x7e>
  8023a8:	31 c0                	xor    %eax,%eax
  8023aa:	39 eb                	cmp    %ebp,%ebx
  8023ac:	77 a9                	ja     802357 <__udivdi3+0x27>
  8023ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b3:	eb a2                	jmp    802357 <__udivdi3+0x27>
  8023b5:	8d 76 00             	lea    0x0(%esi),%esi
  8023b8:	31 ff                	xor    %edi,%edi
  8023ba:	31 c0                	xor    %eax,%eax
  8023bc:	89 fa                	mov    %edi,%edx
  8023be:	83 c4 1c             	add    $0x1c,%esp
  8023c1:	5b                   	pop    %ebx
  8023c2:	5e                   	pop    %esi
  8023c3:	5f                   	pop    %edi
  8023c4:	5d                   	pop    %ebp
  8023c5:	c3                   	ret    
  8023c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023cd:	8d 76 00             	lea    0x0(%esi),%esi
  8023d0:	89 f9                	mov    %edi,%ecx
  8023d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023d7:	29 f8                	sub    %edi,%eax
  8023d9:	d3 e2                	shl    %cl,%edx
  8023db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023df:	89 c1                	mov    %eax,%ecx
  8023e1:	89 da                	mov    %ebx,%edx
  8023e3:	d3 ea                	shr    %cl,%edx
  8023e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023e9:	09 d1                	or     %edx,%ecx
  8023eb:	89 f2                	mov    %esi,%edx
  8023ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023f1:	89 f9                	mov    %edi,%ecx
  8023f3:	d3 e3                	shl    %cl,%ebx
  8023f5:	89 c1                	mov    %eax,%ecx
  8023f7:	d3 ea                	shr    %cl,%edx
  8023f9:	89 f9                	mov    %edi,%ecx
  8023fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023ff:	89 eb                	mov    %ebp,%ebx
  802401:	d3 e6                	shl    %cl,%esi
  802403:	89 c1                	mov    %eax,%ecx
  802405:	d3 eb                	shr    %cl,%ebx
  802407:	09 de                	or     %ebx,%esi
  802409:	89 f0                	mov    %esi,%eax
  80240b:	f7 74 24 08          	divl   0x8(%esp)
  80240f:	89 d6                	mov    %edx,%esi
  802411:	89 c3                	mov    %eax,%ebx
  802413:	f7 64 24 0c          	mull   0xc(%esp)
  802417:	39 d6                	cmp    %edx,%esi
  802419:	72 15                	jb     802430 <__udivdi3+0x100>
  80241b:	89 f9                	mov    %edi,%ecx
  80241d:	d3 e5                	shl    %cl,%ebp
  80241f:	39 c5                	cmp    %eax,%ebp
  802421:	73 04                	jae    802427 <__udivdi3+0xf7>
  802423:	39 d6                	cmp    %edx,%esi
  802425:	74 09                	je     802430 <__udivdi3+0x100>
  802427:	89 d8                	mov    %ebx,%eax
  802429:	31 ff                	xor    %edi,%edi
  80242b:	e9 27 ff ff ff       	jmp    802357 <__udivdi3+0x27>
  802430:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802433:	31 ff                	xor    %edi,%edi
  802435:	e9 1d ff ff ff       	jmp    802357 <__udivdi3+0x27>
  80243a:	66 90                	xchg   %ax,%ax
  80243c:	66 90                	xchg   %ax,%ax
  80243e:	66 90                	xchg   %ax,%ax

00802440 <__umoddi3>:
  802440:	55                   	push   %ebp
  802441:	57                   	push   %edi
  802442:	56                   	push   %esi
  802443:	53                   	push   %ebx
  802444:	83 ec 1c             	sub    $0x1c,%esp
  802447:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80244b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80244f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802453:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802457:	89 da                	mov    %ebx,%edx
  802459:	85 c0                	test   %eax,%eax
  80245b:	75 43                	jne    8024a0 <__umoddi3+0x60>
  80245d:	39 df                	cmp    %ebx,%edi
  80245f:	76 17                	jbe    802478 <__umoddi3+0x38>
  802461:	89 f0                	mov    %esi,%eax
  802463:	f7 f7                	div    %edi
  802465:	89 d0                	mov    %edx,%eax
  802467:	31 d2                	xor    %edx,%edx
  802469:	83 c4 1c             	add    $0x1c,%esp
  80246c:	5b                   	pop    %ebx
  80246d:	5e                   	pop    %esi
  80246e:	5f                   	pop    %edi
  80246f:	5d                   	pop    %ebp
  802470:	c3                   	ret    
  802471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802478:	89 fd                	mov    %edi,%ebp
  80247a:	85 ff                	test   %edi,%edi
  80247c:	75 0b                	jne    802489 <__umoddi3+0x49>
  80247e:	b8 01 00 00 00       	mov    $0x1,%eax
  802483:	31 d2                	xor    %edx,%edx
  802485:	f7 f7                	div    %edi
  802487:	89 c5                	mov    %eax,%ebp
  802489:	89 d8                	mov    %ebx,%eax
  80248b:	31 d2                	xor    %edx,%edx
  80248d:	f7 f5                	div    %ebp
  80248f:	89 f0                	mov    %esi,%eax
  802491:	f7 f5                	div    %ebp
  802493:	89 d0                	mov    %edx,%eax
  802495:	eb d0                	jmp    802467 <__umoddi3+0x27>
  802497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80249e:	66 90                	xchg   %ax,%ax
  8024a0:	89 f1                	mov    %esi,%ecx
  8024a2:	39 d8                	cmp    %ebx,%eax
  8024a4:	76 0a                	jbe    8024b0 <__umoddi3+0x70>
  8024a6:	89 f0                	mov    %esi,%eax
  8024a8:	83 c4 1c             	add    $0x1c,%esp
  8024ab:	5b                   	pop    %ebx
  8024ac:	5e                   	pop    %esi
  8024ad:	5f                   	pop    %edi
  8024ae:	5d                   	pop    %ebp
  8024af:	c3                   	ret    
  8024b0:	0f bd e8             	bsr    %eax,%ebp
  8024b3:	83 f5 1f             	xor    $0x1f,%ebp
  8024b6:	75 20                	jne    8024d8 <__umoddi3+0x98>
  8024b8:	39 d8                	cmp    %ebx,%eax
  8024ba:	0f 82 b0 00 00 00    	jb     802570 <__umoddi3+0x130>
  8024c0:	39 f7                	cmp    %esi,%edi
  8024c2:	0f 86 a8 00 00 00    	jbe    802570 <__umoddi3+0x130>
  8024c8:	89 c8                	mov    %ecx,%eax
  8024ca:	83 c4 1c             	add    $0x1c,%esp
  8024cd:	5b                   	pop    %ebx
  8024ce:	5e                   	pop    %esi
  8024cf:	5f                   	pop    %edi
  8024d0:	5d                   	pop    %ebp
  8024d1:	c3                   	ret    
  8024d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024d8:	89 e9                	mov    %ebp,%ecx
  8024da:	ba 20 00 00 00       	mov    $0x20,%edx
  8024df:	29 ea                	sub    %ebp,%edx
  8024e1:	d3 e0                	shl    %cl,%eax
  8024e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024e7:	89 d1                	mov    %edx,%ecx
  8024e9:	89 f8                	mov    %edi,%eax
  8024eb:	d3 e8                	shr    %cl,%eax
  8024ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024f9:	09 c1                	or     %eax,%ecx
  8024fb:	89 d8                	mov    %ebx,%eax
  8024fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802501:	89 e9                	mov    %ebp,%ecx
  802503:	d3 e7                	shl    %cl,%edi
  802505:	89 d1                	mov    %edx,%ecx
  802507:	d3 e8                	shr    %cl,%eax
  802509:	89 e9                	mov    %ebp,%ecx
  80250b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80250f:	d3 e3                	shl    %cl,%ebx
  802511:	89 c7                	mov    %eax,%edi
  802513:	89 d1                	mov    %edx,%ecx
  802515:	89 f0                	mov    %esi,%eax
  802517:	d3 e8                	shr    %cl,%eax
  802519:	89 e9                	mov    %ebp,%ecx
  80251b:	89 fa                	mov    %edi,%edx
  80251d:	d3 e6                	shl    %cl,%esi
  80251f:	09 d8                	or     %ebx,%eax
  802521:	f7 74 24 08          	divl   0x8(%esp)
  802525:	89 d1                	mov    %edx,%ecx
  802527:	89 f3                	mov    %esi,%ebx
  802529:	f7 64 24 0c          	mull   0xc(%esp)
  80252d:	89 c6                	mov    %eax,%esi
  80252f:	89 d7                	mov    %edx,%edi
  802531:	39 d1                	cmp    %edx,%ecx
  802533:	72 06                	jb     80253b <__umoddi3+0xfb>
  802535:	75 10                	jne    802547 <__umoddi3+0x107>
  802537:	39 c3                	cmp    %eax,%ebx
  802539:	73 0c                	jae    802547 <__umoddi3+0x107>
  80253b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80253f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802543:	89 d7                	mov    %edx,%edi
  802545:	89 c6                	mov    %eax,%esi
  802547:	89 ca                	mov    %ecx,%edx
  802549:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80254e:	29 f3                	sub    %esi,%ebx
  802550:	19 fa                	sbb    %edi,%edx
  802552:	89 d0                	mov    %edx,%eax
  802554:	d3 e0                	shl    %cl,%eax
  802556:	89 e9                	mov    %ebp,%ecx
  802558:	d3 eb                	shr    %cl,%ebx
  80255a:	d3 ea                	shr    %cl,%edx
  80255c:	09 d8                	or     %ebx,%eax
  80255e:	83 c4 1c             	add    $0x1c,%esp
  802561:	5b                   	pop    %ebx
  802562:	5e                   	pop    %esi
  802563:	5f                   	pop    %edi
  802564:	5d                   	pop    %ebp
  802565:	c3                   	ret    
  802566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80256d:	8d 76 00             	lea    0x0(%esi),%esi
  802570:	89 da                	mov    %ebx,%edx
  802572:	29 fe                	sub    %edi,%esi
  802574:	19 c2                	sbb    %eax,%edx
  802576:	89 f1                	mov    %esi,%ecx
  802578:	89 c8                	mov    %ecx,%eax
  80257a:	e9 4b ff ff ff       	jmp    8024ca <__umoddi3+0x8a>
