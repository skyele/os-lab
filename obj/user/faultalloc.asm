
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
  800040:	68 20 26 80 00       	push   $0x802620
  800045:	e8 32 02 00 00       	call   80027c <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004a:	83 c4 0c             	add    $0xc,%esp
  80004d:	6a 07                	push   $0x7
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	50                   	push   %eax
  800057:	6a 00                	push   $0x0
  800059:	e8 6f 0d 00 00       	call   800dcd <sys_page_alloc>
  80005e:	83 c4 10             	add    $0x10,%esp
  800061:	85 c0                	test   %eax,%eax
  800063:	78 16                	js     80007b <handler+0x48>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800065:	53                   	push   %ebx
  800066:	68 68 26 80 00       	push   $0x802668
  80006b:	6a 64                	push   $0x64
  80006d:	53                   	push   %ebx
  80006e:	e8 15 09 00 00       	call   800988 <snprintf>
}
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800079:	c9                   	leave  
  80007a:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007b:	83 ec 0c             	sub    $0xc,%esp
  80007e:	50                   	push   %eax
  80007f:	53                   	push   %ebx
  800080:	68 3c 26 80 00       	push   $0x80263c
  800085:	6a 0e                	push   $0xe
  800087:	68 2a 26 80 00       	push   $0x80262a
  80008c:	e8 f5 00 00 00       	call   800186 <_panic>

00800091 <umain>:

void
umain(int argc, char **argv)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800097:	68 33 00 80 00       	push   $0x800033
  80009c:	e8 01 10 00 00       	call   8010a2 <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	68 ef be ad de       	push   $0xdeadbeef
  8000a9:	68 a7 26 80 00       	push   $0x8026a7
  8000ae:	e8 c9 01 00 00       	call   80027c <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000b3:	83 c4 08             	add    $0x8,%esp
  8000b6:	68 fe bf fe ca       	push   $0xcafebffe
  8000bb:	68 a7 26 80 00       	push   $0x8026a7
  8000c0:	e8 b7 01 00 00       	call   80027c <cprintf>
}
  8000c5:	83 c4 10             	add    $0x10,%esp
  8000c8:	c9                   	leave  
  8000c9:	c3                   	ret    

008000ca <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8000ca:	55                   	push   %ebp
  8000cb:	89 e5                	mov    %esp,%ebp
  8000cd:	57                   	push   %edi
  8000ce:	56                   	push   %esi
  8000cf:	53                   	push   %ebx
  8000d0:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8000d3:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  8000da:	00 00 00 
	envid_t find = sys_getenvid();
  8000dd:	e8 ad 0c 00 00       	call   800d8f <sys_getenvid>
  8000e2:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  8000e8:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8000ed:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8000f2:	bf 01 00 00 00       	mov    $0x1,%edi
  8000f7:	eb 0b                	jmp    800104 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8000f9:	83 c2 01             	add    $0x1,%edx
  8000fc:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800102:	74 21                	je     800125 <libmain+0x5b>
		if(envs[i].env_id == find)
  800104:	89 d1                	mov    %edx,%ecx
  800106:	c1 e1 07             	shl    $0x7,%ecx
  800109:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80010f:	8b 49 48             	mov    0x48(%ecx),%ecx
  800112:	39 c1                	cmp    %eax,%ecx
  800114:	75 e3                	jne    8000f9 <libmain+0x2f>
  800116:	89 d3                	mov    %edx,%ebx
  800118:	c1 e3 07             	shl    $0x7,%ebx
  80011b:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800121:	89 fe                	mov    %edi,%esi
  800123:	eb d4                	jmp    8000f9 <libmain+0x2f>
  800125:	89 f0                	mov    %esi,%eax
  800127:	84 c0                	test   %al,%al
  800129:	74 06                	je     800131 <libmain+0x67>
  80012b:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800131:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800135:	7e 0a                	jle    800141 <libmain+0x77>
		binaryname = argv[0];
  800137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80013a:	8b 00                	mov    (%eax),%eax
  80013c:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("call umain!\n");
  800141:	83 ec 0c             	sub    $0xc,%esp
  800144:	68 89 26 80 00       	push   $0x802689
  800149:	e8 2e 01 00 00       	call   80027c <cprintf>
	// call user main routine
	umain(argc, argv);
  80014e:	83 c4 08             	add    $0x8,%esp
  800151:	ff 75 0c             	pushl  0xc(%ebp)
  800154:	ff 75 08             	pushl  0x8(%ebp)
  800157:	e8 35 ff ff ff       	call   800091 <umain>

	// exit gracefully
	exit();
  80015c:	e8 0b 00 00 00       	call   80016c <exit>
}
  800161:	83 c4 10             	add    $0x10,%esp
  800164:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800167:	5b                   	pop    %ebx
  800168:	5e                   	pop    %esi
  800169:	5f                   	pop    %edi
  80016a:	5d                   	pop    %ebp
  80016b:	c3                   	ret    

0080016c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80016c:	55                   	push   %ebp
  80016d:	89 e5                	mov    %esp,%ebp
  80016f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800172:	e8 98 11 00 00       	call   80130f <close_all>
	sys_env_destroy(0);
  800177:	83 ec 0c             	sub    $0xc,%esp
  80017a:	6a 00                	push   $0x0
  80017c:	e8 cd 0b 00 00       	call   800d4e <sys_env_destroy>
}
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	c9                   	leave  
  800185:	c3                   	ret    

00800186 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800186:	55                   	push   %ebp
  800187:	89 e5                	mov    %esp,%ebp
  800189:	56                   	push   %esi
  80018a:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80018b:	a1 08 40 80 00       	mov    0x804008,%eax
  800190:	8b 40 48             	mov    0x48(%eax),%eax
  800193:	83 ec 04             	sub    $0x4,%esp
  800196:	68 d0 26 80 00       	push   $0x8026d0
  80019b:	50                   	push   %eax
  80019c:	68 a0 26 80 00       	push   $0x8026a0
  8001a1:	e8 d6 00 00 00       	call   80027c <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8001a6:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001a9:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8001af:	e8 db 0b 00 00       	call   800d8f <sys_getenvid>
  8001b4:	83 c4 04             	add    $0x4,%esp
  8001b7:	ff 75 0c             	pushl  0xc(%ebp)
  8001ba:	ff 75 08             	pushl  0x8(%ebp)
  8001bd:	56                   	push   %esi
  8001be:	50                   	push   %eax
  8001bf:	68 ac 26 80 00       	push   $0x8026ac
  8001c4:	e8 b3 00 00 00       	call   80027c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001c9:	83 c4 18             	add    $0x18,%esp
  8001cc:	53                   	push   %ebx
  8001cd:	ff 75 10             	pushl  0x10(%ebp)
  8001d0:	e8 56 00 00 00       	call   80022b <vcprintf>
	cprintf("\n");
  8001d5:	c7 04 24 94 26 80 00 	movl   $0x802694,(%esp)
  8001dc:	e8 9b 00 00 00       	call   80027c <cprintf>
  8001e1:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001e4:	cc                   	int3   
  8001e5:	eb fd                	jmp    8001e4 <_panic+0x5e>

008001e7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001e7:	55                   	push   %ebp
  8001e8:	89 e5                	mov    %esp,%ebp
  8001ea:	53                   	push   %ebx
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001f1:	8b 13                	mov    (%ebx),%edx
  8001f3:	8d 42 01             	lea    0x1(%edx),%eax
  8001f6:	89 03                	mov    %eax,(%ebx)
  8001f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001fb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001ff:	3d ff 00 00 00       	cmp    $0xff,%eax
  800204:	74 09                	je     80020f <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800206:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80020a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80020d:	c9                   	leave  
  80020e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80020f:	83 ec 08             	sub    $0x8,%esp
  800212:	68 ff 00 00 00       	push   $0xff
  800217:	8d 43 08             	lea    0x8(%ebx),%eax
  80021a:	50                   	push   %eax
  80021b:	e8 f1 0a 00 00       	call   800d11 <sys_cputs>
		b->idx = 0;
  800220:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800226:	83 c4 10             	add    $0x10,%esp
  800229:	eb db                	jmp    800206 <putch+0x1f>

0080022b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80022b:	55                   	push   %ebp
  80022c:	89 e5                	mov    %esp,%ebp
  80022e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800234:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80023b:	00 00 00 
	b.cnt = 0;
  80023e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800245:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800248:	ff 75 0c             	pushl  0xc(%ebp)
  80024b:	ff 75 08             	pushl  0x8(%ebp)
  80024e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800254:	50                   	push   %eax
  800255:	68 e7 01 80 00       	push   $0x8001e7
  80025a:	e8 4a 01 00 00       	call   8003a9 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80025f:	83 c4 08             	add    $0x8,%esp
  800262:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800268:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80026e:	50                   	push   %eax
  80026f:	e8 9d 0a 00 00       	call   800d11 <sys_cputs>

	return b.cnt;
}
  800274:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80027a:	c9                   	leave  
  80027b:	c3                   	ret    

0080027c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80027c:	55                   	push   %ebp
  80027d:	89 e5                	mov    %esp,%ebp
  80027f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800282:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800285:	50                   	push   %eax
  800286:	ff 75 08             	pushl  0x8(%ebp)
  800289:	e8 9d ff ff ff       	call   80022b <vcprintf>
	va_end(ap);

	return cnt;
}
  80028e:	c9                   	leave  
  80028f:	c3                   	ret    

00800290 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	57                   	push   %edi
  800294:	56                   	push   %esi
  800295:	53                   	push   %ebx
  800296:	83 ec 1c             	sub    $0x1c,%esp
  800299:	89 c6                	mov    %eax,%esi
  80029b:	89 d7                	mov    %edx,%edi
  80029d:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002a6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ac:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8002af:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002b3:	74 2c                	je     8002e1 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8002b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002b8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002c2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002c5:	39 c2                	cmp    %eax,%edx
  8002c7:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002ca:	73 43                	jae    80030f <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002cc:	83 eb 01             	sub    $0x1,%ebx
  8002cf:	85 db                	test   %ebx,%ebx
  8002d1:	7e 6c                	jle    80033f <printnum+0xaf>
				putch(padc, putdat);
  8002d3:	83 ec 08             	sub    $0x8,%esp
  8002d6:	57                   	push   %edi
  8002d7:	ff 75 18             	pushl  0x18(%ebp)
  8002da:	ff d6                	call   *%esi
  8002dc:	83 c4 10             	add    $0x10,%esp
  8002df:	eb eb                	jmp    8002cc <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002e1:	83 ec 0c             	sub    $0xc,%esp
  8002e4:	6a 20                	push   $0x20
  8002e6:	6a 00                	push   $0x0
  8002e8:	50                   	push   %eax
  8002e9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ec:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ef:	89 fa                	mov    %edi,%edx
  8002f1:	89 f0                	mov    %esi,%eax
  8002f3:	e8 98 ff ff ff       	call   800290 <printnum>
		while (--width > 0)
  8002f8:	83 c4 20             	add    $0x20,%esp
  8002fb:	83 eb 01             	sub    $0x1,%ebx
  8002fe:	85 db                	test   %ebx,%ebx
  800300:	7e 65                	jle    800367 <printnum+0xd7>
			putch(padc, putdat);
  800302:	83 ec 08             	sub    $0x8,%esp
  800305:	57                   	push   %edi
  800306:	6a 20                	push   $0x20
  800308:	ff d6                	call   *%esi
  80030a:	83 c4 10             	add    $0x10,%esp
  80030d:	eb ec                	jmp    8002fb <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80030f:	83 ec 0c             	sub    $0xc,%esp
  800312:	ff 75 18             	pushl  0x18(%ebp)
  800315:	83 eb 01             	sub    $0x1,%ebx
  800318:	53                   	push   %ebx
  800319:	50                   	push   %eax
  80031a:	83 ec 08             	sub    $0x8,%esp
  80031d:	ff 75 dc             	pushl  -0x24(%ebp)
  800320:	ff 75 d8             	pushl  -0x28(%ebp)
  800323:	ff 75 e4             	pushl  -0x1c(%ebp)
  800326:	ff 75 e0             	pushl  -0x20(%ebp)
  800329:	e8 a2 20 00 00       	call   8023d0 <__udivdi3>
  80032e:	83 c4 18             	add    $0x18,%esp
  800331:	52                   	push   %edx
  800332:	50                   	push   %eax
  800333:	89 fa                	mov    %edi,%edx
  800335:	89 f0                	mov    %esi,%eax
  800337:	e8 54 ff ff ff       	call   800290 <printnum>
  80033c:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80033f:	83 ec 08             	sub    $0x8,%esp
  800342:	57                   	push   %edi
  800343:	83 ec 04             	sub    $0x4,%esp
  800346:	ff 75 dc             	pushl  -0x24(%ebp)
  800349:	ff 75 d8             	pushl  -0x28(%ebp)
  80034c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80034f:	ff 75 e0             	pushl  -0x20(%ebp)
  800352:	e8 89 21 00 00       	call   8024e0 <__umoddi3>
  800357:	83 c4 14             	add    $0x14,%esp
  80035a:	0f be 80 d7 26 80 00 	movsbl 0x8026d7(%eax),%eax
  800361:	50                   	push   %eax
  800362:	ff d6                	call   *%esi
  800364:	83 c4 10             	add    $0x10,%esp
	}
}
  800367:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80036a:	5b                   	pop    %ebx
  80036b:	5e                   	pop    %esi
  80036c:	5f                   	pop    %edi
  80036d:	5d                   	pop    %ebp
  80036e:	c3                   	ret    

0080036f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80036f:	55                   	push   %ebp
  800370:	89 e5                	mov    %esp,%ebp
  800372:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800375:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800379:	8b 10                	mov    (%eax),%edx
  80037b:	3b 50 04             	cmp    0x4(%eax),%edx
  80037e:	73 0a                	jae    80038a <sprintputch+0x1b>
		*b->buf++ = ch;
  800380:	8d 4a 01             	lea    0x1(%edx),%ecx
  800383:	89 08                	mov    %ecx,(%eax)
  800385:	8b 45 08             	mov    0x8(%ebp),%eax
  800388:	88 02                	mov    %al,(%edx)
}
  80038a:	5d                   	pop    %ebp
  80038b:	c3                   	ret    

0080038c <printfmt>:
{
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800392:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800395:	50                   	push   %eax
  800396:	ff 75 10             	pushl  0x10(%ebp)
  800399:	ff 75 0c             	pushl  0xc(%ebp)
  80039c:	ff 75 08             	pushl  0x8(%ebp)
  80039f:	e8 05 00 00 00       	call   8003a9 <vprintfmt>
}
  8003a4:	83 c4 10             	add    $0x10,%esp
  8003a7:	c9                   	leave  
  8003a8:	c3                   	ret    

