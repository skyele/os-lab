
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
  80003e:	e8 9e 02 00 00       	call   8002e1 <cprintf>
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
  800095:	e8 47 02 00 00       	call   8002e1 <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  80009a:	c7 05 20 50 c0 00 00 	movl   $0x0,0xc05020
  8000a1:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  8000a4:	83 c4 0c             	add    $0xc,%esp
  8000a7:	68 c7 26 80 00       	push   $0x8026c7
  8000ac:	6a 1a                	push   $0x1a
  8000ae:	68 b8 26 80 00       	push   $0x8026b8
  8000b3:	e8 33 01 00 00       	call   8001eb <_panic>
			panic("bigarray[%d] isn't cleared!\n", i);
  8000b8:	50                   	push   %eax
  8000b9:	68 9b 26 80 00       	push   $0x80269b
  8000be:	6a 11                	push   $0x11
  8000c0:	68 b8 26 80 00       	push   $0x8026b8
  8000c5:	e8 21 01 00 00       	call   8001eb <_panic>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000ca:	50                   	push   %eax
  8000cb:	68 40 26 80 00       	push   $0x802640
  8000d0:	6a 16                	push   $0x16
  8000d2:	68 b8 26 80 00       	push   $0x8026b8
  8000d7:	e8 0f 01 00 00       	call   8001eb <_panic>

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
  8000ef:	e8 00 0d 00 00       	call   800df4 <sys_getenvid>
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
  800114:	74 23                	je     800139 <libmain+0x5d>
		if(envs[i].env_id == find)
  800116:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  80011c:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800122:	8b 49 48             	mov    0x48(%ecx),%ecx
  800125:	39 c1                	cmp    %eax,%ecx
  800127:	75 e2                	jne    80010b <libmain+0x2f>
  800129:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  80012f:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800135:	89 fe                	mov    %edi,%esi
  800137:	eb d2                	jmp    80010b <libmain+0x2f>
  800139:	89 f0                	mov    %esi,%eax
  80013b:	84 c0                	test   %al,%al
  80013d:	74 06                	je     800145 <libmain+0x69>
  80013f:	89 1d 20 40 c0 00    	mov    %ebx,0xc04020
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800145:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800149:	7e 0a                	jle    800155 <libmain+0x79>
		binaryname = argv[0];
  80014b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80014e:	8b 00                	mov    (%eax),%eax
  800150:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800155:	a1 20 40 c0 00       	mov    0xc04020,%eax
  80015a:	8b 40 48             	mov    0x48(%eax),%eax
  80015d:	83 ec 08             	sub    $0x8,%esp
  800160:	50                   	push   %eax
  800161:	68 de 26 80 00       	push   $0x8026de
  800166:	e8 76 01 00 00       	call   8002e1 <cprintf>
	cprintf("before umain\n");
  80016b:	c7 04 24 fc 26 80 00 	movl   $0x8026fc,(%esp)
  800172:	e8 6a 01 00 00       	call   8002e1 <cprintf>
	// call user main routine
	umain(argc, argv);
  800177:	83 c4 08             	add    $0x8,%esp
  80017a:	ff 75 0c             	pushl  0xc(%ebp)
  80017d:	ff 75 08             	pushl  0x8(%ebp)
  800180:	e8 ae fe ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800185:	c7 04 24 0a 27 80 00 	movl   $0x80270a,(%esp)
  80018c:	e8 50 01 00 00       	call   8002e1 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800191:	a1 20 40 c0 00       	mov    0xc04020,%eax
  800196:	8b 40 48             	mov    0x48(%eax),%eax
  800199:	83 c4 08             	add    $0x8,%esp
  80019c:	50                   	push   %eax
  80019d:	68 17 27 80 00       	push   $0x802717
  8001a2:	e8 3a 01 00 00       	call   8002e1 <cprintf>
	// exit gracefully
	exit();
  8001a7:	e8 0b 00 00 00       	call   8001b7 <exit>
}
  8001ac:	83 c4 10             	add    $0x10,%esp
  8001af:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b2:	5b                   	pop    %ebx
  8001b3:	5e                   	pop    %esi
  8001b4:	5f                   	pop    %edi
  8001b5:	5d                   	pop    %ebp
  8001b6:	c3                   	ret    

008001b7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001b7:	55                   	push   %ebp
  8001b8:	89 e5                	mov    %esp,%ebp
  8001ba:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001bd:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8001c2:	8b 40 48             	mov    0x48(%eax),%eax
  8001c5:	68 44 27 80 00       	push   $0x802744
  8001ca:	50                   	push   %eax
  8001cb:	68 36 27 80 00       	push   $0x802736
  8001d0:	e8 0c 01 00 00       	call   8002e1 <cprintf>
	close_all();
  8001d5:	e8 25 11 00 00       	call   8012ff <close_all>
	sys_env_destroy(0);
  8001da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001e1:	e8 cd 0b 00 00       	call   800db3 <sys_env_destroy>
}
  8001e6:	83 c4 10             	add    $0x10,%esp
  8001e9:	c9                   	leave  
  8001ea:	c3                   	ret    

008001eb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001eb:	55                   	push   %ebp
  8001ec:	89 e5                	mov    %esp,%ebp
  8001ee:	56                   	push   %esi
  8001ef:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001f0:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8001f5:	8b 40 48             	mov    0x48(%eax),%eax
  8001f8:	83 ec 04             	sub    $0x4,%esp
  8001fb:	68 70 27 80 00       	push   $0x802770
  800200:	50                   	push   %eax
  800201:	68 36 27 80 00       	push   $0x802736
  800206:	e8 d6 00 00 00       	call   8002e1 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80020b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80020e:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800214:	e8 db 0b 00 00       	call   800df4 <sys_getenvid>
  800219:	83 c4 04             	add    $0x4,%esp
  80021c:	ff 75 0c             	pushl  0xc(%ebp)
  80021f:	ff 75 08             	pushl  0x8(%ebp)
  800222:	56                   	push   %esi
  800223:	50                   	push   %eax
  800224:	68 4c 27 80 00       	push   $0x80274c
  800229:	e8 b3 00 00 00       	call   8002e1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80022e:	83 c4 18             	add    $0x18,%esp
  800231:	53                   	push   %ebx
  800232:	ff 75 10             	pushl  0x10(%ebp)
  800235:	e8 56 00 00 00       	call   800290 <vcprintf>
	cprintf("\n");
  80023a:	c7 04 24 b6 26 80 00 	movl   $0x8026b6,(%esp)
  800241:	e8 9b 00 00 00       	call   8002e1 <cprintf>
  800246:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800249:	cc                   	int3   
  80024a:	eb fd                	jmp    800249 <_panic+0x5e>

0080024c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80024c:	55                   	push   %ebp
  80024d:	89 e5                	mov    %esp,%ebp
  80024f:	53                   	push   %ebx
  800250:	83 ec 04             	sub    $0x4,%esp
  800253:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800256:	8b 13                	mov    (%ebx),%edx
  800258:	8d 42 01             	lea    0x1(%edx),%eax
  80025b:	89 03                	mov    %eax,(%ebx)
  80025d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800260:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800264:	3d ff 00 00 00       	cmp    $0xff,%eax
  800269:	74 09                	je     800274 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80026b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80026f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800272:	c9                   	leave  
  800273:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800274:	83 ec 08             	sub    $0x8,%esp
  800277:	68 ff 00 00 00       	push   $0xff
  80027c:	8d 43 08             	lea    0x8(%ebx),%eax
  80027f:	50                   	push   %eax
  800280:	e8 f1 0a 00 00       	call   800d76 <sys_cputs>
		b->idx = 0;
  800285:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80028b:	83 c4 10             	add    $0x10,%esp
  80028e:	eb db                	jmp    80026b <putch+0x1f>

00800290 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800299:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002a0:	00 00 00 
	b.cnt = 0;
  8002a3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002aa:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002ad:	ff 75 0c             	pushl  0xc(%ebp)
  8002b0:	ff 75 08             	pushl  0x8(%ebp)
  8002b3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b9:	50                   	push   %eax
  8002ba:	68 4c 02 80 00       	push   $0x80024c
  8002bf:	e8 4a 01 00 00       	call   80040e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002c4:	83 c4 08             	add    $0x8,%esp
  8002c7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002cd:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002d3:	50                   	push   %eax
  8002d4:	e8 9d 0a 00 00       	call   800d76 <sys_cputs>

	return b.cnt;
}
  8002d9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002df:	c9                   	leave  
  8002e0:	c3                   	ret    

008002e1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002e1:	55                   	push   %ebp
  8002e2:	89 e5                	mov    %esp,%ebp
  8002e4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002e7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002ea:	50                   	push   %eax
  8002eb:	ff 75 08             	pushl  0x8(%ebp)
  8002ee:	e8 9d ff ff ff       	call   800290 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002f3:	c9                   	leave  
  8002f4:	c3                   	ret    

008002f5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	57                   	push   %edi
  8002f9:	56                   	push   %esi
  8002fa:	53                   	push   %ebx
  8002fb:	83 ec 1c             	sub    $0x1c,%esp
  8002fe:	89 c6                	mov    %eax,%esi
  800300:	89 d7                	mov    %edx,%edi
  800302:	8b 45 08             	mov    0x8(%ebp),%eax
  800305:	8b 55 0c             	mov    0xc(%ebp),%edx
  800308:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80030b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80030e:	8b 45 10             	mov    0x10(%ebp),%eax
  800311:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800314:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800318:	74 2c                	je     800346 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80031a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80031d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800324:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800327:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80032a:	39 c2                	cmp    %eax,%edx
  80032c:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80032f:	73 43                	jae    800374 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800331:	83 eb 01             	sub    $0x1,%ebx
  800334:	85 db                	test   %ebx,%ebx
  800336:	7e 6c                	jle    8003a4 <printnum+0xaf>
				putch(padc, putdat);
  800338:	83 ec 08             	sub    $0x8,%esp
  80033b:	57                   	push   %edi
  80033c:	ff 75 18             	pushl  0x18(%ebp)
  80033f:	ff d6                	call   *%esi
  800341:	83 c4 10             	add    $0x10,%esp
  800344:	eb eb                	jmp    800331 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800346:	83 ec 0c             	sub    $0xc,%esp
  800349:	6a 20                	push   $0x20
  80034b:	6a 00                	push   $0x0
  80034d:	50                   	push   %eax
  80034e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800351:	ff 75 e0             	pushl  -0x20(%ebp)
  800354:	89 fa                	mov    %edi,%edx
  800356:	89 f0                	mov    %esi,%eax
  800358:	e8 98 ff ff ff       	call   8002f5 <printnum>
		while (--width > 0)
  80035d:	83 c4 20             	add    $0x20,%esp
  800360:	83 eb 01             	sub    $0x1,%ebx
  800363:	85 db                	test   %ebx,%ebx
  800365:	7e 65                	jle    8003cc <printnum+0xd7>
			putch(padc, putdat);
  800367:	83 ec 08             	sub    $0x8,%esp
  80036a:	57                   	push   %edi
  80036b:	6a 20                	push   $0x20
  80036d:	ff d6                	call   *%esi
  80036f:	83 c4 10             	add    $0x10,%esp
  800372:	eb ec                	jmp    800360 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800374:	83 ec 0c             	sub    $0xc,%esp
  800377:	ff 75 18             	pushl  0x18(%ebp)
  80037a:	83 eb 01             	sub    $0x1,%ebx
  80037d:	53                   	push   %ebx
  80037e:	50                   	push   %eax
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	ff 75 dc             	pushl  -0x24(%ebp)
  800385:	ff 75 d8             	pushl  -0x28(%ebp)
  800388:	ff 75 e4             	pushl  -0x1c(%ebp)
  80038b:	ff 75 e0             	pushl  -0x20(%ebp)
  80038e:	e8 2d 20 00 00       	call   8023c0 <__udivdi3>
  800393:	83 c4 18             	add    $0x18,%esp
  800396:	52                   	push   %edx
  800397:	50                   	push   %eax
  800398:	89 fa                	mov    %edi,%edx
  80039a:	89 f0                	mov    %esi,%eax
  80039c:	e8 54 ff ff ff       	call   8002f5 <printnum>
  8003a1:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8003a4:	83 ec 08             	sub    $0x8,%esp
  8003a7:	57                   	push   %edi
  8003a8:	83 ec 04             	sub    $0x4,%esp
  8003ab:	ff 75 dc             	pushl  -0x24(%ebp)
  8003ae:	ff 75 d8             	pushl  -0x28(%ebp)
  8003b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003b4:	ff 75 e0             	pushl  -0x20(%ebp)
  8003b7:	e8 14 21 00 00       	call   8024d0 <__umoddi3>
  8003bc:	83 c4 14             	add    $0x14,%esp
  8003bf:	0f be 80 77 27 80 00 	movsbl 0x802777(%eax),%eax
  8003c6:	50                   	push   %eax
  8003c7:	ff d6                	call   *%esi
  8003c9:	83 c4 10             	add    $0x10,%esp
	}
}
  8003cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003cf:	5b                   	pop    %ebx
  8003d0:	5e                   	pop    %esi
  8003d1:	5f                   	pop    %edi
  8003d2:	5d                   	pop    %ebp
  8003d3:	c3                   	ret    

008003d4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003da:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003de:	8b 10                	mov    (%eax),%edx
  8003e0:	3b 50 04             	cmp    0x4(%eax),%edx
  8003e3:	73 0a                	jae    8003ef <sprintputch+0x1b>
		*b->buf++ = ch;
  8003e5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003e8:	89 08                	mov    %ecx,(%eax)
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ed:	88 02                	mov    %al,(%edx)
}
  8003ef:	5d                   	pop    %ebp
  8003f0:	c3                   	ret    

008003f1 <printfmt>:
{
  8003f1:	55                   	push   %ebp
  8003f2:	89 e5                	mov    %esp,%ebp
  8003f4:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003f7:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003fa:	50                   	push   %eax
  8003fb:	ff 75 10             	pushl  0x10(%ebp)
  8003fe:	ff 75 0c             	pushl  0xc(%ebp)
  800401:	ff 75 08             	pushl  0x8(%ebp)
  800404:	e8 05 00 00 00       	call   80040e <vprintfmt>
}
  800409:	83 c4 10             	add    $0x10,%esp
  80040c:	c9                   	leave  
  80040d:	c3                   	ret    

