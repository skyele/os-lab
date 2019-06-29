
obj/user/faultallocbad.debug:     file format elf32-i386


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
  80002c:	e8 d2 00 00 00       	call   800103 <libmain>
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
	cprintf("in faultallocbadddddddddddddddddddddd %s\n", __FUNCTION__);
  80003a:	68 68 27 80 00       	push   $0x802768
  80003f:	68 40 26 80 00       	push   $0x802640
  800044:	e8 2d 02 00 00       	call   800276 <cprintf>
	int r;
	void *addr = (void*)utf->utf_fault_va;
  800049:	8b 45 08             	mov    0x8(%ebp),%eax
  80004c:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  80004e:	83 c4 08             	add    $0x8,%esp
  800051:	53                   	push   %ebx
  800052:	68 26 27 80 00       	push   $0x802726
  800057:	e8 1a 02 00 00       	call   800276 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80005c:	83 c4 0c             	add    $0xc,%esp
  80005f:	6a 07                	push   $0x7
  800061:	89 d8                	mov    %ebx,%eax
  800063:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800068:	50                   	push   %eax
  800069:	6a 00                	push   $0x0
  80006b:	e8 57 0d 00 00       	call   800dc7 <sys_page_alloc>
  800070:	83 c4 10             	add    $0x10,%esp
  800073:	85 c0                	test   %eax,%eax
  800075:	78 16                	js     80008d <handler+0x5a>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800077:	53                   	push   %ebx
  800078:	68 98 26 80 00       	push   $0x802698
  80007d:	6a 64                	push   $0x64
  80007f:	53                   	push   %ebx
  800080:	e8 fd 08 00 00       	call   800982 <snprintf>
}
  800085:	83 c4 10             	add    $0x10,%esp
  800088:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80008b:	c9                   	leave  
  80008c:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80008d:	83 ec 0c             	sub    $0xc,%esp
  800090:	50                   	push   %eax
  800091:	53                   	push   %ebx
  800092:	68 6c 26 80 00       	push   $0x80266c
  800097:	6a 10                	push   $0x10
  800099:	68 30 27 80 00       	push   $0x802730
  80009e:	e8 dd 00 00 00       	call   800180 <_panic>

008000a3 <umain>:

void
umain(int argc, char **argv)
{
  8000a3:	55                   	push   %ebp
  8000a4:	89 e5                	mov    %esp,%ebp
  8000a6:	83 ec 14             	sub    $0x14,%esp
	cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8000a9:	68 bc 26 80 00       	push   $0x8026bc
  8000ae:	e8 c3 01 00 00       	call   800276 <cprintf>
	cprintf("before set_pgfault_handler() in %s\n", __FUNCTION__);
  8000b3:	83 c4 08             	add    $0x8,%esp
  8000b6:	68 60 27 80 00       	push   $0x802760
  8000bb:	68 e0 26 80 00       	push   $0x8026e0
  8000c0:	e8 b1 01 00 00       	call   800276 <cprintf>
	set_pgfault_handler(handler);
  8000c5:	c7 04 24 33 00 80 00 	movl   $0x800033,(%esp)
  8000cc:	e8 eb 0f 00 00       	call   8010bc <set_pgfault_handler>
	cprintf(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
  8000d1:	c7 04 24 04 27 80 00 	movl   $0x802704,(%esp)
  8000d8:	e8 99 01 00 00       	call   800276 <cprintf>
	cprintf("before sys_cputs() in %s\n", __FUNCTION__);
  8000dd:	83 c4 08             	add    $0x8,%esp
  8000e0:	68 60 27 80 00       	push   $0x802760
  8000e5:	68 45 27 80 00       	push   $0x802745
  8000ea:	e8 87 01 00 00       	call   800276 <cprintf>
	sys_cputs((char*)0xDEADBEEF, 4);
  8000ef:	83 c4 08             	add    $0x8,%esp
  8000f2:	6a 04                	push   $0x4
  8000f4:	68 ef be ad de       	push   $0xdeadbeef
  8000f9:	e8 0d 0c 00 00       	call   800d0b <sys_cputs>
}
  8000fe:	83 c4 10             	add    $0x10,%esp
  800101:	c9                   	leave  
  800102:	c3                   	ret    

00800103 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800103:	55                   	push   %ebp
  800104:	89 e5                	mov    %esp,%ebp
  800106:	56                   	push   %esi
  800107:	53                   	push   %ebx
  800108:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80010b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  80010e:	e8 76 0c 00 00       	call   800d89 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  800113:	25 ff 03 00 00       	and    $0x3ff,%eax
  800118:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80011e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800123:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800128:	85 db                	test   %ebx,%ebx
  80012a:	7e 07                	jle    800133 <libmain+0x30>
		binaryname = argv[0];
  80012c:	8b 06                	mov    (%esi),%eax
  80012e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800133:	83 ec 08             	sub    $0x8,%esp
  800136:	56                   	push   %esi
  800137:	53                   	push   %ebx
  800138:	e8 66 ff ff ff       	call   8000a3 <umain>

	// exit gracefully
	exit();
  80013d:	e8 0a 00 00 00       	call   80014c <exit>
}
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800148:	5b                   	pop    %ebx
  800149:	5e                   	pop    %esi
  80014a:	5d                   	pop    %ebp
  80014b:	c3                   	ret    

0080014c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800152:	a1 08 40 80 00       	mov    0x804008,%eax
  800157:	8b 40 48             	mov    0x48(%eax),%eax
  80015a:	68 88 27 80 00       	push   $0x802788
  80015f:	50                   	push   %eax
  800160:	68 7a 27 80 00       	push   $0x80277a
  800165:	e8 0c 01 00 00       	call   800276 <cprintf>
	close_all();
  80016a:	e8 ba 11 00 00       	call   801329 <close_all>
	sys_env_destroy(0);
  80016f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800176:	e8 cd 0b 00 00       	call   800d48 <sys_env_destroy>
}
  80017b:	83 c4 10             	add    $0x10,%esp
  80017e:	c9                   	leave  
  80017f:	c3                   	ret    

00800180 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800180:	55                   	push   %ebp
  800181:	89 e5                	mov    %esp,%ebp
  800183:	56                   	push   %esi
  800184:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800185:	a1 08 40 80 00       	mov    0x804008,%eax
  80018a:	8b 40 48             	mov    0x48(%eax),%eax
  80018d:	83 ec 04             	sub    $0x4,%esp
  800190:	68 b4 27 80 00       	push   $0x8027b4
  800195:	50                   	push   %eax
  800196:	68 7a 27 80 00       	push   $0x80277a
  80019b:	e8 d6 00 00 00       	call   800276 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8001a0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001a3:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8001a9:	e8 db 0b 00 00       	call   800d89 <sys_getenvid>
  8001ae:	83 c4 04             	add    $0x4,%esp
  8001b1:	ff 75 0c             	pushl  0xc(%ebp)
  8001b4:	ff 75 08             	pushl  0x8(%ebp)
  8001b7:	56                   	push   %esi
  8001b8:	50                   	push   %eax
  8001b9:	68 90 27 80 00       	push   $0x802790
  8001be:	e8 b3 00 00 00       	call   800276 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001c3:	83 c4 18             	add    $0x18,%esp
  8001c6:	53                   	push   %ebx
  8001c7:	ff 75 10             	pushl  0x10(%ebp)
  8001ca:	e8 56 00 00 00       	call   800225 <vcprintf>
	cprintf("\n");
  8001cf:	c7 04 24 2a 2d 80 00 	movl   $0x802d2a,(%esp)
  8001d6:	e8 9b 00 00 00       	call   800276 <cprintf>
  8001db:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001de:	cc                   	int3   
  8001df:	eb fd                	jmp    8001de <_panic+0x5e>

008001e1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001e1:	55                   	push   %ebp
  8001e2:	89 e5                	mov    %esp,%ebp
  8001e4:	53                   	push   %ebx
  8001e5:	83 ec 04             	sub    $0x4,%esp
  8001e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001eb:	8b 13                	mov    (%ebx),%edx
  8001ed:	8d 42 01             	lea    0x1(%edx),%eax
  8001f0:	89 03                	mov    %eax,(%ebx)
  8001f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001f5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001f9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001fe:	74 09                	je     800209 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800200:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800204:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800207:	c9                   	leave  
  800208:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800209:	83 ec 08             	sub    $0x8,%esp
  80020c:	68 ff 00 00 00       	push   $0xff
  800211:	8d 43 08             	lea    0x8(%ebx),%eax
  800214:	50                   	push   %eax
  800215:	e8 f1 0a 00 00       	call   800d0b <sys_cputs>
		b->idx = 0;
  80021a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800220:	83 c4 10             	add    $0x10,%esp
  800223:	eb db                	jmp    800200 <putch+0x1f>

00800225 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80022e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800235:	00 00 00 
	b.cnt = 0;
  800238:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80023f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800242:	ff 75 0c             	pushl  0xc(%ebp)
  800245:	ff 75 08             	pushl  0x8(%ebp)
  800248:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80024e:	50                   	push   %eax
  80024f:	68 e1 01 80 00       	push   $0x8001e1
  800254:	e8 4a 01 00 00       	call   8003a3 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800259:	83 c4 08             	add    $0x8,%esp
  80025c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800262:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800268:	50                   	push   %eax
  800269:	e8 9d 0a 00 00       	call   800d0b <sys_cputs>

	return b.cnt;
}
  80026e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800274:	c9                   	leave  
  800275:	c3                   	ret    

00800276 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800276:	55                   	push   %ebp
  800277:	89 e5                	mov    %esp,%ebp
  800279:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80027c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80027f:	50                   	push   %eax
  800280:	ff 75 08             	pushl  0x8(%ebp)
  800283:	e8 9d ff ff ff       	call   800225 <vcprintf>
	va_end(ap);

	return cnt;
}
  800288:	c9                   	leave  
  800289:	c3                   	ret    

0080028a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	57                   	push   %edi
  80028e:	56                   	push   %esi
  80028f:	53                   	push   %ebx
  800290:	83 ec 1c             	sub    $0x1c,%esp
  800293:	89 c6                	mov    %eax,%esi
  800295:	89 d7                	mov    %edx,%edi
  800297:	8b 45 08             	mov    0x8(%ebp),%eax
  80029a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80029d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002a0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a6:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8002a9:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002ad:	74 2c                	je     8002db <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8002af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002b2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002bc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002bf:	39 c2                	cmp    %eax,%edx
  8002c1:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002c4:	73 43                	jae    800309 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002c6:	83 eb 01             	sub    $0x1,%ebx
  8002c9:	85 db                	test   %ebx,%ebx
  8002cb:	7e 6c                	jle    800339 <printnum+0xaf>
				putch(padc, putdat);
  8002cd:	83 ec 08             	sub    $0x8,%esp
  8002d0:	57                   	push   %edi
  8002d1:	ff 75 18             	pushl  0x18(%ebp)
  8002d4:	ff d6                	call   *%esi
  8002d6:	83 c4 10             	add    $0x10,%esp
  8002d9:	eb eb                	jmp    8002c6 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002db:	83 ec 0c             	sub    $0xc,%esp
  8002de:	6a 20                	push   $0x20
  8002e0:	6a 00                	push   $0x0
  8002e2:	50                   	push   %eax
  8002e3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e6:	ff 75 e0             	pushl  -0x20(%ebp)
  8002e9:	89 fa                	mov    %edi,%edx
  8002eb:	89 f0                	mov    %esi,%eax
  8002ed:	e8 98 ff ff ff       	call   80028a <printnum>
		while (--width > 0)
  8002f2:	83 c4 20             	add    $0x20,%esp
  8002f5:	83 eb 01             	sub    $0x1,%ebx
  8002f8:	85 db                	test   %ebx,%ebx
  8002fa:	7e 65                	jle    800361 <printnum+0xd7>
			putch(padc, putdat);
  8002fc:	83 ec 08             	sub    $0x8,%esp
  8002ff:	57                   	push   %edi
  800300:	6a 20                	push   $0x20
  800302:	ff d6                	call   *%esi
  800304:	83 c4 10             	add    $0x10,%esp
  800307:	eb ec                	jmp    8002f5 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800309:	83 ec 0c             	sub    $0xc,%esp
  80030c:	ff 75 18             	pushl  0x18(%ebp)
  80030f:	83 eb 01             	sub    $0x1,%ebx
  800312:	53                   	push   %ebx
  800313:	50                   	push   %eax
  800314:	83 ec 08             	sub    $0x8,%esp
  800317:	ff 75 dc             	pushl  -0x24(%ebp)
  80031a:	ff 75 d8             	pushl  -0x28(%ebp)
  80031d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800320:	ff 75 e0             	pushl  -0x20(%ebp)
  800323:	e8 c8 20 00 00       	call   8023f0 <__udivdi3>
  800328:	83 c4 18             	add    $0x18,%esp
  80032b:	52                   	push   %edx
  80032c:	50                   	push   %eax
  80032d:	89 fa                	mov    %edi,%edx
  80032f:	89 f0                	mov    %esi,%eax
  800331:	e8 54 ff ff ff       	call   80028a <printnum>
  800336:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800339:	83 ec 08             	sub    $0x8,%esp
  80033c:	57                   	push   %edi
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	ff 75 dc             	pushl  -0x24(%ebp)
  800343:	ff 75 d8             	pushl  -0x28(%ebp)
  800346:	ff 75 e4             	pushl  -0x1c(%ebp)
  800349:	ff 75 e0             	pushl  -0x20(%ebp)
  80034c:	e8 af 21 00 00       	call   802500 <__umoddi3>
  800351:	83 c4 14             	add    $0x14,%esp
  800354:	0f be 80 bb 27 80 00 	movsbl 0x8027bb(%eax),%eax
  80035b:	50                   	push   %eax
  80035c:	ff d6                	call   *%esi
  80035e:	83 c4 10             	add    $0x10,%esp
	}
}
  800361:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800364:	5b                   	pop    %ebx
  800365:	5e                   	pop    %esi
  800366:	5f                   	pop    %edi
  800367:	5d                   	pop    %ebp
  800368:	c3                   	ret    

00800369 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800369:	55                   	push   %ebp
  80036a:	89 e5                	mov    %esp,%ebp
  80036c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80036f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800373:	8b 10                	mov    (%eax),%edx
  800375:	3b 50 04             	cmp    0x4(%eax),%edx
  800378:	73 0a                	jae    800384 <sprintputch+0x1b>
		*b->buf++ = ch;
  80037a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80037d:	89 08                	mov    %ecx,(%eax)
  80037f:	8b 45 08             	mov    0x8(%ebp),%eax
  800382:	88 02                	mov    %al,(%edx)
}
  800384:	5d                   	pop    %ebp
  800385:	c3                   	ret    

00800386 <printfmt>:
{
  800386:	55                   	push   %ebp
  800387:	89 e5                	mov    %esp,%ebp
  800389:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80038c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80038f:	50                   	push   %eax
  800390:	ff 75 10             	pushl  0x10(%ebp)
  800393:	ff 75 0c             	pushl  0xc(%ebp)
  800396:	ff 75 08             	pushl  0x8(%ebp)
  800399:	e8 05 00 00 00       	call   8003a3 <vprintfmt>
}
  80039e:	83 c4 10             	add    $0x10,%esp
  8003a1:	c9                   	leave  
  8003a2:	c3                   	ret    

