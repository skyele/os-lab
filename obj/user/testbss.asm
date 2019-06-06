
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
  800039:	68 00 26 80 00       	push   $0x802600
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
  800090:	68 48 26 80 00       	push   $0x802648
  800095:	e8 45 02 00 00       	call   8002df <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  80009a:	c7 05 20 50 c0 00 00 	movl   $0x0,0xc05020
  8000a1:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  8000a4:	83 c4 0c             	add    $0xc,%esp
  8000a7:	68 a7 26 80 00       	push   $0x8026a7
  8000ac:	6a 1a                	push   $0x1a
  8000ae:	68 98 26 80 00       	push   $0x802698
  8000b3:	e8 31 01 00 00       	call   8001e9 <_panic>
			panic("bigarray[%d] isn't cleared!\n", i);
  8000b8:	50                   	push   %eax
  8000b9:	68 7b 26 80 00       	push   $0x80267b
  8000be:	6a 11                	push   $0x11
  8000c0:	68 98 26 80 00       	push   $0x802698
  8000c5:	e8 1f 01 00 00       	call   8001e9 <_panic>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000ca:	50                   	push   %eax
  8000cb:	68 20 26 80 00       	push   $0x802620
  8000d0:	6a 16                	push   $0x16
  8000d2:	68 98 26 80 00       	push   $0x802698
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
  80015f:	68 be 26 80 00       	push   $0x8026be
  800164:	e8 76 01 00 00       	call   8002df <cprintf>
	cprintf("before umain\n");
  800169:	c7 04 24 dc 26 80 00 	movl   $0x8026dc,(%esp)
  800170:	e8 6a 01 00 00       	call   8002df <cprintf>
	// call user main routine
	umain(argc, argv);
  800175:	83 c4 08             	add    $0x8,%esp
  800178:	ff 75 0c             	pushl  0xc(%ebp)
  80017b:	ff 75 08             	pushl  0x8(%ebp)
  80017e:	e8 b0 fe ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800183:	c7 04 24 ea 26 80 00 	movl   $0x8026ea,(%esp)
  80018a:	e8 50 01 00 00       	call   8002df <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80018f:	a1 20 40 c0 00       	mov    0xc04020,%eax
  800194:	8b 40 48             	mov    0x48(%eax),%eax
  800197:	83 c4 08             	add    $0x8,%esp
  80019a:	50                   	push   %eax
  80019b:	68 f7 26 80 00       	push   $0x8026f7
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
  8001c3:	68 24 27 80 00       	push   $0x802724
  8001c8:	50                   	push   %eax
  8001c9:	68 16 27 80 00       	push   $0x802716
  8001ce:	e8 0c 01 00 00       	call   8002df <cprintf>
	close_all();
  8001d3:	e8 05 11 00 00       	call   8012dd <close_all>
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
  8001f9:	68 50 27 80 00       	push   $0x802750
  8001fe:	50                   	push   %eax
  8001ff:	68 16 27 80 00       	push   $0x802716
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
  800222:	68 2c 27 80 00       	push   $0x80272c
  800227:	e8 b3 00 00 00       	call   8002df <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80022c:	83 c4 18             	add    $0x18,%esp
  80022f:	53                   	push   %ebx
  800230:	ff 75 10             	pushl  0x10(%ebp)
  800233:	e8 56 00 00 00       	call   80028e <vcprintf>
	cprintf("\n");
  800238:	c7 04 24 96 26 80 00 	movl   $0x802696,(%esp)
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
  80038c:	e8 0f 20 00 00       	call   8023a0 <__udivdi3>
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
  8003b5:	e8 f6 20 00 00       	call   8024b0 <__umoddi3>
  8003ba:	83 c4 14             	add    $0x14,%esp
  8003bd:	0f be 80 57 27 80 00 	movsbl 0x802757(%eax),%eax
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
  800466:	ff 24 85 40 29 80 00 	jmp    *0x802940(,%eax,4)
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
  800531:	8b 14 85 a0 2a 80 00 	mov    0x802aa0(,%eax,4),%edx
  800538:	85 d2                	test   %edx,%edx
  80053a:	74 18                	je     800554 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80053c:	52                   	push   %edx
  80053d:	68 c1 2b 80 00       	push   $0x802bc1
  800542:	53                   	push   %ebx
  800543:	56                   	push   %esi
  800544:	e8 a6 fe ff ff       	call   8003ef <printfmt>
  800549:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80054c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80054f:	e9 fe 02 00 00       	jmp    800852 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800554:	50                   	push   %eax
  800555:	68 6f 27 80 00       	push   $0x80276f
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
  80057c:	b8 68 27 80 00       	mov    $0x802768,%eax
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
  800914:	bf 8d 28 80 00       	mov    $0x80288d,%edi
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
  800940:	bf c5 28 80 00       	mov    $0x8028c5,%edi
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
  800de1:	68 e8 2a 80 00       	push   $0x802ae8
  800de6:	6a 43                	push   $0x43
  800de8:	68 05 2b 80 00       	push   $0x802b05
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
  800e62:	68 e8 2a 80 00       	push   $0x802ae8
  800e67:	6a 43                	push   $0x43
  800e69:	68 05 2b 80 00       	push   $0x802b05
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
  800ea4:	68 e8 2a 80 00       	push   $0x802ae8
  800ea9:	6a 43                	push   $0x43
  800eab:	68 05 2b 80 00       	push   $0x802b05
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
  800ee6:	68 e8 2a 80 00       	push   $0x802ae8
  800eeb:	6a 43                	push   $0x43
  800eed:	68 05 2b 80 00       	push   $0x802b05
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
  800f28:	68 e8 2a 80 00       	push   $0x802ae8
  800f2d:	6a 43                	push   $0x43
  800f2f:	68 05 2b 80 00       	push   $0x802b05
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
  800f6a:	68 e8 2a 80 00       	push   $0x802ae8
  800f6f:	6a 43                	push   $0x43
  800f71:	68 05 2b 80 00       	push   $0x802b05
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
  800fac:	68 e8 2a 80 00       	push   $0x802ae8
  800fb1:	6a 43                	push   $0x43
  800fb3:	68 05 2b 80 00       	push   $0x802b05
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
  801010:	68 e8 2a 80 00       	push   $0x802ae8
  801015:	6a 43                	push   $0x43
  801017:	68 05 2b 80 00       	push   $0x802b05
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
  8010f4:	68 e8 2a 80 00       	push   $0x802ae8
  8010f9:	6a 43                	push   $0x43
  8010fb:	68 05 2b 80 00       	push   $0x802b05
  801100:	e8 e4 f0 ff ff       	call   8001e9 <_panic>

00801105 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	05 00 00 00 30       	add    $0x30000000,%eax
  801110:	c1 e8 0c             	shr    $0xc,%eax
}
  801113:	5d                   	pop    %ebp
  801114:	c3                   	ret    

00801115 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801120:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801125:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80112a:	5d                   	pop    %ebp
  80112b:	c3                   	ret    

0080112c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80112c:	55                   	push   %ebp
  80112d:	89 e5                	mov    %esp,%ebp
  80112f:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801134:	89 c2                	mov    %eax,%edx
  801136:	c1 ea 16             	shr    $0x16,%edx
  801139:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801140:	f6 c2 01             	test   $0x1,%dl
  801143:	74 2d                	je     801172 <fd_alloc+0x46>
  801145:	89 c2                	mov    %eax,%edx
  801147:	c1 ea 0c             	shr    $0xc,%edx
  80114a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801151:	f6 c2 01             	test   $0x1,%dl
  801154:	74 1c                	je     801172 <fd_alloc+0x46>
  801156:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80115b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801160:	75 d2                	jne    801134 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
  801165:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80116b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801170:	eb 0a                	jmp    80117c <fd_alloc+0x50>
			*fd_store = fd;
  801172:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801175:	89 01                	mov    %eax,(%ecx)
			return 0;
  801177:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80117c:	5d                   	pop    %ebp
  80117d:	c3                   	ret    

0080117e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80117e:	55                   	push   %ebp
  80117f:	89 e5                	mov    %esp,%ebp
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801184:	83 f8 1f             	cmp    $0x1f,%eax
  801187:	77 30                	ja     8011b9 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801189:	c1 e0 0c             	shl    $0xc,%eax
  80118c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801191:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801197:	f6 c2 01             	test   $0x1,%dl
  80119a:	74 24                	je     8011c0 <fd_lookup+0x42>
  80119c:	89 c2                	mov    %eax,%edx
  80119e:	c1 ea 0c             	shr    $0xc,%edx
  8011a1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011a8:	f6 c2 01             	test   $0x1,%dl
  8011ab:	74 1a                	je     8011c7 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011b0:	89 02                	mov    %eax,(%edx)
	return 0;
  8011b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011b7:	5d                   	pop    %ebp
  8011b8:	c3                   	ret    
		return -E_INVAL;
  8011b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011be:	eb f7                	jmp    8011b7 <fd_lookup+0x39>
		return -E_INVAL;
  8011c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011c5:	eb f0                	jmp    8011b7 <fd_lookup+0x39>
  8011c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011cc:	eb e9                	jmp    8011b7 <fd_lookup+0x39>

008011ce <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011ce:	55                   	push   %ebp
  8011cf:	89 e5                	mov    %esp,%ebp
  8011d1:	83 ec 08             	sub    $0x8,%esp
  8011d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8011d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8011dc:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011e1:	39 08                	cmp    %ecx,(%eax)
  8011e3:	74 38                	je     80121d <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8011e5:	83 c2 01             	add    $0x1,%edx
  8011e8:	8b 04 95 94 2b 80 00 	mov    0x802b94(,%edx,4),%eax
  8011ef:	85 c0                	test   %eax,%eax
  8011f1:	75 ee                	jne    8011e1 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011f3:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8011f8:	8b 40 48             	mov    0x48(%eax),%eax
  8011fb:	83 ec 04             	sub    $0x4,%esp
  8011fe:	51                   	push   %ecx
  8011ff:	50                   	push   %eax
  801200:	68 14 2b 80 00       	push   $0x802b14
  801205:	e8 d5 f0 ff ff       	call   8002df <cprintf>
	*dev = 0;
  80120a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801213:	83 c4 10             	add    $0x10,%esp
  801216:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80121b:	c9                   	leave  
  80121c:	c3                   	ret    
			*dev = devtab[i];
  80121d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801220:	89 01                	mov    %eax,(%ecx)
			return 0;
  801222:	b8 00 00 00 00       	mov    $0x0,%eax
  801227:	eb f2                	jmp    80121b <dev_lookup+0x4d>

00801229 <fd_close>:
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	57                   	push   %edi
  80122d:	56                   	push   %esi
  80122e:	53                   	push   %ebx
  80122f:	83 ec 24             	sub    $0x24,%esp
  801232:	8b 75 08             	mov    0x8(%ebp),%esi
  801235:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801238:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80123b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80123c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801242:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801245:	50                   	push   %eax
  801246:	e8 33 ff ff ff       	call   80117e <fd_lookup>
  80124b:	89 c3                	mov    %eax,%ebx
  80124d:	83 c4 10             	add    $0x10,%esp
  801250:	85 c0                	test   %eax,%eax
  801252:	78 05                	js     801259 <fd_close+0x30>
	    || fd != fd2)
  801254:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801257:	74 16                	je     80126f <fd_close+0x46>
		return (must_exist ? r : 0);
  801259:	89 f8                	mov    %edi,%eax
  80125b:	84 c0                	test   %al,%al
  80125d:	b8 00 00 00 00       	mov    $0x0,%eax
  801262:	0f 44 d8             	cmove  %eax,%ebx
}
  801265:	89 d8                	mov    %ebx,%eax
  801267:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80126a:	5b                   	pop    %ebx
  80126b:	5e                   	pop    %esi
  80126c:	5f                   	pop    %edi
  80126d:	5d                   	pop    %ebp
  80126e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80126f:	83 ec 08             	sub    $0x8,%esp
  801272:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801275:	50                   	push   %eax
  801276:	ff 36                	pushl  (%esi)
  801278:	e8 51 ff ff ff       	call   8011ce <dev_lookup>
  80127d:	89 c3                	mov    %eax,%ebx
  80127f:	83 c4 10             	add    $0x10,%esp
  801282:	85 c0                	test   %eax,%eax
  801284:	78 1a                	js     8012a0 <fd_close+0x77>
		if (dev->dev_close)
  801286:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801289:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80128c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801291:	85 c0                	test   %eax,%eax
  801293:	74 0b                	je     8012a0 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801295:	83 ec 0c             	sub    $0xc,%esp
  801298:	56                   	push   %esi
  801299:	ff d0                	call   *%eax
  80129b:	89 c3                	mov    %eax,%ebx
  80129d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012a0:	83 ec 08             	sub    $0x8,%esp
  8012a3:	56                   	push   %esi
  8012a4:	6a 00                	push   $0x0
  8012a6:	e8 0a fc ff ff       	call   800eb5 <sys_page_unmap>
	return r;
  8012ab:	83 c4 10             	add    $0x10,%esp
  8012ae:	eb b5                	jmp    801265 <fd_close+0x3c>