0080040e <vprintfmt>:
{
  80040e:	55                   	push   %ebp
  80040f:	89 e5                	mov    %esp,%ebp
  800411:	57                   	push   %edi
  800412:	56                   	push   %esi
  800413:	53                   	push   %ebx
  800414:	83 ec 3c             	sub    $0x3c,%esp
  800417:	8b 75 08             	mov    0x8(%ebp),%esi
  80041a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80041d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800420:	e9 32 04 00 00       	jmp    800857 <vprintfmt+0x449>
		padc = ' ';
  800425:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800429:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800430:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800437:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80043e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800445:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80044c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800451:	8d 47 01             	lea    0x1(%edi),%eax
  800454:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800457:	0f b6 17             	movzbl (%edi),%edx
  80045a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80045d:	3c 55                	cmp    $0x55,%al
  80045f:	0f 87 12 05 00 00    	ja     800977 <vprintfmt+0x569>
  800465:	0f b6 c0             	movzbl %al,%eax
  800468:	ff 24 85 60 29 80 00 	jmp    *0x802960(,%eax,4)
  80046f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800472:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800476:	eb d9                	jmp    800451 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800478:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80047b:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80047f:	eb d0                	jmp    800451 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800481:	0f b6 d2             	movzbl %dl,%edx
  800484:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800487:	b8 00 00 00 00       	mov    $0x0,%eax
  80048c:	89 75 08             	mov    %esi,0x8(%ebp)
  80048f:	eb 03                	jmp    800494 <vprintfmt+0x86>
  800491:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800494:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800497:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80049b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80049e:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004a1:	83 fe 09             	cmp    $0x9,%esi
  8004a4:	76 eb                	jbe    800491 <vprintfmt+0x83>
  8004a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004a9:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ac:	eb 14                	jmp    8004c2 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8004ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b9:	8d 40 04             	lea    0x4(%eax),%eax
  8004bc:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004c2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004c6:	79 89                	jns    800451 <vprintfmt+0x43>
				width = precision, precision = -1;
  8004c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ce:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004d5:	e9 77 ff ff ff       	jmp    800451 <vprintfmt+0x43>
  8004da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004dd:	85 c0                	test   %eax,%eax
  8004df:	0f 48 c1             	cmovs  %ecx,%eax
  8004e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004e8:	e9 64 ff ff ff       	jmp    800451 <vprintfmt+0x43>
  8004ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004f0:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004f7:	e9 55 ff ff ff       	jmp    800451 <vprintfmt+0x43>
			lflag++;
  8004fc:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800500:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800503:	e9 49 ff ff ff       	jmp    800451 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800508:	8b 45 14             	mov    0x14(%ebp),%eax
  80050b:	8d 78 04             	lea    0x4(%eax),%edi
  80050e:	83 ec 08             	sub    $0x8,%esp
  800511:	53                   	push   %ebx
  800512:	ff 30                	pushl  (%eax)
  800514:	ff d6                	call   *%esi
			break;
  800516:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800519:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80051c:	e9 33 03 00 00       	jmp    800854 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800521:	8b 45 14             	mov    0x14(%ebp),%eax
  800524:	8d 78 04             	lea    0x4(%eax),%edi
  800527:	8b 00                	mov    (%eax),%eax
  800529:	99                   	cltd   
  80052a:	31 d0                	xor    %edx,%eax
  80052c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80052e:	83 f8 11             	cmp    $0x11,%eax
  800531:	7f 23                	jg     800556 <vprintfmt+0x148>
  800533:	8b 14 85 c0 2a 80 00 	mov    0x802ac0(,%eax,4),%edx
  80053a:	85 d2                	test   %edx,%edx
  80053c:	74 18                	je     800556 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80053e:	52                   	push   %edx
  80053f:	68 e1 2b 80 00       	push   $0x802be1
  800544:	53                   	push   %ebx
  800545:	56                   	push   %esi
  800546:	e8 a6 fe ff ff       	call   8003f1 <printfmt>
  80054b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80054e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800551:	e9 fe 02 00 00       	jmp    800854 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800556:	50                   	push   %eax
  800557:	68 8f 27 80 00       	push   $0x80278f
  80055c:	53                   	push   %ebx
  80055d:	56                   	push   %esi
  80055e:	e8 8e fe ff ff       	call   8003f1 <printfmt>
  800563:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800566:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800569:	e9 e6 02 00 00       	jmp    800854 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80056e:	8b 45 14             	mov    0x14(%ebp),%eax
  800571:	83 c0 04             	add    $0x4,%eax
  800574:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800577:	8b 45 14             	mov    0x14(%ebp),%eax
  80057a:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80057c:	85 c9                	test   %ecx,%ecx
  80057e:	b8 88 27 80 00       	mov    $0x802788,%eax
  800583:	0f 45 c1             	cmovne %ecx,%eax
  800586:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800589:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80058d:	7e 06                	jle    800595 <vprintfmt+0x187>
  80058f:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800593:	75 0d                	jne    8005a2 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800595:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800598:	89 c7                	mov    %eax,%edi
  80059a:	03 45 e0             	add    -0x20(%ebp),%eax
  80059d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005a0:	eb 53                	jmp    8005f5 <vprintfmt+0x1e7>
  8005a2:	83 ec 08             	sub    $0x8,%esp
  8005a5:	ff 75 d8             	pushl  -0x28(%ebp)
  8005a8:	50                   	push   %eax
  8005a9:	e8 71 04 00 00       	call   800a1f <strnlen>
  8005ae:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005b1:	29 c1                	sub    %eax,%ecx
  8005b3:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8005b6:	83 c4 10             	add    $0x10,%esp
  8005b9:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005bb:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c2:	eb 0f                	jmp    8005d3 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8005c4:	83 ec 08             	sub    $0x8,%esp
  8005c7:	53                   	push   %ebx
  8005c8:	ff 75 e0             	pushl  -0x20(%ebp)
  8005cb:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005cd:	83 ef 01             	sub    $0x1,%edi
  8005d0:	83 c4 10             	add    $0x10,%esp
  8005d3:	85 ff                	test   %edi,%edi
  8005d5:	7f ed                	jg     8005c4 <vprintfmt+0x1b6>
  8005d7:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8005da:	85 c9                	test   %ecx,%ecx
  8005dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e1:	0f 49 c1             	cmovns %ecx,%eax
  8005e4:	29 c1                	sub    %eax,%ecx
  8005e6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005e9:	eb aa                	jmp    800595 <vprintfmt+0x187>
					putch(ch, putdat);
  8005eb:	83 ec 08             	sub    $0x8,%esp
  8005ee:	53                   	push   %ebx
  8005ef:	52                   	push   %edx
  8005f0:	ff d6                	call   *%esi
  8005f2:	83 c4 10             	add    $0x10,%esp
  8005f5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005f8:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005fa:	83 c7 01             	add    $0x1,%edi
  8005fd:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800601:	0f be d0             	movsbl %al,%edx
  800604:	85 d2                	test   %edx,%edx
  800606:	74 4b                	je     800653 <vprintfmt+0x245>
  800608:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80060c:	78 06                	js     800614 <vprintfmt+0x206>
  80060e:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800612:	78 1e                	js     800632 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800614:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800618:	74 d1                	je     8005eb <vprintfmt+0x1dd>
  80061a:	0f be c0             	movsbl %al,%eax
  80061d:	83 e8 20             	sub    $0x20,%eax
  800620:	83 f8 5e             	cmp    $0x5e,%eax
  800623:	76 c6                	jbe    8005eb <vprintfmt+0x1dd>
					putch('?', putdat);
  800625:	83 ec 08             	sub    $0x8,%esp
  800628:	53                   	push   %ebx
  800629:	6a 3f                	push   $0x3f
  80062b:	ff d6                	call   *%esi
  80062d:	83 c4 10             	add    $0x10,%esp
  800630:	eb c3                	jmp    8005f5 <vprintfmt+0x1e7>
  800632:	89 cf                	mov    %ecx,%edi
  800634:	eb 0e                	jmp    800644 <vprintfmt+0x236>
				putch(' ', putdat);
  800636:	83 ec 08             	sub    $0x8,%esp
  800639:	53                   	push   %ebx
  80063a:	6a 20                	push   $0x20
  80063c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80063e:	83 ef 01             	sub    $0x1,%edi
  800641:	83 c4 10             	add    $0x10,%esp
  800644:	85 ff                	test   %edi,%edi
  800646:	7f ee                	jg     800636 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800648:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80064b:	89 45 14             	mov    %eax,0x14(%ebp)
  80064e:	e9 01 02 00 00       	jmp    800854 <vprintfmt+0x446>
  800653:	89 cf                	mov    %ecx,%edi
  800655:	eb ed                	jmp    800644 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800657:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80065a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800661:	e9 eb fd ff ff       	jmp    800451 <vprintfmt+0x43>
	if (lflag >= 2)
  800666:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80066a:	7f 21                	jg     80068d <vprintfmt+0x27f>
	else if (lflag)
  80066c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800670:	74 68                	je     8006da <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80067a:	89 c1                	mov    %eax,%ecx
  80067c:	c1 f9 1f             	sar    $0x1f,%ecx
  80067f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800682:	8b 45 14             	mov    0x14(%ebp),%eax
  800685:	8d 40 04             	lea    0x4(%eax),%eax
  800688:	89 45 14             	mov    %eax,0x14(%ebp)
  80068b:	eb 17                	jmp    8006a4 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80068d:	8b 45 14             	mov    0x14(%ebp),%eax
  800690:	8b 50 04             	mov    0x4(%eax),%edx
  800693:	8b 00                	mov    (%eax),%eax
  800695:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800698:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80069b:	8b 45 14             	mov    0x14(%ebp),%eax
  80069e:	8d 40 08             	lea    0x8(%eax),%eax
  8006a1:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006a4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006a7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ad:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8006b0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006b4:	78 3f                	js     8006f5 <vprintfmt+0x2e7>
			base = 10;
  8006b6:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8006bb:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8006bf:	0f 84 71 01 00 00    	je     800836 <vprintfmt+0x428>
				putch('+', putdat);
  8006c5:	83 ec 08             	sub    $0x8,%esp
  8006c8:	53                   	push   %ebx
  8006c9:	6a 2b                	push   $0x2b
  8006cb:	ff d6                	call   *%esi
  8006cd:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006d0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d5:	e9 5c 01 00 00       	jmp    800836 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8006da:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dd:	8b 00                	mov    (%eax),%eax
  8006df:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006e2:	89 c1                	mov    %eax,%ecx
  8006e4:	c1 f9 1f             	sar    $0x1f,%ecx
  8006e7:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	8d 40 04             	lea    0x4(%eax),%eax
  8006f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f3:	eb af                	jmp    8006a4 <vprintfmt+0x296>
				putch('-', putdat);
  8006f5:	83 ec 08             	sub    $0x8,%esp
  8006f8:	53                   	push   %ebx
  8006f9:	6a 2d                	push   $0x2d
  8006fb:	ff d6                	call   *%esi
				num = -(long long) num;
  8006fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800700:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800703:	f7 d8                	neg    %eax
  800705:	83 d2 00             	adc    $0x0,%edx
  800708:	f7 da                	neg    %edx
  80070a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80070d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800710:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800713:	b8 0a 00 00 00       	mov    $0xa,%eax
  800718:	e9 19 01 00 00       	jmp    800836 <vprintfmt+0x428>
	if (lflag >= 2)
  80071d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800721:	7f 29                	jg     80074c <vprintfmt+0x33e>
	else if (lflag)
  800723:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800727:	74 44                	je     80076d <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800729:	8b 45 14             	mov    0x14(%ebp),%eax
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	ba 00 00 00 00       	mov    $0x0,%edx
  800733:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800736:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800739:	8b 45 14             	mov    0x14(%ebp),%eax
  80073c:	8d 40 04             	lea    0x4(%eax),%eax
  80073f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800742:	b8 0a 00 00 00       	mov    $0xa,%eax
  800747:	e9 ea 00 00 00       	jmp    800836 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80074c:	8b 45 14             	mov    0x14(%ebp),%eax
  80074f:	8b 50 04             	mov    0x4(%eax),%edx
  800752:	8b 00                	mov    (%eax),%eax
  800754:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800757:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075a:	8b 45 14             	mov    0x14(%ebp),%eax
  80075d:	8d 40 08             	lea    0x8(%eax),%eax
  800760:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800763:	b8 0a 00 00 00       	mov    $0xa,%eax
  800768:	e9 c9 00 00 00       	jmp    800836 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	ba 00 00 00 00       	mov    $0x0,%edx
  800777:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	8d 40 04             	lea    0x4(%eax),%eax
  800783:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800786:	b8 0a 00 00 00       	mov    $0xa,%eax
  80078b:	e9 a6 00 00 00       	jmp    800836 <vprintfmt+0x428>
			putch('0', putdat);
  800790:	83 ec 08             	sub    $0x8,%esp
  800793:	53                   	push   %ebx
  800794:	6a 30                	push   $0x30
  800796:	ff d6                	call   *%esi
	if (lflag >= 2)
  800798:	83 c4 10             	add    $0x10,%esp
  80079b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80079f:	7f 26                	jg     8007c7 <vprintfmt+0x3b9>
	else if (lflag)
  8007a1:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007a5:	74 3e                	je     8007e5 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ba:	8d 40 04             	lea    0x4(%eax),%eax
  8007bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007c0:	b8 08 00 00 00       	mov    $0x8,%eax
  8007c5:	eb 6f                	jmp    800836 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	8b 50 04             	mov    0x4(%eax),%edx
  8007cd:	8b 00                	mov    (%eax),%eax
  8007cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d8:	8d 40 08             	lea    0x8(%eax),%eax
  8007db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007de:	b8 08 00 00 00       	mov    $0x8,%eax
  8007e3:	eb 51                	jmp    800836 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f8:	8d 40 04             	lea    0x4(%eax),%eax
  8007fb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007fe:	b8 08 00 00 00       	mov    $0x8,%eax
  800803:	eb 31                	jmp    800836 <vprintfmt+0x428>
			putch('0', putdat);
  800805:	83 ec 08             	sub    $0x8,%esp
  800808:	53                   	push   %ebx
  800809:	6a 30                	push   $0x30
  80080b:	ff d6                	call   *%esi
			putch('x', putdat);
  80080d:	83 c4 08             	add    $0x8,%esp
  800810:	53                   	push   %ebx
  800811:	6a 78                	push   $0x78
  800813:	ff d6                	call   *%esi
			num = (unsigned long long)
  800815:	8b 45 14             	mov    0x14(%ebp),%eax
  800818:	8b 00                	mov    (%eax),%eax
  80081a:	ba 00 00 00 00       	mov    $0x0,%edx
  80081f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800822:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800825:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800828:	8b 45 14             	mov    0x14(%ebp),%eax
  80082b:	8d 40 04             	lea    0x4(%eax),%eax
  80082e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800831:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800836:	83 ec 0c             	sub    $0xc,%esp
  800839:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80083d:	52                   	push   %edx
  80083e:	ff 75 e0             	pushl  -0x20(%ebp)
  800841:	50                   	push   %eax
  800842:	ff 75 dc             	pushl  -0x24(%ebp)
  800845:	ff 75 d8             	pushl  -0x28(%ebp)
  800848:	89 da                	mov    %ebx,%edx
  80084a:	89 f0                	mov    %esi,%eax
  80084c:	e8 a4 fa ff ff       	call   8002f5 <printnum>
			break;
  800851:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800854:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800857:	83 c7 01             	add    $0x1,%edi
  80085a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80085e:	83 f8 25             	cmp    $0x25,%eax
  800861:	0f 84 be fb ff ff    	je     800425 <vprintfmt+0x17>
			if (ch == '\0')
  800867:	85 c0                	test   %eax,%eax
  800869:	0f 84 28 01 00 00    	je     800997 <vprintfmt+0x589>
			putch(ch, putdat);
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	53                   	push   %ebx
  800873:	50                   	push   %eax
  800874:	ff d6                	call   *%esi
  800876:	83 c4 10             	add    $0x10,%esp
  800879:	eb dc                	jmp    800857 <vprintfmt+0x449>
	if (lflag >= 2)
  80087b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80087f:	7f 26                	jg     8008a7 <vprintfmt+0x499>
	else if (lflag)
  800881:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800885:	74 41                	je     8008c8 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	8b 00                	mov    (%eax),%eax
  80088c:	ba 00 00 00 00       	mov    $0x0,%edx
  800891:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800894:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	8d 40 04             	lea    0x4(%eax),%eax
  80089d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008a0:	b8 10 00 00 00       	mov    $0x10,%eax
  8008a5:	eb 8f                	jmp    800836 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008aa:	8b 50 04             	mov    0x4(%eax),%edx
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b8:	8d 40 08             	lea    0x8(%eax),%eax
  8008bb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008be:	b8 10 00 00 00       	mov    $0x10,%eax
  8008c3:	e9 6e ff ff ff       	jmp    800836 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cb:	8b 00                	mov    (%eax),%eax
  8008cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008db:	8d 40 04             	lea    0x4(%eax),%eax
  8008de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008e1:	b8 10 00 00 00       	mov    $0x10,%eax
  8008e6:	e9 4b ff ff ff       	jmp    800836 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8008eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ee:	83 c0 04             	add    $0x4,%eax
  8008f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	85 c0                	test   %eax,%eax
  8008fb:	74 14                	je     800911 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8008fd:	8b 13                	mov    (%ebx),%edx
  8008ff:	83 fa 7f             	cmp    $0x7f,%edx
  800902:	7f 37                	jg     80093b <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800904:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800906:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800909:	89 45 14             	mov    %eax,0x14(%ebp)
  80090c:	e9 43 ff ff ff       	jmp    800854 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800911:	b8 0a 00 00 00       	mov    $0xa,%eax
  800916:	bf ad 28 80 00       	mov    $0x8028ad,%edi
							putch(ch, putdat);
  80091b:	83 ec 08             	sub    $0x8,%esp
  80091e:	53                   	push   %ebx
  80091f:	50                   	push   %eax
  800920:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800922:	83 c7 01             	add    $0x1,%edi
  800925:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800929:	83 c4 10             	add    $0x10,%esp
  80092c:	85 c0                	test   %eax,%eax
  80092e:	75 eb                	jne    80091b <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800930:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800933:	89 45 14             	mov    %eax,0x14(%ebp)
  800936:	e9 19 ff ff ff       	jmp    800854 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80093b:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80093d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800942:	bf e5 28 80 00       	mov    $0x8028e5,%edi
							putch(ch, putdat);
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	53                   	push   %ebx
  80094b:	50                   	push   %eax
  80094c:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80094e:	83 c7 01             	add    $0x1,%edi
  800951:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800955:	83 c4 10             	add    $0x10,%esp
  800958:	85 c0                	test   %eax,%eax
  80095a:	75 eb                	jne    800947 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80095c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80095f:	89 45 14             	mov    %eax,0x14(%ebp)
  800962:	e9 ed fe ff ff       	jmp    800854 <vprintfmt+0x446>
			putch(ch, putdat);
  800967:	83 ec 08             	sub    $0x8,%esp
  80096a:	53                   	push   %ebx
  80096b:	6a 25                	push   $0x25
  80096d:	ff d6                	call   *%esi
			break;
  80096f:	83 c4 10             	add    $0x10,%esp
  800972:	e9 dd fe ff ff       	jmp    800854 <vprintfmt+0x446>
			putch('%', putdat);
  800977:	83 ec 08             	sub    $0x8,%esp
  80097a:	53                   	push   %ebx
  80097b:	6a 25                	push   $0x25
  80097d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80097f:	83 c4 10             	add    $0x10,%esp
  800982:	89 f8                	mov    %edi,%eax
  800984:	eb 03                	jmp    800989 <vprintfmt+0x57b>
  800986:	83 e8 01             	sub    $0x1,%eax
  800989:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80098d:	75 f7                	jne    800986 <vprintfmt+0x578>
  80098f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800992:	e9 bd fe ff ff       	jmp    800854 <vprintfmt+0x446>
}
  800997:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80099a:	5b                   	pop    %ebx
  80099b:	5e                   	pop    %esi
  80099c:	5f                   	pop    %edi
  80099d:	5d                   	pop    %ebp
  80099e:	c3                   	ret    

0080099f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80099f:	55                   	push   %ebp
  8009a0:	89 e5                	mov    %esp,%ebp
  8009a2:	83 ec 18             	sub    $0x18,%esp
  8009a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a8:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009ae:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009b2:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009bc:	85 c0                	test   %eax,%eax
  8009be:	74 26                	je     8009e6 <vsnprintf+0x47>
  8009c0:	85 d2                	test   %edx,%edx
  8009c2:	7e 22                	jle    8009e6 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009c4:	ff 75 14             	pushl  0x14(%ebp)
  8009c7:	ff 75 10             	pushl  0x10(%ebp)
  8009ca:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009cd:	50                   	push   %eax
  8009ce:	68 d4 03 80 00       	push   $0x8003d4
  8009d3:	e8 36 fa ff ff       	call   80040e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009db:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
}
  8009e4:	c9                   	leave  
  8009e5:	c3                   	ret    
		return -E_INVAL;
  8009e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009eb:	eb f7                	jmp    8009e4 <vsnprintf+0x45>

008009ed <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009f3:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009f6:	50                   	push   %eax
  8009f7:	ff 75 10             	pushl  0x10(%ebp)
  8009fa:	ff 75 0c             	pushl  0xc(%ebp)
  8009fd:	ff 75 08             	pushl  0x8(%ebp)
  800a00:	e8 9a ff ff ff       	call   80099f <vsnprintf>
	va_end(ap);

	return rc;
}
  800a05:	c9                   	leave  
  800a06:	c3                   	ret    

00800a07 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a12:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a16:	74 05                	je     800a1d <strlen+0x16>
		n++;
  800a18:	83 c0 01             	add    $0x1,%eax
  800a1b:	eb f5                	jmp    800a12 <strlen+0xb>
	return n;
}
  800a1d:	5d                   	pop    %ebp
  800a1e:	c3                   	ret    

00800a1f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
  800a22:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a25:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a28:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2d:	39 c2                	cmp    %eax,%edx
  800a2f:	74 0d                	je     800a3e <strnlen+0x1f>
  800a31:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a35:	74 05                	je     800a3c <strnlen+0x1d>
		n++;
  800a37:	83 c2 01             	add    $0x1,%edx
  800a3a:	eb f1                	jmp    800a2d <strnlen+0xe>
  800a3c:	89 d0                	mov    %edx,%eax
	return n;
}
  800a3e:	5d                   	pop    %ebp
  800a3f:	c3                   	ret    

00800a40 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a40:	55                   	push   %ebp
  800a41:	89 e5                	mov    %esp,%ebp
  800a43:	53                   	push   %ebx
  800a44:	8b 45 08             	mov    0x8(%ebp),%eax
  800a47:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4f:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a53:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a56:	83 c2 01             	add    $0x1,%edx
  800a59:	84 c9                	test   %cl,%cl
  800a5b:	75 f2                	jne    800a4f <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a5d:	5b                   	pop    %ebx
  800a5e:	5d                   	pop    %ebp
  800a5f:	c3                   	ret    

