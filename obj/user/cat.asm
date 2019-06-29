
obj/user/cat.debug:     file format elf32-i386


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
  80002c:	e8 fc 00 00 00       	call   80012d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  80003b:	83 ec 04             	sub    $0x4,%esp
  80003e:	68 00 20 00 00       	push   $0x2000
  800043:	68 20 40 80 00       	push   $0x804020
  800048:	56                   	push   %esi
  800049:	e8 81 13 00 00       	call   8013cf <read>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	7e 2f                	jle    800086 <cat+0x53>
		if ((r = write(1, buf, n)) != n)
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	53                   	push   %ebx
  80005b:	68 20 40 80 00       	push   $0x804020
  800060:	6a 01                	push   $0x1
  800062:	e8 34 14 00 00       	call   80149b <write>
  800067:	83 c4 10             	add    $0x10,%esp
  80006a:	39 c3                	cmp    %eax,%ebx
  80006c:	74 cd                	je     80003b <cat+0x8>
			panic("write error copying %s: %e", s, r);
  80006e:	83 ec 0c             	sub    $0xc,%esp
  800071:	50                   	push   %eax
  800072:	ff 75 0c             	pushl  0xc(%ebp)
  800075:	68 e0 26 80 00       	push   $0x8026e0
  80007a:	6a 0d                	push   $0xd
  80007c:	68 fb 26 80 00       	push   $0x8026fb
  800081:	e8 24 01 00 00       	call   8001aa <_panic>
	if (n < 0)
  800086:	78 07                	js     80008f <cat+0x5c>
		panic("error reading %s: %e", s, n);
}
  800088:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008b:	5b                   	pop    %ebx
  80008c:	5e                   	pop    %esi
  80008d:	5d                   	pop    %ebp
  80008e:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	50                   	push   %eax
  800093:	ff 75 0c             	pushl  0xc(%ebp)
  800096:	68 06 27 80 00       	push   $0x802706
  80009b:	6a 0f                	push   $0xf
  80009d:	68 fb 26 80 00       	push   $0x8026fb
  8000a2:	e8 03 01 00 00       	call   8001aa <_panic>

008000a7 <umain>:

void
umain(int argc, char **argv)
{
  8000a7:	55                   	push   %ebp
  8000a8:	89 e5                	mov    %esp,%ebp
  8000aa:	57                   	push   %edi
  8000ab:	56                   	push   %esi
  8000ac:	53                   	push   %ebx
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int f, i;

	binaryname = "cat";
  8000b3:	c7 05 00 30 80 00 1b 	movl   $0x80271b,0x803000
  8000ba:	27 80 00 
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8000bd:	bb 01 00 00 00       	mov    $0x1,%ebx
	if (argc == 1)
  8000c2:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000c6:	75 31                	jne    8000f9 <umain+0x52>
		cat(0, "<stdin>");
  8000c8:	83 ec 08             	sub    $0x8,%esp
  8000cb:	68 1f 27 80 00       	push   $0x80271f
  8000d0:	6a 00                	push   $0x0
  8000d2:	e8 5c ff ff ff       	call   800033 <cat>
  8000d7:	83 c4 10             	add    $0x10,%esp
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  8000da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000dd:	5b                   	pop    %ebx
  8000de:	5e                   	pop    %esi
  8000df:	5f                   	pop    %edi
  8000e0:	5d                   	pop    %ebp
  8000e1:	c3                   	ret    
				printf("can't open %s: %e\n", argv[i], f);
  8000e2:	83 ec 04             	sub    $0x4,%esp
  8000e5:	50                   	push   %eax
  8000e6:	ff 34 9f             	pushl  (%edi,%ebx,4)
  8000e9:	68 27 27 80 00       	push   $0x802727
  8000ee:	e8 1d 19 00 00       	call   801a10 <printf>
  8000f3:	83 c4 10             	add    $0x10,%esp
		for (i = 1; i < argc; i++) {
  8000f6:	83 c3 01             	add    $0x1,%ebx
  8000f9:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  8000fc:	7d dc                	jge    8000da <umain+0x33>
			f = open(argv[i], O_RDONLY);
  8000fe:	83 ec 08             	sub    $0x8,%esp
  800101:	6a 00                	push   $0x0
  800103:	ff 34 9f             	pushl  (%edi,%ebx,4)
  800106:	e8 62 17 00 00       	call   80186d <open>
  80010b:	89 c6                	mov    %eax,%esi
			if (f < 0)
  80010d:	83 c4 10             	add    $0x10,%esp
  800110:	85 c0                	test   %eax,%eax
  800112:	78 ce                	js     8000e2 <umain+0x3b>
				cat(f, argv[i]);
  800114:	83 ec 08             	sub    $0x8,%esp
  800117:	ff 34 9f             	pushl  (%edi,%ebx,4)
  80011a:	50                   	push   %eax
  80011b:	e8 13 ff ff ff       	call   800033 <cat>
				close(f);
  800120:	89 34 24             	mov    %esi,(%esp)
  800123:	e8 69 11 00 00       	call   801291 <close>
  800128:	83 c4 10             	add    $0x10,%esp
  80012b:	eb c9                	jmp    8000f6 <umain+0x4f>

0080012d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80012d:	55                   	push   %ebp
  80012e:	89 e5                	mov    %esp,%ebp
  800130:	56                   	push   %esi
  800131:	53                   	push   %ebx
  800132:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800135:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  800138:	e8 76 0c 00 00       	call   800db3 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  80013d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800142:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800148:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80014d:	a3 20 60 80 00       	mov    %eax,0x806020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800152:	85 db                	test   %ebx,%ebx
  800154:	7e 07                	jle    80015d <libmain+0x30>
		binaryname = argv[0];
  800156:	8b 06                	mov    (%esi),%eax
  800158:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80015d:	83 ec 08             	sub    $0x8,%esp
  800160:	56                   	push   %esi
  800161:	53                   	push   %ebx
  800162:	e8 40 ff ff ff       	call   8000a7 <umain>

	// exit gracefully
	exit();
  800167:	e8 0a 00 00 00       	call   800176 <exit>
}
  80016c:	83 c4 10             	add    $0x10,%esp
  80016f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800172:	5b                   	pop    %ebx
  800173:	5e                   	pop    %esi
  800174:	5d                   	pop    %ebp
  800175:	c3                   	ret    

00800176 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800176:	55                   	push   %ebp
  800177:	89 e5                	mov    %esp,%ebp
  800179:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80017c:	a1 20 60 80 00       	mov    0x806020,%eax
  800181:	8b 40 48             	mov    0x48(%eax),%eax
  800184:	68 50 27 80 00       	push   $0x802750
  800189:	50                   	push   %eax
  80018a:	68 44 27 80 00       	push   $0x802744
  80018f:	e8 0c 01 00 00       	call   8002a0 <cprintf>
	close_all();
  800194:	e8 25 11 00 00       	call   8012be <close_all>
	sys_env_destroy(0);
  800199:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001a0:	e8 cd 0b 00 00       	call   800d72 <sys_env_destroy>
}
  8001a5:	83 c4 10             	add    $0x10,%esp
  8001a8:	c9                   	leave  
  8001a9:	c3                   	ret    

008001aa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	56                   	push   %esi
  8001ae:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001af:	a1 20 60 80 00       	mov    0x806020,%eax
  8001b4:	8b 40 48             	mov    0x48(%eax),%eax
  8001b7:	83 ec 04             	sub    $0x4,%esp
  8001ba:	68 7c 27 80 00       	push   $0x80277c
  8001bf:	50                   	push   %eax
  8001c0:	68 44 27 80 00       	push   $0x802744
  8001c5:	e8 d6 00 00 00       	call   8002a0 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8001ca:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001cd:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8001d3:	e8 db 0b 00 00       	call   800db3 <sys_getenvid>
  8001d8:	83 c4 04             	add    $0x4,%esp
  8001db:	ff 75 0c             	pushl  0xc(%ebp)
  8001de:	ff 75 08             	pushl  0x8(%ebp)
  8001e1:	56                   	push   %esi
  8001e2:	50                   	push   %eax
  8001e3:	68 58 27 80 00       	push   $0x802758
  8001e8:	e8 b3 00 00 00       	call   8002a0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001ed:	83 c4 18             	add    $0x18,%esp
  8001f0:	53                   	push   %ebx
  8001f1:	ff 75 10             	pushl  0x10(%ebp)
  8001f4:	e8 56 00 00 00       	call   80024f <vcprintf>
	cprintf("\n");
  8001f9:	c7 04 24 72 2c 80 00 	movl   $0x802c72,(%esp)
  800200:	e8 9b 00 00 00       	call   8002a0 <cprintf>
  800205:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800208:	cc                   	int3   
  800209:	eb fd                	jmp    800208 <_panic+0x5e>

0080020b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80020b:	55                   	push   %ebp
  80020c:	89 e5                	mov    %esp,%ebp
  80020e:	53                   	push   %ebx
  80020f:	83 ec 04             	sub    $0x4,%esp
  800212:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800215:	8b 13                	mov    (%ebx),%edx
  800217:	8d 42 01             	lea    0x1(%edx),%eax
  80021a:	89 03                	mov    %eax,(%ebx)
  80021c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80021f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800223:	3d ff 00 00 00       	cmp    $0xff,%eax
  800228:	74 09                	je     800233 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80022a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80022e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800231:	c9                   	leave  
  800232:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800233:	83 ec 08             	sub    $0x8,%esp
  800236:	68 ff 00 00 00       	push   $0xff
  80023b:	8d 43 08             	lea    0x8(%ebx),%eax
  80023e:	50                   	push   %eax
  80023f:	e8 f1 0a 00 00       	call   800d35 <sys_cputs>
		b->idx = 0;
  800244:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80024a:	83 c4 10             	add    $0x10,%esp
  80024d:	eb db                	jmp    80022a <putch+0x1f>

0080024f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80024f:	55                   	push   %ebp
  800250:	89 e5                	mov    %esp,%ebp
  800252:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800258:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80025f:	00 00 00 
	b.cnt = 0;
  800262:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800269:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80026c:	ff 75 0c             	pushl  0xc(%ebp)
  80026f:	ff 75 08             	pushl  0x8(%ebp)
  800272:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800278:	50                   	push   %eax
  800279:	68 0b 02 80 00       	push   $0x80020b
  80027e:	e8 4a 01 00 00       	call   8003cd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800283:	83 c4 08             	add    $0x8,%esp
  800286:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80028c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800292:	50                   	push   %eax
  800293:	e8 9d 0a 00 00       	call   800d35 <sys_cputs>

	return b.cnt;
}
  800298:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80029e:	c9                   	leave  
  80029f:	c3                   	ret    

008002a0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002a6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002a9:	50                   	push   %eax
  8002aa:	ff 75 08             	pushl  0x8(%ebp)
  8002ad:	e8 9d ff ff ff       	call   80024f <vcprintf>
	va_end(ap);

	return cnt;
}
  8002b2:	c9                   	leave  
  8002b3:	c3                   	ret    

008002b4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002b4:	55                   	push   %ebp
  8002b5:	89 e5                	mov    %esp,%ebp
  8002b7:	57                   	push   %edi
  8002b8:	56                   	push   %esi
  8002b9:	53                   	push   %ebx
  8002ba:	83 ec 1c             	sub    $0x1c,%esp
  8002bd:	89 c6                	mov    %eax,%esi
  8002bf:	89 d7                	mov    %edx,%edi
  8002c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002ca:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d0:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8002d3:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002d7:	74 2c                	je     800305 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8002d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002dc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002e6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002e9:	39 c2                	cmp    %eax,%edx
  8002eb:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002ee:	73 43                	jae    800333 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002f0:	83 eb 01             	sub    $0x1,%ebx
  8002f3:	85 db                	test   %ebx,%ebx
  8002f5:	7e 6c                	jle    800363 <printnum+0xaf>
				putch(padc, putdat);
  8002f7:	83 ec 08             	sub    $0x8,%esp
  8002fa:	57                   	push   %edi
  8002fb:	ff 75 18             	pushl  0x18(%ebp)
  8002fe:	ff d6                	call   *%esi
  800300:	83 c4 10             	add    $0x10,%esp
  800303:	eb eb                	jmp    8002f0 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800305:	83 ec 0c             	sub    $0xc,%esp
  800308:	6a 20                	push   $0x20
  80030a:	6a 00                	push   $0x0
  80030c:	50                   	push   %eax
  80030d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800310:	ff 75 e0             	pushl  -0x20(%ebp)
  800313:	89 fa                	mov    %edi,%edx
  800315:	89 f0                	mov    %esi,%eax
  800317:	e8 98 ff ff ff       	call   8002b4 <printnum>
		while (--width > 0)
  80031c:	83 c4 20             	add    $0x20,%esp
  80031f:	83 eb 01             	sub    $0x1,%ebx
  800322:	85 db                	test   %ebx,%ebx
  800324:	7e 65                	jle    80038b <printnum+0xd7>
			putch(padc, putdat);
  800326:	83 ec 08             	sub    $0x8,%esp
  800329:	57                   	push   %edi
  80032a:	6a 20                	push   $0x20
  80032c:	ff d6                	call   *%esi
  80032e:	83 c4 10             	add    $0x10,%esp
  800331:	eb ec                	jmp    80031f <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800333:	83 ec 0c             	sub    $0xc,%esp
  800336:	ff 75 18             	pushl  0x18(%ebp)
  800339:	83 eb 01             	sub    $0x1,%ebx
  80033c:	53                   	push   %ebx
  80033d:	50                   	push   %eax
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	ff 75 dc             	pushl  -0x24(%ebp)
  800344:	ff 75 d8             	pushl  -0x28(%ebp)
  800347:	ff 75 e4             	pushl  -0x1c(%ebp)
  80034a:	ff 75 e0             	pushl  -0x20(%ebp)
  80034d:	e8 3e 21 00 00       	call   802490 <__udivdi3>
  800352:	83 c4 18             	add    $0x18,%esp
  800355:	52                   	push   %edx
  800356:	50                   	push   %eax
  800357:	89 fa                	mov    %edi,%edx
  800359:	89 f0                	mov    %esi,%eax
  80035b:	e8 54 ff ff ff       	call   8002b4 <printnum>
  800360:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800363:	83 ec 08             	sub    $0x8,%esp
  800366:	57                   	push   %edi
  800367:	83 ec 04             	sub    $0x4,%esp
  80036a:	ff 75 dc             	pushl  -0x24(%ebp)
  80036d:	ff 75 d8             	pushl  -0x28(%ebp)
  800370:	ff 75 e4             	pushl  -0x1c(%ebp)
  800373:	ff 75 e0             	pushl  -0x20(%ebp)
  800376:	e8 25 22 00 00       	call   8025a0 <__umoddi3>
  80037b:	83 c4 14             	add    $0x14,%esp
  80037e:	0f be 80 83 27 80 00 	movsbl 0x802783(%eax),%eax
  800385:	50                   	push   %eax
  800386:	ff d6                	call   *%esi
  800388:	83 c4 10             	add    $0x10,%esp
	}
}
  80038b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80038e:	5b                   	pop    %ebx
  80038f:	5e                   	pop    %esi
  800390:	5f                   	pop    %edi
  800391:	5d                   	pop    %ebp
  800392:	c3                   	ret    

00800393 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800393:	55                   	push   %ebp
  800394:	89 e5                	mov    %esp,%ebp
  800396:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800399:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80039d:	8b 10                	mov    (%eax),%edx
  80039f:	3b 50 04             	cmp    0x4(%eax),%edx
  8003a2:	73 0a                	jae    8003ae <sprintputch+0x1b>
		*b->buf++ = ch;
  8003a4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003a7:	89 08                	mov    %ecx,(%eax)
  8003a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ac:	88 02                	mov    %al,(%edx)
}
  8003ae:	5d                   	pop    %ebp
  8003af:	c3                   	ret    

008003b0 <printfmt>:
{
  8003b0:	55                   	push   %ebp
  8003b1:	89 e5                	mov    %esp,%ebp
  8003b3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003b6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003b9:	50                   	push   %eax
  8003ba:	ff 75 10             	pushl  0x10(%ebp)
  8003bd:	ff 75 0c             	pushl  0xc(%ebp)
  8003c0:	ff 75 08             	pushl  0x8(%ebp)
  8003c3:	e8 05 00 00 00       	call   8003cd <vprintfmt>
}
  8003c8:	83 c4 10             	add    $0x10,%esp
  8003cb:	c9                   	leave  
  8003cc:	c3                   	ret    

