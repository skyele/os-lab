
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
  800039:	68 a0 25 80 00       	push   $0x8025a0
  80003e:	e8 4b 02 00 00       	call   80028e <cprintf>
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
  800090:	68 e8 25 80 00       	push   $0x8025e8
  800095:	e8 f4 01 00 00       	call   80028e <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  80009a:	c7 05 20 50 c0 00 00 	movl   $0x0,0xc05020
  8000a1:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  8000a4:	83 c4 0c             	add    $0xc,%esp
  8000a7:	68 47 26 80 00       	push   $0x802647
  8000ac:	6a 1a                	push   $0x1a
  8000ae:	68 38 26 80 00       	push   $0x802638
  8000b3:	e8 e0 00 00 00       	call   800198 <_panic>
			panic("bigarray[%d] isn't cleared!\n", i);
  8000b8:	50                   	push   %eax
  8000b9:	68 1b 26 80 00       	push   $0x80261b
  8000be:	6a 11                	push   $0x11
  8000c0:	68 38 26 80 00       	push   $0x802638
  8000c5:	e8 ce 00 00 00       	call   800198 <_panic>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000ca:	50                   	push   %eax
  8000cb:	68 c0 25 80 00       	push   $0x8025c0
  8000d0:	6a 16                	push   $0x16
  8000d2:	68 38 26 80 00       	push   $0x802638
  8000d7:	e8 bc 00 00 00       	call   800198 <_panic>

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
  8000ef:	e8 ad 0c 00 00       	call   800da1 <sys_getenvid>
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

	cprintf("call umain!\n");
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	68 5e 26 80 00       	push   $0x80265e
  80015b:	e8 2e 01 00 00       	call   80028e <cprintf>
	// call user main routine
	umain(argc, argv);
  800160:	83 c4 08             	add    $0x8,%esp
  800163:	ff 75 0c             	pushl  0xc(%ebp)
  800166:	ff 75 08             	pushl  0x8(%ebp)
  800169:	e8 c5 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80016e:	e8 0b 00 00 00       	call   80017e <exit>
}
  800173:	83 c4 10             	add    $0x10,%esp
  800176:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800179:	5b                   	pop    %ebx
  80017a:	5e                   	pop    %esi
  80017b:	5f                   	pop    %edi
  80017c:	5d                   	pop    %ebp
  80017d:	c3                   	ret    

0080017e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80017e:	55                   	push   %ebp
  80017f:	89 e5                	mov    %esp,%ebp
  800181:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800184:	e8 03 11 00 00       	call   80128c <close_all>
	sys_env_destroy(0);
  800189:	83 ec 0c             	sub    $0xc,%esp
  80018c:	6a 00                	push   $0x0
  80018e:	e8 cd 0b 00 00       	call   800d60 <sys_env_destroy>
}
  800193:	83 c4 10             	add    $0x10,%esp
  800196:	c9                   	leave  
  800197:	c3                   	ret    

00800198 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800198:	55                   	push   %ebp
  800199:	89 e5                	mov    %esp,%ebp
  80019b:	56                   	push   %esi
  80019c:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80019d:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8001a2:	8b 40 48             	mov    0x48(%eax),%eax
  8001a5:	83 ec 04             	sub    $0x4,%esp
  8001a8:	68 a4 26 80 00       	push   $0x8026a4
  8001ad:	50                   	push   %eax
  8001ae:	68 75 26 80 00       	push   $0x802675
  8001b3:	e8 d6 00 00 00       	call   80028e <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8001b8:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001bb:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8001c1:	e8 db 0b 00 00       	call   800da1 <sys_getenvid>
  8001c6:	83 c4 04             	add    $0x4,%esp
  8001c9:	ff 75 0c             	pushl  0xc(%ebp)
  8001cc:	ff 75 08             	pushl  0x8(%ebp)
  8001cf:	56                   	push   %esi
  8001d0:	50                   	push   %eax
  8001d1:	68 80 26 80 00       	push   $0x802680
  8001d6:	e8 b3 00 00 00       	call   80028e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001db:	83 c4 18             	add    $0x18,%esp
  8001de:	53                   	push   %ebx
  8001df:	ff 75 10             	pushl  0x10(%ebp)
  8001e2:	e8 56 00 00 00       	call   80023d <vcprintf>
	cprintf("\n");
  8001e7:	c7 04 24 36 26 80 00 	movl   $0x802636,(%esp)
  8001ee:	e8 9b 00 00 00       	call   80028e <cprintf>
  8001f3:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001f6:	cc                   	int3   
  8001f7:	eb fd                	jmp    8001f6 <_panic+0x5e>

008001f9 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001f9:	55                   	push   %ebp
  8001fa:	89 e5                	mov    %esp,%ebp
  8001fc:	53                   	push   %ebx
  8001fd:	83 ec 04             	sub    $0x4,%esp
  800200:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800203:	8b 13                	mov    (%ebx),%edx
  800205:	8d 42 01             	lea    0x1(%edx),%eax
  800208:	89 03                	mov    %eax,(%ebx)
  80020a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80020d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800211:	3d ff 00 00 00       	cmp    $0xff,%eax
  800216:	74 09                	je     800221 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800218:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80021c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80021f:	c9                   	leave  
  800220:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800221:	83 ec 08             	sub    $0x8,%esp
  800224:	68 ff 00 00 00       	push   $0xff
  800229:	8d 43 08             	lea    0x8(%ebx),%eax
  80022c:	50                   	push   %eax
  80022d:	e8 f1 0a 00 00       	call   800d23 <sys_cputs>
		b->idx = 0;
  800232:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800238:	83 c4 10             	add    $0x10,%esp
  80023b:	eb db                	jmp    800218 <putch+0x1f>

0080023d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80023d:	55                   	push   %ebp
  80023e:	89 e5                	mov    %esp,%ebp
  800240:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800246:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80024d:	00 00 00 
	b.cnt = 0;
  800250:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800257:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80025a:	ff 75 0c             	pushl  0xc(%ebp)
  80025d:	ff 75 08             	pushl  0x8(%ebp)
  800260:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800266:	50                   	push   %eax
  800267:	68 f9 01 80 00       	push   $0x8001f9
  80026c:	e8 4a 01 00 00       	call   8003bb <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800271:	83 c4 08             	add    $0x8,%esp
  800274:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80027a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800280:	50                   	push   %eax
  800281:	e8 9d 0a 00 00       	call   800d23 <sys_cputs>

	return b.cnt;
}
  800286:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80028c:	c9                   	leave  
  80028d:	c3                   	ret    

0080028e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800294:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800297:	50                   	push   %eax
  800298:	ff 75 08             	pushl  0x8(%ebp)
  80029b:	e8 9d ff ff ff       	call   80023d <vcprintf>
	va_end(ap);

	return cnt;
}
  8002a0:	c9                   	leave  
  8002a1:	c3                   	ret    

008002a2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002a2:	55                   	push   %ebp
  8002a3:	89 e5                	mov    %esp,%ebp
  8002a5:	57                   	push   %edi
  8002a6:	56                   	push   %esi
  8002a7:	53                   	push   %ebx
  8002a8:	83 ec 1c             	sub    $0x1c,%esp
  8002ab:	89 c6                	mov    %eax,%esi
  8002ad:	89 d7                	mov    %edx,%edi
  8002af:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002b8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8002be:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8002c1:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002c5:	74 2c                	je     8002f3 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8002c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002ca:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002d1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002d4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002d7:	39 c2                	cmp    %eax,%edx
  8002d9:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002dc:	73 43                	jae    800321 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002de:	83 eb 01             	sub    $0x1,%ebx
  8002e1:	85 db                	test   %ebx,%ebx
  8002e3:	7e 6c                	jle    800351 <printnum+0xaf>
				putch(padc, putdat);
  8002e5:	83 ec 08             	sub    $0x8,%esp
  8002e8:	57                   	push   %edi
  8002e9:	ff 75 18             	pushl  0x18(%ebp)
  8002ec:	ff d6                	call   *%esi
  8002ee:	83 c4 10             	add    $0x10,%esp
  8002f1:	eb eb                	jmp    8002de <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002f3:	83 ec 0c             	sub    $0xc,%esp
  8002f6:	6a 20                	push   $0x20
  8002f8:	6a 00                	push   $0x0
  8002fa:	50                   	push   %eax
  8002fb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002fe:	ff 75 e0             	pushl  -0x20(%ebp)
  800301:	89 fa                	mov    %edi,%edx
  800303:	89 f0                	mov    %esi,%eax
  800305:	e8 98 ff ff ff       	call   8002a2 <printnum>
		while (--width > 0)
  80030a:	83 c4 20             	add    $0x20,%esp
  80030d:	83 eb 01             	sub    $0x1,%ebx
  800310:	85 db                	test   %ebx,%ebx
  800312:	7e 65                	jle    800379 <printnum+0xd7>
			putch(padc, putdat);
  800314:	83 ec 08             	sub    $0x8,%esp
  800317:	57                   	push   %edi
  800318:	6a 20                	push   $0x20
  80031a:	ff d6                	call   *%esi
  80031c:	83 c4 10             	add    $0x10,%esp
  80031f:	eb ec                	jmp    80030d <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800321:	83 ec 0c             	sub    $0xc,%esp
  800324:	ff 75 18             	pushl  0x18(%ebp)
  800327:	83 eb 01             	sub    $0x1,%ebx
  80032a:	53                   	push   %ebx
  80032b:	50                   	push   %eax
  80032c:	83 ec 08             	sub    $0x8,%esp
  80032f:	ff 75 dc             	pushl  -0x24(%ebp)
  800332:	ff 75 d8             	pushl  -0x28(%ebp)
  800335:	ff 75 e4             	pushl  -0x1c(%ebp)
  800338:	ff 75 e0             	pushl  -0x20(%ebp)
  80033b:	e8 10 20 00 00       	call   802350 <__udivdi3>
  800340:	83 c4 18             	add    $0x18,%esp
  800343:	52                   	push   %edx
  800344:	50                   	push   %eax
  800345:	89 fa                	mov    %edi,%edx
  800347:	89 f0                	mov    %esi,%eax
  800349:	e8 54 ff ff ff       	call   8002a2 <printnum>
  80034e:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800351:	83 ec 08             	sub    $0x8,%esp
  800354:	57                   	push   %edi
  800355:	83 ec 04             	sub    $0x4,%esp
  800358:	ff 75 dc             	pushl  -0x24(%ebp)
  80035b:	ff 75 d8             	pushl  -0x28(%ebp)
  80035e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800361:	ff 75 e0             	pushl  -0x20(%ebp)
  800364:	e8 f7 20 00 00       	call   802460 <__umoddi3>
  800369:	83 c4 14             	add    $0x14,%esp
  80036c:	0f be 80 ab 26 80 00 	movsbl 0x8026ab(%eax),%eax
  800373:	50                   	push   %eax
  800374:	ff d6                	call   *%esi
  800376:	83 c4 10             	add    $0x10,%esp
	}
}
  800379:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80037c:	5b                   	pop    %ebx
  80037d:	5e                   	pop    %esi
  80037e:	5f                   	pop    %edi
  80037f:	5d                   	pop    %ebp
  800380:	c3                   	ret    

00800381 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800381:	55                   	push   %ebp
  800382:	89 e5                	mov    %esp,%ebp
  800384:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800387:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80038b:	8b 10                	mov    (%eax),%edx
  80038d:	3b 50 04             	cmp    0x4(%eax),%edx
  800390:	73 0a                	jae    80039c <sprintputch+0x1b>
		*b->buf++ = ch;
  800392:	8d 4a 01             	lea    0x1(%edx),%ecx
  800395:	89 08                	mov    %ecx,(%eax)
  800397:	8b 45 08             	mov    0x8(%ebp),%eax
  80039a:	88 02                	mov    %al,(%edx)
}
  80039c:	5d                   	pop    %ebp
  80039d:	c3                   	ret    

0080039e <printfmt>:
{
  80039e:	55                   	push   %ebp
  80039f:	89 e5                	mov    %esp,%ebp
  8003a1:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003a4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003a7:	50                   	push   %eax
  8003a8:	ff 75 10             	pushl  0x10(%ebp)
  8003ab:	ff 75 0c             	pushl  0xc(%ebp)
  8003ae:	ff 75 08             	pushl  0x8(%ebp)
  8003b1:	e8 05 00 00 00       	call   8003bb <vprintfmt>
}
  8003b6:	83 c4 10             	add    $0x10,%esp
  8003b9:	c9                   	leave  
  8003ba:	c3                   	ret    