008012b0 <close>:

int
close(int fdnum)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
  8012b3:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012b9:	50                   	push   %eax
  8012ba:	ff 75 08             	pushl  0x8(%ebp)
  8012bd:	e8 bc fe ff ff       	call   80117e <fd_lookup>
  8012c2:	83 c4 10             	add    $0x10,%esp
  8012c5:	85 c0                	test   %eax,%eax
  8012c7:	79 02                	jns    8012cb <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8012c9:	c9                   	leave  
  8012ca:	c3                   	ret    
		return fd_close(fd, 1);
  8012cb:	83 ec 08             	sub    $0x8,%esp
  8012ce:	6a 01                	push   $0x1
  8012d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8012d3:	e8 51 ff ff ff       	call   801229 <fd_close>
  8012d8:	83 c4 10             	add    $0x10,%esp
  8012db:	eb ec                	jmp    8012c9 <close+0x19>

008012dd <close_all>:

void
close_all(void)
{
  8012dd:	55                   	push   %ebp
  8012de:	89 e5                	mov    %esp,%ebp
  8012e0:	53                   	push   %ebx
  8012e1:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012e4:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012e9:	83 ec 0c             	sub    $0xc,%esp
  8012ec:	53                   	push   %ebx
  8012ed:	e8 be ff ff ff       	call   8012b0 <close>
	for (i = 0; i < MAXFD; i++)
  8012f2:	83 c3 01             	add    $0x1,%ebx
  8012f5:	83 c4 10             	add    $0x10,%esp
  8012f8:	83 fb 20             	cmp    $0x20,%ebx
  8012fb:	75 ec                	jne    8012e9 <close_all+0xc>
}
  8012fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801300:	c9                   	leave  
  801301:	c3                   	ret    

00801302 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801302:	55                   	push   %ebp
  801303:	89 e5                	mov    %esp,%ebp
  801305:	57                   	push   %edi
  801306:	56                   	push   %esi
  801307:	53                   	push   %ebx
  801308:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80130b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80130e:	50                   	push   %eax
  80130f:	ff 75 08             	pushl  0x8(%ebp)
  801312:	e8 67 fe ff ff       	call   80117e <fd_lookup>
  801317:	89 c3                	mov    %eax,%ebx
  801319:	83 c4 10             	add    $0x10,%esp
  80131c:	85 c0                	test   %eax,%eax
  80131e:	0f 88 81 00 00 00    	js     8013a5 <dup+0xa3>
		return r;
	close(newfdnum);
  801324:	83 ec 0c             	sub    $0xc,%esp
  801327:	ff 75 0c             	pushl  0xc(%ebp)
  80132a:	e8 81 ff ff ff       	call   8012b0 <close>

	newfd = INDEX2FD(newfdnum);
  80132f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801332:	c1 e6 0c             	shl    $0xc,%esi
  801335:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80133b:	83 c4 04             	add    $0x4,%esp
  80133e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801341:	e8 cf fd ff ff       	call   801115 <fd2data>
  801346:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801348:	89 34 24             	mov    %esi,(%esp)
  80134b:	e8 c5 fd ff ff       	call   801115 <fd2data>
  801350:	83 c4 10             	add    $0x10,%esp
  801353:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801355:	89 d8                	mov    %ebx,%eax
  801357:	c1 e8 16             	shr    $0x16,%eax
  80135a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801361:	a8 01                	test   $0x1,%al
  801363:	74 11                	je     801376 <dup+0x74>
  801365:	89 d8                	mov    %ebx,%eax
  801367:	c1 e8 0c             	shr    $0xc,%eax
  80136a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801371:	f6 c2 01             	test   $0x1,%dl
  801374:	75 39                	jne    8013af <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801376:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801379:	89 d0                	mov    %edx,%eax
  80137b:	c1 e8 0c             	shr    $0xc,%eax
  80137e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801385:	83 ec 0c             	sub    $0xc,%esp
  801388:	25 07 0e 00 00       	and    $0xe07,%eax
  80138d:	50                   	push   %eax
  80138e:	56                   	push   %esi
  80138f:	6a 00                	push   $0x0
  801391:	52                   	push   %edx
  801392:	6a 00                	push   $0x0
  801394:	e8 da fa ff ff       	call   800e73 <sys_page_map>
  801399:	89 c3                	mov    %eax,%ebx
  80139b:	83 c4 20             	add    $0x20,%esp
  80139e:	85 c0                	test   %eax,%eax
  8013a0:	78 31                	js     8013d3 <dup+0xd1>
		goto err;

	return newfdnum;
  8013a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013a5:	89 d8                	mov    %ebx,%eax
  8013a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013aa:	5b                   	pop    %ebx
  8013ab:	5e                   	pop    %esi
  8013ac:	5f                   	pop    %edi
  8013ad:	5d                   	pop    %ebp
  8013ae:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013af:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013b6:	83 ec 0c             	sub    $0xc,%esp
  8013b9:	25 07 0e 00 00       	and    $0xe07,%eax
  8013be:	50                   	push   %eax
  8013bf:	57                   	push   %edi
  8013c0:	6a 00                	push   $0x0
  8013c2:	53                   	push   %ebx
  8013c3:	6a 00                	push   $0x0
  8013c5:	e8 a9 fa ff ff       	call   800e73 <sys_page_map>
  8013ca:	89 c3                	mov    %eax,%ebx
  8013cc:	83 c4 20             	add    $0x20,%esp
  8013cf:	85 c0                	test   %eax,%eax
  8013d1:	79 a3                	jns    801376 <dup+0x74>
	sys_page_unmap(0, newfd);
  8013d3:	83 ec 08             	sub    $0x8,%esp
  8013d6:	56                   	push   %esi
  8013d7:	6a 00                	push   $0x0
  8013d9:	e8 d7 fa ff ff       	call   800eb5 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013de:	83 c4 08             	add    $0x8,%esp
  8013e1:	57                   	push   %edi
  8013e2:	6a 00                	push   $0x0
  8013e4:	e8 cc fa ff ff       	call   800eb5 <sys_page_unmap>
	return r;
  8013e9:	83 c4 10             	add    $0x10,%esp
  8013ec:	eb b7                	jmp    8013a5 <dup+0xa3>

008013ee <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
  8013f1:	53                   	push   %ebx
  8013f2:	83 ec 1c             	sub    $0x1c,%esp
  8013f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013fb:	50                   	push   %eax
  8013fc:	53                   	push   %ebx
  8013fd:	e8 7c fd ff ff       	call   80117e <fd_lookup>
  801402:	83 c4 10             	add    $0x10,%esp
  801405:	85 c0                	test   %eax,%eax
  801407:	78 3f                	js     801448 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801409:	83 ec 08             	sub    $0x8,%esp
  80140c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80140f:	50                   	push   %eax
  801410:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801413:	ff 30                	pushl  (%eax)
  801415:	e8 b4 fd ff ff       	call   8011ce <dev_lookup>
  80141a:	83 c4 10             	add    $0x10,%esp
  80141d:	85 c0                	test   %eax,%eax
  80141f:	78 27                	js     801448 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801421:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801424:	8b 42 08             	mov    0x8(%edx),%eax
  801427:	83 e0 03             	and    $0x3,%eax
  80142a:	83 f8 01             	cmp    $0x1,%eax
  80142d:	74 1e                	je     80144d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80142f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801432:	8b 40 08             	mov    0x8(%eax),%eax
  801435:	85 c0                	test   %eax,%eax
  801437:	74 35                	je     80146e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801439:	83 ec 04             	sub    $0x4,%esp
  80143c:	ff 75 10             	pushl  0x10(%ebp)
  80143f:	ff 75 0c             	pushl  0xc(%ebp)
  801442:	52                   	push   %edx
  801443:	ff d0                	call   *%eax
  801445:	83 c4 10             	add    $0x10,%esp
}
  801448:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80144b:	c9                   	leave  
  80144c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80144d:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801452:	8b 40 48             	mov    0x48(%eax),%eax
  801455:	83 ec 04             	sub    $0x4,%esp
  801458:	53                   	push   %ebx
  801459:	50                   	push   %eax
  80145a:	68 58 2b 80 00       	push   $0x802b58
  80145f:	e8 7b ee ff ff       	call   8002df <cprintf>
		return -E_INVAL;
  801464:	83 c4 10             	add    $0x10,%esp
  801467:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80146c:	eb da                	jmp    801448 <read+0x5a>
		return -E_NOT_SUPP;
  80146e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801473:	eb d3                	jmp    801448 <read+0x5a>

00801475 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
  801478:	57                   	push   %edi
  801479:	56                   	push   %esi
  80147a:	53                   	push   %ebx
  80147b:	83 ec 0c             	sub    $0xc,%esp
  80147e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801481:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801484:	bb 00 00 00 00       	mov    $0x0,%ebx
  801489:	39 f3                	cmp    %esi,%ebx
  80148b:	73 23                	jae    8014b0 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80148d:	83 ec 04             	sub    $0x4,%esp
  801490:	89 f0                	mov    %esi,%eax
  801492:	29 d8                	sub    %ebx,%eax
  801494:	50                   	push   %eax
  801495:	89 d8                	mov    %ebx,%eax
  801497:	03 45 0c             	add    0xc(%ebp),%eax
  80149a:	50                   	push   %eax
  80149b:	57                   	push   %edi
  80149c:	e8 4d ff ff ff       	call   8013ee <read>
		if (m < 0)
  8014a1:	83 c4 10             	add    $0x10,%esp
  8014a4:	85 c0                	test   %eax,%eax
  8014a6:	78 06                	js     8014ae <readn+0x39>
			return m;
		if (m == 0)
  8014a8:	74 06                	je     8014b0 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8014aa:	01 c3                	add    %eax,%ebx
  8014ac:	eb db                	jmp    801489 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014ae:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014b0:	89 d8                	mov    %ebx,%eax
  8014b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014b5:	5b                   	pop    %ebx
  8014b6:	5e                   	pop    %esi
  8014b7:	5f                   	pop    %edi
  8014b8:	5d                   	pop    %ebp
  8014b9:	c3                   	ret    

008014ba <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
  8014bd:	53                   	push   %ebx
  8014be:	83 ec 1c             	sub    $0x1c,%esp
  8014c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014c7:	50                   	push   %eax
  8014c8:	53                   	push   %ebx
  8014c9:	e8 b0 fc ff ff       	call   80117e <fd_lookup>
  8014ce:	83 c4 10             	add    $0x10,%esp
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	78 3a                	js     80150f <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014d5:	83 ec 08             	sub    $0x8,%esp
  8014d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014db:	50                   	push   %eax
  8014dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014df:	ff 30                	pushl  (%eax)
  8014e1:	e8 e8 fc ff ff       	call   8011ce <dev_lookup>
  8014e6:	83 c4 10             	add    $0x10,%esp
  8014e9:	85 c0                	test   %eax,%eax
  8014eb:	78 22                	js     80150f <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014f4:	74 1e                	je     801514 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f9:	8b 52 0c             	mov    0xc(%edx),%edx
  8014fc:	85 d2                	test   %edx,%edx
  8014fe:	74 35                	je     801535 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801500:	83 ec 04             	sub    $0x4,%esp
  801503:	ff 75 10             	pushl  0x10(%ebp)
  801506:	ff 75 0c             	pushl  0xc(%ebp)
  801509:	50                   	push   %eax
  80150a:	ff d2                	call   *%edx
  80150c:	83 c4 10             	add    $0x10,%esp
}
  80150f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801512:	c9                   	leave  
  801513:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801514:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801519:	8b 40 48             	mov    0x48(%eax),%eax
  80151c:	83 ec 04             	sub    $0x4,%esp
  80151f:	53                   	push   %ebx
  801520:	50                   	push   %eax
  801521:	68 74 2b 80 00       	push   $0x802b74
  801526:	e8 b4 ed ff ff       	call   8002df <cprintf>
		return -E_INVAL;
  80152b:	83 c4 10             	add    $0x10,%esp
  80152e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801533:	eb da                	jmp    80150f <write+0x55>
		return -E_NOT_SUPP;
  801535:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80153a:	eb d3                	jmp    80150f <write+0x55>