008003cd <vprintfmt>:
{
  8003cd:	55                   	push   %ebp
  8003ce:	89 e5                	mov    %esp,%ebp
  8003d0:	57                   	push   %edi
  8003d1:	56                   	push   %esi
  8003d2:	53                   	push   %ebx
  8003d3:	83 ec 3c             	sub    $0x3c,%esp
  8003d6:	8b 75 08             	mov    0x8(%ebp),%esi
  8003d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003dc:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003df:	e9 32 04 00 00       	jmp    800816 <vprintfmt+0x449>
		padc = ' ';
  8003e4:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003e8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003ef:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003f6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003fd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800404:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80040b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800410:	8d 47 01             	lea    0x1(%edi),%eax
  800413:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800416:	0f b6 17             	movzbl (%edi),%edx
  800419:	8d 42 dd             	lea    -0x23(%edx),%eax
  80041c:	3c 55                	cmp    $0x55,%al
  80041e:	0f 87 12 05 00 00    	ja     800936 <vprintfmt+0x569>
  800424:	0f b6 c0             	movzbl %al,%eax
  800427:	ff 24 85 60 29 80 00 	jmp    *0x802960(,%eax,4)
  80042e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800431:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800435:	eb d9                	jmp    800410 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800437:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80043a:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80043e:	eb d0                	jmp    800410 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800440:	0f b6 d2             	movzbl %dl,%edx
  800443:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800446:	b8 00 00 00 00       	mov    $0x0,%eax
  80044b:	89 75 08             	mov    %esi,0x8(%ebp)
  80044e:	eb 03                	jmp    800453 <vprintfmt+0x86>
  800450:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800453:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800456:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80045a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80045d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800460:	83 fe 09             	cmp    $0x9,%esi
  800463:	76 eb                	jbe    800450 <vprintfmt+0x83>
  800465:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800468:	8b 75 08             	mov    0x8(%ebp),%esi
  80046b:	eb 14                	jmp    800481 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80046d:	8b 45 14             	mov    0x14(%ebp),%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800475:	8b 45 14             	mov    0x14(%ebp),%eax
  800478:	8d 40 04             	lea    0x4(%eax),%eax
  80047b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80047e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800481:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800485:	79 89                	jns    800410 <vprintfmt+0x43>
				width = precision, precision = -1;
  800487:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80048a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80048d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800494:	e9 77 ff ff ff       	jmp    800410 <vprintfmt+0x43>
  800499:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80049c:	85 c0                	test   %eax,%eax
  80049e:	0f 48 c1             	cmovs  %ecx,%eax
  8004a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004a7:	e9 64 ff ff ff       	jmp    800410 <vprintfmt+0x43>
  8004ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004af:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004b6:	e9 55 ff ff ff       	jmp    800410 <vprintfmt+0x43>
			lflag++;
  8004bb:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004c2:	e9 49 ff ff ff       	jmp    800410 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ca:	8d 78 04             	lea    0x4(%eax),%edi
  8004cd:	83 ec 08             	sub    $0x8,%esp
  8004d0:	53                   	push   %ebx
  8004d1:	ff 30                	pushl  (%eax)
  8004d3:	ff d6                	call   *%esi
			break;
  8004d5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004d8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004db:	e9 33 03 00 00       	jmp    800813 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e3:	8d 78 04             	lea    0x4(%eax),%edi
  8004e6:	8b 00                	mov    (%eax),%eax
  8004e8:	99                   	cltd   
  8004e9:	31 d0                	xor    %edx,%eax
  8004eb:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004ed:	83 f8 11             	cmp    $0x11,%eax
  8004f0:	7f 23                	jg     800515 <vprintfmt+0x148>
  8004f2:	8b 14 85 c0 2a 80 00 	mov    0x802ac0(,%eax,4),%edx
  8004f9:	85 d2                	test   %edx,%edx
  8004fb:	74 18                	je     800515 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004fd:	52                   	push   %edx
  8004fe:	68 e1 2b 80 00       	push   $0x802be1
  800503:	53                   	push   %ebx
  800504:	56                   	push   %esi
  800505:	e8 a6 fe ff ff       	call   8003b0 <printfmt>
  80050a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80050d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800510:	e9 fe 02 00 00       	jmp    800813 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800515:	50                   	push   %eax
  800516:	68 9b 27 80 00       	push   $0x80279b
  80051b:	53                   	push   %ebx
  80051c:	56                   	push   %esi
  80051d:	e8 8e fe ff ff       	call   8003b0 <printfmt>
  800522:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800525:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800528:	e9 e6 02 00 00       	jmp    800813 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80052d:	8b 45 14             	mov    0x14(%ebp),%eax
  800530:	83 c0 04             	add    $0x4,%eax
  800533:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800536:	8b 45 14             	mov    0x14(%ebp),%eax
  800539:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80053b:	85 c9                	test   %ecx,%ecx
  80053d:	b8 94 27 80 00       	mov    $0x802794,%eax
  800542:	0f 45 c1             	cmovne %ecx,%eax
  800545:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800548:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80054c:	7e 06                	jle    800554 <vprintfmt+0x187>
  80054e:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800552:	75 0d                	jne    800561 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800554:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800557:	89 c7                	mov    %eax,%edi
  800559:	03 45 e0             	add    -0x20(%ebp),%eax
  80055c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80055f:	eb 53                	jmp    8005b4 <vprintfmt+0x1e7>
  800561:	83 ec 08             	sub    $0x8,%esp
  800564:	ff 75 d8             	pushl  -0x28(%ebp)
  800567:	50                   	push   %eax
  800568:	e8 71 04 00 00       	call   8009de <strnlen>
  80056d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800570:	29 c1                	sub    %eax,%ecx
  800572:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800575:	83 c4 10             	add    $0x10,%esp
  800578:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80057a:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80057e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800581:	eb 0f                	jmp    800592 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	53                   	push   %ebx
  800587:	ff 75 e0             	pushl  -0x20(%ebp)
  80058a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80058c:	83 ef 01             	sub    $0x1,%edi
  80058f:	83 c4 10             	add    $0x10,%esp
  800592:	85 ff                	test   %edi,%edi
  800594:	7f ed                	jg     800583 <vprintfmt+0x1b6>
  800596:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800599:	85 c9                	test   %ecx,%ecx
  80059b:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a0:	0f 49 c1             	cmovns %ecx,%eax
  8005a3:	29 c1                	sub    %eax,%ecx
  8005a5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005a8:	eb aa                	jmp    800554 <vprintfmt+0x187>
					putch(ch, putdat);
  8005aa:	83 ec 08             	sub    $0x8,%esp
  8005ad:	53                   	push   %ebx
  8005ae:	52                   	push   %edx
  8005af:	ff d6                	call   *%esi
  8005b1:	83 c4 10             	add    $0x10,%esp
  8005b4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005b7:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005b9:	83 c7 01             	add    $0x1,%edi
  8005bc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005c0:	0f be d0             	movsbl %al,%edx
  8005c3:	85 d2                	test   %edx,%edx
  8005c5:	74 4b                	je     800612 <vprintfmt+0x245>
  8005c7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005cb:	78 06                	js     8005d3 <vprintfmt+0x206>
  8005cd:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005d1:	78 1e                	js     8005f1 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8005d3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005d7:	74 d1                	je     8005aa <vprintfmt+0x1dd>
  8005d9:	0f be c0             	movsbl %al,%eax
  8005dc:	83 e8 20             	sub    $0x20,%eax
  8005df:	83 f8 5e             	cmp    $0x5e,%eax
  8005e2:	76 c6                	jbe    8005aa <vprintfmt+0x1dd>
					putch('?', putdat);
  8005e4:	83 ec 08             	sub    $0x8,%esp
  8005e7:	53                   	push   %ebx
  8005e8:	6a 3f                	push   $0x3f
  8005ea:	ff d6                	call   *%esi
  8005ec:	83 c4 10             	add    $0x10,%esp
  8005ef:	eb c3                	jmp    8005b4 <vprintfmt+0x1e7>
  8005f1:	89 cf                	mov    %ecx,%edi
  8005f3:	eb 0e                	jmp    800603 <vprintfmt+0x236>
				putch(' ', putdat);
  8005f5:	83 ec 08             	sub    $0x8,%esp
  8005f8:	53                   	push   %ebx
  8005f9:	6a 20                	push   $0x20
  8005fb:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005fd:	83 ef 01             	sub    $0x1,%edi
  800600:	83 c4 10             	add    $0x10,%esp
  800603:	85 ff                	test   %edi,%edi
  800605:	7f ee                	jg     8005f5 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800607:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80060a:	89 45 14             	mov    %eax,0x14(%ebp)
  80060d:	e9 01 02 00 00       	jmp    800813 <vprintfmt+0x446>
  800612:	89 cf                	mov    %ecx,%edi
  800614:	eb ed                	jmp    800603 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800616:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800619:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800620:	e9 eb fd ff ff       	jmp    800410 <vprintfmt+0x43>
	if (lflag >= 2)
  800625:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800629:	7f 21                	jg     80064c <vprintfmt+0x27f>
	else if (lflag)
  80062b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80062f:	74 68                	je     800699 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	8b 00                	mov    (%eax),%eax
  800636:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800639:	89 c1                	mov    %eax,%ecx
  80063b:	c1 f9 1f             	sar    $0x1f,%ecx
  80063e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800641:	8b 45 14             	mov    0x14(%ebp),%eax
  800644:	8d 40 04             	lea    0x4(%eax),%eax
  800647:	89 45 14             	mov    %eax,0x14(%ebp)
  80064a:	eb 17                	jmp    800663 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80064c:	8b 45 14             	mov    0x14(%ebp),%eax
  80064f:	8b 50 04             	mov    0x4(%eax),%edx
  800652:	8b 00                	mov    (%eax),%eax
  800654:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800657:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	8d 40 08             	lea    0x8(%eax),%eax
  800660:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800663:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800666:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800669:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066c:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80066f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800673:	78 3f                	js     8006b4 <vprintfmt+0x2e7>
			base = 10;
  800675:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80067a:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80067e:	0f 84 71 01 00 00    	je     8007f5 <vprintfmt+0x428>
				putch('+', putdat);
  800684:	83 ec 08             	sub    $0x8,%esp
  800687:	53                   	push   %ebx
  800688:	6a 2b                	push   $0x2b
  80068a:	ff d6                	call   *%esi
  80068c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80068f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800694:	e9 5c 01 00 00       	jmp    8007f5 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800699:	8b 45 14             	mov    0x14(%ebp),%eax
  80069c:	8b 00                	mov    (%eax),%eax
  80069e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006a1:	89 c1                	mov    %eax,%ecx
  8006a3:	c1 f9 1f             	sar    $0x1f,%ecx
  8006a6:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	8d 40 04             	lea    0x4(%eax),%eax
  8006af:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b2:	eb af                	jmp    800663 <vprintfmt+0x296>
				putch('-', putdat);
  8006b4:	83 ec 08             	sub    $0x8,%esp
  8006b7:	53                   	push   %ebx
  8006b8:	6a 2d                	push   $0x2d
  8006ba:	ff d6                	call   *%esi
				num = -(long long) num;
  8006bc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006bf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006c2:	f7 d8                	neg    %eax
  8006c4:	83 d2 00             	adc    $0x0,%edx
  8006c7:	f7 da                	neg    %edx
  8006c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006cc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006cf:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006d2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d7:	e9 19 01 00 00       	jmp    8007f5 <vprintfmt+0x428>
	if (lflag >= 2)
  8006dc:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006e0:	7f 29                	jg     80070b <vprintfmt+0x33e>
	else if (lflag)
  8006e2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006e6:	74 44                	je     80072c <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006eb:	8b 00                	mov    (%eax),%eax
  8006ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fb:	8d 40 04             	lea    0x4(%eax),%eax
  8006fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800701:	b8 0a 00 00 00       	mov    $0xa,%eax
  800706:	e9 ea 00 00 00       	jmp    8007f5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	8b 50 04             	mov    0x4(%eax),%edx
  800711:	8b 00                	mov    (%eax),%eax
  800713:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800716:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800719:	8b 45 14             	mov    0x14(%ebp),%eax
  80071c:	8d 40 08             	lea    0x8(%eax),%eax
  80071f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800722:	b8 0a 00 00 00       	mov    $0xa,%eax
  800727:	e9 c9 00 00 00       	jmp    8007f5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8b 00                	mov    (%eax),%eax
  800731:	ba 00 00 00 00       	mov    $0x0,%edx
  800736:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800739:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073c:	8b 45 14             	mov    0x14(%ebp),%eax
  80073f:	8d 40 04             	lea    0x4(%eax),%eax
  800742:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800745:	b8 0a 00 00 00       	mov    $0xa,%eax
  80074a:	e9 a6 00 00 00       	jmp    8007f5 <vprintfmt+0x428>
			putch('0', putdat);
  80074f:	83 ec 08             	sub    $0x8,%esp
  800752:	53                   	push   %ebx
  800753:	6a 30                	push   $0x30
  800755:	ff d6                	call   *%esi
	if (lflag >= 2)
  800757:	83 c4 10             	add    $0x10,%esp
  80075a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80075e:	7f 26                	jg     800786 <vprintfmt+0x3b9>
	else if (lflag)
  800760:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800764:	74 3e                	je     8007a4 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800766:	8b 45 14             	mov    0x14(%ebp),%eax
  800769:	8b 00                	mov    (%eax),%eax
  80076b:	ba 00 00 00 00       	mov    $0x0,%edx
  800770:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800773:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800776:	8b 45 14             	mov    0x14(%ebp),%eax
  800779:	8d 40 04             	lea    0x4(%eax),%eax
  80077c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80077f:	b8 08 00 00 00       	mov    $0x8,%eax
  800784:	eb 6f                	jmp    8007f5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	8b 50 04             	mov    0x4(%eax),%edx
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800791:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800794:	8b 45 14             	mov    0x14(%ebp),%eax
  800797:	8d 40 08             	lea    0x8(%eax),%eax
  80079a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80079d:	b8 08 00 00 00       	mov    $0x8,%eax
  8007a2:	eb 51                	jmp    8007f5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	8b 00                	mov    (%eax),%eax
  8007a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	8d 40 04             	lea    0x4(%eax),%eax
  8007ba:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007bd:	b8 08 00 00 00       	mov    $0x8,%eax
  8007c2:	eb 31                	jmp    8007f5 <vprintfmt+0x428>
			putch('0', putdat);
  8007c4:	83 ec 08             	sub    $0x8,%esp
  8007c7:	53                   	push   %ebx
  8007c8:	6a 30                	push   $0x30
  8007ca:	ff d6                	call   *%esi
			putch('x', putdat);
  8007cc:	83 c4 08             	add    $0x8,%esp
  8007cf:	53                   	push   %ebx
  8007d0:	6a 78                	push   $0x78
  8007d2:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d7:	8b 00                	mov    (%eax),%eax
  8007d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e1:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007e4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ea:	8d 40 04             	lea    0x4(%eax),%eax
  8007ed:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f0:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007f5:	83 ec 0c             	sub    $0xc,%esp
  8007f8:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007fc:	52                   	push   %edx
  8007fd:	ff 75 e0             	pushl  -0x20(%ebp)
  800800:	50                   	push   %eax
  800801:	ff 75 dc             	pushl  -0x24(%ebp)
  800804:	ff 75 d8             	pushl  -0x28(%ebp)
  800807:	89 da                	mov    %ebx,%edx
  800809:	89 f0                	mov    %esi,%eax
  80080b:	e8 a4 fa ff ff       	call   8002b4 <printnum>
			break;
  800810:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800813:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800816:	83 c7 01             	add    $0x1,%edi
  800819:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80081d:	83 f8 25             	cmp    $0x25,%eax
  800820:	0f 84 be fb ff ff    	je     8003e4 <vprintfmt+0x17>
			if (ch == '\0')
  800826:	85 c0                	test   %eax,%eax
  800828:	0f 84 28 01 00 00    	je     800956 <vprintfmt+0x589>
			putch(ch, putdat);
  80082e:	83 ec 08             	sub    $0x8,%esp
  800831:	53                   	push   %ebx
  800832:	50                   	push   %eax
  800833:	ff d6                	call   *%esi
  800835:	83 c4 10             	add    $0x10,%esp
  800838:	eb dc                	jmp    800816 <vprintfmt+0x449>
	if (lflag >= 2)
  80083a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80083e:	7f 26                	jg     800866 <vprintfmt+0x499>
	else if (lflag)
  800840:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800844:	74 41                	je     800887 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	8b 00                	mov    (%eax),%eax
  80084b:	ba 00 00 00 00       	mov    $0x0,%edx
  800850:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800853:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800856:	8b 45 14             	mov    0x14(%ebp),%eax
  800859:	8d 40 04             	lea    0x4(%eax),%eax
  80085c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80085f:	b8 10 00 00 00       	mov    $0x10,%eax
  800864:	eb 8f                	jmp    8007f5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800866:	8b 45 14             	mov    0x14(%ebp),%eax
  800869:	8b 50 04             	mov    0x4(%eax),%edx
  80086c:	8b 00                	mov    (%eax),%eax
  80086e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800871:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800874:	8b 45 14             	mov    0x14(%ebp),%eax
  800877:	8d 40 08             	lea    0x8(%eax),%eax
  80087a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80087d:	b8 10 00 00 00       	mov    $0x10,%eax
  800882:	e9 6e ff ff ff       	jmp    8007f5 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
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
  8008a5:	e9 4b ff ff ff       	jmp    8007f5 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	83 c0 04             	add    $0x4,%eax
  8008b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	8b 00                	mov    (%eax),%eax
  8008b8:	85 c0                	test   %eax,%eax
  8008ba:	74 14                	je     8008d0 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8008bc:	8b 13                	mov    (%ebx),%edx
  8008be:	83 fa 7f             	cmp    $0x7f,%edx
  8008c1:	7f 37                	jg     8008fa <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8008c3:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8008c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008cb:	e9 43 ff ff ff       	jmp    800813 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8008d0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008d5:	bf b9 28 80 00       	mov    $0x8028b9,%edi
							putch(ch, putdat);
  8008da:	83 ec 08             	sub    $0x8,%esp
  8008dd:	53                   	push   %ebx
  8008de:	50                   	push   %eax
  8008df:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008e1:	83 c7 01             	add    $0x1,%edi
  8008e4:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008e8:	83 c4 10             	add    $0x10,%esp
  8008eb:	85 c0                	test   %eax,%eax
  8008ed:	75 eb                	jne    8008da <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008ef:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f5:	e9 19 ff ff ff       	jmp    800813 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008fa:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008fc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800901:	bf f1 28 80 00       	mov    $0x8028f1,%edi
							putch(ch, putdat);
  800906:	83 ec 08             	sub    $0x8,%esp
  800909:	53                   	push   %ebx
  80090a:	50                   	push   %eax
  80090b:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80090d:	83 c7 01             	add    $0x1,%edi
  800910:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800914:	83 c4 10             	add    $0x10,%esp
  800917:	85 c0                	test   %eax,%eax
  800919:	75 eb                	jne    800906 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80091b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80091e:	89 45 14             	mov    %eax,0x14(%ebp)
  800921:	e9 ed fe ff ff       	jmp    800813 <vprintfmt+0x446>
			putch(ch, putdat);
  800926:	83 ec 08             	sub    $0x8,%esp
  800929:	53                   	push   %ebx
  80092a:	6a 25                	push   $0x25
  80092c:	ff d6                	call   *%esi
			break;
  80092e:	83 c4 10             	add    $0x10,%esp
  800931:	e9 dd fe ff ff       	jmp    800813 <vprintfmt+0x446>
			putch('%', putdat);
  800936:	83 ec 08             	sub    $0x8,%esp
  800939:	53                   	push   %ebx
  80093a:	6a 25                	push   $0x25
  80093c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80093e:	83 c4 10             	add    $0x10,%esp
  800941:	89 f8                	mov    %edi,%eax
  800943:	eb 03                	jmp    800948 <vprintfmt+0x57b>
  800945:	83 e8 01             	sub    $0x1,%eax
  800948:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80094c:	75 f7                	jne    800945 <vprintfmt+0x578>
  80094e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800951:	e9 bd fe ff ff       	jmp    800813 <vprintfmt+0x446>
}
  800956:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800959:	5b                   	pop    %ebx
  80095a:	5e                   	pop    %esi
  80095b:	5f                   	pop    %edi
  80095c:	5d                   	pop    %ebp
  80095d:	c3                   	ret    

0080095e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80095e:	55                   	push   %ebp
  80095f:	89 e5                	mov    %esp,%ebp
  800961:	83 ec 18             	sub    $0x18,%esp
  800964:	8b 45 08             	mov    0x8(%ebp),%eax
  800967:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80096a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80096d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800971:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800974:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80097b:	85 c0                	test   %eax,%eax
  80097d:	74 26                	je     8009a5 <vsnprintf+0x47>
  80097f:	85 d2                	test   %edx,%edx
  800981:	7e 22                	jle    8009a5 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800983:	ff 75 14             	pushl  0x14(%ebp)
  800986:	ff 75 10             	pushl  0x10(%ebp)
  800989:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80098c:	50                   	push   %eax
  80098d:	68 93 03 80 00       	push   $0x800393
  800992:	e8 36 fa ff ff       	call   8003cd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800997:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80099a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80099d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009a0:	83 c4 10             	add    $0x10,%esp
}
  8009a3:	c9                   	leave  
  8009a4:	c3                   	ret    
		return -E_INVAL;
  8009a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009aa:	eb f7                	jmp    8009a3 <vsnprintf+0x45>

008009ac <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009ac:	55                   	push   %ebp
  8009ad:	89 e5                	mov    %esp,%ebp
  8009af:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009b2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009b5:	50                   	push   %eax
  8009b6:	ff 75 10             	pushl  0x10(%ebp)
  8009b9:	ff 75 0c             	pushl  0xc(%ebp)
  8009bc:	ff 75 08             	pushl  0x8(%ebp)
  8009bf:	e8 9a ff ff ff       	call   80095e <vsnprintf>
	va_end(ap);

	return rc;
}
  8009c4:	c9                   	leave  
  8009c5:	c3                   	ret    

008009c6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009c6:	55                   	push   %ebp
  8009c7:	89 e5                	mov    %esp,%ebp
  8009c9:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009d5:	74 05                	je     8009dc <strlen+0x16>
		n++;
  8009d7:	83 c0 01             	add    $0x1,%eax
  8009da:	eb f5                	jmp    8009d1 <strlen+0xb>
	return n;
}
  8009dc:	5d                   	pop    %ebp
  8009dd:	c3                   	ret    

008009de <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009de:	55                   	push   %ebp
  8009df:	89 e5                	mov    %esp,%ebp
  8009e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009e4:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ec:	39 c2                	cmp    %eax,%edx
  8009ee:	74 0d                	je     8009fd <strnlen+0x1f>
  8009f0:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009f4:	74 05                	je     8009fb <strnlen+0x1d>
		n++;
  8009f6:	83 c2 01             	add    $0x1,%edx
  8009f9:	eb f1                	jmp    8009ec <strnlen+0xe>
  8009fb:	89 d0                	mov    %edx,%eax
	return n;
}
  8009fd:	5d                   	pop    %ebp
  8009fe:	c3                   	ret    

008009ff <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	53                   	push   %ebx
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a09:	ba 00 00 00 00       	mov    $0x0,%edx
  800a0e:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a12:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a15:	83 c2 01             	add    $0x1,%edx
  800a18:	84 c9                	test   %cl,%cl
  800a1a:	75 f2                	jne    800a0e <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a1c:	5b                   	pop    %ebx
  800a1d:	5d                   	pop    %ebp
  800a1e:	c3                   	ret    

00800a1f <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
  800a22:	53                   	push   %ebx
  800a23:	83 ec 10             	sub    $0x10,%esp
  800a26:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a29:	53                   	push   %ebx
  800a2a:	e8 97 ff ff ff       	call   8009c6 <strlen>
  800a2f:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a32:	ff 75 0c             	pushl  0xc(%ebp)
  800a35:	01 d8                	add    %ebx,%eax
  800a37:	50                   	push   %eax
  800a38:	e8 c2 ff ff ff       	call   8009ff <strcpy>
	return dst;
}
  800a3d:	89 d8                	mov    %ebx,%eax
  800a3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a42:	c9                   	leave  
  800a43:	c3                   	ret    

00800a44 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	56                   	push   %esi
  800a48:	53                   	push   %ebx
  800a49:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a4f:	89 c6                	mov    %eax,%esi
  800a51:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a54:	89 c2                	mov    %eax,%edx
  800a56:	39 f2                	cmp    %esi,%edx
  800a58:	74 11                	je     800a6b <strncpy+0x27>
		*dst++ = *src;
  800a5a:	83 c2 01             	add    $0x1,%edx
  800a5d:	0f b6 19             	movzbl (%ecx),%ebx
  800a60:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a63:	80 fb 01             	cmp    $0x1,%bl
  800a66:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a69:	eb eb                	jmp    800a56 <strncpy+0x12>
	}
	return ret;
}
  800a6b:	5b                   	pop    %ebx
  800a6c:	5e                   	pop    %esi
  800a6d:	5d                   	pop    %ebp
  800a6e:	c3                   	ret    