008003bb <vprintfmt>:
{
  8003bb:	55                   	push   %ebp
  8003bc:	89 e5                	mov    %esp,%ebp
  8003be:	57                   	push   %edi
  8003bf:	56                   	push   %esi
  8003c0:	53                   	push   %ebx
  8003c1:	83 ec 3c             	sub    $0x3c,%esp
  8003c4:	8b 75 08             	mov    0x8(%ebp),%esi
  8003c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003ca:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003cd:	e9 32 04 00 00       	jmp    800804 <vprintfmt+0x449>
		padc = ' ';
  8003d2:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003d6:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003dd:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003e4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003eb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003f2:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003f9:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003fe:	8d 47 01             	lea    0x1(%edi),%eax
  800401:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800404:	0f b6 17             	movzbl (%edi),%edx
  800407:	8d 42 dd             	lea    -0x23(%edx),%eax
  80040a:	3c 55                	cmp    $0x55,%al
  80040c:	0f 87 12 05 00 00    	ja     800924 <vprintfmt+0x569>
  800412:	0f b6 c0             	movzbl %al,%eax
  800415:	ff 24 85 80 28 80 00 	jmp    *0x802880(,%eax,4)
  80041c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80041f:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800423:	eb d9                	jmp    8003fe <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800425:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800428:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80042c:	eb d0                	jmp    8003fe <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80042e:	0f b6 d2             	movzbl %dl,%edx
  800431:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800434:	b8 00 00 00 00       	mov    $0x0,%eax
  800439:	89 75 08             	mov    %esi,0x8(%ebp)
  80043c:	eb 03                	jmp    800441 <vprintfmt+0x86>
  80043e:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800441:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800444:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800448:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80044b:	8d 72 d0             	lea    -0x30(%edx),%esi
  80044e:	83 fe 09             	cmp    $0x9,%esi
  800451:	76 eb                	jbe    80043e <vprintfmt+0x83>
  800453:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800456:	8b 75 08             	mov    0x8(%ebp),%esi
  800459:	eb 14                	jmp    80046f <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80045b:	8b 45 14             	mov    0x14(%ebp),%eax
  80045e:	8b 00                	mov    (%eax),%eax
  800460:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800463:	8b 45 14             	mov    0x14(%ebp),%eax
  800466:	8d 40 04             	lea    0x4(%eax),%eax
  800469:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80046c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80046f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800473:	79 89                	jns    8003fe <vprintfmt+0x43>
				width = precision, precision = -1;
  800475:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800478:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80047b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800482:	e9 77 ff ff ff       	jmp    8003fe <vprintfmt+0x43>
  800487:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80048a:	85 c0                	test   %eax,%eax
  80048c:	0f 48 c1             	cmovs  %ecx,%eax
  80048f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800492:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800495:	e9 64 ff ff ff       	jmp    8003fe <vprintfmt+0x43>
  80049a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80049d:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004a4:	e9 55 ff ff ff       	jmp    8003fe <vprintfmt+0x43>
			lflag++;
  8004a9:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004b0:	e9 49 ff ff ff       	jmp    8003fe <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b8:	8d 78 04             	lea    0x4(%eax),%edi
  8004bb:	83 ec 08             	sub    $0x8,%esp
  8004be:	53                   	push   %ebx
  8004bf:	ff 30                	pushl  (%eax)
  8004c1:	ff d6                	call   *%esi
			break;
  8004c3:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004c6:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004c9:	e9 33 03 00 00       	jmp    800801 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d1:	8d 78 04             	lea    0x4(%eax),%edi
  8004d4:	8b 00                	mov    (%eax),%eax
  8004d6:	99                   	cltd   
  8004d7:	31 d0                	xor    %edx,%eax
  8004d9:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004db:	83 f8 10             	cmp    $0x10,%eax
  8004de:	7f 23                	jg     800503 <vprintfmt+0x148>
  8004e0:	8b 14 85 e0 29 80 00 	mov    0x8029e0(,%eax,4),%edx
  8004e7:	85 d2                	test   %edx,%edx
  8004e9:	74 18                	je     800503 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004eb:	52                   	push   %edx
  8004ec:	68 fd 2a 80 00       	push   $0x802afd
  8004f1:	53                   	push   %ebx
  8004f2:	56                   	push   %esi
  8004f3:	e8 a6 fe ff ff       	call   80039e <printfmt>
  8004f8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004fb:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004fe:	e9 fe 02 00 00       	jmp    800801 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800503:	50                   	push   %eax
  800504:	68 c3 26 80 00       	push   $0x8026c3
  800509:	53                   	push   %ebx
  80050a:	56                   	push   %esi
  80050b:	e8 8e fe ff ff       	call   80039e <printfmt>
  800510:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800513:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800516:	e9 e6 02 00 00       	jmp    800801 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	83 c0 04             	add    $0x4,%eax
  800521:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800524:	8b 45 14             	mov    0x14(%ebp),%eax
  800527:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800529:	85 c9                	test   %ecx,%ecx
  80052b:	b8 bc 26 80 00       	mov    $0x8026bc,%eax
  800530:	0f 45 c1             	cmovne %ecx,%eax
  800533:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800536:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80053a:	7e 06                	jle    800542 <vprintfmt+0x187>
  80053c:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800540:	75 0d                	jne    80054f <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800542:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800545:	89 c7                	mov    %eax,%edi
  800547:	03 45 e0             	add    -0x20(%ebp),%eax
  80054a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80054d:	eb 53                	jmp    8005a2 <vprintfmt+0x1e7>
  80054f:	83 ec 08             	sub    $0x8,%esp
  800552:	ff 75 d8             	pushl  -0x28(%ebp)
  800555:	50                   	push   %eax
  800556:	e8 71 04 00 00       	call   8009cc <strnlen>
  80055b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80055e:	29 c1                	sub    %eax,%ecx
  800560:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800563:	83 c4 10             	add    $0x10,%esp
  800566:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800568:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80056c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80056f:	eb 0f                	jmp    800580 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800571:	83 ec 08             	sub    $0x8,%esp
  800574:	53                   	push   %ebx
  800575:	ff 75 e0             	pushl  -0x20(%ebp)
  800578:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80057a:	83 ef 01             	sub    $0x1,%edi
  80057d:	83 c4 10             	add    $0x10,%esp
  800580:	85 ff                	test   %edi,%edi
  800582:	7f ed                	jg     800571 <vprintfmt+0x1b6>
  800584:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800587:	85 c9                	test   %ecx,%ecx
  800589:	b8 00 00 00 00       	mov    $0x0,%eax
  80058e:	0f 49 c1             	cmovns %ecx,%eax
  800591:	29 c1                	sub    %eax,%ecx
  800593:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800596:	eb aa                	jmp    800542 <vprintfmt+0x187>
					putch(ch, putdat);
  800598:	83 ec 08             	sub    $0x8,%esp
  80059b:	53                   	push   %ebx
  80059c:	52                   	push   %edx
  80059d:	ff d6                	call   *%esi
  80059f:	83 c4 10             	add    $0x10,%esp
  8005a2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005a5:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005a7:	83 c7 01             	add    $0x1,%edi
  8005aa:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005ae:	0f be d0             	movsbl %al,%edx
  8005b1:	85 d2                	test   %edx,%edx
  8005b3:	74 4b                	je     800600 <vprintfmt+0x245>
  8005b5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005b9:	78 06                	js     8005c1 <vprintfmt+0x206>
  8005bb:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005bf:	78 1e                	js     8005df <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8005c1:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005c5:	74 d1                	je     800598 <vprintfmt+0x1dd>
  8005c7:	0f be c0             	movsbl %al,%eax
  8005ca:	83 e8 20             	sub    $0x20,%eax
  8005cd:	83 f8 5e             	cmp    $0x5e,%eax
  8005d0:	76 c6                	jbe    800598 <vprintfmt+0x1dd>
					putch('?', putdat);
  8005d2:	83 ec 08             	sub    $0x8,%esp
  8005d5:	53                   	push   %ebx
  8005d6:	6a 3f                	push   $0x3f
  8005d8:	ff d6                	call   *%esi
  8005da:	83 c4 10             	add    $0x10,%esp
  8005dd:	eb c3                	jmp    8005a2 <vprintfmt+0x1e7>
  8005df:	89 cf                	mov    %ecx,%edi
  8005e1:	eb 0e                	jmp    8005f1 <vprintfmt+0x236>
				putch(' ', putdat);
  8005e3:	83 ec 08             	sub    $0x8,%esp
  8005e6:	53                   	push   %ebx
  8005e7:	6a 20                	push   $0x20
  8005e9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005eb:	83 ef 01             	sub    $0x1,%edi
  8005ee:	83 c4 10             	add    $0x10,%esp
  8005f1:	85 ff                	test   %edi,%edi
  8005f3:	7f ee                	jg     8005e3 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005f5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005fb:	e9 01 02 00 00       	jmp    800801 <vprintfmt+0x446>
  800600:	89 cf                	mov    %ecx,%edi
  800602:	eb ed                	jmp    8005f1 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800604:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800607:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80060e:	e9 eb fd ff ff       	jmp    8003fe <vprintfmt+0x43>
	if (lflag >= 2)
  800613:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800617:	7f 21                	jg     80063a <vprintfmt+0x27f>
	else if (lflag)
  800619:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80061d:	74 68                	je     800687 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80061f:	8b 45 14             	mov    0x14(%ebp),%eax
  800622:	8b 00                	mov    (%eax),%eax
  800624:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800627:	89 c1                	mov    %eax,%ecx
  800629:	c1 f9 1f             	sar    $0x1f,%ecx
  80062c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80062f:	8b 45 14             	mov    0x14(%ebp),%eax
  800632:	8d 40 04             	lea    0x4(%eax),%eax
  800635:	89 45 14             	mov    %eax,0x14(%ebp)
  800638:	eb 17                	jmp    800651 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8b 50 04             	mov    0x4(%eax),%edx
  800640:	8b 00                	mov    (%eax),%eax
  800642:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800645:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	8d 40 08             	lea    0x8(%eax),%eax
  80064e:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800651:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800654:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800657:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80065d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800661:	78 3f                	js     8006a2 <vprintfmt+0x2e7>
			base = 10;
  800663:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800668:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80066c:	0f 84 71 01 00 00    	je     8007e3 <vprintfmt+0x428>
				putch('+', putdat);
  800672:	83 ec 08             	sub    $0x8,%esp
  800675:	53                   	push   %ebx
  800676:	6a 2b                	push   $0x2b
  800678:	ff d6                	call   *%esi
  80067a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80067d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800682:	e9 5c 01 00 00       	jmp    8007e3 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800687:	8b 45 14             	mov    0x14(%ebp),%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80068f:	89 c1                	mov    %eax,%ecx
  800691:	c1 f9 1f             	sar    $0x1f,%ecx
  800694:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8d 40 04             	lea    0x4(%eax),%eax
  80069d:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a0:	eb af                	jmp    800651 <vprintfmt+0x296>
				putch('-', putdat);
  8006a2:	83 ec 08             	sub    $0x8,%esp
  8006a5:	53                   	push   %ebx
  8006a6:	6a 2d                	push   $0x2d
  8006a8:	ff d6                	call   *%esi
				num = -(long long) num;
  8006aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006ad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006b0:	f7 d8                	neg    %eax
  8006b2:	83 d2 00             	adc    $0x0,%edx
  8006b5:	f7 da                	neg    %edx
  8006b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ba:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006bd:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006c0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c5:	e9 19 01 00 00       	jmp    8007e3 <vprintfmt+0x428>
	if (lflag >= 2)
  8006ca:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006ce:	7f 29                	jg     8006f9 <vprintfmt+0x33e>
	else if (lflag)
  8006d0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006d4:	74 44                	je     80071a <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e9:	8d 40 04             	lea    0x4(%eax),%eax
  8006ec:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ef:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006f4:	e9 ea 00 00 00       	jmp    8007e3 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fc:	8b 50 04             	mov    0x4(%eax),%edx
  8006ff:	8b 00                	mov    (%eax),%eax
  800701:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800704:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800707:	8b 45 14             	mov    0x14(%ebp),%eax
  80070a:	8d 40 08             	lea    0x8(%eax),%eax
  80070d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800710:	b8 0a 00 00 00       	mov    $0xa,%eax
  800715:	e9 c9 00 00 00       	jmp    8007e3 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80071a:	8b 45 14             	mov    0x14(%ebp),%eax
  80071d:	8b 00                	mov    (%eax),%eax
  80071f:	ba 00 00 00 00       	mov    $0x0,%edx
  800724:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800727:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80072a:	8b 45 14             	mov    0x14(%ebp),%eax
  80072d:	8d 40 04             	lea    0x4(%eax),%eax
  800730:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800733:	b8 0a 00 00 00       	mov    $0xa,%eax
  800738:	e9 a6 00 00 00       	jmp    8007e3 <vprintfmt+0x428>
			putch('0', putdat);
  80073d:	83 ec 08             	sub    $0x8,%esp
  800740:	53                   	push   %ebx
  800741:	6a 30                	push   $0x30
  800743:	ff d6                	call   *%esi
	if (lflag >= 2)
  800745:	83 c4 10             	add    $0x10,%esp
  800748:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80074c:	7f 26                	jg     800774 <vprintfmt+0x3b9>
	else if (lflag)
  80074e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800752:	74 3e                	je     800792 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800754:	8b 45 14             	mov    0x14(%ebp),%eax
  800757:	8b 00                	mov    (%eax),%eax
  800759:	ba 00 00 00 00       	mov    $0x0,%edx
  80075e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800761:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	8d 40 04             	lea    0x4(%eax),%eax
  80076a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80076d:	b8 08 00 00 00       	mov    $0x8,%eax
  800772:	eb 6f                	jmp    8007e3 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8b 50 04             	mov    0x4(%eax),%edx
  80077a:	8b 00                	mov    (%eax),%eax
  80077c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800782:	8b 45 14             	mov    0x14(%ebp),%eax
  800785:	8d 40 08             	lea    0x8(%eax),%eax
  800788:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80078b:	b8 08 00 00 00       	mov    $0x8,%eax
  800790:	eb 51                	jmp    8007e3 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800792:	8b 45 14             	mov    0x14(%ebp),%eax
  800795:	8b 00                	mov    (%eax),%eax
  800797:	ba 00 00 00 00       	mov    $0x0,%edx
  80079c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a5:	8d 40 04             	lea    0x4(%eax),%eax
  8007a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007ab:	b8 08 00 00 00       	mov    $0x8,%eax
  8007b0:	eb 31                	jmp    8007e3 <vprintfmt+0x428>
			putch('0', putdat);
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	53                   	push   %ebx
  8007b6:	6a 30                	push   $0x30
  8007b8:	ff d6                	call   *%esi
			putch('x', putdat);
  8007ba:	83 c4 08             	add    $0x8,%esp
  8007bd:	53                   	push   %ebx
  8007be:	6a 78                	push   $0x78
  8007c0:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c5:	8b 00                	mov    (%eax),%eax
  8007c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007cf:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007d2:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d8:	8d 40 04             	lea    0x4(%eax),%eax
  8007db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007de:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007e3:	83 ec 0c             	sub    $0xc,%esp
  8007e6:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007ea:	52                   	push   %edx
  8007eb:	ff 75 e0             	pushl  -0x20(%ebp)
  8007ee:	50                   	push   %eax
  8007ef:	ff 75 dc             	pushl  -0x24(%ebp)
  8007f2:	ff 75 d8             	pushl  -0x28(%ebp)
  8007f5:	89 da                	mov    %ebx,%edx
  8007f7:	89 f0                	mov    %esi,%eax
  8007f9:	e8 a4 fa ff ff       	call   8002a2 <printnum>
			break;
  8007fe:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800801:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800804:	83 c7 01             	add    $0x1,%edi
  800807:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80080b:	83 f8 25             	cmp    $0x25,%eax
  80080e:	0f 84 be fb ff ff    	je     8003d2 <vprintfmt+0x17>
			if (ch == '\0')
  800814:	85 c0                	test   %eax,%eax
  800816:	0f 84 28 01 00 00    	je     800944 <vprintfmt+0x589>
			putch(ch, putdat);
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	53                   	push   %ebx
  800820:	50                   	push   %eax
  800821:	ff d6                	call   *%esi
  800823:	83 c4 10             	add    $0x10,%esp
  800826:	eb dc                	jmp    800804 <vprintfmt+0x449>
	if (lflag >= 2)
  800828:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80082c:	7f 26                	jg     800854 <vprintfmt+0x499>
	else if (lflag)
  80082e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800832:	74 41                	je     800875 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800834:	8b 45 14             	mov    0x14(%ebp),%eax
  800837:	8b 00                	mov    (%eax),%eax
  800839:	ba 00 00 00 00       	mov    $0x0,%edx
  80083e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800841:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800844:	8b 45 14             	mov    0x14(%ebp),%eax
  800847:	8d 40 04             	lea    0x4(%eax),%eax
  80084a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80084d:	b8 10 00 00 00       	mov    $0x10,%eax
  800852:	eb 8f                	jmp    8007e3 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800854:	8b 45 14             	mov    0x14(%ebp),%eax
  800857:	8b 50 04             	mov    0x4(%eax),%edx
  80085a:	8b 00                	mov    (%eax),%eax
  80085c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800862:	8b 45 14             	mov    0x14(%ebp),%eax
  800865:	8d 40 08             	lea    0x8(%eax),%eax
  800868:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80086b:	b8 10 00 00 00       	mov    $0x10,%eax
  800870:	e9 6e ff ff ff       	jmp    8007e3 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	ba 00 00 00 00       	mov    $0x0,%edx
  80087f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800882:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800885:	8b 45 14             	mov    0x14(%ebp),%eax
  800888:	8d 40 04             	lea    0x4(%eax),%eax
  80088b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80088e:	b8 10 00 00 00       	mov    $0x10,%eax
  800893:	e9 4b ff ff ff       	jmp    8007e3 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800898:	8b 45 14             	mov    0x14(%ebp),%eax
  80089b:	83 c0 04             	add    $0x4,%eax
  80089e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a4:	8b 00                	mov    (%eax),%eax
  8008a6:	85 c0                	test   %eax,%eax
  8008a8:	74 14                	je     8008be <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8008aa:	8b 13                	mov    (%ebx),%edx
  8008ac:	83 fa 7f             	cmp    $0x7f,%edx
  8008af:	7f 37                	jg     8008e8 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8008b1:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8008b3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008b6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b9:	e9 43 ff ff ff       	jmp    800801 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8008be:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008c3:	bf e1 27 80 00       	mov    $0x8027e1,%edi
							putch(ch, putdat);
  8008c8:	83 ec 08             	sub    $0x8,%esp
  8008cb:	53                   	push   %ebx
  8008cc:	50                   	push   %eax
  8008cd:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008cf:	83 c7 01             	add    $0x1,%edi
  8008d2:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008d6:	83 c4 10             	add    $0x10,%esp
  8008d9:	85 c0                	test   %eax,%eax
  8008db:	75 eb                	jne    8008c8 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e3:	e9 19 ff ff ff       	jmp    800801 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008e8:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008ea:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008ef:	bf 19 28 80 00       	mov    $0x802819,%edi
							putch(ch, putdat);
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	53                   	push   %ebx
  8008f8:	50                   	push   %eax
  8008f9:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008fb:	83 c7 01             	add    $0x1,%edi
  8008fe:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800902:	83 c4 10             	add    $0x10,%esp
  800905:	85 c0                	test   %eax,%eax
  800907:	75 eb                	jne    8008f4 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800909:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80090c:	89 45 14             	mov    %eax,0x14(%ebp)
  80090f:	e9 ed fe ff ff       	jmp    800801 <vprintfmt+0x446>
			putch(ch, putdat);
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	53                   	push   %ebx
  800918:	6a 25                	push   $0x25
  80091a:	ff d6                	call   *%esi
			break;
  80091c:	83 c4 10             	add    $0x10,%esp
  80091f:	e9 dd fe ff ff       	jmp    800801 <vprintfmt+0x446>
			putch('%', putdat);
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	53                   	push   %ebx
  800928:	6a 25                	push   $0x25
  80092a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80092c:	83 c4 10             	add    $0x10,%esp
  80092f:	89 f8                	mov    %edi,%eax
  800931:	eb 03                	jmp    800936 <vprintfmt+0x57b>
  800933:	83 e8 01             	sub    $0x1,%eax
  800936:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80093a:	75 f7                	jne    800933 <vprintfmt+0x578>
  80093c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80093f:	e9 bd fe ff ff       	jmp    800801 <vprintfmt+0x446>
}
  800944:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800947:	5b                   	pop    %ebx
  800948:	5e                   	pop    %esi
  800949:	5f                   	pop    %edi
  80094a:	5d                   	pop    %ebp
  80094b:	c3                   	ret    

0080094c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80094c:	55                   	push   %ebp
  80094d:	89 e5                	mov    %esp,%ebp
  80094f:	83 ec 18             	sub    $0x18,%esp
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800958:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80095b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80095f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800962:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800969:	85 c0                	test   %eax,%eax
  80096b:	74 26                	je     800993 <vsnprintf+0x47>
  80096d:	85 d2                	test   %edx,%edx
  80096f:	7e 22                	jle    800993 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800971:	ff 75 14             	pushl  0x14(%ebp)
  800974:	ff 75 10             	pushl  0x10(%ebp)
  800977:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80097a:	50                   	push   %eax
  80097b:	68 81 03 80 00       	push   $0x800381
  800980:	e8 36 fa ff ff       	call   8003bb <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800985:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800988:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80098b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80098e:	83 c4 10             	add    $0x10,%esp
}
  800991:	c9                   	leave  
  800992:	c3                   	ret    
		return -E_INVAL;
  800993:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800998:	eb f7                	jmp    800991 <vsnprintf+0x45>

0080099a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80099a:	55                   	push   %ebp
  80099b:	89 e5                	mov    %esp,%ebp
  80099d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009a0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009a3:	50                   	push   %eax
  8009a4:	ff 75 10             	pushl  0x10(%ebp)
  8009a7:	ff 75 0c             	pushl  0xc(%ebp)
  8009aa:	ff 75 08             	pushl  0x8(%ebp)
  8009ad:	e8 9a ff ff ff       	call   80094c <vsnprintf>
	va_end(ap);

	return rc;
}
  8009b2:	c9                   	leave  
  8009b3:	c3                   	ret    

008009b4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8009bf:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009c3:	74 05                	je     8009ca <strlen+0x16>
		n++;
  8009c5:	83 c0 01             	add    $0x1,%eax
  8009c8:	eb f5                	jmp    8009bf <strlen+0xb>
	return n;
}
  8009ca:	5d                   	pop    %ebp
  8009cb:	c3                   	ret    

008009cc <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009d2:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009da:	39 c2                	cmp    %eax,%edx
  8009dc:	74 0d                	je     8009eb <strnlen+0x1f>
  8009de:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009e2:	74 05                	je     8009e9 <strnlen+0x1d>
		n++;
  8009e4:	83 c2 01             	add    $0x1,%edx
  8009e7:	eb f1                	jmp    8009da <strnlen+0xe>
  8009e9:	89 d0                	mov    %edx,%eax
	return n;
}
  8009eb:	5d                   	pop    %ebp
  8009ec:	c3                   	ret    

008009ed <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	53                   	push   %ebx
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fc:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a00:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a03:	83 c2 01             	add    $0x1,%edx
  800a06:	84 c9                	test   %cl,%cl
  800a08:	75 f2                	jne    8009fc <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a0a:	5b                   	pop    %ebx
  800a0b:	5d                   	pop    %ebp
  800a0c:	c3                   	ret    

00800a0d <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	53                   	push   %ebx
  800a11:	83 ec 10             	sub    $0x10,%esp
  800a14:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a17:	53                   	push   %ebx
  800a18:	e8 97 ff ff ff       	call   8009b4 <strlen>
  800a1d:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a20:	ff 75 0c             	pushl  0xc(%ebp)
  800a23:	01 d8                	add    %ebx,%eax
  800a25:	50                   	push   %eax
  800a26:	e8 c2 ff ff ff       	call   8009ed <strcpy>
	return dst;
}
  800a2b:	89 d8                	mov    %ebx,%eax
  800a2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a30:	c9                   	leave  
  800a31:	c3                   	ret    

00800a32 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a32:	55                   	push   %ebp
  800a33:	89 e5                	mov    %esp,%ebp
  800a35:	56                   	push   %esi
  800a36:	53                   	push   %ebx
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a3d:	89 c6                	mov    %eax,%esi
  800a3f:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a42:	89 c2                	mov    %eax,%edx
  800a44:	39 f2                	cmp    %esi,%edx
  800a46:	74 11                	je     800a59 <strncpy+0x27>
		*dst++ = *src;
  800a48:	83 c2 01             	add    $0x1,%edx
  800a4b:	0f b6 19             	movzbl (%ecx),%ebx
  800a4e:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a51:	80 fb 01             	cmp    $0x1,%bl
  800a54:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a57:	eb eb                	jmp    800a44 <strncpy+0x12>
	}
	return ret;
}
  800a59:	5b                   	pop    %ebx
  800a5a:	5e                   	pop    %esi
  800a5b:	5d                   	pop    %ebp
  800a5c:	c3                   	ret    

00800a5d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a5d:	55                   	push   %ebp
  800a5e:	89 e5                	mov    %esp,%ebp
  800a60:	56                   	push   %esi
  800a61:	53                   	push   %ebx
  800a62:	8b 75 08             	mov    0x8(%ebp),%esi
  800a65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a68:	8b 55 10             	mov    0x10(%ebp),%edx
  800a6b:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a6d:	85 d2                	test   %edx,%edx
  800a6f:	74 21                	je     800a92 <strlcpy+0x35>
  800a71:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a75:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a77:	39 c2                	cmp    %eax,%edx
  800a79:	74 14                	je     800a8f <strlcpy+0x32>
  800a7b:	0f b6 19             	movzbl (%ecx),%ebx
  800a7e:	84 db                	test   %bl,%bl
  800a80:	74 0b                	je     800a8d <strlcpy+0x30>
			*dst++ = *src++;
  800a82:	83 c1 01             	add    $0x1,%ecx
  800a85:	83 c2 01             	add    $0x1,%edx
  800a88:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a8b:	eb ea                	jmp    800a77 <strlcpy+0x1a>
  800a8d:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a8f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a92:	29 f0                	sub    %esi,%eax
}
  800a94:	5b                   	pop    %ebx
  800a95:	5e                   	pop    %esi
  800a96:	5d                   	pop    %ebp
  800a97:	c3                   	ret    

00800a98 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
  800a9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a9e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800aa1:	0f b6 01             	movzbl (%ecx),%eax
  800aa4:	84 c0                	test   %al,%al
  800aa6:	74 0c                	je     800ab4 <strcmp+0x1c>
  800aa8:	3a 02                	cmp    (%edx),%al
  800aaa:	75 08                	jne    800ab4 <strcmp+0x1c>
		p++, q++;
  800aac:	83 c1 01             	add    $0x1,%ecx
  800aaf:	83 c2 01             	add    $0x1,%edx
  800ab2:	eb ed                	jmp    800aa1 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ab4:	0f b6 c0             	movzbl %al,%eax
  800ab7:	0f b6 12             	movzbl (%edx),%edx
  800aba:	29 d0                	sub    %edx,%eax
}
  800abc:	5d                   	pop    %ebp
  800abd:	c3                   	ret    