008003a3 <vprintfmt>:
{
  8003a3:	55                   	push   %ebp
  8003a4:	89 e5                	mov    %esp,%ebp
  8003a6:	57                   	push   %edi
  8003a7:	56                   	push   %esi
  8003a8:	53                   	push   %ebx
  8003a9:	83 ec 3c             	sub    $0x3c,%esp
  8003ac:	8b 75 08             	mov    0x8(%ebp),%esi
  8003af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003b2:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003b5:	e9 32 04 00 00       	jmp    8007ec <vprintfmt+0x449>
		padc = ' ';
  8003ba:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003be:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003c5:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003cc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003d3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003da:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003e1:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003e6:	8d 47 01             	lea    0x1(%edi),%eax
  8003e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ec:	0f b6 17             	movzbl (%edi),%edx
  8003ef:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003f2:	3c 55                	cmp    $0x55,%al
  8003f4:	0f 87 12 05 00 00    	ja     80090c <vprintfmt+0x569>
  8003fa:	0f b6 c0             	movzbl %al,%eax
  8003fd:	ff 24 85 a0 29 80 00 	jmp    *0x8029a0(,%eax,4)
  800404:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800407:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80040b:	eb d9                	jmp    8003e6 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80040d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800410:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800414:	eb d0                	jmp    8003e6 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800416:	0f b6 d2             	movzbl %dl,%edx
  800419:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80041c:	b8 00 00 00 00       	mov    $0x0,%eax
  800421:	89 75 08             	mov    %esi,0x8(%ebp)
  800424:	eb 03                	jmp    800429 <vprintfmt+0x86>
  800426:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800429:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80042c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800430:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800433:	8d 72 d0             	lea    -0x30(%edx),%esi
  800436:	83 fe 09             	cmp    $0x9,%esi
  800439:	76 eb                	jbe    800426 <vprintfmt+0x83>
  80043b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80043e:	8b 75 08             	mov    0x8(%ebp),%esi
  800441:	eb 14                	jmp    800457 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800443:	8b 45 14             	mov    0x14(%ebp),%eax
  800446:	8b 00                	mov    (%eax),%eax
  800448:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80044b:	8b 45 14             	mov    0x14(%ebp),%eax
  80044e:	8d 40 04             	lea    0x4(%eax),%eax
  800451:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800454:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800457:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80045b:	79 89                	jns    8003e6 <vprintfmt+0x43>
				width = precision, precision = -1;
  80045d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800460:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800463:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80046a:	e9 77 ff ff ff       	jmp    8003e6 <vprintfmt+0x43>
  80046f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800472:	85 c0                	test   %eax,%eax
  800474:	0f 48 c1             	cmovs  %ecx,%eax
  800477:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80047a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80047d:	e9 64 ff ff ff       	jmp    8003e6 <vprintfmt+0x43>
  800482:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800485:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80048c:	e9 55 ff ff ff       	jmp    8003e6 <vprintfmt+0x43>
			lflag++;
  800491:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800495:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800498:	e9 49 ff ff ff       	jmp    8003e6 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80049d:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a0:	8d 78 04             	lea    0x4(%eax),%edi
  8004a3:	83 ec 08             	sub    $0x8,%esp
  8004a6:	53                   	push   %ebx
  8004a7:	ff 30                	pushl  (%eax)
  8004a9:	ff d6                	call   *%esi
			break;
  8004ab:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004ae:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004b1:	e9 33 03 00 00       	jmp    8007e9 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b9:	8d 78 04             	lea    0x4(%eax),%edi
  8004bc:	8b 00                	mov    (%eax),%eax
  8004be:	99                   	cltd   
  8004bf:	31 d0                	xor    %edx,%eax
  8004c1:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004c3:	83 f8 11             	cmp    $0x11,%eax
  8004c6:	7f 23                	jg     8004eb <vprintfmt+0x148>
  8004c8:	8b 14 85 00 2b 80 00 	mov    0x802b00(,%eax,4),%edx
  8004cf:	85 d2                	test   %edx,%edx
  8004d1:	74 18                	je     8004eb <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004d3:	52                   	push   %edx
  8004d4:	68 99 2c 80 00       	push   $0x802c99
  8004d9:	53                   	push   %ebx
  8004da:	56                   	push   %esi
  8004db:	e8 a6 fe ff ff       	call   800386 <printfmt>
  8004e0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004e3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004e6:	e9 fe 02 00 00       	jmp    8007e9 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004eb:	50                   	push   %eax
  8004ec:	68 d3 27 80 00       	push   $0x8027d3
  8004f1:	53                   	push   %ebx
  8004f2:	56                   	push   %esi
  8004f3:	e8 8e fe ff ff       	call   800386 <printfmt>
  8004f8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004fb:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004fe:	e9 e6 02 00 00       	jmp    8007e9 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800503:	8b 45 14             	mov    0x14(%ebp),%eax
  800506:	83 c0 04             	add    $0x4,%eax
  800509:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80050c:	8b 45 14             	mov    0x14(%ebp),%eax
  80050f:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800511:	85 c9                	test   %ecx,%ecx
  800513:	b8 cc 27 80 00       	mov    $0x8027cc,%eax
  800518:	0f 45 c1             	cmovne %ecx,%eax
  80051b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80051e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800522:	7e 06                	jle    80052a <vprintfmt+0x187>
  800524:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800528:	75 0d                	jne    800537 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80052a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80052d:	89 c7                	mov    %eax,%edi
  80052f:	03 45 e0             	add    -0x20(%ebp),%eax
  800532:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800535:	eb 53                	jmp    80058a <vprintfmt+0x1e7>
  800537:	83 ec 08             	sub    $0x8,%esp
  80053a:	ff 75 d8             	pushl  -0x28(%ebp)
  80053d:	50                   	push   %eax
  80053e:	e8 71 04 00 00       	call   8009b4 <strnlen>
  800543:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800546:	29 c1                	sub    %eax,%ecx
  800548:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80054b:	83 c4 10             	add    $0x10,%esp
  80054e:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800550:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800554:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800557:	eb 0f                	jmp    800568 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800559:	83 ec 08             	sub    $0x8,%esp
  80055c:	53                   	push   %ebx
  80055d:	ff 75 e0             	pushl  -0x20(%ebp)
  800560:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800562:	83 ef 01             	sub    $0x1,%edi
  800565:	83 c4 10             	add    $0x10,%esp
  800568:	85 ff                	test   %edi,%edi
  80056a:	7f ed                	jg     800559 <vprintfmt+0x1b6>
  80056c:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80056f:	85 c9                	test   %ecx,%ecx
  800571:	b8 00 00 00 00       	mov    $0x0,%eax
  800576:	0f 49 c1             	cmovns %ecx,%eax
  800579:	29 c1                	sub    %eax,%ecx
  80057b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80057e:	eb aa                	jmp    80052a <vprintfmt+0x187>
					putch(ch, putdat);
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	53                   	push   %ebx
  800584:	52                   	push   %edx
  800585:	ff d6                	call   *%esi
  800587:	83 c4 10             	add    $0x10,%esp
  80058a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80058d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80058f:	83 c7 01             	add    $0x1,%edi
  800592:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800596:	0f be d0             	movsbl %al,%edx
  800599:	85 d2                	test   %edx,%edx
  80059b:	74 4b                	je     8005e8 <vprintfmt+0x245>
  80059d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005a1:	78 06                	js     8005a9 <vprintfmt+0x206>
  8005a3:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005a7:	78 1e                	js     8005c7 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8005a9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005ad:	74 d1                	je     800580 <vprintfmt+0x1dd>
  8005af:	0f be c0             	movsbl %al,%eax
  8005b2:	83 e8 20             	sub    $0x20,%eax
  8005b5:	83 f8 5e             	cmp    $0x5e,%eax
  8005b8:	76 c6                	jbe    800580 <vprintfmt+0x1dd>
					putch('?', putdat);
  8005ba:	83 ec 08             	sub    $0x8,%esp
  8005bd:	53                   	push   %ebx
  8005be:	6a 3f                	push   $0x3f
  8005c0:	ff d6                	call   *%esi
  8005c2:	83 c4 10             	add    $0x10,%esp
  8005c5:	eb c3                	jmp    80058a <vprintfmt+0x1e7>
  8005c7:	89 cf                	mov    %ecx,%edi
  8005c9:	eb 0e                	jmp    8005d9 <vprintfmt+0x236>
				putch(' ', putdat);
  8005cb:	83 ec 08             	sub    $0x8,%esp
  8005ce:	53                   	push   %ebx
  8005cf:	6a 20                	push   $0x20
  8005d1:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005d3:	83 ef 01             	sub    $0x1,%edi
  8005d6:	83 c4 10             	add    $0x10,%esp
  8005d9:	85 ff                	test   %edi,%edi
  8005db:	7f ee                	jg     8005cb <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005dd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e3:	e9 01 02 00 00       	jmp    8007e9 <vprintfmt+0x446>
  8005e8:	89 cf                	mov    %ecx,%edi
  8005ea:	eb ed                	jmp    8005d9 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005ef:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005f6:	e9 eb fd ff ff       	jmp    8003e6 <vprintfmt+0x43>
	if (lflag >= 2)
  8005fb:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005ff:	7f 21                	jg     800622 <vprintfmt+0x27f>
	else if (lflag)
  800601:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800605:	74 68                	je     80066f <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800607:	8b 45 14             	mov    0x14(%ebp),%eax
  80060a:	8b 00                	mov    (%eax),%eax
  80060c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80060f:	89 c1                	mov    %eax,%ecx
  800611:	c1 f9 1f             	sar    $0x1f,%ecx
  800614:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800617:	8b 45 14             	mov    0x14(%ebp),%eax
  80061a:	8d 40 04             	lea    0x4(%eax),%eax
  80061d:	89 45 14             	mov    %eax,0x14(%ebp)
  800620:	eb 17                	jmp    800639 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	8b 50 04             	mov    0x4(%eax),%edx
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80062d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800630:	8b 45 14             	mov    0x14(%ebp),%eax
  800633:	8d 40 08             	lea    0x8(%eax),%eax
  800636:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800639:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80063c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80063f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800642:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800645:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800649:	78 3f                	js     80068a <vprintfmt+0x2e7>
			base = 10;
  80064b:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800650:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800654:	0f 84 71 01 00 00    	je     8007cb <vprintfmt+0x428>
				putch('+', putdat);
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	53                   	push   %ebx
  80065e:	6a 2b                	push   $0x2b
  800660:	ff d6                	call   *%esi
  800662:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800665:	b8 0a 00 00 00       	mov    $0xa,%eax
  80066a:	e9 5c 01 00 00       	jmp    8007cb <vprintfmt+0x428>
		return va_arg(*ap, int);
  80066f:	8b 45 14             	mov    0x14(%ebp),%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800677:	89 c1                	mov    %eax,%ecx
  800679:	c1 f9 1f             	sar    $0x1f,%ecx
  80067c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8d 40 04             	lea    0x4(%eax),%eax
  800685:	89 45 14             	mov    %eax,0x14(%ebp)
  800688:	eb af                	jmp    800639 <vprintfmt+0x296>
				putch('-', putdat);
  80068a:	83 ec 08             	sub    $0x8,%esp
  80068d:	53                   	push   %ebx
  80068e:	6a 2d                	push   $0x2d
  800690:	ff d6                	call   *%esi
				num = -(long long) num;
  800692:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800695:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800698:	f7 d8                	neg    %eax
  80069a:	83 d2 00             	adc    $0x0,%edx
  80069d:	f7 da                	neg    %edx
  80069f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006a8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ad:	e9 19 01 00 00       	jmp    8007cb <vprintfmt+0x428>
	if (lflag >= 2)
  8006b2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006b6:	7f 29                	jg     8006e1 <vprintfmt+0x33e>
	else if (lflag)
  8006b8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006bc:	74 44                	je     800702 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006be:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c1:	8b 00                	mov    (%eax),%eax
  8006c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006cb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d1:	8d 40 04             	lea    0x4(%eax),%eax
  8006d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006d7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006dc:	e9 ea 00 00 00       	jmp    8007cb <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e4:	8b 50 04             	mov    0x4(%eax),%edx
  8006e7:	8b 00                	mov    (%eax),%eax
  8006e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ec:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	8d 40 08             	lea    0x8(%eax),%eax
  8006f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006f8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006fd:	e9 c9 00 00 00       	jmp    8007cb <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800702:	8b 45 14             	mov    0x14(%ebp),%eax
  800705:	8b 00                	mov    (%eax),%eax
  800707:	ba 00 00 00 00       	mov    $0x0,%edx
  80070c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80070f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800712:	8b 45 14             	mov    0x14(%ebp),%eax
  800715:	8d 40 04             	lea    0x4(%eax),%eax
  800718:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80071b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800720:	e9 a6 00 00 00       	jmp    8007cb <vprintfmt+0x428>
			putch('0', putdat);
  800725:	83 ec 08             	sub    $0x8,%esp
  800728:	53                   	push   %ebx
  800729:	6a 30                	push   $0x30
  80072b:	ff d6                	call   *%esi
	if (lflag >= 2)
  80072d:	83 c4 10             	add    $0x10,%esp
  800730:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800734:	7f 26                	jg     80075c <vprintfmt+0x3b9>
	else if (lflag)
  800736:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80073a:	74 3e                	je     80077a <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80073c:	8b 45 14             	mov    0x14(%ebp),%eax
  80073f:	8b 00                	mov    (%eax),%eax
  800741:	ba 00 00 00 00       	mov    $0x0,%edx
  800746:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800749:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80074c:	8b 45 14             	mov    0x14(%ebp),%eax
  80074f:	8d 40 04             	lea    0x4(%eax),%eax
  800752:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800755:	b8 08 00 00 00       	mov    $0x8,%eax
  80075a:	eb 6f                	jmp    8007cb <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80075c:	8b 45 14             	mov    0x14(%ebp),%eax
  80075f:	8b 50 04             	mov    0x4(%eax),%edx
  800762:	8b 00                	mov    (%eax),%eax
  800764:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800767:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80076a:	8b 45 14             	mov    0x14(%ebp),%eax
  80076d:	8d 40 08             	lea    0x8(%eax),%eax
  800770:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800773:	b8 08 00 00 00       	mov    $0x8,%eax
  800778:	eb 51                	jmp    8007cb <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	ba 00 00 00 00       	mov    $0x0,%edx
  800784:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800787:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078a:	8b 45 14             	mov    0x14(%ebp),%eax
  80078d:	8d 40 04             	lea    0x4(%eax),%eax
  800790:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800793:	b8 08 00 00 00       	mov    $0x8,%eax
  800798:	eb 31                	jmp    8007cb <vprintfmt+0x428>
			putch('0', putdat);
  80079a:	83 ec 08             	sub    $0x8,%esp
  80079d:	53                   	push   %ebx
  80079e:	6a 30                	push   $0x30
  8007a0:	ff d6                	call   *%esi
			putch('x', putdat);
  8007a2:	83 c4 08             	add    $0x8,%esp
  8007a5:	53                   	push   %ebx
  8007a6:	6a 78                	push   $0x78
  8007a8:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ad:	8b 00                	mov    (%eax),%eax
  8007af:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007ba:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	8d 40 04             	lea    0x4(%eax),%eax
  8007c3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c6:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007cb:	83 ec 0c             	sub    $0xc,%esp
  8007ce:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007d2:	52                   	push   %edx
  8007d3:	ff 75 e0             	pushl  -0x20(%ebp)
  8007d6:	50                   	push   %eax
  8007d7:	ff 75 dc             	pushl  -0x24(%ebp)
  8007da:	ff 75 d8             	pushl  -0x28(%ebp)
  8007dd:	89 da                	mov    %ebx,%edx
  8007df:	89 f0                	mov    %esi,%eax
  8007e1:	e8 a4 fa ff ff       	call   80028a <printnum>
			break;
  8007e6:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ec:	83 c7 01             	add    $0x1,%edi
  8007ef:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007f3:	83 f8 25             	cmp    $0x25,%eax
  8007f6:	0f 84 be fb ff ff    	je     8003ba <vprintfmt+0x17>
			if (ch == '\0')
  8007fc:	85 c0                	test   %eax,%eax
  8007fe:	0f 84 28 01 00 00    	je     80092c <vprintfmt+0x589>
			putch(ch, putdat);
  800804:	83 ec 08             	sub    $0x8,%esp
  800807:	53                   	push   %ebx
  800808:	50                   	push   %eax
  800809:	ff d6                	call   *%esi
  80080b:	83 c4 10             	add    $0x10,%esp
  80080e:	eb dc                	jmp    8007ec <vprintfmt+0x449>
	if (lflag >= 2)
  800810:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800814:	7f 26                	jg     80083c <vprintfmt+0x499>
	else if (lflag)
  800816:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80081a:	74 41                	je     80085d <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	8b 00                	mov    (%eax),%eax
  800821:	ba 00 00 00 00       	mov    $0x0,%edx
  800826:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800829:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	8d 40 04             	lea    0x4(%eax),%eax
  800832:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800835:	b8 10 00 00 00       	mov    $0x10,%eax
  80083a:	eb 8f                	jmp    8007cb <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80083c:	8b 45 14             	mov    0x14(%ebp),%eax
  80083f:	8b 50 04             	mov    0x4(%eax),%edx
  800842:	8b 00                	mov    (%eax),%eax
  800844:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800847:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80084a:	8b 45 14             	mov    0x14(%ebp),%eax
  80084d:	8d 40 08             	lea    0x8(%eax),%eax
  800850:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800853:	b8 10 00 00 00       	mov    $0x10,%eax
  800858:	e9 6e ff ff ff       	jmp    8007cb <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80085d:	8b 45 14             	mov    0x14(%ebp),%eax
  800860:	8b 00                	mov    (%eax),%eax
  800862:	ba 00 00 00 00       	mov    $0x0,%edx
  800867:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80086a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80086d:	8b 45 14             	mov    0x14(%ebp),%eax
  800870:	8d 40 04             	lea    0x4(%eax),%eax
  800873:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800876:	b8 10 00 00 00       	mov    $0x10,%eax
  80087b:	e9 4b ff ff ff       	jmp    8007cb <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800880:	8b 45 14             	mov    0x14(%ebp),%eax
  800883:	83 c0 04             	add    $0x4,%eax
  800886:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800889:	8b 45 14             	mov    0x14(%ebp),%eax
  80088c:	8b 00                	mov    (%eax),%eax
  80088e:	85 c0                	test   %eax,%eax
  800890:	74 14                	je     8008a6 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800892:	8b 13                	mov    (%ebx),%edx
  800894:	83 fa 7f             	cmp    $0x7f,%edx
  800897:	7f 37                	jg     8008d0 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800899:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80089b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80089e:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a1:	e9 43 ff ff ff       	jmp    8007e9 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8008a6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008ab:	bf f1 28 80 00       	mov    $0x8028f1,%edi
							putch(ch, putdat);
  8008b0:	83 ec 08             	sub    $0x8,%esp
  8008b3:	53                   	push   %ebx
  8008b4:	50                   	push   %eax
  8008b5:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008b7:	83 c7 01             	add    $0x1,%edi
  8008ba:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008be:	83 c4 10             	add    $0x10,%esp
  8008c1:	85 c0                	test   %eax,%eax
  8008c3:	75 eb                	jne    8008b0 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008cb:	e9 19 ff ff ff       	jmp    8007e9 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008d0:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008d2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008d7:	bf 29 29 80 00       	mov    $0x802929,%edi
							putch(ch, putdat);
  8008dc:	83 ec 08             	sub    $0x8,%esp
  8008df:	53                   	push   %ebx
  8008e0:	50                   	push   %eax
  8008e1:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008e3:	83 c7 01             	add    $0x1,%edi
  8008e6:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008ea:	83 c4 10             	add    $0x10,%esp
  8008ed:	85 c0                	test   %eax,%eax
  8008ef:	75 eb                	jne    8008dc <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008f4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f7:	e9 ed fe ff ff       	jmp    8007e9 <vprintfmt+0x446>
			putch(ch, putdat);
  8008fc:	83 ec 08             	sub    $0x8,%esp
  8008ff:	53                   	push   %ebx
  800900:	6a 25                	push   $0x25
  800902:	ff d6                	call   *%esi
			break;
  800904:	83 c4 10             	add    $0x10,%esp
  800907:	e9 dd fe ff ff       	jmp    8007e9 <vprintfmt+0x446>
			putch('%', putdat);
  80090c:	83 ec 08             	sub    $0x8,%esp
  80090f:	53                   	push   %ebx
  800910:	6a 25                	push   $0x25
  800912:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800914:	83 c4 10             	add    $0x10,%esp
  800917:	89 f8                	mov    %edi,%eax
  800919:	eb 03                	jmp    80091e <vprintfmt+0x57b>
  80091b:	83 e8 01             	sub    $0x1,%eax
  80091e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800922:	75 f7                	jne    80091b <vprintfmt+0x578>
  800924:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800927:	e9 bd fe ff ff       	jmp    8007e9 <vprintfmt+0x446>
}
  80092c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80092f:	5b                   	pop    %ebx
  800930:	5e                   	pop    %esi
  800931:	5f                   	pop    %edi
  800932:	5d                   	pop    %ebp
  800933:	c3                   	ret    

00800934 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
  800937:	83 ec 18             	sub    $0x18,%esp
  80093a:	8b 45 08             	mov    0x8(%ebp),%eax
  80093d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800940:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800943:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800947:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80094a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800951:	85 c0                	test   %eax,%eax
  800953:	74 26                	je     80097b <vsnprintf+0x47>
  800955:	85 d2                	test   %edx,%edx
  800957:	7e 22                	jle    80097b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800959:	ff 75 14             	pushl  0x14(%ebp)
  80095c:	ff 75 10             	pushl  0x10(%ebp)
  80095f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800962:	50                   	push   %eax
  800963:	68 69 03 80 00       	push   $0x800369
  800968:	e8 36 fa ff ff       	call   8003a3 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80096d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800970:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800976:	83 c4 10             	add    $0x10,%esp
}
  800979:	c9                   	leave  
  80097a:	c3                   	ret    
		return -E_INVAL;
  80097b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800980:	eb f7                	jmp    800979 <vsnprintf+0x45>

00800982 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800988:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80098b:	50                   	push   %eax
  80098c:	ff 75 10             	pushl  0x10(%ebp)
  80098f:	ff 75 0c             	pushl  0xc(%ebp)
  800992:	ff 75 08             	pushl  0x8(%ebp)
  800995:	e8 9a ff ff ff       	call   800934 <vsnprintf>
	va_end(ap);

	return rc;
}
  80099a:	c9                   	leave  
  80099b:	c3                   	ret    

0080099c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8009a7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009ab:	74 05                	je     8009b2 <strlen+0x16>
		n++;
  8009ad:	83 c0 01             	add    $0x1,%eax
  8009b0:	eb f5                	jmp    8009a7 <strlen+0xb>
	return n;
}
  8009b2:	5d                   	pop    %ebp
  8009b3:	c3                   	ret    

008009b4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ba:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c2:	39 c2                	cmp    %eax,%edx
  8009c4:	74 0d                	je     8009d3 <strnlen+0x1f>
  8009c6:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009ca:	74 05                	je     8009d1 <strnlen+0x1d>
		n++;
  8009cc:	83 c2 01             	add    $0x1,%edx
  8009cf:	eb f1                	jmp    8009c2 <strnlen+0xe>
  8009d1:	89 d0                	mov    %edx,%eax
	return n;
}
  8009d3:	5d                   	pop    %ebp
  8009d4:	c3                   	ret    

008009d5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009d5:	55                   	push   %ebp
  8009d6:	89 e5                	mov    %esp,%ebp
  8009d8:	53                   	push   %ebx
  8009d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009df:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e4:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009e8:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009eb:	83 c2 01             	add    $0x1,%edx
  8009ee:	84 c9                	test   %cl,%cl
  8009f0:	75 f2                	jne    8009e4 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009f2:	5b                   	pop    %ebx
  8009f3:	5d                   	pop    %ebp
  8009f4:	c3                   	ret    

008009f5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009f5:	55                   	push   %ebp
  8009f6:	89 e5                	mov    %esp,%ebp
  8009f8:	53                   	push   %ebx
  8009f9:	83 ec 10             	sub    $0x10,%esp
  8009fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009ff:	53                   	push   %ebx
  800a00:	e8 97 ff ff ff       	call   80099c <strlen>
  800a05:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a08:	ff 75 0c             	pushl  0xc(%ebp)
  800a0b:	01 d8                	add    %ebx,%eax
  800a0d:	50                   	push   %eax
  800a0e:	e8 c2 ff ff ff       	call   8009d5 <strcpy>
	return dst;
}
  800a13:	89 d8                	mov    %ebx,%eax
  800a15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a18:	c9                   	leave  
  800a19:	c3                   	ret    

00800a1a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	56                   	push   %esi
  800a1e:	53                   	push   %ebx
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a25:	89 c6                	mov    %eax,%esi
  800a27:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a2a:	89 c2                	mov    %eax,%edx
  800a2c:	39 f2                	cmp    %esi,%edx
  800a2e:	74 11                	je     800a41 <strncpy+0x27>
		*dst++ = *src;
  800a30:	83 c2 01             	add    $0x1,%edx
  800a33:	0f b6 19             	movzbl (%ecx),%ebx
  800a36:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a39:	80 fb 01             	cmp    $0x1,%bl
  800a3c:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a3f:	eb eb                	jmp    800a2c <strncpy+0x12>
	}
	return ret;
}
  800a41:	5b                   	pop    %ebx
  800a42:	5e                   	pop    %esi
  800a43:	5d                   	pop    %ebp
  800a44:	c3                   	ret    

