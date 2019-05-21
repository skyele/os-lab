
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
  800039:	68 60 12 80 00       	push   $0x801260
  80003e:	e8 36 02 00 00       	call   800279 <cprintf>
  800043:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < ARRAYSIZE; i++)
  800046:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
  80004b:	83 3c 85 20 20 80 00 	cmpl   $0x0,0x802020(,%eax,4)
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
  800064:	89 04 85 20 20 80 00 	mov    %eax,0x802020(,%eax,4)
	for (i = 0; i < ARRAYSIZE; i++)
  80006b:	83 c0 01             	add    $0x1,%eax
  80006e:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800073:	75 ef                	jne    800064 <umain+0x31>
	for (i = 0; i < ARRAYSIZE; i++)
  800075:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != i)
  80007a:	39 04 85 20 20 80 00 	cmp    %eax,0x802020(,%eax,4)
  800081:	75 47                	jne    8000ca <umain+0x97>
	for (i = 0; i < ARRAYSIZE; i++)
  800083:	83 c0 01             	add    $0x1,%eax
  800086:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80008b:	75 ed                	jne    80007a <umain+0x47>
			panic("bigarray[%d] didn't hold its value!\n", i);

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  80008d:	83 ec 0c             	sub    $0xc,%esp
  800090:	68 a8 12 80 00       	push   $0x8012a8
  800095:	e8 df 01 00 00       	call   800279 <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  80009a:	c7 05 20 30 c0 00 00 	movl   $0x0,0xc03020
  8000a1:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  8000a4:	83 c4 0c             	add    $0xc,%esp
  8000a7:	68 07 13 80 00       	push   $0x801307
  8000ac:	6a 1a                	push   $0x1a
  8000ae:	68 f8 12 80 00       	push   $0x8012f8
  8000b3:	e8 cb 00 00 00       	call   800183 <_panic>
			panic("bigarray[%d] isn't cleared!\n", i);
  8000b8:	50                   	push   %eax
  8000b9:	68 db 12 80 00       	push   $0x8012db
  8000be:	6a 11                	push   $0x11
  8000c0:	68 f8 12 80 00       	push   $0x8012f8
  8000c5:	e8 b9 00 00 00       	call   800183 <_panic>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000ca:	50                   	push   %eax
  8000cb:	68 80 12 80 00       	push   $0x801280
  8000d0:	6a 16                	push   $0x16
  8000d2:	68 f8 12 80 00       	push   $0x8012f8
  8000d7:	e8 a7 00 00 00       	call   800183 <_panic>

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
  8000e5:	c7 05 20 20 c0 00 00 	movl   $0x0,0xc02020
  8000ec:	00 00 00 
	envid_t find = sys_getenvid();
  8000ef:	e8 98 0c 00 00       	call   800d8c <sys_getenvid>
  8000f4:	8b 1d 20 20 c0 00    	mov    0xc02020,%ebx
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
  80013d:	89 1d 20 20 c0 00    	mov    %ebx,0xc02020
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800143:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800147:	7e 0a                	jle    800153 <libmain+0x77>
		binaryname = argv[0];
  800149:	8b 45 0c             	mov    0xc(%ebp),%eax
  80014c:	8b 00                	mov    (%eax),%eax
  80014e:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800153:	83 ec 08             	sub    $0x8,%esp
  800156:	ff 75 0c             	pushl  0xc(%ebp)
  800159:	ff 75 08             	pushl  0x8(%ebp)
  80015c:	e8 d2 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800161:	e8 0b 00 00 00       	call   800171 <exit>
}
  800166:	83 c4 10             	add    $0x10,%esp
  800169:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80016c:	5b                   	pop    %ebx
  80016d:	5e                   	pop    %esi
  80016e:	5f                   	pop    %edi
  80016f:	5d                   	pop    %ebp
  800170:	c3                   	ret    

00800171 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800171:	55                   	push   %ebp
  800172:	89 e5                	mov    %esp,%ebp
  800174:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800177:	6a 00                	push   $0x0
  800179:	e8 cd 0b 00 00       	call   800d4b <sys_env_destroy>
}
  80017e:	83 c4 10             	add    $0x10,%esp
  800181:	c9                   	leave  
  800182:	c3                   	ret    

00800183 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800183:	55                   	push   %ebp
  800184:	89 e5                	mov    %esp,%ebp
  800186:	56                   	push   %esi
  800187:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800188:	a1 20 20 c0 00       	mov    0xc02020,%eax
  80018d:	8b 40 48             	mov    0x48(%eax),%eax
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	68 58 13 80 00       	push   $0x801358
  800198:	50                   	push   %eax
  800199:	68 28 13 80 00       	push   $0x801328
  80019e:	e8 d6 00 00 00       	call   800279 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8001a3:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001a6:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8001ac:	e8 db 0b 00 00       	call   800d8c <sys_getenvid>
  8001b1:	83 c4 04             	add    $0x4,%esp
  8001b4:	ff 75 0c             	pushl  0xc(%ebp)
  8001b7:	ff 75 08             	pushl  0x8(%ebp)
  8001ba:	56                   	push   %esi
  8001bb:	50                   	push   %eax
  8001bc:	68 34 13 80 00       	push   $0x801334
  8001c1:	e8 b3 00 00 00       	call   800279 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001c6:	83 c4 18             	add    $0x18,%esp
  8001c9:	53                   	push   %ebx
  8001ca:	ff 75 10             	pushl  0x10(%ebp)
  8001cd:	e8 56 00 00 00       	call   800228 <vcprintf>
	cprintf("\n");
  8001d2:	c7 04 24 f6 12 80 00 	movl   $0x8012f6,(%esp)
  8001d9:	e8 9b 00 00 00       	call   800279 <cprintf>
  8001de:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001e1:	cc                   	int3   
  8001e2:	eb fd                	jmp    8001e1 <_panic+0x5e>

008001e4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001e4:	55                   	push   %ebp
  8001e5:	89 e5                	mov    %esp,%ebp
  8001e7:	53                   	push   %ebx
  8001e8:	83 ec 04             	sub    $0x4,%esp
  8001eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001ee:	8b 13                	mov    (%ebx),%edx
  8001f0:	8d 42 01             	lea    0x1(%edx),%eax
  8001f3:	89 03                	mov    %eax,(%ebx)
  8001f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001f8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001fc:	3d ff 00 00 00       	cmp    $0xff,%eax
  800201:	74 09                	je     80020c <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800203:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800207:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80020a:	c9                   	leave  
  80020b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80020c:	83 ec 08             	sub    $0x8,%esp
  80020f:	68 ff 00 00 00       	push   $0xff
  800214:	8d 43 08             	lea    0x8(%ebx),%eax
  800217:	50                   	push   %eax
  800218:	e8 f1 0a 00 00       	call   800d0e <sys_cputs>
		b->idx = 0;
  80021d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800223:	83 c4 10             	add    $0x10,%esp
  800226:	eb db                	jmp    800203 <putch+0x1f>

00800228 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800228:	55                   	push   %ebp
  800229:	89 e5                	mov    %esp,%ebp
  80022b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800231:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800238:	00 00 00 
	b.cnt = 0;
  80023b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800242:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800245:	ff 75 0c             	pushl  0xc(%ebp)
  800248:	ff 75 08             	pushl  0x8(%ebp)
  80024b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800251:	50                   	push   %eax
  800252:	68 e4 01 80 00       	push   $0x8001e4
  800257:	e8 4a 01 00 00       	call   8003a6 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80025c:	83 c4 08             	add    $0x8,%esp
  80025f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800265:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80026b:	50                   	push   %eax
  80026c:	e8 9d 0a 00 00       	call   800d0e <sys_cputs>

	return b.cnt;
}
  800271:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800277:	c9                   	leave  
  800278:	c3                   	ret    

00800279 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80027f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800282:	50                   	push   %eax
  800283:	ff 75 08             	pushl  0x8(%ebp)
  800286:	e8 9d ff ff ff       	call   800228 <vcprintf>
	va_end(ap);

	return cnt;
}
  80028b:	c9                   	leave  
  80028c:	c3                   	ret    