00800abe <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800abe:	55                   	push   %ebp
  800abf:	89 e5                	mov    %esp,%ebp
  800ac1:	53                   	push   %ebx
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac8:	89 c3                	mov    %eax,%ebx
  800aca:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800acd:	eb 06                	jmp    800ad5 <strncmp+0x17>
		n--, p++, q++;
  800acf:	83 c0 01             	add    $0x1,%eax
  800ad2:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ad5:	39 d8                	cmp    %ebx,%eax
  800ad7:	74 16                	je     800aef <strncmp+0x31>
  800ad9:	0f b6 08             	movzbl (%eax),%ecx
  800adc:	84 c9                	test   %cl,%cl
  800ade:	74 04                	je     800ae4 <strncmp+0x26>
  800ae0:	3a 0a                	cmp    (%edx),%cl
  800ae2:	74 eb                	je     800acf <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ae4:	0f b6 00             	movzbl (%eax),%eax
  800ae7:	0f b6 12             	movzbl (%edx),%edx
  800aea:	29 d0                	sub    %edx,%eax
}
  800aec:	5b                   	pop    %ebx
  800aed:	5d                   	pop    %ebp
  800aee:	c3                   	ret    
		return 0;
  800aef:	b8 00 00 00 00       	mov    $0x0,%eax
  800af4:	eb f6                	jmp    800aec <strncmp+0x2e>

00800af6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b00:	0f b6 10             	movzbl (%eax),%edx
  800b03:	84 d2                	test   %dl,%dl
  800b05:	74 09                	je     800b10 <strchr+0x1a>
		if (*s == c)
  800b07:	38 ca                	cmp    %cl,%dl
  800b09:	74 0a                	je     800b15 <strchr+0x1f>
	for (; *s; s++)
  800b0b:	83 c0 01             	add    $0x1,%eax
  800b0e:	eb f0                	jmp    800b00 <strchr+0xa>
			return (char *) s;
	return 0;
  800b10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b15:	5d                   	pop    %ebp
  800b16:	c3                   	ret    

00800b17 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b21:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b24:	38 ca                	cmp    %cl,%dl
  800b26:	74 09                	je     800b31 <strfind+0x1a>
  800b28:	84 d2                	test   %dl,%dl
  800b2a:	74 05                	je     800b31 <strfind+0x1a>
	for (; *s; s++)
  800b2c:	83 c0 01             	add    $0x1,%eax
  800b2f:	eb f0                	jmp    800b21 <strfind+0xa>
			break;
	return (char *) s;
}
  800b31:	5d                   	pop    %ebp
  800b32:	c3                   	ret    

00800b33 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b33:	55                   	push   %ebp
  800b34:	89 e5                	mov    %esp,%ebp
  800b36:	57                   	push   %edi
  800b37:	56                   	push   %esi
  800b38:	53                   	push   %ebx
  800b39:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b3c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b3f:	85 c9                	test   %ecx,%ecx
  800b41:	74 31                	je     800b74 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b43:	89 f8                	mov    %edi,%eax
  800b45:	09 c8                	or     %ecx,%eax
  800b47:	a8 03                	test   $0x3,%al
  800b49:	75 23                	jne    800b6e <memset+0x3b>
		c &= 0xFF;
  800b4b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b4f:	89 d3                	mov    %edx,%ebx
  800b51:	c1 e3 08             	shl    $0x8,%ebx
  800b54:	89 d0                	mov    %edx,%eax
  800b56:	c1 e0 18             	shl    $0x18,%eax
  800b59:	89 d6                	mov    %edx,%esi
  800b5b:	c1 e6 10             	shl    $0x10,%esi
  800b5e:	09 f0                	or     %esi,%eax
  800b60:	09 c2                	or     %eax,%edx
  800b62:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b64:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b67:	89 d0                	mov    %edx,%eax
  800b69:	fc                   	cld    
  800b6a:	f3 ab                	rep stos %eax,%es:(%edi)
  800b6c:	eb 06                	jmp    800b74 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b71:	fc                   	cld    
  800b72:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b74:	89 f8                	mov    %edi,%eax
  800b76:	5b                   	pop    %ebx
  800b77:	5e                   	pop    %esi
  800b78:	5f                   	pop    %edi
  800b79:	5d                   	pop    %ebp
  800b7a:	c3                   	ret    

00800b7b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	57                   	push   %edi
  800b7f:	56                   	push   %esi
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b86:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b89:	39 c6                	cmp    %eax,%esi
  800b8b:	73 32                	jae    800bbf <memmove+0x44>
  800b8d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b90:	39 c2                	cmp    %eax,%edx
  800b92:	76 2b                	jbe    800bbf <memmove+0x44>
		s += n;
		d += n;
  800b94:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b97:	89 fe                	mov    %edi,%esi
  800b99:	09 ce                	or     %ecx,%esi
  800b9b:	09 d6                	or     %edx,%esi
  800b9d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ba3:	75 0e                	jne    800bb3 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ba5:	83 ef 04             	sub    $0x4,%edi
  800ba8:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bab:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bae:	fd                   	std    
  800baf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bb1:	eb 09                	jmp    800bbc <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bb3:	83 ef 01             	sub    $0x1,%edi
  800bb6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bb9:	fd                   	std    
  800bba:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bbc:	fc                   	cld    
  800bbd:	eb 1a                	jmp    800bd9 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bbf:	89 c2                	mov    %eax,%edx
  800bc1:	09 ca                	or     %ecx,%edx
  800bc3:	09 f2                	or     %esi,%edx
  800bc5:	f6 c2 03             	test   $0x3,%dl
  800bc8:	75 0a                	jne    800bd4 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bca:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bcd:	89 c7                	mov    %eax,%edi
  800bcf:	fc                   	cld    
  800bd0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bd2:	eb 05                	jmp    800bd9 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bd4:	89 c7                	mov    %eax,%edi
  800bd6:	fc                   	cld    
  800bd7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bd9:	5e                   	pop    %esi
  800bda:	5f                   	pop    %edi
  800bdb:	5d                   	pop    %ebp
  800bdc:	c3                   	ret    

00800bdd <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800be3:	ff 75 10             	pushl  0x10(%ebp)
  800be6:	ff 75 0c             	pushl  0xc(%ebp)
  800be9:	ff 75 08             	pushl  0x8(%ebp)
  800bec:	e8 8a ff ff ff       	call   800b7b <memmove>
}
  800bf1:	c9                   	leave  
  800bf2:	c3                   	ret    

00800bf3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	56                   	push   %esi
  800bf7:	53                   	push   %ebx
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bfe:	89 c6                	mov    %eax,%esi
  800c00:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c03:	39 f0                	cmp    %esi,%eax
  800c05:	74 1c                	je     800c23 <memcmp+0x30>
		if (*s1 != *s2)
  800c07:	0f b6 08             	movzbl (%eax),%ecx
  800c0a:	0f b6 1a             	movzbl (%edx),%ebx
  800c0d:	38 d9                	cmp    %bl,%cl
  800c0f:	75 08                	jne    800c19 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c11:	83 c0 01             	add    $0x1,%eax
  800c14:	83 c2 01             	add    $0x1,%edx
  800c17:	eb ea                	jmp    800c03 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c19:	0f b6 c1             	movzbl %cl,%eax
  800c1c:	0f b6 db             	movzbl %bl,%ebx
  800c1f:	29 d8                	sub    %ebx,%eax
  800c21:	eb 05                	jmp    800c28 <memcmp+0x35>
	}

	return 0;
  800c23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c28:	5b                   	pop    %ebx
  800c29:	5e                   	pop    %esi
  800c2a:	5d                   	pop    %ebp
  800c2b:	c3                   	ret    

00800c2c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c35:	89 c2                	mov    %eax,%edx
  800c37:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c3a:	39 d0                	cmp    %edx,%eax
  800c3c:	73 09                	jae    800c47 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c3e:	38 08                	cmp    %cl,(%eax)
  800c40:	74 05                	je     800c47 <memfind+0x1b>
	for (; s < ends; s++)
  800c42:	83 c0 01             	add    $0x1,%eax
  800c45:	eb f3                	jmp    800c3a <memfind+0xe>
			break;
	return (void *) s;
}
  800c47:	5d                   	pop    %ebp
  800c48:	c3                   	ret    

00800c49 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	57                   	push   %edi
  800c4d:	56                   	push   %esi
  800c4e:	53                   	push   %ebx
  800c4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c52:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c55:	eb 03                	jmp    800c5a <strtol+0x11>
		s++;
  800c57:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c5a:	0f b6 01             	movzbl (%ecx),%eax
  800c5d:	3c 20                	cmp    $0x20,%al
  800c5f:	74 f6                	je     800c57 <strtol+0xe>
  800c61:	3c 09                	cmp    $0x9,%al
  800c63:	74 f2                	je     800c57 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c65:	3c 2b                	cmp    $0x2b,%al
  800c67:	74 2a                	je     800c93 <strtol+0x4a>
	int neg = 0;
  800c69:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c6e:	3c 2d                	cmp    $0x2d,%al
  800c70:	74 2b                	je     800c9d <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c72:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c78:	75 0f                	jne    800c89 <strtol+0x40>
  800c7a:	80 39 30             	cmpb   $0x30,(%ecx)
  800c7d:	74 28                	je     800ca7 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c7f:	85 db                	test   %ebx,%ebx
  800c81:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c86:	0f 44 d8             	cmove  %eax,%ebx
  800c89:	b8 00 00 00 00       	mov    $0x0,%eax
  800c8e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c91:	eb 50                	jmp    800ce3 <strtol+0x9a>
		s++;
  800c93:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c96:	bf 00 00 00 00       	mov    $0x0,%edi
  800c9b:	eb d5                	jmp    800c72 <strtol+0x29>
		s++, neg = 1;
  800c9d:	83 c1 01             	add    $0x1,%ecx
  800ca0:	bf 01 00 00 00       	mov    $0x1,%edi
  800ca5:	eb cb                	jmp    800c72 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ca7:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cab:	74 0e                	je     800cbb <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800cad:	85 db                	test   %ebx,%ebx
  800caf:	75 d8                	jne    800c89 <strtol+0x40>
		s++, base = 8;
  800cb1:	83 c1 01             	add    $0x1,%ecx
  800cb4:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cb9:	eb ce                	jmp    800c89 <strtol+0x40>
		s += 2, base = 16;
  800cbb:	83 c1 02             	add    $0x2,%ecx
  800cbe:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cc3:	eb c4                	jmp    800c89 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cc5:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cc8:	89 f3                	mov    %esi,%ebx
  800cca:	80 fb 19             	cmp    $0x19,%bl
  800ccd:	77 29                	ja     800cf8 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ccf:	0f be d2             	movsbl %dl,%edx
  800cd2:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cd5:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cd8:	7d 30                	jge    800d0a <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cda:	83 c1 01             	add    $0x1,%ecx
  800cdd:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ce1:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ce3:	0f b6 11             	movzbl (%ecx),%edx
  800ce6:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ce9:	89 f3                	mov    %esi,%ebx
  800ceb:	80 fb 09             	cmp    $0x9,%bl
  800cee:	77 d5                	ja     800cc5 <strtol+0x7c>
			dig = *s - '0';
  800cf0:	0f be d2             	movsbl %dl,%edx
  800cf3:	83 ea 30             	sub    $0x30,%edx
  800cf6:	eb dd                	jmp    800cd5 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800cf8:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cfb:	89 f3                	mov    %esi,%ebx
  800cfd:	80 fb 19             	cmp    $0x19,%bl
  800d00:	77 08                	ja     800d0a <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d02:	0f be d2             	movsbl %dl,%edx
  800d05:	83 ea 37             	sub    $0x37,%edx
  800d08:	eb cb                	jmp    800cd5 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d0a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d0e:	74 05                	je     800d15 <strtol+0xcc>
		*endptr = (char *) s;
  800d10:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d13:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d15:	89 c2                	mov    %eax,%edx
  800d17:	f7 da                	neg    %edx
  800d19:	85 ff                	test   %edi,%edi
  800d1b:	0f 45 c2             	cmovne %edx,%eax
}
  800d1e:	5b                   	pop    %ebx
  800d1f:	5e                   	pop    %esi
  800d20:	5f                   	pop    %edi
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    

00800d23 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	57                   	push   %edi
  800d27:	56                   	push   %esi
  800d28:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d29:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d34:	89 c3                	mov    %eax,%ebx
  800d36:	89 c7                	mov    %eax,%edi
  800d38:	89 c6                	mov    %eax,%esi
  800d3a:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d3c:	5b                   	pop    %ebx
  800d3d:	5e                   	pop    %esi
  800d3e:	5f                   	pop    %edi
  800d3f:	5d                   	pop    %ebp
  800d40:	c3                   	ret    

00800d41 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
  800d44:	57                   	push   %edi
  800d45:	56                   	push   %esi
  800d46:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d47:	ba 00 00 00 00       	mov    $0x0,%edx
  800d4c:	b8 01 00 00 00       	mov    $0x1,%eax
  800d51:	89 d1                	mov    %edx,%ecx
  800d53:	89 d3                	mov    %edx,%ebx
  800d55:	89 d7                	mov    %edx,%edi
  800d57:	89 d6                	mov    %edx,%esi
  800d59:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d5b:	5b                   	pop    %ebx
  800d5c:	5e                   	pop    %esi
  800d5d:	5f                   	pop    %edi
  800d5e:	5d                   	pop    %ebp
  800d5f:	c3                   	ret    

00800d60 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	57                   	push   %edi
  800d64:	56                   	push   %esi
  800d65:	53                   	push   %ebx
  800d66:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d69:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d71:	b8 03 00 00 00       	mov    $0x3,%eax
  800d76:	89 cb                	mov    %ecx,%ebx
  800d78:	89 cf                	mov    %ecx,%edi
  800d7a:	89 ce                	mov    %ecx,%esi
  800d7c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d7e:	85 c0                	test   %eax,%eax
  800d80:	7f 08                	jg     800d8a <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d82:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d85:	5b                   	pop    %ebx
  800d86:	5e                   	pop    %esi
  800d87:	5f                   	pop    %edi
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8a:	83 ec 0c             	sub    $0xc,%esp
  800d8d:	50                   	push   %eax
  800d8e:	6a 03                	push   $0x3
  800d90:	68 24 2a 80 00       	push   $0x802a24
  800d95:	6a 43                	push   $0x43
  800d97:	68 41 2a 80 00       	push   $0x802a41
  800d9c:	e8 f7 f3 ff ff       	call   800198 <_panic>

00800da1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800da1:	55                   	push   %ebp
  800da2:	89 e5                	mov    %esp,%ebp
  800da4:	57                   	push   %edi
  800da5:	56                   	push   %esi
  800da6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da7:	ba 00 00 00 00       	mov    $0x0,%edx
  800dac:	b8 02 00 00 00       	mov    $0x2,%eax
  800db1:	89 d1                	mov    %edx,%ecx
  800db3:	89 d3                	mov    %edx,%ebx
  800db5:	89 d7                	mov    %edx,%edi
  800db7:	89 d6                	mov    %edx,%esi
  800db9:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dbb:	5b                   	pop    %ebx
  800dbc:	5e                   	pop    %esi
  800dbd:	5f                   	pop    %edi
  800dbe:	5d                   	pop    %ebp
  800dbf:	c3                   	ret    

00800dc0 <sys_yield>:

void
sys_yield(void)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
  800dc3:	57                   	push   %edi
  800dc4:	56                   	push   %esi
  800dc5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dc6:	ba 00 00 00 00       	mov    $0x0,%edx
  800dcb:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dd0:	89 d1                	mov    %edx,%ecx
  800dd2:	89 d3                	mov    %edx,%ebx
  800dd4:	89 d7                	mov    %edx,%edi
  800dd6:	89 d6                	mov    %edx,%esi
  800dd8:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dda:	5b                   	pop    %ebx
  800ddb:	5e                   	pop    %esi
  800ddc:	5f                   	pop    %edi
  800ddd:	5d                   	pop    %ebp
  800dde:	c3                   	ret    

00800ddf <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
  800de2:	57                   	push   %edi
  800de3:	56                   	push   %esi
  800de4:	53                   	push   %ebx
  800de5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de8:	be 00 00 00 00       	mov    $0x0,%esi
  800ded:	8b 55 08             	mov    0x8(%ebp),%edx
  800df0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df3:	b8 04 00 00 00       	mov    $0x4,%eax
  800df8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dfb:	89 f7                	mov    %esi,%edi
  800dfd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dff:	85 c0                	test   %eax,%eax
  800e01:	7f 08                	jg     800e0b <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e03:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e06:	5b                   	pop    %ebx
  800e07:	5e                   	pop    %esi
  800e08:	5f                   	pop    %edi
  800e09:	5d                   	pop    %ebp
  800e0a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0b:	83 ec 0c             	sub    $0xc,%esp
  800e0e:	50                   	push   %eax
  800e0f:	6a 04                	push   $0x4
  800e11:	68 24 2a 80 00       	push   $0x802a24
  800e16:	6a 43                	push   $0x43
  800e18:	68 41 2a 80 00       	push   $0x802a41
  800e1d:	e8 76 f3 ff ff       	call   800198 <_panic>

00800e22 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	57                   	push   %edi
  800e26:	56                   	push   %esi
  800e27:	53                   	push   %ebx
  800e28:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e31:	b8 05 00 00 00       	mov    $0x5,%eax
  800e36:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e39:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e3c:	8b 75 18             	mov    0x18(%ebp),%esi
  800e3f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e41:	85 c0                	test   %eax,%eax
  800e43:	7f 08                	jg     800e4d <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e45:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e48:	5b                   	pop    %ebx
  800e49:	5e                   	pop    %esi
  800e4a:	5f                   	pop    %edi
  800e4b:	5d                   	pop    %ebp
  800e4c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4d:	83 ec 0c             	sub    $0xc,%esp
  800e50:	50                   	push   %eax
  800e51:	6a 05                	push   $0x5
  800e53:	68 24 2a 80 00       	push   $0x802a24
  800e58:	6a 43                	push   $0x43
  800e5a:	68 41 2a 80 00       	push   $0x802a41
  800e5f:	e8 34 f3 ff ff       	call   800198 <_panic>

00800e64 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	57                   	push   %edi
  800e68:	56                   	push   %esi
  800e69:	53                   	push   %ebx
  800e6a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e72:	8b 55 08             	mov    0x8(%ebp),%edx
  800e75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e78:	b8 06 00 00 00       	mov    $0x6,%eax
  800e7d:	89 df                	mov    %ebx,%edi
  800e7f:	89 de                	mov    %ebx,%esi
  800e81:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e83:	85 c0                	test   %eax,%eax
  800e85:	7f 08                	jg     800e8f <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8a:	5b                   	pop    %ebx
  800e8b:	5e                   	pop    %esi
  800e8c:	5f                   	pop    %edi
  800e8d:	5d                   	pop    %ebp
  800e8e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8f:	83 ec 0c             	sub    $0xc,%esp
  800e92:	50                   	push   %eax
  800e93:	6a 06                	push   $0x6
  800e95:	68 24 2a 80 00       	push   $0x802a24
  800e9a:	6a 43                	push   $0x43
  800e9c:	68 41 2a 80 00       	push   $0x802a41
  800ea1:	e8 f2 f2 ff ff       	call   800198 <_panic>

00800ea6 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ea6:	55                   	push   %ebp
  800ea7:	89 e5                	mov    %esp,%ebp
  800ea9:	57                   	push   %edi
  800eaa:	56                   	push   %esi
  800eab:	53                   	push   %ebx
  800eac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eaf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eba:	b8 08 00 00 00       	mov    $0x8,%eax
  800ebf:	89 df                	mov    %ebx,%edi
  800ec1:	89 de                	mov    %ebx,%esi
  800ec3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec5:	85 c0                	test   %eax,%eax
  800ec7:	7f 08                	jg     800ed1 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ec9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ecc:	5b                   	pop    %ebx
  800ecd:	5e                   	pop    %esi
  800ece:	5f                   	pop    %edi
  800ecf:	5d                   	pop    %ebp
  800ed0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed1:	83 ec 0c             	sub    $0xc,%esp
  800ed4:	50                   	push   %eax
  800ed5:	6a 08                	push   $0x8
  800ed7:	68 24 2a 80 00       	push   $0x802a24
  800edc:	6a 43                	push   $0x43
  800ede:	68 41 2a 80 00       	push   $0x802a41
  800ee3:	e8 b0 f2 ff ff       	call   800198 <_panic>