00800a45 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a45:	55                   	push   %ebp
  800a46:	89 e5                	mov    %esp,%ebp
  800a48:	56                   	push   %esi
  800a49:	53                   	push   %ebx
  800a4a:	8b 75 08             	mov    0x8(%ebp),%esi
  800a4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a50:	8b 55 10             	mov    0x10(%ebp),%edx
  800a53:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a55:	85 d2                	test   %edx,%edx
  800a57:	74 21                	je     800a7a <strlcpy+0x35>
  800a59:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a5d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a5f:	39 c2                	cmp    %eax,%edx
  800a61:	74 14                	je     800a77 <strlcpy+0x32>
  800a63:	0f b6 19             	movzbl (%ecx),%ebx
  800a66:	84 db                	test   %bl,%bl
  800a68:	74 0b                	je     800a75 <strlcpy+0x30>
			*dst++ = *src++;
  800a6a:	83 c1 01             	add    $0x1,%ecx
  800a6d:	83 c2 01             	add    $0x1,%edx
  800a70:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a73:	eb ea                	jmp    800a5f <strlcpy+0x1a>
  800a75:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a77:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a7a:	29 f0                	sub    %esi,%eax
}
  800a7c:	5b                   	pop    %ebx
  800a7d:	5e                   	pop    %esi
  800a7e:	5d                   	pop    %ebp
  800a7f:	c3                   	ret    

00800a80 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a86:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a89:	0f b6 01             	movzbl (%ecx),%eax
  800a8c:	84 c0                	test   %al,%al
  800a8e:	74 0c                	je     800a9c <strcmp+0x1c>
  800a90:	3a 02                	cmp    (%edx),%al
  800a92:	75 08                	jne    800a9c <strcmp+0x1c>
		p++, q++;
  800a94:	83 c1 01             	add    $0x1,%ecx
  800a97:	83 c2 01             	add    $0x1,%edx
  800a9a:	eb ed                	jmp    800a89 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a9c:	0f b6 c0             	movzbl %al,%eax
  800a9f:	0f b6 12             	movzbl (%edx),%edx
  800aa2:	29 d0                	sub    %edx,%eax
}
  800aa4:	5d                   	pop    %ebp
  800aa5:	c3                   	ret    

00800aa6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800aa6:	55                   	push   %ebp
  800aa7:	89 e5                	mov    %esp,%ebp
  800aa9:	53                   	push   %ebx
  800aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800aad:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab0:	89 c3                	mov    %eax,%ebx
  800ab2:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ab5:	eb 06                	jmp    800abd <strncmp+0x17>
		n--, p++, q++;
  800ab7:	83 c0 01             	add    $0x1,%eax
  800aba:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800abd:	39 d8                	cmp    %ebx,%eax
  800abf:	74 16                	je     800ad7 <strncmp+0x31>
  800ac1:	0f b6 08             	movzbl (%eax),%ecx
  800ac4:	84 c9                	test   %cl,%cl
  800ac6:	74 04                	je     800acc <strncmp+0x26>
  800ac8:	3a 0a                	cmp    (%edx),%cl
  800aca:	74 eb                	je     800ab7 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800acc:	0f b6 00             	movzbl (%eax),%eax
  800acf:	0f b6 12             	movzbl (%edx),%edx
  800ad2:	29 d0                	sub    %edx,%eax
}
  800ad4:	5b                   	pop    %ebx
  800ad5:	5d                   	pop    %ebp
  800ad6:	c3                   	ret    
		return 0;
  800ad7:	b8 00 00 00 00       	mov    $0x0,%eax
  800adc:	eb f6                	jmp    800ad4 <strncmp+0x2e>

00800ade <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ade:	55                   	push   %ebp
  800adf:	89 e5                	mov    %esp,%ebp
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ae8:	0f b6 10             	movzbl (%eax),%edx
  800aeb:	84 d2                	test   %dl,%dl
  800aed:	74 09                	je     800af8 <strchr+0x1a>
		if (*s == c)
  800aef:	38 ca                	cmp    %cl,%dl
  800af1:	74 0a                	je     800afd <strchr+0x1f>
	for (; *s; s++)
  800af3:	83 c0 01             	add    $0x1,%eax
  800af6:	eb f0                	jmp    800ae8 <strchr+0xa>
			return (char *) s;
	return 0;
  800af8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800afd:	5d                   	pop    %ebp
  800afe:	c3                   	ret    

00800aff <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b09:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b0c:	38 ca                	cmp    %cl,%dl
  800b0e:	74 09                	je     800b19 <strfind+0x1a>
  800b10:	84 d2                	test   %dl,%dl
  800b12:	74 05                	je     800b19 <strfind+0x1a>
	for (; *s; s++)
  800b14:	83 c0 01             	add    $0x1,%eax
  800b17:	eb f0                	jmp    800b09 <strfind+0xa>
			break;
	return (char *) s;
}
  800b19:	5d                   	pop    %ebp
  800b1a:	c3                   	ret    

00800b1b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b1b:	55                   	push   %ebp
  800b1c:	89 e5                	mov    %esp,%ebp
  800b1e:	57                   	push   %edi
  800b1f:	56                   	push   %esi
  800b20:	53                   	push   %ebx
  800b21:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b24:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b27:	85 c9                	test   %ecx,%ecx
  800b29:	74 31                	je     800b5c <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b2b:	89 f8                	mov    %edi,%eax
  800b2d:	09 c8                	or     %ecx,%eax
  800b2f:	a8 03                	test   $0x3,%al
  800b31:	75 23                	jne    800b56 <memset+0x3b>
		c &= 0xFF;
  800b33:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b37:	89 d3                	mov    %edx,%ebx
  800b39:	c1 e3 08             	shl    $0x8,%ebx
  800b3c:	89 d0                	mov    %edx,%eax
  800b3e:	c1 e0 18             	shl    $0x18,%eax
  800b41:	89 d6                	mov    %edx,%esi
  800b43:	c1 e6 10             	shl    $0x10,%esi
  800b46:	09 f0                	or     %esi,%eax
  800b48:	09 c2                	or     %eax,%edx
  800b4a:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b4c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b4f:	89 d0                	mov    %edx,%eax
  800b51:	fc                   	cld    
  800b52:	f3 ab                	rep stos %eax,%es:(%edi)
  800b54:	eb 06                	jmp    800b5c <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b59:	fc                   	cld    
  800b5a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b5c:	89 f8                	mov    %edi,%eax
  800b5e:	5b                   	pop    %ebx
  800b5f:	5e                   	pop    %esi
  800b60:	5f                   	pop    %edi
  800b61:	5d                   	pop    %ebp
  800b62:	c3                   	ret    

00800b63 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	57                   	push   %edi
  800b67:	56                   	push   %esi
  800b68:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b6e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b71:	39 c6                	cmp    %eax,%esi
  800b73:	73 32                	jae    800ba7 <memmove+0x44>
  800b75:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b78:	39 c2                	cmp    %eax,%edx
  800b7a:	76 2b                	jbe    800ba7 <memmove+0x44>
		s += n;
		d += n;
  800b7c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b7f:	89 fe                	mov    %edi,%esi
  800b81:	09 ce                	or     %ecx,%esi
  800b83:	09 d6                	or     %edx,%esi
  800b85:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b8b:	75 0e                	jne    800b9b <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b8d:	83 ef 04             	sub    $0x4,%edi
  800b90:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b93:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b96:	fd                   	std    
  800b97:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b99:	eb 09                	jmp    800ba4 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b9b:	83 ef 01             	sub    $0x1,%edi
  800b9e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ba1:	fd                   	std    
  800ba2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ba4:	fc                   	cld    
  800ba5:	eb 1a                	jmp    800bc1 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ba7:	89 c2                	mov    %eax,%edx
  800ba9:	09 ca                	or     %ecx,%edx
  800bab:	09 f2                	or     %esi,%edx
  800bad:	f6 c2 03             	test   $0x3,%dl
  800bb0:	75 0a                	jne    800bbc <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bb2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bb5:	89 c7                	mov    %eax,%edi
  800bb7:	fc                   	cld    
  800bb8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bba:	eb 05                	jmp    800bc1 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bbc:	89 c7                	mov    %eax,%edi
  800bbe:	fc                   	cld    
  800bbf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bc1:	5e                   	pop    %esi
  800bc2:	5f                   	pop    %edi
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    

00800bc5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bcb:	ff 75 10             	pushl  0x10(%ebp)
  800bce:	ff 75 0c             	pushl  0xc(%ebp)
  800bd1:	ff 75 08             	pushl  0x8(%ebp)
  800bd4:	e8 8a ff ff ff       	call   800b63 <memmove>
}
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    

00800bdb <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	56                   	push   %esi
  800bdf:	53                   	push   %ebx
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be6:	89 c6                	mov    %eax,%esi
  800be8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800beb:	39 f0                	cmp    %esi,%eax
  800bed:	74 1c                	je     800c0b <memcmp+0x30>
		if (*s1 != *s2)
  800bef:	0f b6 08             	movzbl (%eax),%ecx
  800bf2:	0f b6 1a             	movzbl (%edx),%ebx
  800bf5:	38 d9                	cmp    %bl,%cl
  800bf7:	75 08                	jne    800c01 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bf9:	83 c0 01             	add    $0x1,%eax
  800bfc:	83 c2 01             	add    $0x1,%edx
  800bff:	eb ea                	jmp    800beb <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c01:	0f b6 c1             	movzbl %cl,%eax
  800c04:	0f b6 db             	movzbl %bl,%ebx
  800c07:	29 d8                	sub    %ebx,%eax
  800c09:	eb 05                	jmp    800c10 <memcmp+0x35>
	}

	return 0;
  800c0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c10:	5b                   	pop    %ebx
  800c11:	5e                   	pop    %esi
  800c12:	5d                   	pop    %ebp
  800c13:	c3                   	ret    

00800c14 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c1d:	89 c2                	mov    %eax,%edx
  800c1f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c22:	39 d0                	cmp    %edx,%eax
  800c24:	73 09                	jae    800c2f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c26:	38 08                	cmp    %cl,(%eax)
  800c28:	74 05                	je     800c2f <memfind+0x1b>
	for (; s < ends; s++)
  800c2a:	83 c0 01             	add    $0x1,%eax
  800c2d:	eb f3                	jmp    800c22 <memfind+0xe>
			break;
	return (void *) s;
}
  800c2f:	5d                   	pop    %ebp
  800c30:	c3                   	ret    

00800c31 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	57                   	push   %edi
  800c35:	56                   	push   %esi
  800c36:	53                   	push   %ebx
  800c37:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c3a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c3d:	eb 03                	jmp    800c42 <strtol+0x11>
		s++;
  800c3f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c42:	0f b6 01             	movzbl (%ecx),%eax
  800c45:	3c 20                	cmp    $0x20,%al
  800c47:	74 f6                	je     800c3f <strtol+0xe>
  800c49:	3c 09                	cmp    $0x9,%al
  800c4b:	74 f2                	je     800c3f <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c4d:	3c 2b                	cmp    $0x2b,%al
  800c4f:	74 2a                	je     800c7b <strtol+0x4a>
	int neg = 0;
  800c51:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c56:	3c 2d                	cmp    $0x2d,%al
  800c58:	74 2b                	je     800c85 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c5a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c60:	75 0f                	jne    800c71 <strtol+0x40>
  800c62:	80 39 30             	cmpb   $0x30,(%ecx)
  800c65:	74 28                	je     800c8f <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c67:	85 db                	test   %ebx,%ebx
  800c69:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c6e:	0f 44 d8             	cmove  %eax,%ebx
  800c71:	b8 00 00 00 00       	mov    $0x0,%eax
  800c76:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c79:	eb 50                	jmp    800ccb <strtol+0x9a>
		s++;
  800c7b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c7e:	bf 00 00 00 00       	mov    $0x0,%edi
  800c83:	eb d5                	jmp    800c5a <strtol+0x29>
		s++, neg = 1;
  800c85:	83 c1 01             	add    $0x1,%ecx
  800c88:	bf 01 00 00 00       	mov    $0x1,%edi
  800c8d:	eb cb                	jmp    800c5a <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c8f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c93:	74 0e                	je     800ca3 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c95:	85 db                	test   %ebx,%ebx
  800c97:	75 d8                	jne    800c71 <strtol+0x40>
		s++, base = 8;
  800c99:	83 c1 01             	add    $0x1,%ecx
  800c9c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ca1:	eb ce                	jmp    800c71 <strtol+0x40>
		s += 2, base = 16;
  800ca3:	83 c1 02             	add    $0x2,%ecx
  800ca6:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cab:	eb c4                	jmp    800c71 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cad:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cb0:	89 f3                	mov    %esi,%ebx
  800cb2:	80 fb 19             	cmp    $0x19,%bl
  800cb5:	77 29                	ja     800ce0 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cb7:	0f be d2             	movsbl %dl,%edx
  800cba:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cbd:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cc0:	7d 30                	jge    800cf2 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cc2:	83 c1 01             	add    $0x1,%ecx
  800cc5:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cc9:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ccb:	0f b6 11             	movzbl (%ecx),%edx
  800cce:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cd1:	89 f3                	mov    %esi,%ebx
  800cd3:	80 fb 09             	cmp    $0x9,%bl
  800cd6:	77 d5                	ja     800cad <strtol+0x7c>
			dig = *s - '0';
  800cd8:	0f be d2             	movsbl %dl,%edx
  800cdb:	83 ea 30             	sub    $0x30,%edx
  800cde:	eb dd                	jmp    800cbd <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ce0:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ce3:	89 f3                	mov    %esi,%ebx
  800ce5:	80 fb 19             	cmp    $0x19,%bl
  800ce8:	77 08                	ja     800cf2 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cea:	0f be d2             	movsbl %dl,%edx
  800ced:	83 ea 37             	sub    $0x37,%edx
  800cf0:	eb cb                	jmp    800cbd <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cf2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf6:	74 05                	je     800cfd <strtol+0xcc>
		*endptr = (char *) s;
  800cf8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cfb:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cfd:	89 c2                	mov    %eax,%edx
  800cff:	f7 da                	neg    %edx
  800d01:	85 ff                	test   %edi,%edi
  800d03:	0f 45 c2             	cmovne %edx,%eax
}
  800d06:	5b                   	pop    %ebx
  800d07:	5e                   	pop    %esi
  800d08:	5f                   	pop    %edi
  800d09:	5d                   	pop    %ebp
  800d0a:	c3                   	ret    

00800d0b <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	57                   	push   %edi
  800d0f:	56                   	push   %esi
  800d10:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d11:	b8 00 00 00 00       	mov    $0x0,%eax
  800d16:	8b 55 08             	mov    0x8(%ebp),%edx
  800d19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1c:	89 c3                	mov    %eax,%ebx
  800d1e:	89 c7                	mov    %eax,%edi
  800d20:	89 c6                	mov    %eax,%esi
  800d22:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d24:	5b                   	pop    %ebx
  800d25:	5e                   	pop    %esi
  800d26:	5f                   	pop    %edi
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    

00800d29 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	57                   	push   %edi
  800d2d:	56                   	push   %esi
  800d2e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d34:	b8 01 00 00 00       	mov    $0x1,%eax
  800d39:	89 d1                	mov    %edx,%ecx
  800d3b:	89 d3                	mov    %edx,%ebx
  800d3d:	89 d7                	mov    %edx,%edi
  800d3f:	89 d6                	mov    %edx,%esi
  800d41:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d43:	5b                   	pop    %ebx
  800d44:	5e                   	pop    %esi
  800d45:	5f                   	pop    %edi
  800d46:	5d                   	pop    %ebp
  800d47:	c3                   	ret    

00800d48 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	57                   	push   %edi
  800d4c:	56                   	push   %esi
  800d4d:	53                   	push   %ebx
  800d4e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d51:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d56:	8b 55 08             	mov    0x8(%ebp),%edx
  800d59:	b8 03 00 00 00       	mov    $0x3,%eax
  800d5e:	89 cb                	mov    %ecx,%ebx
  800d60:	89 cf                	mov    %ecx,%edi
  800d62:	89 ce                	mov    %ecx,%esi
  800d64:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d66:	85 c0                	test   %eax,%eax
  800d68:	7f 08                	jg     800d72 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6d:	5b                   	pop    %ebx
  800d6e:	5e                   	pop    %esi
  800d6f:	5f                   	pop    %edi
  800d70:	5d                   	pop    %ebp
  800d71:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d72:	83 ec 0c             	sub    $0xc,%esp
  800d75:	50                   	push   %eax
  800d76:	6a 03                	push   $0x3
  800d78:	68 48 2b 80 00       	push   $0x802b48
  800d7d:	6a 43                	push   $0x43
  800d7f:	68 65 2b 80 00       	push   $0x802b65
  800d84:	e8 f7 f3 ff ff       	call   800180 <_panic>

00800d89 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	57                   	push   %edi
  800d8d:	56                   	push   %esi
  800d8e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d8f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d94:	b8 02 00 00 00       	mov    $0x2,%eax
  800d99:	89 d1                	mov    %edx,%ecx
  800d9b:	89 d3                	mov    %edx,%ebx
  800d9d:	89 d7                	mov    %edx,%edi
  800d9f:	89 d6                	mov    %edx,%esi
  800da1:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800da3:	5b                   	pop    %ebx
  800da4:	5e                   	pop    %esi
  800da5:	5f                   	pop    %edi
  800da6:	5d                   	pop    %ebp
  800da7:	c3                   	ret    

00800da8 <sys_yield>:

void
sys_yield(void)
{
  800da8:	55                   	push   %ebp
  800da9:	89 e5                	mov    %esp,%ebp
  800dab:	57                   	push   %edi
  800dac:	56                   	push   %esi
  800dad:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dae:	ba 00 00 00 00       	mov    $0x0,%edx
  800db3:	b8 0b 00 00 00       	mov    $0xb,%eax
  800db8:	89 d1                	mov    %edx,%ecx
  800dba:	89 d3                	mov    %edx,%ebx
  800dbc:	89 d7                	mov    %edx,%edi
  800dbe:	89 d6                	mov    %edx,%esi
  800dc0:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dc2:	5b                   	pop    %ebx
  800dc3:	5e                   	pop    %esi
  800dc4:	5f                   	pop    %edi
  800dc5:	5d                   	pop    %ebp
  800dc6:	c3                   	ret    

00800dc7 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	57                   	push   %edi
  800dcb:	56                   	push   %esi
  800dcc:	53                   	push   %ebx
  800dcd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd0:	be 00 00 00 00       	mov    $0x0,%esi
  800dd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ddb:	b8 04 00 00 00       	mov    $0x4,%eax
  800de0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de3:	89 f7                	mov    %esi,%edi
  800de5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de7:	85 c0                	test   %eax,%eax
  800de9:	7f 08                	jg     800df3 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800deb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dee:	5b                   	pop    %ebx
  800def:	5e                   	pop    %esi
  800df0:	5f                   	pop    %edi
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df3:	83 ec 0c             	sub    $0xc,%esp
  800df6:	50                   	push   %eax
  800df7:	6a 04                	push   $0x4
  800df9:	68 48 2b 80 00       	push   $0x802b48
  800dfe:	6a 43                	push   $0x43
  800e00:	68 65 2b 80 00       	push   $0x802b65
  800e05:	e8 76 f3 ff ff       	call   800180 <_panic>

00800e0a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	57                   	push   %edi
  800e0e:	56                   	push   %esi
  800e0f:	53                   	push   %ebx
  800e10:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e13:	8b 55 08             	mov    0x8(%ebp),%edx
  800e16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e19:	b8 05 00 00 00       	mov    $0x5,%eax
  800e1e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e21:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e24:	8b 75 18             	mov    0x18(%ebp),%esi
  800e27:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e29:	85 c0                	test   %eax,%eax
  800e2b:	7f 08                	jg     800e35 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e30:	5b                   	pop    %ebx
  800e31:	5e                   	pop    %esi
  800e32:	5f                   	pop    %edi
  800e33:	5d                   	pop    %ebp
  800e34:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e35:	83 ec 0c             	sub    $0xc,%esp
  800e38:	50                   	push   %eax
  800e39:	6a 05                	push   $0x5
  800e3b:	68 48 2b 80 00       	push   $0x802b48
  800e40:	6a 43                	push   $0x43
  800e42:	68 65 2b 80 00       	push   $0x802b65
  800e47:	e8 34 f3 ff ff       	call   800180 <_panic>

00800e4c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	57                   	push   %edi
  800e50:	56                   	push   %esi
  800e51:	53                   	push   %ebx
  800e52:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e55:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e60:	b8 06 00 00 00       	mov    $0x6,%eax
  800e65:	89 df                	mov    %ebx,%edi
  800e67:	89 de                	mov    %ebx,%esi
  800e69:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6b:	85 c0                	test   %eax,%eax
  800e6d:	7f 08                	jg     800e77 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e72:	5b                   	pop    %ebx
  800e73:	5e                   	pop    %esi
  800e74:	5f                   	pop    %edi
  800e75:	5d                   	pop    %ebp
  800e76:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e77:	83 ec 0c             	sub    $0xc,%esp
  800e7a:	50                   	push   %eax
  800e7b:	6a 06                	push   $0x6
  800e7d:	68 48 2b 80 00       	push   $0x802b48
  800e82:	6a 43                	push   $0x43
  800e84:	68 65 2b 80 00       	push   $0x802b65
  800e89:	e8 f2 f2 ff ff       	call   800180 <_panic>

00800e8e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	57                   	push   %edi
  800e92:	56                   	push   %esi
  800e93:	53                   	push   %ebx
  800e94:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e97:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea2:	b8 08 00 00 00       	mov    $0x8,%eax
  800ea7:	89 df                	mov    %ebx,%edi
  800ea9:	89 de                	mov    %ebx,%esi
  800eab:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ead:	85 c0                	test   %eax,%eax
  800eaf:	7f 08                	jg     800eb9 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800eb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb4:	5b                   	pop    %ebx
  800eb5:	5e                   	pop    %esi
  800eb6:	5f                   	pop    %edi
  800eb7:	5d                   	pop    %ebp
  800eb8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb9:	83 ec 0c             	sub    $0xc,%esp
  800ebc:	50                   	push   %eax
  800ebd:	6a 08                	push   $0x8
  800ebf:	68 48 2b 80 00       	push   $0x802b48
  800ec4:	6a 43                	push   $0x43
  800ec6:	68 65 2b 80 00       	push   $0x802b65
  800ecb:	e8 b0 f2 ff ff       	call   800180 <_panic>

00800ed0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	57                   	push   %edi
  800ed4:	56                   	push   %esi
  800ed5:	53                   	push   %ebx
  800ed6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ede:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee4:	b8 09 00 00 00       	mov    $0x9,%eax
  800ee9:	89 df                	mov    %ebx,%edi
  800eeb:	89 de                	mov    %ebx,%esi
  800eed:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eef:	85 c0                	test   %eax,%eax
  800ef1:	7f 08                	jg     800efb <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef6:	5b                   	pop    %ebx
  800ef7:	5e                   	pop    %esi
  800ef8:	5f                   	pop    %edi
  800ef9:	5d                   	pop    %ebp
  800efa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800efb:	83 ec 0c             	sub    $0xc,%esp
  800efe:	50                   	push   %eax
  800eff:	6a 09                	push   $0x9
  800f01:	68 48 2b 80 00       	push   $0x802b48
  800f06:	6a 43                	push   $0x43
  800f08:	68 65 2b 80 00       	push   $0x802b65
  800f0d:	e8 6e f2 ff ff       	call   800180 <_panic>

00800f12 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	57                   	push   %edi
  800f16:	56                   	push   %esi
  800f17:	53                   	push   %ebx
  800f18:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f1b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f20:	8b 55 08             	mov    0x8(%ebp),%edx
  800f23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f26:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f2b:	89 df                	mov    %ebx,%edi
  800f2d:	89 de                	mov    %ebx,%esi
  800f2f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f31:	85 c0                	test   %eax,%eax
  800f33:	7f 08                	jg     800f3d <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f38:	5b                   	pop    %ebx
  800f39:	5e                   	pop    %esi
  800f3a:	5f                   	pop    %edi
  800f3b:	5d                   	pop    %ebp
  800f3c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3d:	83 ec 0c             	sub    $0xc,%esp
  800f40:	50                   	push   %eax
  800f41:	6a 0a                	push   $0xa
  800f43:	68 48 2b 80 00       	push   $0x802b48
  800f48:	6a 43                	push   $0x43
  800f4a:	68 65 2b 80 00       	push   $0x802b65
  800f4f:	e8 2c f2 ff ff       	call   800180 <_panic>

00800f54 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f54:	55                   	push   %ebp
  800f55:	89 e5                	mov    %esp,%ebp
  800f57:	57                   	push   %edi
  800f58:	56                   	push   %esi
  800f59:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f60:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f65:	be 00 00 00 00       	mov    $0x0,%esi
  800f6a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f6d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f70:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f72:	5b                   	pop    %ebx
  800f73:	5e                   	pop    %esi
  800f74:	5f                   	pop    %edi
  800f75:	5d                   	pop    %ebp
  800f76:	c3                   	ret    

00800f77 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f77:	55                   	push   %ebp
  800f78:	89 e5                	mov    %esp,%ebp
  800f7a:	57                   	push   %edi
  800f7b:	56                   	push   %esi
  800f7c:	53                   	push   %ebx
  800f7d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f80:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f85:	8b 55 08             	mov    0x8(%ebp),%edx
  800f88:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f8d:	89 cb                	mov    %ecx,%ebx
  800f8f:	89 cf                	mov    %ecx,%edi
  800f91:	89 ce                	mov    %ecx,%esi
  800f93:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f95:	85 c0                	test   %eax,%eax
  800f97:	7f 08                	jg     800fa1 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f99:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f9c:	5b                   	pop    %ebx
  800f9d:	5e                   	pop    %esi
  800f9e:	5f                   	pop    %edi
  800f9f:	5d                   	pop    %ebp
  800fa0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa1:	83 ec 0c             	sub    $0xc,%esp
  800fa4:	50                   	push   %eax
  800fa5:	6a 0d                	push   $0xd
  800fa7:	68 48 2b 80 00       	push   $0x802b48
  800fac:	6a 43                	push   $0x43
  800fae:	68 65 2b 80 00       	push   $0x802b65
  800fb3:	e8 c8 f1 ff ff       	call   800180 <_panic>

00800fb8 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fb8:	55                   	push   %ebp
  800fb9:	89 e5                	mov    %esp,%ebp
  800fbb:	57                   	push   %edi
  800fbc:	56                   	push   %esi
  800fbd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fbe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fce:	89 df                	mov    %ebx,%edi
  800fd0:	89 de                	mov    %ebx,%esi
  800fd2:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fd4:	5b                   	pop    %ebx
  800fd5:	5e                   	pop    %esi
  800fd6:	5f                   	pop    %edi
  800fd7:	5d                   	pop    %ebp
  800fd8:	c3                   	ret    

00800fd9 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	57                   	push   %edi
  800fdd:	56                   	push   %esi
  800fde:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fdf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fe4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe7:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fec:	89 cb                	mov    %ecx,%ebx
  800fee:	89 cf                	mov    %ecx,%edi
  800ff0:	89 ce                	mov    %ecx,%esi
  800ff2:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800ff4:	5b                   	pop    %ebx
  800ff5:	5e                   	pop    %esi
  800ff6:	5f                   	pop    %edi
  800ff7:	5d                   	pop    %ebp
  800ff8:	c3                   	ret    

00800ff9 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ff9:	55                   	push   %ebp
  800ffa:	89 e5                	mov    %esp,%ebp
  800ffc:	57                   	push   %edi
  800ffd:	56                   	push   %esi
  800ffe:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fff:	ba 00 00 00 00       	mov    $0x0,%edx
  801004:	b8 10 00 00 00       	mov    $0x10,%eax
  801009:	89 d1                	mov    %edx,%ecx
  80100b:	89 d3                	mov    %edx,%ebx
  80100d:	89 d7                	mov    %edx,%edi
  80100f:	89 d6                	mov    %edx,%esi
  801011:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801013:	5b                   	pop    %ebx
  801014:	5e                   	pop    %esi
  801015:	5f                   	pop    %edi
  801016:	5d                   	pop    %ebp
  801017:	c3                   	ret    

00801018 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	57                   	push   %edi
  80101c:	56                   	push   %esi
  80101d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80101e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801023:	8b 55 08             	mov    0x8(%ebp),%edx
  801026:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801029:	b8 11 00 00 00       	mov    $0x11,%eax
  80102e:	89 df                	mov    %ebx,%edi
  801030:	89 de                	mov    %ebx,%esi
  801032:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801034:	5b                   	pop    %ebx
  801035:	5e                   	pop    %esi
  801036:	5f                   	pop    %edi
  801037:	5d                   	pop    %ebp
  801038:	c3                   	ret    

00801039 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	57                   	push   %edi
  80103d:	56                   	push   %esi
  80103e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80103f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801044:	8b 55 08             	mov    0x8(%ebp),%edx
  801047:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80104a:	b8 12 00 00 00       	mov    $0x12,%eax
  80104f:	89 df                	mov    %ebx,%edi
  801051:	89 de                	mov    %ebx,%esi
  801053:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801055:	5b                   	pop    %ebx
  801056:	5e                   	pop    %esi
  801057:	5f                   	pop    %edi
  801058:	5d                   	pop    %ebp
  801059:	c3                   	ret    

0080105a <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	57                   	push   %edi
  80105e:	56                   	push   %esi
  80105f:	53                   	push   %ebx
  801060:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801063:	bb 00 00 00 00       	mov    $0x0,%ebx
  801068:	8b 55 08             	mov    0x8(%ebp),%edx
  80106b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80106e:	b8 13 00 00 00       	mov    $0x13,%eax
  801073:	89 df                	mov    %ebx,%edi
  801075:	89 de                	mov    %ebx,%esi
  801077:	cd 30                	int    $0x30
	if(check && ret > 0)
  801079:	85 c0                	test   %eax,%eax
  80107b:	7f 08                	jg     801085 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80107d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801080:	5b                   	pop    %ebx
  801081:	5e                   	pop    %esi
  801082:	5f                   	pop    %edi
  801083:	5d                   	pop    %ebp
  801084:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801085:	83 ec 0c             	sub    $0xc,%esp
  801088:	50                   	push   %eax
  801089:	6a 13                	push   $0x13
  80108b:	68 48 2b 80 00       	push   $0x802b48
  801090:	6a 43                	push   $0x43
  801092:	68 65 2b 80 00       	push   $0x802b65
  801097:	e8 e4 f0 ff ff       	call   800180 <_panic>

0080109c <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80109c:	55                   	push   %ebp
  80109d:	89 e5                	mov    %esp,%ebp
  80109f:	57                   	push   %edi
  8010a0:	56                   	push   %esi
  8010a1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010aa:	b8 14 00 00 00       	mov    $0x14,%eax
  8010af:	89 cb                	mov    %ecx,%ebx
  8010b1:	89 cf                	mov    %ecx,%edi
  8010b3:	89 ce                	mov    %ecx,%esi
  8010b5:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8010b7:	5b                   	pop    %ebx
  8010b8:	5e                   	pop    %esi
  8010b9:	5f                   	pop    %edi
  8010ba:	5d                   	pop    %ebp
  8010bb:	c3                   	ret    

008010bc <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8010bc:	55                   	push   %ebp
  8010bd:	89 e5                	mov    %esp,%ebp
  8010bf:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8010c2:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  8010c9:	74 0a                	je     8010d5 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  8010d3:	c9                   	leave  
  8010d4:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8010d5:	83 ec 04             	sub    $0x4,%esp
  8010d8:	6a 07                	push   $0x7
  8010da:	68 00 f0 bf ee       	push   $0xeebff000
  8010df:	6a 00                	push   $0x0
  8010e1:	e8 e1 fc ff ff       	call   800dc7 <sys_page_alloc>
		if(r < 0)
  8010e6:	83 c4 10             	add    $0x10,%esp
  8010e9:	85 c0                	test   %eax,%eax
  8010eb:	78 2a                	js     801117 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8010ed:	83 ec 08             	sub    $0x8,%esp
  8010f0:	68 2b 11 80 00       	push   $0x80112b
  8010f5:	6a 00                	push   $0x0
  8010f7:	e8 16 fe ff ff       	call   800f12 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8010fc:	83 c4 10             	add    $0x10,%esp
  8010ff:	85 c0                	test   %eax,%eax
  801101:	79 c8                	jns    8010cb <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  801103:	83 ec 04             	sub    $0x4,%esp
  801106:	68 a4 2b 80 00       	push   $0x802ba4
  80110b:	6a 25                	push   $0x25
  80110d:	68 dd 2b 80 00       	push   $0x802bdd
  801112:	e8 69 f0 ff ff       	call   800180 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  801117:	83 ec 04             	sub    $0x4,%esp
  80111a:	68 74 2b 80 00       	push   $0x802b74
  80111f:	6a 22                	push   $0x22
  801121:	68 dd 2b 80 00       	push   $0x802bdd
  801126:	e8 55 f0 ff ff       	call   800180 <_panic>

0080112b <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80112b:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80112c:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  801131:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801133:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  801136:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80113a:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80113e:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801141:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  801143:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  801147:	83 c4 08             	add    $0x8,%esp
	popal
  80114a:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80114b:	83 c4 04             	add    $0x4,%esp
	popfl
  80114e:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80114f:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801150:	c3                   	ret    

00801151 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	05 00 00 00 30       	add    $0x30000000,%eax
  80115c:	c1 e8 0c             	shr    $0xc,%eax
}
  80115f:	5d                   	pop    %ebp
  801160:	c3                   	ret    

00801161 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801161:	55                   	push   %ebp
  801162:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80116c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801171:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801176:	5d                   	pop    %ebp
  801177:	c3                   	ret    

00801178 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
  80117b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801180:	89 c2                	mov    %eax,%edx
  801182:	c1 ea 16             	shr    $0x16,%edx
  801185:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80118c:	f6 c2 01             	test   $0x1,%dl
  80118f:	74 2d                	je     8011be <fd_alloc+0x46>
  801191:	89 c2                	mov    %eax,%edx
  801193:	c1 ea 0c             	shr    $0xc,%edx
  801196:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80119d:	f6 c2 01             	test   $0x1,%dl
  8011a0:	74 1c                	je     8011be <fd_alloc+0x46>
  8011a2:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011a7:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011ac:	75 d2                	jne    801180 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8011b7:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011bc:	eb 0a                	jmp    8011c8 <fd_alloc+0x50>
			*fd_store = fd;
  8011be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011c1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011c8:	5d                   	pop    %ebp
  8011c9:	c3                   	ret    

008011ca <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011d0:	83 f8 1f             	cmp    $0x1f,%eax
  8011d3:	77 30                	ja     801205 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011d5:	c1 e0 0c             	shl    $0xc,%eax
  8011d8:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011dd:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8011e3:	f6 c2 01             	test   $0x1,%dl
  8011e6:	74 24                	je     80120c <fd_lookup+0x42>
  8011e8:	89 c2                	mov    %eax,%edx
  8011ea:	c1 ea 0c             	shr    $0xc,%edx
  8011ed:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011f4:	f6 c2 01             	test   $0x1,%dl
  8011f7:	74 1a                	je     801213 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011fc:	89 02                	mov    %eax,(%edx)
	return 0;
  8011fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801203:	5d                   	pop    %ebp
  801204:	c3                   	ret    
		return -E_INVAL;
  801205:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80120a:	eb f7                	jmp    801203 <fd_lookup+0x39>
		return -E_INVAL;
  80120c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801211:	eb f0                	jmp    801203 <fd_lookup+0x39>
  801213:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801218:	eb e9                	jmp    801203 <fd_lookup+0x39>

0080121a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80121a:	55                   	push   %ebp
  80121b:	89 e5                	mov    %esp,%ebp
  80121d:	83 ec 08             	sub    $0x8,%esp
  801220:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801223:	ba 00 00 00 00       	mov    $0x0,%edx
  801228:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80122d:	39 08                	cmp    %ecx,(%eax)
  80122f:	74 38                	je     801269 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801231:	83 c2 01             	add    $0x1,%edx
  801234:	8b 04 95 6c 2c 80 00 	mov    0x802c6c(,%edx,4),%eax
  80123b:	85 c0                	test   %eax,%eax
  80123d:	75 ee                	jne    80122d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80123f:	a1 08 40 80 00       	mov    0x804008,%eax
  801244:	8b 40 48             	mov    0x48(%eax),%eax
  801247:	83 ec 04             	sub    $0x4,%esp
  80124a:	51                   	push   %ecx
  80124b:	50                   	push   %eax
  80124c:	68 ec 2b 80 00       	push   $0x802bec
  801251:	e8 20 f0 ff ff       	call   800276 <cprintf>
	*dev = 0;
  801256:	8b 45 0c             	mov    0xc(%ebp),%eax
  801259:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80125f:	83 c4 10             	add    $0x10,%esp
  801262:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801267:	c9                   	leave  
  801268:	c3                   	ret    
			*dev = devtab[i];
  801269:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80126c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80126e:	b8 00 00 00 00       	mov    $0x0,%eax
  801273:	eb f2                	jmp    801267 <dev_lookup+0x4d>

00801275 <fd_close>:
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
  801278:	57                   	push   %edi
  801279:	56                   	push   %esi
  80127a:	53                   	push   %ebx
  80127b:	83 ec 24             	sub    $0x24,%esp
  80127e:	8b 75 08             	mov    0x8(%ebp),%esi
  801281:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801284:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801287:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801288:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80128e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801291:	50                   	push   %eax
  801292:	e8 33 ff ff ff       	call   8011ca <fd_lookup>
  801297:	89 c3                	mov    %eax,%ebx
  801299:	83 c4 10             	add    $0x10,%esp
  80129c:	85 c0                	test   %eax,%eax
  80129e:	78 05                	js     8012a5 <fd_close+0x30>
	    || fd != fd2)
  8012a0:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012a3:	74 16                	je     8012bb <fd_close+0x46>
		return (must_exist ? r : 0);
  8012a5:	89 f8                	mov    %edi,%eax
  8012a7:	84 c0                	test   %al,%al
  8012a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ae:	0f 44 d8             	cmove  %eax,%ebx
}
  8012b1:	89 d8                	mov    %ebx,%eax
  8012b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012b6:	5b                   	pop    %ebx
  8012b7:	5e                   	pop    %esi
  8012b8:	5f                   	pop    %edi
  8012b9:	5d                   	pop    %ebp
  8012ba:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012bb:	83 ec 08             	sub    $0x8,%esp
  8012be:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012c1:	50                   	push   %eax
  8012c2:	ff 36                	pushl  (%esi)
  8012c4:	e8 51 ff ff ff       	call   80121a <dev_lookup>
  8012c9:	89 c3                	mov    %eax,%ebx
  8012cb:	83 c4 10             	add    $0x10,%esp
  8012ce:	85 c0                	test   %eax,%eax
  8012d0:	78 1a                	js     8012ec <fd_close+0x77>
		if (dev->dev_close)
  8012d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012d5:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8012d8:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012dd:	85 c0                	test   %eax,%eax
  8012df:	74 0b                	je     8012ec <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8012e1:	83 ec 0c             	sub    $0xc,%esp
  8012e4:	56                   	push   %esi
  8012e5:	ff d0                	call   *%eax
  8012e7:	89 c3                	mov    %eax,%ebx
  8012e9:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012ec:	83 ec 08             	sub    $0x8,%esp
  8012ef:	56                   	push   %esi
  8012f0:	6a 00                	push   $0x0
  8012f2:	e8 55 fb ff ff       	call   800e4c <sys_page_unmap>
	return r;
  8012f7:	83 c4 10             	add    $0x10,%esp
  8012fa:	eb b5                	jmp    8012b1 <fd_close+0x3c>

008012fc <close>:

int
close(int fdnum)
{
  8012fc:	55                   	push   %ebp
  8012fd:	89 e5                	mov    %esp,%ebp
  8012ff:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801302:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801305:	50                   	push   %eax
  801306:	ff 75 08             	pushl  0x8(%ebp)
  801309:	e8 bc fe ff ff       	call   8011ca <fd_lookup>
  80130e:	83 c4 10             	add    $0x10,%esp
  801311:	85 c0                	test   %eax,%eax
  801313:	79 02                	jns    801317 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801315:	c9                   	leave  
  801316:	c3                   	ret    
		return fd_close(fd, 1);
  801317:	83 ec 08             	sub    $0x8,%esp
  80131a:	6a 01                	push   $0x1
  80131c:	ff 75 f4             	pushl  -0xc(%ebp)
  80131f:	e8 51 ff ff ff       	call   801275 <fd_close>
  801324:	83 c4 10             	add    $0x10,%esp
  801327:	eb ec                	jmp    801315 <close+0x19>

00801329 <close_all>:

void
close_all(void)
{
  801329:	55                   	push   %ebp
  80132a:	89 e5                	mov    %esp,%ebp
  80132c:	53                   	push   %ebx
  80132d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801330:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801335:	83 ec 0c             	sub    $0xc,%esp
  801338:	53                   	push   %ebx
  801339:	e8 be ff ff ff       	call   8012fc <close>
	for (i = 0; i < MAXFD; i++)
  80133e:	83 c3 01             	add    $0x1,%ebx
  801341:	83 c4 10             	add    $0x10,%esp
  801344:	83 fb 20             	cmp    $0x20,%ebx
  801347:	75 ec                	jne    801335 <close_all+0xc>
}
  801349:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    

0080134e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
  801351:	57                   	push   %edi
  801352:	56                   	push   %esi
  801353:	53                   	push   %ebx
  801354:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801357:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80135a:	50                   	push   %eax
  80135b:	ff 75 08             	pushl  0x8(%ebp)
  80135e:	e8 67 fe ff ff       	call   8011ca <fd_lookup>
  801363:	89 c3                	mov    %eax,%ebx
  801365:	83 c4 10             	add    $0x10,%esp
  801368:	85 c0                	test   %eax,%eax
  80136a:	0f 88 81 00 00 00    	js     8013f1 <dup+0xa3>
		return r;
	close(newfdnum);
  801370:	83 ec 0c             	sub    $0xc,%esp
  801373:	ff 75 0c             	pushl  0xc(%ebp)
  801376:	e8 81 ff ff ff       	call   8012fc <close>

	newfd = INDEX2FD(newfdnum);
  80137b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80137e:	c1 e6 0c             	shl    $0xc,%esi
  801381:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801387:	83 c4 04             	add    $0x4,%esp
  80138a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80138d:	e8 cf fd ff ff       	call   801161 <fd2data>
  801392:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801394:	89 34 24             	mov    %esi,(%esp)
  801397:	e8 c5 fd ff ff       	call   801161 <fd2data>
  80139c:	83 c4 10             	add    $0x10,%esp
  80139f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013a1:	89 d8                	mov    %ebx,%eax
  8013a3:	c1 e8 16             	shr    $0x16,%eax
  8013a6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013ad:	a8 01                	test   $0x1,%al
  8013af:	74 11                	je     8013c2 <dup+0x74>
  8013b1:	89 d8                	mov    %ebx,%eax
  8013b3:	c1 e8 0c             	shr    $0xc,%eax
  8013b6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013bd:	f6 c2 01             	test   $0x1,%dl
  8013c0:	75 39                	jne    8013fb <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013c5:	89 d0                	mov    %edx,%eax
  8013c7:	c1 e8 0c             	shr    $0xc,%eax
  8013ca:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013d1:	83 ec 0c             	sub    $0xc,%esp
  8013d4:	25 07 0e 00 00       	and    $0xe07,%eax
  8013d9:	50                   	push   %eax
  8013da:	56                   	push   %esi
  8013db:	6a 00                	push   $0x0
  8013dd:	52                   	push   %edx
  8013de:	6a 00                	push   $0x0
  8013e0:	e8 25 fa ff ff       	call   800e0a <sys_page_map>
  8013e5:	89 c3                	mov    %eax,%ebx
  8013e7:	83 c4 20             	add    $0x20,%esp
  8013ea:	85 c0                	test   %eax,%eax
  8013ec:	78 31                	js     80141f <dup+0xd1>
		goto err;

	return newfdnum;
  8013ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013f1:	89 d8                	mov    %ebx,%eax
  8013f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013f6:	5b                   	pop    %ebx
  8013f7:	5e                   	pop    %esi
  8013f8:	5f                   	pop    %edi
  8013f9:	5d                   	pop    %ebp
  8013fa:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013fb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801402:	83 ec 0c             	sub    $0xc,%esp
  801405:	25 07 0e 00 00       	and    $0xe07,%eax
  80140a:	50                   	push   %eax
  80140b:	57                   	push   %edi
  80140c:	6a 00                	push   $0x0
  80140e:	53                   	push   %ebx
  80140f:	6a 00                	push   $0x0
  801411:	e8 f4 f9 ff ff       	call   800e0a <sys_page_map>
  801416:	89 c3                	mov    %eax,%ebx
  801418:	83 c4 20             	add    $0x20,%esp
  80141b:	85 c0                	test   %eax,%eax
  80141d:	79 a3                	jns    8013c2 <dup+0x74>
	sys_page_unmap(0, newfd);
  80141f:	83 ec 08             	sub    $0x8,%esp
  801422:	56                   	push   %esi
  801423:	6a 00                	push   $0x0
  801425:	e8 22 fa ff ff       	call   800e4c <sys_page_unmap>
	sys_page_unmap(0, nva);
  80142a:	83 c4 08             	add    $0x8,%esp
  80142d:	57                   	push   %edi
  80142e:	6a 00                	push   $0x0
  801430:	e8 17 fa ff ff       	call   800e4c <sys_page_unmap>
	return r;
  801435:	83 c4 10             	add    $0x10,%esp
  801438:	eb b7                	jmp    8013f1 <dup+0xa3>

0080143a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	53                   	push   %ebx
  80143e:	83 ec 1c             	sub    $0x1c,%esp
  801441:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801444:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801447:	50                   	push   %eax
  801448:	53                   	push   %ebx
  801449:	e8 7c fd ff ff       	call   8011ca <fd_lookup>
  80144e:	83 c4 10             	add    $0x10,%esp
  801451:	85 c0                	test   %eax,%eax
  801453:	78 3f                	js     801494 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801455:	83 ec 08             	sub    $0x8,%esp
  801458:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80145b:	50                   	push   %eax
  80145c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80145f:	ff 30                	pushl  (%eax)
  801461:	e8 b4 fd ff ff       	call   80121a <dev_lookup>
  801466:	83 c4 10             	add    $0x10,%esp
  801469:	85 c0                	test   %eax,%eax
  80146b:	78 27                	js     801494 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80146d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801470:	8b 42 08             	mov    0x8(%edx),%eax
  801473:	83 e0 03             	and    $0x3,%eax
  801476:	83 f8 01             	cmp    $0x1,%eax
  801479:	74 1e                	je     801499 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80147b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147e:	8b 40 08             	mov    0x8(%eax),%eax
  801481:	85 c0                	test   %eax,%eax
  801483:	74 35                	je     8014ba <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801485:	83 ec 04             	sub    $0x4,%esp
  801488:	ff 75 10             	pushl  0x10(%ebp)
  80148b:	ff 75 0c             	pushl  0xc(%ebp)
  80148e:	52                   	push   %edx
  80148f:	ff d0                	call   *%eax
  801491:	83 c4 10             	add    $0x10,%esp
}
  801494:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801497:	c9                   	leave  
  801498:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801499:	a1 08 40 80 00       	mov    0x804008,%eax
  80149e:	8b 40 48             	mov    0x48(%eax),%eax
  8014a1:	83 ec 04             	sub    $0x4,%esp
  8014a4:	53                   	push   %ebx
  8014a5:	50                   	push   %eax
  8014a6:	68 30 2c 80 00       	push   $0x802c30
  8014ab:	e8 c6 ed ff ff       	call   800276 <cprintf>
		return -E_INVAL;
  8014b0:	83 c4 10             	add    $0x10,%esp
  8014b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014b8:	eb da                	jmp    801494 <read+0x5a>
		return -E_NOT_SUPP;
  8014ba:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014bf:	eb d3                	jmp    801494 <read+0x5a>

008014c1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014c1:	55                   	push   %ebp
  8014c2:	89 e5                	mov    %esp,%ebp
  8014c4:	57                   	push   %edi
  8014c5:	56                   	push   %esi
  8014c6:	53                   	push   %ebx
  8014c7:	83 ec 0c             	sub    $0xc,%esp
  8014ca:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014cd:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014d5:	39 f3                	cmp    %esi,%ebx
  8014d7:	73 23                	jae    8014fc <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014d9:	83 ec 04             	sub    $0x4,%esp
  8014dc:	89 f0                	mov    %esi,%eax
  8014de:	29 d8                	sub    %ebx,%eax
  8014e0:	50                   	push   %eax
  8014e1:	89 d8                	mov    %ebx,%eax
  8014e3:	03 45 0c             	add    0xc(%ebp),%eax
  8014e6:	50                   	push   %eax
  8014e7:	57                   	push   %edi
  8014e8:	e8 4d ff ff ff       	call   80143a <read>
		if (m < 0)
  8014ed:	83 c4 10             	add    $0x10,%esp
  8014f0:	85 c0                	test   %eax,%eax
  8014f2:	78 06                	js     8014fa <readn+0x39>
			return m;
		if (m == 0)
  8014f4:	74 06                	je     8014fc <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8014f6:	01 c3                	add    %eax,%ebx
  8014f8:	eb db                	jmp    8014d5 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014fa:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014fc:	89 d8                	mov    %ebx,%eax
  8014fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801501:	5b                   	pop    %ebx
  801502:	5e                   	pop    %esi
  801503:	5f                   	pop    %edi
  801504:	5d                   	pop    %ebp
  801505:	c3                   	ret    

00801506 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
  801509:	53                   	push   %ebx
  80150a:	83 ec 1c             	sub    $0x1c,%esp
  80150d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801510:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801513:	50                   	push   %eax
  801514:	53                   	push   %ebx
  801515:	e8 b0 fc ff ff       	call   8011ca <fd_lookup>
  80151a:	83 c4 10             	add    $0x10,%esp
  80151d:	85 c0                	test   %eax,%eax
  80151f:	78 3a                	js     80155b <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801521:	83 ec 08             	sub    $0x8,%esp
  801524:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801527:	50                   	push   %eax
  801528:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152b:	ff 30                	pushl  (%eax)
  80152d:	e8 e8 fc ff ff       	call   80121a <dev_lookup>
  801532:	83 c4 10             	add    $0x10,%esp
  801535:	85 c0                	test   %eax,%eax
  801537:	78 22                	js     80155b <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801539:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801540:	74 1e                	je     801560 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801542:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801545:	8b 52 0c             	mov    0xc(%edx),%edx
  801548:	85 d2                	test   %edx,%edx
  80154a:	74 35                	je     801581 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80154c:	83 ec 04             	sub    $0x4,%esp
  80154f:	ff 75 10             	pushl  0x10(%ebp)
  801552:	ff 75 0c             	pushl  0xc(%ebp)
  801555:	50                   	push   %eax
  801556:	ff d2                	call   *%edx
  801558:	83 c4 10             	add    $0x10,%esp
}
  80155b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80155e:	c9                   	leave  
  80155f:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801560:	a1 08 40 80 00       	mov    0x804008,%eax
  801565:	8b 40 48             	mov    0x48(%eax),%eax
  801568:	83 ec 04             	sub    $0x4,%esp
  80156b:	53                   	push   %ebx
  80156c:	50                   	push   %eax
  80156d:	68 4c 2c 80 00       	push   $0x802c4c
  801572:	e8 ff ec ff ff       	call   800276 <cprintf>
		return -E_INVAL;
  801577:	83 c4 10             	add    $0x10,%esp
  80157a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80157f:	eb da                	jmp    80155b <write+0x55>
		return -E_NOT_SUPP;
  801581:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801586:	eb d3                	jmp    80155b <write+0x55>

00801588 <seek>:

int
seek(int fdnum, off_t offset)
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
  80158b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80158e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801591:	50                   	push   %eax
  801592:	ff 75 08             	pushl  0x8(%ebp)
  801595:	e8 30 fc ff ff       	call   8011ca <fd_lookup>
  80159a:	83 c4 10             	add    $0x10,%esp
  80159d:	85 c0                	test   %eax,%eax
  80159f:	78 0e                	js     8015af <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a7:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	53                   	push   %ebx
  8015b5:	83 ec 1c             	sub    $0x1c,%esp
  8015b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015be:	50                   	push   %eax
  8015bf:	53                   	push   %ebx
  8015c0:	e8 05 fc ff ff       	call   8011ca <fd_lookup>
  8015c5:	83 c4 10             	add    $0x10,%esp
  8015c8:	85 c0                	test   %eax,%eax
  8015ca:	78 37                	js     801603 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015cc:	83 ec 08             	sub    $0x8,%esp
  8015cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d2:	50                   	push   %eax
  8015d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d6:	ff 30                	pushl  (%eax)
  8015d8:	e8 3d fc ff ff       	call   80121a <dev_lookup>
  8015dd:	83 c4 10             	add    $0x10,%esp
  8015e0:	85 c0                	test   %eax,%eax
  8015e2:	78 1f                	js     801603 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015eb:	74 1b                	je     801608 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f0:	8b 52 18             	mov    0x18(%edx),%edx
  8015f3:	85 d2                	test   %edx,%edx
  8015f5:	74 32                	je     801629 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015f7:	83 ec 08             	sub    $0x8,%esp
  8015fa:	ff 75 0c             	pushl  0xc(%ebp)
  8015fd:	50                   	push   %eax
  8015fe:	ff d2                	call   *%edx
  801600:	83 c4 10             	add    $0x10,%esp
}
  801603:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801606:	c9                   	leave  
  801607:	c3                   	ret    
			thisenv->env_id, fdnum);
  801608:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80160d:	8b 40 48             	mov    0x48(%eax),%eax
  801610:	83 ec 04             	sub    $0x4,%esp
  801613:	53                   	push   %ebx
  801614:	50                   	push   %eax
  801615:	68 0c 2c 80 00       	push   $0x802c0c
  80161a:	e8 57 ec ff ff       	call   800276 <cprintf>
		return -E_INVAL;
  80161f:	83 c4 10             	add    $0x10,%esp
  801622:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801627:	eb da                	jmp    801603 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801629:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80162e:	eb d3                	jmp    801603 <ftruncate+0x52>

00801630 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	53                   	push   %ebx
  801634:	83 ec 1c             	sub    $0x1c,%esp
  801637:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80163a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80163d:	50                   	push   %eax
  80163e:	ff 75 08             	pushl  0x8(%ebp)
  801641:	e8 84 fb ff ff       	call   8011ca <fd_lookup>
  801646:	83 c4 10             	add    $0x10,%esp
  801649:	85 c0                	test   %eax,%eax
  80164b:	78 4b                	js     801698 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80164d:	83 ec 08             	sub    $0x8,%esp
  801650:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801653:	50                   	push   %eax
  801654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801657:	ff 30                	pushl  (%eax)
  801659:	e8 bc fb ff ff       	call   80121a <dev_lookup>
  80165e:	83 c4 10             	add    $0x10,%esp
  801661:	85 c0                	test   %eax,%eax
  801663:	78 33                	js     801698 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801668:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80166c:	74 2f                	je     80169d <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80166e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801671:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801678:	00 00 00 
	stat->st_isdir = 0;
  80167b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801682:	00 00 00 
	stat->st_dev = dev;
  801685:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80168b:	83 ec 08             	sub    $0x8,%esp
  80168e:	53                   	push   %ebx
  80168f:	ff 75 f0             	pushl  -0x10(%ebp)
  801692:	ff 50 14             	call   *0x14(%eax)
  801695:	83 c4 10             	add    $0x10,%esp
}
  801698:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80169b:	c9                   	leave  
  80169c:	c3                   	ret    
		return -E_NOT_SUPP;
  80169d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016a2:	eb f4                	jmp    801698 <fstat+0x68>

008016a4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	56                   	push   %esi
  8016a8:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016a9:	83 ec 08             	sub    $0x8,%esp
  8016ac:	6a 00                	push   $0x0
  8016ae:	ff 75 08             	pushl  0x8(%ebp)
  8016b1:	e8 22 02 00 00       	call   8018d8 <open>
  8016b6:	89 c3                	mov    %eax,%ebx
  8016b8:	83 c4 10             	add    $0x10,%esp
  8016bb:	85 c0                	test   %eax,%eax
  8016bd:	78 1b                	js     8016da <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016bf:	83 ec 08             	sub    $0x8,%esp
  8016c2:	ff 75 0c             	pushl  0xc(%ebp)
  8016c5:	50                   	push   %eax
  8016c6:	e8 65 ff ff ff       	call   801630 <fstat>
  8016cb:	89 c6                	mov    %eax,%esi
	close(fd);
  8016cd:	89 1c 24             	mov    %ebx,(%esp)
  8016d0:	e8 27 fc ff ff       	call   8012fc <close>
	return r;
  8016d5:	83 c4 10             	add    $0x10,%esp
  8016d8:	89 f3                	mov    %esi,%ebx
}
  8016da:	89 d8                	mov    %ebx,%eax
  8016dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016df:	5b                   	pop    %ebx
  8016e0:	5e                   	pop    %esi
  8016e1:	5d                   	pop    %ebp
  8016e2:	c3                   	ret    

008016e3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
  8016e6:	56                   	push   %esi
  8016e7:	53                   	push   %ebx
  8016e8:	89 c6                	mov    %eax,%esi
  8016ea:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016ec:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016f3:	74 27                	je     80171c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016f5:	6a 07                	push   $0x7
  8016f7:	68 00 50 80 00       	push   $0x805000
  8016fc:	56                   	push   %esi
  8016fd:	ff 35 00 40 80 00    	pushl  0x804000
  801703:	e8 08 0c 00 00       	call   802310 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801708:	83 c4 0c             	add    $0xc,%esp
  80170b:	6a 00                	push   $0x0
  80170d:	53                   	push   %ebx
  80170e:	6a 00                	push   $0x0
  801710:	e8 92 0b 00 00       	call   8022a7 <ipc_recv>
}
  801715:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801718:	5b                   	pop    %ebx
  801719:	5e                   	pop    %esi
  80171a:	5d                   	pop    %ebp
  80171b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80171c:	83 ec 0c             	sub    $0xc,%esp
  80171f:	6a 01                	push   $0x1
  801721:	e8 42 0c 00 00       	call   802368 <ipc_find_env>
  801726:	a3 00 40 80 00       	mov    %eax,0x804000
  80172b:	83 c4 10             	add    $0x10,%esp
  80172e:	eb c5                	jmp    8016f5 <fsipc+0x12>

00801730 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	8b 40 0c             	mov    0xc(%eax),%eax
  80173c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801741:	8b 45 0c             	mov    0xc(%ebp),%eax
  801744:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801749:	ba 00 00 00 00       	mov    $0x0,%edx
  80174e:	b8 02 00 00 00       	mov    $0x2,%eax
  801753:	e8 8b ff ff ff       	call   8016e3 <fsipc>
}
  801758:	c9                   	leave  
  801759:	c3                   	ret    

0080175a <devfile_flush>:
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
  80175d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801760:	8b 45 08             	mov    0x8(%ebp),%eax
  801763:	8b 40 0c             	mov    0xc(%eax),%eax
  801766:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80176b:	ba 00 00 00 00       	mov    $0x0,%edx
  801770:	b8 06 00 00 00       	mov    $0x6,%eax
  801775:	e8 69 ff ff ff       	call   8016e3 <fsipc>
}
  80177a:	c9                   	leave  
  80177b:	c3                   	ret    

0080177c <devfile_stat>:
{
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
  80177f:	53                   	push   %ebx
  801780:	83 ec 04             	sub    $0x4,%esp
  801783:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801786:	8b 45 08             	mov    0x8(%ebp),%eax
  801789:	8b 40 0c             	mov    0xc(%eax),%eax
  80178c:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801791:	ba 00 00 00 00       	mov    $0x0,%edx
  801796:	b8 05 00 00 00       	mov    $0x5,%eax
  80179b:	e8 43 ff ff ff       	call   8016e3 <fsipc>
  8017a0:	85 c0                	test   %eax,%eax
  8017a2:	78 2c                	js     8017d0 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017a4:	83 ec 08             	sub    $0x8,%esp
  8017a7:	68 00 50 80 00       	push   $0x805000
  8017ac:	53                   	push   %ebx
  8017ad:	e8 23 f2 ff ff       	call   8009d5 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017b2:	a1 80 50 80 00       	mov    0x805080,%eax
  8017b7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017bd:	a1 84 50 80 00       	mov    0x805084,%eax
  8017c2:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017c8:	83 c4 10             	add    $0x10,%esp
  8017cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <devfile_write>:
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	53                   	push   %ebx
  8017d9:	83 ec 08             	sub    $0x8,%esp
  8017dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8017ea:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8017f0:	53                   	push   %ebx
  8017f1:	ff 75 0c             	pushl  0xc(%ebp)
  8017f4:	68 08 50 80 00       	push   $0x805008
  8017f9:	e8 c7 f3 ff ff       	call   800bc5 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801803:	b8 04 00 00 00       	mov    $0x4,%eax
  801808:	e8 d6 fe ff ff       	call   8016e3 <fsipc>
  80180d:	83 c4 10             	add    $0x10,%esp
  801810:	85 c0                	test   %eax,%eax
  801812:	78 0b                	js     80181f <devfile_write+0x4a>
	assert(r <= n);
  801814:	39 d8                	cmp    %ebx,%eax
  801816:	77 0c                	ja     801824 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801818:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80181d:	7f 1e                	jg     80183d <devfile_write+0x68>
}
  80181f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801822:	c9                   	leave  
  801823:	c3                   	ret    
	assert(r <= n);
  801824:	68 80 2c 80 00       	push   $0x802c80
  801829:	68 87 2c 80 00       	push   $0x802c87
  80182e:	68 98 00 00 00       	push   $0x98
  801833:	68 9c 2c 80 00       	push   $0x802c9c
  801838:	e8 43 e9 ff ff       	call   800180 <_panic>
	assert(r <= PGSIZE);
  80183d:	68 a7 2c 80 00       	push   $0x802ca7
  801842:	68 87 2c 80 00       	push   $0x802c87
  801847:	68 99 00 00 00       	push   $0x99
  80184c:	68 9c 2c 80 00       	push   $0x802c9c
  801851:	e8 2a e9 ff ff       	call   800180 <_panic>