008003a9 <vprintfmt>:
{
  8003a9:	55                   	push   %ebp
  8003aa:	89 e5                	mov    %esp,%ebp
  8003ac:	57                   	push   %edi
  8003ad:	56                   	push   %esi
  8003ae:	53                   	push   %ebx
  8003af:	83 ec 3c             	sub    $0x3c,%esp
  8003b2:	8b 75 08             	mov    0x8(%ebp),%esi
  8003b5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003b8:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003bb:	e9 32 04 00 00       	jmp    8007f2 <vprintfmt+0x449>
		padc = ' ';
  8003c0:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003c4:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003cb:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003d2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003d9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003e0:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003e7:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003ec:	8d 47 01             	lea    0x1(%edi),%eax
  8003ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003f2:	0f b6 17             	movzbl (%edi),%edx
  8003f5:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003f8:	3c 55                	cmp    $0x55,%al
  8003fa:	0f 87 12 05 00 00    	ja     800912 <vprintfmt+0x569>
  800400:	0f b6 c0             	movzbl %al,%eax
  800403:	ff 24 85 c0 28 80 00 	jmp    *0x8028c0(,%eax,4)
  80040a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80040d:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800411:	eb d9                	jmp    8003ec <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800413:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800416:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80041a:	eb d0                	jmp    8003ec <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80041c:	0f b6 d2             	movzbl %dl,%edx
  80041f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800422:	b8 00 00 00 00       	mov    $0x0,%eax
  800427:	89 75 08             	mov    %esi,0x8(%ebp)
  80042a:	eb 03                	jmp    80042f <vprintfmt+0x86>
  80042c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80042f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800432:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800436:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800439:	8d 72 d0             	lea    -0x30(%edx),%esi
  80043c:	83 fe 09             	cmp    $0x9,%esi
  80043f:	76 eb                	jbe    80042c <vprintfmt+0x83>
  800441:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800444:	8b 75 08             	mov    0x8(%ebp),%esi
  800447:	eb 14                	jmp    80045d <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800449:	8b 45 14             	mov    0x14(%ebp),%eax
  80044c:	8b 00                	mov    (%eax),%eax
  80044e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800451:	8b 45 14             	mov    0x14(%ebp),%eax
  800454:	8d 40 04             	lea    0x4(%eax),%eax
  800457:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80045a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80045d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800461:	79 89                	jns    8003ec <vprintfmt+0x43>
				width = precision, precision = -1;
  800463:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800466:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800469:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800470:	e9 77 ff ff ff       	jmp    8003ec <vprintfmt+0x43>
  800475:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800478:	85 c0                	test   %eax,%eax
  80047a:	0f 48 c1             	cmovs  %ecx,%eax
  80047d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800480:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800483:	e9 64 ff ff ff       	jmp    8003ec <vprintfmt+0x43>
  800488:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80048b:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800492:	e9 55 ff ff ff       	jmp    8003ec <vprintfmt+0x43>
			lflag++;
  800497:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80049b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80049e:	e9 49 ff ff ff       	jmp    8003ec <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a6:	8d 78 04             	lea    0x4(%eax),%edi
  8004a9:	83 ec 08             	sub    $0x8,%esp
  8004ac:	53                   	push   %ebx
  8004ad:	ff 30                	pushl  (%eax)
  8004af:	ff d6                	call   *%esi
			break;
  8004b1:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004b4:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004b7:	e9 33 03 00 00       	jmp    8007ef <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bf:	8d 78 04             	lea    0x4(%eax),%edi
  8004c2:	8b 00                	mov    (%eax),%eax
  8004c4:	99                   	cltd   
  8004c5:	31 d0                	xor    %edx,%eax
  8004c7:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004c9:	83 f8 10             	cmp    $0x10,%eax
  8004cc:	7f 23                	jg     8004f1 <vprintfmt+0x148>
  8004ce:	8b 14 85 20 2a 80 00 	mov    0x802a20(,%eax,4),%edx
  8004d5:	85 d2                	test   %edx,%edx
  8004d7:	74 18                	je     8004f1 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004d9:	52                   	push   %edx
  8004da:	68 b5 2b 80 00       	push   $0x802bb5
  8004df:	53                   	push   %ebx
  8004e0:	56                   	push   %esi
  8004e1:	e8 a6 fe ff ff       	call   80038c <printfmt>
  8004e6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004e9:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004ec:	e9 fe 02 00 00       	jmp    8007ef <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004f1:	50                   	push   %eax
  8004f2:	68 ef 26 80 00       	push   $0x8026ef
  8004f7:	53                   	push   %ebx
  8004f8:	56                   	push   %esi
  8004f9:	e8 8e fe ff ff       	call   80038c <printfmt>
  8004fe:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800501:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800504:	e9 e6 02 00 00       	jmp    8007ef <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800509:	8b 45 14             	mov    0x14(%ebp),%eax
  80050c:	83 c0 04             	add    $0x4,%eax
  80050f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800512:	8b 45 14             	mov    0x14(%ebp),%eax
  800515:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800517:	85 c9                	test   %ecx,%ecx
  800519:	b8 e8 26 80 00       	mov    $0x8026e8,%eax
  80051e:	0f 45 c1             	cmovne %ecx,%eax
  800521:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800524:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800528:	7e 06                	jle    800530 <vprintfmt+0x187>
  80052a:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80052e:	75 0d                	jne    80053d <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800530:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800533:	89 c7                	mov    %eax,%edi
  800535:	03 45 e0             	add    -0x20(%ebp),%eax
  800538:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80053b:	eb 53                	jmp    800590 <vprintfmt+0x1e7>
  80053d:	83 ec 08             	sub    $0x8,%esp
  800540:	ff 75 d8             	pushl  -0x28(%ebp)
  800543:	50                   	push   %eax
  800544:	e8 71 04 00 00       	call   8009ba <strnlen>
  800549:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80054c:	29 c1                	sub    %eax,%ecx
  80054e:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800551:	83 c4 10             	add    $0x10,%esp
  800554:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800556:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80055a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80055d:	eb 0f                	jmp    80056e <vprintfmt+0x1c5>
					putch(padc, putdat);
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	53                   	push   %ebx
  800563:	ff 75 e0             	pushl  -0x20(%ebp)
  800566:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800568:	83 ef 01             	sub    $0x1,%edi
  80056b:	83 c4 10             	add    $0x10,%esp
  80056e:	85 ff                	test   %edi,%edi
  800570:	7f ed                	jg     80055f <vprintfmt+0x1b6>
  800572:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800575:	85 c9                	test   %ecx,%ecx
  800577:	b8 00 00 00 00       	mov    $0x0,%eax
  80057c:	0f 49 c1             	cmovns %ecx,%eax
  80057f:	29 c1                	sub    %eax,%ecx
  800581:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800584:	eb aa                	jmp    800530 <vprintfmt+0x187>
					putch(ch, putdat);
  800586:	83 ec 08             	sub    $0x8,%esp
  800589:	53                   	push   %ebx
  80058a:	52                   	push   %edx
  80058b:	ff d6                	call   *%esi
  80058d:	83 c4 10             	add    $0x10,%esp
  800590:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800593:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800595:	83 c7 01             	add    $0x1,%edi
  800598:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80059c:	0f be d0             	movsbl %al,%edx
  80059f:	85 d2                	test   %edx,%edx
  8005a1:	74 4b                	je     8005ee <vprintfmt+0x245>
  8005a3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005a7:	78 06                	js     8005af <vprintfmt+0x206>
  8005a9:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005ad:	78 1e                	js     8005cd <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8005af:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005b3:	74 d1                	je     800586 <vprintfmt+0x1dd>
  8005b5:	0f be c0             	movsbl %al,%eax
  8005b8:	83 e8 20             	sub    $0x20,%eax
  8005bb:	83 f8 5e             	cmp    $0x5e,%eax
  8005be:	76 c6                	jbe    800586 <vprintfmt+0x1dd>
					putch('?', putdat);
  8005c0:	83 ec 08             	sub    $0x8,%esp
  8005c3:	53                   	push   %ebx
  8005c4:	6a 3f                	push   $0x3f
  8005c6:	ff d6                	call   *%esi
  8005c8:	83 c4 10             	add    $0x10,%esp
  8005cb:	eb c3                	jmp    800590 <vprintfmt+0x1e7>
  8005cd:	89 cf                	mov    %ecx,%edi
  8005cf:	eb 0e                	jmp    8005df <vprintfmt+0x236>
				putch(' ', putdat);
  8005d1:	83 ec 08             	sub    $0x8,%esp
  8005d4:	53                   	push   %ebx
  8005d5:	6a 20                	push   $0x20
  8005d7:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005d9:	83 ef 01             	sub    $0x1,%edi
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	85 ff                	test   %edi,%edi
  8005e1:	7f ee                	jg     8005d1 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005e3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e9:	e9 01 02 00 00       	jmp    8007ef <vprintfmt+0x446>
  8005ee:	89 cf                	mov    %ecx,%edi
  8005f0:	eb ed                	jmp    8005df <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005f5:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005fc:	e9 eb fd ff ff       	jmp    8003ec <vprintfmt+0x43>
	if (lflag >= 2)
  800601:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800605:	7f 21                	jg     800628 <vprintfmt+0x27f>
	else if (lflag)
  800607:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80060b:	74 68                	je     800675 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80060d:	8b 45 14             	mov    0x14(%ebp),%eax
  800610:	8b 00                	mov    (%eax),%eax
  800612:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800615:	89 c1                	mov    %eax,%ecx
  800617:	c1 f9 1f             	sar    $0x1f,%ecx
  80061a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80061d:	8b 45 14             	mov    0x14(%ebp),%eax
  800620:	8d 40 04             	lea    0x4(%eax),%eax
  800623:	89 45 14             	mov    %eax,0x14(%ebp)
  800626:	eb 17                	jmp    80063f <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800628:	8b 45 14             	mov    0x14(%ebp),%eax
  80062b:	8b 50 04             	mov    0x4(%eax),%edx
  80062e:	8b 00                	mov    (%eax),%eax
  800630:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800633:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8d 40 08             	lea    0x8(%eax),%eax
  80063c:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80063f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800642:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800645:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800648:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80064b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80064f:	78 3f                	js     800690 <vprintfmt+0x2e7>
			base = 10;
  800651:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800656:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80065a:	0f 84 71 01 00 00    	je     8007d1 <vprintfmt+0x428>
				putch('+', putdat);
  800660:	83 ec 08             	sub    $0x8,%esp
  800663:	53                   	push   %ebx
  800664:	6a 2b                	push   $0x2b
  800666:	ff d6                	call   *%esi
  800668:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80066b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800670:	e9 5c 01 00 00       	jmp    8007d1 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800675:	8b 45 14             	mov    0x14(%ebp),%eax
  800678:	8b 00                	mov    (%eax),%eax
  80067a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80067d:	89 c1                	mov    %eax,%ecx
  80067f:	c1 f9 1f             	sar    $0x1f,%ecx
  800682:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8d 40 04             	lea    0x4(%eax),%eax
  80068b:	89 45 14             	mov    %eax,0x14(%ebp)
  80068e:	eb af                	jmp    80063f <vprintfmt+0x296>
				putch('-', putdat);
  800690:	83 ec 08             	sub    $0x8,%esp
  800693:	53                   	push   %ebx
  800694:	6a 2d                	push   $0x2d
  800696:	ff d6                	call   *%esi
				num = -(long long) num;
  800698:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80069b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80069e:	f7 d8                	neg    %eax
  8006a0:	83 d2 00             	adc    $0x0,%edx
  8006a3:	f7 da                	neg    %edx
  8006a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ab:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006ae:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b3:	e9 19 01 00 00       	jmp    8007d1 <vprintfmt+0x428>
	if (lflag >= 2)
  8006b8:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006bc:	7f 29                	jg     8006e7 <vprintfmt+0x33e>
	else if (lflag)
  8006be:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006c2:	74 44                	je     800708 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d7:	8d 40 04             	lea    0x4(%eax),%eax
  8006da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006dd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006e2:	e9 ea 00 00 00       	jmp    8007d1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ea:	8b 50 04             	mov    0x4(%eax),%edx
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f8:	8d 40 08             	lea    0x8(%eax),%eax
  8006fb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006fe:	b8 0a 00 00 00       	mov    $0xa,%eax
  800703:	e9 c9 00 00 00       	jmp    8007d1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	ba 00 00 00 00       	mov    $0x0,%edx
  800712:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800715:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800718:	8b 45 14             	mov    0x14(%ebp),%eax
  80071b:	8d 40 04             	lea    0x4(%eax),%eax
  80071e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800721:	b8 0a 00 00 00       	mov    $0xa,%eax
  800726:	e9 a6 00 00 00       	jmp    8007d1 <vprintfmt+0x428>
			putch('0', putdat);
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	53                   	push   %ebx
  80072f:	6a 30                	push   $0x30
  800731:	ff d6                	call   *%esi
	if (lflag >= 2)
  800733:	83 c4 10             	add    $0x10,%esp
  800736:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80073a:	7f 26                	jg     800762 <vprintfmt+0x3b9>
	else if (lflag)
  80073c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800740:	74 3e                	je     800780 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800742:	8b 45 14             	mov    0x14(%ebp),%eax
  800745:	8b 00                	mov    (%eax),%eax
  800747:	ba 00 00 00 00       	mov    $0x0,%edx
  80074c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800752:	8b 45 14             	mov    0x14(%ebp),%eax
  800755:	8d 40 04             	lea    0x4(%eax),%eax
  800758:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80075b:	b8 08 00 00 00       	mov    $0x8,%eax
  800760:	eb 6f                	jmp    8007d1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800762:	8b 45 14             	mov    0x14(%ebp),%eax
  800765:	8b 50 04             	mov    0x4(%eax),%edx
  800768:	8b 00                	mov    (%eax),%eax
  80076a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	8d 40 08             	lea    0x8(%eax),%eax
  800776:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800779:	b8 08 00 00 00       	mov    $0x8,%eax
  80077e:	eb 51                	jmp    8007d1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800780:	8b 45 14             	mov    0x14(%ebp),%eax
  800783:	8b 00                	mov    (%eax),%eax
  800785:	ba 00 00 00 00       	mov    $0x0,%edx
  80078a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800790:	8b 45 14             	mov    0x14(%ebp),%eax
  800793:	8d 40 04             	lea    0x4(%eax),%eax
  800796:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800799:	b8 08 00 00 00       	mov    $0x8,%eax
  80079e:	eb 31                	jmp    8007d1 <vprintfmt+0x428>
			putch('0', putdat);
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	53                   	push   %ebx
  8007a4:	6a 30                	push   $0x30
  8007a6:	ff d6                	call   *%esi
			putch('x', putdat);
  8007a8:	83 c4 08             	add    $0x8,%esp
  8007ab:	53                   	push   %ebx
  8007ac:	6a 78                	push   $0x78
  8007ae:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007bd:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007c0:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	8d 40 04             	lea    0x4(%eax),%eax
  8007c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007cc:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007d1:	83 ec 0c             	sub    $0xc,%esp
  8007d4:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007d8:	52                   	push   %edx
  8007d9:	ff 75 e0             	pushl  -0x20(%ebp)
  8007dc:	50                   	push   %eax
  8007dd:	ff 75 dc             	pushl  -0x24(%ebp)
  8007e0:	ff 75 d8             	pushl  -0x28(%ebp)
  8007e3:	89 da                	mov    %ebx,%edx
  8007e5:	89 f0                	mov    %esi,%eax
  8007e7:	e8 a4 fa ff ff       	call   800290 <printnum>
			break;
  8007ec:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007f2:	83 c7 01             	add    $0x1,%edi
  8007f5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007f9:	83 f8 25             	cmp    $0x25,%eax
  8007fc:	0f 84 be fb ff ff    	je     8003c0 <vprintfmt+0x17>
			if (ch == '\0')
  800802:	85 c0                	test   %eax,%eax
  800804:	0f 84 28 01 00 00    	je     800932 <vprintfmt+0x589>
			putch(ch, putdat);
  80080a:	83 ec 08             	sub    $0x8,%esp
  80080d:	53                   	push   %ebx
  80080e:	50                   	push   %eax
  80080f:	ff d6                	call   *%esi
  800811:	83 c4 10             	add    $0x10,%esp
  800814:	eb dc                	jmp    8007f2 <vprintfmt+0x449>
	if (lflag >= 2)
  800816:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80081a:	7f 26                	jg     800842 <vprintfmt+0x499>
	else if (lflag)
  80081c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800820:	74 41                	je     800863 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800822:	8b 45 14             	mov    0x14(%ebp),%eax
  800825:	8b 00                	mov    (%eax),%eax
  800827:	ba 00 00 00 00       	mov    $0x0,%edx
  80082c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80082f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	8d 40 04             	lea    0x4(%eax),%eax
  800838:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80083b:	b8 10 00 00 00       	mov    $0x10,%eax
  800840:	eb 8f                	jmp    8007d1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800842:	8b 45 14             	mov    0x14(%ebp),%eax
  800845:	8b 50 04             	mov    0x4(%eax),%edx
  800848:	8b 00                	mov    (%eax),%eax
  80084a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800850:	8b 45 14             	mov    0x14(%ebp),%eax
  800853:	8d 40 08             	lea    0x8(%eax),%eax
  800856:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800859:	b8 10 00 00 00       	mov    $0x10,%eax
  80085e:	e9 6e ff ff ff       	jmp    8007d1 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800863:	8b 45 14             	mov    0x14(%ebp),%eax
  800866:	8b 00                	mov    (%eax),%eax
  800868:	ba 00 00 00 00       	mov    $0x0,%edx
  80086d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800870:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	8d 40 04             	lea    0x4(%eax),%eax
  800879:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80087c:	b8 10 00 00 00       	mov    $0x10,%eax
  800881:	e9 4b ff ff ff       	jmp    8007d1 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800886:	8b 45 14             	mov    0x14(%ebp),%eax
  800889:	83 c0 04             	add    $0x4,%eax
  80088c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088f:	8b 45 14             	mov    0x14(%ebp),%eax
  800892:	8b 00                	mov    (%eax),%eax
  800894:	85 c0                	test   %eax,%eax
  800896:	74 14                	je     8008ac <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800898:	8b 13                	mov    (%ebx),%edx
  80089a:	83 fa 7f             	cmp    $0x7f,%edx
  80089d:	7f 37                	jg     8008d6 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80089f:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8008a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008a4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a7:	e9 43 ff ff ff       	jmp    8007ef <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8008ac:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008b1:	bf 0d 28 80 00       	mov    $0x80280d,%edi
							putch(ch, putdat);
  8008b6:	83 ec 08             	sub    $0x8,%esp
  8008b9:	53                   	push   %ebx
  8008ba:	50                   	push   %eax
  8008bb:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008bd:	83 c7 01             	add    $0x1,%edi
  8008c0:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008c4:	83 c4 10             	add    $0x10,%esp
  8008c7:	85 c0                	test   %eax,%eax
  8008c9:	75 eb                	jne    8008b6 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008ce:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d1:	e9 19 ff ff ff       	jmp    8007ef <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008d6:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008d8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008dd:	bf 45 28 80 00       	mov    $0x802845,%edi
							putch(ch, putdat);
  8008e2:	83 ec 08             	sub    $0x8,%esp
  8008e5:	53                   	push   %ebx
  8008e6:	50                   	push   %eax
  8008e7:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008e9:	83 c7 01             	add    $0x1,%edi
  8008ec:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	85 c0                	test   %eax,%eax
  8008f5:	75 eb                	jne    8008e2 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8008fd:	e9 ed fe ff ff       	jmp    8007ef <vprintfmt+0x446>
			putch(ch, putdat);
  800902:	83 ec 08             	sub    $0x8,%esp
  800905:	53                   	push   %ebx
  800906:	6a 25                	push   $0x25
  800908:	ff d6                	call   *%esi
			break;
  80090a:	83 c4 10             	add    $0x10,%esp
  80090d:	e9 dd fe ff ff       	jmp    8007ef <vprintfmt+0x446>
			putch('%', putdat);
  800912:	83 ec 08             	sub    $0x8,%esp
  800915:	53                   	push   %ebx
  800916:	6a 25                	push   $0x25
  800918:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80091a:	83 c4 10             	add    $0x10,%esp
  80091d:	89 f8                	mov    %edi,%eax
  80091f:	eb 03                	jmp    800924 <vprintfmt+0x57b>
  800921:	83 e8 01             	sub    $0x1,%eax
  800924:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800928:	75 f7                	jne    800921 <vprintfmt+0x578>
  80092a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80092d:	e9 bd fe ff ff       	jmp    8007ef <vprintfmt+0x446>
}
  800932:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800935:	5b                   	pop    %ebx
  800936:	5e                   	pop    %esi
  800937:	5f                   	pop    %edi
  800938:	5d                   	pop    %ebp
  800939:	c3                   	ret    

0080093a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	83 ec 18             	sub    $0x18,%esp
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800946:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800949:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80094d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800950:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800957:	85 c0                	test   %eax,%eax
  800959:	74 26                	je     800981 <vsnprintf+0x47>
  80095b:	85 d2                	test   %edx,%edx
  80095d:	7e 22                	jle    800981 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80095f:	ff 75 14             	pushl  0x14(%ebp)
  800962:	ff 75 10             	pushl  0x10(%ebp)
  800965:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800968:	50                   	push   %eax
  800969:	68 6f 03 80 00       	push   $0x80036f
  80096e:	e8 36 fa ff ff       	call   8003a9 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800973:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800976:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80097c:	83 c4 10             	add    $0x10,%esp
}
  80097f:	c9                   	leave  
  800980:	c3                   	ret    
		return -E_INVAL;
  800981:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800986:	eb f7                	jmp    80097f <vsnprintf+0x45>

00800988 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800988:	55                   	push   %ebp
  800989:	89 e5                	mov    %esp,%ebp
  80098b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80098e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800991:	50                   	push   %eax
  800992:	ff 75 10             	pushl  0x10(%ebp)
  800995:	ff 75 0c             	pushl  0xc(%ebp)
  800998:	ff 75 08             	pushl  0x8(%ebp)
  80099b:	e8 9a ff ff ff       	call   80093a <vsnprintf>
	va_end(ap);

	return rc;
}
  8009a0:	c9                   	leave  
  8009a1:	c3                   	ret    

008009a2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ad:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009b1:	74 05                	je     8009b8 <strlen+0x16>
		n++;
  8009b3:	83 c0 01             	add    $0x1,%eax
  8009b6:	eb f5                	jmp    8009ad <strlen+0xb>
	return n;
}
  8009b8:	5d                   	pop    %ebp
  8009b9:	c3                   	ret    

008009ba <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009c0:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c8:	39 c2                	cmp    %eax,%edx
  8009ca:	74 0d                	je     8009d9 <strnlen+0x1f>
  8009cc:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009d0:	74 05                	je     8009d7 <strnlen+0x1d>
		n++;
  8009d2:	83 c2 01             	add    $0x1,%edx
  8009d5:	eb f1                	jmp    8009c8 <strnlen+0xe>
  8009d7:	89 d0                	mov    %edx,%eax
	return n;
}
  8009d9:	5d                   	pop    %ebp
  8009da:	c3                   	ret    

008009db <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	53                   	push   %ebx
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ea:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009ee:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009f1:	83 c2 01             	add    $0x1,%edx
  8009f4:	84 c9                	test   %cl,%cl
  8009f6:	75 f2                	jne    8009ea <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009f8:	5b                   	pop    %ebx
  8009f9:	5d                   	pop    %ebp
  8009fa:	c3                   	ret    

008009fb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	53                   	push   %ebx
  8009ff:	83 ec 10             	sub    $0x10,%esp
  800a02:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a05:	53                   	push   %ebx
  800a06:	e8 97 ff ff ff       	call   8009a2 <strlen>
  800a0b:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a0e:	ff 75 0c             	pushl  0xc(%ebp)
  800a11:	01 d8                	add    %ebx,%eax
  800a13:	50                   	push   %eax
  800a14:	e8 c2 ff ff ff       	call   8009db <strcpy>
	return dst;
}
  800a19:	89 d8                	mov    %ebx,%eax
  800a1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a1e:	c9                   	leave  
  800a1f:	c3                   	ret    

00800a20 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	56                   	push   %esi
  800a24:	53                   	push   %ebx
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a2b:	89 c6                	mov    %eax,%esi
  800a2d:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a30:	89 c2                	mov    %eax,%edx
  800a32:	39 f2                	cmp    %esi,%edx
  800a34:	74 11                	je     800a47 <strncpy+0x27>
		*dst++ = *src;
  800a36:	83 c2 01             	add    $0x1,%edx
  800a39:	0f b6 19             	movzbl (%ecx),%ebx
  800a3c:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a3f:	80 fb 01             	cmp    $0x1,%bl
  800a42:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a45:	eb eb                	jmp    800a32 <strncpy+0x12>
	}
	return ret;
}
  800a47:	5b                   	pop    %ebx
  800a48:	5e                   	pop    %esi
  800a49:	5d                   	pop    %ebp
  800a4a:	c3                   	ret    

00800a4b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	56                   	push   %esi
  800a4f:	53                   	push   %ebx
  800a50:	8b 75 08             	mov    0x8(%ebp),%esi
  800a53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a56:	8b 55 10             	mov    0x10(%ebp),%edx
  800a59:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a5b:	85 d2                	test   %edx,%edx
  800a5d:	74 21                	je     800a80 <strlcpy+0x35>
  800a5f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a63:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a65:	39 c2                	cmp    %eax,%edx
  800a67:	74 14                	je     800a7d <strlcpy+0x32>
  800a69:	0f b6 19             	movzbl (%ecx),%ebx
  800a6c:	84 db                	test   %bl,%bl
  800a6e:	74 0b                	je     800a7b <strlcpy+0x30>
			*dst++ = *src++;
  800a70:	83 c1 01             	add    $0x1,%ecx
  800a73:	83 c2 01             	add    $0x1,%edx
  800a76:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a79:	eb ea                	jmp    800a65 <strlcpy+0x1a>
  800a7b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a7d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a80:	29 f0                	sub    %esi,%eax
}
  800a82:	5b                   	pop    %ebx
  800a83:	5e                   	pop    %esi
  800a84:	5d                   	pop    %ebp
  800a85:	c3                   	ret    

