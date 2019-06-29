
obj/user/faultalloc.debug:     file format elf32-i386


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
  80002c:	e8 99 00 00 00       	call   8000ca <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80003a:	8b 45 08             	mov    0x8(%ebp),%eax
  80003d:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  80003f:	53                   	push   %ebx
  800040:	68 00 26 80 00       	push   $0x802600
  800045:	e8 f3 01 00 00       	call   80023d <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004a:	83 c4 0c             	add    $0xc,%esp
  80004d:	6a 07                	push   $0x7
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	50                   	push   %eax
  800057:	6a 00                	push   $0x0
  800059:	e8 30 0d 00 00       	call   800d8e <sys_page_alloc>
  80005e:	83 c4 10             	add    $0x10,%esp
  800061:	85 c0                	test   %eax,%eax
  800063:	78 16                	js     80007b <handler+0x48>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800065:	53                   	push   %ebx
  800066:	68 48 26 80 00       	push   $0x802648
  80006b:	6a 64                	push   $0x64
  80006d:	53                   	push   %ebx
  80006e:	e8 d6 08 00 00       	call   800949 <snprintf>
}
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800079:	c9                   	leave  
  80007a:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007b:	83 ec 0c             	sub    $0xc,%esp
  80007e:	50                   	push   %eax
  80007f:	53                   	push   %ebx
  800080:	68 1c 26 80 00       	push   $0x80261c
  800085:	6a 0e                	push   $0xe
  800087:	68 0a 26 80 00       	push   $0x80260a
  80008c:	e8 b6 00 00 00       	call   800147 <_panic>

00800091 <umain>:

void
umain(int argc, char **argv)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800097:	68 33 00 80 00       	push   $0x800033
  80009c:	e8 e2 0f 00 00       	call   801083 <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	68 ef be ad de       	push   $0xdeadbeef
  8000a9:	68 7a 26 80 00       	push   $0x80267a
  8000ae:	e8 8a 01 00 00       	call   80023d <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000b3:	83 c4 08             	add    $0x8,%esp
  8000b6:	68 fe bf fe ca       	push   $0xcafebffe
  8000bb:	68 7a 26 80 00       	push   $0x80267a
  8000c0:	e8 78 01 00 00       	call   80023d <cprintf>
}
  8000c5:	83 c4 10             	add    $0x10,%esp
  8000c8:	c9                   	leave  
  8000c9:	c3                   	ret    

008000ca <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000ca:	55                   	push   %ebp
  8000cb:	89 e5                	mov    %esp,%ebp
  8000cd:	56                   	push   %esi
  8000ce:	53                   	push   %ebx
  8000cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000d2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  8000d5:	e8 76 0c 00 00       	call   800d50 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  8000da:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000df:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8000e5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000ea:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ef:	85 db                	test   %ebx,%ebx
  8000f1:	7e 07                	jle    8000fa <libmain+0x30>
		binaryname = argv[0];
  8000f3:	8b 06                	mov    (%esi),%eax
  8000f5:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000fa:	83 ec 08             	sub    $0x8,%esp
  8000fd:	56                   	push   %esi
  8000fe:	53                   	push   %ebx
  8000ff:	e8 8d ff ff ff       	call   800091 <umain>

	// exit gracefully
	exit();
  800104:	e8 0a 00 00 00       	call   800113 <exit>
}
  800109:	83 c4 10             	add    $0x10,%esp
  80010c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80010f:	5b                   	pop    %ebx
  800110:	5e                   	pop    %esi
  800111:	5d                   	pop    %ebp
  800112:	c3                   	ret    

00800113 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800113:	55                   	push   %ebp
  800114:	89 e5                	mov    %esp,%ebp
  800116:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800119:	a1 08 40 80 00       	mov    0x804008,%eax
  80011e:	8b 40 48             	mov    0x48(%eax),%eax
  800121:	68 80 26 80 00       	push   $0x802680
  800126:	50                   	push   %eax
  800127:	68 73 26 80 00       	push   $0x802673
  80012c:	e8 0c 01 00 00       	call   80023d <cprintf>
	close_all();
  800131:	e8 ba 11 00 00       	call   8012f0 <close_all>
	sys_env_destroy(0);
  800136:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80013d:	e8 cd 0b 00 00       	call   800d0f <sys_env_destroy>
}
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	c9                   	leave  
  800146:	c3                   	ret    

00800147 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800147:	55                   	push   %ebp
  800148:	89 e5                	mov    %esp,%ebp
  80014a:	56                   	push   %esi
  80014b:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80014c:	a1 08 40 80 00       	mov    0x804008,%eax
  800151:	8b 40 48             	mov    0x48(%eax),%eax
  800154:	83 ec 04             	sub    $0x4,%esp
  800157:	68 ac 26 80 00       	push   $0x8026ac
  80015c:	50                   	push   %eax
  80015d:	68 73 26 80 00       	push   $0x802673
  800162:	e8 d6 00 00 00       	call   80023d <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800167:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80016a:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800170:	e8 db 0b 00 00       	call   800d50 <sys_getenvid>
  800175:	83 c4 04             	add    $0x4,%esp
  800178:	ff 75 0c             	pushl  0xc(%ebp)
  80017b:	ff 75 08             	pushl  0x8(%ebp)
  80017e:	56                   	push   %esi
  80017f:	50                   	push   %eax
  800180:	68 88 26 80 00       	push   $0x802688
  800185:	e8 b3 00 00 00       	call   80023d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80018a:	83 c4 18             	add    $0x18,%esp
  80018d:	53                   	push   %ebx
  80018e:	ff 75 10             	pushl  0x10(%ebp)
  800191:	e8 56 00 00 00       	call   8001ec <vcprintf>
	cprintf("\n");
  800196:	c7 04 24 2a 2c 80 00 	movl   $0x802c2a,(%esp)
  80019d:	e8 9b 00 00 00       	call   80023d <cprintf>
  8001a2:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001a5:	cc                   	int3   
  8001a6:	eb fd                	jmp    8001a5 <_panic+0x5e>

008001a8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001a8:	55                   	push   %ebp
  8001a9:	89 e5                	mov    %esp,%ebp
  8001ab:	53                   	push   %ebx
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001b2:	8b 13                	mov    (%ebx),%edx
  8001b4:	8d 42 01             	lea    0x1(%edx),%eax
  8001b7:	89 03                	mov    %eax,(%ebx)
  8001b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001bc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001c0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c5:	74 09                	je     8001d0 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001c7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001ce:	c9                   	leave  
  8001cf:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001d0:	83 ec 08             	sub    $0x8,%esp
  8001d3:	68 ff 00 00 00       	push   $0xff
  8001d8:	8d 43 08             	lea    0x8(%ebx),%eax
  8001db:	50                   	push   %eax
  8001dc:	e8 f1 0a 00 00       	call   800cd2 <sys_cputs>
		b->idx = 0;
  8001e1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001e7:	83 c4 10             	add    $0x10,%esp
  8001ea:	eb db                	jmp    8001c7 <putch+0x1f>

008001ec <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001f5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001fc:	00 00 00 
	b.cnt = 0;
  8001ff:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800206:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800209:	ff 75 0c             	pushl  0xc(%ebp)
  80020c:	ff 75 08             	pushl  0x8(%ebp)
  80020f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800215:	50                   	push   %eax
  800216:	68 a8 01 80 00       	push   $0x8001a8
  80021b:	e8 4a 01 00 00       	call   80036a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800220:	83 c4 08             	add    $0x8,%esp
  800223:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800229:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80022f:	50                   	push   %eax
  800230:	e8 9d 0a 00 00       	call   800cd2 <sys_cputs>

	return b.cnt;
}
  800235:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80023b:	c9                   	leave  
  80023c:	c3                   	ret    

0080023d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80023d:	55                   	push   %ebp
  80023e:	89 e5                	mov    %esp,%ebp
  800240:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800243:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800246:	50                   	push   %eax
  800247:	ff 75 08             	pushl  0x8(%ebp)
  80024a:	e8 9d ff ff ff       	call   8001ec <vcprintf>
	va_end(ap);

	return cnt;
}
  80024f:	c9                   	leave  
  800250:	c3                   	ret    

00800251 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800251:	55                   	push   %ebp
  800252:	89 e5                	mov    %esp,%ebp
  800254:	57                   	push   %edi
  800255:	56                   	push   %esi
  800256:	53                   	push   %ebx
  800257:	83 ec 1c             	sub    $0x1c,%esp
  80025a:	89 c6                	mov    %eax,%esi
  80025c:	89 d7                	mov    %edx,%edi
  80025e:	8b 45 08             	mov    0x8(%ebp),%eax
  800261:	8b 55 0c             	mov    0xc(%ebp),%edx
  800264:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800267:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80026a:	8b 45 10             	mov    0x10(%ebp),%eax
  80026d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800270:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800274:	74 2c                	je     8002a2 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800276:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800279:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800280:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800283:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800286:	39 c2                	cmp    %eax,%edx
  800288:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80028b:	73 43                	jae    8002d0 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80028d:	83 eb 01             	sub    $0x1,%ebx
  800290:	85 db                	test   %ebx,%ebx
  800292:	7e 6c                	jle    800300 <printnum+0xaf>
				putch(padc, putdat);
  800294:	83 ec 08             	sub    $0x8,%esp
  800297:	57                   	push   %edi
  800298:	ff 75 18             	pushl  0x18(%ebp)
  80029b:	ff d6                	call   *%esi
  80029d:	83 c4 10             	add    $0x10,%esp
  8002a0:	eb eb                	jmp    80028d <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002a2:	83 ec 0c             	sub    $0xc,%esp
  8002a5:	6a 20                	push   $0x20
  8002a7:	6a 00                	push   $0x0
  8002a9:	50                   	push   %eax
  8002aa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ad:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b0:	89 fa                	mov    %edi,%edx
  8002b2:	89 f0                	mov    %esi,%eax
  8002b4:	e8 98 ff ff ff       	call   800251 <printnum>
		while (--width > 0)
  8002b9:	83 c4 20             	add    $0x20,%esp
  8002bc:	83 eb 01             	sub    $0x1,%ebx
  8002bf:	85 db                	test   %ebx,%ebx
  8002c1:	7e 65                	jle    800328 <printnum+0xd7>
			putch(padc, putdat);
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	57                   	push   %edi
  8002c7:	6a 20                	push   $0x20
  8002c9:	ff d6                	call   *%esi
  8002cb:	83 c4 10             	add    $0x10,%esp
  8002ce:	eb ec                	jmp    8002bc <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	ff 75 18             	pushl  0x18(%ebp)
  8002d6:	83 eb 01             	sub    $0x1,%ebx
  8002d9:	53                   	push   %ebx
  8002da:	50                   	push   %eax
  8002db:	83 ec 08             	sub    $0x8,%esp
  8002de:	ff 75 dc             	pushl  -0x24(%ebp)
  8002e1:	ff 75 d8             	pushl  -0x28(%ebp)
  8002e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e7:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ea:	e8 c1 20 00 00       	call   8023b0 <__udivdi3>
  8002ef:	83 c4 18             	add    $0x18,%esp
  8002f2:	52                   	push   %edx
  8002f3:	50                   	push   %eax
  8002f4:	89 fa                	mov    %edi,%edx
  8002f6:	89 f0                	mov    %esi,%eax
  8002f8:	e8 54 ff ff ff       	call   800251 <printnum>
  8002fd:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800300:	83 ec 08             	sub    $0x8,%esp
  800303:	57                   	push   %edi
  800304:	83 ec 04             	sub    $0x4,%esp
  800307:	ff 75 dc             	pushl  -0x24(%ebp)
  80030a:	ff 75 d8             	pushl  -0x28(%ebp)
  80030d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800310:	ff 75 e0             	pushl  -0x20(%ebp)
  800313:	e8 a8 21 00 00       	call   8024c0 <__umoddi3>
  800318:	83 c4 14             	add    $0x14,%esp
  80031b:	0f be 80 b3 26 80 00 	movsbl 0x8026b3(%eax),%eax
  800322:	50                   	push   %eax
  800323:	ff d6                	call   *%esi
  800325:	83 c4 10             	add    $0x10,%esp
	}
}
  800328:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032b:	5b                   	pop    %ebx
  80032c:	5e                   	pop    %esi
  80032d:	5f                   	pop    %edi
  80032e:	5d                   	pop    %ebp
  80032f:	c3                   	ret    

00800330 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800330:	55                   	push   %ebp
  800331:	89 e5                	mov    %esp,%ebp
  800333:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800336:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80033a:	8b 10                	mov    (%eax),%edx
  80033c:	3b 50 04             	cmp    0x4(%eax),%edx
  80033f:	73 0a                	jae    80034b <sprintputch+0x1b>
		*b->buf++ = ch;
  800341:	8d 4a 01             	lea    0x1(%edx),%ecx
  800344:	89 08                	mov    %ecx,(%eax)
  800346:	8b 45 08             	mov    0x8(%ebp),%eax
  800349:	88 02                	mov    %al,(%edx)
}
  80034b:	5d                   	pop    %ebp
  80034c:	c3                   	ret    

0080034d <printfmt>:
{
  80034d:	55                   	push   %ebp
  80034e:	89 e5                	mov    %esp,%ebp
  800350:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800353:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800356:	50                   	push   %eax
  800357:	ff 75 10             	pushl  0x10(%ebp)
  80035a:	ff 75 0c             	pushl  0xc(%ebp)
  80035d:	ff 75 08             	pushl  0x8(%ebp)
  800360:	e8 05 00 00 00       	call   80036a <vprintfmt>
}
  800365:	83 c4 10             	add    $0x10,%esp
  800368:	c9                   	leave  
  800369:	c3                   	ret    