00801856 <devfile_read>:
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	56                   	push   %esi
  80185a:	53                   	push   %ebx
  80185b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80185e:	8b 45 08             	mov    0x8(%ebp),%eax
  801861:	8b 40 0c             	mov    0xc(%eax),%eax
  801864:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801869:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80186f:	ba 00 00 00 00       	mov    $0x0,%edx
  801874:	b8 03 00 00 00       	mov    $0x3,%eax
  801879:	e8 65 fe ff ff       	call   8016e3 <fsipc>
  80187e:	89 c3                	mov    %eax,%ebx
  801880:	85 c0                	test   %eax,%eax
  801882:	78 1f                	js     8018a3 <devfile_read+0x4d>
	assert(r <= n);
  801884:	39 f0                	cmp    %esi,%eax
  801886:	77 24                	ja     8018ac <devfile_read+0x56>
	assert(r <= PGSIZE);
  801888:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80188d:	7f 33                	jg     8018c2 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80188f:	83 ec 04             	sub    $0x4,%esp
  801892:	50                   	push   %eax
  801893:	68 00 50 80 00       	push   $0x805000
  801898:	ff 75 0c             	pushl  0xc(%ebp)
  80189b:	e8 c3 f2 ff ff       	call   800b63 <memmove>
	return r;
  8018a0:	83 c4 10             	add    $0x10,%esp
}
  8018a3:	89 d8                	mov    %ebx,%eax
  8018a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018a8:	5b                   	pop    %ebx
  8018a9:	5e                   	pop    %esi
  8018aa:	5d                   	pop    %ebp
  8018ab:	c3                   	ret    
	assert(r <= n);
  8018ac:	68 80 2c 80 00       	push   $0x802c80
  8018b1:	68 87 2c 80 00       	push   $0x802c87
  8018b6:	6a 7c                	push   $0x7c
  8018b8:	68 9c 2c 80 00       	push   $0x802c9c
  8018bd:	e8 be e8 ff ff       	call   800180 <_panic>
	assert(r <= PGSIZE);
  8018c2:	68 a7 2c 80 00       	push   $0x802ca7
  8018c7:	68 87 2c 80 00       	push   $0x802c87
  8018cc:	6a 7d                	push   $0x7d
  8018ce:	68 9c 2c 80 00       	push   $0x802c9c
  8018d3:	e8 a8 e8 ff ff       	call   800180 <_panic>

008018d8 <open>:
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
  8018db:	56                   	push   %esi
  8018dc:	53                   	push   %ebx
  8018dd:	83 ec 1c             	sub    $0x1c,%esp
  8018e0:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018e3:	56                   	push   %esi
  8018e4:	e8 b3 f0 ff ff       	call   80099c <strlen>
  8018e9:	83 c4 10             	add    $0x10,%esp
  8018ec:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018f1:	7f 6c                	jg     80195f <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018f3:	83 ec 0c             	sub    $0xc,%esp
  8018f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018f9:	50                   	push   %eax
  8018fa:	e8 79 f8 ff ff       	call   801178 <fd_alloc>
  8018ff:	89 c3                	mov    %eax,%ebx
  801901:	83 c4 10             	add    $0x10,%esp
  801904:	85 c0                	test   %eax,%eax
  801906:	78 3c                	js     801944 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801908:	83 ec 08             	sub    $0x8,%esp
  80190b:	56                   	push   %esi
  80190c:	68 00 50 80 00       	push   $0x805000
  801911:	e8 bf f0 ff ff       	call   8009d5 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801916:	8b 45 0c             	mov    0xc(%ebp),%eax
  801919:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80191e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801921:	b8 01 00 00 00       	mov    $0x1,%eax
  801926:	e8 b8 fd ff ff       	call   8016e3 <fsipc>
  80192b:	89 c3                	mov    %eax,%ebx
  80192d:	83 c4 10             	add    $0x10,%esp
  801930:	85 c0                	test   %eax,%eax
  801932:	78 19                	js     80194d <open+0x75>
	return fd2num(fd);
  801934:	83 ec 0c             	sub    $0xc,%esp
  801937:	ff 75 f4             	pushl  -0xc(%ebp)
  80193a:	e8 12 f8 ff ff       	call   801151 <fd2num>
  80193f:	89 c3                	mov    %eax,%ebx
  801941:	83 c4 10             	add    $0x10,%esp
}
  801944:	89 d8                	mov    %ebx,%eax
  801946:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801949:	5b                   	pop    %ebx
  80194a:	5e                   	pop    %esi
  80194b:	5d                   	pop    %ebp
  80194c:	c3                   	ret    
		fd_close(fd, 0);
  80194d:	83 ec 08             	sub    $0x8,%esp
  801950:	6a 00                	push   $0x0
  801952:	ff 75 f4             	pushl  -0xc(%ebp)
  801955:	e8 1b f9 ff ff       	call   801275 <fd_close>
		return r;
  80195a:	83 c4 10             	add    $0x10,%esp
  80195d:	eb e5                	jmp    801944 <open+0x6c>
		return -E_BAD_PATH;
  80195f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801964:	eb de                	jmp    801944 <open+0x6c>

00801966 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
  801969:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80196c:	ba 00 00 00 00       	mov    $0x0,%edx
  801971:	b8 08 00 00 00       	mov    $0x8,%eax
  801976:	e8 68 fd ff ff       	call   8016e3 <fsipc>
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
  801980:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801983:	68 b3 2c 80 00       	push   $0x802cb3
  801988:	ff 75 0c             	pushl  0xc(%ebp)
  80198b:	e8 45 f0 ff ff       	call   8009d5 <strcpy>
	return 0;
}
  801990:	b8 00 00 00 00       	mov    $0x0,%eax
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <devsock_close>:
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
  80199a:	53                   	push   %ebx
  80199b:	83 ec 10             	sub    $0x10,%esp
  80199e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8019a1:	53                   	push   %ebx
  8019a2:	e8 00 0a 00 00       	call   8023a7 <pageref>
  8019a7:	83 c4 10             	add    $0x10,%esp
		return 0;
  8019aa:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8019af:	83 f8 01             	cmp    $0x1,%eax
  8019b2:	74 07                	je     8019bb <devsock_close+0x24>
}
  8019b4:	89 d0                	mov    %edx,%eax
  8019b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8019bb:	83 ec 0c             	sub    $0xc,%esp
  8019be:	ff 73 0c             	pushl  0xc(%ebx)
  8019c1:	e8 b9 02 00 00       	call   801c7f <nsipc_close>
  8019c6:	89 c2                	mov    %eax,%edx
  8019c8:	83 c4 10             	add    $0x10,%esp
  8019cb:	eb e7                	jmp    8019b4 <devsock_close+0x1d>

008019cd <devsock_write>:
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
  8019d0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019d3:	6a 00                	push   $0x0
  8019d5:	ff 75 10             	pushl  0x10(%ebp)
  8019d8:	ff 75 0c             	pushl  0xc(%ebp)
  8019db:	8b 45 08             	mov    0x8(%ebp),%eax
  8019de:	ff 70 0c             	pushl  0xc(%eax)
  8019e1:	e8 76 03 00 00       	call   801d5c <nsipc_send>
}
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <devsock_read>:
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
  8019eb:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019ee:	6a 00                	push   $0x0
  8019f0:	ff 75 10             	pushl  0x10(%ebp)
  8019f3:	ff 75 0c             	pushl  0xc(%ebp)
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	ff 70 0c             	pushl  0xc(%eax)
  8019fc:	e8 ef 02 00 00       	call   801cf0 <nsipc_recv>
}
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <fd2sockid>:
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
  801a06:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a09:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a0c:	52                   	push   %edx
  801a0d:	50                   	push   %eax
  801a0e:	e8 b7 f7 ff ff       	call   8011ca <fd_lookup>
  801a13:	83 c4 10             	add    $0x10,%esp
  801a16:	85 c0                	test   %eax,%eax
  801a18:	78 10                	js     801a2a <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a1d:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a23:	39 08                	cmp    %ecx,(%eax)
  801a25:	75 05                	jne    801a2c <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a27:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    
		return -E_NOT_SUPP;
  801a2c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a31:	eb f7                	jmp    801a2a <fd2sockid+0x27>

00801a33 <alloc_sockfd>:
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
  801a36:	56                   	push   %esi
  801a37:	53                   	push   %ebx
  801a38:	83 ec 1c             	sub    $0x1c,%esp
  801a3b:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a3d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a40:	50                   	push   %eax
  801a41:	e8 32 f7 ff ff       	call   801178 <fd_alloc>
  801a46:	89 c3                	mov    %eax,%ebx
  801a48:	83 c4 10             	add    $0x10,%esp
  801a4b:	85 c0                	test   %eax,%eax
  801a4d:	78 43                	js     801a92 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a4f:	83 ec 04             	sub    $0x4,%esp
  801a52:	68 07 04 00 00       	push   $0x407
  801a57:	ff 75 f4             	pushl  -0xc(%ebp)
  801a5a:	6a 00                	push   $0x0
  801a5c:	e8 66 f3 ff ff       	call   800dc7 <sys_page_alloc>
  801a61:	89 c3                	mov    %eax,%ebx
  801a63:	83 c4 10             	add    $0x10,%esp
  801a66:	85 c0                	test   %eax,%eax
  801a68:	78 28                	js     801a92 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6d:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a73:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a78:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a7f:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a82:	83 ec 0c             	sub    $0xc,%esp
  801a85:	50                   	push   %eax
  801a86:	e8 c6 f6 ff ff       	call   801151 <fd2num>
  801a8b:	89 c3                	mov    %eax,%ebx
  801a8d:	83 c4 10             	add    $0x10,%esp
  801a90:	eb 0c                	jmp    801a9e <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a92:	83 ec 0c             	sub    $0xc,%esp
  801a95:	56                   	push   %esi
  801a96:	e8 e4 01 00 00       	call   801c7f <nsipc_close>
		return r;
  801a9b:	83 c4 10             	add    $0x10,%esp
}
  801a9e:	89 d8                	mov    %ebx,%eax
  801aa0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aa3:	5b                   	pop    %ebx
  801aa4:	5e                   	pop    %esi
  801aa5:	5d                   	pop    %ebp
  801aa6:	c3                   	ret    

00801aa7 <accept>:
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
  801aaa:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801aad:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab0:	e8 4e ff ff ff       	call   801a03 <fd2sockid>
  801ab5:	85 c0                	test   %eax,%eax
  801ab7:	78 1b                	js     801ad4 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ab9:	83 ec 04             	sub    $0x4,%esp
  801abc:	ff 75 10             	pushl  0x10(%ebp)
  801abf:	ff 75 0c             	pushl  0xc(%ebp)
  801ac2:	50                   	push   %eax
  801ac3:	e8 0e 01 00 00       	call   801bd6 <nsipc_accept>
  801ac8:	83 c4 10             	add    $0x10,%esp
  801acb:	85 c0                	test   %eax,%eax
  801acd:	78 05                	js     801ad4 <accept+0x2d>
	return alloc_sockfd(r);
  801acf:	e8 5f ff ff ff       	call   801a33 <alloc_sockfd>
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <bind>:
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801adc:	8b 45 08             	mov    0x8(%ebp),%eax
  801adf:	e8 1f ff ff ff       	call   801a03 <fd2sockid>
  801ae4:	85 c0                	test   %eax,%eax
  801ae6:	78 12                	js     801afa <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801ae8:	83 ec 04             	sub    $0x4,%esp
  801aeb:	ff 75 10             	pushl  0x10(%ebp)
  801aee:	ff 75 0c             	pushl  0xc(%ebp)
  801af1:	50                   	push   %eax
  801af2:	e8 31 01 00 00       	call   801c28 <nsipc_bind>
  801af7:	83 c4 10             	add    $0x10,%esp
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <shutdown>:
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
  801aff:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b02:	8b 45 08             	mov    0x8(%ebp),%eax
  801b05:	e8 f9 fe ff ff       	call   801a03 <fd2sockid>
  801b0a:	85 c0                	test   %eax,%eax
  801b0c:	78 0f                	js     801b1d <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801b0e:	83 ec 08             	sub    $0x8,%esp
  801b11:	ff 75 0c             	pushl  0xc(%ebp)
  801b14:	50                   	push   %eax
  801b15:	e8 43 01 00 00       	call   801c5d <nsipc_shutdown>
  801b1a:	83 c4 10             	add    $0x10,%esp
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <connect>:
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
  801b22:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b25:	8b 45 08             	mov    0x8(%ebp),%eax
  801b28:	e8 d6 fe ff ff       	call   801a03 <fd2sockid>
  801b2d:	85 c0                	test   %eax,%eax
  801b2f:	78 12                	js     801b43 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b31:	83 ec 04             	sub    $0x4,%esp
  801b34:	ff 75 10             	pushl  0x10(%ebp)
  801b37:	ff 75 0c             	pushl  0xc(%ebp)
  801b3a:	50                   	push   %eax
  801b3b:	e8 59 01 00 00       	call   801c99 <nsipc_connect>
  801b40:	83 c4 10             	add    $0x10,%esp
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <listen>:
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	e8 b0 fe ff ff       	call   801a03 <fd2sockid>
  801b53:	85 c0                	test   %eax,%eax
  801b55:	78 0f                	js     801b66 <listen+0x21>
	return nsipc_listen(r, backlog);
  801b57:	83 ec 08             	sub    $0x8,%esp
  801b5a:	ff 75 0c             	pushl  0xc(%ebp)
  801b5d:	50                   	push   %eax
  801b5e:	e8 6b 01 00 00       	call   801cce <nsipc_listen>
  801b63:	83 c4 10             	add    $0x10,%esp
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <socket>:

int
socket(int domain, int type, int protocol)
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
  801b6b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b6e:	ff 75 10             	pushl  0x10(%ebp)
  801b71:	ff 75 0c             	pushl  0xc(%ebp)
  801b74:	ff 75 08             	pushl  0x8(%ebp)
  801b77:	e8 3e 02 00 00       	call   801dba <nsipc_socket>
  801b7c:	83 c4 10             	add    $0x10,%esp
  801b7f:	85 c0                	test   %eax,%eax
  801b81:	78 05                	js     801b88 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801b83:	e8 ab fe ff ff       	call   801a33 <alloc_sockfd>
}
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
  801b8d:	53                   	push   %ebx
  801b8e:	83 ec 04             	sub    $0x4,%esp
  801b91:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b93:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b9a:	74 26                	je     801bc2 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b9c:	6a 07                	push   $0x7
  801b9e:	68 00 60 80 00       	push   $0x806000
  801ba3:	53                   	push   %ebx
  801ba4:	ff 35 04 40 80 00    	pushl  0x804004
  801baa:	e8 61 07 00 00       	call   802310 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801baf:	83 c4 0c             	add    $0xc,%esp
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	e8 ea 06 00 00       	call   8022a7 <ipc_recv>
}
  801bbd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801bc2:	83 ec 0c             	sub    $0xc,%esp
  801bc5:	6a 02                	push   $0x2
  801bc7:	e8 9c 07 00 00       	call   802368 <ipc_find_env>
  801bcc:	a3 04 40 80 00       	mov    %eax,0x804004
  801bd1:	83 c4 10             	add    $0x10,%esp
  801bd4:	eb c6                	jmp    801b9c <nsipc+0x12>

00801bd6 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	56                   	push   %esi
  801bda:	53                   	push   %ebx
  801bdb:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801bde:	8b 45 08             	mov    0x8(%ebp),%eax
  801be1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801be6:	8b 06                	mov    (%esi),%eax
  801be8:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801bed:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf2:	e8 93 ff ff ff       	call   801b8a <nsipc>
  801bf7:	89 c3                	mov    %eax,%ebx
  801bf9:	85 c0                	test   %eax,%eax
  801bfb:	79 09                	jns    801c06 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801bfd:	89 d8                	mov    %ebx,%eax
  801bff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c02:	5b                   	pop    %ebx
  801c03:	5e                   	pop    %esi
  801c04:	5d                   	pop    %ebp
  801c05:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c06:	83 ec 04             	sub    $0x4,%esp
  801c09:	ff 35 10 60 80 00    	pushl  0x806010
  801c0f:	68 00 60 80 00       	push   $0x806000
  801c14:	ff 75 0c             	pushl  0xc(%ebp)
  801c17:	e8 47 ef ff ff       	call   800b63 <memmove>
		*addrlen = ret->ret_addrlen;
  801c1c:	a1 10 60 80 00       	mov    0x806010,%eax
  801c21:	89 06                	mov    %eax,(%esi)
  801c23:	83 c4 10             	add    $0x10,%esp
	return r;
  801c26:	eb d5                	jmp    801bfd <nsipc_accept+0x27>

00801c28 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
  801c2b:	53                   	push   %ebx
  801c2c:	83 ec 08             	sub    $0x8,%esp
  801c2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c32:	8b 45 08             	mov    0x8(%ebp),%eax
  801c35:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c3a:	53                   	push   %ebx
  801c3b:	ff 75 0c             	pushl  0xc(%ebp)
  801c3e:	68 04 60 80 00       	push   $0x806004
  801c43:	e8 1b ef ff ff       	call   800b63 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c48:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c4e:	b8 02 00 00 00       	mov    $0x2,%eax
  801c53:	e8 32 ff ff ff       	call   801b8a <nsipc>
}
  801c58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c63:	8b 45 08             	mov    0x8(%ebp),%eax
  801c66:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6e:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801c73:	b8 03 00 00 00       	mov    $0x3,%eax
  801c78:	e8 0d ff ff ff       	call   801b8a <nsipc>
}
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <nsipc_close>:

int
nsipc_close(int s)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c85:	8b 45 08             	mov    0x8(%ebp),%eax
  801c88:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c8d:	b8 04 00 00 00       	mov    $0x4,%eax
  801c92:	e8 f3 fe ff ff       	call   801b8a <nsipc>
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
  801c9c:	53                   	push   %ebx
  801c9d:	83 ec 08             	sub    $0x8,%esp
  801ca0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca6:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801cab:	53                   	push   %ebx
  801cac:	ff 75 0c             	pushl  0xc(%ebp)
  801caf:	68 04 60 80 00       	push   $0x806004
  801cb4:	e8 aa ee ff ff       	call   800b63 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801cb9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801cbf:	b8 05 00 00 00       	mov    $0x5,%eax
  801cc4:	e8 c1 fe ff ff       	call   801b8a <nsipc>
}
  801cc9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
  801cd1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cdf:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801ce4:	b8 06 00 00 00       	mov    $0x6,%eax
  801ce9:	e8 9c fe ff ff       	call   801b8a <nsipc>
}
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
  801cf3:	56                   	push   %esi
  801cf4:	53                   	push   %ebx
  801cf5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d00:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d06:	8b 45 14             	mov    0x14(%ebp),%eax
  801d09:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d0e:	b8 07 00 00 00       	mov    $0x7,%eax
  801d13:	e8 72 fe ff ff       	call   801b8a <nsipc>
  801d18:	89 c3                	mov    %eax,%ebx
  801d1a:	85 c0                	test   %eax,%eax
  801d1c:	78 1f                	js     801d3d <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d1e:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d23:	7f 21                	jg     801d46 <nsipc_recv+0x56>
  801d25:	39 c6                	cmp    %eax,%esi
  801d27:	7c 1d                	jl     801d46 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d29:	83 ec 04             	sub    $0x4,%esp
  801d2c:	50                   	push   %eax
  801d2d:	68 00 60 80 00       	push   $0x806000
  801d32:	ff 75 0c             	pushl  0xc(%ebp)
  801d35:	e8 29 ee ff ff       	call   800b63 <memmove>
  801d3a:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d3d:	89 d8                	mov    %ebx,%eax
  801d3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d42:	5b                   	pop    %ebx
  801d43:	5e                   	pop    %esi
  801d44:	5d                   	pop    %ebp
  801d45:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d46:	68 bf 2c 80 00       	push   $0x802cbf
  801d4b:	68 87 2c 80 00       	push   $0x802c87
  801d50:	6a 62                	push   $0x62
  801d52:	68 d4 2c 80 00       	push   $0x802cd4
  801d57:	e8 24 e4 ff ff       	call   800180 <_panic>