00800a6f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	56                   	push   %esi
  800a73:	53                   	push   %ebx
  800a74:	8b 75 08             	mov    0x8(%ebp),%esi
  800a77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a7a:	8b 55 10             	mov    0x10(%ebp),%edx
  800a7d:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a7f:	85 d2                	test   %edx,%edx
  800a81:	74 21                	je     800aa4 <strlcpy+0x35>
  800a83:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a87:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a89:	39 c2                	cmp    %eax,%edx
  800a8b:	74 14                	je     800aa1 <strlcpy+0x32>
  800a8d:	0f b6 19             	movzbl (%ecx),%ebx
  800a90:	84 db                	test   %bl,%bl
  800a92:	74 0b                	je     800a9f <strlcpy+0x30>
			*dst++ = *src++;
  800a94:	83 c1 01             	add    $0x1,%ecx
  800a97:	83 c2 01             	add    $0x1,%edx
  800a9a:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a9d:	eb ea                	jmp    800a89 <strlcpy+0x1a>
  800a9f:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800aa1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800aa4:	29 f0                	sub    %esi,%eax
}
  800aa6:	5b                   	pop    %ebx
  800aa7:	5e                   	pop    %esi
  800aa8:	5d                   	pop    %ebp
  800aa9:	c3                   	ret    

00800aaa <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800aaa:	55                   	push   %ebp
  800aab:	89 e5                	mov    %esp,%ebp
  800aad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ab0:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ab3:	0f b6 01             	movzbl (%ecx),%eax
  800ab6:	84 c0                	test   %al,%al
  800ab8:	74 0c                	je     800ac6 <strcmp+0x1c>
  800aba:	3a 02                	cmp    (%edx),%al
  800abc:	75 08                	jne    800ac6 <strcmp+0x1c>
		p++, q++;
  800abe:	83 c1 01             	add    $0x1,%ecx
  800ac1:	83 c2 01             	add    $0x1,%edx
  800ac4:	eb ed                	jmp    800ab3 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ac6:	0f b6 c0             	movzbl %al,%eax
  800ac9:	0f b6 12             	movzbl (%edx),%edx
  800acc:	29 d0                	sub    %edx,%eax
}
  800ace:	5d                   	pop    %ebp
  800acf:	c3                   	ret    

00800ad0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ad0:	55                   	push   %ebp
  800ad1:	89 e5                	mov    %esp,%ebp
  800ad3:	53                   	push   %ebx
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ada:	89 c3                	mov    %eax,%ebx
  800adc:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800adf:	eb 06                	jmp    800ae7 <strncmp+0x17>
		n--, p++, q++;
  800ae1:	83 c0 01             	add    $0x1,%eax
  800ae4:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ae7:	39 d8                	cmp    %ebx,%eax
  800ae9:	74 16                	je     800b01 <strncmp+0x31>
  800aeb:	0f b6 08             	movzbl (%eax),%ecx
  800aee:	84 c9                	test   %cl,%cl
  800af0:	74 04                	je     800af6 <strncmp+0x26>
  800af2:	3a 0a                	cmp    (%edx),%cl
  800af4:	74 eb                	je     800ae1 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800af6:	0f b6 00             	movzbl (%eax),%eax
  800af9:	0f b6 12             	movzbl (%edx),%edx
  800afc:	29 d0                	sub    %edx,%eax
}
  800afe:	5b                   	pop    %ebx
  800aff:	5d                   	pop    %ebp
  800b00:	c3                   	ret    
		return 0;
  800b01:	b8 00 00 00 00       	mov    $0x0,%eax
  800b06:	eb f6                	jmp    800afe <strncmp+0x2e>

00800b08 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b12:	0f b6 10             	movzbl (%eax),%edx
  800b15:	84 d2                	test   %dl,%dl
  800b17:	74 09                	je     800b22 <strchr+0x1a>
		if (*s == c)
  800b19:	38 ca                	cmp    %cl,%dl
  800b1b:	74 0a                	je     800b27 <strchr+0x1f>
	for (; *s; s++)
  800b1d:	83 c0 01             	add    $0x1,%eax
  800b20:	eb f0                	jmp    800b12 <strchr+0xa>
			return (char *) s;
	return 0;
  800b22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b27:	5d                   	pop    %ebp
  800b28:	c3                   	ret    

00800b29 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b29:	55                   	push   %ebp
  800b2a:	89 e5                	mov    %esp,%ebp
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b33:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b36:	38 ca                	cmp    %cl,%dl
  800b38:	74 09                	je     800b43 <strfind+0x1a>
  800b3a:	84 d2                	test   %dl,%dl
  800b3c:	74 05                	je     800b43 <strfind+0x1a>
	for (; *s; s++)
  800b3e:	83 c0 01             	add    $0x1,%eax
  800b41:	eb f0                	jmp    800b33 <strfind+0xa>
			break;
	return (char *) s;
}
  800b43:	5d                   	pop    %ebp
  800b44:	c3                   	ret    

00800b45 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	57                   	push   %edi
  800b49:	56                   	push   %esi
  800b4a:	53                   	push   %ebx
  800b4b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b51:	85 c9                	test   %ecx,%ecx
  800b53:	74 31                	je     800b86 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b55:	89 f8                	mov    %edi,%eax
  800b57:	09 c8                	or     %ecx,%eax
  800b59:	a8 03                	test   $0x3,%al
  800b5b:	75 23                	jne    800b80 <memset+0x3b>
		c &= 0xFF;
  800b5d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b61:	89 d3                	mov    %edx,%ebx
  800b63:	c1 e3 08             	shl    $0x8,%ebx
  800b66:	89 d0                	mov    %edx,%eax
  800b68:	c1 e0 18             	shl    $0x18,%eax
  800b6b:	89 d6                	mov    %edx,%esi
  800b6d:	c1 e6 10             	shl    $0x10,%esi
  800b70:	09 f0                	or     %esi,%eax
  800b72:	09 c2                	or     %eax,%edx
  800b74:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b76:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b79:	89 d0                	mov    %edx,%eax
  800b7b:	fc                   	cld    
  800b7c:	f3 ab                	rep stos %eax,%es:(%edi)
  800b7e:	eb 06                	jmp    800b86 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b83:	fc                   	cld    
  800b84:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b86:	89 f8                	mov    %edi,%eax
  800b88:	5b                   	pop    %ebx
  800b89:	5e                   	pop    %esi
  800b8a:	5f                   	pop    %edi
  800b8b:	5d                   	pop    %ebp
  800b8c:	c3                   	ret    

00800b8d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b8d:	55                   	push   %ebp
  800b8e:	89 e5                	mov    %esp,%ebp
  800b90:	57                   	push   %edi
  800b91:	56                   	push   %esi
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b98:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b9b:	39 c6                	cmp    %eax,%esi
  800b9d:	73 32                	jae    800bd1 <memmove+0x44>
  800b9f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ba2:	39 c2                	cmp    %eax,%edx
  800ba4:	76 2b                	jbe    800bd1 <memmove+0x44>
		s += n;
		d += n;
  800ba6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ba9:	89 fe                	mov    %edi,%esi
  800bab:	09 ce                	or     %ecx,%esi
  800bad:	09 d6                	or     %edx,%esi
  800baf:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bb5:	75 0e                	jne    800bc5 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bb7:	83 ef 04             	sub    $0x4,%edi
  800bba:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bbd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bc0:	fd                   	std    
  800bc1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bc3:	eb 09                	jmp    800bce <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bc5:	83 ef 01             	sub    $0x1,%edi
  800bc8:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bcb:	fd                   	std    
  800bcc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bce:	fc                   	cld    
  800bcf:	eb 1a                	jmp    800beb <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bd1:	89 c2                	mov    %eax,%edx
  800bd3:	09 ca                	or     %ecx,%edx
  800bd5:	09 f2                	or     %esi,%edx
  800bd7:	f6 c2 03             	test   $0x3,%dl
  800bda:	75 0a                	jne    800be6 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bdc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bdf:	89 c7                	mov    %eax,%edi
  800be1:	fc                   	cld    
  800be2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800be4:	eb 05                	jmp    800beb <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800be6:	89 c7                	mov    %eax,%edi
  800be8:	fc                   	cld    
  800be9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800beb:	5e                   	pop    %esi
  800bec:	5f                   	pop    %edi
  800bed:	5d                   	pop    %ebp
  800bee:	c3                   	ret    

00800bef <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bef:	55                   	push   %ebp
  800bf0:	89 e5                	mov    %esp,%ebp
  800bf2:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bf5:	ff 75 10             	pushl  0x10(%ebp)
  800bf8:	ff 75 0c             	pushl  0xc(%ebp)
  800bfb:	ff 75 08             	pushl  0x8(%ebp)
  800bfe:	e8 8a ff ff ff       	call   800b8d <memmove>
}
  800c03:	c9                   	leave  
  800c04:	c3                   	ret    

00800c05 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	56                   	push   %esi
  800c09:	53                   	push   %ebx
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c10:	89 c6                	mov    %eax,%esi
  800c12:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c15:	39 f0                	cmp    %esi,%eax
  800c17:	74 1c                	je     800c35 <memcmp+0x30>
		if (*s1 != *s2)
  800c19:	0f b6 08             	movzbl (%eax),%ecx
  800c1c:	0f b6 1a             	movzbl (%edx),%ebx
  800c1f:	38 d9                	cmp    %bl,%cl
  800c21:	75 08                	jne    800c2b <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c23:	83 c0 01             	add    $0x1,%eax
  800c26:	83 c2 01             	add    $0x1,%edx
  800c29:	eb ea                	jmp    800c15 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c2b:	0f b6 c1             	movzbl %cl,%eax
  800c2e:	0f b6 db             	movzbl %bl,%ebx
  800c31:	29 d8                	sub    %ebx,%eax
  800c33:	eb 05                	jmp    800c3a <memcmp+0x35>
	}

	return 0;
  800c35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c3a:	5b                   	pop    %ebx
  800c3b:	5e                   	pop    %esi
  800c3c:	5d                   	pop    %ebp
  800c3d:	c3                   	ret    

00800c3e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c3e:	55                   	push   %ebp
  800c3f:	89 e5                	mov    %esp,%ebp
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c47:	89 c2                	mov    %eax,%edx
  800c49:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c4c:	39 d0                	cmp    %edx,%eax
  800c4e:	73 09                	jae    800c59 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c50:	38 08                	cmp    %cl,(%eax)
  800c52:	74 05                	je     800c59 <memfind+0x1b>
	for (; s < ends; s++)
  800c54:	83 c0 01             	add    $0x1,%eax
  800c57:	eb f3                	jmp    800c4c <memfind+0xe>
			break;
	return (void *) s;
}
  800c59:	5d                   	pop    %ebp
  800c5a:	c3                   	ret    

00800c5b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	57                   	push   %edi
  800c5f:	56                   	push   %esi
  800c60:	53                   	push   %ebx
  800c61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c64:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c67:	eb 03                	jmp    800c6c <strtol+0x11>
		s++;
  800c69:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c6c:	0f b6 01             	movzbl (%ecx),%eax
  800c6f:	3c 20                	cmp    $0x20,%al
  800c71:	74 f6                	je     800c69 <strtol+0xe>
  800c73:	3c 09                	cmp    $0x9,%al
  800c75:	74 f2                	je     800c69 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c77:	3c 2b                	cmp    $0x2b,%al
  800c79:	74 2a                	je     800ca5 <strtol+0x4a>
	int neg = 0;
  800c7b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c80:	3c 2d                	cmp    $0x2d,%al
  800c82:	74 2b                	je     800caf <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c84:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c8a:	75 0f                	jne    800c9b <strtol+0x40>
  800c8c:	80 39 30             	cmpb   $0x30,(%ecx)
  800c8f:	74 28                	je     800cb9 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c91:	85 db                	test   %ebx,%ebx
  800c93:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c98:	0f 44 d8             	cmove  %eax,%ebx
  800c9b:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ca3:	eb 50                	jmp    800cf5 <strtol+0x9a>
		s++;
  800ca5:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ca8:	bf 00 00 00 00       	mov    $0x0,%edi
  800cad:	eb d5                	jmp    800c84 <strtol+0x29>
		s++, neg = 1;
  800caf:	83 c1 01             	add    $0x1,%ecx
  800cb2:	bf 01 00 00 00       	mov    $0x1,%edi
  800cb7:	eb cb                	jmp    800c84 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cb9:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cbd:	74 0e                	je     800ccd <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800cbf:	85 db                	test   %ebx,%ebx
  800cc1:	75 d8                	jne    800c9b <strtol+0x40>
		s++, base = 8;
  800cc3:	83 c1 01             	add    $0x1,%ecx
  800cc6:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ccb:	eb ce                	jmp    800c9b <strtol+0x40>
		s += 2, base = 16;
  800ccd:	83 c1 02             	add    $0x2,%ecx
  800cd0:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cd5:	eb c4                	jmp    800c9b <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cd7:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cda:	89 f3                	mov    %esi,%ebx
  800cdc:	80 fb 19             	cmp    $0x19,%bl
  800cdf:	77 29                	ja     800d0a <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ce1:	0f be d2             	movsbl %dl,%edx
  800ce4:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ce7:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cea:	7d 30                	jge    800d1c <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cec:	83 c1 01             	add    $0x1,%ecx
  800cef:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cf3:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cf5:	0f b6 11             	movzbl (%ecx),%edx
  800cf8:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cfb:	89 f3                	mov    %esi,%ebx
  800cfd:	80 fb 09             	cmp    $0x9,%bl
  800d00:	77 d5                	ja     800cd7 <strtol+0x7c>
			dig = *s - '0';
  800d02:	0f be d2             	movsbl %dl,%edx
  800d05:	83 ea 30             	sub    $0x30,%edx
  800d08:	eb dd                	jmp    800ce7 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d0a:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d0d:	89 f3                	mov    %esi,%ebx
  800d0f:	80 fb 19             	cmp    $0x19,%bl
  800d12:	77 08                	ja     800d1c <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d14:	0f be d2             	movsbl %dl,%edx
  800d17:	83 ea 37             	sub    $0x37,%edx
  800d1a:	eb cb                	jmp    800ce7 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d1c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d20:	74 05                	je     800d27 <strtol+0xcc>
		*endptr = (char *) s;
  800d22:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d25:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d27:	89 c2                	mov    %eax,%edx
  800d29:	f7 da                	neg    %edx
  800d2b:	85 ff                	test   %edi,%edi
  800d2d:	0f 45 c2             	cmovne %edx,%eax
}
  800d30:	5b                   	pop    %ebx
  800d31:	5e                   	pop    %esi
  800d32:	5f                   	pop    %edi
  800d33:	5d                   	pop    %ebp
  800d34:	c3                   	ret    

00800d35 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	57                   	push   %edi
  800d39:	56                   	push   %esi
  800d3a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d40:	8b 55 08             	mov    0x8(%ebp),%edx
  800d43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d46:	89 c3                	mov    %eax,%ebx
  800d48:	89 c7                	mov    %eax,%edi
  800d4a:	89 c6                	mov    %eax,%esi
  800d4c:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d4e:	5b                   	pop    %ebx
  800d4f:	5e                   	pop    %esi
  800d50:	5f                   	pop    %edi
  800d51:	5d                   	pop    %ebp
  800d52:	c3                   	ret    

00800d53 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	57                   	push   %edi
  800d57:	56                   	push   %esi
  800d58:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d59:	ba 00 00 00 00       	mov    $0x0,%edx
  800d5e:	b8 01 00 00 00       	mov    $0x1,%eax
  800d63:	89 d1                	mov    %edx,%ecx
  800d65:	89 d3                	mov    %edx,%ebx
  800d67:	89 d7                	mov    %edx,%edi
  800d69:	89 d6                	mov    %edx,%esi
  800d6b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d6d:	5b                   	pop    %ebx
  800d6e:	5e                   	pop    %esi
  800d6f:	5f                   	pop    %edi
  800d70:	5d                   	pop    %ebp
  800d71:	c3                   	ret    

00800d72 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d72:	55                   	push   %ebp
  800d73:	89 e5                	mov    %esp,%ebp
  800d75:	57                   	push   %edi
  800d76:	56                   	push   %esi
  800d77:	53                   	push   %ebx
  800d78:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d80:	8b 55 08             	mov    0x8(%ebp),%edx
  800d83:	b8 03 00 00 00       	mov    $0x3,%eax
  800d88:	89 cb                	mov    %ecx,%ebx
  800d8a:	89 cf                	mov    %ecx,%edi
  800d8c:	89 ce                	mov    %ecx,%esi
  800d8e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d90:	85 c0                	test   %eax,%eax
  800d92:	7f 08                	jg     800d9c <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d97:	5b                   	pop    %ebx
  800d98:	5e                   	pop    %esi
  800d99:	5f                   	pop    %edi
  800d9a:	5d                   	pop    %ebp
  800d9b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9c:	83 ec 0c             	sub    $0xc,%esp
  800d9f:	50                   	push   %eax
  800da0:	6a 03                	push   $0x3
  800da2:	68 08 2b 80 00       	push   $0x802b08
  800da7:	6a 43                	push   $0x43
  800da9:	68 25 2b 80 00       	push   $0x802b25
  800dae:	e8 f7 f3 ff ff       	call   8001aa <_panic>

00800db3 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	57                   	push   %edi
  800db7:	56                   	push   %esi
  800db8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db9:	ba 00 00 00 00       	mov    $0x0,%edx
  800dbe:	b8 02 00 00 00       	mov    $0x2,%eax
  800dc3:	89 d1                	mov    %edx,%ecx
  800dc5:	89 d3                	mov    %edx,%ebx
  800dc7:	89 d7                	mov    %edx,%edi
  800dc9:	89 d6                	mov    %edx,%esi
  800dcb:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dcd:	5b                   	pop    %ebx
  800dce:	5e                   	pop    %esi
  800dcf:	5f                   	pop    %edi
  800dd0:	5d                   	pop    %ebp
  800dd1:	c3                   	ret    

00800dd2 <sys_yield>:

void
sys_yield(void)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
  800dd5:	57                   	push   %edi
  800dd6:	56                   	push   %esi
  800dd7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dd8:	ba 00 00 00 00       	mov    $0x0,%edx
  800ddd:	b8 0b 00 00 00       	mov    $0xb,%eax
  800de2:	89 d1                	mov    %edx,%ecx
  800de4:	89 d3                	mov    %edx,%ebx
  800de6:	89 d7                	mov    %edx,%edi
  800de8:	89 d6                	mov    %edx,%esi
  800dea:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dec:	5b                   	pop    %ebx
  800ded:	5e                   	pop    %esi
  800dee:	5f                   	pop    %edi
  800def:	5d                   	pop    %ebp
  800df0:	c3                   	ret    

00800df1 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
  800df4:	57                   	push   %edi
  800df5:	56                   	push   %esi
  800df6:	53                   	push   %ebx
  800df7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dfa:	be 00 00 00 00       	mov    $0x0,%esi
  800dff:	8b 55 08             	mov    0x8(%ebp),%edx
  800e02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e05:	b8 04 00 00 00       	mov    $0x4,%eax
  800e0a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e0d:	89 f7                	mov    %esi,%edi
  800e0f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e11:	85 c0                	test   %eax,%eax
  800e13:	7f 08                	jg     800e1d <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e18:	5b                   	pop    %ebx
  800e19:	5e                   	pop    %esi
  800e1a:	5f                   	pop    %edi
  800e1b:	5d                   	pop    %ebp
  800e1c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1d:	83 ec 0c             	sub    $0xc,%esp
  800e20:	50                   	push   %eax
  800e21:	6a 04                	push   $0x4
  800e23:	68 08 2b 80 00       	push   $0x802b08
  800e28:	6a 43                	push   $0x43
  800e2a:	68 25 2b 80 00       	push   $0x802b25
  800e2f:	e8 76 f3 ff ff       	call   8001aa <_panic>

00800e34 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
  800e37:	57                   	push   %edi
  800e38:	56                   	push   %esi
  800e39:	53                   	push   %ebx
  800e3a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e43:	b8 05 00 00 00       	mov    $0x5,%eax
  800e48:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e4b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e4e:	8b 75 18             	mov    0x18(%ebp),%esi
  800e51:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e53:	85 c0                	test   %eax,%eax
  800e55:	7f 08                	jg     800e5f <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5a:	5b                   	pop    %ebx
  800e5b:	5e                   	pop    %esi
  800e5c:	5f                   	pop    %edi
  800e5d:	5d                   	pop    %ebp
  800e5e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5f:	83 ec 0c             	sub    $0xc,%esp
  800e62:	50                   	push   %eax
  800e63:	6a 05                	push   $0x5
  800e65:	68 08 2b 80 00       	push   $0x802b08
  800e6a:	6a 43                	push   $0x43
  800e6c:	68 25 2b 80 00       	push   $0x802b25
  800e71:	e8 34 f3 ff ff       	call   8001aa <_panic>

