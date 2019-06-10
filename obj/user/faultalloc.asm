
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
  800040:	68 a0 26 80 00       	push   $0x8026a0
  800045:	e8 83 02 00 00       	call   8002cd <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004a:	83 c4 0c             	add    $0xc,%esp
  80004d:	6a 07                	push   $0x7
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	50                   	push   %eax
  800057:	6a 00                	push   $0x0
  800059:	e8 c0 0d 00 00       	call   800e1e <sys_page_alloc>
  80005e:	83 c4 10             	add    $0x10,%esp
  800061:	85 c0                	test   %eax,%eax
  800063:	78 16                	js     80007b <handler+0x48>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800065:	53                   	push   %ebx
  800066:	68 e8 26 80 00       	push   $0x8026e8
  80006b:	6a 64                	push   $0x64
  80006d:	53                   	push   %ebx
  80006e:	e8 66 09 00 00       	call   8009d9 <snprintf>
}
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800079:	c9                   	leave  
  80007a:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007b:	83 ec 0c             	sub    $0xc,%esp
  80007e:	50                   	push   %eax
  80007f:	53                   	push   %ebx
  800080:	68 bc 26 80 00       	push   $0x8026bc
  800085:	6a 0e                	push   $0xe
  800087:	68 aa 26 80 00       	push   $0x8026aa
  80008c:	e8 46 01 00 00       	call   8001d7 <_panic>

00800091 <umain>:

void
umain(int argc, char **argv)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800097:	68 33 00 80 00       	push   $0x800033
  80009c:	e8 72 10 00 00       	call   801113 <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	68 ef be ad de       	push   $0xdeadbeef
  8000a9:	68 68 27 80 00       	push   $0x802768
  8000ae:	e8 1a 02 00 00       	call   8002cd <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000b3:	83 c4 08             	add    $0x8,%esp
  8000b6:	68 fe bf fe ca       	push   $0xcafebffe
  8000bb:	68 68 27 80 00       	push   $0x802768
  8000c0:	e8 08 02 00 00       	call   8002cd <cprintf>
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
  8000dd:	e8 fe 0c 00 00       	call   800de0 <sys_getenvid>
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

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800141:	a1 08 40 80 00       	mov    0x804008,%eax
  800146:	8b 40 48             	mov    0x48(%eax),%eax
  800149:	83 ec 08             	sub    $0x8,%esp
  80014c:	50                   	push   %eax
  80014d:	68 09 27 80 00       	push   $0x802709
  800152:	e8 76 01 00 00       	call   8002cd <cprintf>
	cprintf("before umain\n");
  800157:	c7 04 24 27 27 80 00 	movl   $0x802727,(%esp)
  80015e:	e8 6a 01 00 00       	call   8002cd <cprintf>
	// call user main routine
	umain(argc, argv);
  800163:	83 c4 08             	add    $0x8,%esp
  800166:	ff 75 0c             	pushl  0xc(%ebp)
  800169:	ff 75 08             	pushl  0x8(%ebp)
  80016c:	e8 20 ff ff ff       	call   800091 <umain>
	cprintf("after umain\n");
  800171:	c7 04 24 35 27 80 00 	movl   $0x802735,(%esp)
  800178:	e8 50 01 00 00       	call   8002cd <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80017d:	a1 08 40 80 00       	mov    0x804008,%eax
  800182:	8b 40 48             	mov    0x48(%eax),%eax
  800185:	83 c4 08             	add    $0x8,%esp
  800188:	50                   	push   %eax
  800189:	68 42 27 80 00       	push   $0x802742
  80018e:	e8 3a 01 00 00       	call   8002cd <cprintf>
	// exit gracefully
	exit();
  800193:	e8 0b 00 00 00       	call   8001a3 <exit>
}
  800198:	83 c4 10             	add    $0x10,%esp
  80019b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80019e:	5b                   	pop    %ebx
  80019f:	5e                   	pop    %esi
  8001a0:	5f                   	pop    %edi
  8001a1:	5d                   	pop    %ebp
  8001a2:	c3                   	ret    

008001a3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001a3:	55                   	push   %ebp
  8001a4:	89 e5                	mov    %esp,%ebp
  8001a6:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001a9:	a1 08 40 80 00       	mov    0x804008,%eax
  8001ae:	8b 40 48             	mov    0x48(%eax),%eax
  8001b1:	68 6c 27 80 00       	push   $0x80276c
  8001b6:	50                   	push   %eax
  8001b7:	68 61 27 80 00       	push   $0x802761
  8001bc:	e8 0c 01 00 00       	call   8002cd <cprintf>
	close_all();
  8001c1:	e8 ba 11 00 00       	call   801380 <close_all>
	sys_env_destroy(0);
  8001c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001cd:	e8 cd 0b 00 00       	call   800d9f <sys_env_destroy>
}
  8001d2:	83 c4 10             	add    $0x10,%esp
  8001d5:	c9                   	leave  
  8001d6:	c3                   	ret    

008001d7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001d7:	55                   	push   %ebp
  8001d8:	89 e5                	mov    %esp,%ebp
  8001da:	56                   	push   %esi
  8001db:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001dc:	a1 08 40 80 00       	mov    0x804008,%eax
  8001e1:	8b 40 48             	mov    0x48(%eax),%eax
  8001e4:	83 ec 04             	sub    $0x4,%esp
  8001e7:	68 98 27 80 00       	push   $0x802798
  8001ec:	50                   	push   %eax
  8001ed:	68 61 27 80 00       	push   $0x802761
  8001f2:	e8 d6 00 00 00       	call   8002cd <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8001f7:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001fa:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800200:	e8 db 0b 00 00       	call   800de0 <sys_getenvid>
  800205:	83 c4 04             	add    $0x4,%esp
  800208:	ff 75 0c             	pushl  0xc(%ebp)
  80020b:	ff 75 08             	pushl  0x8(%ebp)
  80020e:	56                   	push   %esi
  80020f:	50                   	push   %eax
  800210:	68 74 27 80 00       	push   $0x802774
  800215:	e8 b3 00 00 00       	call   8002cd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80021a:	83 c4 18             	add    $0x18,%esp
  80021d:	53                   	push   %ebx
  80021e:	ff 75 10             	pushl  0x10(%ebp)
  800221:	e8 56 00 00 00       	call   80027c <vcprintf>
	cprintf("\n");
  800226:	c7 04 24 25 27 80 00 	movl   $0x802725,(%esp)
  80022d:	e8 9b 00 00 00       	call   8002cd <cprintf>
  800232:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800235:	cc                   	int3   
  800236:	eb fd                	jmp    800235 <_panic+0x5e>

00800238 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800238:	55                   	push   %ebp
  800239:	89 e5                	mov    %esp,%ebp
  80023b:	53                   	push   %ebx
  80023c:	83 ec 04             	sub    $0x4,%esp
  80023f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800242:	8b 13                	mov    (%ebx),%edx
  800244:	8d 42 01             	lea    0x1(%edx),%eax
  800247:	89 03                	mov    %eax,(%ebx)
  800249:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80024c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800250:	3d ff 00 00 00       	cmp    $0xff,%eax
  800255:	74 09                	je     800260 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800257:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80025b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80025e:	c9                   	leave  
  80025f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800260:	83 ec 08             	sub    $0x8,%esp
  800263:	68 ff 00 00 00       	push   $0xff
  800268:	8d 43 08             	lea    0x8(%ebx),%eax
  80026b:	50                   	push   %eax
  80026c:	e8 f1 0a 00 00       	call   800d62 <sys_cputs>
		b->idx = 0;
  800271:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800277:	83 c4 10             	add    $0x10,%esp
  80027a:	eb db                	jmp    800257 <putch+0x1f>

0080027c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80027c:	55                   	push   %ebp
  80027d:	89 e5                	mov    %esp,%ebp
  80027f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800285:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80028c:	00 00 00 
	b.cnt = 0;
  80028f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800296:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800299:	ff 75 0c             	pushl  0xc(%ebp)
  80029c:	ff 75 08             	pushl  0x8(%ebp)
  80029f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a5:	50                   	push   %eax
  8002a6:	68 38 02 80 00       	push   $0x800238
  8002ab:	e8 4a 01 00 00       	call   8003fa <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002b0:	83 c4 08             	add    $0x8,%esp
  8002b3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002b9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002bf:	50                   	push   %eax
  8002c0:	e8 9d 0a 00 00       	call   800d62 <sys_cputs>

	return b.cnt;
}
  8002c5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002cb:	c9                   	leave  
  8002cc:	c3                   	ret    

008002cd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002cd:	55                   	push   %ebp
  8002ce:	89 e5                	mov    %esp,%ebp
  8002d0:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002d3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002d6:	50                   	push   %eax
  8002d7:	ff 75 08             	pushl  0x8(%ebp)
  8002da:	e8 9d ff ff ff       	call   80027c <vcprintf>
	va_end(ap);

	return cnt;
}
  8002df:	c9                   	leave  
  8002e0:	c3                   	ret    

008002e1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002e1:	55                   	push   %ebp
  8002e2:	89 e5                	mov    %esp,%ebp
  8002e4:	57                   	push   %edi
  8002e5:	56                   	push   %esi
  8002e6:	53                   	push   %ebx
  8002e7:	83 ec 1c             	sub    $0x1c,%esp
  8002ea:	89 c6                	mov    %eax,%esi
  8002ec:	89 d7                	mov    %edx,%edi
  8002ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002f7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8002fd:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800300:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800304:	74 2c                	je     800332 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800306:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800309:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800310:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800313:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800316:	39 c2                	cmp    %eax,%edx
  800318:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80031b:	73 43                	jae    800360 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80031d:	83 eb 01             	sub    $0x1,%ebx
  800320:	85 db                	test   %ebx,%ebx
  800322:	7e 6c                	jle    800390 <printnum+0xaf>
				putch(padc, putdat);
  800324:	83 ec 08             	sub    $0x8,%esp
  800327:	57                   	push   %edi
  800328:	ff 75 18             	pushl  0x18(%ebp)
  80032b:	ff d6                	call   *%esi
  80032d:	83 c4 10             	add    $0x10,%esp
  800330:	eb eb                	jmp    80031d <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800332:	83 ec 0c             	sub    $0xc,%esp
  800335:	6a 20                	push   $0x20
  800337:	6a 00                	push   $0x0
  800339:	50                   	push   %eax
  80033a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80033d:	ff 75 e0             	pushl  -0x20(%ebp)
  800340:	89 fa                	mov    %edi,%edx
  800342:	89 f0                	mov    %esi,%eax
  800344:	e8 98 ff ff ff       	call   8002e1 <printnum>
		while (--width > 0)
  800349:	83 c4 20             	add    $0x20,%esp
  80034c:	83 eb 01             	sub    $0x1,%ebx
  80034f:	85 db                	test   %ebx,%ebx
  800351:	7e 65                	jle    8003b8 <printnum+0xd7>
			putch(padc, putdat);
  800353:	83 ec 08             	sub    $0x8,%esp
  800356:	57                   	push   %edi
  800357:	6a 20                	push   $0x20
  800359:	ff d6                	call   *%esi
  80035b:	83 c4 10             	add    $0x10,%esp
  80035e:	eb ec                	jmp    80034c <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800360:	83 ec 0c             	sub    $0xc,%esp
  800363:	ff 75 18             	pushl  0x18(%ebp)
  800366:	83 eb 01             	sub    $0x1,%ebx
  800369:	53                   	push   %ebx
  80036a:	50                   	push   %eax
  80036b:	83 ec 08             	sub    $0x8,%esp
  80036e:	ff 75 dc             	pushl  -0x24(%ebp)
  800371:	ff 75 d8             	pushl  -0x28(%ebp)
  800374:	ff 75 e4             	pushl  -0x1c(%ebp)
  800377:	ff 75 e0             	pushl  -0x20(%ebp)
  80037a:	e8 c1 20 00 00       	call   802440 <__udivdi3>
  80037f:	83 c4 18             	add    $0x18,%esp
  800382:	52                   	push   %edx
  800383:	50                   	push   %eax
  800384:	89 fa                	mov    %edi,%edx
  800386:	89 f0                	mov    %esi,%eax
  800388:	e8 54 ff ff ff       	call   8002e1 <printnum>
  80038d:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800390:	83 ec 08             	sub    $0x8,%esp
  800393:	57                   	push   %edi
  800394:	83 ec 04             	sub    $0x4,%esp
  800397:	ff 75 dc             	pushl  -0x24(%ebp)
  80039a:	ff 75 d8             	pushl  -0x28(%ebp)
  80039d:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a0:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a3:	e8 a8 21 00 00       	call   802550 <__umoddi3>
  8003a8:	83 c4 14             	add    $0x14,%esp
  8003ab:	0f be 80 9f 27 80 00 	movsbl 0x80279f(%eax),%eax
  8003b2:	50                   	push   %eax
  8003b3:	ff d6                	call   *%esi
  8003b5:	83 c4 10             	add    $0x10,%esp
	}
}
  8003b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003bb:	5b                   	pop    %ebx
  8003bc:	5e                   	pop    %esi
  8003bd:	5f                   	pop    %edi
  8003be:	5d                   	pop    %ebp
  8003bf:	c3                   	ret    

008003c0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003c0:	55                   	push   %ebp
  8003c1:	89 e5                	mov    %esp,%ebp
  8003c3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003c6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003ca:	8b 10                	mov    (%eax),%edx
  8003cc:	3b 50 04             	cmp    0x4(%eax),%edx
  8003cf:	73 0a                	jae    8003db <sprintputch+0x1b>
		*b->buf++ = ch;
  8003d1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003d4:	89 08                	mov    %ecx,(%eax)
  8003d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d9:	88 02                	mov    %al,(%edx)
}
  8003db:	5d                   	pop    %ebp
  8003dc:	c3                   	ret    

008003dd <printfmt>:
{
  8003dd:	55                   	push   %ebp
  8003de:	89 e5                	mov    %esp,%ebp
  8003e0:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003e3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003e6:	50                   	push   %eax
  8003e7:	ff 75 10             	pushl  0x10(%ebp)
  8003ea:	ff 75 0c             	pushl  0xc(%ebp)
  8003ed:	ff 75 08             	pushl  0x8(%ebp)
  8003f0:	e8 05 00 00 00       	call   8003fa <vprintfmt>
}
  8003f5:	83 c4 10             	add    $0x10,%esp
  8003f8:	c9                   	leave  
  8003f9:	c3                   	ret    