0080036a <vprintfmt>:
{
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
  80036d:	57                   	push   %edi
  80036e:	56                   	push   %esi
  80036f:	53                   	push   %ebx
  800370:	83 ec 3c             	sub    $0x3c,%esp
  800373:	8b 75 08             	mov    0x8(%ebp),%esi
  800376:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800379:	8b 7d 10             	mov    0x10(%ebp),%edi
  80037c:	e9 32 04 00 00       	jmp    8007b3 <vprintfmt+0x449>
		padc = ' ';
  800381:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800385:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80038c:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800393:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80039a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003a1:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003a8:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003ad:	8d 47 01             	lea    0x1(%edi),%eax
  8003b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003b3:	0f b6 17             	movzbl (%edi),%edx
  8003b6:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003b9:	3c 55                	cmp    $0x55,%al
  8003bb:	0f 87 12 05 00 00    	ja     8008d3 <vprintfmt+0x569>
  8003c1:	0f b6 c0             	movzbl %al,%eax
  8003c4:	ff 24 85 a0 28 80 00 	jmp    *0x8028a0(,%eax,4)
  8003cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003ce:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003d2:	eb d9                	jmp    8003ad <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003d7:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003db:	eb d0                	jmp    8003ad <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003dd:	0f b6 d2             	movzbl %dl,%edx
  8003e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e8:	89 75 08             	mov    %esi,0x8(%ebp)
  8003eb:	eb 03                	jmp    8003f0 <vprintfmt+0x86>
  8003ed:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003f0:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003f3:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003f7:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003fa:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003fd:	83 fe 09             	cmp    $0x9,%esi
  800400:	76 eb                	jbe    8003ed <vprintfmt+0x83>
  800402:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800405:	8b 75 08             	mov    0x8(%ebp),%esi
  800408:	eb 14                	jmp    80041e <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80040a:	8b 45 14             	mov    0x14(%ebp),%eax
  80040d:	8b 00                	mov    (%eax),%eax
  80040f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800412:	8b 45 14             	mov    0x14(%ebp),%eax
  800415:	8d 40 04             	lea    0x4(%eax),%eax
  800418:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80041b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80041e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800422:	79 89                	jns    8003ad <vprintfmt+0x43>
				width = precision, precision = -1;
  800424:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800427:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80042a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800431:	e9 77 ff ff ff       	jmp    8003ad <vprintfmt+0x43>
  800436:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800439:	85 c0                	test   %eax,%eax
  80043b:	0f 48 c1             	cmovs  %ecx,%eax
  80043e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800441:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800444:	e9 64 ff ff ff       	jmp    8003ad <vprintfmt+0x43>
  800449:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80044c:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800453:	e9 55 ff ff ff       	jmp    8003ad <vprintfmt+0x43>
			lflag++;
  800458:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80045c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80045f:	e9 49 ff ff ff       	jmp    8003ad <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800464:	8b 45 14             	mov    0x14(%ebp),%eax
  800467:	8d 78 04             	lea    0x4(%eax),%edi
  80046a:	83 ec 08             	sub    $0x8,%esp
  80046d:	53                   	push   %ebx
  80046e:	ff 30                	pushl  (%eax)
  800470:	ff d6                	call   *%esi
			break;
  800472:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800475:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800478:	e9 33 03 00 00       	jmp    8007b0 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80047d:	8b 45 14             	mov    0x14(%ebp),%eax
  800480:	8d 78 04             	lea    0x4(%eax),%edi
  800483:	8b 00                	mov    (%eax),%eax
  800485:	99                   	cltd   
  800486:	31 d0                	xor    %edx,%eax
  800488:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80048a:	83 f8 11             	cmp    $0x11,%eax
  80048d:	7f 23                	jg     8004b2 <vprintfmt+0x148>
  80048f:	8b 14 85 00 2a 80 00 	mov    0x802a00(,%eax,4),%edx
  800496:	85 d2                	test   %edx,%edx
  800498:	74 18                	je     8004b2 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80049a:	52                   	push   %edx
  80049b:	68 99 2b 80 00       	push   $0x802b99
  8004a0:	53                   	push   %ebx
  8004a1:	56                   	push   %esi
  8004a2:	e8 a6 fe ff ff       	call   80034d <printfmt>
  8004a7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004aa:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004ad:	e9 fe 02 00 00       	jmp    8007b0 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004b2:	50                   	push   %eax
  8004b3:	68 cb 26 80 00       	push   $0x8026cb
  8004b8:	53                   	push   %ebx
  8004b9:	56                   	push   %esi
  8004ba:	e8 8e fe ff ff       	call   80034d <printfmt>
  8004bf:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004c2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004c5:	e9 e6 02 00 00       	jmp    8007b0 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cd:	83 c0 04             	add    $0x4,%eax
  8004d0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d6:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004d8:	85 c9                	test   %ecx,%ecx
  8004da:	b8 c4 26 80 00       	mov    $0x8026c4,%eax
  8004df:	0f 45 c1             	cmovne %ecx,%eax
  8004e2:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004e9:	7e 06                	jle    8004f1 <vprintfmt+0x187>
  8004eb:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004ef:	75 0d                	jne    8004fe <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004f4:	89 c7                	mov    %eax,%edi
  8004f6:	03 45 e0             	add    -0x20(%ebp),%eax
  8004f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004fc:	eb 53                	jmp    800551 <vprintfmt+0x1e7>
  8004fe:	83 ec 08             	sub    $0x8,%esp
  800501:	ff 75 d8             	pushl  -0x28(%ebp)
  800504:	50                   	push   %eax
  800505:	e8 71 04 00 00       	call   80097b <strnlen>
  80050a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80050d:	29 c1                	sub    %eax,%ecx
  80050f:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800512:	83 c4 10             	add    $0x10,%esp
  800515:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800517:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80051b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80051e:	eb 0f                	jmp    80052f <vprintfmt+0x1c5>
					putch(padc, putdat);
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	53                   	push   %ebx
  800524:	ff 75 e0             	pushl  -0x20(%ebp)
  800527:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800529:	83 ef 01             	sub    $0x1,%edi
  80052c:	83 c4 10             	add    $0x10,%esp
  80052f:	85 ff                	test   %edi,%edi
  800531:	7f ed                	jg     800520 <vprintfmt+0x1b6>
  800533:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800536:	85 c9                	test   %ecx,%ecx
  800538:	b8 00 00 00 00       	mov    $0x0,%eax
  80053d:	0f 49 c1             	cmovns %ecx,%eax
  800540:	29 c1                	sub    %eax,%ecx
  800542:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800545:	eb aa                	jmp    8004f1 <vprintfmt+0x187>
					putch(ch, putdat);
  800547:	83 ec 08             	sub    $0x8,%esp
  80054a:	53                   	push   %ebx
  80054b:	52                   	push   %edx
  80054c:	ff d6                	call   *%esi
  80054e:	83 c4 10             	add    $0x10,%esp
  800551:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800554:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800556:	83 c7 01             	add    $0x1,%edi
  800559:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80055d:	0f be d0             	movsbl %al,%edx
  800560:	85 d2                	test   %edx,%edx
  800562:	74 4b                	je     8005af <vprintfmt+0x245>
  800564:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800568:	78 06                	js     800570 <vprintfmt+0x206>
  80056a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80056e:	78 1e                	js     80058e <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800570:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800574:	74 d1                	je     800547 <vprintfmt+0x1dd>
  800576:	0f be c0             	movsbl %al,%eax
  800579:	83 e8 20             	sub    $0x20,%eax
  80057c:	83 f8 5e             	cmp    $0x5e,%eax
  80057f:	76 c6                	jbe    800547 <vprintfmt+0x1dd>
					putch('?', putdat);
  800581:	83 ec 08             	sub    $0x8,%esp
  800584:	53                   	push   %ebx
  800585:	6a 3f                	push   $0x3f
  800587:	ff d6                	call   *%esi
  800589:	83 c4 10             	add    $0x10,%esp
  80058c:	eb c3                	jmp    800551 <vprintfmt+0x1e7>
  80058e:	89 cf                	mov    %ecx,%edi
  800590:	eb 0e                	jmp    8005a0 <vprintfmt+0x236>
				putch(' ', putdat);
  800592:	83 ec 08             	sub    $0x8,%esp
  800595:	53                   	push   %ebx
  800596:	6a 20                	push   $0x20
  800598:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80059a:	83 ef 01             	sub    $0x1,%edi
  80059d:	83 c4 10             	add    $0x10,%esp
  8005a0:	85 ff                	test   %edi,%edi
  8005a2:	7f ee                	jg     800592 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005a4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8005aa:	e9 01 02 00 00       	jmp    8007b0 <vprintfmt+0x446>
  8005af:	89 cf                	mov    %ecx,%edi
  8005b1:	eb ed                	jmp    8005a0 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005b6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005bd:	e9 eb fd ff ff       	jmp    8003ad <vprintfmt+0x43>
	if (lflag >= 2)
  8005c2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005c6:	7f 21                	jg     8005e9 <vprintfmt+0x27f>
	else if (lflag)
  8005c8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005cc:	74 68                	je     800636 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005d6:	89 c1                	mov    %eax,%ecx
  8005d8:	c1 f9 1f             	sar    $0x1f,%ecx
  8005db:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8d 40 04             	lea    0x4(%eax),%eax
  8005e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e7:	eb 17                	jmp    800600 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	8b 50 04             	mov    0x4(%eax),%edx
  8005ef:	8b 00                	mov    (%eax),%eax
  8005f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005f4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	8d 40 08             	lea    0x8(%eax),%eax
  8005fd:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800600:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800603:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800606:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800609:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80060c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800610:	78 3f                	js     800651 <vprintfmt+0x2e7>
			base = 10;
  800612:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800617:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80061b:	0f 84 71 01 00 00    	je     800792 <vprintfmt+0x428>
				putch('+', putdat);
  800621:	83 ec 08             	sub    $0x8,%esp
  800624:	53                   	push   %ebx
  800625:	6a 2b                	push   $0x2b
  800627:	ff d6                	call   *%esi
  800629:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80062c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800631:	e9 5c 01 00 00       	jmp    800792 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8b 00                	mov    (%eax),%eax
  80063b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80063e:	89 c1                	mov    %eax,%ecx
  800640:	c1 f9 1f             	sar    $0x1f,%ecx
  800643:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8d 40 04             	lea    0x4(%eax),%eax
  80064c:	89 45 14             	mov    %eax,0x14(%ebp)
  80064f:	eb af                	jmp    800600 <vprintfmt+0x296>
				putch('-', putdat);
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	53                   	push   %ebx
  800655:	6a 2d                	push   $0x2d
  800657:	ff d6                	call   *%esi
				num = -(long long) num;
  800659:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80065c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80065f:	f7 d8                	neg    %eax
  800661:	83 d2 00             	adc    $0x0,%edx
  800664:	f7 da                	neg    %edx
  800666:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800669:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80066c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80066f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800674:	e9 19 01 00 00       	jmp    800792 <vprintfmt+0x428>
	if (lflag >= 2)
  800679:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80067d:	7f 29                	jg     8006a8 <vprintfmt+0x33e>
	else if (lflag)
  80067f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800683:	74 44                	je     8006c9 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8b 00                	mov    (%eax),%eax
  80068a:	ba 00 00 00 00       	mov    $0x0,%edx
  80068f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800692:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8d 40 04             	lea    0x4(%eax),%eax
  80069b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80069e:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a3:	e9 ea 00 00 00       	jmp    800792 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	8b 50 04             	mov    0x4(%eax),%edx
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b9:	8d 40 08             	lea    0x8(%eax),%eax
  8006bc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006bf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c4:	e9 c9 00 00 00       	jmp    800792 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cc:	8b 00                	mov    (%eax),%eax
  8006ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dc:	8d 40 04             	lea    0x4(%eax),%eax
  8006df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006e7:	e9 a6 00 00 00       	jmp    800792 <vprintfmt+0x428>
			putch('0', putdat);
  8006ec:	83 ec 08             	sub    $0x8,%esp
  8006ef:	53                   	push   %ebx
  8006f0:	6a 30                	push   $0x30
  8006f2:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006f4:	83 c4 10             	add    $0x10,%esp
  8006f7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006fb:	7f 26                	jg     800723 <vprintfmt+0x3b9>
	else if (lflag)
  8006fd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800701:	74 3e                	je     800741 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800703:	8b 45 14             	mov    0x14(%ebp),%eax
  800706:	8b 00                	mov    (%eax),%eax
  800708:	ba 00 00 00 00       	mov    $0x0,%edx
  80070d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800710:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800713:	8b 45 14             	mov    0x14(%ebp),%eax
  800716:	8d 40 04             	lea    0x4(%eax),%eax
  800719:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80071c:	b8 08 00 00 00       	mov    $0x8,%eax
  800721:	eb 6f                	jmp    800792 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	8b 50 04             	mov    0x4(%eax),%edx
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800731:	8b 45 14             	mov    0x14(%ebp),%eax
  800734:	8d 40 08             	lea    0x8(%eax),%eax
  800737:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80073a:	b8 08 00 00 00       	mov    $0x8,%eax
  80073f:	eb 51                	jmp    800792 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	8b 00                	mov    (%eax),%eax
  800746:	ba 00 00 00 00       	mov    $0x0,%edx
  80074b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	8d 40 04             	lea    0x4(%eax),%eax
  800757:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80075a:	b8 08 00 00 00       	mov    $0x8,%eax
  80075f:	eb 31                	jmp    800792 <vprintfmt+0x428>
			putch('0', putdat);
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	53                   	push   %ebx
  800765:	6a 30                	push   $0x30
  800767:	ff d6                	call   *%esi
			putch('x', putdat);
  800769:	83 c4 08             	add    $0x8,%esp
  80076c:	53                   	push   %ebx
  80076d:	6a 78                	push   $0x78
  80076f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800771:	8b 45 14             	mov    0x14(%ebp),%eax
  800774:	8b 00                	mov    (%eax),%eax
  800776:	ba 00 00 00 00       	mov    $0x0,%edx
  80077b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800781:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800784:	8b 45 14             	mov    0x14(%ebp),%eax
  800787:	8d 40 04             	lea    0x4(%eax),%eax
  80078a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80078d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800792:	83 ec 0c             	sub    $0xc,%esp
  800795:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800799:	52                   	push   %edx
  80079a:	ff 75 e0             	pushl  -0x20(%ebp)
  80079d:	50                   	push   %eax
  80079e:	ff 75 dc             	pushl  -0x24(%ebp)
  8007a1:	ff 75 d8             	pushl  -0x28(%ebp)
  8007a4:	89 da                	mov    %ebx,%edx
  8007a6:	89 f0                	mov    %esi,%eax
  8007a8:	e8 a4 fa ff ff       	call   800251 <printnum>
			break;
  8007ad:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007b3:	83 c7 01             	add    $0x1,%edi
  8007b6:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007ba:	83 f8 25             	cmp    $0x25,%eax
  8007bd:	0f 84 be fb ff ff    	je     800381 <vprintfmt+0x17>
			if (ch == '\0')
  8007c3:	85 c0                	test   %eax,%eax
  8007c5:	0f 84 28 01 00 00    	je     8008f3 <vprintfmt+0x589>
			putch(ch, putdat);
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	53                   	push   %ebx
  8007cf:	50                   	push   %eax
  8007d0:	ff d6                	call   *%esi
  8007d2:	83 c4 10             	add    $0x10,%esp
  8007d5:	eb dc                	jmp    8007b3 <vprintfmt+0x449>
	if (lflag >= 2)
  8007d7:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007db:	7f 26                	jg     800803 <vprintfmt+0x499>
	else if (lflag)
  8007dd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007e1:	74 41                	je     800824 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e6:	8b 00                	mov    (%eax),%eax
  8007e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f6:	8d 40 04             	lea    0x4(%eax),%eax
  8007f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007fc:	b8 10 00 00 00       	mov    $0x10,%eax
  800801:	eb 8f                	jmp    800792 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800803:	8b 45 14             	mov    0x14(%ebp),%eax
  800806:	8b 50 04             	mov    0x4(%eax),%edx
  800809:	8b 00                	mov    (%eax),%eax
  80080b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800811:	8b 45 14             	mov    0x14(%ebp),%eax
  800814:	8d 40 08             	lea    0x8(%eax),%eax
  800817:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081a:	b8 10 00 00 00       	mov    $0x10,%eax
  80081f:	e9 6e ff ff ff       	jmp    800792 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	8b 00                	mov    (%eax),%eax
  800829:	ba 00 00 00 00       	mov    $0x0,%edx
  80082e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800831:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800834:	8b 45 14             	mov    0x14(%ebp),%eax
  800837:	8d 40 04             	lea    0x4(%eax),%eax
  80083a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80083d:	b8 10 00 00 00       	mov    $0x10,%eax
  800842:	e9 4b ff ff ff       	jmp    800792 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800847:	8b 45 14             	mov    0x14(%ebp),%eax
  80084a:	83 c0 04             	add    $0x4,%eax
  80084d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	8b 00                	mov    (%eax),%eax
  800855:	85 c0                	test   %eax,%eax
  800857:	74 14                	je     80086d <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800859:	8b 13                	mov    (%ebx),%edx
  80085b:	83 fa 7f             	cmp    $0x7f,%edx
  80085e:	7f 37                	jg     800897 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800860:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800862:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800865:	89 45 14             	mov    %eax,0x14(%ebp)
  800868:	e9 43 ff ff ff       	jmp    8007b0 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80086d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800872:	bf e9 27 80 00       	mov    $0x8027e9,%edi
							putch(ch, putdat);
  800877:	83 ec 08             	sub    $0x8,%esp
  80087a:	53                   	push   %ebx
  80087b:	50                   	push   %eax
  80087c:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80087e:	83 c7 01             	add    $0x1,%edi
  800881:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800885:	83 c4 10             	add    $0x10,%esp
  800888:	85 c0                	test   %eax,%eax
  80088a:	75 eb                	jne    800877 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80088c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80088f:	89 45 14             	mov    %eax,0x14(%ebp)
  800892:	e9 19 ff ff ff       	jmp    8007b0 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800897:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800899:	b8 0a 00 00 00       	mov    $0xa,%eax
  80089e:	bf 21 28 80 00       	mov    $0x802821,%edi
							putch(ch, putdat);
  8008a3:	83 ec 08             	sub    $0x8,%esp
  8008a6:	53                   	push   %ebx
  8008a7:	50                   	push   %eax
  8008a8:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008aa:	83 c7 01             	add    $0x1,%edi
  8008ad:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008b1:	83 c4 10             	add    $0x10,%esp
  8008b4:	85 c0                	test   %eax,%eax
  8008b6:	75 eb                	jne    8008a3 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008bb:	89 45 14             	mov    %eax,0x14(%ebp)
  8008be:	e9 ed fe ff ff       	jmp    8007b0 <vprintfmt+0x446>
			putch(ch, putdat);
  8008c3:	83 ec 08             	sub    $0x8,%esp
  8008c6:	53                   	push   %ebx
  8008c7:	6a 25                	push   $0x25
  8008c9:	ff d6                	call   *%esi
			break;
  8008cb:	83 c4 10             	add    $0x10,%esp
  8008ce:	e9 dd fe ff ff       	jmp    8007b0 <vprintfmt+0x446>
			putch('%', putdat);
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	53                   	push   %ebx
  8008d7:	6a 25                	push   $0x25
  8008d9:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008db:	83 c4 10             	add    $0x10,%esp
  8008de:	89 f8                	mov    %edi,%eax
  8008e0:	eb 03                	jmp    8008e5 <vprintfmt+0x57b>
  8008e2:	83 e8 01             	sub    $0x1,%eax
  8008e5:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008e9:	75 f7                	jne    8008e2 <vprintfmt+0x578>
  8008eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ee:	e9 bd fe ff ff       	jmp    8007b0 <vprintfmt+0x446>
}
  8008f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008f6:	5b                   	pop    %ebx
  8008f7:	5e                   	pop    %esi
  8008f8:	5f                   	pop    %edi
  8008f9:	5d                   	pop    %ebp
  8008fa:	c3                   	ret    

008008fb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008fb:	55                   	push   %ebp
  8008fc:	89 e5                	mov    %esp,%ebp
  8008fe:	83 ec 18             	sub    $0x18,%esp
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800907:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80090a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80090e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800911:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800918:	85 c0                	test   %eax,%eax
  80091a:	74 26                	je     800942 <vsnprintf+0x47>
  80091c:	85 d2                	test   %edx,%edx
  80091e:	7e 22                	jle    800942 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800920:	ff 75 14             	pushl  0x14(%ebp)
  800923:	ff 75 10             	pushl  0x10(%ebp)
  800926:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800929:	50                   	push   %eax
  80092a:	68 30 03 80 00       	push   $0x800330
  80092f:	e8 36 fa ff ff       	call   80036a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800934:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800937:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80093a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80093d:	83 c4 10             	add    $0x10,%esp
}
  800940:	c9                   	leave  
  800941:	c3                   	ret    
		return -E_INVAL;
  800942:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800947:	eb f7                	jmp    800940 <vsnprintf+0x45>

00800949 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80094f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800952:	50                   	push   %eax
  800953:	ff 75 10             	pushl  0x10(%ebp)
  800956:	ff 75 0c             	pushl  0xc(%ebp)
  800959:	ff 75 08             	pushl  0x8(%ebp)
  80095c:	e8 9a ff ff ff       	call   8008fb <vsnprintf>
	va_end(ap);

	return rc;
}
  800961:	c9                   	leave  
  800962:	c3                   	ret    

00800963 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800963:	55                   	push   %ebp
  800964:	89 e5                	mov    %esp,%ebp
  800966:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800969:	b8 00 00 00 00       	mov    $0x0,%eax
  80096e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800972:	74 05                	je     800979 <strlen+0x16>
		n++;
  800974:	83 c0 01             	add    $0x1,%eax
  800977:	eb f5                	jmp    80096e <strlen+0xb>
	return n;
}
  800979:	5d                   	pop    %ebp
  80097a:	c3                   	ret    

0080097b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800981:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800984:	ba 00 00 00 00       	mov    $0x0,%edx
  800989:	39 c2                	cmp    %eax,%edx
  80098b:	74 0d                	je     80099a <strnlen+0x1f>
  80098d:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800991:	74 05                	je     800998 <strnlen+0x1d>
		n++;
  800993:	83 c2 01             	add    $0x1,%edx
  800996:	eb f1                	jmp    800989 <strnlen+0xe>
  800998:	89 d0                	mov    %edx,%eax
	return n;
}
  80099a:	5d                   	pop    %ebp
  80099b:	c3                   	ret    

0080099c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	53                   	push   %ebx
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ab:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009af:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009b2:	83 c2 01             	add    $0x1,%edx
  8009b5:	84 c9                	test   %cl,%cl
  8009b7:	75 f2                	jne    8009ab <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009b9:	5b                   	pop    %ebx
  8009ba:	5d                   	pop    %ebp
  8009bb:	c3                   	ret    

008009bc <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	53                   	push   %ebx
  8009c0:	83 ec 10             	sub    $0x10,%esp
  8009c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009c6:	53                   	push   %ebx
  8009c7:	e8 97 ff ff ff       	call   800963 <strlen>
  8009cc:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009cf:	ff 75 0c             	pushl  0xc(%ebp)
  8009d2:	01 d8                	add    %ebx,%eax
  8009d4:	50                   	push   %eax
  8009d5:	e8 c2 ff ff ff       	call   80099c <strcpy>
	return dst;
}
  8009da:	89 d8                	mov    %ebx,%eax
  8009dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009df:	c9                   	leave  
  8009e0:	c3                   	ret    

008009e1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009e1:	55                   	push   %ebp
  8009e2:	89 e5                	mov    %esp,%ebp
  8009e4:	56                   	push   %esi
  8009e5:	53                   	push   %ebx
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ec:	89 c6                	mov    %eax,%esi
  8009ee:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009f1:	89 c2                	mov    %eax,%edx
  8009f3:	39 f2                	cmp    %esi,%edx
  8009f5:	74 11                	je     800a08 <strncpy+0x27>
		*dst++ = *src;
  8009f7:	83 c2 01             	add    $0x1,%edx
  8009fa:	0f b6 19             	movzbl (%ecx),%ebx
  8009fd:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a00:	80 fb 01             	cmp    $0x1,%bl
  800a03:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a06:	eb eb                	jmp    8009f3 <strncpy+0x12>
	}
	return ret;
}
  800a08:	5b                   	pop    %ebx
  800a09:	5e                   	pop    %esi
  800a0a:	5d                   	pop    %ebp
  800a0b:	c3                   	ret    

00800a0c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	56                   	push   %esi
  800a10:	53                   	push   %ebx
  800a11:	8b 75 08             	mov    0x8(%ebp),%esi
  800a14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a17:	8b 55 10             	mov    0x10(%ebp),%edx
  800a1a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a1c:	85 d2                	test   %edx,%edx
  800a1e:	74 21                	je     800a41 <strlcpy+0x35>
  800a20:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a24:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a26:	39 c2                	cmp    %eax,%edx
  800a28:	74 14                	je     800a3e <strlcpy+0x32>
  800a2a:	0f b6 19             	movzbl (%ecx),%ebx
  800a2d:	84 db                	test   %bl,%bl
  800a2f:	74 0b                	je     800a3c <strlcpy+0x30>
			*dst++ = *src++;
  800a31:	83 c1 01             	add    $0x1,%ecx
  800a34:	83 c2 01             	add    $0x1,%edx
  800a37:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a3a:	eb ea                	jmp    800a26 <strlcpy+0x1a>
  800a3c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a3e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a41:	29 f0                	sub    %esi,%eax
}
  800a43:	5b                   	pop    %ebx
  800a44:	5e                   	pop    %esi
  800a45:	5d                   	pop    %ebp
  800a46:	c3                   	ret    

00800a47 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
  800a4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a50:	0f b6 01             	movzbl (%ecx),%eax
  800a53:	84 c0                	test   %al,%al
  800a55:	74 0c                	je     800a63 <strcmp+0x1c>
  800a57:	3a 02                	cmp    (%edx),%al
  800a59:	75 08                	jne    800a63 <strcmp+0x1c>
		p++, q++;
  800a5b:	83 c1 01             	add    $0x1,%ecx
  800a5e:	83 c2 01             	add    $0x1,%edx
  800a61:	eb ed                	jmp    800a50 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a63:	0f b6 c0             	movzbl %al,%eax
  800a66:	0f b6 12             	movzbl (%edx),%edx
  800a69:	29 d0                	sub    %edx,%eax
}
  800a6b:	5d                   	pop    %ebp
  800a6c:	c3                   	ret    