0080028d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80028d:	55                   	push   %ebp
  80028e:	89 e5                	mov    %esp,%ebp
  800290:	57                   	push   %edi
  800291:	56                   	push   %esi
  800292:	53                   	push   %ebx
  800293:	83 ec 1c             	sub    $0x1c,%esp
  800296:	89 c6                	mov    %eax,%esi
  800298:	89 d7                	mov    %edx,%edi
  80029a:	8b 45 08             	mov    0x8(%ebp),%eax
  80029d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002a3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a9:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8002ac:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002b0:	74 2c                	je     8002de <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8002b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002b5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002bf:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002c2:	39 c2                	cmp    %eax,%edx
  8002c4:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002c7:	73 43                	jae    80030c <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002c9:	83 eb 01             	sub    $0x1,%ebx
  8002cc:	85 db                	test   %ebx,%ebx
  8002ce:	7e 6c                	jle    80033c <printnum+0xaf>
				putch(padc, putdat);
  8002d0:	83 ec 08             	sub    $0x8,%esp
  8002d3:	57                   	push   %edi
  8002d4:	ff 75 18             	pushl  0x18(%ebp)
  8002d7:	ff d6                	call   *%esi
  8002d9:	83 c4 10             	add    $0x10,%esp
  8002dc:	eb eb                	jmp    8002c9 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002de:	83 ec 0c             	sub    $0xc,%esp
  8002e1:	6a 20                	push   $0x20
  8002e3:	6a 00                	push   $0x0
  8002e5:	50                   	push   %eax
  8002e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e9:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ec:	89 fa                	mov    %edi,%edx
  8002ee:	89 f0                	mov    %esi,%eax
  8002f0:	e8 98 ff ff ff       	call   80028d <printnum>
		while (--width > 0)
  8002f5:	83 c4 20             	add    $0x20,%esp
  8002f8:	83 eb 01             	sub    $0x1,%ebx
  8002fb:	85 db                	test   %ebx,%ebx
  8002fd:	7e 65                	jle    800364 <printnum+0xd7>
			putch(padc, putdat);
  8002ff:	83 ec 08             	sub    $0x8,%esp
  800302:	57                   	push   %edi
  800303:	6a 20                	push   $0x20
  800305:	ff d6                	call   *%esi
  800307:	83 c4 10             	add    $0x10,%esp
  80030a:	eb ec                	jmp    8002f8 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80030c:	83 ec 0c             	sub    $0xc,%esp
  80030f:	ff 75 18             	pushl  0x18(%ebp)
  800312:	83 eb 01             	sub    $0x1,%ebx
  800315:	53                   	push   %ebx
  800316:	50                   	push   %eax
  800317:	83 ec 08             	sub    $0x8,%esp
  80031a:	ff 75 dc             	pushl  -0x24(%ebp)
  80031d:	ff 75 d8             	pushl  -0x28(%ebp)
  800320:	ff 75 e4             	pushl  -0x1c(%ebp)
  800323:	ff 75 e0             	pushl  -0x20(%ebp)
  800326:	e8 d5 0c 00 00       	call   801000 <__udivdi3>
  80032b:	83 c4 18             	add    $0x18,%esp
  80032e:	52                   	push   %edx
  80032f:	50                   	push   %eax
  800330:	89 fa                	mov    %edi,%edx
  800332:	89 f0                	mov    %esi,%eax
  800334:	e8 54 ff ff ff       	call   80028d <printnum>
  800339:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80033c:	83 ec 08             	sub    $0x8,%esp
  80033f:	57                   	push   %edi
  800340:	83 ec 04             	sub    $0x4,%esp
  800343:	ff 75 dc             	pushl  -0x24(%ebp)
  800346:	ff 75 d8             	pushl  -0x28(%ebp)
  800349:	ff 75 e4             	pushl  -0x1c(%ebp)
  80034c:	ff 75 e0             	pushl  -0x20(%ebp)
  80034f:	e8 bc 0d 00 00       	call   801110 <__umoddi3>
  800354:	83 c4 14             	add    $0x14,%esp
  800357:	0f be 80 5f 13 80 00 	movsbl 0x80135f(%eax),%eax
  80035e:	50                   	push   %eax
  80035f:	ff d6                	call   *%esi
  800361:	83 c4 10             	add    $0x10,%esp
	}
}
  800364:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800367:	5b                   	pop    %ebx
  800368:	5e                   	pop    %esi
  800369:	5f                   	pop    %edi
  80036a:	5d                   	pop    %ebp
  80036b:	c3                   	ret    

0080036c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80036c:	55                   	push   %ebp
  80036d:	89 e5                	mov    %esp,%ebp
  80036f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800372:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800376:	8b 10                	mov    (%eax),%edx
  800378:	3b 50 04             	cmp    0x4(%eax),%edx
  80037b:	73 0a                	jae    800387 <sprintputch+0x1b>
		*b->buf++ = ch;
  80037d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800380:	89 08                	mov    %ecx,(%eax)
  800382:	8b 45 08             	mov    0x8(%ebp),%eax
  800385:	88 02                	mov    %al,(%edx)
}
  800387:	5d                   	pop    %ebp
  800388:	c3                   	ret    

00800389 <printfmt>:
{
  800389:	55                   	push   %ebp
  80038a:	89 e5                	mov    %esp,%ebp
  80038c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80038f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800392:	50                   	push   %eax
  800393:	ff 75 10             	pushl  0x10(%ebp)
  800396:	ff 75 0c             	pushl  0xc(%ebp)
  800399:	ff 75 08             	pushl  0x8(%ebp)
  80039c:	e8 05 00 00 00       	call   8003a6 <vprintfmt>
}
  8003a1:	83 c4 10             	add    $0x10,%esp
  8003a4:	c9                   	leave  
  8003a5:	c3                   	ret    