008003fa <vprintfmt>:
{
  8003fa:	55                   	push   %ebp
  8003fb:	89 e5                	mov    %esp,%ebp
  8003fd:	57                   	push   %edi
  8003fe:	56                   	push   %esi
  8003ff:	53                   	push   %ebx
  800400:	83 ec 3c             	sub    $0x3c,%esp
  800403:	8b 75 08             	mov    0x8(%ebp),%esi
  800406:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800409:	8b 7d 10             	mov    0x10(%ebp),%edi
  80040c:	e9 32 04 00 00       	jmp    800843 <vprintfmt+0x449>
		padc = ' ';
  800411:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800415:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80041c:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800423:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80042a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800431:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800438:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80043d:	8d 47 01             	lea    0x1(%edi),%eax
  800440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800443:	0f b6 17             	movzbl (%edi),%edx
  800446:	8d 42 dd             	lea    -0x23(%edx),%eax
  800449:	3c 55                	cmp    $0x55,%al
  80044b:	0f 87 12 05 00 00    	ja     800963 <vprintfmt+0x569>
  800451:	0f b6 c0             	movzbl %al,%eax
  800454:	ff 24 85 80 29 80 00 	jmp    *0x802980(,%eax,4)
  80045b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80045e:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800462:	eb d9                	jmp    80043d <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800464:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800467:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80046b:	eb d0                	jmp    80043d <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80046d:	0f b6 d2             	movzbl %dl,%edx
  800470:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800473:	b8 00 00 00 00       	mov    $0x0,%eax
  800478:	89 75 08             	mov    %esi,0x8(%ebp)
  80047b:	eb 03                	jmp    800480 <vprintfmt+0x86>
  80047d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800480:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800483:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800487:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80048a:	8d 72 d0             	lea    -0x30(%edx),%esi
  80048d:	83 fe 09             	cmp    $0x9,%esi
  800490:	76 eb                	jbe    80047d <vprintfmt+0x83>
  800492:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800495:	8b 75 08             	mov    0x8(%ebp),%esi
  800498:	eb 14                	jmp    8004ae <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80049a:	8b 45 14             	mov    0x14(%ebp),%eax
  80049d:	8b 00                	mov    (%eax),%eax
  80049f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a5:	8d 40 04             	lea    0x4(%eax),%eax
  8004a8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004ae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004b2:	79 89                	jns    80043d <vprintfmt+0x43>
				width = precision, precision = -1;
  8004b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ba:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004c1:	e9 77 ff ff ff       	jmp    80043d <vprintfmt+0x43>
  8004c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c9:	85 c0                	test   %eax,%eax
  8004cb:	0f 48 c1             	cmovs  %ecx,%eax
  8004ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004d4:	e9 64 ff ff ff       	jmp    80043d <vprintfmt+0x43>
  8004d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004dc:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004e3:	e9 55 ff ff ff       	jmp    80043d <vprintfmt+0x43>
			lflag++;
  8004e8:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004ef:	e9 49 ff ff ff       	jmp    80043d <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f7:	8d 78 04             	lea    0x4(%eax),%edi
  8004fa:	83 ec 08             	sub    $0x8,%esp
  8004fd:	53                   	push   %ebx
  8004fe:	ff 30                	pushl  (%eax)
  800500:	ff d6                	call   *%esi
			break;
  800502:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800505:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800508:	e9 33 03 00 00       	jmp    800840 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80050d:	8b 45 14             	mov    0x14(%ebp),%eax
  800510:	8d 78 04             	lea    0x4(%eax),%edi
  800513:	8b 00                	mov    (%eax),%eax
  800515:	99                   	cltd   
  800516:	31 d0                	xor    %edx,%eax
  800518:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80051a:	83 f8 11             	cmp    $0x11,%eax
  80051d:	7f 23                	jg     800542 <vprintfmt+0x148>
  80051f:	8b 14 85 e0 2a 80 00 	mov    0x802ae0(,%eax,4),%edx
  800526:	85 d2                	test   %edx,%edx
  800528:	74 18                	je     800542 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80052a:	52                   	push   %edx
  80052b:	68 79 2c 80 00       	push   $0x802c79
  800530:	53                   	push   %ebx
  800531:	56                   	push   %esi
  800532:	e8 a6 fe ff ff       	call   8003dd <printfmt>
  800537:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80053a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80053d:	e9 fe 02 00 00       	jmp    800840 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800542:	50                   	push   %eax
  800543:	68 b7 27 80 00       	push   $0x8027b7
  800548:	53                   	push   %ebx
  800549:	56                   	push   %esi
  80054a:	e8 8e fe ff ff       	call   8003dd <printfmt>
  80054f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800552:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800555:	e9 e6 02 00 00       	jmp    800840 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80055a:	8b 45 14             	mov    0x14(%ebp),%eax
  80055d:	83 c0 04             	add    $0x4,%eax
  800560:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800563:	8b 45 14             	mov    0x14(%ebp),%eax
  800566:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800568:	85 c9                	test   %ecx,%ecx
  80056a:	b8 b0 27 80 00       	mov    $0x8027b0,%eax
  80056f:	0f 45 c1             	cmovne %ecx,%eax
  800572:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800575:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800579:	7e 06                	jle    800581 <vprintfmt+0x187>
  80057b:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80057f:	75 0d                	jne    80058e <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800581:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800584:	89 c7                	mov    %eax,%edi
  800586:	03 45 e0             	add    -0x20(%ebp),%eax
  800589:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80058c:	eb 53                	jmp    8005e1 <vprintfmt+0x1e7>
  80058e:	83 ec 08             	sub    $0x8,%esp
  800591:	ff 75 d8             	pushl  -0x28(%ebp)
  800594:	50                   	push   %eax
  800595:	e8 71 04 00 00       	call   800a0b <strnlen>
  80059a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80059d:	29 c1                	sub    %eax,%ecx
  80059f:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8005a2:	83 c4 10             	add    $0x10,%esp
  8005a5:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005a7:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ae:	eb 0f                	jmp    8005bf <vprintfmt+0x1c5>
					putch(padc, putdat);
  8005b0:	83 ec 08             	sub    $0x8,%esp
  8005b3:	53                   	push   %ebx
  8005b4:	ff 75 e0             	pushl  -0x20(%ebp)
  8005b7:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b9:	83 ef 01             	sub    $0x1,%edi
  8005bc:	83 c4 10             	add    $0x10,%esp
  8005bf:	85 ff                	test   %edi,%edi
  8005c1:	7f ed                	jg     8005b0 <vprintfmt+0x1b6>
  8005c3:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8005c6:	85 c9                	test   %ecx,%ecx
  8005c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8005cd:	0f 49 c1             	cmovns %ecx,%eax
  8005d0:	29 c1                	sub    %eax,%ecx
  8005d2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005d5:	eb aa                	jmp    800581 <vprintfmt+0x187>
					putch(ch, putdat);
  8005d7:	83 ec 08             	sub    $0x8,%esp
  8005da:	53                   	push   %ebx
  8005db:	52                   	push   %edx
  8005dc:	ff d6                	call   *%esi
  8005de:	83 c4 10             	add    $0x10,%esp
  8005e1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005e4:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005e6:	83 c7 01             	add    $0x1,%edi
  8005e9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005ed:	0f be d0             	movsbl %al,%edx
  8005f0:	85 d2                	test   %edx,%edx
  8005f2:	74 4b                	je     80063f <vprintfmt+0x245>
  8005f4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005f8:	78 06                	js     800600 <vprintfmt+0x206>
  8005fa:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005fe:	78 1e                	js     80061e <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800600:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800604:	74 d1                	je     8005d7 <vprintfmt+0x1dd>
  800606:	0f be c0             	movsbl %al,%eax
  800609:	83 e8 20             	sub    $0x20,%eax
  80060c:	83 f8 5e             	cmp    $0x5e,%eax
  80060f:	76 c6                	jbe    8005d7 <vprintfmt+0x1dd>
					putch('?', putdat);
  800611:	83 ec 08             	sub    $0x8,%esp
  800614:	53                   	push   %ebx
  800615:	6a 3f                	push   $0x3f
  800617:	ff d6                	call   *%esi
  800619:	83 c4 10             	add    $0x10,%esp
  80061c:	eb c3                	jmp    8005e1 <vprintfmt+0x1e7>
  80061e:	89 cf                	mov    %ecx,%edi
  800620:	eb 0e                	jmp    800630 <vprintfmt+0x236>
				putch(' ', putdat);
  800622:	83 ec 08             	sub    $0x8,%esp
  800625:	53                   	push   %ebx
  800626:	6a 20                	push   $0x20
  800628:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80062a:	83 ef 01             	sub    $0x1,%edi
  80062d:	83 c4 10             	add    $0x10,%esp
  800630:	85 ff                	test   %edi,%edi
  800632:	7f ee                	jg     800622 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800634:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800637:	89 45 14             	mov    %eax,0x14(%ebp)
  80063a:	e9 01 02 00 00       	jmp    800840 <vprintfmt+0x446>
  80063f:	89 cf                	mov    %ecx,%edi
  800641:	eb ed                	jmp    800630 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800643:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800646:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80064d:	e9 eb fd ff ff       	jmp    80043d <vprintfmt+0x43>
	if (lflag >= 2)
  800652:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800656:	7f 21                	jg     800679 <vprintfmt+0x27f>
	else if (lflag)
  800658:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80065c:	74 68                	je     8006c6 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	8b 00                	mov    (%eax),%eax
  800663:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800666:	89 c1                	mov    %eax,%ecx
  800668:	c1 f9 1f             	sar    $0x1f,%ecx
  80066b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	8d 40 04             	lea    0x4(%eax),%eax
  800674:	89 45 14             	mov    %eax,0x14(%ebp)
  800677:	eb 17                	jmp    800690 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800679:	8b 45 14             	mov    0x14(%ebp),%eax
  80067c:	8b 50 04             	mov    0x4(%eax),%edx
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800684:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800687:	8b 45 14             	mov    0x14(%ebp),%eax
  80068a:	8d 40 08             	lea    0x8(%eax),%eax
  80068d:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800690:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800693:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800696:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800699:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80069c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006a0:	78 3f                	js     8006e1 <vprintfmt+0x2e7>
			base = 10;
  8006a2:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8006a7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8006ab:	0f 84 71 01 00 00    	je     800822 <vprintfmt+0x428>
				putch('+', putdat);
  8006b1:	83 ec 08             	sub    $0x8,%esp
  8006b4:	53                   	push   %ebx
  8006b5:	6a 2b                	push   $0x2b
  8006b7:	ff d6                	call   *%esi
  8006b9:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006bc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c1:	e9 5c 01 00 00       	jmp    800822 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8006c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c9:	8b 00                	mov    (%eax),%eax
  8006cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006ce:	89 c1                	mov    %eax,%ecx
  8006d0:	c1 f9 1f             	sar    $0x1f,%ecx
  8006d3:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	8d 40 04             	lea    0x4(%eax),%eax
  8006dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8006df:	eb af                	jmp    800690 <vprintfmt+0x296>
				putch('-', putdat);
  8006e1:	83 ec 08             	sub    $0x8,%esp
  8006e4:	53                   	push   %ebx
  8006e5:	6a 2d                	push   $0x2d
  8006e7:	ff d6                	call   *%esi
				num = -(long long) num;
  8006e9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006ec:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006ef:	f7 d8                	neg    %eax
  8006f1:	83 d2 00             	adc    $0x0,%edx
  8006f4:	f7 da                	neg    %edx
  8006f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fc:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006ff:	b8 0a 00 00 00       	mov    $0xa,%eax
  800704:	e9 19 01 00 00       	jmp    800822 <vprintfmt+0x428>
	if (lflag >= 2)
  800709:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80070d:	7f 29                	jg     800738 <vprintfmt+0x33e>
	else if (lflag)
  80070f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800713:	74 44                	je     800759 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	ba 00 00 00 00       	mov    $0x0,%edx
  80071f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800722:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800725:	8b 45 14             	mov    0x14(%ebp),%eax
  800728:	8d 40 04             	lea    0x4(%eax),%eax
  80072b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80072e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800733:	e9 ea 00 00 00       	jmp    800822 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800738:	8b 45 14             	mov    0x14(%ebp),%eax
  80073b:	8b 50 04             	mov    0x4(%eax),%edx
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800743:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800746:	8b 45 14             	mov    0x14(%ebp),%eax
  800749:	8d 40 08             	lea    0x8(%eax),%eax
  80074c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80074f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800754:	e9 c9 00 00 00       	jmp    800822 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800759:	8b 45 14             	mov    0x14(%ebp),%eax
  80075c:	8b 00                	mov    (%eax),%eax
  80075e:	ba 00 00 00 00       	mov    $0x0,%edx
  800763:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800766:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800769:	8b 45 14             	mov    0x14(%ebp),%eax
  80076c:	8d 40 04             	lea    0x4(%eax),%eax
  80076f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800772:	b8 0a 00 00 00       	mov    $0xa,%eax
  800777:	e9 a6 00 00 00       	jmp    800822 <vprintfmt+0x428>
			putch('0', putdat);
  80077c:	83 ec 08             	sub    $0x8,%esp
  80077f:	53                   	push   %ebx
  800780:	6a 30                	push   $0x30
  800782:	ff d6                	call   *%esi
	if (lflag >= 2)
  800784:	83 c4 10             	add    $0x10,%esp
  800787:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80078b:	7f 26                	jg     8007b3 <vprintfmt+0x3b9>
	else if (lflag)
  80078d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800791:	74 3e                	je     8007d1 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800793:	8b 45 14             	mov    0x14(%ebp),%eax
  800796:	8b 00                	mov    (%eax),%eax
  800798:	ba 00 00 00 00       	mov    $0x0,%edx
  80079d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a6:	8d 40 04             	lea    0x4(%eax),%eax
  8007a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007ac:	b8 08 00 00 00       	mov    $0x8,%eax
  8007b1:	eb 6f                	jmp    800822 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b6:	8b 50 04             	mov    0x4(%eax),%edx
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007be:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c4:	8d 40 08             	lea    0x8(%eax),%eax
  8007c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007ca:	b8 08 00 00 00       	mov    $0x8,%eax
  8007cf:	eb 51                	jmp    800822 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8007db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007de:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e4:	8d 40 04             	lea    0x4(%eax),%eax
  8007e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007ea:	b8 08 00 00 00       	mov    $0x8,%eax
  8007ef:	eb 31                	jmp    800822 <vprintfmt+0x428>
			putch('0', putdat);
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	53                   	push   %ebx
  8007f5:	6a 30                	push   $0x30
  8007f7:	ff d6                	call   *%esi
			putch('x', putdat);
  8007f9:	83 c4 08             	add    $0x8,%esp
  8007fc:	53                   	push   %ebx
  8007fd:	6a 78                	push   $0x78
  8007ff:	ff d6                	call   *%esi
			num = (unsigned long long)
  800801:	8b 45 14             	mov    0x14(%ebp),%eax
  800804:	8b 00                	mov    (%eax),%eax
  800806:	ba 00 00 00 00       	mov    $0x0,%edx
  80080b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800811:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	8d 40 04             	lea    0x4(%eax),%eax
  80081a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800822:	83 ec 0c             	sub    $0xc,%esp
  800825:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800829:	52                   	push   %edx
  80082a:	ff 75 e0             	pushl  -0x20(%ebp)
  80082d:	50                   	push   %eax
  80082e:	ff 75 dc             	pushl  -0x24(%ebp)
  800831:	ff 75 d8             	pushl  -0x28(%ebp)
  800834:	89 da                	mov    %ebx,%edx
  800836:	89 f0                	mov    %esi,%eax
  800838:	e8 a4 fa ff ff       	call   8002e1 <printnum>
			break;
  80083d:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800840:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800843:	83 c7 01             	add    $0x1,%edi
  800846:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80084a:	83 f8 25             	cmp    $0x25,%eax
  80084d:	0f 84 be fb ff ff    	je     800411 <vprintfmt+0x17>
			if (ch == '\0')
  800853:	85 c0                	test   %eax,%eax
  800855:	0f 84 28 01 00 00    	je     800983 <vprintfmt+0x589>
			putch(ch, putdat);
  80085b:	83 ec 08             	sub    $0x8,%esp
  80085e:	53                   	push   %ebx
  80085f:	50                   	push   %eax
  800860:	ff d6                	call   *%esi
  800862:	83 c4 10             	add    $0x10,%esp
  800865:	eb dc                	jmp    800843 <vprintfmt+0x449>
	if (lflag >= 2)
  800867:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80086b:	7f 26                	jg     800893 <vprintfmt+0x499>
	else if (lflag)
  80086d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800871:	74 41                	je     8008b4 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	8b 00                	mov    (%eax),%eax
  800878:	ba 00 00 00 00       	mov    $0x0,%edx
  80087d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800880:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800883:	8b 45 14             	mov    0x14(%ebp),%eax
  800886:	8d 40 04             	lea    0x4(%eax),%eax
  800889:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80088c:	b8 10 00 00 00       	mov    $0x10,%eax
  800891:	eb 8f                	jmp    800822 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800893:	8b 45 14             	mov    0x14(%ebp),%eax
  800896:	8b 50 04             	mov    0x4(%eax),%edx
  800899:	8b 00                	mov    (%eax),%eax
  80089b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80089e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a4:	8d 40 08             	lea    0x8(%eax),%eax
  8008a7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008aa:	b8 10 00 00 00       	mov    $0x10,%eax
  8008af:	e9 6e ff ff ff       	jmp    800822 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b7:	8b 00                	mov    (%eax),%eax
  8008b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8008be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c7:	8d 40 04             	lea    0x4(%eax),%eax
  8008ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008cd:	b8 10 00 00 00       	mov    $0x10,%eax
  8008d2:	e9 4b ff ff ff       	jmp    800822 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	83 c0 04             	add    $0x4,%eax
  8008dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	8b 00                	mov    (%eax),%eax
  8008e5:	85 c0                	test   %eax,%eax
  8008e7:	74 14                	je     8008fd <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8008e9:	8b 13                	mov    (%ebx),%edx
  8008eb:	83 fa 7f             	cmp    $0x7f,%edx
  8008ee:	7f 37                	jg     800927 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8008f0:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8008f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008f5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f8:	e9 43 ff ff ff       	jmp    800840 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8008fd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800902:	bf d5 28 80 00       	mov    $0x8028d5,%edi
							putch(ch, putdat);
  800907:	83 ec 08             	sub    $0x8,%esp
  80090a:	53                   	push   %ebx
  80090b:	50                   	push   %eax
  80090c:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80090e:	83 c7 01             	add    $0x1,%edi
  800911:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800915:	83 c4 10             	add    $0x10,%esp
  800918:	85 c0                	test   %eax,%eax
  80091a:	75 eb                	jne    800907 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80091c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80091f:	89 45 14             	mov    %eax,0x14(%ebp)
  800922:	e9 19 ff ff ff       	jmp    800840 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800927:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800929:	b8 0a 00 00 00       	mov    $0xa,%eax
  80092e:	bf 0d 29 80 00       	mov    $0x80290d,%edi
							putch(ch, putdat);
  800933:	83 ec 08             	sub    $0x8,%esp
  800936:	53                   	push   %ebx
  800937:	50                   	push   %eax
  800938:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80093a:	83 c7 01             	add    $0x1,%edi
  80093d:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800941:	83 c4 10             	add    $0x10,%esp
  800944:	85 c0                	test   %eax,%eax
  800946:	75 eb                	jne    800933 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800948:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80094b:	89 45 14             	mov    %eax,0x14(%ebp)
  80094e:	e9 ed fe ff ff       	jmp    800840 <vprintfmt+0x446>
			putch(ch, putdat);
  800953:	83 ec 08             	sub    $0x8,%esp
  800956:	53                   	push   %ebx
  800957:	6a 25                	push   $0x25
  800959:	ff d6                	call   *%esi
			break;
  80095b:	83 c4 10             	add    $0x10,%esp
  80095e:	e9 dd fe ff ff       	jmp    800840 <vprintfmt+0x446>
			putch('%', putdat);
  800963:	83 ec 08             	sub    $0x8,%esp
  800966:	53                   	push   %ebx
  800967:	6a 25                	push   $0x25
  800969:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80096b:	83 c4 10             	add    $0x10,%esp
  80096e:	89 f8                	mov    %edi,%eax
  800970:	eb 03                	jmp    800975 <vprintfmt+0x57b>
  800972:	83 e8 01             	sub    $0x1,%eax
  800975:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800979:	75 f7                	jne    800972 <vprintfmt+0x578>
  80097b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80097e:	e9 bd fe ff ff       	jmp    800840 <vprintfmt+0x446>
}
  800983:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800986:	5b                   	pop    %ebx
  800987:	5e                   	pop    %esi
  800988:	5f                   	pop    %edi
  800989:	5d                   	pop    %ebp
  80098a:	c3                   	ret    

0080098b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80098b:	55                   	push   %ebp
  80098c:	89 e5                	mov    %esp,%ebp
  80098e:	83 ec 18             	sub    $0x18,%esp
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800997:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80099a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80099e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009a8:	85 c0                	test   %eax,%eax
  8009aa:	74 26                	je     8009d2 <vsnprintf+0x47>
  8009ac:	85 d2                	test   %edx,%edx
  8009ae:	7e 22                	jle    8009d2 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009b0:	ff 75 14             	pushl  0x14(%ebp)
  8009b3:	ff 75 10             	pushl  0x10(%ebp)
  8009b6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b9:	50                   	push   %eax
  8009ba:	68 c0 03 80 00       	push   $0x8003c0
  8009bf:	e8 36 fa ff ff       	call   8003fa <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009cd:	83 c4 10             	add    $0x10,%esp
}
  8009d0:	c9                   	leave  
  8009d1:	c3                   	ret    
		return -E_INVAL;
  8009d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009d7:	eb f7                	jmp    8009d0 <vsnprintf+0x45>

008009d9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d9:	55                   	push   %ebp
  8009da:	89 e5                	mov    %esp,%ebp
  8009dc:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009df:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009e2:	50                   	push   %eax
  8009e3:	ff 75 10             	pushl  0x10(%ebp)
  8009e6:	ff 75 0c             	pushl  0xc(%ebp)
  8009e9:	ff 75 08             	pushl  0x8(%ebp)
  8009ec:	e8 9a ff ff ff       	call   80098b <vsnprintf>
	va_end(ap);

	return rc;
}
  8009f1:	c9                   	leave  
  8009f2:	c3                   	ret    

008009f3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009f3:	55                   	push   %ebp
  8009f4:	89 e5                	mov    %esp,%ebp
  8009f6:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8009fe:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a02:	74 05                	je     800a09 <strlen+0x16>
		n++;
  800a04:	83 c0 01             	add    $0x1,%eax
  800a07:	eb f5                	jmp    8009fe <strlen+0xb>
	return n;
}
  800a09:	5d                   	pop    %ebp
  800a0a:	c3                   	ret    

00800a0b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a11:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a14:	ba 00 00 00 00       	mov    $0x0,%edx
  800a19:	39 c2                	cmp    %eax,%edx
  800a1b:	74 0d                	je     800a2a <strnlen+0x1f>
  800a1d:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a21:	74 05                	je     800a28 <strnlen+0x1d>
		n++;
  800a23:	83 c2 01             	add    $0x1,%edx
  800a26:	eb f1                	jmp    800a19 <strnlen+0xe>
  800a28:	89 d0                	mov    %edx,%eax
	return n;
}
  800a2a:	5d                   	pop    %ebp
  800a2b:	c3                   	ret    

00800a2c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	53                   	push   %ebx
  800a30:	8b 45 08             	mov    0x8(%ebp),%eax
  800a33:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a36:	ba 00 00 00 00       	mov    $0x0,%edx
  800a3b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a3f:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a42:	83 c2 01             	add    $0x1,%edx
  800a45:	84 c9                	test   %cl,%cl
  800a47:	75 f2                	jne    800a3b <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a49:	5b                   	pop    %ebx
  800a4a:	5d                   	pop    %ebp
  800a4b:	c3                   	ret    

00800a4c <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	53                   	push   %ebx
  800a50:	83 ec 10             	sub    $0x10,%esp
  800a53:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a56:	53                   	push   %ebx
  800a57:	e8 97 ff ff ff       	call   8009f3 <strlen>
  800a5c:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a5f:	ff 75 0c             	pushl  0xc(%ebp)
  800a62:	01 d8                	add    %ebx,%eax
  800a64:	50                   	push   %eax
  800a65:	e8 c2 ff ff ff       	call   800a2c <strcpy>
	return dst;
}
  800a6a:	89 d8                	mov    %ebx,%eax
  800a6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a6f:	c9                   	leave  
  800a70:	c3                   	ret    

00800a71 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a71:	55                   	push   %ebp
  800a72:	89 e5                	mov    %esp,%ebp
  800a74:	56                   	push   %esi
  800a75:	53                   	push   %ebx
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a7c:	89 c6                	mov    %eax,%esi
  800a7e:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a81:	89 c2                	mov    %eax,%edx
  800a83:	39 f2                	cmp    %esi,%edx
  800a85:	74 11                	je     800a98 <strncpy+0x27>
		*dst++ = *src;
  800a87:	83 c2 01             	add    $0x1,%edx
  800a8a:	0f b6 19             	movzbl (%ecx),%ebx
  800a8d:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a90:	80 fb 01             	cmp    $0x1,%bl
  800a93:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a96:	eb eb                	jmp    800a83 <strncpy+0x12>
	}
	return ret;
}
  800a98:	5b                   	pop    %ebx
  800a99:	5e                   	pop    %esi
  800a9a:	5d                   	pop    %ebp
  800a9b:	c3                   	ret    

00800a9c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	56                   	push   %esi
  800aa0:	53                   	push   %ebx
  800aa1:	8b 75 08             	mov    0x8(%ebp),%esi
  800aa4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aa7:	8b 55 10             	mov    0x10(%ebp),%edx
  800aaa:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800aac:	85 d2                	test   %edx,%edx
  800aae:	74 21                	je     800ad1 <strlcpy+0x35>
  800ab0:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ab4:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ab6:	39 c2                	cmp    %eax,%edx
  800ab8:	74 14                	je     800ace <strlcpy+0x32>
  800aba:	0f b6 19             	movzbl (%ecx),%ebx
  800abd:	84 db                	test   %bl,%bl
  800abf:	74 0b                	je     800acc <strlcpy+0x30>
			*dst++ = *src++;
  800ac1:	83 c1 01             	add    $0x1,%ecx
  800ac4:	83 c2 01             	add    $0x1,%edx
  800ac7:	88 5a ff             	mov    %bl,-0x1(%edx)
  800aca:	eb ea                	jmp    800ab6 <strlcpy+0x1a>
  800acc:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ace:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ad1:	29 f0                	sub    %esi,%eax
}
  800ad3:	5b                   	pop    %ebx
  800ad4:	5e                   	pop    %esi
  800ad5:	5d                   	pop    %ebp
  800ad6:	c3                   	ret    