00800a60 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	53                   	push   %ebx
  800a64:	83 ec 10             	sub    $0x10,%esp
  800a67:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a6a:	53                   	push   %ebx
  800a6b:	e8 97 ff ff ff       	call   800a07 <strlen>
  800a70:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a73:	ff 75 0c             	pushl  0xc(%ebp)
  800a76:	01 d8                	add    %ebx,%eax
  800a78:	50                   	push   %eax
  800a79:	e8 c2 ff ff ff       	call   800a40 <strcpy>
	return dst;
}
  800a7e:	89 d8                	mov    %ebx,%eax
  800a80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a83:	c9                   	leave  
  800a84:	c3                   	ret    

00800a85 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	56                   	push   %esi
  800a89:	53                   	push   %ebx
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a90:	89 c6                	mov    %eax,%esi
  800a92:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a95:	89 c2                	mov    %eax,%edx
  800a97:	39 f2                	cmp    %esi,%edx
  800a99:	74 11                	je     800aac <strncpy+0x27>
		*dst++ = *src;
  800a9b:	83 c2 01             	add    $0x1,%edx
  800a9e:	0f b6 19             	movzbl (%ecx),%ebx
  800aa1:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aa4:	80 fb 01             	cmp    $0x1,%bl
  800aa7:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800aaa:	eb eb                	jmp    800a97 <strncpy+0x12>
	}
	return ret;
}
  800aac:	5b                   	pop    %ebx
  800aad:	5e                   	pop    %esi
  800aae:	5d                   	pop    %ebp
  800aaf:	c3                   	ret    

00800ab0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	56                   	push   %esi
  800ab4:	53                   	push   %ebx
  800ab5:	8b 75 08             	mov    0x8(%ebp),%esi
  800ab8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800abb:	8b 55 10             	mov    0x10(%ebp),%edx
  800abe:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ac0:	85 d2                	test   %edx,%edx
  800ac2:	74 21                	je     800ae5 <strlcpy+0x35>
  800ac4:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ac8:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800aca:	39 c2                	cmp    %eax,%edx
  800acc:	74 14                	je     800ae2 <strlcpy+0x32>
  800ace:	0f b6 19             	movzbl (%ecx),%ebx
  800ad1:	84 db                	test   %bl,%bl
  800ad3:	74 0b                	je     800ae0 <strlcpy+0x30>
			*dst++ = *src++;
  800ad5:	83 c1 01             	add    $0x1,%ecx
  800ad8:	83 c2 01             	add    $0x1,%edx
  800adb:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ade:	eb ea                	jmp    800aca <strlcpy+0x1a>
  800ae0:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ae2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ae5:	29 f0                	sub    %esi,%eax
}
  800ae7:	5b                   	pop    %ebx
  800ae8:	5e                   	pop    %esi
  800ae9:	5d                   	pop    %ebp
  800aea:	c3                   	ret    

00800aeb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800aeb:	55                   	push   %ebp
  800aec:	89 e5                	mov    %esp,%ebp
  800aee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800af4:	0f b6 01             	movzbl (%ecx),%eax
  800af7:	84 c0                	test   %al,%al
  800af9:	74 0c                	je     800b07 <strcmp+0x1c>
  800afb:	3a 02                	cmp    (%edx),%al
  800afd:	75 08                	jne    800b07 <strcmp+0x1c>
		p++, q++;
  800aff:	83 c1 01             	add    $0x1,%ecx
  800b02:	83 c2 01             	add    $0x1,%edx
  800b05:	eb ed                	jmp    800af4 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b07:	0f b6 c0             	movzbl %al,%eax
  800b0a:	0f b6 12             	movzbl (%edx),%edx
  800b0d:	29 d0                	sub    %edx,%eax
}
  800b0f:	5d                   	pop    %ebp
  800b10:	c3                   	ret    

00800b11 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b11:	55                   	push   %ebp
  800b12:	89 e5                	mov    %esp,%ebp
  800b14:	53                   	push   %ebx
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1b:	89 c3                	mov    %eax,%ebx
  800b1d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b20:	eb 06                	jmp    800b28 <strncmp+0x17>
		n--, p++, q++;
  800b22:	83 c0 01             	add    $0x1,%eax
  800b25:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b28:	39 d8                	cmp    %ebx,%eax
  800b2a:	74 16                	je     800b42 <strncmp+0x31>
  800b2c:	0f b6 08             	movzbl (%eax),%ecx
  800b2f:	84 c9                	test   %cl,%cl
  800b31:	74 04                	je     800b37 <strncmp+0x26>
  800b33:	3a 0a                	cmp    (%edx),%cl
  800b35:	74 eb                	je     800b22 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b37:	0f b6 00             	movzbl (%eax),%eax
  800b3a:	0f b6 12             	movzbl (%edx),%edx
  800b3d:	29 d0                	sub    %edx,%eax
}
  800b3f:	5b                   	pop    %ebx
  800b40:	5d                   	pop    %ebp
  800b41:	c3                   	ret    
		return 0;
  800b42:	b8 00 00 00 00       	mov    $0x0,%eax
  800b47:	eb f6                	jmp    800b3f <strncmp+0x2e>

00800b49 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b49:	55                   	push   %ebp
  800b4a:	89 e5                	mov    %esp,%ebp
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b53:	0f b6 10             	movzbl (%eax),%edx
  800b56:	84 d2                	test   %dl,%dl
  800b58:	74 09                	je     800b63 <strchr+0x1a>
		if (*s == c)
  800b5a:	38 ca                	cmp    %cl,%dl
  800b5c:	74 0a                	je     800b68 <strchr+0x1f>
	for (; *s; s++)
  800b5e:	83 c0 01             	add    $0x1,%eax
  800b61:	eb f0                	jmp    800b53 <strchr+0xa>
			return (char *) s;
	return 0;
  800b63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b68:	5d                   	pop    %ebp
  800b69:	c3                   	ret    

00800b6a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b74:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b77:	38 ca                	cmp    %cl,%dl
  800b79:	74 09                	je     800b84 <strfind+0x1a>
  800b7b:	84 d2                	test   %dl,%dl
  800b7d:	74 05                	je     800b84 <strfind+0x1a>
	for (; *s; s++)
  800b7f:	83 c0 01             	add    $0x1,%eax
  800b82:	eb f0                	jmp    800b74 <strfind+0xa>
			break;
	return (char *) s;
}
  800b84:	5d                   	pop    %ebp
  800b85:	c3                   	ret    

00800b86 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	57                   	push   %edi
  800b8a:	56                   	push   %esi
  800b8b:	53                   	push   %ebx
  800b8c:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b8f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b92:	85 c9                	test   %ecx,%ecx
  800b94:	74 31                	je     800bc7 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b96:	89 f8                	mov    %edi,%eax
  800b98:	09 c8                	or     %ecx,%eax
  800b9a:	a8 03                	test   $0x3,%al
  800b9c:	75 23                	jne    800bc1 <memset+0x3b>
		c &= 0xFF;
  800b9e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ba2:	89 d3                	mov    %edx,%ebx
  800ba4:	c1 e3 08             	shl    $0x8,%ebx
  800ba7:	89 d0                	mov    %edx,%eax
  800ba9:	c1 e0 18             	shl    $0x18,%eax
  800bac:	89 d6                	mov    %edx,%esi
  800bae:	c1 e6 10             	shl    $0x10,%esi
  800bb1:	09 f0                	or     %esi,%eax
  800bb3:	09 c2                	or     %eax,%edx
  800bb5:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bb7:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bba:	89 d0                	mov    %edx,%eax
  800bbc:	fc                   	cld    
  800bbd:	f3 ab                	rep stos %eax,%es:(%edi)
  800bbf:	eb 06                	jmp    800bc7 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc4:	fc                   	cld    
  800bc5:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bc7:	89 f8                	mov    %edi,%eax
  800bc9:	5b                   	pop    %ebx
  800bca:	5e                   	pop    %esi
  800bcb:	5f                   	pop    %edi
  800bcc:	5d                   	pop    %ebp
  800bcd:	c3                   	ret    

00800bce <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
  800bd1:	57                   	push   %edi
  800bd2:	56                   	push   %esi
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bd9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bdc:	39 c6                	cmp    %eax,%esi
  800bde:	73 32                	jae    800c12 <memmove+0x44>
  800be0:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800be3:	39 c2                	cmp    %eax,%edx
  800be5:	76 2b                	jbe    800c12 <memmove+0x44>
		s += n;
		d += n;
  800be7:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bea:	89 fe                	mov    %edi,%esi
  800bec:	09 ce                	or     %ecx,%esi
  800bee:	09 d6                	or     %edx,%esi
  800bf0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bf6:	75 0e                	jne    800c06 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bf8:	83 ef 04             	sub    $0x4,%edi
  800bfb:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bfe:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c01:	fd                   	std    
  800c02:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c04:	eb 09                	jmp    800c0f <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c06:	83 ef 01             	sub    $0x1,%edi
  800c09:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c0c:	fd                   	std    
  800c0d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c0f:	fc                   	cld    
  800c10:	eb 1a                	jmp    800c2c <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c12:	89 c2                	mov    %eax,%edx
  800c14:	09 ca                	or     %ecx,%edx
  800c16:	09 f2                	or     %esi,%edx
  800c18:	f6 c2 03             	test   $0x3,%dl
  800c1b:	75 0a                	jne    800c27 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c1d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c20:	89 c7                	mov    %eax,%edi
  800c22:	fc                   	cld    
  800c23:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c25:	eb 05                	jmp    800c2c <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c27:	89 c7                	mov    %eax,%edi
  800c29:	fc                   	cld    
  800c2a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c2c:	5e                   	pop    %esi
  800c2d:	5f                   	pop    %edi
  800c2e:	5d                   	pop    %ebp
  800c2f:	c3                   	ret    

00800c30 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c36:	ff 75 10             	pushl  0x10(%ebp)
  800c39:	ff 75 0c             	pushl  0xc(%ebp)
  800c3c:	ff 75 08             	pushl  0x8(%ebp)
  800c3f:	e8 8a ff ff ff       	call   800bce <memmove>
}
  800c44:	c9                   	leave  
  800c45:	c3                   	ret    

00800c46 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	56                   	push   %esi
  800c4a:	53                   	push   %ebx
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c51:	89 c6                	mov    %eax,%esi
  800c53:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c56:	39 f0                	cmp    %esi,%eax
  800c58:	74 1c                	je     800c76 <memcmp+0x30>
		if (*s1 != *s2)
  800c5a:	0f b6 08             	movzbl (%eax),%ecx
  800c5d:	0f b6 1a             	movzbl (%edx),%ebx
  800c60:	38 d9                	cmp    %bl,%cl
  800c62:	75 08                	jne    800c6c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c64:	83 c0 01             	add    $0x1,%eax
  800c67:	83 c2 01             	add    $0x1,%edx
  800c6a:	eb ea                	jmp    800c56 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c6c:	0f b6 c1             	movzbl %cl,%eax
  800c6f:	0f b6 db             	movzbl %bl,%ebx
  800c72:	29 d8                	sub    %ebx,%eax
  800c74:	eb 05                	jmp    800c7b <memcmp+0x35>
	}

	return 0;
  800c76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c7b:	5b                   	pop    %ebx
  800c7c:	5e                   	pop    %esi
  800c7d:	5d                   	pop    %ebp
  800c7e:	c3                   	ret    

00800c7f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c88:	89 c2                	mov    %eax,%edx
  800c8a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c8d:	39 d0                	cmp    %edx,%eax
  800c8f:	73 09                	jae    800c9a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c91:	38 08                	cmp    %cl,(%eax)
  800c93:	74 05                	je     800c9a <memfind+0x1b>
	for (; s < ends; s++)
  800c95:	83 c0 01             	add    $0x1,%eax
  800c98:	eb f3                	jmp    800c8d <memfind+0xe>
			break;
	return (void *) s;
}
  800c9a:	5d                   	pop    %ebp
  800c9b:	c3                   	ret    

00800c9c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	57                   	push   %edi
  800ca0:	56                   	push   %esi
  800ca1:	53                   	push   %ebx
  800ca2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ca5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ca8:	eb 03                	jmp    800cad <strtol+0x11>
		s++;
  800caa:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cad:	0f b6 01             	movzbl (%ecx),%eax
  800cb0:	3c 20                	cmp    $0x20,%al
  800cb2:	74 f6                	je     800caa <strtol+0xe>
  800cb4:	3c 09                	cmp    $0x9,%al
  800cb6:	74 f2                	je     800caa <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cb8:	3c 2b                	cmp    $0x2b,%al
  800cba:	74 2a                	je     800ce6 <strtol+0x4a>
	int neg = 0;
  800cbc:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cc1:	3c 2d                	cmp    $0x2d,%al
  800cc3:	74 2b                	je     800cf0 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cc5:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ccb:	75 0f                	jne    800cdc <strtol+0x40>
  800ccd:	80 39 30             	cmpb   $0x30,(%ecx)
  800cd0:	74 28                	je     800cfa <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cd2:	85 db                	test   %ebx,%ebx
  800cd4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cd9:	0f 44 d8             	cmove  %eax,%ebx
  800cdc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ce4:	eb 50                	jmp    800d36 <strtol+0x9a>
		s++;
  800ce6:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ce9:	bf 00 00 00 00       	mov    $0x0,%edi
  800cee:	eb d5                	jmp    800cc5 <strtol+0x29>
		s++, neg = 1;
  800cf0:	83 c1 01             	add    $0x1,%ecx
  800cf3:	bf 01 00 00 00       	mov    $0x1,%edi
  800cf8:	eb cb                	jmp    800cc5 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cfa:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cfe:	74 0e                	je     800d0e <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d00:	85 db                	test   %ebx,%ebx
  800d02:	75 d8                	jne    800cdc <strtol+0x40>
		s++, base = 8;
  800d04:	83 c1 01             	add    $0x1,%ecx
  800d07:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d0c:	eb ce                	jmp    800cdc <strtol+0x40>
		s += 2, base = 16;
  800d0e:	83 c1 02             	add    $0x2,%ecx
  800d11:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d16:	eb c4                	jmp    800cdc <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d18:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d1b:	89 f3                	mov    %esi,%ebx
  800d1d:	80 fb 19             	cmp    $0x19,%bl
  800d20:	77 29                	ja     800d4b <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d22:	0f be d2             	movsbl %dl,%edx
  800d25:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d28:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d2b:	7d 30                	jge    800d5d <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d2d:	83 c1 01             	add    $0x1,%ecx
  800d30:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d34:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d36:	0f b6 11             	movzbl (%ecx),%edx
  800d39:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d3c:	89 f3                	mov    %esi,%ebx
  800d3e:	80 fb 09             	cmp    $0x9,%bl
  800d41:	77 d5                	ja     800d18 <strtol+0x7c>
			dig = *s - '0';
  800d43:	0f be d2             	movsbl %dl,%edx
  800d46:	83 ea 30             	sub    $0x30,%edx
  800d49:	eb dd                	jmp    800d28 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d4b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d4e:	89 f3                	mov    %esi,%ebx
  800d50:	80 fb 19             	cmp    $0x19,%bl
  800d53:	77 08                	ja     800d5d <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d55:	0f be d2             	movsbl %dl,%edx
  800d58:	83 ea 37             	sub    $0x37,%edx
  800d5b:	eb cb                	jmp    800d28 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d61:	74 05                	je     800d68 <strtol+0xcc>
		*endptr = (char *) s;
  800d63:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d66:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d68:	89 c2                	mov    %eax,%edx
  800d6a:	f7 da                	neg    %edx
  800d6c:	85 ff                	test   %edi,%edi
  800d6e:	0f 45 c2             	cmovne %edx,%eax
}
  800d71:	5b                   	pop    %ebx
  800d72:	5e                   	pop    %esi
  800d73:	5f                   	pop    %edi
  800d74:	5d                   	pop    %ebp
  800d75:	c3                   	ret    

00800d76 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d76:	55                   	push   %ebp
  800d77:	89 e5                	mov    %esp,%ebp
  800d79:	57                   	push   %edi
  800d7a:	56                   	push   %esi
  800d7b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d81:	8b 55 08             	mov    0x8(%ebp),%edx
  800d84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d87:	89 c3                	mov    %eax,%ebx
  800d89:	89 c7                	mov    %eax,%edi
  800d8b:	89 c6                	mov    %eax,%esi
  800d8d:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d8f:	5b                   	pop    %ebx
  800d90:	5e                   	pop    %esi
  800d91:	5f                   	pop    %edi
  800d92:	5d                   	pop    %ebp
  800d93:	c3                   	ret    

00800d94 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
  800d97:	57                   	push   %edi
  800d98:	56                   	push   %esi
  800d99:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9f:	b8 01 00 00 00       	mov    $0x1,%eax
  800da4:	89 d1                	mov    %edx,%ecx
  800da6:	89 d3                	mov    %edx,%ebx
  800da8:	89 d7                	mov    %edx,%edi
  800daa:	89 d6                	mov    %edx,%esi
  800dac:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dae:	5b                   	pop    %ebx
  800daf:	5e                   	pop    %esi
  800db0:	5f                   	pop    %edi
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    

00800db3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	57                   	push   %edi
  800db7:	56                   	push   %esi
  800db8:	53                   	push   %ebx
  800db9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc4:	b8 03 00 00 00       	mov    $0x3,%eax
  800dc9:	89 cb                	mov    %ecx,%ebx
  800dcb:	89 cf                	mov    %ecx,%edi
  800dcd:	89 ce                	mov    %ecx,%esi
  800dcf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd1:	85 c0                	test   %eax,%eax
  800dd3:	7f 08                	jg     800ddd <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd8:	5b                   	pop    %ebx
  800dd9:	5e                   	pop    %esi
  800dda:	5f                   	pop    %edi
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddd:	83 ec 0c             	sub    $0xc,%esp
  800de0:	50                   	push   %eax
  800de1:	6a 03                	push   $0x3
  800de3:	68 08 2b 80 00       	push   $0x802b08
  800de8:	6a 43                	push   $0x43
  800dea:	68 25 2b 80 00       	push   $0x802b25
  800def:	e8 f7 f3 ff ff       	call   8001eb <_panic>

00800df4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	57                   	push   %edi
  800df8:	56                   	push   %esi
  800df9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dfa:	ba 00 00 00 00       	mov    $0x0,%edx
  800dff:	b8 02 00 00 00       	mov    $0x2,%eax
  800e04:	89 d1                	mov    %edx,%ecx
  800e06:	89 d3                	mov    %edx,%ebx
  800e08:	89 d7                	mov    %edx,%edi
  800e0a:	89 d6                	mov    %edx,%esi
  800e0c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e0e:	5b                   	pop    %ebx
  800e0f:	5e                   	pop    %esi
  800e10:	5f                   	pop    %edi
  800e11:	5d                   	pop    %ebp
  800e12:	c3                   	ret    