00800ee8 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	57                   	push   %edi
  800eec:	56                   	push   %esi
  800eed:	53                   	push   %ebx
  800eee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efc:	b8 09 00 00 00       	mov    $0x9,%eax
  800f01:	89 df                	mov    %ebx,%edi
  800f03:	89 de                	mov    %ebx,%esi
  800f05:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f07:	85 c0                	test   %eax,%eax
  800f09:	7f 08                	jg     800f13 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f0e:	5b                   	pop    %ebx
  800f0f:	5e                   	pop    %esi
  800f10:	5f                   	pop    %edi
  800f11:	5d                   	pop    %ebp
  800f12:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f13:	83 ec 0c             	sub    $0xc,%esp
  800f16:	50                   	push   %eax
  800f17:	6a 09                	push   $0x9
  800f19:	68 24 2a 80 00       	push   $0x802a24
  800f1e:	6a 43                	push   $0x43
  800f20:	68 41 2a 80 00       	push   $0x802a41
  800f25:	e8 6e f2 ff ff       	call   800198 <_panic>

00800f2a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f2a:	55                   	push   %ebp
  800f2b:	89 e5                	mov    %esp,%ebp
  800f2d:	57                   	push   %edi
  800f2e:	56                   	push   %esi
  800f2f:	53                   	push   %ebx
  800f30:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f33:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f38:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f43:	89 df                	mov    %ebx,%edi
  800f45:	89 de                	mov    %ebx,%esi
  800f47:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f49:	85 c0                	test   %eax,%eax
  800f4b:	7f 08                	jg     800f55 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f50:	5b                   	pop    %ebx
  800f51:	5e                   	pop    %esi
  800f52:	5f                   	pop    %edi
  800f53:	5d                   	pop    %ebp
  800f54:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f55:	83 ec 0c             	sub    $0xc,%esp
  800f58:	50                   	push   %eax
  800f59:	6a 0a                	push   $0xa
  800f5b:	68 24 2a 80 00       	push   $0x802a24
  800f60:	6a 43                	push   $0x43
  800f62:	68 41 2a 80 00       	push   $0x802a41
  800f67:	e8 2c f2 ff ff       	call   800198 <_panic>

00800f6c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
  800f6f:	57                   	push   %edi
  800f70:	56                   	push   %esi
  800f71:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f72:	8b 55 08             	mov    0x8(%ebp),%edx
  800f75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f78:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f7d:	be 00 00 00 00       	mov    $0x0,%esi
  800f82:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f85:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f88:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f8a:	5b                   	pop    %ebx
  800f8b:	5e                   	pop    %esi
  800f8c:	5f                   	pop    %edi
  800f8d:	5d                   	pop    %ebp
  800f8e:	c3                   	ret    

00800f8f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f8f:	55                   	push   %ebp
  800f90:	89 e5                	mov    %esp,%ebp
  800f92:	57                   	push   %edi
  800f93:	56                   	push   %esi
  800f94:	53                   	push   %ebx
  800f95:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f98:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa0:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fa5:	89 cb                	mov    %ecx,%ebx
  800fa7:	89 cf                	mov    %ecx,%edi
  800fa9:	89 ce                	mov    %ecx,%esi
  800fab:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fad:	85 c0                	test   %eax,%eax
  800faf:	7f 08                	jg     800fb9 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb4:	5b                   	pop    %ebx
  800fb5:	5e                   	pop    %esi
  800fb6:	5f                   	pop    %edi
  800fb7:	5d                   	pop    %ebp
  800fb8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb9:	83 ec 0c             	sub    $0xc,%esp
  800fbc:	50                   	push   %eax
  800fbd:	6a 0d                	push   $0xd
  800fbf:	68 24 2a 80 00       	push   $0x802a24
  800fc4:	6a 43                	push   $0x43
  800fc6:	68 41 2a 80 00       	push   $0x802a41
  800fcb:	e8 c8 f1 ff ff       	call   800198 <_panic>

00800fd0 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	57                   	push   %edi
  800fd4:	56                   	push   %esi
  800fd5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fdb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe1:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fe6:	89 df                	mov    %ebx,%edi
  800fe8:	89 de                	mov    %ebx,%esi
  800fea:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fec:	5b                   	pop    %ebx
  800fed:	5e                   	pop    %esi
  800fee:	5f                   	pop    %edi
  800fef:	5d                   	pop    %ebp
  800ff0:	c3                   	ret    

00800ff1 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
  800ff4:	57                   	push   %edi
  800ff5:	56                   	push   %esi
  800ff6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ff7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ffc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fff:	b8 0f 00 00 00       	mov    $0xf,%eax
  801004:	89 cb                	mov    %ecx,%ebx
  801006:	89 cf                	mov    %ecx,%edi
  801008:	89 ce                	mov    %ecx,%esi
  80100a:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80100c:	5b                   	pop    %ebx
  80100d:	5e                   	pop    %esi
  80100e:	5f                   	pop    %edi
  80100f:	5d                   	pop    %ebp
  801010:	c3                   	ret    

00801011 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
  801014:	57                   	push   %edi
  801015:	56                   	push   %esi
  801016:	53                   	push   %ebx
	asm volatile("int %1\n"
  801017:	ba 00 00 00 00       	mov    $0x0,%edx
  80101c:	b8 10 00 00 00       	mov    $0x10,%eax
  801021:	89 d1                	mov    %edx,%ecx
  801023:	89 d3                	mov    %edx,%ebx
  801025:	89 d7                	mov    %edx,%edi
  801027:	89 d6                	mov    %edx,%esi
  801029:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80102b:	5b                   	pop    %ebx
  80102c:	5e                   	pop    %esi
  80102d:	5f                   	pop    %edi
  80102e:	5d                   	pop    %ebp
  80102f:	c3                   	ret    

00801030 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
  801033:	57                   	push   %edi
  801034:	56                   	push   %esi
  801035:	53                   	push   %ebx
	asm volatile("int %1\n"
  801036:	bb 00 00 00 00       	mov    $0x0,%ebx
  80103b:	8b 55 08             	mov    0x8(%ebp),%edx
  80103e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801041:	b8 11 00 00 00       	mov    $0x11,%eax
  801046:	89 df                	mov    %ebx,%edi
  801048:	89 de                	mov    %ebx,%esi
  80104a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80104c:	5b                   	pop    %ebx
  80104d:	5e                   	pop    %esi
  80104e:	5f                   	pop    %edi
  80104f:	5d                   	pop    %ebp
  801050:	c3                   	ret    

00801051 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801051:	55                   	push   %ebp
  801052:	89 e5                	mov    %esp,%ebp
  801054:	57                   	push   %edi
  801055:	56                   	push   %esi
  801056:	53                   	push   %ebx
	asm volatile("int %1\n"
  801057:	bb 00 00 00 00       	mov    $0x0,%ebx
  80105c:	8b 55 08             	mov    0x8(%ebp),%edx
  80105f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801062:	b8 12 00 00 00       	mov    $0x12,%eax
  801067:	89 df                	mov    %ebx,%edi
  801069:	89 de                	mov    %ebx,%esi
  80106b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80106d:	5b                   	pop    %ebx
  80106e:	5e                   	pop    %esi
  80106f:	5f                   	pop    %edi
  801070:	5d                   	pop    %ebp
  801071:	c3                   	ret    

00801072 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
  801075:	57                   	push   %edi
  801076:	56                   	push   %esi
  801077:	53                   	push   %ebx
  801078:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80107b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801080:	8b 55 08             	mov    0x8(%ebp),%edx
  801083:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801086:	b8 13 00 00 00       	mov    $0x13,%eax
  80108b:	89 df                	mov    %ebx,%edi
  80108d:	89 de                	mov    %ebx,%esi
  80108f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801091:	85 c0                	test   %eax,%eax
  801093:	7f 08                	jg     80109d <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801095:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801098:	5b                   	pop    %ebx
  801099:	5e                   	pop    %esi
  80109a:	5f                   	pop    %edi
  80109b:	5d                   	pop    %ebp
  80109c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80109d:	83 ec 0c             	sub    $0xc,%esp
  8010a0:	50                   	push   %eax
  8010a1:	6a 13                	push   $0x13
  8010a3:	68 24 2a 80 00       	push   $0x802a24
  8010a8:	6a 43                	push   $0x43
  8010aa:	68 41 2a 80 00       	push   $0x802a41
  8010af:	e8 e4 f0 ff ff       	call   800198 <_panic>

008010b4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010b4:	55                   	push   %ebp
  8010b5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	05 00 00 00 30       	add    $0x30000000,%eax
  8010bf:	c1 e8 0c             	shr    $0xc,%eax
}
  8010c2:	5d                   	pop    %ebp
  8010c3:	c3                   	ret    

008010c4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010d4:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010d9:	5d                   	pop    %ebp
  8010da:	c3                   	ret    

008010db <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010e3:	89 c2                	mov    %eax,%edx
  8010e5:	c1 ea 16             	shr    $0x16,%edx
  8010e8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010ef:	f6 c2 01             	test   $0x1,%dl
  8010f2:	74 2d                	je     801121 <fd_alloc+0x46>
  8010f4:	89 c2                	mov    %eax,%edx
  8010f6:	c1 ea 0c             	shr    $0xc,%edx
  8010f9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801100:	f6 c2 01             	test   $0x1,%dl
  801103:	74 1c                	je     801121 <fd_alloc+0x46>
  801105:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80110a:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80110f:	75 d2                	jne    8010e3 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80111a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80111f:	eb 0a                	jmp    80112b <fd_alloc+0x50>
			*fd_store = fd;
  801121:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801124:	89 01                	mov    %eax,(%ecx)
			return 0;
  801126:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80112b:	5d                   	pop    %ebp
  80112c:	c3                   	ret    

0080112d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801133:	83 f8 1f             	cmp    $0x1f,%eax
  801136:	77 30                	ja     801168 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801138:	c1 e0 0c             	shl    $0xc,%eax
  80113b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801140:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801146:	f6 c2 01             	test   $0x1,%dl
  801149:	74 24                	je     80116f <fd_lookup+0x42>
  80114b:	89 c2                	mov    %eax,%edx
  80114d:	c1 ea 0c             	shr    $0xc,%edx
  801150:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801157:	f6 c2 01             	test   $0x1,%dl
  80115a:	74 1a                	je     801176 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80115c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80115f:	89 02                	mov    %eax,(%edx)
	return 0;
  801161:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801166:	5d                   	pop    %ebp
  801167:	c3                   	ret    
		return -E_INVAL;
  801168:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80116d:	eb f7                	jmp    801166 <fd_lookup+0x39>
		return -E_INVAL;
  80116f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801174:	eb f0                	jmp    801166 <fd_lookup+0x39>
  801176:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80117b:	eb e9                	jmp    801166 <fd_lookup+0x39>

0080117d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
  801180:	83 ec 08             	sub    $0x8,%esp
  801183:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801186:	ba 00 00 00 00       	mov    $0x0,%edx
  80118b:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801190:	39 08                	cmp    %ecx,(%eax)
  801192:	74 38                	je     8011cc <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801194:	83 c2 01             	add    $0x1,%edx
  801197:	8b 04 95 d0 2a 80 00 	mov    0x802ad0(,%edx,4),%eax
  80119e:	85 c0                	test   %eax,%eax
  8011a0:	75 ee                	jne    801190 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011a2:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8011a7:	8b 40 48             	mov    0x48(%eax),%eax
  8011aa:	83 ec 04             	sub    $0x4,%esp
  8011ad:	51                   	push   %ecx
  8011ae:	50                   	push   %eax
  8011af:	68 50 2a 80 00       	push   $0x802a50
  8011b4:	e8 d5 f0 ff ff       	call   80028e <cprintf>
	*dev = 0;
  8011b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011c2:	83 c4 10             	add    $0x10,%esp
  8011c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011ca:	c9                   	leave  
  8011cb:	c3                   	ret    
			*dev = devtab[i];
  8011cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011cf:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8011d6:	eb f2                	jmp    8011ca <dev_lookup+0x4d>

008011d8 <fd_close>:
{
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
  8011db:	57                   	push   %edi
  8011dc:	56                   	push   %esi
  8011dd:	53                   	push   %ebx
  8011de:	83 ec 24             	sub    $0x24,%esp
  8011e1:	8b 75 08             	mov    0x8(%ebp),%esi
  8011e4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011e7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011ea:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011eb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011f1:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011f4:	50                   	push   %eax
  8011f5:	e8 33 ff ff ff       	call   80112d <fd_lookup>
  8011fa:	89 c3                	mov    %eax,%ebx
  8011fc:	83 c4 10             	add    $0x10,%esp
  8011ff:	85 c0                	test   %eax,%eax
  801201:	78 05                	js     801208 <fd_close+0x30>
	    || fd != fd2)
  801203:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801206:	74 16                	je     80121e <fd_close+0x46>
		return (must_exist ? r : 0);
  801208:	89 f8                	mov    %edi,%eax
  80120a:	84 c0                	test   %al,%al
  80120c:	b8 00 00 00 00       	mov    $0x0,%eax
  801211:	0f 44 d8             	cmove  %eax,%ebx
}
  801214:	89 d8                	mov    %ebx,%eax
  801216:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801219:	5b                   	pop    %ebx
  80121a:	5e                   	pop    %esi
  80121b:	5f                   	pop    %edi
  80121c:	5d                   	pop    %ebp
  80121d:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80121e:	83 ec 08             	sub    $0x8,%esp
  801221:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801224:	50                   	push   %eax
  801225:	ff 36                	pushl  (%esi)
  801227:	e8 51 ff ff ff       	call   80117d <dev_lookup>
  80122c:	89 c3                	mov    %eax,%ebx
  80122e:	83 c4 10             	add    $0x10,%esp
  801231:	85 c0                	test   %eax,%eax
  801233:	78 1a                	js     80124f <fd_close+0x77>
		if (dev->dev_close)
  801235:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801238:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80123b:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801240:	85 c0                	test   %eax,%eax
  801242:	74 0b                	je     80124f <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801244:	83 ec 0c             	sub    $0xc,%esp
  801247:	56                   	push   %esi
  801248:	ff d0                	call   *%eax
  80124a:	89 c3                	mov    %eax,%ebx
  80124c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80124f:	83 ec 08             	sub    $0x8,%esp
  801252:	56                   	push   %esi
  801253:	6a 00                	push   $0x0
  801255:	e8 0a fc ff ff       	call   800e64 <sys_page_unmap>
	return r;
  80125a:	83 c4 10             	add    $0x10,%esp
  80125d:	eb b5                	jmp    801214 <fd_close+0x3c>

0080125f <close>:

int
close(int fdnum)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801265:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801268:	50                   	push   %eax
  801269:	ff 75 08             	pushl  0x8(%ebp)
  80126c:	e8 bc fe ff ff       	call   80112d <fd_lookup>
  801271:	83 c4 10             	add    $0x10,%esp
  801274:	85 c0                	test   %eax,%eax
  801276:	79 02                	jns    80127a <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801278:	c9                   	leave  
  801279:	c3                   	ret    
		return fd_close(fd, 1);
  80127a:	83 ec 08             	sub    $0x8,%esp
  80127d:	6a 01                	push   $0x1
  80127f:	ff 75 f4             	pushl  -0xc(%ebp)
  801282:	e8 51 ff ff ff       	call   8011d8 <fd_close>
  801287:	83 c4 10             	add    $0x10,%esp
  80128a:	eb ec                	jmp    801278 <close+0x19>

0080128c <close_all>:

void
close_all(void)
{
  80128c:	55                   	push   %ebp
  80128d:	89 e5                	mov    %esp,%ebp
  80128f:	53                   	push   %ebx
  801290:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801293:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801298:	83 ec 0c             	sub    $0xc,%esp
  80129b:	53                   	push   %ebx
  80129c:	e8 be ff ff ff       	call   80125f <close>
	for (i = 0; i < MAXFD; i++)
  8012a1:	83 c3 01             	add    $0x1,%ebx
  8012a4:	83 c4 10             	add    $0x10,%esp
  8012a7:	83 fb 20             	cmp    $0x20,%ebx
  8012aa:	75 ec                	jne    801298 <close_all+0xc>
}
  8012ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012af:	c9                   	leave  
  8012b0:	c3                   	ret    

008012b1 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012b1:	55                   	push   %ebp
  8012b2:	89 e5                	mov    %esp,%ebp
  8012b4:	57                   	push   %edi
  8012b5:	56                   	push   %esi
  8012b6:	53                   	push   %ebx
  8012b7:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012ba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012bd:	50                   	push   %eax
  8012be:	ff 75 08             	pushl  0x8(%ebp)
  8012c1:	e8 67 fe ff ff       	call   80112d <fd_lookup>
  8012c6:	89 c3                	mov    %eax,%ebx
  8012c8:	83 c4 10             	add    $0x10,%esp
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	0f 88 81 00 00 00    	js     801354 <dup+0xa3>
		return r;
	close(newfdnum);
  8012d3:	83 ec 0c             	sub    $0xc,%esp
  8012d6:	ff 75 0c             	pushl  0xc(%ebp)
  8012d9:	e8 81 ff ff ff       	call   80125f <close>

	newfd = INDEX2FD(newfdnum);
  8012de:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012e1:	c1 e6 0c             	shl    $0xc,%esi
  8012e4:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012ea:	83 c4 04             	add    $0x4,%esp
  8012ed:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012f0:	e8 cf fd ff ff       	call   8010c4 <fd2data>
  8012f5:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012f7:	89 34 24             	mov    %esi,(%esp)
  8012fa:	e8 c5 fd ff ff       	call   8010c4 <fd2data>
  8012ff:	83 c4 10             	add    $0x10,%esp
  801302:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801304:	89 d8                	mov    %ebx,%eax
  801306:	c1 e8 16             	shr    $0x16,%eax
  801309:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801310:	a8 01                	test   $0x1,%al
  801312:	74 11                	je     801325 <dup+0x74>
  801314:	89 d8                	mov    %ebx,%eax
  801316:	c1 e8 0c             	shr    $0xc,%eax
  801319:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801320:	f6 c2 01             	test   $0x1,%dl
  801323:	75 39                	jne    80135e <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801325:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801328:	89 d0                	mov    %edx,%eax
  80132a:	c1 e8 0c             	shr    $0xc,%eax
  80132d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801334:	83 ec 0c             	sub    $0xc,%esp
  801337:	25 07 0e 00 00       	and    $0xe07,%eax
  80133c:	50                   	push   %eax
  80133d:	56                   	push   %esi
  80133e:	6a 00                	push   $0x0
  801340:	52                   	push   %edx
  801341:	6a 00                	push   $0x0
  801343:	e8 da fa ff ff       	call   800e22 <sys_page_map>
  801348:	89 c3                	mov    %eax,%ebx
  80134a:	83 c4 20             	add    $0x20,%esp
  80134d:	85 c0                	test   %eax,%eax
  80134f:	78 31                	js     801382 <dup+0xd1>
		goto err;

	return newfdnum;
  801351:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801354:	89 d8                	mov    %ebx,%eax
  801356:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801359:	5b                   	pop    %ebx
  80135a:	5e                   	pop    %esi
  80135b:	5f                   	pop    %edi
  80135c:	5d                   	pop    %ebp
  80135d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80135e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801365:	83 ec 0c             	sub    $0xc,%esp
  801368:	25 07 0e 00 00       	and    $0xe07,%eax
  80136d:	50                   	push   %eax
  80136e:	57                   	push   %edi
  80136f:	6a 00                	push   $0x0
  801371:	53                   	push   %ebx
  801372:	6a 00                	push   $0x0
  801374:	e8 a9 fa ff ff       	call   800e22 <sys_page_map>
  801379:	89 c3                	mov    %eax,%ebx
  80137b:	83 c4 20             	add    $0x20,%esp
  80137e:	85 c0                	test   %eax,%eax
  801380:	79 a3                	jns    801325 <dup+0x74>
	sys_page_unmap(0, newfd);
  801382:	83 ec 08             	sub    $0x8,%esp
  801385:	56                   	push   %esi
  801386:	6a 00                	push   $0x0
  801388:	e8 d7 fa ff ff       	call   800e64 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80138d:	83 c4 08             	add    $0x8,%esp
  801390:	57                   	push   %edi
  801391:	6a 00                	push   $0x0
  801393:	e8 cc fa ff ff       	call   800e64 <sys_page_unmap>
	return r;
  801398:	83 c4 10             	add    $0x10,%esp
  80139b:	eb b7                	jmp    801354 <dup+0xa3>

0080139d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
  8013a0:	53                   	push   %ebx
  8013a1:	83 ec 1c             	sub    $0x1c,%esp
  8013a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013a7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013aa:	50                   	push   %eax
  8013ab:	53                   	push   %ebx
  8013ac:	e8 7c fd ff ff       	call   80112d <fd_lookup>
  8013b1:	83 c4 10             	add    $0x10,%esp
  8013b4:	85 c0                	test   %eax,%eax
  8013b6:	78 3f                	js     8013f7 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013b8:	83 ec 08             	sub    $0x8,%esp
  8013bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013be:	50                   	push   %eax
  8013bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c2:	ff 30                	pushl  (%eax)
  8013c4:	e8 b4 fd ff ff       	call   80117d <dev_lookup>
  8013c9:	83 c4 10             	add    $0x10,%esp
  8013cc:	85 c0                	test   %eax,%eax
  8013ce:	78 27                	js     8013f7 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013d3:	8b 42 08             	mov    0x8(%edx),%eax
  8013d6:	83 e0 03             	and    $0x3,%eax
  8013d9:	83 f8 01             	cmp    $0x1,%eax
  8013dc:	74 1e                	je     8013fc <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e1:	8b 40 08             	mov    0x8(%eax),%eax
  8013e4:	85 c0                	test   %eax,%eax
  8013e6:	74 35                	je     80141d <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013e8:	83 ec 04             	sub    $0x4,%esp
  8013eb:	ff 75 10             	pushl  0x10(%ebp)
  8013ee:	ff 75 0c             	pushl  0xc(%ebp)
  8013f1:	52                   	push   %edx
  8013f2:	ff d0                	call   *%eax
  8013f4:	83 c4 10             	add    $0x10,%esp
}
  8013f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013fa:	c9                   	leave  
  8013fb:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013fc:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801401:	8b 40 48             	mov    0x48(%eax),%eax
  801404:	83 ec 04             	sub    $0x4,%esp
  801407:	53                   	push   %ebx
  801408:	50                   	push   %eax
  801409:	68 94 2a 80 00       	push   $0x802a94
  80140e:	e8 7b ee ff ff       	call   80028e <cprintf>
		return -E_INVAL;
  801413:	83 c4 10             	add    $0x10,%esp
  801416:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80141b:	eb da                	jmp    8013f7 <read+0x5a>
		return -E_NOT_SUPP;
  80141d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801422:	eb d3                	jmp    8013f7 <read+0x5a>