00800ad7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800add:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ae0:	0f b6 01             	movzbl (%ecx),%eax
  800ae3:	84 c0                	test   %al,%al
  800ae5:	74 0c                	je     800af3 <strcmp+0x1c>
  800ae7:	3a 02                	cmp    (%edx),%al
  800ae9:	75 08                	jne    800af3 <strcmp+0x1c>
		p++, q++;
  800aeb:	83 c1 01             	add    $0x1,%ecx
  800aee:	83 c2 01             	add    $0x1,%edx
  800af1:	eb ed                	jmp    800ae0 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800af3:	0f b6 c0             	movzbl %al,%eax
  800af6:	0f b6 12             	movzbl (%edx),%edx
  800af9:	29 d0                	sub    %edx,%eax
}
  800afb:	5d                   	pop    %ebp
  800afc:	c3                   	ret    

00800afd <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800afd:	55                   	push   %ebp
  800afe:	89 e5                	mov    %esp,%ebp
  800b00:	53                   	push   %ebx
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b07:	89 c3                	mov    %eax,%ebx
  800b09:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b0c:	eb 06                	jmp    800b14 <strncmp+0x17>
		n--, p++, q++;
  800b0e:	83 c0 01             	add    $0x1,%eax
  800b11:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b14:	39 d8                	cmp    %ebx,%eax
  800b16:	74 16                	je     800b2e <strncmp+0x31>
  800b18:	0f b6 08             	movzbl (%eax),%ecx
  800b1b:	84 c9                	test   %cl,%cl
  800b1d:	74 04                	je     800b23 <strncmp+0x26>
  800b1f:	3a 0a                	cmp    (%edx),%cl
  800b21:	74 eb                	je     800b0e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b23:	0f b6 00             	movzbl (%eax),%eax
  800b26:	0f b6 12             	movzbl (%edx),%edx
  800b29:	29 d0                	sub    %edx,%eax
}
  800b2b:	5b                   	pop    %ebx
  800b2c:	5d                   	pop    %ebp
  800b2d:	c3                   	ret    
		return 0;
  800b2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b33:	eb f6                	jmp    800b2b <strncmp+0x2e>

00800b35 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b35:	55                   	push   %ebp
  800b36:	89 e5                	mov    %esp,%ebp
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b3f:	0f b6 10             	movzbl (%eax),%edx
  800b42:	84 d2                	test   %dl,%dl
  800b44:	74 09                	je     800b4f <strchr+0x1a>
		if (*s == c)
  800b46:	38 ca                	cmp    %cl,%dl
  800b48:	74 0a                	je     800b54 <strchr+0x1f>
	for (; *s; s++)
  800b4a:	83 c0 01             	add    $0x1,%eax
  800b4d:	eb f0                	jmp    800b3f <strchr+0xa>
			return (char *) s;
	return 0;
  800b4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b54:	5d                   	pop    %ebp
  800b55:	c3                   	ret    

00800b56 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b60:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b63:	38 ca                	cmp    %cl,%dl
  800b65:	74 09                	je     800b70 <strfind+0x1a>
  800b67:	84 d2                	test   %dl,%dl
  800b69:	74 05                	je     800b70 <strfind+0x1a>
	for (; *s; s++)
  800b6b:	83 c0 01             	add    $0x1,%eax
  800b6e:	eb f0                	jmp    800b60 <strfind+0xa>
			break;
	return (char *) s;
}
  800b70:	5d                   	pop    %ebp
  800b71:	c3                   	ret    

00800b72 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	57                   	push   %edi
  800b76:	56                   	push   %esi
  800b77:	53                   	push   %ebx
  800b78:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b7e:	85 c9                	test   %ecx,%ecx
  800b80:	74 31                	je     800bb3 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b82:	89 f8                	mov    %edi,%eax
  800b84:	09 c8                	or     %ecx,%eax
  800b86:	a8 03                	test   $0x3,%al
  800b88:	75 23                	jne    800bad <memset+0x3b>
		c &= 0xFF;
  800b8a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b8e:	89 d3                	mov    %edx,%ebx
  800b90:	c1 e3 08             	shl    $0x8,%ebx
  800b93:	89 d0                	mov    %edx,%eax
  800b95:	c1 e0 18             	shl    $0x18,%eax
  800b98:	89 d6                	mov    %edx,%esi
  800b9a:	c1 e6 10             	shl    $0x10,%esi
  800b9d:	09 f0                	or     %esi,%eax
  800b9f:	09 c2                	or     %eax,%edx
  800ba1:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ba3:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ba6:	89 d0                	mov    %edx,%eax
  800ba8:	fc                   	cld    
  800ba9:	f3 ab                	rep stos %eax,%es:(%edi)
  800bab:	eb 06                	jmp    800bb3 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb0:	fc                   	cld    
  800bb1:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bb3:	89 f8                	mov    %edi,%eax
  800bb5:	5b                   	pop    %ebx
  800bb6:	5e                   	pop    %esi
  800bb7:	5f                   	pop    %edi
  800bb8:	5d                   	pop    %ebp
  800bb9:	c3                   	ret    

00800bba <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	57                   	push   %edi
  800bbe:	56                   	push   %esi
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bc5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bc8:	39 c6                	cmp    %eax,%esi
  800bca:	73 32                	jae    800bfe <memmove+0x44>
  800bcc:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bcf:	39 c2                	cmp    %eax,%edx
  800bd1:	76 2b                	jbe    800bfe <memmove+0x44>
		s += n;
		d += n;
  800bd3:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bd6:	89 fe                	mov    %edi,%esi
  800bd8:	09 ce                	or     %ecx,%esi
  800bda:	09 d6                	or     %edx,%esi
  800bdc:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800be2:	75 0e                	jne    800bf2 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800be4:	83 ef 04             	sub    $0x4,%edi
  800be7:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bea:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bed:	fd                   	std    
  800bee:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bf0:	eb 09                	jmp    800bfb <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bf2:	83 ef 01             	sub    $0x1,%edi
  800bf5:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bf8:	fd                   	std    
  800bf9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bfb:	fc                   	cld    
  800bfc:	eb 1a                	jmp    800c18 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bfe:	89 c2                	mov    %eax,%edx
  800c00:	09 ca                	or     %ecx,%edx
  800c02:	09 f2                	or     %esi,%edx
  800c04:	f6 c2 03             	test   $0x3,%dl
  800c07:	75 0a                	jne    800c13 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c09:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c0c:	89 c7                	mov    %eax,%edi
  800c0e:	fc                   	cld    
  800c0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c11:	eb 05                	jmp    800c18 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c13:	89 c7                	mov    %eax,%edi
  800c15:	fc                   	cld    
  800c16:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c18:	5e                   	pop    %esi
  800c19:	5f                   	pop    %edi
  800c1a:	5d                   	pop    %ebp
  800c1b:	c3                   	ret    

00800c1c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c22:	ff 75 10             	pushl  0x10(%ebp)
  800c25:	ff 75 0c             	pushl  0xc(%ebp)
  800c28:	ff 75 08             	pushl  0x8(%ebp)
  800c2b:	e8 8a ff ff ff       	call   800bba <memmove>
}
  800c30:	c9                   	leave  
  800c31:	c3                   	ret    

00800c32 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	56                   	push   %esi
  800c36:	53                   	push   %ebx
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3d:	89 c6                	mov    %eax,%esi
  800c3f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c42:	39 f0                	cmp    %esi,%eax
  800c44:	74 1c                	je     800c62 <memcmp+0x30>
		if (*s1 != *s2)
  800c46:	0f b6 08             	movzbl (%eax),%ecx
  800c49:	0f b6 1a             	movzbl (%edx),%ebx
  800c4c:	38 d9                	cmp    %bl,%cl
  800c4e:	75 08                	jne    800c58 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c50:	83 c0 01             	add    $0x1,%eax
  800c53:	83 c2 01             	add    $0x1,%edx
  800c56:	eb ea                	jmp    800c42 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c58:	0f b6 c1             	movzbl %cl,%eax
  800c5b:	0f b6 db             	movzbl %bl,%ebx
  800c5e:	29 d8                	sub    %ebx,%eax
  800c60:	eb 05                	jmp    800c67 <memcmp+0x35>
	}

	return 0;
  800c62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c67:	5b                   	pop    %ebx
  800c68:	5e                   	pop    %esi
  800c69:	5d                   	pop    %ebp
  800c6a:	c3                   	ret    

00800c6b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c74:	89 c2                	mov    %eax,%edx
  800c76:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c79:	39 d0                	cmp    %edx,%eax
  800c7b:	73 09                	jae    800c86 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c7d:	38 08                	cmp    %cl,(%eax)
  800c7f:	74 05                	je     800c86 <memfind+0x1b>
	for (; s < ends; s++)
  800c81:	83 c0 01             	add    $0x1,%eax
  800c84:	eb f3                	jmp    800c79 <memfind+0xe>
			break;
	return (void *) s;
}
  800c86:	5d                   	pop    %ebp
  800c87:	c3                   	ret    

00800c88 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	57                   	push   %edi
  800c8c:	56                   	push   %esi
  800c8d:	53                   	push   %ebx
  800c8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c91:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c94:	eb 03                	jmp    800c99 <strtol+0x11>
		s++;
  800c96:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c99:	0f b6 01             	movzbl (%ecx),%eax
  800c9c:	3c 20                	cmp    $0x20,%al
  800c9e:	74 f6                	je     800c96 <strtol+0xe>
  800ca0:	3c 09                	cmp    $0x9,%al
  800ca2:	74 f2                	je     800c96 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ca4:	3c 2b                	cmp    $0x2b,%al
  800ca6:	74 2a                	je     800cd2 <strtol+0x4a>
	int neg = 0;
  800ca8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800cad:	3c 2d                	cmp    $0x2d,%al
  800caf:	74 2b                	je     800cdc <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cb1:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cb7:	75 0f                	jne    800cc8 <strtol+0x40>
  800cb9:	80 39 30             	cmpb   $0x30,(%ecx)
  800cbc:	74 28                	je     800ce6 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cbe:	85 db                	test   %ebx,%ebx
  800cc0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cc5:	0f 44 d8             	cmove  %eax,%ebx
  800cc8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ccd:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cd0:	eb 50                	jmp    800d22 <strtol+0x9a>
		s++;
  800cd2:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cd5:	bf 00 00 00 00       	mov    $0x0,%edi
  800cda:	eb d5                	jmp    800cb1 <strtol+0x29>
		s++, neg = 1;
  800cdc:	83 c1 01             	add    $0x1,%ecx
  800cdf:	bf 01 00 00 00       	mov    $0x1,%edi
  800ce4:	eb cb                	jmp    800cb1 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ce6:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cea:	74 0e                	je     800cfa <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800cec:	85 db                	test   %ebx,%ebx
  800cee:	75 d8                	jne    800cc8 <strtol+0x40>
		s++, base = 8;
  800cf0:	83 c1 01             	add    $0x1,%ecx
  800cf3:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cf8:	eb ce                	jmp    800cc8 <strtol+0x40>
		s += 2, base = 16;
  800cfa:	83 c1 02             	add    $0x2,%ecx
  800cfd:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d02:	eb c4                	jmp    800cc8 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d04:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d07:	89 f3                	mov    %esi,%ebx
  800d09:	80 fb 19             	cmp    $0x19,%bl
  800d0c:	77 29                	ja     800d37 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d0e:	0f be d2             	movsbl %dl,%edx
  800d11:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d14:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d17:	7d 30                	jge    800d49 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d19:	83 c1 01             	add    $0x1,%ecx
  800d1c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d20:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d22:	0f b6 11             	movzbl (%ecx),%edx
  800d25:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d28:	89 f3                	mov    %esi,%ebx
  800d2a:	80 fb 09             	cmp    $0x9,%bl
  800d2d:	77 d5                	ja     800d04 <strtol+0x7c>
			dig = *s - '0';
  800d2f:	0f be d2             	movsbl %dl,%edx
  800d32:	83 ea 30             	sub    $0x30,%edx
  800d35:	eb dd                	jmp    800d14 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d37:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d3a:	89 f3                	mov    %esi,%ebx
  800d3c:	80 fb 19             	cmp    $0x19,%bl
  800d3f:	77 08                	ja     800d49 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d41:	0f be d2             	movsbl %dl,%edx
  800d44:	83 ea 37             	sub    $0x37,%edx
  800d47:	eb cb                	jmp    800d14 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d4d:	74 05                	je     800d54 <strtol+0xcc>
		*endptr = (char *) s;
  800d4f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d52:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d54:	89 c2                	mov    %eax,%edx
  800d56:	f7 da                	neg    %edx
  800d58:	85 ff                	test   %edi,%edi
  800d5a:	0f 45 c2             	cmovne %edx,%eax
}
  800d5d:	5b                   	pop    %ebx
  800d5e:	5e                   	pop    %esi
  800d5f:	5f                   	pop    %edi
  800d60:	5d                   	pop    %ebp
  800d61:	c3                   	ret    

00800d62 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	57                   	push   %edi
  800d66:	56                   	push   %esi
  800d67:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d68:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d73:	89 c3                	mov    %eax,%ebx
  800d75:	89 c7                	mov    %eax,%edi
  800d77:	89 c6                	mov    %eax,%esi
  800d79:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d7b:	5b                   	pop    %ebx
  800d7c:	5e                   	pop    %esi
  800d7d:	5f                   	pop    %edi
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    

00800d80 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	57                   	push   %edi
  800d84:	56                   	push   %esi
  800d85:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d86:	ba 00 00 00 00       	mov    $0x0,%edx
  800d8b:	b8 01 00 00 00       	mov    $0x1,%eax
  800d90:	89 d1                	mov    %edx,%ecx
  800d92:	89 d3                	mov    %edx,%ebx
  800d94:	89 d7                	mov    %edx,%edi
  800d96:	89 d6                	mov    %edx,%esi
  800d98:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d9a:	5b                   	pop    %ebx
  800d9b:	5e                   	pop    %esi
  800d9c:	5f                   	pop    %edi
  800d9d:	5d                   	pop    %ebp
  800d9e:	c3                   	ret    

00800d9f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	57                   	push   %edi
  800da3:	56                   	push   %esi
  800da4:	53                   	push   %ebx
  800da5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dad:	8b 55 08             	mov    0x8(%ebp),%edx
  800db0:	b8 03 00 00 00       	mov    $0x3,%eax
  800db5:	89 cb                	mov    %ecx,%ebx
  800db7:	89 cf                	mov    %ecx,%edi
  800db9:	89 ce                	mov    %ecx,%esi
  800dbb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dbd:	85 c0                	test   %eax,%eax
  800dbf:	7f 08                	jg     800dc9 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc4:	5b                   	pop    %ebx
  800dc5:	5e                   	pop    %esi
  800dc6:	5f                   	pop    %edi
  800dc7:	5d                   	pop    %ebp
  800dc8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc9:	83 ec 0c             	sub    $0xc,%esp
  800dcc:	50                   	push   %eax
  800dcd:	6a 03                	push   $0x3
  800dcf:	68 28 2b 80 00       	push   $0x802b28
  800dd4:	6a 43                	push   $0x43
  800dd6:	68 45 2b 80 00       	push   $0x802b45
  800ddb:	e8 f7 f3 ff ff       	call   8001d7 <_panic>

00800de0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	57                   	push   %edi
  800de4:	56                   	push   %esi
  800de5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de6:	ba 00 00 00 00       	mov    $0x0,%edx
  800deb:	b8 02 00 00 00       	mov    $0x2,%eax
  800df0:	89 d1                	mov    %edx,%ecx
  800df2:	89 d3                	mov    %edx,%ebx
  800df4:	89 d7                	mov    %edx,%edi
  800df6:	89 d6                	mov    %edx,%esi
  800df8:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dfa:	5b                   	pop    %ebx
  800dfb:	5e                   	pop    %esi
  800dfc:	5f                   	pop    %edi
  800dfd:	5d                   	pop    %ebp
  800dfe:	c3                   	ret    

00800dff <sys_yield>:

void
sys_yield(void)
{
  800dff:	55                   	push   %ebp
  800e00:	89 e5                	mov    %esp,%ebp
  800e02:	57                   	push   %edi
  800e03:	56                   	push   %esi
  800e04:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e05:	ba 00 00 00 00       	mov    $0x0,%edx
  800e0a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e0f:	89 d1                	mov    %edx,%ecx
  800e11:	89 d3                	mov    %edx,%ebx
  800e13:	89 d7                	mov    %edx,%edi
  800e15:	89 d6                	mov    %edx,%esi
  800e17:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e19:	5b                   	pop    %ebx
  800e1a:	5e                   	pop    %esi
  800e1b:	5f                   	pop    %edi
  800e1c:	5d                   	pop    %ebp
  800e1d:	c3                   	ret    

00800e1e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	57                   	push   %edi
  800e22:	56                   	push   %esi
  800e23:	53                   	push   %ebx
  800e24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e27:	be 00 00 00 00       	mov    $0x0,%esi
  800e2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e32:	b8 04 00 00 00       	mov    $0x4,%eax
  800e37:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e3a:	89 f7                	mov    %esi,%edi
  800e3c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3e:	85 c0                	test   %eax,%eax
  800e40:	7f 08                	jg     800e4a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e45:	5b                   	pop    %ebx
  800e46:	5e                   	pop    %esi
  800e47:	5f                   	pop    %edi
  800e48:	5d                   	pop    %ebp
  800e49:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4a:	83 ec 0c             	sub    $0xc,%esp
  800e4d:	50                   	push   %eax
  800e4e:	6a 04                	push   $0x4
  800e50:	68 28 2b 80 00       	push   $0x802b28
  800e55:	6a 43                	push   $0x43
  800e57:	68 45 2b 80 00       	push   $0x802b45
  800e5c:	e8 76 f3 ff ff       	call   8001d7 <_panic>

00800e61 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e61:	55                   	push   %ebp
  800e62:	89 e5                	mov    %esp,%ebp
  800e64:	57                   	push   %edi
  800e65:	56                   	push   %esi
  800e66:	53                   	push   %ebx
  800e67:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e70:	b8 05 00 00 00       	mov    $0x5,%eax
  800e75:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e78:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e7b:	8b 75 18             	mov    0x18(%ebp),%esi
  800e7e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e80:	85 c0                	test   %eax,%eax
  800e82:	7f 08                	jg     800e8c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e87:	5b                   	pop    %ebx
  800e88:	5e                   	pop    %esi
  800e89:	5f                   	pop    %edi
  800e8a:	5d                   	pop    %ebp
  800e8b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8c:	83 ec 0c             	sub    $0xc,%esp
  800e8f:	50                   	push   %eax
  800e90:	6a 05                	push   $0x5
  800e92:	68 28 2b 80 00       	push   $0x802b28
  800e97:	6a 43                	push   $0x43
  800e99:	68 45 2b 80 00       	push   $0x802b45
  800e9e:	e8 34 f3 ff ff       	call   8001d7 <_panic>

00800ea3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	57                   	push   %edi
  800ea7:	56                   	push   %esi
  800ea8:	53                   	push   %ebx
  800ea9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eac:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb1:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb7:	b8 06 00 00 00       	mov    $0x6,%eax
  800ebc:	89 df                	mov    %ebx,%edi
  800ebe:	89 de                	mov    %ebx,%esi
  800ec0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec2:	85 c0                	test   %eax,%eax
  800ec4:	7f 08                	jg     800ece <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ec6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec9:	5b                   	pop    %ebx
  800eca:	5e                   	pop    %esi
  800ecb:	5f                   	pop    %edi
  800ecc:	5d                   	pop    %ebp
  800ecd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ece:	83 ec 0c             	sub    $0xc,%esp
  800ed1:	50                   	push   %eax
  800ed2:	6a 06                	push   $0x6
  800ed4:	68 28 2b 80 00       	push   $0x802b28
  800ed9:	6a 43                	push   $0x43
  800edb:	68 45 2b 80 00       	push   $0x802b45
  800ee0:	e8 f2 f2 ff ff       	call   8001d7 <_panic>

00800ee5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	57                   	push   %edi
  800ee9:	56                   	push   %esi
  800eea:	53                   	push   %ebx
  800eeb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eee:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef9:	b8 08 00 00 00       	mov    $0x8,%eax
  800efe:	89 df                	mov    %ebx,%edi
  800f00:	89 de                	mov    %ebx,%esi
  800f02:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f04:	85 c0                	test   %eax,%eax
  800f06:	7f 08                	jg     800f10 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f0b:	5b                   	pop    %ebx
  800f0c:	5e                   	pop    %esi
  800f0d:	5f                   	pop    %edi
  800f0e:	5d                   	pop    %ebp
  800f0f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f10:	83 ec 0c             	sub    $0xc,%esp
  800f13:	50                   	push   %eax
  800f14:	6a 08                	push   $0x8
  800f16:	68 28 2b 80 00       	push   $0x802b28
  800f1b:	6a 43                	push   $0x43
  800f1d:	68 45 2b 80 00       	push   $0x802b45
  800f22:	e8 b0 f2 ff ff       	call   8001d7 <_panic>

00800f27 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f27:	55                   	push   %ebp
  800f28:	89 e5                	mov    %esp,%ebp
  800f2a:	57                   	push   %edi
  800f2b:	56                   	push   %esi
  800f2c:	53                   	push   %ebx
  800f2d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f30:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f35:	8b 55 08             	mov    0x8(%ebp),%edx
  800f38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3b:	b8 09 00 00 00       	mov    $0x9,%eax
  800f40:	89 df                	mov    %ebx,%edi
  800f42:	89 de                	mov    %ebx,%esi
  800f44:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f46:	85 c0                	test   %eax,%eax
  800f48:	7f 08                	jg     800f52 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f4d:	5b                   	pop    %ebx
  800f4e:	5e                   	pop    %esi
  800f4f:	5f                   	pop    %edi
  800f50:	5d                   	pop    %ebp
  800f51:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f52:	83 ec 0c             	sub    $0xc,%esp
  800f55:	50                   	push   %eax
  800f56:	6a 09                	push   $0x9
  800f58:	68 28 2b 80 00       	push   $0x802b28
  800f5d:	6a 43                	push   $0x43
  800f5f:	68 45 2b 80 00       	push   $0x802b45
  800f64:	e8 6e f2 ff ff       	call   8001d7 <_panic>

00800f69 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f69:	55                   	push   %ebp
  800f6a:	89 e5                	mov    %esp,%ebp
  800f6c:	57                   	push   %edi
  800f6d:	56                   	push   %esi
  800f6e:	53                   	push   %ebx
  800f6f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f72:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f77:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f82:	89 df                	mov    %ebx,%edi
  800f84:	89 de                	mov    %ebx,%esi
  800f86:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f88:	85 c0                	test   %eax,%eax
  800f8a:	7f 08                	jg     800f94 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f8f:	5b                   	pop    %ebx
  800f90:	5e                   	pop    %esi
  800f91:	5f                   	pop    %edi
  800f92:	5d                   	pop    %ebp
  800f93:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f94:	83 ec 0c             	sub    $0xc,%esp
  800f97:	50                   	push   %eax
  800f98:	6a 0a                	push   $0xa
  800f9a:	68 28 2b 80 00       	push   $0x802b28
  800f9f:	6a 43                	push   $0x43
  800fa1:	68 45 2b 80 00       	push   $0x802b45
  800fa6:	e8 2c f2 ff ff       	call   8001d7 <_panic>

00800fab <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
  800fae:	57                   	push   %edi
  800faf:	56                   	push   %esi
  800fb0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fb1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb7:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fbc:	be 00 00 00 00       	mov    $0x0,%esi
  800fc1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fc4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fc7:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fc9:	5b                   	pop    %ebx
  800fca:	5e                   	pop    %esi
  800fcb:	5f                   	pop    %edi
  800fcc:	5d                   	pop    %ebp
  800fcd:	c3                   	ret    

00800fce <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
  800fd1:	57                   	push   %edi
  800fd2:	56                   	push   %esi
  800fd3:	53                   	push   %ebx
  800fd4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdf:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fe4:	89 cb                	mov    %ecx,%ebx
  800fe6:	89 cf                	mov    %ecx,%edi
  800fe8:	89 ce                	mov    %ecx,%esi
  800fea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fec:	85 c0                	test   %eax,%eax
  800fee:	7f 08                	jg     800ff8 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ff0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff3:	5b                   	pop    %ebx
  800ff4:	5e                   	pop    %esi
  800ff5:	5f                   	pop    %edi
  800ff6:	5d                   	pop    %ebp
  800ff7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff8:	83 ec 0c             	sub    $0xc,%esp
  800ffb:	50                   	push   %eax
  800ffc:	6a 0d                	push   $0xd
  800ffe:	68 28 2b 80 00       	push   $0x802b28
  801003:	6a 43                	push   $0x43
  801005:	68 45 2b 80 00       	push   $0x802b45
  80100a:	e8 c8 f1 ff ff       	call   8001d7 <_panic>

0080100f <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	57                   	push   %edi
  801013:	56                   	push   %esi
  801014:	53                   	push   %ebx
	asm volatile("int %1\n"
  801015:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101a:	8b 55 08             	mov    0x8(%ebp),%edx
  80101d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801020:	b8 0e 00 00 00       	mov    $0xe,%eax
  801025:	89 df                	mov    %ebx,%edi
  801027:	89 de                	mov    %ebx,%esi
  801029:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80102b:	5b                   	pop    %ebx
  80102c:	5e                   	pop    %esi
  80102d:	5f                   	pop    %edi
  80102e:	5d                   	pop    %ebp
  80102f:	c3                   	ret    

00801030 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
  801033:	57                   	push   %edi
  801034:	56                   	push   %esi
  801035:	53                   	push   %ebx
	asm volatile("int %1\n"
  801036:	b9 00 00 00 00       	mov    $0x0,%ecx
  80103b:	8b 55 08             	mov    0x8(%ebp),%edx
  80103e:	b8 0f 00 00 00       	mov    $0xf,%eax
  801043:	89 cb                	mov    %ecx,%ebx
  801045:	89 cf                	mov    %ecx,%edi
  801047:	89 ce                	mov    %ecx,%esi
  801049:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80104b:	5b                   	pop    %ebx
  80104c:	5e                   	pop    %esi
  80104d:	5f                   	pop    %edi
  80104e:	5d                   	pop    %ebp
  80104f:	c3                   	ret    

00801050 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801050:	55                   	push   %ebp
  801051:	89 e5                	mov    %esp,%ebp
  801053:	57                   	push   %edi
  801054:	56                   	push   %esi
  801055:	53                   	push   %ebx
	asm volatile("int %1\n"
  801056:	ba 00 00 00 00       	mov    $0x0,%edx
  80105b:	b8 10 00 00 00       	mov    $0x10,%eax
  801060:	89 d1                	mov    %edx,%ecx
  801062:	89 d3                	mov    %edx,%ebx
  801064:	89 d7                	mov    %edx,%edi
  801066:	89 d6                	mov    %edx,%esi
  801068:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80106a:	5b                   	pop    %ebx
  80106b:	5e                   	pop    %esi
  80106c:	5f                   	pop    %edi
  80106d:	5d                   	pop    %ebp
  80106e:	c3                   	ret    

0080106f <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80106f:	55                   	push   %ebp
  801070:	89 e5                	mov    %esp,%ebp
  801072:	57                   	push   %edi
  801073:	56                   	push   %esi
  801074:	53                   	push   %ebx
	asm volatile("int %1\n"
  801075:	bb 00 00 00 00       	mov    $0x0,%ebx
  80107a:	8b 55 08             	mov    0x8(%ebp),%edx
  80107d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801080:	b8 11 00 00 00       	mov    $0x11,%eax
  801085:	89 df                	mov    %ebx,%edi
  801087:	89 de                	mov    %ebx,%esi
  801089:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80108b:	5b                   	pop    %ebx
  80108c:	5e                   	pop    %esi
  80108d:	5f                   	pop    %edi
  80108e:	5d                   	pop    %ebp
  80108f:	c3                   	ret    

00801090 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	57                   	push   %edi
  801094:	56                   	push   %esi
  801095:	53                   	push   %ebx
	asm volatile("int %1\n"
  801096:	bb 00 00 00 00       	mov    $0x0,%ebx
  80109b:	8b 55 08             	mov    0x8(%ebp),%edx
  80109e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a1:	b8 12 00 00 00       	mov    $0x12,%eax
  8010a6:	89 df                	mov    %ebx,%edi
  8010a8:	89 de                	mov    %ebx,%esi
  8010aa:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010ac:	5b                   	pop    %ebx
  8010ad:	5e                   	pop    %esi
  8010ae:	5f                   	pop    %edi
  8010af:	5d                   	pop    %ebp
  8010b0:	c3                   	ret    

008010b1 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8010b1:	55                   	push   %ebp
  8010b2:	89 e5                	mov    %esp,%ebp
  8010b4:	57                   	push   %edi
  8010b5:	56                   	push   %esi
  8010b6:	53                   	push   %ebx
  8010b7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c5:	b8 13 00 00 00       	mov    $0x13,%eax
  8010ca:	89 df                	mov    %ebx,%edi
  8010cc:	89 de                	mov    %ebx,%esi
  8010ce:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010d0:	85 c0                	test   %eax,%eax
  8010d2:	7f 08                	jg     8010dc <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010d7:	5b                   	pop    %ebx
  8010d8:	5e                   	pop    %esi
  8010d9:	5f                   	pop    %edi
  8010da:	5d                   	pop    %ebp
  8010db:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010dc:	83 ec 0c             	sub    $0xc,%esp
  8010df:	50                   	push   %eax
  8010e0:	6a 13                	push   $0x13
  8010e2:	68 28 2b 80 00       	push   $0x802b28
  8010e7:	6a 43                	push   $0x43
  8010e9:	68 45 2b 80 00       	push   $0x802b45
  8010ee:	e8 e4 f0 ff ff       	call   8001d7 <_panic>

008010f3 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8010f3:	55                   	push   %ebp
  8010f4:	89 e5                	mov    %esp,%ebp
  8010f6:	57                   	push   %edi
  8010f7:	56                   	push   %esi
  8010f8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010f9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010fe:	8b 55 08             	mov    0x8(%ebp),%edx
  801101:	b8 14 00 00 00       	mov    $0x14,%eax
  801106:	89 cb                	mov    %ecx,%ebx
  801108:	89 cf                	mov    %ecx,%edi
  80110a:	89 ce                	mov    %ecx,%esi
  80110c:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80110e:	5b                   	pop    %ebx
  80110f:	5e                   	pop    %esi
  801110:	5f                   	pop    %edi
  801111:	5d                   	pop    %ebp
  801112:	c3                   	ret    

00801113 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801113:	55                   	push   %ebp
  801114:	89 e5                	mov    %esp,%ebp
  801116:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801119:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  801120:	74 0a                	je     80112c <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  80112a:	c9                   	leave  
  80112b:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80112c:	83 ec 04             	sub    $0x4,%esp
  80112f:	6a 07                	push   $0x7
  801131:	68 00 f0 bf ee       	push   $0xeebff000
  801136:	6a 00                	push   $0x0
  801138:	e8 e1 fc ff ff       	call   800e1e <sys_page_alloc>
		if(r < 0)
  80113d:	83 c4 10             	add    $0x10,%esp
  801140:	85 c0                	test   %eax,%eax
  801142:	78 2a                	js     80116e <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  801144:	83 ec 08             	sub    $0x8,%esp
  801147:	68 82 11 80 00       	push   $0x801182
  80114c:	6a 00                	push   $0x0
  80114e:	e8 16 fe ff ff       	call   800f69 <sys_env_set_pgfault_upcall>
		if(r < 0)
  801153:	83 c4 10             	add    $0x10,%esp
  801156:	85 c0                	test   %eax,%eax
  801158:	79 c8                	jns    801122 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  80115a:	83 ec 04             	sub    $0x4,%esp
  80115d:	68 84 2b 80 00       	push   $0x802b84
  801162:	6a 25                	push   $0x25
  801164:	68 bd 2b 80 00       	push   $0x802bbd
  801169:	e8 69 f0 ff ff       	call   8001d7 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  80116e:	83 ec 04             	sub    $0x4,%esp
  801171:	68 54 2b 80 00       	push   $0x802b54
  801176:	6a 22                	push   $0x22
  801178:	68 bd 2b 80 00       	push   $0x802bbd
  80117d:	e8 55 f0 ff ff       	call   8001d7 <_panic>

00801182 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801182:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801183:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  801188:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80118a:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  80118d:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  801191:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  801195:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801198:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80119a:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  80119e:	83 c4 08             	add    $0x8,%esp
	popal
  8011a1:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8011a2:	83 c4 04             	add    $0x4,%esp
	popfl
  8011a5:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8011a6:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8011a7:	c3                   	ret    

008011a8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ae:	05 00 00 00 30       	add    $0x30000000,%eax
  8011b3:	c1 e8 0c             	shr    $0xc,%eax
}
  8011b6:	5d                   	pop    %ebp
  8011b7:	c3                   	ret    

008011b8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011b8:	55                   	push   %ebp
  8011b9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011c8:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011cd:	5d                   	pop    %ebp
  8011ce:	c3                   	ret    

008011cf <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011d7:	89 c2                	mov    %eax,%edx
  8011d9:	c1 ea 16             	shr    $0x16,%edx
  8011dc:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011e3:	f6 c2 01             	test   $0x1,%dl
  8011e6:	74 2d                	je     801215 <fd_alloc+0x46>
  8011e8:	89 c2                	mov    %eax,%edx
  8011ea:	c1 ea 0c             	shr    $0xc,%edx
  8011ed:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011f4:	f6 c2 01             	test   $0x1,%dl
  8011f7:	74 1c                	je     801215 <fd_alloc+0x46>
  8011f9:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011fe:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801203:	75 d2                	jne    8011d7 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80120e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801213:	eb 0a                	jmp    80121f <fd_alloc+0x50>
			*fd_store = fd;
  801215:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801218:	89 01                	mov    %eax,(%ecx)
			return 0;
  80121a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80121f:	5d                   	pop    %ebp
  801220:	c3                   	ret    

00801221 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801227:	83 f8 1f             	cmp    $0x1f,%eax
  80122a:	77 30                	ja     80125c <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80122c:	c1 e0 0c             	shl    $0xc,%eax
  80122f:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801234:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80123a:	f6 c2 01             	test   $0x1,%dl
  80123d:	74 24                	je     801263 <fd_lookup+0x42>
  80123f:	89 c2                	mov    %eax,%edx
  801241:	c1 ea 0c             	shr    $0xc,%edx
  801244:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80124b:	f6 c2 01             	test   $0x1,%dl
  80124e:	74 1a                	je     80126a <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801250:	8b 55 0c             	mov    0xc(%ebp),%edx
  801253:	89 02                	mov    %eax,(%edx)
	return 0;
  801255:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80125a:	5d                   	pop    %ebp
  80125b:	c3                   	ret    
		return -E_INVAL;
  80125c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801261:	eb f7                	jmp    80125a <fd_lookup+0x39>
		return -E_INVAL;
  801263:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801268:	eb f0                	jmp    80125a <fd_lookup+0x39>
  80126a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80126f:	eb e9                	jmp    80125a <fd_lookup+0x39>

00801271 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
  801274:	83 ec 08             	sub    $0x8,%esp
  801277:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80127a:	ba 00 00 00 00       	mov    $0x0,%edx
  80127f:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801284:	39 08                	cmp    %ecx,(%eax)
  801286:	74 38                	je     8012c0 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801288:	83 c2 01             	add    $0x1,%edx
  80128b:	8b 04 95 4c 2c 80 00 	mov    0x802c4c(,%edx,4),%eax
  801292:	85 c0                	test   %eax,%eax
  801294:	75 ee                	jne    801284 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801296:	a1 08 40 80 00       	mov    0x804008,%eax
  80129b:	8b 40 48             	mov    0x48(%eax),%eax
  80129e:	83 ec 04             	sub    $0x4,%esp
  8012a1:	51                   	push   %ecx
  8012a2:	50                   	push   %eax
  8012a3:	68 cc 2b 80 00       	push   $0x802bcc
  8012a8:	e8 20 f0 ff ff       	call   8002cd <cprintf>
	*dev = 0;
  8012ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012b6:	83 c4 10             	add    $0x10,%esp
  8012b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012be:	c9                   	leave  
  8012bf:	c3                   	ret    
			*dev = devtab[i];
  8012c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012c3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ca:	eb f2                	jmp    8012be <dev_lookup+0x4d>

008012cc <fd_close>:
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
  8012cf:	57                   	push   %edi
  8012d0:	56                   	push   %esi
  8012d1:	53                   	push   %ebx
  8012d2:	83 ec 24             	sub    $0x24,%esp
  8012d5:	8b 75 08             	mov    0x8(%ebp),%esi
  8012d8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012db:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012de:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012df:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012e5:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012e8:	50                   	push   %eax
  8012e9:	e8 33 ff ff ff       	call   801221 <fd_lookup>
  8012ee:	89 c3                	mov    %eax,%ebx
  8012f0:	83 c4 10             	add    $0x10,%esp
  8012f3:	85 c0                	test   %eax,%eax
  8012f5:	78 05                	js     8012fc <fd_close+0x30>
	    || fd != fd2)
  8012f7:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012fa:	74 16                	je     801312 <fd_close+0x46>
		return (must_exist ? r : 0);
  8012fc:	89 f8                	mov    %edi,%eax
  8012fe:	84 c0                	test   %al,%al
  801300:	b8 00 00 00 00       	mov    $0x0,%eax
  801305:	0f 44 d8             	cmove  %eax,%ebx
}
  801308:	89 d8                	mov    %ebx,%eax
  80130a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80130d:	5b                   	pop    %ebx
  80130e:	5e                   	pop    %esi
  80130f:	5f                   	pop    %edi
  801310:	5d                   	pop    %ebp
  801311:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801312:	83 ec 08             	sub    $0x8,%esp
  801315:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801318:	50                   	push   %eax
  801319:	ff 36                	pushl  (%esi)
  80131b:	e8 51 ff ff ff       	call   801271 <dev_lookup>
  801320:	89 c3                	mov    %eax,%ebx
  801322:	83 c4 10             	add    $0x10,%esp
  801325:	85 c0                	test   %eax,%eax
  801327:	78 1a                	js     801343 <fd_close+0x77>
		if (dev->dev_close)
  801329:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80132c:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80132f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801334:	85 c0                	test   %eax,%eax
  801336:	74 0b                	je     801343 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801338:	83 ec 0c             	sub    $0xc,%esp
  80133b:	56                   	push   %esi
  80133c:	ff d0                	call   *%eax
  80133e:	89 c3                	mov    %eax,%ebx
  801340:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801343:	83 ec 08             	sub    $0x8,%esp
  801346:	56                   	push   %esi
  801347:	6a 00                	push   $0x0
  801349:	e8 55 fb ff ff       	call   800ea3 <sys_page_unmap>
	return r;
  80134e:	83 c4 10             	add    $0x10,%esp
  801351:	eb b5                	jmp    801308 <fd_close+0x3c>

00801353 <close>:

int
close(int fdnum)
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
  801356:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801359:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80135c:	50                   	push   %eax
  80135d:	ff 75 08             	pushl  0x8(%ebp)
  801360:	e8 bc fe ff ff       	call   801221 <fd_lookup>
  801365:	83 c4 10             	add    $0x10,%esp
  801368:	85 c0                	test   %eax,%eax
  80136a:	79 02                	jns    80136e <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80136c:	c9                   	leave  
  80136d:	c3                   	ret    
		return fd_close(fd, 1);
  80136e:	83 ec 08             	sub    $0x8,%esp
  801371:	6a 01                	push   $0x1
  801373:	ff 75 f4             	pushl  -0xc(%ebp)
  801376:	e8 51 ff ff ff       	call   8012cc <fd_close>
  80137b:	83 c4 10             	add    $0x10,%esp
  80137e:	eb ec                	jmp    80136c <close+0x19>

00801380 <close_all>:

void
close_all(void)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	53                   	push   %ebx
  801384:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801387:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80138c:	83 ec 0c             	sub    $0xc,%esp
  80138f:	53                   	push   %ebx
  801390:	e8 be ff ff ff       	call   801353 <close>
	for (i = 0; i < MAXFD; i++)
  801395:	83 c3 01             	add    $0x1,%ebx
  801398:	83 c4 10             	add    $0x10,%esp
  80139b:	83 fb 20             	cmp    $0x20,%ebx
  80139e:	75 ec                	jne    80138c <close_all+0xc>
}
  8013a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013a3:	c9                   	leave  
  8013a4:	c3                   	ret    

008013a5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013a5:	55                   	push   %ebp
  8013a6:	89 e5                	mov    %esp,%ebp
  8013a8:	57                   	push   %edi
  8013a9:	56                   	push   %esi
  8013aa:	53                   	push   %ebx
  8013ab:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013ae:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013b1:	50                   	push   %eax
  8013b2:	ff 75 08             	pushl  0x8(%ebp)
  8013b5:	e8 67 fe ff ff       	call   801221 <fd_lookup>
  8013ba:	89 c3                	mov    %eax,%ebx
  8013bc:	83 c4 10             	add    $0x10,%esp
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	0f 88 81 00 00 00    	js     801448 <dup+0xa3>
		return r;
	close(newfdnum);
  8013c7:	83 ec 0c             	sub    $0xc,%esp
  8013ca:	ff 75 0c             	pushl  0xc(%ebp)
  8013cd:	e8 81 ff ff ff       	call   801353 <close>

	newfd = INDEX2FD(newfdnum);
  8013d2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013d5:	c1 e6 0c             	shl    $0xc,%esi
  8013d8:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013de:	83 c4 04             	add    $0x4,%esp
  8013e1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013e4:	e8 cf fd ff ff       	call   8011b8 <fd2data>
  8013e9:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013eb:	89 34 24             	mov    %esi,(%esp)
  8013ee:	e8 c5 fd ff ff       	call   8011b8 <fd2data>
  8013f3:	83 c4 10             	add    $0x10,%esp
  8013f6:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013f8:	89 d8                	mov    %ebx,%eax
  8013fa:	c1 e8 16             	shr    $0x16,%eax
  8013fd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801404:	a8 01                	test   $0x1,%al
  801406:	74 11                	je     801419 <dup+0x74>
  801408:	89 d8                	mov    %ebx,%eax
  80140a:	c1 e8 0c             	shr    $0xc,%eax
  80140d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801414:	f6 c2 01             	test   $0x1,%dl
  801417:	75 39                	jne    801452 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801419:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80141c:	89 d0                	mov    %edx,%eax
  80141e:	c1 e8 0c             	shr    $0xc,%eax
  801421:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801428:	83 ec 0c             	sub    $0xc,%esp
  80142b:	25 07 0e 00 00       	and    $0xe07,%eax
  801430:	50                   	push   %eax
  801431:	56                   	push   %esi
  801432:	6a 00                	push   $0x0
  801434:	52                   	push   %edx
  801435:	6a 00                	push   $0x0
  801437:	e8 25 fa ff ff       	call   800e61 <sys_page_map>
  80143c:	89 c3                	mov    %eax,%ebx
  80143e:	83 c4 20             	add    $0x20,%esp
  801441:	85 c0                	test   %eax,%eax
  801443:	78 31                	js     801476 <dup+0xd1>
		goto err;

	return newfdnum;
  801445:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801448:	89 d8                	mov    %ebx,%eax
  80144a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80144d:	5b                   	pop    %ebx
  80144e:	5e                   	pop    %esi
  80144f:	5f                   	pop    %edi
  801450:	5d                   	pop    %ebp
  801451:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801452:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801459:	83 ec 0c             	sub    $0xc,%esp
  80145c:	25 07 0e 00 00       	and    $0xe07,%eax
  801461:	50                   	push   %eax
  801462:	57                   	push   %edi
  801463:	6a 00                	push   $0x0
  801465:	53                   	push   %ebx
  801466:	6a 00                	push   $0x0
  801468:	e8 f4 f9 ff ff       	call   800e61 <sys_page_map>
  80146d:	89 c3                	mov    %eax,%ebx
  80146f:	83 c4 20             	add    $0x20,%esp
  801472:	85 c0                	test   %eax,%eax
  801474:	79 a3                	jns    801419 <dup+0x74>
	sys_page_unmap(0, newfd);
  801476:	83 ec 08             	sub    $0x8,%esp
  801479:	56                   	push   %esi
  80147a:	6a 00                	push   $0x0
  80147c:	e8 22 fa ff ff       	call   800ea3 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801481:	83 c4 08             	add    $0x8,%esp
  801484:	57                   	push   %edi
  801485:	6a 00                	push   $0x0
  801487:	e8 17 fa ff ff       	call   800ea3 <sys_page_unmap>
	return r;
  80148c:	83 c4 10             	add    $0x10,%esp
  80148f:	eb b7                	jmp    801448 <dup+0xa3>

00801491 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801491:	55                   	push   %ebp
  801492:	89 e5                	mov    %esp,%ebp
  801494:	53                   	push   %ebx
  801495:	83 ec 1c             	sub    $0x1c,%esp
  801498:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80149b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80149e:	50                   	push   %eax
  80149f:	53                   	push   %ebx
  8014a0:	e8 7c fd ff ff       	call   801221 <fd_lookup>
  8014a5:	83 c4 10             	add    $0x10,%esp
  8014a8:	85 c0                	test   %eax,%eax
  8014aa:	78 3f                	js     8014eb <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ac:	83 ec 08             	sub    $0x8,%esp
  8014af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b2:	50                   	push   %eax
  8014b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b6:	ff 30                	pushl  (%eax)
  8014b8:	e8 b4 fd ff ff       	call   801271 <dev_lookup>
  8014bd:	83 c4 10             	add    $0x10,%esp
  8014c0:	85 c0                	test   %eax,%eax
  8014c2:	78 27                	js     8014eb <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014c7:	8b 42 08             	mov    0x8(%edx),%eax
  8014ca:	83 e0 03             	and    $0x3,%eax
  8014cd:	83 f8 01             	cmp    $0x1,%eax
  8014d0:	74 1e                	je     8014f0 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d5:	8b 40 08             	mov    0x8(%eax),%eax
  8014d8:	85 c0                	test   %eax,%eax
  8014da:	74 35                	je     801511 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014dc:	83 ec 04             	sub    $0x4,%esp
  8014df:	ff 75 10             	pushl  0x10(%ebp)
  8014e2:	ff 75 0c             	pushl  0xc(%ebp)
  8014e5:	52                   	push   %edx
  8014e6:	ff d0                	call   *%eax
  8014e8:	83 c4 10             	add    $0x10,%esp
}
  8014eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014f0:	a1 08 40 80 00       	mov    0x804008,%eax
  8014f5:	8b 40 48             	mov    0x48(%eax),%eax
  8014f8:	83 ec 04             	sub    $0x4,%esp
  8014fb:	53                   	push   %ebx
  8014fc:	50                   	push   %eax
  8014fd:	68 10 2c 80 00       	push   $0x802c10
  801502:	e8 c6 ed ff ff       	call   8002cd <cprintf>
		return -E_INVAL;
  801507:	83 c4 10             	add    $0x10,%esp
  80150a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80150f:	eb da                	jmp    8014eb <read+0x5a>
		return -E_NOT_SUPP;
  801511:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801516:	eb d3                	jmp    8014eb <read+0x5a>

00801518 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
  80151b:	57                   	push   %edi
  80151c:	56                   	push   %esi
  80151d:	53                   	push   %ebx
  80151e:	83 ec 0c             	sub    $0xc,%esp
  801521:	8b 7d 08             	mov    0x8(%ebp),%edi
  801524:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801527:	bb 00 00 00 00       	mov    $0x0,%ebx
  80152c:	39 f3                	cmp    %esi,%ebx
  80152e:	73 23                	jae    801553 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801530:	83 ec 04             	sub    $0x4,%esp
  801533:	89 f0                	mov    %esi,%eax
  801535:	29 d8                	sub    %ebx,%eax
  801537:	50                   	push   %eax
  801538:	89 d8                	mov    %ebx,%eax
  80153a:	03 45 0c             	add    0xc(%ebp),%eax
  80153d:	50                   	push   %eax
  80153e:	57                   	push   %edi
  80153f:	e8 4d ff ff ff       	call   801491 <read>
		if (m < 0)
  801544:	83 c4 10             	add    $0x10,%esp
  801547:	85 c0                	test   %eax,%eax
  801549:	78 06                	js     801551 <readn+0x39>
			return m;
		if (m == 0)
  80154b:	74 06                	je     801553 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80154d:	01 c3                	add    %eax,%ebx
  80154f:	eb db                	jmp    80152c <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801551:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801553:	89 d8                	mov    %ebx,%eax
  801555:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801558:	5b                   	pop    %ebx
  801559:	5e                   	pop    %esi
  80155a:	5f                   	pop    %edi
  80155b:	5d                   	pop    %ebp
  80155c:	c3                   	ret    

0080155d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80155d:	55                   	push   %ebp
  80155e:	89 e5                	mov    %esp,%ebp
  801560:	53                   	push   %ebx
  801561:	83 ec 1c             	sub    $0x1c,%esp
  801564:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801567:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80156a:	50                   	push   %eax
  80156b:	53                   	push   %ebx
  80156c:	e8 b0 fc ff ff       	call   801221 <fd_lookup>
  801571:	83 c4 10             	add    $0x10,%esp
  801574:	85 c0                	test   %eax,%eax
  801576:	78 3a                	js     8015b2 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801578:	83 ec 08             	sub    $0x8,%esp
  80157b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80157e:	50                   	push   %eax
  80157f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801582:	ff 30                	pushl  (%eax)
  801584:	e8 e8 fc ff ff       	call   801271 <dev_lookup>
  801589:	83 c4 10             	add    $0x10,%esp
  80158c:	85 c0                	test   %eax,%eax
  80158e:	78 22                	js     8015b2 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801590:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801593:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801597:	74 1e                	je     8015b7 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801599:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80159c:	8b 52 0c             	mov    0xc(%edx),%edx
  80159f:	85 d2                	test   %edx,%edx
  8015a1:	74 35                	je     8015d8 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015a3:	83 ec 04             	sub    $0x4,%esp
  8015a6:	ff 75 10             	pushl  0x10(%ebp)
  8015a9:	ff 75 0c             	pushl  0xc(%ebp)
  8015ac:	50                   	push   %eax
  8015ad:	ff d2                	call   *%edx
  8015af:	83 c4 10             	add    $0x10,%esp
}
  8015b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015b5:	c9                   	leave  
  8015b6:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015b7:	a1 08 40 80 00       	mov    0x804008,%eax
  8015bc:	8b 40 48             	mov    0x48(%eax),%eax
  8015bf:	83 ec 04             	sub    $0x4,%esp
  8015c2:	53                   	push   %ebx
  8015c3:	50                   	push   %eax
  8015c4:	68 2c 2c 80 00       	push   $0x802c2c
  8015c9:	e8 ff ec ff ff       	call   8002cd <cprintf>
		return -E_INVAL;
  8015ce:	83 c4 10             	add    $0x10,%esp
  8015d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015d6:	eb da                	jmp    8015b2 <write+0x55>
		return -E_NOT_SUPP;
  8015d8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015dd:	eb d3                	jmp    8015b2 <write+0x55>