00800e13 <sys_yield>:

void
sys_yield(void)
{
  800e13:	55                   	push   %ebp
  800e14:	89 e5                	mov    %esp,%ebp
  800e16:	57                   	push   %edi
  800e17:	56                   	push   %esi
  800e18:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e19:	ba 00 00 00 00       	mov    $0x0,%edx
  800e1e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e23:	89 d1                	mov    %edx,%ecx
  800e25:	89 d3                	mov    %edx,%ebx
  800e27:	89 d7                	mov    %edx,%edi
  800e29:	89 d6                	mov    %edx,%esi
  800e2b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e2d:	5b                   	pop    %ebx
  800e2e:	5e                   	pop    %esi
  800e2f:	5f                   	pop    %edi
  800e30:	5d                   	pop    %ebp
  800e31:	c3                   	ret    

00800e32 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e32:	55                   	push   %ebp
  800e33:	89 e5                	mov    %esp,%ebp
  800e35:	57                   	push   %edi
  800e36:	56                   	push   %esi
  800e37:	53                   	push   %ebx
  800e38:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3b:	be 00 00 00 00       	mov    $0x0,%esi
  800e40:	8b 55 08             	mov    0x8(%ebp),%edx
  800e43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e46:	b8 04 00 00 00       	mov    $0x4,%eax
  800e4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e4e:	89 f7                	mov    %esi,%edi
  800e50:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e52:	85 c0                	test   %eax,%eax
  800e54:	7f 08                	jg     800e5e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e59:	5b                   	pop    %ebx
  800e5a:	5e                   	pop    %esi
  800e5b:	5f                   	pop    %edi
  800e5c:	5d                   	pop    %ebp
  800e5d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5e:	83 ec 0c             	sub    $0xc,%esp
  800e61:	50                   	push   %eax
  800e62:	6a 04                	push   $0x4
  800e64:	68 08 2b 80 00       	push   $0x802b08
  800e69:	6a 43                	push   $0x43
  800e6b:	68 25 2b 80 00       	push   $0x802b25
  800e70:	e8 76 f3 ff ff       	call   8001eb <_panic>

00800e75 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e75:	55                   	push   %ebp
  800e76:	89 e5                	mov    %esp,%ebp
  800e78:	57                   	push   %edi
  800e79:	56                   	push   %esi
  800e7a:	53                   	push   %ebx
  800e7b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e84:	b8 05 00 00 00       	mov    $0x5,%eax
  800e89:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e8c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e8f:	8b 75 18             	mov    0x18(%ebp),%esi
  800e92:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e94:	85 c0                	test   %eax,%eax
  800e96:	7f 08                	jg     800ea0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9b:	5b                   	pop    %ebx
  800e9c:	5e                   	pop    %esi
  800e9d:	5f                   	pop    %edi
  800e9e:	5d                   	pop    %ebp
  800e9f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea0:	83 ec 0c             	sub    $0xc,%esp
  800ea3:	50                   	push   %eax
  800ea4:	6a 05                	push   $0x5
  800ea6:	68 08 2b 80 00       	push   $0x802b08
  800eab:	6a 43                	push   $0x43
  800ead:	68 25 2b 80 00       	push   $0x802b25
  800eb2:	e8 34 f3 ff ff       	call   8001eb <_panic>

00800eb7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	57                   	push   %edi
  800ebb:	56                   	push   %esi
  800ebc:	53                   	push   %ebx
  800ebd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ecb:	b8 06 00 00 00       	mov    $0x6,%eax
  800ed0:	89 df                	mov    %ebx,%edi
  800ed2:	89 de                	mov    %ebx,%esi
  800ed4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed6:	85 c0                	test   %eax,%eax
  800ed8:	7f 08                	jg     800ee2 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800eda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800edd:	5b                   	pop    %ebx
  800ede:	5e                   	pop    %esi
  800edf:	5f                   	pop    %edi
  800ee0:	5d                   	pop    %ebp
  800ee1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee2:	83 ec 0c             	sub    $0xc,%esp
  800ee5:	50                   	push   %eax
  800ee6:	6a 06                	push   $0x6
  800ee8:	68 08 2b 80 00       	push   $0x802b08
  800eed:	6a 43                	push   $0x43
  800eef:	68 25 2b 80 00       	push   $0x802b25
  800ef4:	e8 f2 f2 ff ff       	call   8001eb <_panic>

00800ef9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ef9:	55                   	push   %ebp
  800efa:	89 e5                	mov    %esp,%ebp
  800efc:	57                   	push   %edi
  800efd:	56                   	push   %esi
  800efe:	53                   	push   %ebx
  800eff:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f02:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f07:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0d:	b8 08 00 00 00       	mov    $0x8,%eax
  800f12:	89 df                	mov    %ebx,%edi
  800f14:	89 de                	mov    %ebx,%esi
  800f16:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f18:	85 c0                	test   %eax,%eax
  800f1a:	7f 08                	jg     800f24 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f1f:	5b                   	pop    %ebx
  800f20:	5e                   	pop    %esi
  800f21:	5f                   	pop    %edi
  800f22:	5d                   	pop    %ebp
  800f23:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f24:	83 ec 0c             	sub    $0xc,%esp
  800f27:	50                   	push   %eax
  800f28:	6a 08                	push   $0x8
  800f2a:	68 08 2b 80 00       	push   $0x802b08
  800f2f:	6a 43                	push   $0x43
  800f31:	68 25 2b 80 00       	push   $0x802b25
  800f36:	e8 b0 f2 ff ff       	call   8001eb <_panic>

00800f3b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	57                   	push   %edi
  800f3f:	56                   	push   %esi
  800f40:	53                   	push   %ebx
  800f41:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f44:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f49:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4f:	b8 09 00 00 00       	mov    $0x9,%eax
  800f54:	89 df                	mov    %ebx,%edi
  800f56:	89 de                	mov    %ebx,%esi
  800f58:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f5a:	85 c0                	test   %eax,%eax
  800f5c:	7f 08                	jg     800f66 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f61:	5b                   	pop    %ebx
  800f62:	5e                   	pop    %esi
  800f63:	5f                   	pop    %edi
  800f64:	5d                   	pop    %ebp
  800f65:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f66:	83 ec 0c             	sub    $0xc,%esp
  800f69:	50                   	push   %eax
  800f6a:	6a 09                	push   $0x9
  800f6c:	68 08 2b 80 00       	push   $0x802b08
  800f71:	6a 43                	push   $0x43
  800f73:	68 25 2b 80 00       	push   $0x802b25
  800f78:	e8 6e f2 ff ff       	call   8001eb <_panic>

00800f7d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f7d:	55                   	push   %ebp
  800f7e:	89 e5                	mov    %esp,%ebp
  800f80:	57                   	push   %edi
  800f81:	56                   	push   %esi
  800f82:	53                   	push   %ebx
  800f83:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f86:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f91:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f96:	89 df                	mov    %ebx,%edi
  800f98:	89 de                	mov    %ebx,%esi
  800f9a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f9c:	85 c0                	test   %eax,%eax
  800f9e:	7f 08                	jg     800fa8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa3:	5b                   	pop    %ebx
  800fa4:	5e                   	pop    %esi
  800fa5:	5f                   	pop    %edi
  800fa6:	5d                   	pop    %ebp
  800fa7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa8:	83 ec 0c             	sub    $0xc,%esp
  800fab:	50                   	push   %eax
  800fac:	6a 0a                	push   $0xa
  800fae:	68 08 2b 80 00       	push   $0x802b08
  800fb3:	6a 43                	push   $0x43
  800fb5:	68 25 2b 80 00       	push   $0x802b25
  800fba:	e8 2c f2 ff ff       	call   8001eb <_panic>

00800fbf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fbf:	55                   	push   %ebp
  800fc0:	89 e5                	mov    %esp,%ebp
  800fc2:	57                   	push   %edi
  800fc3:	56                   	push   %esi
  800fc4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fcb:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fd0:	be 00 00 00 00       	mov    $0x0,%esi
  800fd5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fd8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fdb:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fdd:	5b                   	pop    %ebx
  800fde:	5e                   	pop    %esi
  800fdf:	5f                   	pop    %edi
  800fe0:	5d                   	pop    %ebp
  800fe1:	c3                   	ret    

00800fe2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fe2:	55                   	push   %ebp
  800fe3:	89 e5                	mov    %esp,%ebp
  800fe5:	57                   	push   %edi
  800fe6:	56                   	push   %esi
  800fe7:	53                   	push   %ebx
  800fe8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800feb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ff0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff3:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ff8:	89 cb                	mov    %ecx,%ebx
  800ffa:	89 cf                	mov    %ecx,%edi
  800ffc:	89 ce                	mov    %ecx,%esi
  800ffe:	cd 30                	int    $0x30
	if(check && ret > 0)
  801000:	85 c0                	test   %eax,%eax
  801002:	7f 08                	jg     80100c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801004:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801007:	5b                   	pop    %ebx
  801008:	5e                   	pop    %esi
  801009:	5f                   	pop    %edi
  80100a:	5d                   	pop    %ebp
  80100b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80100c:	83 ec 0c             	sub    $0xc,%esp
  80100f:	50                   	push   %eax
  801010:	6a 0d                	push   $0xd
  801012:	68 08 2b 80 00       	push   $0x802b08
  801017:	6a 43                	push   $0x43
  801019:	68 25 2b 80 00       	push   $0x802b25
  80101e:	e8 c8 f1 ff ff       	call   8001eb <_panic>

00801023 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801023:	55                   	push   %ebp
  801024:	89 e5                	mov    %esp,%ebp
  801026:	57                   	push   %edi
  801027:	56                   	push   %esi
  801028:	53                   	push   %ebx
	asm volatile("int %1\n"
  801029:	bb 00 00 00 00       	mov    $0x0,%ebx
  80102e:	8b 55 08             	mov    0x8(%ebp),%edx
  801031:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801034:	b8 0e 00 00 00       	mov    $0xe,%eax
  801039:	89 df                	mov    %ebx,%edi
  80103b:	89 de                	mov    %ebx,%esi
  80103d:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80103f:	5b                   	pop    %ebx
  801040:	5e                   	pop    %esi
  801041:	5f                   	pop    %edi
  801042:	5d                   	pop    %ebp
  801043:	c3                   	ret    

00801044 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801044:	55                   	push   %ebp
  801045:	89 e5                	mov    %esp,%ebp
  801047:	57                   	push   %edi
  801048:	56                   	push   %esi
  801049:	53                   	push   %ebx
	asm volatile("int %1\n"
  80104a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80104f:	8b 55 08             	mov    0x8(%ebp),%edx
  801052:	b8 0f 00 00 00       	mov    $0xf,%eax
  801057:	89 cb                	mov    %ecx,%ebx
  801059:	89 cf                	mov    %ecx,%edi
  80105b:	89 ce                	mov    %ecx,%esi
  80105d:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80105f:	5b                   	pop    %ebx
  801060:	5e                   	pop    %esi
  801061:	5f                   	pop    %edi
  801062:	5d                   	pop    %ebp
  801063:	c3                   	ret    

00801064 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
  801067:	57                   	push   %edi
  801068:	56                   	push   %esi
  801069:	53                   	push   %ebx
	asm volatile("int %1\n"
  80106a:	ba 00 00 00 00       	mov    $0x0,%edx
  80106f:	b8 10 00 00 00       	mov    $0x10,%eax
  801074:	89 d1                	mov    %edx,%ecx
  801076:	89 d3                	mov    %edx,%ebx
  801078:	89 d7                	mov    %edx,%edi
  80107a:	89 d6                	mov    %edx,%esi
  80107c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80107e:	5b                   	pop    %ebx
  80107f:	5e                   	pop    %esi
  801080:	5f                   	pop    %edi
  801081:	5d                   	pop    %ebp
  801082:	c3                   	ret    

00801083 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
  801086:	57                   	push   %edi
  801087:	56                   	push   %esi
  801088:	53                   	push   %ebx
	asm volatile("int %1\n"
  801089:	bb 00 00 00 00       	mov    $0x0,%ebx
  80108e:	8b 55 08             	mov    0x8(%ebp),%edx
  801091:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801094:	b8 11 00 00 00       	mov    $0x11,%eax
  801099:	89 df                	mov    %ebx,%edi
  80109b:	89 de                	mov    %ebx,%esi
  80109d:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80109f:	5b                   	pop    %ebx
  8010a0:	5e                   	pop    %esi
  8010a1:	5f                   	pop    %edi
  8010a2:	5d                   	pop    %ebp
  8010a3:	c3                   	ret    

008010a4 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8010a4:	55                   	push   %ebp
  8010a5:	89 e5                	mov    %esp,%ebp
  8010a7:	57                   	push   %edi
  8010a8:	56                   	push   %esi
  8010a9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010af:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b5:	b8 12 00 00 00       	mov    $0x12,%eax
  8010ba:	89 df                	mov    %ebx,%edi
  8010bc:	89 de                	mov    %ebx,%esi
  8010be:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010c0:	5b                   	pop    %ebx
  8010c1:	5e                   	pop    %esi
  8010c2:	5f                   	pop    %edi
  8010c3:	5d                   	pop    %ebp
  8010c4:	c3                   	ret    

008010c5 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	57                   	push   %edi
  8010c9:	56                   	push   %esi
  8010ca:	53                   	push   %ebx
  8010cb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010ce:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d9:	b8 13 00 00 00       	mov    $0x13,%eax
  8010de:	89 df                	mov    %ebx,%edi
  8010e0:	89 de                	mov    %ebx,%esi
  8010e2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010e4:	85 c0                	test   %eax,%eax
  8010e6:	7f 08                	jg     8010f0 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010eb:	5b                   	pop    %ebx
  8010ec:	5e                   	pop    %esi
  8010ed:	5f                   	pop    %edi
  8010ee:	5d                   	pop    %ebp
  8010ef:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f0:	83 ec 0c             	sub    $0xc,%esp
  8010f3:	50                   	push   %eax
  8010f4:	6a 13                	push   $0x13
  8010f6:	68 08 2b 80 00       	push   $0x802b08
  8010fb:	6a 43                	push   $0x43
  8010fd:	68 25 2b 80 00       	push   $0x802b25
  801102:	e8 e4 f0 ff ff       	call   8001eb <_panic>

00801107 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	57                   	push   %edi
  80110b:	56                   	push   %esi
  80110c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80110d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801112:	8b 55 08             	mov    0x8(%ebp),%edx
  801115:	b8 14 00 00 00       	mov    $0x14,%eax
  80111a:	89 cb                	mov    %ecx,%ebx
  80111c:	89 cf                	mov    %ecx,%edi
  80111e:	89 ce                	mov    %ecx,%esi
  801120:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801122:	5b                   	pop    %ebx
  801123:	5e                   	pop    %esi
  801124:	5f                   	pop    %edi
  801125:	5d                   	pop    %ebp
  801126:	c3                   	ret    

00801127 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801127:	55                   	push   %ebp
  801128:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	05 00 00 00 30       	add    $0x30000000,%eax
  801132:	c1 e8 0c             	shr    $0xc,%eax
}
  801135:	5d                   	pop    %ebp
  801136:	c3                   	ret    

00801137 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801142:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801147:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80114c:	5d                   	pop    %ebp
  80114d:	c3                   	ret    

0080114e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
  801151:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801156:	89 c2                	mov    %eax,%edx
  801158:	c1 ea 16             	shr    $0x16,%edx
  80115b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801162:	f6 c2 01             	test   $0x1,%dl
  801165:	74 2d                	je     801194 <fd_alloc+0x46>
  801167:	89 c2                	mov    %eax,%edx
  801169:	c1 ea 0c             	shr    $0xc,%edx
  80116c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801173:	f6 c2 01             	test   $0x1,%dl
  801176:	74 1c                	je     801194 <fd_alloc+0x46>
  801178:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80117d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801182:	75 d2                	jne    801156 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80118d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801192:	eb 0a                	jmp    80119e <fd_alloc+0x50>
			*fd_store = fd;
  801194:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801197:	89 01                	mov    %eax,(%ecx)
			return 0;
  801199:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80119e:	5d                   	pop    %ebp
  80119f:	c3                   	ret    

008011a0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011a0:	55                   	push   %ebp
  8011a1:	89 e5                	mov    %esp,%ebp
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011a6:	83 f8 1f             	cmp    $0x1f,%eax
  8011a9:	77 30                	ja     8011db <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011ab:	c1 e0 0c             	shl    $0xc,%eax
  8011ae:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011b3:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8011b9:	f6 c2 01             	test   $0x1,%dl
  8011bc:	74 24                	je     8011e2 <fd_lookup+0x42>
  8011be:	89 c2                	mov    %eax,%edx
  8011c0:	c1 ea 0c             	shr    $0xc,%edx
  8011c3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011ca:	f6 c2 01             	test   $0x1,%dl
  8011cd:	74 1a                	je     8011e9 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d2:	89 02                	mov    %eax,(%edx)
	return 0;
  8011d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d9:	5d                   	pop    %ebp
  8011da:	c3                   	ret    
		return -E_INVAL;
  8011db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011e0:	eb f7                	jmp    8011d9 <fd_lookup+0x39>
		return -E_INVAL;
  8011e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011e7:	eb f0                	jmp    8011d9 <fd_lookup+0x39>
  8011e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ee:	eb e9                	jmp    8011d9 <fd_lookup+0x39>

008011f0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011f0:	55                   	push   %ebp
  8011f1:	89 e5                	mov    %esp,%ebp
  8011f3:	83 ec 08             	sub    $0x8,%esp
  8011f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8011f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8011fe:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801203:	39 08                	cmp    %ecx,(%eax)
  801205:	74 38                	je     80123f <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801207:	83 c2 01             	add    $0x1,%edx
  80120a:	8b 04 95 b4 2b 80 00 	mov    0x802bb4(,%edx,4),%eax
  801211:	85 c0                	test   %eax,%eax
  801213:	75 ee                	jne    801203 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801215:	a1 20 40 c0 00       	mov    0xc04020,%eax
  80121a:	8b 40 48             	mov    0x48(%eax),%eax
  80121d:	83 ec 04             	sub    $0x4,%esp
  801220:	51                   	push   %ecx
  801221:	50                   	push   %eax
  801222:	68 34 2b 80 00       	push   $0x802b34
  801227:	e8 b5 f0 ff ff       	call   8002e1 <cprintf>
	*dev = 0;
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801235:	83 c4 10             	add    $0x10,%esp
  801238:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80123d:	c9                   	leave  
  80123e:	c3                   	ret    
			*dev = devtab[i];
  80123f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801242:	89 01                	mov    %eax,(%ecx)
			return 0;
  801244:	b8 00 00 00 00       	mov    $0x0,%eax
  801249:	eb f2                	jmp    80123d <dev_lookup+0x4d>

0080124b <fd_close>:
{
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
  80124e:	57                   	push   %edi
  80124f:	56                   	push   %esi
  801250:	53                   	push   %ebx
  801251:	83 ec 24             	sub    $0x24,%esp
  801254:	8b 75 08             	mov    0x8(%ebp),%esi
  801257:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80125a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80125d:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80125e:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801264:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801267:	50                   	push   %eax
  801268:	e8 33 ff ff ff       	call   8011a0 <fd_lookup>
  80126d:	89 c3                	mov    %eax,%ebx
  80126f:	83 c4 10             	add    $0x10,%esp
  801272:	85 c0                	test   %eax,%eax
  801274:	78 05                	js     80127b <fd_close+0x30>
	    || fd != fd2)
  801276:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801279:	74 16                	je     801291 <fd_close+0x46>
		return (must_exist ? r : 0);
  80127b:	89 f8                	mov    %edi,%eax
  80127d:	84 c0                	test   %al,%al
  80127f:	b8 00 00 00 00       	mov    $0x0,%eax
  801284:	0f 44 d8             	cmove  %eax,%ebx
}
  801287:	89 d8                	mov    %ebx,%eax
  801289:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80128c:	5b                   	pop    %ebx
  80128d:	5e                   	pop    %esi
  80128e:	5f                   	pop    %edi
  80128f:	5d                   	pop    %ebp
  801290:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801291:	83 ec 08             	sub    $0x8,%esp
  801294:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801297:	50                   	push   %eax
  801298:	ff 36                	pushl  (%esi)
  80129a:	e8 51 ff ff ff       	call   8011f0 <dev_lookup>
  80129f:	89 c3                	mov    %eax,%ebx
  8012a1:	83 c4 10             	add    $0x10,%esp
  8012a4:	85 c0                	test   %eax,%eax
  8012a6:	78 1a                	js     8012c2 <fd_close+0x77>
		if (dev->dev_close)
  8012a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ab:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8012ae:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012b3:	85 c0                	test   %eax,%eax
  8012b5:	74 0b                	je     8012c2 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8012b7:	83 ec 0c             	sub    $0xc,%esp
  8012ba:	56                   	push   %esi
  8012bb:	ff d0                	call   *%eax
  8012bd:	89 c3                	mov    %eax,%ebx
  8012bf:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012c2:	83 ec 08             	sub    $0x8,%esp
  8012c5:	56                   	push   %esi
  8012c6:	6a 00                	push   $0x0
  8012c8:	e8 ea fb ff ff       	call   800eb7 <sys_page_unmap>
	return r;
  8012cd:	83 c4 10             	add    $0x10,%esp
  8012d0:	eb b5                	jmp    801287 <fd_close+0x3c>

008012d2 <close>:

int
close(int fdnum)
{
  8012d2:	55                   	push   %ebp
  8012d3:	89 e5                	mov    %esp,%ebp
  8012d5:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012db:	50                   	push   %eax
  8012dc:	ff 75 08             	pushl  0x8(%ebp)
  8012df:	e8 bc fe ff ff       	call   8011a0 <fd_lookup>
  8012e4:	83 c4 10             	add    $0x10,%esp
  8012e7:	85 c0                	test   %eax,%eax
  8012e9:	79 02                	jns    8012ed <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8012eb:	c9                   	leave  
  8012ec:	c3                   	ret    
		return fd_close(fd, 1);
  8012ed:	83 ec 08             	sub    $0x8,%esp
  8012f0:	6a 01                	push   $0x1
  8012f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8012f5:	e8 51 ff ff ff       	call   80124b <fd_close>
  8012fa:	83 c4 10             	add    $0x10,%esp
  8012fd:	eb ec                	jmp    8012eb <close+0x19>

008012ff <close_all>:

void
close_all(void)
{
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
  801302:	53                   	push   %ebx
  801303:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801306:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80130b:	83 ec 0c             	sub    $0xc,%esp
  80130e:	53                   	push   %ebx
  80130f:	e8 be ff ff ff       	call   8012d2 <close>
	for (i = 0; i < MAXFD; i++)
  801314:	83 c3 01             	add    $0x1,%ebx
  801317:	83 c4 10             	add    $0x10,%esp
  80131a:	83 fb 20             	cmp    $0x20,%ebx
  80131d:	75 ec                	jne    80130b <close_all+0xc>
}
  80131f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801322:	c9                   	leave  
  801323:	c3                   	ret    

00801324 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
  801327:	57                   	push   %edi
  801328:	56                   	push   %esi
  801329:	53                   	push   %ebx
  80132a:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80132d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801330:	50                   	push   %eax
  801331:	ff 75 08             	pushl  0x8(%ebp)
  801334:	e8 67 fe ff ff       	call   8011a0 <fd_lookup>
  801339:	89 c3                	mov    %eax,%ebx
  80133b:	83 c4 10             	add    $0x10,%esp
  80133e:	85 c0                	test   %eax,%eax
  801340:	0f 88 81 00 00 00    	js     8013c7 <dup+0xa3>
		return r;
	close(newfdnum);
  801346:	83 ec 0c             	sub    $0xc,%esp
  801349:	ff 75 0c             	pushl  0xc(%ebp)
  80134c:	e8 81 ff ff ff       	call   8012d2 <close>

	newfd = INDEX2FD(newfdnum);
  801351:	8b 75 0c             	mov    0xc(%ebp),%esi
  801354:	c1 e6 0c             	shl    $0xc,%esi
  801357:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80135d:	83 c4 04             	add    $0x4,%esp
  801360:	ff 75 e4             	pushl  -0x1c(%ebp)
  801363:	e8 cf fd ff ff       	call   801137 <fd2data>
  801368:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80136a:	89 34 24             	mov    %esi,(%esp)
  80136d:	e8 c5 fd ff ff       	call   801137 <fd2data>
  801372:	83 c4 10             	add    $0x10,%esp
  801375:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801377:	89 d8                	mov    %ebx,%eax
  801379:	c1 e8 16             	shr    $0x16,%eax
  80137c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801383:	a8 01                	test   $0x1,%al
  801385:	74 11                	je     801398 <dup+0x74>
  801387:	89 d8                	mov    %ebx,%eax
  801389:	c1 e8 0c             	shr    $0xc,%eax
  80138c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801393:	f6 c2 01             	test   $0x1,%dl
  801396:	75 39                	jne    8013d1 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801398:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80139b:	89 d0                	mov    %edx,%eax
  80139d:	c1 e8 0c             	shr    $0xc,%eax
  8013a0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013a7:	83 ec 0c             	sub    $0xc,%esp
  8013aa:	25 07 0e 00 00       	and    $0xe07,%eax
  8013af:	50                   	push   %eax
  8013b0:	56                   	push   %esi
  8013b1:	6a 00                	push   $0x0
  8013b3:	52                   	push   %edx
  8013b4:	6a 00                	push   $0x0
  8013b6:	e8 ba fa ff ff       	call   800e75 <sys_page_map>
  8013bb:	89 c3                	mov    %eax,%ebx
  8013bd:	83 c4 20             	add    $0x20,%esp
  8013c0:	85 c0                	test   %eax,%eax
  8013c2:	78 31                	js     8013f5 <dup+0xd1>
		goto err;

	return newfdnum;
  8013c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013c7:	89 d8                	mov    %ebx,%eax
  8013c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013cc:	5b                   	pop    %ebx
  8013cd:	5e                   	pop    %esi
  8013ce:	5f                   	pop    %edi
  8013cf:	5d                   	pop    %ebp
  8013d0:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013d1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013d8:	83 ec 0c             	sub    $0xc,%esp
  8013db:	25 07 0e 00 00       	and    $0xe07,%eax
  8013e0:	50                   	push   %eax
  8013e1:	57                   	push   %edi
  8013e2:	6a 00                	push   $0x0
  8013e4:	53                   	push   %ebx
  8013e5:	6a 00                	push   $0x0
  8013e7:	e8 89 fa ff ff       	call   800e75 <sys_page_map>
  8013ec:	89 c3                	mov    %eax,%ebx
  8013ee:	83 c4 20             	add    $0x20,%esp
  8013f1:	85 c0                	test   %eax,%eax
  8013f3:	79 a3                	jns    801398 <dup+0x74>
	sys_page_unmap(0, newfd);
  8013f5:	83 ec 08             	sub    $0x8,%esp
  8013f8:	56                   	push   %esi
  8013f9:	6a 00                	push   $0x0
  8013fb:	e8 b7 fa ff ff       	call   800eb7 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801400:	83 c4 08             	add    $0x8,%esp
  801403:	57                   	push   %edi
  801404:	6a 00                	push   $0x0
  801406:	e8 ac fa ff ff       	call   800eb7 <sys_page_unmap>
	return r;
  80140b:	83 c4 10             	add    $0x10,%esp
  80140e:	eb b7                	jmp    8013c7 <dup+0xa3>

00801410 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
  801413:	53                   	push   %ebx
  801414:	83 ec 1c             	sub    $0x1c,%esp
  801417:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80141a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80141d:	50                   	push   %eax
  80141e:	53                   	push   %ebx
  80141f:	e8 7c fd ff ff       	call   8011a0 <fd_lookup>
  801424:	83 c4 10             	add    $0x10,%esp
  801427:	85 c0                	test   %eax,%eax
  801429:	78 3f                	js     80146a <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80142b:	83 ec 08             	sub    $0x8,%esp
  80142e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801431:	50                   	push   %eax
  801432:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801435:	ff 30                	pushl  (%eax)
  801437:	e8 b4 fd ff ff       	call   8011f0 <dev_lookup>
  80143c:	83 c4 10             	add    $0x10,%esp
  80143f:	85 c0                	test   %eax,%eax
  801441:	78 27                	js     80146a <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801443:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801446:	8b 42 08             	mov    0x8(%edx),%eax
  801449:	83 e0 03             	and    $0x3,%eax
  80144c:	83 f8 01             	cmp    $0x1,%eax
  80144f:	74 1e                	je     80146f <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801454:	8b 40 08             	mov    0x8(%eax),%eax
  801457:	85 c0                	test   %eax,%eax
  801459:	74 35                	je     801490 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80145b:	83 ec 04             	sub    $0x4,%esp
  80145e:	ff 75 10             	pushl  0x10(%ebp)
  801461:	ff 75 0c             	pushl  0xc(%ebp)
  801464:	52                   	push   %edx
  801465:	ff d0                	call   *%eax
  801467:	83 c4 10             	add    $0x10,%esp
}
  80146a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80146d:	c9                   	leave  
  80146e:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80146f:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801474:	8b 40 48             	mov    0x48(%eax),%eax
  801477:	83 ec 04             	sub    $0x4,%esp
  80147a:	53                   	push   %ebx
  80147b:	50                   	push   %eax
  80147c:	68 78 2b 80 00       	push   $0x802b78
  801481:	e8 5b ee ff ff       	call   8002e1 <cprintf>
		return -E_INVAL;
  801486:	83 c4 10             	add    $0x10,%esp
  801489:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80148e:	eb da                	jmp    80146a <read+0x5a>
		return -E_NOT_SUPP;
  801490:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801495:	eb d3                	jmp    80146a <read+0x5a>

00801497 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	57                   	push   %edi
  80149b:	56                   	push   %esi
  80149c:	53                   	push   %ebx
  80149d:	83 ec 0c             	sub    $0xc,%esp
  8014a0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014a3:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014ab:	39 f3                	cmp    %esi,%ebx
  8014ad:	73 23                	jae    8014d2 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014af:	83 ec 04             	sub    $0x4,%esp
  8014b2:	89 f0                	mov    %esi,%eax
  8014b4:	29 d8                	sub    %ebx,%eax
  8014b6:	50                   	push   %eax
  8014b7:	89 d8                	mov    %ebx,%eax
  8014b9:	03 45 0c             	add    0xc(%ebp),%eax
  8014bc:	50                   	push   %eax
  8014bd:	57                   	push   %edi
  8014be:	e8 4d ff ff ff       	call   801410 <read>
		if (m < 0)
  8014c3:	83 c4 10             	add    $0x10,%esp
  8014c6:	85 c0                	test   %eax,%eax
  8014c8:	78 06                	js     8014d0 <readn+0x39>
			return m;
		if (m == 0)
  8014ca:	74 06                	je     8014d2 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8014cc:	01 c3                	add    %eax,%ebx
  8014ce:	eb db                	jmp    8014ab <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014d0:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014d2:	89 d8                	mov    %ebx,%eax
  8014d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014d7:	5b                   	pop    %ebx
  8014d8:	5e                   	pop    %esi
  8014d9:	5f                   	pop    %edi
  8014da:	5d                   	pop    %ebp
  8014db:	c3                   	ret    

008014dc <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
  8014df:	53                   	push   %ebx
  8014e0:	83 ec 1c             	sub    $0x1c,%esp
  8014e3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014e9:	50                   	push   %eax
  8014ea:	53                   	push   %ebx
  8014eb:	e8 b0 fc ff ff       	call   8011a0 <fd_lookup>
  8014f0:	83 c4 10             	add    $0x10,%esp
  8014f3:	85 c0                	test   %eax,%eax
  8014f5:	78 3a                	js     801531 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014f7:	83 ec 08             	sub    $0x8,%esp
  8014fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014fd:	50                   	push   %eax
  8014fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801501:	ff 30                	pushl  (%eax)
  801503:	e8 e8 fc ff ff       	call   8011f0 <dev_lookup>
  801508:	83 c4 10             	add    $0x10,%esp
  80150b:	85 c0                	test   %eax,%eax
  80150d:	78 22                	js     801531 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80150f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801512:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801516:	74 1e                	je     801536 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801518:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80151b:	8b 52 0c             	mov    0xc(%edx),%edx
  80151e:	85 d2                	test   %edx,%edx
  801520:	74 35                	je     801557 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801522:	83 ec 04             	sub    $0x4,%esp
  801525:	ff 75 10             	pushl  0x10(%ebp)
  801528:	ff 75 0c             	pushl  0xc(%ebp)
  80152b:	50                   	push   %eax
  80152c:	ff d2                	call   *%edx
  80152e:	83 c4 10             	add    $0x10,%esp
}
  801531:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801534:	c9                   	leave  
  801535:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801536:	a1 20 40 c0 00       	mov    0xc04020,%eax
  80153b:	8b 40 48             	mov    0x48(%eax),%eax
  80153e:	83 ec 04             	sub    $0x4,%esp
  801541:	53                   	push   %ebx
  801542:	50                   	push   %eax
  801543:	68 94 2b 80 00       	push   $0x802b94
  801548:	e8 94 ed ff ff       	call   8002e1 <cprintf>
		return -E_INVAL;
  80154d:	83 c4 10             	add    $0x10,%esp
  801550:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801555:	eb da                	jmp    801531 <write+0x55>
		return -E_NOT_SUPP;
  801557:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80155c:	eb d3                	jmp    801531 <write+0x55>

0080155e <seek>:

int
seek(int fdnum, off_t offset)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801564:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801567:	50                   	push   %eax
  801568:	ff 75 08             	pushl  0x8(%ebp)
  80156b:	e8 30 fc ff ff       	call   8011a0 <fd_lookup>
  801570:	83 c4 10             	add    $0x10,%esp
  801573:	85 c0                	test   %eax,%eax
  801575:	78 0e                	js     801585 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801577:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80157d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801580:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	53                   	push   %ebx
  80158b:	83 ec 1c             	sub    $0x1c,%esp
  80158e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801591:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801594:	50                   	push   %eax
  801595:	53                   	push   %ebx
  801596:	e8 05 fc ff ff       	call   8011a0 <fd_lookup>
  80159b:	83 c4 10             	add    $0x10,%esp
  80159e:	85 c0                	test   %eax,%eax
  8015a0:	78 37                	js     8015d9 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015a2:	83 ec 08             	sub    $0x8,%esp
  8015a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a8:	50                   	push   %eax
  8015a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ac:	ff 30                	pushl  (%eax)
  8015ae:	e8 3d fc ff ff       	call   8011f0 <dev_lookup>
  8015b3:	83 c4 10             	add    $0x10,%esp
  8015b6:	85 c0                	test   %eax,%eax
  8015b8:	78 1f                	js     8015d9 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015bd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015c1:	74 1b                	je     8015de <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c6:	8b 52 18             	mov    0x18(%edx),%edx
  8015c9:	85 d2                	test   %edx,%edx
  8015cb:	74 32                	je     8015ff <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015cd:	83 ec 08             	sub    $0x8,%esp
  8015d0:	ff 75 0c             	pushl  0xc(%ebp)
  8015d3:	50                   	push   %eax
  8015d4:	ff d2                	call   *%edx
  8015d6:	83 c4 10             	add    $0x10,%esp
}
  8015d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015de:	a1 20 40 c0 00       	mov    0xc04020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015e3:	8b 40 48             	mov    0x48(%eax),%eax
  8015e6:	83 ec 04             	sub    $0x4,%esp
  8015e9:	53                   	push   %ebx
  8015ea:	50                   	push   %eax
  8015eb:	68 54 2b 80 00       	push   $0x802b54
  8015f0:	e8 ec ec ff ff       	call   8002e1 <cprintf>
		return -E_INVAL;
  8015f5:	83 c4 10             	add    $0x10,%esp
  8015f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015fd:	eb da                	jmp    8015d9 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8015ff:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801604:	eb d3                	jmp    8015d9 <ftruncate+0x52>

00801606 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
  801609:	53                   	push   %ebx
  80160a:	83 ec 1c             	sub    $0x1c,%esp
  80160d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801610:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801613:	50                   	push   %eax
  801614:	ff 75 08             	pushl  0x8(%ebp)
  801617:	e8 84 fb ff ff       	call   8011a0 <fd_lookup>
  80161c:	83 c4 10             	add    $0x10,%esp
  80161f:	85 c0                	test   %eax,%eax
  801621:	78 4b                	js     80166e <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801623:	83 ec 08             	sub    $0x8,%esp
  801626:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801629:	50                   	push   %eax
  80162a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162d:	ff 30                	pushl  (%eax)
  80162f:	e8 bc fb ff ff       	call   8011f0 <dev_lookup>
  801634:	83 c4 10             	add    $0x10,%esp
  801637:	85 c0                	test   %eax,%eax
  801639:	78 33                	js     80166e <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80163b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801642:	74 2f                	je     801673 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801644:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801647:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80164e:	00 00 00 
	stat->st_isdir = 0;
  801651:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801658:	00 00 00 
	stat->st_dev = dev;
  80165b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801661:	83 ec 08             	sub    $0x8,%esp
  801664:	53                   	push   %ebx
  801665:	ff 75 f0             	pushl  -0x10(%ebp)
  801668:	ff 50 14             	call   *0x14(%eax)
  80166b:	83 c4 10             	add    $0x10,%esp
}
  80166e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801671:	c9                   	leave  
  801672:	c3                   	ret    
		return -E_NOT_SUPP;
  801673:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801678:	eb f4                	jmp    80166e <fstat+0x68>