008003a6 <vprintfmt>:
{
  8003a6:	55                   	push   %ebp
  8003a7:	89 e5                	mov    %esp,%ebp
  8003a9:	57                   	push   %edi
  8003aa:	56                   	push   %esi
  8003ab:	53                   	push   %ebx
  8003ac:	83 ec 3c             	sub    $0x3c,%esp
  8003af:	8b 75 08             	mov    0x8(%ebp),%esi
  8003b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003b5:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003b8:	e9 32 04 00 00       	jmp    8007ef <vprintfmt+0x449>
		padc = ' ';
  8003bd:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003c1:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003c8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003cf:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003d6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003dd:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003e4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003e9:	8d 47 01             	lea    0x1(%edi),%eax
  8003ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ef:	0f b6 17             	movzbl (%edi),%edx
  8003f2:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003f5:	3c 55                	cmp    $0x55,%al
  8003f7:	0f 87 12 05 00 00    	ja     80090f <vprintfmt+0x569>
  8003fd:	0f b6 c0             	movzbl %al,%eax
  800400:	ff 24 85 40 15 80 00 	jmp    *0x801540(,%eax,4)
  800407:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80040a:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80040e:	eb d9                	jmp    8003e9 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800410:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800413:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800417:	eb d0                	jmp    8003e9 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800419:	0f b6 d2             	movzbl %dl,%edx
  80041c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80041f:	b8 00 00 00 00       	mov    $0x0,%eax
  800424:	89 75 08             	mov    %esi,0x8(%ebp)
  800427:	eb 03                	jmp    80042c <vprintfmt+0x86>
  800429:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80042c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80042f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800433:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800436:	8d 72 d0             	lea    -0x30(%edx),%esi
  800439:	83 fe 09             	cmp    $0x9,%esi
  80043c:	76 eb                	jbe    800429 <vprintfmt+0x83>
  80043e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800441:	8b 75 08             	mov    0x8(%ebp),%esi
  800444:	eb 14                	jmp    80045a <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800446:	8b 45 14             	mov    0x14(%ebp),%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80044e:	8b 45 14             	mov    0x14(%ebp),%eax
  800451:	8d 40 04             	lea    0x4(%eax),%eax
  800454:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800457:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80045a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80045e:	79 89                	jns    8003e9 <vprintfmt+0x43>
				width = precision, precision = -1;
  800460:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800463:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800466:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80046d:	e9 77 ff ff ff       	jmp    8003e9 <vprintfmt+0x43>
  800472:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800475:	85 c0                	test   %eax,%eax
  800477:	0f 48 c1             	cmovs  %ecx,%eax
  80047a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80047d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800480:	e9 64 ff ff ff       	jmp    8003e9 <vprintfmt+0x43>
  800485:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800488:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80048f:	e9 55 ff ff ff       	jmp    8003e9 <vprintfmt+0x43>
			lflag++;
  800494:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800498:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80049b:	e9 49 ff ff ff       	jmp    8003e9 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a3:	8d 78 04             	lea    0x4(%eax),%edi
  8004a6:	83 ec 08             	sub    $0x8,%esp
  8004a9:	53                   	push   %ebx
  8004aa:	ff 30                	pushl  (%eax)
  8004ac:	ff d6                	call   *%esi
			break;
  8004ae:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004b1:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004b4:	e9 33 03 00 00       	jmp    8007ec <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bc:	8d 78 04             	lea    0x4(%eax),%edi
  8004bf:	8b 00                	mov    (%eax),%eax
  8004c1:	99                   	cltd   
  8004c2:	31 d0                	xor    %edx,%eax
  8004c4:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004c6:	83 f8 0f             	cmp    $0xf,%eax
  8004c9:	7f 23                	jg     8004ee <vprintfmt+0x148>
  8004cb:	8b 14 85 a0 16 80 00 	mov    0x8016a0(,%eax,4),%edx
  8004d2:	85 d2                	test   %edx,%edx
  8004d4:	74 18                	je     8004ee <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004d6:	52                   	push   %edx
  8004d7:	68 80 13 80 00       	push   $0x801380
  8004dc:	53                   	push   %ebx
  8004dd:	56                   	push   %esi
  8004de:	e8 a6 fe ff ff       	call   800389 <printfmt>
  8004e3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004e6:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004e9:	e9 fe 02 00 00       	jmp    8007ec <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004ee:	50                   	push   %eax
  8004ef:	68 77 13 80 00       	push   $0x801377
  8004f4:	53                   	push   %ebx
  8004f5:	56                   	push   %esi
  8004f6:	e8 8e fe ff ff       	call   800389 <printfmt>
  8004fb:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004fe:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800501:	e9 e6 02 00 00       	jmp    8007ec <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800506:	8b 45 14             	mov    0x14(%ebp),%eax
  800509:	83 c0 04             	add    $0x4,%eax
  80050c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80050f:	8b 45 14             	mov    0x14(%ebp),%eax
  800512:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800514:	85 c9                	test   %ecx,%ecx
  800516:	b8 70 13 80 00       	mov    $0x801370,%eax
  80051b:	0f 45 c1             	cmovne %ecx,%eax
  80051e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800521:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800525:	7e 06                	jle    80052d <vprintfmt+0x187>
  800527:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80052b:	75 0d                	jne    80053a <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80052d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800530:	89 c7                	mov    %eax,%edi
  800532:	03 45 e0             	add    -0x20(%ebp),%eax
  800535:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800538:	eb 53                	jmp    80058d <vprintfmt+0x1e7>
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	ff 75 d8             	pushl  -0x28(%ebp)
  800540:	50                   	push   %eax
  800541:	e8 71 04 00 00       	call   8009b7 <strnlen>
  800546:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800549:	29 c1                	sub    %eax,%ecx
  80054b:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80054e:	83 c4 10             	add    $0x10,%esp
  800551:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800553:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800557:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80055a:	eb 0f                	jmp    80056b <vprintfmt+0x1c5>
					putch(padc, putdat);
  80055c:	83 ec 08             	sub    $0x8,%esp
  80055f:	53                   	push   %ebx
  800560:	ff 75 e0             	pushl  -0x20(%ebp)
  800563:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800565:	83 ef 01             	sub    $0x1,%edi
  800568:	83 c4 10             	add    $0x10,%esp
  80056b:	85 ff                	test   %edi,%edi
  80056d:	7f ed                	jg     80055c <vprintfmt+0x1b6>
  80056f:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800572:	85 c9                	test   %ecx,%ecx
  800574:	b8 00 00 00 00       	mov    $0x0,%eax
  800579:	0f 49 c1             	cmovns %ecx,%eax
  80057c:	29 c1                	sub    %eax,%ecx
  80057e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800581:	eb aa                	jmp    80052d <vprintfmt+0x187>
					putch(ch, putdat);
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	53                   	push   %ebx
  800587:	52                   	push   %edx
  800588:	ff d6                	call   *%esi
  80058a:	83 c4 10             	add    $0x10,%esp
  80058d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800590:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800592:	83 c7 01             	add    $0x1,%edi
  800595:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800599:	0f be d0             	movsbl %al,%edx
  80059c:	85 d2                	test   %edx,%edx
  80059e:	74 4b                	je     8005eb <vprintfmt+0x245>
  8005a0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005a4:	78 06                	js     8005ac <vprintfmt+0x206>
  8005a6:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005aa:	78 1e                	js     8005ca <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ac:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005b0:	74 d1                	je     800583 <vprintfmt+0x1dd>
  8005b2:	0f be c0             	movsbl %al,%eax
  8005b5:	83 e8 20             	sub    $0x20,%eax
  8005b8:	83 f8 5e             	cmp    $0x5e,%eax
  8005bb:	76 c6                	jbe    800583 <vprintfmt+0x1dd>
					putch('?', putdat);
  8005bd:	83 ec 08             	sub    $0x8,%esp
  8005c0:	53                   	push   %ebx
  8005c1:	6a 3f                	push   $0x3f
  8005c3:	ff d6                	call   *%esi
  8005c5:	83 c4 10             	add    $0x10,%esp
  8005c8:	eb c3                	jmp    80058d <vprintfmt+0x1e7>
  8005ca:	89 cf                	mov    %ecx,%edi
  8005cc:	eb 0e                	jmp    8005dc <vprintfmt+0x236>
				putch(' ', putdat);
  8005ce:	83 ec 08             	sub    $0x8,%esp
  8005d1:	53                   	push   %ebx
  8005d2:	6a 20                	push   $0x20
  8005d4:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005d6:	83 ef 01             	sub    $0x1,%edi
  8005d9:	83 c4 10             	add    $0x10,%esp
  8005dc:	85 ff                	test   %edi,%edi
  8005de:	7f ee                	jg     8005ce <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005e0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e6:	e9 01 02 00 00       	jmp    8007ec <vprintfmt+0x446>
  8005eb:	89 cf                	mov    %ecx,%edi
  8005ed:	eb ed                	jmp    8005dc <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005f2:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005f9:	e9 eb fd ff ff       	jmp    8003e9 <vprintfmt+0x43>
	if (lflag >= 2)
  8005fe:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800602:	7f 21                	jg     800625 <vprintfmt+0x27f>
	else if (lflag)
  800604:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800608:	74 68                	je     800672 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	8b 00                	mov    (%eax),%eax
  80060f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800612:	89 c1                	mov    %eax,%ecx
  800614:	c1 f9 1f             	sar    $0x1f,%ecx
  800617:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8d 40 04             	lea    0x4(%eax),%eax
  800620:	89 45 14             	mov    %eax,0x14(%ebp)
  800623:	eb 17                	jmp    80063c <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800625:	8b 45 14             	mov    0x14(%ebp),%eax
  800628:	8b 50 04             	mov    0x4(%eax),%edx
  80062b:	8b 00                	mov    (%eax),%eax
  80062d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800630:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	8d 40 08             	lea    0x8(%eax),%eax
  800639:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80063c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80063f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800642:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800645:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800648:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80064c:	78 3f                	js     80068d <vprintfmt+0x2e7>
			base = 10;
  80064e:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800653:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800657:	0f 84 71 01 00 00    	je     8007ce <vprintfmt+0x428>
				putch('+', putdat);
  80065d:	83 ec 08             	sub    $0x8,%esp
  800660:	53                   	push   %ebx
  800661:	6a 2b                	push   $0x2b
  800663:	ff d6                	call   *%esi
  800665:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800668:	b8 0a 00 00 00       	mov    $0xa,%eax
  80066d:	e9 5c 01 00 00       	jmp    8007ce <vprintfmt+0x428>
		return va_arg(*ap, int);
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80067a:	89 c1                	mov    %eax,%ecx
  80067c:	c1 f9 1f             	sar    $0x1f,%ecx
  80067f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800682:	8b 45 14             	mov    0x14(%ebp),%eax
  800685:	8d 40 04             	lea    0x4(%eax),%eax
  800688:	89 45 14             	mov    %eax,0x14(%ebp)
  80068b:	eb af                	jmp    80063c <vprintfmt+0x296>
				putch('-', putdat);
  80068d:	83 ec 08             	sub    $0x8,%esp
  800690:	53                   	push   %ebx
  800691:	6a 2d                	push   $0x2d
  800693:	ff d6                	call   *%esi
				num = -(long long) num;
  800695:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800698:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80069b:	f7 d8                	neg    %eax
  80069d:	83 d2 00             	adc    $0x0,%edx
  8006a0:	f7 da                	neg    %edx
  8006a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006ab:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b0:	e9 19 01 00 00       	jmp    8007ce <vprintfmt+0x428>
	if (lflag >= 2)
  8006b5:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006b9:	7f 29                	jg     8006e4 <vprintfmt+0x33e>
	else if (lflag)
  8006bb:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006bf:	74 44                	je     800705 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ce:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	8d 40 04             	lea    0x4(%eax),%eax
  8006d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006da:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006df:	e9 ea 00 00 00       	jmp    8007ce <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	8b 50 04             	mov    0x4(%eax),%edx
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ef:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	8d 40 08             	lea    0x8(%eax),%eax
  8006f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006fb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800700:	e9 c9 00 00 00       	jmp    8007ce <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800705:	8b 45 14             	mov    0x14(%ebp),%eax
  800708:	8b 00                	mov    (%eax),%eax
  80070a:	ba 00 00 00 00       	mov    $0x0,%edx
  80070f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800712:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	8d 40 04             	lea    0x4(%eax),%eax
  80071b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80071e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800723:	e9 a6 00 00 00       	jmp    8007ce <vprintfmt+0x428>
			putch('0', putdat);
  800728:	83 ec 08             	sub    $0x8,%esp
  80072b:	53                   	push   %ebx
  80072c:	6a 30                	push   $0x30
  80072e:	ff d6                	call   *%esi
	if (lflag >= 2)
  800730:	83 c4 10             	add    $0x10,%esp
  800733:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800737:	7f 26                	jg     80075f <vprintfmt+0x3b9>
	else if (lflag)
  800739:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80073d:	74 3e                	je     80077d <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80073f:	8b 45 14             	mov    0x14(%ebp),%eax
  800742:	8b 00                	mov    (%eax),%eax
  800744:	ba 00 00 00 00       	mov    $0x0,%edx
  800749:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80074f:	8b 45 14             	mov    0x14(%ebp),%eax
  800752:	8d 40 04             	lea    0x4(%eax),%eax
  800755:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800758:	b8 08 00 00 00       	mov    $0x8,%eax
  80075d:	eb 6f                	jmp    8007ce <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	8b 50 04             	mov    0x4(%eax),%edx
  800765:	8b 00                	mov    (%eax),%eax
  800767:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	8d 40 08             	lea    0x8(%eax),%eax
  800773:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800776:	b8 08 00 00 00       	mov    $0x8,%eax
  80077b:	eb 51                	jmp    8007ce <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80077d:	8b 45 14             	mov    0x14(%ebp),%eax
  800780:	8b 00                	mov    (%eax),%eax
  800782:	ba 00 00 00 00       	mov    $0x0,%edx
  800787:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078d:	8b 45 14             	mov    0x14(%ebp),%eax
  800790:	8d 40 04             	lea    0x4(%eax),%eax
  800793:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800796:	b8 08 00 00 00       	mov    $0x8,%eax
  80079b:	eb 31                	jmp    8007ce <vprintfmt+0x428>
			putch('0', putdat);
  80079d:	83 ec 08             	sub    $0x8,%esp
  8007a0:	53                   	push   %ebx
  8007a1:	6a 30                	push   $0x30
  8007a3:	ff d6                	call   *%esi
			putch('x', putdat);
  8007a5:	83 c4 08             	add    $0x8,%esp
  8007a8:	53                   	push   %ebx
  8007a9:	6a 78                	push   $0x78
  8007ab:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ba:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007bd:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c3:	8d 40 04             	lea    0x4(%eax),%eax
  8007c6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c9:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007ce:	83 ec 0c             	sub    $0xc,%esp
  8007d1:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007d5:	52                   	push   %edx
  8007d6:	ff 75 e0             	pushl  -0x20(%ebp)
  8007d9:	50                   	push   %eax
  8007da:	ff 75 dc             	pushl  -0x24(%ebp)
  8007dd:	ff 75 d8             	pushl  -0x28(%ebp)
  8007e0:	89 da                	mov    %ebx,%edx
  8007e2:	89 f0                	mov    %esi,%eax
  8007e4:	e8 a4 fa ff ff       	call   80028d <printnum>
			break;
  8007e9:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ef:	83 c7 01             	add    $0x1,%edi
  8007f2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007f6:	83 f8 25             	cmp    $0x25,%eax
  8007f9:	0f 84 be fb ff ff    	je     8003bd <vprintfmt+0x17>
			if (ch == '\0')
  8007ff:	85 c0                	test   %eax,%eax
  800801:	0f 84 28 01 00 00    	je     80092f <vprintfmt+0x589>
			putch(ch, putdat);
  800807:	83 ec 08             	sub    $0x8,%esp
  80080a:	53                   	push   %ebx
  80080b:	50                   	push   %eax
  80080c:	ff d6                	call   *%esi
  80080e:	83 c4 10             	add    $0x10,%esp
  800811:	eb dc                	jmp    8007ef <vprintfmt+0x449>
	if (lflag >= 2)
  800813:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800817:	7f 26                	jg     80083f <vprintfmt+0x499>
	else if (lflag)
  800819:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80081d:	74 41                	je     800860 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80081f:	8b 45 14             	mov    0x14(%ebp),%eax
  800822:	8b 00                	mov    (%eax),%eax
  800824:	ba 00 00 00 00       	mov    $0x0,%edx
  800829:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80082f:	8b 45 14             	mov    0x14(%ebp),%eax
  800832:	8d 40 04             	lea    0x4(%eax),%eax
  800835:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800838:	b8 10 00 00 00       	mov    $0x10,%eax
  80083d:	eb 8f                	jmp    8007ce <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80083f:	8b 45 14             	mov    0x14(%ebp),%eax
  800842:	8b 50 04             	mov    0x4(%eax),%edx
  800845:	8b 00                	mov    (%eax),%eax
  800847:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80084d:	8b 45 14             	mov    0x14(%ebp),%eax
  800850:	8d 40 08             	lea    0x8(%eax),%eax
  800853:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800856:	b8 10 00 00 00       	mov    $0x10,%eax
  80085b:	e9 6e ff ff ff       	jmp    8007ce <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800860:	8b 45 14             	mov    0x14(%ebp),%eax
  800863:	8b 00                	mov    (%eax),%eax
  800865:	ba 00 00 00 00       	mov    $0x0,%edx
  80086a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80086d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800870:	8b 45 14             	mov    0x14(%ebp),%eax
  800873:	8d 40 04             	lea    0x4(%eax),%eax
  800876:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800879:	b8 10 00 00 00       	mov    $0x10,%eax
  80087e:	e9 4b ff ff ff       	jmp    8007ce <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800883:	8b 45 14             	mov    0x14(%ebp),%eax
  800886:	83 c0 04             	add    $0x4,%eax
  800889:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088c:	8b 45 14             	mov    0x14(%ebp),%eax
  80088f:	8b 00                	mov    (%eax),%eax
  800891:	85 c0                	test   %eax,%eax
  800893:	74 14                	je     8008a9 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800895:	8b 13                	mov    (%ebx),%edx
  800897:	83 fa 7f             	cmp    $0x7f,%edx
  80089a:	7f 37                	jg     8008d3 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80089c:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80089e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008a1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a4:	e9 43 ff ff ff       	jmp    8007ec <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8008a9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008ae:	bf 99 14 80 00       	mov    $0x801499,%edi
							putch(ch, putdat);
  8008b3:	83 ec 08             	sub    $0x8,%esp
  8008b6:	53                   	push   %ebx
  8008b7:	50                   	push   %eax
  8008b8:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008ba:	83 c7 01             	add    $0x1,%edi
  8008bd:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008c1:	83 c4 10             	add    $0x10,%esp
  8008c4:	85 c0                	test   %eax,%eax
  8008c6:	75 eb                	jne    8008b3 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ce:	e9 19 ff ff ff       	jmp    8007ec <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008d3:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008d5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008da:	bf d1 14 80 00       	mov    $0x8014d1,%edi
							putch(ch, putdat);
  8008df:	83 ec 08             	sub    $0x8,%esp
  8008e2:	53                   	push   %ebx
  8008e3:	50                   	push   %eax
  8008e4:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008e6:	83 c7 01             	add    $0x1,%edi
  8008e9:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008ed:	83 c4 10             	add    $0x10,%esp
  8008f0:	85 c0                	test   %eax,%eax
  8008f2:	75 eb                	jne    8008df <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008f7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008fa:	e9 ed fe ff ff       	jmp    8007ec <vprintfmt+0x446>
			putch(ch, putdat);
  8008ff:	83 ec 08             	sub    $0x8,%esp
  800902:	53                   	push   %ebx
  800903:	6a 25                	push   $0x25
  800905:	ff d6                	call   *%esi
			break;
  800907:	83 c4 10             	add    $0x10,%esp
  80090a:	e9 dd fe ff ff       	jmp    8007ec <vprintfmt+0x446>
			putch('%', putdat);
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	53                   	push   %ebx
  800913:	6a 25                	push   $0x25
  800915:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800917:	83 c4 10             	add    $0x10,%esp
  80091a:	89 f8                	mov    %edi,%eax
  80091c:	eb 03                	jmp    800921 <vprintfmt+0x57b>
  80091e:	83 e8 01             	sub    $0x1,%eax
  800921:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800925:	75 f7                	jne    80091e <vprintfmt+0x578>
  800927:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80092a:	e9 bd fe ff ff       	jmp    8007ec <vprintfmt+0x446>
}
  80092f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800932:	5b                   	pop    %ebx
  800933:	5e                   	pop    %esi
  800934:	5f                   	pop    %edi
  800935:	5d                   	pop    %ebp
  800936:	c3                   	ret    