0080153c <seek>:

int
seek(int fdnum, off_t offset)
{
  80153c:	55                   	push   %ebp
  80153d:	89 e5                	mov    %esp,%ebp
  80153f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801542:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801545:	50                   	push   %eax
  801546:	ff 75 08             	pushl  0x8(%ebp)
  801549:	e8 30 fc ff ff       	call   80117e <fd_lookup>
  80154e:	83 c4 10             	add    $0x10,%esp
  801551:	85 c0                	test   %eax,%eax
  801553:	78 0e                	js     801563 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801555:	8b 55 0c             	mov    0xc(%ebp),%edx
  801558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80155e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801563:	c9                   	leave  
  801564:	c3                   	ret    

00801565 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
  801568:	53                   	push   %ebx
  801569:	83 ec 1c             	sub    $0x1c,%esp
  80156c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80156f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801572:	50                   	push   %eax
  801573:	53                   	push   %ebx
  801574:	e8 05 fc ff ff       	call   80117e <fd_lookup>
  801579:	83 c4 10             	add    $0x10,%esp
  80157c:	85 c0                	test   %eax,%eax
  80157e:	78 37                	js     8015b7 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801580:	83 ec 08             	sub    $0x8,%esp
  801583:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801586:	50                   	push   %eax
  801587:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158a:	ff 30                	pushl  (%eax)
  80158c:	e8 3d fc ff ff       	call   8011ce <dev_lookup>
  801591:	83 c4 10             	add    $0x10,%esp
  801594:	85 c0                	test   %eax,%eax
  801596:	78 1f                	js     8015b7 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801598:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80159f:	74 1b                	je     8015bc <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015a4:	8b 52 18             	mov    0x18(%edx),%edx
  8015a7:	85 d2                	test   %edx,%edx
  8015a9:	74 32                	je     8015dd <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015ab:	83 ec 08             	sub    $0x8,%esp
  8015ae:	ff 75 0c             	pushl  0xc(%ebp)
  8015b1:	50                   	push   %eax
  8015b2:	ff d2                	call   *%edx
  8015b4:	83 c4 10             	add    $0x10,%esp
}
  8015b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ba:	c9                   	leave  
  8015bb:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015bc:	a1 20 40 c0 00       	mov    0xc04020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015c1:	8b 40 48             	mov    0x48(%eax),%eax
  8015c4:	83 ec 04             	sub    $0x4,%esp
  8015c7:	53                   	push   %ebx
  8015c8:	50                   	push   %eax
  8015c9:	68 34 2b 80 00       	push   $0x802b34
  8015ce:	e8 0c ed ff ff       	call   8002df <cprintf>
		return -E_INVAL;
  8015d3:	83 c4 10             	add    $0x10,%esp
  8015d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015db:	eb da                	jmp    8015b7 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8015dd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015e2:	eb d3                	jmp    8015b7 <ftruncate+0x52>

008015e4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	53                   	push   %ebx
  8015e8:	83 ec 1c             	sub    $0x1c,%esp
  8015eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ee:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015f1:	50                   	push   %eax
  8015f2:	ff 75 08             	pushl  0x8(%ebp)
  8015f5:	e8 84 fb ff ff       	call   80117e <fd_lookup>
  8015fa:	83 c4 10             	add    $0x10,%esp
  8015fd:	85 c0                	test   %eax,%eax
  8015ff:	78 4b                	js     80164c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801601:	83 ec 08             	sub    $0x8,%esp
  801604:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801607:	50                   	push   %eax
  801608:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160b:	ff 30                	pushl  (%eax)
  80160d:	e8 bc fb ff ff       	call   8011ce <dev_lookup>
  801612:	83 c4 10             	add    $0x10,%esp
  801615:	85 c0                	test   %eax,%eax
  801617:	78 33                	js     80164c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801620:	74 2f                	je     801651 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801622:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801625:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80162c:	00 00 00 
	stat->st_isdir = 0;
  80162f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801636:	00 00 00 
	stat->st_dev = dev;
  801639:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80163f:	83 ec 08             	sub    $0x8,%esp
  801642:	53                   	push   %ebx
  801643:	ff 75 f0             	pushl  -0x10(%ebp)
  801646:	ff 50 14             	call   *0x14(%eax)
  801649:	83 c4 10             	add    $0x10,%esp
}
  80164c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80164f:	c9                   	leave  
  801650:	c3                   	ret    
		return -E_NOT_SUPP;
  801651:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801656:	eb f4                	jmp    80164c <fstat+0x68>

00801658 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	56                   	push   %esi
  80165c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80165d:	83 ec 08             	sub    $0x8,%esp
  801660:	6a 00                	push   $0x0
  801662:	ff 75 08             	pushl  0x8(%ebp)
  801665:	e8 22 02 00 00       	call   80188c <open>
  80166a:	89 c3                	mov    %eax,%ebx
  80166c:	83 c4 10             	add    $0x10,%esp
  80166f:	85 c0                	test   %eax,%eax
  801671:	78 1b                	js     80168e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801673:	83 ec 08             	sub    $0x8,%esp
  801676:	ff 75 0c             	pushl  0xc(%ebp)
  801679:	50                   	push   %eax
  80167a:	e8 65 ff ff ff       	call   8015e4 <fstat>
  80167f:	89 c6                	mov    %eax,%esi
	close(fd);
  801681:	89 1c 24             	mov    %ebx,(%esp)
  801684:	e8 27 fc ff ff       	call   8012b0 <close>
	return r;
  801689:	83 c4 10             	add    $0x10,%esp
  80168c:	89 f3                	mov    %esi,%ebx
}
  80168e:	89 d8                	mov    %ebx,%eax
  801690:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801693:	5b                   	pop    %ebx
  801694:	5e                   	pop    %esi
  801695:	5d                   	pop    %ebp
  801696:	c3                   	ret    

00801697 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
  80169a:	56                   	push   %esi
  80169b:	53                   	push   %ebx
  80169c:	89 c6                	mov    %eax,%esi
  80169e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016a0:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016a7:	74 27                	je     8016d0 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016a9:	6a 07                	push   $0x7
  8016ab:	68 00 50 c0 00       	push   $0xc05000
  8016b0:	56                   	push   %esi
  8016b1:	ff 35 00 40 80 00    	pushl  0x804000
  8016b7:	e8 08 0c 00 00       	call   8022c4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016bc:	83 c4 0c             	add    $0xc,%esp
  8016bf:	6a 00                	push   $0x0
  8016c1:	53                   	push   %ebx
  8016c2:	6a 00                	push   $0x0
  8016c4:	e8 92 0b 00 00       	call   80225b <ipc_recv>
}
  8016c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016cc:	5b                   	pop    %ebx
  8016cd:	5e                   	pop    %esi
  8016ce:	5d                   	pop    %ebp
  8016cf:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016d0:	83 ec 0c             	sub    $0xc,%esp
  8016d3:	6a 01                	push   $0x1
  8016d5:	e8 42 0c 00 00       	call   80231c <ipc_find_env>
  8016da:	a3 00 40 80 00       	mov    %eax,0x804000
  8016df:	83 c4 10             	add    $0x10,%esp
  8016e2:	eb c5                	jmp    8016a9 <fsipc+0x12>

008016e4 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
  8016e7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8016f0:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.set_size.req_size = newsize;
  8016f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f8:	a3 04 50 c0 00       	mov    %eax,0xc05004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801702:	b8 02 00 00 00       	mov    $0x2,%eax
  801707:	e8 8b ff ff ff       	call   801697 <fsipc>
}
  80170c:	c9                   	leave  
  80170d:	c3                   	ret    

0080170e <devfile_flush>:
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
  801711:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	8b 40 0c             	mov    0xc(%eax),%eax
  80171a:	a3 00 50 c0 00       	mov    %eax,0xc05000
	return fsipc(FSREQ_FLUSH, NULL);
  80171f:	ba 00 00 00 00       	mov    $0x0,%edx
  801724:	b8 06 00 00 00       	mov    $0x6,%eax
  801729:	e8 69 ff ff ff       	call   801697 <fsipc>
}
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <devfile_stat>:
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	53                   	push   %ebx
  801734:	83 ec 04             	sub    $0x4,%esp
  801737:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80173a:	8b 45 08             	mov    0x8(%ebp),%eax
  80173d:	8b 40 0c             	mov    0xc(%eax),%eax
  801740:	a3 00 50 c0 00       	mov    %eax,0xc05000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801745:	ba 00 00 00 00       	mov    $0x0,%edx
  80174a:	b8 05 00 00 00       	mov    $0x5,%eax
  80174f:	e8 43 ff ff ff       	call   801697 <fsipc>
  801754:	85 c0                	test   %eax,%eax
  801756:	78 2c                	js     801784 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801758:	83 ec 08             	sub    $0x8,%esp
  80175b:	68 00 50 c0 00       	push   $0xc05000
  801760:	53                   	push   %ebx
  801761:	e8 d8 f2 ff ff       	call   800a3e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801766:	a1 80 50 c0 00       	mov    0xc05080,%eax
  80176b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801771:	a1 84 50 c0 00       	mov    0xc05084,%eax
  801776:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80177c:	83 c4 10             	add    $0x10,%esp
  80177f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801784:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801787:	c9                   	leave  
  801788:	c3                   	ret    

00801789 <devfile_write>:
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
  80178c:	53                   	push   %ebx
  80178d:	83 ec 08             	sub    $0x8,%esp
  801790:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801793:	8b 45 08             	mov    0x8(%ebp),%eax
  801796:	8b 40 0c             	mov    0xc(%eax),%eax
  801799:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.write.req_n = n;
  80179e:	89 1d 04 50 c0 00    	mov    %ebx,0xc05004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8017a4:	53                   	push   %ebx
  8017a5:	ff 75 0c             	pushl  0xc(%ebp)
  8017a8:	68 08 50 c0 00       	push   $0xc05008
  8017ad:	e8 7c f4 ff ff       	call   800c2e <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b7:	b8 04 00 00 00       	mov    $0x4,%eax
  8017bc:	e8 d6 fe ff ff       	call   801697 <fsipc>
  8017c1:	83 c4 10             	add    $0x10,%esp
  8017c4:	85 c0                	test   %eax,%eax
  8017c6:	78 0b                	js     8017d3 <devfile_write+0x4a>
	assert(r <= n);
  8017c8:	39 d8                	cmp    %ebx,%eax
  8017ca:	77 0c                	ja     8017d8 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8017cc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017d1:	7f 1e                	jg     8017f1 <devfile_write+0x68>
}
  8017d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    
	assert(r <= n);
  8017d8:	68 a8 2b 80 00       	push   $0x802ba8
  8017dd:	68 af 2b 80 00       	push   $0x802baf
  8017e2:	68 98 00 00 00       	push   $0x98
  8017e7:	68 c4 2b 80 00       	push   $0x802bc4
  8017ec:	e8 f8 e9 ff ff       	call   8001e9 <_panic>
	assert(r <= PGSIZE);
  8017f1:	68 cf 2b 80 00       	push   $0x802bcf
  8017f6:	68 af 2b 80 00       	push   $0x802baf
  8017fb:	68 99 00 00 00       	push   $0x99
  801800:	68 c4 2b 80 00       	push   $0x802bc4
  801805:	e8 df e9 ff ff       	call   8001e9 <_panic>