00800a6d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a6d:	55                   	push   %ebp
  800a6e:	89 e5                	mov    %esp,%ebp
  800a70:	53                   	push   %ebx
  800a71:	8b 45 08             	mov    0x8(%ebp),%eax
  800a74:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a77:	89 c3                	mov    %eax,%ebx
  800a79:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a7c:	eb 06                	jmp    800a84 <strncmp+0x17>
		n--, p++, q++;
  800a7e:	83 c0 01             	add    $0x1,%eax
  800a81:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a84:	39 d8                	cmp    %ebx,%eax
  800a86:	74 16                	je     800a9e <strncmp+0x31>
  800a88:	0f b6 08             	movzbl (%eax),%ecx
  800a8b:	84 c9                	test   %cl,%cl
  800a8d:	74 04                	je     800a93 <strncmp+0x26>
  800a8f:	3a 0a                	cmp    (%edx),%cl
  800a91:	74 eb                	je     800a7e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a93:	0f b6 00             	movzbl (%eax),%eax
  800a96:	0f b6 12             	movzbl (%edx),%edx
  800a99:	29 d0                	sub    %edx,%eax
}
  800a9b:	5b                   	pop    %ebx
  800a9c:	5d                   	pop    %ebp
  800a9d:	c3                   	ret    
		return 0;
  800a9e:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa3:	eb f6                	jmp    800a9b <strncmp+0x2e>

00800aa5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aa5:	55                   	push   %ebp
  800aa6:	89 e5                	mov    %esp,%ebp
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aaf:	0f b6 10             	movzbl (%eax),%edx
  800ab2:	84 d2                	test   %dl,%dl
  800ab4:	74 09                	je     800abf <strchr+0x1a>
		if (*s == c)
  800ab6:	38 ca                	cmp    %cl,%dl
  800ab8:	74 0a                	je     800ac4 <strchr+0x1f>
	for (; *s; s++)
  800aba:	83 c0 01             	add    $0x1,%eax
  800abd:	eb f0                	jmp    800aaf <strchr+0xa>
			return (char *) s;
	return 0;
  800abf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac4:	5d                   	pop    %ebp
  800ac5:	c3                   	ret    

00800ac6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ad0:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800ad3:	38 ca                	cmp    %cl,%dl
  800ad5:	74 09                	je     800ae0 <strfind+0x1a>
  800ad7:	84 d2                	test   %dl,%dl
  800ad9:	74 05                	je     800ae0 <strfind+0x1a>
	for (; *s; s++)
  800adb:	83 c0 01             	add    $0x1,%eax
  800ade:	eb f0                	jmp    800ad0 <strfind+0xa>
			break;
	return (char *) s;
}
  800ae0:	5d                   	pop    %ebp
  800ae1:	c3                   	ret    

00800ae2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
  800ae5:	57                   	push   %edi
  800ae6:	56                   	push   %esi
  800ae7:	53                   	push   %ebx
  800ae8:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aeb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aee:	85 c9                	test   %ecx,%ecx
  800af0:	74 31                	je     800b23 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800af2:	89 f8                	mov    %edi,%eax
  800af4:	09 c8                	or     %ecx,%eax
  800af6:	a8 03                	test   $0x3,%al
  800af8:	75 23                	jne    800b1d <memset+0x3b>
		c &= 0xFF;
  800afa:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800afe:	89 d3                	mov    %edx,%ebx
  800b00:	c1 e3 08             	shl    $0x8,%ebx
  800b03:	89 d0                	mov    %edx,%eax
  800b05:	c1 e0 18             	shl    $0x18,%eax
  800b08:	89 d6                	mov    %edx,%esi
  800b0a:	c1 e6 10             	shl    $0x10,%esi
  800b0d:	09 f0                	or     %esi,%eax
  800b0f:	09 c2                	or     %eax,%edx
  800b11:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b13:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b16:	89 d0                	mov    %edx,%eax
  800b18:	fc                   	cld    
  800b19:	f3 ab                	rep stos %eax,%es:(%edi)
  800b1b:	eb 06                	jmp    800b23 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b20:	fc                   	cld    
  800b21:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b23:	89 f8                	mov    %edi,%eax
  800b25:	5b                   	pop    %ebx
  800b26:	5e                   	pop    %esi
  800b27:	5f                   	pop    %edi
  800b28:	5d                   	pop    %ebp
  800b29:	c3                   	ret    

00800b2a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	57                   	push   %edi
  800b2e:	56                   	push   %esi
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b35:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b38:	39 c6                	cmp    %eax,%esi
  800b3a:	73 32                	jae    800b6e <memmove+0x44>
  800b3c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b3f:	39 c2                	cmp    %eax,%edx
  800b41:	76 2b                	jbe    800b6e <memmove+0x44>
		s += n;
		d += n;
  800b43:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b46:	89 fe                	mov    %edi,%esi
  800b48:	09 ce                	or     %ecx,%esi
  800b4a:	09 d6                	or     %edx,%esi
  800b4c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b52:	75 0e                	jne    800b62 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b54:	83 ef 04             	sub    $0x4,%edi
  800b57:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b5a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b5d:	fd                   	std    
  800b5e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b60:	eb 09                	jmp    800b6b <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b62:	83 ef 01             	sub    $0x1,%edi
  800b65:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b68:	fd                   	std    
  800b69:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b6b:	fc                   	cld    
  800b6c:	eb 1a                	jmp    800b88 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b6e:	89 c2                	mov    %eax,%edx
  800b70:	09 ca                	or     %ecx,%edx
  800b72:	09 f2                	or     %esi,%edx
  800b74:	f6 c2 03             	test   $0x3,%dl
  800b77:	75 0a                	jne    800b83 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b79:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b7c:	89 c7                	mov    %eax,%edi
  800b7e:	fc                   	cld    
  800b7f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b81:	eb 05                	jmp    800b88 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b83:	89 c7                	mov    %eax,%edi
  800b85:	fc                   	cld    
  800b86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b88:	5e                   	pop    %esi
  800b89:	5f                   	pop    %edi
  800b8a:	5d                   	pop    %ebp
  800b8b:	c3                   	ret    

00800b8c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b92:	ff 75 10             	pushl  0x10(%ebp)
  800b95:	ff 75 0c             	pushl  0xc(%ebp)
  800b98:	ff 75 08             	pushl  0x8(%ebp)
  800b9b:	e8 8a ff ff ff       	call   800b2a <memmove>
}
  800ba0:	c9                   	leave  
  800ba1:	c3                   	ret    

00800ba2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ba2:	55                   	push   %ebp
  800ba3:	89 e5                	mov    %esp,%ebp
  800ba5:	56                   	push   %esi
  800ba6:	53                   	push   %ebx
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bad:	89 c6                	mov    %eax,%esi
  800baf:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bb2:	39 f0                	cmp    %esi,%eax
  800bb4:	74 1c                	je     800bd2 <memcmp+0x30>
		if (*s1 != *s2)
  800bb6:	0f b6 08             	movzbl (%eax),%ecx
  800bb9:	0f b6 1a             	movzbl (%edx),%ebx
  800bbc:	38 d9                	cmp    %bl,%cl
  800bbe:	75 08                	jne    800bc8 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bc0:	83 c0 01             	add    $0x1,%eax
  800bc3:	83 c2 01             	add    $0x1,%edx
  800bc6:	eb ea                	jmp    800bb2 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bc8:	0f b6 c1             	movzbl %cl,%eax
  800bcb:	0f b6 db             	movzbl %bl,%ebx
  800bce:	29 d8                	sub    %ebx,%eax
  800bd0:	eb 05                	jmp    800bd7 <memcmp+0x35>
	}

	return 0;
  800bd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bd7:	5b                   	pop    %ebx
  800bd8:	5e                   	pop    %esi
  800bd9:	5d                   	pop    %ebp
  800bda:	c3                   	ret    

00800bdb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800be4:	89 c2                	mov    %eax,%edx
  800be6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800be9:	39 d0                	cmp    %edx,%eax
  800beb:	73 09                	jae    800bf6 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bed:	38 08                	cmp    %cl,(%eax)
  800bef:	74 05                	je     800bf6 <memfind+0x1b>
	for (; s < ends; s++)
  800bf1:	83 c0 01             	add    $0x1,%eax
  800bf4:	eb f3                	jmp    800be9 <memfind+0xe>
			break;
	return (void *) s;
}
  800bf6:	5d                   	pop    %ebp
  800bf7:	c3                   	ret    

00800bf8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	57                   	push   %edi
  800bfc:	56                   	push   %esi
  800bfd:	53                   	push   %ebx
  800bfe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c01:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c04:	eb 03                	jmp    800c09 <strtol+0x11>
		s++;
  800c06:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c09:	0f b6 01             	movzbl (%ecx),%eax
  800c0c:	3c 20                	cmp    $0x20,%al
  800c0e:	74 f6                	je     800c06 <strtol+0xe>
  800c10:	3c 09                	cmp    $0x9,%al
  800c12:	74 f2                	je     800c06 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c14:	3c 2b                	cmp    $0x2b,%al
  800c16:	74 2a                	je     800c42 <strtol+0x4a>
	int neg = 0;
  800c18:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c1d:	3c 2d                	cmp    $0x2d,%al
  800c1f:	74 2b                	je     800c4c <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c21:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c27:	75 0f                	jne    800c38 <strtol+0x40>
  800c29:	80 39 30             	cmpb   $0x30,(%ecx)
  800c2c:	74 28                	je     800c56 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c2e:	85 db                	test   %ebx,%ebx
  800c30:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c35:	0f 44 d8             	cmove  %eax,%ebx
  800c38:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c40:	eb 50                	jmp    800c92 <strtol+0x9a>
		s++;
  800c42:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c45:	bf 00 00 00 00       	mov    $0x0,%edi
  800c4a:	eb d5                	jmp    800c21 <strtol+0x29>
		s++, neg = 1;
  800c4c:	83 c1 01             	add    $0x1,%ecx
  800c4f:	bf 01 00 00 00       	mov    $0x1,%edi
  800c54:	eb cb                	jmp    800c21 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c56:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c5a:	74 0e                	je     800c6a <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c5c:	85 db                	test   %ebx,%ebx
  800c5e:	75 d8                	jne    800c38 <strtol+0x40>
		s++, base = 8;
  800c60:	83 c1 01             	add    $0x1,%ecx
  800c63:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c68:	eb ce                	jmp    800c38 <strtol+0x40>
		s += 2, base = 16;
  800c6a:	83 c1 02             	add    $0x2,%ecx
  800c6d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c72:	eb c4                	jmp    800c38 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c74:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c77:	89 f3                	mov    %esi,%ebx
  800c79:	80 fb 19             	cmp    $0x19,%bl
  800c7c:	77 29                	ja     800ca7 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c7e:	0f be d2             	movsbl %dl,%edx
  800c81:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c84:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c87:	7d 30                	jge    800cb9 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c89:	83 c1 01             	add    $0x1,%ecx
  800c8c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c90:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c92:	0f b6 11             	movzbl (%ecx),%edx
  800c95:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c98:	89 f3                	mov    %esi,%ebx
  800c9a:	80 fb 09             	cmp    $0x9,%bl
  800c9d:	77 d5                	ja     800c74 <strtol+0x7c>
			dig = *s - '0';
  800c9f:	0f be d2             	movsbl %dl,%edx
  800ca2:	83 ea 30             	sub    $0x30,%edx
  800ca5:	eb dd                	jmp    800c84 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ca7:	8d 72 bf             	lea    -0x41(%edx),%esi
  800caa:	89 f3                	mov    %esi,%ebx
  800cac:	80 fb 19             	cmp    $0x19,%bl
  800caf:	77 08                	ja     800cb9 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cb1:	0f be d2             	movsbl %dl,%edx
  800cb4:	83 ea 37             	sub    $0x37,%edx
  800cb7:	eb cb                	jmp    800c84 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cb9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cbd:	74 05                	je     800cc4 <strtol+0xcc>
		*endptr = (char *) s;
  800cbf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cc2:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cc4:	89 c2                	mov    %eax,%edx
  800cc6:	f7 da                	neg    %edx
  800cc8:	85 ff                	test   %edi,%edi
  800cca:	0f 45 c2             	cmovne %edx,%eax
}
  800ccd:	5b                   	pop    %ebx
  800cce:	5e                   	pop    %esi
  800ccf:	5f                   	pop    %edi
  800cd0:	5d                   	pop    %ebp
  800cd1:	c3                   	ret    

00800cd2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	57                   	push   %edi
  800cd6:	56                   	push   %esi
  800cd7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd8:	b8 00 00 00 00       	mov    $0x0,%eax
  800cdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce3:	89 c3                	mov    %eax,%ebx
  800ce5:	89 c7                	mov    %eax,%edi
  800ce7:	89 c6                	mov    %eax,%esi
  800ce9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ceb:	5b                   	pop    %ebx
  800cec:	5e                   	pop    %esi
  800ced:	5f                   	pop    %edi
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    

00800cf0 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	57                   	push   %edi
  800cf4:	56                   	push   %esi
  800cf5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf6:	ba 00 00 00 00       	mov    $0x0,%edx
  800cfb:	b8 01 00 00 00       	mov    $0x1,%eax
  800d00:	89 d1                	mov    %edx,%ecx
  800d02:	89 d3                	mov    %edx,%ebx
  800d04:	89 d7                	mov    %edx,%edi
  800d06:	89 d6                	mov    %edx,%esi
  800d08:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d0a:	5b                   	pop    %ebx
  800d0b:	5e                   	pop    %esi
  800d0c:	5f                   	pop    %edi
  800d0d:	5d                   	pop    %ebp
  800d0e:	c3                   	ret    

00800d0f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d0f:	55                   	push   %ebp
  800d10:	89 e5                	mov    %esp,%ebp
  800d12:	57                   	push   %edi
  800d13:	56                   	push   %esi
  800d14:	53                   	push   %ebx
  800d15:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d18:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d20:	b8 03 00 00 00       	mov    $0x3,%eax
  800d25:	89 cb                	mov    %ecx,%ebx
  800d27:	89 cf                	mov    %ecx,%edi
  800d29:	89 ce                	mov    %ecx,%esi
  800d2b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2d:	85 c0                	test   %eax,%eax
  800d2f:	7f 08                	jg     800d39 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d34:	5b                   	pop    %ebx
  800d35:	5e                   	pop    %esi
  800d36:	5f                   	pop    %edi
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d39:	83 ec 0c             	sub    $0xc,%esp
  800d3c:	50                   	push   %eax
  800d3d:	6a 03                	push   $0x3
  800d3f:	68 48 2a 80 00       	push   $0x802a48
  800d44:	6a 43                	push   $0x43
  800d46:	68 65 2a 80 00       	push   $0x802a65
  800d4b:	e8 f7 f3 ff ff       	call   800147 <_panic>

00800d50 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	57                   	push   %edi
  800d54:	56                   	push   %esi
  800d55:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d56:	ba 00 00 00 00       	mov    $0x0,%edx
  800d5b:	b8 02 00 00 00       	mov    $0x2,%eax
  800d60:	89 d1                	mov    %edx,%ecx
  800d62:	89 d3                	mov    %edx,%ebx
  800d64:	89 d7                	mov    %edx,%edi
  800d66:	89 d6                	mov    %edx,%esi
  800d68:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d6a:	5b                   	pop    %ebx
  800d6b:	5e                   	pop    %esi
  800d6c:	5f                   	pop    %edi
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    

00800d6f <sys_yield>:

void
sys_yield(void)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	57                   	push   %edi
  800d73:	56                   	push   %esi
  800d74:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d75:	ba 00 00 00 00       	mov    $0x0,%edx
  800d7a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d7f:	89 d1                	mov    %edx,%ecx
  800d81:	89 d3                	mov    %edx,%ebx
  800d83:	89 d7                	mov    %edx,%edi
  800d85:	89 d6                	mov    %edx,%esi
  800d87:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d89:	5b                   	pop    %ebx
  800d8a:	5e                   	pop    %esi
  800d8b:	5f                   	pop    %edi
  800d8c:	5d                   	pop    %ebp
  800d8d:	c3                   	ret    

00800d8e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d8e:	55                   	push   %ebp
  800d8f:	89 e5                	mov    %esp,%ebp
  800d91:	57                   	push   %edi
  800d92:	56                   	push   %esi
  800d93:	53                   	push   %ebx
  800d94:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d97:	be 00 00 00 00       	mov    $0x0,%esi
  800d9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da2:	b8 04 00 00 00       	mov    $0x4,%eax
  800da7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800daa:	89 f7                	mov    %esi,%edi
  800dac:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dae:	85 c0                	test   %eax,%eax
  800db0:	7f 08                	jg     800dba <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800db2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db5:	5b                   	pop    %ebx
  800db6:	5e                   	pop    %esi
  800db7:	5f                   	pop    %edi
  800db8:	5d                   	pop    %ebp
  800db9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dba:	83 ec 0c             	sub    $0xc,%esp
  800dbd:	50                   	push   %eax
  800dbe:	6a 04                	push   $0x4
  800dc0:	68 48 2a 80 00       	push   $0x802a48
  800dc5:	6a 43                	push   $0x43
  800dc7:	68 65 2a 80 00       	push   $0x802a65
  800dcc:	e8 76 f3 ff ff       	call   800147 <_panic>

00800dd1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
  800dd4:	57                   	push   %edi
  800dd5:	56                   	push   %esi
  800dd6:	53                   	push   %ebx
  800dd7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dda:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de0:	b8 05 00 00 00       	mov    $0x5,%eax
  800de5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800deb:	8b 75 18             	mov    0x18(%ebp),%esi
  800dee:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df0:	85 c0                	test   %eax,%eax
  800df2:	7f 08                	jg     800dfc <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800df4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df7:	5b                   	pop    %ebx
  800df8:	5e                   	pop    %esi
  800df9:	5f                   	pop    %edi
  800dfa:	5d                   	pop    %ebp
  800dfb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfc:	83 ec 0c             	sub    $0xc,%esp
  800dff:	50                   	push   %eax
  800e00:	6a 05                	push   $0x5
  800e02:	68 48 2a 80 00       	push   $0x802a48
  800e07:	6a 43                	push   $0x43
  800e09:	68 65 2a 80 00       	push   $0x802a65
  800e0e:	e8 34 f3 ff ff       	call   800147 <_panic>

00800e13 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e13:	55                   	push   %ebp
  800e14:	89 e5                	mov    %esp,%ebp
  800e16:	57                   	push   %edi
  800e17:	56                   	push   %esi
  800e18:	53                   	push   %ebx
  800e19:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e1c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e21:	8b 55 08             	mov    0x8(%ebp),%edx
  800e24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e27:	b8 06 00 00 00       	mov    $0x6,%eax
  800e2c:	89 df                	mov    %ebx,%edi
  800e2e:	89 de                	mov    %ebx,%esi
  800e30:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e32:	85 c0                	test   %eax,%eax
  800e34:	7f 08                	jg     800e3e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e39:	5b                   	pop    %ebx
  800e3a:	5e                   	pop    %esi
  800e3b:	5f                   	pop    %edi
  800e3c:	5d                   	pop    %ebp
  800e3d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3e:	83 ec 0c             	sub    $0xc,%esp
  800e41:	50                   	push   %eax
  800e42:	6a 06                	push   $0x6
  800e44:	68 48 2a 80 00       	push   $0x802a48
  800e49:	6a 43                	push   $0x43
  800e4b:	68 65 2a 80 00       	push   $0x802a65
  800e50:	e8 f2 f2 ff ff       	call   800147 <_panic>

00800e55 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e55:	55                   	push   %ebp
  800e56:	89 e5                	mov    %esp,%ebp
  800e58:	57                   	push   %edi
  800e59:	56                   	push   %esi
  800e5a:	53                   	push   %ebx
  800e5b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e63:	8b 55 08             	mov    0x8(%ebp),%edx
  800e66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e69:	b8 08 00 00 00       	mov    $0x8,%eax
  800e6e:	89 df                	mov    %ebx,%edi
  800e70:	89 de                	mov    %ebx,%esi
  800e72:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e74:	85 c0                	test   %eax,%eax
  800e76:	7f 08                	jg     800e80 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7b:	5b                   	pop    %ebx
  800e7c:	5e                   	pop    %esi
  800e7d:	5f                   	pop    %edi
  800e7e:	5d                   	pop    %ebp
  800e7f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e80:	83 ec 0c             	sub    $0xc,%esp
  800e83:	50                   	push   %eax
  800e84:	6a 08                	push   $0x8
  800e86:	68 48 2a 80 00       	push   $0x802a48
  800e8b:	6a 43                	push   $0x43
  800e8d:	68 65 2a 80 00       	push   $0x802a65
  800e92:	e8 b0 f2 ff ff       	call   800147 <_panic>