00800937 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	83 ec 18             	sub    $0x18,%esp
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800943:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800946:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80094a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80094d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800954:	85 c0                	test   %eax,%eax
  800956:	74 26                	je     80097e <vsnprintf+0x47>
  800958:	85 d2                	test   %edx,%edx
  80095a:	7e 22                	jle    80097e <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80095c:	ff 75 14             	pushl  0x14(%ebp)
  80095f:	ff 75 10             	pushl  0x10(%ebp)
  800962:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800965:	50                   	push   %eax
  800966:	68 6c 03 80 00       	push   $0x80036c
  80096b:	e8 36 fa ff ff       	call   8003a6 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800970:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800973:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800976:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800979:	83 c4 10             	add    $0x10,%esp
}
  80097c:	c9                   	leave  
  80097d:	c3                   	ret    
		return -E_INVAL;
  80097e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800983:	eb f7                	jmp    80097c <vsnprintf+0x45>

00800985 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
  800988:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80098b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80098e:	50                   	push   %eax
  80098f:	ff 75 10             	pushl  0x10(%ebp)
  800992:	ff 75 0c             	pushl  0xc(%ebp)
  800995:	ff 75 08             	pushl  0x8(%ebp)
  800998:	e8 9a ff ff ff       	call   800937 <vsnprintf>
	va_end(ap);

	return rc;
}
  80099d:	c9                   	leave  
  80099e:	c3                   	ret    

0080099f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80099f:	55                   	push   %ebp
  8009a0:	89 e5                	mov    %esp,%ebp
  8009a2:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009aa:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009ae:	74 05                	je     8009b5 <strlen+0x16>
		n++;
  8009b0:	83 c0 01             	add    $0x1,%eax
  8009b3:	eb f5                	jmp    8009aa <strlen+0xb>
	return n;
}
  8009b5:	5d                   	pop    %ebp
  8009b6:	c3                   	ret    

008009b7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009bd:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c5:	39 c2                	cmp    %eax,%edx
  8009c7:	74 0d                	je     8009d6 <strnlen+0x1f>
  8009c9:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009cd:	74 05                	je     8009d4 <strnlen+0x1d>
		n++;
  8009cf:	83 c2 01             	add    $0x1,%edx
  8009d2:	eb f1                	jmp    8009c5 <strnlen+0xe>
  8009d4:	89 d0                	mov    %edx,%eax
	return n;
}
  8009d6:	5d                   	pop    %ebp
  8009d7:	c3                   	ret    

008009d8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	53                   	push   %ebx
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e7:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009eb:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009ee:	83 c2 01             	add    $0x1,%edx
  8009f1:	84 c9                	test   %cl,%cl
  8009f3:	75 f2                	jne    8009e7 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009f5:	5b                   	pop    %ebx
  8009f6:	5d                   	pop    %ebp
  8009f7:	c3                   	ret    

008009f8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009f8:	55                   	push   %ebp
  8009f9:	89 e5                	mov    %esp,%ebp
  8009fb:	53                   	push   %ebx
  8009fc:	83 ec 10             	sub    $0x10,%esp
  8009ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a02:	53                   	push   %ebx
  800a03:	e8 97 ff ff ff       	call   80099f <strlen>
  800a08:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a0b:	ff 75 0c             	pushl  0xc(%ebp)
  800a0e:	01 d8                	add    %ebx,%eax
  800a10:	50                   	push   %eax
  800a11:	e8 c2 ff ff ff       	call   8009d8 <strcpy>
	return dst;
}
  800a16:	89 d8                	mov    %ebx,%eax
  800a18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a1b:	c9                   	leave  
  800a1c:	c3                   	ret    

00800a1d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a1d:	55                   	push   %ebp
  800a1e:	89 e5                	mov    %esp,%ebp
  800a20:	56                   	push   %esi
  800a21:	53                   	push   %ebx
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a28:	89 c6                	mov    %eax,%esi
  800a2a:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a2d:	89 c2                	mov    %eax,%edx
  800a2f:	39 f2                	cmp    %esi,%edx
  800a31:	74 11                	je     800a44 <strncpy+0x27>
		*dst++ = *src;
  800a33:	83 c2 01             	add    $0x1,%edx
  800a36:	0f b6 19             	movzbl (%ecx),%ebx
  800a39:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a3c:	80 fb 01             	cmp    $0x1,%bl
  800a3f:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a42:	eb eb                	jmp    800a2f <strncpy+0x12>
	}
	return ret;
}
  800a44:	5b                   	pop    %ebx
  800a45:	5e                   	pop    %esi
  800a46:	5d                   	pop    %ebp
  800a47:	c3                   	ret    

00800a48 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a48:	55                   	push   %ebp
  800a49:	89 e5                	mov    %esp,%ebp
  800a4b:	56                   	push   %esi
  800a4c:	53                   	push   %ebx
  800a4d:	8b 75 08             	mov    0x8(%ebp),%esi
  800a50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a53:	8b 55 10             	mov    0x10(%ebp),%edx
  800a56:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a58:	85 d2                	test   %edx,%edx
  800a5a:	74 21                	je     800a7d <strlcpy+0x35>
  800a5c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a60:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a62:	39 c2                	cmp    %eax,%edx
  800a64:	74 14                	je     800a7a <strlcpy+0x32>
  800a66:	0f b6 19             	movzbl (%ecx),%ebx
  800a69:	84 db                	test   %bl,%bl
  800a6b:	74 0b                	je     800a78 <strlcpy+0x30>
			*dst++ = *src++;
  800a6d:	83 c1 01             	add    $0x1,%ecx
  800a70:	83 c2 01             	add    $0x1,%edx
  800a73:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a76:	eb ea                	jmp    800a62 <strlcpy+0x1a>
  800a78:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a7a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a7d:	29 f0                	sub    %esi,%eax
}
  800a7f:	5b                   	pop    %ebx
  800a80:	5e                   	pop    %esi
  800a81:	5d                   	pop    %ebp
  800a82:	c3                   	ret    