0080180a <devfile_read>:
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	56                   	push   %esi
  80180e:	53                   	push   %ebx
  80180f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
  801815:	8b 40 0c             	mov    0xc(%eax),%eax
  801818:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.read.req_n = n;
  80181d:	89 35 04 50 c0 00    	mov    %esi,0xc05004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801823:	ba 00 00 00 00       	mov    $0x0,%edx
  801828:	b8 03 00 00 00       	mov    $0x3,%eax
  80182d:	e8 65 fe ff ff       	call   801697 <fsipc>
  801832:	89 c3                	mov    %eax,%ebx
  801834:	85 c0                	test   %eax,%eax
  801836:	78 1f                	js     801857 <devfile_read+0x4d>
	assert(r <= n);
  801838:	39 f0                	cmp    %esi,%eax
  80183a:	77 24                	ja     801860 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80183c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801841:	7f 33                	jg     801876 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801843:	83 ec 04             	sub    $0x4,%esp
  801846:	50                   	push   %eax
  801847:	68 00 50 c0 00       	push   $0xc05000
  80184c:	ff 75 0c             	pushl  0xc(%ebp)
  80184f:	e8 78 f3 ff ff       	call   800bcc <memmove>
	return r;
  801854:	83 c4 10             	add    $0x10,%esp
}
  801857:	89 d8                	mov    %ebx,%eax
  801859:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80185c:	5b                   	pop    %ebx
  80185d:	5e                   	pop    %esi
  80185e:	5d                   	pop    %ebp
  80185f:	c3                   	ret    
	assert(r <= n);
  801860:	68 a8 2b 80 00       	push   $0x802ba8
  801865:	68 af 2b 80 00       	push   $0x802baf
  80186a:	6a 7c                	push   $0x7c
  80186c:	68 c4 2b 80 00       	push   $0x802bc4
  801871:	e8 73 e9 ff ff       	call   8001e9 <_panic>
	assert(r <= PGSIZE);
  801876:	68 cf 2b 80 00       	push   $0x802bcf
  80187b:	68 af 2b 80 00       	push   $0x802baf
  801880:	6a 7d                	push   $0x7d
  801882:	68 c4 2b 80 00       	push   $0x802bc4
  801887:	e8 5d e9 ff ff       	call   8001e9 <_panic>

0080188c <open>:
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	56                   	push   %esi
  801890:	53                   	push   %ebx
  801891:	83 ec 1c             	sub    $0x1c,%esp
  801894:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801897:	56                   	push   %esi
  801898:	e8 68 f1 ff ff       	call   800a05 <strlen>
  80189d:	83 c4 10             	add    $0x10,%esp
  8018a0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018a5:	7f 6c                	jg     801913 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018a7:	83 ec 0c             	sub    $0xc,%esp
  8018aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ad:	50                   	push   %eax
  8018ae:	e8 79 f8 ff ff       	call   80112c <fd_alloc>
  8018b3:	89 c3                	mov    %eax,%ebx
  8018b5:	83 c4 10             	add    $0x10,%esp
  8018b8:	85 c0                	test   %eax,%eax
  8018ba:	78 3c                	js     8018f8 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8018bc:	83 ec 08             	sub    $0x8,%esp
  8018bf:	56                   	push   %esi
  8018c0:	68 00 50 c0 00       	push   $0xc05000
  8018c5:	e8 74 f1 ff ff       	call   800a3e <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cd:	a3 00 54 c0 00       	mov    %eax,0xc05400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8018da:	e8 b8 fd ff ff       	call   801697 <fsipc>
  8018df:	89 c3                	mov    %eax,%ebx
  8018e1:	83 c4 10             	add    $0x10,%esp
  8018e4:	85 c0                	test   %eax,%eax
  8018e6:	78 19                	js     801901 <open+0x75>
	return fd2num(fd);
  8018e8:	83 ec 0c             	sub    $0xc,%esp
  8018eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ee:	e8 12 f8 ff ff       	call   801105 <fd2num>
  8018f3:	89 c3                	mov    %eax,%ebx
  8018f5:	83 c4 10             	add    $0x10,%esp
}
  8018f8:	89 d8                	mov    %ebx,%eax
  8018fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018fd:	5b                   	pop    %ebx
  8018fe:	5e                   	pop    %esi
  8018ff:	5d                   	pop    %ebp
  801900:	c3                   	ret    
		fd_close(fd, 0);
  801901:	83 ec 08             	sub    $0x8,%esp
  801904:	6a 00                	push   $0x0
  801906:	ff 75 f4             	pushl  -0xc(%ebp)
  801909:	e8 1b f9 ff ff       	call   801229 <fd_close>
		return r;
  80190e:	83 c4 10             	add    $0x10,%esp
  801911:	eb e5                	jmp    8018f8 <open+0x6c>
		return -E_BAD_PATH;
  801913:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801918:	eb de                	jmp    8018f8 <open+0x6c>

0080191a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801920:	ba 00 00 00 00       	mov    $0x0,%edx
  801925:	b8 08 00 00 00       	mov    $0x8,%eax
  80192a:	e8 68 fd ff ff       	call   801697 <fsipc>
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801937:	68 db 2b 80 00       	push   $0x802bdb
  80193c:	ff 75 0c             	pushl  0xc(%ebp)
  80193f:	e8 fa f0 ff ff       	call   800a3e <strcpy>
	return 0;
}
  801944:	b8 00 00 00 00       	mov    $0x0,%eax
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <devsock_close>:
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	53                   	push   %ebx
  80194f:	83 ec 10             	sub    $0x10,%esp
  801952:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801955:	53                   	push   %ebx
  801956:	e8 fc 09 00 00       	call   802357 <pageref>
  80195b:	83 c4 10             	add    $0x10,%esp
		return 0;
  80195e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801963:	83 f8 01             	cmp    $0x1,%eax
  801966:	74 07                	je     80196f <devsock_close+0x24>
}
  801968:	89 d0                	mov    %edx,%eax
  80196a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80196d:	c9                   	leave  
  80196e:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80196f:	83 ec 0c             	sub    $0xc,%esp
  801972:	ff 73 0c             	pushl  0xc(%ebx)
  801975:	e8 b9 02 00 00       	call   801c33 <nsipc_close>
  80197a:	89 c2                	mov    %eax,%edx
  80197c:	83 c4 10             	add    $0x10,%esp
  80197f:	eb e7                	jmp    801968 <devsock_close+0x1d>

00801981 <devsock_write>:
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
  801984:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801987:	6a 00                	push   $0x0
  801989:	ff 75 10             	pushl  0x10(%ebp)
  80198c:	ff 75 0c             	pushl  0xc(%ebp)
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	ff 70 0c             	pushl  0xc(%eax)
  801995:	e8 76 03 00 00       	call   801d10 <nsipc_send>
}
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <devsock_read>:
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019a2:	6a 00                	push   $0x0
  8019a4:	ff 75 10             	pushl  0x10(%ebp)
  8019a7:	ff 75 0c             	pushl  0xc(%ebp)
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	ff 70 0c             	pushl  0xc(%eax)
  8019b0:	e8 ef 02 00 00       	call   801ca4 <nsipc_recv>
}
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <fd2sockid>:
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
  8019ba:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8019bd:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8019c0:	52                   	push   %edx
  8019c1:	50                   	push   %eax
  8019c2:	e8 b7 f7 ff ff       	call   80117e <fd_lookup>
  8019c7:	83 c4 10             	add    $0x10,%esp
  8019ca:	85 c0                	test   %eax,%eax
  8019cc:	78 10                	js     8019de <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8019ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d1:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8019d7:	39 08                	cmp    %ecx,(%eax)
  8019d9:	75 05                	jne    8019e0 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8019db:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    
		return -E_NOT_SUPP;
  8019e0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019e5:	eb f7                	jmp    8019de <fd2sockid+0x27>

008019e7 <alloc_sockfd>:
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
  8019ea:	56                   	push   %esi
  8019eb:	53                   	push   %ebx
  8019ec:	83 ec 1c             	sub    $0x1c,%esp
  8019ef:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8019f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019f4:	50                   	push   %eax
  8019f5:	e8 32 f7 ff ff       	call   80112c <fd_alloc>
  8019fa:	89 c3                	mov    %eax,%ebx
  8019fc:	83 c4 10             	add    $0x10,%esp
  8019ff:	85 c0                	test   %eax,%eax
  801a01:	78 43                	js     801a46 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a03:	83 ec 04             	sub    $0x4,%esp
  801a06:	68 07 04 00 00       	push   $0x407
  801a0b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a0e:	6a 00                	push   $0x0
  801a10:	e8 1b f4 ff ff       	call   800e30 <sys_page_alloc>
  801a15:	89 c3                	mov    %eax,%ebx
  801a17:	83 c4 10             	add    $0x10,%esp
  801a1a:	85 c0                	test   %eax,%eax
  801a1c:	78 28                	js     801a46 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a21:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a27:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a2c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a33:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a36:	83 ec 0c             	sub    $0xc,%esp
  801a39:	50                   	push   %eax
  801a3a:	e8 c6 f6 ff ff       	call   801105 <fd2num>
  801a3f:	89 c3                	mov    %eax,%ebx
  801a41:	83 c4 10             	add    $0x10,%esp
  801a44:	eb 0c                	jmp    801a52 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a46:	83 ec 0c             	sub    $0xc,%esp
  801a49:	56                   	push   %esi
  801a4a:	e8 e4 01 00 00       	call   801c33 <nsipc_close>
		return r;
  801a4f:	83 c4 10             	add    $0x10,%esp
}
  801a52:	89 d8                	mov    %ebx,%eax
  801a54:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a57:	5b                   	pop    %ebx
  801a58:	5e                   	pop    %esi
  801a59:	5d                   	pop    %ebp
  801a5a:	c3                   	ret    

00801a5b <accept>:
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
  801a5e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a61:	8b 45 08             	mov    0x8(%ebp),%eax
  801a64:	e8 4e ff ff ff       	call   8019b7 <fd2sockid>
  801a69:	85 c0                	test   %eax,%eax
  801a6b:	78 1b                	js     801a88 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a6d:	83 ec 04             	sub    $0x4,%esp
  801a70:	ff 75 10             	pushl  0x10(%ebp)
  801a73:	ff 75 0c             	pushl  0xc(%ebp)
  801a76:	50                   	push   %eax
  801a77:	e8 0e 01 00 00       	call   801b8a <nsipc_accept>
  801a7c:	83 c4 10             	add    $0x10,%esp
  801a7f:	85 c0                	test   %eax,%eax
  801a81:	78 05                	js     801a88 <accept+0x2d>
	return alloc_sockfd(r);
  801a83:	e8 5f ff ff ff       	call   8019e7 <alloc_sockfd>
}
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <bind>:
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
  801a8d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	e8 1f ff ff ff       	call   8019b7 <fd2sockid>
  801a98:	85 c0                	test   %eax,%eax
  801a9a:	78 12                	js     801aae <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801a9c:	83 ec 04             	sub    $0x4,%esp
  801a9f:	ff 75 10             	pushl  0x10(%ebp)
  801aa2:	ff 75 0c             	pushl  0xc(%ebp)
  801aa5:	50                   	push   %eax
  801aa6:	e8 31 01 00 00       	call   801bdc <nsipc_bind>
  801aab:	83 c4 10             	add    $0x10,%esp
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <shutdown>:
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab9:	e8 f9 fe ff ff       	call   8019b7 <fd2sockid>
  801abe:	85 c0                	test   %eax,%eax
  801ac0:	78 0f                	js     801ad1 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801ac2:	83 ec 08             	sub    $0x8,%esp
  801ac5:	ff 75 0c             	pushl  0xc(%ebp)
  801ac8:	50                   	push   %eax
  801ac9:	e8 43 01 00 00       	call   801c11 <nsipc_shutdown>
  801ace:	83 c4 10             	add    $0x10,%esp
}
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <connect>:
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
  801ad6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	e8 d6 fe ff ff       	call   8019b7 <fd2sockid>
  801ae1:	85 c0                	test   %eax,%eax
  801ae3:	78 12                	js     801af7 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801ae5:	83 ec 04             	sub    $0x4,%esp
  801ae8:	ff 75 10             	pushl  0x10(%ebp)
  801aeb:	ff 75 0c             	pushl  0xc(%ebp)
  801aee:	50                   	push   %eax
  801aef:	e8 59 01 00 00       	call   801c4d <nsipc_connect>
  801af4:	83 c4 10             	add    $0x10,%esp
}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <listen>:
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
  801afc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801aff:	8b 45 08             	mov    0x8(%ebp),%eax
  801b02:	e8 b0 fe ff ff       	call   8019b7 <fd2sockid>
  801b07:	85 c0                	test   %eax,%eax
  801b09:	78 0f                	js     801b1a <listen+0x21>
	return nsipc_listen(r, backlog);
  801b0b:	83 ec 08             	sub    $0x8,%esp
  801b0e:	ff 75 0c             	pushl  0xc(%ebp)
  801b11:	50                   	push   %eax
  801b12:	e8 6b 01 00 00       	call   801c82 <nsipc_listen>
  801b17:	83 c4 10             	add    $0x10,%esp
}
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <socket>:

int
socket(int domain, int type, int protocol)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
  801b1f:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b22:	ff 75 10             	pushl  0x10(%ebp)
  801b25:	ff 75 0c             	pushl  0xc(%ebp)
  801b28:	ff 75 08             	pushl  0x8(%ebp)
  801b2b:	e8 3e 02 00 00       	call   801d6e <nsipc_socket>
  801b30:	83 c4 10             	add    $0x10,%esp
  801b33:	85 c0                	test   %eax,%eax
  801b35:	78 05                	js     801b3c <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801b37:	e8 ab fe ff ff       	call   8019e7 <alloc_sockfd>
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
  801b41:	53                   	push   %ebx
  801b42:	83 ec 04             	sub    $0x4,%esp
  801b45:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b47:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b4e:	74 26                	je     801b76 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b50:	6a 07                	push   $0x7
  801b52:	68 00 60 c0 00       	push   $0xc06000
  801b57:	53                   	push   %ebx
  801b58:	ff 35 04 40 80 00    	pushl  0x804004
  801b5e:	e8 61 07 00 00       	call   8022c4 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b63:	83 c4 0c             	add    $0xc,%esp
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	e8 ea 06 00 00       	call   80225b <ipc_recv>
}
  801b71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b76:	83 ec 0c             	sub    $0xc,%esp
  801b79:	6a 02                	push   $0x2
  801b7b:	e8 9c 07 00 00       	call   80231c <ipc_find_env>
  801b80:	a3 04 40 80 00       	mov    %eax,0x804004
  801b85:	83 c4 10             	add    $0x10,%esp
  801b88:	eb c6                	jmp    801b50 <nsipc+0x12>

00801b8a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
  801b8d:	56                   	push   %esi
  801b8e:	53                   	push   %ebx
  801b8f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b92:	8b 45 08             	mov    0x8(%ebp),%eax
  801b95:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b9a:	8b 06                	mov    (%esi),%eax
  801b9c:	a3 04 60 c0 00       	mov    %eax,0xc06004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ba1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba6:	e8 93 ff ff ff       	call   801b3e <nsipc>
  801bab:	89 c3                	mov    %eax,%ebx
  801bad:	85 c0                	test   %eax,%eax
  801baf:	79 09                	jns    801bba <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801bb1:	89 d8                	mov    %ebx,%eax
  801bb3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bb6:	5b                   	pop    %ebx
  801bb7:	5e                   	pop    %esi
  801bb8:	5d                   	pop    %ebp
  801bb9:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801bba:	83 ec 04             	sub    $0x4,%esp
  801bbd:	ff 35 10 60 c0 00    	pushl  0xc06010
  801bc3:	68 00 60 c0 00       	push   $0xc06000
  801bc8:	ff 75 0c             	pushl  0xc(%ebp)
  801bcb:	e8 fc ef ff ff       	call   800bcc <memmove>
		*addrlen = ret->ret_addrlen;
  801bd0:	a1 10 60 c0 00       	mov    0xc06010,%eax
  801bd5:	89 06                	mov    %eax,(%esi)
  801bd7:	83 c4 10             	add    $0x10,%esp
	return r;
  801bda:	eb d5                	jmp    801bb1 <nsipc_accept+0x27>

00801bdc <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	53                   	push   %ebx
  801be0:	83 ec 08             	sub    $0x8,%esp
  801be3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801be6:	8b 45 08             	mov    0x8(%ebp),%eax
  801be9:	a3 00 60 c0 00       	mov    %eax,0xc06000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801bee:	53                   	push   %ebx
  801bef:	ff 75 0c             	pushl  0xc(%ebp)
  801bf2:	68 04 60 c0 00       	push   $0xc06004
  801bf7:	e8 d0 ef ff ff       	call   800bcc <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801bfc:	89 1d 14 60 c0 00    	mov    %ebx,0xc06014
	return nsipc(NSREQ_BIND);
  801c02:	b8 02 00 00 00       	mov    $0x2,%eax
  801c07:	e8 32 ff ff ff       	call   801b3e <nsipc>
}
  801c0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
  801c14:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c17:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1a:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.shutdown.req_how = how;
  801c1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c22:	a3 04 60 c0 00       	mov    %eax,0xc06004
	return nsipc(NSREQ_SHUTDOWN);
  801c27:	b8 03 00 00 00       	mov    $0x3,%eax
  801c2c:	e8 0d ff ff ff       	call   801b3e <nsipc>
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <nsipc_close>:

int
nsipc_close(int s)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
  801c36:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	a3 00 60 c0 00       	mov    %eax,0xc06000
	return nsipc(NSREQ_CLOSE);
  801c41:	b8 04 00 00 00       	mov    $0x4,%eax
  801c46:	e8 f3 fe ff ff       	call   801b3e <nsipc>
}
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
  801c50:	53                   	push   %ebx
  801c51:	83 ec 08             	sub    $0x8,%esp
  801c54:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c57:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5a:	a3 00 60 c0 00       	mov    %eax,0xc06000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c5f:	53                   	push   %ebx
  801c60:	ff 75 0c             	pushl  0xc(%ebp)
  801c63:	68 04 60 c0 00       	push   $0xc06004
  801c68:	e8 5f ef ff ff       	call   800bcc <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c6d:	89 1d 14 60 c0 00    	mov    %ebx,0xc06014
	return nsipc(NSREQ_CONNECT);
  801c73:	b8 05 00 00 00       	mov    $0x5,%eax
  801c78:	e8 c1 fe ff ff       	call   801b3e <nsipc>
}
  801c7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c88:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8b:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.listen.req_backlog = backlog;
  801c90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c93:	a3 04 60 c0 00       	mov    %eax,0xc06004
	return nsipc(NSREQ_LISTEN);
  801c98:	b8 06 00 00 00       	mov    $0x6,%eax
  801c9d:	e8 9c fe ff ff       	call   801b3e <nsipc>
}
  801ca2:	c9                   	leave  
  801ca3:	c3                   	ret    

00801ca4 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
  801ca7:	56                   	push   %esi
  801ca8:	53                   	push   %ebx
  801ca9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801cac:	8b 45 08             	mov    0x8(%ebp),%eax
  801caf:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.recv.req_len = len;
  801cb4:	89 35 04 60 c0 00    	mov    %esi,0xc06004
	nsipcbuf.recv.req_flags = flags;
  801cba:	8b 45 14             	mov    0x14(%ebp),%eax
  801cbd:	a3 08 60 c0 00       	mov    %eax,0xc06008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801cc2:	b8 07 00 00 00       	mov    $0x7,%eax
  801cc7:	e8 72 fe ff ff       	call   801b3e <nsipc>
  801ccc:	89 c3                	mov    %eax,%ebx
  801cce:	85 c0                	test   %eax,%eax
  801cd0:	78 1f                	js     801cf1 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801cd2:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801cd7:	7f 21                	jg     801cfa <nsipc_recv+0x56>
  801cd9:	39 c6                	cmp    %eax,%esi
  801cdb:	7c 1d                	jl     801cfa <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801cdd:	83 ec 04             	sub    $0x4,%esp
  801ce0:	50                   	push   %eax
  801ce1:	68 00 60 c0 00       	push   $0xc06000
  801ce6:	ff 75 0c             	pushl  0xc(%ebp)
  801ce9:	e8 de ee ff ff       	call   800bcc <memmove>
  801cee:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801cf1:	89 d8                	mov    %ebx,%eax
  801cf3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cf6:	5b                   	pop    %ebx
  801cf7:	5e                   	pop    %esi
  801cf8:	5d                   	pop    %ebp
  801cf9:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801cfa:	68 e7 2b 80 00       	push   $0x802be7
  801cff:	68 af 2b 80 00       	push   $0x802baf
  801d04:	6a 62                	push   $0x62
  801d06:	68 fc 2b 80 00       	push   $0x802bfc
  801d0b:	e8 d9 e4 ff ff       	call   8001e9 <_panic>

00801d10 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
  801d13:	53                   	push   %ebx
  801d14:	83 ec 04             	sub    $0x4,%esp
  801d17:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	a3 00 60 c0 00       	mov    %eax,0xc06000
	assert(size < 1600);
  801d22:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d28:	7f 2e                	jg     801d58 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d2a:	83 ec 04             	sub    $0x4,%esp
  801d2d:	53                   	push   %ebx
  801d2e:	ff 75 0c             	pushl  0xc(%ebp)
  801d31:	68 0c 60 c0 00       	push   $0xc0600c
  801d36:	e8 91 ee ff ff       	call   800bcc <memmove>
	nsipcbuf.send.req_size = size;
  801d3b:	89 1d 04 60 c0 00    	mov    %ebx,0xc06004
	nsipcbuf.send.req_flags = flags;
  801d41:	8b 45 14             	mov    0x14(%ebp),%eax
  801d44:	a3 08 60 c0 00       	mov    %eax,0xc06008
	return nsipc(NSREQ_SEND);
  801d49:	b8 08 00 00 00       	mov    $0x8,%eax
  801d4e:	e8 eb fd ff ff       	call   801b3e <nsipc>
}
  801d53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    
	assert(size < 1600);
  801d58:	68 08 2c 80 00       	push   $0x802c08
  801d5d:	68 af 2b 80 00       	push   $0x802baf
  801d62:	6a 6d                	push   $0x6d
  801d64:	68 fc 2b 80 00       	push   $0x802bfc
  801d69:	e8 7b e4 ff ff       	call   8001e9 <_panic>

00801d6e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
  801d71:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.socket.req_type = type;
  801d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d7f:	a3 04 60 c0 00       	mov    %eax,0xc06004
	nsipcbuf.socket.req_protocol = protocol;
  801d84:	8b 45 10             	mov    0x10(%ebp),%eax
  801d87:	a3 08 60 c0 00       	mov    %eax,0xc06008
	return nsipc(NSREQ_SOCKET);
  801d8c:	b8 09 00 00 00       	mov    $0x9,%eax
  801d91:	e8 a8 fd ff ff       	call   801b3e <nsipc>
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	56                   	push   %esi
  801d9c:	53                   	push   %ebx
  801d9d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801da0:	83 ec 0c             	sub    $0xc,%esp
  801da3:	ff 75 08             	pushl  0x8(%ebp)
  801da6:	e8 6a f3 ff ff       	call   801115 <fd2data>
  801dab:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801dad:	83 c4 08             	add    $0x8,%esp
  801db0:	68 14 2c 80 00       	push   $0x802c14
  801db5:	53                   	push   %ebx
  801db6:	e8 83 ec ff ff       	call   800a3e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801dbb:	8b 46 04             	mov    0x4(%esi),%eax
  801dbe:	2b 06                	sub    (%esi),%eax
  801dc0:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801dc6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801dcd:	00 00 00 
	stat->st_dev = &devpipe;
  801dd0:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801dd7:	30 80 00 
	return 0;
}
  801dda:	b8 00 00 00 00       	mov    $0x0,%eax
  801ddf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de2:	5b                   	pop    %ebx
  801de3:	5e                   	pop    %esi
  801de4:	5d                   	pop    %ebp
  801de5:	c3                   	ret    

00801de6 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	53                   	push   %ebx
  801dea:	83 ec 0c             	sub    $0xc,%esp
  801ded:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801df0:	53                   	push   %ebx
  801df1:	6a 00                	push   $0x0
  801df3:	e8 bd f0 ff ff       	call   800eb5 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801df8:	89 1c 24             	mov    %ebx,(%esp)
  801dfb:	e8 15 f3 ff ff       	call   801115 <fd2data>
  801e00:	83 c4 08             	add    $0x8,%esp
  801e03:	50                   	push   %eax
  801e04:	6a 00                	push   $0x0
  801e06:	e8 aa f0 ff ff       	call   800eb5 <sys_page_unmap>
}
  801e0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <_pipeisclosed>:
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	57                   	push   %edi
  801e14:	56                   	push   %esi
  801e15:	53                   	push   %ebx
  801e16:	83 ec 1c             	sub    $0x1c,%esp
  801e19:	89 c7                	mov    %eax,%edi
  801e1b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e1d:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801e22:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e25:	83 ec 0c             	sub    $0xc,%esp
  801e28:	57                   	push   %edi
  801e29:	e8 29 05 00 00       	call   802357 <pageref>
  801e2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e31:	89 34 24             	mov    %esi,(%esp)
  801e34:	e8 1e 05 00 00       	call   802357 <pageref>
		nn = thisenv->env_runs;
  801e39:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  801e3f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e42:	83 c4 10             	add    $0x10,%esp
  801e45:	39 cb                	cmp    %ecx,%ebx
  801e47:	74 1b                	je     801e64 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e49:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e4c:	75 cf                	jne    801e1d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e4e:	8b 42 58             	mov    0x58(%edx),%eax
  801e51:	6a 01                	push   $0x1
  801e53:	50                   	push   %eax
  801e54:	53                   	push   %ebx
  801e55:	68 1b 2c 80 00       	push   $0x802c1b
  801e5a:	e8 80 e4 ff ff       	call   8002df <cprintf>
  801e5f:	83 c4 10             	add    $0x10,%esp
  801e62:	eb b9                	jmp    801e1d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e64:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e67:	0f 94 c0             	sete   %al
  801e6a:	0f b6 c0             	movzbl %al,%eax
}
  801e6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e70:	5b                   	pop    %ebx
  801e71:	5e                   	pop    %esi
  801e72:	5f                   	pop    %edi
  801e73:	5d                   	pop    %ebp
  801e74:	c3                   	ret    