00800e97 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	57                   	push   %edi
  800e9b:	56                   	push   %esi
  800e9c:	53                   	push   %ebx
  800e9d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eab:	b8 09 00 00 00       	mov    $0x9,%eax
  800eb0:	89 df                	mov    %ebx,%edi
  800eb2:	89 de                	mov    %ebx,%esi
  800eb4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb6:	85 c0                	test   %eax,%eax
  800eb8:	7f 08                	jg     800ec2 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ebd:	5b                   	pop    %ebx
  800ebe:	5e                   	pop    %esi
  800ebf:	5f                   	pop    %edi
  800ec0:	5d                   	pop    %ebp
  800ec1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec2:	83 ec 0c             	sub    $0xc,%esp
  800ec5:	50                   	push   %eax
  800ec6:	6a 09                	push   $0x9
  800ec8:	68 48 2a 80 00       	push   $0x802a48
  800ecd:	6a 43                	push   $0x43
  800ecf:	68 65 2a 80 00       	push   $0x802a65
  800ed4:	e8 6e f2 ff ff       	call   800147 <_panic>

00800ed9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
  800edc:	57                   	push   %edi
  800edd:	56                   	push   %esi
  800ede:	53                   	push   %ebx
  800edf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eed:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ef2:	89 df                	mov    %ebx,%edi
  800ef4:	89 de                	mov    %ebx,%esi
  800ef6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef8:	85 c0                	test   %eax,%eax
  800efa:	7f 08                	jg     800f04 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eff:	5b                   	pop    %ebx
  800f00:	5e                   	pop    %esi
  800f01:	5f                   	pop    %edi
  800f02:	5d                   	pop    %ebp
  800f03:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f04:	83 ec 0c             	sub    $0xc,%esp
  800f07:	50                   	push   %eax
  800f08:	6a 0a                	push   $0xa
  800f0a:	68 48 2a 80 00       	push   $0x802a48
  800f0f:	6a 43                	push   $0x43
  800f11:	68 65 2a 80 00       	push   $0x802a65
  800f16:	e8 2c f2 ff ff       	call   800147 <_panic>

00800f1b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	57                   	push   %edi
  800f1f:	56                   	push   %esi
  800f20:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f21:	8b 55 08             	mov    0x8(%ebp),%edx
  800f24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f27:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f2c:	be 00 00 00 00       	mov    $0x0,%esi
  800f31:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f34:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f37:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f39:	5b                   	pop    %ebx
  800f3a:	5e                   	pop    %esi
  800f3b:	5f                   	pop    %edi
  800f3c:	5d                   	pop    %ebp
  800f3d:	c3                   	ret    

00800f3e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
  800f41:	57                   	push   %edi
  800f42:	56                   	push   %esi
  800f43:	53                   	push   %ebx
  800f44:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f47:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f54:	89 cb                	mov    %ecx,%ebx
  800f56:	89 cf                	mov    %ecx,%edi
  800f58:	89 ce                	mov    %ecx,%esi
  800f5a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f5c:	85 c0                	test   %eax,%eax
  800f5e:	7f 08                	jg     800f68 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f63:	5b                   	pop    %ebx
  800f64:	5e                   	pop    %esi
  800f65:	5f                   	pop    %edi
  800f66:	5d                   	pop    %ebp
  800f67:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f68:	83 ec 0c             	sub    $0xc,%esp
  800f6b:	50                   	push   %eax
  800f6c:	6a 0d                	push   $0xd
  800f6e:	68 48 2a 80 00       	push   $0x802a48
  800f73:	6a 43                	push   $0x43
  800f75:	68 65 2a 80 00       	push   $0x802a65
  800f7a:	e8 c8 f1 ff ff       	call   800147 <_panic>

00800f7f <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	57                   	push   %edi
  800f83:	56                   	push   %esi
  800f84:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f85:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f90:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f95:	89 df                	mov    %ebx,%edi
  800f97:	89 de                	mov    %ebx,%esi
  800f99:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f9b:	5b                   	pop    %ebx
  800f9c:	5e                   	pop    %esi
  800f9d:	5f                   	pop    %edi
  800f9e:	5d                   	pop    %ebp
  800f9f:	c3                   	ret    

00800fa0 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
  800fa3:	57                   	push   %edi
  800fa4:	56                   	push   %esi
  800fa5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fab:	8b 55 08             	mov    0x8(%ebp),%edx
  800fae:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fb3:	89 cb                	mov    %ecx,%ebx
  800fb5:	89 cf                	mov    %ecx,%edi
  800fb7:	89 ce                	mov    %ecx,%esi
  800fb9:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fbb:	5b                   	pop    %ebx
  800fbc:	5e                   	pop    %esi
  800fbd:	5f                   	pop    %edi
  800fbe:	5d                   	pop    %ebp
  800fbf:	c3                   	ret    

00800fc0 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	57                   	push   %edi
  800fc4:	56                   	push   %esi
  800fc5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc6:	ba 00 00 00 00       	mov    $0x0,%edx
  800fcb:	b8 10 00 00 00       	mov    $0x10,%eax
  800fd0:	89 d1                	mov    %edx,%ecx
  800fd2:	89 d3                	mov    %edx,%ebx
  800fd4:	89 d7                	mov    %edx,%edi
  800fd6:	89 d6                	mov    %edx,%esi
  800fd8:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fda:	5b                   	pop    %ebx
  800fdb:	5e                   	pop    %esi
  800fdc:	5f                   	pop    %edi
  800fdd:	5d                   	pop    %ebp
  800fde:	c3                   	ret    

00800fdf <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	57                   	push   %edi
  800fe3:	56                   	push   %esi
  800fe4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fe5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fea:	8b 55 08             	mov    0x8(%ebp),%edx
  800fed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff0:	b8 11 00 00 00       	mov    $0x11,%eax
  800ff5:	89 df                	mov    %ebx,%edi
  800ff7:	89 de                	mov    %ebx,%esi
  800ff9:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800ffb:	5b                   	pop    %ebx
  800ffc:	5e                   	pop    %esi
  800ffd:	5f                   	pop    %edi
  800ffe:	5d                   	pop    %ebp
  800fff:	c3                   	ret    

00801000 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	57                   	push   %edi
  801004:	56                   	push   %esi
  801005:	53                   	push   %ebx
	asm volatile("int %1\n"
  801006:	bb 00 00 00 00       	mov    $0x0,%ebx
  80100b:	8b 55 08             	mov    0x8(%ebp),%edx
  80100e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801011:	b8 12 00 00 00       	mov    $0x12,%eax
  801016:	89 df                	mov    %ebx,%edi
  801018:	89 de                	mov    %ebx,%esi
  80101a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80101c:	5b                   	pop    %ebx
  80101d:	5e                   	pop    %esi
  80101e:	5f                   	pop    %edi
  80101f:	5d                   	pop    %ebp
  801020:	c3                   	ret    

00801021 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
  801024:	57                   	push   %edi
  801025:	56                   	push   %esi
  801026:	53                   	push   %ebx
  801027:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80102a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80102f:	8b 55 08             	mov    0x8(%ebp),%edx
  801032:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801035:	b8 13 00 00 00       	mov    $0x13,%eax
  80103a:	89 df                	mov    %ebx,%edi
  80103c:	89 de                	mov    %ebx,%esi
  80103e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801040:	85 c0                	test   %eax,%eax
  801042:	7f 08                	jg     80104c <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801044:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801047:	5b                   	pop    %ebx
  801048:	5e                   	pop    %esi
  801049:	5f                   	pop    %edi
  80104a:	5d                   	pop    %ebp
  80104b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80104c:	83 ec 0c             	sub    $0xc,%esp
  80104f:	50                   	push   %eax
  801050:	6a 13                	push   $0x13
  801052:	68 48 2a 80 00       	push   $0x802a48
  801057:	6a 43                	push   $0x43
  801059:	68 65 2a 80 00       	push   $0x802a65
  80105e:	e8 e4 f0 ff ff       	call   800147 <_panic>

00801063 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	57                   	push   %edi
  801067:	56                   	push   %esi
  801068:	53                   	push   %ebx
	asm volatile("int %1\n"
  801069:	b9 00 00 00 00       	mov    $0x0,%ecx
  80106e:	8b 55 08             	mov    0x8(%ebp),%edx
  801071:	b8 14 00 00 00       	mov    $0x14,%eax
  801076:	89 cb                	mov    %ecx,%ebx
  801078:	89 cf                	mov    %ecx,%edi
  80107a:	89 ce                	mov    %ecx,%esi
  80107c:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80107e:	5b                   	pop    %ebx
  80107f:	5e                   	pop    %esi
  801080:	5f                   	pop    %edi
  801081:	5d                   	pop    %ebp
  801082:	c3                   	ret    

00801083 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
  801086:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801089:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  801090:	74 0a                	je     80109c <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  80109a:	c9                   	leave  
  80109b:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80109c:	83 ec 04             	sub    $0x4,%esp
  80109f:	6a 07                	push   $0x7
  8010a1:	68 00 f0 bf ee       	push   $0xeebff000
  8010a6:	6a 00                	push   $0x0
  8010a8:	e8 e1 fc ff ff       	call   800d8e <sys_page_alloc>
		if(r < 0)
  8010ad:	83 c4 10             	add    $0x10,%esp
  8010b0:	85 c0                	test   %eax,%eax
  8010b2:	78 2a                	js     8010de <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8010b4:	83 ec 08             	sub    $0x8,%esp
  8010b7:	68 f2 10 80 00       	push   $0x8010f2
  8010bc:	6a 00                	push   $0x0
  8010be:	e8 16 fe ff ff       	call   800ed9 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8010c3:	83 c4 10             	add    $0x10,%esp
  8010c6:	85 c0                	test   %eax,%eax
  8010c8:	79 c8                	jns    801092 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8010ca:	83 ec 04             	sub    $0x4,%esp
  8010cd:	68 a4 2a 80 00       	push   $0x802aa4
  8010d2:	6a 25                	push   $0x25
  8010d4:	68 dd 2a 80 00       	push   $0x802add
  8010d9:	e8 69 f0 ff ff       	call   800147 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8010de:	83 ec 04             	sub    $0x4,%esp
  8010e1:	68 74 2a 80 00       	push   $0x802a74
  8010e6:	6a 22                	push   $0x22
  8010e8:	68 dd 2a 80 00       	push   $0x802add
  8010ed:	e8 55 f0 ff ff       	call   800147 <_panic>

008010f2 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8010f2:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8010f3:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  8010f8:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8010fa:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8010fd:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  801101:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  801105:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801108:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80110a:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  80110e:	83 c4 08             	add    $0x8,%esp
	popal
  801111:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801112:	83 c4 04             	add    $0x4,%esp
	popfl
  801115:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801116:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801117:	c3                   	ret    

00801118 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801118:	55                   	push   %ebp
  801119:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	05 00 00 00 30       	add    $0x30000000,%eax
  801123:	c1 e8 0c             	shr    $0xc,%eax
}
  801126:	5d                   	pop    %ebp
  801127:	c3                   	ret    

00801128 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801133:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801138:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80113d:	5d                   	pop    %ebp
  80113e:	c3                   	ret    

0080113f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
  801142:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801147:	89 c2                	mov    %eax,%edx
  801149:	c1 ea 16             	shr    $0x16,%edx
  80114c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801153:	f6 c2 01             	test   $0x1,%dl
  801156:	74 2d                	je     801185 <fd_alloc+0x46>
  801158:	89 c2                	mov    %eax,%edx
  80115a:	c1 ea 0c             	shr    $0xc,%edx
  80115d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801164:	f6 c2 01             	test   $0x1,%dl
  801167:	74 1c                	je     801185 <fd_alloc+0x46>
  801169:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80116e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801173:	75 d2                	jne    801147 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80117e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801183:	eb 0a                	jmp    80118f <fd_alloc+0x50>
			*fd_store = fd;
  801185:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801188:	89 01                	mov    %eax,(%ecx)
			return 0;
  80118a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80118f:	5d                   	pop    %ebp
  801190:	c3                   	ret    

00801191 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
  801194:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801197:	83 f8 1f             	cmp    $0x1f,%eax
  80119a:	77 30                	ja     8011cc <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80119c:	c1 e0 0c             	shl    $0xc,%eax
  80119f:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011a4:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8011aa:	f6 c2 01             	test   $0x1,%dl
  8011ad:	74 24                	je     8011d3 <fd_lookup+0x42>
  8011af:	89 c2                	mov    %eax,%edx
  8011b1:	c1 ea 0c             	shr    $0xc,%edx
  8011b4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011bb:	f6 c2 01             	test   $0x1,%dl
  8011be:	74 1a                	je     8011da <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011c3:	89 02                	mov    %eax,(%edx)
	return 0;
  8011c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ca:	5d                   	pop    %ebp
  8011cb:	c3                   	ret    
		return -E_INVAL;
  8011cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011d1:	eb f7                	jmp    8011ca <fd_lookup+0x39>
		return -E_INVAL;
  8011d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011d8:	eb f0                	jmp    8011ca <fd_lookup+0x39>
  8011da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011df:	eb e9                	jmp    8011ca <fd_lookup+0x39>

008011e1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
  8011e4:	83 ec 08             	sub    $0x8,%esp
  8011e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8011ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ef:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011f4:	39 08                	cmp    %ecx,(%eax)
  8011f6:	74 38                	je     801230 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8011f8:	83 c2 01             	add    $0x1,%edx
  8011fb:	8b 04 95 6c 2b 80 00 	mov    0x802b6c(,%edx,4),%eax
  801202:	85 c0                	test   %eax,%eax
  801204:	75 ee                	jne    8011f4 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801206:	a1 08 40 80 00       	mov    0x804008,%eax
  80120b:	8b 40 48             	mov    0x48(%eax),%eax
  80120e:	83 ec 04             	sub    $0x4,%esp
  801211:	51                   	push   %ecx
  801212:	50                   	push   %eax
  801213:	68 ec 2a 80 00       	push   $0x802aec
  801218:	e8 20 f0 ff ff       	call   80023d <cprintf>
	*dev = 0;
  80121d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801220:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801226:	83 c4 10             	add    $0x10,%esp
  801229:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80122e:	c9                   	leave  
  80122f:	c3                   	ret    
			*dev = devtab[i];
  801230:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801233:	89 01                	mov    %eax,(%ecx)
			return 0;
  801235:	b8 00 00 00 00       	mov    $0x0,%eax
  80123a:	eb f2                	jmp    80122e <dev_lookup+0x4d>

0080123c <fd_close>:
{
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
  80123f:	57                   	push   %edi
  801240:	56                   	push   %esi
  801241:	53                   	push   %ebx
  801242:	83 ec 24             	sub    $0x24,%esp
  801245:	8b 75 08             	mov    0x8(%ebp),%esi
  801248:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80124b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80124e:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80124f:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801255:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801258:	50                   	push   %eax
  801259:	e8 33 ff ff ff       	call   801191 <fd_lookup>
  80125e:	89 c3                	mov    %eax,%ebx
  801260:	83 c4 10             	add    $0x10,%esp
  801263:	85 c0                	test   %eax,%eax
  801265:	78 05                	js     80126c <fd_close+0x30>
	    || fd != fd2)
  801267:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80126a:	74 16                	je     801282 <fd_close+0x46>
		return (must_exist ? r : 0);
  80126c:	89 f8                	mov    %edi,%eax
  80126e:	84 c0                	test   %al,%al
  801270:	b8 00 00 00 00       	mov    $0x0,%eax
  801275:	0f 44 d8             	cmove  %eax,%ebx
}
  801278:	89 d8                	mov    %ebx,%eax
  80127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80127d:	5b                   	pop    %ebx
  80127e:	5e                   	pop    %esi
  80127f:	5f                   	pop    %edi
  801280:	5d                   	pop    %ebp
  801281:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801282:	83 ec 08             	sub    $0x8,%esp
  801285:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801288:	50                   	push   %eax
  801289:	ff 36                	pushl  (%esi)
  80128b:	e8 51 ff ff ff       	call   8011e1 <dev_lookup>
  801290:	89 c3                	mov    %eax,%ebx
  801292:	83 c4 10             	add    $0x10,%esp
  801295:	85 c0                	test   %eax,%eax
  801297:	78 1a                	js     8012b3 <fd_close+0x77>
		if (dev->dev_close)
  801299:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80129c:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80129f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012a4:	85 c0                	test   %eax,%eax
  8012a6:	74 0b                	je     8012b3 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8012a8:	83 ec 0c             	sub    $0xc,%esp
  8012ab:	56                   	push   %esi
  8012ac:	ff d0                	call   *%eax
  8012ae:	89 c3                	mov    %eax,%ebx
  8012b0:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012b3:	83 ec 08             	sub    $0x8,%esp
  8012b6:	56                   	push   %esi
  8012b7:	6a 00                	push   $0x0
  8012b9:	e8 55 fb ff ff       	call   800e13 <sys_page_unmap>
	return r;
  8012be:	83 c4 10             	add    $0x10,%esp
  8012c1:	eb b5                	jmp    801278 <fd_close+0x3c>

008012c3 <close>:

int
close(int fdnum)
{
  8012c3:	55                   	push   %ebp
  8012c4:	89 e5                	mov    %esp,%ebp
  8012c6:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012cc:	50                   	push   %eax
  8012cd:	ff 75 08             	pushl  0x8(%ebp)
  8012d0:	e8 bc fe ff ff       	call   801191 <fd_lookup>
  8012d5:	83 c4 10             	add    $0x10,%esp
  8012d8:	85 c0                	test   %eax,%eax
  8012da:	79 02                	jns    8012de <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8012dc:	c9                   	leave  
  8012dd:	c3                   	ret    
		return fd_close(fd, 1);
  8012de:	83 ec 08             	sub    $0x8,%esp
  8012e1:	6a 01                	push   $0x1
  8012e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8012e6:	e8 51 ff ff ff       	call   80123c <fd_close>
  8012eb:	83 c4 10             	add    $0x10,%esp
  8012ee:	eb ec                	jmp    8012dc <close+0x19>

008012f0 <close_all>:

void
close_all(void)
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	53                   	push   %ebx
  8012f4:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012f7:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012fc:	83 ec 0c             	sub    $0xc,%esp
  8012ff:	53                   	push   %ebx
  801300:	e8 be ff ff ff       	call   8012c3 <close>
	for (i = 0; i < MAXFD; i++)
  801305:	83 c3 01             	add    $0x1,%ebx
  801308:	83 c4 10             	add    $0x10,%esp
  80130b:	83 fb 20             	cmp    $0x20,%ebx
  80130e:	75 ec                	jne    8012fc <close_all+0xc>
}
  801310:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801313:	c9                   	leave  
  801314:	c3                   	ret    