00800a83 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a83:	55                   	push   %ebp
  800a84:	89 e5                	mov    %esp,%ebp
  800a86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a89:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a8c:	0f b6 01             	movzbl (%ecx),%eax
  800a8f:	84 c0                	test   %al,%al
  800a91:	74 0c                	je     800a9f <strcmp+0x1c>
  800a93:	3a 02                	cmp    (%edx),%al
  800a95:	75 08                	jne    800a9f <strcmp+0x1c>
		p++, q++;
  800a97:	83 c1 01             	add    $0x1,%ecx
  800a9a:	83 c2 01             	add    $0x1,%edx
  800a9d:	eb ed                	jmp    800a8c <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a9f:	0f b6 c0             	movzbl %al,%eax
  800aa2:	0f b6 12             	movzbl (%edx),%edx
  800aa5:	29 d0                	sub    %edx,%eax
}
  800aa7:	5d                   	pop    %ebp
  800aa8:	c3                   	ret    

00800aa9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
  800aac:	53                   	push   %ebx
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab3:	89 c3                	mov    %eax,%ebx
  800ab5:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ab8:	eb 06                	jmp    800ac0 <strncmp+0x17>
		n--, p++, q++;
  800aba:	83 c0 01             	add    $0x1,%eax
  800abd:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ac0:	39 d8                	cmp    %ebx,%eax
  800ac2:	74 16                	je     800ada <strncmp+0x31>
  800ac4:	0f b6 08             	movzbl (%eax),%ecx
  800ac7:	84 c9                	test   %cl,%cl
  800ac9:	74 04                	je     800acf <strncmp+0x26>
  800acb:	3a 0a                	cmp    (%edx),%cl
  800acd:	74 eb                	je     800aba <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800acf:	0f b6 00             	movzbl (%eax),%eax
  800ad2:	0f b6 12             	movzbl (%edx),%edx
  800ad5:	29 d0                	sub    %edx,%eax
}
  800ad7:	5b                   	pop    %ebx
  800ad8:	5d                   	pop    %ebp
  800ad9:	c3                   	ret    
		return 0;
  800ada:	b8 00 00 00 00       	mov    $0x0,%eax
  800adf:	eb f6                	jmp    800ad7 <strncmp+0x2e>

00800ae1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ae1:	55                   	push   %ebp
  800ae2:	89 e5                	mov    %esp,%ebp
  800ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aeb:	0f b6 10             	movzbl (%eax),%edx
  800aee:	84 d2                	test   %dl,%dl
  800af0:	74 09                	je     800afb <strchr+0x1a>
		if (*s == c)
  800af2:	38 ca                	cmp    %cl,%dl
  800af4:	74 0a                	je     800b00 <strchr+0x1f>
	for (; *s; s++)
  800af6:	83 c0 01             	add    $0x1,%eax
  800af9:	eb f0                	jmp    800aeb <strchr+0xa>
			return (char *) s;
	return 0;
  800afb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b00:	5d                   	pop    %ebp
  800b01:	c3                   	ret    

00800b02 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	8b 45 08             	mov    0x8(%ebp),%eax
  800b08:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b0c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b0f:	38 ca                	cmp    %cl,%dl
  800b11:	74 09                	je     800b1c <strfind+0x1a>
  800b13:	84 d2                	test   %dl,%dl
  800b15:	74 05                	je     800b1c <strfind+0x1a>
	for (; *s; s++)
  800b17:	83 c0 01             	add    $0x1,%eax
  800b1a:	eb f0                	jmp    800b0c <strfind+0xa>
			break;
	return (char *) s;
}
  800b1c:	5d                   	pop    %ebp
  800b1d:	c3                   	ret    

00800b1e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	57                   	push   %edi
  800b22:	56                   	push   %esi
  800b23:	53                   	push   %ebx
  800b24:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b27:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b2a:	85 c9                	test   %ecx,%ecx
  800b2c:	74 31                	je     800b5f <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b2e:	89 f8                	mov    %edi,%eax
  800b30:	09 c8                	or     %ecx,%eax
  800b32:	a8 03                	test   $0x3,%al
  800b34:	75 23                	jne    800b59 <memset+0x3b>
		c &= 0xFF;
  800b36:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b3a:	89 d3                	mov    %edx,%ebx
  800b3c:	c1 e3 08             	shl    $0x8,%ebx
  800b3f:	89 d0                	mov    %edx,%eax
  800b41:	c1 e0 18             	shl    $0x18,%eax
  800b44:	89 d6                	mov    %edx,%esi
  800b46:	c1 e6 10             	shl    $0x10,%esi
  800b49:	09 f0                	or     %esi,%eax
  800b4b:	09 c2                	or     %eax,%edx
  800b4d:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b4f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b52:	89 d0                	mov    %edx,%eax
  800b54:	fc                   	cld    
  800b55:	f3 ab                	rep stos %eax,%es:(%edi)
  800b57:	eb 06                	jmp    800b5f <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5c:	fc                   	cld    
  800b5d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b5f:	89 f8                	mov    %edi,%eax
  800b61:	5b                   	pop    %ebx
  800b62:	5e                   	pop    %esi
  800b63:	5f                   	pop    %edi
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	57                   	push   %edi
  800b6a:	56                   	push   %esi
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b71:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b74:	39 c6                	cmp    %eax,%esi
  800b76:	73 32                	jae    800baa <memmove+0x44>
  800b78:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b7b:	39 c2                	cmp    %eax,%edx
  800b7d:	76 2b                	jbe    800baa <memmove+0x44>
		s += n;
		d += n;
  800b7f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b82:	89 fe                	mov    %edi,%esi
  800b84:	09 ce                	or     %ecx,%esi
  800b86:	09 d6                	or     %edx,%esi
  800b88:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b8e:	75 0e                	jne    800b9e <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b90:	83 ef 04             	sub    $0x4,%edi
  800b93:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b96:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b99:	fd                   	std    
  800b9a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b9c:	eb 09                	jmp    800ba7 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b9e:	83 ef 01             	sub    $0x1,%edi
  800ba1:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ba4:	fd                   	std    
  800ba5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ba7:	fc                   	cld    
  800ba8:	eb 1a                	jmp    800bc4 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800baa:	89 c2                	mov    %eax,%edx
  800bac:	09 ca                	or     %ecx,%edx
  800bae:	09 f2                	or     %esi,%edx
  800bb0:	f6 c2 03             	test   $0x3,%dl
  800bb3:	75 0a                	jne    800bbf <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bb5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bb8:	89 c7                	mov    %eax,%edi
  800bba:	fc                   	cld    
  800bbb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bbd:	eb 05                	jmp    800bc4 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bbf:	89 c7                	mov    %eax,%edi
  800bc1:	fc                   	cld    
  800bc2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bc4:	5e                   	pop    %esi
  800bc5:	5f                   	pop    %edi
  800bc6:	5d                   	pop    %ebp
  800bc7:	c3                   	ret    

00800bc8 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bce:	ff 75 10             	pushl  0x10(%ebp)
  800bd1:	ff 75 0c             	pushl  0xc(%ebp)
  800bd4:	ff 75 08             	pushl  0x8(%ebp)
  800bd7:	e8 8a ff ff ff       	call   800b66 <memmove>
}
  800bdc:	c9                   	leave  
  800bdd:	c3                   	ret    

00800bde <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bde:	55                   	push   %ebp
  800bdf:	89 e5                	mov    %esp,%ebp
  800be1:	56                   	push   %esi
  800be2:	53                   	push   %ebx
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be9:	89 c6                	mov    %eax,%esi
  800beb:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bee:	39 f0                	cmp    %esi,%eax
  800bf0:	74 1c                	je     800c0e <memcmp+0x30>
		if (*s1 != *s2)
  800bf2:	0f b6 08             	movzbl (%eax),%ecx
  800bf5:	0f b6 1a             	movzbl (%edx),%ebx
  800bf8:	38 d9                	cmp    %bl,%cl
  800bfa:	75 08                	jne    800c04 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bfc:	83 c0 01             	add    $0x1,%eax
  800bff:	83 c2 01             	add    $0x1,%edx
  800c02:	eb ea                	jmp    800bee <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c04:	0f b6 c1             	movzbl %cl,%eax
  800c07:	0f b6 db             	movzbl %bl,%ebx
  800c0a:	29 d8                	sub    %ebx,%eax
  800c0c:	eb 05                	jmp    800c13 <memcmp+0x35>
	}

	return 0;
  800c0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c13:	5b                   	pop    %ebx
  800c14:	5e                   	pop    %esi
  800c15:	5d                   	pop    %ebp
  800c16:	c3                   	ret    

00800c17 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c20:	89 c2                	mov    %eax,%edx
  800c22:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c25:	39 d0                	cmp    %edx,%eax
  800c27:	73 09                	jae    800c32 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c29:	38 08                	cmp    %cl,(%eax)
  800c2b:	74 05                	je     800c32 <memfind+0x1b>
	for (; s < ends; s++)
  800c2d:	83 c0 01             	add    $0x1,%eax
  800c30:	eb f3                	jmp    800c25 <memfind+0xe>
			break;
	return (void *) s;
}
  800c32:	5d                   	pop    %ebp
  800c33:	c3                   	ret    