0080167a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	56                   	push   %esi
  80167e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80167f:	83 ec 08             	sub    $0x8,%esp
  801682:	6a 00                	push   $0x0
  801684:	ff 75 08             	pushl  0x8(%ebp)
  801687:	e8 22 02 00 00       	call   8018ae <open>
  80168c:	89 c3                	mov    %eax,%ebx
  80168e:	83 c4 10             	add    $0x10,%esp
  801691:	85 c0                	test   %eax,%eax
  801693:	78 1b                	js     8016b0 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801695:	83 ec 08             	sub    $0x8,%esp
  801698:	ff 75 0c             	pushl  0xc(%ebp)
  80169b:	50                   	push   %eax
  80169c:	e8 65 ff ff ff       	call   801606 <fstat>
  8016a1:	89 c6                	mov    %eax,%esi
	close(fd);
  8016a3:	89 1c 24             	mov    %ebx,(%esp)
  8016a6:	e8 27 fc ff ff       	call   8012d2 <close>
	return r;
  8016ab:	83 c4 10             	add    $0x10,%esp
  8016ae:	89 f3                	mov    %esi,%ebx
}
  8016b0:	89 d8                	mov    %ebx,%eax
  8016b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016b5:	5b                   	pop    %ebx
  8016b6:	5e                   	pop    %esi
  8016b7:	5d                   	pop    %ebp
  8016b8:	c3                   	ret    