00801315 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
  801318:	57                   	push   %edi
  801319:	56                   	push   %esi
  80131a:	53                   	push   %ebx
  80131b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80131e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801321:	50                   	push   %eax
  801322:	ff 75 08             	pushl  0x8(%ebp)
  801325:	e8 67 fe ff ff       	call   801191 <fd_lookup>
  80132a:	89 c3                	mov    %eax,%ebx
  80132c:	83 c4 10             	add    $0x10,%esp
  80132f:	85 c0                	test   %eax,%eax
  801331:	0f 88 81 00 00 00    	js     8013b8 <dup+0xa3>
		return r;
	close(newfdnum);
  801337:	83 ec 0c             	sub    $0xc,%esp
  80133a:	ff 75 0c             	pushl  0xc(%ebp)
  80133d:	e8 81 ff ff ff       	call   8012c3 <close>

	newfd = INDEX2FD(newfdnum);
  801342:	8b 75 0c             	mov    0xc(%ebp),%esi
  801345:	c1 e6 0c             	shl    $0xc,%esi
  801348:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80134e:	83 c4 04             	add    $0x4,%esp
  801351:	ff 75 e4             	pushl  -0x1c(%ebp)
  801354:	e8 cf fd ff ff       	call   801128 <fd2data>
  801359:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80135b:	89 34 24             	mov    %esi,(%esp)
  80135e:	e8 c5 fd ff ff       	call   801128 <fd2data>
  801363:	83 c4 10             	add    $0x10,%esp
  801366:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801368:	89 d8                	mov    %ebx,%eax
  80136a:	c1 e8 16             	shr    $0x16,%eax
  80136d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801374:	a8 01                	test   $0x1,%al
  801376:	74 11                	je     801389 <dup+0x74>
  801378:	89 d8                	mov    %ebx,%eax
  80137a:	c1 e8 0c             	shr    $0xc,%eax
  80137d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801384:	f6 c2 01             	test   $0x1,%dl
  801387:	75 39                	jne    8013c2 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801389:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80138c:	89 d0                	mov    %edx,%eax
  80138e:	c1 e8 0c             	shr    $0xc,%eax
  801391:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801398:	83 ec 0c             	sub    $0xc,%esp
  80139b:	25 07 0e 00 00       	and    $0xe07,%eax
  8013a0:	50                   	push   %eax
  8013a1:	56                   	push   %esi
  8013a2:	6a 00                	push   $0x0
  8013a4:	52                   	push   %edx
  8013a5:	6a 00                	push   $0x0
  8013a7:	e8 25 fa ff ff       	call   800dd1 <sys_page_map>
  8013ac:	89 c3                	mov    %eax,%ebx
  8013ae:	83 c4 20             	add    $0x20,%esp
  8013b1:	85 c0                	test   %eax,%eax
  8013b3:	78 31                	js     8013e6 <dup+0xd1>
		goto err;

	return newfdnum;
  8013b5:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013b8:	89 d8                	mov    %ebx,%eax
  8013ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013bd:	5b                   	pop    %ebx
  8013be:	5e                   	pop    %esi
  8013bf:	5f                   	pop    %edi
  8013c0:	5d                   	pop    %ebp
  8013c1:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013c2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013c9:	83 ec 0c             	sub    $0xc,%esp
  8013cc:	25 07 0e 00 00       	and    $0xe07,%eax
  8013d1:	50                   	push   %eax
  8013d2:	57                   	push   %edi
  8013d3:	6a 00                	push   $0x0
  8013d5:	53                   	push   %ebx
  8013d6:	6a 00                	push   $0x0
  8013d8:	e8 f4 f9 ff ff       	call   800dd1 <sys_page_map>
  8013dd:	89 c3                	mov    %eax,%ebx
  8013df:	83 c4 20             	add    $0x20,%esp
  8013e2:	85 c0                	test   %eax,%eax
  8013e4:	79 a3                	jns    801389 <dup+0x74>
	sys_page_unmap(0, newfd);
  8013e6:	83 ec 08             	sub    $0x8,%esp
  8013e9:	56                   	push   %esi
  8013ea:	6a 00                	push   $0x0
  8013ec:	e8 22 fa ff ff       	call   800e13 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013f1:	83 c4 08             	add    $0x8,%esp
  8013f4:	57                   	push   %edi
  8013f5:	6a 00                	push   $0x0
  8013f7:	e8 17 fa ff ff       	call   800e13 <sys_page_unmap>
	return r;
  8013fc:	83 c4 10             	add    $0x10,%esp
  8013ff:	eb b7                	jmp    8013b8 <dup+0xa3>

00801401 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801401:	55                   	push   %ebp
  801402:	89 e5                	mov    %esp,%ebp
  801404:	53                   	push   %ebx
  801405:	83 ec 1c             	sub    $0x1c,%esp
  801408:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80140b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80140e:	50                   	push   %eax
  80140f:	53                   	push   %ebx
  801410:	e8 7c fd ff ff       	call   801191 <fd_lookup>
  801415:	83 c4 10             	add    $0x10,%esp
  801418:	85 c0                	test   %eax,%eax
  80141a:	78 3f                	js     80145b <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80141c:	83 ec 08             	sub    $0x8,%esp
  80141f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801422:	50                   	push   %eax
  801423:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801426:	ff 30                	pushl  (%eax)
  801428:	e8 b4 fd ff ff       	call   8011e1 <dev_lookup>
  80142d:	83 c4 10             	add    $0x10,%esp
  801430:	85 c0                	test   %eax,%eax
  801432:	78 27                	js     80145b <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801434:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801437:	8b 42 08             	mov    0x8(%edx),%eax
  80143a:	83 e0 03             	and    $0x3,%eax
  80143d:	83 f8 01             	cmp    $0x1,%eax
  801440:	74 1e                	je     801460 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801442:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801445:	8b 40 08             	mov    0x8(%eax),%eax
  801448:	85 c0                	test   %eax,%eax
  80144a:	74 35                	je     801481 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80144c:	83 ec 04             	sub    $0x4,%esp
  80144f:	ff 75 10             	pushl  0x10(%ebp)
  801452:	ff 75 0c             	pushl  0xc(%ebp)
  801455:	52                   	push   %edx
  801456:	ff d0                	call   *%eax
  801458:	83 c4 10             	add    $0x10,%esp
}
  80145b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801460:	a1 08 40 80 00       	mov    0x804008,%eax
  801465:	8b 40 48             	mov    0x48(%eax),%eax
  801468:	83 ec 04             	sub    $0x4,%esp
  80146b:	53                   	push   %ebx
  80146c:	50                   	push   %eax
  80146d:	68 30 2b 80 00       	push   $0x802b30
  801472:	e8 c6 ed ff ff       	call   80023d <cprintf>
		return -E_INVAL;
  801477:	83 c4 10             	add    $0x10,%esp
  80147a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80147f:	eb da                	jmp    80145b <read+0x5a>
		return -E_NOT_SUPP;
  801481:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801486:	eb d3                	jmp    80145b <read+0x5a>

00801488 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801488:	55                   	push   %ebp
  801489:	89 e5                	mov    %esp,%ebp
  80148b:	57                   	push   %edi
  80148c:	56                   	push   %esi
  80148d:	53                   	push   %ebx
  80148e:	83 ec 0c             	sub    $0xc,%esp
  801491:	8b 7d 08             	mov    0x8(%ebp),%edi
  801494:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801497:	bb 00 00 00 00       	mov    $0x0,%ebx
  80149c:	39 f3                	cmp    %esi,%ebx
  80149e:	73 23                	jae    8014c3 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014a0:	83 ec 04             	sub    $0x4,%esp
  8014a3:	89 f0                	mov    %esi,%eax
  8014a5:	29 d8                	sub    %ebx,%eax
  8014a7:	50                   	push   %eax
  8014a8:	89 d8                	mov    %ebx,%eax
  8014aa:	03 45 0c             	add    0xc(%ebp),%eax
  8014ad:	50                   	push   %eax
  8014ae:	57                   	push   %edi
  8014af:	e8 4d ff ff ff       	call   801401 <read>
		if (m < 0)
  8014b4:	83 c4 10             	add    $0x10,%esp
  8014b7:	85 c0                	test   %eax,%eax
  8014b9:	78 06                	js     8014c1 <readn+0x39>
			return m;
		if (m == 0)
  8014bb:	74 06                	je     8014c3 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8014bd:	01 c3                	add    %eax,%ebx
  8014bf:	eb db                	jmp    80149c <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014c1:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014c3:	89 d8                	mov    %ebx,%eax
  8014c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014c8:	5b                   	pop    %ebx
  8014c9:	5e                   	pop    %esi
  8014ca:	5f                   	pop    %edi
  8014cb:	5d                   	pop    %ebp
  8014cc:	c3                   	ret    

008014cd <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
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
  8014dc:	e8 b0 fc ff ff       	call   801191 <fd_lookup>
  8014e1:	83 c4 10             	add    $0x10,%esp
  8014e4:	85 c0                	test   %eax,%eax
  8014e6:	78 3a                	js     801522 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014e8:	83 ec 08             	sub    $0x8,%esp
  8014eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ee:	50                   	push   %eax
  8014ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f2:	ff 30                	pushl  (%eax)
  8014f4:	e8 e8 fc ff ff       	call   8011e1 <dev_lookup>
  8014f9:	83 c4 10             	add    $0x10,%esp
  8014fc:	85 c0                	test   %eax,%eax
  8014fe:	78 22                	js     801522 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801503:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801507:	74 1e                	je     801527 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801509:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150c:	8b 52 0c             	mov    0xc(%edx),%edx
  80150f:	85 d2                	test   %edx,%edx
  801511:	74 35                	je     801548 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801513:	83 ec 04             	sub    $0x4,%esp
  801516:	ff 75 10             	pushl  0x10(%ebp)
  801519:	ff 75 0c             	pushl  0xc(%ebp)
  80151c:	50                   	push   %eax
  80151d:	ff d2                	call   *%edx
  80151f:	83 c4 10             	add    $0x10,%esp
}
  801522:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801525:	c9                   	leave  
  801526:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801527:	a1 08 40 80 00       	mov    0x804008,%eax
  80152c:	8b 40 48             	mov    0x48(%eax),%eax
  80152f:	83 ec 04             	sub    $0x4,%esp
  801532:	53                   	push   %ebx
  801533:	50                   	push   %eax
  801534:	68 4c 2b 80 00       	push   $0x802b4c
  801539:	e8 ff ec ff ff       	call   80023d <cprintf>
		return -E_INVAL;
  80153e:	83 c4 10             	add    $0x10,%esp
  801541:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801546:	eb da                	jmp    801522 <write+0x55>
		return -E_NOT_SUPP;
  801548:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80154d:	eb d3                	jmp    801522 <write+0x55>

0080154f <seek>:

int
seek(int fdnum, off_t offset)
{
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
  801552:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801555:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801558:	50                   	push   %eax
  801559:	ff 75 08             	pushl  0x8(%ebp)
  80155c:	e8 30 fc ff ff       	call   801191 <fd_lookup>
  801561:	83 c4 10             	add    $0x10,%esp
  801564:	85 c0                	test   %eax,%eax
  801566:	78 0e                	js     801576 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801568:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801571:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801576:	c9                   	leave  
  801577:	c3                   	ret    

00801578 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
  80157b:	53                   	push   %ebx
  80157c:	83 ec 1c             	sub    $0x1c,%esp
  80157f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801582:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801585:	50                   	push   %eax
  801586:	53                   	push   %ebx
  801587:	e8 05 fc ff ff       	call   801191 <fd_lookup>
  80158c:	83 c4 10             	add    $0x10,%esp
  80158f:	85 c0                	test   %eax,%eax
  801591:	78 37                	js     8015ca <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801593:	83 ec 08             	sub    $0x8,%esp
  801596:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801599:	50                   	push   %eax
  80159a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159d:	ff 30                	pushl  (%eax)
  80159f:	e8 3d fc ff ff       	call   8011e1 <dev_lookup>
  8015a4:	83 c4 10             	add    $0x10,%esp
  8015a7:	85 c0                	test   %eax,%eax
  8015a9:	78 1f                	js     8015ca <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ae:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015b2:	74 1b                	je     8015cf <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b7:	8b 52 18             	mov    0x18(%edx),%edx
  8015ba:	85 d2                	test   %edx,%edx
  8015bc:	74 32                	je     8015f0 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015be:	83 ec 08             	sub    $0x8,%esp
  8015c1:	ff 75 0c             	pushl  0xc(%ebp)
  8015c4:	50                   	push   %eax
  8015c5:	ff d2                	call   *%edx
  8015c7:	83 c4 10             	add    $0x10,%esp
}
  8015ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015cf:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015d4:	8b 40 48             	mov    0x48(%eax),%eax
  8015d7:	83 ec 04             	sub    $0x4,%esp
  8015da:	53                   	push   %ebx
  8015db:	50                   	push   %eax
  8015dc:	68 0c 2b 80 00       	push   $0x802b0c
  8015e1:	e8 57 ec ff ff       	call   80023d <cprintf>
		return -E_INVAL;
  8015e6:	83 c4 10             	add    $0x10,%esp
  8015e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ee:	eb da                	jmp    8015ca <ftruncate+0x52>
		return -E_NOT_SUPP;
  8015f0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015f5:	eb d3                	jmp    8015ca <ftruncate+0x52>

008015f7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	53                   	push   %ebx
  8015fb:	83 ec 1c             	sub    $0x1c,%esp
  8015fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801601:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801604:	50                   	push   %eax
  801605:	ff 75 08             	pushl  0x8(%ebp)
  801608:	e8 84 fb ff ff       	call   801191 <fd_lookup>
  80160d:	83 c4 10             	add    $0x10,%esp
  801610:	85 c0                	test   %eax,%eax
  801612:	78 4b                	js     80165f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801614:	83 ec 08             	sub    $0x8,%esp
  801617:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80161a:	50                   	push   %eax
  80161b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161e:	ff 30                	pushl  (%eax)
  801620:	e8 bc fb ff ff       	call   8011e1 <dev_lookup>
  801625:	83 c4 10             	add    $0x10,%esp
  801628:	85 c0                	test   %eax,%eax
  80162a:	78 33                	js     80165f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80162c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801633:	74 2f                	je     801664 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801635:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801638:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80163f:	00 00 00 
	stat->st_isdir = 0;
  801642:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801649:	00 00 00 
	stat->st_dev = dev;
  80164c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801652:	83 ec 08             	sub    $0x8,%esp
  801655:	53                   	push   %ebx
  801656:	ff 75 f0             	pushl  -0x10(%ebp)
  801659:	ff 50 14             	call   *0x14(%eax)
  80165c:	83 c4 10             	add    $0x10,%esp
}
  80165f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801662:	c9                   	leave  
  801663:	c3                   	ret    
		return -E_NOT_SUPP;
  801664:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801669:	eb f4                	jmp    80165f <fstat+0x68>

0080166b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
  80166e:	56                   	push   %esi
  80166f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801670:	83 ec 08             	sub    $0x8,%esp
  801673:	6a 00                	push   $0x0
  801675:	ff 75 08             	pushl  0x8(%ebp)
  801678:	e8 22 02 00 00       	call   80189f <open>
  80167d:	89 c3                	mov    %eax,%ebx
  80167f:	83 c4 10             	add    $0x10,%esp
  801682:	85 c0                	test   %eax,%eax
  801684:	78 1b                	js     8016a1 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801686:	83 ec 08             	sub    $0x8,%esp
  801689:	ff 75 0c             	pushl  0xc(%ebp)
  80168c:	50                   	push   %eax
  80168d:	e8 65 ff ff ff       	call   8015f7 <fstat>
  801692:	89 c6                	mov    %eax,%esi
	close(fd);
  801694:	89 1c 24             	mov    %ebx,(%esp)
  801697:	e8 27 fc ff ff       	call   8012c3 <close>
	return r;
  80169c:	83 c4 10             	add    $0x10,%esp
  80169f:	89 f3                	mov    %esi,%ebx
}
  8016a1:	89 d8                	mov    %ebx,%eax
  8016a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016a6:	5b                   	pop    %ebx
  8016a7:	5e                   	pop    %esi
  8016a8:	5d                   	pop    %ebp
  8016a9:	c3                   	ret    

008016aa <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
  8016ad:	56                   	push   %esi
  8016ae:	53                   	push   %ebx
  8016af:	89 c6                	mov    %eax,%esi
  8016b1:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016b3:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016ba:	74 27                	je     8016e3 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016bc:	6a 07                	push   $0x7
  8016be:	68 00 50 80 00       	push   $0x805000
  8016c3:	56                   	push   %esi
  8016c4:	ff 35 00 40 80 00    	pushl  0x804000
  8016ca:	e8 08 0c 00 00       	call   8022d7 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016cf:	83 c4 0c             	add    $0xc,%esp
  8016d2:	6a 00                	push   $0x0
  8016d4:	53                   	push   %ebx
  8016d5:	6a 00                	push   $0x0
  8016d7:	e8 92 0b 00 00       	call   80226e <ipc_recv>
}
  8016dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016df:	5b                   	pop    %ebx
  8016e0:	5e                   	pop    %esi
  8016e1:	5d                   	pop    %ebp
  8016e2:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016e3:	83 ec 0c             	sub    $0xc,%esp
  8016e6:	6a 01                	push   $0x1
  8016e8:	e8 42 0c 00 00       	call   80232f <ipc_find_env>
  8016ed:	a3 00 40 80 00       	mov    %eax,0x804000
  8016f2:	83 c4 10             	add    $0x10,%esp
  8016f5:	eb c5                	jmp    8016bc <fsipc+0x12>

008016f7 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	8b 40 0c             	mov    0xc(%eax),%eax
  801703:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801708:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170b:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801710:	ba 00 00 00 00       	mov    $0x0,%edx
  801715:	b8 02 00 00 00       	mov    $0x2,%eax
  80171a:	e8 8b ff ff ff       	call   8016aa <fsipc>
}
  80171f:	c9                   	leave  
  801720:	c3                   	ret    

00801721 <devfile_flush>:
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
  801724:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801727:	8b 45 08             	mov    0x8(%ebp),%eax
  80172a:	8b 40 0c             	mov    0xc(%eax),%eax
  80172d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801732:	ba 00 00 00 00       	mov    $0x0,%edx
  801737:	b8 06 00 00 00       	mov    $0x6,%eax
  80173c:	e8 69 ff ff ff       	call   8016aa <fsipc>
}
  801741:	c9                   	leave  
  801742:	c3                   	ret    

00801743 <devfile_stat>:
{
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
  801746:	53                   	push   %ebx
  801747:	83 ec 04             	sub    $0x4,%esp
  80174a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
  801750:	8b 40 0c             	mov    0xc(%eax),%eax
  801753:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801758:	ba 00 00 00 00       	mov    $0x0,%edx
  80175d:	b8 05 00 00 00       	mov    $0x5,%eax
  801762:	e8 43 ff ff ff       	call   8016aa <fsipc>
  801767:	85 c0                	test   %eax,%eax
  801769:	78 2c                	js     801797 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80176b:	83 ec 08             	sub    $0x8,%esp
  80176e:	68 00 50 80 00       	push   $0x805000
  801773:	53                   	push   %ebx
  801774:	e8 23 f2 ff ff       	call   80099c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801779:	a1 80 50 80 00       	mov    0x805080,%eax
  80177e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801784:	a1 84 50 80 00       	mov    0x805084,%eax
  801789:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80178f:	83 c4 10             	add    $0x10,%esp
  801792:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801797:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <devfile_write>:
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	53                   	push   %ebx
  8017a0:	83 ec 08             	sub    $0x8,%esp
  8017a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ac:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8017b1:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8017b7:	53                   	push   %ebx
  8017b8:	ff 75 0c             	pushl  0xc(%ebp)
  8017bb:	68 08 50 80 00       	push   $0x805008
  8017c0:	e8 c7 f3 ff ff       	call   800b8c <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ca:	b8 04 00 00 00       	mov    $0x4,%eax
  8017cf:	e8 d6 fe ff ff       	call   8016aa <fsipc>
  8017d4:	83 c4 10             	add    $0x10,%esp
  8017d7:	85 c0                	test   %eax,%eax
  8017d9:	78 0b                	js     8017e6 <devfile_write+0x4a>
	assert(r <= n);
  8017db:	39 d8                	cmp    %ebx,%eax
  8017dd:	77 0c                	ja     8017eb <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8017df:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017e4:	7f 1e                	jg     801804 <devfile_write+0x68>
}
  8017e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    
	assert(r <= n);
  8017eb:	68 80 2b 80 00       	push   $0x802b80
  8017f0:	68 87 2b 80 00       	push   $0x802b87
  8017f5:	68 98 00 00 00       	push   $0x98
  8017fa:	68 9c 2b 80 00       	push   $0x802b9c
  8017ff:	e8 43 e9 ff ff       	call   800147 <_panic>
	assert(r <= PGSIZE);
  801804:	68 a7 2b 80 00       	push   $0x802ba7
  801809:	68 87 2b 80 00       	push   $0x802b87
  80180e:	68 99 00 00 00       	push   $0x99
  801813:	68 9c 2b 80 00       	push   $0x802b9c
  801818:	e8 2a e9 ff ff       	call   800147 <_panic>