008015df <seek>:

int
seek(int fdnum, off_t offset)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
  8015e2:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015e8:	50                   	push   %eax
  8015e9:	ff 75 08             	pushl  0x8(%ebp)
  8015ec:	e8 30 fc ff ff       	call   801221 <fd_lookup>
  8015f1:	83 c4 10             	add    $0x10,%esp
  8015f4:	85 c0                	test   %eax,%eax
  8015f6:	78 0e                	js     801606 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015fe:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801601:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801606:	c9                   	leave  
  801607:	c3                   	ret    

00801608 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
  80160b:	53                   	push   %ebx
  80160c:	83 ec 1c             	sub    $0x1c,%esp
  80160f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801612:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801615:	50                   	push   %eax
  801616:	53                   	push   %ebx
  801617:	e8 05 fc ff ff       	call   801221 <fd_lookup>
  80161c:	83 c4 10             	add    $0x10,%esp
  80161f:	85 c0                	test   %eax,%eax
  801621:	78 37                	js     80165a <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801623:	83 ec 08             	sub    $0x8,%esp
  801626:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801629:	50                   	push   %eax
  80162a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162d:	ff 30                	pushl  (%eax)
  80162f:	e8 3d fc ff ff       	call   801271 <dev_lookup>
  801634:	83 c4 10             	add    $0x10,%esp
  801637:	85 c0                	test   %eax,%eax
  801639:	78 1f                	js     80165a <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80163b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801642:	74 1b                	je     80165f <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801644:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801647:	8b 52 18             	mov    0x18(%edx),%edx
  80164a:	85 d2                	test   %edx,%edx
  80164c:	74 32                	je     801680 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80164e:	83 ec 08             	sub    $0x8,%esp
  801651:	ff 75 0c             	pushl  0xc(%ebp)
  801654:	50                   	push   %eax
  801655:	ff d2                	call   *%edx
  801657:	83 c4 10             	add    $0x10,%esp
}
  80165a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80165f:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801664:	8b 40 48             	mov    0x48(%eax),%eax
  801667:	83 ec 04             	sub    $0x4,%esp
  80166a:	53                   	push   %ebx
  80166b:	50                   	push   %eax
  80166c:	68 ec 2b 80 00       	push   $0x802bec
  801671:	e8 57 ec ff ff       	call   8002cd <cprintf>
		return -E_INVAL;
  801676:	83 c4 10             	add    $0x10,%esp
  801679:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80167e:	eb da                	jmp    80165a <ftruncate+0x52>
		return -E_NOT_SUPP;
  801680:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801685:	eb d3                	jmp    80165a <ftruncate+0x52>

00801687 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
  80168a:	53                   	push   %ebx
  80168b:	83 ec 1c             	sub    $0x1c,%esp
  80168e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801691:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801694:	50                   	push   %eax
  801695:	ff 75 08             	pushl  0x8(%ebp)
  801698:	e8 84 fb ff ff       	call   801221 <fd_lookup>
  80169d:	83 c4 10             	add    $0x10,%esp
  8016a0:	85 c0                	test   %eax,%eax
  8016a2:	78 4b                	js     8016ef <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016a4:	83 ec 08             	sub    $0x8,%esp
  8016a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016aa:	50                   	push   %eax
  8016ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ae:	ff 30                	pushl  (%eax)
  8016b0:	e8 bc fb ff ff       	call   801271 <dev_lookup>
  8016b5:	83 c4 10             	add    $0x10,%esp
  8016b8:	85 c0                	test   %eax,%eax
  8016ba:	78 33                	js     8016ef <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8016bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016bf:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016c3:	74 2f                	je     8016f4 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016c5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016c8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016cf:	00 00 00 
	stat->st_isdir = 0;
  8016d2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016d9:	00 00 00 
	stat->st_dev = dev;
  8016dc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016e2:	83 ec 08             	sub    $0x8,%esp
  8016e5:	53                   	push   %ebx
  8016e6:	ff 75 f0             	pushl  -0x10(%ebp)
  8016e9:	ff 50 14             	call   *0x14(%eax)
  8016ec:	83 c4 10             	add    $0x10,%esp
}
  8016ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016f2:	c9                   	leave  
  8016f3:	c3                   	ret    
		return -E_NOT_SUPP;
  8016f4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016f9:	eb f4                	jmp    8016ef <fstat+0x68>

008016fb <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
  8016fe:	56                   	push   %esi
  8016ff:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801700:	83 ec 08             	sub    $0x8,%esp
  801703:	6a 00                	push   $0x0
  801705:	ff 75 08             	pushl  0x8(%ebp)
  801708:	e8 22 02 00 00       	call   80192f <open>
  80170d:	89 c3                	mov    %eax,%ebx
  80170f:	83 c4 10             	add    $0x10,%esp
  801712:	85 c0                	test   %eax,%eax
  801714:	78 1b                	js     801731 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801716:	83 ec 08             	sub    $0x8,%esp
  801719:	ff 75 0c             	pushl  0xc(%ebp)
  80171c:	50                   	push   %eax
  80171d:	e8 65 ff ff ff       	call   801687 <fstat>
  801722:	89 c6                	mov    %eax,%esi
	close(fd);
  801724:	89 1c 24             	mov    %ebx,(%esp)
  801727:	e8 27 fc ff ff       	call   801353 <close>
	return r;
  80172c:	83 c4 10             	add    $0x10,%esp
  80172f:	89 f3                	mov    %esi,%ebx
}
  801731:	89 d8                	mov    %ebx,%eax
  801733:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801736:	5b                   	pop    %ebx
  801737:	5e                   	pop    %esi
  801738:	5d                   	pop    %ebp
  801739:	c3                   	ret    

0080173a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	56                   	push   %esi
  80173e:	53                   	push   %ebx
  80173f:	89 c6                	mov    %eax,%esi
  801741:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801743:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80174a:	74 27                	je     801773 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80174c:	6a 07                	push   $0x7
  80174e:	68 00 50 80 00       	push   $0x805000
  801753:	56                   	push   %esi
  801754:	ff 35 00 40 80 00    	pushl  0x804000
  80175a:	e8 08 0c 00 00       	call   802367 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80175f:	83 c4 0c             	add    $0xc,%esp
  801762:	6a 00                	push   $0x0
  801764:	53                   	push   %ebx
  801765:	6a 00                	push   $0x0
  801767:	e8 92 0b 00 00       	call   8022fe <ipc_recv>
}
  80176c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80176f:	5b                   	pop    %ebx
  801770:	5e                   	pop    %esi
  801771:	5d                   	pop    %ebp
  801772:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801773:	83 ec 0c             	sub    $0xc,%esp
  801776:	6a 01                	push   $0x1
  801778:	e8 42 0c 00 00       	call   8023bf <ipc_find_env>
  80177d:	a3 00 40 80 00       	mov    %eax,0x804000
  801782:	83 c4 10             	add    $0x10,%esp
  801785:	eb c5                	jmp    80174c <fsipc+0x12>

00801787 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
  80178a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	8b 40 0c             	mov    0xc(%eax),%eax
  801793:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801798:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179b:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a5:	b8 02 00 00 00       	mov    $0x2,%eax
  8017aa:	e8 8b ff ff ff       	call   80173a <fsipc>
}
  8017af:	c9                   	leave  
  8017b0:	c3                   	ret    

008017b1 <devfile_flush>:
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
  8017b4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8017bd:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c7:	b8 06 00 00 00       	mov    $0x6,%eax
  8017cc:	e8 69 ff ff ff       	call   80173a <fsipc>
}
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <devfile_stat>:
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	53                   	push   %ebx
  8017d7:	83 ec 04             	sub    $0x4,%esp
  8017da:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e3:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ed:	b8 05 00 00 00       	mov    $0x5,%eax
  8017f2:	e8 43 ff ff ff       	call   80173a <fsipc>
  8017f7:	85 c0                	test   %eax,%eax
  8017f9:	78 2c                	js     801827 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017fb:	83 ec 08             	sub    $0x8,%esp
  8017fe:	68 00 50 80 00       	push   $0x805000
  801803:	53                   	push   %ebx
  801804:	e8 23 f2 ff ff       	call   800a2c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801809:	a1 80 50 80 00       	mov    0x805080,%eax
  80180e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801814:	a1 84 50 80 00       	mov    0x805084,%eax
  801819:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80181f:	83 c4 10             	add    $0x10,%esp
  801822:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801827:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80182a:	c9                   	leave  
  80182b:	c3                   	ret    

0080182c <devfile_write>:
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
  80182f:	53                   	push   %ebx
  801830:	83 ec 08             	sub    $0x8,%esp
  801833:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
  801839:	8b 40 0c             	mov    0xc(%eax),%eax
  80183c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801841:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801847:	53                   	push   %ebx
  801848:	ff 75 0c             	pushl  0xc(%ebp)
  80184b:	68 08 50 80 00       	push   $0x805008
  801850:	e8 c7 f3 ff ff       	call   800c1c <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801855:	ba 00 00 00 00       	mov    $0x0,%edx
  80185a:	b8 04 00 00 00       	mov    $0x4,%eax
  80185f:	e8 d6 fe ff ff       	call   80173a <fsipc>
  801864:	83 c4 10             	add    $0x10,%esp
  801867:	85 c0                	test   %eax,%eax
  801869:	78 0b                	js     801876 <devfile_write+0x4a>
	assert(r <= n);
  80186b:	39 d8                	cmp    %ebx,%eax
  80186d:	77 0c                	ja     80187b <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80186f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801874:	7f 1e                	jg     801894 <devfile_write+0x68>
}
  801876:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801879:	c9                   	leave  
  80187a:	c3                   	ret    
	assert(r <= n);
  80187b:	68 60 2c 80 00       	push   $0x802c60
  801880:	68 67 2c 80 00       	push   $0x802c67
  801885:	68 98 00 00 00       	push   $0x98
  80188a:	68 7c 2c 80 00       	push   $0x802c7c
  80188f:	e8 43 e9 ff ff       	call   8001d7 <_panic>
	assert(r <= PGSIZE);
  801894:	68 87 2c 80 00       	push   $0x802c87
  801899:	68 67 2c 80 00       	push   $0x802c67
  80189e:	68 99 00 00 00       	push   $0x99
  8018a3:	68 7c 2c 80 00       	push   $0x802c7c
  8018a8:	e8 2a e9 ff ff       	call   8001d7 <_panic>

