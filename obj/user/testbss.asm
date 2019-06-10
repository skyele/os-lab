
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
  800039:	68 20 26 80 00       	push   $0x802620
  80003e:	e8 9c 02 00 00       	call   8002df <cprintf>
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
  800090:	68 68 26 80 00       	push   $0x802668
  800095:	e8 45 02 00 00       	call   8002df <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  80009a:	c7 05 20 50 c0 00 00 	movl   $0x0,0xc05020
  8000a1:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  8000a4:	83 c4 0c             	add    $0xc,%esp
  8000a7:	68 c7 26 80 00       	push   $0x8026c7
  8000ac:	6a 1a                	push   $0x1a
  8000ae:	68 b8 26 80 00       	push   $0x8026b8
  8000b3:	e8 31 01 00 00       	call   8001e9 <_panic>
			panic("bigarray[%d] isn't cleared!\n", i);
  8000b8:	50                   	push   %eax
  8000b9:	68 9b 26 80 00       	push   $0x80269b
  8000be:	6a 11                	push   $0x11
  8000c0:	68 b8 26 80 00       	push   $0x8026b8
  8000c5:	e8 1f 01 00 00       	call   8001e9 <_panic>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000ca:	50                   	push   %eax
  8000cb:	68 40 26 80 00       	push   $0x802640
  8000d0:	6a 16                	push   $0x16
  8000d2:	68 b8 26 80 00       	push   $0x8026b8
  8000d7:	e8 0d 01 00 00       	call   8001e9 <_panic>

008000dc <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8000dc:	55                   	push   %ebp
  8000dd:	89 e5                	mov    %esp,%ebp
  8000df:	57                   	push   %edi
  8000e0:	56                   	push   %esi
  8000e1:	53                   	push   %ebx
  8000e2:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8000e5:	c7 05 20 40 c0 00 00 	movl   $0x0,0xc04020
  8000ec:	00 00 00 
	envid_t find = sys_getenvid();
  8000ef:	e8 fe 0c 00 00       	call   800df2 <sys_getenvid>
  8000f4:	8b 1d 20 40 c0 00    	mov    0xc04020,%ebx
  8000fa:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8000ff:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800104:	bf 01 00 00 00       	mov    $0x1,%edi
  800109:	eb 0b                	jmp    800116 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  80010b:	83 c2 01             	add    $0x1,%edx
  80010e:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800114:	74 21                	je     800137 <libmain+0x5b>
		if(envs[i].env_id == find)
  800116:	89 d1                	mov    %edx,%ecx
  800118:	c1 e1 07             	shl    $0x7,%ecx
  80011b:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800121:	8b 49 48             	mov    0x48(%ecx),%ecx
  800124:	39 c1                	cmp    %eax,%ecx
  800126:	75 e3                	jne    80010b <libmain+0x2f>
  800128:	89 d3                	mov    %edx,%ebx
  80012a:	c1 e3 07             	shl    $0x7,%ebx
  80012d:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800133:	89 fe                	mov    %edi,%esi
  800135:	eb d4                	jmp    80010b <libmain+0x2f>
  800137:	89 f0                	mov    %esi,%eax
  800139:	84 c0                	test   %al,%al
  80013b:	74 06                	je     800143 <libmain+0x67>
  80013d:	89 1d 20 40 c0 00    	mov    %ebx,0xc04020
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800143:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800147:	7e 0a                	jle    800153 <libmain+0x77>
		binaryname = argv[0];
  800149:	8b 45 0c             	mov    0xc(%ebp),%eax
  80014c:	8b 00                	mov    (%eax),%eax
  80014e:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800153:	a1 20 40 c0 00       	mov    0xc04020,%eax
  800158:	8b 40 48             	mov    0x48(%eax),%eax
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	50                   	push   %eax
  80015f:	68 de 26 80 00       	push   $0x8026de
  800164:	e8 76 01 00 00       	call   8002df <cprintf>
	cprintf("before umain\n");
  800169:	c7 04 24 fc 26 80 00 	movl   $0x8026fc,(%esp)
  800170:	e8 6a 01 00 00       	call   8002df <cprintf>
	// call user main routine
	umain(argc, argv);
  800175:	83 c4 08             	add    $0x8,%esp
  800178:	ff 75 0c             	pushl  0xc(%ebp)
  80017b:	ff 75 08             	pushl  0x8(%ebp)
  80017e:	e8 b0 fe ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800183:	c7 04 24 0a 27 80 00 	movl   $0x80270a,(%esp)
  80018a:	e8 50 01 00 00       	call   8002df <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80018f:	a1 20 40 c0 00       	mov    0xc04020,%eax
  800194:	8b 40 48             	mov    0x48(%eax),%eax
  800197:	83 c4 08             	add    $0x8,%esp
  80019a:	50                   	push   %eax
  80019b:	68 17 27 80 00       	push   $0x802717
  8001a0:	e8 3a 01 00 00       	call   8002df <cprintf>
	// exit gracefully
	exit();
  8001a5:	e8 0b 00 00 00       	call   8001b5 <exit>
}
  8001aa:	83 c4 10             	add    $0x10,%esp
  8001ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b0:	5b                   	pop    %ebx
  8001b1:	5e                   	pop    %esi
  8001b2:	5f                   	pop    %edi
  8001b3:	5d                   	pop    %ebp
  8001b4:	c3                   	ret    

008001b5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001bb:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8001c0:	8b 40 48             	mov    0x48(%eax),%eax
  8001c3:	68 44 27 80 00       	push   $0x802744
  8001c8:	50                   	push   %eax
  8001c9:	68 36 27 80 00       	push   $0x802736
  8001ce:	e8 0c 01 00 00       	call   8002df <cprintf>
	close_all();
  8001d3:	e8 25 11 00 00       	call   8012fd <close_all>
	sys_env_destroy(0);
  8001d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001df:	e8 cd 0b 00 00       	call   800db1 <sys_env_destroy>
}
  8001e4:	83 c4 10             	add    $0x10,%esp
  8001e7:	c9                   	leave  
  8001e8:	c3                   	ret    

008001e9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001e9:	55                   	push   %ebp
  8001ea:	89 e5                	mov    %esp,%ebp
  8001ec:	56                   	push   %esi
  8001ed:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001ee:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8001f3:	8b 40 48             	mov    0x48(%eax),%eax
  8001f6:	83 ec 04             	sub    $0x4,%esp
  8001f9:	68 70 27 80 00       	push   $0x802770
  8001fe:	50                   	push   %eax
  8001ff:	68 36 27 80 00       	push   $0x802736
  800204:	e8 d6 00 00 00       	call   8002df <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800209:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80020c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800212:	e8 db 0b 00 00       	call   800df2 <sys_getenvid>
  800217:	83 c4 04             	add    $0x4,%esp
  80021a:	ff 75 0c             	pushl  0xc(%ebp)
  80021d:	ff 75 08             	pushl  0x8(%ebp)
  800220:	56                   	push   %esi
  800221:	50                   	push   %eax
  800222:	68 4c 27 80 00       	push   $0x80274c
  800227:	e8 b3 00 00 00       	call   8002df <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80022c:	83 c4 18             	add    $0x18,%esp
  80022f:	53                   	push   %ebx
  800230:	ff 75 10             	pushl  0x10(%ebp)
  800233:	e8 56 00 00 00       	call   80028e <vcprintf>
	cprintf("\n");
  800238:	c7 04 24 b6 26 80 00 	movl   $0x8026b6,(%esp)
  80023f:	e8 9b 00 00 00       	call   8002df <cprintf>
  800244:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800247:	cc                   	int3   
  800248:	eb fd                	jmp    800247 <_panic+0x5e>

0080024a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80024a:	55                   	push   %ebp
  80024b:	89 e5                	mov    %esp,%ebp
  80024d:	53                   	push   %ebx
  80024e:	83 ec 04             	sub    $0x4,%esp
  800251:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800254:	8b 13                	mov    (%ebx),%edx
  800256:	8d 42 01             	lea    0x1(%edx),%eax
  800259:	89 03                	mov    %eax,(%ebx)
  80025b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80025e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800262:	3d ff 00 00 00       	cmp    $0xff,%eax
  800267:	74 09                	je     800272 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800269:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80026d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800270:	c9                   	leave  
  800271:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	68 ff 00 00 00       	push   $0xff
  80027a:	8d 43 08             	lea    0x8(%ebx),%eax
  80027d:	50                   	push   %eax
  80027e:	e8 f1 0a 00 00       	call   800d74 <sys_cputs>
		b->idx = 0;
  800283:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800289:	83 c4 10             	add    $0x10,%esp
  80028c:	eb db                	jmp    800269 <putch+0x1f>

0080028e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800297:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80029e:	00 00 00 
	b.cnt = 0;
  8002a1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002a8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002ab:	ff 75 0c             	pushl  0xc(%ebp)
  8002ae:	ff 75 08             	pushl  0x8(%ebp)
  8002b1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b7:	50                   	push   %eax
  8002b8:	68 4a 02 80 00       	push   $0x80024a
  8002bd:	e8 4a 01 00 00       	call   80040c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002c2:	83 c4 08             	add    $0x8,%esp
  8002c5:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002cb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002d1:	50                   	push   %eax
  8002d2:	e8 9d 0a 00 00       	call   800d74 <sys_cputs>

	return b.cnt;
}
  8002d7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002dd:	c9                   	leave  
  8002de:	c3                   	ret    

008002df <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002df:	55                   	push   %ebp
  8002e0:	89 e5                	mov    %esp,%ebp
  8002e2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002e5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002e8:	50                   	push   %eax
  8002e9:	ff 75 08             	pushl  0x8(%ebp)
  8002ec:	e8 9d ff ff ff       	call   80028e <vcprintf>
	va_end(ap);

	return cnt;
}
  8002f1:	c9                   	leave  
  8002f2:	c3                   	ret    

008002f3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002f3:	55                   	push   %ebp
  8002f4:	89 e5                	mov    %esp,%ebp
  8002f6:	57                   	push   %edi
  8002f7:	56                   	push   %esi
  8002f8:	53                   	push   %ebx
  8002f9:	83 ec 1c             	sub    $0x1c,%esp
  8002fc:	89 c6                	mov    %eax,%esi
  8002fe:	89 d7                	mov    %edx,%edi
  800300:	8b 45 08             	mov    0x8(%ebp),%eax
  800303:	8b 55 0c             	mov    0xc(%ebp),%edx
  800306:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800309:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80030c:	8b 45 10             	mov    0x10(%ebp),%eax
  80030f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800312:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800316:	74 2c                	je     800344 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800318:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80031b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800322:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800325:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800328:	39 c2                	cmp    %eax,%edx
  80032a:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80032d:	73 43                	jae    800372 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80032f:	83 eb 01             	sub    $0x1,%ebx
  800332:	85 db                	test   %ebx,%ebx
  800334:	7e 6c                	jle    8003a2 <printnum+0xaf>
				putch(padc, putdat);
  800336:	83 ec 08             	sub    $0x8,%esp
  800339:	57                   	push   %edi
  80033a:	ff 75 18             	pushl  0x18(%ebp)
  80033d:	ff d6                	call   *%esi
  80033f:	83 c4 10             	add    $0x10,%esp
  800342:	eb eb                	jmp    80032f <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800344:	83 ec 0c             	sub    $0xc,%esp
  800347:	6a 20                	push   $0x20
  800349:	6a 00                	push   $0x0
  80034b:	50                   	push   %eax
  80034c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80034f:	ff 75 e0             	pushl  -0x20(%ebp)
  800352:	89 fa                	mov    %edi,%edx
  800354:	89 f0                	mov    %esi,%eax
  800356:	e8 98 ff ff ff       	call   8002f3 <printnum>
		while (--width > 0)
  80035b:	83 c4 20             	add    $0x20,%esp
  80035e:	83 eb 01             	sub    $0x1,%ebx
  800361:	85 db                	test   %ebx,%ebx
  800363:	7e 65                	jle    8003ca <printnum+0xd7>
			putch(padc, putdat);
  800365:	83 ec 08             	sub    $0x8,%esp
  800368:	57                   	push   %edi
  800369:	6a 20                	push   $0x20
  80036b:	ff d6                	call   *%esi
  80036d:	83 c4 10             	add    $0x10,%esp
  800370:	eb ec                	jmp    80035e <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800372:	83 ec 0c             	sub    $0xc,%esp
  800375:	ff 75 18             	pushl  0x18(%ebp)
  800378:	83 eb 01             	sub    $0x1,%ebx
  80037b:	53                   	push   %ebx
  80037c:	50                   	push   %eax
  80037d:	83 ec 08             	sub    $0x8,%esp
  800380:	ff 75 dc             	pushl  -0x24(%ebp)
  800383:	ff 75 d8             	pushl  -0x28(%ebp)
  800386:	ff 75 e4             	pushl  -0x1c(%ebp)
  800389:	ff 75 e0             	pushl  -0x20(%ebp)
  80038c:	e8 2f 20 00 00       	call   8023c0 <__udivdi3>
  800391:	83 c4 18             	add    $0x18,%esp
  800394:	52                   	push   %edx
  800395:	50                   	push   %eax
  800396:	89 fa                	mov    %edi,%edx
  800398:	89 f0                	mov    %esi,%eax
  80039a:	e8 54 ff ff ff       	call   8002f3 <printnum>
  80039f:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8003a2:	83 ec 08             	sub    $0x8,%esp
  8003a5:	57                   	push   %edi
  8003a6:	83 ec 04             	sub    $0x4,%esp
  8003a9:	ff 75 dc             	pushl  -0x24(%ebp)
  8003ac:	ff 75 d8             	pushl  -0x28(%ebp)
  8003af:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003b2:	ff 75 e0             	pushl  -0x20(%ebp)
  8003b5:	e8 16 21 00 00       	call   8024d0 <__umoddi3>
  8003ba:	83 c4 14             	add    $0x14,%esp
  8003bd:	0f be 80 77 27 80 00 	movsbl 0x802777(%eax),%eax
  8003c4:	50                   	push   %eax
  8003c5:	ff d6                	call   *%esi
  8003c7:	83 c4 10             	add    $0x10,%esp
	}
}
  8003ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003cd:	5b                   	pop    %ebx
  8003ce:	5e                   	pop    %esi
  8003cf:	5f                   	pop    %edi
  8003d0:	5d                   	pop    %ebp
  8003d1:	c3                   	ret    

008003d2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003d2:	55                   	push   %ebp
  8003d3:	89 e5                	mov    %esp,%ebp
  8003d5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003d8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003dc:	8b 10                	mov    (%eax),%edx
  8003de:	3b 50 04             	cmp    0x4(%eax),%edx
  8003e1:	73 0a                	jae    8003ed <sprintputch+0x1b>
		*b->buf++ = ch;
  8003e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003e6:	89 08                	mov    %ecx,(%eax)
  8003e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003eb:	88 02                	mov    %al,(%edx)
}
  8003ed:	5d                   	pop    %ebp
  8003ee:	c3                   	ret    

008003ef <printfmt>:
{
  8003ef:	55                   	push   %ebp
  8003f0:	89 e5                	mov    %esp,%ebp
  8003f2:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003f5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003f8:	50                   	push   %eax
  8003f9:	ff 75 10             	pushl  0x10(%ebp)
  8003fc:	ff 75 0c             	pushl  0xc(%ebp)
  8003ff:	ff 75 08             	pushl  0x8(%ebp)
  800402:	e8 05 00 00 00       	call   80040c <vprintfmt>
}
  800407:	83 c4 10             	add    $0x10,%esp
  80040a:	c9                   	leave  
  80040b:	c3                   	ret    