00801424 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	57                   	push   %edi
  801428:	56                   	push   %esi
  801429:	53                   	push   %ebx
  80142a:	83 ec 0c             	sub    $0xc,%esp
  80142d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801430:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801433:	bb 00 00 00 00       	mov    $0x0,%ebx
  801438:	39 f3                	cmp    %esi,%ebx
  80143a:	73 23                	jae    80145f <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80143c:	83 ec 04             	sub    $0x4,%esp
  80143f:	89 f0                	mov    %esi,%eax
  801441:	29 d8                	sub    %ebx,%eax
  801443:	50                   	push   %eax
  801444:	89 d8                	mov    %ebx,%eax
  801446:	03 45 0c             	add    0xc(%ebp),%eax
  801449:	50                   	push   %eax
  80144a:	57                   	push   %edi
  80144b:	e8 4d ff ff ff       	call   80139d <read>
		if (m < 0)
  801450:	83 c4 10             	add    $0x10,%esp
  801453:	85 c0                	test   %eax,%eax
  801455:	78 06                	js     80145d <readn+0x39>
			return m;
		if (m == 0)
  801457:	74 06                	je     80145f <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801459:	01 c3                	add    %eax,%ebx
  80145b:	eb db                	jmp    801438 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80145d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80145f:	89 d8                	mov    %ebx,%eax
  801461:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801464:	5b                   	pop    %ebx
  801465:	5e                   	pop    %esi
  801466:	5f                   	pop    %edi
  801467:	5d                   	pop    %ebp
  801468:	c3                   	ret    

00801469 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
  80146c:	53                   	push   %ebx
  80146d:	83 ec 1c             	sub    $0x1c,%esp
  801470:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801473:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801476:	50                   	push   %eax
  801477:	53                   	push   %ebx
  801478:	e8 b0 fc ff ff       	call   80112d <fd_lookup>
  80147d:	83 c4 10             	add    $0x10,%esp
  801480:	85 c0                	test   %eax,%eax
  801482:	78 3a                	js     8014be <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801484:	83 ec 08             	sub    $0x8,%esp
  801487:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80148a:	50                   	push   %eax
  80148b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148e:	ff 30                	pushl  (%eax)
  801490:	e8 e8 fc ff ff       	call   80117d <dev_lookup>
  801495:	83 c4 10             	add    $0x10,%esp
  801498:	85 c0                	test   %eax,%eax
  80149a:	78 22                	js     8014be <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80149c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014a3:	74 1e                	je     8014c3 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014a8:	8b 52 0c             	mov    0xc(%edx),%edx
  8014ab:	85 d2                	test   %edx,%edx
  8014ad:	74 35                	je     8014e4 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014af:	83 ec 04             	sub    $0x4,%esp
  8014b2:	ff 75 10             	pushl  0x10(%ebp)
  8014b5:	ff 75 0c             	pushl  0xc(%ebp)
  8014b8:	50                   	push   %eax
  8014b9:	ff d2                	call   *%edx
  8014bb:	83 c4 10             	add    $0x10,%esp
}
  8014be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014c3:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8014c8:	8b 40 48             	mov    0x48(%eax),%eax
  8014cb:	83 ec 04             	sub    $0x4,%esp
  8014ce:	53                   	push   %ebx
  8014cf:	50                   	push   %eax
  8014d0:	68 b0 2a 80 00       	push   $0x802ab0
  8014d5:	e8 b4 ed ff ff       	call   80028e <cprintf>
		return -E_INVAL;
  8014da:	83 c4 10             	add    $0x10,%esp
  8014dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014e2:	eb da                	jmp    8014be <write+0x55>
		return -E_NOT_SUPP;
  8014e4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014e9:	eb d3                	jmp    8014be <write+0x55>

008014eb <seek>:

int
seek(int fdnum, off_t offset)
{
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
  8014ee:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f4:	50                   	push   %eax
  8014f5:	ff 75 08             	pushl  0x8(%ebp)
  8014f8:	e8 30 fc ff ff       	call   80112d <fd_lookup>
  8014fd:	83 c4 10             	add    $0x10,%esp
  801500:	85 c0                	test   %eax,%eax
  801502:	78 0e                	js     801512 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801504:	8b 55 0c             	mov    0xc(%ebp),%edx
  801507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80150a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80150d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	53                   	push   %ebx
  801518:	83 ec 1c             	sub    $0x1c,%esp
  80151b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80151e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801521:	50                   	push   %eax
  801522:	53                   	push   %ebx
  801523:	e8 05 fc ff ff       	call   80112d <fd_lookup>
  801528:	83 c4 10             	add    $0x10,%esp
  80152b:	85 c0                	test   %eax,%eax
  80152d:	78 37                	js     801566 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80152f:	83 ec 08             	sub    $0x8,%esp
  801532:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801535:	50                   	push   %eax
  801536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801539:	ff 30                	pushl  (%eax)
  80153b:	e8 3d fc ff ff       	call   80117d <dev_lookup>
  801540:	83 c4 10             	add    $0x10,%esp
  801543:	85 c0                	test   %eax,%eax
  801545:	78 1f                	js     801566 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80154e:	74 1b                	je     80156b <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801550:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801553:	8b 52 18             	mov    0x18(%edx),%edx
  801556:	85 d2                	test   %edx,%edx
  801558:	74 32                	je     80158c <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80155a:	83 ec 08             	sub    $0x8,%esp
  80155d:	ff 75 0c             	pushl  0xc(%ebp)
  801560:	50                   	push   %eax
  801561:	ff d2                	call   *%edx
  801563:	83 c4 10             	add    $0x10,%esp
}
  801566:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801569:	c9                   	leave  
  80156a:	c3                   	ret    
			thisenv->env_id, fdnum);
  80156b:	a1 20 40 c0 00       	mov    0xc04020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801570:	8b 40 48             	mov    0x48(%eax),%eax
  801573:	83 ec 04             	sub    $0x4,%esp
  801576:	53                   	push   %ebx
  801577:	50                   	push   %eax
  801578:	68 70 2a 80 00       	push   $0x802a70
  80157d:	e8 0c ed ff ff       	call   80028e <cprintf>
		return -E_INVAL;
  801582:	83 c4 10             	add    $0x10,%esp
  801585:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80158a:	eb da                	jmp    801566 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80158c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801591:	eb d3                	jmp    801566 <ftruncate+0x52>

00801593 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801593:	55                   	push   %ebp
  801594:	89 e5                	mov    %esp,%ebp
  801596:	53                   	push   %ebx
  801597:	83 ec 1c             	sub    $0x1c,%esp
  80159a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80159d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015a0:	50                   	push   %eax
  8015a1:	ff 75 08             	pushl  0x8(%ebp)
  8015a4:	e8 84 fb ff ff       	call   80112d <fd_lookup>
  8015a9:	83 c4 10             	add    $0x10,%esp
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	78 4b                	js     8015fb <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015b0:	83 ec 08             	sub    $0x8,%esp
  8015b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b6:	50                   	push   %eax
  8015b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ba:	ff 30                	pushl  (%eax)
  8015bc:	e8 bc fb ff ff       	call   80117d <dev_lookup>
  8015c1:	83 c4 10             	add    $0x10,%esp
  8015c4:	85 c0                	test   %eax,%eax
  8015c6:	78 33                	js     8015fb <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015cb:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015cf:	74 2f                	je     801600 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015d1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015d4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015db:	00 00 00 
	stat->st_isdir = 0;
  8015de:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015e5:	00 00 00 
	stat->st_dev = dev;
  8015e8:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015ee:	83 ec 08             	sub    $0x8,%esp
  8015f1:	53                   	push   %ebx
  8015f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8015f5:	ff 50 14             	call   *0x14(%eax)
  8015f8:	83 c4 10             	add    $0x10,%esp
}
  8015fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    
		return -E_NOT_SUPP;
  801600:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801605:	eb f4                	jmp    8015fb <fstat+0x68>

00801607 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
  80160a:	56                   	push   %esi
  80160b:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80160c:	83 ec 08             	sub    $0x8,%esp
  80160f:	6a 00                	push   $0x0
  801611:	ff 75 08             	pushl  0x8(%ebp)
  801614:	e8 22 02 00 00       	call   80183b <open>
  801619:	89 c3                	mov    %eax,%ebx
  80161b:	83 c4 10             	add    $0x10,%esp
  80161e:	85 c0                	test   %eax,%eax
  801620:	78 1b                	js     80163d <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801622:	83 ec 08             	sub    $0x8,%esp
  801625:	ff 75 0c             	pushl  0xc(%ebp)
  801628:	50                   	push   %eax
  801629:	e8 65 ff ff ff       	call   801593 <fstat>
  80162e:	89 c6                	mov    %eax,%esi
	close(fd);
  801630:	89 1c 24             	mov    %ebx,(%esp)
  801633:	e8 27 fc ff ff       	call   80125f <close>
	return r;
  801638:	83 c4 10             	add    $0x10,%esp
  80163b:	89 f3                	mov    %esi,%ebx
}
  80163d:	89 d8                	mov    %ebx,%eax
  80163f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801642:	5b                   	pop    %ebx
  801643:	5e                   	pop    %esi
  801644:	5d                   	pop    %ebp
  801645:	c3                   	ret    

00801646 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
  801649:	56                   	push   %esi
  80164a:	53                   	push   %ebx
  80164b:	89 c6                	mov    %eax,%esi
  80164d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80164f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801656:	74 27                	je     80167f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801658:	6a 07                	push   $0x7
  80165a:	68 00 50 c0 00       	push   $0xc05000
  80165f:	56                   	push   %esi
  801660:	ff 35 00 40 80 00    	pushl  0x804000
  801666:	e8 08 0c 00 00       	call   802273 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80166b:	83 c4 0c             	add    $0xc,%esp
  80166e:	6a 00                	push   $0x0
  801670:	53                   	push   %ebx
  801671:	6a 00                	push   $0x0
  801673:	e8 92 0b 00 00       	call   80220a <ipc_recv>
}
  801678:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80167b:	5b                   	pop    %ebx
  80167c:	5e                   	pop    %esi
  80167d:	5d                   	pop    %ebp
  80167e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80167f:	83 ec 0c             	sub    $0xc,%esp
  801682:	6a 01                	push   $0x1
  801684:	e8 42 0c 00 00       	call   8022cb <ipc_find_env>
  801689:	a3 00 40 80 00       	mov    %eax,0x804000
  80168e:	83 c4 10             	add    $0x10,%esp
  801691:	eb c5                	jmp    801658 <fsipc+0x12>

00801693 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801699:	8b 45 08             	mov    0x8(%ebp),%eax
  80169c:	8b 40 0c             	mov    0xc(%eax),%eax
  80169f:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.set_size.req_size = newsize;
  8016a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a7:	a3 04 50 c0 00       	mov    %eax,0xc05004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b1:	b8 02 00 00 00       	mov    $0x2,%eax
  8016b6:	e8 8b ff ff ff       	call   801646 <fsipc>
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <devfile_flush>:
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8016c9:	a3 00 50 c0 00       	mov    %eax,0xc05000
	return fsipc(FSREQ_FLUSH, NULL);
  8016ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d3:	b8 06 00 00 00       	mov    $0x6,%eax
  8016d8:	e8 69 ff ff ff       	call   801646 <fsipc>
}
  8016dd:	c9                   	leave  
  8016de:	c3                   	ret    

008016df <devfile_stat>:
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
  8016e2:	53                   	push   %ebx
  8016e3:	83 ec 04             	sub    $0x4,%esp
  8016e6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ef:	a3 00 50 c0 00       	mov    %eax,0xc05000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f9:	b8 05 00 00 00       	mov    $0x5,%eax
  8016fe:	e8 43 ff ff ff       	call   801646 <fsipc>
  801703:	85 c0                	test   %eax,%eax
  801705:	78 2c                	js     801733 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801707:	83 ec 08             	sub    $0x8,%esp
  80170a:	68 00 50 c0 00       	push   $0xc05000
  80170f:	53                   	push   %ebx
  801710:	e8 d8 f2 ff ff       	call   8009ed <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801715:	a1 80 50 c0 00       	mov    0xc05080,%eax
  80171a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801720:	a1 84 50 c0 00       	mov    0xc05084,%eax
  801725:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80172b:	83 c4 10             	add    $0x10,%esp
  80172e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801733:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <devfile_write>:
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	53                   	push   %ebx
  80173c:	83 ec 08             	sub    $0x8,%esp
  80173f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801742:	8b 45 08             	mov    0x8(%ebp),%eax
  801745:	8b 40 0c             	mov    0xc(%eax),%eax
  801748:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.write.req_n = n;
  80174d:	89 1d 04 50 c0 00    	mov    %ebx,0xc05004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801753:	53                   	push   %ebx
  801754:	ff 75 0c             	pushl  0xc(%ebp)
  801757:	68 08 50 c0 00       	push   $0xc05008
  80175c:	e8 7c f4 ff ff       	call   800bdd <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801761:	ba 00 00 00 00       	mov    $0x0,%edx
  801766:	b8 04 00 00 00       	mov    $0x4,%eax
  80176b:	e8 d6 fe ff ff       	call   801646 <fsipc>
  801770:	83 c4 10             	add    $0x10,%esp
  801773:	85 c0                	test   %eax,%eax
  801775:	78 0b                	js     801782 <devfile_write+0x4a>
	assert(r <= n);
  801777:	39 d8                	cmp    %ebx,%eax
  801779:	77 0c                	ja     801787 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80177b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801780:	7f 1e                	jg     8017a0 <devfile_write+0x68>
}
  801782:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801785:	c9                   	leave  
  801786:	c3                   	ret    
	assert(r <= n);
  801787:	68 e4 2a 80 00       	push   $0x802ae4
  80178c:	68 eb 2a 80 00       	push   $0x802aeb
  801791:	68 98 00 00 00       	push   $0x98
  801796:	68 00 2b 80 00       	push   $0x802b00
  80179b:	e8 f8 e9 ff ff       	call   800198 <_panic>
	assert(r <= PGSIZE);
  8017a0:	68 0b 2b 80 00       	push   $0x802b0b
  8017a5:	68 eb 2a 80 00       	push   $0x802aeb
  8017aa:	68 99 00 00 00       	push   $0x99
  8017af:	68 00 2b 80 00       	push   $0x802b00
  8017b4:	e8 df e9 ff ff       	call   800198 <_panic>

008017b9 <devfile_read>:
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
  8017bc:	56                   	push   %esi
  8017bd:	53                   	push   %ebx
  8017be:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8017c7:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.read.req_n = n;
  8017cc:	89 35 04 50 c0 00    	mov    %esi,0xc05004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d7:	b8 03 00 00 00       	mov    $0x3,%eax
  8017dc:	e8 65 fe ff ff       	call   801646 <fsipc>
  8017e1:	89 c3                	mov    %eax,%ebx
  8017e3:	85 c0                	test   %eax,%eax
  8017e5:	78 1f                	js     801806 <devfile_read+0x4d>
	assert(r <= n);
  8017e7:	39 f0                	cmp    %esi,%eax
  8017e9:	77 24                	ja     80180f <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017eb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017f0:	7f 33                	jg     801825 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017f2:	83 ec 04             	sub    $0x4,%esp
  8017f5:	50                   	push   %eax
  8017f6:	68 00 50 c0 00       	push   $0xc05000
  8017fb:	ff 75 0c             	pushl  0xc(%ebp)
  8017fe:	e8 78 f3 ff ff       	call   800b7b <memmove>
	return r;
  801803:	83 c4 10             	add    $0x10,%esp
}
  801806:	89 d8                	mov    %ebx,%eax
  801808:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80180b:	5b                   	pop    %ebx
  80180c:	5e                   	pop    %esi
  80180d:	5d                   	pop    %ebp
  80180e:	c3                   	ret    
	assert(r <= n);
  80180f:	68 e4 2a 80 00       	push   $0x802ae4
  801814:	68 eb 2a 80 00       	push   $0x802aeb
  801819:	6a 7c                	push   $0x7c
  80181b:	68 00 2b 80 00       	push   $0x802b00
  801820:	e8 73 e9 ff ff       	call   800198 <_panic>
	assert(r <= PGSIZE);
  801825:	68 0b 2b 80 00       	push   $0x802b0b
  80182a:	68 eb 2a 80 00       	push   $0x802aeb
  80182f:	6a 7d                	push   $0x7d
  801831:	68 00 2b 80 00       	push   $0x802b00
  801836:	e8 5d e9 ff ff       	call   800198 <_panic>