00800e76 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	57                   	push   %edi
  800e7a:	56                   	push   %esi
  800e7b:	53                   	push   %ebx
  800e7c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e84:	8b 55 08             	mov    0x8(%ebp),%edx
  800e87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8a:	b8 06 00 00 00       	mov    $0x6,%eax
  800e8f:	89 df                	mov    %ebx,%edi
  800e91:	89 de                	mov    %ebx,%esi
  800e93:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e95:	85 c0                	test   %eax,%eax
  800e97:	7f 08                	jg     800ea1 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e99:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9c:	5b                   	pop    %ebx
  800e9d:	5e                   	pop    %esi
  800e9e:	5f                   	pop    %edi
  800e9f:	5d                   	pop    %ebp
  800ea0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea1:	83 ec 0c             	sub    $0xc,%esp
  800ea4:	50                   	push   %eax
  800ea5:	6a 06                	push   $0x6
  800ea7:	68 08 2b 80 00       	push   $0x802b08
  800eac:	6a 43                	push   $0x43
  800eae:	68 25 2b 80 00       	push   $0x802b25
  800eb3:	e8 f2 f2 ff ff       	call   8001aa <_panic>

00800eb8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	57                   	push   %edi
  800ebc:	56                   	push   %esi
  800ebd:	53                   	push   %ebx
  800ebe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ec1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ecc:	b8 08 00 00 00       	mov    $0x8,%eax
  800ed1:	89 df                	mov    %ebx,%edi
  800ed3:	89 de                	mov    %ebx,%esi
  800ed5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed7:	85 c0                	test   %eax,%eax
  800ed9:	7f 08                	jg     800ee3 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800edb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ede:	5b                   	pop    %ebx
  800edf:	5e                   	pop    %esi
  800ee0:	5f                   	pop    %edi
  800ee1:	5d                   	pop    %ebp
  800ee2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee3:	83 ec 0c             	sub    $0xc,%esp
  800ee6:	50                   	push   %eax
  800ee7:	6a 08                	push   $0x8
  800ee9:	68 08 2b 80 00       	push   $0x802b08
  800eee:	6a 43                	push   $0x43
  800ef0:	68 25 2b 80 00       	push   $0x802b25
  800ef5:	e8 b0 f2 ff ff       	call   8001aa <_panic>

00800efa <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	57                   	push   %edi
  800efe:	56                   	push   %esi
  800eff:	53                   	push   %ebx
  800f00:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f03:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f08:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0e:	b8 09 00 00 00       	mov    $0x9,%eax
  800f13:	89 df                	mov    %ebx,%edi
  800f15:	89 de                	mov    %ebx,%esi
  800f17:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f19:	85 c0                	test   %eax,%eax
  800f1b:	7f 08                	jg     800f25 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f20:	5b                   	pop    %ebx
  800f21:	5e                   	pop    %esi
  800f22:	5f                   	pop    %edi
  800f23:	5d                   	pop    %ebp
  800f24:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f25:	83 ec 0c             	sub    $0xc,%esp
  800f28:	50                   	push   %eax
  800f29:	6a 09                	push   $0x9
  800f2b:	68 08 2b 80 00       	push   $0x802b08
  800f30:	6a 43                	push   $0x43
  800f32:	68 25 2b 80 00       	push   $0x802b25
  800f37:	e8 6e f2 ff ff       	call   8001aa <_panic>

00800f3c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f3c:	55                   	push   %ebp
  800f3d:	89 e5                	mov    %esp,%ebp
  800f3f:	57                   	push   %edi
  800f40:	56                   	push   %esi
  800f41:	53                   	push   %ebx
  800f42:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f45:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f50:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f55:	89 df                	mov    %ebx,%edi
  800f57:	89 de                	mov    %ebx,%esi
  800f59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f5b:	85 c0                	test   %eax,%eax
  800f5d:	7f 08                	jg     800f67 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f62:	5b                   	pop    %ebx
  800f63:	5e                   	pop    %esi
  800f64:	5f                   	pop    %edi
  800f65:	5d                   	pop    %ebp
  800f66:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f67:	83 ec 0c             	sub    $0xc,%esp
  800f6a:	50                   	push   %eax
  800f6b:	6a 0a                	push   $0xa
  800f6d:	68 08 2b 80 00       	push   $0x802b08
  800f72:	6a 43                	push   $0x43
  800f74:	68 25 2b 80 00       	push   $0x802b25
  800f79:	e8 2c f2 ff ff       	call   8001aa <_panic>

00800f7e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f7e:	55                   	push   %ebp
  800f7f:	89 e5                	mov    %esp,%ebp
  800f81:	57                   	push   %edi
  800f82:	56                   	push   %esi
  800f83:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f84:	8b 55 08             	mov    0x8(%ebp),%edx
  800f87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8a:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f8f:	be 00 00 00 00       	mov    $0x0,%esi
  800f94:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f97:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f9a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f9c:	5b                   	pop    %ebx
  800f9d:	5e                   	pop    %esi
  800f9e:	5f                   	pop    %edi
  800f9f:	5d                   	pop    %ebp
  800fa0:	c3                   	ret    

00800fa1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	57                   	push   %edi
  800fa5:	56                   	push   %esi
  800fa6:	53                   	push   %ebx
  800fa7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800faa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800faf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb2:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fb7:	89 cb                	mov    %ecx,%ebx
  800fb9:	89 cf                	mov    %ecx,%edi
  800fbb:	89 ce                	mov    %ecx,%esi
  800fbd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fbf:	85 c0                	test   %eax,%eax
  800fc1:	7f 08                	jg     800fcb <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc6:	5b                   	pop    %ebx
  800fc7:	5e                   	pop    %esi
  800fc8:	5f                   	pop    %edi
  800fc9:	5d                   	pop    %ebp
  800fca:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fcb:	83 ec 0c             	sub    $0xc,%esp
  800fce:	50                   	push   %eax
  800fcf:	6a 0d                	push   $0xd
  800fd1:	68 08 2b 80 00       	push   $0x802b08
  800fd6:	6a 43                	push   $0x43
  800fd8:	68 25 2b 80 00       	push   $0x802b25
  800fdd:	e8 c8 f1 ff ff       	call   8001aa <_panic>

00800fe2 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fe2:	55                   	push   %ebp
  800fe3:	89 e5                	mov    %esp,%ebp
  800fe5:	57                   	push   %edi
  800fe6:	56                   	push   %esi
  800fe7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fe8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fed:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff3:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ff8:	89 df                	mov    %ebx,%edi
  800ffa:	89 de                	mov    %ebx,%esi
  800ffc:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ffe:	5b                   	pop    %ebx
  800fff:	5e                   	pop    %esi
  801000:	5f                   	pop    %edi
  801001:	5d                   	pop    %ebp
  801002:	c3                   	ret    

00801003 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801003:	55                   	push   %ebp
  801004:	89 e5                	mov    %esp,%ebp
  801006:	57                   	push   %edi
  801007:	56                   	push   %esi
  801008:	53                   	push   %ebx
	asm volatile("int %1\n"
  801009:	b9 00 00 00 00       	mov    $0x0,%ecx
  80100e:	8b 55 08             	mov    0x8(%ebp),%edx
  801011:	b8 0f 00 00 00       	mov    $0xf,%eax
  801016:	89 cb                	mov    %ecx,%ebx
  801018:	89 cf                	mov    %ecx,%edi
  80101a:	89 ce                	mov    %ecx,%esi
  80101c:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80101e:	5b                   	pop    %ebx
  80101f:	5e                   	pop    %esi
  801020:	5f                   	pop    %edi
  801021:	5d                   	pop    %ebp
  801022:	c3                   	ret    

00801023 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801023:	55                   	push   %ebp
  801024:	89 e5                	mov    %esp,%ebp
  801026:	57                   	push   %edi
  801027:	56                   	push   %esi
  801028:	53                   	push   %ebx
	asm volatile("int %1\n"
  801029:	ba 00 00 00 00       	mov    $0x0,%edx
  80102e:	b8 10 00 00 00       	mov    $0x10,%eax
  801033:	89 d1                	mov    %edx,%ecx
  801035:	89 d3                	mov    %edx,%ebx
  801037:	89 d7                	mov    %edx,%edi
  801039:	89 d6                	mov    %edx,%esi
  80103b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80103d:	5b                   	pop    %ebx
  80103e:	5e                   	pop    %esi
  80103f:	5f                   	pop    %edi
  801040:	5d                   	pop    %ebp
  801041:	c3                   	ret    

00801042 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
  801045:	57                   	push   %edi
  801046:	56                   	push   %esi
  801047:	53                   	push   %ebx
	asm volatile("int %1\n"
  801048:	bb 00 00 00 00       	mov    $0x0,%ebx
  80104d:	8b 55 08             	mov    0x8(%ebp),%edx
  801050:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801053:	b8 11 00 00 00       	mov    $0x11,%eax
  801058:	89 df                	mov    %ebx,%edi
  80105a:	89 de                	mov    %ebx,%esi
  80105c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80105e:	5b                   	pop    %ebx
  80105f:	5e                   	pop    %esi
  801060:	5f                   	pop    %edi
  801061:	5d                   	pop    %ebp
  801062:	c3                   	ret    

00801063 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	57                   	push   %edi
  801067:	56                   	push   %esi
  801068:	53                   	push   %ebx
	asm volatile("int %1\n"
  801069:	bb 00 00 00 00       	mov    $0x0,%ebx
  80106e:	8b 55 08             	mov    0x8(%ebp),%edx
  801071:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801074:	b8 12 00 00 00       	mov    $0x12,%eax
  801079:	89 df                	mov    %ebx,%edi
  80107b:	89 de                	mov    %ebx,%esi
  80107d:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80107f:	5b                   	pop    %ebx
  801080:	5e                   	pop    %esi
  801081:	5f                   	pop    %edi
  801082:	5d                   	pop    %ebp
  801083:	c3                   	ret    

00801084 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801084:	55                   	push   %ebp
  801085:	89 e5                	mov    %esp,%ebp
  801087:	57                   	push   %edi
  801088:	56                   	push   %esi
  801089:	53                   	push   %ebx
  80108a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80108d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801092:	8b 55 08             	mov    0x8(%ebp),%edx
  801095:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801098:	b8 13 00 00 00       	mov    $0x13,%eax
  80109d:	89 df                	mov    %ebx,%edi
  80109f:	89 de                	mov    %ebx,%esi
  8010a1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010a3:	85 c0                	test   %eax,%eax
  8010a5:	7f 08                	jg     8010af <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010aa:	5b                   	pop    %ebx
  8010ab:	5e                   	pop    %esi
  8010ac:	5f                   	pop    %edi
  8010ad:	5d                   	pop    %ebp
  8010ae:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010af:	83 ec 0c             	sub    $0xc,%esp
  8010b2:	50                   	push   %eax
  8010b3:	6a 13                	push   $0x13
  8010b5:	68 08 2b 80 00       	push   $0x802b08
  8010ba:	6a 43                	push   $0x43
  8010bc:	68 25 2b 80 00       	push   $0x802b25
  8010c1:	e8 e4 f0 ff ff       	call   8001aa <_panic>

008010c6 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	57                   	push   %edi
  8010ca:	56                   	push   %esi
  8010cb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d4:	b8 14 00 00 00       	mov    $0x14,%eax
  8010d9:	89 cb                	mov    %ecx,%ebx
  8010db:	89 cf                	mov    %ecx,%edi
  8010dd:	89 ce                	mov    %ecx,%esi
  8010df:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8010e1:	5b                   	pop    %ebx
  8010e2:	5e                   	pop    %esi
  8010e3:	5f                   	pop    %edi
  8010e4:	5d                   	pop    %ebp
  8010e5:	c3                   	ret    

008010e6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	05 00 00 00 30       	add    $0x30000000,%eax
  8010f1:	c1 e8 0c             	shr    $0xc,%eax
}
  8010f4:	5d                   	pop    %ebp
  8010f5:	c3                   	ret    

008010f6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801101:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801106:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80110b:	5d                   	pop    %ebp
  80110c:	c3                   	ret    

0080110d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80110d:	55                   	push   %ebp
  80110e:	89 e5                	mov    %esp,%ebp
  801110:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801115:	89 c2                	mov    %eax,%edx
  801117:	c1 ea 16             	shr    $0x16,%edx
  80111a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801121:	f6 c2 01             	test   $0x1,%dl
  801124:	74 2d                	je     801153 <fd_alloc+0x46>
  801126:	89 c2                	mov    %eax,%edx
  801128:	c1 ea 0c             	shr    $0xc,%edx
  80112b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801132:	f6 c2 01             	test   $0x1,%dl
  801135:	74 1c                	je     801153 <fd_alloc+0x46>
  801137:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80113c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801141:	75 d2                	jne    801115 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80114c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801151:	eb 0a                	jmp    80115d <fd_alloc+0x50>
			*fd_store = fd;
  801153:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801156:	89 01                	mov    %eax,(%ecx)
			return 0;
  801158:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80115d:	5d                   	pop    %ebp
  80115e:	c3                   	ret    

0080115f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80115f:	55                   	push   %ebp
  801160:	89 e5                	mov    %esp,%ebp
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801165:	83 f8 1f             	cmp    $0x1f,%eax
  801168:	77 30                	ja     80119a <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80116a:	c1 e0 0c             	shl    $0xc,%eax
  80116d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801172:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801178:	f6 c2 01             	test   $0x1,%dl
  80117b:	74 24                	je     8011a1 <fd_lookup+0x42>
  80117d:	89 c2                	mov    %eax,%edx
  80117f:	c1 ea 0c             	shr    $0xc,%edx
  801182:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801189:	f6 c2 01             	test   $0x1,%dl
  80118c:	74 1a                	je     8011a8 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80118e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801191:	89 02                	mov    %eax,(%edx)
	return 0;
  801193:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801198:	5d                   	pop    %ebp
  801199:	c3                   	ret    
		return -E_INVAL;
  80119a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80119f:	eb f7                	jmp    801198 <fd_lookup+0x39>
		return -E_INVAL;
  8011a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011a6:	eb f0                	jmp    801198 <fd_lookup+0x39>
  8011a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ad:	eb e9                	jmp    801198 <fd_lookup+0x39>

008011af <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011af:	55                   	push   %ebp
  8011b0:	89 e5                	mov    %esp,%ebp
  8011b2:	83 ec 08             	sub    $0x8,%esp
  8011b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8011b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8011bd:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011c2:	39 08                	cmp    %ecx,(%eax)
  8011c4:	74 38                	je     8011fe <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8011c6:	83 c2 01             	add    $0x1,%edx
  8011c9:	8b 04 95 b4 2b 80 00 	mov    0x802bb4(,%edx,4),%eax
  8011d0:	85 c0                	test   %eax,%eax
  8011d2:	75 ee                	jne    8011c2 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011d4:	a1 20 60 80 00       	mov    0x806020,%eax
  8011d9:	8b 40 48             	mov    0x48(%eax),%eax
  8011dc:	83 ec 04             	sub    $0x4,%esp
  8011df:	51                   	push   %ecx
  8011e0:	50                   	push   %eax
  8011e1:	68 34 2b 80 00       	push   $0x802b34
  8011e6:	e8 b5 f0 ff ff       	call   8002a0 <cprintf>
	*dev = 0;
  8011eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011f4:	83 c4 10             	add    $0x10,%esp
  8011f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011fc:	c9                   	leave  
  8011fd:	c3                   	ret    
			*dev = devtab[i];
  8011fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801201:	89 01                	mov    %eax,(%ecx)
			return 0;
  801203:	b8 00 00 00 00       	mov    $0x0,%eax
  801208:	eb f2                	jmp    8011fc <dev_lookup+0x4d>

0080120a <fd_close>:
{
  80120a:	55                   	push   %ebp
  80120b:	89 e5                	mov    %esp,%ebp
  80120d:	57                   	push   %edi
  80120e:	56                   	push   %esi
  80120f:	53                   	push   %ebx
  801210:	83 ec 24             	sub    $0x24,%esp
  801213:	8b 75 08             	mov    0x8(%ebp),%esi
  801216:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801219:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80121c:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80121d:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801223:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801226:	50                   	push   %eax
  801227:	e8 33 ff ff ff       	call   80115f <fd_lookup>
  80122c:	89 c3                	mov    %eax,%ebx
  80122e:	83 c4 10             	add    $0x10,%esp
  801231:	85 c0                	test   %eax,%eax
  801233:	78 05                	js     80123a <fd_close+0x30>
	    || fd != fd2)
  801235:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801238:	74 16                	je     801250 <fd_close+0x46>
		return (must_exist ? r : 0);
  80123a:	89 f8                	mov    %edi,%eax
  80123c:	84 c0                	test   %al,%al
  80123e:	b8 00 00 00 00       	mov    $0x0,%eax
  801243:	0f 44 d8             	cmove  %eax,%ebx
}
  801246:	89 d8                	mov    %ebx,%eax
  801248:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80124b:	5b                   	pop    %ebx
  80124c:	5e                   	pop    %esi
  80124d:	5f                   	pop    %edi
  80124e:	5d                   	pop    %ebp
  80124f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801250:	83 ec 08             	sub    $0x8,%esp
  801253:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801256:	50                   	push   %eax
  801257:	ff 36                	pushl  (%esi)
  801259:	e8 51 ff ff ff       	call   8011af <dev_lookup>
  80125e:	89 c3                	mov    %eax,%ebx
  801260:	83 c4 10             	add    $0x10,%esp
  801263:	85 c0                	test   %eax,%eax
  801265:	78 1a                	js     801281 <fd_close+0x77>
		if (dev->dev_close)
  801267:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80126a:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80126d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801272:	85 c0                	test   %eax,%eax
  801274:	74 0b                	je     801281 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801276:	83 ec 0c             	sub    $0xc,%esp
  801279:	56                   	push   %esi
  80127a:	ff d0                	call   *%eax
  80127c:	89 c3                	mov    %eax,%ebx
  80127e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801281:	83 ec 08             	sub    $0x8,%esp
  801284:	56                   	push   %esi
  801285:	6a 00                	push   $0x0
  801287:	e8 ea fb ff ff       	call   800e76 <sys_page_unmap>
	return r;
  80128c:	83 c4 10             	add    $0x10,%esp
  80128f:	eb b5                	jmp    801246 <fd_close+0x3c>

00801291 <close>:

int
close(int fdnum)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
  801294:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801297:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80129a:	50                   	push   %eax
  80129b:	ff 75 08             	pushl  0x8(%ebp)
  80129e:	e8 bc fe ff ff       	call   80115f <fd_lookup>
  8012a3:	83 c4 10             	add    $0x10,%esp
  8012a6:	85 c0                	test   %eax,%eax
  8012a8:	79 02                	jns    8012ac <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8012aa:	c9                   	leave  
  8012ab:	c3                   	ret    
		return fd_close(fd, 1);
  8012ac:	83 ec 08             	sub    $0x8,%esp
  8012af:	6a 01                	push   $0x1
  8012b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b4:	e8 51 ff ff ff       	call   80120a <fd_close>
  8012b9:	83 c4 10             	add    $0x10,%esp
  8012bc:	eb ec                	jmp    8012aa <close+0x19>

008012be <close_all>:

void
close_all(void)
{
  8012be:	55                   	push   %ebp
  8012bf:	89 e5                	mov    %esp,%ebp
  8012c1:	53                   	push   %ebx
  8012c2:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012c5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012ca:	83 ec 0c             	sub    $0xc,%esp
  8012cd:	53                   	push   %ebx
  8012ce:	e8 be ff ff ff       	call   801291 <close>
	for (i = 0; i < MAXFD; i++)
  8012d3:	83 c3 01             	add    $0x1,%ebx
  8012d6:	83 c4 10             	add    $0x10,%esp
  8012d9:	83 fb 20             	cmp    $0x20,%ebx
  8012dc:	75 ec                	jne    8012ca <close_all+0xc>
}
  8012de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012e1:	c9                   	leave  
  8012e2:	c3                   	ret    

008012e3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
  8012e6:	57                   	push   %edi
  8012e7:	56                   	push   %esi
  8012e8:	53                   	push   %ebx
  8012e9:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012ec:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012ef:	50                   	push   %eax
  8012f0:	ff 75 08             	pushl  0x8(%ebp)
  8012f3:	e8 67 fe ff ff       	call   80115f <fd_lookup>
  8012f8:	89 c3                	mov    %eax,%ebx
  8012fa:	83 c4 10             	add    $0x10,%esp
  8012fd:	85 c0                	test   %eax,%eax
  8012ff:	0f 88 81 00 00 00    	js     801386 <dup+0xa3>
		return r;
	close(newfdnum);
  801305:	83 ec 0c             	sub    $0xc,%esp
  801308:	ff 75 0c             	pushl  0xc(%ebp)
  80130b:	e8 81 ff ff ff       	call   801291 <close>

	newfd = INDEX2FD(newfdnum);
  801310:	8b 75 0c             	mov    0xc(%ebp),%esi
  801313:	c1 e6 0c             	shl    $0xc,%esi
  801316:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80131c:	83 c4 04             	add    $0x4,%esp
  80131f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801322:	e8 cf fd ff ff       	call   8010f6 <fd2data>
  801327:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801329:	89 34 24             	mov    %esi,(%esp)
  80132c:	e8 c5 fd ff ff       	call   8010f6 <fd2data>
  801331:	83 c4 10             	add    $0x10,%esp
  801334:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801336:	89 d8                	mov    %ebx,%eax
  801338:	c1 e8 16             	shr    $0x16,%eax
  80133b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801342:	a8 01                	test   $0x1,%al
  801344:	74 11                	je     801357 <dup+0x74>
  801346:	89 d8                	mov    %ebx,%eax
  801348:	c1 e8 0c             	shr    $0xc,%eax
  80134b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801352:	f6 c2 01             	test   $0x1,%dl
  801355:	75 39                	jne    801390 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801357:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80135a:	89 d0                	mov    %edx,%eax
  80135c:	c1 e8 0c             	shr    $0xc,%eax
  80135f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801366:	83 ec 0c             	sub    $0xc,%esp
  801369:	25 07 0e 00 00       	and    $0xe07,%eax
  80136e:	50                   	push   %eax
  80136f:	56                   	push   %esi
  801370:	6a 00                	push   $0x0
  801372:	52                   	push   %edx
  801373:	6a 00                	push   $0x0
  801375:	e8 ba fa ff ff       	call   800e34 <sys_page_map>
  80137a:	89 c3                	mov    %eax,%ebx
  80137c:	83 c4 20             	add    $0x20,%esp
  80137f:	85 c0                	test   %eax,%eax
  801381:	78 31                	js     8013b4 <dup+0xd1>
		goto err;

	return newfdnum;
  801383:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801386:	89 d8                	mov    %ebx,%eax
  801388:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80138b:	5b                   	pop    %ebx
  80138c:	5e                   	pop    %esi
  80138d:	5f                   	pop    %edi
  80138e:	5d                   	pop    %ebp
  80138f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801390:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801397:	83 ec 0c             	sub    $0xc,%esp
  80139a:	25 07 0e 00 00       	and    $0xe07,%eax
  80139f:	50                   	push   %eax
  8013a0:	57                   	push   %edi
  8013a1:	6a 00                	push   $0x0
  8013a3:	53                   	push   %ebx
  8013a4:	6a 00                	push   $0x0
  8013a6:	e8 89 fa ff ff       	call   800e34 <sys_page_map>
  8013ab:	89 c3                	mov    %eax,%ebx
  8013ad:	83 c4 20             	add    $0x20,%esp
  8013b0:	85 c0                	test   %eax,%eax
  8013b2:	79 a3                	jns    801357 <dup+0x74>
	sys_page_unmap(0, newfd);
  8013b4:	83 ec 08             	sub    $0x8,%esp
  8013b7:	56                   	push   %esi
  8013b8:	6a 00                	push   $0x0
  8013ba:	e8 b7 fa ff ff       	call   800e76 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013bf:	83 c4 08             	add    $0x8,%esp
  8013c2:	57                   	push   %edi
  8013c3:	6a 00                	push   $0x0
  8013c5:	e8 ac fa ff ff       	call   800e76 <sys_page_unmap>
	return r;
  8013ca:	83 c4 10             	add    $0x10,%esp
  8013cd:	eb b7                	jmp    801386 <dup+0xa3>

008013cf <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
  8013d2:	53                   	push   %ebx
  8013d3:	83 ec 1c             	sub    $0x1c,%esp
  8013d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013dc:	50                   	push   %eax
  8013dd:	53                   	push   %ebx
  8013de:	e8 7c fd ff ff       	call   80115f <fd_lookup>
  8013e3:	83 c4 10             	add    $0x10,%esp
  8013e6:	85 c0                	test   %eax,%eax
  8013e8:	78 3f                	js     801429 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013ea:	83 ec 08             	sub    $0x8,%esp
  8013ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013f0:	50                   	push   %eax
  8013f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f4:	ff 30                	pushl  (%eax)
  8013f6:	e8 b4 fd ff ff       	call   8011af <dev_lookup>
  8013fb:	83 c4 10             	add    $0x10,%esp
  8013fe:	85 c0                	test   %eax,%eax
  801400:	78 27                	js     801429 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801402:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801405:	8b 42 08             	mov    0x8(%edx),%eax
  801408:	83 e0 03             	and    $0x3,%eax
  80140b:	83 f8 01             	cmp    $0x1,%eax
  80140e:	74 1e                	je     80142e <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801413:	8b 40 08             	mov    0x8(%eax),%eax
  801416:	85 c0                	test   %eax,%eax
  801418:	74 35                	je     80144f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80141a:	83 ec 04             	sub    $0x4,%esp
  80141d:	ff 75 10             	pushl  0x10(%ebp)
  801420:	ff 75 0c             	pushl  0xc(%ebp)
  801423:	52                   	push   %edx
  801424:	ff d0                	call   *%eax
  801426:	83 c4 10             	add    $0x10,%esp
}
  801429:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80142c:	c9                   	leave  
  80142d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80142e:	a1 20 60 80 00       	mov    0x806020,%eax
  801433:	8b 40 48             	mov    0x48(%eax),%eax
  801436:	83 ec 04             	sub    $0x4,%esp
  801439:	53                   	push   %ebx
  80143a:	50                   	push   %eax
  80143b:	68 78 2b 80 00       	push   $0x802b78
  801440:	e8 5b ee ff ff       	call   8002a0 <cprintf>
		return -E_INVAL;
  801445:	83 c4 10             	add    $0x10,%esp
  801448:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80144d:	eb da                	jmp    801429 <read+0x5a>
		return -E_NOT_SUPP;
  80144f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801454:	eb d3                	jmp    801429 <read+0x5a>

00801456 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
  801459:	57                   	push   %edi
  80145a:	56                   	push   %esi
  80145b:	53                   	push   %ebx
  80145c:	83 ec 0c             	sub    $0xc,%esp
  80145f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801462:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801465:	bb 00 00 00 00       	mov    $0x0,%ebx
  80146a:	39 f3                	cmp    %esi,%ebx
  80146c:	73 23                	jae    801491 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80146e:	83 ec 04             	sub    $0x4,%esp
  801471:	89 f0                	mov    %esi,%eax
  801473:	29 d8                	sub    %ebx,%eax
  801475:	50                   	push   %eax
  801476:	89 d8                	mov    %ebx,%eax
  801478:	03 45 0c             	add    0xc(%ebp),%eax
  80147b:	50                   	push   %eax
  80147c:	57                   	push   %edi
  80147d:	e8 4d ff ff ff       	call   8013cf <read>
		if (m < 0)
  801482:	83 c4 10             	add    $0x10,%esp
  801485:	85 c0                	test   %eax,%eax
  801487:	78 06                	js     80148f <readn+0x39>
			return m;
		if (m == 0)
  801489:	74 06                	je     801491 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80148b:	01 c3                	add    %eax,%ebx
  80148d:	eb db                	jmp    80146a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80148f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801491:	89 d8                	mov    %ebx,%eax
  801493:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801496:	5b                   	pop    %ebx
  801497:	5e                   	pop    %esi
  801498:	5f                   	pop    %edi
  801499:	5d                   	pop    %ebp
  80149a:	c3                   	ret    

0080149b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	53                   	push   %ebx
  80149f:	83 ec 1c             	sub    $0x1c,%esp
  8014a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014a5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a8:	50                   	push   %eax
  8014a9:	53                   	push   %ebx
  8014aa:	e8 b0 fc ff ff       	call   80115f <fd_lookup>
  8014af:	83 c4 10             	add    $0x10,%esp
  8014b2:	85 c0                	test   %eax,%eax
  8014b4:	78 3a                	js     8014f0 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014b6:	83 ec 08             	sub    $0x8,%esp
  8014b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014bc:	50                   	push   %eax
  8014bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c0:	ff 30                	pushl  (%eax)
  8014c2:	e8 e8 fc ff ff       	call   8011af <dev_lookup>
  8014c7:	83 c4 10             	add    $0x10,%esp
  8014ca:	85 c0                	test   %eax,%eax
  8014cc:	78 22                	js     8014f0 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014d5:	74 1e                	je     8014f5 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014da:	8b 52 0c             	mov    0xc(%edx),%edx
  8014dd:	85 d2                	test   %edx,%edx
  8014df:	74 35                	je     801516 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014e1:	83 ec 04             	sub    $0x4,%esp
  8014e4:	ff 75 10             	pushl  0x10(%ebp)
  8014e7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ea:	50                   	push   %eax
  8014eb:	ff d2                	call   *%edx
  8014ed:	83 c4 10             	add    $0x10,%esp
}
  8014f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f3:	c9                   	leave  
  8014f4:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014f5:	a1 20 60 80 00       	mov    0x806020,%eax
  8014fa:	8b 40 48             	mov    0x48(%eax),%eax
  8014fd:	83 ec 04             	sub    $0x4,%esp
  801500:	53                   	push   %ebx
  801501:	50                   	push   %eax
  801502:	68 94 2b 80 00       	push   $0x802b94
  801507:	e8 94 ed ff ff       	call   8002a0 <cprintf>
		return -E_INVAL;
  80150c:	83 c4 10             	add    $0x10,%esp
  80150f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801514:	eb da                	jmp    8014f0 <write+0x55>
		return -E_NOT_SUPP;
  801516:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80151b:	eb d3                	jmp    8014f0 <write+0x55>