0080040c <vprintfmt>:
{
  80040c:	55                   	push   %ebp
  80040d:	89 e5                	mov    %esp,%ebp
  80040f:	57                   	push   %edi
  800410:	56                   	push   %esi
  800411:	53                   	push   %ebx
  800412:	83 ec 3c             	sub    $0x3c,%esp
  800415:	8b 75 08             	mov    0x8(%ebp),%esi
  800418:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80041b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80041e:	e9 32 04 00 00       	jmp    800855 <vprintfmt+0x449>
		padc = ' ';
  800423:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800427:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80042e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800435:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80043c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800443:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80044a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80044f:	8d 47 01             	lea    0x1(%edi),%eax
  800452:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800455:	0f b6 17             	movzbl (%edi),%edx
  800458:	8d 42 dd             	lea    -0x23(%edx),%eax
  80045b:	3c 55                	cmp    $0x55,%al
  80045d:	0f 87 12 05 00 00    	ja     800975 <vprintfmt+0x569>
  800463:	0f b6 c0             	movzbl %al,%eax
  800466:	ff 24 85 60 29 80 00 	jmp    *0x802960(,%eax,4)
  80046d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800470:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800474:	eb d9                	jmp    80044f <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800476:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800479:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80047d:	eb d0                	jmp    80044f <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80047f:	0f b6 d2             	movzbl %dl,%edx
  800482:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800485:	b8 00 00 00 00       	mov    $0x0,%eax
  80048a:	89 75 08             	mov    %esi,0x8(%ebp)
  80048d:	eb 03                	jmp    800492 <vprintfmt+0x86>
  80048f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800492:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800495:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800499:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80049c:	8d 72 d0             	lea    -0x30(%edx),%esi
  80049f:	83 fe 09             	cmp    $0x9,%esi
  8004a2:	76 eb                	jbe    80048f <vprintfmt+0x83>
  8004a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004a7:	8b 75 08             	mov    0x8(%ebp),%esi
  8004aa:	eb 14                	jmp    8004c0 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8004ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8004af:	8b 00                	mov    (%eax),%eax
  8004b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b7:	8d 40 04             	lea    0x4(%eax),%eax
  8004ba:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004c0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004c4:	79 89                	jns    80044f <vprintfmt+0x43>
				width = precision, precision = -1;
  8004c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004cc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004d3:	e9 77 ff ff ff       	jmp    80044f <vprintfmt+0x43>
  8004d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004db:	85 c0                	test   %eax,%eax
  8004dd:	0f 48 c1             	cmovs  %ecx,%eax
  8004e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004e6:	e9 64 ff ff ff       	jmp    80044f <vprintfmt+0x43>
  8004eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004ee:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004f5:	e9 55 ff ff ff       	jmp    80044f <vprintfmt+0x43>
			lflag++;
  8004fa:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800501:	e9 49 ff ff ff       	jmp    80044f <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800506:	8b 45 14             	mov    0x14(%ebp),%eax
  800509:	8d 78 04             	lea    0x4(%eax),%edi
  80050c:	83 ec 08             	sub    $0x8,%esp
  80050f:	53                   	push   %ebx
  800510:	ff 30                	pushl  (%eax)
  800512:	ff d6                	call   *%esi
			break;
  800514:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800517:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80051a:	e9 33 03 00 00       	jmp    800852 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80051f:	8b 45 14             	mov    0x14(%ebp),%eax
  800522:	8d 78 04             	lea    0x4(%eax),%edi
  800525:	8b 00                	mov    (%eax),%eax
  800527:	99                   	cltd   
  800528:	31 d0                	xor    %edx,%eax
  80052a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80052c:	83 f8 11             	cmp    $0x11,%eax
  80052f:	7f 23                	jg     800554 <vprintfmt+0x148>
  800531:	8b 14 85 c0 2a 80 00 	mov    0x802ac0(,%eax,4),%edx
  800538:	85 d2                	test   %edx,%edx
  80053a:	74 18                	je     800554 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80053c:	52                   	push   %edx
  80053d:	68 e1 2b 80 00       	push   $0x802be1
  800542:	53                   	push   %ebx
  800543:	56                   	push   %esi
  800544:	e8 a6 fe ff ff       	call   8003ef <printfmt>
  800549:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80054c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80054f:	e9 fe 02 00 00       	jmp    800852 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800554:	50                   	push   %eax
  800555:	68 8f 27 80 00       	push   $0x80278f
  80055a:	53                   	push   %ebx
  80055b:	56                   	push   %esi
  80055c:	e8 8e fe ff ff       	call   8003ef <printfmt>
  800561:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800564:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800567:	e9 e6 02 00 00       	jmp    800852 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80056c:	8b 45 14             	mov    0x14(%ebp),%eax
  80056f:	83 c0 04             	add    $0x4,%eax
  800572:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800575:	8b 45 14             	mov    0x14(%ebp),%eax
  800578:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80057a:	85 c9                	test   %ecx,%ecx
  80057c:	b8 88 27 80 00       	mov    $0x802788,%eax
  800581:	0f 45 c1             	cmovne %ecx,%eax
  800584:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800587:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80058b:	7e 06                	jle    800593 <vprintfmt+0x187>
  80058d:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800591:	75 0d                	jne    8005a0 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800593:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800596:	89 c7                	mov    %eax,%edi
  800598:	03 45 e0             	add    -0x20(%ebp),%eax
  80059b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80059e:	eb 53                	jmp    8005f3 <vprintfmt+0x1e7>
  8005a0:	83 ec 08             	sub    $0x8,%esp
  8005a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8005a6:	50                   	push   %eax
  8005a7:	e8 71 04 00 00       	call   800a1d <strnlen>
  8005ac:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005af:	29 c1                	sub    %eax,%ecx
  8005b1:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8005b4:	83 c4 10             	add    $0x10,%esp
  8005b7:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005b9:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c0:	eb 0f                	jmp    8005d1 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8005c2:	83 ec 08             	sub    $0x8,%esp
  8005c5:	53                   	push   %ebx
  8005c6:	ff 75 e0             	pushl  -0x20(%ebp)
  8005c9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005cb:	83 ef 01             	sub    $0x1,%edi
  8005ce:	83 c4 10             	add    $0x10,%esp
  8005d1:	85 ff                	test   %edi,%edi
  8005d3:	7f ed                	jg     8005c2 <vprintfmt+0x1b6>
  8005d5:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8005d8:	85 c9                	test   %ecx,%ecx
  8005da:	b8 00 00 00 00       	mov    $0x0,%eax
  8005df:	0f 49 c1             	cmovns %ecx,%eax
  8005e2:	29 c1                	sub    %eax,%ecx
  8005e4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005e7:	eb aa                	jmp    800593 <vprintfmt+0x187>
					putch(ch, putdat);
  8005e9:	83 ec 08             	sub    $0x8,%esp
  8005ec:	53                   	push   %ebx
  8005ed:	52                   	push   %edx
  8005ee:	ff d6                	call   *%esi
  8005f0:	83 c4 10             	add    $0x10,%esp
  8005f3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005f6:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005f8:	83 c7 01             	add    $0x1,%edi
  8005fb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005ff:	0f be d0             	movsbl %al,%edx
  800602:	85 d2                	test   %edx,%edx
  800604:	74 4b                	je     800651 <vprintfmt+0x245>
  800606:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80060a:	78 06                	js     800612 <vprintfmt+0x206>
  80060c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800610:	78 1e                	js     800630 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800612:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800616:	74 d1                	je     8005e9 <vprintfmt+0x1dd>
  800618:	0f be c0             	movsbl %al,%eax
  80061b:	83 e8 20             	sub    $0x20,%eax
  80061e:	83 f8 5e             	cmp    $0x5e,%eax
  800621:	76 c6                	jbe    8005e9 <vprintfmt+0x1dd>
					putch('?', putdat);
  800623:	83 ec 08             	sub    $0x8,%esp
  800626:	53                   	push   %ebx
  800627:	6a 3f                	push   $0x3f
  800629:	ff d6                	call   *%esi
  80062b:	83 c4 10             	add    $0x10,%esp
  80062e:	eb c3                	jmp    8005f3 <vprintfmt+0x1e7>
  800630:	89 cf                	mov    %ecx,%edi
  800632:	eb 0e                	jmp    800642 <vprintfmt+0x236>
				putch(' ', putdat);
  800634:	83 ec 08             	sub    $0x8,%esp
  800637:	53                   	push   %ebx
  800638:	6a 20                	push   $0x20
  80063a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80063c:	83 ef 01             	sub    $0x1,%edi
  80063f:	83 c4 10             	add    $0x10,%esp
  800642:	85 ff                	test   %edi,%edi
  800644:	7f ee                	jg     800634 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800646:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800649:	89 45 14             	mov    %eax,0x14(%ebp)
  80064c:	e9 01 02 00 00       	jmp    800852 <vprintfmt+0x446>
  800651:	89 cf                	mov    %ecx,%edi
  800653:	eb ed                	jmp    800642 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800655:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800658:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80065f:	e9 eb fd ff ff       	jmp    80044f <vprintfmt+0x43>
	if (lflag >= 2)
  800664:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800668:	7f 21                	jg     80068b <vprintfmt+0x27f>
	else if (lflag)
  80066a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80066e:	74 68                	je     8006d8 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800678:	89 c1                	mov    %eax,%ecx
  80067a:	c1 f9 1f             	sar    $0x1f,%ecx
  80067d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	8d 40 04             	lea    0x4(%eax),%eax
  800686:	89 45 14             	mov    %eax,0x14(%ebp)
  800689:	eb 17                	jmp    8006a2 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80068b:	8b 45 14             	mov    0x14(%ebp),%eax
  80068e:	8b 50 04             	mov    0x4(%eax),%edx
  800691:	8b 00                	mov    (%eax),%eax
  800693:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800696:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800699:	8b 45 14             	mov    0x14(%ebp),%eax
  80069c:	8d 40 08             	lea    0x8(%eax),%eax
  80069f:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006a2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006a5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ab:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8006ae:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006b2:	78 3f                	js     8006f3 <vprintfmt+0x2e7>
			base = 10;
  8006b4:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8006b9:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8006bd:	0f 84 71 01 00 00    	je     800834 <vprintfmt+0x428>
				putch('+', putdat);
  8006c3:	83 ec 08             	sub    $0x8,%esp
  8006c6:	53                   	push   %ebx
  8006c7:	6a 2b                	push   $0x2b
  8006c9:	ff d6                	call   *%esi
  8006cb:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006ce:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d3:	e9 5c 01 00 00       	jmp    800834 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8006d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006e0:	89 c1                	mov    %eax,%ecx
  8006e2:	c1 f9 1f             	sar    $0x1f,%ecx
  8006e5:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006eb:	8d 40 04             	lea    0x4(%eax),%eax
  8006ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f1:	eb af                	jmp    8006a2 <vprintfmt+0x296>
				putch('-', putdat);
  8006f3:	83 ec 08             	sub    $0x8,%esp
  8006f6:	53                   	push   %ebx
  8006f7:	6a 2d                	push   $0x2d
  8006f9:	ff d6                	call   *%esi
				num = -(long long) num;
  8006fb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006fe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800701:	f7 d8                	neg    %eax
  800703:	83 d2 00             	adc    $0x0,%edx
  800706:	f7 da                	neg    %edx
  800708:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80070b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80070e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800711:	b8 0a 00 00 00       	mov    $0xa,%eax
  800716:	e9 19 01 00 00       	jmp    800834 <vprintfmt+0x428>
	if (lflag >= 2)
  80071b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80071f:	7f 29                	jg     80074a <vprintfmt+0x33e>
	else if (lflag)
  800721:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800725:	74 44                	je     80076b <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800727:	8b 45 14             	mov    0x14(%ebp),%eax
  80072a:	8b 00                	mov    (%eax),%eax
  80072c:	ba 00 00 00 00       	mov    $0x0,%edx
  800731:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800734:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800737:	8b 45 14             	mov    0x14(%ebp),%eax
  80073a:	8d 40 04             	lea    0x4(%eax),%eax
  80073d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800740:	b8 0a 00 00 00       	mov    $0xa,%eax
  800745:	e9 ea 00 00 00       	jmp    800834 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80074a:	8b 45 14             	mov    0x14(%ebp),%eax
  80074d:	8b 50 04             	mov    0x4(%eax),%edx
  800750:	8b 00                	mov    (%eax),%eax
  800752:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800755:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800758:	8b 45 14             	mov    0x14(%ebp),%eax
  80075b:	8d 40 08             	lea    0x8(%eax),%eax
  80075e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800761:	b8 0a 00 00 00       	mov    $0xa,%eax
  800766:	e9 c9 00 00 00       	jmp    800834 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80076b:	8b 45 14             	mov    0x14(%ebp),%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	ba 00 00 00 00       	mov    $0x0,%edx
  800775:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800778:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077b:	8b 45 14             	mov    0x14(%ebp),%eax
  80077e:	8d 40 04             	lea    0x4(%eax),%eax
  800781:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800784:	b8 0a 00 00 00       	mov    $0xa,%eax
  800789:	e9 a6 00 00 00       	jmp    800834 <vprintfmt+0x428>
			putch('0', putdat);
  80078e:	83 ec 08             	sub    $0x8,%esp
  800791:	53                   	push   %ebx
  800792:	6a 30                	push   $0x30
  800794:	ff d6                	call   *%esi
	if (lflag >= 2)
  800796:	83 c4 10             	add    $0x10,%esp
  800799:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80079d:	7f 26                	jg     8007c5 <vprintfmt+0x3b9>
	else if (lflag)
  80079f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007a3:	74 3e                	je     8007e3 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8007a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a8:	8b 00                	mov    (%eax),%eax
  8007aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8007af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b8:	8d 40 04             	lea    0x4(%eax),%eax
  8007bb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007be:	b8 08 00 00 00       	mov    $0x8,%eax
  8007c3:	eb 6f                	jmp    800834 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	8b 50 04             	mov    0x4(%eax),%edx
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	8d 40 08             	lea    0x8(%eax),%eax
  8007d9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007dc:	b8 08 00 00 00       	mov    $0x8,%eax
  8007e1:	eb 51                	jmp    800834 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e6:	8b 00                	mov    (%eax),%eax
  8007e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f6:	8d 40 04             	lea    0x4(%eax),%eax
  8007f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007fc:	b8 08 00 00 00       	mov    $0x8,%eax
  800801:	eb 31                	jmp    800834 <vprintfmt+0x428>
			putch('0', putdat);
  800803:	83 ec 08             	sub    $0x8,%esp
  800806:	53                   	push   %ebx
  800807:	6a 30                	push   $0x30
  800809:	ff d6                	call   *%esi
			putch('x', putdat);
  80080b:	83 c4 08             	add    $0x8,%esp
  80080e:	53                   	push   %ebx
  80080f:	6a 78                	push   $0x78
  800811:	ff d6                	call   *%esi
			num = (unsigned long long)
  800813:	8b 45 14             	mov    0x14(%ebp),%eax
  800816:	8b 00                	mov    (%eax),%eax
  800818:	ba 00 00 00 00       	mov    $0x0,%edx
  80081d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800820:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800823:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800826:	8b 45 14             	mov    0x14(%ebp),%eax
  800829:	8d 40 04             	lea    0x4(%eax),%eax
  80082c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80082f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800834:	83 ec 0c             	sub    $0xc,%esp
  800837:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80083b:	52                   	push   %edx
  80083c:	ff 75 e0             	pushl  -0x20(%ebp)
  80083f:	50                   	push   %eax
  800840:	ff 75 dc             	pushl  -0x24(%ebp)
  800843:	ff 75 d8             	pushl  -0x28(%ebp)
  800846:	89 da                	mov    %ebx,%edx
  800848:	89 f0                	mov    %esi,%eax
  80084a:	e8 a4 fa ff ff       	call   8002f3 <printnum>
			break;
  80084f:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800852:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800855:	83 c7 01             	add    $0x1,%edi
  800858:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80085c:	83 f8 25             	cmp    $0x25,%eax
  80085f:	0f 84 be fb ff ff    	je     800423 <vprintfmt+0x17>
			if (ch == '\0')
  800865:	85 c0                	test   %eax,%eax
  800867:	0f 84 28 01 00 00    	je     800995 <vprintfmt+0x589>
			putch(ch, putdat);
  80086d:	83 ec 08             	sub    $0x8,%esp
  800870:	53                   	push   %ebx
  800871:	50                   	push   %eax
  800872:	ff d6                	call   *%esi
  800874:	83 c4 10             	add    $0x10,%esp
  800877:	eb dc                	jmp    800855 <vprintfmt+0x449>
	if (lflag >= 2)
  800879:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80087d:	7f 26                	jg     8008a5 <vprintfmt+0x499>
	else if (lflag)
  80087f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800883:	74 41                	je     8008c6 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800885:	8b 45 14             	mov    0x14(%ebp),%eax
  800888:	8b 00                	mov    (%eax),%eax
  80088a:	ba 00 00 00 00       	mov    $0x0,%edx
  80088f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800892:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800895:	8b 45 14             	mov    0x14(%ebp),%eax
  800898:	8d 40 04             	lea    0x4(%eax),%eax
  80089b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80089e:	b8 10 00 00 00       	mov    $0x10,%eax
  8008a3:	eb 8f                	jmp    800834 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	8b 50 04             	mov    0x4(%eax),%edx
  8008ab:	8b 00                	mov    (%eax),%eax
  8008ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	8d 40 08             	lea    0x8(%eax),%eax
  8008b9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008bc:	b8 10 00 00 00       	mov    $0x10,%eax
  8008c1:	e9 6e ff ff ff       	jmp    800834 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c9:	8b 00                	mov    (%eax),%eax
  8008cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d9:	8d 40 04             	lea    0x4(%eax),%eax
  8008dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008df:	b8 10 00 00 00       	mov    $0x10,%eax
  8008e4:	e9 4b ff ff ff       	jmp    800834 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8008e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ec:	83 c0 04             	add    $0x4,%eax
  8008ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	85 c0                	test   %eax,%eax
  8008f9:	74 14                	je     80090f <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8008fb:	8b 13                	mov    (%ebx),%edx
  8008fd:	83 fa 7f             	cmp    $0x7f,%edx
  800900:	7f 37                	jg     800939 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800902:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800904:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800907:	89 45 14             	mov    %eax,0x14(%ebp)
  80090a:	e9 43 ff ff ff       	jmp    800852 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80090f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800914:	bf ad 28 80 00       	mov    $0x8028ad,%edi
							putch(ch, putdat);
  800919:	83 ec 08             	sub    $0x8,%esp
  80091c:	53                   	push   %ebx
  80091d:	50                   	push   %eax
  80091e:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800920:	83 c7 01             	add    $0x1,%edi
  800923:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800927:	83 c4 10             	add    $0x10,%esp
  80092a:	85 c0                	test   %eax,%eax
  80092c:	75 eb                	jne    800919 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80092e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800931:	89 45 14             	mov    %eax,0x14(%ebp)
  800934:	e9 19 ff ff ff       	jmp    800852 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800939:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80093b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800940:	bf e5 28 80 00       	mov    $0x8028e5,%edi
							putch(ch, putdat);
  800945:	83 ec 08             	sub    $0x8,%esp
  800948:	53                   	push   %ebx
  800949:	50                   	push   %eax
  80094a:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80094c:	83 c7 01             	add    $0x1,%edi
  80094f:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800953:	83 c4 10             	add    $0x10,%esp
  800956:	85 c0                	test   %eax,%eax
  800958:	75 eb                	jne    800945 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80095a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80095d:	89 45 14             	mov    %eax,0x14(%ebp)
  800960:	e9 ed fe ff ff       	jmp    800852 <vprintfmt+0x446>
			putch(ch, putdat);
  800965:	83 ec 08             	sub    $0x8,%esp
  800968:	53                   	push   %ebx
  800969:	6a 25                	push   $0x25
  80096b:	ff d6                	call   *%esi
			break;
  80096d:	83 c4 10             	add    $0x10,%esp
  800970:	e9 dd fe ff ff       	jmp    800852 <vprintfmt+0x446>
			putch('%', putdat);
  800975:	83 ec 08             	sub    $0x8,%esp
  800978:	53                   	push   %ebx
  800979:	6a 25                	push   $0x25
  80097b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80097d:	83 c4 10             	add    $0x10,%esp
  800980:	89 f8                	mov    %edi,%eax
  800982:	eb 03                	jmp    800987 <vprintfmt+0x57b>
  800984:	83 e8 01             	sub    $0x1,%eax
  800987:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80098b:	75 f7                	jne    800984 <vprintfmt+0x578>
  80098d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800990:	e9 bd fe ff ff       	jmp    800852 <vprintfmt+0x446>
}
  800995:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800998:	5b                   	pop    %ebx
  800999:	5e                   	pop    %esi
  80099a:	5f                   	pop    %edi
  80099b:	5d                   	pop    %ebp
  80099c:	c3                   	ret    

0080099d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80099d:	55                   	push   %ebp
  80099e:	89 e5                	mov    %esp,%ebp
  8009a0:	83 ec 18             	sub    $0x18,%esp
  8009a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a6:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009ac:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009b0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009ba:	85 c0                	test   %eax,%eax
  8009bc:	74 26                	je     8009e4 <vsnprintf+0x47>
  8009be:	85 d2                	test   %edx,%edx
  8009c0:	7e 22                	jle    8009e4 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009c2:	ff 75 14             	pushl  0x14(%ebp)
  8009c5:	ff 75 10             	pushl  0x10(%ebp)
  8009c8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009cb:	50                   	push   %eax
  8009cc:	68 d2 03 80 00       	push   $0x8003d2
  8009d1:	e8 36 fa ff ff       	call   80040c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009d9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009df:	83 c4 10             	add    $0x10,%esp
}
  8009e2:	c9                   	leave  
  8009e3:	c3                   	ret    
		return -E_INVAL;
  8009e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009e9:	eb f7                	jmp    8009e2 <vsnprintf+0x45>

008009eb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009eb:	55                   	push   %ebp
  8009ec:	89 e5                	mov    %esp,%ebp
  8009ee:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009f1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009f4:	50                   	push   %eax
  8009f5:	ff 75 10             	pushl  0x10(%ebp)
  8009f8:	ff 75 0c             	pushl  0xc(%ebp)
  8009fb:	ff 75 08             	pushl  0x8(%ebp)
  8009fe:	e8 9a ff ff ff       	call   80099d <vsnprintf>
	va_end(ap);

	return rc;
}
  800a03:	c9                   	leave  
  800a04:	c3                   	ret    

00800a05 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a10:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a14:	74 05                	je     800a1b <strlen+0x16>
		n++;
  800a16:	83 c0 01             	add    $0x1,%eax
  800a19:	eb f5                	jmp    800a10 <strlen+0xb>
	return n;
}
  800a1b:	5d                   	pop    %ebp
  800a1c:	c3                   	ret    

00800a1d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a1d:	55                   	push   %ebp
  800a1e:	89 e5                	mov    %esp,%ebp
  800a20:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a23:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a26:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2b:	39 c2                	cmp    %eax,%edx
  800a2d:	74 0d                	je     800a3c <strnlen+0x1f>
  800a2f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a33:	74 05                	je     800a3a <strnlen+0x1d>
		n++;
  800a35:	83 c2 01             	add    $0x1,%edx
  800a38:	eb f1                	jmp    800a2b <strnlen+0xe>
  800a3a:	89 d0                	mov    %edx,%eax
	return n;
}
  800a3c:	5d                   	pop    %ebp
  800a3d:	c3                   	ret    

00800a3e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a3e:	55                   	push   %ebp
  800a3f:	89 e5                	mov    %esp,%ebp
  800a41:	53                   	push   %ebx
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a48:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4d:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a51:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a54:	83 c2 01             	add    $0x1,%edx
  800a57:	84 c9                	test   %cl,%cl
  800a59:	75 f2                	jne    800a4d <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a5b:	5b                   	pop    %ebx
  800a5c:	5d                   	pop    %ebp
  800a5d:	c3                   	ret    

00800a5e <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a5e:	55                   	push   %ebp
  800a5f:	89 e5                	mov    %esp,%ebp
  800a61:	53                   	push   %ebx
  800a62:	83 ec 10             	sub    $0x10,%esp
  800a65:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a68:	53                   	push   %ebx
  800a69:	e8 97 ff ff ff       	call   800a05 <strlen>
  800a6e:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a71:	ff 75 0c             	pushl  0xc(%ebp)
  800a74:	01 d8                	add    %ebx,%eax
  800a76:	50                   	push   %eax
  800a77:	e8 c2 ff ff ff       	call   800a3e <strcpy>
	return dst;
}
  800a7c:	89 d8                	mov    %ebx,%eax
  800a7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a81:	c9                   	leave  
  800a82:	c3                   	ret    

00800a83 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a83:	55                   	push   %ebp
  800a84:	89 e5                	mov    %esp,%ebp
  800a86:	56                   	push   %esi
  800a87:	53                   	push   %ebx
  800a88:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a8e:	89 c6                	mov    %eax,%esi
  800a90:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a93:	89 c2                	mov    %eax,%edx
  800a95:	39 f2                	cmp    %esi,%edx
  800a97:	74 11                	je     800aaa <strncpy+0x27>
		*dst++ = *src;
  800a99:	83 c2 01             	add    $0x1,%edx
  800a9c:	0f b6 19             	movzbl (%ecx),%ebx
  800a9f:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aa2:	80 fb 01             	cmp    $0x1,%bl
  800aa5:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800aa8:	eb eb                	jmp    800a95 <strncpy+0x12>
	}
	return ret;
}
  800aaa:	5b                   	pop    %ebx
  800aab:	5e                   	pop    %esi
  800aac:	5d                   	pop    %ebp
  800aad:	c3                   	ret    