0080181d <devfile_read>:
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
  801820:	56                   	push   %esi
  801821:	53                   	push   %ebx
  801822:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801825:	8b 45 08             	mov    0x8(%ebp),%eax
  801828:	8b 40 0c             	mov    0xc(%eax),%eax
  80182b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801830:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801836:	ba 00 00 00 00       	mov    $0x0,%edx
  80183b:	b8 03 00 00 00       	mov    $0x3,%eax
  801840:	e8 65 fe ff ff       	call   8016aa <fsipc>
  801845:	89 c3                	mov    %eax,%ebx
  801847:	85 c0                	test   %eax,%eax
  801849:	78 1f                	js     80186a <devfile_read+0x4d>
	assert(r <= n);
  80184b:	39 f0                	cmp    %esi,%eax
  80184d:	77 24                	ja     801873 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80184f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801854:	7f 33                	jg     801889 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801856:	83 ec 04             	sub    $0x4,%esp
  801859:	50                   	push   %eax
  80185a:	68 00 50 80 00       	push   $0x805000
  80185f:	ff 75 0c             	pushl  0xc(%ebp)
  801862:	e8 c3 f2 ff ff       	call   800b2a <memmove>
	return r;
  801867:	83 c4 10             	add    $0x10,%esp
}
  80186a:	89 d8                	mov    %ebx,%eax
  80186c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80186f:	5b                   	pop    %ebx
  801870:	5e                   	pop    %esi
  801871:	5d                   	pop    %ebp
  801872:	c3                   	ret    
	assert(r <= n);
  801873:	68 80 2b 80 00       	push   $0x802b80
  801878:	68 87 2b 80 00       	push   $0x802b87
  80187d:	6a 7c                	push   $0x7c
  80187f:	68 9c 2b 80 00       	push   $0x802b9c
  801884:	e8 be e8 ff ff       	call   800147 <_panic>
	assert(r <= PGSIZE);
  801889:	68 a7 2b 80 00       	push   $0x802ba7
  80188e:	68 87 2b 80 00       	push   $0x802b87
  801893:	6a 7d                	push   $0x7d
  801895:	68 9c 2b 80 00       	push   $0x802b9c
  80189a:	e8 a8 e8 ff ff       	call   800147 <_panic>

0080189f <open>:
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
  8018a2:	56                   	push   %esi
  8018a3:	53                   	push   %ebx
  8018a4:	83 ec 1c             	sub    $0x1c,%esp
  8018a7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018aa:	56                   	push   %esi
  8018ab:	e8 b3 f0 ff ff       	call   800963 <strlen>
  8018b0:	83 c4 10             	add    $0x10,%esp
  8018b3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018b8:	7f 6c                	jg     801926 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018ba:	83 ec 0c             	sub    $0xc,%esp
  8018bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c0:	50                   	push   %eax
  8018c1:	e8 79 f8 ff ff       	call   80113f <fd_alloc>
  8018c6:	89 c3                	mov    %eax,%ebx
  8018c8:	83 c4 10             	add    $0x10,%esp
  8018cb:	85 c0                	test   %eax,%eax
  8018cd:	78 3c                	js     80190b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8018cf:	83 ec 08             	sub    $0x8,%esp
  8018d2:	56                   	push   %esi
  8018d3:	68 00 50 80 00       	push   $0x805000
  8018d8:	e8 bf f0 ff ff       	call   80099c <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e0:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e8:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ed:	e8 b8 fd ff ff       	call   8016aa <fsipc>
  8018f2:	89 c3                	mov    %eax,%ebx
  8018f4:	83 c4 10             	add    $0x10,%esp
  8018f7:	85 c0                	test   %eax,%eax
  8018f9:	78 19                	js     801914 <open+0x75>
	return fd2num(fd);
  8018fb:	83 ec 0c             	sub    $0xc,%esp
  8018fe:	ff 75 f4             	pushl  -0xc(%ebp)
  801901:	e8 12 f8 ff ff       	call   801118 <fd2num>
  801906:	89 c3                	mov    %eax,%ebx
  801908:	83 c4 10             	add    $0x10,%esp
}
  80190b:	89 d8                	mov    %ebx,%eax
  80190d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801910:	5b                   	pop    %ebx
  801911:	5e                   	pop    %esi
  801912:	5d                   	pop    %ebp
  801913:	c3                   	ret    
		fd_close(fd, 0);
  801914:	83 ec 08             	sub    $0x8,%esp
  801917:	6a 00                	push   $0x0
  801919:	ff 75 f4             	pushl  -0xc(%ebp)
  80191c:	e8 1b f9 ff ff       	call   80123c <fd_close>
		return r;
  801921:	83 c4 10             	add    $0x10,%esp
  801924:	eb e5                	jmp    80190b <open+0x6c>
		return -E_BAD_PATH;
  801926:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80192b:	eb de                	jmp    80190b <open+0x6c>

0080192d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
  801930:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801933:	ba 00 00 00 00       	mov    $0x0,%edx
  801938:	b8 08 00 00 00       	mov    $0x8,%eax
  80193d:	e8 68 fd ff ff       	call   8016aa <fsipc>
}
  801942:	c9                   	leave  
  801943:	c3                   	ret    

00801944 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
  801947:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80194a:	68 b3 2b 80 00       	push   $0x802bb3
  80194f:	ff 75 0c             	pushl  0xc(%ebp)
  801952:	e8 45 f0 ff ff       	call   80099c <strcpy>
	return 0;
}
  801957:	b8 00 00 00 00       	mov    $0x0,%eax
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <devsock_close>:
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
  801961:	53                   	push   %ebx
  801962:	83 ec 10             	sub    $0x10,%esp
  801965:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801968:	53                   	push   %ebx
  801969:	e8 00 0a 00 00       	call   80236e <pageref>
  80196e:	83 c4 10             	add    $0x10,%esp
		return 0;
  801971:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801976:	83 f8 01             	cmp    $0x1,%eax
  801979:	74 07                	je     801982 <devsock_close+0x24>
}
  80197b:	89 d0                	mov    %edx,%eax
  80197d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801980:	c9                   	leave  
  801981:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801982:	83 ec 0c             	sub    $0xc,%esp
  801985:	ff 73 0c             	pushl  0xc(%ebx)
  801988:	e8 b9 02 00 00       	call   801c46 <nsipc_close>
  80198d:	89 c2                	mov    %eax,%edx
  80198f:	83 c4 10             	add    $0x10,%esp
  801992:	eb e7                	jmp    80197b <devsock_close+0x1d>

00801994 <devsock_write>:
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80199a:	6a 00                	push   $0x0
  80199c:	ff 75 10             	pushl  0x10(%ebp)
  80199f:	ff 75 0c             	pushl  0xc(%ebp)
  8019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a5:	ff 70 0c             	pushl  0xc(%eax)
  8019a8:	e8 76 03 00 00       	call   801d23 <nsipc_send>
}
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    

008019af <devsock_read>:
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
  8019b2:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019b5:	6a 00                	push   $0x0
  8019b7:	ff 75 10             	pushl  0x10(%ebp)
  8019ba:	ff 75 0c             	pushl  0xc(%ebp)
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	ff 70 0c             	pushl  0xc(%eax)
  8019c3:	e8 ef 02 00 00       	call   801cb7 <nsipc_recv>
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <fd2sockid>:
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
  8019cd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8019d0:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8019d3:	52                   	push   %edx
  8019d4:	50                   	push   %eax
  8019d5:	e8 b7 f7 ff ff       	call   801191 <fd_lookup>
  8019da:	83 c4 10             	add    $0x10,%esp
  8019dd:	85 c0                	test   %eax,%eax
  8019df:	78 10                	js     8019f1 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8019e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e4:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8019ea:	39 08                	cmp    %ecx,(%eax)
  8019ec:	75 05                	jne    8019f3 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8019ee:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    
		return -E_NOT_SUPP;
  8019f3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019f8:	eb f7                	jmp    8019f1 <fd2sockid+0x27>

008019fa <alloc_sockfd>:
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
  8019fd:	56                   	push   %esi
  8019fe:	53                   	push   %ebx
  8019ff:	83 ec 1c             	sub    $0x1c,%esp
  801a02:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a04:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a07:	50                   	push   %eax
  801a08:	e8 32 f7 ff ff       	call   80113f <fd_alloc>
  801a0d:	89 c3                	mov    %eax,%ebx
  801a0f:	83 c4 10             	add    $0x10,%esp
  801a12:	85 c0                	test   %eax,%eax
  801a14:	78 43                	js     801a59 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a16:	83 ec 04             	sub    $0x4,%esp
  801a19:	68 07 04 00 00       	push   $0x407
  801a1e:	ff 75 f4             	pushl  -0xc(%ebp)
  801a21:	6a 00                	push   $0x0
  801a23:	e8 66 f3 ff ff       	call   800d8e <sys_page_alloc>
  801a28:	89 c3                	mov    %eax,%ebx
  801a2a:	83 c4 10             	add    $0x10,%esp
  801a2d:	85 c0                	test   %eax,%eax
  801a2f:	78 28                	js     801a59 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a34:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a3a:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a3f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a46:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a49:	83 ec 0c             	sub    $0xc,%esp
  801a4c:	50                   	push   %eax
  801a4d:	e8 c6 f6 ff ff       	call   801118 <fd2num>
  801a52:	89 c3                	mov    %eax,%ebx
  801a54:	83 c4 10             	add    $0x10,%esp
  801a57:	eb 0c                	jmp    801a65 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a59:	83 ec 0c             	sub    $0xc,%esp
  801a5c:	56                   	push   %esi
  801a5d:	e8 e4 01 00 00       	call   801c46 <nsipc_close>
		return r;
  801a62:	83 c4 10             	add    $0x10,%esp
}
  801a65:	89 d8                	mov    %ebx,%eax
  801a67:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a6a:	5b                   	pop    %ebx
  801a6b:	5e                   	pop    %esi
  801a6c:	5d                   	pop    %ebp
  801a6d:	c3                   	ret    

00801a6e <accept>:
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
  801a71:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	e8 4e ff ff ff       	call   8019ca <fd2sockid>
  801a7c:	85 c0                	test   %eax,%eax
  801a7e:	78 1b                	js     801a9b <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a80:	83 ec 04             	sub    $0x4,%esp
  801a83:	ff 75 10             	pushl  0x10(%ebp)
  801a86:	ff 75 0c             	pushl  0xc(%ebp)
  801a89:	50                   	push   %eax
  801a8a:	e8 0e 01 00 00       	call   801b9d <nsipc_accept>
  801a8f:	83 c4 10             	add    $0x10,%esp
  801a92:	85 c0                	test   %eax,%eax
  801a94:	78 05                	js     801a9b <accept+0x2d>
	return alloc_sockfd(r);
  801a96:	e8 5f ff ff ff       	call   8019fa <alloc_sockfd>
}
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <bind>:
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
  801aa0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa6:	e8 1f ff ff ff       	call   8019ca <fd2sockid>
  801aab:	85 c0                	test   %eax,%eax
  801aad:	78 12                	js     801ac1 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801aaf:	83 ec 04             	sub    $0x4,%esp
  801ab2:	ff 75 10             	pushl  0x10(%ebp)
  801ab5:	ff 75 0c             	pushl  0xc(%ebp)
  801ab8:	50                   	push   %eax
  801ab9:	e8 31 01 00 00       	call   801bef <nsipc_bind>
  801abe:	83 c4 10             	add    $0x10,%esp
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <shutdown>:
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
  801ac6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	e8 f9 fe ff ff       	call   8019ca <fd2sockid>
  801ad1:	85 c0                	test   %eax,%eax
  801ad3:	78 0f                	js     801ae4 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801ad5:	83 ec 08             	sub    $0x8,%esp
  801ad8:	ff 75 0c             	pushl  0xc(%ebp)
  801adb:	50                   	push   %eax
  801adc:	e8 43 01 00 00       	call   801c24 <nsipc_shutdown>
  801ae1:	83 c4 10             	add    $0x10,%esp
}
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <connect>:
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
  801ae9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801aec:	8b 45 08             	mov    0x8(%ebp),%eax
  801aef:	e8 d6 fe ff ff       	call   8019ca <fd2sockid>
  801af4:	85 c0                	test   %eax,%eax
  801af6:	78 12                	js     801b0a <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801af8:	83 ec 04             	sub    $0x4,%esp
  801afb:	ff 75 10             	pushl  0x10(%ebp)
  801afe:	ff 75 0c             	pushl  0xc(%ebp)
  801b01:	50                   	push   %eax
  801b02:	e8 59 01 00 00       	call   801c60 <nsipc_connect>
  801b07:	83 c4 10             	add    $0x10,%esp
}
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <listen>:
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
  801b0f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b12:	8b 45 08             	mov    0x8(%ebp),%eax
  801b15:	e8 b0 fe ff ff       	call   8019ca <fd2sockid>
  801b1a:	85 c0                	test   %eax,%eax
  801b1c:	78 0f                	js     801b2d <listen+0x21>
	return nsipc_listen(r, backlog);
  801b1e:	83 ec 08             	sub    $0x8,%esp
  801b21:	ff 75 0c             	pushl  0xc(%ebp)
  801b24:	50                   	push   %eax
  801b25:	e8 6b 01 00 00       	call   801c95 <nsipc_listen>
  801b2a:	83 c4 10             	add    $0x10,%esp
}
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <socket>:

int
socket(int domain, int type, int protocol)
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
  801b32:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b35:	ff 75 10             	pushl  0x10(%ebp)
  801b38:	ff 75 0c             	pushl  0xc(%ebp)
  801b3b:	ff 75 08             	pushl  0x8(%ebp)
  801b3e:	e8 3e 02 00 00       	call   801d81 <nsipc_socket>
  801b43:	83 c4 10             	add    $0x10,%esp
  801b46:	85 c0                	test   %eax,%eax
  801b48:	78 05                	js     801b4f <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801b4a:	e8 ab fe ff ff       	call   8019fa <alloc_sockfd>
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
  801b54:	53                   	push   %ebx
  801b55:	83 ec 04             	sub    $0x4,%esp
  801b58:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b5a:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b61:	74 26                	je     801b89 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b63:	6a 07                	push   $0x7
  801b65:	68 00 60 80 00       	push   $0x806000
  801b6a:	53                   	push   %ebx
  801b6b:	ff 35 04 40 80 00    	pushl  0x804004
  801b71:	e8 61 07 00 00       	call   8022d7 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b76:	83 c4 0c             	add    $0xc,%esp
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	e8 ea 06 00 00       	call   80226e <ipc_recv>
}
  801b84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b89:	83 ec 0c             	sub    $0xc,%esp
  801b8c:	6a 02                	push   $0x2
  801b8e:	e8 9c 07 00 00       	call   80232f <ipc_find_env>
  801b93:	a3 04 40 80 00       	mov    %eax,0x804004
  801b98:	83 c4 10             	add    $0x10,%esp
  801b9b:	eb c6                	jmp    801b63 <nsipc+0x12>

00801b9d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	56                   	push   %esi
  801ba1:	53                   	push   %ebx
  801ba2:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801bad:	8b 06                	mov    (%esi),%eax
  801baf:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801bb4:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb9:	e8 93 ff ff ff       	call   801b51 <nsipc>
  801bbe:	89 c3                	mov    %eax,%ebx
  801bc0:	85 c0                	test   %eax,%eax
  801bc2:	79 09                	jns    801bcd <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801bc4:	89 d8                	mov    %ebx,%eax
  801bc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bc9:	5b                   	pop    %ebx
  801bca:	5e                   	pop    %esi
  801bcb:	5d                   	pop    %ebp
  801bcc:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801bcd:	83 ec 04             	sub    $0x4,%esp
  801bd0:	ff 35 10 60 80 00    	pushl  0x806010
  801bd6:	68 00 60 80 00       	push   $0x806000
  801bdb:	ff 75 0c             	pushl  0xc(%ebp)
  801bde:	e8 47 ef ff ff       	call   800b2a <memmove>
		*addrlen = ret->ret_addrlen;
  801be3:	a1 10 60 80 00       	mov    0x806010,%eax
  801be8:	89 06                	mov    %eax,(%esi)
  801bea:	83 c4 10             	add    $0x10,%esp
	return r;
  801bed:	eb d5                	jmp    801bc4 <nsipc_accept+0x27>

00801bef <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
  801bf2:	53                   	push   %ebx
  801bf3:	83 ec 08             	sub    $0x8,%esp
  801bf6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfc:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c01:	53                   	push   %ebx
  801c02:	ff 75 0c             	pushl  0xc(%ebp)
  801c05:	68 04 60 80 00       	push   $0x806004
  801c0a:	e8 1b ef ff ff       	call   800b2a <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c0f:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c15:	b8 02 00 00 00       	mov    $0x2,%eax
  801c1a:	e8 32 ff ff ff       	call   801b51 <nsipc>
}
  801c1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c22:	c9                   	leave  
  801c23:	c3                   	ret    

00801c24 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
  801c27:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c32:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c35:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801c3a:	b8 03 00 00 00       	mov    $0x3,%eax
  801c3f:	e8 0d ff ff ff       	call   801b51 <nsipc>
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <nsipc_close>:

int
nsipc_close(int s)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
  801c49:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4f:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c54:	b8 04 00 00 00       	mov    $0x4,%eax
  801c59:	e8 f3 fe ff ff       	call   801b51 <nsipc>
}
  801c5e:	c9                   	leave  
  801c5f:	c3                   	ret    

00801c60 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
  801c63:	53                   	push   %ebx
  801c64:	83 ec 08             	sub    $0x8,%esp
  801c67:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c72:	53                   	push   %ebx
  801c73:	ff 75 0c             	pushl  0xc(%ebp)
  801c76:	68 04 60 80 00       	push   $0x806004
  801c7b:	e8 aa ee ff ff       	call   800b2a <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c80:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c86:	b8 05 00 00 00       	mov    $0x5,%eax
  801c8b:	e8 c1 fe ff ff       	call   801b51 <nsipc>
}
  801c90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
  801c98:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801ca3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca6:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801cab:	b8 06 00 00 00       	mov    $0x6,%eax
  801cb0:	e8 9c fe ff ff       	call   801b51 <nsipc>
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
  801cba:	56                   	push   %esi
  801cbb:	53                   	push   %ebx
  801cbc:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801cc7:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801ccd:	8b 45 14             	mov    0x14(%ebp),%eax
  801cd0:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801cd5:	b8 07 00 00 00       	mov    $0x7,%eax
  801cda:	e8 72 fe ff ff       	call   801b51 <nsipc>
  801cdf:	89 c3                	mov    %eax,%ebx
  801ce1:	85 c0                	test   %eax,%eax
  801ce3:	78 1f                	js     801d04 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801ce5:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801cea:	7f 21                	jg     801d0d <nsipc_recv+0x56>
  801cec:	39 c6                	cmp    %eax,%esi
  801cee:	7c 1d                	jl     801d0d <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801cf0:	83 ec 04             	sub    $0x4,%esp
  801cf3:	50                   	push   %eax
  801cf4:	68 00 60 80 00       	push   $0x806000
  801cf9:	ff 75 0c             	pushl  0xc(%ebp)
  801cfc:	e8 29 ee ff ff       	call   800b2a <memmove>
  801d01:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d04:	89 d8                	mov    %ebx,%eax
  801d06:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d09:	5b                   	pop    %ebx
  801d0a:	5e                   	pop    %esi
  801d0b:	5d                   	pop    %ebp
  801d0c:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d0d:	68 bf 2b 80 00       	push   $0x802bbf
  801d12:	68 87 2b 80 00       	push   $0x802b87
  801d17:	6a 62                	push   $0x62
  801d19:	68 d4 2b 80 00       	push   $0x802bd4
  801d1e:	e8 24 e4 ff ff       	call   800147 <_panic>

00801d23 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
  801d26:	53                   	push   %ebx
  801d27:	83 ec 04             	sub    $0x4,%esp
  801d2a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d30:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d35:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d3b:	7f 2e                	jg     801d6b <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d3d:	83 ec 04             	sub    $0x4,%esp
  801d40:	53                   	push   %ebx
  801d41:	ff 75 0c             	pushl  0xc(%ebp)
  801d44:	68 0c 60 80 00       	push   $0x80600c
  801d49:	e8 dc ed ff ff       	call   800b2a <memmove>
	nsipcbuf.send.req_size = size;
  801d4e:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d54:	8b 45 14             	mov    0x14(%ebp),%eax
  801d57:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d5c:	b8 08 00 00 00       	mov    $0x8,%eax
  801d61:	e8 eb fd ff ff       	call   801b51 <nsipc>
}
  801d66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    
	assert(size < 1600);
  801d6b:	68 e0 2b 80 00       	push   $0x802be0
  801d70:	68 87 2b 80 00       	push   $0x802b87
  801d75:	6a 6d                	push   $0x6d
  801d77:	68 d4 2b 80 00       	push   $0x802bd4
  801d7c:	e8 c6 e3 ff ff       	call   800147 <_panic>