0080151d <seek>:

int
seek(int fdnum, off_t offset)
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
  801520:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801523:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801526:	50                   	push   %eax
  801527:	ff 75 08             	pushl  0x8(%ebp)
  80152a:	e8 30 fc ff ff       	call   80115f <fd_lookup>
  80152f:	83 c4 10             	add    $0x10,%esp
  801532:	85 c0                	test   %eax,%eax
  801534:	78 0e                	js     801544 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801536:	8b 55 0c             	mov    0xc(%ebp),%edx
  801539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80153f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801544:	c9                   	leave  
  801545:	c3                   	ret    

00801546 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
  801549:	53                   	push   %ebx
  80154a:	83 ec 1c             	sub    $0x1c,%esp
  80154d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801550:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801553:	50                   	push   %eax
  801554:	53                   	push   %ebx
  801555:	e8 05 fc ff ff       	call   80115f <fd_lookup>
  80155a:	83 c4 10             	add    $0x10,%esp
  80155d:	85 c0                	test   %eax,%eax
  80155f:	78 37                	js     801598 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801561:	83 ec 08             	sub    $0x8,%esp
  801564:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801567:	50                   	push   %eax
  801568:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156b:	ff 30                	pushl  (%eax)
  80156d:	e8 3d fc ff ff       	call   8011af <dev_lookup>
  801572:	83 c4 10             	add    $0x10,%esp
  801575:	85 c0                	test   %eax,%eax
  801577:	78 1f                	js     801598 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801579:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801580:	74 1b                	je     80159d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801582:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801585:	8b 52 18             	mov    0x18(%edx),%edx
  801588:	85 d2                	test   %edx,%edx
  80158a:	74 32                	je     8015be <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80158c:	83 ec 08             	sub    $0x8,%esp
  80158f:	ff 75 0c             	pushl  0xc(%ebp)
  801592:	50                   	push   %eax
  801593:	ff d2                	call   *%edx
  801595:	83 c4 10             	add    $0x10,%esp
}
  801598:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80159b:	c9                   	leave  
  80159c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80159d:	a1 20 60 80 00       	mov    0x806020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015a2:	8b 40 48             	mov    0x48(%eax),%eax
  8015a5:	83 ec 04             	sub    $0x4,%esp
  8015a8:	53                   	push   %ebx
  8015a9:	50                   	push   %eax
  8015aa:	68 54 2b 80 00       	push   $0x802b54
  8015af:	e8 ec ec ff ff       	call   8002a0 <cprintf>
		return -E_INVAL;
  8015b4:	83 c4 10             	add    $0x10,%esp
  8015b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015bc:	eb da                	jmp    801598 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8015be:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015c3:	eb d3                	jmp    801598 <ftruncate+0x52>

008015c5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	53                   	push   %ebx
  8015c9:	83 ec 1c             	sub    $0x1c,%esp
  8015cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015cf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015d2:	50                   	push   %eax
  8015d3:	ff 75 08             	pushl  0x8(%ebp)
  8015d6:	e8 84 fb ff ff       	call   80115f <fd_lookup>
  8015db:	83 c4 10             	add    $0x10,%esp
  8015de:	85 c0                	test   %eax,%eax
  8015e0:	78 4b                	js     80162d <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015e2:	83 ec 08             	sub    $0x8,%esp
  8015e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015e8:	50                   	push   %eax
  8015e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ec:	ff 30                	pushl  (%eax)
  8015ee:	e8 bc fb ff ff       	call   8011af <dev_lookup>
  8015f3:	83 c4 10             	add    $0x10,%esp
  8015f6:	85 c0                	test   %eax,%eax
  8015f8:	78 33                	js     80162d <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015fd:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801601:	74 2f                	je     801632 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801603:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801606:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80160d:	00 00 00 
	stat->st_isdir = 0;
  801610:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801617:	00 00 00 
	stat->st_dev = dev;
  80161a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801620:	83 ec 08             	sub    $0x8,%esp
  801623:	53                   	push   %ebx
  801624:	ff 75 f0             	pushl  -0x10(%ebp)
  801627:	ff 50 14             	call   *0x14(%eax)
  80162a:	83 c4 10             	add    $0x10,%esp
}
  80162d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801630:	c9                   	leave  
  801631:	c3                   	ret    
		return -E_NOT_SUPP;
  801632:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801637:	eb f4                	jmp    80162d <fstat+0x68>

00801639 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	56                   	push   %esi
  80163d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80163e:	83 ec 08             	sub    $0x8,%esp
  801641:	6a 00                	push   $0x0
  801643:	ff 75 08             	pushl  0x8(%ebp)
  801646:	e8 22 02 00 00       	call   80186d <open>
  80164b:	89 c3                	mov    %eax,%ebx
  80164d:	83 c4 10             	add    $0x10,%esp
  801650:	85 c0                	test   %eax,%eax
  801652:	78 1b                	js     80166f <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801654:	83 ec 08             	sub    $0x8,%esp
  801657:	ff 75 0c             	pushl  0xc(%ebp)
  80165a:	50                   	push   %eax
  80165b:	e8 65 ff ff ff       	call   8015c5 <fstat>
  801660:	89 c6                	mov    %eax,%esi
	close(fd);
  801662:	89 1c 24             	mov    %ebx,(%esp)
  801665:	e8 27 fc ff ff       	call   801291 <close>
	return r;
  80166a:	83 c4 10             	add    $0x10,%esp
  80166d:	89 f3                	mov    %esi,%ebx
}
  80166f:	89 d8                	mov    %ebx,%eax
  801671:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801674:	5b                   	pop    %ebx
  801675:	5e                   	pop    %esi
  801676:	5d                   	pop    %ebp
  801677:	c3                   	ret    

00801678 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
  80167b:	56                   	push   %esi
  80167c:	53                   	push   %ebx
  80167d:	89 c6                	mov    %eax,%esi
  80167f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801681:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801688:	74 27                	je     8016b1 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80168a:	6a 07                	push   $0x7
  80168c:	68 00 70 80 00       	push   $0x807000
  801691:	56                   	push   %esi
  801692:	ff 35 00 40 80 00    	pushl  0x804000
  801698:	e8 1c 0d 00 00       	call   8023b9 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80169d:	83 c4 0c             	add    $0xc,%esp
  8016a0:	6a 00                	push   $0x0
  8016a2:	53                   	push   %ebx
  8016a3:	6a 00                	push   $0x0
  8016a5:	e8 a6 0c 00 00       	call   802350 <ipc_recv>
}
  8016aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016ad:	5b                   	pop    %ebx
  8016ae:	5e                   	pop    %esi
  8016af:	5d                   	pop    %ebp
  8016b0:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016b1:	83 ec 0c             	sub    $0xc,%esp
  8016b4:	6a 01                	push   $0x1
  8016b6:	e8 56 0d 00 00       	call   802411 <ipc_find_env>
  8016bb:	a3 00 40 80 00       	mov    %eax,0x804000
  8016c0:	83 c4 10             	add    $0x10,%esp
  8016c3:	eb c5                	jmp    80168a <fsipc+0x12>

008016c5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8016d1:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  8016d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d9:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016de:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e3:	b8 02 00 00 00       	mov    $0x2,%eax
  8016e8:	e8 8b ff ff ff       	call   801678 <fsipc>
}
  8016ed:	c9                   	leave  
  8016ee:	c3                   	ret    

008016ef <devfile_flush>:
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
  8016f2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8016fb:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  801700:	ba 00 00 00 00       	mov    $0x0,%edx
  801705:	b8 06 00 00 00       	mov    $0x6,%eax
  80170a:	e8 69 ff ff ff       	call   801678 <fsipc>
}
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <devfile_stat>:
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	53                   	push   %ebx
  801715:	83 ec 04             	sub    $0x4,%esp
  801718:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	8b 40 0c             	mov    0xc(%eax),%eax
  801721:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801726:	ba 00 00 00 00       	mov    $0x0,%edx
  80172b:	b8 05 00 00 00       	mov    $0x5,%eax
  801730:	e8 43 ff ff ff       	call   801678 <fsipc>
  801735:	85 c0                	test   %eax,%eax
  801737:	78 2c                	js     801765 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801739:	83 ec 08             	sub    $0x8,%esp
  80173c:	68 00 70 80 00       	push   $0x807000
  801741:	53                   	push   %ebx
  801742:	e8 b8 f2 ff ff       	call   8009ff <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801747:	a1 80 70 80 00       	mov    0x807080,%eax
  80174c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801752:	a1 84 70 80 00       	mov    0x807084,%eax
  801757:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80175d:	83 c4 10             	add    $0x10,%esp
  801760:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801765:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <devfile_write>:
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
  80176d:	53                   	push   %ebx
  80176e:	83 ec 08             	sub    $0x8,%esp
  801771:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801774:	8b 45 08             	mov    0x8(%ebp),%eax
  801777:	8b 40 0c             	mov    0xc(%eax),%eax
  80177a:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.write.req_n = n;
  80177f:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801785:	53                   	push   %ebx
  801786:	ff 75 0c             	pushl  0xc(%ebp)
  801789:	68 08 70 80 00       	push   $0x807008
  80178e:	e8 5c f4 ff ff       	call   800bef <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801793:	ba 00 00 00 00       	mov    $0x0,%edx
  801798:	b8 04 00 00 00       	mov    $0x4,%eax
  80179d:	e8 d6 fe ff ff       	call   801678 <fsipc>
  8017a2:	83 c4 10             	add    $0x10,%esp
  8017a5:	85 c0                	test   %eax,%eax
  8017a7:	78 0b                	js     8017b4 <devfile_write+0x4a>
	assert(r <= n);
  8017a9:	39 d8                	cmp    %ebx,%eax
  8017ab:	77 0c                	ja     8017b9 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8017ad:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017b2:	7f 1e                	jg     8017d2 <devfile_write+0x68>
}
  8017b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017b7:	c9                   	leave  
  8017b8:	c3                   	ret    
	assert(r <= n);
  8017b9:	68 c8 2b 80 00       	push   $0x802bc8
  8017be:	68 cf 2b 80 00       	push   $0x802bcf
  8017c3:	68 98 00 00 00       	push   $0x98
  8017c8:	68 e4 2b 80 00       	push   $0x802be4
  8017cd:	e8 d8 e9 ff ff       	call   8001aa <_panic>
	assert(r <= PGSIZE);
  8017d2:	68 ef 2b 80 00       	push   $0x802bef
  8017d7:	68 cf 2b 80 00       	push   $0x802bcf
  8017dc:	68 99 00 00 00       	push   $0x99
  8017e1:	68 e4 2b 80 00       	push   $0x802be4
  8017e6:	e8 bf e9 ff ff       	call   8001aa <_panic>

008017eb <devfile_read>:
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	56                   	push   %esi
  8017ef:	53                   	push   %ebx
  8017f0:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8017f9:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  8017fe:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801804:	ba 00 00 00 00       	mov    $0x0,%edx
  801809:	b8 03 00 00 00       	mov    $0x3,%eax
  80180e:	e8 65 fe ff ff       	call   801678 <fsipc>
  801813:	89 c3                	mov    %eax,%ebx
  801815:	85 c0                	test   %eax,%eax
  801817:	78 1f                	js     801838 <devfile_read+0x4d>
	assert(r <= n);
  801819:	39 f0                	cmp    %esi,%eax
  80181b:	77 24                	ja     801841 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80181d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801822:	7f 33                	jg     801857 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801824:	83 ec 04             	sub    $0x4,%esp
  801827:	50                   	push   %eax
  801828:	68 00 70 80 00       	push   $0x807000
  80182d:	ff 75 0c             	pushl  0xc(%ebp)
  801830:	e8 58 f3 ff ff       	call   800b8d <memmove>
	return r;
  801835:	83 c4 10             	add    $0x10,%esp
}
  801838:	89 d8                	mov    %ebx,%eax
  80183a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80183d:	5b                   	pop    %ebx
  80183e:	5e                   	pop    %esi
  80183f:	5d                   	pop    %ebp
  801840:	c3                   	ret    
	assert(r <= n);
  801841:	68 c8 2b 80 00       	push   $0x802bc8
  801846:	68 cf 2b 80 00       	push   $0x802bcf
  80184b:	6a 7c                	push   $0x7c
  80184d:	68 e4 2b 80 00       	push   $0x802be4
  801852:	e8 53 e9 ff ff       	call   8001aa <_panic>
	assert(r <= PGSIZE);
  801857:	68 ef 2b 80 00       	push   $0x802bef
  80185c:	68 cf 2b 80 00       	push   $0x802bcf
  801861:	6a 7d                	push   $0x7d
  801863:	68 e4 2b 80 00       	push   $0x802be4
  801868:	e8 3d e9 ff ff       	call   8001aa <_panic>