00800aae <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	56                   	push   %esi
  800ab2:	53                   	push   %ebx
  800ab3:	8b 75 08             	mov    0x8(%ebp),%esi
  800ab6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ab9:	8b 55 10             	mov    0x10(%ebp),%edx
  800abc:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800abe:	85 d2                	test   %edx,%edx
  800ac0:	74 21                	je     800ae3 <strlcpy+0x35>
  800ac2:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ac6:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ac8:	39 c2                	cmp    %eax,%edx
  800aca:	74 14                	je     800ae0 <strlcpy+0x32>
  800acc:	0f b6 19             	movzbl (%ecx),%ebx
  800acf:	84 db                	test   %bl,%bl
  800ad1:	74 0b                	je     800ade <strlcpy+0x30>
			*dst++ = *src++;
  800ad3:	83 c1 01             	add    $0x1,%ecx
  800ad6:	83 c2 01             	add    $0x1,%edx
  800ad9:	88 5a ff             	mov    %bl,-0x1(%edx)
  800adc:	eb ea                	jmp    800ac8 <strlcpy+0x1a>
  800ade:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ae0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ae3:	29 f0                	sub    %esi,%eax
}
  800ae5:	5b                   	pop    %ebx
  800ae6:	5e                   	pop    %esi
  800ae7:	5d                   	pop    %ebp
  800ae8:	c3                   	ret    

00800ae9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
  800aec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aef:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800af2:	0f b6 01             	movzbl (%ecx),%eax
  800af5:	84 c0                	test   %al,%al
  800af7:	74 0c                	je     800b05 <strcmp+0x1c>
  800af9:	3a 02                	cmp    (%edx),%al
  800afb:	75 08                	jne    800b05 <strcmp+0x1c>
		p++, q++;
  800afd:	83 c1 01             	add    $0x1,%ecx
  800b00:	83 c2 01             	add    $0x1,%edx
  800b03:	eb ed                	jmp    800af2 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b05:	0f b6 c0             	movzbl %al,%eax
  800b08:	0f b6 12             	movzbl (%edx),%edx
  800b0b:	29 d0                	sub    %edx,%eax
}
  800b0d:	5d                   	pop    %ebp
  800b0e:	c3                   	ret    

00800b0f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
  800b12:	53                   	push   %ebx
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b19:	89 c3                	mov    %eax,%ebx
  800b1b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b1e:	eb 06                	jmp    800b26 <strncmp+0x17>
		n--, p++, q++;
  800b20:	83 c0 01             	add    $0x1,%eax
  800b23:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b26:	39 d8                	cmp    %ebx,%eax
  800b28:	74 16                	je     800b40 <strncmp+0x31>
  800b2a:	0f b6 08             	movzbl (%eax),%ecx
  800b2d:	84 c9                	test   %cl,%cl
  800b2f:	74 04                	je     800b35 <strncmp+0x26>
  800b31:	3a 0a                	cmp    (%edx),%cl
  800b33:	74 eb                	je     800b20 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b35:	0f b6 00             	movzbl (%eax),%eax
  800b38:	0f b6 12             	movzbl (%edx),%edx
  800b3b:	29 d0                	sub    %edx,%eax
}
  800b3d:	5b                   	pop    %ebx
  800b3e:	5d                   	pop    %ebp
  800b3f:	c3                   	ret    
		return 0;
  800b40:	b8 00 00 00 00       	mov    $0x0,%eax
  800b45:	eb f6                	jmp    800b3d <strncmp+0x2e>

00800b47 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b47:	55                   	push   %ebp
  800b48:	89 e5                	mov    %esp,%ebp
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b51:	0f b6 10             	movzbl (%eax),%edx
  800b54:	84 d2                	test   %dl,%dl
  800b56:	74 09                	je     800b61 <strchr+0x1a>
		if (*s == c)
  800b58:	38 ca                	cmp    %cl,%dl
  800b5a:	74 0a                	je     800b66 <strchr+0x1f>
	for (; *s; s++)
  800b5c:	83 c0 01             	add    $0x1,%eax
  800b5f:	eb f0                	jmp    800b51 <strchr+0xa>
			return (char *) s;
	return 0;
  800b61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b66:	5d                   	pop    %ebp
  800b67:	c3                   	ret    

00800b68 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b72:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b75:	38 ca                	cmp    %cl,%dl
  800b77:	74 09                	je     800b82 <strfind+0x1a>
  800b79:	84 d2                	test   %dl,%dl
  800b7b:	74 05                	je     800b82 <strfind+0x1a>
	for (; *s; s++)
  800b7d:	83 c0 01             	add    $0x1,%eax
  800b80:	eb f0                	jmp    800b72 <strfind+0xa>
			break;
	return (char *) s;
}
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    

00800b84 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	57                   	push   %edi
  800b88:	56                   	push   %esi
  800b89:	53                   	push   %ebx
  800b8a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b8d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b90:	85 c9                	test   %ecx,%ecx
  800b92:	74 31                	je     800bc5 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b94:	89 f8                	mov    %edi,%eax
  800b96:	09 c8                	or     %ecx,%eax
  800b98:	a8 03                	test   $0x3,%al
  800b9a:	75 23                	jne    800bbf <memset+0x3b>
		c &= 0xFF;
  800b9c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ba0:	89 d3                	mov    %edx,%ebx
  800ba2:	c1 e3 08             	shl    $0x8,%ebx
  800ba5:	89 d0                	mov    %edx,%eax
  800ba7:	c1 e0 18             	shl    $0x18,%eax
  800baa:	89 d6                	mov    %edx,%esi
  800bac:	c1 e6 10             	shl    $0x10,%esi
  800baf:	09 f0                	or     %esi,%eax
  800bb1:	09 c2                	or     %eax,%edx
  800bb3:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bb5:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bb8:	89 d0                	mov    %edx,%eax
  800bba:	fc                   	cld    
  800bbb:	f3 ab                	rep stos %eax,%es:(%edi)
  800bbd:	eb 06                	jmp    800bc5 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc2:	fc                   	cld    
  800bc3:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bc5:	89 f8                	mov    %edi,%eax
  800bc7:	5b                   	pop    %ebx
  800bc8:	5e                   	pop    %esi
  800bc9:	5f                   	pop    %edi
  800bca:	5d                   	pop    %ebp
  800bcb:	c3                   	ret    

00800bcc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	57                   	push   %edi
  800bd0:	56                   	push   %esi
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bd7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bda:	39 c6                	cmp    %eax,%esi
  800bdc:	73 32                	jae    800c10 <memmove+0x44>
  800bde:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800be1:	39 c2                	cmp    %eax,%edx
  800be3:	76 2b                	jbe    800c10 <memmove+0x44>
		s += n;
		d += n;
  800be5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800be8:	89 fe                	mov    %edi,%esi
  800bea:	09 ce                	or     %ecx,%esi
  800bec:	09 d6                	or     %edx,%esi
  800bee:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bf4:	75 0e                	jne    800c04 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bf6:	83 ef 04             	sub    $0x4,%edi
  800bf9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bfc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bff:	fd                   	std    
  800c00:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c02:	eb 09                	jmp    800c0d <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c04:	83 ef 01             	sub    $0x1,%edi
  800c07:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c0a:	fd                   	std    
  800c0b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c0d:	fc                   	cld    
  800c0e:	eb 1a                	jmp    800c2a <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c10:	89 c2                	mov    %eax,%edx
  800c12:	09 ca                	or     %ecx,%edx
  800c14:	09 f2                	or     %esi,%edx
  800c16:	f6 c2 03             	test   $0x3,%dl
  800c19:	75 0a                	jne    800c25 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c1b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c1e:	89 c7                	mov    %eax,%edi
  800c20:	fc                   	cld    
  800c21:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c23:	eb 05                	jmp    800c2a <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c25:	89 c7                	mov    %eax,%edi
  800c27:	fc                   	cld    
  800c28:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c2a:	5e                   	pop    %esi
  800c2b:	5f                   	pop    %edi
  800c2c:	5d                   	pop    %ebp
  800c2d:	c3                   	ret    

00800c2e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
  800c31:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c34:	ff 75 10             	pushl  0x10(%ebp)
  800c37:	ff 75 0c             	pushl  0xc(%ebp)
  800c3a:	ff 75 08             	pushl  0x8(%ebp)
  800c3d:	e8 8a ff ff ff       	call   800bcc <memmove>
}
  800c42:	c9                   	leave  
  800c43:	c3                   	ret    

00800c44 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	56                   	push   %esi
  800c48:	53                   	push   %ebx
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c4f:	89 c6                	mov    %eax,%esi
  800c51:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c54:	39 f0                	cmp    %esi,%eax
  800c56:	74 1c                	je     800c74 <memcmp+0x30>
		if (*s1 != *s2)
  800c58:	0f b6 08             	movzbl (%eax),%ecx
  800c5b:	0f b6 1a             	movzbl (%edx),%ebx
  800c5e:	38 d9                	cmp    %bl,%cl
  800c60:	75 08                	jne    800c6a <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c62:	83 c0 01             	add    $0x1,%eax
  800c65:	83 c2 01             	add    $0x1,%edx
  800c68:	eb ea                	jmp    800c54 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c6a:	0f b6 c1             	movzbl %cl,%eax
  800c6d:	0f b6 db             	movzbl %bl,%ebx
  800c70:	29 d8                	sub    %ebx,%eax
  800c72:	eb 05                	jmp    800c79 <memcmp+0x35>
	}

	return 0;
  800c74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c79:	5b                   	pop    %ebx
  800c7a:	5e                   	pop    %esi
  800c7b:	5d                   	pop    %ebp
  800c7c:	c3                   	ret    

00800c7d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c7d:	55                   	push   %ebp
  800c7e:	89 e5                	mov    %esp,%ebp
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c86:	89 c2                	mov    %eax,%edx
  800c88:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c8b:	39 d0                	cmp    %edx,%eax
  800c8d:	73 09                	jae    800c98 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c8f:	38 08                	cmp    %cl,(%eax)
  800c91:	74 05                	je     800c98 <memfind+0x1b>
	for (; s < ends; s++)
  800c93:	83 c0 01             	add    $0x1,%eax
  800c96:	eb f3                	jmp    800c8b <memfind+0xe>
			break;
	return (void *) s;
}
  800c98:	5d                   	pop    %ebp
  800c99:	c3                   	ret    

00800c9a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	57                   	push   %edi
  800c9e:	56                   	push   %esi
  800c9f:	53                   	push   %ebx
  800ca0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ca3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ca6:	eb 03                	jmp    800cab <strtol+0x11>
		s++;
  800ca8:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cab:	0f b6 01             	movzbl (%ecx),%eax
  800cae:	3c 20                	cmp    $0x20,%al
  800cb0:	74 f6                	je     800ca8 <strtol+0xe>
  800cb2:	3c 09                	cmp    $0x9,%al
  800cb4:	74 f2                	je     800ca8 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cb6:	3c 2b                	cmp    $0x2b,%al
  800cb8:	74 2a                	je     800ce4 <strtol+0x4a>
	int neg = 0;
  800cba:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cbf:	3c 2d                	cmp    $0x2d,%al
  800cc1:	74 2b                	je     800cee <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cc3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cc9:	75 0f                	jne    800cda <strtol+0x40>
  800ccb:	80 39 30             	cmpb   $0x30,(%ecx)
  800cce:	74 28                	je     800cf8 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cd0:	85 db                	test   %ebx,%ebx
  800cd2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cd7:	0f 44 d8             	cmove  %eax,%ebx
  800cda:	b8 00 00 00 00       	mov    $0x0,%eax
  800cdf:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ce2:	eb 50                	jmp    800d34 <strtol+0x9a>
		s++;
  800ce4:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ce7:	bf 00 00 00 00       	mov    $0x0,%edi
  800cec:	eb d5                	jmp    800cc3 <strtol+0x29>
		s++, neg = 1;
  800cee:	83 c1 01             	add    $0x1,%ecx
  800cf1:	bf 01 00 00 00       	mov    $0x1,%edi
  800cf6:	eb cb                	jmp    800cc3 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cf8:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cfc:	74 0e                	je     800d0c <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800cfe:	85 db                	test   %ebx,%ebx
  800d00:	75 d8                	jne    800cda <strtol+0x40>
		s++, base = 8;
  800d02:	83 c1 01             	add    $0x1,%ecx
  800d05:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d0a:	eb ce                	jmp    800cda <strtol+0x40>
		s += 2, base = 16;
  800d0c:	83 c1 02             	add    $0x2,%ecx
  800d0f:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d14:	eb c4                	jmp    800cda <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d16:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d19:	89 f3                	mov    %esi,%ebx
  800d1b:	80 fb 19             	cmp    $0x19,%bl
  800d1e:	77 29                	ja     800d49 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d20:	0f be d2             	movsbl %dl,%edx
  800d23:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d26:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d29:	7d 30                	jge    800d5b <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d2b:	83 c1 01             	add    $0x1,%ecx
  800d2e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d32:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d34:	0f b6 11             	movzbl (%ecx),%edx
  800d37:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d3a:	89 f3                	mov    %esi,%ebx
  800d3c:	80 fb 09             	cmp    $0x9,%bl
  800d3f:	77 d5                	ja     800d16 <strtol+0x7c>
			dig = *s - '0';
  800d41:	0f be d2             	movsbl %dl,%edx
  800d44:	83 ea 30             	sub    $0x30,%edx
  800d47:	eb dd                	jmp    800d26 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d49:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d4c:	89 f3                	mov    %esi,%ebx
  800d4e:	80 fb 19             	cmp    $0x19,%bl
  800d51:	77 08                	ja     800d5b <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d53:	0f be d2             	movsbl %dl,%edx
  800d56:	83 ea 37             	sub    $0x37,%edx
  800d59:	eb cb                	jmp    800d26 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d5b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d5f:	74 05                	je     800d66 <strtol+0xcc>
		*endptr = (char *) s;
  800d61:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d64:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d66:	89 c2                	mov    %eax,%edx
  800d68:	f7 da                	neg    %edx
  800d6a:	85 ff                	test   %edi,%edi
  800d6c:	0f 45 c2             	cmovne %edx,%eax
}
  800d6f:	5b                   	pop    %ebx
  800d70:	5e                   	pop    %esi
  800d71:	5f                   	pop    %edi
  800d72:	5d                   	pop    %ebp
  800d73:	c3                   	ret    

00800d74 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d74:	55                   	push   %ebp
  800d75:	89 e5                	mov    %esp,%ebp
  800d77:	57                   	push   %edi
  800d78:	56                   	push   %esi
  800d79:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d85:	89 c3                	mov    %eax,%ebx
  800d87:	89 c7                	mov    %eax,%edi
  800d89:	89 c6                	mov    %eax,%esi
  800d8b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d8d:	5b                   	pop    %ebx
  800d8e:	5e                   	pop    %esi
  800d8f:	5f                   	pop    %edi
  800d90:	5d                   	pop    %ebp
  800d91:	c3                   	ret    

00800d92 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d92:	55                   	push   %ebp
  800d93:	89 e5                	mov    %esp,%ebp
  800d95:	57                   	push   %edi
  800d96:	56                   	push   %esi
  800d97:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d98:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9d:	b8 01 00 00 00       	mov    $0x1,%eax
  800da2:	89 d1                	mov    %edx,%ecx
  800da4:	89 d3                	mov    %edx,%ebx
  800da6:	89 d7                	mov    %edx,%edi
  800da8:	89 d6                	mov    %edx,%esi
  800daa:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dac:	5b                   	pop    %ebx
  800dad:	5e                   	pop    %esi
  800dae:	5f                   	pop    %edi
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    

00800db1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	57                   	push   %edi
  800db5:	56                   	push   %esi
  800db6:	53                   	push   %ebx
  800db7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dba:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc2:	b8 03 00 00 00       	mov    $0x3,%eax
  800dc7:	89 cb                	mov    %ecx,%ebx
  800dc9:	89 cf                	mov    %ecx,%edi
  800dcb:	89 ce                	mov    %ecx,%esi
  800dcd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dcf:	85 c0                	test   %eax,%eax
  800dd1:	7f 08                	jg     800ddb <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd6:	5b                   	pop    %ebx
  800dd7:	5e                   	pop    %esi
  800dd8:	5f                   	pop    %edi
  800dd9:	5d                   	pop    %ebp
  800dda:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddb:	83 ec 0c             	sub    $0xc,%esp
  800dde:	50                   	push   %eax
  800ddf:	6a 03                	push   $0x3
  800de1:	68 08 2b 80 00       	push   $0x802b08
  800de6:	6a 43                	push   $0x43
  800de8:	68 25 2b 80 00       	push   $0x802b25
  800ded:	e8 f7 f3 ff ff       	call   8001e9 <_panic>

00800df2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	57                   	push   %edi
  800df6:	56                   	push   %esi
  800df7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800df8:	ba 00 00 00 00       	mov    $0x0,%edx
  800dfd:	b8 02 00 00 00       	mov    $0x2,%eax
  800e02:	89 d1                	mov    %edx,%ecx
  800e04:	89 d3                	mov    %edx,%ebx
  800e06:	89 d7                	mov    %edx,%edi
  800e08:	89 d6                	mov    %edx,%esi
  800e0a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e0c:	5b                   	pop    %ebx
  800e0d:	5e                   	pop    %esi
  800e0e:	5f                   	pop    %edi
  800e0f:	5d                   	pop    %ebp
  800e10:	c3                   	ret    

00800e11 <sys_yield>:

void
sys_yield(void)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
  800e14:	57                   	push   %edi
  800e15:	56                   	push   %esi
  800e16:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e17:	ba 00 00 00 00       	mov    $0x0,%edx
  800e1c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e21:	89 d1                	mov    %edx,%ecx
  800e23:	89 d3                	mov    %edx,%ebx
  800e25:	89 d7                	mov    %edx,%edi
  800e27:	89 d6                	mov    %edx,%esi
  800e29:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e2b:	5b                   	pop    %ebx
  800e2c:	5e                   	pop    %esi
  800e2d:	5f                   	pop    %edi
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    

00800e30 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	57                   	push   %edi
  800e34:	56                   	push   %esi
  800e35:	53                   	push   %ebx
  800e36:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e39:	be 00 00 00 00       	mov    $0x0,%esi
  800e3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e44:	b8 04 00 00 00       	mov    $0x4,%eax
  800e49:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e4c:	89 f7                	mov    %esi,%edi
  800e4e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e50:	85 c0                	test   %eax,%eax
  800e52:	7f 08                	jg     800e5c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800e60:	6a 04                	push   $0x4
  800e62:	68 08 2b 80 00       	push   $0x802b08
  800e67:	6a 43                	push   $0x43
  800e69:	68 25 2b 80 00       	push   $0x802b25
  800e6e:	e8 76 f3 ff ff       	call   8001e9 <_panic>

00800e73 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e73:	55                   	push   %ebp
  800e74:	89 e5                	mov    %esp,%ebp
  800e76:	57                   	push   %edi
  800e77:	56                   	push   %esi
  800e78:	53                   	push   %ebx
  800e79:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e82:	b8 05 00 00 00       	mov    $0x5,%eax
  800e87:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e8a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e8d:	8b 75 18             	mov    0x18(%ebp),%esi
  800e90:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e92:	85 c0                	test   %eax,%eax
  800e94:	7f 08                	jg     800e9e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e99:	5b                   	pop    %ebx
  800e9a:	5e                   	pop    %esi
  800e9b:	5f                   	pop    %edi
  800e9c:	5d                   	pop    %ebp
  800e9d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9e:	83 ec 0c             	sub    $0xc,%esp
  800ea1:	50                   	push   %eax
  800ea2:	6a 05                	push   $0x5
  800ea4:	68 08 2b 80 00       	push   $0x802b08
  800ea9:	6a 43                	push   $0x43
  800eab:	68 25 2b 80 00       	push   $0x802b25
  800eb0:	e8 34 f3 ff ff       	call   8001e9 <_panic>

00800eb5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	57                   	push   %edi
  800eb9:	56                   	push   %esi
  800eba:	53                   	push   %ebx
  800ebb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ebe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec9:	b8 06 00 00 00       	mov    $0x6,%eax
  800ece:	89 df                	mov    %ebx,%edi
  800ed0:	89 de                	mov    %ebx,%esi
  800ed2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed4:	85 c0                	test   %eax,%eax
  800ed6:	7f 08                	jg     800ee0 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ed8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800edb:	5b                   	pop    %ebx
  800edc:	5e                   	pop    %esi
  800edd:	5f                   	pop    %edi
  800ede:	5d                   	pop    %ebp
  800edf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee0:	83 ec 0c             	sub    $0xc,%esp
  800ee3:	50                   	push   %eax
  800ee4:	6a 06                	push   $0x6
  800ee6:	68 08 2b 80 00       	push   $0x802b08
  800eeb:	6a 43                	push   $0x43
  800eed:	68 25 2b 80 00       	push   $0x802b25
  800ef2:	e8 f2 f2 ff ff       	call   8001e9 <_panic>