00800a86 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a86:	55                   	push   %ebp
  800a87:	89 e5                	mov    %esp,%ebp
  800a89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a8c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a8f:	0f b6 01             	movzbl (%ecx),%eax
  800a92:	84 c0                	test   %al,%al
  800a94:	74 0c                	je     800aa2 <strcmp+0x1c>
  800a96:	3a 02                	cmp    (%edx),%al
  800a98:	75 08                	jne    800aa2 <strcmp+0x1c>
		p++, q++;
  800a9a:	83 c1 01             	add    $0x1,%ecx
  800a9d:	83 c2 01             	add    $0x1,%edx
  800aa0:	eb ed                	jmp    800a8f <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aa2:	0f b6 c0             	movzbl %al,%eax
  800aa5:	0f b6 12             	movzbl (%edx),%edx
  800aa8:	29 d0                	sub    %edx,%eax
}
  800aaa:	5d                   	pop    %ebp
  800aab:	c3                   	ret    

00800aac <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	53                   	push   %ebx
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab6:	89 c3                	mov    %eax,%ebx
  800ab8:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800abb:	eb 06                	jmp    800ac3 <strncmp+0x17>
		n--, p++, q++;
  800abd:	83 c0 01             	add    $0x1,%eax
  800ac0:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ac3:	39 d8                	cmp    %ebx,%eax
  800ac5:	74 16                	je     800add <strncmp+0x31>
  800ac7:	0f b6 08             	movzbl (%eax),%ecx
  800aca:	84 c9                	test   %cl,%cl
  800acc:	74 04                	je     800ad2 <strncmp+0x26>
  800ace:	3a 0a                	cmp    (%edx),%cl
  800ad0:	74 eb                	je     800abd <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ad2:	0f b6 00             	movzbl (%eax),%eax
  800ad5:	0f b6 12             	movzbl (%edx),%edx
  800ad8:	29 d0                	sub    %edx,%eax
}
  800ada:	5b                   	pop    %ebx
  800adb:	5d                   	pop    %ebp
  800adc:	c3                   	ret    
		return 0;
  800add:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae2:	eb f6                	jmp    800ada <strncmp+0x2e>

00800ae4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ae4:	55                   	push   %ebp
  800ae5:	89 e5                	mov    %esp,%ebp
  800ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aea:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aee:	0f b6 10             	movzbl (%eax),%edx
  800af1:	84 d2                	test   %dl,%dl
  800af3:	74 09                	je     800afe <strchr+0x1a>
		if (*s == c)
  800af5:	38 ca                	cmp    %cl,%dl
  800af7:	74 0a                	je     800b03 <strchr+0x1f>
	for (; *s; s++)
  800af9:	83 c0 01             	add    $0x1,%eax
  800afc:	eb f0                	jmp    800aee <strchr+0xa>
			return (char *) s;
	return 0;
  800afe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b03:	5d                   	pop    %ebp
  800b04:	c3                   	ret    

00800b05 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b0f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b12:	38 ca                	cmp    %cl,%dl
  800b14:	74 09                	je     800b1f <strfind+0x1a>
  800b16:	84 d2                	test   %dl,%dl
  800b18:	74 05                	je     800b1f <strfind+0x1a>
	for (; *s; s++)
  800b1a:	83 c0 01             	add    $0x1,%eax
  800b1d:	eb f0                	jmp    800b0f <strfind+0xa>
			break;
	return (char *) s;
}
  800b1f:	5d                   	pop    %ebp
  800b20:	c3                   	ret    

00800b21 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
  800b24:	57                   	push   %edi
  800b25:	56                   	push   %esi
  800b26:	53                   	push   %ebx
  800b27:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b2d:	85 c9                	test   %ecx,%ecx
  800b2f:	74 31                	je     800b62 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b31:	89 f8                	mov    %edi,%eax
  800b33:	09 c8                	or     %ecx,%eax
  800b35:	a8 03                	test   $0x3,%al
  800b37:	75 23                	jne    800b5c <memset+0x3b>
		c &= 0xFF;
  800b39:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b3d:	89 d3                	mov    %edx,%ebx
  800b3f:	c1 e3 08             	shl    $0x8,%ebx
  800b42:	89 d0                	mov    %edx,%eax
  800b44:	c1 e0 18             	shl    $0x18,%eax
  800b47:	89 d6                	mov    %edx,%esi
  800b49:	c1 e6 10             	shl    $0x10,%esi
  800b4c:	09 f0                	or     %esi,%eax
  800b4e:	09 c2                	or     %eax,%edx
  800b50:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b52:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b55:	89 d0                	mov    %edx,%eax
  800b57:	fc                   	cld    
  800b58:	f3 ab                	rep stos %eax,%es:(%edi)
  800b5a:	eb 06                	jmp    800b62 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5f:	fc                   	cld    
  800b60:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b62:	89 f8                	mov    %edi,%eax
  800b64:	5b                   	pop    %ebx
  800b65:	5e                   	pop    %esi
  800b66:	5f                   	pop    %edi
  800b67:	5d                   	pop    %ebp
  800b68:	c3                   	ret    

00800b69 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b69:	55                   	push   %ebp
  800b6a:	89 e5                	mov    %esp,%ebp
  800b6c:	57                   	push   %edi
  800b6d:	56                   	push   %esi
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b74:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b77:	39 c6                	cmp    %eax,%esi
  800b79:	73 32                	jae    800bad <memmove+0x44>
  800b7b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b7e:	39 c2                	cmp    %eax,%edx
  800b80:	76 2b                	jbe    800bad <memmove+0x44>
		s += n;
		d += n;
  800b82:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b85:	89 fe                	mov    %edi,%esi
  800b87:	09 ce                	or     %ecx,%esi
  800b89:	09 d6                	or     %edx,%esi
  800b8b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b91:	75 0e                	jne    800ba1 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b93:	83 ef 04             	sub    $0x4,%edi
  800b96:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b99:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b9c:	fd                   	std    
  800b9d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b9f:	eb 09                	jmp    800baa <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ba1:	83 ef 01             	sub    $0x1,%edi
  800ba4:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ba7:	fd                   	std    
  800ba8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800baa:	fc                   	cld    
  800bab:	eb 1a                	jmp    800bc7 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bad:	89 c2                	mov    %eax,%edx
  800baf:	09 ca                	or     %ecx,%edx
  800bb1:	09 f2                	or     %esi,%edx
  800bb3:	f6 c2 03             	test   $0x3,%dl
  800bb6:	75 0a                	jne    800bc2 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bb8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bbb:	89 c7                	mov    %eax,%edi
  800bbd:	fc                   	cld    
  800bbe:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bc0:	eb 05                	jmp    800bc7 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bc2:	89 c7                	mov    %eax,%edi
  800bc4:	fc                   	cld    
  800bc5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bc7:	5e                   	pop    %esi
  800bc8:	5f                   	pop    %edi
  800bc9:	5d                   	pop    %ebp
  800bca:	c3                   	ret    

00800bcb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bd1:	ff 75 10             	pushl  0x10(%ebp)
  800bd4:	ff 75 0c             	pushl  0xc(%ebp)
  800bd7:	ff 75 08             	pushl  0x8(%ebp)
  800bda:	e8 8a ff ff ff       	call   800b69 <memmove>
}
  800bdf:	c9                   	leave  
  800be0:	c3                   	ret    

00800be1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	56                   	push   %esi
  800be5:	53                   	push   %ebx
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bec:	89 c6                	mov    %eax,%esi
  800bee:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bf1:	39 f0                	cmp    %esi,%eax
  800bf3:	74 1c                	je     800c11 <memcmp+0x30>
		if (*s1 != *s2)
  800bf5:	0f b6 08             	movzbl (%eax),%ecx
  800bf8:	0f b6 1a             	movzbl (%edx),%ebx
  800bfb:	38 d9                	cmp    %bl,%cl
  800bfd:	75 08                	jne    800c07 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bff:	83 c0 01             	add    $0x1,%eax
  800c02:	83 c2 01             	add    $0x1,%edx
  800c05:	eb ea                	jmp    800bf1 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c07:	0f b6 c1             	movzbl %cl,%eax
  800c0a:	0f b6 db             	movzbl %bl,%ebx
  800c0d:	29 d8                	sub    %ebx,%eax
  800c0f:	eb 05                	jmp    800c16 <memcmp+0x35>
	}

	return 0;
  800c11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c16:	5b                   	pop    %ebx
  800c17:	5e                   	pop    %esi
  800c18:	5d                   	pop    %ebp
  800c19:	c3                   	ret    

00800c1a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c1a:	55                   	push   %ebp
  800c1b:	89 e5                	mov    %esp,%ebp
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c23:	89 c2                	mov    %eax,%edx
  800c25:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c28:	39 d0                	cmp    %edx,%eax
  800c2a:	73 09                	jae    800c35 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c2c:	38 08                	cmp    %cl,(%eax)
  800c2e:	74 05                	je     800c35 <memfind+0x1b>
	for (; s < ends; s++)
  800c30:	83 c0 01             	add    $0x1,%eax
  800c33:	eb f3                	jmp    800c28 <memfind+0xe>
			break;
	return (void *) s;
}
  800c35:	5d                   	pop    %ebp
  800c36:	c3                   	ret    

00800c37 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	57                   	push   %edi
  800c3b:	56                   	push   %esi
  800c3c:	53                   	push   %ebx
  800c3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c40:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c43:	eb 03                	jmp    800c48 <strtol+0x11>
		s++;
  800c45:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c48:	0f b6 01             	movzbl (%ecx),%eax
  800c4b:	3c 20                	cmp    $0x20,%al
  800c4d:	74 f6                	je     800c45 <strtol+0xe>
  800c4f:	3c 09                	cmp    $0x9,%al
  800c51:	74 f2                	je     800c45 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c53:	3c 2b                	cmp    $0x2b,%al
  800c55:	74 2a                	je     800c81 <strtol+0x4a>
	int neg = 0;
  800c57:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c5c:	3c 2d                	cmp    $0x2d,%al
  800c5e:	74 2b                	je     800c8b <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c60:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c66:	75 0f                	jne    800c77 <strtol+0x40>
  800c68:	80 39 30             	cmpb   $0x30,(%ecx)
  800c6b:	74 28                	je     800c95 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c6d:	85 db                	test   %ebx,%ebx
  800c6f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c74:	0f 44 d8             	cmove  %eax,%ebx
  800c77:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c7f:	eb 50                	jmp    800cd1 <strtol+0x9a>
		s++;
  800c81:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c84:	bf 00 00 00 00       	mov    $0x0,%edi
  800c89:	eb d5                	jmp    800c60 <strtol+0x29>
		s++, neg = 1;
  800c8b:	83 c1 01             	add    $0x1,%ecx
  800c8e:	bf 01 00 00 00       	mov    $0x1,%edi
  800c93:	eb cb                	jmp    800c60 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c95:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c99:	74 0e                	je     800ca9 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c9b:	85 db                	test   %ebx,%ebx
  800c9d:	75 d8                	jne    800c77 <strtol+0x40>
		s++, base = 8;
  800c9f:	83 c1 01             	add    $0x1,%ecx
  800ca2:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ca7:	eb ce                	jmp    800c77 <strtol+0x40>
		s += 2, base = 16;
  800ca9:	83 c1 02             	add    $0x2,%ecx
  800cac:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cb1:	eb c4                	jmp    800c77 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cb3:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cb6:	89 f3                	mov    %esi,%ebx
  800cb8:	80 fb 19             	cmp    $0x19,%bl
  800cbb:	77 29                	ja     800ce6 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cbd:	0f be d2             	movsbl %dl,%edx
  800cc0:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cc3:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cc6:	7d 30                	jge    800cf8 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cc8:	83 c1 01             	add    $0x1,%ecx
  800ccb:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ccf:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cd1:	0f b6 11             	movzbl (%ecx),%edx
  800cd4:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cd7:	89 f3                	mov    %esi,%ebx
  800cd9:	80 fb 09             	cmp    $0x9,%bl
  800cdc:	77 d5                	ja     800cb3 <strtol+0x7c>
			dig = *s - '0';
  800cde:	0f be d2             	movsbl %dl,%edx
  800ce1:	83 ea 30             	sub    $0x30,%edx
  800ce4:	eb dd                	jmp    800cc3 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ce6:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ce9:	89 f3                	mov    %esi,%ebx
  800ceb:	80 fb 19             	cmp    $0x19,%bl
  800cee:	77 08                	ja     800cf8 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cf0:	0f be d2             	movsbl %dl,%edx
  800cf3:	83 ea 37             	sub    $0x37,%edx
  800cf6:	eb cb                	jmp    800cc3 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cf8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cfc:	74 05                	je     800d03 <strtol+0xcc>
		*endptr = (char *) s;
  800cfe:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d01:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d03:	89 c2                	mov    %eax,%edx
  800d05:	f7 da                	neg    %edx
  800d07:	85 ff                	test   %edi,%edi
  800d09:	0f 45 c2             	cmovne %edx,%eax
}
  800d0c:	5b                   	pop    %ebx
  800d0d:	5e                   	pop    %esi
  800d0e:	5f                   	pop    %edi
  800d0f:	5d                   	pop    %ebp
  800d10:	c3                   	ret    

00800d11 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d11:	55                   	push   %ebp
  800d12:	89 e5                	mov    %esp,%ebp
  800d14:	57                   	push   %edi
  800d15:	56                   	push   %esi
  800d16:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d17:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d22:	89 c3                	mov    %eax,%ebx
  800d24:	89 c7                	mov    %eax,%edi
  800d26:	89 c6                	mov    %eax,%esi
  800d28:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d2a:	5b                   	pop    %ebx
  800d2b:	5e                   	pop    %esi
  800d2c:	5f                   	pop    %edi
  800d2d:	5d                   	pop    %ebp
  800d2e:	c3                   	ret    

00800d2f <sys_cgetc>:

int
sys_cgetc(void)
{
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	57                   	push   %edi
  800d33:	56                   	push   %esi
  800d34:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d35:	ba 00 00 00 00       	mov    $0x0,%edx
  800d3a:	b8 01 00 00 00       	mov    $0x1,%eax
  800d3f:	89 d1                	mov    %edx,%ecx
  800d41:	89 d3                	mov    %edx,%ebx
  800d43:	89 d7                	mov    %edx,%edi
  800d45:	89 d6                	mov    %edx,%esi
  800d47:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d49:	5b                   	pop    %ebx
  800d4a:	5e                   	pop    %esi
  800d4b:	5f                   	pop    %edi
  800d4c:	5d                   	pop    %ebp
  800d4d:	c3                   	ret    

00800d4e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
  800d51:	57                   	push   %edi
  800d52:	56                   	push   %esi
  800d53:	53                   	push   %ebx
  800d54:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d57:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5f:	b8 03 00 00 00       	mov    $0x3,%eax
  800d64:	89 cb                	mov    %ecx,%ebx
  800d66:	89 cf                	mov    %ecx,%edi
  800d68:	89 ce                	mov    %ecx,%esi
  800d6a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d6c:	85 c0                	test   %eax,%eax
  800d6e:	7f 08                	jg     800d78 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d73:	5b                   	pop    %ebx
  800d74:	5e                   	pop    %esi
  800d75:	5f                   	pop    %edi
  800d76:	5d                   	pop    %ebp
  800d77:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d78:	83 ec 0c             	sub    $0xc,%esp
  800d7b:	50                   	push   %eax
  800d7c:	6a 03                	push   $0x3
  800d7e:	68 64 2a 80 00       	push   $0x802a64
  800d83:	6a 43                	push   $0x43
  800d85:	68 81 2a 80 00       	push   $0x802a81
  800d8a:	e8 f7 f3 ff ff       	call   800186 <_panic>

00800d8f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	57                   	push   %edi
  800d93:	56                   	push   %esi
  800d94:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d95:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9a:	b8 02 00 00 00       	mov    $0x2,%eax
  800d9f:	89 d1                	mov    %edx,%ecx
  800da1:	89 d3                	mov    %edx,%ebx
  800da3:	89 d7                	mov    %edx,%edi
  800da5:	89 d6                	mov    %edx,%esi
  800da7:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800da9:	5b                   	pop    %ebx
  800daa:	5e                   	pop    %esi
  800dab:	5f                   	pop    %edi
  800dac:	5d                   	pop    %ebp
  800dad:	c3                   	ret    

00800dae <sys_yield>:

void
sys_yield(void)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	57                   	push   %edi
  800db2:	56                   	push   %esi
  800db3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db4:	ba 00 00 00 00       	mov    $0x0,%edx
  800db9:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dbe:	89 d1                	mov    %edx,%ecx
  800dc0:	89 d3                	mov    %edx,%ebx
  800dc2:	89 d7                	mov    %edx,%edi
  800dc4:	89 d6                	mov    %edx,%esi
  800dc6:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dc8:	5b                   	pop    %ebx
  800dc9:	5e                   	pop    %esi
  800dca:	5f                   	pop    %edi
  800dcb:	5d                   	pop    %ebp
  800dcc:	c3                   	ret    

00800dcd <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	57                   	push   %edi
  800dd1:	56                   	push   %esi
  800dd2:	53                   	push   %ebx
  800dd3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd6:	be 00 00 00 00       	mov    $0x0,%esi
  800ddb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de1:	b8 04 00 00 00       	mov    $0x4,%eax
  800de6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de9:	89 f7                	mov    %esi,%edi
  800deb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ded:	85 c0                	test   %eax,%eax
  800def:	7f 08                	jg     800df9 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800df1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df4:	5b                   	pop    %ebx
  800df5:	5e                   	pop    %esi
  800df6:	5f                   	pop    %edi
  800df7:	5d                   	pop    %ebp
  800df8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df9:	83 ec 0c             	sub    $0xc,%esp
  800dfc:	50                   	push   %eax
  800dfd:	6a 04                	push   $0x4
  800dff:	68 64 2a 80 00       	push   $0x802a64
  800e04:	6a 43                	push   $0x43
  800e06:	68 81 2a 80 00       	push   $0x802a81
  800e0b:	e8 76 f3 ff ff       	call   800186 <_panic>

00800e10 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
  800e13:	57                   	push   %edi
  800e14:	56                   	push   %esi
  800e15:	53                   	push   %ebx
  800e16:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e19:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1f:	b8 05 00 00 00       	mov    $0x5,%eax
  800e24:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e27:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e2a:	8b 75 18             	mov    0x18(%ebp),%esi
  800e2d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2f:	85 c0                	test   %eax,%eax
  800e31:	7f 08                	jg     800e3b <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e33:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e36:	5b                   	pop    %ebx
  800e37:	5e                   	pop    %esi
  800e38:	5f                   	pop    %edi
  800e39:	5d                   	pop    %ebp
  800e3a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3b:	83 ec 0c             	sub    $0xc,%esp
  800e3e:	50                   	push   %eax
  800e3f:	6a 05                	push   $0x5
  800e41:	68 64 2a 80 00       	push   $0x802a64
  800e46:	6a 43                	push   $0x43
  800e48:	68 81 2a 80 00       	push   $0x802a81
  800e4d:	e8 34 f3 ff ff       	call   800186 <_panic>

00800e52 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	57                   	push   %edi
  800e56:	56                   	push   %esi
  800e57:	53                   	push   %ebx
  800e58:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e60:	8b 55 08             	mov    0x8(%ebp),%edx
  800e63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e66:	b8 06 00 00 00       	mov    $0x6,%eax
  800e6b:	89 df                	mov    %ebx,%edi
  800e6d:	89 de                	mov    %ebx,%esi
  800e6f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e71:	85 c0                	test   %eax,%eax
  800e73:	7f 08                	jg     800e7d <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e78:	5b                   	pop    %ebx
  800e79:	5e                   	pop    %esi
  800e7a:	5f                   	pop    %edi
  800e7b:	5d                   	pop    %ebp
  800e7c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7d:	83 ec 0c             	sub    $0xc,%esp
  800e80:	50                   	push   %eax
  800e81:	6a 06                	push   $0x6
  800e83:	68 64 2a 80 00       	push   $0x802a64
  800e88:	6a 43                	push   $0x43
  800e8a:	68 81 2a 80 00       	push   $0x802a81
  800e8f:	e8 f2 f2 ff ff       	call   800186 <_panic>

00800e94 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e94:	55                   	push   %ebp
  800e95:	89 e5                	mov    %esp,%ebp
  800e97:	57                   	push   %edi
  800e98:	56                   	push   %esi
  800e99:	53                   	push   %ebx
  800e9a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e9d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea8:	b8 08 00 00 00       	mov    $0x8,%eax
  800ead:	89 df                	mov    %ebx,%edi
  800eaf:	89 de                	mov    %ebx,%esi
  800eb1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb3:	85 c0                	test   %eax,%eax
  800eb5:	7f 08                	jg     800ebf <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800eb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eba:	5b                   	pop    %ebx
  800ebb:	5e                   	pop    %esi
  800ebc:	5f                   	pop    %edi
  800ebd:	5d                   	pop    %ebp
  800ebe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebf:	83 ec 0c             	sub    $0xc,%esp
  800ec2:	50                   	push   %eax
  800ec3:	6a 08                	push   $0x8
  800ec5:	68 64 2a 80 00       	push   $0x802a64
  800eca:	6a 43                	push   $0x43
  800ecc:	68 81 2a 80 00       	push   $0x802a81
  800ed1:	e8 b0 f2 ff ff       	call   800186 <_panic>

00800ed6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	57                   	push   %edi
  800eda:	56                   	push   %esi
  800edb:	53                   	push   %ebx
  800edc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800edf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eea:	b8 09 00 00 00       	mov    $0x9,%eax
  800eef:	89 df                	mov    %ebx,%edi
  800ef1:	89 de                	mov    %ebx,%esi
  800ef3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef5:	85 c0                	test   %eax,%eax
  800ef7:	7f 08                	jg     800f01 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ef9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800efc:	5b                   	pop    %ebx
  800efd:	5e                   	pop    %esi
  800efe:	5f                   	pop    %edi
  800eff:	5d                   	pop    %ebp
  800f00:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f01:	83 ec 0c             	sub    $0xc,%esp
  800f04:	50                   	push   %eax
  800f05:	6a 09                	push   $0x9
  800f07:	68 64 2a 80 00       	push   $0x802a64
  800f0c:	6a 43                	push   $0x43
  800f0e:	68 81 2a 80 00       	push   $0x802a81
  800f13:	e8 6e f2 ff ff       	call   800186 <_panic>

00800f18 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	57                   	push   %edi
  800f1c:	56                   	push   %esi
  800f1d:	53                   	push   %ebx
  800f1e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f21:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f26:	8b 55 08             	mov    0x8(%ebp),%edx
  800f29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f31:	89 df                	mov    %ebx,%edi
  800f33:	89 de                	mov    %ebx,%esi
  800f35:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f37:	85 c0                	test   %eax,%eax
  800f39:	7f 08                	jg     800f43 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f3e:	5b                   	pop    %ebx
  800f3f:	5e                   	pop    %esi
  800f40:	5f                   	pop    %edi
  800f41:	5d                   	pop    %ebp
  800f42:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f43:	83 ec 0c             	sub    $0xc,%esp
  800f46:	50                   	push   %eax
  800f47:	6a 0a                	push   $0xa
  800f49:	68 64 2a 80 00       	push   $0x802a64
  800f4e:	6a 43                	push   $0x43
  800f50:	68 81 2a 80 00       	push   $0x802a81
  800f55:	e8 2c f2 ff ff       	call   800186 <_panic>

00800f5a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	57                   	push   %edi
  800f5e:	56                   	push   %esi
  800f5f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f60:	8b 55 08             	mov    0x8(%ebp),%edx
  800f63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f66:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f6b:	be 00 00 00 00       	mov    $0x0,%esi
  800f70:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f73:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f76:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f78:	5b                   	pop    %ebx
  800f79:	5e                   	pop    %esi
  800f7a:	5f                   	pop    %edi
  800f7b:	5d                   	pop    %ebp
  800f7c:	c3                   	ret    

00800f7d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f7d:	55                   	push   %ebp
  800f7e:	89 e5                	mov    %esp,%ebp
  800f80:	57                   	push   %edi
  800f81:	56                   	push   %esi
  800f82:	53                   	push   %ebx
  800f83:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f86:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f93:	89 cb                	mov    %ecx,%ebx
  800f95:	89 cf                	mov    %ecx,%edi
  800f97:	89 ce                	mov    %ecx,%esi
  800f99:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f9b:	85 c0                	test   %eax,%eax
  800f9d:	7f 08                	jg     800fa7 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa2:	5b                   	pop    %ebx
  800fa3:	5e                   	pop    %esi
  800fa4:	5f                   	pop    %edi
  800fa5:	5d                   	pop    %ebp
  800fa6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa7:	83 ec 0c             	sub    $0xc,%esp
  800faa:	50                   	push   %eax
  800fab:	6a 0d                	push   $0xd
  800fad:	68 64 2a 80 00       	push   $0x802a64
  800fb2:	6a 43                	push   $0x43
  800fb4:	68 81 2a 80 00       	push   $0x802a81
  800fb9:	e8 c8 f1 ff ff       	call   800186 <_panic>

00800fbe <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fbe:	55                   	push   %ebp
  800fbf:	89 e5                	mov    %esp,%ebp
  800fc1:	57                   	push   %edi
  800fc2:	56                   	push   %esi
  800fc3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fcf:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fd4:	89 df                	mov    %ebx,%edi
  800fd6:	89 de                	mov    %ebx,%esi
  800fd8:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fda:	5b                   	pop    %ebx
  800fdb:	5e                   	pop    %esi
  800fdc:	5f                   	pop    %edi
  800fdd:	5d                   	pop    %ebp
  800fde:	c3                   	ret    

00800fdf <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	57                   	push   %edi
  800fe3:	56                   	push   %esi
  800fe4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fe5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fea:	8b 55 08             	mov    0x8(%ebp),%edx
  800fed:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ff2:	89 cb                	mov    %ecx,%ebx
  800ff4:	89 cf                	mov    %ecx,%edi
  800ff6:	89 ce                	mov    %ecx,%esi
  800ff8:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800ffa:	5b                   	pop    %ebx
  800ffb:	5e                   	pop    %esi
  800ffc:	5f                   	pop    %edi
  800ffd:	5d                   	pop    %ebp
  800ffe:	c3                   	ret    

00800fff <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
  801002:	57                   	push   %edi
  801003:	56                   	push   %esi
  801004:	53                   	push   %ebx
	asm volatile("int %1\n"
  801005:	ba 00 00 00 00       	mov    $0x0,%edx
  80100a:	b8 10 00 00 00       	mov    $0x10,%eax
  80100f:	89 d1                	mov    %edx,%ecx
  801011:	89 d3                	mov    %edx,%ebx
  801013:	89 d7                	mov    %edx,%edi
  801015:	89 d6                	mov    %edx,%esi
  801017:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801019:	5b                   	pop    %ebx
  80101a:	5e                   	pop    %esi
  80101b:	5f                   	pop    %edi
  80101c:	5d                   	pop    %ebp
  80101d:	c3                   	ret    

0080101e <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	57                   	push   %edi
  801022:	56                   	push   %esi
  801023:	53                   	push   %ebx
	asm volatile("int %1\n"
  801024:	bb 00 00 00 00       	mov    $0x0,%ebx
  801029:	8b 55 08             	mov    0x8(%ebp),%edx
  80102c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102f:	b8 11 00 00 00       	mov    $0x11,%eax
  801034:	89 df                	mov    %ebx,%edi
  801036:	89 de                	mov    %ebx,%esi
  801038:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80103a:	5b                   	pop    %ebx
  80103b:	5e                   	pop    %esi
  80103c:	5f                   	pop    %edi
  80103d:	5d                   	pop    %ebp
  80103e:	c3                   	ret    

0080103f <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80103f:	55                   	push   %ebp
  801040:	89 e5                	mov    %esp,%ebp
  801042:	57                   	push   %edi
  801043:	56                   	push   %esi
  801044:	53                   	push   %ebx
	asm volatile("int %1\n"
  801045:	bb 00 00 00 00       	mov    $0x0,%ebx
  80104a:	8b 55 08             	mov    0x8(%ebp),%edx
  80104d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801050:	b8 12 00 00 00       	mov    $0x12,%eax
  801055:	89 df                	mov    %ebx,%edi
  801057:	89 de                	mov    %ebx,%esi
  801059:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80105b:	5b                   	pop    %ebx
  80105c:	5e                   	pop    %esi
  80105d:	5f                   	pop    %edi
  80105e:	5d                   	pop    %ebp
  80105f:	c3                   	ret    

00801060 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801060:	55                   	push   %ebp
  801061:	89 e5                	mov    %esp,%ebp
  801063:	57                   	push   %edi
  801064:	56                   	push   %esi
  801065:	53                   	push   %ebx
  801066:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801069:	bb 00 00 00 00       	mov    $0x0,%ebx
  80106e:	8b 55 08             	mov    0x8(%ebp),%edx
  801071:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801074:	b8 13 00 00 00       	mov    $0x13,%eax
  801079:	89 df                	mov    %ebx,%edi
  80107b:	89 de                	mov    %ebx,%esi
  80107d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80107f:	85 c0                	test   %eax,%eax
  801081:	7f 08                	jg     80108b <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801083:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801086:	5b                   	pop    %ebx
  801087:	5e                   	pop    %esi
  801088:	5f                   	pop    %edi
  801089:	5d                   	pop    %ebp
  80108a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80108b:	83 ec 0c             	sub    $0xc,%esp
  80108e:	50                   	push   %eax
  80108f:	6a 13                	push   $0x13
  801091:	68 64 2a 80 00       	push   $0x802a64
  801096:	6a 43                	push   $0x43
  801098:	68 81 2a 80 00       	push   $0x802a81
  80109d:	e8 e4 f0 ff ff       	call   800186 <_panic>

008010a2 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
  8010a5:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8010a8:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  8010af:	74 0a                	je     8010bb <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  8010b9:	c9                   	leave  
  8010ba:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8010bb:	83 ec 04             	sub    $0x4,%esp
  8010be:	6a 07                	push   $0x7
  8010c0:	68 00 f0 bf ee       	push   $0xeebff000
  8010c5:	6a 00                	push   $0x0
  8010c7:	e8 01 fd ff ff       	call   800dcd <sys_page_alloc>
		if(r < 0)
  8010cc:	83 c4 10             	add    $0x10,%esp
  8010cf:	85 c0                	test   %eax,%eax
  8010d1:	78 2a                	js     8010fd <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  8010d3:	83 ec 08             	sub    $0x8,%esp
  8010d6:	68 11 11 80 00       	push   $0x801111
  8010db:	6a 00                	push   $0x0
  8010dd:	e8 36 fe ff ff       	call   800f18 <sys_env_set_pgfault_upcall>
		if(r < 0)
  8010e2:	83 c4 10             	add    $0x10,%esp
  8010e5:	85 c0                	test   %eax,%eax
  8010e7:	79 c8                	jns    8010b1 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  8010e9:	83 ec 04             	sub    $0x4,%esp
  8010ec:	68 c0 2a 80 00       	push   $0x802ac0
  8010f1:	6a 25                	push   $0x25
  8010f3:	68 f9 2a 80 00       	push   $0x802af9
  8010f8:	e8 89 f0 ff ff       	call   800186 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8010fd:	83 ec 04             	sub    $0x4,%esp
  801100:	68 90 2a 80 00       	push   $0x802a90
  801105:	6a 22                	push   $0x22
  801107:	68 f9 2a 80 00       	push   $0x802af9
  80110c:	e8 75 f0 ff ff       	call   800186 <_panic>

00801111 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801111:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801112:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  801117:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801119:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  80111c:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  801120:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  801124:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801127:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  801129:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  80112d:	83 c4 08             	add    $0x8,%esp
	popal
  801130:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801131:	83 c4 04             	add    $0x4,%esp
	popfl
  801134:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801135:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801136:	c3                   	ret    

00801137 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	05 00 00 00 30       	add    $0x30000000,%eax
  801142:	c1 e8 0c             	shr    $0xc,%eax
}
  801145:	5d                   	pop    %ebp
  801146:	c3                   	ret    

00801147 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801147:	55                   	push   %ebp
  801148:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801152:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801157:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80115c:	5d                   	pop    %ebp
  80115d:	c3                   	ret    

0080115e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80115e:	55                   	push   %ebp
  80115f:	89 e5                	mov    %esp,%ebp
  801161:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801166:	89 c2                	mov    %eax,%edx
  801168:	c1 ea 16             	shr    $0x16,%edx
  80116b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801172:	f6 c2 01             	test   $0x1,%dl
  801175:	74 2d                	je     8011a4 <fd_alloc+0x46>
  801177:	89 c2                	mov    %eax,%edx
  801179:	c1 ea 0c             	shr    $0xc,%edx
  80117c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801183:	f6 c2 01             	test   $0x1,%dl
  801186:	74 1c                	je     8011a4 <fd_alloc+0x46>
  801188:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80118d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801192:	75 d2                	jne    801166 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801194:	8b 45 08             	mov    0x8(%ebp),%eax
  801197:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80119d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011a2:	eb 0a                	jmp    8011ae <fd_alloc+0x50>
			*fd_store = fd;
  8011a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ae:	5d                   	pop    %ebp
  8011af:	c3                   	ret    

008011b0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011b6:	83 f8 1f             	cmp    $0x1f,%eax
  8011b9:	77 30                	ja     8011eb <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011bb:	c1 e0 0c             	shl    $0xc,%eax
  8011be:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011c3:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8011c9:	f6 c2 01             	test   $0x1,%dl
  8011cc:	74 24                	je     8011f2 <fd_lookup+0x42>
  8011ce:	89 c2                	mov    %eax,%edx
  8011d0:	c1 ea 0c             	shr    $0xc,%edx
  8011d3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011da:	f6 c2 01             	test   $0x1,%dl
  8011dd:	74 1a                	je     8011f9 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011e2:	89 02                	mov    %eax,(%edx)
	return 0;
  8011e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011e9:	5d                   	pop    %ebp
  8011ea:	c3                   	ret    
		return -E_INVAL;
  8011eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f0:	eb f7                	jmp    8011e9 <fd_lookup+0x39>
		return -E_INVAL;
  8011f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f7:	eb f0                	jmp    8011e9 <fd_lookup+0x39>
  8011f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011fe:	eb e9                	jmp    8011e9 <fd_lookup+0x39>

00801200 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	83 ec 08             	sub    $0x8,%esp
  801206:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801209:	ba 00 00 00 00       	mov    $0x0,%edx
  80120e:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801213:	39 08                	cmp    %ecx,(%eax)
  801215:	74 38                	je     80124f <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801217:	83 c2 01             	add    $0x1,%edx
  80121a:	8b 04 95 88 2b 80 00 	mov    0x802b88(,%edx,4),%eax
  801221:	85 c0                	test   %eax,%eax
  801223:	75 ee                	jne    801213 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801225:	a1 08 40 80 00       	mov    0x804008,%eax
  80122a:	8b 40 48             	mov    0x48(%eax),%eax
  80122d:	83 ec 04             	sub    $0x4,%esp
  801230:	51                   	push   %ecx
  801231:	50                   	push   %eax
  801232:	68 08 2b 80 00       	push   $0x802b08
  801237:	e8 40 f0 ff ff       	call   80027c <cprintf>
	*dev = 0;
  80123c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801245:	83 c4 10             	add    $0x10,%esp
  801248:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80124d:	c9                   	leave  
  80124e:	c3                   	ret    
			*dev = devtab[i];
  80124f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801252:	89 01                	mov    %eax,(%ecx)
			return 0;
  801254:	b8 00 00 00 00       	mov    $0x0,%eax
  801259:	eb f2                	jmp    80124d <dev_lookup+0x4d>

0080125b <fd_close>:
{
  80125b:	55                   	push   %ebp
  80125c:	89 e5                	mov    %esp,%ebp
  80125e:	57                   	push   %edi
  80125f:	56                   	push   %esi
  801260:	53                   	push   %ebx
  801261:	83 ec 24             	sub    $0x24,%esp
  801264:	8b 75 08             	mov    0x8(%ebp),%esi
  801267:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80126a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80126d:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80126e:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801274:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801277:	50                   	push   %eax
  801278:	e8 33 ff ff ff       	call   8011b0 <fd_lookup>
  80127d:	89 c3                	mov    %eax,%ebx
  80127f:	83 c4 10             	add    $0x10,%esp
  801282:	85 c0                	test   %eax,%eax
  801284:	78 05                	js     80128b <fd_close+0x30>
	    || fd != fd2)
  801286:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801289:	74 16                	je     8012a1 <fd_close+0x46>
		return (must_exist ? r : 0);
  80128b:	89 f8                	mov    %edi,%eax
  80128d:	84 c0                	test   %al,%al
  80128f:	b8 00 00 00 00       	mov    $0x0,%eax
  801294:	0f 44 d8             	cmove  %eax,%ebx
}
  801297:	89 d8                	mov    %ebx,%eax
  801299:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80129c:	5b                   	pop    %ebx
  80129d:	5e                   	pop    %esi
  80129e:	5f                   	pop    %edi
  80129f:	5d                   	pop    %ebp
  8012a0:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012a1:	83 ec 08             	sub    $0x8,%esp
  8012a4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012a7:	50                   	push   %eax
  8012a8:	ff 36                	pushl  (%esi)
  8012aa:	e8 51 ff ff ff       	call   801200 <dev_lookup>
  8012af:	89 c3                	mov    %eax,%ebx
  8012b1:	83 c4 10             	add    $0x10,%esp
  8012b4:	85 c0                	test   %eax,%eax
  8012b6:	78 1a                	js     8012d2 <fd_close+0x77>
		if (dev->dev_close)
  8012b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012bb:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8012be:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012c3:	85 c0                	test   %eax,%eax
  8012c5:	74 0b                	je     8012d2 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8012c7:	83 ec 0c             	sub    $0xc,%esp
  8012ca:	56                   	push   %esi
  8012cb:	ff d0                	call   *%eax
  8012cd:	89 c3                	mov    %eax,%ebx
  8012cf:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8012d2:	83 ec 08             	sub    $0x8,%esp
  8012d5:	56                   	push   %esi
  8012d6:	6a 00                	push   $0x0
  8012d8:	e8 75 fb ff ff       	call   800e52 <sys_page_unmap>
	return r;
  8012dd:	83 c4 10             	add    $0x10,%esp
  8012e0:	eb b5                	jmp    801297 <fd_close+0x3c>

008012e2 <close>:

int
close(int fdnum)
{
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
  8012e5:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012eb:	50                   	push   %eax
  8012ec:	ff 75 08             	pushl  0x8(%ebp)
  8012ef:	e8 bc fe ff ff       	call   8011b0 <fd_lookup>
  8012f4:	83 c4 10             	add    $0x10,%esp
  8012f7:	85 c0                	test   %eax,%eax
  8012f9:	79 02                	jns    8012fd <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8012fb:	c9                   	leave  
  8012fc:	c3                   	ret    
		return fd_close(fd, 1);
  8012fd:	83 ec 08             	sub    $0x8,%esp
  801300:	6a 01                	push   $0x1
  801302:	ff 75 f4             	pushl  -0xc(%ebp)
  801305:	e8 51 ff ff ff       	call   80125b <fd_close>
  80130a:	83 c4 10             	add    $0x10,%esp
  80130d:	eb ec                	jmp    8012fb <close+0x19>

0080130f <close_all>:

void
close_all(void)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	53                   	push   %ebx
  801313:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801316:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80131b:	83 ec 0c             	sub    $0xc,%esp
  80131e:	53                   	push   %ebx
  80131f:	e8 be ff ff ff       	call   8012e2 <close>
	for (i = 0; i < MAXFD; i++)
  801324:	83 c3 01             	add    $0x1,%ebx
  801327:	83 c4 10             	add    $0x10,%esp
  80132a:	83 fb 20             	cmp    $0x20,%ebx
  80132d:	75 ec                	jne    80131b <close_all+0xc>
}
  80132f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801332:	c9                   	leave  
  801333:	c3                   	ret    

00801334 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801334:	55                   	push   %ebp
  801335:	89 e5                	mov    %esp,%ebp
  801337:	57                   	push   %edi
  801338:	56                   	push   %esi
  801339:	53                   	push   %ebx
  80133a:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80133d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801340:	50                   	push   %eax
  801341:	ff 75 08             	pushl  0x8(%ebp)
  801344:	e8 67 fe ff ff       	call   8011b0 <fd_lookup>
  801349:	89 c3                	mov    %eax,%ebx
  80134b:	83 c4 10             	add    $0x10,%esp
  80134e:	85 c0                	test   %eax,%eax
  801350:	0f 88 81 00 00 00    	js     8013d7 <dup+0xa3>
		return r;
	close(newfdnum);
  801356:	83 ec 0c             	sub    $0xc,%esp
  801359:	ff 75 0c             	pushl  0xc(%ebp)
  80135c:	e8 81 ff ff ff       	call   8012e2 <close>

	newfd = INDEX2FD(newfdnum);
  801361:	8b 75 0c             	mov    0xc(%ebp),%esi
  801364:	c1 e6 0c             	shl    $0xc,%esi
  801367:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80136d:	83 c4 04             	add    $0x4,%esp
  801370:	ff 75 e4             	pushl  -0x1c(%ebp)
  801373:	e8 cf fd ff ff       	call   801147 <fd2data>
  801378:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80137a:	89 34 24             	mov    %esi,(%esp)
  80137d:	e8 c5 fd ff ff       	call   801147 <fd2data>
  801382:	83 c4 10             	add    $0x10,%esp
  801385:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801387:	89 d8                	mov    %ebx,%eax
  801389:	c1 e8 16             	shr    $0x16,%eax
  80138c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801393:	a8 01                	test   $0x1,%al
  801395:	74 11                	je     8013a8 <dup+0x74>
  801397:	89 d8                	mov    %ebx,%eax
  801399:	c1 e8 0c             	shr    $0xc,%eax
  80139c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013a3:	f6 c2 01             	test   $0x1,%dl
  8013a6:	75 39                	jne    8013e1 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013ab:	89 d0                	mov    %edx,%eax
  8013ad:	c1 e8 0c             	shr    $0xc,%eax
  8013b0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013b7:	83 ec 0c             	sub    $0xc,%esp
  8013ba:	25 07 0e 00 00       	and    $0xe07,%eax
  8013bf:	50                   	push   %eax
  8013c0:	56                   	push   %esi
  8013c1:	6a 00                	push   $0x0
  8013c3:	52                   	push   %edx
  8013c4:	6a 00                	push   $0x0
  8013c6:	e8 45 fa ff ff       	call   800e10 <sys_page_map>
  8013cb:	89 c3                	mov    %eax,%ebx
  8013cd:	83 c4 20             	add    $0x20,%esp
  8013d0:	85 c0                	test   %eax,%eax
  8013d2:	78 31                	js     801405 <dup+0xd1>
		goto err;

	return newfdnum;
  8013d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8013d7:	89 d8                	mov    %ebx,%eax
  8013d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013dc:	5b                   	pop    %ebx
  8013dd:	5e                   	pop    %esi
  8013de:	5f                   	pop    %edi
  8013df:	5d                   	pop    %ebp
  8013e0:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013e1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013e8:	83 ec 0c             	sub    $0xc,%esp
  8013eb:	25 07 0e 00 00       	and    $0xe07,%eax
  8013f0:	50                   	push   %eax
  8013f1:	57                   	push   %edi
  8013f2:	6a 00                	push   $0x0
  8013f4:	53                   	push   %ebx
  8013f5:	6a 00                	push   $0x0
  8013f7:	e8 14 fa ff ff       	call   800e10 <sys_page_map>
  8013fc:	89 c3                	mov    %eax,%ebx
  8013fe:	83 c4 20             	add    $0x20,%esp
  801401:	85 c0                	test   %eax,%eax
  801403:	79 a3                	jns    8013a8 <dup+0x74>
	sys_page_unmap(0, newfd);
  801405:	83 ec 08             	sub    $0x8,%esp
  801408:	56                   	push   %esi
  801409:	6a 00                	push   $0x0
  80140b:	e8 42 fa ff ff       	call   800e52 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801410:	83 c4 08             	add    $0x8,%esp
  801413:	57                   	push   %edi
  801414:	6a 00                	push   $0x0
  801416:	e8 37 fa ff ff       	call   800e52 <sys_page_unmap>
	return r;
  80141b:	83 c4 10             	add    $0x10,%esp
  80141e:	eb b7                	jmp    8013d7 <dup+0xa3>

00801420 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
  801423:	53                   	push   %ebx
  801424:	83 ec 1c             	sub    $0x1c,%esp
  801427:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80142a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80142d:	50                   	push   %eax
  80142e:	53                   	push   %ebx
  80142f:	e8 7c fd ff ff       	call   8011b0 <fd_lookup>
  801434:	83 c4 10             	add    $0x10,%esp
  801437:	85 c0                	test   %eax,%eax
  801439:	78 3f                	js     80147a <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80143b:	83 ec 08             	sub    $0x8,%esp
  80143e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801441:	50                   	push   %eax
  801442:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801445:	ff 30                	pushl  (%eax)
  801447:	e8 b4 fd ff ff       	call   801200 <dev_lookup>
  80144c:	83 c4 10             	add    $0x10,%esp
  80144f:	85 c0                	test   %eax,%eax
  801451:	78 27                	js     80147a <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801453:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801456:	8b 42 08             	mov    0x8(%edx),%eax
  801459:	83 e0 03             	and    $0x3,%eax
  80145c:	83 f8 01             	cmp    $0x1,%eax
  80145f:	74 1e                	je     80147f <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801464:	8b 40 08             	mov    0x8(%eax),%eax
  801467:	85 c0                	test   %eax,%eax
  801469:	74 35                	je     8014a0 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80146b:	83 ec 04             	sub    $0x4,%esp
  80146e:	ff 75 10             	pushl  0x10(%ebp)
  801471:	ff 75 0c             	pushl  0xc(%ebp)
  801474:	52                   	push   %edx
  801475:	ff d0                	call   *%eax
  801477:	83 c4 10             	add    $0x10,%esp
}
  80147a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80147d:	c9                   	leave  
  80147e:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80147f:	a1 08 40 80 00       	mov    0x804008,%eax
  801484:	8b 40 48             	mov    0x48(%eax),%eax
  801487:	83 ec 04             	sub    $0x4,%esp
  80148a:	53                   	push   %ebx
  80148b:	50                   	push   %eax
  80148c:	68 4c 2b 80 00       	push   $0x802b4c
  801491:	e8 e6 ed ff ff       	call   80027c <cprintf>
		return -E_INVAL;
  801496:	83 c4 10             	add    $0x10,%esp
  801499:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80149e:	eb da                	jmp    80147a <read+0x5a>
		return -E_NOT_SUPP;
  8014a0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014a5:	eb d3                	jmp    80147a <read+0x5a>

008014a7 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014a7:	55                   	push   %ebp
  8014a8:	89 e5                	mov    %esp,%ebp
  8014aa:	57                   	push   %edi
  8014ab:	56                   	push   %esi
  8014ac:	53                   	push   %ebx
  8014ad:	83 ec 0c             	sub    $0xc,%esp
  8014b0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014b3:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014bb:	39 f3                	cmp    %esi,%ebx
  8014bd:	73 23                	jae    8014e2 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014bf:	83 ec 04             	sub    $0x4,%esp
  8014c2:	89 f0                	mov    %esi,%eax
  8014c4:	29 d8                	sub    %ebx,%eax
  8014c6:	50                   	push   %eax
  8014c7:	89 d8                	mov    %ebx,%eax
  8014c9:	03 45 0c             	add    0xc(%ebp),%eax
  8014cc:	50                   	push   %eax
  8014cd:	57                   	push   %edi
  8014ce:	e8 4d ff ff ff       	call   801420 <read>
		if (m < 0)
  8014d3:	83 c4 10             	add    $0x10,%esp
  8014d6:	85 c0                	test   %eax,%eax
  8014d8:	78 06                	js     8014e0 <readn+0x39>
			return m;
		if (m == 0)
  8014da:	74 06                	je     8014e2 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8014dc:	01 c3                	add    %eax,%ebx
  8014de:	eb db                	jmp    8014bb <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014e0:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8014e2:	89 d8                	mov    %ebx,%eax
  8014e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014e7:	5b                   	pop    %ebx
  8014e8:	5e                   	pop    %esi
  8014e9:	5f                   	pop    %edi
  8014ea:	5d                   	pop    %ebp
  8014eb:	c3                   	ret    

008014ec <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
  8014ef:	53                   	push   %ebx
  8014f0:	83 ec 1c             	sub    $0x1c,%esp
  8014f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014f9:	50                   	push   %eax
  8014fa:	53                   	push   %ebx
  8014fb:	e8 b0 fc ff ff       	call   8011b0 <fd_lookup>
  801500:	83 c4 10             	add    $0x10,%esp
  801503:	85 c0                	test   %eax,%eax
  801505:	78 3a                	js     801541 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801507:	83 ec 08             	sub    $0x8,%esp
  80150a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80150d:	50                   	push   %eax
  80150e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801511:	ff 30                	pushl  (%eax)
  801513:	e8 e8 fc ff ff       	call   801200 <dev_lookup>
  801518:	83 c4 10             	add    $0x10,%esp
  80151b:	85 c0                	test   %eax,%eax
  80151d:	78 22                	js     801541 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80151f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801522:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801526:	74 1e                	je     801546 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801528:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80152b:	8b 52 0c             	mov    0xc(%edx),%edx
  80152e:	85 d2                	test   %edx,%edx
  801530:	74 35                	je     801567 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801532:	83 ec 04             	sub    $0x4,%esp
  801535:	ff 75 10             	pushl  0x10(%ebp)
  801538:	ff 75 0c             	pushl  0xc(%ebp)
  80153b:	50                   	push   %eax
  80153c:	ff d2                	call   *%edx
  80153e:	83 c4 10             	add    $0x10,%esp
}
  801541:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801544:	c9                   	leave  
  801545:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801546:	a1 08 40 80 00       	mov    0x804008,%eax
  80154b:	8b 40 48             	mov    0x48(%eax),%eax
  80154e:	83 ec 04             	sub    $0x4,%esp
  801551:	53                   	push   %ebx
  801552:	50                   	push   %eax
  801553:	68 68 2b 80 00       	push   $0x802b68
  801558:	e8 1f ed ff ff       	call   80027c <cprintf>
		return -E_INVAL;
  80155d:	83 c4 10             	add    $0x10,%esp
  801560:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801565:	eb da                	jmp    801541 <write+0x55>
		return -E_NOT_SUPP;
  801567:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80156c:	eb d3                	jmp    801541 <write+0x55>