0080183b <open>:
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	56                   	push   %esi
  80183f:	53                   	push   %ebx
  801840:	83 ec 1c             	sub    $0x1c,%esp
  801843:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801846:	56                   	push   %esi
  801847:	e8 68 f1 ff ff       	call   8009b4 <strlen>
  80184c:	83 c4 10             	add    $0x10,%esp
  80184f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801854:	7f 6c                	jg     8018c2 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801856:	83 ec 0c             	sub    $0xc,%esp
  801859:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80185c:	50                   	push   %eax
  80185d:	e8 79 f8 ff ff       	call   8010db <fd_alloc>
  801862:	89 c3                	mov    %eax,%ebx
  801864:	83 c4 10             	add    $0x10,%esp
  801867:	85 c0                	test   %eax,%eax
  801869:	78 3c                	js     8018a7 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80186b:	83 ec 08             	sub    $0x8,%esp
  80186e:	56                   	push   %esi
  80186f:	68 00 50 c0 00       	push   $0xc05000
  801874:	e8 74 f1 ff ff       	call   8009ed <strcpy>
	fsipcbuf.open.req_omode = mode;
  801879:	8b 45 0c             	mov    0xc(%ebp),%eax
  80187c:	a3 00 54 c0 00       	mov    %eax,0xc05400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801881:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801884:	b8 01 00 00 00       	mov    $0x1,%eax
  801889:	e8 b8 fd ff ff       	call   801646 <fsipc>
  80188e:	89 c3                	mov    %eax,%ebx
  801890:	83 c4 10             	add    $0x10,%esp
  801893:	85 c0                	test   %eax,%eax
  801895:	78 19                	js     8018b0 <open+0x75>
	return fd2num(fd);
  801897:	83 ec 0c             	sub    $0xc,%esp
  80189a:	ff 75 f4             	pushl  -0xc(%ebp)
  80189d:	e8 12 f8 ff ff       	call   8010b4 <fd2num>
  8018a2:	89 c3                	mov    %eax,%ebx
  8018a4:	83 c4 10             	add    $0x10,%esp
}
  8018a7:	89 d8                	mov    %ebx,%eax
  8018a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ac:	5b                   	pop    %ebx
  8018ad:	5e                   	pop    %esi
  8018ae:	5d                   	pop    %ebp
  8018af:	c3                   	ret    
		fd_close(fd, 0);
  8018b0:	83 ec 08             	sub    $0x8,%esp
  8018b3:	6a 00                	push   $0x0
  8018b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b8:	e8 1b f9 ff ff       	call   8011d8 <fd_close>
		return r;
  8018bd:	83 c4 10             	add    $0x10,%esp
  8018c0:	eb e5                	jmp    8018a7 <open+0x6c>
		return -E_BAD_PATH;
  8018c2:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018c7:	eb de                	jmp    8018a7 <open+0x6c>

008018c9 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
  8018cc:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d4:	b8 08 00 00 00       	mov    $0x8,%eax
  8018d9:	e8 68 fd ff ff       	call   801646 <fsipc>
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8018e6:	68 17 2b 80 00       	push   $0x802b17
  8018eb:	ff 75 0c             	pushl  0xc(%ebp)
  8018ee:	e8 fa f0 ff ff       	call   8009ed <strcpy>
	return 0;
}
  8018f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    

008018fa <devsock_close>:
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
  8018fd:	53                   	push   %ebx
  8018fe:	83 ec 10             	sub    $0x10,%esp
  801901:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801904:	53                   	push   %ebx
  801905:	e8 fc 09 00 00       	call   802306 <pageref>
  80190a:	83 c4 10             	add    $0x10,%esp
		return 0;
  80190d:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801912:	83 f8 01             	cmp    $0x1,%eax
  801915:	74 07                	je     80191e <devsock_close+0x24>
}
  801917:	89 d0                	mov    %edx,%eax
  801919:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80191e:	83 ec 0c             	sub    $0xc,%esp
  801921:	ff 73 0c             	pushl  0xc(%ebx)
  801924:	e8 b9 02 00 00       	call   801be2 <nsipc_close>
  801929:	89 c2                	mov    %eax,%edx
  80192b:	83 c4 10             	add    $0x10,%esp
  80192e:	eb e7                	jmp    801917 <devsock_close+0x1d>

00801930 <devsock_write>:
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
  801933:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801936:	6a 00                	push   $0x0
  801938:	ff 75 10             	pushl  0x10(%ebp)
  80193b:	ff 75 0c             	pushl  0xc(%ebp)
  80193e:	8b 45 08             	mov    0x8(%ebp),%eax
  801941:	ff 70 0c             	pushl  0xc(%eax)
  801944:	e8 76 03 00 00       	call   801cbf <nsipc_send>
}
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <devsock_read>:
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801951:	6a 00                	push   $0x0
  801953:	ff 75 10             	pushl  0x10(%ebp)
  801956:	ff 75 0c             	pushl  0xc(%ebp)
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	ff 70 0c             	pushl  0xc(%eax)
  80195f:	e8 ef 02 00 00       	call   801c53 <nsipc_recv>
}
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <fd2sockid>:
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
  801969:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80196c:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80196f:	52                   	push   %edx
  801970:	50                   	push   %eax
  801971:	e8 b7 f7 ff ff       	call   80112d <fd_lookup>
  801976:	83 c4 10             	add    $0x10,%esp
  801979:	85 c0                	test   %eax,%eax
  80197b:	78 10                	js     80198d <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80197d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801980:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801986:	39 08                	cmp    %ecx,(%eax)
  801988:	75 05                	jne    80198f <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80198a:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    
		return -E_NOT_SUPP;
  80198f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801994:	eb f7                	jmp    80198d <fd2sockid+0x27>

00801996 <alloc_sockfd>:
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	56                   	push   %esi
  80199a:	53                   	push   %ebx
  80199b:	83 ec 1c             	sub    $0x1c,%esp
  80199e:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8019a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a3:	50                   	push   %eax
  8019a4:	e8 32 f7 ff ff       	call   8010db <fd_alloc>
  8019a9:	89 c3                	mov    %eax,%ebx
  8019ab:	83 c4 10             	add    $0x10,%esp
  8019ae:	85 c0                	test   %eax,%eax
  8019b0:	78 43                	js     8019f5 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8019b2:	83 ec 04             	sub    $0x4,%esp
  8019b5:	68 07 04 00 00       	push   $0x407
  8019ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8019bd:	6a 00                	push   $0x0
  8019bf:	e8 1b f4 ff ff       	call   800ddf <sys_page_alloc>
  8019c4:	89 c3                	mov    %eax,%ebx
  8019c6:	83 c4 10             	add    $0x10,%esp
  8019c9:	85 c0                	test   %eax,%eax
  8019cb:	78 28                	js     8019f5 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8019cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d0:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019d6:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8019d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019db:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8019e2:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8019e5:	83 ec 0c             	sub    $0xc,%esp
  8019e8:	50                   	push   %eax
  8019e9:	e8 c6 f6 ff ff       	call   8010b4 <fd2num>
  8019ee:	89 c3                	mov    %eax,%ebx
  8019f0:	83 c4 10             	add    $0x10,%esp
  8019f3:	eb 0c                	jmp    801a01 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8019f5:	83 ec 0c             	sub    $0xc,%esp
  8019f8:	56                   	push   %esi
  8019f9:	e8 e4 01 00 00       	call   801be2 <nsipc_close>
		return r;
  8019fe:	83 c4 10             	add    $0x10,%esp
}
  801a01:	89 d8                	mov    %ebx,%eax
  801a03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a06:	5b                   	pop    %ebx
  801a07:	5e                   	pop    %esi
  801a08:	5d                   	pop    %ebp
  801a09:	c3                   	ret    

00801a0a <accept>:
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
  801a0d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	e8 4e ff ff ff       	call   801966 <fd2sockid>
  801a18:	85 c0                	test   %eax,%eax
  801a1a:	78 1b                	js     801a37 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a1c:	83 ec 04             	sub    $0x4,%esp
  801a1f:	ff 75 10             	pushl  0x10(%ebp)
  801a22:	ff 75 0c             	pushl  0xc(%ebp)
  801a25:	50                   	push   %eax
  801a26:	e8 0e 01 00 00       	call   801b39 <nsipc_accept>
  801a2b:	83 c4 10             	add    $0x10,%esp
  801a2e:	85 c0                	test   %eax,%eax
  801a30:	78 05                	js     801a37 <accept+0x2d>
	return alloc_sockfd(r);
  801a32:	e8 5f ff ff ff       	call   801996 <alloc_sockfd>
}
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

00801a39 <bind>:
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
  801a3c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a42:	e8 1f ff ff ff       	call   801966 <fd2sockid>
  801a47:	85 c0                	test   %eax,%eax
  801a49:	78 12                	js     801a5d <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801a4b:	83 ec 04             	sub    $0x4,%esp
  801a4e:	ff 75 10             	pushl  0x10(%ebp)
  801a51:	ff 75 0c             	pushl  0xc(%ebp)
  801a54:	50                   	push   %eax
  801a55:	e8 31 01 00 00       	call   801b8b <nsipc_bind>
  801a5a:	83 c4 10             	add    $0x10,%esp
}
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <shutdown>:
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a65:	8b 45 08             	mov    0x8(%ebp),%eax
  801a68:	e8 f9 fe ff ff       	call   801966 <fd2sockid>
  801a6d:	85 c0                	test   %eax,%eax
  801a6f:	78 0f                	js     801a80 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a71:	83 ec 08             	sub    $0x8,%esp
  801a74:	ff 75 0c             	pushl  0xc(%ebp)
  801a77:	50                   	push   %eax
  801a78:	e8 43 01 00 00       	call   801bc0 <nsipc_shutdown>
  801a7d:	83 c4 10             	add    $0x10,%esp
}
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    

00801a82 <connect>:
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
  801a85:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a88:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8b:	e8 d6 fe ff ff       	call   801966 <fd2sockid>
  801a90:	85 c0                	test   %eax,%eax
  801a92:	78 12                	js     801aa6 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a94:	83 ec 04             	sub    $0x4,%esp
  801a97:	ff 75 10             	pushl  0x10(%ebp)
  801a9a:	ff 75 0c             	pushl  0xc(%ebp)
  801a9d:	50                   	push   %eax
  801a9e:	e8 59 01 00 00       	call   801bfc <nsipc_connect>
  801aa3:	83 c4 10             	add    $0x10,%esp
}
  801aa6:	c9                   	leave  
  801aa7:	c3                   	ret    

00801aa8 <listen>:
{
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
  801aab:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801aae:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab1:	e8 b0 fe ff ff       	call   801966 <fd2sockid>
  801ab6:	85 c0                	test   %eax,%eax
  801ab8:	78 0f                	js     801ac9 <listen+0x21>
	return nsipc_listen(r, backlog);
  801aba:	83 ec 08             	sub    $0x8,%esp
  801abd:	ff 75 0c             	pushl  0xc(%ebp)
  801ac0:	50                   	push   %eax
  801ac1:	e8 6b 01 00 00       	call   801c31 <nsipc_listen>
  801ac6:	83 c4 10             	add    $0x10,%esp
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <socket>:

int
socket(int domain, int type, int protocol)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
  801ace:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ad1:	ff 75 10             	pushl  0x10(%ebp)
  801ad4:	ff 75 0c             	pushl  0xc(%ebp)
  801ad7:	ff 75 08             	pushl  0x8(%ebp)
  801ada:	e8 3e 02 00 00       	call   801d1d <nsipc_socket>
  801adf:	83 c4 10             	add    $0x10,%esp
  801ae2:	85 c0                	test   %eax,%eax
  801ae4:	78 05                	js     801aeb <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801ae6:	e8 ab fe ff ff       	call   801996 <alloc_sockfd>
}
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
  801af0:	53                   	push   %ebx
  801af1:	83 ec 04             	sub    $0x4,%esp
  801af4:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801af6:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801afd:	74 26                	je     801b25 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801aff:	6a 07                	push   $0x7
  801b01:	68 00 60 c0 00       	push   $0xc06000
  801b06:	53                   	push   %ebx
  801b07:	ff 35 04 40 80 00    	pushl  0x804004
  801b0d:	e8 61 07 00 00       	call   802273 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b12:	83 c4 0c             	add    $0xc,%esp
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	e8 ea 06 00 00       	call   80220a <ipc_recv>
}
  801b20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b23:	c9                   	leave  
  801b24:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b25:	83 ec 0c             	sub    $0xc,%esp
  801b28:	6a 02                	push   $0x2
  801b2a:	e8 9c 07 00 00       	call   8022cb <ipc_find_env>
  801b2f:	a3 04 40 80 00       	mov    %eax,0x804004
  801b34:	83 c4 10             	add    $0x10,%esp
  801b37:	eb c6                	jmp    801aff <nsipc+0x12>

00801b39 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	56                   	push   %esi
  801b3d:	53                   	push   %ebx
  801b3e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b41:	8b 45 08             	mov    0x8(%ebp),%eax
  801b44:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b49:	8b 06                	mov    (%esi),%eax
  801b4b:	a3 04 60 c0 00       	mov    %eax,0xc06004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b50:	b8 01 00 00 00       	mov    $0x1,%eax
  801b55:	e8 93 ff ff ff       	call   801aed <nsipc>
  801b5a:	89 c3                	mov    %eax,%ebx
  801b5c:	85 c0                	test   %eax,%eax
  801b5e:	79 09                	jns    801b69 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b60:	89 d8                	mov    %ebx,%eax
  801b62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b65:	5b                   	pop    %ebx
  801b66:	5e                   	pop    %esi
  801b67:	5d                   	pop    %ebp
  801b68:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b69:	83 ec 04             	sub    $0x4,%esp
  801b6c:	ff 35 10 60 c0 00    	pushl  0xc06010
  801b72:	68 00 60 c0 00       	push   $0xc06000
  801b77:	ff 75 0c             	pushl  0xc(%ebp)
  801b7a:	e8 fc ef ff ff       	call   800b7b <memmove>
		*addrlen = ret->ret_addrlen;
  801b7f:	a1 10 60 c0 00       	mov    0xc06010,%eax
  801b84:	89 06                	mov    %eax,(%esi)
  801b86:	83 c4 10             	add    $0x10,%esp
	return r;
  801b89:	eb d5                	jmp    801b60 <nsipc_accept+0x27>

00801b8b <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
  801b8e:	53                   	push   %ebx
  801b8f:	83 ec 08             	sub    $0x8,%esp
  801b92:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b95:	8b 45 08             	mov    0x8(%ebp),%eax
  801b98:	a3 00 60 c0 00       	mov    %eax,0xc06000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b9d:	53                   	push   %ebx
  801b9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ba1:	68 04 60 c0 00       	push   $0xc06004
  801ba6:	e8 d0 ef ff ff       	call   800b7b <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801bab:	89 1d 14 60 c0 00    	mov    %ebx,0xc06014
	return nsipc(NSREQ_BIND);
  801bb1:	b8 02 00 00 00       	mov    $0x2,%eax
  801bb6:	e8 32 ff ff ff       	call   801aed <nsipc>
}
  801bbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc9:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.shutdown.req_how = how;
  801bce:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd1:	a3 04 60 c0 00       	mov    %eax,0xc06004
	return nsipc(NSREQ_SHUTDOWN);
  801bd6:	b8 03 00 00 00       	mov    $0x3,%eax
  801bdb:	e8 0d ff ff ff       	call   801aed <nsipc>
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <nsipc_close>:

int
nsipc_close(int s)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
  801be5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	a3 00 60 c0 00       	mov    %eax,0xc06000
	return nsipc(NSREQ_CLOSE);
  801bf0:	b8 04 00 00 00       	mov    $0x4,%eax
  801bf5:	e8 f3 fe ff ff       	call   801aed <nsipc>
}
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	53                   	push   %ebx
  801c00:	83 ec 08             	sub    $0x8,%esp
  801c03:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c06:	8b 45 08             	mov    0x8(%ebp),%eax
  801c09:	a3 00 60 c0 00       	mov    %eax,0xc06000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c0e:	53                   	push   %ebx
  801c0f:	ff 75 0c             	pushl  0xc(%ebp)
  801c12:	68 04 60 c0 00       	push   $0xc06004
  801c17:	e8 5f ef ff ff       	call   800b7b <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c1c:	89 1d 14 60 c0 00    	mov    %ebx,0xc06014
	return nsipc(NSREQ_CONNECT);
  801c22:	b8 05 00 00 00       	mov    $0x5,%eax
  801c27:	e8 c1 fe ff ff       	call   801aed <nsipc>
}
  801c2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
  801c34:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.listen.req_backlog = backlog;
  801c3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c42:	a3 04 60 c0 00       	mov    %eax,0xc06004
	return nsipc(NSREQ_LISTEN);
  801c47:	b8 06 00 00 00       	mov    $0x6,%eax
  801c4c:	e8 9c fe ff ff       	call   801aed <nsipc>
}
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    

00801c53 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
  801c56:	56                   	push   %esi
  801c57:	53                   	push   %ebx
  801c58:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5e:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.recv.req_len = len;
  801c63:	89 35 04 60 c0 00    	mov    %esi,0xc06004
	nsipcbuf.recv.req_flags = flags;
  801c69:	8b 45 14             	mov    0x14(%ebp),%eax
  801c6c:	a3 08 60 c0 00       	mov    %eax,0xc06008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c71:	b8 07 00 00 00       	mov    $0x7,%eax
  801c76:	e8 72 fe ff ff       	call   801aed <nsipc>
  801c7b:	89 c3                	mov    %eax,%ebx
  801c7d:	85 c0                	test   %eax,%eax
  801c7f:	78 1f                	js     801ca0 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c81:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c86:	7f 21                	jg     801ca9 <nsipc_recv+0x56>
  801c88:	39 c6                	cmp    %eax,%esi
  801c8a:	7c 1d                	jl     801ca9 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c8c:	83 ec 04             	sub    $0x4,%esp
  801c8f:	50                   	push   %eax
  801c90:	68 00 60 c0 00       	push   $0xc06000
  801c95:	ff 75 0c             	pushl  0xc(%ebp)
  801c98:	e8 de ee ff ff       	call   800b7b <memmove>
  801c9d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801ca0:	89 d8                	mov    %ebx,%eax
  801ca2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ca5:	5b                   	pop    %ebx
  801ca6:	5e                   	pop    %esi
  801ca7:	5d                   	pop    %ebp
  801ca8:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801ca9:	68 23 2b 80 00       	push   $0x802b23
  801cae:	68 eb 2a 80 00       	push   $0x802aeb
  801cb3:	6a 62                	push   $0x62
  801cb5:	68 38 2b 80 00       	push   $0x802b38
  801cba:	e8 d9 e4 ff ff       	call   800198 <_panic>

00801cbf <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
  801cc2:	53                   	push   %ebx
  801cc3:	83 ec 04             	sub    $0x4,%esp
  801cc6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	a3 00 60 c0 00       	mov    %eax,0xc06000
	assert(size < 1600);
  801cd1:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801cd7:	7f 2e                	jg     801d07 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801cd9:	83 ec 04             	sub    $0x4,%esp
  801cdc:	53                   	push   %ebx
  801cdd:	ff 75 0c             	pushl  0xc(%ebp)
  801ce0:	68 0c 60 c0 00       	push   $0xc0600c
  801ce5:	e8 91 ee ff ff       	call   800b7b <memmove>
	nsipcbuf.send.req_size = size;
  801cea:	89 1d 04 60 c0 00    	mov    %ebx,0xc06004
	nsipcbuf.send.req_flags = flags;
  801cf0:	8b 45 14             	mov    0x14(%ebp),%eax
  801cf3:	a3 08 60 c0 00       	mov    %eax,0xc06008
	return nsipc(NSREQ_SEND);
  801cf8:	b8 08 00 00 00       	mov    $0x8,%eax
  801cfd:	e8 eb fd ff ff       	call   801aed <nsipc>
}
  801d02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    
	assert(size < 1600);
  801d07:	68 44 2b 80 00       	push   $0x802b44
  801d0c:	68 eb 2a 80 00       	push   $0x802aeb
  801d11:	6a 6d                	push   $0x6d
  801d13:	68 38 2b 80 00       	push   $0x802b38
  801d18:	e8 7b e4 ff ff       	call   800198 <_panic>