00800ef7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ef7:	55                   	push   %ebp
  800ef8:	89 e5                	mov    %esp,%ebp
  800efa:	57                   	push   %edi
  800efb:	56                   	push   %esi
  800efc:	53                   	push   %ebx
  800efd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f00:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f05:	8b 55 08             	mov    0x8(%ebp),%edx
  800f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0b:	b8 08 00 00 00       	mov    $0x8,%eax
  800f10:	89 df                	mov    %ebx,%edi
  800f12:	89 de                	mov    %ebx,%esi
  800f14:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f16:	85 c0                	test   %eax,%eax
  800f18:	7f 08                	jg     800f22 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f1d:	5b                   	pop    %ebx
  800f1e:	5e                   	pop    %esi
  800f1f:	5f                   	pop    %edi
  800f20:	5d                   	pop    %ebp
  800f21:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f22:	83 ec 0c             	sub    $0xc,%esp
  800f25:	50                   	push   %eax
  800f26:	6a 08                	push   $0x8
  800f28:	68 08 2b 80 00       	push   $0x802b08
  800f2d:	6a 43                	push   $0x43
  800f2f:	68 25 2b 80 00       	push   $0x802b25
  800f34:	e8 b0 f2 ff ff       	call   8001e9 <_panic>

00800f39 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	57                   	push   %edi
  800f3d:	56                   	push   %esi
  800f3e:	53                   	push   %ebx
  800f3f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f42:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f47:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4d:	b8 09 00 00 00       	mov    $0x9,%eax
  800f52:	89 df                	mov    %ebx,%edi
  800f54:	89 de                	mov    %ebx,%esi
  800f56:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f58:	85 c0                	test   %eax,%eax
  800f5a:	7f 08                	jg     800f64 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f5f:	5b                   	pop    %ebx
  800f60:	5e                   	pop    %esi
  800f61:	5f                   	pop    %edi
  800f62:	5d                   	pop    %ebp
  800f63:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f64:	83 ec 0c             	sub    $0xc,%esp
  800f67:	50                   	push   %eax
  800f68:	6a 09                	push   $0x9
  800f6a:	68 08 2b 80 00       	push   $0x802b08
  800f6f:	6a 43                	push   $0x43
  800f71:	68 25 2b 80 00       	push   $0x802b25
  800f76:	e8 6e f2 ff ff       	call   8001e9 <_panic>

00800f7b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
  800f7e:	57                   	push   %edi
  800f7f:	56                   	push   %esi
  800f80:	53                   	push   %ebx
  800f81:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f84:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f89:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f94:	89 df                	mov    %ebx,%edi
  800f96:	89 de                	mov    %ebx,%esi
  800f98:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f9a:	85 c0                	test   %eax,%eax
  800f9c:	7f 08                	jg     800fa6 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa1:	5b                   	pop    %ebx
  800fa2:	5e                   	pop    %esi
  800fa3:	5f                   	pop    %edi
  800fa4:	5d                   	pop    %ebp
  800fa5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa6:	83 ec 0c             	sub    $0xc,%esp
  800fa9:	50                   	push   %eax
  800faa:	6a 0a                	push   $0xa
  800fac:	68 08 2b 80 00       	push   $0x802b08
  800fb1:	6a 43                	push   $0x43
  800fb3:	68 25 2b 80 00       	push   $0x802b25
  800fb8:	e8 2c f2 ff ff       	call   8001e9 <_panic>

00800fbd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	57                   	push   %edi
  800fc1:	56                   	push   %esi
  800fc2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc9:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fce:	be 00 00 00 00       	mov    $0x0,%esi
  800fd3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fd6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fd9:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fdb:	5b                   	pop    %ebx
  800fdc:	5e                   	pop    %esi
  800fdd:	5f                   	pop    %edi
  800fde:	5d                   	pop    %ebp
  800fdf:	c3                   	ret    

00800fe0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	57                   	push   %edi
  800fe4:	56                   	push   %esi
  800fe5:	53                   	push   %ebx
  800fe6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fe9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fee:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff1:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ff6:	89 cb                	mov    %ecx,%ebx
  800ff8:	89 cf                	mov    %ecx,%edi
  800ffa:	89 ce                	mov    %ecx,%esi
  800ffc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ffe:	85 c0                	test   %eax,%eax
  801000:	7f 08                	jg     80100a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801002:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801005:	5b                   	pop    %ebx
  801006:	5e                   	pop    %esi
  801007:	5f                   	pop    %edi
  801008:	5d                   	pop    %ebp
  801009:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80100a:	83 ec 0c             	sub    $0xc,%esp
  80100d:	50                   	push   %eax
  80100e:	6a 0d                	push   $0xd
  801010:	68 08 2b 80 00       	push   $0x802b08
  801015:	6a 43                	push   $0x43
  801017:	68 25 2b 80 00       	push   $0x802b25
  80101c:	e8 c8 f1 ff ff       	call   8001e9 <_panic>

00801021 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
  801024:	57                   	push   %edi
  801025:	56                   	push   %esi
  801026:	53                   	push   %ebx
	asm volatile("int %1\n"
  801027:	bb 00 00 00 00       	mov    $0x0,%ebx
  80102c:	8b 55 08             	mov    0x8(%ebp),%edx
  80102f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801032:	b8 0e 00 00 00       	mov    $0xe,%eax
  801037:	89 df                	mov    %ebx,%edi
  801039:	89 de                	mov    %ebx,%esi
  80103b:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80103d:	5b                   	pop    %ebx
  80103e:	5e                   	pop    %esi
  80103f:	5f                   	pop    %edi
  801040:	5d                   	pop    %ebp
  801041:	c3                   	ret    

00801042 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
  801045:	57                   	push   %edi
  801046:	56                   	push   %esi
  801047:	53                   	push   %ebx
	asm volatile("int %1\n"
  801048:	b9 00 00 00 00       	mov    $0x0,%ecx
  80104d:	8b 55 08             	mov    0x8(%ebp),%edx
  801050:	b8 0f 00 00 00       	mov    $0xf,%eax
  801055:	89 cb                	mov    %ecx,%ebx
  801057:	89 cf                	mov    %ecx,%edi
  801059:	89 ce                	mov    %ecx,%esi
  80105b:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80105d:	5b                   	pop    %ebx
  80105e:	5e                   	pop    %esi
  80105f:	5f                   	pop    %edi
  801060:	5d                   	pop    %ebp
  801061:	c3                   	ret    

00801062 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
  801065:	57                   	push   %edi
  801066:	56                   	push   %esi
  801067:	53                   	push   %ebx
	asm volatile("int %1\n"
  801068:	ba 00 00 00 00       	mov    $0x0,%edx
  80106d:	b8 10 00 00 00       	mov    $0x10,%eax
  801072:	89 d1                	mov    %edx,%ecx
  801074:	89 d3                	mov    %edx,%ebx
  801076:	89 d7                	mov    %edx,%edi
  801078:	89 d6                	mov    %edx,%esi
  80107a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80107c:	5b                   	pop    %ebx
  80107d:	5e                   	pop    %esi
  80107e:	5f                   	pop    %edi
  80107f:	5d                   	pop    %ebp
  801080:	c3                   	ret    

00801081 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
  801084:	57                   	push   %edi
  801085:	56                   	push   %esi
  801086:	53                   	push   %ebx
	asm volatile("int %1\n"
  801087:	bb 00 00 00 00       	mov    $0x0,%ebx
  80108c:	8b 55 08             	mov    0x8(%ebp),%edx
  80108f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801092:	b8 11 00 00 00       	mov    $0x11,%eax
  801097:	89 df                	mov    %ebx,%edi
  801099:	89 de                	mov    %ebx,%esi
  80109b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80109d:	5b                   	pop    %ebx
  80109e:	5e                   	pop    %esi
  80109f:	5f                   	pop    %edi
  8010a0:	5d                   	pop    %ebp
  8010a1:	c3                   	ret    

008010a2 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
  8010a5:	57                   	push   %edi
  8010a6:	56                   	push   %esi
  8010a7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010a8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b3:	b8 12 00 00 00       	mov    $0x12,%eax
  8010b8:	89 df                	mov    %ebx,%edi
  8010ba:	89 de                	mov    %ebx,%esi
  8010bc:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010be:	5b                   	pop    %ebx
  8010bf:	5e                   	pop    %esi
  8010c0:	5f                   	pop    %edi
  8010c1:	5d                   	pop    %ebp
  8010c2:	c3                   	ret    

008010c3 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8010c3:	55                   	push   %ebp
  8010c4:	89 e5                	mov    %esp,%ebp
  8010c6:	57                   	push   %edi
  8010c7:	56                   	push   %esi
  8010c8:	53                   	push   %ebx
  8010c9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d7:	b8 13 00 00 00       	mov    $0x13,%eax
  8010dc:	89 df                	mov    %ebx,%edi
  8010de:	89 de                	mov    %ebx,%esi
  8010e0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010e2:	85 c0                	test   %eax,%eax
  8010e4:	7f 08                	jg     8010ee <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010e9:	5b                   	pop    %ebx
  8010ea:	5e                   	pop    %esi
  8010eb:	5f                   	pop    %edi
  8010ec:	5d                   	pop    %ebp
  8010ed:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ee:	83 ec 0c             	sub    $0xc,%esp
  8010f1:	50                   	push   %eax
  8010f2:	6a 13                	push   $0x13
  8010f4:	68 08 2b 80 00       	push   $0x802b08
  8010f9:	6a 43                	push   $0x43
  8010fb:	68 25 2b 80 00       	push   $0x802b25
  801100:	e8 e4 f0 ff ff       	call   8001e9 <_panic>

00801105 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	57                   	push   %edi
  801109:	56                   	push   %esi
  80110a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80110b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801110:	8b 55 08             	mov    0x8(%ebp),%edx
  801113:	b8 14 00 00 00       	mov    $0x14,%eax
  801118:	89 cb                	mov    %ecx,%ebx
  80111a:	89 cf                	mov    %ecx,%edi
  80111c:	89 ce                	mov    %ecx,%esi
  80111e:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801120:	5b                   	pop    %ebx
  801121:	5e                   	pop    %esi
  801122:	5f                   	pop    %edi
  801123:	5d                   	pop    %ebp
  801124:	c3                   	ret    

00801125 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	05 00 00 00 30       	add    $0x30000000,%eax
  801130:	c1 e8 0c             	shr    $0xc,%eax
}
  801133:	5d                   	pop    %ebp
  801134:	c3                   	ret    

00801135 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801140:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801145:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80114a:	5d                   	pop    %ebp
  80114b:	c3                   	ret    

0080114c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801154:	89 c2                	mov    %eax,%edx
  801156:	c1 ea 16             	shr    $0x16,%edx
  801159:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801160:	f6 c2 01             	test   $0x1,%dl
  801163:	74 2d                	je     801192 <fd_alloc+0x46>
  801165:	89 c2                	mov    %eax,%edx
  801167:	c1 ea 0c             	shr    $0xc,%edx
  80116a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801171:	f6 c2 01             	test   $0x1,%dl
  801174:	74 1c                	je     801192 <fd_alloc+0x46>
  801176:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80117b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801180:	75 d2                	jne    801154 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80118b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801190:	eb 0a                	jmp    80119c <fd_alloc+0x50>
			*fd_store = fd;
  801192:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801195:	89 01                	mov    %eax,(%ecx)
			return 0;
  801197:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80119c:	5d                   	pop    %ebp
  80119d:	c3                   	ret    

0080119e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80119e:	55                   	push   %ebp
  80119f:	89 e5                	mov    %esp,%ebp
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011a4:	83 f8 1f             	cmp    $0x1f,%eax
  8011a7:	77 30                	ja     8011d9 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011a9:	c1 e0 0c             	shl    $0xc,%eax
  8011ac:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011b1:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8011b7:	f6 c2 01             	test   $0x1,%dl
  8011ba:	74 24                	je     8011e0 <fd_lookup+0x42>
  8011bc:	89 c2                	mov    %eax,%edx
  8011be:	c1 ea 0c             	shr    $0xc,%edx
  8011c1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011c8:	f6 c2 01             	test   $0x1,%dl
  8011cb:	74 1a                	je     8011e7 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d0:	89 02                	mov    %eax,(%edx)
	return 0;
  8011d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d7:	5d                   	pop    %ebp
  8011d8:	c3                   	ret    
		return -E_INVAL;
  8011d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011de:	eb f7                	jmp    8011d7 <fd_lookup+0x39>
		return -E_INVAL;
  8011e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011e5:	eb f0                	jmp    8011d7 <fd_lookup+0x39>
  8011e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ec:	eb e9                	jmp    8011d7 <fd_lookup+0x39>

008011ee <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	83 ec 08             	sub    $0x8,%esp
  8011f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8011f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8011fc:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801201:	39 08                	cmp    %ecx,(%eax)
  801203:	74 38                	je     80123d <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801205:	83 c2 01             	add    $0x1,%edx
  801208:	8b 04 95 b4 2b 80 00 	mov    0x802bb4(,%edx,4),%eax
  80120f:	85 c0                	test   %eax,%eax
  801211:	75 ee                	jne    801201 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801213:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801218:	8b 40 48             	mov    0x48(%eax),%eax
  80121b:	83 ec 04             	sub    $0x4,%esp
  80121e:	51                   	push   %ecx
  80121f:	50                   	push   %eax
  801220:	68 34 2b 80 00       	push   $0x802b34
  801225:	e8 b5 f0 ff ff       	call   8002df <cprintf>
	*dev = 0;
  80122a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801233:	83 c4 10             	add    $0x10,%esp
  801236:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80123b:	c9                   	leave  
  80123c:	c3                   	ret    
			*dev = devtab[i];
  80123d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801240:	89 01                	mov    %eax,(%ecx)
			return 0;
  801242:	b8 00 00 00 00       	mov    $0x0,%eax
  801247:	eb f2                	jmp    80123b <dev_lookup+0x4d>

00801249 <fd_close>:
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	57                   	push   %edi
  80124d:	56                   	push   %esi
  80124e:	53                   	push   %ebx
  80124f:	83 ec 24             	sub    $0x24,%esp
  801252:	8b 75 08             	mov    0x8(%ebp),%esi
  801255:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801258:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80125b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80125c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801262:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801265:	50                   	push   %eax
  801266:	e8 33 ff ff ff       	call   80119e <fd_lookup>
  80126b:	89 c3                	mov    %eax,%ebx
  80126d:	83 c4 10             	add    $0x10,%esp
  801270:	85 c0                	test   %eax,%eax
  801272:	78 05                	js     801279 <fd_close+0x30>
	    || fd != fd2)
  801274:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801277:	74 16                	je     80128f <fd_close+0x46>
		return (must_exist ? r : 0);
  801279:	89 f8                	mov    %edi,%eax
  80127b:	84 c0                	test   %al,%al
  80127d:	b8 00 00 00 00       	mov    $0x0,%eax
  801282:	0f 44 d8             	cmove  %eax,%ebx
}
  801285:	89 d8                	mov    %ebx,%eax
  801287:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80128a:	5b                   	pop    %ebx
  80128b:	5e                   	pop    %esi
  80128c:	5f                   	pop    %edi
  80128d:	5d                   	pop    %ebp
  80128e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80128f:	83 ec 08             	sub    $0x8,%esp
  801292:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801295:	50                   	push   %eax
  801296:	ff 36                	pushl  (%esi)
  801298:	e8 51 ff ff ff       	call   8011ee <dev_lookup>
  80129d:	89 c3                	mov    %eax,%ebx
  80129f:	83 c4 10             	add    $0x10,%esp
  8012a2:	85 c0                	test   %eax,%eax
  8012a4:	78 1a                	js     8012c0 <fd_close+0x77>
		if (dev->dev_close)
  8012a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012a9:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8012ac:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012b1:	85 c0                	test   %eax,%eax
  8012b3:	74 0b                	je     8012c0 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8012b5:	83 ec 0c             	sub    $0xc,%esp
  8012b8:	56                   	push   %esi
  8012b9:	ff d0                	call   *%eax
  8012bb:	89 c3                	mov    %eax,%ebx
  8012bd:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012c0:	83 ec 08             	sub    $0x8,%esp
  8012c3:	56                   	push   %esi
  8012c4:	6a 00                	push   $0x0
  8012c6:	e8 ea fb ff ff       	call   800eb5 <sys_page_unmap>
	return r;
  8012cb:	83 c4 10             	add    $0x10,%esp
  8012ce:	eb b5                	jmp    801285 <fd_close+0x3c>

008012d0 <close>:

int
close(int fdnum)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012d9:	50                   	push   %eax
  8012da:	ff 75 08             	pushl  0x8(%ebp)
  8012dd:	e8 bc fe ff ff       	call   80119e <fd_lookup>
  8012e2:	83 c4 10             	add    $0x10,%esp
  8012e5:	85 c0                	test   %eax,%eax
  8012e7:	79 02                	jns    8012eb <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8012e9:	c9                   	leave  
  8012ea:	c3                   	ret    
		return fd_close(fd, 1);
  8012eb:	83 ec 08             	sub    $0x8,%esp
  8012ee:	6a 01                	push   $0x1
  8012f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8012f3:	e8 51 ff ff ff       	call   801249 <fd_close>
  8012f8:	83 c4 10             	add    $0x10,%esp
  8012fb:	eb ec                	jmp    8012e9 <close+0x19>

008012fd <close_all>:

void
close_all(void)
{
  8012fd:	55                   	push   %ebp
  8012fe:	89 e5                	mov    %esp,%ebp
  801300:	53                   	push   %ebx
  801301:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801304:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801309:	83 ec 0c             	sub    $0xc,%esp
  80130c:	53                   	push   %ebx
  80130d:	e8 be ff ff ff       	call   8012d0 <close>
	for (i = 0; i < MAXFD; i++)
  801312:	83 c3 01             	add    $0x1,%ebx
  801315:	83 c4 10             	add    $0x10,%esp
  801318:	83 fb 20             	cmp    $0x20,%ebx
  80131b:	75 ec                	jne    801309 <close_all+0xc>
}
  80131d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801320:	c9                   	leave  
  801321:	c3                   	ret    

00801322 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801322:	55                   	push   %ebp
  801323:	89 e5                	mov    %esp,%ebp
  801325:	57                   	push   %edi
  801326:	56                   	push   %esi
  801327:	53                   	push   %ebx
  801328:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80132b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80132e:	50                   	push   %eax
  80132f:	ff 75 08             	pushl  0x8(%ebp)
  801332:	e8 67 fe ff ff       	call   80119e <fd_lookup>
  801337:	89 c3                	mov    %eax,%ebx
  801339:	83 c4 10             	add    $0x10,%esp
  80133c:	85 c0                	test   %eax,%eax
  80133e:	0f 88 81 00 00 00    	js     8013c5 <dup+0xa3>
		return r;
	close(newfdnum);
  801344:	83 ec 0c             	sub    $0xc,%esp
  801347:	ff 75 0c             	pushl  0xc(%ebp)
  80134a:	e8 81 ff ff ff       	call   8012d0 <close>

	newfd = INDEX2FD(newfdnum);
  80134f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801352:	c1 e6 0c             	shl    $0xc,%esi
  801355:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80135b:	83 c4 04             	add    $0x4,%esp
  80135e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801361:	e8 cf fd ff ff       	call   801135 <fd2data>
  801366:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801368:	89 34 24             	mov    %esi,(%esp)
  80136b:	e8 c5 fd ff ff       	call   801135 <fd2data>
  801370:	83 c4 10             	add    $0x10,%esp
  801373:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801375:	89 d8                	mov    %ebx,%eax
  801377:	c1 e8 16             	shr    $0x16,%eax
  80137a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801381:	a8 01                	test   $0x1,%al
  801383:	74 11                	je     801396 <dup+0x74>
  801385:	89 d8                	mov    %ebx,%eax
  801387:	c1 e8 0c             	shr    $0xc,%eax
  80138a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801391:	f6 c2 01             	test   $0x1,%dl
  801394:	75 39                	jne    8013cf <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801396:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801399:	89 d0                	mov    %edx,%eax
  80139b:	c1 e8 0c             	shr    $0xc,%eax
  80139e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013a5:	83 ec 0c             	sub    $0xc,%esp
  8013a8:	25 07 0e 00 00       	and    $0xe07,%eax
  8013ad:	50                   	push   %eax
  8013ae:	56                   	push   %esi
  8013af:	6a 00                	push   $0x0
  8013b1:	52                   	push   %edx
  8013b2:	6a 00                	push   $0x0
  8013b4:	e8 ba fa ff ff       	call   800e73 <sys_page_map>
  8013b9:	89 c3                	mov    %eax,%ebx
  8013bb:	83 c4 20             	add    $0x20,%esp
  8013be:	85 c0                	test   %eax,%eax
  8013c0:	78 31                	js     8013f3 <dup+0xd1>
		goto err;

	return newfdnum;
  8013c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013c5:	89 d8                	mov    %ebx,%eax
  8013c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ca:	5b                   	pop    %ebx
  8013cb:	5e                   	pop    %esi
  8013cc:	5f                   	pop    %edi
  8013cd:	5d                   	pop    %ebp
  8013ce:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013cf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013d6:	83 ec 0c             	sub    $0xc,%esp
  8013d9:	25 07 0e 00 00       	and    $0xe07,%eax
  8013de:	50                   	push   %eax
  8013df:	57                   	push   %edi
  8013e0:	6a 00                	push   $0x0
  8013e2:	53                   	push   %ebx
  8013e3:	6a 00                	push   $0x0
  8013e5:	e8 89 fa ff ff       	call   800e73 <sys_page_map>
  8013ea:	89 c3                	mov    %eax,%ebx
  8013ec:	83 c4 20             	add    $0x20,%esp
  8013ef:	85 c0                	test   %eax,%eax
  8013f1:	79 a3                	jns    801396 <dup+0x74>
	sys_page_unmap(0, newfd);
  8013f3:	83 ec 08             	sub    $0x8,%esp
  8013f6:	56                   	push   %esi
  8013f7:	6a 00                	push   $0x0
  8013f9:	e8 b7 fa ff ff       	call   800eb5 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013fe:	83 c4 08             	add    $0x8,%esp
  801401:	57                   	push   %edi
  801402:	6a 00                	push   $0x0
  801404:	e8 ac fa ff ff       	call   800eb5 <sys_page_unmap>
	return r;
  801409:	83 c4 10             	add    $0x10,%esp
  80140c:	eb b7                	jmp    8013c5 <dup+0xa3>

0080140e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	53                   	push   %ebx
  801412:	83 ec 1c             	sub    $0x1c,%esp
  801415:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801418:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80141b:	50                   	push   %eax
  80141c:	53                   	push   %ebx
  80141d:	e8 7c fd ff ff       	call   80119e <fd_lookup>
  801422:	83 c4 10             	add    $0x10,%esp
  801425:	85 c0                	test   %eax,%eax
  801427:	78 3f                	js     801468 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801429:	83 ec 08             	sub    $0x8,%esp
  80142c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80142f:	50                   	push   %eax
  801430:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801433:	ff 30                	pushl  (%eax)
  801435:	e8 b4 fd ff ff       	call   8011ee <dev_lookup>
  80143a:	83 c4 10             	add    $0x10,%esp
  80143d:	85 c0                	test   %eax,%eax
  80143f:	78 27                	js     801468 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801441:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801444:	8b 42 08             	mov    0x8(%edx),%eax
  801447:	83 e0 03             	and    $0x3,%eax
  80144a:	83 f8 01             	cmp    $0x1,%eax
  80144d:	74 1e                	je     80146d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80144f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801452:	8b 40 08             	mov    0x8(%eax),%eax
  801455:	85 c0                	test   %eax,%eax
  801457:	74 35                	je     80148e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801459:	83 ec 04             	sub    $0x4,%esp
  80145c:	ff 75 10             	pushl  0x10(%ebp)
  80145f:	ff 75 0c             	pushl  0xc(%ebp)
  801462:	52                   	push   %edx
  801463:	ff d0                	call   *%eax
  801465:	83 c4 10             	add    $0x10,%esp
}
  801468:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80146b:	c9                   	leave  
  80146c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80146d:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801472:	8b 40 48             	mov    0x48(%eax),%eax
  801475:	83 ec 04             	sub    $0x4,%esp
  801478:	53                   	push   %ebx
  801479:	50                   	push   %eax
  80147a:	68 78 2b 80 00       	push   $0x802b78
  80147f:	e8 5b ee ff ff       	call   8002df <cprintf>
		return -E_INVAL;
  801484:	83 c4 10             	add    $0x10,%esp
  801487:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80148c:	eb da                	jmp    801468 <read+0x5a>
		return -E_NOT_SUPP;
  80148e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801493:	eb d3                	jmp    801468 <read+0x5a>