00801e75 <devpipe_write>:
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
  801e78:	57                   	push   %edi
  801e79:	56                   	push   %esi
  801e7a:	53                   	push   %ebx
  801e7b:	83 ec 28             	sub    $0x28,%esp
  801e7e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e81:	56                   	push   %esi
  801e82:	e8 8e f2 ff ff       	call   801115 <fd2data>
  801e87:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e89:	83 c4 10             	add    $0x10,%esp
  801e8c:	bf 00 00 00 00       	mov    $0x0,%edi
  801e91:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e94:	74 4f                	je     801ee5 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e96:	8b 43 04             	mov    0x4(%ebx),%eax
  801e99:	8b 0b                	mov    (%ebx),%ecx
  801e9b:	8d 51 20             	lea    0x20(%ecx),%edx
  801e9e:	39 d0                	cmp    %edx,%eax
  801ea0:	72 14                	jb     801eb6 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ea2:	89 da                	mov    %ebx,%edx
  801ea4:	89 f0                	mov    %esi,%eax
  801ea6:	e8 65 ff ff ff       	call   801e10 <_pipeisclosed>
  801eab:	85 c0                	test   %eax,%eax
  801ead:	75 3b                	jne    801eea <devpipe_write+0x75>
			sys_yield();
  801eaf:	e8 5d ef ff ff       	call   800e11 <sys_yield>
  801eb4:	eb e0                	jmp    801e96 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801eb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801eb9:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ebd:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ec0:	89 c2                	mov    %eax,%edx
  801ec2:	c1 fa 1f             	sar    $0x1f,%edx
  801ec5:	89 d1                	mov    %edx,%ecx
  801ec7:	c1 e9 1b             	shr    $0x1b,%ecx
  801eca:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ecd:	83 e2 1f             	and    $0x1f,%edx
  801ed0:	29 ca                	sub    %ecx,%edx
  801ed2:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ed6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801eda:	83 c0 01             	add    $0x1,%eax
  801edd:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ee0:	83 c7 01             	add    $0x1,%edi
  801ee3:	eb ac                	jmp    801e91 <devpipe_write+0x1c>
	return i;
  801ee5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee8:	eb 05                	jmp    801eef <devpipe_write+0x7a>
				return 0;
  801eea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ef2:	5b                   	pop    %ebx
  801ef3:	5e                   	pop    %esi
  801ef4:	5f                   	pop    %edi
  801ef5:	5d                   	pop    %ebp
  801ef6:	c3                   	ret    

00801ef7 <devpipe_read>:
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	57                   	push   %edi
  801efb:	56                   	push   %esi
  801efc:	53                   	push   %ebx
  801efd:	83 ec 18             	sub    $0x18,%esp
  801f00:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f03:	57                   	push   %edi
  801f04:	e8 0c f2 ff ff       	call   801115 <fd2data>
  801f09:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f0b:	83 c4 10             	add    $0x10,%esp
  801f0e:	be 00 00 00 00       	mov    $0x0,%esi
  801f13:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f16:	75 14                	jne    801f2c <devpipe_read+0x35>
	return i;
  801f18:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1b:	eb 02                	jmp    801f1f <devpipe_read+0x28>
				return i;
  801f1d:	89 f0                	mov    %esi,%eax
}
  801f1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f22:	5b                   	pop    %ebx
  801f23:	5e                   	pop    %esi
  801f24:	5f                   	pop    %edi
  801f25:	5d                   	pop    %ebp
  801f26:	c3                   	ret    
			sys_yield();
  801f27:	e8 e5 ee ff ff       	call   800e11 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801f2c:	8b 03                	mov    (%ebx),%eax
  801f2e:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f31:	75 18                	jne    801f4b <devpipe_read+0x54>
			if (i > 0)
  801f33:	85 f6                	test   %esi,%esi
  801f35:	75 e6                	jne    801f1d <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801f37:	89 da                	mov    %ebx,%edx
  801f39:	89 f8                	mov    %edi,%eax
  801f3b:	e8 d0 fe ff ff       	call   801e10 <_pipeisclosed>
  801f40:	85 c0                	test   %eax,%eax
  801f42:	74 e3                	je     801f27 <devpipe_read+0x30>
				return 0;
  801f44:	b8 00 00 00 00       	mov    $0x0,%eax
  801f49:	eb d4                	jmp    801f1f <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f4b:	99                   	cltd   
  801f4c:	c1 ea 1b             	shr    $0x1b,%edx
  801f4f:	01 d0                	add    %edx,%eax
  801f51:	83 e0 1f             	and    $0x1f,%eax
  801f54:	29 d0                	sub    %edx,%eax
  801f56:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f5e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f61:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f64:	83 c6 01             	add    $0x1,%esi
  801f67:	eb aa                	jmp    801f13 <devpipe_read+0x1c>

00801f69 <pipe>:
{
  801f69:	55                   	push   %ebp
  801f6a:	89 e5                	mov    %esp,%ebp
  801f6c:	56                   	push   %esi
  801f6d:	53                   	push   %ebx
  801f6e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f71:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f74:	50                   	push   %eax
  801f75:	e8 b2 f1 ff ff       	call   80112c <fd_alloc>
  801f7a:	89 c3                	mov    %eax,%ebx
  801f7c:	83 c4 10             	add    $0x10,%esp
  801f7f:	85 c0                	test   %eax,%eax
  801f81:	0f 88 23 01 00 00    	js     8020aa <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f87:	83 ec 04             	sub    $0x4,%esp
  801f8a:	68 07 04 00 00       	push   $0x407
  801f8f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f92:	6a 00                	push   $0x0
  801f94:	e8 97 ee ff ff       	call   800e30 <sys_page_alloc>
  801f99:	89 c3                	mov    %eax,%ebx
  801f9b:	83 c4 10             	add    $0x10,%esp
  801f9e:	85 c0                	test   %eax,%eax
  801fa0:	0f 88 04 01 00 00    	js     8020aa <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801fa6:	83 ec 0c             	sub    $0xc,%esp
  801fa9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fac:	50                   	push   %eax
  801fad:	e8 7a f1 ff ff       	call   80112c <fd_alloc>
  801fb2:	89 c3                	mov    %eax,%ebx
  801fb4:	83 c4 10             	add    $0x10,%esp
  801fb7:	85 c0                	test   %eax,%eax
  801fb9:	0f 88 db 00 00 00    	js     80209a <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fbf:	83 ec 04             	sub    $0x4,%esp
  801fc2:	68 07 04 00 00       	push   $0x407
  801fc7:	ff 75 f0             	pushl  -0x10(%ebp)
  801fca:	6a 00                	push   $0x0
  801fcc:	e8 5f ee ff ff       	call   800e30 <sys_page_alloc>
  801fd1:	89 c3                	mov    %eax,%ebx
  801fd3:	83 c4 10             	add    $0x10,%esp
  801fd6:	85 c0                	test   %eax,%eax
  801fd8:	0f 88 bc 00 00 00    	js     80209a <pipe+0x131>
	va = fd2data(fd0);
  801fde:	83 ec 0c             	sub    $0xc,%esp
  801fe1:	ff 75 f4             	pushl  -0xc(%ebp)
  801fe4:	e8 2c f1 ff ff       	call   801115 <fd2data>
  801fe9:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801feb:	83 c4 0c             	add    $0xc,%esp
  801fee:	68 07 04 00 00       	push   $0x407
  801ff3:	50                   	push   %eax
  801ff4:	6a 00                	push   $0x0
  801ff6:	e8 35 ee ff ff       	call   800e30 <sys_page_alloc>
  801ffb:	89 c3                	mov    %eax,%ebx
  801ffd:	83 c4 10             	add    $0x10,%esp
  802000:	85 c0                	test   %eax,%eax
  802002:	0f 88 82 00 00 00    	js     80208a <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802008:	83 ec 0c             	sub    $0xc,%esp
  80200b:	ff 75 f0             	pushl  -0x10(%ebp)
  80200e:	e8 02 f1 ff ff       	call   801115 <fd2data>
  802013:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80201a:	50                   	push   %eax
  80201b:	6a 00                	push   $0x0
  80201d:	56                   	push   %esi
  80201e:	6a 00                	push   $0x0
  802020:	e8 4e ee ff ff       	call   800e73 <sys_page_map>
  802025:	89 c3                	mov    %eax,%ebx
  802027:	83 c4 20             	add    $0x20,%esp
  80202a:	85 c0                	test   %eax,%eax
  80202c:	78 4e                	js     80207c <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80202e:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802033:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802036:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802038:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80203b:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802042:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802045:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802047:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802051:	83 ec 0c             	sub    $0xc,%esp
  802054:	ff 75 f4             	pushl  -0xc(%ebp)
  802057:	e8 a9 f0 ff ff       	call   801105 <fd2num>
  80205c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80205f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802061:	83 c4 04             	add    $0x4,%esp
  802064:	ff 75 f0             	pushl  -0x10(%ebp)
  802067:	e8 99 f0 ff ff       	call   801105 <fd2num>
  80206c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80206f:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802072:	83 c4 10             	add    $0x10,%esp
  802075:	bb 00 00 00 00       	mov    $0x0,%ebx
  80207a:	eb 2e                	jmp    8020aa <pipe+0x141>
	sys_page_unmap(0, va);
  80207c:	83 ec 08             	sub    $0x8,%esp
  80207f:	56                   	push   %esi
  802080:	6a 00                	push   $0x0
  802082:	e8 2e ee ff ff       	call   800eb5 <sys_page_unmap>
  802087:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80208a:	83 ec 08             	sub    $0x8,%esp
  80208d:	ff 75 f0             	pushl  -0x10(%ebp)
  802090:	6a 00                	push   $0x0
  802092:	e8 1e ee ff ff       	call   800eb5 <sys_page_unmap>
  802097:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80209a:	83 ec 08             	sub    $0x8,%esp
  80209d:	ff 75 f4             	pushl  -0xc(%ebp)
  8020a0:	6a 00                	push   $0x0
  8020a2:	e8 0e ee ff ff       	call   800eb5 <sys_page_unmap>
  8020a7:	83 c4 10             	add    $0x10,%esp
}
  8020aa:	89 d8                	mov    %ebx,%eax
  8020ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020af:	5b                   	pop    %ebx
  8020b0:	5e                   	pop    %esi
  8020b1:	5d                   	pop    %ebp
  8020b2:	c3                   	ret    

008020b3 <pipeisclosed>:
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020bc:	50                   	push   %eax
  8020bd:	ff 75 08             	pushl  0x8(%ebp)
  8020c0:	e8 b9 f0 ff ff       	call   80117e <fd_lookup>
  8020c5:	83 c4 10             	add    $0x10,%esp
  8020c8:	85 c0                	test   %eax,%eax
  8020ca:	78 18                	js     8020e4 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8020cc:	83 ec 0c             	sub    $0xc,%esp
  8020cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8020d2:	e8 3e f0 ff ff       	call   801115 <fd2data>
	return _pipeisclosed(fd, p);
  8020d7:	89 c2                	mov    %eax,%edx
  8020d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dc:	e8 2f fd ff ff       	call   801e10 <_pipeisclosed>
  8020e1:	83 c4 10             	add    $0x10,%esp
}
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8020e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020eb:	c3                   	ret    

008020ec <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
  8020ef:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8020f2:	68 33 2c 80 00       	push   $0x802c33
  8020f7:	ff 75 0c             	pushl  0xc(%ebp)
  8020fa:	e8 3f e9 ff ff       	call   800a3e <strcpy>
	return 0;
}
  8020ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802104:	c9                   	leave  
  802105:	c3                   	ret    