00801d81 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
  801d84:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d87:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d92:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d97:	8b 45 10             	mov    0x10(%ebp),%eax
  801d9a:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d9f:	b8 09 00 00 00       	mov    $0x9,%eax
  801da4:	e8 a8 fd ff ff       	call   801b51 <nsipc>
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	56                   	push   %esi
  801daf:	53                   	push   %ebx
  801db0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801db3:	83 ec 0c             	sub    $0xc,%esp
  801db6:	ff 75 08             	pushl  0x8(%ebp)
  801db9:	e8 6a f3 ff ff       	call   801128 <fd2data>
  801dbe:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801dc0:	83 c4 08             	add    $0x8,%esp
  801dc3:	68 ec 2b 80 00       	push   $0x802bec
  801dc8:	53                   	push   %ebx
  801dc9:	e8 ce eb ff ff       	call   80099c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801dce:	8b 46 04             	mov    0x4(%esi),%eax
  801dd1:	2b 06                	sub    (%esi),%eax
  801dd3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801dd9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801de0:	00 00 00 
	stat->st_dev = &devpipe;
  801de3:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801dea:	30 80 00 
	return 0;
}
  801ded:	b8 00 00 00 00       	mov    $0x0,%eax
  801df2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801df5:	5b                   	pop    %ebx
  801df6:	5e                   	pop    %esi
  801df7:	5d                   	pop    %ebp
  801df8:	c3                   	ret    

00801df9 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
  801dfc:	53                   	push   %ebx
  801dfd:	83 ec 0c             	sub    $0xc,%esp
  801e00:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e03:	53                   	push   %ebx
  801e04:	6a 00                	push   $0x0
  801e06:	e8 08 f0 ff ff       	call   800e13 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e0b:	89 1c 24             	mov    %ebx,(%esp)
  801e0e:	e8 15 f3 ff ff       	call   801128 <fd2data>
  801e13:	83 c4 08             	add    $0x8,%esp
  801e16:	50                   	push   %eax
  801e17:	6a 00                	push   $0x0
  801e19:	e8 f5 ef ff ff       	call   800e13 <sys_page_unmap>
}
  801e1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e21:	c9                   	leave  
  801e22:	c3                   	ret    

00801e23 <_pipeisclosed>:
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
  801e26:	57                   	push   %edi
  801e27:	56                   	push   %esi
  801e28:	53                   	push   %ebx
  801e29:	83 ec 1c             	sub    $0x1c,%esp
  801e2c:	89 c7                	mov    %eax,%edi
  801e2e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e30:	a1 08 40 80 00       	mov    0x804008,%eax
  801e35:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e38:	83 ec 0c             	sub    $0xc,%esp
  801e3b:	57                   	push   %edi
  801e3c:	e8 2d 05 00 00       	call   80236e <pageref>
  801e41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e44:	89 34 24             	mov    %esi,(%esp)
  801e47:	e8 22 05 00 00       	call   80236e <pageref>
		nn = thisenv->env_runs;
  801e4c:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801e52:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e55:	83 c4 10             	add    $0x10,%esp
  801e58:	39 cb                	cmp    %ecx,%ebx
  801e5a:	74 1b                	je     801e77 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e5c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e5f:	75 cf                	jne    801e30 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e61:	8b 42 58             	mov    0x58(%edx),%eax
  801e64:	6a 01                	push   $0x1
  801e66:	50                   	push   %eax
  801e67:	53                   	push   %ebx
  801e68:	68 f3 2b 80 00       	push   $0x802bf3
  801e6d:	e8 cb e3 ff ff       	call   80023d <cprintf>
  801e72:	83 c4 10             	add    $0x10,%esp
  801e75:	eb b9                	jmp    801e30 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e77:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e7a:	0f 94 c0             	sete   %al
  801e7d:	0f b6 c0             	movzbl %al,%eax
}
  801e80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e83:	5b                   	pop    %ebx
  801e84:	5e                   	pop    %esi
  801e85:	5f                   	pop    %edi
  801e86:	5d                   	pop    %ebp
  801e87:	c3                   	ret    

00801e88 <devpipe_write>:
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
  801e8b:	57                   	push   %edi
  801e8c:	56                   	push   %esi
  801e8d:	53                   	push   %ebx
  801e8e:	83 ec 28             	sub    $0x28,%esp
  801e91:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e94:	56                   	push   %esi
  801e95:	e8 8e f2 ff ff       	call   801128 <fd2data>
  801e9a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e9c:	83 c4 10             	add    $0x10,%esp
  801e9f:	bf 00 00 00 00       	mov    $0x0,%edi
  801ea4:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ea7:	74 4f                	je     801ef8 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ea9:	8b 43 04             	mov    0x4(%ebx),%eax
  801eac:	8b 0b                	mov    (%ebx),%ecx
  801eae:	8d 51 20             	lea    0x20(%ecx),%edx
  801eb1:	39 d0                	cmp    %edx,%eax
  801eb3:	72 14                	jb     801ec9 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801eb5:	89 da                	mov    %ebx,%edx
  801eb7:	89 f0                	mov    %esi,%eax
  801eb9:	e8 65 ff ff ff       	call   801e23 <_pipeisclosed>
  801ebe:	85 c0                	test   %eax,%eax
  801ec0:	75 3b                	jne    801efd <devpipe_write+0x75>
			sys_yield();
  801ec2:	e8 a8 ee ff ff       	call   800d6f <sys_yield>
  801ec7:	eb e0                	jmp    801ea9 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ec9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ecc:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ed0:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ed3:	89 c2                	mov    %eax,%edx
  801ed5:	c1 fa 1f             	sar    $0x1f,%edx
  801ed8:	89 d1                	mov    %edx,%ecx
  801eda:	c1 e9 1b             	shr    $0x1b,%ecx
  801edd:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ee0:	83 e2 1f             	and    $0x1f,%edx
  801ee3:	29 ca                	sub    %ecx,%edx
  801ee5:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ee9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801eed:	83 c0 01             	add    $0x1,%eax
  801ef0:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ef3:	83 c7 01             	add    $0x1,%edi
  801ef6:	eb ac                	jmp    801ea4 <devpipe_write+0x1c>
	return i;
  801ef8:	8b 45 10             	mov    0x10(%ebp),%eax
  801efb:	eb 05                	jmp    801f02 <devpipe_write+0x7a>
				return 0;
  801efd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f02:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f05:	5b                   	pop    %ebx
  801f06:	5e                   	pop    %esi
  801f07:	5f                   	pop    %edi
  801f08:	5d                   	pop    %ebp
  801f09:	c3                   	ret    

00801f0a <devpipe_read>:
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
  801f0d:	57                   	push   %edi
  801f0e:	56                   	push   %esi
  801f0f:	53                   	push   %ebx
  801f10:	83 ec 18             	sub    $0x18,%esp
  801f13:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f16:	57                   	push   %edi
  801f17:	e8 0c f2 ff ff       	call   801128 <fd2data>
  801f1c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f1e:	83 c4 10             	add    $0x10,%esp
  801f21:	be 00 00 00 00       	mov    $0x0,%esi
  801f26:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f29:	75 14                	jne    801f3f <devpipe_read+0x35>
	return i;
  801f2b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f2e:	eb 02                	jmp    801f32 <devpipe_read+0x28>
				return i;
  801f30:	89 f0                	mov    %esi,%eax
}
  801f32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f35:	5b                   	pop    %ebx
  801f36:	5e                   	pop    %esi
  801f37:	5f                   	pop    %edi
  801f38:	5d                   	pop    %ebp
  801f39:	c3                   	ret    
			sys_yield();
  801f3a:	e8 30 ee ff ff       	call   800d6f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801f3f:	8b 03                	mov    (%ebx),%eax
  801f41:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f44:	75 18                	jne    801f5e <devpipe_read+0x54>
			if (i > 0)
  801f46:	85 f6                	test   %esi,%esi
  801f48:	75 e6                	jne    801f30 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801f4a:	89 da                	mov    %ebx,%edx
  801f4c:	89 f8                	mov    %edi,%eax
  801f4e:	e8 d0 fe ff ff       	call   801e23 <_pipeisclosed>
  801f53:	85 c0                	test   %eax,%eax
  801f55:	74 e3                	je     801f3a <devpipe_read+0x30>
				return 0;
  801f57:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5c:	eb d4                	jmp    801f32 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f5e:	99                   	cltd   
  801f5f:	c1 ea 1b             	shr    $0x1b,%edx
  801f62:	01 d0                	add    %edx,%eax
  801f64:	83 e0 1f             	and    $0x1f,%eax
  801f67:	29 d0                	sub    %edx,%eax
  801f69:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f71:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f74:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f77:	83 c6 01             	add    $0x1,%esi
  801f7a:	eb aa                	jmp    801f26 <devpipe_read+0x1c>

00801f7c <pipe>:
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
  801f7f:	56                   	push   %esi
  801f80:	53                   	push   %ebx
  801f81:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f84:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f87:	50                   	push   %eax
  801f88:	e8 b2 f1 ff ff       	call   80113f <fd_alloc>
  801f8d:	89 c3                	mov    %eax,%ebx
  801f8f:	83 c4 10             	add    $0x10,%esp
  801f92:	85 c0                	test   %eax,%eax
  801f94:	0f 88 23 01 00 00    	js     8020bd <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f9a:	83 ec 04             	sub    $0x4,%esp
  801f9d:	68 07 04 00 00       	push   $0x407
  801fa2:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa5:	6a 00                	push   $0x0
  801fa7:	e8 e2 ed ff ff       	call   800d8e <sys_page_alloc>
  801fac:	89 c3                	mov    %eax,%ebx
  801fae:	83 c4 10             	add    $0x10,%esp
  801fb1:	85 c0                	test   %eax,%eax
  801fb3:	0f 88 04 01 00 00    	js     8020bd <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801fb9:	83 ec 0c             	sub    $0xc,%esp
  801fbc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fbf:	50                   	push   %eax
  801fc0:	e8 7a f1 ff ff       	call   80113f <fd_alloc>
  801fc5:	89 c3                	mov    %eax,%ebx
  801fc7:	83 c4 10             	add    $0x10,%esp
  801fca:	85 c0                	test   %eax,%eax
  801fcc:	0f 88 db 00 00 00    	js     8020ad <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fd2:	83 ec 04             	sub    $0x4,%esp
  801fd5:	68 07 04 00 00       	push   $0x407
  801fda:	ff 75 f0             	pushl  -0x10(%ebp)
  801fdd:	6a 00                	push   $0x0
  801fdf:	e8 aa ed ff ff       	call   800d8e <sys_page_alloc>
  801fe4:	89 c3                	mov    %eax,%ebx
  801fe6:	83 c4 10             	add    $0x10,%esp
  801fe9:	85 c0                	test   %eax,%eax
  801feb:	0f 88 bc 00 00 00    	js     8020ad <pipe+0x131>
	va = fd2data(fd0);
  801ff1:	83 ec 0c             	sub    $0xc,%esp
  801ff4:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff7:	e8 2c f1 ff ff       	call   801128 <fd2data>
  801ffc:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ffe:	83 c4 0c             	add    $0xc,%esp
  802001:	68 07 04 00 00       	push   $0x407
  802006:	50                   	push   %eax
  802007:	6a 00                	push   $0x0
  802009:	e8 80 ed ff ff       	call   800d8e <sys_page_alloc>
  80200e:	89 c3                	mov    %eax,%ebx
  802010:	83 c4 10             	add    $0x10,%esp
  802013:	85 c0                	test   %eax,%eax
  802015:	0f 88 82 00 00 00    	js     80209d <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80201b:	83 ec 0c             	sub    $0xc,%esp
  80201e:	ff 75 f0             	pushl  -0x10(%ebp)
  802021:	e8 02 f1 ff ff       	call   801128 <fd2data>
  802026:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80202d:	50                   	push   %eax
  80202e:	6a 00                	push   $0x0
  802030:	56                   	push   %esi
  802031:	6a 00                	push   $0x0
  802033:	e8 99 ed ff ff       	call   800dd1 <sys_page_map>
  802038:	89 c3                	mov    %eax,%ebx
  80203a:	83 c4 20             	add    $0x20,%esp
  80203d:	85 c0                	test   %eax,%eax
  80203f:	78 4e                	js     80208f <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802041:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802046:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802049:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80204b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204e:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802055:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802058:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80205a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802064:	83 ec 0c             	sub    $0xc,%esp
  802067:	ff 75 f4             	pushl  -0xc(%ebp)
  80206a:	e8 a9 f0 ff ff       	call   801118 <fd2num>
  80206f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802072:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802074:	83 c4 04             	add    $0x4,%esp
  802077:	ff 75 f0             	pushl  -0x10(%ebp)
  80207a:	e8 99 f0 ff ff       	call   801118 <fd2num>
  80207f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802082:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802085:	83 c4 10             	add    $0x10,%esp
  802088:	bb 00 00 00 00       	mov    $0x0,%ebx
  80208d:	eb 2e                	jmp    8020bd <pipe+0x141>
	sys_page_unmap(0, va);
  80208f:	83 ec 08             	sub    $0x8,%esp
  802092:	56                   	push   %esi
  802093:	6a 00                	push   $0x0
  802095:	e8 79 ed ff ff       	call   800e13 <sys_page_unmap>
  80209a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80209d:	83 ec 08             	sub    $0x8,%esp
  8020a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8020a3:	6a 00                	push   $0x0
  8020a5:	e8 69 ed ff ff       	call   800e13 <sys_page_unmap>
  8020aa:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8020ad:	83 ec 08             	sub    $0x8,%esp
  8020b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8020b3:	6a 00                	push   $0x0
  8020b5:	e8 59 ed ff ff       	call   800e13 <sys_page_unmap>
  8020ba:	83 c4 10             	add    $0x10,%esp
}
  8020bd:	89 d8                	mov    %ebx,%eax
  8020bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020c2:	5b                   	pop    %ebx
  8020c3:	5e                   	pop    %esi
  8020c4:	5d                   	pop    %ebp
  8020c5:	c3                   	ret    

008020c6 <pipeisclosed>:
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
  8020c9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020cf:	50                   	push   %eax
  8020d0:	ff 75 08             	pushl  0x8(%ebp)
  8020d3:	e8 b9 f0 ff ff       	call   801191 <fd_lookup>
  8020d8:	83 c4 10             	add    $0x10,%esp
  8020db:	85 c0                	test   %eax,%eax
  8020dd:	78 18                	js     8020f7 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8020df:	83 ec 0c             	sub    $0xc,%esp
  8020e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e5:	e8 3e f0 ff ff       	call   801128 <fd2data>
	return _pipeisclosed(fd, p);
  8020ea:	89 c2                	mov    %eax,%edx
  8020ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ef:	e8 2f fd ff ff       	call   801e23 <_pipeisclosed>
  8020f4:	83 c4 10             	add    $0x10,%esp
}
  8020f7:	c9                   	leave  
  8020f8:	c3                   	ret    

008020f9 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8020f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020fe:	c3                   	ret    

008020ff <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
  802102:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802105:	68 0b 2c 80 00       	push   $0x802c0b
  80210a:	ff 75 0c             	pushl  0xc(%ebp)
  80210d:	e8 8a e8 ff ff       	call   80099c <strcpy>
	return 0;
}
  802112:	b8 00 00 00 00       	mov    $0x0,%eax
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <devcons_write>:
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
  80211c:	57                   	push   %edi
  80211d:	56                   	push   %esi
  80211e:	53                   	push   %ebx
  80211f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802125:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80212a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802130:	3b 75 10             	cmp    0x10(%ebp),%esi
  802133:	73 31                	jae    802166 <devcons_write+0x4d>
		m = n - tot;
  802135:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802138:	29 f3                	sub    %esi,%ebx
  80213a:	83 fb 7f             	cmp    $0x7f,%ebx
  80213d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802142:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802145:	83 ec 04             	sub    $0x4,%esp
  802148:	53                   	push   %ebx
  802149:	89 f0                	mov    %esi,%eax
  80214b:	03 45 0c             	add    0xc(%ebp),%eax
  80214e:	50                   	push   %eax
  80214f:	57                   	push   %edi
  802150:	e8 d5 e9 ff ff       	call   800b2a <memmove>
		sys_cputs(buf, m);
  802155:	83 c4 08             	add    $0x8,%esp
  802158:	53                   	push   %ebx
  802159:	57                   	push   %edi
  80215a:	e8 73 eb ff ff       	call   800cd2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80215f:	01 de                	add    %ebx,%esi
  802161:	83 c4 10             	add    $0x10,%esp
  802164:	eb ca                	jmp    802130 <devcons_write+0x17>
}
  802166:	89 f0                	mov    %esi,%eax
  802168:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80216b:	5b                   	pop    %ebx
  80216c:	5e                   	pop    %esi
  80216d:	5f                   	pop    %edi
  80216e:	5d                   	pop    %ebp
  80216f:	c3                   	ret    

00802170 <devcons_read>:
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
  802173:	83 ec 08             	sub    $0x8,%esp
  802176:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80217b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80217f:	74 21                	je     8021a2 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802181:	e8 6a eb ff ff       	call   800cf0 <sys_cgetc>
  802186:	85 c0                	test   %eax,%eax
  802188:	75 07                	jne    802191 <devcons_read+0x21>
		sys_yield();
  80218a:	e8 e0 eb ff ff       	call   800d6f <sys_yield>
  80218f:	eb f0                	jmp    802181 <devcons_read+0x11>
	if (c < 0)
  802191:	78 0f                	js     8021a2 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802193:	83 f8 04             	cmp    $0x4,%eax
  802196:	74 0c                	je     8021a4 <devcons_read+0x34>
	*(char*)vbuf = c;
  802198:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219b:	88 02                	mov    %al,(%edx)
	return 1;
  80219d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8021a2:	c9                   	leave  
  8021a3:	c3                   	ret    
		return 0;
  8021a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a9:	eb f7                	jmp    8021a2 <devcons_read+0x32>

008021ab <cputchar>:
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
  8021ae:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b4:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8021b7:	6a 01                	push   $0x1
  8021b9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021bc:	50                   	push   %eax
  8021bd:	e8 10 eb ff ff       	call   800cd2 <sys_cputs>
}
  8021c2:	83 c4 10             	add    $0x10,%esp
  8021c5:	c9                   	leave  
  8021c6:	c3                   	ret    

008021c7 <getchar>:
{
  8021c7:	55                   	push   %ebp
  8021c8:	89 e5                	mov    %esp,%ebp
  8021ca:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8021cd:	6a 01                	push   $0x1
  8021cf:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021d2:	50                   	push   %eax
  8021d3:	6a 00                	push   $0x0
  8021d5:	e8 27 f2 ff ff       	call   801401 <read>
	if (r < 0)
  8021da:	83 c4 10             	add    $0x10,%esp
  8021dd:	85 c0                	test   %eax,%eax
  8021df:	78 06                	js     8021e7 <getchar+0x20>
	if (r < 1)
  8021e1:	74 06                	je     8021e9 <getchar+0x22>
	return c;
  8021e3:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8021e7:	c9                   	leave  
  8021e8:	c3                   	ret    
		return -E_EOF;
  8021e9:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8021ee:	eb f7                	jmp    8021e7 <getchar+0x20>

008021f0 <iscons>:
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
  8021f3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021f9:	50                   	push   %eax
  8021fa:	ff 75 08             	pushl  0x8(%ebp)
  8021fd:	e8 8f ef ff ff       	call   801191 <fd_lookup>
  802202:	83 c4 10             	add    $0x10,%esp
  802205:	85 c0                	test   %eax,%eax
  802207:	78 11                	js     80221a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220c:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802212:	39 10                	cmp    %edx,(%eax)
  802214:	0f 94 c0             	sete   %al
  802217:	0f b6 c0             	movzbl %al,%eax
}
  80221a:	c9                   	leave  
  80221b:	c3                   	ret    