00801495 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
  801498:	57                   	push   %edi
  801499:	56                   	push   %esi
  80149a:	53                   	push   %ebx
  80149b:	83 ec 0c             	sub    $0xc,%esp
  80149e:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014a1:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014a9:	39 f3                	cmp    %esi,%ebx
  8014ab:	73 23                	jae    8014d0 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014ad:	83 ec 04             	sub    $0x4,%esp
  8014b0:	89 f0                	mov    %esi,%eax
  8014b2:	29 d8                	sub    %ebx,%eax
  8014b4:	50                   	push   %eax
  8014b5:	89 d8                	mov    %ebx,%eax
  8014b7:	03 45 0c             	add    0xc(%ebp),%eax
  8014ba:	50                   	push   %eax
  8014bb:	57                   	push   %edi
  8014bc:	e8 4d ff ff ff       	call   80140e <read>
		if (m < 0)
  8014c1:	83 c4 10             	add    $0x10,%esp
  8014c4:	85 c0                	test   %eax,%eax
  8014c6:	78 06                	js     8014ce <readn+0x39>
			return m;
		if (m == 0)
  8014c8:	74 06                	je     8014d0 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8014ca:	01 c3                	add    %eax,%ebx
  8014cc:	eb db                	jmp    8014a9 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014ce:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014d0:	89 d8                	mov    %ebx,%eax
  8014d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014d5:	5b                   	pop    %ebx
  8014d6:	5e                   	pop    %esi
  8014d7:	5f                   	pop    %edi
  8014d8:	5d                   	pop    %ebp
  8014d9:	c3                   	ret    

008014da <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
  8014dd:	53                   	push   %ebx
  8014de:	83 ec 1c             	sub    $0x1c,%esp
  8014e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014e7:	50                   	push   %eax
  8014e8:	53                   	push   %ebx
  8014e9:	e8 b0 fc ff ff       	call   80119e <fd_lookup>
  8014ee:	83 c4 10             	add    $0x10,%esp
  8014f1:	85 c0                	test   %eax,%eax
  8014f3:	78 3a                	js     80152f <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014f5:	83 ec 08             	sub    $0x8,%esp
  8014f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014fb:	50                   	push   %eax
  8014fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ff:	ff 30                	pushl  (%eax)
  801501:	e8 e8 fc ff ff       	call   8011ee <dev_lookup>
  801506:	83 c4 10             	add    $0x10,%esp
  801509:	85 c0                	test   %eax,%eax
  80150b:	78 22                	js     80152f <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80150d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801510:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801514:	74 1e                	je     801534 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801516:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801519:	8b 52 0c             	mov    0xc(%edx),%edx
  80151c:	85 d2                	test   %edx,%edx
  80151e:	74 35                	je     801555 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801520:	83 ec 04             	sub    $0x4,%esp
  801523:	ff 75 10             	pushl  0x10(%ebp)
  801526:	ff 75 0c             	pushl  0xc(%ebp)
  801529:	50                   	push   %eax
  80152a:	ff d2                	call   *%edx
  80152c:	83 c4 10             	add    $0x10,%esp
}
  80152f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801532:	c9                   	leave  
  801533:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801534:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801539:	8b 40 48             	mov    0x48(%eax),%eax
  80153c:	83 ec 04             	sub    $0x4,%esp
  80153f:	53                   	push   %ebx
  801540:	50                   	push   %eax
  801541:	68 94 2b 80 00       	push   $0x802b94
  801546:	e8 94 ed ff ff       	call   8002df <cprintf>
		return -E_INVAL;
  80154b:	83 c4 10             	add    $0x10,%esp
  80154e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801553:	eb da                	jmp    80152f <write+0x55>
		return -E_NOT_SUPP;
  801555:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80155a:	eb d3                	jmp    80152f <write+0x55>

0080155c <seek>:

int
seek(int fdnum, off_t offset)
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
  80155f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801562:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801565:	50                   	push   %eax
  801566:	ff 75 08             	pushl  0x8(%ebp)
  801569:	e8 30 fc ff ff       	call   80119e <fd_lookup>
  80156e:	83 c4 10             	add    $0x10,%esp
  801571:	85 c0                	test   %eax,%eax
  801573:	78 0e                	js     801583 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801575:	8b 55 0c             	mov    0xc(%ebp),%edx
  801578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80157b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80157e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801583:	c9                   	leave  
  801584:	c3                   	ret    

00801585 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	53                   	push   %ebx
  801589:	83 ec 1c             	sub    $0x1c,%esp
  80158c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80158f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801592:	50                   	push   %eax
  801593:	53                   	push   %ebx
  801594:	e8 05 fc ff ff       	call   80119e <fd_lookup>
  801599:	83 c4 10             	add    $0x10,%esp
  80159c:	85 c0                	test   %eax,%eax
  80159e:	78 37                	js     8015d7 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015a0:	83 ec 08             	sub    $0x8,%esp
  8015a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a6:	50                   	push   %eax
  8015a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015aa:	ff 30                	pushl  (%eax)
  8015ac:	e8 3d fc ff ff       	call   8011ee <dev_lookup>
  8015b1:	83 c4 10             	add    $0x10,%esp
  8015b4:	85 c0                	test   %eax,%eax
  8015b6:	78 1f                	js     8015d7 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015bb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015bf:	74 1b                	je     8015dc <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c4:	8b 52 18             	mov    0x18(%edx),%edx
  8015c7:	85 d2                	test   %edx,%edx
  8015c9:	74 32                	je     8015fd <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015cb:	83 ec 08             	sub    $0x8,%esp
  8015ce:	ff 75 0c             	pushl  0xc(%ebp)
  8015d1:	50                   	push   %eax
  8015d2:	ff d2                	call   *%edx
  8015d4:	83 c4 10             	add    $0x10,%esp
}
  8015d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015dc:	a1 20 40 c0 00       	mov    0xc04020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015e1:	8b 40 48             	mov    0x48(%eax),%eax
  8015e4:	83 ec 04             	sub    $0x4,%esp
  8015e7:	53                   	push   %ebx
  8015e8:	50                   	push   %eax
  8015e9:	68 54 2b 80 00       	push   $0x802b54
  8015ee:	e8 ec ec ff ff       	call   8002df <cprintf>
		return -E_INVAL;
  8015f3:	83 c4 10             	add    $0x10,%esp
  8015f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015fb:	eb da                	jmp    8015d7 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8015fd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801602:	eb d3                	jmp    8015d7 <ftruncate+0x52>

00801604 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
  801607:	53                   	push   %ebx
  801608:	83 ec 1c             	sub    $0x1c,%esp
  80160b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80160e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801611:	50                   	push   %eax
  801612:	ff 75 08             	pushl  0x8(%ebp)
  801615:	e8 84 fb ff ff       	call   80119e <fd_lookup>
  80161a:	83 c4 10             	add    $0x10,%esp
  80161d:	85 c0                	test   %eax,%eax
  80161f:	78 4b                	js     80166c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801621:	83 ec 08             	sub    $0x8,%esp
  801624:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801627:	50                   	push   %eax
  801628:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162b:	ff 30                	pushl  (%eax)
  80162d:	e8 bc fb ff ff       	call   8011ee <dev_lookup>
  801632:	83 c4 10             	add    $0x10,%esp
  801635:	85 c0                	test   %eax,%eax
  801637:	78 33                	js     80166c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801640:	74 2f                	je     801671 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801642:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801645:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80164c:	00 00 00 
	stat->st_isdir = 0;
  80164f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801656:	00 00 00 
	stat->st_dev = dev;
  801659:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80165f:	83 ec 08             	sub    $0x8,%esp
  801662:	53                   	push   %ebx
  801663:	ff 75 f0             	pushl  -0x10(%ebp)
  801666:	ff 50 14             	call   *0x14(%eax)
  801669:	83 c4 10             	add    $0x10,%esp
}
  80166c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80166f:	c9                   	leave  
  801670:	c3                   	ret    
		return -E_NOT_SUPP;
  801671:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801676:	eb f4                	jmp    80166c <fstat+0x68>

00801678 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
  80167b:	56                   	push   %esi
  80167c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80167d:	83 ec 08             	sub    $0x8,%esp
  801680:	6a 00                	push   $0x0
  801682:	ff 75 08             	pushl  0x8(%ebp)
  801685:	e8 22 02 00 00       	call   8018ac <open>
  80168a:	89 c3                	mov    %eax,%ebx
  80168c:	83 c4 10             	add    $0x10,%esp
  80168f:	85 c0                	test   %eax,%eax
  801691:	78 1b                	js     8016ae <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801693:	83 ec 08             	sub    $0x8,%esp
  801696:	ff 75 0c             	pushl  0xc(%ebp)
  801699:	50                   	push   %eax
  80169a:	e8 65 ff ff ff       	call   801604 <fstat>
  80169f:	89 c6                	mov    %eax,%esi
	close(fd);
  8016a1:	89 1c 24             	mov    %ebx,(%esp)
  8016a4:	e8 27 fc ff ff       	call   8012d0 <close>
	return r;
  8016a9:	83 c4 10             	add    $0x10,%esp
  8016ac:	89 f3                	mov    %esi,%ebx
}
  8016ae:	89 d8                	mov    %ebx,%eax
  8016b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016b3:	5b                   	pop    %ebx
  8016b4:	5e                   	pop    %esi
  8016b5:	5d                   	pop    %ebp
  8016b6:	c3                   	ret    

008016b7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
  8016ba:	56                   	push   %esi
  8016bb:	53                   	push   %ebx
  8016bc:	89 c6                	mov    %eax,%esi
  8016be:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016c0:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016c7:	74 27                	je     8016f0 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016c9:	6a 07                	push   $0x7
  8016cb:	68 00 50 c0 00       	push   $0xc05000
  8016d0:	56                   	push   %esi
  8016d1:	ff 35 00 40 80 00    	pushl  0x804000
  8016d7:	e8 08 0c 00 00       	call   8022e4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016dc:	83 c4 0c             	add    $0xc,%esp
  8016df:	6a 00                	push   $0x0
  8016e1:	53                   	push   %ebx
  8016e2:	6a 00                	push   $0x0
  8016e4:	e8 92 0b 00 00       	call   80227b <ipc_recv>
}
  8016e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016ec:	5b                   	pop    %ebx
  8016ed:	5e                   	pop    %esi
  8016ee:	5d                   	pop    %ebp
  8016ef:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016f0:	83 ec 0c             	sub    $0xc,%esp
  8016f3:	6a 01                	push   $0x1
  8016f5:	e8 42 0c 00 00       	call   80233c <ipc_find_env>
  8016fa:	a3 00 40 80 00       	mov    %eax,0x804000
  8016ff:	83 c4 10             	add    $0x10,%esp
  801702:	eb c5                	jmp    8016c9 <fsipc+0x12>

00801704 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801704:	55                   	push   %ebp
  801705:	89 e5                	mov    %esp,%ebp
  801707:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80170a:	8b 45 08             	mov    0x8(%ebp),%eax
  80170d:	8b 40 0c             	mov    0xc(%eax),%eax
  801710:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.set_size.req_size = newsize;
  801715:	8b 45 0c             	mov    0xc(%ebp),%eax
  801718:	a3 04 50 c0 00       	mov    %eax,0xc05004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80171d:	ba 00 00 00 00       	mov    $0x0,%edx
  801722:	b8 02 00 00 00       	mov    $0x2,%eax
  801727:	e8 8b ff ff ff       	call   8016b7 <fsipc>
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <devfile_flush>:
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
  801737:	8b 40 0c             	mov    0xc(%eax),%eax
  80173a:	a3 00 50 c0 00       	mov    %eax,0xc05000
	return fsipc(FSREQ_FLUSH, NULL);
  80173f:	ba 00 00 00 00       	mov    $0x0,%edx
  801744:	b8 06 00 00 00       	mov    $0x6,%eax
  801749:	e8 69 ff ff ff       	call   8016b7 <fsipc>
}
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <devfile_stat>:
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	53                   	push   %ebx
  801754:	83 ec 04             	sub    $0x4,%esp
  801757:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80175a:	8b 45 08             	mov    0x8(%ebp),%eax
  80175d:	8b 40 0c             	mov    0xc(%eax),%eax
  801760:	a3 00 50 c0 00       	mov    %eax,0xc05000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801765:	ba 00 00 00 00       	mov    $0x0,%edx
  80176a:	b8 05 00 00 00       	mov    $0x5,%eax
  80176f:	e8 43 ff ff ff       	call   8016b7 <fsipc>
  801774:	85 c0                	test   %eax,%eax
  801776:	78 2c                	js     8017a4 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801778:	83 ec 08             	sub    $0x8,%esp
  80177b:	68 00 50 c0 00       	push   $0xc05000
  801780:	53                   	push   %ebx
  801781:	e8 b8 f2 ff ff       	call   800a3e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801786:	a1 80 50 c0 00       	mov    0xc05080,%eax
  80178b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801791:	a1 84 50 c0 00       	mov    0xc05084,%eax
  801796:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80179c:	83 c4 10             	add    $0x10,%esp
  80179f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <devfile_write>:
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
  8017ac:	53                   	push   %ebx
  8017ad:	83 ec 08             	sub    $0x8,%esp
  8017b0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b9:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.write.req_n = n;
  8017be:	89 1d 04 50 c0 00    	mov    %ebx,0xc05004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8017c4:	53                   	push   %ebx
  8017c5:	ff 75 0c             	pushl  0xc(%ebp)
  8017c8:	68 08 50 c0 00       	push   $0xc05008
  8017cd:	e8 5c f4 ff ff       	call   800c2e <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d7:	b8 04 00 00 00       	mov    $0x4,%eax
  8017dc:	e8 d6 fe ff ff       	call   8016b7 <fsipc>
  8017e1:	83 c4 10             	add    $0x10,%esp
  8017e4:	85 c0                	test   %eax,%eax
  8017e6:	78 0b                	js     8017f3 <devfile_write+0x4a>
	assert(r <= n);
  8017e8:	39 d8                	cmp    %ebx,%eax
  8017ea:	77 0c                	ja     8017f8 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8017ec:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017f1:	7f 1e                	jg     801811 <devfile_write+0x68>
}
  8017f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    
	assert(r <= n);
  8017f8:	68 c8 2b 80 00       	push   $0x802bc8
  8017fd:	68 cf 2b 80 00       	push   $0x802bcf
  801802:	68 98 00 00 00       	push   $0x98
  801807:	68 e4 2b 80 00       	push   $0x802be4
  80180c:	e8 d8 e9 ff ff       	call   8001e9 <_panic>
	assert(r <= PGSIZE);
  801811:	68 ef 2b 80 00       	push   $0x802bef
  801816:	68 cf 2b 80 00       	push   $0x802bcf
  80181b:	68 99 00 00 00       	push   $0x99
  801820:	68 e4 2b 80 00       	push   $0x802be4
  801825:	e8 bf e9 ff ff       	call   8001e9 <_panic>