00801d1d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
  801d20:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d23:	8b 45 08             	mov    0x8(%ebp),%eax
  801d26:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.socket.req_type = type;
  801d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2e:	a3 04 60 c0 00       	mov    %eax,0xc06004
	nsipcbuf.socket.req_protocol = protocol;
  801d33:	8b 45 10             	mov    0x10(%ebp),%eax
  801d36:	a3 08 60 c0 00       	mov    %eax,0xc06008
	return nsipc(NSREQ_SOCKET);
  801d3b:	b8 09 00 00 00       	mov    $0x9,%eax
  801d40:	e8 a8 fd ff ff       	call   801aed <nsipc>
}
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
  801d4a:	56                   	push   %esi
  801d4b:	53                   	push   %ebx
  801d4c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d4f:	83 ec 0c             	sub    $0xc,%esp
  801d52:	ff 75 08             	pushl  0x8(%ebp)
  801d55:	e8 6a f3 ff ff       	call   8010c4 <fd2data>
  801d5a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d5c:	83 c4 08             	add    $0x8,%esp
  801d5f:	68 50 2b 80 00       	push   $0x802b50
  801d64:	53                   	push   %ebx
  801d65:	e8 83 ec ff ff       	call   8009ed <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d6a:	8b 46 04             	mov    0x4(%esi),%eax
  801d6d:	2b 06                	sub    (%esi),%eax
  801d6f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d75:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d7c:	00 00 00 
	stat->st_dev = &devpipe;
  801d7f:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d86:	30 80 00 
	return 0;
}
  801d89:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d91:	5b                   	pop    %ebx
  801d92:	5e                   	pop    %esi
  801d93:	5d                   	pop    %ebp
  801d94:	c3                   	ret    

00801d95 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	53                   	push   %ebx
  801d99:	83 ec 0c             	sub    $0xc,%esp
  801d9c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d9f:	53                   	push   %ebx
  801da0:	6a 00                	push   $0x0
  801da2:	e8 bd f0 ff ff       	call   800e64 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801da7:	89 1c 24             	mov    %ebx,(%esp)
  801daa:	e8 15 f3 ff ff       	call   8010c4 <fd2data>
  801daf:	83 c4 08             	add    $0x8,%esp
  801db2:	50                   	push   %eax
  801db3:	6a 00                	push   $0x0
  801db5:	e8 aa f0 ff ff       	call   800e64 <sys_page_unmap>
}
  801dba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    

00801dbf <_pipeisclosed>:
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
  801dc2:	57                   	push   %edi
  801dc3:	56                   	push   %esi
  801dc4:	53                   	push   %ebx
  801dc5:	83 ec 1c             	sub    $0x1c,%esp
  801dc8:	89 c7                	mov    %eax,%edi
  801dca:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801dcc:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801dd1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801dd4:	83 ec 0c             	sub    $0xc,%esp
  801dd7:	57                   	push   %edi
  801dd8:	e8 29 05 00 00       	call   802306 <pageref>
  801ddd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801de0:	89 34 24             	mov    %esi,(%esp)
  801de3:	e8 1e 05 00 00       	call   802306 <pageref>
		nn = thisenv->env_runs;
  801de8:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  801dee:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801df1:	83 c4 10             	add    $0x10,%esp
  801df4:	39 cb                	cmp    %ecx,%ebx
  801df6:	74 1b                	je     801e13 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801df8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dfb:	75 cf                	jne    801dcc <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801dfd:	8b 42 58             	mov    0x58(%edx),%eax
  801e00:	6a 01                	push   $0x1
  801e02:	50                   	push   %eax
  801e03:	53                   	push   %ebx
  801e04:	68 57 2b 80 00       	push   $0x802b57
  801e09:	e8 80 e4 ff ff       	call   80028e <cprintf>
  801e0e:	83 c4 10             	add    $0x10,%esp
  801e11:	eb b9                	jmp    801dcc <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e13:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e16:	0f 94 c0             	sete   %al
  801e19:	0f b6 c0             	movzbl %al,%eax
}
  801e1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e1f:	5b                   	pop    %ebx
  801e20:	5e                   	pop    %esi
  801e21:	5f                   	pop    %edi
  801e22:	5d                   	pop    %ebp
  801e23:	c3                   	ret    

00801e24 <devpipe_write>:
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
  801e27:	57                   	push   %edi
  801e28:	56                   	push   %esi
  801e29:	53                   	push   %ebx
  801e2a:	83 ec 28             	sub    $0x28,%esp
  801e2d:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e30:	56                   	push   %esi
  801e31:	e8 8e f2 ff ff       	call   8010c4 <fd2data>
  801e36:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e38:	83 c4 10             	add    $0x10,%esp
  801e3b:	bf 00 00 00 00       	mov    $0x0,%edi
  801e40:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e43:	74 4f                	je     801e94 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e45:	8b 43 04             	mov    0x4(%ebx),%eax
  801e48:	8b 0b                	mov    (%ebx),%ecx
  801e4a:	8d 51 20             	lea    0x20(%ecx),%edx
  801e4d:	39 d0                	cmp    %edx,%eax
  801e4f:	72 14                	jb     801e65 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e51:	89 da                	mov    %ebx,%edx
  801e53:	89 f0                	mov    %esi,%eax
  801e55:	e8 65 ff ff ff       	call   801dbf <_pipeisclosed>
  801e5a:	85 c0                	test   %eax,%eax
  801e5c:	75 3b                	jne    801e99 <devpipe_write+0x75>
			sys_yield();
  801e5e:	e8 5d ef ff ff       	call   800dc0 <sys_yield>
  801e63:	eb e0                	jmp    801e45 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e68:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e6c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e6f:	89 c2                	mov    %eax,%edx
  801e71:	c1 fa 1f             	sar    $0x1f,%edx
  801e74:	89 d1                	mov    %edx,%ecx
  801e76:	c1 e9 1b             	shr    $0x1b,%ecx
  801e79:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e7c:	83 e2 1f             	and    $0x1f,%edx
  801e7f:	29 ca                	sub    %ecx,%edx
  801e81:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e85:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e89:	83 c0 01             	add    $0x1,%eax
  801e8c:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e8f:	83 c7 01             	add    $0x1,%edi
  801e92:	eb ac                	jmp    801e40 <devpipe_write+0x1c>
	return i;
  801e94:	8b 45 10             	mov    0x10(%ebp),%eax
  801e97:	eb 05                	jmp    801e9e <devpipe_write+0x7a>
				return 0;
  801e99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ea1:	5b                   	pop    %ebx
  801ea2:	5e                   	pop    %esi
  801ea3:	5f                   	pop    %edi
  801ea4:	5d                   	pop    %ebp
  801ea5:	c3                   	ret    

00801ea6 <devpipe_read>:
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
  801ea9:	57                   	push   %edi
  801eaa:	56                   	push   %esi
  801eab:	53                   	push   %ebx
  801eac:	83 ec 18             	sub    $0x18,%esp
  801eaf:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801eb2:	57                   	push   %edi
  801eb3:	e8 0c f2 ff ff       	call   8010c4 <fd2data>
  801eb8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801eba:	83 c4 10             	add    $0x10,%esp
  801ebd:	be 00 00 00 00       	mov    $0x0,%esi
  801ec2:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ec5:	75 14                	jne    801edb <devpipe_read+0x35>
	return i;
  801ec7:	8b 45 10             	mov    0x10(%ebp),%eax
  801eca:	eb 02                	jmp    801ece <devpipe_read+0x28>
				return i;
  801ecc:	89 f0                	mov    %esi,%eax
}
  801ece:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ed1:	5b                   	pop    %ebx
  801ed2:	5e                   	pop    %esi
  801ed3:	5f                   	pop    %edi
  801ed4:	5d                   	pop    %ebp
  801ed5:	c3                   	ret    
			sys_yield();
  801ed6:	e8 e5 ee ff ff       	call   800dc0 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801edb:	8b 03                	mov    (%ebx),%eax
  801edd:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ee0:	75 18                	jne    801efa <devpipe_read+0x54>
			if (i > 0)
  801ee2:	85 f6                	test   %esi,%esi
  801ee4:	75 e6                	jne    801ecc <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801ee6:	89 da                	mov    %ebx,%edx
  801ee8:	89 f8                	mov    %edi,%eax
  801eea:	e8 d0 fe ff ff       	call   801dbf <_pipeisclosed>
  801eef:	85 c0                	test   %eax,%eax
  801ef1:	74 e3                	je     801ed6 <devpipe_read+0x30>
				return 0;
  801ef3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef8:	eb d4                	jmp    801ece <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801efa:	99                   	cltd   
  801efb:	c1 ea 1b             	shr    $0x1b,%edx
  801efe:	01 d0                	add    %edx,%eax
  801f00:	83 e0 1f             	and    $0x1f,%eax
  801f03:	29 d0                	sub    %edx,%eax
  801f05:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f0d:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f10:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f13:	83 c6 01             	add    $0x1,%esi
  801f16:	eb aa                	jmp    801ec2 <devpipe_read+0x1c>

00801f18 <pipe>:
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
  801f1b:	56                   	push   %esi
  801f1c:	53                   	push   %ebx
  801f1d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f20:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f23:	50                   	push   %eax
  801f24:	e8 b2 f1 ff ff       	call   8010db <fd_alloc>
  801f29:	89 c3                	mov    %eax,%ebx
  801f2b:	83 c4 10             	add    $0x10,%esp
  801f2e:	85 c0                	test   %eax,%eax
  801f30:	0f 88 23 01 00 00    	js     802059 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f36:	83 ec 04             	sub    $0x4,%esp
  801f39:	68 07 04 00 00       	push   $0x407
  801f3e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f41:	6a 00                	push   $0x0
  801f43:	e8 97 ee ff ff       	call   800ddf <sys_page_alloc>
  801f48:	89 c3                	mov    %eax,%ebx
  801f4a:	83 c4 10             	add    $0x10,%esp
  801f4d:	85 c0                	test   %eax,%eax
  801f4f:	0f 88 04 01 00 00    	js     802059 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f55:	83 ec 0c             	sub    $0xc,%esp
  801f58:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f5b:	50                   	push   %eax
  801f5c:	e8 7a f1 ff ff       	call   8010db <fd_alloc>
  801f61:	89 c3                	mov    %eax,%ebx
  801f63:	83 c4 10             	add    $0x10,%esp
  801f66:	85 c0                	test   %eax,%eax
  801f68:	0f 88 db 00 00 00    	js     802049 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f6e:	83 ec 04             	sub    $0x4,%esp
  801f71:	68 07 04 00 00       	push   $0x407
  801f76:	ff 75 f0             	pushl  -0x10(%ebp)
  801f79:	6a 00                	push   $0x0
  801f7b:	e8 5f ee ff ff       	call   800ddf <sys_page_alloc>
  801f80:	89 c3                	mov    %eax,%ebx
  801f82:	83 c4 10             	add    $0x10,%esp
  801f85:	85 c0                	test   %eax,%eax
  801f87:	0f 88 bc 00 00 00    	js     802049 <pipe+0x131>
	va = fd2data(fd0);
  801f8d:	83 ec 0c             	sub    $0xc,%esp
  801f90:	ff 75 f4             	pushl  -0xc(%ebp)
  801f93:	e8 2c f1 ff ff       	call   8010c4 <fd2data>
  801f98:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f9a:	83 c4 0c             	add    $0xc,%esp
  801f9d:	68 07 04 00 00       	push   $0x407
  801fa2:	50                   	push   %eax
  801fa3:	6a 00                	push   $0x0
  801fa5:	e8 35 ee ff ff       	call   800ddf <sys_page_alloc>
  801faa:	89 c3                	mov    %eax,%ebx
  801fac:	83 c4 10             	add    $0x10,%esp
  801faf:	85 c0                	test   %eax,%eax
  801fb1:	0f 88 82 00 00 00    	js     802039 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fb7:	83 ec 0c             	sub    $0xc,%esp
  801fba:	ff 75 f0             	pushl  -0x10(%ebp)
  801fbd:	e8 02 f1 ff ff       	call   8010c4 <fd2data>
  801fc2:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801fc9:	50                   	push   %eax
  801fca:	6a 00                	push   $0x0
  801fcc:	56                   	push   %esi
  801fcd:	6a 00                	push   $0x0
  801fcf:	e8 4e ee ff ff       	call   800e22 <sys_page_map>
  801fd4:	89 c3                	mov    %eax,%ebx
  801fd6:	83 c4 20             	add    $0x20,%esp
  801fd9:	85 c0                	test   %eax,%eax
  801fdb:	78 4e                	js     80202b <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801fdd:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801fe2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fe5:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801fe7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fea:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801ff1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ff4:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801ff6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802000:	83 ec 0c             	sub    $0xc,%esp
  802003:	ff 75 f4             	pushl  -0xc(%ebp)
  802006:	e8 a9 f0 ff ff       	call   8010b4 <fd2num>
  80200b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80200e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802010:	83 c4 04             	add    $0x4,%esp
  802013:	ff 75 f0             	pushl  -0x10(%ebp)
  802016:	e8 99 f0 ff ff       	call   8010b4 <fd2num>
  80201b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80201e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802021:	83 c4 10             	add    $0x10,%esp
  802024:	bb 00 00 00 00       	mov    $0x0,%ebx
  802029:	eb 2e                	jmp    802059 <pipe+0x141>
	sys_page_unmap(0, va);
  80202b:	83 ec 08             	sub    $0x8,%esp
  80202e:	56                   	push   %esi
  80202f:	6a 00                	push   $0x0
  802031:	e8 2e ee ff ff       	call   800e64 <sys_page_unmap>
  802036:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802039:	83 ec 08             	sub    $0x8,%esp
  80203c:	ff 75 f0             	pushl  -0x10(%ebp)
  80203f:	6a 00                	push   $0x0
  802041:	e8 1e ee ff ff       	call   800e64 <sys_page_unmap>
  802046:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802049:	83 ec 08             	sub    $0x8,%esp
  80204c:	ff 75 f4             	pushl  -0xc(%ebp)
  80204f:	6a 00                	push   $0x0
  802051:	e8 0e ee ff ff       	call   800e64 <sys_page_unmap>
  802056:	83 c4 10             	add    $0x10,%esp
}
  802059:	89 d8                	mov    %ebx,%eax
  80205b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80205e:	5b                   	pop    %ebx
  80205f:	5e                   	pop    %esi
  802060:	5d                   	pop    %ebp
  802061:	c3                   	ret    

00802062 <pipeisclosed>:
{
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
  802065:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802068:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80206b:	50                   	push   %eax
  80206c:	ff 75 08             	pushl  0x8(%ebp)
  80206f:	e8 b9 f0 ff ff       	call   80112d <fd_lookup>
  802074:	83 c4 10             	add    $0x10,%esp
  802077:	85 c0                	test   %eax,%eax
  802079:	78 18                	js     802093 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80207b:	83 ec 0c             	sub    $0xc,%esp
  80207e:	ff 75 f4             	pushl  -0xc(%ebp)
  802081:	e8 3e f0 ff ff       	call   8010c4 <fd2data>
	return _pipeisclosed(fd, p);
  802086:	89 c2                	mov    %eax,%edx
  802088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208b:	e8 2f fd ff ff       	call   801dbf <_pipeisclosed>
  802090:	83 c4 10             	add    $0x10,%esp
}
  802093:	c9                   	leave  
  802094:	c3                   	ret    

00802095 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802095:	b8 00 00 00 00       	mov    $0x0,%eax
  80209a:	c3                   	ret    

0080209b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
  80209e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8020a1:	68 6f 2b 80 00       	push   $0x802b6f
  8020a6:	ff 75 0c             	pushl  0xc(%ebp)
  8020a9:	e8 3f e9 ff ff       	call   8009ed <strcpy>
	return 0;
}
  8020ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b3:	c9                   	leave  
  8020b4:	c3                   	ret    

008020b5 <devcons_write>:
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
  8020b8:	57                   	push   %edi
  8020b9:	56                   	push   %esi
  8020ba:	53                   	push   %ebx
  8020bb:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8020c1:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8020c6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8020cc:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020cf:	73 31                	jae    802102 <devcons_write+0x4d>
		m = n - tot;
  8020d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020d4:	29 f3                	sub    %esi,%ebx
  8020d6:	83 fb 7f             	cmp    $0x7f,%ebx
  8020d9:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8020de:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8020e1:	83 ec 04             	sub    $0x4,%esp
  8020e4:	53                   	push   %ebx
  8020e5:	89 f0                	mov    %esi,%eax
  8020e7:	03 45 0c             	add    0xc(%ebp),%eax
  8020ea:	50                   	push   %eax
  8020eb:	57                   	push   %edi
  8020ec:	e8 8a ea ff ff       	call   800b7b <memmove>
		sys_cputs(buf, m);
  8020f1:	83 c4 08             	add    $0x8,%esp
  8020f4:	53                   	push   %ebx
  8020f5:	57                   	push   %edi
  8020f6:	e8 28 ec ff ff       	call   800d23 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020fb:	01 de                	add    %ebx,%esi
  8020fd:	83 c4 10             	add    $0x10,%esp
  802100:	eb ca                	jmp    8020cc <devcons_write+0x17>
}
  802102:	89 f0                	mov    %esi,%eax
  802104:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802107:	5b                   	pop    %ebx
  802108:	5e                   	pop    %esi
  802109:	5f                   	pop    %edi
  80210a:	5d                   	pop    %ebp
  80210b:	c3                   	ret    

0080210c <devcons_read>:
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
  80210f:	83 ec 08             	sub    $0x8,%esp
  802112:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802117:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80211b:	74 21                	je     80213e <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80211d:	e8 1f ec ff ff       	call   800d41 <sys_cgetc>
  802122:	85 c0                	test   %eax,%eax
  802124:	75 07                	jne    80212d <devcons_read+0x21>
		sys_yield();
  802126:	e8 95 ec ff ff       	call   800dc0 <sys_yield>
  80212b:	eb f0                	jmp    80211d <devcons_read+0x11>
	if (c < 0)
  80212d:	78 0f                	js     80213e <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80212f:	83 f8 04             	cmp    $0x4,%eax
  802132:	74 0c                	je     802140 <devcons_read+0x34>
	*(char*)vbuf = c;
  802134:	8b 55 0c             	mov    0xc(%ebp),%edx
  802137:	88 02                	mov    %al,(%edx)
	return 1;
  802139:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    
		return 0;
  802140:	b8 00 00 00 00       	mov    $0x0,%eax
  802145:	eb f7                	jmp    80213e <devcons_read+0x32>

00802147 <cputchar>:
{
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
  80214a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80214d:	8b 45 08             	mov    0x8(%ebp),%eax
  802150:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802153:	6a 01                	push   $0x1
  802155:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802158:	50                   	push   %eax
  802159:	e8 c5 eb ff ff       	call   800d23 <sys_cputs>
}
  80215e:	83 c4 10             	add    $0x10,%esp
  802161:	c9                   	leave  
  802162:	c3                   	ret    

00802163 <getchar>:
{
  802163:	55                   	push   %ebp
  802164:	89 e5                	mov    %esp,%ebp
  802166:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802169:	6a 01                	push   $0x1
  80216b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80216e:	50                   	push   %eax
  80216f:	6a 00                	push   $0x0
  802171:	e8 27 f2 ff ff       	call   80139d <read>
	if (r < 0)
  802176:	83 c4 10             	add    $0x10,%esp
  802179:	85 c0                	test   %eax,%eax
  80217b:	78 06                	js     802183 <getchar+0x20>
	if (r < 1)
  80217d:	74 06                	je     802185 <getchar+0x22>
	return c;
  80217f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802183:	c9                   	leave  
  802184:	c3                   	ret    
		return -E_EOF;
  802185:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80218a:	eb f7                	jmp    802183 <getchar+0x20>

0080218c <iscons>:
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
  80218f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802192:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802195:	50                   	push   %eax
  802196:	ff 75 08             	pushl  0x8(%ebp)
  802199:	e8 8f ef ff ff       	call   80112d <fd_lookup>
  80219e:	83 c4 10             	add    $0x10,%esp
  8021a1:	85 c0                	test   %eax,%eax
  8021a3:	78 11                	js     8021b6 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8021a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a8:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021ae:	39 10                	cmp    %edx,(%eax)
  8021b0:	0f 94 c0             	sete   %al
  8021b3:	0f b6 c0             	movzbl %al,%eax
}
  8021b6:	c9                   	leave  
  8021b7:	c3                   	ret    