0080156e <seek>:

int
seek(int fdnum, off_t offset)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801574:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801577:	50                   	push   %eax
  801578:	ff 75 08             	pushl  0x8(%ebp)
  80157b:	e8 30 fc ff ff       	call   8011b0 <fd_lookup>
  801580:	83 c4 10             	add    $0x10,%esp
  801583:	85 c0                	test   %eax,%eax
  801585:	78 0e                	js     801595 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801587:	8b 55 0c             	mov    0xc(%ebp),%edx
  80158a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80158d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801590:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801595:	c9                   	leave  
  801596:	c3                   	ret    

00801597 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
  80159a:	53                   	push   %ebx
  80159b:	83 ec 1c             	sub    $0x1c,%esp
  80159e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015a4:	50                   	push   %eax
  8015a5:	53                   	push   %ebx
  8015a6:	e8 05 fc ff ff       	call   8011b0 <fd_lookup>
  8015ab:	83 c4 10             	add    $0x10,%esp
  8015ae:	85 c0                	test   %eax,%eax
  8015b0:	78 37                	js     8015e9 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015b2:	83 ec 08             	sub    $0x8,%esp
  8015b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b8:	50                   	push   %eax
  8015b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015bc:	ff 30                	pushl  (%eax)
  8015be:	e8 3d fc ff ff       	call   801200 <dev_lookup>
  8015c3:	83 c4 10             	add    $0x10,%esp
  8015c6:	85 c0                	test   %eax,%eax
  8015c8:	78 1f                	js     8015e9 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015d1:	74 1b                	je     8015ee <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8015d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d6:	8b 52 18             	mov    0x18(%edx),%edx
  8015d9:	85 d2                	test   %edx,%edx
  8015db:	74 32                	je     80160f <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015dd:	83 ec 08             	sub    $0x8,%esp
  8015e0:	ff 75 0c             	pushl  0xc(%ebp)
  8015e3:	50                   	push   %eax
  8015e4:	ff d2                	call   *%edx
  8015e6:	83 c4 10             	add    $0x10,%esp
}
  8015e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015ee:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015f3:	8b 40 48             	mov    0x48(%eax),%eax
  8015f6:	83 ec 04             	sub    $0x4,%esp
  8015f9:	53                   	push   %ebx
  8015fa:	50                   	push   %eax
  8015fb:	68 28 2b 80 00       	push   $0x802b28
  801600:	e8 77 ec ff ff       	call   80027c <cprintf>
		return -E_INVAL;
  801605:	83 c4 10             	add    $0x10,%esp
  801608:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80160d:	eb da                	jmp    8015e9 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80160f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801614:	eb d3                	jmp    8015e9 <ftruncate+0x52>

00801616 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
  801619:	53                   	push   %ebx
  80161a:	83 ec 1c             	sub    $0x1c,%esp
  80161d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801620:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801623:	50                   	push   %eax
  801624:	ff 75 08             	pushl  0x8(%ebp)
  801627:	e8 84 fb ff ff       	call   8011b0 <fd_lookup>
  80162c:	83 c4 10             	add    $0x10,%esp
  80162f:	85 c0                	test   %eax,%eax
  801631:	78 4b                	js     80167e <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801633:	83 ec 08             	sub    $0x8,%esp
  801636:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801639:	50                   	push   %eax
  80163a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163d:	ff 30                	pushl  (%eax)
  80163f:	e8 bc fb ff ff       	call   801200 <dev_lookup>
  801644:	83 c4 10             	add    $0x10,%esp
  801647:	85 c0                	test   %eax,%eax
  801649:	78 33                	js     80167e <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80164b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801652:	74 2f                	je     801683 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801654:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801657:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80165e:	00 00 00 
	stat->st_isdir = 0;
  801661:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801668:	00 00 00 
	stat->st_dev = dev;
  80166b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801671:	83 ec 08             	sub    $0x8,%esp
  801674:	53                   	push   %ebx
  801675:	ff 75 f0             	pushl  -0x10(%ebp)
  801678:	ff 50 14             	call   *0x14(%eax)
  80167b:	83 c4 10             	add    $0x10,%esp
}
  80167e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801681:	c9                   	leave  
  801682:	c3                   	ret    
		return -E_NOT_SUPP;
  801683:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801688:	eb f4                	jmp    80167e <fstat+0x68>

0080168a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
  80168d:	56                   	push   %esi
  80168e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80168f:	83 ec 08             	sub    $0x8,%esp
  801692:	6a 00                	push   $0x0
  801694:	ff 75 08             	pushl  0x8(%ebp)
  801697:	e8 22 02 00 00       	call   8018be <open>
  80169c:	89 c3                	mov    %eax,%ebx
  80169e:	83 c4 10             	add    $0x10,%esp
  8016a1:	85 c0                	test   %eax,%eax
  8016a3:	78 1b                	js     8016c0 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016a5:	83 ec 08             	sub    $0x8,%esp
  8016a8:	ff 75 0c             	pushl  0xc(%ebp)
  8016ab:	50                   	push   %eax
  8016ac:	e8 65 ff ff ff       	call   801616 <fstat>
  8016b1:	89 c6                	mov    %eax,%esi
	close(fd);
  8016b3:	89 1c 24             	mov    %ebx,(%esp)
  8016b6:	e8 27 fc ff ff       	call   8012e2 <close>
	return r;
  8016bb:	83 c4 10             	add    $0x10,%esp
  8016be:	89 f3                	mov    %esi,%ebx
}
  8016c0:	89 d8                	mov    %ebx,%eax
  8016c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016c5:	5b                   	pop    %ebx
  8016c6:	5e                   	pop    %esi
  8016c7:	5d                   	pop    %ebp
  8016c8:	c3                   	ret    

008016c9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
  8016cc:	56                   	push   %esi
  8016cd:	53                   	push   %ebx
  8016ce:	89 c6                	mov    %eax,%esi
  8016d0:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016d2:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8016d9:	74 27                	je     801702 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016db:	6a 07                	push   $0x7
  8016dd:	68 00 50 80 00       	push   $0x805000
  8016e2:	56                   	push   %esi
  8016e3:	ff 35 00 40 80 00    	pushl  0x804000
  8016e9:	e8 08 0c 00 00       	call   8022f6 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016ee:	83 c4 0c             	add    $0xc,%esp
  8016f1:	6a 00                	push   $0x0
  8016f3:	53                   	push   %ebx
  8016f4:	6a 00                	push   $0x0
  8016f6:	e8 92 0b 00 00       	call   80228d <ipc_recv>
}
  8016fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016fe:	5b                   	pop    %ebx
  8016ff:	5e                   	pop    %esi
  801700:	5d                   	pop    %ebp
  801701:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801702:	83 ec 0c             	sub    $0xc,%esp
  801705:	6a 01                	push   $0x1
  801707:	e8 42 0c 00 00       	call   80234e <ipc_find_env>
  80170c:	a3 00 40 80 00       	mov    %eax,0x804000
  801711:	83 c4 10             	add    $0x10,%esp
  801714:	eb c5                	jmp    8016db <fsipc+0x12>

00801716 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
  801719:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80171c:	8b 45 08             	mov    0x8(%ebp),%eax
  80171f:	8b 40 0c             	mov    0xc(%eax),%eax
  801722:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801727:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172a:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80172f:	ba 00 00 00 00       	mov    $0x0,%edx
  801734:	b8 02 00 00 00       	mov    $0x2,%eax
  801739:	e8 8b ff ff ff       	call   8016c9 <fsipc>
}
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <devfile_flush>:
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801746:	8b 45 08             	mov    0x8(%ebp),%eax
  801749:	8b 40 0c             	mov    0xc(%eax),%eax
  80174c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801751:	ba 00 00 00 00       	mov    $0x0,%edx
  801756:	b8 06 00 00 00       	mov    $0x6,%eax
  80175b:	e8 69 ff ff ff       	call   8016c9 <fsipc>
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <devfile_stat>:
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	53                   	push   %ebx
  801766:	83 ec 04             	sub    $0x4,%esp
  801769:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80176c:	8b 45 08             	mov    0x8(%ebp),%eax
  80176f:	8b 40 0c             	mov    0xc(%eax),%eax
  801772:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801777:	ba 00 00 00 00       	mov    $0x0,%edx
  80177c:	b8 05 00 00 00       	mov    $0x5,%eax
  801781:	e8 43 ff ff ff       	call   8016c9 <fsipc>
  801786:	85 c0                	test   %eax,%eax
  801788:	78 2c                	js     8017b6 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80178a:	83 ec 08             	sub    $0x8,%esp
  80178d:	68 00 50 80 00       	push   $0x805000
  801792:	53                   	push   %ebx
  801793:	e8 43 f2 ff ff       	call   8009db <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801798:	a1 80 50 80 00       	mov    0x805080,%eax
  80179d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017a3:	a1 84 50 80 00       	mov    0x805084,%eax
  8017a8:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017ae:	83 c4 10             	add    $0x10,%esp
  8017b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    

008017bb <devfile_write>:
{
  8017bb:	55                   	push   %ebp
  8017bc:	89 e5                	mov    %esp,%ebp
  8017be:	53                   	push   %ebx
  8017bf:	83 ec 08             	sub    $0x8,%esp
  8017c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8017cb:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8017d0:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8017d6:	53                   	push   %ebx
  8017d7:	ff 75 0c             	pushl  0xc(%ebp)
  8017da:	68 08 50 80 00       	push   $0x805008
  8017df:	e8 e7 f3 ff ff       	call   800bcb <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e9:	b8 04 00 00 00       	mov    $0x4,%eax
  8017ee:	e8 d6 fe ff ff       	call   8016c9 <fsipc>
  8017f3:	83 c4 10             	add    $0x10,%esp
  8017f6:	85 c0                	test   %eax,%eax
  8017f8:	78 0b                	js     801805 <devfile_write+0x4a>
	assert(r <= n);
  8017fa:	39 d8                	cmp    %ebx,%eax
  8017fc:	77 0c                	ja     80180a <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8017fe:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801803:	7f 1e                	jg     801823 <devfile_write+0x68>
}
  801805:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801808:	c9                   	leave  
  801809:	c3                   	ret    
	assert(r <= n);
  80180a:	68 9c 2b 80 00       	push   $0x802b9c
  80180f:	68 a3 2b 80 00       	push   $0x802ba3
  801814:	68 98 00 00 00       	push   $0x98
  801819:	68 b8 2b 80 00       	push   $0x802bb8
  80181e:	e8 63 e9 ff ff       	call   800186 <_panic>
	assert(r <= PGSIZE);
  801823:	68 c3 2b 80 00       	push   $0x802bc3
  801828:	68 a3 2b 80 00       	push   $0x802ba3
  80182d:	68 99 00 00 00       	push   $0x99
  801832:	68 b8 2b 80 00       	push   $0x802bb8
  801837:	e8 4a e9 ff ff       	call   800186 <_panic>