0080182a <devfile_read>:
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	56                   	push   %esi
  80182e:	53                   	push   %ebx
  80182f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801832:	8b 45 08             	mov    0x8(%ebp),%eax
  801835:	8b 40 0c             	mov    0xc(%eax),%eax
  801838:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.read.req_n = n;
  80183d:	89 35 04 50 c0 00    	mov    %esi,0xc05004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801843:	ba 00 00 00 00       	mov    $0x0,%edx
  801848:	b8 03 00 00 00       	mov    $0x3,%eax
  80184d:	e8 65 fe ff ff       	call   8016b7 <fsipc>
  801852:	89 c3                	mov    %eax,%ebx
  801854:	85 c0                	test   %eax,%eax
  801856:	78 1f                	js     801877 <devfile_read+0x4d>
	assert(r <= n);
  801858:	39 f0                	cmp    %esi,%eax
  80185a:	77 24                	ja     801880 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80185c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801861:	7f 33                	jg     801896 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801863:	83 ec 04             	sub    $0x4,%esp
  801866:	50                   	push   %eax
  801867:	68 00 50 c0 00       	push   $0xc05000
  80186c:	ff 75 0c             	pushl  0xc(%ebp)
  80186f:	e8 58 f3 ff ff       	call   800bcc <memmove>
	return r;
  801874:	83 c4 10             	add    $0x10,%esp
}
  801877:	89 d8                	mov    %ebx,%eax
  801879:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80187c:	5b                   	pop    %ebx
  80187d:	5e                   	pop    %esi
  80187e:	5d                   	pop    %ebp
  80187f:	c3                   	ret    
	assert(r <= n);
  801880:	68 c8 2b 80 00       	push   $0x802bc8
  801885:	68 cf 2b 80 00       	push   $0x802bcf
  80188a:	6a 7c                	push   $0x7c
  80188c:	68 e4 2b 80 00       	push   $0x802be4
  801891:	e8 53 e9 ff ff       	call   8001e9 <_panic>
	assert(r <= PGSIZE);
  801896:	68 ef 2b 80 00       	push   $0x802bef
  80189b:	68 cf 2b 80 00       	push   $0x802bcf
  8018a0:	6a 7d                	push   $0x7d
  8018a2:	68 e4 2b 80 00       	push   $0x802be4
  8018a7:	e8 3d e9 ff ff       	call   8001e9 <_panic>

008018ac <open>:
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	56                   	push   %esi
  8018b0:	53                   	push   %ebx
  8018b1:	83 ec 1c             	sub    $0x1c,%esp
  8018b4:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018b7:	56                   	push   %esi
  8018b8:	e8 48 f1 ff ff       	call   800a05 <strlen>
  8018bd:	83 c4 10             	add    $0x10,%esp
  8018c0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018c5:	7f 6c                	jg     801933 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018c7:	83 ec 0c             	sub    $0xc,%esp
  8018ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018cd:	50                   	push   %eax
  8018ce:	e8 79 f8 ff ff       	call   80114c <fd_alloc>
  8018d3:	89 c3                	mov    %eax,%ebx
  8018d5:	83 c4 10             	add    $0x10,%esp
  8018d8:	85 c0                	test   %eax,%eax
  8018da:	78 3c                	js     801918 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8018dc:	83 ec 08             	sub    $0x8,%esp
  8018df:	56                   	push   %esi
  8018e0:	68 00 50 c0 00       	push   $0xc05000
  8018e5:	e8 54 f1 ff ff       	call   800a3e <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ed:	a3 00 54 c0 00       	mov    %eax,0xc05400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8018fa:	e8 b8 fd ff ff       	call   8016b7 <fsipc>
  8018ff:	89 c3                	mov    %eax,%ebx
  801901:	83 c4 10             	add    $0x10,%esp
  801904:	85 c0                	test   %eax,%eax
  801906:	78 19                	js     801921 <open+0x75>
	return fd2num(fd);
  801908:	83 ec 0c             	sub    $0xc,%esp
  80190b:	ff 75 f4             	pushl  -0xc(%ebp)
  80190e:	e8 12 f8 ff ff       	call   801125 <fd2num>
  801913:	89 c3                	mov    %eax,%ebx
  801915:	83 c4 10             	add    $0x10,%esp
}
  801918:	89 d8                	mov    %ebx,%eax
  80191a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80191d:	5b                   	pop    %ebx
  80191e:	5e                   	pop    %esi
  80191f:	5d                   	pop    %ebp
  801920:	c3                   	ret    
		fd_close(fd, 0);
  801921:	83 ec 08             	sub    $0x8,%esp
  801924:	6a 00                	push   $0x0
  801926:	ff 75 f4             	pushl  -0xc(%ebp)
  801929:	e8 1b f9 ff ff       	call   801249 <fd_close>
		return r;
  80192e:	83 c4 10             	add    $0x10,%esp
  801931:	eb e5                	jmp    801918 <open+0x6c>
		return -E_BAD_PATH;
  801933:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801938:	eb de                	jmp    801918 <open+0x6c>

0080193a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801940:	ba 00 00 00 00       	mov    $0x0,%edx
  801945:	b8 08 00 00 00       	mov    $0x8,%eax
  80194a:	e8 68 fd ff ff       	call   8016b7 <fsipc>
}
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
  801954:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801957:	68 fb 2b 80 00       	push   $0x802bfb
  80195c:	ff 75 0c             	pushl  0xc(%ebp)
  80195f:	e8 da f0 ff ff       	call   800a3e <strcpy>
	return 0;
}
  801964:	b8 00 00 00 00       	mov    $0x0,%eax
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <devsock_close>:
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	53                   	push   %ebx
  80196f:	83 ec 10             	sub    $0x10,%esp
  801972:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801975:	53                   	push   %ebx
  801976:	e8 fc 09 00 00       	call   802377 <pageref>
  80197b:	83 c4 10             	add    $0x10,%esp
		return 0;
  80197e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801983:	83 f8 01             	cmp    $0x1,%eax
  801986:	74 07                	je     80198f <devsock_close+0x24>
}
  801988:	89 d0                	mov    %edx,%eax
  80198a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80198f:	83 ec 0c             	sub    $0xc,%esp
  801992:	ff 73 0c             	pushl  0xc(%ebx)
  801995:	e8 b9 02 00 00       	call   801c53 <nsipc_close>
  80199a:	89 c2                	mov    %eax,%edx
  80199c:	83 c4 10             	add    $0x10,%esp
  80199f:	eb e7                	jmp    801988 <devsock_close+0x1d>

008019a1 <devsock_write>:
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
  8019a4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019a7:	6a 00                	push   $0x0
  8019a9:	ff 75 10             	pushl  0x10(%ebp)
  8019ac:	ff 75 0c             	pushl  0xc(%ebp)
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	ff 70 0c             	pushl  0xc(%eax)
  8019b5:	e8 76 03 00 00       	call   801d30 <nsipc_send>
}
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <devsock_read>:
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
  8019bf:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019c2:	6a 00                	push   $0x0
  8019c4:	ff 75 10             	pushl  0x10(%ebp)
  8019c7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cd:	ff 70 0c             	pushl  0xc(%eax)
  8019d0:	e8 ef 02 00 00       	call   801cc4 <nsipc_recv>
}
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <fd2sockid>:
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
  8019da:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8019dd:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8019e0:	52                   	push   %edx
  8019e1:	50                   	push   %eax
  8019e2:	e8 b7 f7 ff ff       	call   80119e <fd_lookup>
  8019e7:	83 c4 10             	add    $0x10,%esp
  8019ea:	85 c0                	test   %eax,%eax
  8019ec:	78 10                	js     8019fe <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8019ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f1:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8019f7:	39 08                	cmp    %ecx,(%eax)
  8019f9:	75 05                	jne    801a00 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8019fb:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    
		return -E_NOT_SUPP;
  801a00:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a05:	eb f7                	jmp    8019fe <fd2sockid+0x27>

00801a07 <alloc_sockfd>:
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	56                   	push   %esi
  801a0b:	53                   	push   %ebx
  801a0c:	83 ec 1c             	sub    $0x1c,%esp
  801a0f:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a11:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a14:	50                   	push   %eax
  801a15:	e8 32 f7 ff ff       	call   80114c <fd_alloc>
  801a1a:	89 c3                	mov    %eax,%ebx
  801a1c:	83 c4 10             	add    $0x10,%esp
  801a1f:	85 c0                	test   %eax,%eax
  801a21:	78 43                	js     801a66 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a23:	83 ec 04             	sub    $0x4,%esp
  801a26:	68 07 04 00 00       	push   $0x407
  801a2b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a2e:	6a 00                	push   $0x0
  801a30:	e8 fb f3 ff ff       	call   800e30 <sys_page_alloc>
  801a35:	89 c3                	mov    %eax,%ebx
  801a37:	83 c4 10             	add    $0x10,%esp
  801a3a:	85 c0                	test   %eax,%eax
  801a3c:	78 28                	js     801a66 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a41:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a47:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a53:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a56:	83 ec 0c             	sub    $0xc,%esp
  801a59:	50                   	push   %eax
  801a5a:	e8 c6 f6 ff ff       	call   801125 <fd2num>
  801a5f:	89 c3                	mov    %eax,%ebx
  801a61:	83 c4 10             	add    $0x10,%esp
  801a64:	eb 0c                	jmp    801a72 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a66:	83 ec 0c             	sub    $0xc,%esp
  801a69:	56                   	push   %esi
  801a6a:	e8 e4 01 00 00       	call   801c53 <nsipc_close>
		return r;
  801a6f:	83 c4 10             	add    $0x10,%esp
}
  801a72:	89 d8                	mov    %ebx,%eax
  801a74:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a77:	5b                   	pop    %ebx
  801a78:	5e                   	pop    %esi
  801a79:	5d                   	pop    %ebp
  801a7a:	c3                   	ret    

00801a7b <accept>:
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
  801a7e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	e8 4e ff ff ff       	call   8019d7 <fd2sockid>
  801a89:	85 c0                	test   %eax,%eax
  801a8b:	78 1b                	js     801aa8 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a8d:	83 ec 04             	sub    $0x4,%esp
  801a90:	ff 75 10             	pushl  0x10(%ebp)
  801a93:	ff 75 0c             	pushl  0xc(%ebp)
  801a96:	50                   	push   %eax
  801a97:	e8 0e 01 00 00       	call   801baa <nsipc_accept>
  801a9c:	83 c4 10             	add    $0x10,%esp
  801a9f:	85 c0                	test   %eax,%eax
  801aa1:	78 05                	js     801aa8 <accept+0x2d>
	return alloc_sockfd(r);
  801aa3:	e8 5f ff ff ff       	call   801a07 <alloc_sockfd>
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <bind>:
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
  801aad:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	e8 1f ff ff ff       	call   8019d7 <fd2sockid>
  801ab8:	85 c0                	test   %eax,%eax
  801aba:	78 12                	js     801ace <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801abc:	83 ec 04             	sub    $0x4,%esp
  801abf:	ff 75 10             	pushl  0x10(%ebp)
  801ac2:	ff 75 0c             	pushl  0xc(%ebp)
  801ac5:	50                   	push   %eax
  801ac6:	e8 31 01 00 00       	call   801bfc <nsipc_bind>
  801acb:	83 c4 10             	add    $0x10,%esp
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <shutdown>:
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
  801ad3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad9:	e8 f9 fe ff ff       	call   8019d7 <fd2sockid>
  801ade:	85 c0                	test   %eax,%eax
  801ae0:	78 0f                	js     801af1 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801ae2:	83 ec 08             	sub    $0x8,%esp
  801ae5:	ff 75 0c             	pushl  0xc(%ebp)
  801ae8:	50                   	push   %eax
  801ae9:	e8 43 01 00 00       	call   801c31 <nsipc_shutdown>
  801aee:	83 c4 10             	add    $0x10,%esp
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <connect>:
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801af9:	8b 45 08             	mov    0x8(%ebp),%eax
  801afc:	e8 d6 fe ff ff       	call   8019d7 <fd2sockid>
  801b01:	85 c0                	test   %eax,%eax
  801b03:	78 12                	js     801b17 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b05:	83 ec 04             	sub    $0x4,%esp
  801b08:	ff 75 10             	pushl  0x10(%ebp)
  801b0b:	ff 75 0c             	pushl  0xc(%ebp)
  801b0e:	50                   	push   %eax
  801b0f:	e8 59 01 00 00       	call   801c6d <nsipc_connect>
  801b14:	83 c4 10             	add    $0x10,%esp
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <listen>:
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b22:	e8 b0 fe ff ff       	call   8019d7 <fd2sockid>
  801b27:	85 c0                	test   %eax,%eax
  801b29:	78 0f                	js     801b3a <listen+0x21>
	return nsipc_listen(r, backlog);
  801b2b:	83 ec 08             	sub    $0x8,%esp
  801b2e:	ff 75 0c             	pushl  0xc(%ebp)
  801b31:	50                   	push   %eax
  801b32:	e8 6b 01 00 00       	call   801ca2 <nsipc_listen>
  801b37:	83 c4 10             	add    $0x10,%esp
}
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <socket>:

int
socket(int domain, int type, int protocol)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
  801b3f:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b42:	ff 75 10             	pushl  0x10(%ebp)
  801b45:	ff 75 0c             	pushl  0xc(%ebp)
  801b48:	ff 75 08             	pushl  0x8(%ebp)
  801b4b:	e8 3e 02 00 00       	call   801d8e <nsipc_socket>
  801b50:	83 c4 10             	add    $0x10,%esp
  801b53:	85 c0                	test   %eax,%eax
  801b55:	78 05                	js     801b5c <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801b57:	e8 ab fe ff ff       	call   801a07 <alloc_sockfd>
}
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	53                   	push   %ebx
  801b62:	83 ec 04             	sub    $0x4,%esp
  801b65:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b67:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b6e:	74 26                	je     801b96 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b70:	6a 07                	push   $0x7
  801b72:	68 00 60 c0 00       	push   $0xc06000
  801b77:	53                   	push   %ebx
  801b78:	ff 35 04 40 80 00    	pushl  0x804004
  801b7e:	e8 61 07 00 00       	call   8022e4 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b83:	83 c4 0c             	add    $0xc,%esp
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	e8 ea 06 00 00       	call   80227b <ipc_recv>
}
  801b91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b96:	83 ec 0c             	sub    $0xc,%esp
  801b99:	6a 02                	push   $0x2
  801b9b:	e8 9c 07 00 00       	call   80233c <ipc_find_env>
  801ba0:	a3 04 40 80 00       	mov    %eax,0x804004
  801ba5:	83 c4 10             	add    $0x10,%esp
  801ba8:	eb c6                	jmp    801b70 <nsipc+0x12>

00801baa <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
  801bad:	56                   	push   %esi
  801bae:	53                   	push   %ebx
  801baf:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801bba:	8b 06                	mov    (%esi),%eax
  801bbc:	a3 04 60 c0 00       	mov    %eax,0xc06004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801bc1:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc6:	e8 93 ff ff ff       	call   801b5e <nsipc>
  801bcb:	89 c3                	mov    %eax,%ebx
  801bcd:	85 c0                	test   %eax,%eax
  801bcf:	79 09                	jns    801bda <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801bd1:	89 d8                	mov    %ebx,%eax
  801bd3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bd6:	5b                   	pop    %ebx
  801bd7:	5e                   	pop    %esi
  801bd8:	5d                   	pop    %ebp
  801bd9:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801bda:	83 ec 04             	sub    $0x4,%esp
  801bdd:	ff 35 10 60 c0 00    	pushl  0xc06010
  801be3:	68 00 60 c0 00       	push   $0xc06000
  801be8:	ff 75 0c             	pushl  0xc(%ebp)
  801beb:	e8 dc ef ff ff       	call   800bcc <memmove>
		*addrlen = ret->ret_addrlen;
  801bf0:	a1 10 60 c0 00       	mov    0xc06010,%eax
  801bf5:	89 06                	mov    %eax,(%esi)
  801bf7:	83 c4 10             	add    $0x10,%esp
	return r;
  801bfa:	eb d5                	jmp    801bd1 <nsipc_accept+0x27>

00801bfc <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	53                   	push   %ebx
  801c00:	83 ec 08             	sub    $0x8,%esp
  801c03:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c06:	8b 45 08             	mov    0x8(%ebp),%eax
  801c09:	a3 00 60 c0 00       	mov    %eax,0xc06000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c0e:	53                   	push   %ebx
  801c0f:	ff 75 0c             	pushl  0xc(%ebp)
  801c12:	68 04 60 c0 00       	push   $0xc06004
  801c17:	e8 b0 ef ff ff       	call   800bcc <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c1c:	89 1d 14 60 c0 00    	mov    %ebx,0xc06014
	return nsipc(NSREQ_BIND);
  801c22:	b8 02 00 00 00       	mov    $0x2,%eax
  801c27:	e8 32 ff ff ff       	call   801b5e <nsipc>
}
  801c2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
  801c34:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.shutdown.req_how = how;
  801c3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c42:	a3 04 60 c0 00       	mov    %eax,0xc06004
	return nsipc(NSREQ_SHUTDOWN);
  801c47:	b8 03 00 00 00       	mov    $0x3,%eax
  801c4c:	e8 0d ff ff ff       	call   801b5e <nsipc>
}
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    

00801c53 <nsipc_close>:

int
nsipc_close(int s)
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
  801c56:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	a3 00 60 c0 00       	mov    %eax,0xc06000
	return nsipc(NSREQ_CLOSE);
  801c61:	b8 04 00 00 00       	mov    $0x4,%eax
  801c66:	e8 f3 fe ff ff       	call   801b5e <nsipc>
}
  801c6b:	c9                   	leave  
  801c6c:	c3                   	ret    

00801c6d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
  801c70:	53                   	push   %ebx
  801c71:	83 ec 08             	sub    $0x8,%esp
  801c74:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c77:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7a:	a3 00 60 c0 00       	mov    %eax,0xc06000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c7f:	53                   	push   %ebx
  801c80:	ff 75 0c             	pushl  0xc(%ebp)
  801c83:	68 04 60 c0 00       	push   $0xc06004
  801c88:	e8 3f ef ff ff       	call   800bcc <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c8d:	89 1d 14 60 c0 00    	mov    %ebx,0xc06014
	return nsipc(NSREQ_CONNECT);
  801c93:	b8 05 00 00 00       	mov    $0x5,%eax
  801c98:	e8 c1 fe ff ff       	call   801b5e <nsipc>
}
  801c9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
  801ca5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cab:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.listen.req_backlog = backlog;
  801cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb3:	a3 04 60 c0 00       	mov    %eax,0xc06004
	return nsipc(NSREQ_LISTEN);
  801cb8:	b8 06 00 00 00       	mov    $0x6,%eax
  801cbd:	e8 9c fe ff ff       	call   801b5e <nsipc>
}
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
  801cc7:	56                   	push   %esi
  801cc8:	53                   	push   %ebx
  801cc9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccf:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.recv.req_len = len;
  801cd4:	89 35 04 60 c0 00    	mov    %esi,0xc06004
	nsipcbuf.recv.req_flags = flags;
  801cda:	8b 45 14             	mov    0x14(%ebp),%eax
  801cdd:	a3 08 60 c0 00       	mov    %eax,0xc06008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801ce2:	b8 07 00 00 00       	mov    $0x7,%eax
  801ce7:	e8 72 fe ff ff       	call   801b5e <nsipc>
  801cec:	89 c3                	mov    %eax,%ebx
  801cee:	85 c0                	test   %eax,%eax
  801cf0:	78 1f                	js     801d11 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801cf2:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801cf7:	7f 21                	jg     801d1a <nsipc_recv+0x56>
  801cf9:	39 c6                	cmp    %eax,%esi
  801cfb:	7c 1d                	jl     801d1a <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801cfd:	83 ec 04             	sub    $0x4,%esp
  801d00:	50                   	push   %eax
  801d01:	68 00 60 c0 00       	push   $0xc06000
  801d06:	ff 75 0c             	pushl  0xc(%ebp)
  801d09:	e8 be ee ff ff       	call   800bcc <memmove>
  801d0e:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d11:	89 d8                	mov    %ebx,%eax
  801d13:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d16:	5b                   	pop    %ebx
  801d17:	5e                   	pop    %esi
  801d18:	5d                   	pop    %ebp
  801d19:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d1a:	68 07 2c 80 00       	push   $0x802c07
  801d1f:	68 cf 2b 80 00       	push   $0x802bcf
  801d24:	6a 62                	push   $0x62
  801d26:	68 1c 2c 80 00       	push   $0x802c1c
  801d2b:	e8 b9 e4 ff ff       	call   8001e9 <_panic>

00801d30 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
  801d33:	53                   	push   %ebx
  801d34:	83 ec 04             	sub    $0x4,%esp
  801d37:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3d:	a3 00 60 c0 00       	mov    %eax,0xc06000
	assert(size < 1600);
  801d42:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d48:	7f 2e                	jg     801d78 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d4a:	83 ec 04             	sub    $0x4,%esp
  801d4d:	53                   	push   %ebx
  801d4e:	ff 75 0c             	pushl  0xc(%ebp)
  801d51:	68 0c 60 c0 00       	push   $0xc0600c
  801d56:	e8 71 ee ff ff       	call   800bcc <memmove>
	nsipcbuf.send.req_size = size;
  801d5b:	89 1d 04 60 c0 00    	mov    %ebx,0xc06004
	nsipcbuf.send.req_flags = flags;
  801d61:	8b 45 14             	mov    0x14(%ebp),%eax
  801d64:	a3 08 60 c0 00       	mov    %eax,0xc06008
	return nsipc(NSREQ_SEND);
  801d69:	b8 08 00 00 00       	mov    $0x8,%eax
  801d6e:	e8 eb fd ff ff       	call   801b5e <nsipc>
}
  801d73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    
	assert(size < 1600);
  801d78:	68 28 2c 80 00       	push   $0x802c28
  801d7d:	68 cf 2b 80 00       	push   $0x802bcf
  801d82:	6a 6d                	push   $0x6d
  801d84:	68 1c 2c 80 00       	push   $0x802c1c
  801d89:	e8 5b e4 ff ff       	call   8001e9 <_panic>