00800c34 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	57                   	push   %edi
  800c38:	56                   	push   %esi
  800c39:	53                   	push   %ebx
  800c3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c3d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c40:	eb 03                	jmp    800c45 <strtol+0x11>
		s++;
  800c42:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c45:	0f b6 01             	movzbl (%ecx),%eax
  800c48:	3c 20                	cmp    $0x20,%al
  800c4a:	74 f6                	je     800c42 <strtol+0xe>
  800c4c:	3c 09                	cmp    $0x9,%al
  800c4e:	74 f2                	je     800c42 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c50:	3c 2b                	cmp    $0x2b,%al
  800c52:	74 2a                	je     800c7e <strtol+0x4a>
	int neg = 0;
  800c54:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c59:	3c 2d                	cmp    $0x2d,%al
  800c5b:	74 2b                	je     800c88 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c5d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c63:	75 0f                	jne    800c74 <strtol+0x40>
  800c65:	80 39 30             	cmpb   $0x30,(%ecx)
  800c68:	74 28                	je     800c92 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c6a:	85 db                	test   %ebx,%ebx
  800c6c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c71:	0f 44 d8             	cmove  %eax,%ebx
  800c74:	b8 00 00 00 00       	mov    $0x0,%eax
  800c79:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c7c:	eb 50                	jmp    800cce <strtol+0x9a>
		s++;
  800c7e:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c81:	bf 00 00 00 00       	mov    $0x0,%edi
  800c86:	eb d5                	jmp    800c5d <strtol+0x29>
		s++, neg = 1;
  800c88:	83 c1 01             	add    $0x1,%ecx
  800c8b:	bf 01 00 00 00       	mov    $0x1,%edi
  800c90:	eb cb                	jmp    800c5d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c92:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c96:	74 0e                	je     800ca6 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c98:	85 db                	test   %ebx,%ebx
  800c9a:	75 d8                	jne    800c74 <strtol+0x40>
		s++, base = 8;
  800c9c:	83 c1 01             	add    $0x1,%ecx
  800c9f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ca4:	eb ce                	jmp    800c74 <strtol+0x40>
		s += 2, base = 16;
  800ca6:	83 c1 02             	add    $0x2,%ecx
  800ca9:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cae:	eb c4                	jmp    800c74 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cb0:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cb3:	89 f3                	mov    %esi,%ebx
  800cb5:	80 fb 19             	cmp    $0x19,%bl
  800cb8:	77 29                	ja     800ce3 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cba:	0f be d2             	movsbl %dl,%edx
  800cbd:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cc0:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cc3:	7d 30                	jge    800cf5 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cc5:	83 c1 01             	add    $0x1,%ecx
  800cc8:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ccc:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cce:	0f b6 11             	movzbl (%ecx),%edx
  800cd1:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cd4:	89 f3                	mov    %esi,%ebx
  800cd6:	80 fb 09             	cmp    $0x9,%bl
  800cd9:	77 d5                	ja     800cb0 <strtol+0x7c>
			dig = *s - '0';
  800cdb:	0f be d2             	movsbl %dl,%edx
  800cde:	83 ea 30             	sub    $0x30,%edx
  800ce1:	eb dd                	jmp    800cc0 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ce3:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ce6:	89 f3                	mov    %esi,%ebx
  800ce8:	80 fb 19             	cmp    $0x19,%bl
  800ceb:	77 08                	ja     800cf5 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ced:	0f be d2             	movsbl %dl,%edx
  800cf0:	83 ea 37             	sub    $0x37,%edx
  800cf3:	eb cb                	jmp    800cc0 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cf5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf9:	74 05                	je     800d00 <strtol+0xcc>
		*endptr = (char *) s;
  800cfb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cfe:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d00:	89 c2                	mov    %eax,%edx
  800d02:	f7 da                	neg    %edx
  800d04:	85 ff                	test   %edi,%edi
  800d06:	0f 45 c2             	cmovne %edx,%eax
}
  800d09:	5b                   	pop    %ebx
  800d0a:	5e                   	pop    %esi
  800d0b:	5f                   	pop    %edi
  800d0c:	5d                   	pop    %ebp
  800d0d:	c3                   	ret    

00800d0e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	57                   	push   %edi
  800d12:	56                   	push   %esi
  800d13:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d14:	b8 00 00 00 00       	mov    $0x0,%eax
  800d19:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1f:	89 c3                	mov    %eax,%ebx
  800d21:	89 c7                	mov    %eax,%edi
  800d23:	89 c6                	mov    %eax,%esi
  800d25:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d27:	5b                   	pop    %ebx
  800d28:	5e                   	pop    %esi
  800d29:	5f                   	pop    %edi
  800d2a:	5d                   	pop    %ebp
  800d2b:	c3                   	ret    

00800d2c <sys_cgetc>:

int
sys_cgetc(void)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
  800d2f:	57                   	push   %edi
  800d30:	56                   	push   %esi
  800d31:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d32:	ba 00 00 00 00       	mov    $0x0,%edx
  800d37:	b8 01 00 00 00       	mov    $0x1,%eax
  800d3c:	89 d1                	mov    %edx,%ecx
  800d3e:	89 d3                	mov    %edx,%ebx
  800d40:	89 d7                	mov    %edx,%edi
  800d42:	89 d6                	mov    %edx,%esi
  800d44:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d46:	5b                   	pop    %ebx
  800d47:	5e                   	pop    %esi
  800d48:	5f                   	pop    %edi
  800d49:	5d                   	pop    %ebp
  800d4a:	c3                   	ret    

00800d4b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
  800d4e:	57                   	push   %edi
  800d4f:	56                   	push   %esi
  800d50:	53                   	push   %ebx
  800d51:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d54:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d59:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5c:	b8 03 00 00 00       	mov    $0x3,%eax
  800d61:	89 cb                	mov    %ecx,%ebx
  800d63:	89 cf                	mov    %ecx,%edi
  800d65:	89 ce                	mov    %ecx,%esi
  800d67:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d69:	85 c0                	test   %eax,%eax
  800d6b:	7f 08                	jg     800d75 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d70:	5b                   	pop    %ebx
  800d71:	5e                   	pop    %esi
  800d72:	5f                   	pop    %edi
  800d73:	5d                   	pop    %ebp
  800d74:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d75:	83 ec 0c             	sub    $0xc,%esp
  800d78:	50                   	push   %eax
  800d79:	6a 03                	push   $0x3
  800d7b:	68 e0 16 80 00       	push   $0x8016e0
  800d80:	6a 43                	push   $0x43
  800d82:	68 fd 16 80 00       	push   $0x8016fd
  800d87:	e8 f7 f3 ff ff       	call   800183 <_panic>

00800d8c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	57                   	push   %edi
  800d90:	56                   	push   %esi
  800d91:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d92:	ba 00 00 00 00       	mov    $0x0,%edx
  800d97:	b8 02 00 00 00       	mov    $0x2,%eax
  800d9c:	89 d1                	mov    %edx,%ecx
  800d9e:	89 d3                	mov    %edx,%ebx
  800da0:	89 d7                	mov    %edx,%edi
  800da2:	89 d6                	mov    %edx,%esi
  800da4:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800da6:	5b                   	pop    %ebx
  800da7:	5e                   	pop    %esi
  800da8:	5f                   	pop    %edi
  800da9:	5d                   	pop    %ebp
  800daa:	c3                   	ret    

00800dab <sys_yield>:

void
sys_yield(void)
{
  800dab:	55                   	push   %ebp
  800dac:	89 e5                	mov    %esp,%ebp
  800dae:	57                   	push   %edi
  800daf:	56                   	push   %esi
  800db0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db1:	ba 00 00 00 00       	mov    $0x0,%edx
  800db6:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dbb:	89 d1                	mov    %edx,%ecx
  800dbd:	89 d3                	mov    %edx,%ebx
  800dbf:	89 d7                	mov    %edx,%edi
  800dc1:	89 d6                	mov    %edx,%esi
  800dc3:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dc5:	5b                   	pop    %ebx
  800dc6:	5e                   	pop    %esi
  800dc7:	5f                   	pop    %edi
  800dc8:	5d                   	pop    %ebp
  800dc9:	c3                   	ret    

00800dca <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	57                   	push   %edi
  800dce:	56                   	push   %esi
  800dcf:	53                   	push   %ebx
  800dd0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd3:	be 00 00 00 00       	mov    $0x0,%esi
  800dd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dde:	b8 04 00 00 00       	mov    $0x4,%eax
  800de3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de6:	89 f7                	mov    %esi,%edi
  800de8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dea:	85 c0                	test   %eax,%eax
  800dec:	7f 08                	jg     800df6 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df1:	5b                   	pop    %ebx
  800df2:	5e                   	pop    %esi
  800df3:	5f                   	pop    %edi
  800df4:	5d                   	pop    %ebp
  800df5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df6:	83 ec 0c             	sub    $0xc,%esp
  800df9:	50                   	push   %eax
  800dfa:	6a 04                	push   $0x4
  800dfc:	68 e0 16 80 00       	push   $0x8016e0
  800e01:	6a 43                	push   $0x43
  800e03:	68 fd 16 80 00       	push   $0x8016fd
  800e08:	e8 76 f3 ff ff       	call   800183 <_panic>

00800e0d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	57                   	push   %edi
  800e11:	56                   	push   %esi
  800e12:	53                   	push   %ebx
  800e13:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e16:	8b 55 08             	mov    0x8(%ebp),%edx
  800e19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1c:	b8 05 00 00 00       	mov    $0x5,%eax
  800e21:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e24:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e27:	8b 75 18             	mov    0x18(%ebp),%esi
  800e2a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2c:	85 c0                	test   %eax,%eax
  800e2e:	7f 08                	jg     800e38 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e33:	5b                   	pop    %ebx
  800e34:	5e                   	pop    %esi
  800e35:	5f                   	pop    %edi
  800e36:	5d                   	pop    %ebp
  800e37:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e38:	83 ec 0c             	sub    $0xc,%esp
  800e3b:	50                   	push   %eax
  800e3c:	6a 05                	push   $0x5
  800e3e:	68 e0 16 80 00       	push   $0x8016e0
  800e43:	6a 43                	push   $0x43
  800e45:	68 fd 16 80 00       	push   $0x8016fd
  800e4a:	e8 34 f3 ff ff       	call   800183 <_panic>

00800e4f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	57                   	push   %edi
  800e53:	56                   	push   %esi
  800e54:	53                   	push   %ebx
  800e55:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e58:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e63:	b8 06 00 00 00       	mov    $0x6,%eax
  800e68:	89 df                	mov    %ebx,%edi
  800e6a:	89 de                	mov    %ebx,%esi
  800e6c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6e:	85 c0                	test   %eax,%eax
  800e70:	7f 08                	jg     800e7a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e75:	5b                   	pop    %ebx
  800e76:	5e                   	pop    %esi
  800e77:	5f                   	pop    %edi
  800e78:	5d                   	pop    %ebp
  800e79:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7a:	83 ec 0c             	sub    $0xc,%esp
  800e7d:	50                   	push   %eax
  800e7e:	6a 06                	push   $0x6
  800e80:	68 e0 16 80 00       	push   $0x8016e0
  800e85:	6a 43                	push   $0x43
  800e87:	68 fd 16 80 00       	push   $0x8016fd
  800e8c:	e8 f2 f2 ff ff       	call   800183 <_panic>

00800e91 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e91:	55                   	push   %ebp
  800e92:	89 e5                	mov    %esp,%ebp
  800e94:	57                   	push   %edi
  800e95:	56                   	push   %esi
  800e96:	53                   	push   %ebx
  800e97:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e9a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea5:	b8 08 00 00 00       	mov    $0x8,%eax
  800eaa:	89 df                	mov    %ebx,%edi
  800eac:	89 de                	mov    %ebx,%esi
  800eae:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb0:	85 c0                	test   %eax,%eax
  800eb2:	7f 08                	jg     800ebc <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800eb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb7:	5b                   	pop    %ebx
  800eb8:	5e                   	pop    %esi
  800eb9:	5f                   	pop    %edi
  800eba:	5d                   	pop    %ebp
  800ebb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebc:	83 ec 0c             	sub    $0xc,%esp
  800ebf:	50                   	push   %eax
  800ec0:	6a 08                	push   $0x8
  800ec2:	68 e0 16 80 00       	push   $0x8016e0
  800ec7:	6a 43                	push   $0x43
  800ec9:	68 fd 16 80 00       	push   $0x8016fd
  800ece:	e8 b0 f2 ff ff       	call   800183 <_panic>

00800ed3 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
  800ed6:	57                   	push   %edi
  800ed7:	56                   	push   %esi
  800ed8:	53                   	push   %ebx
  800ed9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800edc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee7:	b8 09 00 00 00       	mov    $0x9,%eax
  800eec:	89 df                	mov    %ebx,%edi
  800eee:	89 de                	mov    %ebx,%esi
  800ef0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef2:	85 c0                	test   %eax,%eax
  800ef4:	7f 08                	jg     800efe <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ef6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef9:	5b                   	pop    %ebx
  800efa:	5e                   	pop    %esi
  800efb:	5f                   	pop    %edi
  800efc:	5d                   	pop    %ebp
  800efd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800efe:	83 ec 0c             	sub    $0xc,%esp
  800f01:	50                   	push   %eax
  800f02:	6a 09                	push   $0x9
  800f04:	68 e0 16 80 00       	push   $0x8016e0
  800f09:	6a 43                	push   $0x43
  800f0b:	68 fd 16 80 00       	push   $0x8016fd
  800f10:	e8 6e f2 ff ff       	call   800183 <_panic>

00800f15 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	57                   	push   %edi
  800f19:	56                   	push   %esi
  800f1a:	53                   	push   %ebx
  800f1b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f1e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f23:	8b 55 08             	mov    0x8(%ebp),%edx
  800f26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f29:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f2e:	89 df                	mov    %ebx,%edi
  800f30:	89 de                	mov    %ebx,%esi
  800f32:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f34:	85 c0                	test   %eax,%eax
  800f36:	7f 08                	jg     800f40 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f3b:	5b                   	pop    %ebx
  800f3c:	5e                   	pop    %esi
  800f3d:	5f                   	pop    %edi
  800f3e:	5d                   	pop    %ebp
  800f3f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f40:	83 ec 0c             	sub    $0xc,%esp
  800f43:	50                   	push   %eax
  800f44:	6a 0a                	push   $0xa
  800f46:	68 e0 16 80 00       	push   $0x8016e0
  800f4b:	6a 43                	push   $0x43
  800f4d:	68 fd 16 80 00       	push   $0x8016fd
  800f52:	e8 2c f2 ff ff       	call   800183 <_panic>

00800f57 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f57:	55                   	push   %ebp
  800f58:	89 e5                	mov    %esp,%ebp
  800f5a:	57                   	push   %edi
  800f5b:	56                   	push   %esi
  800f5c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f63:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f68:	be 00 00 00 00       	mov    $0x0,%esi
  800f6d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f70:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f73:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f75:	5b                   	pop    %ebx
  800f76:	5e                   	pop    %esi
  800f77:	5f                   	pop    %edi
  800f78:	5d                   	pop    %ebp
  800f79:	c3                   	ret    

00800f7a <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	57                   	push   %edi
  800f7e:	56                   	push   %esi
  800f7f:	53                   	push   %ebx
  800f80:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f83:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f88:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8b:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f90:	89 cb                	mov    %ecx,%ebx
  800f92:	89 cf                	mov    %ecx,%edi
  800f94:	89 ce                	mov    %ecx,%esi
  800f96:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f98:	85 c0                	test   %eax,%eax
  800f9a:	7f 08                	jg     800fa4 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f9f:	5b                   	pop    %ebx
  800fa0:	5e                   	pop    %esi
  800fa1:	5f                   	pop    %edi
  800fa2:	5d                   	pop    %ebp
  800fa3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa4:	83 ec 0c             	sub    $0xc,%esp
  800fa7:	50                   	push   %eax
  800fa8:	6a 0d                	push   $0xd
  800faa:	68 e0 16 80 00       	push   $0x8016e0
  800faf:	6a 43                	push   $0x43
  800fb1:	68 fd 16 80 00       	push   $0x8016fd
  800fb6:	e8 c8 f1 ff ff       	call   800183 <_panic>

00800fbb <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fbb:	55                   	push   %ebp
  800fbc:	89 e5                	mov    %esp,%ebp
  800fbe:	57                   	push   %edi
  800fbf:	56                   	push   %esi
  800fc0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fcc:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fd1:	89 df                	mov    %ebx,%edi
  800fd3:	89 de                	mov    %ebx,%esi
  800fd5:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fd7:	5b                   	pop    %ebx
  800fd8:	5e                   	pop    %esi
  800fd9:	5f                   	pop    %edi
  800fda:	5d                   	pop    %ebp
  800fdb:	c3                   	ret    

00800fdc <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	57                   	push   %edi
  800fe0:	56                   	push   %esi
  800fe1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fe2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fe7:	8b 55 08             	mov    0x8(%ebp),%edx
  800fea:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fef:	89 cb                	mov    %ecx,%ebx
  800ff1:	89 cf                	mov    %ecx,%edi
  800ff3:	89 ce                	mov    %ecx,%esi
  800ff5:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800ff7:	5b                   	pop    %ebx
  800ff8:	5e                   	pop    %esi
  800ff9:	5f                   	pop    %edi
  800ffa:	5d                   	pop    %ebp
  800ffb:	c3                   	ret    
  800ffc:	66 90                	xchg   %ax,%ax
  800ffe:	66 90                	xchg   %ax,%ax

00801000 <__udivdi3>:
  801000:	55                   	push   %ebp
  801001:	57                   	push   %edi
  801002:	56                   	push   %esi
  801003:	53                   	push   %ebx
  801004:	83 ec 1c             	sub    $0x1c,%esp
  801007:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80100b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80100f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801013:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801017:	85 d2                	test   %edx,%edx
  801019:	75 4d                	jne    801068 <__udivdi3+0x68>
  80101b:	39 f3                	cmp    %esi,%ebx
  80101d:	76 19                	jbe    801038 <__udivdi3+0x38>
  80101f:	31 ff                	xor    %edi,%edi
  801021:	89 e8                	mov    %ebp,%eax
  801023:	89 f2                	mov    %esi,%edx
  801025:	f7 f3                	div    %ebx
  801027:	89 fa                	mov    %edi,%edx
  801029:	83 c4 1c             	add    $0x1c,%esp
  80102c:	5b                   	pop    %ebx
  80102d:	5e                   	pop    %esi
  80102e:	5f                   	pop    %edi
  80102f:	5d                   	pop    %ebp
  801030:	c3                   	ret    
  801031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801038:	89 d9                	mov    %ebx,%ecx
  80103a:	85 db                	test   %ebx,%ebx
  80103c:	75 0b                	jne    801049 <__udivdi3+0x49>
  80103e:	b8 01 00 00 00       	mov    $0x1,%eax
  801043:	31 d2                	xor    %edx,%edx
  801045:	f7 f3                	div    %ebx
  801047:	89 c1                	mov    %eax,%ecx
  801049:	31 d2                	xor    %edx,%edx
  80104b:	89 f0                	mov    %esi,%eax
  80104d:	f7 f1                	div    %ecx
  80104f:	89 c6                	mov    %eax,%esi
  801051:	89 e8                	mov    %ebp,%eax
  801053:	89 f7                	mov    %esi,%edi
  801055:	f7 f1                	div    %ecx
  801057:	89 fa                	mov    %edi,%edx
  801059:	83 c4 1c             	add    $0x1c,%esp
  80105c:	5b                   	pop    %ebx
  80105d:	5e                   	pop    %esi
  80105e:	5f                   	pop    %edi
  80105f:	5d                   	pop    %ebp
  801060:	c3                   	ret    
  801061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801068:	39 f2                	cmp    %esi,%edx
  80106a:	77 1c                	ja     801088 <__udivdi3+0x88>
  80106c:	0f bd fa             	bsr    %edx,%edi
  80106f:	83 f7 1f             	xor    $0x1f,%edi
  801072:	75 2c                	jne    8010a0 <__udivdi3+0xa0>
  801074:	39 f2                	cmp    %esi,%edx
  801076:	72 06                	jb     80107e <__udivdi3+0x7e>
  801078:	31 c0                	xor    %eax,%eax
  80107a:	39 eb                	cmp    %ebp,%ebx
  80107c:	77 a9                	ja     801027 <__udivdi3+0x27>
  80107e:	b8 01 00 00 00       	mov    $0x1,%eax
  801083:	eb a2                	jmp    801027 <__udivdi3+0x27>
  801085:	8d 76 00             	lea    0x0(%esi),%esi
  801088:	31 ff                	xor    %edi,%edi
  80108a:	31 c0                	xor    %eax,%eax
  80108c:	89 fa                	mov    %edi,%edx
  80108e:	83 c4 1c             	add    $0x1c,%esp
  801091:	5b                   	pop    %ebx
  801092:	5e                   	pop    %esi
  801093:	5f                   	pop    %edi
  801094:	5d                   	pop    %ebp
  801095:	c3                   	ret    
  801096:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80109d:	8d 76 00             	lea    0x0(%esi),%esi
  8010a0:	89 f9                	mov    %edi,%ecx
  8010a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8010a7:	29 f8                	sub    %edi,%eax
  8010a9:	d3 e2                	shl    %cl,%edx
  8010ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8010af:	89 c1                	mov    %eax,%ecx
  8010b1:	89 da                	mov    %ebx,%edx
  8010b3:	d3 ea                	shr    %cl,%edx
  8010b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8010b9:	09 d1                	or     %edx,%ecx
  8010bb:	89 f2                	mov    %esi,%edx
  8010bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010c1:	89 f9                	mov    %edi,%ecx
  8010c3:	d3 e3                	shl    %cl,%ebx
  8010c5:	89 c1                	mov    %eax,%ecx
  8010c7:	d3 ea                	shr    %cl,%edx
  8010c9:	89 f9                	mov    %edi,%ecx
  8010cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8010cf:	89 eb                	mov    %ebp,%ebx
  8010d1:	d3 e6                	shl    %cl,%esi
  8010d3:	89 c1                	mov    %eax,%ecx
  8010d5:	d3 eb                	shr    %cl,%ebx
  8010d7:	09 de                	or     %ebx,%esi
  8010d9:	89 f0                	mov    %esi,%eax
  8010db:	f7 74 24 08          	divl   0x8(%esp)
  8010df:	89 d6                	mov    %edx,%esi
  8010e1:	89 c3                	mov    %eax,%ebx
  8010e3:	f7 64 24 0c          	mull   0xc(%esp)
  8010e7:	39 d6                	cmp    %edx,%esi
  8010e9:	72 15                	jb     801100 <__udivdi3+0x100>
  8010eb:	89 f9                	mov    %edi,%ecx
  8010ed:	d3 e5                	shl    %cl,%ebp
  8010ef:	39 c5                	cmp    %eax,%ebp
  8010f1:	73 04                	jae    8010f7 <__udivdi3+0xf7>
  8010f3:	39 d6                	cmp    %edx,%esi
  8010f5:	74 09                	je     801100 <__udivdi3+0x100>
  8010f7:	89 d8                	mov    %ebx,%eax
  8010f9:	31 ff                	xor    %edi,%edi
  8010fb:	e9 27 ff ff ff       	jmp    801027 <__udivdi3+0x27>
  801100:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801103:	31 ff                	xor    %edi,%edi
  801105:	e9 1d ff ff ff       	jmp    801027 <__udivdi3+0x27>
  80110a:	66 90                	xchg   %ax,%ax
  80110c:	66 90                	xchg   %ax,%ax
  80110e:	66 90                	xchg   %ax,%ax

00801110 <__umoddi3>:
  801110:	55                   	push   %ebp
  801111:	57                   	push   %edi
  801112:	56                   	push   %esi
  801113:	53                   	push   %ebx
  801114:	83 ec 1c             	sub    $0x1c,%esp
  801117:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80111b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80111f:	8b 74 24 30          	mov    0x30(%esp),%esi
  801123:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801127:	89 da                	mov    %ebx,%edx
  801129:	85 c0                	test   %eax,%eax
  80112b:	75 43                	jne    801170 <__umoddi3+0x60>
  80112d:	39 df                	cmp    %ebx,%edi
  80112f:	76 17                	jbe    801148 <__umoddi3+0x38>
  801131:	89 f0                	mov    %esi,%eax
  801133:	f7 f7                	div    %edi
  801135:	89 d0                	mov    %edx,%eax
  801137:	31 d2                	xor    %edx,%edx
  801139:	83 c4 1c             	add    $0x1c,%esp
  80113c:	5b                   	pop    %ebx
  80113d:	5e                   	pop    %esi
  80113e:	5f                   	pop    %edi
  80113f:	5d                   	pop    %ebp
  801140:	c3                   	ret    
  801141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801148:	89 fd                	mov    %edi,%ebp
  80114a:	85 ff                	test   %edi,%edi
  80114c:	75 0b                	jne    801159 <__umoddi3+0x49>
  80114e:	b8 01 00 00 00       	mov    $0x1,%eax
  801153:	31 d2                	xor    %edx,%edx
  801155:	f7 f7                	div    %edi
  801157:	89 c5                	mov    %eax,%ebp
  801159:	89 d8                	mov    %ebx,%eax
  80115b:	31 d2                	xor    %edx,%edx
  80115d:	f7 f5                	div    %ebp
  80115f:	89 f0                	mov    %esi,%eax
  801161:	f7 f5                	div    %ebp
  801163:	89 d0                	mov    %edx,%eax
  801165:	eb d0                	jmp    801137 <__umoddi3+0x27>
  801167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80116e:	66 90                	xchg   %ax,%ax
  801170:	89 f1                	mov    %esi,%ecx
  801172:	39 d8                	cmp    %ebx,%eax
  801174:	76 0a                	jbe    801180 <__umoddi3+0x70>
  801176:	89 f0                	mov    %esi,%eax
  801178:	83 c4 1c             	add    $0x1c,%esp
  80117b:	5b                   	pop    %ebx
  80117c:	5e                   	pop    %esi
  80117d:	5f                   	pop    %edi
  80117e:	5d                   	pop    %ebp
  80117f:	c3                   	ret    
  801180:	0f bd e8             	bsr    %eax,%ebp
  801183:	83 f5 1f             	xor    $0x1f,%ebp
  801186:	75 20                	jne    8011a8 <__umoddi3+0x98>
  801188:	39 d8                	cmp    %ebx,%eax
  80118a:	0f 82 b0 00 00 00    	jb     801240 <__umoddi3+0x130>
  801190:	39 f7                	cmp    %esi,%edi
  801192:	0f 86 a8 00 00 00    	jbe    801240 <__umoddi3+0x130>
  801198:	89 c8                	mov    %ecx,%eax
  80119a:	83 c4 1c             	add    $0x1c,%esp
  80119d:	5b                   	pop    %ebx
  80119e:	5e                   	pop    %esi
  80119f:	5f                   	pop    %edi
  8011a0:	5d                   	pop    %ebp
  8011a1:	c3                   	ret    
  8011a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8011a8:	89 e9                	mov    %ebp,%ecx
  8011aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8011af:	29 ea                	sub    %ebp,%edx
  8011b1:	d3 e0                	shl    %cl,%eax
  8011b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011b7:	89 d1                	mov    %edx,%ecx
  8011b9:	89 f8                	mov    %edi,%eax
  8011bb:	d3 e8                	shr    %cl,%eax
  8011bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8011c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8011c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8011c9:	09 c1                	or     %eax,%ecx
  8011cb:	89 d8                	mov    %ebx,%eax
  8011cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8011d1:	89 e9                	mov    %ebp,%ecx
  8011d3:	d3 e7                	shl    %cl,%edi
  8011d5:	89 d1                	mov    %edx,%ecx
  8011d7:	d3 e8                	shr    %cl,%eax
  8011d9:	89 e9                	mov    %ebp,%ecx
  8011db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8011df:	d3 e3                	shl    %cl,%ebx
  8011e1:	89 c7                	mov    %eax,%edi
  8011e3:	89 d1                	mov    %edx,%ecx
  8011e5:	89 f0                	mov    %esi,%eax
  8011e7:	d3 e8                	shr    %cl,%eax
  8011e9:	89 e9                	mov    %ebp,%ecx
  8011eb:	89 fa                	mov    %edi,%edx
  8011ed:	d3 e6                	shl    %cl,%esi
  8011ef:	09 d8                	or     %ebx,%eax
  8011f1:	f7 74 24 08          	divl   0x8(%esp)
  8011f5:	89 d1                	mov    %edx,%ecx
  8011f7:	89 f3                	mov    %esi,%ebx
  8011f9:	f7 64 24 0c          	mull   0xc(%esp)
  8011fd:	89 c6                	mov    %eax,%esi
  8011ff:	89 d7                	mov    %edx,%edi
  801201:	39 d1                	cmp    %edx,%ecx
  801203:	72 06                	jb     80120b <__umoddi3+0xfb>
  801205:	75 10                	jne    801217 <__umoddi3+0x107>
  801207:	39 c3                	cmp    %eax,%ebx
  801209:	73 0c                	jae    801217 <__umoddi3+0x107>
  80120b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80120f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801213:	89 d7                	mov    %edx,%edi
  801215:	89 c6                	mov    %eax,%esi
  801217:	89 ca                	mov    %ecx,%edx
  801219:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80121e:	29 f3                	sub    %esi,%ebx
  801220:	19 fa                	sbb    %edi,%edx
  801222:	89 d0                	mov    %edx,%eax
  801224:	d3 e0                	shl    %cl,%eax
  801226:	89 e9                	mov    %ebp,%ecx
  801228:	d3 eb                	shr    %cl,%ebx
  80122a:	d3 ea                	shr    %cl,%edx
  80122c:	09 d8                	or     %ebx,%eax
  80122e:	83 c4 1c             	add    $0x1c,%esp
  801231:	5b                   	pop    %ebx
  801232:	5e                   	pop    %esi
  801233:	5f                   	pop    %edi
  801234:	5d                   	pop    %ebp
  801235:	c3                   	ret    
  801236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80123d:	8d 76 00             	lea    0x0(%esi),%esi
  801240:	89 da                	mov    %ebx,%edx
  801242:	29 fe                	sub    %edi,%esi
  801244:	19 c2                	sbb    %eax,%edx
  801246:	89 f1                	mov    %esi,%ecx
  801248:	89 c8                	mov    %ecx,%eax
  80124a:	e9 4b ff ff ff       	jmp    80119a <__umoddi3+0x8a>