00802106 <devcons_write>:
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
  802109:	57                   	push   %edi
  80210a:	56                   	push   %esi
  80210b:	53                   	push   %ebx
  80210c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802112:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802117:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80211d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802120:	73 31                	jae    802153 <devcons_write+0x4d>
		m = n - tot;
  802122:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802125:	29 f3                	sub    %esi,%ebx
  802127:	83 fb 7f             	cmp    $0x7f,%ebx
  80212a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80212f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802132:	83 ec 04             	sub    $0x4,%esp
  802135:	53                   	push   %ebx
  802136:	89 f0                	mov    %esi,%eax
  802138:	03 45 0c             	add    0xc(%ebp),%eax
  80213b:	50                   	push   %eax
  80213c:	57                   	push   %edi
  80213d:	e8 8a ea ff ff       	call   800bcc <memmove>
		sys_cputs(buf, m);
  802142:	83 c4 08             	add    $0x8,%esp
  802145:	53                   	push   %ebx
  802146:	57                   	push   %edi
  802147:	e8 28 ec ff ff       	call   800d74 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80214c:	01 de                	add    %ebx,%esi
  80214e:	83 c4 10             	add    $0x10,%esp
  802151:	eb ca                	jmp    80211d <devcons_write+0x17>
}
  802153:	89 f0                	mov    %esi,%eax
  802155:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802158:	5b                   	pop    %ebx
  802159:	5e                   	pop    %esi
  80215a:	5f                   	pop    %edi
  80215b:	5d                   	pop    %ebp
  80215c:	c3                   	ret    

0080215d <devcons_read>:
{
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
  802160:	83 ec 08             	sub    $0x8,%esp
  802163:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802168:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80216c:	74 21                	je     80218f <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80216e:	e8 1f ec ff ff       	call   800d92 <sys_cgetc>
  802173:	85 c0                	test   %eax,%eax
  802175:	75 07                	jne    80217e <devcons_read+0x21>
		sys_yield();
  802177:	e8 95 ec ff ff       	call   800e11 <sys_yield>
  80217c:	eb f0                	jmp    80216e <devcons_read+0x11>
	if (c < 0)
  80217e:	78 0f                	js     80218f <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802180:	83 f8 04             	cmp    $0x4,%eax
  802183:	74 0c                	je     802191 <devcons_read+0x34>
	*(char*)vbuf = c;
  802185:	8b 55 0c             	mov    0xc(%ebp),%edx
  802188:	88 02                	mov    %al,(%edx)
	return 1;
  80218a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80218f:	c9                   	leave  
  802190:	c3                   	ret    
		return 0;
  802191:	b8 00 00 00 00       	mov    $0x0,%eax
  802196:	eb f7                	jmp    80218f <devcons_read+0x32>

00802198 <cputchar>:
{
  802198:	55                   	push   %ebp
  802199:	89 e5                	mov    %esp,%ebp
  80219b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8021a4:	6a 01                	push   $0x1
  8021a6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021a9:	50                   	push   %eax
  8021aa:	e8 c5 eb ff ff       	call   800d74 <sys_cputs>
}
  8021af:	83 c4 10             	add    $0x10,%esp
  8021b2:	c9                   	leave  
  8021b3:	c3                   	ret    

008021b4 <getchar>:
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
  8021b7:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8021ba:	6a 01                	push   $0x1
  8021bc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021bf:	50                   	push   %eax
  8021c0:	6a 00                	push   $0x0
  8021c2:	e8 27 f2 ff ff       	call   8013ee <read>
	if (r < 0)
  8021c7:	83 c4 10             	add    $0x10,%esp
  8021ca:	85 c0                	test   %eax,%eax
  8021cc:	78 06                	js     8021d4 <getchar+0x20>
	if (r < 1)
  8021ce:	74 06                	je     8021d6 <getchar+0x22>
	return c;
  8021d0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8021d4:	c9                   	leave  
  8021d5:	c3                   	ret    
		return -E_EOF;
  8021d6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8021db:	eb f7                	jmp    8021d4 <getchar+0x20>

008021dd <iscons>:
{
  8021dd:	55                   	push   %ebp
  8021de:	89 e5                	mov    %esp,%ebp
  8021e0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021e6:	50                   	push   %eax
  8021e7:	ff 75 08             	pushl  0x8(%ebp)
  8021ea:	e8 8f ef ff ff       	call   80117e <fd_lookup>
  8021ef:	83 c4 10             	add    $0x10,%esp
  8021f2:	85 c0                	test   %eax,%eax
  8021f4:	78 11                	js     802207 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8021f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f9:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021ff:	39 10                	cmp    %edx,(%eax)
  802201:	0f 94 c0             	sete   %al
  802204:	0f b6 c0             	movzbl %al,%eax
}
  802207:	c9                   	leave  
  802208:	c3                   	ret    

00802209 <opencons>:
{
  802209:	55                   	push   %ebp
  80220a:	89 e5                	mov    %esp,%ebp
  80220c:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80220f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802212:	50                   	push   %eax
  802213:	e8 14 ef ff ff       	call   80112c <fd_alloc>
  802218:	83 c4 10             	add    $0x10,%esp
  80221b:	85 c0                	test   %eax,%eax
  80221d:	78 3a                	js     802259 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80221f:	83 ec 04             	sub    $0x4,%esp
  802222:	68 07 04 00 00       	push   $0x407
  802227:	ff 75 f4             	pushl  -0xc(%ebp)
  80222a:	6a 00                	push   $0x0
  80222c:	e8 ff eb ff ff       	call   800e30 <sys_page_alloc>
  802231:	83 c4 10             	add    $0x10,%esp
  802234:	85 c0                	test   %eax,%eax
  802236:	78 21                	js     802259 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802241:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802246:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80224d:	83 ec 0c             	sub    $0xc,%esp
  802250:	50                   	push   %eax
  802251:	e8 af ee ff ff       	call   801105 <fd2num>
  802256:	83 c4 10             	add    $0x10,%esp
}
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
  80225e:	56                   	push   %esi
  80225f:	53                   	push   %ebx
  802260:	8b 75 08             	mov    0x8(%ebp),%esi
  802263:	8b 45 0c             	mov    0xc(%ebp),%eax
  802266:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802269:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80226b:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802270:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802273:	83 ec 0c             	sub    $0xc,%esp
  802276:	50                   	push   %eax
  802277:	e8 64 ed ff ff       	call   800fe0 <sys_ipc_recv>
	if(ret < 0){
  80227c:	83 c4 10             	add    $0x10,%esp
  80227f:	85 c0                	test   %eax,%eax
  802281:	78 2b                	js     8022ae <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802283:	85 f6                	test   %esi,%esi
  802285:	74 0a                	je     802291 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802287:	a1 20 40 c0 00       	mov    0xc04020,%eax
  80228c:	8b 40 74             	mov    0x74(%eax),%eax
  80228f:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802291:	85 db                	test   %ebx,%ebx
  802293:	74 0a                	je     80229f <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802295:	a1 20 40 c0 00       	mov    0xc04020,%eax
  80229a:	8b 40 78             	mov    0x78(%eax),%eax
  80229d:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80229f:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8022a4:	8b 40 70             	mov    0x70(%eax),%eax
}
  8022a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022aa:	5b                   	pop    %ebx
  8022ab:	5e                   	pop    %esi
  8022ac:	5d                   	pop    %ebp
  8022ad:	c3                   	ret    
		if(from_env_store)
  8022ae:	85 f6                	test   %esi,%esi
  8022b0:	74 06                	je     8022b8 <ipc_recv+0x5d>
			*from_env_store = 0;
  8022b2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8022b8:	85 db                	test   %ebx,%ebx
  8022ba:	74 eb                	je     8022a7 <ipc_recv+0x4c>
			*perm_store = 0;
  8022bc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022c2:	eb e3                	jmp    8022a7 <ipc_recv+0x4c>

008022c4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8022c4:	55                   	push   %ebp
  8022c5:	89 e5                	mov    %esp,%ebp
  8022c7:	57                   	push   %edi
  8022c8:	56                   	push   %esi
  8022c9:	53                   	push   %ebx
  8022ca:	83 ec 0c             	sub    $0xc,%esp
  8022cd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022d0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8022d6:	85 db                	test   %ebx,%ebx
  8022d8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8022dd:	0f 44 d8             	cmove  %eax,%ebx
  8022e0:	eb 05                	jmp    8022e7 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8022e2:	e8 2a eb ff ff       	call   800e11 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8022e7:	ff 75 14             	pushl  0x14(%ebp)
  8022ea:	53                   	push   %ebx
  8022eb:	56                   	push   %esi
  8022ec:	57                   	push   %edi
  8022ed:	e8 cb ec ff ff       	call   800fbd <sys_ipc_try_send>
  8022f2:	83 c4 10             	add    $0x10,%esp
  8022f5:	85 c0                	test   %eax,%eax
  8022f7:	74 1b                	je     802314 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8022f9:	79 e7                	jns    8022e2 <ipc_send+0x1e>
  8022fb:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022fe:	74 e2                	je     8022e2 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802300:	83 ec 04             	sub    $0x4,%esp
  802303:	68 3f 2c 80 00       	push   $0x802c3f
  802308:	6a 46                	push   $0x46
  80230a:	68 54 2c 80 00       	push   $0x802c54
  80230f:	e8 d5 de ff ff       	call   8001e9 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802314:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802317:	5b                   	pop    %ebx
  802318:	5e                   	pop    %esi
  802319:	5f                   	pop    %edi
  80231a:	5d                   	pop    %ebp
  80231b:	c3                   	ret    

0080231c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
  80231f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802322:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802327:	89 c2                	mov    %eax,%edx
  802329:	c1 e2 07             	shl    $0x7,%edx
  80232c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802332:	8b 52 50             	mov    0x50(%edx),%edx
  802335:	39 ca                	cmp    %ecx,%edx
  802337:	74 11                	je     80234a <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802339:	83 c0 01             	add    $0x1,%eax
  80233c:	3d 00 04 00 00       	cmp    $0x400,%eax
  802341:	75 e4                	jne    802327 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802343:	b8 00 00 00 00       	mov    $0x0,%eax
  802348:	eb 0b                	jmp    802355 <ipc_find_env+0x39>
			return envs[i].env_id;
  80234a:	c1 e0 07             	shl    $0x7,%eax
  80234d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802352:	8b 40 48             	mov    0x48(%eax),%eax
}
  802355:	5d                   	pop    %ebp
  802356:	c3                   	ret    

00802357 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802357:	55                   	push   %ebp
  802358:	89 e5                	mov    %esp,%ebp
  80235a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80235d:	89 d0                	mov    %edx,%eax
  80235f:	c1 e8 16             	shr    $0x16,%eax
  802362:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802369:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80236e:	f6 c1 01             	test   $0x1,%cl
  802371:	74 1d                	je     802390 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802373:	c1 ea 0c             	shr    $0xc,%edx
  802376:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80237d:	f6 c2 01             	test   $0x1,%dl
  802380:	74 0e                	je     802390 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802382:	c1 ea 0c             	shr    $0xc,%edx
  802385:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80238c:	ef 
  80238d:	0f b7 c0             	movzwl %ax,%eax
}
  802390:	5d                   	pop    %ebp
  802391:	c3                   	ret    
  802392:	66 90                	xchg   %ax,%ax
  802394:	66 90                	xchg   %ax,%ax
  802396:	66 90                	xchg   %ax,%ax
  802398:	66 90                	xchg   %ax,%ax
  80239a:	66 90                	xchg   %ax,%ax
  80239c:	66 90                	xchg   %ax,%ax
  80239e:	66 90                	xchg   %ax,%ax