008021b8 <opencons>:
{
  8021b8:	55                   	push   %ebp
  8021b9:	89 e5                	mov    %esp,%ebp
  8021bb:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8021be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021c1:	50                   	push   %eax
  8021c2:	e8 14 ef ff ff       	call   8010db <fd_alloc>
  8021c7:	83 c4 10             	add    $0x10,%esp
  8021ca:	85 c0                	test   %eax,%eax
  8021cc:	78 3a                	js     802208 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021ce:	83 ec 04             	sub    $0x4,%esp
  8021d1:	68 07 04 00 00       	push   $0x407
  8021d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8021d9:	6a 00                	push   $0x0
  8021db:	e8 ff eb ff ff       	call   800ddf <sys_page_alloc>
  8021e0:	83 c4 10             	add    $0x10,%esp
  8021e3:	85 c0                	test   %eax,%eax
  8021e5:	78 21                	js     802208 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8021e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ea:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021f0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021fc:	83 ec 0c             	sub    $0xc,%esp
  8021ff:	50                   	push   %eax
  802200:	e8 af ee ff ff       	call   8010b4 <fd2num>
  802205:	83 c4 10             	add    $0x10,%esp
}
  802208:	c9                   	leave  
  802209:	c3                   	ret    

0080220a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
  80220d:	56                   	push   %esi
  80220e:	53                   	push   %ebx
  80220f:	8b 75 08             	mov    0x8(%ebp),%esi
  802212:	8b 45 0c             	mov    0xc(%ebp),%eax
  802215:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802218:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80221a:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80221f:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802222:	83 ec 0c             	sub    $0xc,%esp
  802225:	50                   	push   %eax
  802226:	e8 64 ed ff ff       	call   800f8f <sys_ipc_recv>
	if(ret < 0){
  80222b:	83 c4 10             	add    $0x10,%esp
  80222e:	85 c0                	test   %eax,%eax
  802230:	78 2b                	js     80225d <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802232:	85 f6                	test   %esi,%esi
  802234:	74 0a                	je     802240 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  802236:	a1 20 40 c0 00       	mov    0xc04020,%eax
  80223b:	8b 40 74             	mov    0x74(%eax),%eax
  80223e:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802240:	85 db                	test   %ebx,%ebx
  802242:	74 0a                	je     80224e <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802244:	a1 20 40 c0 00       	mov    0xc04020,%eax
  802249:	8b 40 78             	mov    0x78(%eax),%eax
  80224c:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  80224e:	a1 20 40 c0 00       	mov    0xc04020,%eax
  802253:	8b 40 70             	mov    0x70(%eax),%eax
}
  802256:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802259:	5b                   	pop    %ebx
  80225a:	5e                   	pop    %esi
  80225b:	5d                   	pop    %ebp
  80225c:	c3                   	ret    
		if(from_env_store)
  80225d:	85 f6                	test   %esi,%esi
  80225f:	74 06                	je     802267 <ipc_recv+0x5d>
			*from_env_store = 0;
  802261:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802267:	85 db                	test   %ebx,%ebx
  802269:	74 eb                	je     802256 <ipc_recv+0x4c>
			*perm_store = 0;
  80226b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802271:	eb e3                	jmp    802256 <ipc_recv+0x4c>

00802273 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802273:	55                   	push   %ebp
  802274:	89 e5                	mov    %esp,%ebp
  802276:	57                   	push   %edi
  802277:	56                   	push   %esi
  802278:	53                   	push   %ebx
  802279:	83 ec 0c             	sub    $0xc,%esp
  80227c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80227f:	8b 75 0c             	mov    0xc(%ebp),%esi
  802282:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802285:	85 db                	test   %ebx,%ebx
  802287:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80228c:	0f 44 d8             	cmove  %eax,%ebx
  80228f:	eb 05                	jmp    802296 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802291:	e8 2a eb ff ff       	call   800dc0 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802296:	ff 75 14             	pushl  0x14(%ebp)
  802299:	53                   	push   %ebx
  80229a:	56                   	push   %esi
  80229b:	57                   	push   %edi
  80229c:	e8 cb ec ff ff       	call   800f6c <sys_ipc_try_send>
  8022a1:	83 c4 10             	add    $0x10,%esp
  8022a4:	85 c0                	test   %eax,%eax
  8022a6:	74 1b                	je     8022c3 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8022a8:	79 e7                	jns    802291 <ipc_send+0x1e>
  8022aa:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022ad:	74 e2                	je     802291 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8022af:	83 ec 04             	sub    $0x4,%esp
  8022b2:	68 7b 2b 80 00       	push   $0x802b7b
  8022b7:	6a 48                	push   $0x48
  8022b9:	68 90 2b 80 00       	push   $0x802b90
  8022be:	e8 d5 de ff ff       	call   800198 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8022c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022c6:	5b                   	pop    %ebx
  8022c7:	5e                   	pop    %esi
  8022c8:	5f                   	pop    %edi
  8022c9:	5d                   	pop    %ebp
  8022ca:	c3                   	ret    

008022cb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
  8022ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022d1:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022d6:	89 c2                	mov    %eax,%edx
  8022d8:	c1 e2 07             	shl    $0x7,%edx
  8022db:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022e1:	8b 52 50             	mov    0x50(%edx),%edx
  8022e4:	39 ca                	cmp    %ecx,%edx
  8022e6:	74 11                	je     8022f9 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8022e8:	83 c0 01             	add    $0x1,%eax
  8022eb:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022f0:	75 e4                	jne    8022d6 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f7:	eb 0b                	jmp    802304 <ipc_find_env+0x39>
			return envs[i].env_id;
  8022f9:	c1 e0 07             	shl    $0x7,%eax
  8022fc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802301:	8b 40 48             	mov    0x48(%eax),%eax
}
  802304:	5d                   	pop    %ebp
  802305:	c3                   	ret    

00802306 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
  802309:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80230c:	89 d0                	mov    %edx,%eax
  80230e:	c1 e8 16             	shr    $0x16,%eax
  802311:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802318:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80231d:	f6 c1 01             	test   $0x1,%cl
  802320:	74 1d                	je     80233f <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802322:	c1 ea 0c             	shr    $0xc,%edx
  802325:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80232c:	f6 c2 01             	test   $0x1,%dl
  80232f:	74 0e                	je     80233f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802331:	c1 ea 0c             	shr    $0xc,%edx
  802334:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80233b:	ef 
  80233c:	0f b7 c0             	movzwl %ax,%eax
}
  80233f:	5d                   	pop    %ebp
  802340:	c3                   	ret    
  802341:	66 90                	xchg   %ax,%ax
  802343:	66 90                	xchg   %ax,%ax
  802345:	66 90                	xchg   %ax,%ax
  802347:	66 90                	xchg   %ax,%ax
  802349:	66 90                	xchg   %ax,%ax
  80234b:	66 90                	xchg   %ax,%ax
  80234d:	66 90                	xchg   %ax,%ax
  80234f:	90                   	nop

00802350 <__udivdi3>:
  802350:	55                   	push   %ebp
  802351:	57                   	push   %edi
  802352:	56                   	push   %esi
  802353:	53                   	push   %ebx
  802354:	83 ec 1c             	sub    $0x1c,%esp
  802357:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80235b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80235f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802363:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802367:	85 d2                	test   %edx,%edx
  802369:	75 4d                	jne    8023b8 <__udivdi3+0x68>
  80236b:	39 f3                	cmp    %esi,%ebx
  80236d:	76 19                	jbe    802388 <__udivdi3+0x38>
  80236f:	31 ff                	xor    %edi,%edi
  802371:	89 e8                	mov    %ebp,%eax
  802373:	89 f2                	mov    %esi,%edx
  802375:	f7 f3                	div    %ebx
  802377:	89 fa                	mov    %edi,%edx
  802379:	83 c4 1c             	add    $0x1c,%esp
  80237c:	5b                   	pop    %ebx
  80237d:	5e                   	pop    %esi
  80237e:	5f                   	pop    %edi
  80237f:	5d                   	pop    %ebp
  802380:	c3                   	ret    
  802381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802388:	89 d9                	mov    %ebx,%ecx
  80238a:	85 db                	test   %ebx,%ebx
  80238c:	75 0b                	jne    802399 <__udivdi3+0x49>
  80238e:	b8 01 00 00 00       	mov    $0x1,%eax
  802393:	31 d2                	xor    %edx,%edx
  802395:	f7 f3                	div    %ebx
  802397:	89 c1                	mov    %eax,%ecx
  802399:	31 d2                	xor    %edx,%edx
  80239b:	89 f0                	mov    %esi,%eax
  80239d:	f7 f1                	div    %ecx
  80239f:	89 c6                	mov    %eax,%esi
  8023a1:	89 e8                	mov    %ebp,%eax
  8023a3:	89 f7                	mov    %esi,%edi
  8023a5:	f7 f1                	div    %ecx
  8023a7:	89 fa                	mov    %edi,%edx
  8023a9:	83 c4 1c             	add    $0x1c,%esp
  8023ac:	5b                   	pop    %ebx
  8023ad:	5e                   	pop    %esi
  8023ae:	5f                   	pop    %edi
  8023af:	5d                   	pop    %ebp
  8023b0:	c3                   	ret    
  8023b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023b8:	39 f2                	cmp    %esi,%edx
  8023ba:	77 1c                	ja     8023d8 <__udivdi3+0x88>
  8023bc:	0f bd fa             	bsr    %edx,%edi
  8023bf:	83 f7 1f             	xor    $0x1f,%edi
  8023c2:	75 2c                	jne    8023f0 <__udivdi3+0xa0>
  8023c4:	39 f2                	cmp    %esi,%edx
  8023c6:	72 06                	jb     8023ce <__udivdi3+0x7e>
  8023c8:	31 c0                	xor    %eax,%eax
  8023ca:	39 eb                	cmp    %ebp,%ebx
  8023cc:	77 a9                	ja     802377 <__udivdi3+0x27>
  8023ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8023d3:	eb a2                	jmp    802377 <__udivdi3+0x27>
  8023d5:	8d 76 00             	lea    0x0(%esi),%esi
  8023d8:	31 ff                	xor    %edi,%edi
  8023da:	31 c0                	xor    %eax,%eax
  8023dc:	89 fa                	mov    %edi,%edx
  8023de:	83 c4 1c             	add    $0x1c,%esp
  8023e1:	5b                   	pop    %ebx
  8023e2:	5e                   	pop    %esi
  8023e3:	5f                   	pop    %edi
  8023e4:	5d                   	pop    %ebp
  8023e5:	c3                   	ret    
  8023e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023ed:	8d 76 00             	lea    0x0(%esi),%esi
  8023f0:	89 f9                	mov    %edi,%ecx
  8023f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023f7:	29 f8                	sub    %edi,%eax
  8023f9:	d3 e2                	shl    %cl,%edx
  8023fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023ff:	89 c1                	mov    %eax,%ecx
  802401:	89 da                	mov    %ebx,%edx
  802403:	d3 ea                	shr    %cl,%edx
  802405:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802409:	09 d1                	or     %edx,%ecx
  80240b:	89 f2                	mov    %esi,%edx
  80240d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802411:	89 f9                	mov    %edi,%ecx
  802413:	d3 e3                	shl    %cl,%ebx
  802415:	89 c1                	mov    %eax,%ecx
  802417:	d3 ea                	shr    %cl,%edx
  802419:	89 f9                	mov    %edi,%ecx
  80241b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80241f:	89 eb                	mov    %ebp,%ebx
  802421:	d3 e6                	shl    %cl,%esi
  802423:	89 c1                	mov    %eax,%ecx
  802425:	d3 eb                	shr    %cl,%ebx
  802427:	09 de                	or     %ebx,%esi
  802429:	89 f0                	mov    %esi,%eax
  80242b:	f7 74 24 08          	divl   0x8(%esp)
  80242f:	89 d6                	mov    %edx,%esi
  802431:	89 c3                	mov    %eax,%ebx
  802433:	f7 64 24 0c          	mull   0xc(%esp)
  802437:	39 d6                	cmp    %edx,%esi
  802439:	72 15                	jb     802450 <__udivdi3+0x100>
  80243b:	89 f9                	mov    %edi,%ecx
  80243d:	d3 e5                	shl    %cl,%ebp
  80243f:	39 c5                	cmp    %eax,%ebp
  802441:	73 04                	jae    802447 <__udivdi3+0xf7>
  802443:	39 d6                	cmp    %edx,%esi
  802445:	74 09                	je     802450 <__udivdi3+0x100>
  802447:	89 d8                	mov    %ebx,%eax
  802449:	31 ff                	xor    %edi,%edi
  80244b:	e9 27 ff ff ff       	jmp    802377 <__udivdi3+0x27>
  802450:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802453:	31 ff                	xor    %edi,%edi
  802455:	e9 1d ff ff ff       	jmp    802377 <__udivdi3+0x27>
  80245a:	66 90                	xchg   %ax,%ax
  80245c:	66 90                	xchg   %ax,%ax
  80245e:	66 90                	xchg   %ax,%ax

00802460 <__umoddi3>:
  802460:	55                   	push   %ebp
  802461:	57                   	push   %edi
  802462:	56                   	push   %esi
  802463:	53                   	push   %ebx
  802464:	83 ec 1c             	sub    $0x1c,%esp
  802467:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80246b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80246f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802473:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802477:	89 da                	mov    %ebx,%edx
  802479:	85 c0                	test   %eax,%eax
  80247b:	75 43                	jne    8024c0 <__umoddi3+0x60>
  80247d:	39 df                	cmp    %ebx,%edi
  80247f:	76 17                	jbe    802498 <__umoddi3+0x38>
  802481:	89 f0                	mov    %esi,%eax
  802483:	f7 f7                	div    %edi
  802485:	89 d0                	mov    %edx,%eax
  802487:	31 d2                	xor    %edx,%edx
  802489:	83 c4 1c             	add    $0x1c,%esp
  80248c:	5b                   	pop    %ebx
  80248d:	5e                   	pop    %esi
  80248e:	5f                   	pop    %edi
  80248f:	5d                   	pop    %ebp
  802490:	c3                   	ret    
  802491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802498:	89 fd                	mov    %edi,%ebp
  80249a:	85 ff                	test   %edi,%edi
  80249c:	75 0b                	jne    8024a9 <__umoddi3+0x49>
  80249e:	b8 01 00 00 00       	mov    $0x1,%eax
  8024a3:	31 d2                	xor    %edx,%edx
  8024a5:	f7 f7                	div    %edi
  8024a7:	89 c5                	mov    %eax,%ebp
  8024a9:	89 d8                	mov    %ebx,%eax
  8024ab:	31 d2                	xor    %edx,%edx
  8024ad:	f7 f5                	div    %ebp
  8024af:	89 f0                	mov    %esi,%eax
  8024b1:	f7 f5                	div    %ebp
  8024b3:	89 d0                	mov    %edx,%eax
  8024b5:	eb d0                	jmp    802487 <__umoddi3+0x27>
  8024b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024be:	66 90                	xchg   %ax,%ax
  8024c0:	89 f1                	mov    %esi,%ecx
  8024c2:	39 d8                	cmp    %ebx,%eax
  8024c4:	76 0a                	jbe    8024d0 <__umoddi3+0x70>
  8024c6:	89 f0                	mov    %esi,%eax
  8024c8:	83 c4 1c             	add    $0x1c,%esp
  8024cb:	5b                   	pop    %ebx
  8024cc:	5e                   	pop    %esi
  8024cd:	5f                   	pop    %edi
  8024ce:	5d                   	pop    %ebp
  8024cf:	c3                   	ret    
  8024d0:	0f bd e8             	bsr    %eax,%ebp
  8024d3:	83 f5 1f             	xor    $0x1f,%ebp
  8024d6:	75 20                	jne    8024f8 <__umoddi3+0x98>
  8024d8:	39 d8                	cmp    %ebx,%eax
  8024da:	0f 82 b0 00 00 00    	jb     802590 <__umoddi3+0x130>
  8024e0:	39 f7                	cmp    %esi,%edi
  8024e2:	0f 86 a8 00 00 00    	jbe    802590 <__umoddi3+0x130>
  8024e8:	89 c8                	mov    %ecx,%eax
  8024ea:	83 c4 1c             	add    $0x1c,%esp
  8024ed:	5b                   	pop    %ebx
  8024ee:	5e                   	pop    %esi
  8024ef:	5f                   	pop    %edi
  8024f0:	5d                   	pop    %ebp
  8024f1:	c3                   	ret    
  8024f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024f8:	89 e9                	mov    %ebp,%ecx
  8024fa:	ba 20 00 00 00       	mov    $0x20,%edx
  8024ff:	29 ea                	sub    %ebp,%edx
  802501:	d3 e0                	shl    %cl,%eax
  802503:	89 44 24 08          	mov    %eax,0x8(%esp)
  802507:	89 d1                	mov    %edx,%ecx
  802509:	89 f8                	mov    %edi,%eax
  80250b:	d3 e8                	shr    %cl,%eax
  80250d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802511:	89 54 24 04          	mov    %edx,0x4(%esp)
  802515:	8b 54 24 04          	mov    0x4(%esp),%edx
  802519:	09 c1                	or     %eax,%ecx
  80251b:	89 d8                	mov    %ebx,%eax
  80251d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802521:	89 e9                	mov    %ebp,%ecx
  802523:	d3 e7                	shl    %cl,%edi
  802525:	89 d1                	mov    %edx,%ecx
  802527:	d3 e8                	shr    %cl,%eax
  802529:	89 e9                	mov    %ebp,%ecx
  80252b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80252f:	d3 e3                	shl    %cl,%ebx
  802531:	89 c7                	mov    %eax,%edi
  802533:	89 d1                	mov    %edx,%ecx
  802535:	89 f0                	mov    %esi,%eax
  802537:	d3 e8                	shr    %cl,%eax
  802539:	89 e9                	mov    %ebp,%ecx
  80253b:	89 fa                	mov    %edi,%edx
  80253d:	d3 e6                	shl    %cl,%esi
  80253f:	09 d8                	or     %ebx,%eax
  802541:	f7 74 24 08          	divl   0x8(%esp)
  802545:	89 d1                	mov    %edx,%ecx
  802547:	89 f3                	mov    %esi,%ebx
  802549:	f7 64 24 0c          	mull   0xc(%esp)
  80254d:	89 c6                	mov    %eax,%esi
  80254f:	89 d7                	mov    %edx,%edi
  802551:	39 d1                	cmp    %edx,%ecx
  802553:	72 06                	jb     80255b <__umoddi3+0xfb>
  802555:	75 10                	jne    802567 <__umoddi3+0x107>
  802557:	39 c3                	cmp    %eax,%ebx
  802559:	73 0c                	jae    802567 <__umoddi3+0x107>
  80255b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80255f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802563:	89 d7                	mov    %edx,%edi
  802565:	89 c6                	mov    %eax,%esi
  802567:	89 ca                	mov    %ecx,%edx
  802569:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80256e:	29 f3                	sub    %esi,%ebx
  802570:	19 fa                	sbb    %edi,%edx
  802572:	89 d0                	mov    %edx,%eax
  802574:	d3 e0                	shl    %cl,%eax
  802576:	89 e9                	mov    %ebp,%ecx
  802578:	d3 eb                	shr    %cl,%ebx
  80257a:	d3 ea                	shr    %cl,%edx
  80257c:	09 d8                	or     %ebx,%eax
  80257e:	83 c4 1c             	add    $0x1c,%esp
  802581:	5b                   	pop    %ebx
  802582:	5e                   	pop    %esi
  802583:	5f                   	pop    %edi
  802584:	5d                   	pop    %ebp
  802585:	c3                   	ret    
  802586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80258d:	8d 76 00             	lea    0x0(%esi),%esi
  802590:	89 da                	mov    %ebx,%edx
  802592:	29 fe                	sub    %edi,%esi
  802594:	19 c2                	sbb    %eax,%edx
  802596:	89 f1                	mov    %esi,%ecx
  802598:	89 c8                	mov    %ecx,%eax
  80259a:	e9 4b ff ff ff       	jmp    8024ea <__umoddi3+0x8a>