008016b9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
  8016bc:	56                   	push   %esi
  8016bd:	53                   	push   %ebx
  8016be:	89 c6                	mov    %eax,%esi
  8016c0:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016c2:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016c9:	74 27                	je     8016f2 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016cb:	6a 07                	push   $0x7
  8016cd:	68 00 50 c0 00       	push   $0xc05000
  8016d2:	56                   	push   %esi
  8016d3:	ff 35 00 40 80 00    	pushl  0x804000
  8016d9:	e8 08 0c 00 00       	call   8022e6 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016de:	83 c4 0c             	add    $0xc,%esp
  8016e1:	6a 00                	push   $0x0
  8016e3:	53                   	push   %ebx
  8016e4:	6a 00                	push   $0x0
  8016e6:	e8 92 0b 00 00       	call   80227d <ipc_recv>
}
  8016eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016ee:	5b                   	pop    %ebx
  8016ef:	5e                   	pop    %esi
  8016f0:	5d                   	pop    %ebp
  8016f1:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016f2:	83 ec 0c             	sub    $0xc,%esp
  8016f5:	6a 01                	push   $0x1
  8016f7:	e8 42 0c 00 00       	call   80233e <ipc_find_env>
  8016fc:	a3 00 40 80 00       	mov    %eax,0x804000
  801701:	83 c4 10             	add    $0x10,%esp
  801704:	eb c5                	jmp    8016cb <fsipc+0x12>

00801706 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
  801709:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80170c:	8b 45 08             	mov    0x8(%ebp),%eax
  80170f:	8b 40 0c             	mov    0xc(%eax),%eax
  801712:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.set_size.req_size = newsize;
  801717:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171a:	a3 04 50 c0 00       	mov    %eax,0xc05004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80171f:	ba 00 00 00 00       	mov    $0x0,%edx
  801724:	b8 02 00 00 00       	mov    $0x2,%eax
  801729:	e8 8b ff ff ff       	call   8016b9 <fsipc>
}
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <devfile_flush>:
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	8b 40 0c             	mov    0xc(%eax),%eax
  80173c:	a3 00 50 c0 00       	mov    %eax,0xc05000
	return fsipc(FSREQ_FLUSH, NULL);
  801741:	ba 00 00 00 00       	mov    $0x0,%edx
  801746:	b8 06 00 00 00       	mov    $0x6,%eax
  80174b:	e8 69 ff ff ff       	call   8016b9 <fsipc>
}
  801750:	c9                   	leave  
  801751:	c3                   	ret    

00801752 <devfile_stat>:
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
  801755:	53                   	push   %ebx
  801756:	83 ec 04             	sub    $0x4,%esp
  801759:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	8b 40 0c             	mov    0xc(%eax),%eax
  801762:	a3 00 50 c0 00       	mov    %eax,0xc05000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801767:	ba 00 00 00 00       	mov    $0x0,%edx
  80176c:	b8 05 00 00 00       	mov    $0x5,%eax
  801771:	e8 43 ff ff ff       	call   8016b9 <fsipc>
  801776:	85 c0                	test   %eax,%eax
  801778:	78 2c                	js     8017a6 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80177a:	83 ec 08             	sub    $0x8,%esp
  80177d:	68 00 50 c0 00       	push   $0xc05000
  801782:	53                   	push   %ebx
  801783:	e8 b8 f2 ff ff       	call   800a40 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801788:	a1 80 50 c0 00       	mov    0xc05080,%eax
  80178d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801793:	a1 84 50 c0 00       	mov    0xc05084,%eax
  801798:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80179e:	83 c4 10             	add    $0x10,%esp
  8017a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <devfile_write>:
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	53                   	push   %ebx
  8017af:	83 ec 08             	sub    $0x8,%esp
  8017b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8017bb:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.write.req_n = n;
  8017c0:	89 1d 04 50 c0 00    	mov    %ebx,0xc05004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8017c6:	53                   	push   %ebx
  8017c7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ca:	68 08 50 c0 00       	push   $0xc05008
  8017cf:	e8 5c f4 ff ff       	call   800c30 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d9:	b8 04 00 00 00       	mov    $0x4,%eax
  8017de:	e8 d6 fe ff ff       	call   8016b9 <fsipc>
  8017e3:	83 c4 10             	add    $0x10,%esp
  8017e6:	85 c0                	test   %eax,%eax
  8017e8:	78 0b                	js     8017f5 <devfile_write+0x4a>
	assert(r <= n);
  8017ea:	39 d8                	cmp    %ebx,%eax
  8017ec:	77 0c                	ja     8017fa <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8017ee:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017f3:	7f 1e                	jg     801813 <devfile_write+0x68>
}
  8017f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    
	assert(r <= n);
  8017fa:	68 c8 2b 80 00       	push   $0x802bc8
  8017ff:	68 cf 2b 80 00       	push   $0x802bcf
  801804:	68 98 00 00 00       	push   $0x98
  801809:	68 e4 2b 80 00       	push   $0x802be4
  80180e:	e8 d8 e9 ff ff       	call   8001eb <_panic>
	assert(r <= PGSIZE);
  801813:	68 ef 2b 80 00       	push   $0x802bef
  801818:	68 cf 2b 80 00       	push   $0x802bcf
  80181d:	68 99 00 00 00       	push   $0x99
  801822:	68 e4 2b 80 00       	push   $0x802be4
  801827:	e8 bf e9 ff ff       	call   8001eb <_panic>

0080182c <devfile_read>:
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
  80182f:	56                   	push   %esi
  801830:	53                   	push   %ebx
  801831:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801834:	8b 45 08             	mov    0x8(%ebp),%eax
  801837:	8b 40 0c             	mov    0xc(%eax),%eax
  80183a:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.read.req_n = n;
  80183f:	89 35 04 50 c0 00    	mov    %esi,0xc05004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801845:	ba 00 00 00 00       	mov    $0x0,%edx
  80184a:	b8 03 00 00 00       	mov    $0x3,%eax
  80184f:	e8 65 fe ff ff       	call   8016b9 <fsipc>
  801854:	89 c3                	mov    %eax,%ebx
  801856:	85 c0                	test   %eax,%eax
  801858:	78 1f                	js     801879 <devfile_read+0x4d>
	assert(r <= n);
  80185a:	39 f0                	cmp    %esi,%eax
  80185c:	77 24                	ja     801882 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80185e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801863:	7f 33                	jg     801898 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801865:	83 ec 04             	sub    $0x4,%esp
  801868:	50                   	push   %eax
  801869:	68 00 50 c0 00       	push   $0xc05000
  80186e:	ff 75 0c             	pushl  0xc(%ebp)
  801871:	e8 58 f3 ff ff       	call   800bce <memmove>
	return r;
  801876:	83 c4 10             	add    $0x10,%esp
}
  801879:	89 d8                	mov    %ebx,%eax
  80187b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80187e:	5b                   	pop    %ebx
  80187f:	5e                   	pop    %esi
  801880:	5d                   	pop    %ebp
  801881:	c3                   	ret    
	assert(r <= n);
  801882:	68 c8 2b 80 00       	push   $0x802bc8
  801887:	68 cf 2b 80 00       	push   $0x802bcf
  80188c:	6a 7c                	push   $0x7c
  80188e:	68 e4 2b 80 00       	push   $0x802be4
  801893:	e8 53 e9 ff ff       	call   8001eb <_panic>
	assert(r <= PGSIZE);
  801898:	68 ef 2b 80 00       	push   $0x802bef
  80189d:	68 cf 2b 80 00       	push   $0x802bcf
  8018a2:	6a 7d                	push   $0x7d
  8018a4:	68 e4 2b 80 00       	push   $0x802be4
  8018a9:	e8 3d e9 ff ff       	call   8001eb <_panic>

008018ae <open>:
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	56                   	push   %esi
  8018b2:	53                   	push   %ebx
  8018b3:	83 ec 1c             	sub    $0x1c,%esp
  8018b6:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018b9:	56                   	push   %esi
  8018ba:	e8 48 f1 ff ff       	call   800a07 <strlen>
  8018bf:	83 c4 10             	add    $0x10,%esp
  8018c2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018c7:	7f 6c                	jg     801935 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018c9:	83 ec 0c             	sub    $0xc,%esp
  8018cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018cf:	50                   	push   %eax
  8018d0:	e8 79 f8 ff ff       	call   80114e <fd_alloc>
  8018d5:	89 c3                	mov    %eax,%ebx
  8018d7:	83 c4 10             	add    $0x10,%esp
  8018da:	85 c0                	test   %eax,%eax
  8018dc:	78 3c                	js     80191a <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8018de:	83 ec 08             	sub    $0x8,%esp
  8018e1:	56                   	push   %esi
  8018e2:	68 00 50 c0 00       	push   $0xc05000
  8018e7:	e8 54 f1 ff ff       	call   800a40 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ef:	a3 00 54 c0 00       	mov    %eax,0xc05400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018f7:	b8 01 00 00 00       	mov    $0x1,%eax
  8018fc:	e8 b8 fd ff ff       	call   8016b9 <fsipc>
  801901:	89 c3                	mov    %eax,%ebx
  801903:	83 c4 10             	add    $0x10,%esp
  801906:	85 c0                	test   %eax,%eax
  801908:	78 19                	js     801923 <open+0x75>
	return fd2num(fd);
  80190a:	83 ec 0c             	sub    $0xc,%esp
  80190d:	ff 75 f4             	pushl  -0xc(%ebp)
  801910:	e8 12 f8 ff ff       	call   801127 <fd2num>
  801915:	89 c3                	mov    %eax,%ebx
  801917:	83 c4 10             	add    $0x10,%esp
}
  80191a:	89 d8                	mov    %ebx,%eax
  80191c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80191f:	5b                   	pop    %ebx
  801920:	5e                   	pop    %esi
  801921:	5d                   	pop    %ebp
  801922:	c3                   	ret    
		fd_close(fd, 0);
  801923:	83 ec 08             	sub    $0x8,%esp
  801926:	6a 00                	push   $0x0
  801928:	ff 75 f4             	pushl  -0xc(%ebp)
  80192b:	e8 1b f9 ff ff       	call   80124b <fd_close>
		return r;
  801930:	83 c4 10             	add    $0x10,%esp
  801933:	eb e5                	jmp    80191a <open+0x6c>
		return -E_BAD_PATH;
  801935:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80193a:	eb de                	jmp    80191a <open+0x6c>

0080193c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
  80193f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801942:	ba 00 00 00 00       	mov    $0x0,%edx
  801947:	b8 08 00 00 00       	mov    $0x8,%eax
  80194c:	e8 68 fd ff ff       	call   8016b9 <fsipc>
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    

00801953 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
  801956:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801959:	68 fb 2b 80 00       	push   $0x802bfb
  80195e:	ff 75 0c             	pushl  0xc(%ebp)
  801961:	e8 da f0 ff ff       	call   800a40 <strcpy>
	return 0;
}
  801966:	b8 00 00 00 00       	mov    $0x0,%eax
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <devsock_close>:
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
  801970:	53                   	push   %ebx
  801971:	83 ec 10             	sub    $0x10,%esp
  801974:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801977:	53                   	push   %ebx
  801978:	e8 00 0a 00 00       	call   80237d <pageref>
  80197d:	83 c4 10             	add    $0x10,%esp
		return 0;
  801980:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801985:	83 f8 01             	cmp    $0x1,%eax
  801988:	74 07                	je     801991 <devsock_close+0x24>
}
  80198a:	89 d0                	mov    %edx,%eax
  80198c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80198f:	c9                   	leave  
  801990:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801991:	83 ec 0c             	sub    $0xc,%esp
  801994:	ff 73 0c             	pushl  0xc(%ebx)
  801997:	e8 b9 02 00 00       	call   801c55 <nsipc_close>
  80199c:	89 c2                	mov    %eax,%edx
  80199e:	83 c4 10             	add    $0x10,%esp
  8019a1:	eb e7                	jmp    80198a <devsock_close+0x1d>

008019a3 <devsock_write>:
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
  8019a6:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019a9:	6a 00                	push   $0x0
  8019ab:	ff 75 10             	pushl  0x10(%ebp)
  8019ae:	ff 75 0c             	pushl  0xc(%ebp)
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	ff 70 0c             	pushl  0xc(%eax)
  8019b7:	e8 76 03 00 00       	call   801d32 <nsipc_send>
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <devsock_read>:
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019c4:	6a 00                	push   $0x0
  8019c6:	ff 75 10             	pushl  0x10(%ebp)
  8019c9:	ff 75 0c             	pushl  0xc(%ebp)
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cf:	ff 70 0c             	pushl  0xc(%eax)
  8019d2:	e8 ef 02 00 00       	call   801cc6 <nsipc_recv>
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <fd2sockid>:
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
  8019dc:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8019df:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8019e2:	52                   	push   %edx
  8019e3:	50                   	push   %eax
  8019e4:	e8 b7 f7 ff ff       	call   8011a0 <fd_lookup>
  8019e9:	83 c4 10             	add    $0x10,%esp
  8019ec:	85 c0                	test   %eax,%eax
  8019ee:	78 10                	js     801a00 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8019f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f3:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8019f9:	39 08                	cmp    %ecx,(%eax)
  8019fb:	75 05                	jne    801a02 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8019fd:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    
		return -E_NOT_SUPP;
  801a02:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a07:	eb f7                	jmp    801a00 <fd2sockid+0x27>

00801a09 <alloc_sockfd>:
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	56                   	push   %esi
  801a0d:	53                   	push   %ebx
  801a0e:	83 ec 1c             	sub    $0x1c,%esp
  801a11:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a13:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a16:	50                   	push   %eax
  801a17:	e8 32 f7 ff ff       	call   80114e <fd_alloc>
  801a1c:	89 c3                	mov    %eax,%ebx
  801a1e:	83 c4 10             	add    $0x10,%esp
  801a21:	85 c0                	test   %eax,%eax
  801a23:	78 43                	js     801a68 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a25:	83 ec 04             	sub    $0x4,%esp
  801a28:	68 07 04 00 00       	push   $0x407
  801a2d:	ff 75 f4             	pushl  -0xc(%ebp)
  801a30:	6a 00                	push   $0x0
  801a32:	e8 fb f3 ff ff       	call   800e32 <sys_page_alloc>
  801a37:	89 c3                	mov    %eax,%ebx
  801a39:	83 c4 10             	add    $0x10,%esp
  801a3c:	85 c0                	test   %eax,%eax
  801a3e:	78 28                	js     801a68 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a43:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a49:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a55:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a58:	83 ec 0c             	sub    $0xc,%esp
  801a5b:	50                   	push   %eax
  801a5c:	e8 c6 f6 ff ff       	call   801127 <fd2num>
  801a61:	89 c3                	mov    %eax,%ebx
  801a63:	83 c4 10             	add    $0x10,%esp
  801a66:	eb 0c                	jmp    801a74 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a68:	83 ec 0c             	sub    $0xc,%esp
  801a6b:	56                   	push   %esi
  801a6c:	e8 e4 01 00 00       	call   801c55 <nsipc_close>
		return r;
  801a71:	83 c4 10             	add    $0x10,%esp
}
  801a74:	89 d8                	mov    %ebx,%eax
  801a76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a79:	5b                   	pop    %ebx
  801a7a:	5e                   	pop    %esi
  801a7b:	5d                   	pop    %ebp
  801a7c:	c3                   	ret    