008023a0 <__udivdi3>:
  8023a0:	55                   	push   %ebp
  8023a1:	57                   	push   %edi
  8023a2:	56                   	push   %esi
  8023a3:	53                   	push   %ebx
  8023a4:	83 ec 1c             	sub    $0x1c,%esp
  8023a7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8023ab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8023af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023b3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8023b7:	85 d2                	test   %edx,%edx
  8023b9:	75 4d                	jne    802408 <__udivdi3+0x68>
  8023bb:	39 f3                	cmp    %esi,%ebx
  8023bd:	76 19                	jbe    8023d8 <__udivdi3+0x38>
  8023bf:	31 ff                	xor    %edi,%edi
  8023c1:	89 e8                	mov    %ebp,%eax
  8023c3:	89 f2                	mov    %esi,%edx
  8023c5:	f7 f3                	div    %ebx
  8023c7:	89 fa                	mov    %edi,%edx
  8023c9:	83 c4 1c             	add    $0x1c,%esp
  8023cc:	5b                   	pop    %ebx
  8023cd:	5e                   	pop    %esi
  8023ce:	5f                   	pop    %edi
  8023cf:	5d                   	pop    %ebp
  8023d0:	c3                   	ret    
  8023d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023d8:	89 d9                	mov    %ebx,%ecx
  8023da:	85 db                	test   %ebx,%ebx
  8023dc:	75 0b                	jne    8023e9 <__udivdi3+0x49>
  8023de:	b8 01 00 00 00       	mov    $0x1,%eax
  8023e3:	31 d2                	xor    %edx,%edx
  8023e5:	f7 f3                	div    %ebx
  8023e7:	89 c1                	mov    %eax,%ecx
  8023e9:	31 d2                	xor    %edx,%edx
  8023eb:	89 f0                	mov    %esi,%eax
  8023ed:	f7 f1                	div    %ecx
  8023ef:	89 c6                	mov    %eax,%esi
  8023f1:	89 e8                	mov    %ebp,%eax
  8023f3:	89 f7                	mov    %esi,%edi
  8023f5:	f7 f1                	div    %ecx
  8023f7:	89 fa                	mov    %edi,%edx
  8023f9:	83 c4 1c             	add    $0x1c,%esp
  8023fc:	5b                   	pop    %ebx
  8023fd:	5e                   	pop    %esi
  8023fe:	5f                   	pop    %edi
  8023ff:	5d                   	pop    %ebp
  802400:	c3                   	ret    
  802401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802408:	39 f2                	cmp    %esi,%edx
  80240a:	77 1c                	ja     802428 <__udivdi3+0x88>
  80240c:	0f bd fa             	bsr    %edx,%edi
  80240f:	83 f7 1f             	xor    $0x1f,%edi
  802412:	75 2c                	jne    802440 <__udivdi3+0xa0>
  802414:	39 f2                	cmp    %esi,%edx
  802416:	72 06                	jb     80241e <__udivdi3+0x7e>
  802418:	31 c0                	xor    %eax,%eax
  80241a:	39 eb                	cmp    %ebp,%ebx
  80241c:	77 a9                	ja     8023c7 <__udivdi3+0x27>
  80241e:	b8 01 00 00 00       	mov    $0x1,%eax
  802423:	eb a2                	jmp    8023c7 <__udivdi3+0x27>
  802425:	8d 76 00             	lea    0x0(%esi),%esi
  802428:	31 ff                	xor    %edi,%edi
  80242a:	31 c0                	xor    %eax,%eax
  80242c:	89 fa                	mov    %edi,%edx
  80242e:	83 c4 1c             	add    $0x1c,%esp
  802431:	5b                   	pop    %ebx
  802432:	5e                   	pop    %esi
  802433:	5f                   	pop    %edi
  802434:	5d                   	pop    %ebp
  802435:	c3                   	ret    
  802436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80243d:	8d 76 00             	lea    0x0(%esi),%esi
  802440:	89 f9                	mov    %edi,%ecx
  802442:	b8 20 00 00 00       	mov    $0x20,%eax
  802447:	29 f8                	sub    %edi,%eax
  802449:	d3 e2                	shl    %cl,%edx
  80244b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80244f:	89 c1                	mov    %eax,%ecx
  802451:	89 da                	mov    %ebx,%edx
  802453:	d3 ea                	shr    %cl,%edx
  802455:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802459:	09 d1                	or     %edx,%ecx
  80245b:	89 f2                	mov    %esi,%edx
  80245d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802461:	89 f9                	mov    %edi,%ecx
  802463:	d3 e3                	shl    %cl,%ebx
  802465:	89 c1                	mov    %eax,%ecx
  802467:	d3 ea                	shr    %cl,%edx
  802469:	89 f9                	mov    %edi,%ecx
  80246b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80246f:	89 eb                	mov    %ebp,%ebx
  802471:	d3 e6                	shl    %cl,%esi
  802473:	89 c1                	mov    %eax,%ecx
  802475:	d3 eb                	shr    %cl,%ebx
  802477:	09 de                	or     %ebx,%esi
  802479:	89 f0                	mov    %esi,%eax
  80247b:	f7 74 24 08          	divl   0x8(%esp)
  80247f:	89 d6                	mov    %edx,%esi
  802481:	89 c3                	mov    %eax,%ebx
  802483:	f7 64 24 0c          	mull   0xc(%esp)
  802487:	39 d6                	cmp    %edx,%esi
  802489:	72 15                	jb     8024a0 <__udivdi3+0x100>
  80248b:	89 f9                	mov    %edi,%ecx
  80248d:	d3 e5                	shl    %cl,%ebp
  80248f:	39 c5                	cmp    %eax,%ebp
  802491:	73 04                	jae    802497 <__udivdi3+0xf7>
  802493:	39 d6                	cmp    %edx,%esi
  802495:	74 09                	je     8024a0 <__udivdi3+0x100>
  802497:	89 d8                	mov    %ebx,%eax
  802499:	31 ff                	xor    %edi,%edi
  80249b:	e9 27 ff ff ff       	jmp    8023c7 <__udivdi3+0x27>
  8024a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8024a3:	31 ff                	xor    %edi,%edi
  8024a5:	e9 1d ff ff ff       	jmp    8023c7 <__udivdi3+0x27>
  8024aa:	66 90                	xchg   %ax,%ax
  8024ac:	66 90                	xchg   %ax,%ax
  8024ae:	66 90                	xchg   %ax,%ax

008024b0 <__umoddi3>:
  8024b0:	55                   	push   %ebp
  8024b1:	57                   	push   %edi
  8024b2:	56                   	push   %esi
  8024b3:	53                   	push   %ebx
  8024b4:	83 ec 1c             	sub    $0x1c,%esp
  8024b7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8024bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8024bf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8024c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024c7:	89 da                	mov    %ebx,%edx
  8024c9:	85 c0                	test   %eax,%eax
  8024cb:	75 43                	jne    802510 <__umoddi3+0x60>
  8024cd:	39 df                	cmp    %ebx,%edi
  8024cf:	76 17                	jbe    8024e8 <__umoddi3+0x38>
  8024d1:	89 f0                	mov    %esi,%eax
  8024d3:	f7 f7                	div    %edi
  8024d5:	89 d0                	mov    %edx,%eax
  8024d7:	31 d2                	xor    %edx,%edx
  8024d9:	83 c4 1c             	add    $0x1c,%esp
  8024dc:	5b                   	pop    %ebx
  8024dd:	5e                   	pop    %esi
  8024de:	5f                   	pop    %edi
  8024df:	5d                   	pop    %ebp
  8024e0:	c3                   	ret    
  8024e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024e8:	89 fd                	mov    %edi,%ebp
  8024ea:	85 ff                	test   %edi,%edi
  8024ec:	75 0b                	jne    8024f9 <__umoddi3+0x49>
  8024ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8024f3:	31 d2                	xor    %edx,%edx
  8024f5:	f7 f7                	div    %edi
  8024f7:	89 c5                	mov    %eax,%ebp
  8024f9:	89 d8                	mov    %ebx,%eax
  8024fb:	31 d2                	xor    %edx,%edx
  8024fd:	f7 f5                	div    %ebp
  8024ff:	89 f0                	mov    %esi,%eax
  802501:	f7 f5                	div    %ebp
  802503:	89 d0                	mov    %edx,%eax
  802505:	eb d0                	jmp    8024d7 <__umoddi3+0x27>
  802507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80250e:	66 90                	xchg   %ax,%ax
  802510:	89 f1                	mov    %esi,%ecx
  802512:	39 d8                	cmp    %ebx,%eax
  802514:	76 0a                	jbe    802520 <__umoddi3+0x70>
  802516:	89 f0                	mov    %esi,%eax
  802518:	83 c4 1c             	add    $0x1c,%esp
  80251b:	5b                   	pop    %ebx
  80251c:	5e                   	pop    %esi
  80251d:	5f                   	pop    %edi
  80251e:	5d                   	pop    %ebp
  80251f:	c3                   	ret    
  802520:	0f bd e8             	bsr    %eax,%ebp
  802523:	83 f5 1f             	xor    $0x1f,%ebp
  802526:	75 20                	jne    802548 <__umoddi3+0x98>
  802528:	39 d8                	cmp    %ebx,%eax
  80252a:	0f 82 b0 00 00 00    	jb     8025e0 <__umoddi3+0x130>
  802530:	39 f7                	cmp    %esi,%edi
  802532:	0f 86 a8 00 00 00    	jbe    8025e0 <__umoddi3+0x130>
  802538:	89 c8                	mov    %ecx,%eax
  80253a:	83 c4 1c             	add    $0x1c,%esp
  80253d:	5b                   	pop    %ebx
  80253e:	5e                   	pop    %esi
  80253f:	5f                   	pop    %edi
  802540:	5d                   	pop    %ebp
  802541:	c3                   	ret    
  802542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802548:	89 e9                	mov    %ebp,%ecx
  80254a:	ba 20 00 00 00       	mov    $0x20,%edx
  80254f:	29 ea                	sub    %ebp,%edx
  802551:	d3 e0                	shl    %cl,%eax
  802553:	89 44 24 08          	mov    %eax,0x8(%esp)
  802557:	89 d1                	mov    %edx,%ecx
  802559:	89 f8                	mov    %edi,%eax
  80255b:	d3 e8                	shr    %cl,%eax
  80255d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802561:	89 54 24 04          	mov    %edx,0x4(%esp)
  802565:	8b 54 24 04          	mov    0x4(%esp),%edx
  802569:	09 c1                	or     %eax,%ecx
  80256b:	89 d8                	mov    %ebx,%eax
  80256d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802571:	89 e9                	mov    %ebp,%ecx
  802573:	d3 e7                	shl    %cl,%edi
  802575:	89 d1                	mov    %edx,%ecx
  802577:	d3 e8                	shr    %cl,%eax
  802579:	89 e9                	mov    %ebp,%ecx
  80257b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80257f:	d3 e3                	shl    %cl,%ebx
  802581:	89 c7                	mov    %eax,%edi
  802583:	89 d1                	mov    %edx,%ecx
  802585:	89 f0                	mov    %esi,%eax
  802587:	d3 e8                	shr    %cl,%eax
  802589:	89 e9                	mov    %ebp,%ecx
  80258b:	89 fa                	mov    %edi,%edx
  80258d:	d3 e6                	shl    %cl,%esi
  80258f:	09 d8                	or     %ebx,%eax
  802591:	f7 74 24 08          	divl   0x8(%esp)
  802595:	89 d1                	mov    %edx,%ecx
  802597:	89 f3                	mov    %esi,%ebx
  802599:	f7 64 24 0c          	mull   0xc(%esp)
  80259d:	89 c6                	mov    %eax,%esi
  80259f:	89 d7                	mov    %edx,%edi
  8025a1:	39 d1                	cmp    %edx,%ecx
  8025a3:	72 06                	jb     8025ab <__umoddi3+0xfb>
  8025a5:	75 10                	jne    8025b7 <__umoddi3+0x107>
  8025a7:	39 c3                	cmp    %eax,%ebx
  8025a9:	73 0c                	jae    8025b7 <__umoddi3+0x107>
  8025ab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8025af:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8025b3:	89 d7                	mov    %edx,%edi
  8025b5:	89 c6                	mov    %eax,%esi
  8025b7:	89 ca                	mov    %ecx,%edx
  8025b9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025be:	29 f3                	sub    %esi,%ebx
  8025c0:	19 fa                	sbb    %edi,%edx
  8025c2:	89 d0                	mov    %edx,%eax
  8025c4:	d3 e0                	shl    %cl,%eax
  8025c6:	89 e9                	mov    %ebp,%ecx
  8025c8:	d3 eb                	shr    %cl,%ebx
  8025ca:	d3 ea                	shr    %cl,%edx
  8025cc:	09 d8                	or     %ebx,%eax
  8025ce:	83 c4 1c             	add    $0x1c,%esp
  8025d1:	5b                   	pop    %ebx
  8025d2:	5e                   	pop    %esi
  8025d3:	5f                   	pop    %edi
  8025d4:	5d                   	pop    %ebp
  8025d5:	c3                   	ret    
  8025d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025dd:	8d 76 00             	lea    0x0(%esi),%esi
  8025e0:	89 da                	mov    %ebx,%edx
  8025e2:	29 fe                	sub    %edi,%esi
  8025e4:	19 c2                	sbb    %eax,%edx
  8025e6:	89 f1                	mov    %esi,%ecx
  8025e8:	89 c8                	mov    %ecx,%eax
  8025ea:	e9 4b ff ff ff       	jmp    80253a <__umoddi3+0x8a>