00801d5c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
  801d5f:	53                   	push   %ebx
  801d60:	83 ec 04             	sub    $0x4,%esp
  801d63:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d66:	8b 45 08             	mov    0x8(%ebp),%eax
  801d69:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d6e:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d74:	7f 2e                	jg     801da4 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d76:	83 ec 04             	sub    $0x4,%esp
  801d79:	53                   	push   %ebx
  801d7a:	ff 75 0c             	pushl  0xc(%ebp)
  801d7d:	68 0c 60 80 00       	push   $0x80600c
  801d82:	e8 dc ed ff ff       	call   800b63 <memmove>
	nsipcbuf.send.req_size = size;
  801d87:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d8d:	8b 45 14             	mov    0x14(%ebp),%eax
  801d90:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d95:	b8 08 00 00 00       	mov    $0x8,%eax
  801d9a:	e8 eb fd ff ff       	call   801b8a <nsipc>
}
  801d9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    
	assert(size < 1600);
  801da4:	68 e0 2c 80 00       	push   $0x802ce0
  801da9:	68 87 2c 80 00       	push   $0x802c87
  801dae:	6a 6d                	push   $0x6d
  801db0:	68 d4 2c 80 00       	push   $0x802cd4
  801db5:	e8 c6 e3 ff ff       	call   800180 <_panic>

00801dba <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
  801dbd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dcb:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801dd0:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd3:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801dd8:	b8 09 00 00 00       	mov    $0x9,%eax
  801ddd:	e8 a8 fd ff ff       	call   801b8a <nsipc>
}
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
  801de7:	56                   	push   %esi
  801de8:	53                   	push   %ebx
  801de9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801dec:	83 ec 0c             	sub    $0xc,%esp
  801def:	ff 75 08             	pushl  0x8(%ebp)
  801df2:	e8 6a f3 ff ff       	call   801161 <fd2data>
  801df7:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801df9:	83 c4 08             	add    $0x8,%esp
  801dfc:	68 ec 2c 80 00       	push   $0x802cec
  801e01:	53                   	push   %ebx
  801e02:	e8 ce eb ff ff       	call   8009d5 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e07:	8b 46 04             	mov    0x4(%esi),%eax
  801e0a:	2b 06                	sub    (%esi),%eax
  801e0c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e12:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e19:	00 00 00 
	stat->st_dev = &devpipe;
  801e1c:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801e23:	30 80 00 
	return 0;
}
  801e26:	b8 00 00 00 00       	mov    $0x0,%eax
  801e2b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e2e:	5b                   	pop    %ebx
  801e2f:	5e                   	pop    %esi
  801e30:	5d                   	pop    %ebp
  801e31:	c3                   	ret    

00801e32 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	53                   	push   %ebx
  801e36:	83 ec 0c             	sub    $0xc,%esp
  801e39:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e3c:	53                   	push   %ebx
  801e3d:	6a 00                	push   $0x0
  801e3f:	e8 08 f0 ff ff       	call   800e4c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e44:	89 1c 24             	mov    %ebx,(%esp)
  801e47:	e8 15 f3 ff ff       	call   801161 <fd2data>
  801e4c:	83 c4 08             	add    $0x8,%esp
  801e4f:	50                   	push   %eax
  801e50:	6a 00                	push   $0x0
  801e52:	e8 f5 ef ff ff       	call   800e4c <sys_page_unmap>
}
  801e57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e5a:	c9                   	leave  
  801e5b:	c3                   	ret    

00801e5c <_pipeisclosed>:
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	57                   	push   %edi
  801e60:	56                   	push   %esi
  801e61:	53                   	push   %ebx
  801e62:	83 ec 1c             	sub    $0x1c,%esp
  801e65:	89 c7                	mov    %eax,%edi
  801e67:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e69:	a1 08 40 80 00       	mov    0x804008,%eax
  801e6e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e71:	83 ec 0c             	sub    $0xc,%esp
  801e74:	57                   	push   %edi
  801e75:	e8 2d 05 00 00       	call   8023a7 <pageref>
  801e7a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e7d:	89 34 24             	mov    %esi,(%esp)
  801e80:	e8 22 05 00 00       	call   8023a7 <pageref>
		nn = thisenv->env_runs;
  801e85:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801e8b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e8e:	83 c4 10             	add    $0x10,%esp
  801e91:	39 cb                	cmp    %ecx,%ebx
  801e93:	74 1b                	je     801eb0 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e95:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e98:	75 cf                	jne    801e69 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e9a:	8b 42 58             	mov    0x58(%edx),%eax
  801e9d:	6a 01                	push   $0x1
  801e9f:	50                   	push   %eax
  801ea0:	53                   	push   %ebx
  801ea1:	68 f3 2c 80 00       	push   $0x802cf3
  801ea6:	e8 cb e3 ff ff       	call   800276 <cprintf>
  801eab:	83 c4 10             	add    $0x10,%esp
  801eae:	eb b9                	jmp    801e69 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801eb0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801eb3:	0f 94 c0             	sete   %al
  801eb6:	0f b6 c0             	movzbl %al,%eax
}
  801eb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ebc:	5b                   	pop    %ebx
  801ebd:	5e                   	pop    %esi
  801ebe:	5f                   	pop    %edi
  801ebf:	5d                   	pop    %ebp
  801ec0:	c3                   	ret    

00801ec1 <devpipe_write>:
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
  801ec4:	57                   	push   %edi
  801ec5:	56                   	push   %esi
  801ec6:	53                   	push   %ebx
  801ec7:	83 ec 28             	sub    $0x28,%esp
  801eca:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801ecd:	56                   	push   %esi
  801ece:	e8 8e f2 ff ff       	call   801161 <fd2data>
  801ed3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ed5:	83 c4 10             	add    $0x10,%esp
  801ed8:	bf 00 00 00 00       	mov    $0x0,%edi
  801edd:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ee0:	74 4f                	je     801f31 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ee2:	8b 43 04             	mov    0x4(%ebx),%eax
  801ee5:	8b 0b                	mov    (%ebx),%ecx
  801ee7:	8d 51 20             	lea    0x20(%ecx),%edx
  801eea:	39 d0                	cmp    %edx,%eax
  801eec:	72 14                	jb     801f02 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801eee:	89 da                	mov    %ebx,%edx
  801ef0:	89 f0                	mov    %esi,%eax
  801ef2:	e8 65 ff ff ff       	call   801e5c <_pipeisclosed>
  801ef7:	85 c0                	test   %eax,%eax
  801ef9:	75 3b                	jne    801f36 <devpipe_write+0x75>
			sys_yield();
  801efb:	e8 a8 ee ff ff       	call   800da8 <sys_yield>
  801f00:	eb e0                	jmp    801ee2 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f05:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f09:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f0c:	89 c2                	mov    %eax,%edx
  801f0e:	c1 fa 1f             	sar    $0x1f,%edx
  801f11:	89 d1                	mov    %edx,%ecx
  801f13:	c1 e9 1b             	shr    $0x1b,%ecx
  801f16:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801f19:	83 e2 1f             	and    $0x1f,%edx
  801f1c:	29 ca                	sub    %ecx,%edx
  801f1e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f22:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f26:	83 c0 01             	add    $0x1,%eax
  801f29:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f2c:	83 c7 01             	add    $0x1,%edi
  801f2f:	eb ac                	jmp    801edd <devpipe_write+0x1c>
	return i;
  801f31:	8b 45 10             	mov    0x10(%ebp),%eax
  801f34:	eb 05                	jmp    801f3b <devpipe_write+0x7a>
				return 0;
  801f36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f3e:	5b                   	pop    %ebx
  801f3f:	5e                   	pop    %esi
  801f40:	5f                   	pop    %edi
  801f41:	5d                   	pop    %ebp
  801f42:	c3                   	ret    

00801f43 <devpipe_read>:
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
  801f46:	57                   	push   %edi
  801f47:	56                   	push   %esi
  801f48:	53                   	push   %ebx
  801f49:	83 ec 18             	sub    $0x18,%esp
  801f4c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f4f:	57                   	push   %edi
  801f50:	e8 0c f2 ff ff       	call   801161 <fd2data>
  801f55:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f57:	83 c4 10             	add    $0x10,%esp
  801f5a:	be 00 00 00 00       	mov    $0x0,%esi
  801f5f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f62:	75 14                	jne    801f78 <devpipe_read+0x35>
	return i;
  801f64:	8b 45 10             	mov    0x10(%ebp),%eax
  801f67:	eb 02                	jmp    801f6b <devpipe_read+0x28>
				return i;
  801f69:	89 f0                	mov    %esi,%eax
}
  801f6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f6e:	5b                   	pop    %ebx
  801f6f:	5e                   	pop    %esi
  801f70:	5f                   	pop    %edi
  801f71:	5d                   	pop    %ebp
  801f72:	c3                   	ret    
			sys_yield();
  801f73:	e8 30 ee ff ff       	call   800da8 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801f78:	8b 03                	mov    (%ebx),%eax
  801f7a:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f7d:	75 18                	jne    801f97 <devpipe_read+0x54>
			if (i > 0)
  801f7f:	85 f6                	test   %esi,%esi
  801f81:	75 e6                	jne    801f69 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801f83:	89 da                	mov    %ebx,%edx
  801f85:	89 f8                	mov    %edi,%eax
  801f87:	e8 d0 fe ff ff       	call   801e5c <_pipeisclosed>
  801f8c:	85 c0                	test   %eax,%eax
  801f8e:	74 e3                	je     801f73 <devpipe_read+0x30>
				return 0;
  801f90:	b8 00 00 00 00       	mov    $0x0,%eax
  801f95:	eb d4                	jmp    801f6b <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f97:	99                   	cltd   
  801f98:	c1 ea 1b             	shr    $0x1b,%edx
  801f9b:	01 d0                	add    %edx,%eax
  801f9d:	83 e0 1f             	and    $0x1f,%eax
  801fa0:	29 d0                	sub    %edx,%eax
  801fa2:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801fa7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801faa:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801fad:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801fb0:	83 c6 01             	add    $0x1,%esi
  801fb3:	eb aa                	jmp    801f5f <devpipe_read+0x1c>

00801fb5 <pipe>:
{
  801fb5:	55                   	push   %ebp
  801fb6:	89 e5                	mov    %esp,%ebp
  801fb8:	56                   	push   %esi
  801fb9:	53                   	push   %ebx
  801fba:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801fbd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fc0:	50                   	push   %eax
  801fc1:	e8 b2 f1 ff ff       	call   801178 <fd_alloc>
  801fc6:	89 c3                	mov    %eax,%ebx
  801fc8:	83 c4 10             	add    $0x10,%esp
  801fcb:	85 c0                	test   %eax,%eax
  801fcd:	0f 88 23 01 00 00    	js     8020f6 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fd3:	83 ec 04             	sub    $0x4,%esp
  801fd6:	68 07 04 00 00       	push   $0x407
  801fdb:	ff 75 f4             	pushl  -0xc(%ebp)
  801fde:	6a 00                	push   $0x0
  801fe0:	e8 e2 ed ff ff       	call   800dc7 <sys_page_alloc>
  801fe5:	89 c3                	mov    %eax,%ebx
  801fe7:	83 c4 10             	add    $0x10,%esp
  801fea:	85 c0                	test   %eax,%eax
  801fec:	0f 88 04 01 00 00    	js     8020f6 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ff2:	83 ec 0c             	sub    $0xc,%esp
  801ff5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ff8:	50                   	push   %eax
  801ff9:	e8 7a f1 ff ff       	call   801178 <fd_alloc>
  801ffe:	89 c3                	mov    %eax,%ebx
  802000:	83 c4 10             	add    $0x10,%esp
  802003:	85 c0                	test   %eax,%eax
  802005:	0f 88 db 00 00 00    	js     8020e6 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80200b:	83 ec 04             	sub    $0x4,%esp
  80200e:	68 07 04 00 00       	push   $0x407
  802013:	ff 75 f0             	pushl  -0x10(%ebp)
  802016:	6a 00                	push   $0x0
  802018:	e8 aa ed ff ff       	call   800dc7 <sys_page_alloc>
  80201d:	89 c3                	mov    %eax,%ebx
  80201f:	83 c4 10             	add    $0x10,%esp
  802022:	85 c0                	test   %eax,%eax
  802024:	0f 88 bc 00 00 00    	js     8020e6 <pipe+0x131>
	va = fd2data(fd0);
  80202a:	83 ec 0c             	sub    $0xc,%esp
  80202d:	ff 75 f4             	pushl  -0xc(%ebp)
  802030:	e8 2c f1 ff ff       	call   801161 <fd2data>
  802035:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802037:	83 c4 0c             	add    $0xc,%esp
  80203a:	68 07 04 00 00       	push   $0x407
  80203f:	50                   	push   %eax
  802040:	6a 00                	push   $0x0
  802042:	e8 80 ed ff ff       	call   800dc7 <sys_page_alloc>
  802047:	89 c3                	mov    %eax,%ebx
  802049:	83 c4 10             	add    $0x10,%esp
  80204c:	85 c0                	test   %eax,%eax
  80204e:	0f 88 82 00 00 00    	js     8020d6 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802054:	83 ec 0c             	sub    $0xc,%esp
  802057:	ff 75 f0             	pushl  -0x10(%ebp)
  80205a:	e8 02 f1 ff ff       	call   801161 <fd2data>
  80205f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802066:	50                   	push   %eax
  802067:	6a 00                	push   $0x0
  802069:	56                   	push   %esi
  80206a:	6a 00                	push   $0x0
  80206c:	e8 99 ed ff ff       	call   800e0a <sys_page_map>
  802071:	89 c3                	mov    %eax,%ebx
  802073:	83 c4 20             	add    $0x20,%esp
  802076:	85 c0                	test   %eax,%eax
  802078:	78 4e                	js     8020c8 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80207a:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80207f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802082:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802084:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802087:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80208e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802091:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802093:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802096:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80209d:	83 ec 0c             	sub    $0xc,%esp
  8020a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8020a3:	e8 a9 f0 ff ff       	call   801151 <fd2num>
  8020a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020ab:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8020ad:	83 c4 04             	add    $0x4,%esp
  8020b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8020b3:	e8 99 f0 ff ff       	call   801151 <fd2num>
  8020b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020bb:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8020be:	83 c4 10             	add    $0x10,%esp
  8020c1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020c6:	eb 2e                	jmp    8020f6 <pipe+0x141>
	sys_page_unmap(0, va);
  8020c8:	83 ec 08             	sub    $0x8,%esp
  8020cb:	56                   	push   %esi
  8020cc:	6a 00                	push   $0x0
  8020ce:	e8 79 ed ff ff       	call   800e4c <sys_page_unmap>
  8020d3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8020d6:	83 ec 08             	sub    $0x8,%esp
  8020d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8020dc:	6a 00                	push   $0x0
  8020de:	e8 69 ed ff ff       	call   800e4c <sys_page_unmap>
  8020e3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8020e6:	83 ec 08             	sub    $0x8,%esp
  8020e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8020ec:	6a 00                	push   $0x0
  8020ee:	e8 59 ed ff ff       	call   800e4c <sys_page_unmap>
  8020f3:	83 c4 10             	add    $0x10,%esp
}
  8020f6:	89 d8                	mov    %ebx,%eax
  8020f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020fb:	5b                   	pop    %ebx
  8020fc:	5e                   	pop    %esi
  8020fd:	5d                   	pop    %ebp
  8020fe:	c3                   	ret    

008020ff <pipeisclosed>:
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
  802102:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802105:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802108:	50                   	push   %eax
  802109:	ff 75 08             	pushl  0x8(%ebp)
  80210c:	e8 b9 f0 ff ff       	call   8011ca <fd_lookup>
  802111:	83 c4 10             	add    $0x10,%esp
  802114:	85 c0                	test   %eax,%eax
  802116:	78 18                	js     802130 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802118:	83 ec 0c             	sub    $0xc,%esp
  80211b:	ff 75 f4             	pushl  -0xc(%ebp)
  80211e:	e8 3e f0 ff ff       	call   801161 <fd2data>
	return _pipeisclosed(fd, p);
  802123:	89 c2                	mov    %eax,%edx
  802125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802128:	e8 2f fd ff ff       	call   801e5c <_pipeisclosed>
  80212d:	83 c4 10             	add    $0x10,%esp
}
  802130:	c9                   	leave  
  802131:	c3                   	ret    

00802132 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802132:	b8 00 00 00 00       	mov    $0x0,%eax
  802137:	c3                   	ret    

00802138 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
  80213b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80213e:	68 0b 2d 80 00       	push   $0x802d0b
  802143:	ff 75 0c             	pushl  0xc(%ebp)
  802146:	e8 8a e8 ff ff       	call   8009d5 <strcpy>
	return 0;
}
  80214b:	b8 00 00 00 00       	mov    $0x0,%eax
  802150:	c9                   	leave  
  802151:	c3                   	ret    

00802152 <devcons_write>:
{
  802152:	55                   	push   %ebp
  802153:	89 e5                	mov    %esp,%ebp
  802155:	57                   	push   %edi
  802156:	56                   	push   %esi
  802157:	53                   	push   %ebx
  802158:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80215e:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802163:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802169:	3b 75 10             	cmp    0x10(%ebp),%esi
  80216c:	73 31                	jae    80219f <devcons_write+0x4d>
		m = n - tot;
  80216e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802171:	29 f3                	sub    %esi,%ebx
  802173:	83 fb 7f             	cmp    $0x7f,%ebx
  802176:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80217b:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80217e:	83 ec 04             	sub    $0x4,%esp
  802181:	53                   	push   %ebx
  802182:	89 f0                	mov    %esi,%eax
  802184:	03 45 0c             	add    0xc(%ebp),%eax
  802187:	50                   	push   %eax
  802188:	57                   	push   %edi
  802189:	e8 d5 e9 ff ff       	call   800b63 <memmove>
		sys_cputs(buf, m);
  80218e:	83 c4 08             	add    $0x8,%esp
  802191:	53                   	push   %ebx
  802192:	57                   	push   %edi
  802193:	e8 73 eb ff ff       	call   800d0b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802198:	01 de                	add    %ebx,%esi
  80219a:	83 c4 10             	add    $0x10,%esp
  80219d:	eb ca                	jmp    802169 <devcons_write+0x17>
}
  80219f:	89 f0                	mov    %esi,%eax
  8021a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021a4:	5b                   	pop    %ebx
  8021a5:	5e                   	pop    %esi
  8021a6:	5f                   	pop    %edi
  8021a7:	5d                   	pop    %ebp
  8021a8:	c3                   	ret    

008021a9 <devcons_read>:
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
  8021ac:	83 ec 08             	sub    $0x8,%esp
  8021af:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8021b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021b8:	74 21                	je     8021db <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8021ba:	e8 6a eb ff ff       	call   800d29 <sys_cgetc>
  8021bf:	85 c0                	test   %eax,%eax
  8021c1:	75 07                	jne    8021ca <devcons_read+0x21>
		sys_yield();
  8021c3:	e8 e0 eb ff ff       	call   800da8 <sys_yield>
  8021c8:	eb f0                	jmp    8021ba <devcons_read+0x11>
	if (c < 0)
  8021ca:	78 0f                	js     8021db <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8021cc:	83 f8 04             	cmp    $0x4,%eax
  8021cf:	74 0c                	je     8021dd <devcons_read+0x34>
	*(char*)vbuf = c;
  8021d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d4:	88 02                	mov    %al,(%edx)
	return 1;
  8021d6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8021db:	c9                   	leave  
  8021dc:	c3                   	ret    
		return 0;
  8021dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e2:	eb f7                	jmp    8021db <devcons_read+0x32>

008021e4 <cputchar>:
{
  8021e4:	55                   	push   %ebp
  8021e5:	89 e5                	mov    %esp,%ebp
  8021e7:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8021ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ed:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8021f0:	6a 01                	push   $0x1
  8021f2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021f5:	50                   	push   %eax
  8021f6:	e8 10 eb ff ff       	call   800d0b <sys_cputs>
}
  8021fb:	83 c4 10             	add    $0x10,%esp
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <getchar>:
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802206:	6a 01                	push   $0x1
  802208:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80220b:	50                   	push   %eax
  80220c:	6a 00                	push   $0x0
  80220e:	e8 27 f2 ff ff       	call   80143a <read>
	if (r < 0)
  802213:	83 c4 10             	add    $0x10,%esp
  802216:	85 c0                	test   %eax,%eax
  802218:	78 06                	js     802220 <getchar+0x20>
	if (r < 1)
  80221a:	74 06                	je     802222 <getchar+0x22>
	return c;
  80221c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802220:	c9                   	leave  
  802221:	c3                   	ret    
		return -E_EOF;
  802222:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802227:	eb f7                	jmp    802220 <getchar+0x20>