0080186d <open>:
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	56                   	push   %esi
  801871:	53                   	push   %ebx
  801872:	83 ec 1c             	sub    $0x1c,%esp
  801875:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801878:	56                   	push   %esi
  801879:	e8 48 f1 ff ff       	call   8009c6 <strlen>
  80187e:	83 c4 10             	add    $0x10,%esp
  801881:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801886:	7f 6c                	jg     8018f4 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801888:	83 ec 0c             	sub    $0xc,%esp
  80188b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80188e:	50                   	push   %eax
  80188f:	e8 79 f8 ff ff       	call   80110d <fd_alloc>
  801894:	89 c3                	mov    %eax,%ebx
  801896:	83 c4 10             	add    $0x10,%esp
  801899:	85 c0                	test   %eax,%eax
  80189b:	78 3c                	js     8018d9 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80189d:	83 ec 08             	sub    $0x8,%esp
  8018a0:	56                   	push   %esi
  8018a1:	68 00 70 80 00       	push   $0x807000
  8018a6:	e8 54 f1 ff ff       	call   8009ff <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ae:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8018bb:	e8 b8 fd ff ff       	call   801678 <fsipc>
  8018c0:	89 c3                	mov    %eax,%ebx
  8018c2:	83 c4 10             	add    $0x10,%esp
  8018c5:	85 c0                	test   %eax,%eax
  8018c7:	78 19                	js     8018e2 <open+0x75>
	return fd2num(fd);
  8018c9:	83 ec 0c             	sub    $0xc,%esp
  8018cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8018cf:	e8 12 f8 ff ff       	call   8010e6 <fd2num>
  8018d4:	89 c3                	mov    %eax,%ebx
  8018d6:	83 c4 10             	add    $0x10,%esp
}
  8018d9:	89 d8                	mov    %ebx,%eax
  8018db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018de:	5b                   	pop    %ebx
  8018df:	5e                   	pop    %esi
  8018e0:	5d                   	pop    %ebp
  8018e1:	c3                   	ret    
		fd_close(fd, 0);
  8018e2:	83 ec 08             	sub    $0x8,%esp
  8018e5:	6a 00                	push   $0x0
  8018e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ea:	e8 1b f9 ff ff       	call   80120a <fd_close>
		return r;
  8018ef:	83 c4 10             	add    $0x10,%esp
  8018f2:	eb e5                	jmp    8018d9 <open+0x6c>
		return -E_BAD_PATH;
  8018f4:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018f9:	eb de                	jmp    8018d9 <open+0x6c>

008018fb <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801901:	ba 00 00 00 00       	mov    $0x0,%edx
  801906:	b8 08 00 00 00       	mov    $0x8,%eax
  80190b:	e8 68 fd ff ff       	call   801678 <fsipc>
}
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801912:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801916:	7f 01                	jg     801919 <writebuf+0x7>
  801918:	c3                   	ret    
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	53                   	push   %ebx
  80191d:	83 ec 08             	sub    $0x8,%esp
  801920:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801922:	ff 70 04             	pushl  0x4(%eax)
  801925:	8d 40 10             	lea    0x10(%eax),%eax
  801928:	50                   	push   %eax
  801929:	ff 33                	pushl  (%ebx)
  80192b:	e8 6b fb ff ff       	call   80149b <write>
		if (result > 0)
  801930:	83 c4 10             	add    $0x10,%esp
  801933:	85 c0                	test   %eax,%eax
  801935:	7e 03                	jle    80193a <writebuf+0x28>
			b->result += result;
  801937:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  80193a:	39 43 04             	cmp    %eax,0x4(%ebx)
  80193d:	74 0d                	je     80194c <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  80193f:	85 c0                	test   %eax,%eax
  801941:	ba 00 00 00 00       	mov    $0x0,%edx
  801946:	0f 4f c2             	cmovg  %edx,%eax
  801949:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  80194c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <putch>:

static void
putch(int ch, void *thunk)
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
  801954:	53                   	push   %ebx
  801955:	83 ec 04             	sub    $0x4,%esp
  801958:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80195b:	8b 53 04             	mov    0x4(%ebx),%edx
  80195e:	8d 42 01             	lea    0x1(%edx),%eax
  801961:	89 43 04             	mov    %eax,0x4(%ebx)
  801964:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801967:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  80196b:	3d 00 01 00 00       	cmp    $0x100,%eax
  801970:	74 06                	je     801978 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801972:	83 c4 04             	add    $0x4,%esp
  801975:	5b                   	pop    %ebx
  801976:	5d                   	pop    %ebp
  801977:	c3                   	ret    
		writebuf(b);
  801978:	89 d8                	mov    %ebx,%eax
  80197a:	e8 93 ff ff ff       	call   801912 <writebuf>
		b->idx = 0;
  80197f:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  801986:	eb ea                	jmp    801972 <putch+0x21>

00801988 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
  80198b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
  801994:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  80199a:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8019a1:	00 00 00 
	b.result = 0;
  8019a4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8019ab:	00 00 00 
	b.error = 1;
  8019ae:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8019b5:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8019b8:	ff 75 10             	pushl  0x10(%ebp)
  8019bb:	ff 75 0c             	pushl  0xc(%ebp)
  8019be:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8019c4:	50                   	push   %eax
  8019c5:	68 51 19 80 00       	push   $0x801951
  8019ca:	e8 fe e9 ff ff       	call   8003cd <vprintfmt>
	if (b.idx > 0)
  8019cf:	83 c4 10             	add    $0x10,%esp
  8019d2:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8019d9:	7f 11                	jg     8019ec <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  8019db:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8019e1:	85 c0                	test   %eax,%eax
  8019e3:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    
		writebuf(&b);
  8019ec:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8019f2:	e8 1b ff ff ff       	call   801912 <writebuf>
  8019f7:	eb e2                	jmp    8019db <vfprintf+0x53>

008019f9 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
  8019fc:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8019ff:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801a02:	50                   	push   %eax
  801a03:	ff 75 0c             	pushl  0xc(%ebp)
  801a06:	ff 75 08             	pushl  0x8(%ebp)
  801a09:	e8 7a ff ff ff       	call   801988 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <printf>:

int
printf(const char *fmt, ...)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a16:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801a19:	50                   	push   %eax
  801a1a:	ff 75 08             	pushl  0x8(%ebp)
  801a1d:	6a 01                	push   $0x1
  801a1f:	e8 64 ff ff ff       	call   801988 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
  801a29:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801a2c:	68 fb 2b 80 00       	push   $0x802bfb
  801a31:	ff 75 0c             	pushl  0xc(%ebp)
  801a34:	e8 c6 ef ff ff       	call   8009ff <strcpy>
	return 0;
}
  801a39:	b8 00 00 00 00       	mov    $0x0,%eax
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <devsock_close>:
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	53                   	push   %ebx
  801a44:	83 ec 10             	sub    $0x10,%esp
  801a47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a4a:	53                   	push   %ebx
  801a4b:	e8 00 0a 00 00       	call   802450 <pageref>
  801a50:	83 c4 10             	add    $0x10,%esp
		return 0;
  801a53:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801a58:	83 f8 01             	cmp    $0x1,%eax
  801a5b:	74 07                	je     801a64 <devsock_close+0x24>
}
  801a5d:	89 d0                	mov    %edx,%eax
  801a5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801a64:	83 ec 0c             	sub    $0xc,%esp
  801a67:	ff 73 0c             	pushl  0xc(%ebx)
  801a6a:	e8 b9 02 00 00       	call   801d28 <nsipc_close>
  801a6f:	89 c2                	mov    %eax,%edx
  801a71:	83 c4 10             	add    $0x10,%esp
  801a74:	eb e7                	jmp    801a5d <devsock_close+0x1d>

00801a76 <devsock_write>:
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
  801a79:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a7c:	6a 00                	push   $0x0
  801a7e:	ff 75 10             	pushl  0x10(%ebp)
  801a81:	ff 75 0c             	pushl  0xc(%ebp)
  801a84:	8b 45 08             	mov    0x8(%ebp),%eax
  801a87:	ff 70 0c             	pushl  0xc(%eax)
  801a8a:	e8 76 03 00 00       	call   801e05 <nsipc_send>
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <devsock_read>:
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
  801a94:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a97:	6a 00                	push   $0x0
  801a99:	ff 75 10             	pushl  0x10(%ebp)
  801a9c:	ff 75 0c             	pushl  0xc(%ebp)
  801a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa2:	ff 70 0c             	pushl  0xc(%eax)
  801aa5:	e8 ef 02 00 00       	call   801d99 <nsipc_recv>
}
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <fd2sockid>:
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
  801aaf:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ab2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ab5:	52                   	push   %edx
  801ab6:	50                   	push   %eax
  801ab7:	e8 a3 f6 ff ff       	call   80115f <fd_lookup>
  801abc:	83 c4 10             	add    $0x10,%esp
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	78 10                	js     801ad3 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac6:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801acc:	39 08                	cmp    %ecx,(%eax)
  801ace:	75 05                	jne    801ad5 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801ad0:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    
		return -E_NOT_SUPP;
  801ad5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ada:	eb f7                	jmp    801ad3 <fd2sockid+0x27>

00801adc <alloc_sockfd>:
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
  801adf:	56                   	push   %esi
  801ae0:	53                   	push   %ebx
  801ae1:	83 ec 1c             	sub    $0x1c,%esp
  801ae4:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801ae6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ae9:	50                   	push   %eax
  801aea:	e8 1e f6 ff ff       	call   80110d <fd_alloc>
  801aef:	89 c3                	mov    %eax,%ebx
  801af1:	83 c4 10             	add    $0x10,%esp
  801af4:	85 c0                	test   %eax,%eax
  801af6:	78 43                	js     801b3b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801af8:	83 ec 04             	sub    $0x4,%esp
  801afb:	68 07 04 00 00       	push   $0x407
  801b00:	ff 75 f4             	pushl  -0xc(%ebp)
  801b03:	6a 00                	push   $0x0
  801b05:	e8 e7 f2 ff ff       	call   800df1 <sys_page_alloc>
  801b0a:	89 c3                	mov    %eax,%ebx
  801b0c:	83 c4 10             	add    $0x10,%esp
  801b0f:	85 c0                	test   %eax,%eax
  801b11:	78 28                	js     801b3b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b16:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b1c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b21:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801b28:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801b2b:	83 ec 0c             	sub    $0xc,%esp
  801b2e:	50                   	push   %eax
  801b2f:	e8 b2 f5 ff ff       	call   8010e6 <fd2num>
  801b34:	89 c3                	mov    %eax,%ebx
  801b36:	83 c4 10             	add    $0x10,%esp
  801b39:	eb 0c                	jmp    801b47 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801b3b:	83 ec 0c             	sub    $0xc,%esp
  801b3e:	56                   	push   %esi
  801b3f:	e8 e4 01 00 00       	call   801d28 <nsipc_close>
		return r;
  801b44:	83 c4 10             	add    $0x10,%esp
}
  801b47:	89 d8                	mov    %ebx,%eax
  801b49:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b4c:	5b                   	pop    %ebx
  801b4d:	5e                   	pop    %esi
  801b4e:	5d                   	pop    %ebp
  801b4f:	c3                   	ret    

00801b50 <accept>:
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
  801b53:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b56:	8b 45 08             	mov    0x8(%ebp),%eax
  801b59:	e8 4e ff ff ff       	call   801aac <fd2sockid>
  801b5e:	85 c0                	test   %eax,%eax
  801b60:	78 1b                	js     801b7d <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b62:	83 ec 04             	sub    $0x4,%esp
  801b65:	ff 75 10             	pushl  0x10(%ebp)
  801b68:	ff 75 0c             	pushl  0xc(%ebp)
  801b6b:	50                   	push   %eax
  801b6c:	e8 0e 01 00 00       	call   801c7f <nsipc_accept>
  801b71:	83 c4 10             	add    $0x10,%esp
  801b74:	85 c0                	test   %eax,%eax
  801b76:	78 05                	js     801b7d <accept+0x2d>
	return alloc_sockfd(r);
  801b78:	e8 5f ff ff ff       	call   801adc <alloc_sockfd>
}
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <bind>:
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b85:	8b 45 08             	mov    0x8(%ebp),%eax
  801b88:	e8 1f ff ff ff       	call   801aac <fd2sockid>
  801b8d:	85 c0                	test   %eax,%eax
  801b8f:	78 12                	js     801ba3 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801b91:	83 ec 04             	sub    $0x4,%esp
  801b94:	ff 75 10             	pushl  0x10(%ebp)
  801b97:	ff 75 0c             	pushl  0xc(%ebp)
  801b9a:	50                   	push   %eax
  801b9b:	e8 31 01 00 00       	call   801cd1 <nsipc_bind>
  801ba0:	83 c4 10             	add    $0x10,%esp
}
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <shutdown>:
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	e8 f9 fe ff ff       	call   801aac <fd2sockid>
  801bb3:	85 c0                	test   %eax,%eax
  801bb5:	78 0f                	js     801bc6 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801bb7:	83 ec 08             	sub    $0x8,%esp
  801bba:	ff 75 0c             	pushl  0xc(%ebp)
  801bbd:	50                   	push   %eax
  801bbe:	e8 43 01 00 00       	call   801d06 <nsipc_shutdown>
  801bc3:	83 c4 10             	add    $0x10,%esp
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <connect>:
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
  801bcb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bce:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd1:	e8 d6 fe ff ff       	call   801aac <fd2sockid>
  801bd6:	85 c0                	test   %eax,%eax
  801bd8:	78 12                	js     801bec <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801bda:	83 ec 04             	sub    $0x4,%esp
  801bdd:	ff 75 10             	pushl  0x10(%ebp)
  801be0:	ff 75 0c             	pushl  0xc(%ebp)
  801be3:	50                   	push   %eax
  801be4:	e8 59 01 00 00       	call   801d42 <nsipc_connect>
  801be9:	83 c4 10             	add    $0x10,%esp
}
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

00801bee <listen>:
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
  801bf1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf7:	e8 b0 fe ff ff       	call   801aac <fd2sockid>
  801bfc:	85 c0                	test   %eax,%eax
  801bfe:	78 0f                	js     801c0f <listen+0x21>
	return nsipc_listen(r, backlog);
  801c00:	83 ec 08             	sub    $0x8,%esp
  801c03:	ff 75 0c             	pushl  0xc(%ebp)
  801c06:	50                   	push   %eax
  801c07:	e8 6b 01 00 00       	call   801d77 <nsipc_listen>
  801c0c:	83 c4 10             	add    $0x10,%esp
}
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <socket>:

int
socket(int domain, int type, int protocol)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
  801c14:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c17:	ff 75 10             	pushl  0x10(%ebp)
  801c1a:	ff 75 0c             	pushl  0xc(%ebp)
  801c1d:	ff 75 08             	pushl  0x8(%ebp)
  801c20:	e8 3e 02 00 00       	call   801e63 <nsipc_socket>
  801c25:	83 c4 10             	add    $0x10,%esp
  801c28:	85 c0                	test   %eax,%eax
  801c2a:	78 05                	js     801c31 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801c2c:	e8 ab fe ff ff       	call   801adc <alloc_sockfd>
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
  801c36:	53                   	push   %ebx
  801c37:	83 ec 04             	sub    $0x4,%esp
  801c3a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c3c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c43:	74 26                	je     801c6b <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c45:	6a 07                	push   $0x7
  801c47:	68 00 80 80 00       	push   $0x808000
  801c4c:	53                   	push   %ebx
  801c4d:	ff 35 04 40 80 00    	pushl  0x804004
  801c53:	e8 61 07 00 00       	call   8023b9 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c58:	83 c4 0c             	add    $0xc,%esp
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	e8 ea 06 00 00       	call   802350 <ipc_recv>
}
  801c66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c6b:	83 ec 0c             	sub    $0xc,%esp
  801c6e:	6a 02                	push   $0x2
  801c70:	e8 9c 07 00 00       	call   802411 <ipc_find_env>
  801c75:	a3 04 40 80 00       	mov    %eax,0x804004
  801c7a:	83 c4 10             	add    $0x10,%esp
  801c7d:	eb c6                	jmp    801c45 <nsipc+0x12>

00801c7f <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	56                   	push   %esi
  801c83:	53                   	push   %ebx
  801c84:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c87:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8a:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c8f:	8b 06                	mov    (%esi),%eax
  801c91:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c96:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9b:	e8 93 ff ff ff       	call   801c33 <nsipc>
  801ca0:	89 c3                	mov    %eax,%ebx
  801ca2:	85 c0                	test   %eax,%eax
  801ca4:	79 09                	jns    801caf <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ca6:	89 d8                	mov    %ebx,%eax
  801ca8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cab:	5b                   	pop    %ebx
  801cac:	5e                   	pop    %esi
  801cad:	5d                   	pop    %ebp
  801cae:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801caf:	83 ec 04             	sub    $0x4,%esp
  801cb2:	ff 35 10 80 80 00    	pushl  0x808010
  801cb8:	68 00 80 80 00       	push   $0x808000
  801cbd:	ff 75 0c             	pushl  0xc(%ebp)
  801cc0:	e8 c8 ee ff ff       	call   800b8d <memmove>
		*addrlen = ret->ret_addrlen;
  801cc5:	a1 10 80 80 00       	mov    0x808010,%eax
  801cca:	89 06                	mov    %eax,(%esi)
  801ccc:	83 c4 10             	add    $0x10,%esp
	return r;
  801ccf:	eb d5                	jmp    801ca6 <nsipc_accept+0x27>

00801cd1 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
  801cd4:	53                   	push   %ebx
  801cd5:	83 ec 08             	sub    $0x8,%esp
  801cd8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cde:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ce3:	53                   	push   %ebx
  801ce4:	ff 75 0c             	pushl  0xc(%ebp)
  801ce7:	68 04 80 80 00       	push   $0x808004
  801cec:	e8 9c ee ff ff       	call   800b8d <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801cf1:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  801cf7:	b8 02 00 00 00       	mov    $0x2,%eax
  801cfc:	e8 32 ff ff ff       	call   801c33 <nsipc>
}
  801d01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
  801d09:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0f:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  801d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d17:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  801d1c:	b8 03 00 00 00       	mov    $0x3,%eax
  801d21:	e8 0d ff ff ff       	call   801c33 <nsipc>
}
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <nsipc_close>:

int
nsipc_close(int s)
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d31:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  801d36:	b8 04 00 00 00       	mov    $0x4,%eax
  801d3b:	e8 f3 fe ff ff       	call   801c33 <nsipc>
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	53                   	push   %ebx
  801d46:	83 ec 08             	sub    $0x8,%esp
  801d49:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4f:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d54:	53                   	push   %ebx
  801d55:	ff 75 0c             	pushl  0xc(%ebp)
  801d58:	68 04 80 80 00       	push   $0x808004
  801d5d:	e8 2b ee ff ff       	call   800b8d <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d62:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  801d68:	b8 05 00 00 00       	mov    $0x5,%eax
  801d6d:	e8 c1 fe ff ff       	call   801c33 <nsipc>
}
  801d72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
  801d7a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d80:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  801d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d88:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  801d8d:	b8 06 00 00 00       	mov    $0x6,%eax
  801d92:	e8 9c fe ff ff       	call   801c33 <nsipc>
}
  801d97:	c9                   	leave  
  801d98:	c3                   	ret    

00801d99 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
  801d9c:	56                   	push   %esi
  801d9d:	53                   	push   %ebx
  801d9e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801da1:	8b 45 08             	mov    0x8(%ebp),%eax
  801da4:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  801da9:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  801daf:	8b 45 14             	mov    0x14(%ebp),%eax
  801db2:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801db7:	b8 07 00 00 00       	mov    $0x7,%eax
  801dbc:	e8 72 fe ff ff       	call   801c33 <nsipc>
  801dc1:	89 c3                	mov    %eax,%ebx
  801dc3:	85 c0                	test   %eax,%eax
  801dc5:	78 1f                	js     801de6 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801dc7:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801dcc:	7f 21                	jg     801def <nsipc_recv+0x56>
  801dce:	39 c6                	cmp    %eax,%esi
  801dd0:	7c 1d                	jl     801def <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801dd2:	83 ec 04             	sub    $0x4,%esp
  801dd5:	50                   	push   %eax
  801dd6:	68 00 80 80 00       	push   $0x808000
  801ddb:	ff 75 0c             	pushl  0xc(%ebp)
  801dde:	e8 aa ed ff ff       	call   800b8d <memmove>
  801de3:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801de6:	89 d8                	mov    %ebx,%eax
  801de8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801deb:	5b                   	pop    %ebx
  801dec:	5e                   	pop    %esi
  801ded:	5d                   	pop    %ebp
  801dee:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801def:	68 07 2c 80 00       	push   $0x802c07
  801df4:	68 cf 2b 80 00       	push   $0x802bcf
  801df9:	6a 62                	push   $0x62
  801dfb:	68 1c 2c 80 00       	push   $0x802c1c
  801e00:	e8 a5 e3 ff ff       	call   8001aa <_panic>