008018ad <devfile_read>:
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
  8018b0:	56                   	push   %esi
  8018b1:	53                   	push   %ebx
  8018b2:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8018bb:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018c0:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018cb:	b8 03 00 00 00       	mov    $0x3,%eax
  8018d0:	e8 65 fe ff ff       	call   80173a <fsipc>
  8018d5:	89 c3                	mov    %eax,%ebx
  8018d7:	85 c0                	test   %eax,%eax
  8018d9:	78 1f                	js     8018fa <devfile_read+0x4d>
	assert(r <= n);
  8018db:	39 f0                	cmp    %esi,%eax
  8018dd:	77 24                	ja     801903 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018df:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018e4:	7f 33                	jg     801919 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018e6:	83 ec 04             	sub    $0x4,%esp
  8018e9:	50                   	push   %eax
  8018ea:	68 00 50 80 00       	push   $0x805000
  8018ef:	ff 75 0c             	pushl  0xc(%ebp)
  8018f2:	e8 c3 f2 ff ff       	call   800bba <memmove>
	return r;
  8018f7:	83 c4 10             	add    $0x10,%esp
}
  8018fa:	89 d8                	mov    %ebx,%eax
  8018fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ff:	5b                   	pop    %ebx
  801900:	5e                   	pop    %esi
  801901:	5d                   	pop    %ebp
  801902:	c3                   	ret    
	assert(r <= n);
  801903:	68 60 2c 80 00       	push   $0x802c60
  801908:	68 67 2c 80 00       	push   $0x802c67
  80190d:	6a 7c                	push   $0x7c
  80190f:	68 7c 2c 80 00       	push   $0x802c7c
  801914:	e8 be e8 ff ff       	call   8001d7 <_panic>
	assert(r <= PGSIZE);
  801919:	68 87 2c 80 00       	push   $0x802c87
  80191e:	68 67 2c 80 00       	push   $0x802c67
  801923:	6a 7d                	push   $0x7d
  801925:	68 7c 2c 80 00       	push   $0x802c7c
  80192a:	e8 a8 e8 ff ff       	call   8001d7 <_panic>

0080192f <open>:
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
  801932:	56                   	push   %esi
  801933:	53                   	push   %ebx
  801934:	83 ec 1c             	sub    $0x1c,%esp
  801937:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80193a:	56                   	push   %esi
  80193b:	e8 b3 f0 ff ff       	call   8009f3 <strlen>
  801940:	83 c4 10             	add    $0x10,%esp
  801943:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801948:	7f 6c                	jg     8019b6 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80194a:	83 ec 0c             	sub    $0xc,%esp
  80194d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801950:	50                   	push   %eax
  801951:	e8 79 f8 ff ff       	call   8011cf <fd_alloc>
  801956:	89 c3                	mov    %eax,%ebx
  801958:	83 c4 10             	add    $0x10,%esp
  80195b:	85 c0                	test   %eax,%eax
  80195d:	78 3c                	js     80199b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80195f:	83 ec 08             	sub    $0x8,%esp
  801962:	56                   	push   %esi
  801963:	68 00 50 80 00       	push   $0x805000
  801968:	e8 bf f0 ff ff       	call   800a2c <strcpy>
	fsipcbuf.open.req_omode = mode;
  80196d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801970:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801975:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801978:	b8 01 00 00 00       	mov    $0x1,%eax
  80197d:	e8 b8 fd ff ff       	call   80173a <fsipc>
  801982:	89 c3                	mov    %eax,%ebx
  801984:	83 c4 10             	add    $0x10,%esp
  801987:	85 c0                	test   %eax,%eax
  801989:	78 19                	js     8019a4 <open+0x75>
	return fd2num(fd);
  80198b:	83 ec 0c             	sub    $0xc,%esp
  80198e:	ff 75 f4             	pushl  -0xc(%ebp)
  801991:	e8 12 f8 ff ff       	call   8011a8 <fd2num>
  801996:	89 c3                	mov    %eax,%ebx
  801998:	83 c4 10             	add    $0x10,%esp
}
  80199b:	89 d8                	mov    %ebx,%eax
  80199d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019a0:	5b                   	pop    %ebx
  8019a1:	5e                   	pop    %esi
  8019a2:	5d                   	pop    %ebp
  8019a3:	c3                   	ret    
		fd_close(fd, 0);
  8019a4:	83 ec 08             	sub    $0x8,%esp
  8019a7:	6a 00                	push   $0x0
  8019a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ac:	e8 1b f9 ff ff       	call   8012cc <fd_close>
		return r;
  8019b1:	83 c4 10             	add    $0x10,%esp
  8019b4:	eb e5                	jmp    80199b <open+0x6c>
		return -E_BAD_PATH;
  8019b6:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019bb:	eb de                	jmp    80199b <open+0x6c>

008019bd <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c8:	b8 08 00 00 00       	mov    $0x8,%eax
  8019cd:	e8 68 fd ff ff       	call   80173a <fsipc>
}
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8019da:	68 93 2c 80 00       	push   $0x802c93
  8019df:	ff 75 0c             	pushl  0xc(%ebp)
  8019e2:	e8 45 f0 ff ff       	call   800a2c <strcpy>
	return 0;
}
  8019e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <devsock_close>:
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
  8019f1:	53                   	push   %ebx
  8019f2:	83 ec 10             	sub    $0x10,%esp
  8019f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8019f8:	53                   	push   %ebx
  8019f9:	e8 fc 09 00 00       	call   8023fa <pageref>
  8019fe:	83 c4 10             	add    $0x10,%esp
		return 0;
  801a01:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801a06:	83 f8 01             	cmp    $0x1,%eax
  801a09:	74 07                	je     801a12 <devsock_close+0x24>
}
  801a0b:	89 d0                	mov    %edx,%eax
  801a0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801a12:	83 ec 0c             	sub    $0xc,%esp
  801a15:	ff 73 0c             	pushl  0xc(%ebx)
  801a18:	e8 b9 02 00 00       	call   801cd6 <nsipc_close>
  801a1d:	89 c2                	mov    %eax,%edx
  801a1f:	83 c4 10             	add    $0x10,%esp
  801a22:	eb e7                	jmp    801a0b <devsock_close+0x1d>

00801a24 <devsock_write>:
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
  801a27:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a2a:	6a 00                	push   $0x0
  801a2c:	ff 75 10             	pushl  0x10(%ebp)
  801a2f:	ff 75 0c             	pushl  0xc(%ebp)
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	ff 70 0c             	pushl  0xc(%eax)
  801a38:	e8 76 03 00 00       	call   801db3 <nsipc_send>
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <devsock_read>:
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a45:	6a 00                	push   $0x0
  801a47:	ff 75 10             	pushl  0x10(%ebp)
  801a4a:	ff 75 0c             	pushl  0xc(%ebp)
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	ff 70 0c             	pushl  0xc(%eax)
  801a53:	e8 ef 02 00 00       	call   801d47 <nsipc_recv>
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <fd2sockid>:
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a60:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a63:	52                   	push   %edx
  801a64:	50                   	push   %eax
  801a65:	e8 b7 f7 ff ff       	call   801221 <fd_lookup>
  801a6a:	83 c4 10             	add    $0x10,%esp
  801a6d:	85 c0                	test   %eax,%eax
  801a6f:	78 10                	js     801a81 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a74:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a7a:	39 08                	cmp    %ecx,(%eax)
  801a7c:	75 05                	jne    801a83 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a7e:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    
		return -E_NOT_SUPP;
  801a83:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a88:	eb f7                	jmp    801a81 <fd2sockid+0x27>

00801a8a <alloc_sockfd>:
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
  801a8d:	56                   	push   %esi
  801a8e:	53                   	push   %ebx
  801a8f:	83 ec 1c             	sub    $0x1c,%esp
  801a92:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a94:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a97:	50                   	push   %eax
  801a98:	e8 32 f7 ff ff       	call   8011cf <fd_alloc>
  801a9d:	89 c3                	mov    %eax,%ebx
  801a9f:	83 c4 10             	add    $0x10,%esp
  801aa2:	85 c0                	test   %eax,%eax
  801aa4:	78 43                	js     801ae9 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801aa6:	83 ec 04             	sub    $0x4,%esp
  801aa9:	68 07 04 00 00       	push   $0x407
  801aae:	ff 75 f4             	pushl  -0xc(%ebp)
  801ab1:	6a 00                	push   $0x0
  801ab3:	e8 66 f3 ff ff       	call   800e1e <sys_page_alloc>
  801ab8:	89 c3                	mov    %eax,%ebx
  801aba:	83 c4 10             	add    $0x10,%esp
  801abd:	85 c0                	test   %eax,%eax
  801abf:	78 28                	js     801ae9 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac4:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801aca:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801acf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ad6:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ad9:	83 ec 0c             	sub    $0xc,%esp
  801adc:	50                   	push   %eax
  801add:	e8 c6 f6 ff ff       	call   8011a8 <fd2num>
  801ae2:	89 c3                	mov    %eax,%ebx
  801ae4:	83 c4 10             	add    $0x10,%esp
  801ae7:	eb 0c                	jmp    801af5 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801ae9:	83 ec 0c             	sub    $0xc,%esp
  801aec:	56                   	push   %esi
  801aed:	e8 e4 01 00 00       	call   801cd6 <nsipc_close>
		return r;
  801af2:	83 c4 10             	add    $0x10,%esp
}
  801af5:	89 d8                	mov    %ebx,%eax
  801af7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801afa:	5b                   	pop    %ebx
  801afb:	5e                   	pop    %esi
  801afc:	5d                   	pop    %ebp
  801afd:	c3                   	ret    

00801afe <accept>:
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
  801b01:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	e8 4e ff ff ff       	call   801a5a <fd2sockid>
  801b0c:	85 c0                	test   %eax,%eax
  801b0e:	78 1b                	js     801b2b <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b10:	83 ec 04             	sub    $0x4,%esp
  801b13:	ff 75 10             	pushl  0x10(%ebp)
  801b16:	ff 75 0c             	pushl  0xc(%ebp)
  801b19:	50                   	push   %eax
  801b1a:	e8 0e 01 00 00       	call   801c2d <nsipc_accept>
  801b1f:	83 c4 10             	add    $0x10,%esp
  801b22:	85 c0                	test   %eax,%eax
  801b24:	78 05                	js     801b2b <accept+0x2d>
	return alloc_sockfd(r);
  801b26:	e8 5f ff ff ff       	call   801a8a <alloc_sockfd>
}
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    

00801b2d <bind>:
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
  801b30:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b33:	8b 45 08             	mov    0x8(%ebp),%eax
  801b36:	e8 1f ff ff ff       	call   801a5a <fd2sockid>
  801b3b:	85 c0                	test   %eax,%eax
  801b3d:	78 12                	js     801b51 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801b3f:	83 ec 04             	sub    $0x4,%esp
  801b42:	ff 75 10             	pushl  0x10(%ebp)
  801b45:	ff 75 0c             	pushl  0xc(%ebp)
  801b48:	50                   	push   %eax
  801b49:	e8 31 01 00 00       	call   801c7f <nsipc_bind>
  801b4e:	83 c4 10             	add    $0x10,%esp
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <shutdown>:
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b59:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5c:	e8 f9 fe ff ff       	call   801a5a <fd2sockid>
  801b61:	85 c0                	test   %eax,%eax
  801b63:	78 0f                	js     801b74 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801b65:	83 ec 08             	sub    $0x8,%esp
  801b68:	ff 75 0c             	pushl  0xc(%ebp)
  801b6b:	50                   	push   %eax
  801b6c:	e8 43 01 00 00       	call   801cb4 <nsipc_shutdown>
  801b71:	83 c4 10             	add    $0x10,%esp
}
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <connect>:
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
  801b79:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7f:	e8 d6 fe ff ff       	call   801a5a <fd2sockid>
  801b84:	85 c0                	test   %eax,%eax
  801b86:	78 12                	js     801b9a <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b88:	83 ec 04             	sub    $0x4,%esp
  801b8b:	ff 75 10             	pushl  0x10(%ebp)
  801b8e:	ff 75 0c             	pushl  0xc(%ebp)
  801b91:	50                   	push   %eax
  801b92:	e8 59 01 00 00       	call   801cf0 <nsipc_connect>
  801b97:	83 c4 10             	add    $0x10,%esp
}
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <listen>:
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
  801b9f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba5:	e8 b0 fe ff ff       	call   801a5a <fd2sockid>
  801baa:	85 c0                	test   %eax,%eax
  801bac:	78 0f                	js     801bbd <listen+0x21>
	return nsipc_listen(r, backlog);
  801bae:	83 ec 08             	sub    $0x8,%esp
  801bb1:	ff 75 0c             	pushl  0xc(%ebp)
  801bb4:	50                   	push   %eax
  801bb5:	e8 6b 01 00 00       	call   801d25 <nsipc_listen>
  801bba:	83 c4 10             	add    $0x10,%esp
}
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <socket>:

int
socket(int domain, int type, int protocol)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801bc5:	ff 75 10             	pushl  0x10(%ebp)
  801bc8:	ff 75 0c             	pushl  0xc(%ebp)
  801bcb:	ff 75 08             	pushl  0x8(%ebp)
  801bce:	e8 3e 02 00 00       	call   801e11 <nsipc_socket>
  801bd3:	83 c4 10             	add    $0x10,%esp
  801bd6:	85 c0                	test   %eax,%eax
  801bd8:	78 05                	js     801bdf <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801bda:	e8 ab fe ff ff       	call   801a8a <alloc_sockfd>
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	53                   	push   %ebx
  801be5:	83 ec 04             	sub    $0x4,%esp
  801be8:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801bea:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801bf1:	74 26                	je     801c19 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801bf3:	6a 07                	push   $0x7
  801bf5:	68 00 60 80 00       	push   $0x806000
  801bfa:	53                   	push   %ebx
  801bfb:	ff 35 04 40 80 00    	pushl  0x804004
  801c01:	e8 61 07 00 00       	call   802367 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c06:	83 c4 0c             	add    $0xc,%esp
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	e8 ea 06 00 00       	call   8022fe <ipc_recv>
}
  801c14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c17:	c9                   	leave  
  801c18:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c19:	83 ec 0c             	sub    $0xc,%esp
  801c1c:	6a 02                	push   $0x2
  801c1e:	e8 9c 07 00 00       	call   8023bf <ipc_find_env>
  801c23:	a3 04 40 80 00       	mov    %eax,0x804004
  801c28:	83 c4 10             	add    $0x10,%esp
  801c2b:	eb c6                	jmp    801bf3 <nsipc+0x12>

00801c2d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
  801c30:	56                   	push   %esi
  801c31:	53                   	push   %ebx
  801c32:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c35:	8b 45 08             	mov    0x8(%ebp),%eax
  801c38:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c3d:	8b 06                	mov    (%esi),%eax
  801c3f:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c44:	b8 01 00 00 00       	mov    $0x1,%eax
  801c49:	e8 93 ff ff ff       	call   801be1 <nsipc>
  801c4e:	89 c3                	mov    %eax,%ebx
  801c50:	85 c0                	test   %eax,%eax
  801c52:	79 09                	jns    801c5d <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801c54:	89 d8                	mov    %ebx,%eax
  801c56:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c59:	5b                   	pop    %ebx
  801c5a:	5e                   	pop    %esi
  801c5b:	5d                   	pop    %ebp
  801c5c:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c5d:	83 ec 04             	sub    $0x4,%esp
  801c60:	ff 35 10 60 80 00    	pushl  0x806010
  801c66:	68 00 60 80 00       	push   $0x806000
  801c6b:	ff 75 0c             	pushl  0xc(%ebp)
  801c6e:	e8 47 ef ff ff       	call   800bba <memmove>
		*addrlen = ret->ret_addrlen;
  801c73:	a1 10 60 80 00       	mov    0x806010,%eax
  801c78:	89 06                	mov    %eax,(%esi)
  801c7a:	83 c4 10             	add    $0x10,%esp
	return r;
  801c7d:	eb d5                	jmp    801c54 <nsipc_accept+0x27>

00801c7f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	53                   	push   %ebx
  801c83:	83 ec 08             	sub    $0x8,%esp
  801c86:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c91:	53                   	push   %ebx
  801c92:	ff 75 0c             	pushl  0xc(%ebp)
  801c95:	68 04 60 80 00       	push   $0x806004
  801c9a:	e8 1b ef ff ff       	call   800bba <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c9f:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801ca5:	b8 02 00 00 00       	mov    $0x2,%eax
  801caa:	e8 32 ff ff ff       	call   801be1 <nsipc>
}
  801caf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
  801cb7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801cba:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbd:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc5:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801cca:	b8 03 00 00 00       	mov    $0x3,%eax
  801ccf:	e8 0d ff ff ff       	call   801be1 <nsipc>
}
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <nsipc_close>:

int
nsipc_close(int s)
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
  801cd9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdf:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ce4:	b8 04 00 00 00       	mov    $0x4,%eax
  801ce9:	e8 f3 fe ff ff       	call   801be1 <nsipc>
}
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
  801cf3:	53                   	push   %ebx
  801cf4:	83 ec 08             	sub    $0x8,%esp
  801cf7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfd:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d02:	53                   	push   %ebx
  801d03:	ff 75 0c             	pushl  0xc(%ebp)
  801d06:	68 04 60 80 00       	push   $0x806004
  801d0b:	e8 aa ee ff ff       	call   800bba <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d10:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d16:	b8 05 00 00 00       	mov    $0x5,%eax
  801d1b:	e8 c1 fe ff ff       	call   801be1 <nsipc>
}
  801d20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    

00801d25 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
  801d28:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d33:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d36:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d3b:	b8 06 00 00 00       	mov    $0x6,%eax
  801d40:	e8 9c fe ff ff       	call   801be1 <nsipc>
}
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
  801d4a:	56                   	push   %esi
  801d4b:	53                   	push   %ebx
  801d4c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d52:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d57:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d5d:	8b 45 14             	mov    0x14(%ebp),%eax
  801d60:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d65:	b8 07 00 00 00       	mov    $0x7,%eax
  801d6a:	e8 72 fe ff ff       	call   801be1 <nsipc>
  801d6f:	89 c3                	mov    %eax,%ebx
  801d71:	85 c0                	test   %eax,%eax
  801d73:	78 1f                	js     801d94 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d75:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d7a:	7f 21                	jg     801d9d <nsipc_recv+0x56>
  801d7c:	39 c6                	cmp    %eax,%esi
  801d7e:	7c 1d                	jl     801d9d <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d80:	83 ec 04             	sub    $0x4,%esp
  801d83:	50                   	push   %eax
  801d84:	68 00 60 80 00       	push   $0x806000
  801d89:	ff 75 0c             	pushl  0xc(%ebp)
  801d8c:	e8 29 ee ff ff       	call   800bba <memmove>
  801d91:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d94:	89 d8                	mov    %ebx,%eax
  801d96:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d99:	5b                   	pop    %ebx
  801d9a:	5e                   	pop    %esi
  801d9b:	5d                   	pop    %ebp
  801d9c:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d9d:	68 9f 2c 80 00       	push   $0x802c9f
  801da2:	68 67 2c 80 00       	push   $0x802c67
  801da7:	6a 62                	push   $0x62
  801da9:	68 b4 2c 80 00       	push   $0x802cb4
  801dae:	e8 24 e4 ff ff       	call   8001d7 <_panic>