00801d8e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d94:	8b 45 08             	mov    0x8(%ebp),%eax
  801d97:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.socket.req_type = type;
  801d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d9f:	a3 04 60 c0 00       	mov    %eax,0xc06004
	nsipcbuf.socket.req_protocol = protocol;
  801da4:	8b 45 10             	mov    0x10(%ebp),%eax
  801da7:	a3 08 60 c0 00       	mov    %eax,0xc06008
	return nsipc(NSREQ_SOCKET);
  801dac:	b8 09 00 00 00       	mov    $0x9,%eax
  801db1:	e8 a8 fd ff ff       	call   801b5e <nsipc>
}
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
  801dbb:	56                   	push   %esi
  801dbc:	53                   	push   %ebx
  801dbd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801dc0:	83 ec 0c             	sub    $0xc,%esp
  801dc3:	ff 75 08             	pushl  0x8(%ebp)
  801dc6:	e8 6a f3 ff ff       	call   801135 <fd2data>
  801dcb:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801dcd:	83 c4 08             	add    $0x8,%esp
  801dd0:	68 34 2c 80 00       	push   $0x802c34
  801dd5:	53                   	push   %ebx
  801dd6:	e8 63 ec ff ff       	call   800a3e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ddb:	8b 46 04             	mov    0x4(%esi),%eax
  801dde:	2b 06                	sub    (%esi),%eax
  801de0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801de6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ded:	00 00 00 
	stat->st_dev = &devpipe;
  801df0:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801df7:	30 80 00 
	return 0;
}
  801dfa:	b8 00 00 00 00       	mov    $0x0,%eax
  801dff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e02:	5b                   	pop    %ebx
  801e03:	5e                   	pop    %esi
  801e04:	5d                   	pop    %ebp
  801e05:	c3                   	ret    

00801e06 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
  801e09:	53                   	push   %ebx
  801e0a:	83 ec 0c             	sub    $0xc,%esp
  801e0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e10:	53                   	push   %ebx
  801e11:	6a 00                	push   $0x0
  801e13:	e8 9d f0 ff ff       	call   800eb5 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e18:	89 1c 24             	mov    %ebx,(%esp)
  801e1b:	e8 15 f3 ff ff       	call   801135 <fd2data>
  801e20:	83 c4 08             	add    $0x8,%esp
  801e23:	50                   	push   %eax
  801e24:	6a 00                	push   $0x0
  801e26:	e8 8a f0 ff ff       	call   800eb5 <sys_page_unmap>
}
  801e2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e2e:	c9                   	leave  
  801e2f:	c3                   	ret    

00801e30 <_pipeisclosed>:
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
  801e33:	57                   	push   %edi
  801e34:	56                   	push   %esi
  801e35:	53                   	push   %ebx
  801e36:	83 ec 1c             	sub    $0x1c,%esp
  801e39:	89 c7                	mov    %eax,%edi
  801e3b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e3d:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801e42:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e45:	83 ec 0c             	sub    $0xc,%esp
  801e48:	57                   	push   %edi
  801e49:	e8 29 05 00 00       	call   802377 <pageref>
  801e4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e51:	89 34 24             	mov    %esi,(%esp)
  801e54:	e8 1e 05 00 00       	call   802377 <pageref>
		nn = thisenv->env_runs;
  801e59:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  801e5f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e62:	83 c4 10             	add    $0x10,%esp
  801e65:	39 cb                	cmp    %ecx,%ebx
  801e67:	74 1b                	je     801e84 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e69:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e6c:	75 cf                	jne    801e3d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e6e:	8b 42 58             	mov    0x58(%edx),%eax
  801e71:	6a 01                	push   $0x1
  801e73:	50                   	push   %eax
  801e74:	53                   	push   %ebx
  801e75:	68 3b 2c 80 00       	push   $0x802c3b
  801e7a:	e8 60 e4 ff ff       	call   8002df <cprintf>
  801e7f:	83 c4 10             	add    $0x10,%esp
  801e82:	eb b9                	jmp    801e3d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e84:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e87:	0f 94 c0             	sete   %al
  801e8a:	0f b6 c0             	movzbl %al,%eax
}
  801e8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e90:	5b                   	pop    %ebx
  801e91:	5e                   	pop    %esi
  801e92:	5f                   	pop    %edi
  801e93:	5d                   	pop    %ebp
  801e94:	c3                   	ret    

00801e95 <devpipe_write>:
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	57                   	push   %edi
  801e99:	56                   	push   %esi
  801e9a:	53                   	push   %ebx
  801e9b:	83 ec 28             	sub    $0x28,%esp
  801e9e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801ea1:	56                   	push   %esi
  801ea2:	e8 8e f2 ff ff       	call   801135 <fd2data>
  801ea7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ea9:	83 c4 10             	add    $0x10,%esp
  801eac:	bf 00 00 00 00       	mov    $0x0,%edi
  801eb1:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801eb4:	74 4f                	je     801f05 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801eb6:	8b 43 04             	mov    0x4(%ebx),%eax
  801eb9:	8b 0b                	mov    (%ebx),%ecx
  801ebb:	8d 51 20             	lea    0x20(%ecx),%edx
  801ebe:	39 d0                	cmp    %edx,%eax
  801ec0:	72 14                	jb     801ed6 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ec2:	89 da                	mov    %ebx,%edx
  801ec4:	89 f0                	mov    %esi,%eax
  801ec6:	e8 65 ff ff ff       	call   801e30 <_pipeisclosed>
  801ecb:	85 c0                	test   %eax,%eax
  801ecd:	75 3b                	jne    801f0a <devpipe_write+0x75>
			sys_yield();
  801ecf:	e8 3d ef ff ff       	call   800e11 <sys_yield>
  801ed4:	eb e0                	jmp    801eb6 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ed6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ed9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801edd:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ee0:	89 c2                	mov    %eax,%edx
  801ee2:	c1 fa 1f             	sar    $0x1f,%edx
  801ee5:	89 d1                	mov    %edx,%ecx
  801ee7:	c1 e9 1b             	shr    $0x1b,%ecx
  801eea:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801eed:	83 e2 1f             	and    $0x1f,%edx
  801ef0:	29 ca                	sub    %ecx,%edx
  801ef2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ef6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801efa:	83 c0 01             	add    $0x1,%eax
  801efd:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f00:	83 c7 01             	add    $0x1,%edi
  801f03:	eb ac                	jmp    801eb1 <devpipe_write+0x1c>
	return i;
  801f05:	8b 45 10             	mov    0x10(%ebp),%eax
  801f08:	eb 05                	jmp    801f0f <devpipe_write+0x7a>
				return 0;
  801f0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f12:	5b                   	pop    %ebx
  801f13:	5e                   	pop    %esi
  801f14:	5f                   	pop    %edi
  801f15:	5d                   	pop    %ebp
  801f16:	c3                   	ret    

00801f17 <devpipe_read>:
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	57                   	push   %edi
  801f1b:	56                   	push   %esi
  801f1c:	53                   	push   %ebx
  801f1d:	83 ec 18             	sub    $0x18,%esp
  801f20:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f23:	57                   	push   %edi
  801f24:	e8 0c f2 ff ff       	call   801135 <fd2data>
  801f29:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f2b:	83 c4 10             	add    $0x10,%esp
  801f2e:	be 00 00 00 00       	mov    $0x0,%esi
  801f33:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f36:	75 14                	jne    801f4c <devpipe_read+0x35>
	return i;
  801f38:	8b 45 10             	mov    0x10(%ebp),%eax
  801f3b:	eb 02                	jmp    801f3f <devpipe_read+0x28>
				return i;
  801f3d:	89 f0                	mov    %esi,%eax
}
  801f3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f42:	5b                   	pop    %ebx
  801f43:	5e                   	pop    %esi
  801f44:	5f                   	pop    %edi
  801f45:	5d                   	pop    %ebp
  801f46:	c3                   	ret    
			sys_yield();
  801f47:	e8 c5 ee ff ff       	call   800e11 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801f4c:	8b 03                	mov    (%ebx),%eax
  801f4e:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f51:	75 18                	jne    801f6b <devpipe_read+0x54>
			if (i > 0)
  801f53:	85 f6                	test   %esi,%esi
  801f55:	75 e6                	jne    801f3d <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801f57:	89 da                	mov    %ebx,%edx
  801f59:	89 f8                	mov    %edi,%eax
  801f5b:	e8 d0 fe ff ff       	call   801e30 <_pipeisclosed>
  801f60:	85 c0                	test   %eax,%eax
  801f62:	74 e3                	je     801f47 <devpipe_read+0x30>
				return 0;
  801f64:	b8 00 00 00 00       	mov    $0x0,%eax
  801f69:	eb d4                	jmp    801f3f <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f6b:	99                   	cltd   
  801f6c:	c1 ea 1b             	shr    $0x1b,%edx
  801f6f:	01 d0                	add    %edx,%eax
  801f71:	83 e0 1f             	and    $0x1f,%eax
  801f74:	29 d0                	sub    %edx,%eax
  801f76:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f7e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f81:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f84:	83 c6 01             	add    $0x1,%esi
  801f87:	eb aa                	jmp    801f33 <devpipe_read+0x1c>

00801f89 <pipe>:
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	56                   	push   %esi
  801f8d:	53                   	push   %ebx
  801f8e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f91:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f94:	50                   	push   %eax
  801f95:	e8 b2 f1 ff ff       	call   80114c <fd_alloc>
  801f9a:	89 c3                	mov    %eax,%ebx
  801f9c:	83 c4 10             	add    $0x10,%esp
  801f9f:	85 c0                	test   %eax,%eax
  801fa1:	0f 88 23 01 00 00    	js     8020ca <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fa7:	83 ec 04             	sub    $0x4,%esp
  801faa:	68 07 04 00 00       	push   $0x407
  801faf:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb2:	6a 00                	push   $0x0
  801fb4:	e8 77 ee ff ff       	call   800e30 <sys_page_alloc>
  801fb9:	89 c3                	mov    %eax,%ebx
  801fbb:	83 c4 10             	add    $0x10,%esp
  801fbe:	85 c0                	test   %eax,%eax
  801fc0:	0f 88 04 01 00 00    	js     8020ca <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801fc6:	83 ec 0c             	sub    $0xc,%esp
  801fc9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fcc:	50                   	push   %eax
  801fcd:	e8 7a f1 ff ff       	call   80114c <fd_alloc>
  801fd2:	89 c3                	mov    %eax,%ebx
  801fd4:	83 c4 10             	add    $0x10,%esp
  801fd7:	85 c0                	test   %eax,%eax
  801fd9:	0f 88 db 00 00 00    	js     8020ba <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fdf:	83 ec 04             	sub    $0x4,%esp
  801fe2:	68 07 04 00 00       	push   $0x407
  801fe7:	ff 75 f0             	pushl  -0x10(%ebp)
  801fea:	6a 00                	push   $0x0
  801fec:	e8 3f ee ff ff       	call   800e30 <sys_page_alloc>
  801ff1:	89 c3                	mov    %eax,%ebx
  801ff3:	83 c4 10             	add    $0x10,%esp
  801ff6:	85 c0                	test   %eax,%eax
  801ff8:	0f 88 bc 00 00 00    	js     8020ba <pipe+0x131>
	va = fd2data(fd0);
  801ffe:	83 ec 0c             	sub    $0xc,%esp
  802001:	ff 75 f4             	pushl  -0xc(%ebp)
  802004:	e8 2c f1 ff ff       	call   801135 <fd2data>
  802009:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80200b:	83 c4 0c             	add    $0xc,%esp
  80200e:	68 07 04 00 00       	push   $0x407
  802013:	50                   	push   %eax
  802014:	6a 00                	push   $0x0
  802016:	e8 15 ee ff ff       	call   800e30 <sys_page_alloc>
  80201b:	89 c3                	mov    %eax,%ebx
  80201d:	83 c4 10             	add    $0x10,%esp
  802020:	85 c0                	test   %eax,%eax
  802022:	0f 88 82 00 00 00    	js     8020aa <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802028:	83 ec 0c             	sub    $0xc,%esp
  80202b:	ff 75 f0             	pushl  -0x10(%ebp)
  80202e:	e8 02 f1 ff ff       	call   801135 <fd2data>
  802033:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80203a:	50                   	push   %eax
  80203b:	6a 00                	push   $0x0
  80203d:	56                   	push   %esi
  80203e:	6a 00                	push   $0x0
  802040:	e8 2e ee ff ff       	call   800e73 <sys_page_map>
  802045:	89 c3                	mov    %eax,%ebx
  802047:	83 c4 20             	add    $0x20,%esp
  80204a:	85 c0                	test   %eax,%eax
  80204c:	78 4e                	js     80209c <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80204e:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802053:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802056:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802058:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80205b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802062:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802065:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802067:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80206a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802071:	83 ec 0c             	sub    $0xc,%esp
  802074:	ff 75 f4             	pushl  -0xc(%ebp)
  802077:	e8 a9 f0 ff ff       	call   801125 <fd2num>
  80207c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80207f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802081:	83 c4 04             	add    $0x4,%esp
  802084:	ff 75 f0             	pushl  -0x10(%ebp)
  802087:	e8 99 f0 ff ff       	call   801125 <fd2num>
  80208c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80208f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802092:	83 c4 10             	add    $0x10,%esp
  802095:	bb 00 00 00 00       	mov    $0x0,%ebx
  80209a:	eb 2e                	jmp    8020ca <pipe+0x141>
	sys_page_unmap(0, va);
  80209c:	83 ec 08             	sub    $0x8,%esp
  80209f:	56                   	push   %esi
  8020a0:	6a 00                	push   $0x0
  8020a2:	e8 0e ee ff ff       	call   800eb5 <sys_page_unmap>
  8020a7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8020aa:	83 ec 08             	sub    $0x8,%esp
  8020ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8020b0:	6a 00                	push   $0x0
  8020b2:	e8 fe ed ff ff       	call   800eb5 <sys_page_unmap>
  8020b7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8020ba:	83 ec 08             	sub    $0x8,%esp
  8020bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8020c0:	6a 00                	push   $0x0
  8020c2:	e8 ee ed ff ff       	call   800eb5 <sys_page_unmap>
  8020c7:	83 c4 10             	add    $0x10,%esp
}
  8020ca:	89 d8                	mov    %ebx,%eax
  8020cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020cf:	5b                   	pop    %ebx
  8020d0:	5e                   	pop    %esi
  8020d1:	5d                   	pop    %ebp
  8020d2:	c3                   	ret    

008020d3 <pipeisclosed>:
{
  8020d3:	55                   	push   %ebp
  8020d4:	89 e5                	mov    %esp,%ebp
  8020d6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020dc:	50                   	push   %eax
  8020dd:	ff 75 08             	pushl  0x8(%ebp)
  8020e0:	e8 b9 f0 ff ff       	call   80119e <fd_lookup>
  8020e5:	83 c4 10             	add    $0x10,%esp
  8020e8:	85 c0                	test   %eax,%eax
  8020ea:	78 18                	js     802104 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8020ec:	83 ec 0c             	sub    $0xc,%esp
  8020ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8020f2:	e8 3e f0 ff ff       	call   801135 <fd2data>
	return _pipeisclosed(fd, p);
  8020f7:	89 c2                	mov    %eax,%edx
  8020f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fc:	e8 2f fd ff ff       	call   801e30 <_pipeisclosed>
  802101:	83 c4 10             	add    $0x10,%esp
}
  802104:	c9                   	leave  
  802105:	c3                   	ret    

00802106 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802106:	b8 00 00 00 00       	mov    $0x0,%eax
  80210b:	c3                   	ret    

0080210c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
  80210f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802112:	68 53 2c 80 00       	push   $0x802c53
  802117:	ff 75 0c             	pushl  0xc(%ebp)
  80211a:	e8 1f e9 ff ff       	call   800a3e <strcpy>
	return 0;
}
  80211f:	b8 00 00 00 00       	mov    $0x0,%eax
  802124:	c9                   	leave  
  802125:	c3                   	ret    

00802126 <devcons_write>:
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
  802129:	57                   	push   %edi
  80212a:	56                   	push   %esi
  80212b:	53                   	push   %ebx
  80212c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802132:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802137:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80213d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802140:	73 31                	jae    802173 <devcons_write+0x4d>
		m = n - tot;
  802142:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802145:	29 f3                	sub    %esi,%ebx
  802147:	83 fb 7f             	cmp    $0x7f,%ebx
  80214a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80214f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802152:	83 ec 04             	sub    $0x4,%esp
  802155:	53                   	push   %ebx
  802156:	89 f0                	mov    %esi,%eax
  802158:	03 45 0c             	add    0xc(%ebp),%eax
  80215b:	50                   	push   %eax
  80215c:	57                   	push   %edi
  80215d:	e8 6a ea ff ff       	call   800bcc <memmove>
		sys_cputs(buf, m);
  802162:	83 c4 08             	add    $0x8,%esp
  802165:	53                   	push   %ebx
  802166:	57                   	push   %edi
  802167:	e8 08 ec ff ff       	call   800d74 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80216c:	01 de                	add    %ebx,%esi
  80216e:	83 c4 10             	add    $0x10,%esp
  802171:	eb ca                	jmp    80213d <devcons_write+0x17>
}
  802173:	89 f0                	mov    %esi,%eax
  802175:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802178:	5b                   	pop    %ebx
  802179:	5e                   	pop    %esi
  80217a:	5f                   	pop    %edi
  80217b:	5d                   	pop    %ebp
  80217c:	c3                   	ret    