00801a7d <accept>:
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
  801a80:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a83:	8b 45 08             	mov    0x8(%ebp),%eax
  801a86:	e8 4e ff ff ff       	call   8019d9 <fd2sockid>
  801a8b:	85 c0                	test   %eax,%eax
  801a8d:	78 1b                	js     801aaa <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a8f:	83 ec 04             	sub    $0x4,%esp
  801a92:	ff 75 10             	pushl  0x10(%ebp)
  801a95:	ff 75 0c             	pushl  0xc(%ebp)
  801a98:	50                   	push   %eax
  801a99:	e8 0e 01 00 00       	call   801bac <nsipc_accept>
  801a9e:	83 c4 10             	add    $0x10,%esp
  801aa1:	85 c0                	test   %eax,%eax
  801aa3:	78 05                	js     801aaa <accept+0x2d>
	return alloc_sockfd(r);
  801aa5:	e8 5f ff ff ff       	call   801a09 <alloc_sockfd>
}
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <bind>:
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
  801aaf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab5:	e8 1f ff ff ff       	call   8019d9 <fd2sockid>
  801aba:	85 c0                	test   %eax,%eax
  801abc:	78 12                	js     801ad0 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801abe:	83 ec 04             	sub    $0x4,%esp
  801ac1:	ff 75 10             	pushl  0x10(%ebp)
  801ac4:	ff 75 0c             	pushl  0xc(%ebp)
  801ac7:	50                   	push   %eax
  801ac8:	e8 31 01 00 00       	call   801bfe <nsipc_bind>
  801acd:	83 c4 10             	add    $0x10,%esp
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <shutdown>:
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
  801ad5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  801adb:	e8 f9 fe ff ff       	call   8019d9 <fd2sockid>
  801ae0:	85 c0                	test   %eax,%eax
  801ae2:	78 0f                	js     801af3 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801ae4:	83 ec 08             	sub    $0x8,%esp
  801ae7:	ff 75 0c             	pushl  0xc(%ebp)
  801aea:	50                   	push   %eax
  801aeb:	e8 43 01 00 00       	call   801c33 <nsipc_shutdown>
  801af0:	83 c4 10             	add    $0x10,%esp
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <connect>:
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
  801af8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	e8 d6 fe ff ff       	call   8019d9 <fd2sockid>
  801b03:	85 c0                	test   %eax,%eax
  801b05:	78 12                	js     801b19 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b07:	83 ec 04             	sub    $0x4,%esp
  801b0a:	ff 75 10             	pushl  0x10(%ebp)
  801b0d:	ff 75 0c             	pushl  0xc(%ebp)
  801b10:	50                   	push   %eax
  801b11:	e8 59 01 00 00       	call   801c6f <nsipc_connect>
  801b16:	83 c4 10             	add    $0x10,%esp
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <listen>:
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
  801b1e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b21:	8b 45 08             	mov    0x8(%ebp),%eax
  801b24:	e8 b0 fe ff ff       	call   8019d9 <fd2sockid>
  801b29:	85 c0                	test   %eax,%eax
  801b2b:	78 0f                	js     801b3c <listen+0x21>
	return nsipc_listen(r, backlog);
  801b2d:	83 ec 08             	sub    $0x8,%esp
  801b30:	ff 75 0c             	pushl  0xc(%ebp)
  801b33:	50                   	push   %eax
  801b34:	e8 6b 01 00 00       	call   801ca4 <nsipc_listen>
  801b39:	83 c4 10             	add    $0x10,%esp
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <socket>:

int
socket(int domain, int type, int protocol)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
  801b41:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b44:	ff 75 10             	pushl  0x10(%ebp)
  801b47:	ff 75 0c             	pushl  0xc(%ebp)
  801b4a:	ff 75 08             	pushl  0x8(%ebp)
  801b4d:	e8 3e 02 00 00       	call   801d90 <nsipc_socket>
  801b52:	83 c4 10             	add    $0x10,%esp
  801b55:	85 c0                	test   %eax,%eax
  801b57:	78 05                	js     801b5e <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801b59:	e8 ab fe ff ff       	call   801a09 <alloc_sockfd>
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	53                   	push   %ebx
  801b64:	83 ec 04             	sub    $0x4,%esp
  801b67:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b69:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b70:	74 26                	je     801b98 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b72:	6a 07                	push   $0x7
  801b74:	68 00 60 c0 00       	push   $0xc06000
  801b79:	53                   	push   %ebx
  801b7a:	ff 35 04 40 80 00    	pushl  0x804004
  801b80:	e8 61 07 00 00       	call   8022e6 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b85:	83 c4 0c             	add    $0xc,%esp
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	e8 ea 06 00 00       	call   80227d <ipc_recv>
}
  801b93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b98:	83 ec 0c             	sub    $0xc,%esp
  801b9b:	6a 02                	push   $0x2
  801b9d:	e8 9c 07 00 00       	call   80233e <ipc_find_env>
  801ba2:	a3 04 40 80 00       	mov    %eax,0x804004
  801ba7:	83 c4 10             	add    $0x10,%esp
  801baa:	eb c6                	jmp    801b72 <nsipc+0x12>

00801bac <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	56                   	push   %esi
  801bb0:	53                   	push   %ebx
  801bb1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801bbc:	8b 06                	mov    (%esi),%eax
  801bbe:	a3 04 60 c0 00       	mov    %eax,0xc06004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801bc3:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc8:	e8 93 ff ff ff       	call   801b60 <nsipc>
  801bcd:	89 c3                	mov    %eax,%ebx
  801bcf:	85 c0                	test   %eax,%eax
  801bd1:	79 09                	jns    801bdc <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801bd3:	89 d8                	mov    %ebx,%eax
  801bd5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bd8:	5b                   	pop    %ebx
  801bd9:	5e                   	pop    %esi
  801bda:	5d                   	pop    %ebp
  801bdb:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801bdc:	83 ec 04             	sub    $0x4,%esp
  801bdf:	ff 35 10 60 c0 00    	pushl  0xc06010
  801be5:	68 00 60 c0 00       	push   $0xc06000
  801bea:	ff 75 0c             	pushl  0xc(%ebp)
  801bed:	e8 dc ef ff ff       	call   800bce <memmove>
		*addrlen = ret->ret_addrlen;
  801bf2:	a1 10 60 c0 00       	mov    0xc06010,%eax
  801bf7:	89 06                	mov    %eax,(%esi)
  801bf9:	83 c4 10             	add    $0x10,%esp
	return r;
  801bfc:	eb d5                	jmp    801bd3 <nsipc_accept+0x27>

00801bfe <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	53                   	push   %ebx
  801c02:	83 ec 08             	sub    $0x8,%esp
  801c05:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c08:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0b:	a3 00 60 c0 00       	mov    %eax,0xc06000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c10:	53                   	push   %ebx
  801c11:	ff 75 0c             	pushl  0xc(%ebp)
  801c14:	68 04 60 c0 00       	push   $0xc06004
  801c19:	e8 b0 ef ff ff       	call   800bce <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c1e:	89 1d 14 60 c0 00    	mov    %ebx,0xc06014
	return nsipc(NSREQ_BIND);
  801c24:	b8 02 00 00 00       	mov    $0x2,%eax
  801c29:	e8 32 ff ff ff       	call   801b60 <nsipc>
}
  801c2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
  801c36:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.shutdown.req_how = how;
  801c41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c44:	a3 04 60 c0 00       	mov    %eax,0xc06004
	return nsipc(NSREQ_SHUTDOWN);
  801c49:	b8 03 00 00 00       	mov    $0x3,%eax
  801c4e:	e8 0d ff ff ff       	call   801b60 <nsipc>
}
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <nsipc_close>:

int
nsipc_close(int s)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5e:	a3 00 60 c0 00       	mov    %eax,0xc06000
	return nsipc(NSREQ_CLOSE);
  801c63:	b8 04 00 00 00       	mov    $0x4,%eax
  801c68:	e8 f3 fe ff ff       	call   801b60 <nsipc>
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
  801c72:	53                   	push   %ebx
  801c73:	83 ec 08             	sub    $0x8,%esp
  801c76:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c79:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7c:	a3 00 60 c0 00       	mov    %eax,0xc06000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c81:	53                   	push   %ebx
  801c82:	ff 75 0c             	pushl  0xc(%ebp)
  801c85:	68 04 60 c0 00       	push   $0xc06004
  801c8a:	e8 3f ef ff ff       	call   800bce <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c8f:	89 1d 14 60 c0 00    	mov    %ebx,0xc06014
	return nsipc(NSREQ_CONNECT);
  801c95:	b8 05 00 00 00       	mov    $0x5,%eax
  801c9a:	e8 c1 fe ff ff       	call   801b60 <nsipc>
}
  801c9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ca2:	c9                   	leave  
  801ca3:	c3                   	ret    

00801ca4 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
  801ca7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801caa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cad:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.listen.req_backlog = backlog;
  801cb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb5:	a3 04 60 c0 00       	mov    %eax,0xc06004
	return nsipc(NSREQ_LISTEN);
  801cba:	b8 06 00 00 00       	mov    $0x6,%eax
  801cbf:	e8 9c fe ff ff       	call   801b60 <nsipc>
}
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
  801cc9:	56                   	push   %esi
  801cca:	53                   	push   %ebx
  801ccb:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801cce:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd1:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.recv.req_len = len;
  801cd6:	89 35 04 60 c0 00    	mov    %esi,0xc06004
	nsipcbuf.recv.req_flags = flags;
  801cdc:	8b 45 14             	mov    0x14(%ebp),%eax
  801cdf:	a3 08 60 c0 00       	mov    %eax,0xc06008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801ce4:	b8 07 00 00 00       	mov    $0x7,%eax
  801ce9:	e8 72 fe ff ff       	call   801b60 <nsipc>
  801cee:	89 c3                	mov    %eax,%ebx
  801cf0:	85 c0                	test   %eax,%eax
  801cf2:	78 1f                	js     801d13 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801cf4:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801cf9:	7f 21                	jg     801d1c <nsipc_recv+0x56>
  801cfb:	39 c6                	cmp    %eax,%esi
  801cfd:	7c 1d                	jl     801d1c <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801cff:	83 ec 04             	sub    $0x4,%esp
  801d02:	50                   	push   %eax
  801d03:	68 00 60 c0 00       	push   $0xc06000
  801d08:	ff 75 0c             	pushl  0xc(%ebp)
  801d0b:	e8 be ee ff ff       	call   800bce <memmove>
  801d10:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d13:	89 d8                	mov    %ebx,%eax
  801d15:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d18:	5b                   	pop    %ebx
  801d19:	5e                   	pop    %esi
  801d1a:	5d                   	pop    %ebp
  801d1b:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d1c:	68 07 2c 80 00       	push   $0x802c07
  801d21:	68 cf 2b 80 00       	push   $0x802bcf
  801d26:	6a 62                	push   $0x62
  801d28:	68 1c 2c 80 00       	push   $0x802c1c
  801d2d:	e8 b9 e4 ff ff       	call   8001eb <_panic>

00801d32 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
  801d35:	53                   	push   %ebx
  801d36:	83 ec 04             	sub    $0x4,%esp
  801d39:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3f:	a3 00 60 c0 00       	mov    %eax,0xc06000
	assert(size < 1600);
  801d44:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d4a:	7f 2e                	jg     801d7a <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d4c:	83 ec 04             	sub    $0x4,%esp
  801d4f:	53                   	push   %ebx
  801d50:	ff 75 0c             	pushl  0xc(%ebp)
  801d53:	68 0c 60 c0 00       	push   $0xc0600c
  801d58:	e8 71 ee ff ff       	call   800bce <memmove>
	nsipcbuf.send.req_size = size;
  801d5d:	89 1d 04 60 c0 00    	mov    %ebx,0xc06004
	nsipcbuf.send.req_flags = flags;
  801d63:	8b 45 14             	mov    0x14(%ebp),%eax
  801d66:	a3 08 60 c0 00       	mov    %eax,0xc06008
	return nsipc(NSREQ_SEND);
  801d6b:	b8 08 00 00 00       	mov    $0x8,%eax
  801d70:	e8 eb fd ff ff       	call   801b60 <nsipc>
}
  801d75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    
	assert(size < 1600);
  801d7a:	68 28 2c 80 00       	push   $0x802c28
  801d7f:	68 cf 2b 80 00       	push   $0x802bcf
  801d84:	6a 6d                	push   $0x6d
  801d86:	68 1c 2c 80 00       	push   $0x802c1c
  801d8b:	e8 5b e4 ff ff       	call   8001eb <_panic>

00801d90 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d96:	8b 45 08             	mov    0x8(%ebp),%eax
  801d99:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.socket.req_type = type;
  801d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da1:	a3 04 60 c0 00       	mov    %eax,0xc06004
	nsipcbuf.socket.req_protocol = protocol;
  801da6:	8b 45 10             	mov    0x10(%ebp),%eax
  801da9:	a3 08 60 c0 00       	mov    %eax,0xc06008
	return nsipc(NSREQ_SOCKET);
  801dae:	b8 09 00 00 00       	mov    $0x9,%eax
  801db3:	e8 a8 fd ff ff       	call   801b60 <nsipc>
}
  801db8:	c9                   	leave  
  801db9:	c3                   	ret    

00801dba <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
  801dbd:	56                   	push   %esi
  801dbe:	53                   	push   %ebx
  801dbf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801dc2:	83 ec 0c             	sub    $0xc,%esp
  801dc5:	ff 75 08             	pushl  0x8(%ebp)
  801dc8:	e8 6a f3 ff ff       	call   801137 <fd2data>
  801dcd:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801dcf:	83 c4 08             	add    $0x8,%esp
  801dd2:	68 34 2c 80 00       	push   $0x802c34
  801dd7:	53                   	push   %ebx
  801dd8:	e8 63 ec ff ff       	call   800a40 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ddd:	8b 46 04             	mov    0x4(%esi),%eax
  801de0:	2b 06                	sub    (%esi),%eax
  801de2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801de8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801def:	00 00 00 
	stat->st_dev = &devpipe;
  801df2:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801df9:	30 80 00 
	return 0;
}
  801dfc:	b8 00 00 00 00       	mov    $0x0,%eax
  801e01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e04:	5b                   	pop    %ebx
  801e05:	5e                   	pop    %esi
  801e06:	5d                   	pop    %ebp
  801e07:	c3                   	ret    

00801e08 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
  801e0b:	53                   	push   %ebx
  801e0c:	83 ec 0c             	sub    $0xc,%esp
  801e0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e12:	53                   	push   %ebx
  801e13:	6a 00                	push   $0x0
  801e15:	e8 9d f0 ff ff       	call   800eb7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e1a:	89 1c 24             	mov    %ebx,(%esp)
  801e1d:	e8 15 f3 ff ff       	call   801137 <fd2data>
  801e22:	83 c4 08             	add    $0x8,%esp
  801e25:	50                   	push   %eax
  801e26:	6a 00                	push   $0x0
  801e28:	e8 8a f0 ff ff       	call   800eb7 <sys_page_unmap>
}
  801e2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <_pipeisclosed>:
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	57                   	push   %edi
  801e36:	56                   	push   %esi
  801e37:	53                   	push   %ebx
  801e38:	83 ec 1c             	sub    $0x1c,%esp
  801e3b:	89 c7                	mov    %eax,%edi
  801e3d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e3f:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801e44:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e47:	83 ec 0c             	sub    $0xc,%esp
  801e4a:	57                   	push   %edi
  801e4b:	e8 2d 05 00 00       	call   80237d <pageref>
  801e50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e53:	89 34 24             	mov    %esi,(%esp)
  801e56:	e8 22 05 00 00       	call   80237d <pageref>
		nn = thisenv->env_runs;
  801e5b:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  801e61:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e64:	83 c4 10             	add    $0x10,%esp
  801e67:	39 cb                	cmp    %ecx,%ebx
  801e69:	74 1b                	je     801e86 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e6b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e6e:	75 cf                	jne    801e3f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e70:	8b 42 58             	mov    0x58(%edx),%eax
  801e73:	6a 01                	push   $0x1
  801e75:	50                   	push   %eax
  801e76:	53                   	push   %ebx
  801e77:	68 3b 2c 80 00       	push   $0x802c3b
  801e7c:	e8 60 e4 ff ff       	call   8002e1 <cprintf>
  801e81:	83 c4 10             	add    $0x10,%esp
  801e84:	eb b9                	jmp    801e3f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e86:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e89:	0f 94 c0             	sete   %al
  801e8c:	0f b6 c0             	movzbl %al,%eax
}
  801e8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e92:	5b                   	pop    %ebx
  801e93:	5e                   	pop    %esi
  801e94:	5f                   	pop    %edi
  801e95:	5d                   	pop    %ebp
  801e96:	c3                   	ret    

00801e97 <devpipe_write>:
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	57                   	push   %edi
  801e9b:	56                   	push   %esi
  801e9c:	53                   	push   %ebx
  801e9d:	83 ec 28             	sub    $0x28,%esp
  801ea0:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801ea3:	56                   	push   %esi
  801ea4:	e8 8e f2 ff ff       	call   801137 <fd2data>
  801ea9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801eab:	83 c4 10             	add    $0x10,%esp
  801eae:	bf 00 00 00 00       	mov    $0x0,%edi
  801eb3:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801eb6:	74 4f                	je     801f07 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801eb8:	8b 43 04             	mov    0x4(%ebx),%eax
  801ebb:	8b 0b                	mov    (%ebx),%ecx
  801ebd:	8d 51 20             	lea    0x20(%ecx),%edx
  801ec0:	39 d0                	cmp    %edx,%eax
  801ec2:	72 14                	jb     801ed8 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ec4:	89 da                	mov    %ebx,%edx
  801ec6:	89 f0                	mov    %esi,%eax
  801ec8:	e8 65 ff ff ff       	call   801e32 <_pipeisclosed>
  801ecd:	85 c0                	test   %eax,%eax
  801ecf:	75 3b                	jne    801f0c <devpipe_write+0x75>
			sys_yield();
  801ed1:	e8 3d ef ff ff       	call   800e13 <sys_yield>
  801ed6:	eb e0                	jmp    801eb8 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ed8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801edb:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801edf:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ee2:	89 c2                	mov    %eax,%edx
  801ee4:	c1 fa 1f             	sar    $0x1f,%edx
  801ee7:	89 d1                	mov    %edx,%ecx
  801ee9:	c1 e9 1b             	shr    $0x1b,%ecx
  801eec:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801eef:	83 e2 1f             	and    $0x1f,%edx
  801ef2:	29 ca                	sub    %ecx,%edx
  801ef4:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ef8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801efc:	83 c0 01             	add    $0x1,%eax
  801eff:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f02:	83 c7 01             	add    $0x1,%edi
  801f05:	eb ac                	jmp    801eb3 <devpipe_write+0x1c>
	return i;
  801f07:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0a:	eb 05                	jmp    801f11 <devpipe_write+0x7a>
				return 0;
  801f0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f14:	5b                   	pop    %ebx
  801f15:	5e                   	pop    %esi
  801f16:	5f                   	pop    %edi
  801f17:	5d                   	pop    %ebp
  801f18:	c3                   	ret    

00801f19 <devpipe_read>:
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
  801f1c:	57                   	push   %edi
  801f1d:	56                   	push   %esi
  801f1e:	53                   	push   %ebx
  801f1f:	83 ec 18             	sub    $0x18,%esp
  801f22:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f25:	57                   	push   %edi
  801f26:	e8 0c f2 ff ff       	call   801137 <fd2data>
  801f2b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f2d:	83 c4 10             	add    $0x10,%esp
  801f30:	be 00 00 00 00       	mov    $0x0,%esi
  801f35:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f38:	75 14                	jne    801f4e <devpipe_read+0x35>
	return i;
  801f3a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f3d:	eb 02                	jmp    801f41 <devpipe_read+0x28>
				return i;
  801f3f:	89 f0                	mov    %esi,%eax
}
  801f41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f44:	5b                   	pop    %ebx
  801f45:	5e                   	pop    %esi
  801f46:	5f                   	pop    %edi
  801f47:	5d                   	pop    %ebp
  801f48:	c3                   	ret    
			sys_yield();
  801f49:	e8 c5 ee ff ff       	call   800e13 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801f4e:	8b 03                	mov    (%ebx),%eax
  801f50:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f53:	75 18                	jne    801f6d <devpipe_read+0x54>
			if (i > 0)
  801f55:	85 f6                	test   %esi,%esi
  801f57:	75 e6                	jne    801f3f <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801f59:	89 da                	mov    %ebx,%edx
  801f5b:	89 f8                	mov    %edi,%eax
  801f5d:	e8 d0 fe ff ff       	call   801e32 <_pipeisclosed>
  801f62:	85 c0                	test   %eax,%eax
  801f64:	74 e3                	je     801f49 <devpipe_read+0x30>
				return 0;
  801f66:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6b:	eb d4                	jmp    801f41 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f6d:	99                   	cltd   
  801f6e:	c1 ea 1b             	shr    $0x1b,%edx
  801f71:	01 d0                	add    %edx,%eax
  801f73:	83 e0 1f             	and    $0x1f,%eax
  801f76:	29 d0                	sub    %edx,%eax
  801f78:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f80:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f83:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f86:	83 c6 01             	add    $0x1,%esi
  801f89:	eb aa                	jmp    801f35 <devpipe_read+0x1c>