00801db3 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
  801db6:	53                   	push   %ebx
  801db7:	83 ec 04             	sub    $0x4,%esp
  801dba:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc0:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801dc5:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801dcb:	7f 2e                	jg     801dfb <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801dcd:	83 ec 04             	sub    $0x4,%esp
  801dd0:	53                   	push   %ebx
  801dd1:	ff 75 0c             	pushl  0xc(%ebp)
  801dd4:	68 0c 60 80 00       	push   $0x80600c
  801dd9:	e8 dc ed ff ff       	call   800bba <memmove>
	nsipcbuf.send.req_size = size;
  801dde:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801de4:	8b 45 14             	mov    0x14(%ebp),%eax
  801de7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801dec:	b8 08 00 00 00       	mov    $0x8,%eax
  801df1:	e8 eb fd ff ff       	call   801be1 <nsipc>
}
  801df6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801df9:	c9                   	leave  
  801dfa:	c3                   	ret    
	assert(size < 1600);
  801dfb:	68 c0 2c 80 00       	push   $0x802cc0
  801e00:	68 67 2c 80 00       	push   $0x802c67
  801e05:	6a 6d                	push   $0x6d
  801e07:	68 b4 2c 80 00       	push   $0x802cb4
  801e0c:	e8 c6 e3 ff ff       	call   8001d7 <_panic>

00801e11 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
  801e14:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e17:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e22:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e27:	8b 45 10             	mov    0x10(%ebp),%eax
  801e2a:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e2f:	b8 09 00 00 00       	mov    $0x9,%eax
  801e34:	e8 a8 fd ff ff       	call   801be1 <nsipc>
}
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
  801e3e:	56                   	push   %esi
  801e3f:	53                   	push   %ebx
  801e40:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e43:	83 ec 0c             	sub    $0xc,%esp
  801e46:	ff 75 08             	pushl  0x8(%ebp)
  801e49:	e8 6a f3 ff ff       	call   8011b8 <fd2data>
  801e4e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e50:	83 c4 08             	add    $0x8,%esp
  801e53:	68 cc 2c 80 00       	push   $0x802ccc
  801e58:	53                   	push   %ebx
  801e59:	e8 ce eb ff ff       	call   800a2c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e5e:	8b 46 04             	mov    0x4(%esi),%eax
  801e61:	2b 06                	sub    (%esi),%eax
  801e63:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e69:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e70:	00 00 00 
	stat->st_dev = &devpipe;
  801e73:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801e7a:	30 80 00 
	return 0;
}
  801e7d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e82:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e85:	5b                   	pop    %ebx
  801e86:	5e                   	pop    %esi
  801e87:	5d                   	pop    %ebp
  801e88:	c3                   	ret    

00801e89 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
  801e8c:	53                   	push   %ebx
  801e8d:	83 ec 0c             	sub    $0xc,%esp
  801e90:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e93:	53                   	push   %ebx
  801e94:	6a 00                	push   $0x0
  801e96:	e8 08 f0 ff ff       	call   800ea3 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e9b:	89 1c 24             	mov    %ebx,(%esp)
  801e9e:	e8 15 f3 ff ff       	call   8011b8 <fd2data>
  801ea3:	83 c4 08             	add    $0x8,%esp
  801ea6:	50                   	push   %eax
  801ea7:	6a 00                	push   $0x0
  801ea9:	e8 f5 ef ff ff       	call   800ea3 <sys_page_unmap>
}
  801eae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <_pipeisclosed>:
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	57                   	push   %edi
  801eb7:	56                   	push   %esi
  801eb8:	53                   	push   %ebx
  801eb9:	83 ec 1c             	sub    $0x1c,%esp
  801ebc:	89 c7                	mov    %eax,%edi
  801ebe:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ec0:	a1 08 40 80 00       	mov    0x804008,%eax
  801ec5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ec8:	83 ec 0c             	sub    $0xc,%esp
  801ecb:	57                   	push   %edi
  801ecc:	e8 29 05 00 00       	call   8023fa <pageref>
  801ed1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ed4:	89 34 24             	mov    %esi,(%esp)
  801ed7:	e8 1e 05 00 00       	call   8023fa <pageref>
		nn = thisenv->env_runs;
  801edc:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ee2:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ee5:	83 c4 10             	add    $0x10,%esp
  801ee8:	39 cb                	cmp    %ecx,%ebx
  801eea:	74 1b                	je     801f07 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801eec:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801eef:	75 cf                	jne    801ec0 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ef1:	8b 42 58             	mov    0x58(%edx),%eax
  801ef4:	6a 01                	push   $0x1
  801ef6:	50                   	push   %eax
  801ef7:	53                   	push   %ebx
  801ef8:	68 d3 2c 80 00       	push   $0x802cd3
  801efd:	e8 cb e3 ff ff       	call   8002cd <cprintf>
  801f02:	83 c4 10             	add    $0x10,%esp
  801f05:	eb b9                	jmp    801ec0 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801f07:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f0a:	0f 94 c0             	sete   %al
  801f0d:	0f b6 c0             	movzbl %al,%eax
}
  801f10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f13:	5b                   	pop    %ebx
  801f14:	5e                   	pop    %esi
  801f15:	5f                   	pop    %edi
  801f16:	5d                   	pop    %ebp
  801f17:	c3                   	ret    

00801f18 <devpipe_write>:
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
  801f1b:	57                   	push   %edi
  801f1c:	56                   	push   %esi
  801f1d:	53                   	push   %ebx
  801f1e:	83 ec 28             	sub    $0x28,%esp
  801f21:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f24:	56                   	push   %esi
  801f25:	e8 8e f2 ff ff       	call   8011b8 <fd2data>
  801f2a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f2c:	83 c4 10             	add    $0x10,%esp
  801f2f:	bf 00 00 00 00       	mov    $0x0,%edi
  801f34:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f37:	74 4f                	je     801f88 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f39:	8b 43 04             	mov    0x4(%ebx),%eax
  801f3c:	8b 0b                	mov    (%ebx),%ecx
  801f3e:	8d 51 20             	lea    0x20(%ecx),%edx
  801f41:	39 d0                	cmp    %edx,%eax
  801f43:	72 14                	jb     801f59 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801f45:	89 da                	mov    %ebx,%edx
  801f47:	89 f0                	mov    %esi,%eax
  801f49:	e8 65 ff ff ff       	call   801eb3 <_pipeisclosed>
  801f4e:	85 c0                	test   %eax,%eax
  801f50:	75 3b                	jne    801f8d <devpipe_write+0x75>
			sys_yield();
  801f52:	e8 a8 ee ff ff       	call   800dff <sys_yield>
  801f57:	eb e0                	jmp    801f39 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f5c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f60:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f63:	89 c2                	mov    %eax,%edx
  801f65:	c1 fa 1f             	sar    $0x1f,%edx
  801f68:	89 d1                	mov    %edx,%ecx
  801f6a:	c1 e9 1b             	shr    $0x1b,%ecx
  801f6d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801f70:	83 e2 1f             	and    $0x1f,%edx
  801f73:	29 ca                	sub    %ecx,%edx
  801f75:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f79:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f7d:	83 c0 01             	add    $0x1,%eax
  801f80:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f83:	83 c7 01             	add    $0x1,%edi
  801f86:	eb ac                	jmp    801f34 <devpipe_write+0x1c>
	return i;
  801f88:	8b 45 10             	mov    0x10(%ebp),%eax
  801f8b:	eb 05                	jmp    801f92 <devpipe_write+0x7a>
				return 0;
  801f8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f95:	5b                   	pop    %ebx
  801f96:	5e                   	pop    %esi
  801f97:	5f                   	pop    %edi
  801f98:	5d                   	pop    %ebp
  801f99:	c3                   	ret    

00801f9a <devpipe_read>:
{
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
  801f9d:	57                   	push   %edi
  801f9e:	56                   	push   %esi
  801f9f:	53                   	push   %ebx
  801fa0:	83 ec 18             	sub    $0x18,%esp
  801fa3:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801fa6:	57                   	push   %edi
  801fa7:	e8 0c f2 ff ff       	call   8011b8 <fd2data>
  801fac:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801fae:	83 c4 10             	add    $0x10,%esp
  801fb1:	be 00 00 00 00       	mov    $0x0,%esi
  801fb6:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fb9:	75 14                	jne    801fcf <devpipe_read+0x35>
	return i;
  801fbb:	8b 45 10             	mov    0x10(%ebp),%eax
  801fbe:	eb 02                	jmp    801fc2 <devpipe_read+0x28>
				return i;
  801fc0:	89 f0                	mov    %esi,%eax
}
  801fc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fc5:	5b                   	pop    %ebx
  801fc6:	5e                   	pop    %esi
  801fc7:	5f                   	pop    %edi
  801fc8:	5d                   	pop    %ebp
  801fc9:	c3                   	ret    
			sys_yield();
  801fca:	e8 30 ee ff ff       	call   800dff <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801fcf:	8b 03                	mov    (%ebx),%eax
  801fd1:	3b 43 04             	cmp    0x4(%ebx),%eax
  801fd4:	75 18                	jne    801fee <devpipe_read+0x54>
			if (i > 0)
  801fd6:	85 f6                	test   %esi,%esi
  801fd8:	75 e6                	jne    801fc0 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801fda:	89 da                	mov    %ebx,%edx
  801fdc:	89 f8                	mov    %edi,%eax
  801fde:	e8 d0 fe ff ff       	call   801eb3 <_pipeisclosed>
  801fe3:	85 c0                	test   %eax,%eax
  801fe5:	74 e3                	je     801fca <devpipe_read+0x30>
				return 0;
  801fe7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fec:	eb d4                	jmp    801fc2 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801fee:	99                   	cltd   
  801fef:	c1 ea 1b             	shr    $0x1b,%edx
  801ff2:	01 d0                	add    %edx,%eax
  801ff4:	83 e0 1f             	and    $0x1f,%eax
  801ff7:	29 d0                	sub    %edx,%eax
  801ff9:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ffe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802001:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802004:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802007:	83 c6 01             	add    $0x1,%esi
  80200a:	eb aa                	jmp    801fb6 <devpipe_read+0x1c>

0080200c <pipe>:
{
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
  80200f:	56                   	push   %esi
  802010:	53                   	push   %ebx
  802011:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802014:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802017:	50                   	push   %eax
  802018:	e8 b2 f1 ff ff       	call   8011cf <fd_alloc>
  80201d:	89 c3                	mov    %eax,%ebx
  80201f:	83 c4 10             	add    $0x10,%esp
  802022:	85 c0                	test   %eax,%eax
  802024:	0f 88 23 01 00 00    	js     80214d <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80202a:	83 ec 04             	sub    $0x4,%esp
  80202d:	68 07 04 00 00       	push   $0x407
  802032:	ff 75 f4             	pushl  -0xc(%ebp)
  802035:	6a 00                	push   $0x0
  802037:	e8 e2 ed ff ff       	call   800e1e <sys_page_alloc>
  80203c:	89 c3                	mov    %eax,%ebx
  80203e:	83 c4 10             	add    $0x10,%esp
  802041:	85 c0                	test   %eax,%eax
  802043:	0f 88 04 01 00 00    	js     80214d <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802049:	83 ec 0c             	sub    $0xc,%esp
  80204c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80204f:	50                   	push   %eax
  802050:	e8 7a f1 ff ff       	call   8011cf <fd_alloc>
  802055:	89 c3                	mov    %eax,%ebx
  802057:	83 c4 10             	add    $0x10,%esp
  80205a:	85 c0                	test   %eax,%eax
  80205c:	0f 88 db 00 00 00    	js     80213d <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802062:	83 ec 04             	sub    $0x4,%esp
  802065:	68 07 04 00 00       	push   $0x407
  80206a:	ff 75 f0             	pushl  -0x10(%ebp)
  80206d:	6a 00                	push   $0x0
  80206f:	e8 aa ed ff ff       	call   800e1e <sys_page_alloc>
  802074:	89 c3                	mov    %eax,%ebx
  802076:	83 c4 10             	add    $0x10,%esp
  802079:	85 c0                	test   %eax,%eax
  80207b:	0f 88 bc 00 00 00    	js     80213d <pipe+0x131>
	va = fd2data(fd0);
  802081:	83 ec 0c             	sub    $0xc,%esp
  802084:	ff 75 f4             	pushl  -0xc(%ebp)
  802087:	e8 2c f1 ff ff       	call   8011b8 <fd2data>
  80208c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80208e:	83 c4 0c             	add    $0xc,%esp
  802091:	68 07 04 00 00       	push   $0x407
  802096:	50                   	push   %eax
  802097:	6a 00                	push   $0x0
  802099:	e8 80 ed ff ff       	call   800e1e <sys_page_alloc>
  80209e:	89 c3                	mov    %eax,%ebx
  8020a0:	83 c4 10             	add    $0x10,%esp
  8020a3:	85 c0                	test   %eax,%eax
  8020a5:	0f 88 82 00 00 00    	js     80212d <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020ab:	83 ec 0c             	sub    $0xc,%esp
  8020ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8020b1:	e8 02 f1 ff ff       	call   8011b8 <fd2data>
  8020b6:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8020bd:	50                   	push   %eax
  8020be:	6a 00                	push   $0x0
  8020c0:	56                   	push   %esi
  8020c1:	6a 00                	push   $0x0
  8020c3:	e8 99 ed ff ff       	call   800e61 <sys_page_map>
  8020c8:	89 c3                	mov    %eax,%ebx
  8020ca:	83 c4 20             	add    $0x20,%esp
  8020cd:	85 c0                	test   %eax,%eax
  8020cf:	78 4e                	js     80211f <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8020d1:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8020d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d9:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8020db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020de:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8020e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020e8:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8020ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ed:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8020f4:	83 ec 0c             	sub    $0xc,%esp
  8020f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8020fa:	e8 a9 f0 ff ff       	call   8011a8 <fd2num>
  8020ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802102:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802104:	83 c4 04             	add    $0x4,%esp
  802107:	ff 75 f0             	pushl  -0x10(%ebp)
  80210a:	e8 99 f0 ff ff       	call   8011a8 <fd2num>
  80210f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802112:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802115:	83 c4 10             	add    $0x10,%esp
  802118:	bb 00 00 00 00       	mov    $0x0,%ebx
  80211d:	eb 2e                	jmp    80214d <pipe+0x141>
	sys_page_unmap(0, va);
  80211f:	83 ec 08             	sub    $0x8,%esp
  802122:	56                   	push   %esi
  802123:	6a 00                	push   $0x0
  802125:	e8 79 ed ff ff       	call   800ea3 <sys_page_unmap>
  80212a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80212d:	83 ec 08             	sub    $0x8,%esp
  802130:	ff 75 f0             	pushl  -0x10(%ebp)
  802133:	6a 00                	push   $0x0
  802135:	e8 69 ed ff ff       	call   800ea3 <sys_page_unmap>
  80213a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80213d:	83 ec 08             	sub    $0x8,%esp
  802140:	ff 75 f4             	pushl  -0xc(%ebp)
  802143:	6a 00                	push   $0x0
  802145:	e8 59 ed ff ff       	call   800ea3 <sys_page_unmap>
  80214a:	83 c4 10             	add    $0x10,%esp
}
  80214d:	89 d8                	mov    %ebx,%eax
  80214f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802152:	5b                   	pop    %ebx
  802153:	5e                   	pop    %esi
  802154:	5d                   	pop    %ebp
  802155:	c3                   	ret    

00802156 <pipeisclosed>:
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
  802159:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80215c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80215f:	50                   	push   %eax
  802160:	ff 75 08             	pushl  0x8(%ebp)
  802163:	e8 b9 f0 ff ff       	call   801221 <fd_lookup>
  802168:	83 c4 10             	add    $0x10,%esp
  80216b:	85 c0                	test   %eax,%eax
  80216d:	78 18                	js     802187 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80216f:	83 ec 0c             	sub    $0xc,%esp
  802172:	ff 75 f4             	pushl  -0xc(%ebp)
  802175:	e8 3e f0 ff ff       	call   8011b8 <fd2data>
	return _pipeisclosed(fd, p);
  80217a:	89 c2                	mov    %eax,%edx
  80217c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217f:	e8 2f fd ff ff       	call   801eb3 <_pipeisclosed>
  802184:	83 c4 10             	add    $0x10,%esp
}
  802187:	c9                   	leave  
  802188:	c3                   	ret    

00802189 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802189:	b8 00 00 00 00       	mov    $0x0,%eax
  80218e:	c3                   	ret    

0080218f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
  802192:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802195:	68 eb 2c 80 00       	push   $0x802ceb
  80219a:	ff 75 0c             	pushl  0xc(%ebp)
  80219d:	e8 8a e8 ff ff       	call   800a2c <strcpy>
	return 0;
}
  8021a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a7:	c9                   	leave  
  8021a8:	c3                   	ret    

008021a9 <devcons_write>:
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
  8021ac:	57                   	push   %edi
  8021ad:	56                   	push   %esi
  8021ae:	53                   	push   %ebx
  8021af:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8021b5:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8021ba:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8021c0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021c3:	73 31                	jae    8021f6 <devcons_write+0x4d>
		m = n - tot;
  8021c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8021c8:	29 f3                	sub    %esi,%ebx
  8021ca:	83 fb 7f             	cmp    $0x7f,%ebx
  8021cd:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8021d2:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8021d5:	83 ec 04             	sub    $0x4,%esp
  8021d8:	53                   	push   %ebx
  8021d9:	89 f0                	mov    %esi,%eax
  8021db:	03 45 0c             	add    0xc(%ebp),%eax
  8021de:	50                   	push   %eax
  8021df:	57                   	push   %edi
  8021e0:	e8 d5 e9 ff ff       	call   800bba <memmove>
		sys_cputs(buf, m);
  8021e5:	83 c4 08             	add    $0x8,%esp
  8021e8:	53                   	push   %ebx
  8021e9:	57                   	push   %edi
  8021ea:	e8 73 eb ff ff       	call   800d62 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8021ef:	01 de                	add    %ebx,%esi
  8021f1:	83 c4 10             	add    $0x10,%esp
  8021f4:	eb ca                	jmp    8021c0 <devcons_write+0x17>
}
  8021f6:	89 f0                	mov    %esi,%eax
  8021f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021fb:	5b                   	pop    %ebx
  8021fc:	5e                   	pop    %esi
  8021fd:	5f                   	pop    %edi
  8021fe:	5d                   	pop    %ebp
  8021ff:	c3                   	ret    

00802200 <devcons_read>:
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	83 ec 08             	sub    $0x8,%esp
  802206:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80220b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80220f:	74 21                	je     802232 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802211:	e8 6a eb ff ff       	call   800d80 <sys_cgetc>
  802216:	85 c0                	test   %eax,%eax
  802218:	75 07                	jne    802221 <devcons_read+0x21>
		sys_yield();
  80221a:	e8 e0 eb ff ff       	call   800dff <sys_yield>
  80221f:	eb f0                	jmp    802211 <devcons_read+0x11>
	if (c < 0)
  802221:	78 0f                	js     802232 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802223:	83 f8 04             	cmp    $0x4,%eax
  802226:	74 0c                	je     802234 <devcons_read+0x34>
	*(char*)vbuf = c;
  802228:	8b 55 0c             	mov    0xc(%ebp),%edx
  80222b:	88 02                	mov    %al,(%edx)
	return 1;
  80222d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802232:	c9                   	leave  
  802233:	c3                   	ret    
		return 0;
  802234:	b8 00 00 00 00       	mov    $0x0,%eax
  802239:	eb f7                	jmp    802232 <devcons_read+0x32>

0080223b <cputchar>:
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
  80223e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802241:	8b 45 08             	mov    0x8(%ebp),%eax
  802244:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802247:	6a 01                	push   $0x1
  802249:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80224c:	50                   	push   %eax
  80224d:	e8 10 eb ff ff       	call   800d62 <sys_cputs>
}
  802252:	83 c4 10             	add    $0x10,%esp
  802255:	c9                   	leave  
  802256:	c3                   	ret    

00802257 <getchar>:
{
  802257:	55                   	push   %ebp
  802258:	89 e5                	mov    %esp,%ebp
  80225a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80225d:	6a 01                	push   $0x1
  80225f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802262:	50                   	push   %eax
  802263:	6a 00                	push   $0x0
  802265:	e8 27 f2 ff ff       	call   801491 <read>
	if (r < 0)
  80226a:	83 c4 10             	add    $0x10,%esp
  80226d:	85 c0                	test   %eax,%eax
  80226f:	78 06                	js     802277 <getchar+0x20>
	if (r < 1)
  802271:	74 06                	je     802279 <getchar+0x22>
	return c;
  802273:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802277:	c9                   	leave  
  802278:	c3                   	ret    
		return -E_EOF;
  802279:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80227e:	eb f7                	jmp    802277 <getchar+0x20>

00802280 <iscons>:
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
  802283:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802286:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802289:	50                   	push   %eax
  80228a:	ff 75 08             	pushl  0x8(%ebp)
  80228d:	e8 8f ef ff ff       	call   801221 <fd_lookup>
  802292:	83 c4 10             	add    $0x10,%esp
  802295:	85 c0                	test   %eax,%eax
  802297:	78 11                	js     8022aa <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802299:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229c:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022a2:	39 10                	cmp    %edx,(%eax)
  8022a4:	0f 94 c0             	sete   %al
  8022a7:	0f b6 c0             	movzbl %al,%eax
}
  8022aa:	c9                   	leave  
  8022ab:	c3                   	ret    