0080183c <devfile_read>:
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
  80183f:	56                   	push   %esi
  801840:	53                   	push   %ebx
  801841:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801844:	8b 45 08             	mov    0x8(%ebp),%eax
  801847:	8b 40 0c             	mov    0xc(%eax),%eax
  80184a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80184f:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801855:	ba 00 00 00 00       	mov    $0x0,%edx
  80185a:	b8 03 00 00 00       	mov    $0x3,%eax
  80185f:	e8 65 fe ff ff       	call   8016c9 <fsipc>
  801864:	89 c3                	mov    %eax,%ebx
  801866:	85 c0                	test   %eax,%eax
  801868:	78 1f                	js     801889 <devfile_read+0x4d>
	assert(r <= n);
  80186a:	39 f0                	cmp    %esi,%eax
  80186c:	77 24                	ja     801892 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80186e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801873:	7f 33                	jg     8018a8 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801875:	83 ec 04             	sub    $0x4,%esp
  801878:	50                   	push   %eax
  801879:	68 00 50 80 00       	push   $0x805000
  80187e:	ff 75 0c             	pushl  0xc(%ebp)
  801881:	e8 e3 f2 ff ff       	call   800b69 <memmove>
	return r;
  801886:	83 c4 10             	add    $0x10,%esp
}
  801889:	89 d8                	mov    %ebx,%eax
  80188b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80188e:	5b                   	pop    %ebx
  80188f:	5e                   	pop    %esi
  801890:	5d                   	pop    %ebp
  801891:	c3                   	ret    
	assert(r <= n);
  801892:	68 9c 2b 80 00       	push   $0x802b9c
  801897:	68 a3 2b 80 00       	push   $0x802ba3
  80189c:	6a 7c                	push   $0x7c
  80189e:	68 b8 2b 80 00       	push   $0x802bb8
  8018a3:	e8 de e8 ff ff       	call   800186 <_panic>
	assert(r <= PGSIZE);
  8018a8:	68 c3 2b 80 00       	push   $0x802bc3
  8018ad:	68 a3 2b 80 00       	push   $0x802ba3
  8018b2:	6a 7d                	push   $0x7d
  8018b4:	68 b8 2b 80 00       	push   $0x802bb8
  8018b9:	e8 c8 e8 ff ff       	call   800186 <_panic>

008018be <open>:
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	56                   	push   %esi
  8018c2:	53                   	push   %ebx
  8018c3:	83 ec 1c             	sub    $0x1c,%esp
  8018c6:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018c9:	56                   	push   %esi
  8018ca:	e8 d3 f0 ff ff       	call   8009a2 <strlen>
  8018cf:	83 c4 10             	add    $0x10,%esp
  8018d2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018d7:	7f 6c                	jg     801945 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018d9:	83 ec 0c             	sub    $0xc,%esp
  8018dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018df:	50                   	push   %eax
  8018e0:	e8 79 f8 ff ff       	call   80115e <fd_alloc>
  8018e5:	89 c3                	mov    %eax,%ebx
  8018e7:	83 c4 10             	add    $0x10,%esp
  8018ea:	85 c0                	test   %eax,%eax
  8018ec:	78 3c                	js     80192a <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8018ee:	83 ec 08             	sub    $0x8,%esp
  8018f1:	56                   	push   %esi
  8018f2:	68 00 50 80 00       	push   $0x805000
  8018f7:	e8 df f0 ff ff       	call   8009db <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ff:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801904:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801907:	b8 01 00 00 00       	mov    $0x1,%eax
  80190c:	e8 b8 fd ff ff       	call   8016c9 <fsipc>
  801911:	89 c3                	mov    %eax,%ebx
  801913:	83 c4 10             	add    $0x10,%esp
  801916:	85 c0                	test   %eax,%eax
  801918:	78 19                	js     801933 <open+0x75>
	return fd2num(fd);
  80191a:	83 ec 0c             	sub    $0xc,%esp
  80191d:	ff 75 f4             	pushl  -0xc(%ebp)
  801920:	e8 12 f8 ff ff       	call   801137 <fd2num>
  801925:	89 c3                	mov    %eax,%ebx
  801927:	83 c4 10             	add    $0x10,%esp
}
  80192a:	89 d8                	mov    %ebx,%eax
  80192c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80192f:	5b                   	pop    %ebx
  801930:	5e                   	pop    %esi
  801931:	5d                   	pop    %ebp
  801932:	c3                   	ret    
		fd_close(fd, 0);
  801933:	83 ec 08             	sub    $0x8,%esp
  801936:	6a 00                	push   $0x0
  801938:	ff 75 f4             	pushl  -0xc(%ebp)
  80193b:	e8 1b f9 ff ff       	call   80125b <fd_close>
		return r;
  801940:	83 c4 10             	add    $0x10,%esp
  801943:	eb e5                	jmp    80192a <open+0x6c>
		return -E_BAD_PATH;
  801945:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80194a:	eb de                	jmp    80192a <open+0x6c>

0080194c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801952:	ba 00 00 00 00       	mov    $0x0,%edx
  801957:	b8 08 00 00 00       	mov    $0x8,%eax
  80195c:	e8 68 fd ff ff       	call   8016c9 <fsipc>
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
  801966:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801969:	68 cf 2b 80 00       	push   $0x802bcf
  80196e:	ff 75 0c             	pushl  0xc(%ebp)
  801971:	e8 65 f0 ff ff       	call   8009db <strcpy>
	return 0;
}
  801976:	b8 00 00 00 00       	mov    $0x0,%eax
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <devsock_close>:
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
  801980:	53                   	push   %ebx
  801981:	83 ec 10             	sub    $0x10,%esp
  801984:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801987:	53                   	push   %ebx
  801988:	e8 fc 09 00 00       	call   802389 <pageref>
  80198d:	83 c4 10             	add    $0x10,%esp
		return 0;
  801990:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801995:	83 f8 01             	cmp    $0x1,%eax
  801998:	74 07                	je     8019a1 <devsock_close+0x24>
}
  80199a:	89 d0                	mov    %edx,%eax
  80199c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8019a1:	83 ec 0c             	sub    $0xc,%esp
  8019a4:	ff 73 0c             	pushl  0xc(%ebx)
  8019a7:	e8 b9 02 00 00       	call   801c65 <nsipc_close>
  8019ac:	89 c2                	mov    %eax,%edx
  8019ae:	83 c4 10             	add    $0x10,%esp
  8019b1:	eb e7                	jmp    80199a <devsock_close+0x1d>

008019b3 <devsock_write>:
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
  8019b6:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019b9:	6a 00                	push   $0x0
  8019bb:	ff 75 10             	pushl  0x10(%ebp)
  8019be:	ff 75 0c             	pushl  0xc(%ebp)
  8019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c4:	ff 70 0c             	pushl  0xc(%eax)
  8019c7:	e8 76 03 00 00       	call   801d42 <nsipc_send>
}
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <devsock_read>:
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
  8019d1:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019d4:	6a 00                	push   $0x0
  8019d6:	ff 75 10             	pushl  0x10(%ebp)
  8019d9:	ff 75 0c             	pushl  0xc(%ebp)
  8019dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019df:	ff 70 0c             	pushl  0xc(%eax)
  8019e2:	e8 ef 02 00 00       	call   801cd6 <nsipc_recv>
}
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <fd2sockid>:
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
  8019ec:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8019ef:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8019f2:	52                   	push   %edx
  8019f3:	50                   	push   %eax
  8019f4:	e8 b7 f7 ff ff       	call   8011b0 <fd_lookup>
  8019f9:	83 c4 10             	add    $0x10,%esp
  8019fc:	85 c0                	test   %eax,%eax
  8019fe:	78 10                	js     801a10 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a03:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a09:	39 08                	cmp    %ecx,(%eax)
  801a0b:	75 05                	jne    801a12 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a0d:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    
		return -E_NOT_SUPP;
  801a12:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a17:	eb f7                	jmp    801a10 <fd2sockid+0x27>

00801a19 <alloc_sockfd>:
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
  801a1c:	56                   	push   %esi
  801a1d:	53                   	push   %ebx
  801a1e:	83 ec 1c             	sub    $0x1c,%esp
  801a21:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a23:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a26:	50                   	push   %eax
  801a27:	e8 32 f7 ff ff       	call   80115e <fd_alloc>
  801a2c:	89 c3                	mov    %eax,%ebx
  801a2e:	83 c4 10             	add    $0x10,%esp
  801a31:	85 c0                	test   %eax,%eax
  801a33:	78 43                	js     801a78 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a35:	83 ec 04             	sub    $0x4,%esp
  801a38:	68 07 04 00 00       	push   $0x407
  801a3d:	ff 75 f4             	pushl  -0xc(%ebp)
  801a40:	6a 00                	push   $0x0
  801a42:	e8 86 f3 ff ff       	call   800dcd <sys_page_alloc>
  801a47:	89 c3                	mov    %eax,%ebx
  801a49:	83 c4 10             	add    $0x10,%esp
  801a4c:	85 c0                	test   %eax,%eax
  801a4e:	78 28                	js     801a78 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a53:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a59:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a65:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a68:	83 ec 0c             	sub    $0xc,%esp
  801a6b:	50                   	push   %eax
  801a6c:	e8 c6 f6 ff ff       	call   801137 <fd2num>
  801a71:	89 c3                	mov    %eax,%ebx
  801a73:	83 c4 10             	add    $0x10,%esp
  801a76:	eb 0c                	jmp    801a84 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a78:	83 ec 0c             	sub    $0xc,%esp
  801a7b:	56                   	push   %esi
  801a7c:	e8 e4 01 00 00       	call   801c65 <nsipc_close>
		return r;
  801a81:	83 c4 10             	add    $0x10,%esp
}
  801a84:	89 d8                	mov    %ebx,%eax
  801a86:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a89:	5b                   	pop    %ebx
  801a8a:	5e                   	pop    %esi
  801a8b:	5d                   	pop    %ebp
  801a8c:	c3                   	ret    

00801a8d <accept>:
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
  801a90:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	e8 4e ff ff ff       	call   8019e9 <fd2sockid>
  801a9b:	85 c0                	test   %eax,%eax
  801a9d:	78 1b                	js     801aba <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a9f:	83 ec 04             	sub    $0x4,%esp
  801aa2:	ff 75 10             	pushl  0x10(%ebp)
  801aa5:	ff 75 0c             	pushl  0xc(%ebp)
  801aa8:	50                   	push   %eax
  801aa9:	e8 0e 01 00 00       	call   801bbc <nsipc_accept>
  801aae:	83 c4 10             	add    $0x10,%esp
  801ab1:	85 c0                	test   %eax,%eax
  801ab3:	78 05                	js     801aba <accept+0x2d>
	return alloc_sockfd(r);
  801ab5:	e8 5f ff ff ff       	call   801a19 <alloc_sockfd>
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <bind>:
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	e8 1f ff ff ff       	call   8019e9 <fd2sockid>
  801aca:	85 c0                	test   %eax,%eax
  801acc:	78 12                	js     801ae0 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801ace:	83 ec 04             	sub    $0x4,%esp
  801ad1:	ff 75 10             	pushl  0x10(%ebp)
  801ad4:	ff 75 0c             	pushl  0xc(%ebp)
  801ad7:	50                   	push   %eax
  801ad8:	e8 31 01 00 00       	call   801c0e <nsipc_bind>
  801add:	83 c4 10             	add    $0x10,%esp
}
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <shutdown>:
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aeb:	e8 f9 fe ff ff       	call   8019e9 <fd2sockid>
  801af0:	85 c0                	test   %eax,%eax
  801af2:	78 0f                	js     801b03 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801af4:	83 ec 08             	sub    $0x8,%esp
  801af7:	ff 75 0c             	pushl  0xc(%ebp)
  801afa:	50                   	push   %eax
  801afb:	e8 43 01 00 00       	call   801c43 <nsipc_shutdown>
  801b00:	83 c4 10             	add    $0x10,%esp
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <connect>:
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
  801b08:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	e8 d6 fe ff ff       	call   8019e9 <fd2sockid>
  801b13:	85 c0                	test   %eax,%eax
  801b15:	78 12                	js     801b29 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b17:	83 ec 04             	sub    $0x4,%esp
  801b1a:	ff 75 10             	pushl  0x10(%ebp)
  801b1d:	ff 75 0c             	pushl  0xc(%ebp)
  801b20:	50                   	push   %eax
  801b21:	e8 59 01 00 00       	call   801c7f <nsipc_connect>
  801b26:	83 c4 10             	add    $0x10,%esp
}
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <listen>:
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
  801b2e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	e8 b0 fe ff ff       	call   8019e9 <fd2sockid>
  801b39:	85 c0                	test   %eax,%eax
  801b3b:	78 0f                	js     801b4c <listen+0x21>
	return nsipc_listen(r, backlog);
  801b3d:	83 ec 08             	sub    $0x8,%esp
  801b40:	ff 75 0c             	pushl  0xc(%ebp)
  801b43:	50                   	push   %eax
  801b44:	e8 6b 01 00 00       	call   801cb4 <nsipc_listen>
  801b49:	83 c4 10             	add    $0x10,%esp
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <socket>:

int
socket(int domain, int type, int protocol)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b54:	ff 75 10             	pushl  0x10(%ebp)
  801b57:	ff 75 0c             	pushl  0xc(%ebp)
  801b5a:	ff 75 08             	pushl  0x8(%ebp)
  801b5d:	e8 3e 02 00 00       	call   801da0 <nsipc_socket>
  801b62:	83 c4 10             	add    $0x10,%esp
  801b65:	85 c0                	test   %eax,%eax
  801b67:	78 05                	js     801b6e <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801b69:	e8 ab fe ff ff       	call   801a19 <alloc_sockfd>
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
  801b73:	53                   	push   %ebx
  801b74:	83 ec 04             	sub    $0x4,%esp
  801b77:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b79:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b80:	74 26                	je     801ba8 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b82:	6a 07                	push   $0x7
  801b84:	68 00 60 80 00       	push   $0x806000
  801b89:	53                   	push   %ebx
  801b8a:	ff 35 04 40 80 00    	pushl  0x804004
  801b90:	e8 61 07 00 00       	call   8022f6 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b95:	83 c4 0c             	add    $0xc,%esp
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	e8 ea 06 00 00       	call   80228d <ipc_recv>
}
  801ba3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ba8:	83 ec 0c             	sub    $0xc,%esp
  801bab:	6a 02                	push   $0x2
  801bad:	e8 9c 07 00 00       	call   80234e <ipc_find_env>
  801bb2:	a3 04 40 80 00       	mov    %eax,0x804004
  801bb7:	83 c4 10             	add    $0x10,%esp
  801bba:	eb c6                	jmp    801b82 <nsipc+0x12>

00801bbc <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
  801bbf:	56                   	push   %esi
  801bc0:	53                   	push   %ebx
  801bc1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801bcc:	8b 06                	mov    (%esi),%eax
  801bce:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801bd3:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd8:	e8 93 ff ff ff       	call   801b70 <nsipc>
  801bdd:	89 c3                	mov    %eax,%ebx
  801bdf:	85 c0                	test   %eax,%eax
  801be1:	79 09                	jns    801bec <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801be3:	89 d8                	mov    %ebx,%eax
  801be5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801be8:	5b                   	pop    %ebx
  801be9:	5e                   	pop    %esi
  801bea:	5d                   	pop    %ebp
  801beb:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801bec:	83 ec 04             	sub    $0x4,%esp
  801bef:	ff 35 10 60 80 00    	pushl  0x806010
  801bf5:	68 00 60 80 00       	push   $0x806000
  801bfa:	ff 75 0c             	pushl  0xc(%ebp)
  801bfd:	e8 67 ef ff ff       	call   800b69 <memmove>
		*addrlen = ret->ret_addrlen;
  801c02:	a1 10 60 80 00       	mov    0x806010,%eax
  801c07:	89 06                	mov    %eax,(%esi)
  801c09:	83 c4 10             	add    $0x10,%esp
	return r;
  801c0c:	eb d5                	jmp    801be3 <nsipc_accept+0x27>

00801c0e <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	53                   	push   %ebx
  801c12:	83 ec 08             	sub    $0x8,%esp
  801c15:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c18:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1b:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c20:	53                   	push   %ebx
  801c21:	ff 75 0c             	pushl  0xc(%ebp)
  801c24:	68 04 60 80 00       	push   $0x806004
  801c29:	e8 3b ef ff ff       	call   800b69 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c2e:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c34:	b8 02 00 00 00       	mov    $0x2,%eax
  801c39:	e8 32 ff ff ff       	call   801b70 <nsipc>
}
  801c3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c49:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c54:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801c59:	b8 03 00 00 00       	mov    $0x3,%eax
  801c5e:	e8 0d ff ff ff       	call   801b70 <nsipc>
}
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <nsipc_close>:

int
nsipc_close(int s)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6e:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c73:	b8 04 00 00 00       	mov    $0x4,%eax
  801c78:	e8 f3 fe ff ff       	call   801b70 <nsipc>
}
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	53                   	push   %ebx
  801c83:	83 ec 08             	sub    $0x8,%esp
  801c86:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c91:	53                   	push   %ebx
  801c92:	ff 75 0c             	pushl  0xc(%ebp)
  801c95:	68 04 60 80 00       	push   $0x806004
  801c9a:	e8 ca ee ff ff       	call   800b69 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c9f:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801ca5:	b8 05 00 00 00       	mov    $0x5,%eax
  801caa:	e8 c1 fe ff ff       	call   801b70 <nsipc>
}
  801caf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
  801cb7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801cba:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbd:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc5:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801cca:	b8 06 00 00 00       	mov    $0x6,%eax
  801ccf:	e8 9c fe ff ff       	call   801b70 <nsipc>
}
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
  801cd9:	56                   	push   %esi
  801cda:	53                   	push   %ebx
  801cdb:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801cde:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801ce6:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801cec:	8b 45 14             	mov    0x14(%ebp),%eax
  801cef:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801cf4:	b8 07 00 00 00       	mov    $0x7,%eax
  801cf9:	e8 72 fe ff ff       	call   801b70 <nsipc>
  801cfe:	89 c3                	mov    %eax,%ebx
  801d00:	85 c0                	test   %eax,%eax
  801d02:	78 1f                	js     801d23 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d04:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d09:	7f 21                	jg     801d2c <nsipc_recv+0x56>
  801d0b:	39 c6                	cmp    %eax,%esi
  801d0d:	7c 1d                	jl     801d2c <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d0f:	83 ec 04             	sub    $0x4,%esp
  801d12:	50                   	push   %eax
  801d13:	68 00 60 80 00       	push   $0x806000
  801d18:	ff 75 0c             	pushl  0xc(%ebp)
  801d1b:	e8 49 ee ff ff       	call   800b69 <memmove>
  801d20:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d23:	89 d8                	mov    %ebx,%eax
  801d25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d28:	5b                   	pop    %ebx
  801d29:	5e                   	pop    %esi
  801d2a:	5d                   	pop    %ebp
  801d2b:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d2c:	68 db 2b 80 00       	push   $0x802bdb
  801d31:	68 a3 2b 80 00       	push   $0x802ba3
  801d36:	6a 62                	push   $0x62
  801d38:	68 f0 2b 80 00       	push   $0x802bf0
  801d3d:	e8 44 e4 ff ff       	call   800186 <_panic>