00801f8b <pipe>:
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	56                   	push   %esi
  801f8f:	53                   	push   %ebx
  801f90:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f93:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f96:	50                   	push   %eax
  801f97:	e8 b2 f1 ff ff       	call   80114e <fd_alloc>
  801f9c:	89 c3                	mov    %eax,%ebx
  801f9e:	83 c4 10             	add    $0x10,%esp
  801fa1:	85 c0                	test   %eax,%eax
  801fa3:	0f 88 23 01 00 00    	js     8020cc <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fa9:	83 ec 04             	sub    $0x4,%esp
  801fac:	68 07 04 00 00       	push   $0x407
  801fb1:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb4:	6a 00                	push   $0x0
  801fb6:	e8 77 ee ff ff       	call   800e32 <sys_page_alloc>
  801fbb:	89 c3                	mov    %eax,%ebx
  801fbd:	83 c4 10             	add    $0x10,%esp
  801fc0:	85 c0                	test   %eax,%eax
  801fc2:	0f 88 04 01 00 00    	js     8020cc <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801fc8:	83 ec 0c             	sub    $0xc,%esp
  801fcb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fce:	50                   	push   %eax
  801fcf:	e8 7a f1 ff ff       	call   80114e <fd_alloc>
  801fd4:	89 c3                	mov    %eax,%ebx
  801fd6:	83 c4 10             	add    $0x10,%esp
  801fd9:	85 c0                	test   %eax,%eax
  801fdb:	0f 88 db 00 00 00    	js     8020bc <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fe1:	83 ec 04             	sub    $0x4,%esp
  801fe4:	68 07 04 00 00       	push   $0x407
  801fe9:	ff 75 f0             	pushl  -0x10(%ebp)
  801fec:	6a 00                	push   $0x0
  801fee:	e8 3f ee ff ff       	call   800e32 <sys_page_alloc>
  801ff3:	89 c3                	mov    %eax,%ebx
  801ff5:	83 c4 10             	add    $0x10,%esp
  801ff8:	85 c0                	test   %eax,%eax
  801ffa:	0f 88 bc 00 00 00    	js     8020bc <pipe+0x131>
	va = fd2data(fd0);
  802000:	83 ec 0c             	sub    $0xc,%esp
  802003:	ff 75 f4             	pushl  -0xc(%ebp)
  802006:	e8 2c f1 ff ff       	call   801137 <fd2data>
  80200b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80200d:	83 c4 0c             	add    $0xc,%esp
  802010:	68 07 04 00 00       	push   $0x407
  802015:	50                   	push   %eax
  802016:	6a 00                	push   $0x0
  802018:	e8 15 ee ff ff       	call   800e32 <sys_page_alloc>
  80201d:	89 c3                	mov    %eax,%ebx
  80201f:	83 c4 10             	add    $0x10,%esp
  802022:	85 c0                	test   %eax,%eax
  802024:	0f 88 82 00 00 00    	js     8020ac <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80202a:	83 ec 0c             	sub    $0xc,%esp
  80202d:	ff 75 f0             	pushl  -0x10(%ebp)
  802030:	e8 02 f1 ff ff       	call   801137 <fd2data>
  802035:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80203c:	50                   	push   %eax
  80203d:	6a 00                	push   $0x0
  80203f:	56                   	push   %esi
  802040:	6a 00                	push   $0x0
  802042:	e8 2e ee ff ff       	call   800e75 <sys_page_map>
  802047:	89 c3                	mov    %eax,%ebx
  802049:	83 c4 20             	add    $0x20,%esp
  80204c:	85 c0                	test   %eax,%eax
  80204e:	78 4e                	js     80209e <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802050:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802055:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802058:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80205a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80205d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802064:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802067:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802069:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80206c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802073:	83 ec 0c             	sub    $0xc,%esp
  802076:	ff 75 f4             	pushl  -0xc(%ebp)
  802079:	e8 a9 f0 ff ff       	call   801127 <fd2num>
  80207e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802081:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802083:	83 c4 04             	add    $0x4,%esp
  802086:	ff 75 f0             	pushl  -0x10(%ebp)
  802089:	e8 99 f0 ff ff       	call   801127 <fd2num>
  80208e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802091:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802094:	83 c4 10             	add    $0x10,%esp
  802097:	bb 00 00 00 00       	mov    $0x0,%ebx
  80209c:	eb 2e                	jmp    8020cc <pipe+0x141>
	sys_page_unmap(0, va);
  80209e:	83 ec 08             	sub    $0x8,%esp
  8020a1:	56                   	push   %esi
  8020a2:	6a 00                	push   $0x0
  8020a4:	e8 0e ee ff ff       	call   800eb7 <sys_page_unmap>
  8020a9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8020ac:	83 ec 08             	sub    $0x8,%esp
  8020af:	ff 75 f0             	pushl  -0x10(%ebp)
  8020b2:	6a 00                	push   $0x0
  8020b4:	e8 fe ed ff ff       	call   800eb7 <sys_page_unmap>
  8020b9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8020bc:	83 ec 08             	sub    $0x8,%esp
  8020bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8020c2:	6a 00                	push   $0x0
  8020c4:	e8 ee ed ff ff       	call   800eb7 <sys_page_unmap>
  8020c9:	83 c4 10             	add    $0x10,%esp
}
  8020cc:	89 d8                	mov    %ebx,%eax
  8020ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020d1:	5b                   	pop    %ebx
  8020d2:	5e                   	pop    %esi
  8020d3:	5d                   	pop    %ebp
  8020d4:	c3                   	ret    

008020d5 <pipeisclosed>:
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
  8020d8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020de:	50                   	push   %eax
  8020df:	ff 75 08             	pushl  0x8(%ebp)
  8020e2:	e8 b9 f0 ff ff       	call   8011a0 <fd_lookup>
  8020e7:	83 c4 10             	add    $0x10,%esp
  8020ea:	85 c0                	test   %eax,%eax
  8020ec:	78 18                	js     802106 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8020ee:	83 ec 0c             	sub    $0xc,%esp
  8020f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8020f4:	e8 3e f0 ff ff       	call   801137 <fd2data>
	return _pipeisclosed(fd, p);
  8020f9:	89 c2                	mov    %eax,%edx
  8020fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fe:	e8 2f fd ff ff       	call   801e32 <_pipeisclosed>
  802103:	83 c4 10             	add    $0x10,%esp
}
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802108:	b8 00 00 00 00       	mov    $0x0,%eax
  80210d:	c3                   	ret    

0080210e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802114:	68 53 2c 80 00       	push   $0x802c53
  802119:	ff 75 0c             	pushl  0xc(%ebp)
  80211c:	e8 1f e9 ff ff       	call   800a40 <strcpy>
	return 0;
}
  802121:	b8 00 00 00 00       	mov    $0x0,%eax
  802126:	c9                   	leave  
  802127:	c3                   	ret    

00802128 <devcons_write>:
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
  80212b:	57                   	push   %edi
  80212c:	56                   	push   %esi
  80212d:	53                   	push   %ebx
  80212e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802134:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802139:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80213f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802142:	73 31                	jae    802175 <devcons_write+0x4d>
		m = n - tot;
  802144:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802147:	29 f3                	sub    %esi,%ebx
  802149:	83 fb 7f             	cmp    $0x7f,%ebx
  80214c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802151:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802154:	83 ec 04             	sub    $0x4,%esp
  802157:	53                   	push   %ebx
  802158:	89 f0                	mov    %esi,%eax
  80215a:	03 45 0c             	add    0xc(%ebp),%eax
  80215d:	50                   	push   %eax
  80215e:	57                   	push   %edi
  80215f:	e8 6a ea ff ff       	call   800bce <memmove>
		sys_cputs(buf, m);
  802164:	83 c4 08             	add    $0x8,%esp
  802167:	53                   	push   %ebx
  802168:	57                   	push   %edi
  802169:	e8 08 ec ff ff       	call   800d76 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80216e:	01 de                	add    %ebx,%esi
  802170:	83 c4 10             	add    $0x10,%esp
  802173:	eb ca                	jmp    80213f <devcons_write+0x17>
}
  802175:	89 f0                	mov    %esi,%eax
  802177:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80217a:	5b                   	pop    %ebx
  80217b:	5e                   	pop    %esi
  80217c:	5f                   	pop    %edi
  80217d:	5d                   	pop    %ebp
  80217e:	c3                   	ret    

0080217f <devcons_read>:
{
  80217f:	55                   	push   %ebp
  802180:	89 e5                	mov    %esp,%ebp
  802182:	83 ec 08             	sub    $0x8,%esp
  802185:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80218a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80218e:	74 21                	je     8021b1 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802190:	e8 ff eb ff ff       	call   800d94 <sys_cgetc>
  802195:	85 c0                	test   %eax,%eax
  802197:	75 07                	jne    8021a0 <devcons_read+0x21>
		sys_yield();
  802199:	e8 75 ec ff ff       	call   800e13 <sys_yield>
  80219e:	eb f0                	jmp    802190 <devcons_read+0x11>
	if (c < 0)
  8021a0:	78 0f                	js     8021b1 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8021a2:	83 f8 04             	cmp    $0x4,%eax
  8021a5:	74 0c                	je     8021b3 <devcons_read+0x34>
	*(char*)vbuf = c;
  8021a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021aa:	88 02                	mov    %al,(%edx)
	return 1;
  8021ac:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8021b1:	c9                   	leave  
  8021b2:	c3                   	ret    
		return 0;
  8021b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b8:	eb f7                	jmp    8021b1 <devcons_read+0x32>

008021ba <cputchar>:
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
  8021bd:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8021c6:	6a 01                	push   $0x1
  8021c8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021cb:	50                   	push   %eax
  8021cc:	e8 a5 eb ff ff       	call   800d76 <sys_cputs>
}
  8021d1:	83 c4 10             	add    $0x10,%esp
  8021d4:	c9                   	leave  
  8021d5:	c3                   	ret    

008021d6 <getchar>:
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
  8021d9:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8021dc:	6a 01                	push   $0x1
  8021de:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021e1:	50                   	push   %eax
  8021e2:	6a 00                	push   $0x0
  8021e4:	e8 27 f2 ff ff       	call   801410 <read>
	if (r < 0)
  8021e9:	83 c4 10             	add    $0x10,%esp
  8021ec:	85 c0                	test   %eax,%eax
  8021ee:	78 06                	js     8021f6 <getchar+0x20>
	if (r < 1)
  8021f0:	74 06                	je     8021f8 <getchar+0x22>
	return c;
  8021f2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8021f6:	c9                   	leave  
  8021f7:	c3                   	ret    
		return -E_EOF;
  8021f8:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8021fd:	eb f7                	jmp    8021f6 <getchar+0x20>

008021ff <iscons>:
{
  8021ff:	55                   	push   %ebp
  802200:	89 e5                	mov    %esp,%ebp
  802202:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802205:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802208:	50                   	push   %eax
  802209:	ff 75 08             	pushl  0x8(%ebp)
  80220c:	e8 8f ef ff ff       	call   8011a0 <fd_lookup>
  802211:	83 c4 10             	add    $0x10,%esp
  802214:	85 c0                	test   %eax,%eax
  802216:	78 11                	js     802229 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802218:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802221:	39 10                	cmp    %edx,(%eax)
  802223:	0f 94 c0             	sete   %al
  802226:	0f b6 c0             	movzbl %al,%eax
}
  802229:	c9                   	leave  
  80222a:	c3                   	ret    

0080222b <opencons>:
{
  80222b:	55                   	push   %ebp
  80222c:	89 e5                	mov    %esp,%ebp
  80222e:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802231:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802234:	50                   	push   %eax
  802235:	e8 14 ef ff ff       	call   80114e <fd_alloc>
  80223a:	83 c4 10             	add    $0x10,%esp
  80223d:	85 c0                	test   %eax,%eax
  80223f:	78 3a                	js     80227b <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802241:	83 ec 04             	sub    $0x4,%esp
  802244:	68 07 04 00 00       	push   $0x407
  802249:	ff 75 f4             	pushl  -0xc(%ebp)
  80224c:	6a 00                	push   $0x0
  80224e:	e8 df eb ff ff       	call   800e32 <sys_page_alloc>
  802253:	83 c4 10             	add    $0x10,%esp
  802256:	85 c0                	test   %eax,%eax
  802258:	78 21                	js     80227b <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80225a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225d:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802263:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802268:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80226f:	83 ec 0c             	sub    $0xc,%esp
  802272:	50                   	push   %eax
  802273:	e8 af ee ff ff       	call   801127 <fd2num>
  802278:	83 c4 10             	add    $0x10,%esp
}
  80227b:	c9                   	leave  
  80227c:	c3                   	ret    

0080227d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80227d:	55                   	push   %ebp
  80227e:	89 e5                	mov    %esp,%ebp
  802280:	56                   	push   %esi
  802281:	53                   	push   %ebx
  802282:	8b 75 08             	mov    0x8(%ebp),%esi
  802285:	8b 45 0c             	mov    0xc(%ebp),%eax
  802288:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80228b:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80228d:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802292:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802295:	83 ec 0c             	sub    $0xc,%esp
  802298:	50                   	push   %eax
  802299:	e8 44 ed ff ff       	call   800fe2 <sys_ipc_recv>
	if(ret < 0){
  80229e:	83 c4 10             	add    $0x10,%esp
  8022a1:	85 c0                	test   %eax,%eax
  8022a3:	78 2b                	js     8022d0 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8022a5:	85 f6                	test   %esi,%esi
  8022a7:	74 0a                	je     8022b3 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8022a9:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8022ae:	8b 40 78             	mov    0x78(%eax),%eax
  8022b1:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8022b3:	85 db                	test   %ebx,%ebx
  8022b5:	74 0a                	je     8022c1 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8022b7:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8022bc:	8b 40 7c             	mov    0x7c(%eax),%eax
  8022bf:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8022c1:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8022c6:	8b 40 74             	mov    0x74(%eax),%eax
}
  8022c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022cc:	5b                   	pop    %ebx
  8022cd:	5e                   	pop    %esi
  8022ce:	5d                   	pop    %ebp
  8022cf:	c3                   	ret    
		if(from_env_store)
  8022d0:	85 f6                	test   %esi,%esi
  8022d2:	74 06                	je     8022da <ipc_recv+0x5d>
			*from_env_store = 0;
  8022d4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8022da:	85 db                	test   %ebx,%ebx
  8022dc:	74 eb                	je     8022c9 <ipc_recv+0x4c>
			*perm_store = 0;
  8022de:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022e4:	eb e3                	jmp    8022c9 <ipc_recv+0x4c>

008022e6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8022e6:	55                   	push   %ebp
  8022e7:	89 e5                	mov    %esp,%ebp
  8022e9:	57                   	push   %edi
  8022ea:	56                   	push   %esi
  8022eb:	53                   	push   %ebx
  8022ec:	83 ec 0c             	sub    $0xc,%esp
  8022ef:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022f2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022f5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8022f8:	85 db                	test   %ebx,%ebx
  8022fa:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8022ff:	0f 44 d8             	cmove  %eax,%ebx
  802302:	eb 05                	jmp    802309 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802304:	e8 0a eb ff ff       	call   800e13 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802309:	ff 75 14             	pushl  0x14(%ebp)
  80230c:	53                   	push   %ebx
  80230d:	56                   	push   %esi
  80230e:	57                   	push   %edi
  80230f:	e8 ab ec ff ff       	call   800fbf <sys_ipc_try_send>
  802314:	83 c4 10             	add    $0x10,%esp
  802317:	85 c0                	test   %eax,%eax
  802319:	74 1b                	je     802336 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80231b:	79 e7                	jns    802304 <ipc_send+0x1e>
  80231d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802320:	74 e2                	je     802304 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802322:	83 ec 04             	sub    $0x4,%esp
  802325:	68 5f 2c 80 00       	push   $0x802c5f
  80232a:	6a 46                	push   $0x46
  80232c:	68 74 2c 80 00       	push   $0x802c74
  802331:	e8 b5 de ff ff       	call   8001eb <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802336:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802339:	5b                   	pop    %ebx
  80233a:	5e                   	pop    %esi
  80233b:	5f                   	pop    %edi
  80233c:	5d                   	pop    %ebp
  80233d:	c3                   	ret    

0080233e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
  802341:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802344:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802349:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80234f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802355:	8b 52 50             	mov    0x50(%edx),%edx
  802358:	39 ca                	cmp    %ecx,%edx
  80235a:	74 11                	je     80236d <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80235c:	83 c0 01             	add    $0x1,%eax
  80235f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802364:	75 e3                	jne    802349 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802366:	b8 00 00 00 00       	mov    $0x0,%eax
  80236b:	eb 0e                	jmp    80237b <ipc_find_env+0x3d>
			return envs[i].env_id;
  80236d:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802373:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802378:	8b 40 48             	mov    0x48(%eax),%eax
}
  80237b:	5d                   	pop    %ebp
  80237c:	c3                   	ret    

0080237d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80237d:	55                   	push   %ebp
  80237e:	89 e5                	mov    %esp,%ebp
  802380:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802383:	89 d0                	mov    %edx,%eax
  802385:	c1 e8 16             	shr    $0x16,%eax
  802388:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80238f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802394:	f6 c1 01             	test   $0x1,%cl
  802397:	74 1d                	je     8023b6 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802399:	c1 ea 0c             	shr    $0xc,%edx
  80239c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023a3:	f6 c2 01             	test   $0x1,%dl
  8023a6:	74 0e                	je     8023b6 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023a8:	c1 ea 0c             	shr    $0xc,%edx
  8023ab:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023b2:	ef 
  8023b3:	0f b7 c0             	movzwl %ax,%eax
}
  8023b6:	5d                   	pop    %ebp
  8023b7:	c3                   	ret    
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