0080217d <devcons_read>:
{
  80217d:	55                   	push   %ebp
  80217e:	89 e5                	mov    %esp,%ebp
  802180:	83 ec 08             	sub    $0x8,%esp
  802183:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802188:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80218c:	74 21                	je     8021af <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80218e:	e8 ff eb ff ff       	call   800d92 <sys_cgetc>
  802193:	85 c0                	test   %eax,%eax
  802195:	75 07                	jne    80219e <devcons_read+0x21>
		sys_yield();
  802197:	e8 75 ec ff ff       	call   800e11 <sys_yield>
  80219c:	eb f0                	jmp    80218e <devcons_read+0x11>
	if (c < 0)
  80219e:	78 0f                	js     8021af <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8021a0:	83 f8 04             	cmp    $0x4,%eax
  8021a3:	74 0c                	je     8021b1 <devcons_read+0x34>
	*(char*)vbuf = c;
  8021a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a8:	88 02                	mov    %al,(%edx)
	return 1;
  8021aa:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8021af:	c9                   	leave  
  8021b0:	c3                   	ret    
		return 0;
  8021b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b6:	eb f7                	jmp    8021af <devcons_read+0x32>

008021b8 <cputchar>:
{
  8021b8:	55                   	push   %ebp
  8021b9:	89 e5                	mov    %esp,%ebp
  8021bb:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8021be:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c1:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8021c4:	6a 01                	push   $0x1
  8021c6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021c9:	50                   	push   %eax
  8021ca:	e8 a5 eb ff ff       	call   800d74 <sys_cputs>
}
  8021cf:	83 c4 10             	add    $0x10,%esp
  8021d2:	c9                   	leave  
  8021d3:	c3                   	ret    

008021d4 <getchar>:
{
  8021d4:	55                   	push   %ebp
  8021d5:	89 e5                	mov    %esp,%ebp
  8021d7:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8021da:	6a 01                	push   $0x1
  8021dc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021df:	50                   	push   %eax
  8021e0:	6a 00                	push   $0x0
  8021e2:	e8 27 f2 ff ff       	call   80140e <read>
	if (r < 0)
  8021e7:	83 c4 10             	add    $0x10,%esp
  8021ea:	85 c0                	test   %eax,%eax
  8021ec:	78 06                	js     8021f4 <getchar+0x20>
	if (r < 1)
  8021ee:	74 06                	je     8021f6 <getchar+0x22>
	return c;
  8021f0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    
		return -E_EOF;
  8021f6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8021fb:	eb f7                	jmp    8021f4 <getchar+0x20>

008021fd <iscons>:
{
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
  802200:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802203:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802206:	50                   	push   %eax
  802207:	ff 75 08             	pushl  0x8(%ebp)
  80220a:	e8 8f ef ff ff       	call   80119e <fd_lookup>
  80220f:	83 c4 10             	add    $0x10,%esp
  802212:	85 c0                	test   %eax,%eax
  802214:	78 11                	js     802227 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802216:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802219:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80221f:	39 10                	cmp    %edx,(%eax)
  802221:	0f 94 c0             	sete   %al
  802224:	0f b6 c0             	movzbl %al,%eax
}
  802227:	c9                   	leave  
  802228:	c3                   	ret    

00802229 <opencons>:
{
  802229:	55                   	push   %ebp
  80222a:	89 e5                	mov    %esp,%ebp
  80222c:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80222f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802232:	50                   	push   %eax
  802233:	e8 14 ef ff ff       	call   80114c <fd_alloc>
  802238:	83 c4 10             	add    $0x10,%esp
  80223b:	85 c0                	test   %eax,%eax
  80223d:	78 3a                	js     802279 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80223f:	83 ec 04             	sub    $0x4,%esp
  802242:	68 07 04 00 00       	push   $0x407
  802247:	ff 75 f4             	pushl  -0xc(%ebp)
  80224a:	6a 00                	push   $0x0
  80224c:	e8 df eb ff ff       	call   800e30 <sys_page_alloc>
  802251:	83 c4 10             	add    $0x10,%esp
  802254:	85 c0                	test   %eax,%eax
  802256:	78 21                	js     802279 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802261:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802266:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80226d:	83 ec 0c             	sub    $0xc,%esp
  802270:	50                   	push   %eax
  802271:	e8 af ee ff ff       	call   801125 <fd2num>
  802276:	83 c4 10             	add    $0x10,%esp
}
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
  80227e:	56                   	push   %esi
  80227f:	53                   	push   %ebx
  802280:	8b 75 08             	mov    0x8(%ebp),%esi
  802283:	8b 45 0c             	mov    0xc(%ebp),%eax
  802286:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802289:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80228b:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802290:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802293:	83 ec 0c             	sub    $0xc,%esp
  802296:	50                   	push   %eax
  802297:	e8 44 ed ff ff       	call   800fe0 <sys_ipc_recv>
	if(ret < 0){
  80229c:	83 c4 10             	add    $0x10,%esp
  80229f:	85 c0                	test   %eax,%eax
  8022a1:	78 2b                	js     8022ce <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8022a3:	85 f6                	test   %esi,%esi
  8022a5:	74 0a                	je     8022b1 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8022a7:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8022ac:	8b 40 74             	mov    0x74(%eax),%eax
  8022af:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8022b1:	85 db                	test   %ebx,%ebx
  8022b3:	74 0a                	je     8022bf <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8022b5:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8022ba:	8b 40 78             	mov    0x78(%eax),%eax
  8022bd:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8022bf:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8022c4:	8b 40 70             	mov    0x70(%eax),%eax
}
  8022c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022ca:	5b                   	pop    %ebx
  8022cb:	5e                   	pop    %esi
  8022cc:	5d                   	pop    %ebp
  8022cd:	c3                   	ret    
		if(from_env_store)
  8022ce:	85 f6                	test   %esi,%esi
  8022d0:	74 06                	je     8022d8 <ipc_recv+0x5d>
			*from_env_store = 0;
  8022d2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8022d8:	85 db                	test   %ebx,%ebx
  8022da:	74 eb                	je     8022c7 <ipc_recv+0x4c>
			*perm_store = 0;
  8022dc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022e2:	eb e3                	jmp    8022c7 <ipc_recv+0x4c>

008022e4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
  8022e7:	57                   	push   %edi
  8022e8:	56                   	push   %esi
  8022e9:	53                   	push   %ebx
  8022ea:	83 ec 0c             	sub    $0xc,%esp
  8022ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022f0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022f3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8022f6:	85 db                	test   %ebx,%ebx
  8022f8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8022fd:	0f 44 d8             	cmove  %eax,%ebx
  802300:	eb 05                	jmp    802307 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802302:	e8 0a eb ff ff       	call   800e11 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802307:	ff 75 14             	pushl  0x14(%ebp)
  80230a:	53                   	push   %ebx
  80230b:	56                   	push   %esi
  80230c:	57                   	push   %edi
  80230d:	e8 ab ec ff ff       	call   800fbd <sys_ipc_try_send>
  802312:	83 c4 10             	add    $0x10,%esp
  802315:	85 c0                	test   %eax,%eax
  802317:	74 1b                	je     802334 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802319:	79 e7                	jns    802302 <ipc_send+0x1e>
  80231b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80231e:	74 e2                	je     802302 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802320:	83 ec 04             	sub    $0x4,%esp
  802323:	68 5f 2c 80 00       	push   $0x802c5f
  802328:	6a 46                	push   $0x46
  80232a:	68 74 2c 80 00       	push   $0x802c74
  80232f:	e8 b5 de ff ff       	call   8001e9 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802334:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802337:	5b                   	pop    %ebx
  802338:	5e                   	pop    %esi
  802339:	5f                   	pop    %edi
  80233a:	5d                   	pop    %ebp
  80233b:	c3                   	ret    

0080233c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
  80233f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802342:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802347:	89 c2                	mov    %eax,%edx
  802349:	c1 e2 07             	shl    $0x7,%edx
  80234c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802352:	8b 52 50             	mov    0x50(%edx),%edx
  802355:	39 ca                	cmp    %ecx,%edx
  802357:	74 11                	je     80236a <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802359:	83 c0 01             	add    $0x1,%eax
  80235c:	3d 00 04 00 00       	cmp    $0x400,%eax
  802361:	75 e4                	jne    802347 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802363:	b8 00 00 00 00       	mov    $0x0,%eax
  802368:	eb 0b                	jmp    802375 <ipc_find_env+0x39>
			return envs[i].env_id;
  80236a:	c1 e0 07             	shl    $0x7,%eax
  80236d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802372:	8b 40 48             	mov    0x48(%eax),%eax
}
  802375:	5d                   	pop    %ebp
  802376:	c3                   	ret    

00802377 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802377:	55                   	push   %ebp
  802378:	89 e5                	mov    %esp,%ebp
  80237a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80237d:	89 d0                	mov    %edx,%eax
  80237f:	c1 e8 16             	shr    $0x16,%eax
  802382:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802389:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80238e:	f6 c1 01             	test   $0x1,%cl
  802391:	74 1d                	je     8023b0 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802393:	c1 ea 0c             	shr    $0xc,%edx
  802396:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80239d:	f6 c2 01             	test   $0x1,%dl
  8023a0:	74 0e                	je     8023b0 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023a2:	c1 ea 0c             	shr    $0xc,%edx
  8023a5:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023ac:	ef 
  8023ad:	0f b7 c0             	movzwl %ax,%eax
}
  8023b0:	5d                   	pop    %ebp
  8023b1:	c3                   	ret    
  8023b2:	66 90                	xchg   %ax,%ax
  8023b4:	66 90                	xchg   %ax,%ax
  8023b6:	66 90                	xchg   %ax,%ax
  8023b8:	66 90                	xchg   %ax,%ax
  8023ba:	66 90                	xchg   %ax,%ax
  8023bc:	66 90                	xchg   %ax,%ax
  8023be:	66 90                	xchg   %ax,%ax

008023c0 <__udivdi3>:
  8023c0:	55                   	push   %ebp
  8023c1:	57                   	push   %edi
  8023c2:	56                   	push   %esi
  8023c3:	53                   	push   %ebx
  8023c4:	83 ec 1c             	sub    $0x1c,%esp
  8023c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8023cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8023cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8023d7:	85 d2                	test   %edx,%edx
  8023d9:	75 4d                	jne    802428 <__udivdi3+0x68>
  8023db:	39 f3                	cmp    %esi,%ebx
  8023dd:	76 19                	jbe    8023f8 <__udivdi3+0x38>
  8023df:	31 ff                	xor    %edi,%edi
  8023e1:	89 e8                	mov    %ebp,%eax
  8023e3:	89 f2                	mov    %esi,%edx
  8023e5:	f7 f3                	div    %ebx
  8023e7:	89 fa                	mov    %edi,%edx
  8023e9:	83 c4 1c             	add    $0x1c,%esp
  8023ec:	5b                   	pop    %ebx
  8023ed:	5e                   	pop    %esi
  8023ee:	5f                   	pop    %edi
  8023ef:	5d                   	pop    %ebp
  8023f0:	c3                   	ret    
  8023f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023f8:	89 d9                	mov    %ebx,%ecx
  8023fa:	85 db                	test   %ebx,%ebx
  8023fc:	75 0b                	jne    802409 <__udivdi3+0x49>
  8023fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802403:	31 d2                	xor    %edx,%edx
  802405:	f7 f3                	div    %ebx
  802407:	89 c1                	mov    %eax,%ecx
  802409:	31 d2                	xor    %edx,%edx
  80240b:	89 f0                	mov    %esi,%eax
  80240d:	f7 f1                	div    %ecx
  80240f:	89 c6                	mov    %eax,%esi
  802411:	89 e8                	mov    %ebp,%eax
  802413:	89 f7                	mov    %esi,%edi
  802415:	f7 f1                	div    %ecx
  802417:	89 fa                	mov    %edi,%edx
  802419:	83 c4 1c             	add    $0x1c,%esp
  80241c:	5b                   	pop    %ebx
  80241d:	5e                   	pop    %esi
  80241e:	5f                   	pop    %edi
  80241f:	5d                   	pop    %ebp
  802420:	c3                   	ret    
  802421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802428:	39 f2                	cmp    %esi,%edx
  80242a:	77 1c                	ja     802448 <__udivdi3+0x88>
  80242c:	0f bd fa             	bsr    %edx,%edi
  80242f:	83 f7 1f             	xor    $0x1f,%edi
  802432:	75 2c                	jne    802460 <__udivdi3+0xa0>
  802434:	39 f2                	cmp    %esi,%edx
  802436:	72 06                	jb     80243e <__udivdi3+0x7e>
  802438:	31 c0                	xor    %eax,%eax
  80243a:	39 eb                	cmp    %ebp,%ebx
  80243c:	77 a9                	ja     8023e7 <__udivdi3+0x27>
  80243e:	b8 01 00 00 00       	mov    $0x1,%eax
  802443:	eb a2                	jmp    8023e7 <__udivdi3+0x27>
  802445:	8d 76 00             	lea    0x0(%esi),%esi
  802448:	31 ff                	xor    %edi,%edi
  80244a:	31 c0                	xor    %eax,%eax
  80244c:	89 fa                	mov    %edi,%edx
  80244e:	83 c4 1c             	add    $0x1c,%esp
  802451:	5b                   	pop    %ebx
  802452:	5e                   	pop    %esi
  802453:	5f                   	pop    %edi
  802454:	5d                   	pop    %ebp
  802455:	c3                   	ret    
  802456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80245d:	8d 76 00             	lea    0x0(%esi),%esi
  802460:	89 f9                	mov    %edi,%ecx
  802462:	b8 20 00 00 00       	mov    $0x20,%eax
  802467:	29 f8                	sub    %edi,%eax
  802469:	d3 e2                	shl    %cl,%edx
  80246b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80246f:	89 c1                	mov    %eax,%ecx
  802471:	89 da                	mov    %ebx,%edx
  802473:	d3 ea                	shr    %cl,%edx
  802475:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802479:	09 d1                	or     %edx,%ecx
  80247b:	89 f2                	mov    %esi,%edx
  80247d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802481:	89 f9                	mov    %edi,%ecx
  802483:	d3 e3                	shl    %cl,%ebx
  802485:	89 c1                	mov    %eax,%ecx
  802487:	d3 ea                	shr    %cl,%edx
  802489:	89 f9                	mov    %edi,%ecx
  80248b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80248f:	89 eb                	mov    %ebp,%ebx
  802491:	d3 e6                	shl    %cl,%esi
  802493:	89 c1                	mov    %eax,%ecx
  802495:	d3 eb                	shr    %cl,%ebx
  802497:	09 de                	or     %ebx,%esi
  802499:	89 f0                	mov    %esi,%eax
  80249b:	f7 74 24 08          	divl   0x8(%esp)
  80249f:	89 d6                	mov    %edx,%esi
  8024a1:	89 c3                	mov    %eax,%ebx
  8024a3:	f7 64 24 0c          	mull   0xc(%esp)
  8024a7:	39 d6                	cmp    %edx,%esi
  8024a9:	72 15                	jb     8024c0 <__udivdi3+0x100>
  8024ab:	89 f9                	mov    %edi,%ecx
  8024ad:	d3 e5                	shl    %cl,%ebp
  8024af:	39 c5                	cmp    %eax,%ebp
  8024b1:	73 04                	jae    8024b7 <__udivdi3+0xf7>
  8024b3:	39 d6                	cmp    %edx,%esi
  8024b5:	74 09                	je     8024c0 <__udivdi3+0x100>
  8024b7:	89 d8                	mov    %ebx,%eax
  8024b9:	31 ff                	xor    %edi,%edi
  8024bb:	e9 27 ff ff ff       	jmp    8023e7 <__udivdi3+0x27>
  8024c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8024c3:	31 ff                	xor    %edi,%edi
  8024c5:	e9 1d ff ff ff       	jmp    8023e7 <__udivdi3+0x27>
  8024ca:	66 90                	xchg   %ax,%ax
  8024cc:	66 90                	xchg   %ax,%ax
  8024ce:	66 90                	xchg   %ax,%ax

008024d0 <__umoddi3>:
  8024d0:	55                   	push   %ebp
  8024d1:	57                   	push   %edi
  8024d2:	56                   	push   %esi
  8024d3:	53                   	push   %ebx
  8024d4:	83 ec 1c             	sub    $0x1c,%esp
  8024d7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8024db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8024df:	8b 74 24 30          	mov    0x30(%esp),%esi
  8024e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024e7:	89 da                	mov    %ebx,%edx
  8024e9:	85 c0                	test   %eax,%eax
  8024eb:	75 43                	jne    802530 <__umoddi3+0x60>
  8024ed:	39 df                	cmp    %ebx,%edi
  8024ef:	76 17                	jbe    802508 <__umoddi3+0x38>
  8024f1:	89 f0                	mov    %esi,%eax
  8024f3:	f7 f7                	div    %edi
  8024f5:	89 d0                	mov    %edx,%eax
  8024f7:	31 d2                	xor    %edx,%edx
  8024f9:	83 c4 1c             	add    $0x1c,%esp
  8024fc:	5b                   	pop    %ebx
  8024fd:	5e                   	pop    %esi
  8024fe:	5f                   	pop    %edi
  8024ff:	5d                   	pop    %ebp
  802500:	c3                   	ret    
  802501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802508:	89 fd                	mov    %edi,%ebp
  80250a:	85 ff                	test   %edi,%edi
  80250c:	75 0b                	jne    802519 <__umoddi3+0x49>
  80250e:	b8 01 00 00 00       	mov    $0x1,%eax
  802513:	31 d2                	xor    %edx,%edx
  802515:	f7 f7                	div    %edi
  802517:	89 c5                	mov    %eax,%ebp
  802519:	89 d8                	mov    %ebx,%eax
  80251b:	31 d2                	xor    %edx,%edx
  80251d:	f7 f5                	div    %ebp
  80251f:	89 f0                	mov    %esi,%eax
  802521:	f7 f5                	div    %ebp
  802523:	89 d0                	mov    %edx,%eax
  802525:	eb d0                	jmp    8024f7 <__umoddi3+0x27>
  802527:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80252e:	66 90                	xchg   %ax,%ax
  802530:	89 f1                	mov    %esi,%ecx
  802532:	39 d8                	cmp    %ebx,%eax
  802534:	76 0a                	jbe    802540 <__umoddi3+0x70>
  802536:	89 f0                	mov    %esi,%eax
  802538:	83 c4 1c             	add    $0x1c,%esp
  80253b:	5b                   	pop    %ebx
  80253c:	5e                   	pop    %esi
  80253d:	5f                   	pop    %edi
  80253e:	5d                   	pop    %ebp
  80253f:	c3                   	ret    
  802540:	0f bd e8             	bsr    %eax,%ebp
  802543:	83 f5 1f             	xor    $0x1f,%ebp
  802546:	75 20                	jne    802568 <__umoddi3+0x98>
  802548:	39 d8                	cmp    %ebx,%eax
  80254a:	0f 82 b0 00 00 00    	jb     802600 <__umoddi3+0x130>
  802550:	39 f7                	cmp    %esi,%edi
  802552:	0f 86 a8 00 00 00    	jbe    802600 <__umoddi3+0x130>
  802558:	89 c8                	mov    %ecx,%eax
  80255a:	83 c4 1c             	add    $0x1c,%esp
  80255d:	5b                   	pop    %ebx
  80255e:	5e                   	pop    %esi
  80255f:	5f                   	pop    %edi
  802560:	5d                   	pop    %ebp
  802561:	c3                   	ret    
  802562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802568:	89 e9                	mov    %ebp,%ecx
  80256a:	ba 20 00 00 00       	mov    $0x20,%edx
  80256f:	29 ea                	sub    %ebp,%edx
  802571:	d3 e0                	shl    %cl,%eax
  802573:	89 44 24 08          	mov    %eax,0x8(%esp)
  802577:	89 d1                	mov    %edx,%ecx
  802579:	89 f8                	mov    %edi,%eax
  80257b:	d3 e8                	shr    %cl,%eax
  80257d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802581:	89 54 24 04          	mov    %edx,0x4(%esp)
  802585:	8b 54 24 04          	mov    0x4(%esp),%edx
  802589:	09 c1                	or     %eax,%ecx
  80258b:	89 d8                	mov    %ebx,%eax
  80258d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802591:	89 e9                	mov    %ebp,%ecx
  802593:	d3 e7                	shl    %cl,%edi
  802595:	89 d1                	mov    %edx,%ecx
  802597:	d3 e8                	shr    %cl,%eax
  802599:	89 e9                	mov    %ebp,%ecx
  80259b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80259f:	d3 e3                	shl    %cl,%ebx
  8025a1:	89 c7                	mov    %eax,%edi
  8025a3:	89 d1                	mov    %edx,%ecx
  8025a5:	89 f0                	mov    %esi,%eax
  8025a7:	d3 e8                	shr    %cl,%eax
  8025a9:	89 e9                	mov    %ebp,%ecx
  8025ab:	89 fa                	mov    %edi,%edx
  8025ad:	d3 e6                	shl    %cl,%esi
  8025af:	09 d8                	or     %ebx,%eax
  8025b1:	f7 74 24 08          	divl   0x8(%esp)
  8025b5:	89 d1                	mov    %edx,%ecx
  8025b7:	89 f3                	mov    %esi,%ebx
  8025b9:	f7 64 24 0c          	mull   0xc(%esp)
  8025bd:	89 c6                	mov    %eax,%esi
  8025bf:	89 d7                	mov    %edx,%edi
  8025c1:	39 d1                	cmp    %edx,%ecx
  8025c3:	72 06                	jb     8025cb <__umoddi3+0xfb>
  8025c5:	75 10                	jne    8025d7 <__umoddi3+0x107>
  8025c7:	39 c3                	cmp    %eax,%ebx
  8025c9:	73 0c                	jae    8025d7 <__umoddi3+0x107>
  8025cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8025cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8025d3:	89 d7                	mov    %edx,%edi
  8025d5:	89 c6                	mov    %eax,%esi
  8025d7:	89 ca                	mov    %ecx,%edx
  8025d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025de:	29 f3                	sub    %esi,%ebx
  8025e0:	19 fa                	sbb    %edi,%edx
  8025e2:	89 d0                	mov    %edx,%eax
  8025e4:	d3 e0                	shl    %cl,%eax
  8025e6:	89 e9                	mov    %ebp,%ecx
  8025e8:	d3 eb                	shr    %cl,%ebx
  8025ea:	d3 ea                	shr    %cl,%edx
  8025ec:	09 d8                	or     %ebx,%eax
  8025ee:	83 c4 1c             	add    $0x1c,%esp
  8025f1:	5b                   	pop    %ebx
  8025f2:	5e                   	pop    %esi
  8025f3:	5f                   	pop    %edi
  8025f4:	5d                   	pop    %ebp
  8025f5:	c3                   	ret    
  8025f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025fd:	8d 76 00             	lea    0x0(%esi),%esi
  802600:	89 da                	mov    %ebx,%edx
  802602:	29 fe                	sub    %edi,%esi
  802604:	19 c2                	sbb    %eax,%edx
  802606:	89 f1                	mov    %esi,%ecx
  802608:	89 c8                	mov    %ecx,%eax
  80260a:	e9 4b ff ff ff       	jmp    80255a <__umoddi3+0x8a>