00801d42 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	53                   	push   %ebx
  801d46:	83 ec 04             	sub    $0x4,%esp
  801d49:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4f:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d54:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d5a:	7f 2e                	jg     801d8a <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d5c:	83 ec 04             	sub    $0x4,%esp
  801d5f:	53                   	push   %ebx
  801d60:	ff 75 0c             	pushl  0xc(%ebp)
  801d63:	68 0c 60 80 00       	push   $0x80600c
  801d68:	e8 fc ed ff ff       	call   800b69 <memmove>
	nsipcbuf.send.req_size = size;
  801d6d:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d73:	8b 45 14             	mov    0x14(%ebp),%eax
  801d76:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d7b:	b8 08 00 00 00       	mov    $0x8,%eax
  801d80:	e8 eb fd ff ff       	call   801b70 <nsipc>
}
  801d85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    
	assert(size < 1600);
  801d8a:	68 fc 2b 80 00       	push   $0x802bfc
  801d8f:	68 a3 2b 80 00       	push   $0x802ba3
  801d94:	6a 6d                	push   $0x6d
  801d96:	68 f0 2b 80 00       	push   $0x802bf0
  801d9b:	e8 e6 e3 ff ff       	call   800186 <_panic>

00801da0 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
  801da3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801da6:	8b 45 08             	mov    0x8(%ebp),%eax
  801da9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801dae:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db1:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801db6:	8b 45 10             	mov    0x10(%ebp),%eax
  801db9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801dbe:	b8 09 00 00 00       	mov    $0x9,%eax
  801dc3:	e8 a8 fd ff ff       	call   801b70 <nsipc>
}
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    

00801dca <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
  801dcd:	56                   	push   %esi
  801dce:	53                   	push   %ebx
  801dcf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801dd2:	83 ec 0c             	sub    $0xc,%esp
  801dd5:	ff 75 08             	pushl  0x8(%ebp)
  801dd8:	e8 6a f3 ff ff       	call   801147 <fd2data>
  801ddd:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ddf:	83 c4 08             	add    $0x8,%esp
  801de2:	68 08 2c 80 00       	push   $0x802c08
  801de7:	53                   	push   %ebx
  801de8:	e8 ee eb ff ff       	call   8009db <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ded:	8b 46 04             	mov    0x4(%esi),%eax
  801df0:	2b 06                	sub    (%esi),%eax
  801df2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801df8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801dff:	00 00 00 
	stat->st_dev = &devpipe;
  801e02:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801e09:	30 80 00 
	return 0;
}
  801e0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e11:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e14:	5b                   	pop    %ebx
  801e15:	5e                   	pop    %esi
  801e16:	5d                   	pop    %ebp
  801e17:	c3                   	ret    

00801e18 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	53                   	push   %ebx
  801e1c:	83 ec 0c             	sub    $0xc,%esp
  801e1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e22:	53                   	push   %ebx
  801e23:	6a 00                	push   $0x0
  801e25:	e8 28 f0 ff ff       	call   800e52 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e2a:	89 1c 24             	mov    %ebx,(%esp)
  801e2d:	e8 15 f3 ff ff       	call   801147 <fd2data>
  801e32:	83 c4 08             	add    $0x8,%esp
  801e35:	50                   	push   %eax
  801e36:	6a 00                	push   $0x0
  801e38:	e8 15 f0 ff ff       	call   800e52 <sys_page_unmap>
}
  801e3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <_pipeisclosed>:
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
  801e45:	57                   	push   %edi
  801e46:	56                   	push   %esi
  801e47:	53                   	push   %ebx
  801e48:	83 ec 1c             	sub    $0x1c,%esp
  801e4b:	89 c7                	mov    %eax,%edi
  801e4d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e4f:	a1 08 40 80 00       	mov    0x804008,%eax
  801e54:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e57:	83 ec 0c             	sub    $0xc,%esp
  801e5a:	57                   	push   %edi
  801e5b:	e8 29 05 00 00       	call   802389 <pageref>
  801e60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e63:	89 34 24             	mov    %esi,(%esp)
  801e66:	e8 1e 05 00 00       	call   802389 <pageref>
		nn = thisenv->env_runs;
  801e6b:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801e71:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e74:	83 c4 10             	add    $0x10,%esp
  801e77:	39 cb                	cmp    %ecx,%ebx
  801e79:	74 1b                	je     801e96 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e7b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e7e:	75 cf                	jne    801e4f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e80:	8b 42 58             	mov    0x58(%edx),%eax
  801e83:	6a 01                	push   $0x1
  801e85:	50                   	push   %eax
  801e86:	53                   	push   %ebx
  801e87:	68 0f 2c 80 00       	push   $0x802c0f
  801e8c:	e8 eb e3 ff ff       	call   80027c <cprintf>
  801e91:	83 c4 10             	add    $0x10,%esp
  801e94:	eb b9                	jmp    801e4f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e96:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e99:	0f 94 c0             	sete   %al
  801e9c:	0f b6 c0             	movzbl %al,%eax
}
  801e9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ea2:	5b                   	pop    %ebx
  801ea3:	5e                   	pop    %esi
  801ea4:	5f                   	pop    %edi
  801ea5:	5d                   	pop    %ebp
  801ea6:	c3                   	ret    

00801ea7 <devpipe_write>:
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
  801eaa:	57                   	push   %edi
  801eab:	56                   	push   %esi
  801eac:	53                   	push   %ebx
  801ead:	83 ec 28             	sub    $0x28,%esp
  801eb0:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801eb3:	56                   	push   %esi
  801eb4:	e8 8e f2 ff ff       	call   801147 <fd2data>
  801eb9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ebb:	83 c4 10             	add    $0x10,%esp
  801ebe:	bf 00 00 00 00       	mov    $0x0,%edi
  801ec3:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ec6:	74 4f                	je     801f17 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ec8:	8b 43 04             	mov    0x4(%ebx),%eax
  801ecb:	8b 0b                	mov    (%ebx),%ecx
  801ecd:	8d 51 20             	lea    0x20(%ecx),%edx
  801ed0:	39 d0                	cmp    %edx,%eax
  801ed2:	72 14                	jb     801ee8 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ed4:	89 da                	mov    %ebx,%edx
  801ed6:	89 f0                	mov    %esi,%eax
  801ed8:	e8 65 ff ff ff       	call   801e42 <_pipeisclosed>
  801edd:	85 c0                	test   %eax,%eax
  801edf:	75 3b                	jne    801f1c <devpipe_write+0x75>
			sys_yield();
  801ee1:	e8 c8 ee ff ff       	call   800dae <sys_yield>
  801ee6:	eb e0                	jmp    801ec8 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ee8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801eeb:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801eef:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ef2:	89 c2                	mov    %eax,%edx
  801ef4:	c1 fa 1f             	sar    $0x1f,%edx
  801ef7:	89 d1                	mov    %edx,%ecx
  801ef9:	c1 e9 1b             	shr    $0x1b,%ecx
  801efc:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801eff:	83 e2 1f             	and    $0x1f,%edx
  801f02:	29 ca                	sub    %ecx,%edx
  801f04:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f08:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f0c:	83 c0 01             	add    $0x1,%eax
  801f0f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f12:	83 c7 01             	add    $0x1,%edi
  801f15:	eb ac                	jmp    801ec3 <devpipe_write+0x1c>
	return i;
  801f17:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1a:	eb 05                	jmp    801f21 <devpipe_write+0x7a>
				return 0;
  801f1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f24:	5b                   	pop    %ebx
  801f25:	5e                   	pop    %esi
  801f26:	5f                   	pop    %edi
  801f27:	5d                   	pop    %ebp
  801f28:	c3                   	ret    

00801f29 <devpipe_read>:
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
  801f2c:	57                   	push   %edi
  801f2d:	56                   	push   %esi
  801f2e:	53                   	push   %ebx
  801f2f:	83 ec 18             	sub    $0x18,%esp
  801f32:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f35:	57                   	push   %edi
  801f36:	e8 0c f2 ff ff       	call   801147 <fd2data>
  801f3b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f3d:	83 c4 10             	add    $0x10,%esp
  801f40:	be 00 00 00 00       	mov    $0x0,%esi
  801f45:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f48:	75 14                	jne    801f5e <devpipe_read+0x35>
	return i;
  801f4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f4d:	eb 02                	jmp    801f51 <devpipe_read+0x28>
				return i;
  801f4f:	89 f0                	mov    %esi,%eax
}
  801f51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f54:	5b                   	pop    %ebx
  801f55:	5e                   	pop    %esi
  801f56:	5f                   	pop    %edi
  801f57:	5d                   	pop    %ebp
  801f58:	c3                   	ret    
			sys_yield();
  801f59:	e8 50 ee ff ff       	call   800dae <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801f5e:	8b 03                	mov    (%ebx),%eax
  801f60:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f63:	75 18                	jne    801f7d <devpipe_read+0x54>
			if (i > 0)
  801f65:	85 f6                	test   %esi,%esi
  801f67:	75 e6                	jne    801f4f <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801f69:	89 da                	mov    %ebx,%edx
  801f6b:	89 f8                	mov    %edi,%eax
  801f6d:	e8 d0 fe ff ff       	call   801e42 <_pipeisclosed>
  801f72:	85 c0                	test   %eax,%eax
  801f74:	74 e3                	je     801f59 <devpipe_read+0x30>
				return 0;
  801f76:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7b:	eb d4                	jmp    801f51 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f7d:	99                   	cltd   
  801f7e:	c1 ea 1b             	shr    $0x1b,%edx
  801f81:	01 d0                	add    %edx,%eax
  801f83:	83 e0 1f             	and    $0x1f,%eax
  801f86:	29 d0                	sub    %edx,%eax
  801f88:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f90:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f93:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f96:	83 c6 01             	add    $0x1,%esi
  801f99:	eb aa                	jmp    801f45 <devpipe_read+0x1c>

00801f9b <pipe>:
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	56                   	push   %esi
  801f9f:	53                   	push   %ebx
  801fa0:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801fa3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa6:	50                   	push   %eax
  801fa7:	e8 b2 f1 ff ff       	call   80115e <fd_alloc>
  801fac:	89 c3                	mov    %eax,%ebx
  801fae:	83 c4 10             	add    $0x10,%esp
  801fb1:	85 c0                	test   %eax,%eax
  801fb3:	0f 88 23 01 00 00    	js     8020dc <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fb9:	83 ec 04             	sub    $0x4,%esp
  801fbc:	68 07 04 00 00       	push   $0x407
  801fc1:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc4:	6a 00                	push   $0x0
  801fc6:	e8 02 ee ff ff       	call   800dcd <sys_page_alloc>
  801fcb:	89 c3                	mov    %eax,%ebx
  801fcd:	83 c4 10             	add    $0x10,%esp
  801fd0:	85 c0                	test   %eax,%eax
  801fd2:	0f 88 04 01 00 00    	js     8020dc <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801fd8:	83 ec 0c             	sub    $0xc,%esp
  801fdb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fde:	50                   	push   %eax
  801fdf:	e8 7a f1 ff ff       	call   80115e <fd_alloc>
  801fe4:	89 c3                	mov    %eax,%ebx
  801fe6:	83 c4 10             	add    $0x10,%esp
  801fe9:	85 c0                	test   %eax,%eax
  801feb:	0f 88 db 00 00 00    	js     8020cc <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ff1:	83 ec 04             	sub    $0x4,%esp
  801ff4:	68 07 04 00 00       	push   $0x407
  801ff9:	ff 75 f0             	pushl  -0x10(%ebp)
  801ffc:	6a 00                	push   $0x0
  801ffe:	e8 ca ed ff ff       	call   800dcd <sys_page_alloc>
  802003:	89 c3                	mov    %eax,%ebx
  802005:	83 c4 10             	add    $0x10,%esp
  802008:	85 c0                	test   %eax,%eax
  80200a:	0f 88 bc 00 00 00    	js     8020cc <pipe+0x131>
	va = fd2data(fd0);
  802010:	83 ec 0c             	sub    $0xc,%esp
  802013:	ff 75 f4             	pushl  -0xc(%ebp)
  802016:	e8 2c f1 ff ff       	call   801147 <fd2data>
  80201b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80201d:	83 c4 0c             	add    $0xc,%esp
  802020:	68 07 04 00 00       	push   $0x407
  802025:	50                   	push   %eax
  802026:	6a 00                	push   $0x0
  802028:	e8 a0 ed ff ff       	call   800dcd <sys_page_alloc>
  80202d:	89 c3                	mov    %eax,%ebx
  80202f:	83 c4 10             	add    $0x10,%esp
  802032:	85 c0                	test   %eax,%eax
  802034:	0f 88 82 00 00 00    	js     8020bc <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80203a:	83 ec 0c             	sub    $0xc,%esp
  80203d:	ff 75 f0             	pushl  -0x10(%ebp)
  802040:	e8 02 f1 ff ff       	call   801147 <fd2data>
  802045:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80204c:	50                   	push   %eax
  80204d:	6a 00                	push   $0x0
  80204f:	56                   	push   %esi
  802050:	6a 00                	push   $0x0
  802052:	e8 b9 ed ff ff       	call   800e10 <sys_page_map>
  802057:	89 c3                	mov    %eax,%ebx
  802059:	83 c4 20             	add    $0x20,%esp
  80205c:	85 c0                	test   %eax,%eax
  80205e:	78 4e                	js     8020ae <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802060:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802065:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802068:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80206a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80206d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802074:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802077:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802079:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802083:	83 ec 0c             	sub    $0xc,%esp
  802086:	ff 75 f4             	pushl  -0xc(%ebp)
  802089:	e8 a9 f0 ff ff       	call   801137 <fd2num>
  80208e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802091:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802093:	83 c4 04             	add    $0x4,%esp
  802096:	ff 75 f0             	pushl  -0x10(%ebp)
  802099:	e8 99 f0 ff ff       	call   801137 <fd2num>
  80209e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020a1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8020a4:	83 c4 10             	add    $0x10,%esp
  8020a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020ac:	eb 2e                	jmp    8020dc <pipe+0x141>
	sys_page_unmap(0, va);
  8020ae:	83 ec 08             	sub    $0x8,%esp
  8020b1:	56                   	push   %esi
  8020b2:	6a 00                	push   $0x0
  8020b4:	e8 99 ed ff ff       	call   800e52 <sys_page_unmap>
  8020b9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8020bc:	83 ec 08             	sub    $0x8,%esp
  8020bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8020c2:	6a 00                	push   $0x0
  8020c4:	e8 89 ed ff ff       	call   800e52 <sys_page_unmap>
  8020c9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8020cc:	83 ec 08             	sub    $0x8,%esp
  8020cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8020d2:	6a 00                	push   $0x0
  8020d4:	e8 79 ed ff ff       	call   800e52 <sys_page_unmap>
  8020d9:	83 c4 10             	add    $0x10,%esp
}
  8020dc:	89 d8                	mov    %ebx,%eax
  8020de:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020e1:	5b                   	pop    %ebx
  8020e2:	5e                   	pop    %esi
  8020e3:	5d                   	pop    %ebp
  8020e4:	c3                   	ret    

008020e5 <pipeisclosed>:
{
  8020e5:	55                   	push   %ebp
  8020e6:	89 e5                	mov    %esp,%ebp
  8020e8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ee:	50                   	push   %eax
  8020ef:	ff 75 08             	pushl  0x8(%ebp)
  8020f2:	e8 b9 f0 ff ff       	call   8011b0 <fd_lookup>
  8020f7:	83 c4 10             	add    $0x10,%esp
  8020fa:	85 c0                	test   %eax,%eax
  8020fc:	78 18                	js     802116 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8020fe:	83 ec 0c             	sub    $0xc,%esp
  802101:	ff 75 f4             	pushl  -0xc(%ebp)
  802104:	e8 3e f0 ff ff       	call   801147 <fd2data>
	return _pipeisclosed(fd, p);
  802109:	89 c2                	mov    %eax,%edx
  80210b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210e:	e8 2f fd ff ff       	call   801e42 <_pipeisclosed>
  802113:	83 c4 10             	add    $0x10,%esp
}
  802116:	c9                   	leave  
  802117:	c3                   	ret    

00802118 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802118:	b8 00 00 00 00       	mov    $0x0,%eax
  80211d:	c3                   	ret    

0080211e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
  802121:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802124:	68 27 2c 80 00       	push   $0x802c27
  802129:	ff 75 0c             	pushl  0xc(%ebp)
  80212c:	e8 aa e8 ff ff       	call   8009db <strcpy>
	return 0;
}
  802131:	b8 00 00 00 00       	mov    $0x0,%eax
  802136:	c9                   	leave  
  802137:	c3                   	ret    

00802138 <devcons_write>:
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
  80213b:	57                   	push   %edi
  80213c:	56                   	push   %esi
  80213d:	53                   	push   %ebx
  80213e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802144:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802149:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80214f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802152:	73 31                	jae    802185 <devcons_write+0x4d>
		m = n - tot;
  802154:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802157:	29 f3                	sub    %esi,%ebx
  802159:	83 fb 7f             	cmp    $0x7f,%ebx
  80215c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802161:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802164:	83 ec 04             	sub    $0x4,%esp
  802167:	53                   	push   %ebx
  802168:	89 f0                	mov    %esi,%eax
  80216a:	03 45 0c             	add    0xc(%ebp),%eax
  80216d:	50                   	push   %eax
  80216e:	57                   	push   %edi
  80216f:	e8 f5 e9 ff ff       	call   800b69 <memmove>
		sys_cputs(buf, m);
  802174:	83 c4 08             	add    $0x8,%esp
  802177:	53                   	push   %ebx
  802178:	57                   	push   %edi
  802179:	e8 93 eb ff ff       	call   800d11 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80217e:	01 de                	add    %ebx,%esi
  802180:	83 c4 10             	add    $0x10,%esp
  802183:	eb ca                	jmp    80214f <devcons_write+0x17>
}
  802185:	89 f0                	mov    %esi,%eax
  802187:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80218a:	5b                   	pop    %ebx
  80218b:	5e                   	pop    %esi
  80218c:	5f                   	pop    %edi
  80218d:	5d                   	pop    %ebp
  80218e:	c3                   	ret    

0080218f <devcons_read>:
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
  802192:	83 ec 08             	sub    $0x8,%esp
  802195:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80219a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80219e:	74 21                	je     8021c1 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8021a0:	e8 8a eb ff ff       	call   800d2f <sys_cgetc>
  8021a5:	85 c0                	test   %eax,%eax
  8021a7:	75 07                	jne    8021b0 <devcons_read+0x21>
		sys_yield();
  8021a9:	e8 00 ec ff ff       	call   800dae <sys_yield>
  8021ae:	eb f0                	jmp    8021a0 <devcons_read+0x11>
	if (c < 0)
  8021b0:	78 0f                	js     8021c1 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8021b2:	83 f8 04             	cmp    $0x4,%eax
  8021b5:	74 0c                	je     8021c3 <devcons_read+0x34>
	*(char*)vbuf = c;
  8021b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ba:	88 02                	mov    %al,(%edx)
	return 1;
  8021bc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8021c1:	c9                   	leave  
  8021c2:	c3                   	ret    
		return 0;
  8021c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c8:	eb f7                	jmp    8021c1 <devcons_read+0x32>

008021ca <cputchar>:
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
  8021cd:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d3:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8021d6:	6a 01                	push   $0x1
  8021d8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021db:	50                   	push   %eax
  8021dc:	e8 30 eb ff ff       	call   800d11 <sys_cputs>
}
  8021e1:	83 c4 10             	add    $0x10,%esp
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    

008021e6 <getchar>:
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
  8021e9:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8021ec:	6a 01                	push   $0x1
  8021ee:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021f1:	50                   	push   %eax
  8021f2:	6a 00                	push   $0x0
  8021f4:	e8 27 f2 ff ff       	call   801420 <read>
	if (r < 0)
  8021f9:	83 c4 10             	add    $0x10,%esp
  8021fc:	85 c0                	test   %eax,%eax
  8021fe:	78 06                	js     802206 <getchar+0x20>
	if (r < 1)
  802200:	74 06                	je     802208 <getchar+0x22>
	return c;
  802202:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802206:	c9                   	leave  
  802207:	c3                   	ret    
		return -E_EOF;
  802208:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80220d:	eb f7                	jmp    802206 <getchar+0x20>

0080220f <iscons>:
{
  80220f:	55                   	push   %ebp
  802210:	89 e5                	mov    %esp,%ebp
  802212:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802215:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802218:	50                   	push   %eax
  802219:	ff 75 08             	pushl  0x8(%ebp)
  80221c:	e8 8f ef ff ff       	call   8011b0 <fd_lookup>
  802221:	83 c4 10             	add    $0x10,%esp
  802224:	85 c0                	test   %eax,%eax
  802226:	78 11                	js     802239 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802231:	39 10                	cmp    %edx,(%eax)
  802233:	0f 94 c0             	sete   %al
  802236:	0f b6 c0             	movzbl %al,%eax
}
  802239:	c9                   	leave  
  80223a:	c3                   	ret    