0080221c <opencons>:
{
  80221c:	55                   	push   %ebp
  80221d:	89 e5                	mov    %esp,%ebp
  80221f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802222:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802225:	50                   	push   %eax
  802226:	e8 14 ef ff ff       	call   80113f <fd_alloc>
  80222b:	83 c4 10             	add    $0x10,%esp
  80222e:	85 c0                	test   %eax,%eax
  802230:	78 3a                	js     80226c <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802232:	83 ec 04             	sub    $0x4,%esp
  802235:	68 07 04 00 00       	push   $0x407
  80223a:	ff 75 f4             	pushl  -0xc(%ebp)
  80223d:	6a 00                	push   $0x0
  80223f:	e8 4a eb ff ff       	call   800d8e <sys_page_alloc>
  802244:	83 c4 10             	add    $0x10,%esp
  802247:	85 c0                	test   %eax,%eax
  802249:	78 21                	js     80226c <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80224b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802254:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802259:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802260:	83 ec 0c             	sub    $0xc,%esp
  802263:	50                   	push   %eax
  802264:	e8 af ee ff ff       	call   801118 <fd2num>
  802269:	83 c4 10             	add    $0x10,%esp
}
  80226c:	c9                   	leave  
  80226d:	c3                   	ret    

0080226e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
  802271:	56                   	push   %esi
  802272:	53                   	push   %ebx
  802273:	8b 75 08             	mov    0x8(%ebp),%esi
  802276:	8b 45 0c             	mov    0xc(%ebp),%eax
  802279:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80227c:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80227e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802283:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802286:	83 ec 0c             	sub    $0xc,%esp
  802289:	50                   	push   %eax
  80228a:	e8 af ec ff ff       	call   800f3e <sys_ipc_recv>
	if(ret < 0){
  80228f:	83 c4 10             	add    $0x10,%esp
  802292:	85 c0                	test   %eax,%eax
  802294:	78 2b                	js     8022c1 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802296:	85 f6                	test   %esi,%esi
  802298:	74 0a                	je     8022a4 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80229a:	a1 08 40 80 00       	mov    0x804008,%eax
  80229f:	8b 40 78             	mov    0x78(%eax),%eax
  8022a2:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8022a4:	85 db                	test   %ebx,%ebx
  8022a6:	74 0a                	je     8022b2 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8022a8:	a1 08 40 80 00       	mov    0x804008,%eax
  8022ad:	8b 40 7c             	mov    0x7c(%eax),%eax
  8022b0:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8022b2:	a1 08 40 80 00       	mov    0x804008,%eax
  8022b7:	8b 40 74             	mov    0x74(%eax),%eax
}
  8022ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022bd:	5b                   	pop    %ebx
  8022be:	5e                   	pop    %esi
  8022bf:	5d                   	pop    %ebp
  8022c0:	c3                   	ret    
		if(from_env_store)
  8022c1:	85 f6                	test   %esi,%esi
  8022c3:	74 06                	je     8022cb <ipc_recv+0x5d>
			*from_env_store = 0;
  8022c5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8022cb:	85 db                	test   %ebx,%ebx
  8022cd:	74 eb                	je     8022ba <ipc_recv+0x4c>
			*perm_store = 0;
  8022cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022d5:	eb e3                	jmp    8022ba <ipc_recv+0x4c>

008022d7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8022d7:	55                   	push   %ebp
  8022d8:	89 e5                	mov    %esp,%ebp
  8022da:	57                   	push   %edi
  8022db:	56                   	push   %esi
  8022dc:	53                   	push   %ebx
  8022dd:	83 ec 0c             	sub    $0xc,%esp
  8022e0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022e3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8022e9:	85 db                	test   %ebx,%ebx
  8022eb:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8022f0:	0f 44 d8             	cmove  %eax,%ebx
  8022f3:	eb 05                	jmp    8022fa <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8022f5:	e8 75 ea ff ff       	call   800d6f <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8022fa:	ff 75 14             	pushl  0x14(%ebp)
  8022fd:	53                   	push   %ebx
  8022fe:	56                   	push   %esi
  8022ff:	57                   	push   %edi
  802300:	e8 16 ec ff ff       	call   800f1b <sys_ipc_try_send>
  802305:	83 c4 10             	add    $0x10,%esp
  802308:	85 c0                	test   %eax,%eax
  80230a:	74 1b                	je     802327 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80230c:	79 e7                	jns    8022f5 <ipc_send+0x1e>
  80230e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802311:	74 e2                	je     8022f5 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802313:	83 ec 04             	sub    $0x4,%esp
  802316:	68 17 2c 80 00       	push   $0x802c17
  80231b:	6a 46                	push   $0x46
  80231d:	68 2c 2c 80 00       	push   $0x802c2c
  802322:	e8 20 de ff ff       	call   800147 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802327:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80232a:	5b                   	pop    %ebx
  80232b:	5e                   	pop    %esi
  80232c:	5f                   	pop    %edi
  80232d:	5d                   	pop    %ebp
  80232e:	c3                   	ret    

0080232f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
  802332:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802335:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80233a:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802340:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802346:	8b 52 50             	mov    0x50(%edx),%edx
  802349:	39 ca                	cmp    %ecx,%edx
  80234b:	74 11                	je     80235e <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80234d:	83 c0 01             	add    $0x1,%eax
  802350:	3d 00 04 00 00       	cmp    $0x400,%eax
  802355:	75 e3                	jne    80233a <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802357:	b8 00 00 00 00       	mov    $0x0,%eax
  80235c:	eb 0e                	jmp    80236c <ipc_find_env+0x3d>
			return envs[i].env_id;
  80235e:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  802364:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802369:	8b 40 48             	mov    0x48(%eax),%eax
}
  80236c:	5d                   	pop    %ebp
  80236d:	c3                   	ret    

0080236e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80236e:	55                   	push   %ebp
  80236f:	89 e5                	mov    %esp,%ebp
  802371:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802374:	89 d0                	mov    %edx,%eax
  802376:	c1 e8 16             	shr    $0x16,%eax
  802379:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802380:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802385:	f6 c1 01             	test   $0x1,%cl
  802388:	74 1d                	je     8023a7 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80238a:	c1 ea 0c             	shr    $0xc,%edx
  80238d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802394:	f6 c2 01             	test   $0x1,%dl
  802397:	74 0e                	je     8023a7 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802399:	c1 ea 0c             	shr    $0xc,%edx
  80239c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023a3:	ef 
  8023a4:	0f b7 c0             	movzwl %ax,%eax
}
  8023a7:	5d                   	pop    %ebp
  8023a8:	c3                   	ret    
  8023a9:	66 90                	xchg   %ax,%ax
  8023ab:	66 90                	xchg   %ax,%ax
  8023ad:	66 90                	xchg   %ax,%ax
  8023af:	90                   	nop

008023b0 <__udivdi3>:
  8023b0:	55                   	push   %ebp
  8023b1:	57                   	push   %edi
  8023b2:	56                   	push   %esi
  8023b3:	53                   	push   %ebx
  8023b4:	83 ec 1c             	sub    $0x1c,%esp
  8023b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8023bb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8023bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023c3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8023c7:	85 d2                	test   %edx,%edx
  8023c9:	75 4d                	jne    802418 <__udivdi3+0x68>
  8023cb:	39 f3                	cmp    %esi,%ebx
  8023cd:	76 19                	jbe    8023e8 <__udivdi3+0x38>
  8023cf:	31 ff                	xor    %edi,%edi
  8023d1:	89 e8                	mov    %ebp,%eax
  8023d3:	89 f2                	mov    %esi,%edx
  8023d5:	f7 f3                	div    %ebx
  8023d7:	89 fa                	mov    %edi,%edx
  8023d9:	83 c4 1c             	add    $0x1c,%esp
  8023dc:	5b                   	pop    %ebx
  8023dd:	5e                   	pop    %esi
  8023de:	5f                   	pop    %edi
  8023df:	5d                   	pop    %ebp
  8023e0:	c3                   	ret    
  8023e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023e8:	89 d9                	mov    %ebx,%ecx
  8023ea:	85 db                	test   %ebx,%ebx
  8023ec:	75 0b                	jne    8023f9 <__udivdi3+0x49>
  8023ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f3:	31 d2                	xor    %edx,%edx
  8023f5:	f7 f3                	div    %ebx
  8023f7:	89 c1                	mov    %eax,%ecx
  8023f9:	31 d2                	xor    %edx,%edx
  8023fb:	89 f0                	mov    %esi,%eax
  8023fd:	f7 f1                	div    %ecx
  8023ff:	89 c6                	mov    %eax,%esi
  802401:	89 e8                	mov    %ebp,%eax
  802403:	89 f7                	mov    %esi,%edi
  802405:	f7 f1                	div    %ecx
  802407:	89 fa                	mov    %edi,%edx
  802409:	83 c4 1c             	add    $0x1c,%esp
  80240c:	5b                   	pop    %ebx
  80240d:	5e                   	pop    %esi
  80240e:	5f                   	pop    %edi
  80240f:	5d                   	pop    %ebp
  802410:	c3                   	ret    
  802411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802418:	39 f2                	cmp    %esi,%edx
  80241a:	77 1c                	ja     802438 <__udivdi3+0x88>
  80241c:	0f bd fa             	bsr    %edx,%edi
  80241f:	83 f7 1f             	xor    $0x1f,%edi
  802422:	75 2c                	jne    802450 <__udivdi3+0xa0>
  802424:	39 f2                	cmp    %esi,%edx
  802426:	72 06                	jb     80242e <__udivdi3+0x7e>
  802428:	31 c0                	xor    %eax,%eax
  80242a:	39 eb                	cmp    %ebp,%ebx
  80242c:	77 a9                	ja     8023d7 <__udivdi3+0x27>
  80242e:	b8 01 00 00 00       	mov    $0x1,%eax
  802433:	eb a2                	jmp    8023d7 <__udivdi3+0x27>
  802435:	8d 76 00             	lea    0x0(%esi),%esi
  802438:	31 ff                	xor    %edi,%edi
  80243a:	31 c0                	xor    %eax,%eax
  80243c:	89 fa                	mov    %edi,%edx
  80243e:	83 c4 1c             	add    $0x1c,%esp
  802441:	5b                   	pop    %ebx
  802442:	5e                   	pop    %esi
  802443:	5f                   	pop    %edi
  802444:	5d                   	pop    %ebp
  802445:	c3                   	ret    
  802446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80244d:	8d 76 00             	lea    0x0(%esi),%esi
  802450:	89 f9                	mov    %edi,%ecx
  802452:	b8 20 00 00 00       	mov    $0x20,%eax
  802457:	29 f8                	sub    %edi,%eax
  802459:	d3 e2                	shl    %cl,%edx
  80245b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80245f:	89 c1                	mov    %eax,%ecx
  802461:	89 da                	mov    %ebx,%edx
  802463:	d3 ea                	shr    %cl,%edx
  802465:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802469:	09 d1                	or     %edx,%ecx
  80246b:	89 f2                	mov    %esi,%edx
  80246d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802471:	89 f9                	mov    %edi,%ecx
  802473:	d3 e3                	shl    %cl,%ebx
  802475:	89 c1                	mov    %eax,%ecx
  802477:	d3 ea                	shr    %cl,%edx
  802479:	89 f9                	mov    %edi,%ecx
  80247b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80247f:	89 eb                	mov    %ebp,%ebx
  802481:	d3 e6                	shl    %cl,%esi
  802483:	89 c1                	mov    %eax,%ecx
  802485:	d3 eb                	shr    %cl,%ebx
  802487:	09 de                	or     %ebx,%esi
  802489:	89 f0                	mov    %esi,%eax
  80248b:	f7 74 24 08          	divl   0x8(%esp)
  80248f:	89 d6                	mov    %edx,%esi
  802491:	89 c3                	mov    %eax,%ebx
  802493:	f7 64 24 0c          	mull   0xc(%esp)
  802497:	39 d6                	cmp    %edx,%esi
  802499:	72 15                	jb     8024b0 <__udivdi3+0x100>
  80249b:	89 f9                	mov    %edi,%ecx
  80249d:	d3 e5                	shl    %cl,%ebp
  80249f:	39 c5                	cmp    %eax,%ebp
  8024a1:	73 04                	jae    8024a7 <__udivdi3+0xf7>
  8024a3:	39 d6                	cmp    %edx,%esi
  8024a5:	74 09                	je     8024b0 <__udivdi3+0x100>
  8024a7:	89 d8                	mov    %ebx,%eax
  8024a9:	31 ff                	xor    %edi,%edi
  8024ab:	e9 27 ff ff ff       	jmp    8023d7 <__udivdi3+0x27>
  8024b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8024b3:	31 ff                	xor    %edi,%edi
  8024b5:	e9 1d ff ff ff       	jmp    8023d7 <__udivdi3+0x27>
  8024ba:	66 90                	xchg   %ax,%ax
  8024bc:	66 90                	xchg   %ax,%ax
  8024be:	66 90                	xchg   %ax,%ax

008024c0 <__umoddi3>:
  8024c0:	55                   	push   %ebp
  8024c1:	57                   	push   %edi
  8024c2:	56                   	push   %esi
  8024c3:	53                   	push   %ebx
  8024c4:	83 ec 1c             	sub    $0x1c,%esp
  8024c7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8024cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8024cf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8024d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024d7:	89 da                	mov    %ebx,%edx
  8024d9:	85 c0                	test   %eax,%eax
  8024db:	75 43                	jne    802520 <__umoddi3+0x60>
  8024dd:	39 df                	cmp    %ebx,%edi
  8024df:	76 17                	jbe    8024f8 <__umoddi3+0x38>
  8024e1:	89 f0                	mov    %esi,%eax
  8024e3:	f7 f7                	div    %edi
  8024e5:	89 d0                	mov    %edx,%eax
  8024e7:	31 d2                	xor    %edx,%edx
  8024e9:	83 c4 1c             	add    $0x1c,%esp
  8024ec:	5b                   	pop    %ebx
  8024ed:	5e                   	pop    %esi
  8024ee:	5f                   	pop    %edi
  8024ef:	5d                   	pop    %ebp
  8024f0:	c3                   	ret    
  8024f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024f8:	89 fd                	mov    %edi,%ebp
  8024fa:	85 ff                	test   %edi,%edi
  8024fc:	75 0b                	jne    802509 <__umoddi3+0x49>
  8024fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802503:	31 d2                	xor    %edx,%edx
  802505:	f7 f7                	div    %edi
  802507:	89 c5                	mov    %eax,%ebp
  802509:	89 d8                	mov    %ebx,%eax
  80250b:	31 d2                	xor    %edx,%edx
  80250d:	f7 f5                	div    %ebp
  80250f:	89 f0                	mov    %esi,%eax
  802511:	f7 f5                	div    %ebp
  802513:	89 d0                	mov    %edx,%eax
  802515:	eb d0                	jmp    8024e7 <__umoddi3+0x27>
  802517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80251e:	66 90                	xchg   %ax,%ax
  802520:	89 f1                	mov    %esi,%ecx
  802522:	39 d8                	cmp    %ebx,%eax
  802524:	76 0a                	jbe    802530 <__umoddi3+0x70>
  802526:	89 f0                	mov    %esi,%eax
  802528:	83 c4 1c             	add    $0x1c,%esp
  80252b:	5b                   	pop    %ebx
  80252c:	5e                   	pop    %esi
  80252d:	5f                   	pop    %edi
  80252e:	5d                   	pop    %ebp
  80252f:	c3                   	ret    
  802530:	0f bd e8             	bsr    %eax,%ebp
  802533:	83 f5 1f             	xor    $0x1f,%ebp
  802536:	75 20                	jne    802558 <__umoddi3+0x98>
  802538:	39 d8                	cmp    %ebx,%eax
  80253a:	0f 82 b0 00 00 00    	jb     8025f0 <__umoddi3+0x130>
  802540:	39 f7                	cmp    %esi,%edi
  802542:	0f 86 a8 00 00 00    	jbe    8025f0 <__umoddi3+0x130>
  802548:	89 c8                	mov    %ecx,%eax
  80254a:	83 c4 1c             	add    $0x1c,%esp
  80254d:	5b                   	pop    %ebx
  80254e:	5e                   	pop    %esi
  80254f:	5f                   	pop    %edi
  802550:	5d                   	pop    %ebp
  802551:	c3                   	ret    
  802552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802558:	89 e9                	mov    %ebp,%ecx
  80255a:	ba 20 00 00 00       	mov    $0x20,%edx
  80255f:	29 ea                	sub    %ebp,%edx
  802561:	d3 e0                	shl    %cl,%eax
  802563:	89 44 24 08          	mov    %eax,0x8(%esp)
  802567:	89 d1                	mov    %edx,%ecx
  802569:	89 f8                	mov    %edi,%eax
  80256b:	d3 e8                	shr    %cl,%eax
  80256d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802571:	89 54 24 04          	mov    %edx,0x4(%esp)
  802575:	8b 54 24 04          	mov    0x4(%esp),%edx
  802579:	09 c1                	or     %eax,%ecx
  80257b:	89 d8                	mov    %ebx,%eax
  80257d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802581:	89 e9                	mov    %ebp,%ecx
  802583:	d3 e7                	shl    %cl,%edi
  802585:	89 d1                	mov    %edx,%ecx
  802587:	d3 e8                	shr    %cl,%eax
  802589:	89 e9                	mov    %ebp,%ecx
  80258b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80258f:	d3 e3                	shl    %cl,%ebx
  802591:	89 c7                	mov    %eax,%edi
  802593:	89 d1                	mov    %edx,%ecx
  802595:	89 f0                	mov    %esi,%eax
  802597:	d3 e8                	shr    %cl,%eax
  802599:	89 e9                	mov    %ebp,%ecx
  80259b:	89 fa                	mov    %edi,%edx
  80259d:	d3 e6                	shl    %cl,%esi
  80259f:	09 d8                	or     %ebx,%eax
  8025a1:	f7 74 24 08          	divl   0x8(%esp)
  8025a5:	89 d1                	mov    %edx,%ecx
  8025a7:	89 f3                	mov    %esi,%ebx
  8025a9:	f7 64 24 0c          	mull   0xc(%esp)
  8025ad:	89 c6                	mov    %eax,%esi
  8025af:	89 d7                	mov    %edx,%edi
  8025b1:	39 d1                	cmp    %edx,%ecx
  8025b3:	72 06                	jb     8025bb <__umoddi3+0xfb>
  8025b5:	75 10                	jne    8025c7 <__umoddi3+0x107>
  8025b7:	39 c3                	cmp    %eax,%ebx
  8025b9:	73 0c                	jae    8025c7 <__umoddi3+0x107>
  8025bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8025bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8025c3:	89 d7                	mov    %edx,%edi
  8025c5:	89 c6                	mov    %eax,%esi
  8025c7:	89 ca                	mov    %ecx,%edx
  8025c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025ce:	29 f3                	sub    %esi,%ebx
  8025d0:	19 fa                	sbb    %edi,%edx
  8025d2:	89 d0                	mov    %edx,%eax
  8025d4:	d3 e0                	shl    %cl,%eax
  8025d6:	89 e9                	mov    %ebp,%ecx
  8025d8:	d3 eb                	shr    %cl,%ebx
  8025da:	d3 ea                	shr    %cl,%edx
  8025dc:	09 d8                	or     %ebx,%eax
  8025de:	83 c4 1c             	add    $0x1c,%esp
  8025e1:	5b                   	pop    %ebx
  8025e2:	5e                   	pop    %esi
  8025e3:	5f                   	pop    %edi
  8025e4:	5d                   	pop    %ebp
  8025e5:	c3                   	ret    
  8025e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025ed:	8d 76 00             	lea    0x0(%esi),%esi
  8025f0:	89 da                	mov    %ebx,%edx
  8025f2:	29 fe                	sub    %edi,%esi
  8025f4:	19 c2                	sbb    %eax,%edx
  8025f6:	89 f1                	mov    %esi,%ecx
  8025f8:	89 c8                	mov    %ecx,%eax
  8025fa:	e9 4b ff ff ff       	jmp    80254a <__umoddi3+0x8a>