008022ac <opencons>:
{
  8022ac:	55                   	push   %ebp
  8022ad:	89 e5                	mov    %esp,%ebp
  8022af:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8022b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022b5:	50                   	push   %eax
  8022b6:	e8 14 ef ff ff       	call   8011cf <fd_alloc>
  8022bb:	83 c4 10             	add    $0x10,%esp
  8022be:	85 c0                	test   %eax,%eax
  8022c0:	78 3a                	js     8022fc <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022c2:	83 ec 04             	sub    $0x4,%esp
  8022c5:	68 07 04 00 00       	push   $0x407
  8022ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8022cd:	6a 00                	push   $0x0
  8022cf:	e8 4a eb ff ff       	call   800e1e <sys_page_alloc>
  8022d4:	83 c4 10             	add    $0x10,%esp
  8022d7:	85 c0                	test   %eax,%eax
  8022d9:	78 21                	js     8022fc <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8022db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022de:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022e4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022f0:	83 ec 0c             	sub    $0xc,%esp
  8022f3:	50                   	push   %eax
  8022f4:	e8 af ee ff ff       	call   8011a8 <fd2num>
  8022f9:	83 c4 10             	add    $0x10,%esp
}
  8022fc:	c9                   	leave  
  8022fd:	c3                   	ret    

008022fe <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
  802301:	56                   	push   %esi
  802302:	53                   	push   %ebx
  802303:	8b 75 08             	mov    0x8(%ebp),%esi
  802306:	8b 45 0c             	mov    0xc(%ebp),%eax
  802309:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80230c:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80230e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802313:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802316:	83 ec 0c             	sub    $0xc,%esp
  802319:	50                   	push   %eax
  80231a:	e8 af ec ff ff       	call   800fce <sys_ipc_recv>
	if(ret < 0){
  80231f:	83 c4 10             	add    $0x10,%esp
  802322:	85 c0                	test   %eax,%eax
  802324:	78 2b                	js     802351 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802326:	85 f6                	test   %esi,%esi
  802328:	74 0a                	je     802334 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80232a:	a1 08 40 80 00       	mov    0x804008,%eax
  80232f:	8b 40 74             	mov    0x74(%eax),%eax
  802332:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802334:	85 db                	test   %ebx,%ebx
  802336:	74 0a                	je     802342 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802338:	a1 08 40 80 00       	mov    0x804008,%eax
  80233d:	8b 40 78             	mov    0x78(%eax),%eax
  802340:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802342:	a1 08 40 80 00       	mov    0x804008,%eax
  802347:	8b 40 70             	mov    0x70(%eax),%eax
}
  80234a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80234d:	5b                   	pop    %ebx
  80234e:	5e                   	pop    %esi
  80234f:	5d                   	pop    %ebp
  802350:	c3                   	ret    
		if(from_env_store)
  802351:	85 f6                	test   %esi,%esi
  802353:	74 06                	je     80235b <ipc_recv+0x5d>
			*from_env_store = 0;
  802355:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80235b:	85 db                	test   %ebx,%ebx
  80235d:	74 eb                	je     80234a <ipc_recv+0x4c>
			*perm_store = 0;
  80235f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802365:	eb e3                	jmp    80234a <ipc_recv+0x4c>

00802367 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802367:	55                   	push   %ebp
  802368:	89 e5                	mov    %esp,%ebp
  80236a:	57                   	push   %edi
  80236b:	56                   	push   %esi
  80236c:	53                   	push   %ebx
  80236d:	83 ec 0c             	sub    $0xc,%esp
  802370:	8b 7d 08             	mov    0x8(%ebp),%edi
  802373:	8b 75 0c             	mov    0xc(%ebp),%esi
  802376:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802379:	85 db                	test   %ebx,%ebx
  80237b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802380:	0f 44 d8             	cmove  %eax,%ebx
  802383:	eb 05                	jmp    80238a <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802385:	e8 75 ea ff ff       	call   800dff <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80238a:	ff 75 14             	pushl  0x14(%ebp)
  80238d:	53                   	push   %ebx
  80238e:	56                   	push   %esi
  80238f:	57                   	push   %edi
  802390:	e8 16 ec ff ff       	call   800fab <sys_ipc_try_send>
  802395:	83 c4 10             	add    $0x10,%esp
  802398:	85 c0                	test   %eax,%eax
  80239a:	74 1b                	je     8023b7 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80239c:	79 e7                	jns    802385 <ipc_send+0x1e>
  80239e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8023a1:	74 e2                	je     802385 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8023a3:	83 ec 04             	sub    $0x4,%esp
  8023a6:	68 f7 2c 80 00       	push   $0x802cf7
  8023ab:	6a 46                	push   $0x46
  8023ad:	68 0c 2d 80 00       	push   $0x802d0c
  8023b2:	e8 20 de ff ff       	call   8001d7 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8023b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023ba:	5b                   	pop    %ebx
  8023bb:	5e                   	pop    %esi
  8023bc:	5f                   	pop    %edi
  8023bd:	5d                   	pop    %ebp
  8023be:	c3                   	ret    

008023bf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
  8023c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8023c5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8023ca:	89 c2                	mov    %eax,%edx
  8023cc:	c1 e2 07             	shl    $0x7,%edx
  8023cf:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8023d5:	8b 52 50             	mov    0x50(%edx),%edx
  8023d8:	39 ca                	cmp    %ecx,%edx
  8023da:	74 11                	je     8023ed <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8023dc:	83 c0 01             	add    $0x1,%eax
  8023df:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023e4:	75 e4                	jne    8023ca <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8023e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023eb:	eb 0b                	jmp    8023f8 <ipc_find_env+0x39>
			return envs[i].env_id;
  8023ed:	c1 e0 07             	shl    $0x7,%eax
  8023f0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8023f5:	8b 40 48             	mov    0x48(%eax),%eax
}
  8023f8:	5d                   	pop    %ebp
  8023f9:	c3                   	ret    

008023fa <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
  8023fd:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802400:	89 d0                	mov    %edx,%eax
  802402:	c1 e8 16             	shr    $0x16,%eax
  802405:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80240c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802411:	f6 c1 01             	test   $0x1,%cl
  802414:	74 1d                	je     802433 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802416:	c1 ea 0c             	shr    $0xc,%edx
  802419:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802420:	f6 c2 01             	test   $0x1,%dl
  802423:	74 0e                	je     802433 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802425:	c1 ea 0c             	shr    $0xc,%edx
  802428:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80242f:	ef 
  802430:	0f b7 c0             	movzwl %ax,%eax
}
  802433:	5d                   	pop    %ebp
  802434:	c3                   	ret    
  802435:	66 90                	xchg   %ax,%ax
  802437:	66 90                	xchg   %ax,%ax
  802439:	66 90                	xchg   %ax,%ax
  80243b:	66 90                	xchg   %ax,%ax
  80243d:	66 90                	xchg   %ax,%ax
  80243f:	90                   	nop

00802440 <__udivdi3>:
  802440:	55                   	push   %ebp
  802441:	57                   	push   %edi
  802442:	56                   	push   %esi
  802443:	53                   	push   %ebx
  802444:	83 ec 1c             	sub    $0x1c,%esp
  802447:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80244b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80244f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802453:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802457:	85 d2                	test   %edx,%edx
  802459:	75 4d                	jne    8024a8 <__udivdi3+0x68>
  80245b:	39 f3                	cmp    %esi,%ebx
  80245d:	76 19                	jbe    802478 <__udivdi3+0x38>
  80245f:	31 ff                	xor    %edi,%edi
  802461:	89 e8                	mov    %ebp,%eax
  802463:	89 f2                	mov    %esi,%edx
  802465:	f7 f3                	div    %ebx
  802467:	89 fa                	mov    %edi,%edx
  802469:	83 c4 1c             	add    $0x1c,%esp
  80246c:	5b                   	pop    %ebx
  80246d:	5e                   	pop    %esi
  80246e:	5f                   	pop    %edi
  80246f:	5d                   	pop    %ebp
  802470:	c3                   	ret    
  802471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802478:	89 d9                	mov    %ebx,%ecx
  80247a:	85 db                	test   %ebx,%ebx
  80247c:	75 0b                	jne    802489 <__udivdi3+0x49>
  80247e:	b8 01 00 00 00       	mov    $0x1,%eax
  802483:	31 d2                	xor    %edx,%edx
  802485:	f7 f3                	div    %ebx
  802487:	89 c1                	mov    %eax,%ecx
  802489:	31 d2                	xor    %edx,%edx
  80248b:	89 f0                	mov    %esi,%eax
  80248d:	f7 f1                	div    %ecx
  80248f:	89 c6                	mov    %eax,%esi
  802491:	89 e8                	mov    %ebp,%eax
  802493:	89 f7                	mov    %esi,%edi
  802495:	f7 f1                	div    %ecx
  802497:	89 fa                	mov    %edi,%edx
  802499:	83 c4 1c             	add    $0x1c,%esp
  80249c:	5b                   	pop    %ebx
  80249d:	5e                   	pop    %esi
  80249e:	5f                   	pop    %edi
  80249f:	5d                   	pop    %ebp
  8024a0:	c3                   	ret    
  8024a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024a8:	39 f2                	cmp    %esi,%edx
  8024aa:	77 1c                	ja     8024c8 <__udivdi3+0x88>
  8024ac:	0f bd fa             	bsr    %edx,%edi
  8024af:	83 f7 1f             	xor    $0x1f,%edi
  8024b2:	75 2c                	jne    8024e0 <__udivdi3+0xa0>
  8024b4:	39 f2                	cmp    %esi,%edx
  8024b6:	72 06                	jb     8024be <__udivdi3+0x7e>
  8024b8:	31 c0                	xor    %eax,%eax
  8024ba:	39 eb                	cmp    %ebp,%ebx
  8024bc:	77 a9                	ja     802467 <__udivdi3+0x27>
  8024be:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c3:	eb a2                	jmp    802467 <__udivdi3+0x27>
  8024c5:	8d 76 00             	lea    0x0(%esi),%esi
  8024c8:	31 ff                	xor    %edi,%edi
  8024ca:	31 c0                	xor    %eax,%eax
  8024cc:	89 fa                	mov    %edi,%edx
  8024ce:	83 c4 1c             	add    $0x1c,%esp
  8024d1:	5b                   	pop    %ebx
  8024d2:	5e                   	pop    %esi
  8024d3:	5f                   	pop    %edi
  8024d4:	5d                   	pop    %ebp
  8024d5:	c3                   	ret    
  8024d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024dd:	8d 76 00             	lea    0x0(%esi),%esi
  8024e0:	89 f9                	mov    %edi,%ecx
  8024e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8024e7:	29 f8                	sub    %edi,%eax
  8024e9:	d3 e2                	shl    %cl,%edx
  8024eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024ef:	89 c1                	mov    %eax,%ecx
  8024f1:	89 da                	mov    %ebx,%edx
  8024f3:	d3 ea                	shr    %cl,%edx
  8024f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024f9:	09 d1                	or     %edx,%ecx
  8024fb:	89 f2                	mov    %esi,%edx
  8024fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802501:	89 f9                	mov    %edi,%ecx
  802503:	d3 e3                	shl    %cl,%ebx
  802505:	89 c1                	mov    %eax,%ecx
  802507:	d3 ea                	shr    %cl,%edx
  802509:	89 f9                	mov    %edi,%ecx
  80250b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80250f:	89 eb                	mov    %ebp,%ebx
  802511:	d3 e6                	shl    %cl,%esi
  802513:	89 c1                	mov    %eax,%ecx
  802515:	d3 eb                	shr    %cl,%ebx
  802517:	09 de                	or     %ebx,%esi
  802519:	89 f0                	mov    %esi,%eax
  80251b:	f7 74 24 08          	divl   0x8(%esp)
  80251f:	89 d6                	mov    %edx,%esi
  802521:	89 c3                	mov    %eax,%ebx
  802523:	f7 64 24 0c          	mull   0xc(%esp)
  802527:	39 d6                	cmp    %edx,%esi
  802529:	72 15                	jb     802540 <__udivdi3+0x100>
  80252b:	89 f9                	mov    %edi,%ecx
  80252d:	d3 e5                	shl    %cl,%ebp
  80252f:	39 c5                	cmp    %eax,%ebp
  802531:	73 04                	jae    802537 <__udivdi3+0xf7>
  802533:	39 d6                	cmp    %edx,%esi
  802535:	74 09                	je     802540 <__udivdi3+0x100>
  802537:	89 d8                	mov    %ebx,%eax
  802539:	31 ff                	xor    %edi,%edi
  80253b:	e9 27 ff ff ff       	jmp    802467 <__udivdi3+0x27>
  802540:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802543:	31 ff                	xor    %edi,%edi
  802545:	e9 1d ff ff ff       	jmp    802467 <__udivdi3+0x27>
  80254a:	66 90                	xchg   %ax,%ax
  80254c:	66 90                	xchg   %ax,%ax
  80254e:	66 90                	xchg   %ax,%ax

00802550 <__umoddi3>:
  802550:	55                   	push   %ebp
  802551:	57                   	push   %edi
  802552:	56                   	push   %esi
  802553:	53                   	push   %ebx
  802554:	83 ec 1c             	sub    $0x1c,%esp
  802557:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80255b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80255f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802563:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802567:	89 da                	mov    %ebx,%edx
  802569:	85 c0                	test   %eax,%eax
  80256b:	75 43                	jne    8025b0 <__umoddi3+0x60>
  80256d:	39 df                	cmp    %ebx,%edi
  80256f:	76 17                	jbe    802588 <__umoddi3+0x38>
  802571:	89 f0                	mov    %esi,%eax
  802573:	f7 f7                	div    %edi
  802575:	89 d0                	mov    %edx,%eax
  802577:	31 d2                	xor    %edx,%edx
  802579:	83 c4 1c             	add    $0x1c,%esp
  80257c:	5b                   	pop    %ebx
  80257d:	5e                   	pop    %esi
  80257e:	5f                   	pop    %edi
  80257f:	5d                   	pop    %ebp
  802580:	c3                   	ret    
  802581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802588:	89 fd                	mov    %edi,%ebp
  80258a:	85 ff                	test   %edi,%edi
  80258c:	75 0b                	jne    802599 <__umoddi3+0x49>
  80258e:	b8 01 00 00 00       	mov    $0x1,%eax
  802593:	31 d2                	xor    %edx,%edx
  802595:	f7 f7                	div    %edi
  802597:	89 c5                	mov    %eax,%ebp
  802599:	89 d8                	mov    %ebx,%eax
  80259b:	31 d2                	xor    %edx,%edx
  80259d:	f7 f5                	div    %ebp
  80259f:	89 f0                	mov    %esi,%eax
  8025a1:	f7 f5                	div    %ebp
  8025a3:	89 d0                	mov    %edx,%eax
  8025a5:	eb d0                	jmp    802577 <__umoddi3+0x27>
  8025a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025ae:	66 90                	xchg   %ax,%ax
  8025b0:	89 f1                	mov    %esi,%ecx
  8025b2:	39 d8                	cmp    %ebx,%eax
  8025b4:	76 0a                	jbe    8025c0 <__umoddi3+0x70>
  8025b6:	89 f0                	mov    %esi,%eax
  8025b8:	83 c4 1c             	add    $0x1c,%esp
  8025bb:	5b                   	pop    %ebx
  8025bc:	5e                   	pop    %esi
  8025bd:	5f                   	pop    %edi
  8025be:	5d                   	pop    %ebp
  8025bf:	c3                   	ret    
  8025c0:	0f bd e8             	bsr    %eax,%ebp
  8025c3:	83 f5 1f             	xor    $0x1f,%ebp
  8025c6:	75 20                	jne    8025e8 <__umoddi3+0x98>
  8025c8:	39 d8                	cmp    %ebx,%eax
  8025ca:	0f 82 b0 00 00 00    	jb     802680 <__umoddi3+0x130>
  8025d0:	39 f7                	cmp    %esi,%edi
  8025d2:	0f 86 a8 00 00 00    	jbe    802680 <__umoddi3+0x130>
  8025d8:	89 c8                	mov    %ecx,%eax
  8025da:	83 c4 1c             	add    $0x1c,%esp
  8025dd:	5b                   	pop    %ebx
  8025de:	5e                   	pop    %esi
  8025df:	5f                   	pop    %edi
  8025e0:	5d                   	pop    %ebp
  8025e1:	c3                   	ret    
  8025e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025e8:	89 e9                	mov    %ebp,%ecx
  8025ea:	ba 20 00 00 00       	mov    $0x20,%edx
  8025ef:	29 ea                	sub    %ebp,%edx
  8025f1:	d3 e0                	shl    %cl,%eax
  8025f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025f7:	89 d1                	mov    %edx,%ecx
  8025f9:	89 f8                	mov    %edi,%eax
  8025fb:	d3 e8                	shr    %cl,%eax
  8025fd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802601:	89 54 24 04          	mov    %edx,0x4(%esp)
  802605:	8b 54 24 04          	mov    0x4(%esp),%edx
  802609:	09 c1                	or     %eax,%ecx
  80260b:	89 d8                	mov    %ebx,%eax
  80260d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802611:	89 e9                	mov    %ebp,%ecx
  802613:	d3 e7                	shl    %cl,%edi
  802615:	89 d1                	mov    %edx,%ecx
  802617:	d3 e8                	shr    %cl,%eax
  802619:	89 e9                	mov    %ebp,%ecx
  80261b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80261f:	d3 e3                	shl    %cl,%ebx
  802621:	89 c7                	mov    %eax,%edi
  802623:	89 d1                	mov    %edx,%ecx
  802625:	89 f0                	mov    %esi,%eax
  802627:	d3 e8                	shr    %cl,%eax
  802629:	89 e9                	mov    %ebp,%ecx
  80262b:	89 fa                	mov    %edi,%edx
  80262d:	d3 e6                	shl    %cl,%esi
  80262f:	09 d8                	or     %ebx,%eax
  802631:	f7 74 24 08          	divl   0x8(%esp)
  802635:	89 d1                	mov    %edx,%ecx
  802637:	89 f3                	mov    %esi,%ebx
  802639:	f7 64 24 0c          	mull   0xc(%esp)
  80263d:	89 c6                	mov    %eax,%esi
  80263f:	89 d7                	mov    %edx,%edi
  802641:	39 d1                	cmp    %edx,%ecx
  802643:	72 06                	jb     80264b <__umoddi3+0xfb>
  802645:	75 10                	jne    802657 <__umoddi3+0x107>
  802647:	39 c3                	cmp    %eax,%ebx
  802649:	73 0c                	jae    802657 <__umoddi3+0x107>
  80264b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80264f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802653:	89 d7                	mov    %edx,%edi
  802655:	89 c6                	mov    %eax,%esi
  802657:	89 ca                	mov    %ecx,%edx
  802659:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80265e:	29 f3                	sub    %esi,%ebx
  802660:	19 fa                	sbb    %edi,%edx
  802662:	89 d0                	mov    %edx,%eax
  802664:	d3 e0                	shl    %cl,%eax
  802666:	89 e9                	mov    %ebp,%ecx
  802668:	d3 eb                	shr    %cl,%ebx
  80266a:	d3 ea                	shr    %cl,%edx
  80266c:	09 d8                	or     %ebx,%eax
  80266e:	83 c4 1c             	add    $0x1c,%esp
  802671:	5b                   	pop    %ebx
  802672:	5e                   	pop    %esi
  802673:	5f                   	pop    %edi
  802674:	5d                   	pop    %ebp
  802675:	c3                   	ret    
  802676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80267d:	8d 76 00             	lea    0x0(%esi),%esi
  802680:	89 da                	mov    %ebx,%edx
  802682:	29 fe                	sub    %edi,%esi
  802684:	19 c2                	sbb    %eax,%edx
  802686:	89 f1                	mov    %esi,%ecx
  802688:	89 c8                	mov    %ecx,%eax
  80268a:	e9 4b ff ff ff       	jmp    8025da <__umoddi3+0x8a>