0080223b <opencons>:
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
  80223e:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802241:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802244:	50                   	push   %eax
  802245:	e8 14 ef ff ff       	call   80115e <fd_alloc>
  80224a:	83 c4 10             	add    $0x10,%esp
  80224d:	85 c0                	test   %eax,%eax
  80224f:	78 3a                	js     80228b <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802251:	83 ec 04             	sub    $0x4,%esp
  802254:	68 07 04 00 00       	push   $0x407
  802259:	ff 75 f4             	pushl  -0xc(%ebp)
  80225c:	6a 00                	push   $0x0
  80225e:	e8 6a eb ff ff       	call   800dcd <sys_page_alloc>
  802263:	83 c4 10             	add    $0x10,%esp
  802266:	85 c0                	test   %eax,%eax
  802268:	78 21                	js     80228b <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80226a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226d:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802273:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802278:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80227f:	83 ec 0c             	sub    $0xc,%esp
  802282:	50                   	push   %eax
  802283:	e8 af ee ff ff       	call   801137 <fd2num>
  802288:	83 c4 10             	add    $0x10,%esp
}
  80228b:	c9                   	leave  
  80228c:	c3                   	ret    

0080228d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
  802290:	56                   	push   %esi
  802291:	53                   	push   %ebx
  802292:	8b 75 08             	mov    0x8(%ebp),%esi
  802295:	8b 45 0c             	mov    0xc(%ebp),%eax
  802298:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80229b:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80229d:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022a2:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8022a5:	83 ec 0c             	sub    $0xc,%esp
  8022a8:	50                   	push   %eax
  8022a9:	e8 cf ec ff ff       	call   800f7d <sys_ipc_recv>
	if(ret < 0){
  8022ae:	83 c4 10             	add    $0x10,%esp
  8022b1:	85 c0                	test   %eax,%eax
  8022b3:	78 2b                	js     8022e0 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8022b5:	85 f6                	test   %esi,%esi
  8022b7:	74 0a                	je     8022c3 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8022b9:	a1 08 40 80 00       	mov    0x804008,%eax
  8022be:	8b 40 74             	mov    0x74(%eax),%eax
  8022c1:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8022c3:	85 db                	test   %ebx,%ebx
  8022c5:	74 0a                	je     8022d1 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8022c7:	a1 08 40 80 00       	mov    0x804008,%eax
  8022cc:	8b 40 78             	mov    0x78(%eax),%eax
  8022cf:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8022d1:	a1 08 40 80 00       	mov    0x804008,%eax
  8022d6:	8b 40 70             	mov    0x70(%eax),%eax
}
  8022d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022dc:	5b                   	pop    %ebx
  8022dd:	5e                   	pop    %esi
  8022de:	5d                   	pop    %ebp
  8022df:	c3                   	ret    
		if(from_env_store)
  8022e0:	85 f6                	test   %esi,%esi
  8022e2:	74 06                	je     8022ea <ipc_recv+0x5d>
			*from_env_store = 0;
  8022e4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8022ea:	85 db                	test   %ebx,%ebx
  8022ec:	74 eb                	je     8022d9 <ipc_recv+0x4c>
			*perm_store = 0;
  8022ee:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022f4:	eb e3                	jmp    8022d9 <ipc_recv+0x4c>

008022f6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
  8022f9:	57                   	push   %edi
  8022fa:	56                   	push   %esi
  8022fb:	53                   	push   %ebx
  8022fc:	83 ec 0c             	sub    $0xc,%esp
  8022ff:	8b 7d 08             	mov    0x8(%ebp),%edi
  802302:	8b 75 0c             	mov    0xc(%ebp),%esi
  802305:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802308:	85 db                	test   %ebx,%ebx
  80230a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80230f:	0f 44 d8             	cmove  %eax,%ebx
  802312:	eb 05                	jmp    802319 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802314:	e8 95 ea ff ff       	call   800dae <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802319:	ff 75 14             	pushl  0x14(%ebp)
  80231c:	53                   	push   %ebx
  80231d:	56                   	push   %esi
  80231e:	57                   	push   %edi
  80231f:	e8 36 ec ff ff       	call   800f5a <sys_ipc_try_send>
  802324:	83 c4 10             	add    $0x10,%esp
  802327:	85 c0                	test   %eax,%eax
  802329:	74 1b                	je     802346 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80232b:	79 e7                	jns    802314 <ipc_send+0x1e>
  80232d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802330:	74 e2                	je     802314 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802332:	83 ec 04             	sub    $0x4,%esp
  802335:	68 33 2c 80 00       	push   $0x802c33
  80233a:	6a 48                	push   $0x48
  80233c:	68 48 2c 80 00       	push   $0x802c48
  802341:	e8 40 de ff ff       	call   800186 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802346:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802349:	5b                   	pop    %ebx
  80234a:	5e                   	pop    %esi
  80234b:	5f                   	pop    %edi
  80234c:	5d                   	pop    %ebp
  80234d:	c3                   	ret    

0080234e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
  802351:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802354:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802359:	89 c2                	mov    %eax,%edx
  80235b:	c1 e2 07             	shl    $0x7,%edx
  80235e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802364:	8b 52 50             	mov    0x50(%edx),%edx
  802367:	39 ca                	cmp    %ecx,%edx
  802369:	74 11                	je     80237c <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  80236b:	83 c0 01             	add    $0x1,%eax
  80236e:	3d 00 04 00 00       	cmp    $0x400,%eax
  802373:	75 e4                	jne    802359 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802375:	b8 00 00 00 00       	mov    $0x0,%eax
  80237a:	eb 0b                	jmp    802387 <ipc_find_env+0x39>
			return envs[i].env_id;
  80237c:	c1 e0 07             	shl    $0x7,%eax
  80237f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802384:	8b 40 48             	mov    0x48(%eax),%eax
}
  802387:	5d                   	pop    %ebp
  802388:	c3                   	ret    

00802389 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802389:	55                   	push   %ebp
  80238a:	89 e5                	mov    %esp,%ebp
  80238c:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80238f:	89 d0                	mov    %edx,%eax
  802391:	c1 e8 16             	shr    $0x16,%eax
  802394:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80239b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8023a0:	f6 c1 01             	test   $0x1,%cl
  8023a3:	74 1d                	je     8023c2 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8023a5:	c1 ea 0c             	shr    $0xc,%edx
  8023a8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023af:	f6 c2 01             	test   $0x1,%dl
  8023b2:	74 0e                	je     8023c2 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023b4:	c1 ea 0c             	shr    $0xc,%edx
  8023b7:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023be:	ef 
  8023bf:	0f b7 c0             	movzwl %ax,%eax
}
  8023c2:	5d                   	pop    %ebp
  8023c3:	c3                   	ret    
  8023c4:	66 90                	xchg   %ax,%ax
  8023c6:	66 90                	xchg   %ax,%ax
  8023c8:	66 90                	xchg   %ax,%ax
  8023ca:	66 90                	xchg   %ax,%ax
  8023cc:	66 90                	xchg   %ax,%ax
  8023ce:	66 90                	xchg   %ax,%ax

008023d0 <__udivdi3>:
  8023d0:	55                   	push   %ebp
  8023d1:	57                   	push   %edi
  8023d2:	56                   	push   %esi
  8023d3:	53                   	push   %ebx
  8023d4:	83 ec 1c             	sub    $0x1c,%esp
  8023d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8023db:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8023df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023e3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8023e7:	85 d2                	test   %edx,%edx
  8023e9:	75 4d                	jne    802438 <__udivdi3+0x68>
  8023eb:	39 f3                	cmp    %esi,%ebx
  8023ed:	76 19                	jbe    802408 <__udivdi3+0x38>
  8023ef:	31 ff                	xor    %edi,%edi
  8023f1:	89 e8                	mov    %ebp,%eax
  8023f3:	89 f2                	mov    %esi,%edx
  8023f5:	f7 f3                	div    %ebx
  8023f7:	89 fa                	mov    %edi,%edx
  8023f9:	83 c4 1c             	add    $0x1c,%esp
  8023fc:	5b                   	pop    %ebx
  8023fd:	5e                   	pop    %esi
  8023fe:	5f                   	pop    %edi
  8023ff:	5d                   	pop    %ebp
  802400:	c3                   	ret    
  802401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802408:	89 d9                	mov    %ebx,%ecx
  80240a:	85 db                	test   %ebx,%ebx
  80240c:	75 0b                	jne    802419 <__udivdi3+0x49>
  80240e:	b8 01 00 00 00       	mov    $0x1,%eax
  802413:	31 d2                	xor    %edx,%edx
  802415:	f7 f3                	div    %ebx
  802417:	89 c1                	mov    %eax,%ecx
  802419:	31 d2                	xor    %edx,%edx
  80241b:	89 f0                	mov    %esi,%eax
  80241d:	f7 f1                	div    %ecx
  80241f:	89 c6                	mov    %eax,%esi
  802421:	89 e8                	mov    %ebp,%eax
  802423:	89 f7                	mov    %esi,%edi
  802425:	f7 f1                	div    %ecx
  802427:	89 fa                	mov    %edi,%edx
  802429:	83 c4 1c             	add    $0x1c,%esp
  80242c:	5b                   	pop    %ebx
  80242d:	5e                   	pop    %esi
  80242e:	5f                   	pop    %edi
  80242f:	5d                   	pop    %ebp
  802430:	c3                   	ret    
  802431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802438:	39 f2                	cmp    %esi,%edx
  80243a:	77 1c                	ja     802458 <__udivdi3+0x88>
  80243c:	0f bd fa             	bsr    %edx,%edi
  80243f:	83 f7 1f             	xor    $0x1f,%edi
  802442:	75 2c                	jne    802470 <__udivdi3+0xa0>
  802444:	39 f2                	cmp    %esi,%edx
  802446:	72 06                	jb     80244e <__udivdi3+0x7e>
  802448:	31 c0                	xor    %eax,%eax
  80244a:	39 eb                	cmp    %ebp,%ebx
  80244c:	77 a9                	ja     8023f7 <__udivdi3+0x27>
  80244e:	b8 01 00 00 00       	mov    $0x1,%eax
  802453:	eb a2                	jmp    8023f7 <__udivdi3+0x27>
  802455:	8d 76 00             	lea    0x0(%esi),%esi
  802458:	31 ff                	xor    %edi,%edi
  80245a:	31 c0                	xor    %eax,%eax
  80245c:	89 fa                	mov    %edi,%edx
  80245e:	83 c4 1c             	add    $0x1c,%esp
  802461:	5b                   	pop    %ebx
  802462:	5e                   	pop    %esi
  802463:	5f                   	pop    %edi
  802464:	5d                   	pop    %ebp
  802465:	c3                   	ret    
  802466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80246d:	8d 76 00             	lea    0x0(%esi),%esi
  802470:	89 f9                	mov    %edi,%ecx
  802472:	b8 20 00 00 00       	mov    $0x20,%eax
  802477:	29 f8                	sub    %edi,%eax
  802479:	d3 e2                	shl    %cl,%edx
  80247b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80247f:	89 c1                	mov    %eax,%ecx
  802481:	89 da                	mov    %ebx,%edx
  802483:	d3 ea                	shr    %cl,%edx
  802485:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802489:	09 d1                	or     %edx,%ecx
  80248b:	89 f2                	mov    %esi,%edx
  80248d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802491:	89 f9                	mov    %edi,%ecx
  802493:	d3 e3                	shl    %cl,%ebx
  802495:	89 c1                	mov    %eax,%ecx
  802497:	d3 ea                	shr    %cl,%edx
  802499:	89 f9                	mov    %edi,%ecx
  80249b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80249f:	89 eb                	mov    %ebp,%ebx
  8024a1:	d3 e6                	shl    %cl,%esi
  8024a3:	89 c1                	mov    %eax,%ecx
  8024a5:	d3 eb                	shr    %cl,%ebx
  8024a7:	09 de                	or     %ebx,%esi
  8024a9:	89 f0                	mov    %esi,%eax
  8024ab:	f7 74 24 08          	divl   0x8(%esp)
  8024af:	89 d6                	mov    %edx,%esi
  8024b1:	89 c3                	mov    %eax,%ebx
  8024b3:	f7 64 24 0c          	mull   0xc(%esp)
  8024b7:	39 d6                	cmp    %edx,%esi
  8024b9:	72 15                	jb     8024d0 <__udivdi3+0x100>
  8024bb:	89 f9                	mov    %edi,%ecx
  8024bd:	d3 e5                	shl    %cl,%ebp
  8024bf:	39 c5                	cmp    %eax,%ebp
  8024c1:	73 04                	jae    8024c7 <__udivdi3+0xf7>
  8024c3:	39 d6                	cmp    %edx,%esi
  8024c5:	74 09                	je     8024d0 <__udivdi3+0x100>
  8024c7:	89 d8                	mov    %ebx,%eax
  8024c9:	31 ff                	xor    %edi,%edi
  8024cb:	e9 27 ff ff ff       	jmp    8023f7 <__udivdi3+0x27>
  8024d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8024d3:	31 ff                	xor    %edi,%edi
  8024d5:	e9 1d ff ff ff       	jmp    8023f7 <__udivdi3+0x27>
  8024da:	66 90                	xchg   %ax,%ax
  8024dc:	66 90                	xchg   %ax,%ax
  8024de:	66 90                	xchg   %ax,%ax

008024e0 <__umoddi3>:
  8024e0:	55                   	push   %ebp
  8024e1:	57                   	push   %edi
  8024e2:	56                   	push   %esi
  8024e3:	53                   	push   %ebx
  8024e4:	83 ec 1c             	sub    $0x1c,%esp
  8024e7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8024eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8024ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8024f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024f7:	89 da                	mov    %ebx,%edx
  8024f9:	85 c0                	test   %eax,%eax
  8024fb:	75 43                	jne    802540 <__umoddi3+0x60>
  8024fd:	39 df                	cmp    %ebx,%edi
  8024ff:	76 17                	jbe    802518 <__umoddi3+0x38>
  802501:	89 f0                	mov    %esi,%eax
  802503:	f7 f7                	div    %edi
  802505:	89 d0                	mov    %edx,%eax
  802507:	31 d2                	xor    %edx,%edx
  802509:	83 c4 1c             	add    $0x1c,%esp
  80250c:	5b                   	pop    %ebx
  80250d:	5e                   	pop    %esi
  80250e:	5f                   	pop    %edi
  80250f:	5d                   	pop    %ebp
  802510:	c3                   	ret    
  802511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802518:	89 fd                	mov    %edi,%ebp
  80251a:	85 ff                	test   %edi,%edi
  80251c:	75 0b                	jne    802529 <__umoddi3+0x49>
  80251e:	b8 01 00 00 00       	mov    $0x1,%eax
  802523:	31 d2                	xor    %edx,%edx
  802525:	f7 f7                	div    %edi
  802527:	89 c5                	mov    %eax,%ebp
  802529:	89 d8                	mov    %ebx,%eax
  80252b:	31 d2                	xor    %edx,%edx
  80252d:	f7 f5                	div    %ebp
  80252f:	89 f0                	mov    %esi,%eax
  802531:	f7 f5                	div    %ebp
  802533:	89 d0                	mov    %edx,%eax
  802535:	eb d0                	jmp    802507 <__umoddi3+0x27>
  802537:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80253e:	66 90                	xchg   %ax,%ax
  802540:	89 f1                	mov    %esi,%ecx
  802542:	39 d8                	cmp    %ebx,%eax
  802544:	76 0a                	jbe    802550 <__umoddi3+0x70>
  802546:	89 f0                	mov    %esi,%eax
  802548:	83 c4 1c             	add    $0x1c,%esp
  80254b:	5b                   	pop    %ebx
  80254c:	5e                   	pop    %esi
  80254d:	5f                   	pop    %edi
  80254e:	5d                   	pop    %ebp
  80254f:	c3                   	ret    
  802550:	0f bd e8             	bsr    %eax,%ebp
  802553:	83 f5 1f             	xor    $0x1f,%ebp
  802556:	75 20                	jne    802578 <__umoddi3+0x98>
  802558:	39 d8                	cmp    %ebx,%eax
  80255a:	0f 82 b0 00 00 00    	jb     802610 <__umoddi3+0x130>
  802560:	39 f7                	cmp    %esi,%edi
  802562:	0f 86 a8 00 00 00    	jbe    802610 <__umoddi3+0x130>
  802568:	89 c8                	mov    %ecx,%eax
  80256a:	83 c4 1c             	add    $0x1c,%esp
  80256d:	5b                   	pop    %ebx
  80256e:	5e                   	pop    %esi
  80256f:	5f                   	pop    %edi
  802570:	5d                   	pop    %ebp
  802571:	c3                   	ret    
  802572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802578:	89 e9                	mov    %ebp,%ecx
  80257a:	ba 20 00 00 00       	mov    $0x20,%edx
  80257f:	29 ea                	sub    %ebp,%edx
  802581:	d3 e0                	shl    %cl,%eax
  802583:	89 44 24 08          	mov    %eax,0x8(%esp)
  802587:	89 d1                	mov    %edx,%ecx
  802589:	89 f8                	mov    %edi,%eax
  80258b:	d3 e8                	shr    %cl,%eax
  80258d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802591:	89 54 24 04          	mov    %edx,0x4(%esp)
  802595:	8b 54 24 04          	mov    0x4(%esp),%edx
  802599:	09 c1                	or     %eax,%ecx
  80259b:	89 d8                	mov    %ebx,%eax
  80259d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025a1:	89 e9                	mov    %ebp,%ecx
  8025a3:	d3 e7                	shl    %cl,%edi
  8025a5:	89 d1                	mov    %edx,%ecx
  8025a7:	d3 e8                	shr    %cl,%eax
  8025a9:	89 e9                	mov    %ebp,%ecx
  8025ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025af:	d3 e3                	shl    %cl,%ebx
  8025b1:	89 c7                	mov    %eax,%edi
  8025b3:	89 d1                	mov    %edx,%ecx
  8025b5:	89 f0                	mov    %esi,%eax
  8025b7:	d3 e8                	shr    %cl,%eax
  8025b9:	89 e9                	mov    %ebp,%ecx
  8025bb:	89 fa                	mov    %edi,%edx
  8025bd:	d3 e6                	shl    %cl,%esi
  8025bf:	09 d8                	or     %ebx,%eax
  8025c1:	f7 74 24 08          	divl   0x8(%esp)
  8025c5:	89 d1                	mov    %edx,%ecx
  8025c7:	89 f3                	mov    %esi,%ebx
  8025c9:	f7 64 24 0c          	mull   0xc(%esp)
  8025cd:	89 c6                	mov    %eax,%esi
  8025cf:	89 d7                	mov    %edx,%edi
  8025d1:	39 d1                	cmp    %edx,%ecx
  8025d3:	72 06                	jb     8025db <__umoddi3+0xfb>
  8025d5:	75 10                	jne    8025e7 <__umoddi3+0x107>
  8025d7:	39 c3                	cmp    %eax,%ebx
  8025d9:	73 0c                	jae    8025e7 <__umoddi3+0x107>
  8025db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8025df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8025e3:	89 d7                	mov    %edx,%edi
  8025e5:	89 c6                	mov    %eax,%esi
  8025e7:	89 ca                	mov    %ecx,%edx
  8025e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025ee:	29 f3                	sub    %esi,%ebx
  8025f0:	19 fa                	sbb    %edi,%edx
  8025f2:	89 d0                	mov    %edx,%eax
  8025f4:	d3 e0                	shl    %cl,%eax
  8025f6:	89 e9                	mov    %ebp,%ecx
  8025f8:	d3 eb                	shr    %cl,%ebx
  8025fa:	d3 ea                	shr    %cl,%edx
  8025fc:	09 d8                	or     %ebx,%eax
  8025fe:	83 c4 1c             	add    $0x1c,%esp
  802601:	5b                   	pop    %ebx
  802602:	5e                   	pop    %esi
  802603:	5f                   	pop    %edi
  802604:	5d                   	pop    %ebp
  802605:	c3                   	ret    
  802606:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80260d:	8d 76 00             	lea    0x0(%esi),%esi
  802610:	89 da                	mov    %ebx,%edx
  802612:	29 fe                	sub    %edi,%esi
  802614:	19 c2                	sbb    %eax,%edx
  802616:	89 f1                	mov    %esi,%ecx
  802618:	89 c8                	mov    %ecx,%eax
  80261a:	e9 4b ff ff ff       	jmp    80256a <__umoddi3+0x8a>