00801e05 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
  801e08:	53                   	push   %ebx
  801e09:	83 ec 04             	sub    $0x4,%esp
  801e0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e12:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  801e17:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e1d:	7f 2e                	jg     801e4d <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e1f:	83 ec 04             	sub    $0x4,%esp
  801e22:	53                   	push   %ebx
  801e23:	ff 75 0c             	pushl  0xc(%ebp)
  801e26:	68 0c 80 80 00       	push   $0x80800c
  801e2b:	e8 5d ed ff ff       	call   800b8d <memmove>
	nsipcbuf.send.req_size = size;
  801e30:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  801e36:	8b 45 14             	mov    0x14(%ebp),%eax
  801e39:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  801e3e:	b8 08 00 00 00       	mov    $0x8,%eax
  801e43:	e8 eb fd ff ff       	call   801c33 <nsipc>
}
  801e48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    
	assert(size < 1600);
  801e4d:	68 28 2c 80 00       	push   $0x802c28
  801e52:	68 cf 2b 80 00       	push   $0x802bcf
  801e57:	6a 6d                	push   $0x6d
  801e59:	68 1c 2c 80 00       	push   $0x802c1c
  801e5e:	e8 47 e3 ff ff       	call   8001aa <_panic>

00801e63 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
  801e66:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e69:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6c:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  801e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e74:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  801e79:	8b 45 10             	mov    0x10(%ebp),%eax
  801e7c:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  801e81:	b8 09 00 00 00       	mov    $0x9,%eax
  801e86:	e8 a8 fd ff ff       	call   801c33 <nsipc>
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	56                   	push   %esi
  801e91:	53                   	push   %ebx
  801e92:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e95:	83 ec 0c             	sub    $0xc,%esp
  801e98:	ff 75 08             	pushl  0x8(%ebp)
  801e9b:	e8 56 f2 ff ff       	call   8010f6 <fd2data>
  801ea0:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ea2:	83 c4 08             	add    $0x8,%esp
  801ea5:	68 34 2c 80 00       	push   $0x802c34
  801eaa:	53                   	push   %ebx
  801eab:	e8 4f eb ff ff       	call   8009ff <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801eb0:	8b 46 04             	mov    0x4(%esi),%eax
  801eb3:	2b 06                	sub    (%esi),%eax
  801eb5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ebb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ec2:	00 00 00 
	stat->st_dev = &devpipe;
  801ec5:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801ecc:	30 80 00 
	return 0;
}
  801ecf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ed7:	5b                   	pop    %ebx
  801ed8:	5e                   	pop    %esi
  801ed9:	5d                   	pop    %ebp
  801eda:	c3                   	ret    

00801edb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
  801ede:	53                   	push   %ebx
  801edf:	83 ec 0c             	sub    $0xc,%esp
  801ee2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ee5:	53                   	push   %ebx
  801ee6:	6a 00                	push   $0x0
  801ee8:	e8 89 ef ff ff       	call   800e76 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801eed:	89 1c 24             	mov    %ebx,(%esp)
  801ef0:	e8 01 f2 ff ff       	call   8010f6 <fd2data>
  801ef5:	83 c4 08             	add    $0x8,%esp
  801ef8:	50                   	push   %eax
  801ef9:	6a 00                	push   $0x0
  801efb:	e8 76 ef ff ff       	call   800e76 <sys_page_unmap>
}
  801f00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <_pipeisclosed>:
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
  801f08:	57                   	push   %edi
  801f09:	56                   	push   %esi
  801f0a:	53                   	push   %ebx
  801f0b:	83 ec 1c             	sub    $0x1c,%esp
  801f0e:	89 c7                	mov    %eax,%edi
  801f10:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801f12:	a1 20 60 80 00       	mov    0x806020,%eax
  801f17:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f1a:	83 ec 0c             	sub    $0xc,%esp
  801f1d:	57                   	push   %edi
  801f1e:	e8 2d 05 00 00       	call   802450 <pageref>
  801f23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f26:	89 34 24             	mov    %esi,(%esp)
  801f29:	e8 22 05 00 00       	call   802450 <pageref>
		nn = thisenv->env_runs;
  801f2e:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801f34:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801f37:	83 c4 10             	add    $0x10,%esp
  801f3a:	39 cb                	cmp    %ecx,%ebx
  801f3c:	74 1b                	je     801f59 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801f3e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f41:	75 cf                	jne    801f12 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f43:	8b 42 58             	mov    0x58(%edx),%eax
  801f46:	6a 01                	push   $0x1
  801f48:	50                   	push   %eax
  801f49:	53                   	push   %ebx
  801f4a:	68 3b 2c 80 00       	push   $0x802c3b
  801f4f:	e8 4c e3 ff ff       	call   8002a0 <cprintf>
  801f54:	83 c4 10             	add    $0x10,%esp
  801f57:	eb b9                	jmp    801f12 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801f59:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f5c:	0f 94 c0             	sete   %al
  801f5f:	0f b6 c0             	movzbl %al,%eax
}
  801f62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f65:	5b                   	pop    %ebx
  801f66:	5e                   	pop    %esi
  801f67:	5f                   	pop    %edi
  801f68:	5d                   	pop    %ebp
  801f69:	c3                   	ret    

00801f6a <devpipe_write>:
{
  801f6a:	55                   	push   %ebp
  801f6b:	89 e5                	mov    %esp,%ebp
  801f6d:	57                   	push   %edi
  801f6e:	56                   	push   %esi
  801f6f:	53                   	push   %ebx
  801f70:	83 ec 28             	sub    $0x28,%esp
  801f73:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f76:	56                   	push   %esi
  801f77:	e8 7a f1 ff ff       	call   8010f6 <fd2data>
  801f7c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f7e:	83 c4 10             	add    $0x10,%esp
  801f81:	bf 00 00 00 00       	mov    $0x0,%edi
  801f86:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f89:	74 4f                	je     801fda <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f8b:	8b 43 04             	mov    0x4(%ebx),%eax
  801f8e:	8b 0b                	mov    (%ebx),%ecx
  801f90:	8d 51 20             	lea    0x20(%ecx),%edx
  801f93:	39 d0                	cmp    %edx,%eax
  801f95:	72 14                	jb     801fab <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801f97:	89 da                	mov    %ebx,%edx
  801f99:	89 f0                	mov    %esi,%eax
  801f9b:	e8 65 ff ff ff       	call   801f05 <_pipeisclosed>
  801fa0:	85 c0                	test   %eax,%eax
  801fa2:	75 3b                	jne    801fdf <devpipe_write+0x75>
			sys_yield();
  801fa4:	e8 29 ee ff ff       	call   800dd2 <sys_yield>
  801fa9:	eb e0                	jmp    801f8b <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801fab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fae:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801fb2:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801fb5:	89 c2                	mov    %eax,%edx
  801fb7:	c1 fa 1f             	sar    $0x1f,%edx
  801fba:	89 d1                	mov    %edx,%ecx
  801fbc:	c1 e9 1b             	shr    $0x1b,%ecx
  801fbf:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801fc2:	83 e2 1f             	and    $0x1f,%edx
  801fc5:	29 ca                	sub    %ecx,%edx
  801fc7:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801fcb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801fcf:	83 c0 01             	add    $0x1,%eax
  801fd2:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801fd5:	83 c7 01             	add    $0x1,%edi
  801fd8:	eb ac                	jmp    801f86 <devpipe_write+0x1c>
	return i;
  801fda:	8b 45 10             	mov    0x10(%ebp),%eax
  801fdd:	eb 05                	jmp    801fe4 <devpipe_write+0x7a>
				return 0;
  801fdf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fe4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fe7:	5b                   	pop    %ebx
  801fe8:	5e                   	pop    %esi
  801fe9:	5f                   	pop    %edi
  801fea:	5d                   	pop    %ebp
  801feb:	c3                   	ret    

00801fec <devpipe_read>:
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	57                   	push   %edi
  801ff0:	56                   	push   %esi
  801ff1:	53                   	push   %ebx
  801ff2:	83 ec 18             	sub    $0x18,%esp
  801ff5:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ff8:	57                   	push   %edi
  801ff9:	e8 f8 f0 ff ff       	call   8010f6 <fd2data>
  801ffe:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802000:	83 c4 10             	add    $0x10,%esp
  802003:	be 00 00 00 00       	mov    $0x0,%esi
  802008:	3b 75 10             	cmp    0x10(%ebp),%esi
  80200b:	75 14                	jne    802021 <devpipe_read+0x35>
	return i;
  80200d:	8b 45 10             	mov    0x10(%ebp),%eax
  802010:	eb 02                	jmp    802014 <devpipe_read+0x28>
				return i;
  802012:	89 f0                	mov    %esi,%eax
}
  802014:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802017:	5b                   	pop    %ebx
  802018:	5e                   	pop    %esi
  802019:	5f                   	pop    %edi
  80201a:	5d                   	pop    %ebp
  80201b:	c3                   	ret    
			sys_yield();
  80201c:	e8 b1 ed ff ff       	call   800dd2 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802021:	8b 03                	mov    (%ebx),%eax
  802023:	3b 43 04             	cmp    0x4(%ebx),%eax
  802026:	75 18                	jne    802040 <devpipe_read+0x54>
			if (i > 0)
  802028:	85 f6                	test   %esi,%esi
  80202a:	75 e6                	jne    802012 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  80202c:	89 da                	mov    %ebx,%edx
  80202e:	89 f8                	mov    %edi,%eax
  802030:	e8 d0 fe ff ff       	call   801f05 <_pipeisclosed>
  802035:	85 c0                	test   %eax,%eax
  802037:	74 e3                	je     80201c <devpipe_read+0x30>
				return 0;
  802039:	b8 00 00 00 00       	mov    $0x0,%eax
  80203e:	eb d4                	jmp    802014 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802040:	99                   	cltd   
  802041:	c1 ea 1b             	shr    $0x1b,%edx
  802044:	01 d0                	add    %edx,%eax
  802046:	83 e0 1f             	and    $0x1f,%eax
  802049:	29 d0                	sub    %edx,%eax
  80204b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802050:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802053:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802056:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802059:	83 c6 01             	add    $0x1,%esi
  80205c:	eb aa                	jmp    802008 <devpipe_read+0x1c>

0080205e <pipe>:
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
  802061:	56                   	push   %esi
  802062:	53                   	push   %ebx
  802063:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802066:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802069:	50                   	push   %eax
  80206a:	e8 9e f0 ff ff       	call   80110d <fd_alloc>
  80206f:	89 c3                	mov    %eax,%ebx
  802071:	83 c4 10             	add    $0x10,%esp
  802074:	85 c0                	test   %eax,%eax
  802076:	0f 88 23 01 00 00    	js     80219f <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80207c:	83 ec 04             	sub    $0x4,%esp
  80207f:	68 07 04 00 00       	push   $0x407
  802084:	ff 75 f4             	pushl  -0xc(%ebp)
  802087:	6a 00                	push   $0x0
  802089:	e8 63 ed ff ff       	call   800df1 <sys_page_alloc>
  80208e:	89 c3                	mov    %eax,%ebx
  802090:	83 c4 10             	add    $0x10,%esp
  802093:	85 c0                	test   %eax,%eax
  802095:	0f 88 04 01 00 00    	js     80219f <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80209b:	83 ec 0c             	sub    $0xc,%esp
  80209e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020a1:	50                   	push   %eax
  8020a2:	e8 66 f0 ff ff       	call   80110d <fd_alloc>
  8020a7:	89 c3                	mov    %eax,%ebx
  8020a9:	83 c4 10             	add    $0x10,%esp
  8020ac:	85 c0                	test   %eax,%eax
  8020ae:	0f 88 db 00 00 00    	js     80218f <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020b4:	83 ec 04             	sub    $0x4,%esp
  8020b7:	68 07 04 00 00       	push   $0x407
  8020bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8020bf:	6a 00                	push   $0x0
  8020c1:	e8 2b ed ff ff       	call   800df1 <sys_page_alloc>
  8020c6:	89 c3                	mov    %eax,%ebx
  8020c8:	83 c4 10             	add    $0x10,%esp
  8020cb:	85 c0                	test   %eax,%eax
  8020cd:	0f 88 bc 00 00 00    	js     80218f <pipe+0x131>
	va = fd2data(fd0);
  8020d3:	83 ec 0c             	sub    $0xc,%esp
  8020d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8020d9:	e8 18 f0 ff ff       	call   8010f6 <fd2data>
  8020de:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020e0:	83 c4 0c             	add    $0xc,%esp
  8020e3:	68 07 04 00 00       	push   $0x407
  8020e8:	50                   	push   %eax
  8020e9:	6a 00                	push   $0x0
  8020eb:	e8 01 ed ff ff       	call   800df1 <sys_page_alloc>
  8020f0:	89 c3                	mov    %eax,%ebx
  8020f2:	83 c4 10             	add    $0x10,%esp
  8020f5:	85 c0                	test   %eax,%eax
  8020f7:	0f 88 82 00 00 00    	js     80217f <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020fd:	83 ec 0c             	sub    $0xc,%esp
  802100:	ff 75 f0             	pushl  -0x10(%ebp)
  802103:	e8 ee ef ff ff       	call   8010f6 <fd2data>
  802108:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80210f:	50                   	push   %eax
  802110:	6a 00                	push   $0x0
  802112:	56                   	push   %esi
  802113:	6a 00                	push   $0x0
  802115:	e8 1a ed ff ff       	call   800e34 <sys_page_map>
  80211a:	89 c3                	mov    %eax,%ebx
  80211c:	83 c4 20             	add    $0x20,%esp
  80211f:	85 c0                	test   %eax,%eax
  802121:	78 4e                	js     802171 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802123:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802128:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80212b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80212d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802130:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802137:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80213a:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80213c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80213f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802146:	83 ec 0c             	sub    $0xc,%esp
  802149:	ff 75 f4             	pushl  -0xc(%ebp)
  80214c:	e8 95 ef ff ff       	call   8010e6 <fd2num>
  802151:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802154:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802156:	83 c4 04             	add    $0x4,%esp
  802159:	ff 75 f0             	pushl  -0x10(%ebp)
  80215c:	e8 85 ef ff ff       	call   8010e6 <fd2num>
  802161:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802164:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802167:	83 c4 10             	add    $0x10,%esp
  80216a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80216f:	eb 2e                	jmp    80219f <pipe+0x141>
	sys_page_unmap(0, va);
  802171:	83 ec 08             	sub    $0x8,%esp
  802174:	56                   	push   %esi
  802175:	6a 00                	push   $0x0
  802177:	e8 fa ec ff ff       	call   800e76 <sys_page_unmap>
  80217c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80217f:	83 ec 08             	sub    $0x8,%esp
  802182:	ff 75 f0             	pushl  -0x10(%ebp)
  802185:	6a 00                	push   $0x0
  802187:	e8 ea ec ff ff       	call   800e76 <sys_page_unmap>
  80218c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80218f:	83 ec 08             	sub    $0x8,%esp
  802192:	ff 75 f4             	pushl  -0xc(%ebp)
  802195:	6a 00                	push   $0x0
  802197:	e8 da ec ff ff       	call   800e76 <sys_page_unmap>
  80219c:	83 c4 10             	add    $0x10,%esp
}
  80219f:	89 d8                	mov    %ebx,%eax
  8021a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021a4:	5b                   	pop    %ebx
  8021a5:	5e                   	pop    %esi
  8021a6:	5d                   	pop    %ebp
  8021a7:	c3                   	ret    

008021a8 <pipeisclosed>:
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
  8021ab:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021b1:	50                   	push   %eax
  8021b2:	ff 75 08             	pushl  0x8(%ebp)
  8021b5:	e8 a5 ef ff ff       	call   80115f <fd_lookup>
  8021ba:	83 c4 10             	add    $0x10,%esp
  8021bd:	85 c0                	test   %eax,%eax
  8021bf:	78 18                	js     8021d9 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8021c1:	83 ec 0c             	sub    $0xc,%esp
  8021c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8021c7:	e8 2a ef ff ff       	call   8010f6 <fd2data>
	return _pipeisclosed(fd, p);
  8021cc:	89 c2                	mov    %eax,%edx
  8021ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d1:	e8 2f fd ff ff       	call   801f05 <_pipeisclosed>
  8021d6:	83 c4 10             	add    $0x10,%esp
}
  8021d9:	c9                   	leave  
  8021da:	c3                   	ret    

008021db <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8021db:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e0:	c3                   	ret    

008021e1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8021e1:	55                   	push   %ebp
  8021e2:	89 e5                	mov    %esp,%ebp
  8021e4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8021e7:	68 53 2c 80 00       	push   $0x802c53
  8021ec:	ff 75 0c             	pushl  0xc(%ebp)
  8021ef:	e8 0b e8 ff ff       	call   8009ff <strcpy>
	return 0;
}
  8021f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f9:	c9                   	leave  
  8021fa:	c3                   	ret    

008021fb <devcons_write>:
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
  8021fe:	57                   	push   %edi
  8021ff:	56                   	push   %esi
  802200:	53                   	push   %ebx
  802201:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802207:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80220c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802212:	3b 75 10             	cmp    0x10(%ebp),%esi
  802215:	73 31                	jae    802248 <devcons_write+0x4d>
		m = n - tot;
  802217:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80221a:	29 f3                	sub    %esi,%ebx
  80221c:	83 fb 7f             	cmp    $0x7f,%ebx
  80221f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802224:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802227:	83 ec 04             	sub    $0x4,%esp
  80222a:	53                   	push   %ebx
  80222b:	89 f0                	mov    %esi,%eax
  80222d:	03 45 0c             	add    0xc(%ebp),%eax
  802230:	50                   	push   %eax
  802231:	57                   	push   %edi
  802232:	e8 56 e9 ff ff       	call   800b8d <memmove>
		sys_cputs(buf, m);
  802237:	83 c4 08             	add    $0x8,%esp
  80223a:	53                   	push   %ebx
  80223b:	57                   	push   %edi
  80223c:	e8 f4 ea ff ff       	call   800d35 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802241:	01 de                	add    %ebx,%esi
  802243:	83 c4 10             	add    $0x10,%esp
  802246:	eb ca                	jmp    802212 <devcons_write+0x17>
}
  802248:	89 f0                	mov    %esi,%eax
  80224a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80224d:	5b                   	pop    %ebx
  80224e:	5e                   	pop    %esi
  80224f:	5f                   	pop    %edi
  802250:	5d                   	pop    %ebp
  802251:	c3                   	ret    

00802252 <devcons_read>:
{
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
  802255:	83 ec 08             	sub    $0x8,%esp
  802258:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80225d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802261:	74 21                	je     802284 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802263:	e8 eb ea ff ff       	call   800d53 <sys_cgetc>
  802268:	85 c0                	test   %eax,%eax
  80226a:	75 07                	jne    802273 <devcons_read+0x21>
		sys_yield();
  80226c:	e8 61 eb ff ff       	call   800dd2 <sys_yield>
  802271:	eb f0                	jmp    802263 <devcons_read+0x11>
	if (c < 0)
  802273:	78 0f                	js     802284 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802275:	83 f8 04             	cmp    $0x4,%eax
  802278:	74 0c                	je     802286 <devcons_read+0x34>
	*(char*)vbuf = c;
  80227a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227d:	88 02                	mov    %al,(%edx)
	return 1;
  80227f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802284:	c9                   	leave  
  802285:	c3                   	ret    
		return 0;
  802286:	b8 00 00 00 00       	mov    $0x0,%eax
  80228b:	eb f7                	jmp    802284 <devcons_read+0x32>

0080228d <cputchar>:
{
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
  802290:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802299:	6a 01                	push   $0x1
  80229b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80229e:	50                   	push   %eax
  80229f:	e8 91 ea ff ff       	call   800d35 <sys_cputs>
}
  8022a4:	83 c4 10             	add    $0x10,%esp
  8022a7:	c9                   	leave  
  8022a8:	c3                   	ret    

008022a9 <getchar>:
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
  8022ac:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8022af:	6a 01                	push   $0x1
  8022b1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022b4:	50                   	push   %eax
  8022b5:	6a 00                	push   $0x0
  8022b7:	e8 13 f1 ff ff       	call   8013cf <read>
	if (r < 0)
  8022bc:	83 c4 10             	add    $0x10,%esp
  8022bf:	85 c0                	test   %eax,%eax
  8022c1:	78 06                	js     8022c9 <getchar+0x20>
	if (r < 1)
  8022c3:	74 06                	je     8022cb <getchar+0x22>
	return c;
  8022c5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8022c9:	c9                   	leave  
  8022ca:	c3                   	ret    
		return -E_EOF;
  8022cb:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8022d0:	eb f7                	jmp    8022c9 <getchar+0x20>

008022d2 <iscons>:
{
  8022d2:	55                   	push   %ebp
  8022d3:	89 e5                	mov    %esp,%ebp
  8022d5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022db:	50                   	push   %eax
  8022dc:	ff 75 08             	pushl  0x8(%ebp)
  8022df:	e8 7b ee ff ff       	call   80115f <fd_lookup>
  8022e4:	83 c4 10             	add    $0x10,%esp
  8022e7:	85 c0                	test   %eax,%eax
  8022e9:	78 11                	js     8022fc <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8022eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ee:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022f4:	39 10                	cmp    %edx,(%eax)
  8022f6:	0f 94 c0             	sete   %al
  8022f9:	0f b6 c0             	movzbl %al,%eax
}
  8022fc:	c9                   	leave  
  8022fd:	c3                   	ret    

008022fe <opencons>:
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
  802301:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802304:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802307:	50                   	push   %eax
  802308:	e8 00 ee ff ff       	call   80110d <fd_alloc>
  80230d:	83 c4 10             	add    $0x10,%esp
  802310:	85 c0                	test   %eax,%eax
  802312:	78 3a                	js     80234e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802314:	83 ec 04             	sub    $0x4,%esp
  802317:	68 07 04 00 00       	push   $0x407
  80231c:	ff 75 f4             	pushl  -0xc(%ebp)
  80231f:	6a 00                	push   $0x0
  802321:	e8 cb ea ff ff       	call   800df1 <sys_page_alloc>
  802326:	83 c4 10             	add    $0x10,%esp
  802329:	85 c0                	test   %eax,%eax
  80232b:	78 21                	js     80234e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80232d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802330:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802336:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802342:	83 ec 0c             	sub    $0xc,%esp
  802345:	50                   	push   %eax
  802346:	e8 9b ed ff ff       	call   8010e6 <fd2num>
  80234b:	83 c4 10             	add    $0x10,%esp
}
  80234e:	c9                   	leave  
  80234f:	c3                   	ret    