00802229 <iscons>:
{
  802229:	55                   	push   %ebp
  80222a:	89 e5                	mov    %esp,%ebp
  80222c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80222f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802232:	50                   	push   %eax
  802233:	ff 75 08             	pushl  0x8(%ebp)
  802236:	e8 8f ef ff ff       	call   8011ca <fd_lookup>
  80223b:	83 c4 10             	add    $0x10,%esp
  80223e:	85 c0                	test   %eax,%eax
  802240:	78 11                	js     802253 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802245:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80224b:	39 10                	cmp    %edx,(%eax)
  80224d:	0f 94 c0             	sete   %al
  802250:	0f b6 c0             	movzbl %al,%eax
}
  802253:	c9                   	leave  
  802254:	c3                   	ret    

00802255 <opencons>:
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
  802258:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80225b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80225e:	50                   	push   %eax
  80225f:	e8 14 ef ff ff       	call   801178 <fd_alloc>
  802264:	83 c4 10             	add    $0x10,%esp
  802267:	85 c0                	test   %eax,%eax
  802269:	78 3a                	js     8022a5 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80226b:	83 ec 04             	sub    $0x4,%esp
  80226e:	68 07 04 00 00       	push   $0x407
  802273:	ff 75 f4             	pushl  -0xc(%ebp)
  802276:	6a 00                	push   $0x0
  802278:	e8 4a eb ff ff       	call   800dc7 <sys_page_alloc>
  80227d:	83 c4 10             	add    $0x10,%esp
  802280:	85 c0                	test   %eax,%eax
  802282:	78 21                	js     8022a5 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802287:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80228d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80228f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802292:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802299:	83 ec 0c             	sub    $0xc,%esp
  80229c:	50                   	push   %eax
  80229d:	e8 af ee ff ff       	call   801151 <fd2num>
  8022a2:	83 c4 10             	add    $0x10,%esp
}
  8022a5:	c9                   	leave  
  8022a6:	c3                   	ret    

008022a7 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022a7:	55                   	push   %ebp
  8022a8:	89 e5                	mov    %esp,%ebp
  8022aa:	56                   	push   %esi
  8022ab:	53                   	push   %ebx
  8022ac:	8b 75 08             	mov    0x8(%ebp),%esi
  8022af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8022b5:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8022b7:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022bc:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8022bf:	83 ec 0c             	sub    $0xc,%esp
  8022c2:	50                   	push   %eax
  8022c3:	e8 af ec ff ff       	call   800f77 <sys_ipc_recv>
	if(ret < 0){
  8022c8:	83 c4 10             	add    $0x10,%esp
  8022cb:	85 c0                	test   %eax,%eax
  8022cd:	78 2b                	js     8022fa <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8022cf:	85 f6                	test   %esi,%esi
  8022d1:	74 0a                	je     8022dd <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8022d3:	a1 08 40 80 00       	mov    0x804008,%eax
  8022d8:	8b 40 78             	mov    0x78(%eax),%eax
  8022db:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8022dd:	85 db                	test   %ebx,%ebx
  8022df:	74 0a                	je     8022eb <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8022e1:	a1 08 40 80 00       	mov    0x804008,%eax
  8022e6:	8b 40 7c             	mov    0x7c(%eax),%eax
  8022e9:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8022eb:	a1 08 40 80 00       	mov    0x804008,%eax
  8022f0:	8b 40 74             	mov    0x74(%eax),%eax
}
  8022f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022f6:	5b                   	pop    %ebx
  8022f7:	5e                   	pop    %esi
  8022f8:	5d                   	pop    %ebp
  8022f9:	c3                   	ret    
		if(from_env_store)
  8022fa:	85 f6                	test   %esi,%esi
  8022fc:	74 06                	je     802304 <ipc_recv+0x5d>
			*from_env_store = 0;
  8022fe:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802304:	85 db                	test   %ebx,%ebx
  802306:	74 eb                	je     8022f3 <ipc_recv+0x4c>
			*perm_store = 0;
  802308:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80230e:	eb e3                	jmp    8022f3 <ipc_recv+0x4c>

00802310 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
  802313:	57                   	push   %edi
  802314:	56                   	push   %esi
  802315:	53                   	push   %ebx
  802316:	83 ec 0c             	sub    $0xc,%esp
  802319:	8b 7d 08             	mov    0x8(%ebp),%edi
  80231c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80231f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802322:	85 db                	test   %ebx,%ebx
  802324:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802329:	0f 44 d8             	cmove  %eax,%ebx
  80232c:	eb 05                	jmp    802333 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80232e:	e8 75 ea ff ff       	call   800da8 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802333:	ff 75 14             	pushl  0x14(%ebp)
  802336:	53                   	push   %ebx
  802337:	56                   	push   %esi
  802338:	57                   	push   %edi
  802339:	e8 16 ec ff ff       	call   800f54 <sys_ipc_try_send>
  80233e:	83 c4 10             	add    $0x10,%esp
  802341:	85 c0                	test   %eax,%eax
  802343:	74 1b                	je     802360 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802345:	79 e7                	jns    80232e <ipc_send+0x1e>
  802347:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80234a:	74 e2                	je     80232e <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80234c:	83 ec 04             	sub    $0x4,%esp
  80234f:	68 17 2d 80 00       	push   $0x802d17
  802354:	6a 46                	push   $0x46
  802356:	68 2c 2d 80 00       	push   $0x802d2c
  80235b:	e8 20 de ff ff       	call   800180 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802360:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802363:	5b                   	pop    %ebx
  802364:	5e                   	pop    %esi
  802365:	5f                   	pop    %edi
  802366:	5d                   	pop    %ebp
  802367:	c3                   	ret    

00802368 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
  80236b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80236e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802373:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802379:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80237f:	8b 52 50             	mov    0x50(%edx),%edx
  802382:	39 ca                	cmp    %ecx,%edx
  802384:	74 11                	je     802397 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802386:	83 c0 01             	add    $0x1,%eax
  802389:	3d 00 04 00 00       	cmp    $0x400,%eax
  80238e:	75 e3                	jne    802373 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802390:	b8 00 00 00 00       	mov    $0x0,%eax
  802395:	eb 0e                	jmp    8023a5 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802397:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80239d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8023a2:	8b 40 48             	mov    0x48(%eax),%eax
}
  8023a5:	5d                   	pop    %ebp
  8023a6:	c3                   	ret    

008023a7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023a7:	55                   	push   %ebp
  8023a8:	89 e5                	mov    %esp,%ebp
  8023aa:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023ad:	89 d0                	mov    %edx,%eax
  8023af:	c1 e8 16             	shr    $0x16,%eax
  8023b2:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023b9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8023be:	f6 c1 01             	test   $0x1,%cl
  8023c1:	74 1d                	je     8023e0 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8023c3:	c1 ea 0c             	shr    $0xc,%edx
  8023c6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023cd:	f6 c2 01             	test   $0x1,%dl
  8023d0:	74 0e                	je     8023e0 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023d2:	c1 ea 0c             	shr    $0xc,%edx
  8023d5:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023dc:	ef 
  8023dd:	0f b7 c0             	movzwl %ax,%eax
}
  8023e0:	5d                   	pop    %ebp
  8023e1:	c3                   	ret    
  8023e2:	66 90                	xchg   %ax,%ax
  8023e4:	66 90                	xchg   %ax,%ax
  8023e6:	66 90                	xchg   %ax,%ax
  8023e8:	66 90                	xchg   %ax,%ax
  8023ea:	66 90                	xchg   %ax,%ax
  8023ec:	66 90                	xchg   %ax,%ax
  8023ee:	66 90                	xchg   %ax,%ax

008023f0 <__udivdi3>:
  8023f0:	55                   	push   %ebp
  8023f1:	57                   	push   %edi
  8023f2:	56                   	push   %esi
  8023f3:	53                   	push   %ebx
  8023f4:	83 ec 1c             	sub    $0x1c,%esp
  8023f7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8023fb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8023ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  802403:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802407:	85 d2                	test   %edx,%edx
  802409:	75 4d                	jne    802458 <__udivdi3+0x68>
  80240b:	39 f3                	cmp    %esi,%ebx
  80240d:	76 19                	jbe    802428 <__udivdi3+0x38>
  80240f:	31 ff                	xor    %edi,%edi
  802411:	89 e8                	mov    %ebp,%eax
  802413:	89 f2                	mov    %esi,%edx
  802415:	f7 f3                	div    %ebx
  802417:	89 fa                	mov    %edi,%edx
  802419:	83 c4 1c             	add    $0x1c,%esp
  80241c:	5b                   	pop    %ebx
  80241d:	5e                   	pop    %esi
  80241e:	5f                   	pop    %edi
  80241f:	5d                   	pop    %ebp
  802420:	c3                   	ret    
  802421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802428:	89 d9                	mov    %ebx,%ecx
  80242a:	85 db                	test   %ebx,%ebx
  80242c:	75 0b                	jne    802439 <__udivdi3+0x49>
  80242e:	b8 01 00 00 00       	mov    $0x1,%eax
  802433:	31 d2                	xor    %edx,%edx
  802435:	f7 f3                	div    %ebx
  802437:	89 c1                	mov    %eax,%ecx
  802439:	31 d2                	xor    %edx,%edx
  80243b:	89 f0                	mov    %esi,%eax
  80243d:	f7 f1                	div    %ecx
  80243f:	89 c6                	mov    %eax,%esi
  802441:	89 e8                	mov    %ebp,%eax
  802443:	89 f7                	mov    %esi,%edi
  802445:	f7 f1                	div    %ecx
  802447:	89 fa                	mov    %edi,%edx
  802449:	83 c4 1c             	add    $0x1c,%esp
  80244c:	5b                   	pop    %ebx
  80244d:	5e                   	pop    %esi
  80244e:	5f                   	pop    %edi
  80244f:	5d                   	pop    %ebp
  802450:	c3                   	ret    
  802451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802458:	39 f2                	cmp    %esi,%edx
  80245a:	77 1c                	ja     802478 <__udivdi3+0x88>
  80245c:	0f bd fa             	bsr    %edx,%edi
  80245f:	83 f7 1f             	xor    $0x1f,%edi
  802462:	75 2c                	jne    802490 <__udivdi3+0xa0>
  802464:	39 f2                	cmp    %esi,%edx
  802466:	72 06                	jb     80246e <__udivdi3+0x7e>
  802468:	31 c0                	xor    %eax,%eax
  80246a:	39 eb                	cmp    %ebp,%ebx
  80246c:	77 a9                	ja     802417 <__udivdi3+0x27>
  80246e:	b8 01 00 00 00       	mov    $0x1,%eax
  802473:	eb a2                	jmp    802417 <__udivdi3+0x27>
  802475:	8d 76 00             	lea    0x0(%esi),%esi
  802478:	31 ff                	xor    %edi,%edi
  80247a:	31 c0                	xor    %eax,%eax
  80247c:	89 fa                	mov    %edi,%edx
  80247e:	83 c4 1c             	add    $0x1c,%esp
  802481:	5b                   	pop    %ebx
  802482:	5e                   	pop    %esi
  802483:	5f                   	pop    %edi
  802484:	5d                   	pop    %ebp
  802485:	c3                   	ret    
  802486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80248d:	8d 76 00             	lea    0x0(%esi),%esi
  802490:	89 f9                	mov    %edi,%ecx
  802492:	b8 20 00 00 00       	mov    $0x20,%eax
  802497:	29 f8                	sub    %edi,%eax
  802499:	d3 e2                	shl    %cl,%edx
  80249b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80249f:	89 c1                	mov    %eax,%ecx
  8024a1:	89 da                	mov    %ebx,%edx
  8024a3:	d3 ea                	shr    %cl,%edx
  8024a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024a9:	09 d1                	or     %edx,%ecx
  8024ab:	89 f2                	mov    %esi,%edx
  8024ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024b1:	89 f9                	mov    %edi,%ecx
  8024b3:	d3 e3                	shl    %cl,%ebx
  8024b5:	89 c1                	mov    %eax,%ecx
  8024b7:	d3 ea                	shr    %cl,%edx
  8024b9:	89 f9                	mov    %edi,%ecx
  8024bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8024bf:	89 eb                	mov    %ebp,%ebx
  8024c1:	d3 e6                	shl    %cl,%esi
  8024c3:	89 c1                	mov    %eax,%ecx
  8024c5:	d3 eb                	shr    %cl,%ebx
  8024c7:	09 de                	or     %ebx,%esi
  8024c9:	89 f0                	mov    %esi,%eax
  8024cb:	f7 74 24 08          	divl   0x8(%esp)
  8024cf:	89 d6                	mov    %edx,%esi
  8024d1:	89 c3                	mov    %eax,%ebx
  8024d3:	f7 64 24 0c          	mull   0xc(%esp)
  8024d7:	39 d6                	cmp    %edx,%esi
  8024d9:	72 15                	jb     8024f0 <__udivdi3+0x100>
  8024db:	89 f9                	mov    %edi,%ecx
  8024dd:	d3 e5                	shl    %cl,%ebp
  8024df:	39 c5                	cmp    %eax,%ebp
  8024e1:	73 04                	jae    8024e7 <__udivdi3+0xf7>
  8024e3:	39 d6                	cmp    %edx,%esi
  8024e5:	74 09                	je     8024f0 <__udivdi3+0x100>
  8024e7:	89 d8                	mov    %ebx,%eax
  8024e9:	31 ff                	xor    %edi,%edi
  8024eb:	e9 27 ff ff ff       	jmp    802417 <__udivdi3+0x27>
  8024f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8024f3:	31 ff                	xor    %edi,%edi
  8024f5:	e9 1d ff ff ff       	jmp    802417 <__udivdi3+0x27>
  8024fa:	66 90                	xchg   %ax,%ax
  8024fc:	66 90                	xchg   %ax,%ax
  8024fe:	66 90                	xchg   %ax,%ax

00802500 <__umoddi3>:
  802500:	55                   	push   %ebp
  802501:	57                   	push   %edi
  802502:	56                   	push   %esi
  802503:	53                   	push   %ebx
  802504:	83 ec 1c             	sub    $0x1c,%esp
  802507:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80250b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80250f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802513:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802517:	89 da                	mov    %ebx,%edx
  802519:	85 c0                	test   %eax,%eax
  80251b:	75 43                	jne    802560 <__umoddi3+0x60>
  80251d:	39 df                	cmp    %ebx,%edi
  80251f:	76 17                	jbe    802538 <__umoddi3+0x38>
  802521:	89 f0                	mov    %esi,%eax
  802523:	f7 f7                	div    %edi
  802525:	89 d0                	mov    %edx,%eax
  802527:	31 d2                	xor    %edx,%edx
  802529:	83 c4 1c             	add    $0x1c,%esp
  80252c:	5b                   	pop    %ebx
  80252d:	5e                   	pop    %esi
  80252e:	5f                   	pop    %edi
  80252f:	5d                   	pop    %ebp
  802530:	c3                   	ret    
  802531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802538:	89 fd                	mov    %edi,%ebp
  80253a:	85 ff                	test   %edi,%edi
  80253c:	75 0b                	jne    802549 <__umoddi3+0x49>
  80253e:	b8 01 00 00 00       	mov    $0x1,%eax
  802543:	31 d2                	xor    %edx,%edx
  802545:	f7 f7                	div    %edi
  802547:	89 c5                	mov    %eax,%ebp
  802549:	89 d8                	mov    %ebx,%eax
  80254b:	31 d2                	xor    %edx,%edx
  80254d:	f7 f5                	div    %ebp
  80254f:	89 f0                	mov    %esi,%eax
  802551:	f7 f5                	div    %ebp
  802553:	89 d0                	mov    %edx,%eax
  802555:	eb d0                	jmp    802527 <__umoddi3+0x27>
  802557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80255e:	66 90                	xchg   %ax,%ax
  802560:	89 f1                	mov    %esi,%ecx
  802562:	39 d8                	cmp    %ebx,%eax
  802564:	76 0a                	jbe    802570 <__umoddi3+0x70>
  802566:	89 f0                	mov    %esi,%eax
  802568:	83 c4 1c             	add    $0x1c,%esp
  80256b:	5b                   	pop    %ebx
  80256c:	5e                   	pop    %esi
  80256d:	5f                   	pop    %edi
  80256e:	5d                   	pop    %ebp
  80256f:	c3                   	ret    
  802570:	0f bd e8             	bsr    %eax,%ebp
  802573:	83 f5 1f             	xor    $0x1f,%ebp
  802576:	75 20                	jne    802598 <__umoddi3+0x98>
  802578:	39 d8                	cmp    %ebx,%eax
  80257a:	0f 82 b0 00 00 00    	jb     802630 <__umoddi3+0x130>
  802580:	39 f7                	cmp    %esi,%edi
  802582:	0f 86 a8 00 00 00    	jbe    802630 <__umoddi3+0x130>
  802588:	89 c8                	mov    %ecx,%eax
  80258a:	83 c4 1c             	add    $0x1c,%esp
  80258d:	5b                   	pop    %ebx
  80258e:	5e                   	pop    %esi
  80258f:	5f                   	pop    %edi
  802590:	5d                   	pop    %ebp
  802591:	c3                   	ret    
  802592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802598:	89 e9                	mov    %ebp,%ecx
  80259a:	ba 20 00 00 00       	mov    $0x20,%edx
  80259f:	29 ea                	sub    %ebp,%edx
  8025a1:	d3 e0                	shl    %cl,%eax
  8025a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025a7:	89 d1                	mov    %edx,%ecx
  8025a9:	89 f8                	mov    %edi,%eax
  8025ab:	d3 e8                	shr    %cl,%eax
  8025ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025b5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025b9:	09 c1                	or     %eax,%ecx
  8025bb:	89 d8                	mov    %ebx,%eax
  8025bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025c1:	89 e9                	mov    %ebp,%ecx
  8025c3:	d3 e7                	shl    %cl,%edi
  8025c5:	89 d1                	mov    %edx,%ecx
  8025c7:	d3 e8                	shr    %cl,%eax
  8025c9:	89 e9                	mov    %ebp,%ecx
  8025cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025cf:	d3 e3                	shl    %cl,%ebx
  8025d1:	89 c7                	mov    %eax,%edi
  8025d3:	89 d1                	mov    %edx,%ecx
  8025d5:	89 f0                	mov    %esi,%eax
  8025d7:	d3 e8                	shr    %cl,%eax
  8025d9:	89 e9                	mov    %ebp,%ecx
  8025db:	89 fa                	mov    %edi,%edx
  8025dd:	d3 e6                	shl    %cl,%esi
  8025df:	09 d8                	or     %ebx,%eax
  8025e1:	f7 74 24 08          	divl   0x8(%esp)
  8025e5:	89 d1                	mov    %edx,%ecx
  8025e7:	89 f3                	mov    %esi,%ebx
  8025e9:	f7 64 24 0c          	mull   0xc(%esp)
  8025ed:	89 c6                	mov    %eax,%esi
  8025ef:	89 d7                	mov    %edx,%edi
  8025f1:	39 d1                	cmp    %edx,%ecx
  8025f3:	72 06                	jb     8025fb <__umoddi3+0xfb>
  8025f5:	75 10                	jne    802607 <__umoddi3+0x107>
  8025f7:	39 c3                	cmp    %eax,%ebx
  8025f9:	73 0c                	jae    802607 <__umoddi3+0x107>
  8025fb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8025ff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802603:	89 d7                	mov    %edx,%edi
  802605:	89 c6                	mov    %eax,%esi
  802607:	89 ca                	mov    %ecx,%edx
  802609:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80260e:	29 f3                	sub    %esi,%ebx
  802610:	19 fa                	sbb    %edi,%edx
  802612:	89 d0                	mov    %edx,%eax
  802614:	d3 e0                	shl    %cl,%eax
  802616:	89 e9                	mov    %ebp,%ecx
  802618:	d3 eb                	shr    %cl,%ebx
  80261a:	d3 ea                	shr    %cl,%edx
  80261c:	09 d8                	or     %ebx,%eax
  80261e:	83 c4 1c             	add    $0x1c,%esp
  802621:	5b                   	pop    %ebx
  802622:	5e                   	pop    %esi
  802623:	5f                   	pop    %edi
  802624:	5d                   	pop    %ebp
  802625:	c3                   	ret    
  802626:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80262d:	8d 76 00             	lea    0x0(%esi),%esi
  802630:	89 da                	mov    %ebx,%edx
  802632:	29 fe                	sub    %edi,%esi
  802634:	19 c2                	sbb    %eax,%edx
  802636:	89 f1                	mov    %esi,%ecx
  802638:	89 c8                	mov    %ecx,%eax
  80263a:	e9 4b ff ff ff       	jmp    80258a <__umoddi3+0x8a>