00802350 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802350:	55                   	push   %ebp
  802351:	89 e5                	mov    %esp,%ebp
  802353:	56                   	push   %esi
  802354:	53                   	push   %ebx
  802355:	8b 75 08             	mov    0x8(%ebp),%esi
  802358:	8b 45 0c             	mov    0xc(%ebp),%eax
  80235b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80235e:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802360:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802365:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802368:	83 ec 0c             	sub    $0xc,%esp
  80236b:	50                   	push   %eax
  80236c:	e8 30 ec ff ff       	call   800fa1 <sys_ipc_recv>
	if(ret < 0){
  802371:	83 c4 10             	add    $0x10,%esp
  802374:	85 c0                	test   %eax,%eax
  802376:	78 2b                	js     8023a3 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802378:	85 f6                	test   %esi,%esi
  80237a:	74 0a                	je     802386 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80237c:	a1 20 60 80 00       	mov    0x806020,%eax
  802381:	8b 40 78             	mov    0x78(%eax),%eax
  802384:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802386:	85 db                	test   %ebx,%ebx
  802388:	74 0a                	je     802394 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80238a:	a1 20 60 80 00       	mov    0x806020,%eax
  80238f:	8b 40 7c             	mov    0x7c(%eax),%eax
  802392:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802394:	a1 20 60 80 00       	mov    0x806020,%eax
  802399:	8b 40 74             	mov    0x74(%eax),%eax
}
  80239c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80239f:	5b                   	pop    %ebx
  8023a0:	5e                   	pop    %esi
  8023a1:	5d                   	pop    %ebp
  8023a2:	c3                   	ret    
		if(from_env_store)
  8023a3:	85 f6                	test   %esi,%esi
  8023a5:	74 06                	je     8023ad <ipc_recv+0x5d>
			*from_env_store = 0;
  8023a7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8023ad:	85 db                	test   %ebx,%ebx
  8023af:	74 eb                	je     80239c <ipc_recv+0x4c>
			*perm_store = 0;
  8023b1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8023b7:	eb e3                	jmp    80239c <ipc_recv+0x4c>

008023b9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8023b9:	55                   	push   %ebp
  8023ba:	89 e5                	mov    %esp,%ebp
  8023bc:	57                   	push   %edi
  8023bd:	56                   	push   %esi
  8023be:	53                   	push   %ebx
  8023bf:	83 ec 0c             	sub    $0xc,%esp
  8023c2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8023c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8023cb:	85 db                	test   %ebx,%ebx
  8023cd:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8023d2:	0f 44 d8             	cmove  %eax,%ebx
  8023d5:	eb 05                	jmp    8023dc <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8023d7:	e8 f6 e9 ff ff       	call   800dd2 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8023dc:	ff 75 14             	pushl  0x14(%ebp)
  8023df:	53                   	push   %ebx
  8023e0:	56                   	push   %esi
  8023e1:	57                   	push   %edi
  8023e2:	e8 97 eb ff ff       	call   800f7e <sys_ipc_try_send>
  8023e7:	83 c4 10             	add    $0x10,%esp
  8023ea:	85 c0                	test   %eax,%eax
  8023ec:	74 1b                	je     802409 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8023ee:	79 e7                	jns    8023d7 <ipc_send+0x1e>
  8023f0:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8023f3:	74 e2                	je     8023d7 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8023f5:	83 ec 04             	sub    $0x4,%esp
  8023f8:	68 5f 2c 80 00       	push   $0x802c5f
  8023fd:	6a 46                	push   $0x46
  8023ff:	68 74 2c 80 00       	push   $0x802c74
  802404:	e8 a1 dd ff ff       	call   8001aa <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802409:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80240c:	5b                   	pop    %ebx
  80240d:	5e                   	pop    %esi
  80240e:	5f                   	pop    %edi
  80240f:	5d                   	pop    %ebp
  802410:	c3                   	ret    

00802411 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
  802414:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802417:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80241c:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802422:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802428:	8b 52 50             	mov    0x50(%edx),%edx
  80242b:	39 ca                	cmp    %ecx,%edx
  80242d:	74 11                	je     802440 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80242f:	83 c0 01             	add    $0x1,%eax
  802432:	3d 00 04 00 00       	cmp    $0x400,%eax
  802437:	75 e3                	jne    80241c <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802439:	b8 00 00 00 00       	mov    $0x0,%eax
  80243e:	eb 0e                	jmp    80244e <ipc_find_env+0x3d>
			return envs[i].env_id;
  802440:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802446:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80244b:	8b 40 48             	mov    0x48(%eax),%eax
}
  80244e:	5d                   	pop    %ebp
  80244f:	c3                   	ret    

00802450 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802450:	55                   	push   %ebp
  802451:	89 e5                	mov    %esp,%ebp
  802453:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802456:	89 d0                	mov    %edx,%eax
  802458:	c1 e8 16             	shr    $0x16,%eax
  80245b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802462:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802467:	f6 c1 01             	test   $0x1,%cl
  80246a:	74 1d                	je     802489 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80246c:	c1 ea 0c             	shr    $0xc,%edx
  80246f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802476:	f6 c2 01             	test   $0x1,%dl
  802479:	74 0e                	je     802489 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80247b:	c1 ea 0c             	shr    $0xc,%edx
  80247e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802485:	ef 
  802486:	0f b7 c0             	movzwl %ax,%eax
}
  802489:	5d                   	pop    %ebp
  80248a:	c3                   	ret    
  80248b:	66 90                	xchg   %ax,%ax
  80248d:	66 90                	xchg   %ax,%ax
  80248f:	90                   	nop

00802490 <__udivdi3>:
  802490:	55                   	push   %ebp
  802491:	57                   	push   %edi
  802492:	56                   	push   %esi
  802493:	53                   	push   %ebx
  802494:	83 ec 1c             	sub    $0x1c,%esp
  802497:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80249b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80249f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8024a3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8024a7:	85 d2                	test   %edx,%edx
  8024a9:	75 4d                	jne    8024f8 <__udivdi3+0x68>
  8024ab:	39 f3                	cmp    %esi,%ebx
  8024ad:	76 19                	jbe    8024c8 <__udivdi3+0x38>
  8024af:	31 ff                	xor    %edi,%edi
  8024b1:	89 e8                	mov    %ebp,%eax
  8024b3:	89 f2                	mov    %esi,%edx
  8024b5:	f7 f3                	div    %ebx
  8024b7:	89 fa                	mov    %edi,%edx
  8024b9:	83 c4 1c             	add    $0x1c,%esp
  8024bc:	5b                   	pop    %ebx
  8024bd:	5e                   	pop    %esi
  8024be:	5f                   	pop    %edi
  8024bf:	5d                   	pop    %ebp
  8024c0:	c3                   	ret    
  8024c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024c8:	89 d9                	mov    %ebx,%ecx
  8024ca:	85 db                	test   %ebx,%ebx
  8024cc:	75 0b                	jne    8024d9 <__udivdi3+0x49>
  8024ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8024d3:	31 d2                	xor    %edx,%edx
  8024d5:	f7 f3                	div    %ebx
  8024d7:	89 c1                	mov    %eax,%ecx
  8024d9:	31 d2                	xor    %edx,%edx
  8024db:	89 f0                	mov    %esi,%eax
  8024dd:	f7 f1                	div    %ecx
  8024df:	89 c6                	mov    %eax,%esi
  8024e1:	89 e8                	mov    %ebp,%eax
  8024e3:	89 f7                	mov    %esi,%edi
  8024e5:	f7 f1                	div    %ecx
  8024e7:	89 fa                	mov    %edi,%edx
  8024e9:	83 c4 1c             	add    $0x1c,%esp
  8024ec:	5b                   	pop    %ebx
  8024ed:	5e                   	pop    %esi
  8024ee:	5f                   	pop    %edi
  8024ef:	5d                   	pop    %ebp
  8024f0:	c3                   	ret    
  8024f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024f8:	39 f2                	cmp    %esi,%edx
  8024fa:	77 1c                	ja     802518 <__udivdi3+0x88>
  8024fc:	0f bd fa             	bsr    %edx,%edi
  8024ff:	83 f7 1f             	xor    $0x1f,%edi
  802502:	75 2c                	jne    802530 <__udivdi3+0xa0>
  802504:	39 f2                	cmp    %esi,%edx
  802506:	72 06                	jb     80250e <__udivdi3+0x7e>
  802508:	31 c0                	xor    %eax,%eax
  80250a:	39 eb                	cmp    %ebp,%ebx
  80250c:	77 a9                	ja     8024b7 <__udivdi3+0x27>
  80250e:	b8 01 00 00 00       	mov    $0x1,%eax
  802513:	eb a2                	jmp    8024b7 <__udivdi3+0x27>
  802515:	8d 76 00             	lea    0x0(%esi),%esi
  802518:	31 ff                	xor    %edi,%edi
  80251a:	31 c0                	xor    %eax,%eax
  80251c:	89 fa                	mov    %edi,%edx
  80251e:	83 c4 1c             	add    $0x1c,%esp
  802521:	5b                   	pop    %ebx
  802522:	5e                   	pop    %esi
  802523:	5f                   	pop    %edi
  802524:	5d                   	pop    %ebp
  802525:	c3                   	ret    
  802526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80252d:	8d 76 00             	lea    0x0(%esi),%esi
  802530:	89 f9                	mov    %edi,%ecx
  802532:	b8 20 00 00 00       	mov    $0x20,%eax
  802537:	29 f8                	sub    %edi,%eax
  802539:	d3 e2                	shl    %cl,%edx
  80253b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80253f:	89 c1                	mov    %eax,%ecx
  802541:	89 da                	mov    %ebx,%edx
  802543:	d3 ea                	shr    %cl,%edx
  802545:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802549:	09 d1                	or     %edx,%ecx
  80254b:	89 f2                	mov    %esi,%edx
  80254d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802551:	89 f9                	mov    %edi,%ecx
  802553:	d3 e3                	shl    %cl,%ebx
  802555:	89 c1                	mov    %eax,%ecx
  802557:	d3 ea                	shr    %cl,%edx
  802559:	89 f9                	mov    %edi,%ecx
  80255b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80255f:	89 eb                	mov    %ebp,%ebx
  802561:	d3 e6                	shl    %cl,%esi
  802563:	89 c1                	mov    %eax,%ecx
  802565:	d3 eb                	shr    %cl,%ebx
  802567:	09 de                	or     %ebx,%esi
  802569:	89 f0                	mov    %esi,%eax
  80256b:	f7 74 24 08          	divl   0x8(%esp)
  80256f:	89 d6                	mov    %edx,%esi
  802571:	89 c3                	mov    %eax,%ebx
  802573:	f7 64 24 0c          	mull   0xc(%esp)
  802577:	39 d6                	cmp    %edx,%esi
  802579:	72 15                	jb     802590 <__udivdi3+0x100>
  80257b:	89 f9                	mov    %edi,%ecx
  80257d:	d3 e5                	shl    %cl,%ebp
  80257f:	39 c5                	cmp    %eax,%ebp
  802581:	73 04                	jae    802587 <__udivdi3+0xf7>
  802583:	39 d6                	cmp    %edx,%esi
  802585:	74 09                	je     802590 <__udivdi3+0x100>
  802587:	89 d8                	mov    %ebx,%eax
  802589:	31 ff                	xor    %edi,%edi
  80258b:	e9 27 ff ff ff       	jmp    8024b7 <__udivdi3+0x27>
  802590:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802593:	31 ff                	xor    %edi,%edi
  802595:	e9 1d ff ff ff       	jmp    8024b7 <__udivdi3+0x27>
  80259a:	66 90                	xchg   %ax,%ax
  80259c:	66 90                	xchg   %ax,%ax
  80259e:	66 90                	xchg   %ax,%ax

008025a0 <__umoddi3>:
  8025a0:	55                   	push   %ebp
  8025a1:	57                   	push   %edi
  8025a2:	56                   	push   %esi
  8025a3:	53                   	push   %ebx
  8025a4:	83 ec 1c             	sub    $0x1c,%esp
  8025a7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8025ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8025af:	8b 74 24 30          	mov    0x30(%esp),%esi
  8025b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8025b7:	89 da                	mov    %ebx,%edx
  8025b9:	85 c0                	test   %eax,%eax
  8025bb:	75 43                	jne    802600 <__umoddi3+0x60>
  8025bd:	39 df                	cmp    %ebx,%edi
  8025bf:	76 17                	jbe    8025d8 <__umoddi3+0x38>
  8025c1:	89 f0                	mov    %esi,%eax
  8025c3:	f7 f7                	div    %edi
  8025c5:	89 d0                	mov    %edx,%eax
  8025c7:	31 d2                	xor    %edx,%edx
  8025c9:	83 c4 1c             	add    $0x1c,%esp
  8025cc:	5b                   	pop    %ebx
  8025cd:	5e                   	pop    %esi
  8025ce:	5f                   	pop    %edi
  8025cf:	5d                   	pop    %ebp
  8025d0:	c3                   	ret    
  8025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025d8:	89 fd                	mov    %edi,%ebp
  8025da:	85 ff                	test   %edi,%edi
  8025dc:	75 0b                	jne    8025e9 <__umoddi3+0x49>
  8025de:	b8 01 00 00 00       	mov    $0x1,%eax
  8025e3:	31 d2                	xor    %edx,%edx
  8025e5:	f7 f7                	div    %edi
  8025e7:	89 c5                	mov    %eax,%ebp
  8025e9:	89 d8                	mov    %ebx,%eax
  8025eb:	31 d2                	xor    %edx,%edx
  8025ed:	f7 f5                	div    %ebp
  8025ef:	89 f0                	mov    %esi,%eax
  8025f1:	f7 f5                	div    %ebp
  8025f3:	89 d0                	mov    %edx,%eax
  8025f5:	eb d0                	jmp    8025c7 <__umoddi3+0x27>
  8025f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025fe:	66 90                	xchg   %ax,%ax
  802600:	89 f1                	mov    %esi,%ecx
  802602:	39 d8                	cmp    %ebx,%eax
  802604:	76 0a                	jbe    802610 <__umoddi3+0x70>
  802606:	89 f0                	mov    %esi,%eax
  802608:	83 c4 1c             	add    $0x1c,%esp
  80260b:	5b                   	pop    %ebx
  80260c:	5e                   	pop    %esi
  80260d:	5f                   	pop    %edi
  80260e:	5d                   	pop    %ebp
  80260f:	c3                   	ret    
  802610:	0f bd e8             	bsr    %eax,%ebp
  802613:	83 f5 1f             	xor    $0x1f,%ebp
  802616:	75 20                	jne    802638 <__umoddi3+0x98>
  802618:	39 d8                	cmp    %ebx,%eax
  80261a:	0f 82 b0 00 00 00    	jb     8026d0 <__umoddi3+0x130>
  802620:	39 f7                	cmp    %esi,%edi
  802622:	0f 86 a8 00 00 00    	jbe    8026d0 <__umoddi3+0x130>
  802628:	89 c8                	mov    %ecx,%eax
  80262a:	83 c4 1c             	add    $0x1c,%esp
  80262d:	5b                   	pop    %ebx
  80262e:	5e                   	pop    %esi
  80262f:	5f                   	pop    %edi
  802630:	5d                   	pop    %ebp
  802631:	c3                   	ret    
  802632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802638:	89 e9                	mov    %ebp,%ecx
  80263a:	ba 20 00 00 00       	mov    $0x20,%edx
  80263f:	29 ea                	sub    %ebp,%edx
  802641:	d3 e0                	shl    %cl,%eax
  802643:	89 44 24 08          	mov    %eax,0x8(%esp)
  802647:	89 d1                	mov    %edx,%ecx
  802649:	89 f8                	mov    %edi,%eax
  80264b:	d3 e8                	shr    %cl,%eax
  80264d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802651:	89 54 24 04          	mov    %edx,0x4(%esp)
  802655:	8b 54 24 04          	mov    0x4(%esp),%edx
  802659:	09 c1                	or     %eax,%ecx
  80265b:	89 d8                	mov    %ebx,%eax
  80265d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802661:	89 e9                	mov    %ebp,%ecx
  802663:	d3 e7                	shl    %cl,%edi
  802665:	89 d1                	mov    %edx,%ecx
  802667:	d3 e8                	shr    %cl,%eax
  802669:	89 e9                	mov    %ebp,%ecx
  80266b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80266f:	d3 e3                	shl    %cl,%ebx
  802671:	89 c7                	mov    %eax,%edi
  802673:	89 d1                	mov    %edx,%ecx
  802675:	89 f0                	mov    %esi,%eax
  802677:	d3 e8                	shr    %cl,%eax
  802679:	89 e9                	mov    %ebp,%ecx
  80267b:	89 fa                	mov    %edi,%edx
  80267d:	d3 e6                	shl    %cl,%esi
  80267f:	09 d8                	or     %ebx,%eax
  802681:	f7 74 24 08          	divl   0x8(%esp)
  802685:	89 d1                	mov    %edx,%ecx
  802687:	89 f3                	mov    %esi,%ebx
  802689:	f7 64 24 0c          	mull   0xc(%esp)
  80268d:	89 c6                	mov    %eax,%esi
  80268f:	89 d7                	mov    %edx,%edi
  802691:	39 d1                	cmp    %edx,%ecx
  802693:	72 06                	jb     80269b <__umoddi3+0xfb>
  802695:	75 10                	jne    8026a7 <__umoddi3+0x107>
  802697:	39 c3                	cmp    %eax,%ebx
  802699:	73 0c                	jae    8026a7 <__umoddi3+0x107>
  80269b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80269f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8026a3:	89 d7                	mov    %edx,%edi
  8026a5:	89 c6                	mov    %eax,%esi
  8026a7:	89 ca                	mov    %ecx,%edx
  8026a9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026ae:	29 f3                	sub    %esi,%ebx
  8026b0:	19 fa                	sbb    %edi,%edx
  8026b2:	89 d0                	mov    %edx,%eax
  8026b4:	d3 e0                	shl    %cl,%eax
  8026b6:	89 e9                	mov    %ebp,%ecx
  8026b8:	d3 eb                	shr    %cl,%ebx
  8026ba:	d3 ea                	shr    %cl,%edx
  8026bc:	09 d8                	or     %ebx,%eax
  8026be:	83 c4 1c             	add    $0x1c,%esp
  8026c1:	5b                   	pop    %ebx
  8026c2:	5e                   	pop    %esi
  8026c3:	5f                   	pop    %edi
  8026c4:	5d                   	pop    %ebp
  8026c5:	c3                   	ret    
  8026c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026cd:	8d 76 00             	lea    0x0(%esi),%esi
  8026d0:	89 da                	mov    %ebx,%edx
  8026d2:	29 fe                	sub    %edi,%esi
  8026d4:	19 c2                	sbb    %eax,%edx
  8026d6:	89 f1                	mov    %esi,%ecx
  8026d8:	89 c8                	mov    %ecx,%eax
  8026da:	e9 4b ff ff ff       	jmp    80262a <__umoddi3+0x8a>
