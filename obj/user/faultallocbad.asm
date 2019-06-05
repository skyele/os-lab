
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
  80003a:	68 c8 27 80 00       	push   $0x8027c8
  80003f:	68 a0 26 80 00       	push   $0x8026a0
  800044:	e8 bd 02 00 00       	call   800306 <cprintf>
	int r;
	void *addr = (void*)utf->utf_fault_va;
  800049:	8b 45 08             	mov    0x8(%ebp),%eax
  80004c:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  80004e:	83 c4 08             	add    $0x8,%esp
  800051:	53                   	push   %ebx
  800052:	68 86 27 80 00       	push   $0x802786
  800057:	e8 aa 02 00 00       	call   800306 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80005c:	83 c4 0c             	add    $0xc,%esp
  80005f:	6a 07                	push   $0x7
  800061:	89 d8                	mov    %ebx,%eax
  800063:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800068:	50                   	push   %eax
  800069:	6a 00                	push   $0x0
  80006b:	e8 e7 0d 00 00       	call   800e57 <sys_page_alloc>
  800070:	83 c4 10             	add    $0x10,%esp
  800073:	85 c0                	test   %eax,%eax
  800075:	78 16                	js     80008d <handler+0x5a>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800077:	53                   	push   %ebx
  800078:	68 f8 26 80 00       	push   $0x8026f8
  80007d:	6a 64                	push   $0x64
  80007f:	53                   	push   %ebx
  800080:	e8 8d 09 00 00       	call   800a12 <snprintf>
}
  800085:	83 c4 10             	add    $0x10,%esp
  800088:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80008b:	c9                   	leave  
  80008c:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80008d:	83 ec 0c             	sub    $0xc,%esp
  800090:	50                   	push   %eax
  800091:	53                   	push   %ebx
  800092:	68 cc 26 80 00       	push   $0x8026cc
  800097:	6a 10                	push   $0x10
  800099:	68 90 27 80 00       	push   $0x802790
  80009e:	e8 6d 01 00 00       	call   800210 <_panic>

008000a3 <umain>:

void
umain(int argc, char **argv)
{
  8000a3:	55                   	push   %ebp
  8000a4:	89 e5                	mov    %esp,%ebp
  8000a6:	83 ec 14             	sub    $0x14,%esp
	cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8000a9:	68 1c 27 80 00       	push   $0x80271c
  8000ae:	e8 53 02 00 00       	call   800306 <cprintf>
	cprintf("before set_pgfault_handler() in %s\n", __FUNCTION__);
  8000b3:	83 c4 08             	add    $0x8,%esp
  8000b6:	68 c0 27 80 00       	push   $0x8027c0
  8000bb:	68 40 27 80 00       	push   $0x802740
  8000c0:	e8 41 02 00 00       	call   800306 <cprintf>
	set_pgfault_handler(handler);
  8000c5:	c7 04 24 33 00 80 00 	movl   $0x800033,(%esp)
  8000cc:	e8 5b 10 00 00       	call   80112c <set_pgfault_handler>
	cprintf(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
  8000d1:	c7 04 24 64 27 80 00 	movl   $0x802764,(%esp)
  8000d8:	e8 29 02 00 00       	call   800306 <cprintf>
	cprintf("before sys_cputs() in %s\n", __FUNCTION__);
  8000dd:	83 c4 08             	add    $0x8,%esp
  8000e0:	68 c0 27 80 00       	push   $0x8027c0
  8000e5:	68 a5 27 80 00       	push   $0x8027a5
  8000ea:	e8 17 02 00 00       	call   800306 <cprintf>
	sys_cputs((char*)0xDEADBEEF, 4);
  8000ef:	83 c4 08             	add    $0x8,%esp
  8000f2:	6a 04                	push   $0x4
  8000f4:	68 ef be ad de       	push   $0xdeadbeef
  8000f9:	e8 9d 0c 00 00       	call   800d9b <sys_cputs>
}
  8000fe:	83 c4 10             	add    $0x10,%esp
  800101:	c9                   	leave  
  800102:	c3                   	ret    

00800103 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800103:	55                   	push   %ebp
  800104:	89 e5                	mov    %esp,%ebp
  800106:	57                   	push   %edi
  800107:	56                   	push   %esi
  800108:	53                   	push   %ebx
  800109:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80010c:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800113:	00 00 00 
	envid_t find = sys_getenvid();
  800116:	e8 fe 0c 00 00       	call   800e19 <sys_getenvid>
  80011b:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  800121:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800126:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80012b:	bf 01 00 00 00       	mov    $0x1,%edi
  800130:	eb 0b                	jmp    80013d <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800132:	83 c2 01             	add    $0x1,%edx
  800135:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80013b:	74 21                	je     80015e <libmain+0x5b>
		if(envs[i].env_id == find)
  80013d:	89 d1                	mov    %edx,%ecx
  80013f:	c1 e1 07             	shl    $0x7,%ecx
  800142:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800148:	8b 49 48             	mov    0x48(%ecx),%ecx
  80014b:	39 c1                	cmp    %eax,%ecx
  80014d:	75 e3                	jne    800132 <libmain+0x2f>
  80014f:	89 d3                	mov    %edx,%ebx
  800151:	c1 e3 07             	shl    $0x7,%ebx
  800154:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80015a:	89 fe                	mov    %edi,%esi
  80015c:	eb d4                	jmp    800132 <libmain+0x2f>
  80015e:	89 f0                	mov    %esi,%eax
  800160:	84 c0                	test   %al,%al
  800162:	74 06                	je     80016a <libmain+0x67>
  800164:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80016a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80016e:	7e 0a                	jle    80017a <libmain+0x77>
		binaryname = argv[0];
  800170:	8b 45 0c             	mov    0xc(%ebp),%eax
  800173:	8b 00                	mov    (%eax),%eax
  800175:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80017a:	a1 08 40 80 00       	mov    0x804008,%eax
  80017f:	8b 40 48             	mov    0x48(%eax),%eax
  800182:	83 ec 08             	sub    $0x8,%esp
  800185:	50                   	push   %eax
  800186:	68 d0 27 80 00       	push   $0x8027d0
  80018b:	e8 76 01 00 00       	call   800306 <cprintf>
	cprintf("before umain\n");
  800190:	c7 04 24 ee 27 80 00 	movl   $0x8027ee,(%esp)
  800197:	e8 6a 01 00 00       	call   800306 <cprintf>
	// call user main routine
	umain(argc, argv);
  80019c:	83 c4 08             	add    $0x8,%esp
  80019f:	ff 75 0c             	pushl  0xc(%ebp)
  8001a2:	ff 75 08             	pushl  0x8(%ebp)
  8001a5:	e8 f9 fe ff ff       	call   8000a3 <umain>
	cprintf("after umain\n");
  8001aa:	c7 04 24 fc 27 80 00 	movl   $0x8027fc,(%esp)
  8001b1:	e8 50 01 00 00       	call   800306 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8001b6:	a1 08 40 80 00       	mov    0x804008,%eax
  8001bb:	8b 40 48             	mov    0x48(%eax),%eax
  8001be:	83 c4 08             	add    $0x8,%esp
  8001c1:	50                   	push   %eax
  8001c2:	68 09 28 80 00       	push   $0x802809
  8001c7:	e8 3a 01 00 00       	call   800306 <cprintf>
	// exit gracefully
	exit();
  8001cc:	e8 0b 00 00 00       	call   8001dc <exit>
}
  8001d1:	83 c4 10             	add    $0x10,%esp
  8001d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d7:	5b                   	pop    %ebx
  8001d8:	5e                   	pop    %esi
  8001d9:	5f                   	pop    %edi
  8001da:	5d                   	pop    %ebp
  8001db:	c3                   	ret    

008001dc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001dc:	55                   	push   %ebp
  8001dd:	89 e5                	mov    %esp,%ebp
  8001df:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001e2:	a1 08 40 80 00       	mov    0x804008,%eax
  8001e7:	8b 40 48             	mov    0x48(%eax),%eax
  8001ea:	68 34 28 80 00       	push   $0x802834
  8001ef:	50                   	push   %eax
  8001f0:	68 28 28 80 00       	push   $0x802828
  8001f5:	e8 0c 01 00 00       	call   800306 <cprintf>
	close_all();
  8001fa:	e8 9a 11 00 00       	call   801399 <close_all>
	sys_env_destroy(0);
  8001ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800206:	e8 cd 0b 00 00       	call   800dd8 <sys_env_destroy>
}
  80020b:	83 c4 10             	add    $0x10,%esp
  80020e:	c9                   	leave  
  80020f:	c3                   	ret    

00800210 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	56                   	push   %esi
  800214:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800215:	a1 08 40 80 00       	mov    0x804008,%eax
  80021a:	8b 40 48             	mov    0x48(%eax),%eax
  80021d:	83 ec 04             	sub    $0x4,%esp
  800220:	68 60 28 80 00       	push   $0x802860
  800225:	50                   	push   %eax
  800226:	68 28 28 80 00       	push   $0x802828
  80022b:	e8 d6 00 00 00       	call   800306 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800230:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800233:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800239:	e8 db 0b 00 00       	call   800e19 <sys_getenvid>
  80023e:	83 c4 04             	add    $0x4,%esp
  800241:	ff 75 0c             	pushl  0xc(%ebp)
  800244:	ff 75 08             	pushl  0x8(%ebp)
  800247:	56                   	push   %esi
  800248:	50                   	push   %eax
  800249:	68 3c 28 80 00       	push   $0x80283c
  80024e:	e8 b3 00 00 00       	call   800306 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800253:	83 c4 18             	add    $0x18,%esp
  800256:	53                   	push   %ebx
  800257:	ff 75 10             	pushl  0x10(%ebp)
  80025a:	e8 56 00 00 00       	call   8002b5 <vcprintf>
	cprintf("\n");
  80025f:	c7 04 24 ec 27 80 00 	movl   $0x8027ec,(%esp)
  800266:	e8 9b 00 00 00       	call   800306 <cprintf>
  80026b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80026e:	cc                   	int3   
  80026f:	eb fd                	jmp    80026e <_panic+0x5e>

00800271 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	53                   	push   %ebx
  800275:	83 ec 04             	sub    $0x4,%esp
  800278:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80027b:	8b 13                	mov    (%ebx),%edx
  80027d:	8d 42 01             	lea    0x1(%edx),%eax
  800280:	89 03                	mov    %eax,(%ebx)
  800282:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800285:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800289:	3d ff 00 00 00       	cmp    $0xff,%eax
  80028e:	74 09                	je     800299 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800290:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800294:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800297:	c9                   	leave  
  800298:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800299:	83 ec 08             	sub    $0x8,%esp
  80029c:	68 ff 00 00 00       	push   $0xff
  8002a1:	8d 43 08             	lea    0x8(%ebx),%eax
  8002a4:	50                   	push   %eax
  8002a5:	e8 f1 0a 00 00       	call   800d9b <sys_cputs>
		b->idx = 0;
  8002aa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002b0:	83 c4 10             	add    $0x10,%esp
  8002b3:	eb db                	jmp    800290 <putch+0x1f>

008002b5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
  8002b8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002be:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002c5:	00 00 00 
	b.cnt = 0;
  8002c8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002cf:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002d2:	ff 75 0c             	pushl  0xc(%ebp)
  8002d5:	ff 75 08             	pushl  0x8(%ebp)
  8002d8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002de:	50                   	push   %eax
  8002df:	68 71 02 80 00       	push   $0x800271
  8002e4:	e8 4a 01 00 00       	call   800433 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002e9:	83 c4 08             	add    $0x8,%esp
  8002ec:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002f2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002f8:	50                   	push   %eax
  8002f9:	e8 9d 0a 00 00       	call   800d9b <sys_cputs>

	return b.cnt;
}
  8002fe:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800304:	c9                   	leave  
  800305:	c3                   	ret    

00800306 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800306:	55                   	push   %ebp
  800307:	89 e5                	mov    %esp,%ebp
  800309:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80030c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80030f:	50                   	push   %eax
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	e8 9d ff ff ff       	call   8002b5 <vcprintf>
	va_end(ap);

	return cnt;
}
  800318:	c9                   	leave  
  800319:	c3                   	ret    

0080031a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80031a:	55                   	push   %ebp
  80031b:	89 e5                	mov    %esp,%ebp
  80031d:	57                   	push   %edi
  80031e:	56                   	push   %esi
  80031f:	53                   	push   %ebx
  800320:	83 ec 1c             	sub    $0x1c,%esp
  800323:	89 c6                	mov    %eax,%esi
  800325:	89 d7                	mov    %edx,%edi
  800327:	8b 45 08             	mov    0x8(%ebp),%eax
  80032a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80032d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800330:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800333:	8b 45 10             	mov    0x10(%ebp),%eax
  800336:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800339:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80033d:	74 2c                	je     80036b <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80033f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800342:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800349:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80034c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80034f:	39 c2                	cmp    %eax,%edx
  800351:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800354:	73 43                	jae    800399 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800356:	83 eb 01             	sub    $0x1,%ebx
  800359:	85 db                	test   %ebx,%ebx
  80035b:	7e 6c                	jle    8003c9 <printnum+0xaf>
				putch(padc, putdat);
  80035d:	83 ec 08             	sub    $0x8,%esp
  800360:	57                   	push   %edi
  800361:	ff 75 18             	pushl  0x18(%ebp)
  800364:	ff d6                	call   *%esi
  800366:	83 c4 10             	add    $0x10,%esp
  800369:	eb eb                	jmp    800356 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80036b:	83 ec 0c             	sub    $0xc,%esp
  80036e:	6a 20                	push   $0x20
  800370:	6a 00                	push   $0x0
  800372:	50                   	push   %eax
  800373:	ff 75 e4             	pushl  -0x1c(%ebp)
  800376:	ff 75 e0             	pushl  -0x20(%ebp)
  800379:	89 fa                	mov    %edi,%edx
  80037b:	89 f0                	mov    %esi,%eax
  80037d:	e8 98 ff ff ff       	call   80031a <printnum>
		while (--width > 0)
  800382:	83 c4 20             	add    $0x20,%esp
  800385:	83 eb 01             	sub    $0x1,%ebx
  800388:	85 db                	test   %ebx,%ebx
  80038a:	7e 65                	jle    8003f1 <printnum+0xd7>
			putch(padc, putdat);
  80038c:	83 ec 08             	sub    $0x8,%esp
  80038f:	57                   	push   %edi
  800390:	6a 20                	push   $0x20
  800392:	ff d6                	call   *%esi
  800394:	83 c4 10             	add    $0x10,%esp
  800397:	eb ec                	jmp    800385 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800399:	83 ec 0c             	sub    $0xc,%esp
  80039c:	ff 75 18             	pushl  0x18(%ebp)
  80039f:	83 eb 01             	sub    $0x1,%ebx
  8003a2:	53                   	push   %ebx
  8003a3:	50                   	push   %eax
  8003a4:	83 ec 08             	sub    $0x8,%esp
  8003a7:	ff 75 dc             	pushl  -0x24(%ebp)
  8003aa:	ff 75 d8             	pushl  -0x28(%ebp)
  8003ad:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003b0:	ff 75 e0             	pushl  -0x20(%ebp)
  8003b3:	e8 98 20 00 00       	call   802450 <__udivdi3>
  8003b8:	83 c4 18             	add    $0x18,%esp
  8003bb:	52                   	push   %edx
  8003bc:	50                   	push   %eax
  8003bd:	89 fa                	mov    %edi,%edx
  8003bf:	89 f0                	mov    %esi,%eax
  8003c1:	e8 54 ff ff ff       	call   80031a <printnum>
  8003c6:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8003c9:	83 ec 08             	sub    $0x8,%esp
  8003cc:	57                   	push   %edi
  8003cd:	83 ec 04             	sub    $0x4,%esp
  8003d0:	ff 75 dc             	pushl  -0x24(%ebp)
  8003d3:	ff 75 d8             	pushl  -0x28(%ebp)
  8003d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003d9:	ff 75 e0             	pushl  -0x20(%ebp)
  8003dc:	e8 7f 21 00 00       	call   802560 <__umoddi3>
  8003e1:	83 c4 14             	add    $0x14,%esp
  8003e4:	0f be 80 67 28 80 00 	movsbl 0x802867(%eax),%eax
  8003eb:	50                   	push   %eax
  8003ec:	ff d6                	call   *%esi
  8003ee:	83 c4 10             	add    $0x10,%esp
	}
}
  8003f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003f4:	5b                   	pop    %ebx
  8003f5:	5e                   	pop    %esi
  8003f6:	5f                   	pop    %edi
  8003f7:	5d                   	pop    %ebp
  8003f8:	c3                   	ret    

008003f9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003f9:	55                   	push   %ebp
  8003fa:	89 e5                	mov    %esp,%ebp
  8003fc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003ff:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800403:	8b 10                	mov    (%eax),%edx
  800405:	3b 50 04             	cmp    0x4(%eax),%edx
  800408:	73 0a                	jae    800414 <sprintputch+0x1b>
		*b->buf++ = ch;
  80040a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80040d:	89 08                	mov    %ecx,(%eax)
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	88 02                	mov    %al,(%edx)
}
  800414:	5d                   	pop    %ebp
  800415:	c3                   	ret    

00800416 <printfmt>:
{
  800416:	55                   	push   %ebp
  800417:	89 e5                	mov    %esp,%ebp
  800419:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80041c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80041f:	50                   	push   %eax
  800420:	ff 75 10             	pushl  0x10(%ebp)
  800423:	ff 75 0c             	pushl  0xc(%ebp)
  800426:	ff 75 08             	pushl  0x8(%ebp)
  800429:	e8 05 00 00 00       	call   800433 <vprintfmt>
}
  80042e:	83 c4 10             	add    $0x10,%esp
  800431:	c9                   	leave  
  800432:	c3                   	ret    

00800433 <vprintfmt>:
{
  800433:	55                   	push   %ebp
  800434:	89 e5                	mov    %esp,%ebp
  800436:	57                   	push   %edi
  800437:	56                   	push   %esi
  800438:	53                   	push   %ebx
  800439:	83 ec 3c             	sub    $0x3c,%esp
  80043c:	8b 75 08             	mov    0x8(%ebp),%esi
  80043f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800442:	8b 7d 10             	mov    0x10(%ebp),%edi
  800445:	e9 32 04 00 00       	jmp    80087c <vprintfmt+0x449>
		padc = ' ';
  80044a:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80044e:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800455:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80045c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800463:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80046a:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800471:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800476:	8d 47 01             	lea    0x1(%edi),%eax
  800479:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80047c:	0f b6 17             	movzbl (%edi),%edx
  80047f:	8d 42 dd             	lea    -0x23(%edx),%eax
  800482:	3c 55                	cmp    $0x55,%al
  800484:	0f 87 12 05 00 00    	ja     80099c <vprintfmt+0x569>
  80048a:	0f b6 c0             	movzbl %al,%eax
  80048d:	ff 24 85 40 2a 80 00 	jmp    *0x802a40(,%eax,4)
  800494:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800497:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80049b:	eb d9                	jmp    800476 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80049d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004a0:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8004a4:	eb d0                	jmp    800476 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004a6:	0f b6 d2             	movzbl %dl,%edx
  8004a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b1:	89 75 08             	mov    %esi,0x8(%ebp)
  8004b4:	eb 03                	jmp    8004b9 <vprintfmt+0x86>
  8004b6:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004b9:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004bc:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004c0:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004c3:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004c6:	83 fe 09             	cmp    $0x9,%esi
  8004c9:	76 eb                	jbe    8004b6 <vprintfmt+0x83>
  8004cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8004d1:	eb 14                	jmp    8004e7 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8004d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d6:	8b 00                	mov    (%eax),%eax
  8004d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004db:	8b 45 14             	mov    0x14(%ebp),%eax
  8004de:	8d 40 04             	lea    0x4(%eax),%eax
  8004e1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004eb:	79 89                	jns    800476 <vprintfmt+0x43>
				width = precision, precision = -1;
  8004ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004fa:	e9 77 ff ff ff       	jmp    800476 <vprintfmt+0x43>
  8004ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800502:	85 c0                	test   %eax,%eax
  800504:	0f 48 c1             	cmovs  %ecx,%eax
  800507:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80050a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80050d:	e9 64 ff ff ff       	jmp    800476 <vprintfmt+0x43>
  800512:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800515:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80051c:	e9 55 ff ff ff       	jmp    800476 <vprintfmt+0x43>
			lflag++;
  800521:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800525:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800528:	e9 49 ff ff ff       	jmp    800476 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80052d:	8b 45 14             	mov    0x14(%ebp),%eax
  800530:	8d 78 04             	lea    0x4(%eax),%edi
  800533:	83 ec 08             	sub    $0x8,%esp
  800536:	53                   	push   %ebx
  800537:	ff 30                	pushl  (%eax)
  800539:	ff d6                	call   *%esi
			break;
  80053b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80053e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800541:	e9 33 03 00 00       	jmp    800879 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800546:	8b 45 14             	mov    0x14(%ebp),%eax
  800549:	8d 78 04             	lea    0x4(%eax),%edi
  80054c:	8b 00                	mov    (%eax),%eax
  80054e:	99                   	cltd   
  80054f:	31 d0                	xor    %edx,%eax
  800551:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800553:	83 f8 11             	cmp    $0x11,%eax
  800556:	7f 23                	jg     80057b <vprintfmt+0x148>
  800558:	8b 14 85 a0 2b 80 00 	mov    0x802ba0(,%eax,4),%edx
  80055f:	85 d2                	test   %edx,%edx
  800561:	74 18                	je     80057b <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800563:	52                   	push   %edx
  800564:	68 39 2d 80 00       	push   $0x802d39
  800569:	53                   	push   %ebx
  80056a:	56                   	push   %esi
  80056b:	e8 a6 fe ff ff       	call   800416 <printfmt>
  800570:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800573:	89 7d 14             	mov    %edi,0x14(%ebp)
  800576:	e9 fe 02 00 00       	jmp    800879 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80057b:	50                   	push   %eax
  80057c:	68 7f 28 80 00       	push   $0x80287f
  800581:	53                   	push   %ebx
  800582:	56                   	push   %esi
  800583:	e8 8e fe ff ff       	call   800416 <printfmt>
  800588:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80058b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80058e:	e9 e6 02 00 00       	jmp    800879 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800593:	8b 45 14             	mov    0x14(%ebp),%eax
  800596:	83 c0 04             	add    $0x4,%eax
  800599:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8005a1:	85 c9                	test   %ecx,%ecx
  8005a3:	b8 78 28 80 00       	mov    $0x802878,%eax
  8005a8:	0f 45 c1             	cmovne %ecx,%eax
  8005ab:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8005ae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005b2:	7e 06                	jle    8005ba <vprintfmt+0x187>
  8005b4:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8005b8:	75 0d                	jne    8005c7 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ba:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005bd:	89 c7                	mov    %eax,%edi
  8005bf:	03 45 e0             	add    -0x20(%ebp),%eax
  8005c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005c5:	eb 53                	jmp    80061a <vprintfmt+0x1e7>
  8005c7:	83 ec 08             	sub    $0x8,%esp
  8005ca:	ff 75 d8             	pushl  -0x28(%ebp)
  8005cd:	50                   	push   %eax
  8005ce:	e8 71 04 00 00       	call   800a44 <strnlen>
  8005d3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005d6:	29 c1                	sub    %eax,%ecx
  8005d8:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8005db:	83 c4 10             	add    $0x10,%esp
  8005de:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005e0:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e7:	eb 0f                	jmp    8005f8 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8005e9:	83 ec 08             	sub    $0x8,%esp
  8005ec:	53                   	push   %ebx
  8005ed:	ff 75 e0             	pushl  -0x20(%ebp)
  8005f0:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f2:	83 ef 01             	sub    $0x1,%edi
  8005f5:	83 c4 10             	add    $0x10,%esp
  8005f8:	85 ff                	test   %edi,%edi
  8005fa:	7f ed                	jg     8005e9 <vprintfmt+0x1b6>
  8005fc:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8005ff:	85 c9                	test   %ecx,%ecx
  800601:	b8 00 00 00 00       	mov    $0x0,%eax
  800606:	0f 49 c1             	cmovns %ecx,%eax
  800609:	29 c1                	sub    %eax,%ecx
  80060b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80060e:	eb aa                	jmp    8005ba <vprintfmt+0x187>
					putch(ch, putdat);
  800610:	83 ec 08             	sub    $0x8,%esp
  800613:	53                   	push   %ebx
  800614:	52                   	push   %edx
  800615:	ff d6                	call   *%esi
  800617:	83 c4 10             	add    $0x10,%esp
  80061a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80061d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80061f:	83 c7 01             	add    $0x1,%edi
  800622:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800626:	0f be d0             	movsbl %al,%edx
  800629:	85 d2                	test   %edx,%edx
  80062b:	74 4b                	je     800678 <vprintfmt+0x245>
  80062d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800631:	78 06                	js     800639 <vprintfmt+0x206>
  800633:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800637:	78 1e                	js     800657 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800639:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80063d:	74 d1                	je     800610 <vprintfmt+0x1dd>
  80063f:	0f be c0             	movsbl %al,%eax
  800642:	83 e8 20             	sub    $0x20,%eax
  800645:	83 f8 5e             	cmp    $0x5e,%eax
  800648:	76 c6                	jbe    800610 <vprintfmt+0x1dd>
					putch('?', putdat);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	53                   	push   %ebx
  80064e:	6a 3f                	push   $0x3f
  800650:	ff d6                	call   *%esi
  800652:	83 c4 10             	add    $0x10,%esp
  800655:	eb c3                	jmp    80061a <vprintfmt+0x1e7>
  800657:	89 cf                	mov    %ecx,%edi
  800659:	eb 0e                	jmp    800669 <vprintfmt+0x236>
				putch(' ', putdat);
  80065b:	83 ec 08             	sub    $0x8,%esp
  80065e:	53                   	push   %ebx
  80065f:	6a 20                	push   $0x20
  800661:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800663:	83 ef 01             	sub    $0x1,%edi
  800666:	83 c4 10             	add    $0x10,%esp
  800669:	85 ff                	test   %edi,%edi
  80066b:	7f ee                	jg     80065b <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80066d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800670:	89 45 14             	mov    %eax,0x14(%ebp)
  800673:	e9 01 02 00 00       	jmp    800879 <vprintfmt+0x446>
  800678:	89 cf                	mov    %ecx,%edi
  80067a:	eb ed                	jmp    800669 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80067c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80067f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800686:	e9 eb fd ff ff       	jmp    800476 <vprintfmt+0x43>
	if (lflag >= 2)
  80068b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80068f:	7f 21                	jg     8006b2 <vprintfmt+0x27f>
	else if (lflag)
  800691:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800695:	74 68                	je     8006ff <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8b 00                	mov    (%eax),%eax
  80069c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80069f:	89 c1                	mov    %eax,%ecx
  8006a1:	c1 f9 1f             	sar    $0x1f,%ecx
  8006a4:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	8d 40 04             	lea    0x4(%eax),%eax
  8006ad:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b0:	eb 17                	jmp    8006c9 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8006b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b5:	8b 50 04             	mov    0x4(%eax),%edx
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006bd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c3:	8d 40 08             	lea    0x8(%eax),%eax
  8006c6:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d2:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8006d5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006d9:	78 3f                	js     80071a <vprintfmt+0x2e7>
			base = 10;
  8006db:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8006e0:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8006e4:	0f 84 71 01 00 00    	je     80085b <vprintfmt+0x428>
				putch('+', putdat);
  8006ea:	83 ec 08             	sub    $0x8,%esp
  8006ed:	53                   	push   %ebx
  8006ee:	6a 2b                	push   $0x2b
  8006f0:	ff d6                	call   *%esi
  8006f2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006f5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006fa:	e9 5c 01 00 00       	jmp    80085b <vprintfmt+0x428>
		return va_arg(*ap, int);
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	8b 00                	mov    (%eax),%eax
  800704:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800707:	89 c1                	mov    %eax,%ecx
  800709:	c1 f9 1f             	sar    $0x1f,%ecx
  80070c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	8d 40 04             	lea    0x4(%eax),%eax
  800715:	89 45 14             	mov    %eax,0x14(%ebp)
  800718:	eb af                	jmp    8006c9 <vprintfmt+0x296>
				putch('-', putdat);
  80071a:	83 ec 08             	sub    $0x8,%esp
  80071d:	53                   	push   %ebx
  80071e:	6a 2d                	push   $0x2d
  800720:	ff d6                	call   *%esi
				num = -(long long) num;
  800722:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800725:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800728:	f7 d8                	neg    %eax
  80072a:	83 d2 00             	adc    $0x0,%edx
  80072d:	f7 da                	neg    %edx
  80072f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800732:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800735:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800738:	b8 0a 00 00 00       	mov    $0xa,%eax
  80073d:	e9 19 01 00 00       	jmp    80085b <vprintfmt+0x428>
	if (lflag >= 2)
  800742:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800746:	7f 29                	jg     800771 <vprintfmt+0x33e>
	else if (lflag)
  800748:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80074c:	74 44                	je     800792 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80074e:	8b 45 14             	mov    0x14(%ebp),%eax
  800751:	8b 00                	mov    (%eax),%eax
  800753:	ba 00 00 00 00       	mov    $0x0,%edx
  800758:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075e:	8b 45 14             	mov    0x14(%ebp),%eax
  800761:	8d 40 04             	lea    0x4(%eax),%eax
  800764:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800767:	b8 0a 00 00 00       	mov    $0xa,%eax
  80076c:	e9 ea 00 00 00       	jmp    80085b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800771:	8b 45 14             	mov    0x14(%ebp),%eax
  800774:	8b 50 04             	mov    0x4(%eax),%edx
  800777:	8b 00                	mov    (%eax),%eax
  800779:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077f:	8b 45 14             	mov    0x14(%ebp),%eax
  800782:	8d 40 08             	lea    0x8(%eax),%eax
  800785:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800788:	b8 0a 00 00 00       	mov    $0xa,%eax
  80078d:	e9 c9 00 00 00       	jmp    80085b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800792:	8b 45 14             	mov    0x14(%ebp),%eax
  800795:	8b 00                	mov    (%eax),%eax
  800797:	ba 00 00 00 00       	mov    $0x0,%edx
  80079c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a5:	8d 40 04             	lea    0x4(%eax),%eax
  8007a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007ab:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007b0:	e9 a6 00 00 00       	jmp    80085b <vprintfmt+0x428>
			putch('0', putdat);
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	53                   	push   %ebx
  8007b9:	6a 30                	push   $0x30
  8007bb:	ff d6                	call   *%esi
	if (lflag >= 2)
  8007bd:	83 c4 10             	add    $0x10,%esp
  8007c0:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007c4:	7f 26                	jg     8007ec <vprintfmt+0x3b9>
	else if (lflag)
  8007c6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007ca:	74 3e                	je     80080a <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8007cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cf:	8b 00                	mov    (%eax),%eax
  8007d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007df:	8d 40 04             	lea    0x4(%eax),%eax
  8007e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007e5:	b8 08 00 00 00       	mov    $0x8,%eax
  8007ea:	eb 6f                	jmp    80085b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ef:	8b 50 04             	mov    0x4(%eax),%edx
  8007f2:	8b 00                	mov    (%eax),%eax
  8007f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fd:	8d 40 08             	lea    0x8(%eax),%eax
  800800:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800803:	b8 08 00 00 00       	mov    $0x8,%eax
  800808:	eb 51                	jmp    80085b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80080a:	8b 45 14             	mov    0x14(%ebp),%eax
  80080d:	8b 00                	mov    (%eax),%eax
  80080f:	ba 00 00 00 00       	mov    $0x0,%edx
  800814:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800817:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	8d 40 04             	lea    0x4(%eax),%eax
  800820:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800823:	b8 08 00 00 00       	mov    $0x8,%eax
  800828:	eb 31                	jmp    80085b <vprintfmt+0x428>
			putch('0', putdat);
  80082a:	83 ec 08             	sub    $0x8,%esp
  80082d:	53                   	push   %ebx
  80082e:	6a 30                	push   $0x30
  800830:	ff d6                	call   *%esi
			putch('x', putdat);
  800832:	83 c4 08             	add    $0x8,%esp
  800835:	53                   	push   %ebx
  800836:	6a 78                	push   $0x78
  800838:	ff d6                	call   *%esi
			num = (unsigned long long)
  80083a:	8b 45 14             	mov    0x14(%ebp),%eax
  80083d:	8b 00                	mov    (%eax),%eax
  80083f:	ba 00 00 00 00       	mov    $0x0,%edx
  800844:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800847:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80084a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80084d:	8b 45 14             	mov    0x14(%ebp),%eax
  800850:	8d 40 04             	lea    0x4(%eax),%eax
  800853:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800856:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80085b:	83 ec 0c             	sub    $0xc,%esp
  80085e:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800862:	52                   	push   %edx
  800863:	ff 75 e0             	pushl  -0x20(%ebp)
  800866:	50                   	push   %eax
  800867:	ff 75 dc             	pushl  -0x24(%ebp)
  80086a:	ff 75 d8             	pushl  -0x28(%ebp)
  80086d:	89 da                	mov    %ebx,%edx
  80086f:	89 f0                	mov    %esi,%eax
  800871:	e8 a4 fa ff ff       	call   80031a <printnum>
			break;
  800876:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800879:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80087c:	83 c7 01             	add    $0x1,%edi
  80087f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800883:	83 f8 25             	cmp    $0x25,%eax
  800886:	0f 84 be fb ff ff    	je     80044a <vprintfmt+0x17>
			if (ch == '\0')
  80088c:	85 c0                	test   %eax,%eax
  80088e:	0f 84 28 01 00 00    	je     8009bc <vprintfmt+0x589>
			putch(ch, putdat);
  800894:	83 ec 08             	sub    $0x8,%esp
  800897:	53                   	push   %ebx
  800898:	50                   	push   %eax
  800899:	ff d6                	call   *%esi
  80089b:	83 c4 10             	add    $0x10,%esp
  80089e:	eb dc                	jmp    80087c <vprintfmt+0x449>
	if (lflag >= 2)
  8008a0:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008a4:	7f 26                	jg     8008cc <vprintfmt+0x499>
	else if (lflag)
  8008a6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008aa:	74 41                	je     8008ed <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8008ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bf:	8d 40 04             	lea    0x4(%eax),%eax
  8008c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008c5:	b8 10 00 00 00       	mov    $0x10,%eax
  8008ca:	eb 8f                	jmp    80085b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cf:	8b 50 04             	mov    0x4(%eax),%edx
  8008d2:	8b 00                	mov    (%eax),%eax
  8008d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008da:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dd:	8d 40 08             	lea    0x8(%eax),%eax
  8008e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008e3:	b8 10 00 00 00       	mov    $0x10,%eax
  8008e8:	e9 6e ff ff ff       	jmp    80085b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f0:	8b 00                	mov    (%eax),%eax
  8008f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800900:	8d 40 04             	lea    0x4(%eax),%eax
  800903:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800906:	b8 10 00 00 00       	mov    $0x10,%eax
  80090b:	e9 4b ff ff ff       	jmp    80085b <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800910:	8b 45 14             	mov    0x14(%ebp),%eax
  800913:	83 c0 04             	add    $0x4,%eax
  800916:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800919:	8b 45 14             	mov    0x14(%ebp),%eax
  80091c:	8b 00                	mov    (%eax),%eax
  80091e:	85 c0                	test   %eax,%eax
  800920:	74 14                	je     800936 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800922:	8b 13                	mov    (%ebx),%edx
  800924:	83 fa 7f             	cmp    $0x7f,%edx
  800927:	7f 37                	jg     800960 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800929:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80092b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80092e:	89 45 14             	mov    %eax,0x14(%ebp)
  800931:	e9 43 ff ff ff       	jmp    800879 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800936:	b8 0a 00 00 00       	mov    $0xa,%eax
  80093b:	bf 9d 29 80 00       	mov    $0x80299d,%edi
							putch(ch, putdat);
  800940:	83 ec 08             	sub    $0x8,%esp
  800943:	53                   	push   %ebx
  800944:	50                   	push   %eax
  800945:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800947:	83 c7 01             	add    $0x1,%edi
  80094a:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80094e:	83 c4 10             	add    $0x10,%esp
  800951:	85 c0                	test   %eax,%eax
  800953:	75 eb                	jne    800940 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800955:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800958:	89 45 14             	mov    %eax,0x14(%ebp)
  80095b:	e9 19 ff ff ff       	jmp    800879 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800960:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800962:	b8 0a 00 00 00       	mov    $0xa,%eax
  800967:	bf d5 29 80 00       	mov    $0x8029d5,%edi
							putch(ch, putdat);
  80096c:	83 ec 08             	sub    $0x8,%esp
  80096f:	53                   	push   %ebx
  800970:	50                   	push   %eax
  800971:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800973:	83 c7 01             	add    $0x1,%edi
  800976:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80097a:	83 c4 10             	add    $0x10,%esp
  80097d:	85 c0                	test   %eax,%eax
  80097f:	75 eb                	jne    80096c <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800981:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800984:	89 45 14             	mov    %eax,0x14(%ebp)
  800987:	e9 ed fe ff ff       	jmp    800879 <vprintfmt+0x446>
			putch(ch, putdat);
  80098c:	83 ec 08             	sub    $0x8,%esp
  80098f:	53                   	push   %ebx
  800990:	6a 25                	push   $0x25
  800992:	ff d6                	call   *%esi
			break;
  800994:	83 c4 10             	add    $0x10,%esp
  800997:	e9 dd fe ff ff       	jmp    800879 <vprintfmt+0x446>
			putch('%', putdat);
  80099c:	83 ec 08             	sub    $0x8,%esp
  80099f:	53                   	push   %ebx
  8009a0:	6a 25                	push   $0x25
  8009a2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009a4:	83 c4 10             	add    $0x10,%esp
  8009a7:	89 f8                	mov    %edi,%eax
  8009a9:	eb 03                	jmp    8009ae <vprintfmt+0x57b>
  8009ab:	83 e8 01             	sub    $0x1,%eax
  8009ae:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009b2:	75 f7                	jne    8009ab <vprintfmt+0x578>
  8009b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009b7:	e9 bd fe ff ff       	jmp    800879 <vprintfmt+0x446>
}
  8009bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009bf:	5b                   	pop    %ebx
  8009c0:	5e                   	pop    %esi
  8009c1:	5f                   	pop    %edi
  8009c2:	5d                   	pop    %ebp
  8009c3:	c3                   	ret    

008009c4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	83 ec 18             	sub    $0x18,%esp
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009d3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009d7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009e1:	85 c0                	test   %eax,%eax
  8009e3:	74 26                	je     800a0b <vsnprintf+0x47>
  8009e5:	85 d2                	test   %edx,%edx
  8009e7:	7e 22                	jle    800a0b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009e9:	ff 75 14             	pushl  0x14(%ebp)
  8009ec:	ff 75 10             	pushl  0x10(%ebp)
  8009ef:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009f2:	50                   	push   %eax
  8009f3:	68 f9 03 80 00       	push   $0x8003f9
  8009f8:	e8 36 fa ff ff       	call   800433 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a00:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a06:	83 c4 10             	add    $0x10,%esp
}
  800a09:	c9                   	leave  
  800a0a:	c3                   	ret    
		return -E_INVAL;
  800a0b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a10:	eb f7                	jmp    800a09 <vsnprintf+0x45>

00800a12 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a12:	55                   	push   %ebp
  800a13:	89 e5                	mov    %esp,%ebp
  800a15:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a18:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a1b:	50                   	push   %eax
  800a1c:	ff 75 10             	pushl  0x10(%ebp)
  800a1f:	ff 75 0c             	pushl  0xc(%ebp)
  800a22:	ff 75 08             	pushl  0x8(%ebp)
  800a25:	e8 9a ff ff ff       	call   8009c4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a2a:	c9                   	leave  
  800a2b:	c3                   	ret    

00800a2c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a32:	b8 00 00 00 00       	mov    $0x0,%eax
  800a37:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a3b:	74 05                	je     800a42 <strlen+0x16>
		n++;
  800a3d:	83 c0 01             	add    $0x1,%eax
  800a40:	eb f5                	jmp    800a37 <strlen+0xb>
	return n;
}
  800a42:	5d                   	pop    %ebp
  800a43:	c3                   	ret    

00800a44 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a52:	39 c2                	cmp    %eax,%edx
  800a54:	74 0d                	je     800a63 <strnlen+0x1f>
  800a56:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a5a:	74 05                	je     800a61 <strnlen+0x1d>
		n++;
  800a5c:	83 c2 01             	add    $0x1,%edx
  800a5f:	eb f1                	jmp    800a52 <strnlen+0xe>
  800a61:	89 d0                	mov    %edx,%eax
	return n;
}
  800a63:	5d                   	pop    %ebp
  800a64:	c3                   	ret    

00800a65 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
  800a68:	53                   	push   %ebx
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a74:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a78:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a7b:	83 c2 01             	add    $0x1,%edx
  800a7e:	84 c9                	test   %cl,%cl
  800a80:	75 f2                	jne    800a74 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a82:	5b                   	pop    %ebx
  800a83:	5d                   	pop    %ebp
  800a84:	c3                   	ret    

00800a85 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	53                   	push   %ebx
  800a89:	83 ec 10             	sub    $0x10,%esp
  800a8c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a8f:	53                   	push   %ebx
  800a90:	e8 97 ff ff ff       	call   800a2c <strlen>
  800a95:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	01 d8                	add    %ebx,%eax
  800a9d:	50                   	push   %eax
  800a9e:	e8 c2 ff ff ff       	call   800a65 <strcpy>
	return dst;
}
  800aa3:	89 d8                	mov    %ebx,%eax
  800aa5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aa8:	c9                   	leave  
  800aa9:	c3                   	ret    

00800aaa <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800aaa:	55                   	push   %ebp
  800aab:	89 e5                	mov    %esp,%ebp
  800aad:	56                   	push   %esi
  800aae:	53                   	push   %ebx
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ab5:	89 c6                	mov    %eax,%esi
  800ab7:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aba:	89 c2                	mov    %eax,%edx
  800abc:	39 f2                	cmp    %esi,%edx
  800abe:	74 11                	je     800ad1 <strncpy+0x27>
		*dst++ = *src;
  800ac0:	83 c2 01             	add    $0x1,%edx
  800ac3:	0f b6 19             	movzbl (%ecx),%ebx
  800ac6:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ac9:	80 fb 01             	cmp    $0x1,%bl
  800acc:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800acf:	eb eb                	jmp    800abc <strncpy+0x12>
	}
	return ret;
}
  800ad1:	5b                   	pop    %ebx
  800ad2:	5e                   	pop    %esi
  800ad3:	5d                   	pop    %ebp
  800ad4:	c3                   	ret    

00800ad5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ad5:	55                   	push   %ebp
  800ad6:	89 e5                	mov    %esp,%ebp
  800ad8:	56                   	push   %esi
  800ad9:	53                   	push   %ebx
  800ada:	8b 75 08             	mov    0x8(%ebp),%esi
  800add:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ae0:	8b 55 10             	mov    0x10(%ebp),%edx
  800ae3:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ae5:	85 d2                	test   %edx,%edx
  800ae7:	74 21                	je     800b0a <strlcpy+0x35>
  800ae9:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800aed:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800aef:	39 c2                	cmp    %eax,%edx
  800af1:	74 14                	je     800b07 <strlcpy+0x32>
  800af3:	0f b6 19             	movzbl (%ecx),%ebx
  800af6:	84 db                	test   %bl,%bl
  800af8:	74 0b                	je     800b05 <strlcpy+0x30>
			*dst++ = *src++;
  800afa:	83 c1 01             	add    $0x1,%ecx
  800afd:	83 c2 01             	add    $0x1,%edx
  800b00:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b03:	eb ea                	jmp    800aef <strlcpy+0x1a>
  800b05:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b07:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b0a:	29 f0                	sub    %esi,%eax
}
  800b0c:	5b                   	pop    %ebx
  800b0d:	5e                   	pop    %esi
  800b0e:	5d                   	pop    %ebp
  800b0f:	c3                   	ret    

00800b10 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b16:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b19:	0f b6 01             	movzbl (%ecx),%eax
  800b1c:	84 c0                	test   %al,%al
  800b1e:	74 0c                	je     800b2c <strcmp+0x1c>
  800b20:	3a 02                	cmp    (%edx),%al
  800b22:	75 08                	jne    800b2c <strcmp+0x1c>
		p++, q++;
  800b24:	83 c1 01             	add    $0x1,%ecx
  800b27:	83 c2 01             	add    $0x1,%edx
  800b2a:	eb ed                	jmp    800b19 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b2c:	0f b6 c0             	movzbl %al,%eax
  800b2f:	0f b6 12             	movzbl (%edx),%edx
  800b32:	29 d0                	sub    %edx,%eax
}
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	53                   	push   %ebx
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b40:	89 c3                	mov    %eax,%ebx
  800b42:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b45:	eb 06                	jmp    800b4d <strncmp+0x17>
		n--, p++, q++;
  800b47:	83 c0 01             	add    $0x1,%eax
  800b4a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b4d:	39 d8                	cmp    %ebx,%eax
  800b4f:	74 16                	je     800b67 <strncmp+0x31>
  800b51:	0f b6 08             	movzbl (%eax),%ecx
  800b54:	84 c9                	test   %cl,%cl
  800b56:	74 04                	je     800b5c <strncmp+0x26>
  800b58:	3a 0a                	cmp    (%edx),%cl
  800b5a:	74 eb                	je     800b47 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b5c:	0f b6 00             	movzbl (%eax),%eax
  800b5f:	0f b6 12             	movzbl (%edx),%edx
  800b62:	29 d0                	sub    %edx,%eax
}
  800b64:	5b                   	pop    %ebx
  800b65:	5d                   	pop    %ebp
  800b66:	c3                   	ret    
		return 0;
  800b67:	b8 00 00 00 00       	mov    $0x0,%eax
  800b6c:	eb f6                	jmp    800b64 <strncmp+0x2e>

00800b6e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b78:	0f b6 10             	movzbl (%eax),%edx
  800b7b:	84 d2                	test   %dl,%dl
  800b7d:	74 09                	je     800b88 <strchr+0x1a>
		if (*s == c)
  800b7f:	38 ca                	cmp    %cl,%dl
  800b81:	74 0a                	je     800b8d <strchr+0x1f>
	for (; *s; s++)
  800b83:	83 c0 01             	add    $0x1,%eax
  800b86:	eb f0                	jmp    800b78 <strchr+0xa>
			return (char *) s;
	return 0;
  800b88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    

00800b8f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b99:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b9c:	38 ca                	cmp    %cl,%dl
  800b9e:	74 09                	je     800ba9 <strfind+0x1a>
  800ba0:	84 d2                	test   %dl,%dl
  800ba2:	74 05                	je     800ba9 <strfind+0x1a>
	for (; *s; s++)
  800ba4:	83 c0 01             	add    $0x1,%eax
  800ba7:	eb f0                	jmp    800b99 <strfind+0xa>
			break;
	return (char *) s;
}
  800ba9:	5d                   	pop    %ebp
  800baa:	c3                   	ret    

00800bab <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bab:	55                   	push   %ebp
  800bac:	89 e5                	mov    %esp,%ebp
  800bae:	57                   	push   %edi
  800baf:	56                   	push   %esi
  800bb0:	53                   	push   %ebx
  800bb1:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bb4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bb7:	85 c9                	test   %ecx,%ecx
  800bb9:	74 31                	je     800bec <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bbb:	89 f8                	mov    %edi,%eax
  800bbd:	09 c8                	or     %ecx,%eax
  800bbf:	a8 03                	test   $0x3,%al
  800bc1:	75 23                	jne    800be6 <memset+0x3b>
		c &= 0xFF;
  800bc3:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bc7:	89 d3                	mov    %edx,%ebx
  800bc9:	c1 e3 08             	shl    $0x8,%ebx
  800bcc:	89 d0                	mov    %edx,%eax
  800bce:	c1 e0 18             	shl    $0x18,%eax
  800bd1:	89 d6                	mov    %edx,%esi
  800bd3:	c1 e6 10             	shl    $0x10,%esi
  800bd6:	09 f0                	or     %esi,%eax
  800bd8:	09 c2                	or     %eax,%edx
  800bda:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bdc:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800bdf:	89 d0                	mov    %edx,%eax
  800be1:	fc                   	cld    
  800be2:	f3 ab                	rep stos %eax,%es:(%edi)
  800be4:	eb 06                	jmp    800bec <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800be6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be9:	fc                   	cld    
  800bea:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bec:	89 f8                	mov    %edi,%eax
  800bee:	5b                   	pop    %ebx
  800bef:	5e                   	pop    %esi
  800bf0:	5f                   	pop    %edi
  800bf1:	5d                   	pop    %ebp
  800bf2:	c3                   	ret    

00800bf3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	57                   	push   %edi
  800bf7:	56                   	push   %esi
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bfe:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c01:	39 c6                	cmp    %eax,%esi
  800c03:	73 32                	jae    800c37 <memmove+0x44>
  800c05:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c08:	39 c2                	cmp    %eax,%edx
  800c0a:	76 2b                	jbe    800c37 <memmove+0x44>
		s += n;
		d += n;
  800c0c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c0f:	89 fe                	mov    %edi,%esi
  800c11:	09 ce                	or     %ecx,%esi
  800c13:	09 d6                	or     %edx,%esi
  800c15:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c1b:	75 0e                	jne    800c2b <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c1d:	83 ef 04             	sub    $0x4,%edi
  800c20:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c23:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c26:	fd                   	std    
  800c27:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c29:	eb 09                	jmp    800c34 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c2b:	83 ef 01             	sub    $0x1,%edi
  800c2e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c31:	fd                   	std    
  800c32:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c34:	fc                   	cld    
  800c35:	eb 1a                	jmp    800c51 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c37:	89 c2                	mov    %eax,%edx
  800c39:	09 ca                	or     %ecx,%edx
  800c3b:	09 f2                	or     %esi,%edx
  800c3d:	f6 c2 03             	test   $0x3,%dl
  800c40:	75 0a                	jne    800c4c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c42:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c45:	89 c7                	mov    %eax,%edi
  800c47:	fc                   	cld    
  800c48:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c4a:	eb 05                	jmp    800c51 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c4c:	89 c7                	mov    %eax,%edi
  800c4e:	fc                   	cld    
  800c4f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c51:	5e                   	pop    %esi
  800c52:	5f                   	pop    %edi
  800c53:	5d                   	pop    %ebp
  800c54:	c3                   	ret    

00800c55 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c5b:	ff 75 10             	pushl  0x10(%ebp)
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	ff 75 08             	pushl  0x8(%ebp)
  800c64:	e8 8a ff ff ff       	call   800bf3 <memmove>
}
  800c69:	c9                   	leave  
  800c6a:	c3                   	ret    

00800c6b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	56                   	push   %esi
  800c6f:	53                   	push   %ebx
  800c70:	8b 45 08             	mov    0x8(%ebp),%eax
  800c73:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c76:	89 c6                	mov    %eax,%esi
  800c78:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c7b:	39 f0                	cmp    %esi,%eax
  800c7d:	74 1c                	je     800c9b <memcmp+0x30>
		if (*s1 != *s2)
  800c7f:	0f b6 08             	movzbl (%eax),%ecx
  800c82:	0f b6 1a             	movzbl (%edx),%ebx
  800c85:	38 d9                	cmp    %bl,%cl
  800c87:	75 08                	jne    800c91 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c89:	83 c0 01             	add    $0x1,%eax
  800c8c:	83 c2 01             	add    $0x1,%edx
  800c8f:	eb ea                	jmp    800c7b <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c91:	0f b6 c1             	movzbl %cl,%eax
  800c94:	0f b6 db             	movzbl %bl,%ebx
  800c97:	29 d8                	sub    %ebx,%eax
  800c99:	eb 05                	jmp    800ca0 <memcmp+0x35>
	}

	return 0;
  800c9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ca0:	5b                   	pop    %ebx
  800ca1:	5e                   	pop    %esi
  800ca2:	5d                   	pop    %ebp
  800ca3:	c3                   	ret    

00800ca4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cad:	89 c2                	mov    %eax,%edx
  800caf:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cb2:	39 d0                	cmp    %edx,%eax
  800cb4:	73 09                	jae    800cbf <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cb6:	38 08                	cmp    %cl,(%eax)
  800cb8:	74 05                	je     800cbf <memfind+0x1b>
	for (; s < ends; s++)
  800cba:	83 c0 01             	add    $0x1,%eax
  800cbd:	eb f3                	jmp    800cb2 <memfind+0xe>
			break;
	return (void *) s;
}
  800cbf:	5d                   	pop    %ebp
  800cc0:	c3                   	ret    

00800cc1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
  800cc4:	57                   	push   %edi
  800cc5:	56                   	push   %esi
  800cc6:	53                   	push   %ebx
  800cc7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cca:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ccd:	eb 03                	jmp    800cd2 <strtol+0x11>
		s++;
  800ccf:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cd2:	0f b6 01             	movzbl (%ecx),%eax
  800cd5:	3c 20                	cmp    $0x20,%al
  800cd7:	74 f6                	je     800ccf <strtol+0xe>
  800cd9:	3c 09                	cmp    $0x9,%al
  800cdb:	74 f2                	je     800ccf <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cdd:	3c 2b                	cmp    $0x2b,%al
  800cdf:	74 2a                	je     800d0b <strtol+0x4a>
	int neg = 0;
  800ce1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ce6:	3c 2d                	cmp    $0x2d,%al
  800ce8:	74 2b                	je     800d15 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cea:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cf0:	75 0f                	jne    800d01 <strtol+0x40>
  800cf2:	80 39 30             	cmpb   $0x30,(%ecx)
  800cf5:	74 28                	je     800d1f <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cf7:	85 db                	test   %ebx,%ebx
  800cf9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cfe:	0f 44 d8             	cmove  %eax,%ebx
  800d01:	b8 00 00 00 00       	mov    $0x0,%eax
  800d06:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d09:	eb 50                	jmp    800d5b <strtol+0x9a>
		s++;
  800d0b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d0e:	bf 00 00 00 00       	mov    $0x0,%edi
  800d13:	eb d5                	jmp    800cea <strtol+0x29>
		s++, neg = 1;
  800d15:	83 c1 01             	add    $0x1,%ecx
  800d18:	bf 01 00 00 00       	mov    $0x1,%edi
  800d1d:	eb cb                	jmp    800cea <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d1f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d23:	74 0e                	je     800d33 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d25:	85 db                	test   %ebx,%ebx
  800d27:	75 d8                	jne    800d01 <strtol+0x40>
		s++, base = 8;
  800d29:	83 c1 01             	add    $0x1,%ecx
  800d2c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d31:	eb ce                	jmp    800d01 <strtol+0x40>
		s += 2, base = 16;
  800d33:	83 c1 02             	add    $0x2,%ecx
  800d36:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d3b:	eb c4                	jmp    800d01 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d3d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d40:	89 f3                	mov    %esi,%ebx
  800d42:	80 fb 19             	cmp    $0x19,%bl
  800d45:	77 29                	ja     800d70 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d47:	0f be d2             	movsbl %dl,%edx
  800d4a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d4d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d50:	7d 30                	jge    800d82 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d52:	83 c1 01             	add    $0x1,%ecx
  800d55:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d59:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d5b:	0f b6 11             	movzbl (%ecx),%edx
  800d5e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d61:	89 f3                	mov    %esi,%ebx
  800d63:	80 fb 09             	cmp    $0x9,%bl
  800d66:	77 d5                	ja     800d3d <strtol+0x7c>
			dig = *s - '0';
  800d68:	0f be d2             	movsbl %dl,%edx
  800d6b:	83 ea 30             	sub    $0x30,%edx
  800d6e:	eb dd                	jmp    800d4d <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d70:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d73:	89 f3                	mov    %esi,%ebx
  800d75:	80 fb 19             	cmp    $0x19,%bl
  800d78:	77 08                	ja     800d82 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d7a:	0f be d2             	movsbl %dl,%edx
  800d7d:	83 ea 37             	sub    $0x37,%edx
  800d80:	eb cb                	jmp    800d4d <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d86:	74 05                	je     800d8d <strtol+0xcc>
		*endptr = (char *) s;
  800d88:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d8b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d8d:	89 c2                	mov    %eax,%edx
  800d8f:	f7 da                	neg    %edx
  800d91:	85 ff                	test   %edi,%edi
  800d93:	0f 45 c2             	cmovne %edx,%eax
}
  800d96:	5b                   	pop    %ebx
  800d97:	5e                   	pop    %esi
  800d98:	5f                   	pop    %edi
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    

00800d9b <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	57                   	push   %edi
  800d9f:	56                   	push   %esi
  800da0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da1:	b8 00 00 00 00       	mov    $0x0,%eax
  800da6:	8b 55 08             	mov    0x8(%ebp),%edx
  800da9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dac:	89 c3                	mov    %eax,%ebx
  800dae:	89 c7                	mov    %eax,%edi
  800db0:	89 c6                	mov    %eax,%esi
  800db2:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800db4:	5b                   	pop    %ebx
  800db5:	5e                   	pop    %esi
  800db6:	5f                   	pop    %edi
  800db7:	5d                   	pop    %ebp
  800db8:	c3                   	ret    

00800db9 <sys_cgetc>:

int
sys_cgetc(void)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	57                   	push   %edi
  800dbd:	56                   	push   %esi
  800dbe:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dbf:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc4:	b8 01 00 00 00       	mov    $0x1,%eax
  800dc9:	89 d1                	mov    %edx,%ecx
  800dcb:	89 d3                	mov    %edx,%ebx
  800dcd:	89 d7                	mov    %edx,%edi
  800dcf:	89 d6                	mov    %edx,%esi
  800dd1:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dd3:	5b                   	pop    %ebx
  800dd4:	5e                   	pop    %esi
  800dd5:	5f                   	pop    %edi
  800dd6:	5d                   	pop    %ebp
  800dd7:	c3                   	ret    

00800dd8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	57                   	push   %edi
  800ddc:	56                   	push   %esi
  800ddd:	53                   	push   %ebx
  800dde:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800de6:	8b 55 08             	mov    0x8(%ebp),%edx
  800de9:	b8 03 00 00 00       	mov    $0x3,%eax
  800dee:	89 cb                	mov    %ecx,%ebx
  800df0:	89 cf                	mov    %ecx,%edi
  800df2:	89 ce                	mov    %ecx,%esi
  800df4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df6:	85 c0                	test   %eax,%eax
  800df8:	7f 08                	jg     800e02 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dfd:	5b                   	pop    %ebx
  800dfe:	5e                   	pop    %esi
  800dff:	5f                   	pop    %edi
  800e00:	5d                   	pop    %ebp
  800e01:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e02:	83 ec 0c             	sub    $0xc,%esp
  800e05:	50                   	push   %eax
  800e06:	6a 03                	push   $0x3
  800e08:	68 e8 2b 80 00       	push   $0x802be8
  800e0d:	6a 43                	push   $0x43
  800e0f:	68 05 2c 80 00       	push   $0x802c05
  800e14:	e8 f7 f3 ff ff       	call   800210 <_panic>

00800e19 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	57                   	push   %edi
  800e1d:	56                   	push   %esi
  800e1e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800e24:	b8 02 00 00 00       	mov    $0x2,%eax
  800e29:	89 d1                	mov    %edx,%ecx
  800e2b:	89 d3                	mov    %edx,%ebx
  800e2d:	89 d7                	mov    %edx,%edi
  800e2f:	89 d6                	mov    %edx,%esi
  800e31:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e33:	5b                   	pop    %ebx
  800e34:	5e                   	pop    %esi
  800e35:	5f                   	pop    %edi
  800e36:	5d                   	pop    %ebp
  800e37:	c3                   	ret    

00800e38 <sys_yield>:

void
sys_yield(void)
{
  800e38:	55                   	push   %ebp
  800e39:	89 e5                	mov    %esp,%ebp
  800e3b:	57                   	push   %edi
  800e3c:	56                   	push   %esi
  800e3d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e3e:	ba 00 00 00 00       	mov    $0x0,%edx
  800e43:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e48:	89 d1                	mov    %edx,%ecx
  800e4a:	89 d3                	mov    %edx,%ebx
  800e4c:	89 d7                	mov    %edx,%edi
  800e4e:	89 d6                	mov    %edx,%esi
  800e50:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e52:	5b                   	pop    %ebx
  800e53:	5e                   	pop    %esi
  800e54:	5f                   	pop    %edi
  800e55:	5d                   	pop    %ebp
  800e56:	c3                   	ret    

00800e57 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e57:	55                   	push   %ebp
  800e58:	89 e5                	mov    %esp,%ebp
  800e5a:	57                   	push   %edi
  800e5b:	56                   	push   %esi
  800e5c:	53                   	push   %ebx
  800e5d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e60:	be 00 00 00 00       	mov    $0x0,%esi
  800e65:	8b 55 08             	mov    0x8(%ebp),%edx
  800e68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6b:	b8 04 00 00 00       	mov    $0x4,%eax
  800e70:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e73:	89 f7                	mov    %esi,%edi
  800e75:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e77:	85 c0                	test   %eax,%eax
  800e79:	7f 08                	jg     800e83 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7e:	5b                   	pop    %ebx
  800e7f:	5e                   	pop    %esi
  800e80:	5f                   	pop    %edi
  800e81:	5d                   	pop    %ebp
  800e82:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e83:	83 ec 0c             	sub    $0xc,%esp
  800e86:	50                   	push   %eax
  800e87:	6a 04                	push   $0x4
  800e89:	68 e8 2b 80 00       	push   $0x802be8
  800e8e:	6a 43                	push   $0x43
  800e90:	68 05 2c 80 00       	push   $0x802c05
  800e95:	e8 76 f3 ff ff       	call   800210 <_panic>

00800e9a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e9a:	55                   	push   %ebp
  800e9b:	89 e5                	mov    %esp,%ebp
  800e9d:	57                   	push   %edi
  800e9e:	56                   	push   %esi
  800e9f:	53                   	push   %ebx
  800ea0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea9:	b8 05 00 00 00       	mov    $0x5,%eax
  800eae:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eb1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eb4:	8b 75 18             	mov    0x18(%ebp),%esi
  800eb7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	7f 08                	jg     800ec5 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ebd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec0:	5b                   	pop    %ebx
  800ec1:	5e                   	pop    %esi
  800ec2:	5f                   	pop    %edi
  800ec3:	5d                   	pop    %ebp
  800ec4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec5:	83 ec 0c             	sub    $0xc,%esp
  800ec8:	50                   	push   %eax
  800ec9:	6a 05                	push   $0x5
  800ecb:	68 e8 2b 80 00       	push   $0x802be8
  800ed0:	6a 43                	push   $0x43
  800ed2:	68 05 2c 80 00       	push   $0x802c05
  800ed7:	e8 34 f3 ff ff       	call   800210 <_panic>

00800edc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	57                   	push   %edi
  800ee0:	56                   	push   %esi
  800ee1:	53                   	push   %ebx
  800ee2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eea:	8b 55 08             	mov    0x8(%ebp),%edx
  800eed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef0:	b8 06 00 00 00       	mov    $0x6,%eax
  800ef5:	89 df                	mov    %ebx,%edi
  800ef7:	89 de                	mov    %ebx,%esi
  800ef9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800efb:	85 c0                	test   %eax,%eax
  800efd:	7f 08                	jg     800f07 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800eff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f02:	5b                   	pop    %ebx
  800f03:	5e                   	pop    %esi
  800f04:	5f                   	pop    %edi
  800f05:	5d                   	pop    %ebp
  800f06:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f07:	83 ec 0c             	sub    $0xc,%esp
  800f0a:	50                   	push   %eax
  800f0b:	6a 06                	push   $0x6
  800f0d:	68 e8 2b 80 00       	push   $0x802be8
  800f12:	6a 43                	push   $0x43
  800f14:	68 05 2c 80 00       	push   $0x802c05
  800f19:	e8 f2 f2 ff ff       	call   800210 <_panic>

00800f1e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f1e:	55                   	push   %ebp
  800f1f:	89 e5                	mov    %esp,%ebp
  800f21:	57                   	push   %edi
  800f22:	56                   	push   %esi
  800f23:	53                   	push   %ebx
  800f24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f27:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f32:	b8 08 00 00 00       	mov    $0x8,%eax
  800f37:	89 df                	mov    %ebx,%edi
  800f39:	89 de                	mov    %ebx,%esi
  800f3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f3d:	85 c0                	test   %eax,%eax
  800f3f:	7f 08                	jg     800f49 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f44:	5b                   	pop    %ebx
  800f45:	5e                   	pop    %esi
  800f46:	5f                   	pop    %edi
  800f47:	5d                   	pop    %ebp
  800f48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f49:	83 ec 0c             	sub    $0xc,%esp
  800f4c:	50                   	push   %eax
  800f4d:	6a 08                	push   $0x8
  800f4f:	68 e8 2b 80 00       	push   $0x802be8
  800f54:	6a 43                	push   $0x43
  800f56:	68 05 2c 80 00       	push   $0x802c05
  800f5b:	e8 b0 f2 ff ff       	call   800210 <_panic>

00800f60 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	57                   	push   %edi
  800f64:	56                   	push   %esi
  800f65:	53                   	push   %ebx
  800f66:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f69:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f74:	b8 09 00 00 00       	mov    $0x9,%eax
  800f79:	89 df                	mov    %ebx,%edi
  800f7b:	89 de                	mov    %ebx,%esi
  800f7d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f7f:	85 c0                	test   %eax,%eax
  800f81:	7f 08                	jg     800f8b <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f86:	5b                   	pop    %ebx
  800f87:	5e                   	pop    %esi
  800f88:	5f                   	pop    %edi
  800f89:	5d                   	pop    %ebp
  800f8a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8b:	83 ec 0c             	sub    $0xc,%esp
  800f8e:	50                   	push   %eax
  800f8f:	6a 09                	push   $0x9
  800f91:	68 e8 2b 80 00       	push   $0x802be8
  800f96:	6a 43                	push   $0x43
  800f98:	68 05 2c 80 00       	push   $0x802c05
  800f9d:	e8 6e f2 ff ff       	call   800210 <_panic>

00800fa2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
  800fa5:	57                   	push   %edi
  800fa6:	56                   	push   %esi
  800fa7:	53                   	push   %ebx
  800fa8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fbb:	89 df                	mov    %ebx,%edi
  800fbd:	89 de                	mov    %ebx,%esi
  800fbf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc1:	85 c0                	test   %eax,%eax
  800fc3:	7f 08                	jg     800fcd <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fc8:	5b                   	pop    %ebx
  800fc9:	5e                   	pop    %esi
  800fca:	5f                   	pop    %edi
  800fcb:	5d                   	pop    %ebp
  800fcc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fcd:	83 ec 0c             	sub    $0xc,%esp
  800fd0:	50                   	push   %eax
  800fd1:	6a 0a                	push   $0xa
  800fd3:	68 e8 2b 80 00       	push   $0x802be8
  800fd8:	6a 43                	push   $0x43
  800fda:	68 05 2c 80 00       	push   $0x802c05
  800fdf:	e8 2c f2 ff ff       	call   800210 <_panic>

00800fe4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
  800fe7:	57                   	push   %edi
  800fe8:	56                   	push   %esi
  800fe9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fea:	8b 55 08             	mov    0x8(%ebp),%edx
  800fed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff0:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ff5:	be 00 00 00 00       	mov    $0x0,%esi
  800ffa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ffd:	8b 7d 14             	mov    0x14(%ebp),%edi
  801000:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801002:	5b                   	pop    %ebx
  801003:	5e                   	pop    %esi
  801004:	5f                   	pop    %edi
  801005:	5d                   	pop    %ebp
  801006:	c3                   	ret    

00801007 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	57                   	push   %edi
  80100b:	56                   	push   %esi
  80100c:	53                   	push   %ebx
  80100d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801010:	b9 00 00 00 00       	mov    $0x0,%ecx
  801015:	8b 55 08             	mov    0x8(%ebp),%edx
  801018:	b8 0d 00 00 00       	mov    $0xd,%eax
  80101d:	89 cb                	mov    %ecx,%ebx
  80101f:	89 cf                	mov    %ecx,%edi
  801021:	89 ce                	mov    %ecx,%esi
  801023:	cd 30                	int    $0x30
	if(check && ret > 0)
  801025:	85 c0                	test   %eax,%eax
  801027:	7f 08                	jg     801031 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801029:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80102c:	5b                   	pop    %ebx
  80102d:	5e                   	pop    %esi
  80102e:	5f                   	pop    %edi
  80102f:	5d                   	pop    %ebp
  801030:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801031:	83 ec 0c             	sub    $0xc,%esp
  801034:	50                   	push   %eax
  801035:	6a 0d                	push   $0xd
  801037:	68 e8 2b 80 00       	push   $0x802be8
  80103c:	6a 43                	push   $0x43
  80103e:	68 05 2c 80 00       	push   $0x802c05
  801043:	e8 c8 f1 ff ff       	call   800210 <_panic>

00801048 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801048:	55                   	push   %ebp
  801049:	89 e5                	mov    %esp,%ebp
  80104b:	57                   	push   %edi
  80104c:	56                   	push   %esi
  80104d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80104e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801053:	8b 55 08             	mov    0x8(%ebp),%edx
  801056:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801059:	b8 0e 00 00 00       	mov    $0xe,%eax
  80105e:	89 df                	mov    %ebx,%edi
  801060:	89 de                	mov    %ebx,%esi
  801062:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801064:	5b                   	pop    %ebx
  801065:	5e                   	pop    %esi
  801066:	5f                   	pop    %edi
  801067:	5d                   	pop    %ebp
  801068:	c3                   	ret    

00801069 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801069:	55                   	push   %ebp
  80106a:	89 e5                	mov    %esp,%ebp
  80106c:	57                   	push   %edi
  80106d:	56                   	push   %esi
  80106e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80106f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801074:	8b 55 08             	mov    0x8(%ebp),%edx
  801077:	b8 0f 00 00 00       	mov    $0xf,%eax
  80107c:	89 cb                	mov    %ecx,%ebx
  80107e:	89 cf                	mov    %ecx,%edi
  801080:	89 ce                	mov    %ecx,%esi
  801082:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801084:	5b                   	pop    %ebx
  801085:	5e                   	pop    %esi
  801086:	5f                   	pop    %edi
  801087:	5d                   	pop    %ebp
  801088:	c3                   	ret    

00801089 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801089:	55                   	push   %ebp
  80108a:	89 e5                	mov    %esp,%ebp
  80108c:	57                   	push   %edi
  80108d:	56                   	push   %esi
  80108e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80108f:	ba 00 00 00 00       	mov    $0x0,%edx
  801094:	b8 10 00 00 00       	mov    $0x10,%eax
  801099:	89 d1                	mov    %edx,%ecx
  80109b:	89 d3                	mov    %edx,%ebx
  80109d:	89 d7                	mov    %edx,%edi
  80109f:	89 d6                	mov    %edx,%esi
  8010a1:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010a3:	5b                   	pop    %ebx
  8010a4:	5e                   	pop    %esi
  8010a5:	5f                   	pop    %edi
  8010a6:	5d                   	pop    %ebp
  8010a7:	c3                   	ret    

008010a8 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8010a8:	55                   	push   %ebp
  8010a9:	89 e5                	mov    %esp,%ebp
  8010ab:	57                   	push   %edi
  8010ac:	56                   	push   %esi
  8010ad:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b9:	b8 11 00 00 00       	mov    $0x11,%eax
  8010be:	89 df                	mov    %ebx,%edi
  8010c0:	89 de                	mov    %ebx,%esi
  8010c2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010c4:	5b                   	pop    %ebx
  8010c5:	5e                   	pop    %esi
  8010c6:	5f                   	pop    %edi
  8010c7:	5d                   	pop    %ebp
  8010c8:	c3                   	ret    

008010c9 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8010c9:	55                   	push   %ebp
  8010ca:	89 e5                	mov    %esp,%ebp
  8010cc:	57                   	push   %edi
  8010cd:	56                   	push   %esi
  8010ce:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010cf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010da:	b8 12 00 00 00       	mov    $0x12,%eax
  8010df:	89 df                	mov    %ebx,%edi
  8010e1:	89 de                	mov    %ebx,%esi
  8010e3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010e5:	5b                   	pop    %ebx
  8010e6:	5e                   	pop    %esi
  8010e7:	5f                   	pop    %edi
  8010e8:	5d                   	pop    %ebp
  8010e9:	c3                   	ret    

008010ea <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8010ea:	55                   	push   %ebp
  8010eb:	89 e5                	mov    %esp,%ebp
  8010ed:	57                   	push   %edi
  8010ee:	56                   	push   %esi
  8010ef:	53                   	push   %ebx
  8010f0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010fe:	b8 13 00 00 00       	mov    $0x13,%eax
  801103:	89 df                	mov    %ebx,%edi
  801105:	89 de                	mov    %ebx,%esi
  801107:	cd 30                	int    $0x30
	if(check && ret > 0)
  801109:	85 c0                	test   %eax,%eax
  80110b:	7f 08                	jg     801115 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80110d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801110:	5b                   	pop    %ebx
  801111:	5e                   	pop    %esi
  801112:	5f                   	pop    %edi
  801113:	5d                   	pop    %ebp
  801114:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801115:	83 ec 0c             	sub    $0xc,%esp
  801118:	50                   	push   %eax
  801119:	6a 13                	push   $0x13
  80111b:	68 e8 2b 80 00       	push   $0x802be8
  801120:	6a 43                	push   $0x43
  801122:	68 05 2c 80 00       	push   $0x802c05
  801127:	e8 e4 f0 ff ff       	call   800210 <_panic>

0080112c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80112c:	55                   	push   %ebp
  80112d:	89 e5                	mov    %esp,%ebp
  80112f:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801132:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  801139:	74 0a                	je     801145 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  801143:	c9                   	leave  
  801144:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  801145:	83 ec 04             	sub    $0x4,%esp
  801148:	6a 07                	push   $0x7
  80114a:	68 00 f0 bf ee       	push   $0xeebff000
  80114f:	6a 00                	push   $0x0
  801151:	e8 01 fd ff ff       	call   800e57 <sys_page_alloc>
		if(r < 0)
  801156:	83 c4 10             	add    $0x10,%esp
  801159:	85 c0                	test   %eax,%eax
  80115b:	78 2a                	js     801187 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80115d:	83 ec 08             	sub    $0x8,%esp
  801160:	68 9b 11 80 00       	push   $0x80119b
  801165:	6a 00                	push   $0x0
  801167:	e8 36 fe ff ff       	call   800fa2 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80116c:	83 c4 10             	add    $0x10,%esp
  80116f:	85 c0                	test   %eax,%eax
  801171:	79 c8                	jns    80113b <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  801173:	83 ec 04             	sub    $0x4,%esp
  801176:	68 44 2c 80 00       	push   $0x802c44
  80117b:	6a 25                	push   $0x25
  80117d:	68 7d 2c 80 00       	push   $0x802c7d
  801182:	e8 89 f0 ff ff       	call   800210 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  801187:	83 ec 04             	sub    $0x4,%esp
  80118a:	68 14 2c 80 00       	push   $0x802c14
  80118f:	6a 22                	push   $0x22
  801191:	68 7d 2c 80 00       	push   $0x802c7d
  801196:	e8 75 f0 ff ff       	call   800210 <_panic>

0080119b <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80119b:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80119c:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  8011a1:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8011a3:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8011a6:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8011aa:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8011ae:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8011b1:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8011b3:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8011b7:	83 c4 08             	add    $0x8,%esp
	popal
  8011ba:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8011bb:	83 c4 04             	add    $0x4,%esp
	popfl
  8011be:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8011bf:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8011c0:	c3                   	ret    

008011c1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011c1:	55                   	push   %ebp
  8011c2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	05 00 00 00 30       	add    $0x30000000,%eax
  8011cc:	c1 e8 0c             	shr    $0xc,%eax
}
  8011cf:	5d                   	pop    %ebp
  8011d0:	c3                   	ret    

008011d1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011d1:	55                   	push   %ebp
  8011d2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d7:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011dc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011e1:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011e6:	5d                   	pop    %ebp
  8011e7:	c3                   	ret    

008011e8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
  8011eb:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011f0:	89 c2                	mov    %eax,%edx
  8011f2:	c1 ea 16             	shr    $0x16,%edx
  8011f5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011fc:	f6 c2 01             	test   $0x1,%dl
  8011ff:	74 2d                	je     80122e <fd_alloc+0x46>
  801201:	89 c2                	mov    %eax,%edx
  801203:	c1 ea 0c             	shr    $0xc,%edx
  801206:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80120d:	f6 c2 01             	test   $0x1,%dl
  801210:	74 1c                	je     80122e <fd_alloc+0x46>
  801212:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801217:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80121c:	75 d2                	jne    8011f0 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801227:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80122c:	eb 0a                	jmp    801238 <fd_alloc+0x50>
			*fd_store = fd;
  80122e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801231:	89 01                	mov    %eax,(%ecx)
			return 0;
  801233:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801238:	5d                   	pop    %ebp
  801239:	c3                   	ret    

0080123a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80123a:	55                   	push   %ebp
  80123b:	89 e5                	mov    %esp,%ebp
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801240:	83 f8 1f             	cmp    $0x1f,%eax
  801243:	77 30                	ja     801275 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801245:	c1 e0 0c             	shl    $0xc,%eax
  801248:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80124d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801253:	f6 c2 01             	test   $0x1,%dl
  801256:	74 24                	je     80127c <fd_lookup+0x42>
  801258:	89 c2                	mov    %eax,%edx
  80125a:	c1 ea 0c             	shr    $0xc,%edx
  80125d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801264:	f6 c2 01             	test   $0x1,%dl
  801267:	74 1a                	je     801283 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801269:	8b 55 0c             	mov    0xc(%ebp),%edx
  80126c:	89 02                	mov    %eax,(%edx)
	return 0;
  80126e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801273:	5d                   	pop    %ebp
  801274:	c3                   	ret    
		return -E_INVAL;
  801275:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80127a:	eb f7                	jmp    801273 <fd_lookup+0x39>
		return -E_INVAL;
  80127c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801281:	eb f0                	jmp    801273 <fd_lookup+0x39>
  801283:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801288:	eb e9                	jmp    801273 <fd_lookup+0x39>

0080128a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
  80128d:	83 ec 08             	sub    $0x8,%esp
  801290:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801293:	ba 00 00 00 00       	mov    $0x0,%edx
  801298:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80129d:	39 08                	cmp    %ecx,(%eax)
  80129f:	74 38                	je     8012d9 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8012a1:	83 c2 01             	add    $0x1,%edx
  8012a4:	8b 04 95 0c 2d 80 00 	mov    0x802d0c(,%edx,4),%eax
  8012ab:	85 c0                	test   %eax,%eax
  8012ad:	75 ee                	jne    80129d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012af:	a1 08 40 80 00       	mov    0x804008,%eax
  8012b4:	8b 40 48             	mov    0x48(%eax),%eax
  8012b7:	83 ec 04             	sub    $0x4,%esp
  8012ba:	51                   	push   %ecx
  8012bb:	50                   	push   %eax
  8012bc:	68 8c 2c 80 00       	push   $0x802c8c
  8012c1:	e8 40 f0 ff ff       	call   800306 <cprintf>
	*dev = 0;
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012cf:	83 c4 10             	add    $0x10,%esp
  8012d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012d7:	c9                   	leave  
  8012d8:	c3                   	ret    
			*dev = devtab[i];
  8012d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012dc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012de:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e3:	eb f2                	jmp    8012d7 <dev_lookup+0x4d>

008012e5 <fd_close>:
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
  8012e8:	57                   	push   %edi
  8012e9:	56                   	push   %esi
  8012ea:	53                   	push   %ebx
  8012eb:	83 ec 24             	sub    $0x24,%esp
  8012ee:	8b 75 08             	mov    0x8(%ebp),%esi
  8012f1:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012f4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012f7:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012f8:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012fe:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801301:	50                   	push   %eax
  801302:	e8 33 ff ff ff       	call   80123a <fd_lookup>
  801307:	89 c3                	mov    %eax,%ebx
  801309:	83 c4 10             	add    $0x10,%esp
  80130c:	85 c0                	test   %eax,%eax
  80130e:	78 05                	js     801315 <fd_close+0x30>
	    || fd != fd2)
  801310:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801313:	74 16                	je     80132b <fd_close+0x46>
		return (must_exist ? r : 0);
  801315:	89 f8                	mov    %edi,%eax
  801317:	84 c0                	test   %al,%al
  801319:	b8 00 00 00 00       	mov    $0x0,%eax
  80131e:	0f 44 d8             	cmove  %eax,%ebx
}
  801321:	89 d8                	mov    %ebx,%eax
  801323:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801326:	5b                   	pop    %ebx
  801327:	5e                   	pop    %esi
  801328:	5f                   	pop    %edi
  801329:	5d                   	pop    %ebp
  80132a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80132b:	83 ec 08             	sub    $0x8,%esp
  80132e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801331:	50                   	push   %eax
  801332:	ff 36                	pushl  (%esi)
  801334:	e8 51 ff ff ff       	call   80128a <dev_lookup>
  801339:	89 c3                	mov    %eax,%ebx
  80133b:	83 c4 10             	add    $0x10,%esp
  80133e:	85 c0                	test   %eax,%eax
  801340:	78 1a                	js     80135c <fd_close+0x77>
		if (dev->dev_close)
  801342:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801345:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801348:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80134d:	85 c0                	test   %eax,%eax
  80134f:	74 0b                	je     80135c <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801351:	83 ec 0c             	sub    $0xc,%esp
  801354:	56                   	push   %esi
  801355:	ff d0                	call   *%eax
  801357:	89 c3                	mov    %eax,%ebx
  801359:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80135c:	83 ec 08             	sub    $0x8,%esp
  80135f:	56                   	push   %esi
  801360:	6a 00                	push   $0x0
  801362:	e8 75 fb ff ff       	call   800edc <sys_page_unmap>
	return r;
  801367:	83 c4 10             	add    $0x10,%esp
  80136a:	eb b5                	jmp    801321 <fd_close+0x3c>

0080136c <close>:

int
close(int fdnum)
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801372:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801375:	50                   	push   %eax
  801376:	ff 75 08             	pushl  0x8(%ebp)
  801379:	e8 bc fe ff ff       	call   80123a <fd_lookup>
  80137e:	83 c4 10             	add    $0x10,%esp
  801381:	85 c0                	test   %eax,%eax
  801383:	79 02                	jns    801387 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801385:	c9                   	leave  
  801386:	c3                   	ret    
		return fd_close(fd, 1);
  801387:	83 ec 08             	sub    $0x8,%esp
  80138a:	6a 01                	push   $0x1
  80138c:	ff 75 f4             	pushl  -0xc(%ebp)
  80138f:	e8 51 ff ff ff       	call   8012e5 <fd_close>
  801394:	83 c4 10             	add    $0x10,%esp
  801397:	eb ec                	jmp    801385 <close+0x19>

00801399 <close_all>:

void
close_all(void)
{
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
  80139c:	53                   	push   %ebx
  80139d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013a0:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013a5:	83 ec 0c             	sub    $0xc,%esp
  8013a8:	53                   	push   %ebx
  8013a9:	e8 be ff ff ff       	call   80136c <close>
	for (i = 0; i < MAXFD; i++)
  8013ae:	83 c3 01             	add    $0x1,%ebx
  8013b1:	83 c4 10             	add    $0x10,%esp
  8013b4:	83 fb 20             	cmp    $0x20,%ebx
  8013b7:	75 ec                	jne    8013a5 <close_all+0xc>
}
  8013b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013bc:	c9                   	leave  
  8013bd:	c3                   	ret    

008013be <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
  8013c1:	57                   	push   %edi
  8013c2:	56                   	push   %esi
  8013c3:	53                   	push   %ebx
  8013c4:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013c7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013ca:	50                   	push   %eax
  8013cb:	ff 75 08             	pushl  0x8(%ebp)
  8013ce:	e8 67 fe ff ff       	call   80123a <fd_lookup>
  8013d3:	89 c3                	mov    %eax,%ebx
  8013d5:	83 c4 10             	add    $0x10,%esp
  8013d8:	85 c0                	test   %eax,%eax
  8013da:	0f 88 81 00 00 00    	js     801461 <dup+0xa3>
		return r;
	close(newfdnum);
  8013e0:	83 ec 0c             	sub    $0xc,%esp
  8013e3:	ff 75 0c             	pushl  0xc(%ebp)
  8013e6:	e8 81 ff ff ff       	call   80136c <close>

	newfd = INDEX2FD(newfdnum);
  8013eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013ee:	c1 e6 0c             	shl    $0xc,%esi
  8013f1:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013f7:	83 c4 04             	add    $0x4,%esp
  8013fa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013fd:	e8 cf fd ff ff       	call   8011d1 <fd2data>
  801402:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801404:	89 34 24             	mov    %esi,(%esp)
  801407:	e8 c5 fd ff ff       	call   8011d1 <fd2data>
  80140c:	83 c4 10             	add    $0x10,%esp
  80140f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801411:	89 d8                	mov    %ebx,%eax
  801413:	c1 e8 16             	shr    $0x16,%eax
  801416:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80141d:	a8 01                	test   $0x1,%al
  80141f:	74 11                	je     801432 <dup+0x74>
  801421:	89 d8                	mov    %ebx,%eax
  801423:	c1 e8 0c             	shr    $0xc,%eax
  801426:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80142d:	f6 c2 01             	test   $0x1,%dl
  801430:	75 39                	jne    80146b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801432:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801435:	89 d0                	mov    %edx,%eax
  801437:	c1 e8 0c             	shr    $0xc,%eax
  80143a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801441:	83 ec 0c             	sub    $0xc,%esp
  801444:	25 07 0e 00 00       	and    $0xe07,%eax
  801449:	50                   	push   %eax
  80144a:	56                   	push   %esi
  80144b:	6a 00                	push   $0x0
  80144d:	52                   	push   %edx
  80144e:	6a 00                	push   $0x0
  801450:	e8 45 fa ff ff       	call   800e9a <sys_page_map>
  801455:	89 c3                	mov    %eax,%ebx
  801457:	83 c4 20             	add    $0x20,%esp
  80145a:	85 c0                	test   %eax,%eax
  80145c:	78 31                	js     80148f <dup+0xd1>
		goto err;

	return newfdnum;
  80145e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801461:	89 d8                	mov    %ebx,%eax
  801463:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801466:	5b                   	pop    %ebx
  801467:	5e                   	pop    %esi
  801468:	5f                   	pop    %edi
  801469:	5d                   	pop    %ebp
  80146a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80146b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801472:	83 ec 0c             	sub    $0xc,%esp
  801475:	25 07 0e 00 00       	and    $0xe07,%eax
  80147a:	50                   	push   %eax
  80147b:	57                   	push   %edi
  80147c:	6a 00                	push   $0x0
  80147e:	53                   	push   %ebx
  80147f:	6a 00                	push   $0x0
  801481:	e8 14 fa ff ff       	call   800e9a <sys_page_map>
  801486:	89 c3                	mov    %eax,%ebx
  801488:	83 c4 20             	add    $0x20,%esp
  80148b:	85 c0                	test   %eax,%eax
  80148d:	79 a3                	jns    801432 <dup+0x74>
	sys_page_unmap(0, newfd);
  80148f:	83 ec 08             	sub    $0x8,%esp
  801492:	56                   	push   %esi
  801493:	6a 00                	push   $0x0
  801495:	e8 42 fa ff ff       	call   800edc <sys_page_unmap>
	sys_page_unmap(0, nva);
  80149a:	83 c4 08             	add    $0x8,%esp
  80149d:	57                   	push   %edi
  80149e:	6a 00                	push   $0x0
  8014a0:	e8 37 fa ff ff       	call   800edc <sys_page_unmap>
	return r;
  8014a5:	83 c4 10             	add    $0x10,%esp
  8014a8:	eb b7                	jmp    801461 <dup+0xa3>

008014aa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
  8014ad:	53                   	push   %ebx
  8014ae:	83 ec 1c             	sub    $0x1c,%esp
  8014b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014b7:	50                   	push   %eax
  8014b8:	53                   	push   %ebx
  8014b9:	e8 7c fd ff ff       	call   80123a <fd_lookup>
  8014be:	83 c4 10             	add    $0x10,%esp
  8014c1:	85 c0                	test   %eax,%eax
  8014c3:	78 3f                	js     801504 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014c5:	83 ec 08             	sub    $0x8,%esp
  8014c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014cb:	50                   	push   %eax
  8014cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014cf:	ff 30                	pushl  (%eax)
  8014d1:	e8 b4 fd ff ff       	call   80128a <dev_lookup>
  8014d6:	83 c4 10             	add    $0x10,%esp
  8014d9:	85 c0                	test   %eax,%eax
  8014db:	78 27                	js     801504 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014e0:	8b 42 08             	mov    0x8(%edx),%eax
  8014e3:	83 e0 03             	and    $0x3,%eax
  8014e6:	83 f8 01             	cmp    $0x1,%eax
  8014e9:	74 1e                	je     801509 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ee:	8b 40 08             	mov    0x8(%eax),%eax
  8014f1:	85 c0                	test   %eax,%eax
  8014f3:	74 35                	je     80152a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014f5:	83 ec 04             	sub    $0x4,%esp
  8014f8:	ff 75 10             	pushl  0x10(%ebp)
  8014fb:	ff 75 0c             	pushl  0xc(%ebp)
  8014fe:	52                   	push   %edx
  8014ff:	ff d0                	call   *%eax
  801501:	83 c4 10             	add    $0x10,%esp
}
  801504:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801507:	c9                   	leave  
  801508:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801509:	a1 08 40 80 00       	mov    0x804008,%eax
  80150e:	8b 40 48             	mov    0x48(%eax),%eax
  801511:	83 ec 04             	sub    $0x4,%esp
  801514:	53                   	push   %ebx
  801515:	50                   	push   %eax
  801516:	68 d0 2c 80 00       	push   $0x802cd0
  80151b:	e8 e6 ed ff ff       	call   800306 <cprintf>
		return -E_INVAL;
  801520:	83 c4 10             	add    $0x10,%esp
  801523:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801528:	eb da                	jmp    801504 <read+0x5a>
		return -E_NOT_SUPP;
  80152a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80152f:	eb d3                	jmp    801504 <read+0x5a>

00801531 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801531:	55                   	push   %ebp
  801532:	89 e5                	mov    %esp,%ebp
  801534:	57                   	push   %edi
  801535:	56                   	push   %esi
  801536:	53                   	push   %ebx
  801537:	83 ec 0c             	sub    $0xc,%esp
  80153a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80153d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801540:	bb 00 00 00 00       	mov    $0x0,%ebx
  801545:	39 f3                	cmp    %esi,%ebx
  801547:	73 23                	jae    80156c <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801549:	83 ec 04             	sub    $0x4,%esp
  80154c:	89 f0                	mov    %esi,%eax
  80154e:	29 d8                	sub    %ebx,%eax
  801550:	50                   	push   %eax
  801551:	89 d8                	mov    %ebx,%eax
  801553:	03 45 0c             	add    0xc(%ebp),%eax
  801556:	50                   	push   %eax
  801557:	57                   	push   %edi
  801558:	e8 4d ff ff ff       	call   8014aa <read>
		if (m < 0)
  80155d:	83 c4 10             	add    $0x10,%esp
  801560:	85 c0                	test   %eax,%eax
  801562:	78 06                	js     80156a <readn+0x39>
			return m;
		if (m == 0)
  801564:	74 06                	je     80156c <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801566:	01 c3                	add    %eax,%ebx
  801568:	eb db                	jmp    801545 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80156a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80156c:	89 d8                	mov    %ebx,%eax
  80156e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801571:	5b                   	pop    %ebx
  801572:	5e                   	pop    %esi
  801573:	5f                   	pop    %edi
  801574:	5d                   	pop    %ebp
  801575:	c3                   	ret    

00801576 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
  801579:	53                   	push   %ebx
  80157a:	83 ec 1c             	sub    $0x1c,%esp
  80157d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801580:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801583:	50                   	push   %eax
  801584:	53                   	push   %ebx
  801585:	e8 b0 fc ff ff       	call   80123a <fd_lookup>
  80158a:	83 c4 10             	add    $0x10,%esp
  80158d:	85 c0                	test   %eax,%eax
  80158f:	78 3a                	js     8015cb <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801591:	83 ec 08             	sub    $0x8,%esp
  801594:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801597:	50                   	push   %eax
  801598:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159b:	ff 30                	pushl  (%eax)
  80159d:	e8 e8 fc ff ff       	call   80128a <dev_lookup>
  8015a2:	83 c4 10             	add    $0x10,%esp
  8015a5:	85 c0                	test   %eax,%eax
  8015a7:	78 22                	js     8015cb <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ac:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015b0:	74 1e                	je     8015d0 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b5:	8b 52 0c             	mov    0xc(%edx),%edx
  8015b8:	85 d2                	test   %edx,%edx
  8015ba:	74 35                	je     8015f1 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015bc:	83 ec 04             	sub    $0x4,%esp
  8015bf:	ff 75 10             	pushl  0x10(%ebp)
  8015c2:	ff 75 0c             	pushl  0xc(%ebp)
  8015c5:	50                   	push   %eax
  8015c6:	ff d2                	call   *%edx
  8015c8:	83 c4 10             	add    $0x10,%esp
}
  8015cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ce:	c9                   	leave  
  8015cf:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015d0:	a1 08 40 80 00       	mov    0x804008,%eax
  8015d5:	8b 40 48             	mov    0x48(%eax),%eax
  8015d8:	83 ec 04             	sub    $0x4,%esp
  8015db:	53                   	push   %ebx
  8015dc:	50                   	push   %eax
  8015dd:	68 ec 2c 80 00       	push   $0x802cec
  8015e2:	e8 1f ed ff ff       	call   800306 <cprintf>
		return -E_INVAL;
  8015e7:	83 c4 10             	add    $0x10,%esp
  8015ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ef:	eb da                	jmp    8015cb <write+0x55>
		return -E_NOT_SUPP;
  8015f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015f6:	eb d3                	jmp    8015cb <write+0x55>

008015f8 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
  8015fb:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801601:	50                   	push   %eax
  801602:	ff 75 08             	pushl  0x8(%ebp)
  801605:	e8 30 fc ff ff       	call   80123a <fd_lookup>
  80160a:	83 c4 10             	add    $0x10,%esp
  80160d:	85 c0                	test   %eax,%eax
  80160f:	78 0e                	js     80161f <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801611:	8b 55 0c             	mov    0xc(%ebp),%edx
  801614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801617:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80161a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80161f:	c9                   	leave  
  801620:	c3                   	ret    

00801621 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	53                   	push   %ebx
  801625:	83 ec 1c             	sub    $0x1c,%esp
  801628:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80162b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80162e:	50                   	push   %eax
  80162f:	53                   	push   %ebx
  801630:	e8 05 fc ff ff       	call   80123a <fd_lookup>
  801635:	83 c4 10             	add    $0x10,%esp
  801638:	85 c0                	test   %eax,%eax
  80163a:	78 37                	js     801673 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80163c:	83 ec 08             	sub    $0x8,%esp
  80163f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801642:	50                   	push   %eax
  801643:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801646:	ff 30                	pushl  (%eax)
  801648:	e8 3d fc ff ff       	call   80128a <dev_lookup>
  80164d:	83 c4 10             	add    $0x10,%esp
  801650:	85 c0                	test   %eax,%eax
  801652:	78 1f                	js     801673 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801657:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80165b:	74 1b                	je     801678 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80165d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801660:	8b 52 18             	mov    0x18(%edx),%edx
  801663:	85 d2                	test   %edx,%edx
  801665:	74 32                	je     801699 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801667:	83 ec 08             	sub    $0x8,%esp
  80166a:	ff 75 0c             	pushl  0xc(%ebp)
  80166d:	50                   	push   %eax
  80166e:	ff d2                	call   *%edx
  801670:	83 c4 10             	add    $0x10,%esp
}
  801673:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801676:	c9                   	leave  
  801677:	c3                   	ret    
			thisenv->env_id, fdnum);
  801678:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80167d:	8b 40 48             	mov    0x48(%eax),%eax
  801680:	83 ec 04             	sub    $0x4,%esp
  801683:	53                   	push   %ebx
  801684:	50                   	push   %eax
  801685:	68 ac 2c 80 00       	push   $0x802cac
  80168a:	e8 77 ec ff ff       	call   800306 <cprintf>
		return -E_INVAL;
  80168f:	83 c4 10             	add    $0x10,%esp
  801692:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801697:	eb da                	jmp    801673 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801699:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80169e:	eb d3                	jmp    801673 <ftruncate+0x52>

008016a0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	53                   	push   %ebx
  8016a4:	83 ec 1c             	sub    $0x1c,%esp
  8016a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016ad:	50                   	push   %eax
  8016ae:	ff 75 08             	pushl  0x8(%ebp)
  8016b1:	e8 84 fb ff ff       	call   80123a <fd_lookup>
  8016b6:	83 c4 10             	add    $0x10,%esp
  8016b9:	85 c0                	test   %eax,%eax
  8016bb:	78 4b                	js     801708 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016bd:	83 ec 08             	sub    $0x8,%esp
  8016c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016c3:	50                   	push   %eax
  8016c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c7:	ff 30                	pushl  (%eax)
  8016c9:	e8 bc fb ff ff       	call   80128a <dev_lookup>
  8016ce:	83 c4 10             	add    $0x10,%esp
  8016d1:	85 c0                	test   %eax,%eax
  8016d3:	78 33                	js     801708 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8016d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d8:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016dc:	74 2f                	je     80170d <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016de:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016e1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016e8:	00 00 00 
	stat->st_isdir = 0;
  8016eb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016f2:	00 00 00 
	stat->st_dev = dev;
  8016f5:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016fb:	83 ec 08             	sub    $0x8,%esp
  8016fe:	53                   	push   %ebx
  8016ff:	ff 75 f0             	pushl  -0x10(%ebp)
  801702:	ff 50 14             	call   *0x14(%eax)
  801705:	83 c4 10             	add    $0x10,%esp
}
  801708:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    
		return -E_NOT_SUPP;
  80170d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801712:	eb f4                	jmp    801708 <fstat+0x68>

00801714 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
  801717:	56                   	push   %esi
  801718:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801719:	83 ec 08             	sub    $0x8,%esp
  80171c:	6a 00                	push   $0x0
  80171e:	ff 75 08             	pushl  0x8(%ebp)
  801721:	e8 22 02 00 00       	call   801948 <open>
  801726:	89 c3                	mov    %eax,%ebx
  801728:	83 c4 10             	add    $0x10,%esp
  80172b:	85 c0                	test   %eax,%eax
  80172d:	78 1b                	js     80174a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80172f:	83 ec 08             	sub    $0x8,%esp
  801732:	ff 75 0c             	pushl  0xc(%ebp)
  801735:	50                   	push   %eax
  801736:	e8 65 ff ff ff       	call   8016a0 <fstat>
  80173b:	89 c6                	mov    %eax,%esi
	close(fd);
  80173d:	89 1c 24             	mov    %ebx,(%esp)
  801740:	e8 27 fc ff ff       	call   80136c <close>
	return r;
  801745:	83 c4 10             	add    $0x10,%esp
  801748:	89 f3                	mov    %esi,%ebx
}
  80174a:	89 d8                	mov    %ebx,%eax
  80174c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80174f:	5b                   	pop    %ebx
  801750:	5e                   	pop    %esi
  801751:	5d                   	pop    %ebp
  801752:	c3                   	ret    

00801753 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	56                   	push   %esi
  801757:	53                   	push   %ebx
  801758:	89 c6                	mov    %eax,%esi
  80175a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80175c:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801763:	74 27                	je     80178c <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801765:	6a 07                	push   $0x7
  801767:	68 00 50 80 00       	push   $0x805000
  80176c:	56                   	push   %esi
  80176d:	ff 35 00 40 80 00    	pushl  0x804000
  801773:	e8 08 0c 00 00       	call   802380 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801778:	83 c4 0c             	add    $0xc,%esp
  80177b:	6a 00                	push   $0x0
  80177d:	53                   	push   %ebx
  80177e:	6a 00                	push   $0x0
  801780:	e8 92 0b 00 00       	call   802317 <ipc_recv>
}
  801785:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801788:	5b                   	pop    %ebx
  801789:	5e                   	pop    %esi
  80178a:	5d                   	pop    %ebp
  80178b:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80178c:	83 ec 0c             	sub    $0xc,%esp
  80178f:	6a 01                	push   $0x1
  801791:	e8 42 0c 00 00       	call   8023d8 <ipc_find_env>
  801796:	a3 00 40 80 00       	mov    %eax,0x804000
  80179b:	83 c4 10             	add    $0x10,%esp
  80179e:	eb c5                	jmp    801765 <fsipc+0x12>

008017a0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ac:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b4:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8017be:	b8 02 00 00 00       	mov    $0x2,%eax
  8017c3:	e8 8b ff ff ff       	call   801753 <fsipc>
}
  8017c8:	c9                   	leave  
  8017c9:	c3                   	ret    

008017ca <devfile_flush>:
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
  8017cd:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8017d6:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017db:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e0:	b8 06 00 00 00       	mov    $0x6,%eax
  8017e5:	e8 69 ff ff ff       	call   801753 <fsipc>
}
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <devfile_stat>:
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	53                   	push   %ebx
  8017f0:	83 ec 04             	sub    $0x4,%esp
  8017f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8017fc:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801801:	ba 00 00 00 00       	mov    $0x0,%edx
  801806:	b8 05 00 00 00       	mov    $0x5,%eax
  80180b:	e8 43 ff ff ff       	call   801753 <fsipc>
  801810:	85 c0                	test   %eax,%eax
  801812:	78 2c                	js     801840 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801814:	83 ec 08             	sub    $0x8,%esp
  801817:	68 00 50 80 00       	push   $0x805000
  80181c:	53                   	push   %ebx
  80181d:	e8 43 f2 ff ff       	call   800a65 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801822:	a1 80 50 80 00       	mov    0x805080,%eax
  801827:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80182d:	a1 84 50 80 00       	mov    0x805084,%eax
  801832:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801838:	83 c4 10             	add    $0x10,%esp
  80183b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801840:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801843:	c9                   	leave  
  801844:	c3                   	ret    

00801845 <devfile_write>:
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
  801848:	53                   	push   %ebx
  801849:	83 ec 08             	sub    $0x8,%esp
  80184c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80184f:	8b 45 08             	mov    0x8(%ebp),%eax
  801852:	8b 40 0c             	mov    0xc(%eax),%eax
  801855:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80185a:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801860:	53                   	push   %ebx
  801861:	ff 75 0c             	pushl  0xc(%ebp)
  801864:	68 08 50 80 00       	push   $0x805008
  801869:	e8 e7 f3 ff ff       	call   800c55 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80186e:	ba 00 00 00 00       	mov    $0x0,%edx
  801873:	b8 04 00 00 00       	mov    $0x4,%eax
  801878:	e8 d6 fe ff ff       	call   801753 <fsipc>
  80187d:	83 c4 10             	add    $0x10,%esp
  801880:	85 c0                	test   %eax,%eax
  801882:	78 0b                	js     80188f <devfile_write+0x4a>
	assert(r <= n);
  801884:	39 d8                	cmp    %ebx,%eax
  801886:	77 0c                	ja     801894 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801888:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80188d:	7f 1e                	jg     8018ad <devfile_write+0x68>
}
  80188f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801892:	c9                   	leave  
  801893:	c3                   	ret    
	assert(r <= n);
  801894:	68 20 2d 80 00       	push   $0x802d20
  801899:	68 27 2d 80 00       	push   $0x802d27
  80189e:	68 98 00 00 00       	push   $0x98
  8018a3:	68 3c 2d 80 00       	push   $0x802d3c
  8018a8:	e8 63 e9 ff ff       	call   800210 <_panic>
	assert(r <= PGSIZE);
  8018ad:	68 47 2d 80 00       	push   $0x802d47
  8018b2:	68 27 2d 80 00       	push   $0x802d27
  8018b7:	68 99 00 00 00       	push   $0x99
  8018bc:	68 3c 2d 80 00       	push   $0x802d3c
  8018c1:	e8 4a e9 ff ff       	call   800210 <_panic>

008018c6 <devfile_read>:
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
  8018c9:	56                   	push   %esi
  8018ca:	53                   	push   %ebx
  8018cb:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8018d4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018d9:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018df:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e4:	b8 03 00 00 00       	mov    $0x3,%eax
  8018e9:	e8 65 fe ff ff       	call   801753 <fsipc>
  8018ee:	89 c3                	mov    %eax,%ebx
  8018f0:	85 c0                	test   %eax,%eax
  8018f2:	78 1f                	js     801913 <devfile_read+0x4d>
	assert(r <= n);
  8018f4:	39 f0                	cmp    %esi,%eax
  8018f6:	77 24                	ja     80191c <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018f8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018fd:	7f 33                	jg     801932 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018ff:	83 ec 04             	sub    $0x4,%esp
  801902:	50                   	push   %eax
  801903:	68 00 50 80 00       	push   $0x805000
  801908:	ff 75 0c             	pushl  0xc(%ebp)
  80190b:	e8 e3 f2 ff ff       	call   800bf3 <memmove>
	return r;
  801910:	83 c4 10             	add    $0x10,%esp
}
  801913:	89 d8                	mov    %ebx,%eax
  801915:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801918:	5b                   	pop    %ebx
  801919:	5e                   	pop    %esi
  80191a:	5d                   	pop    %ebp
  80191b:	c3                   	ret    
	assert(r <= n);
  80191c:	68 20 2d 80 00       	push   $0x802d20
  801921:	68 27 2d 80 00       	push   $0x802d27
  801926:	6a 7c                	push   $0x7c
  801928:	68 3c 2d 80 00       	push   $0x802d3c
  80192d:	e8 de e8 ff ff       	call   800210 <_panic>
	assert(r <= PGSIZE);
  801932:	68 47 2d 80 00       	push   $0x802d47
  801937:	68 27 2d 80 00       	push   $0x802d27
  80193c:	6a 7d                	push   $0x7d
  80193e:	68 3c 2d 80 00       	push   $0x802d3c
  801943:	e8 c8 e8 ff ff       	call   800210 <_panic>

00801948 <open>:
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
  80194b:	56                   	push   %esi
  80194c:	53                   	push   %ebx
  80194d:	83 ec 1c             	sub    $0x1c,%esp
  801950:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801953:	56                   	push   %esi
  801954:	e8 d3 f0 ff ff       	call   800a2c <strlen>
  801959:	83 c4 10             	add    $0x10,%esp
  80195c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801961:	7f 6c                	jg     8019cf <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801963:	83 ec 0c             	sub    $0xc,%esp
  801966:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801969:	50                   	push   %eax
  80196a:	e8 79 f8 ff ff       	call   8011e8 <fd_alloc>
  80196f:	89 c3                	mov    %eax,%ebx
  801971:	83 c4 10             	add    $0x10,%esp
  801974:	85 c0                	test   %eax,%eax
  801976:	78 3c                	js     8019b4 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801978:	83 ec 08             	sub    $0x8,%esp
  80197b:	56                   	push   %esi
  80197c:	68 00 50 80 00       	push   $0x805000
  801981:	e8 df f0 ff ff       	call   800a65 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801986:	8b 45 0c             	mov    0xc(%ebp),%eax
  801989:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80198e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801991:	b8 01 00 00 00       	mov    $0x1,%eax
  801996:	e8 b8 fd ff ff       	call   801753 <fsipc>
  80199b:	89 c3                	mov    %eax,%ebx
  80199d:	83 c4 10             	add    $0x10,%esp
  8019a0:	85 c0                	test   %eax,%eax
  8019a2:	78 19                	js     8019bd <open+0x75>
	return fd2num(fd);
  8019a4:	83 ec 0c             	sub    $0xc,%esp
  8019a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8019aa:	e8 12 f8 ff ff       	call   8011c1 <fd2num>
  8019af:	89 c3                	mov    %eax,%ebx
  8019b1:	83 c4 10             	add    $0x10,%esp
}
  8019b4:	89 d8                	mov    %ebx,%eax
  8019b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019b9:	5b                   	pop    %ebx
  8019ba:	5e                   	pop    %esi
  8019bb:	5d                   	pop    %ebp
  8019bc:	c3                   	ret    
		fd_close(fd, 0);
  8019bd:	83 ec 08             	sub    $0x8,%esp
  8019c0:	6a 00                	push   $0x0
  8019c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8019c5:	e8 1b f9 ff ff       	call   8012e5 <fd_close>
		return r;
  8019ca:	83 c4 10             	add    $0x10,%esp
  8019cd:	eb e5                	jmp    8019b4 <open+0x6c>
		return -E_BAD_PATH;
  8019cf:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019d4:	eb de                	jmp    8019b4 <open+0x6c>

008019d6 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
  8019d9:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e1:	b8 08 00 00 00       	mov    $0x8,%eax
  8019e6:	e8 68 fd ff ff       	call   801753 <fsipc>
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
  8019f0:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8019f3:	68 53 2d 80 00       	push   $0x802d53
  8019f8:	ff 75 0c             	pushl  0xc(%ebp)
  8019fb:	e8 65 f0 ff ff       	call   800a65 <strcpy>
	return 0;
}
  801a00:	b8 00 00 00 00       	mov    $0x0,%eax
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <devsock_close>:
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	53                   	push   %ebx
  801a0b:	83 ec 10             	sub    $0x10,%esp
  801a0e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a11:	53                   	push   %ebx
  801a12:	e8 fc 09 00 00       	call   802413 <pageref>
  801a17:	83 c4 10             	add    $0x10,%esp
		return 0;
  801a1a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801a1f:	83 f8 01             	cmp    $0x1,%eax
  801a22:	74 07                	je     801a2b <devsock_close+0x24>
}
  801a24:	89 d0                	mov    %edx,%eax
  801a26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801a2b:	83 ec 0c             	sub    $0xc,%esp
  801a2e:	ff 73 0c             	pushl  0xc(%ebx)
  801a31:	e8 b9 02 00 00       	call   801cef <nsipc_close>
  801a36:	89 c2                	mov    %eax,%edx
  801a38:	83 c4 10             	add    $0x10,%esp
  801a3b:	eb e7                	jmp    801a24 <devsock_close+0x1d>

00801a3d <devsock_write>:
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
  801a40:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a43:	6a 00                	push   $0x0
  801a45:	ff 75 10             	pushl  0x10(%ebp)
  801a48:	ff 75 0c             	pushl  0xc(%ebp)
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	ff 70 0c             	pushl  0xc(%eax)
  801a51:	e8 76 03 00 00       	call   801dcc <nsipc_send>
}
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <devsock_read>:
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
  801a5b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a5e:	6a 00                	push   $0x0
  801a60:	ff 75 10             	pushl  0x10(%ebp)
  801a63:	ff 75 0c             	pushl  0xc(%ebp)
  801a66:	8b 45 08             	mov    0x8(%ebp),%eax
  801a69:	ff 70 0c             	pushl  0xc(%eax)
  801a6c:	e8 ef 02 00 00       	call   801d60 <nsipc_recv>
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <fd2sockid>:
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
  801a76:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a79:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a7c:	52                   	push   %edx
  801a7d:	50                   	push   %eax
  801a7e:	e8 b7 f7 ff ff       	call   80123a <fd_lookup>
  801a83:	83 c4 10             	add    $0x10,%esp
  801a86:	85 c0                	test   %eax,%eax
  801a88:	78 10                	js     801a9a <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8d:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a93:	39 08                	cmp    %ecx,(%eax)
  801a95:	75 05                	jne    801a9c <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a97:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    
		return -E_NOT_SUPP;
  801a9c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801aa1:	eb f7                	jmp    801a9a <fd2sockid+0x27>

00801aa3 <alloc_sockfd>:
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
  801aa6:	56                   	push   %esi
  801aa7:	53                   	push   %ebx
  801aa8:	83 ec 1c             	sub    $0x1c,%esp
  801aab:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801aad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ab0:	50                   	push   %eax
  801ab1:	e8 32 f7 ff ff       	call   8011e8 <fd_alloc>
  801ab6:	89 c3                	mov    %eax,%ebx
  801ab8:	83 c4 10             	add    $0x10,%esp
  801abb:	85 c0                	test   %eax,%eax
  801abd:	78 43                	js     801b02 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801abf:	83 ec 04             	sub    $0x4,%esp
  801ac2:	68 07 04 00 00       	push   $0x407
  801ac7:	ff 75 f4             	pushl  -0xc(%ebp)
  801aca:	6a 00                	push   $0x0
  801acc:	e8 86 f3 ff ff       	call   800e57 <sys_page_alloc>
  801ad1:	89 c3                	mov    %eax,%ebx
  801ad3:	83 c4 10             	add    $0x10,%esp
  801ad6:	85 c0                	test   %eax,%eax
  801ad8:	78 28                	js     801b02 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801add:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ae3:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801aef:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801af2:	83 ec 0c             	sub    $0xc,%esp
  801af5:	50                   	push   %eax
  801af6:	e8 c6 f6 ff ff       	call   8011c1 <fd2num>
  801afb:	89 c3                	mov    %eax,%ebx
  801afd:	83 c4 10             	add    $0x10,%esp
  801b00:	eb 0c                	jmp    801b0e <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801b02:	83 ec 0c             	sub    $0xc,%esp
  801b05:	56                   	push   %esi
  801b06:	e8 e4 01 00 00       	call   801cef <nsipc_close>
		return r;
  801b0b:	83 c4 10             	add    $0x10,%esp
}
  801b0e:	89 d8                	mov    %ebx,%eax
  801b10:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b13:	5b                   	pop    %ebx
  801b14:	5e                   	pop    %esi
  801b15:	5d                   	pop    %ebp
  801b16:	c3                   	ret    

00801b17 <accept>:
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
  801b1a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b20:	e8 4e ff ff ff       	call   801a73 <fd2sockid>
  801b25:	85 c0                	test   %eax,%eax
  801b27:	78 1b                	js     801b44 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b29:	83 ec 04             	sub    $0x4,%esp
  801b2c:	ff 75 10             	pushl  0x10(%ebp)
  801b2f:	ff 75 0c             	pushl  0xc(%ebp)
  801b32:	50                   	push   %eax
  801b33:	e8 0e 01 00 00       	call   801c46 <nsipc_accept>
  801b38:	83 c4 10             	add    $0x10,%esp
  801b3b:	85 c0                	test   %eax,%eax
  801b3d:	78 05                	js     801b44 <accept+0x2d>
	return alloc_sockfd(r);
  801b3f:	e8 5f ff ff ff       	call   801aa3 <alloc_sockfd>
}
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <bind>:
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
  801b49:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4f:	e8 1f ff ff ff       	call   801a73 <fd2sockid>
  801b54:	85 c0                	test   %eax,%eax
  801b56:	78 12                	js     801b6a <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801b58:	83 ec 04             	sub    $0x4,%esp
  801b5b:	ff 75 10             	pushl  0x10(%ebp)
  801b5e:	ff 75 0c             	pushl  0xc(%ebp)
  801b61:	50                   	push   %eax
  801b62:	e8 31 01 00 00       	call   801c98 <nsipc_bind>
  801b67:	83 c4 10             	add    $0x10,%esp
}
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <shutdown>:
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
  801b6f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b72:	8b 45 08             	mov    0x8(%ebp),%eax
  801b75:	e8 f9 fe ff ff       	call   801a73 <fd2sockid>
  801b7a:	85 c0                	test   %eax,%eax
  801b7c:	78 0f                	js     801b8d <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801b7e:	83 ec 08             	sub    $0x8,%esp
  801b81:	ff 75 0c             	pushl  0xc(%ebp)
  801b84:	50                   	push   %eax
  801b85:	e8 43 01 00 00       	call   801ccd <nsipc_shutdown>
  801b8a:	83 c4 10             	add    $0x10,%esp
}
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <connect>:
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
  801b92:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b95:	8b 45 08             	mov    0x8(%ebp),%eax
  801b98:	e8 d6 fe ff ff       	call   801a73 <fd2sockid>
  801b9d:	85 c0                	test   %eax,%eax
  801b9f:	78 12                	js     801bb3 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801ba1:	83 ec 04             	sub    $0x4,%esp
  801ba4:	ff 75 10             	pushl  0x10(%ebp)
  801ba7:	ff 75 0c             	pushl  0xc(%ebp)
  801baa:	50                   	push   %eax
  801bab:	e8 59 01 00 00       	call   801d09 <nsipc_connect>
  801bb0:	83 c4 10             	add    $0x10,%esp
}
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <listen>:
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
  801bb8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	e8 b0 fe ff ff       	call   801a73 <fd2sockid>
  801bc3:	85 c0                	test   %eax,%eax
  801bc5:	78 0f                	js     801bd6 <listen+0x21>
	return nsipc_listen(r, backlog);
  801bc7:	83 ec 08             	sub    $0x8,%esp
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	50                   	push   %eax
  801bce:	e8 6b 01 00 00       	call   801d3e <nsipc_listen>
  801bd3:	83 c4 10             	add    $0x10,%esp
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <socket>:

int
socket(int domain, int type, int protocol)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
  801bdb:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801bde:	ff 75 10             	pushl  0x10(%ebp)
  801be1:	ff 75 0c             	pushl  0xc(%ebp)
  801be4:	ff 75 08             	pushl  0x8(%ebp)
  801be7:	e8 3e 02 00 00       	call   801e2a <nsipc_socket>
  801bec:	83 c4 10             	add    $0x10,%esp
  801bef:	85 c0                	test   %eax,%eax
  801bf1:	78 05                	js     801bf8 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801bf3:	e8 ab fe ff ff       	call   801aa3 <alloc_sockfd>
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
  801bfd:	53                   	push   %ebx
  801bfe:	83 ec 04             	sub    $0x4,%esp
  801c01:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c03:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c0a:	74 26                	je     801c32 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c0c:	6a 07                	push   $0x7
  801c0e:	68 00 60 80 00       	push   $0x806000
  801c13:	53                   	push   %ebx
  801c14:	ff 35 04 40 80 00    	pushl  0x804004
  801c1a:	e8 61 07 00 00       	call   802380 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c1f:	83 c4 0c             	add    $0xc,%esp
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	e8 ea 06 00 00       	call   802317 <ipc_recv>
}
  801c2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c32:	83 ec 0c             	sub    $0xc,%esp
  801c35:	6a 02                	push   $0x2
  801c37:	e8 9c 07 00 00       	call   8023d8 <ipc_find_env>
  801c3c:	a3 04 40 80 00       	mov    %eax,0x804004
  801c41:	83 c4 10             	add    $0x10,%esp
  801c44:	eb c6                	jmp    801c0c <nsipc+0x12>

00801c46 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
  801c49:	56                   	push   %esi
  801c4a:	53                   	push   %ebx
  801c4b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c56:	8b 06                	mov    (%esi),%eax
  801c58:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c5d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c62:	e8 93 ff ff ff       	call   801bfa <nsipc>
  801c67:	89 c3                	mov    %eax,%ebx
  801c69:	85 c0                	test   %eax,%eax
  801c6b:	79 09                	jns    801c76 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801c6d:	89 d8                	mov    %ebx,%eax
  801c6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c72:	5b                   	pop    %ebx
  801c73:	5e                   	pop    %esi
  801c74:	5d                   	pop    %ebp
  801c75:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c76:	83 ec 04             	sub    $0x4,%esp
  801c79:	ff 35 10 60 80 00    	pushl  0x806010
  801c7f:	68 00 60 80 00       	push   $0x806000
  801c84:	ff 75 0c             	pushl  0xc(%ebp)
  801c87:	e8 67 ef ff ff       	call   800bf3 <memmove>
		*addrlen = ret->ret_addrlen;
  801c8c:	a1 10 60 80 00       	mov    0x806010,%eax
  801c91:	89 06                	mov    %eax,(%esi)
  801c93:	83 c4 10             	add    $0x10,%esp
	return r;
  801c96:	eb d5                	jmp    801c6d <nsipc_accept+0x27>

00801c98 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	53                   	push   %ebx
  801c9c:	83 ec 08             	sub    $0x8,%esp
  801c9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca5:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801caa:	53                   	push   %ebx
  801cab:	ff 75 0c             	pushl  0xc(%ebp)
  801cae:	68 04 60 80 00       	push   $0x806004
  801cb3:	e8 3b ef ff ff       	call   800bf3 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801cb8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801cbe:	b8 02 00 00 00       	mov    $0x2,%eax
  801cc3:	e8 32 ff ff ff       	call   801bfa <nsipc>
}
  801cc8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
  801cd0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cde:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ce3:	b8 03 00 00 00       	mov    $0x3,%eax
  801ce8:	e8 0d ff ff ff       	call   801bfa <nsipc>
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <nsipc_close>:

int
nsipc_close(int s)
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf8:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801cfd:	b8 04 00 00 00       	mov    $0x4,%eax
  801d02:	e8 f3 fe ff ff       	call   801bfa <nsipc>
}
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    

00801d09 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
  801d0c:	53                   	push   %ebx
  801d0d:	83 ec 08             	sub    $0x8,%esp
  801d10:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d13:	8b 45 08             	mov    0x8(%ebp),%eax
  801d16:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d1b:	53                   	push   %ebx
  801d1c:	ff 75 0c             	pushl  0xc(%ebp)
  801d1f:	68 04 60 80 00       	push   $0x806004
  801d24:	e8 ca ee ff ff       	call   800bf3 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d29:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d2f:	b8 05 00 00 00       	mov    $0x5,%eax
  801d34:	e8 c1 fe ff ff       	call   801bfa <nsipc>
}
  801d39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
  801d41:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d44:	8b 45 08             	mov    0x8(%ebp),%eax
  801d47:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d4f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d54:	b8 06 00 00 00       	mov    $0x6,%eax
  801d59:	e8 9c fe ff ff       	call   801bfa <nsipc>
}
  801d5e:	c9                   	leave  
  801d5f:	c3                   	ret    

00801d60 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
  801d63:	56                   	push   %esi
  801d64:	53                   	push   %ebx
  801d65:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d68:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d70:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d76:	8b 45 14             	mov    0x14(%ebp),%eax
  801d79:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d7e:	b8 07 00 00 00       	mov    $0x7,%eax
  801d83:	e8 72 fe ff ff       	call   801bfa <nsipc>
  801d88:	89 c3                	mov    %eax,%ebx
  801d8a:	85 c0                	test   %eax,%eax
  801d8c:	78 1f                	js     801dad <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d8e:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d93:	7f 21                	jg     801db6 <nsipc_recv+0x56>
  801d95:	39 c6                	cmp    %eax,%esi
  801d97:	7c 1d                	jl     801db6 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d99:	83 ec 04             	sub    $0x4,%esp
  801d9c:	50                   	push   %eax
  801d9d:	68 00 60 80 00       	push   $0x806000
  801da2:	ff 75 0c             	pushl  0xc(%ebp)
  801da5:	e8 49 ee ff ff       	call   800bf3 <memmove>
  801daa:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801dad:	89 d8                	mov    %ebx,%eax
  801daf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801db2:	5b                   	pop    %ebx
  801db3:	5e                   	pop    %esi
  801db4:	5d                   	pop    %ebp
  801db5:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801db6:	68 5f 2d 80 00       	push   $0x802d5f
  801dbb:	68 27 2d 80 00       	push   $0x802d27
  801dc0:	6a 62                	push   $0x62
  801dc2:	68 74 2d 80 00       	push   $0x802d74
  801dc7:	e8 44 e4 ff ff       	call   800210 <_panic>

00801dcc <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
  801dcf:	53                   	push   %ebx
  801dd0:	83 ec 04             	sub    $0x4,%esp
  801dd3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd9:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801dde:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801de4:	7f 2e                	jg     801e14 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801de6:	83 ec 04             	sub    $0x4,%esp
  801de9:	53                   	push   %ebx
  801dea:	ff 75 0c             	pushl  0xc(%ebp)
  801ded:	68 0c 60 80 00       	push   $0x80600c
  801df2:	e8 fc ed ff ff       	call   800bf3 <memmove>
	nsipcbuf.send.req_size = size;
  801df7:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801dfd:	8b 45 14             	mov    0x14(%ebp),%eax
  801e00:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e05:	b8 08 00 00 00       	mov    $0x8,%eax
  801e0a:	e8 eb fd ff ff       	call   801bfa <nsipc>
}
  801e0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e12:	c9                   	leave  
  801e13:	c3                   	ret    
	assert(size < 1600);
  801e14:	68 80 2d 80 00       	push   $0x802d80
  801e19:	68 27 2d 80 00       	push   $0x802d27
  801e1e:	6a 6d                	push   $0x6d
  801e20:	68 74 2d 80 00       	push   $0x802d74
  801e25:	e8 e6 e3 ff ff       	call   800210 <_panic>

00801e2a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
  801e2d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e30:	8b 45 08             	mov    0x8(%ebp),%eax
  801e33:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e3b:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e40:	8b 45 10             	mov    0x10(%ebp),%eax
  801e43:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e48:	b8 09 00 00 00       	mov    $0x9,%eax
  801e4d:	e8 a8 fd ff ff       	call   801bfa <nsipc>
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	56                   	push   %esi
  801e58:	53                   	push   %ebx
  801e59:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e5c:	83 ec 0c             	sub    $0xc,%esp
  801e5f:	ff 75 08             	pushl  0x8(%ebp)
  801e62:	e8 6a f3 ff ff       	call   8011d1 <fd2data>
  801e67:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e69:	83 c4 08             	add    $0x8,%esp
  801e6c:	68 8c 2d 80 00       	push   $0x802d8c
  801e71:	53                   	push   %ebx
  801e72:	e8 ee eb ff ff       	call   800a65 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e77:	8b 46 04             	mov    0x4(%esi),%eax
  801e7a:	2b 06                	sub    (%esi),%eax
  801e7c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e82:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e89:	00 00 00 
	stat->st_dev = &devpipe;
  801e8c:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801e93:	30 80 00 
	return 0;
}
  801e96:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e9e:	5b                   	pop    %ebx
  801e9f:	5e                   	pop    %esi
  801ea0:	5d                   	pop    %ebp
  801ea1:	c3                   	ret    

00801ea2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
  801ea5:	53                   	push   %ebx
  801ea6:	83 ec 0c             	sub    $0xc,%esp
  801ea9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801eac:	53                   	push   %ebx
  801ead:	6a 00                	push   $0x0
  801eaf:	e8 28 f0 ff ff       	call   800edc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801eb4:	89 1c 24             	mov    %ebx,(%esp)
  801eb7:	e8 15 f3 ff ff       	call   8011d1 <fd2data>
  801ebc:	83 c4 08             	add    $0x8,%esp
  801ebf:	50                   	push   %eax
  801ec0:	6a 00                	push   $0x0
  801ec2:	e8 15 f0 ff ff       	call   800edc <sys_page_unmap>
}
  801ec7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eca:	c9                   	leave  
  801ecb:	c3                   	ret    

00801ecc <_pipeisclosed>:
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
  801ecf:	57                   	push   %edi
  801ed0:	56                   	push   %esi
  801ed1:	53                   	push   %ebx
  801ed2:	83 ec 1c             	sub    $0x1c,%esp
  801ed5:	89 c7                	mov    %eax,%edi
  801ed7:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ed9:	a1 08 40 80 00       	mov    0x804008,%eax
  801ede:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ee1:	83 ec 0c             	sub    $0xc,%esp
  801ee4:	57                   	push   %edi
  801ee5:	e8 29 05 00 00       	call   802413 <pageref>
  801eea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801eed:	89 34 24             	mov    %esi,(%esp)
  801ef0:	e8 1e 05 00 00       	call   802413 <pageref>
		nn = thisenv->env_runs;
  801ef5:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801efb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801efe:	83 c4 10             	add    $0x10,%esp
  801f01:	39 cb                	cmp    %ecx,%ebx
  801f03:	74 1b                	je     801f20 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801f05:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f08:	75 cf                	jne    801ed9 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f0a:	8b 42 58             	mov    0x58(%edx),%eax
  801f0d:	6a 01                	push   $0x1
  801f0f:	50                   	push   %eax
  801f10:	53                   	push   %ebx
  801f11:	68 93 2d 80 00       	push   $0x802d93
  801f16:	e8 eb e3 ff ff       	call   800306 <cprintf>
  801f1b:	83 c4 10             	add    $0x10,%esp
  801f1e:	eb b9                	jmp    801ed9 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801f20:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f23:	0f 94 c0             	sete   %al
  801f26:	0f b6 c0             	movzbl %al,%eax
}
  801f29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f2c:	5b                   	pop    %ebx
  801f2d:	5e                   	pop    %esi
  801f2e:	5f                   	pop    %edi
  801f2f:	5d                   	pop    %ebp
  801f30:	c3                   	ret    

00801f31 <devpipe_write>:
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
  801f34:	57                   	push   %edi
  801f35:	56                   	push   %esi
  801f36:	53                   	push   %ebx
  801f37:	83 ec 28             	sub    $0x28,%esp
  801f3a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f3d:	56                   	push   %esi
  801f3e:	e8 8e f2 ff ff       	call   8011d1 <fd2data>
  801f43:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f45:	83 c4 10             	add    $0x10,%esp
  801f48:	bf 00 00 00 00       	mov    $0x0,%edi
  801f4d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f50:	74 4f                	je     801fa1 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f52:	8b 43 04             	mov    0x4(%ebx),%eax
  801f55:	8b 0b                	mov    (%ebx),%ecx
  801f57:	8d 51 20             	lea    0x20(%ecx),%edx
  801f5a:	39 d0                	cmp    %edx,%eax
  801f5c:	72 14                	jb     801f72 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801f5e:	89 da                	mov    %ebx,%edx
  801f60:	89 f0                	mov    %esi,%eax
  801f62:	e8 65 ff ff ff       	call   801ecc <_pipeisclosed>
  801f67:	85 c0                	test   %eax,%eax
  801f69:	75 3b                	jne    801fa6 <devpipe_write+0x75>
			sys_yield();
  801f6b:	e8 c8 ee ff ff       	call   800e38 <sys_yield>
  801f70:	eb e0                	jmp    801f52 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f75:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f79:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f7c:	89 c2                	mov    %eax,%edx
  801f7e:	c1 fa 1f             	sar    $0x1f,%edx
  801f81:	89 d1                	mov    %edx,%ecx
  801f83:	c1 e9 1b             	shr    $0x1b,%ecx
  801f86:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801f89:	83 e2 1f             	and    $0x1f,%edx
  801f8c:	29 ca                	sub    %ecx,%edx
  801f8e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f92:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f96:	83 c0 01             	add    $0x1,%eax
  801f99:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f9c:	83 c7 01             	add    $0x1,%edi
  801f9f:	eb ac                	jmp    801f4d <devpipe_write+0x1c>
	return i;
  801fa1:	8b 45 10             	mov    0x10(%ebp),%eax
  801fa4:	eb 05                	jmp    801fab <devpipe_write+0x7a>
				return 0;
  801fa6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fae:	5b                   	pop    %ebx
  801faf:	5e                   	pop    %esi
  801fb0:	5f                   	pop    %edi
  801fb1:	5d                   	pop    %ebp
  801fb2:	c3                   	ret    

00801fb3 <devpipe_read>:
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
  801fb6:	57                   	push   %edi
  801fb7:	56                   	push   %esi
  801fb8:	53                   	push   %ebx
  801fb9:	83 ec 18             	sub    $0x18,%esp
  801fbc:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801fbf:	57                   	push   %edi
  801fc0:	e8 0c f2 ff ff       	call   8011d1 <fd2data>
  801fc5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801fc7:	83 c4 10             	add    $0x10,%esp
  801fca:	be 00 00 00 00       	mov    $0x0,%esi
  801fcf:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fd2:	75 14                	jne    801fe8 <devpipe_read+0x35>
	return i;
  801fd4:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd7:	eb 02                	jmp    801fdb <devpipe_read+0x28>
				return i;
  801fd9:	89 f0                	mov    %esi,%eax
}
  801fdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fde:	5b                   	pop    %ebx
  801fdf:	5e                   	pop    %esi
  801fe0:	5f                   	pop    %edi
  801fe1:	5d                   	pop    %ebp
  801fe2:	c3                   	ret    
			sys_yield();
  801fe3:	e8 50 ee ff ff       	call   800e38 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801fe8:	8b 03                	mov    (%ebx),%eax
  801fea:	3b 43 04             	cmp    0x4(%ebx),%eax
  801fed:	75 18                	jne    802007 <devpipe_read+0x54>
			if (i > 0)
  801fef:	85 f6                	test   %esi,%esi
  801ff1:	75 e6                	jne    801fd9 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801ff3:	89 da                	mov    %ebx,%edx
  801ff5:	89 f8                	mov    %edi,%eax
  801ff7:	e8 d0 fe ff ff       	call   801ecc <_pipeisclosed>
  801ffc:	85 c0                	test   %eax,%eax
  801ffe:	74 e3                	je     801fe3 <devpipe_read+0x30>
				return 0;
  802000:	b8 00 00 00 00       	mov    $0x0,%eax
  802005:	eb d4                	jmp    801fdb <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802007:	99                   	cltd   
  802008:	c1 ea 1b             	shr    $0x1b,%edx
  80200b:	01 d0                	add    %edx,%eax
  80200d:	83 e0 1f             	and    $0x1f,%eax
  802010:	29 d0                	sub    %edx,%eax
  802012:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802017:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80201a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80201d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802020:	83 c6 01             	add    $0x1,%esi
  802023:	eb aa                	jmp    801fcf <devpipe_read+0x1c>

00802025 <pipe>:
{
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
  802028:	56                   	push   %esi
  802029:	53                   	push   %ebx
  80202a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80202d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802030:	50                   	push   %eax
  802031:	e8 b2 f1 ff ff       	call   8011e8 <fd_alloc>
  802036:	89 c3                	mov    %eax,%ebx
  802038:	83 c4 10             	add    $0x10,%esp
  80203b:	85 c0                	test   %eax,%eax
  80203d:	0f 88 23 01 00 00    	js     802166 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802043:	83 ec 04             	sub    $0x4,%esp
  802046:	68 07 04 00 00       	push   $0x407
  80204b:	ff 75 f4             	pushl  -0xc(%ebp)
  80204e:	6a 00                	push   $0x0
  802050:	e8 02 ee ff ff       	call   800e57 <sys_page_alloc>
  802055:	89 c3                	mov    %eax,%ebx
  802057:	83 c4 10             	add    $0x10,%esp
  80205a:	85 c0                	test   %eax,%eax
  80205c:	0f 88 04 01 00 00    	js     802166 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802062:	83 ec 0c             	sub    $0xc,%esp
  802065:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802068:	50                   	push   %eax
  802069:	e8 7a f1 ff ff       	call   8011e8 <fd_alloc>
  80206e:	89 c3                	mov    %eax,%ebx
  802070:	83 c4 10             	add    $0x10,%esp
  802073:	85 c0                	test   %eax,%eax
  802075:	0f 88 db 00 00 00    	js     802156 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80207b:	83 ec 04             	sub    $0x4,%esp
  80207e:	68 07 04 00 00       	push   $0x407
  802083:	ff 75 f0             	pushl  -0x10(%ebp)
  802086:	6a 00                	push   $0x0
  802088:	e8 ca ed ff ff       	call   800e57 <sys_page_alloc>
  80208d:	89 c3                	mov    %eax,%ebx
  80208f:	83 c4 10             	add    $0x10,%esp
  802092:	85 c0                	test   %eax,%eax
  802094:	0f 88 bc 00 00 00    	js     802156 <pipe+0x131>
	va = fd2data(fd0);
  80209a:	83 ec 0c             	sub    $0xc,%esp
  80209d:	ff 75 f4             	pushl  -0xc(%ebp)
  8020a0:	e8 2c f1 ff ff       	call   8011d1 <fd2data>
  8020a5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020a7:	83 c4 0c             	add    $0xc,%esp
  8020aa:	68 07 04 00 00       	push   $0x407
  8020af:	50                   	push   %eax
  8020b0:	6a 00                	push   $0x0
  8020b2:	e8 a0 ed ff ff       	call   800e57 <sys_page_alloc>
  8020b7:	89 c3                	mov    %eax,%ebx
  8020b9:	83 c4 10             	add    $0x10,%esp
  8020bc:	85 c0                	test   %eax,%eax
  8020be:	0f 88 82 00 00 00    	js     802146 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020c4:	83 ec 0c             	sub    $0xc,%esp
  8020c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8020ca:	e8 02 f1 ff ff       	call   8011d1 <fd2data>
  8020cf:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8020d6:	50                   	push   %eax
  8020d7:	6a 00                	push   $0x0
  8020d9:	56                   	push   %esi
  8020da:	6a 00                	push   $0x0
  8020dc:	e8 b9 ed ff ff       	call   800e9a <sys_page_map>
  8020e1:	89 c3                	mov    %eax,%ebx
  8020e3:	83 c4 20             	add    $0x20,%esp
  8020e6:	85 c0                	test   %eax,%eax
  8020e8:	78 4e                	js     802138 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8020ea:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8020ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020f2:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8020f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020f7:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8020fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802101:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802103:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802106:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80210d:	83 ec 0c             	sub    $0xc,%esp
  802110:	ff 75 f4             	pushl  -0xc(%ebp)
  802113:	e8 a9 f0 ff ff       	call   8011c1 <fd2num>
  802118:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80211b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80211d:	83 c4 04             	add    $0x4,%esp
  802120:	ff 75 f0             	pushl  -0x10(%ebp)
  802123:	e8 99 f0 ff ff       	call   8011c1 <fd2num>
  802128:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80212b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80212e:	83 c4 10             	add    $0x10,%esp
  802131:	bb 00 00 00 00       	mov    $0x0,%ebx
  802136:	eb 2e                	jmp    802166 <pipe+0x141>
	sys_page_unmap(0, va);
  802138:	83 ec 08             	sub    $0x8,%esp
  80213b:	56                   	push   %esi
  80213c:	6a 00                	push   $0x0
  80213e:	e8 99 ed ff ff       	call   800edc <sys_page_unmap>
  802143:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802146:	83 ec 08             	sub    $0x8,%esp
  802149:	ff 75 f0             	pushl  -0x10(%ebp)
  80214c:	6a 00                	push   $0x0
  80214e:	e8 89 ed ff ff       	call   800edc <sys_page_unmap>
  802153:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802156:	83 ec 08             	sub    $0x8,%esp
  802159:	ff 75 f4             	pushl  -0xc(%ebp)
  80215c:	6a 00                	push   $0x0
  80215e:	e8 79 ed ff ff       	call   800edc <sys_page_unmap>
  802163:	83 c4 10             	add    $0x10,%esp
}
  802166:	89 d8                	mov    %ebx,%eax
  802168:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80216b:	5b                   	pop    %ebx
  80216c:	5e                   	pop    %esi
  80216d:	5d                   	pop    %ebp
  80216e:	c3                   	ret    

0080216f <pipeisclosed>:
{
  80216f:	55                   	push   %ebp
  802170:	89 e5                	mov    %esp,%ebp
  802172:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802175:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802178:	50                   	push   %eax
  802179:	ff 75 08             	pushl  0x8(%ebp)
  80217c:	e8 b9 f0 ff ff       	call   80123a <fd_lookup>
  802181:	83 c4 10             	add    $0x10,%esp
  802184:	85 c0                	test   %eax,%eax
  802186:	78 18                	js     8021a0 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802188:	83 ec 0c             	sub    $0xc,%esp
  80218b:	ff 75 f4             	pushl  -0xc(%ebp)
  80218e:	e8 3e f0 ff ff       	call   8011d1 <fd2data>
	return _pipeisclosed(fd, p);
  802193:	89 c2                	mov    %eax,%edx
  802195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802198:	e8 2f fd ff ff       	call   801ecc <_pipeisclosed>
  80219d:	83 c4 10             	add    $0x10,%esp
}
  8021a0:	c9                   	leave  
  8021a1:	c3                   	ret    

008021a2 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8021a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a7:	c3                   	ret    

008021a8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
  8021ab:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8021ae:	68 ab 2d 80 00       	push   $0x802dab
  8021b3:	ff 75 0c             	pushl  0xc(%ebp)
  8021b6:	e8 aa e8 ff ff       	call   800a65 <strcpy>
	return 0;
}
  8021bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c0:	c9                   	leave  
  8021c1:	c3                   	ret    

008021c2 <devcons_write>:
{
  8021c2:	55                   	push   %ebp
  8021c3:	89 e5                	mov    %esp,%ebp
  8021c5:	57                   	push   %edi
  8021c6:	56                   	push   %esi
  8021c7:	53                   	push   %ebx
  8021c8:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8021ce:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8021d3:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8021d9:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021dc:	73 31                	jae    80220f <devcons_write+0x4d>
		m = n - tot;
  8021de:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8021e1:	29 f3                	sub    %esi,%ebx
  8021e3:	83 fb 7f             	cmp    $0x7f,%ebx
  8021e6:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8021eb:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8021ee:	83 ec 04             	sub    $0x4,%esp
  8021f1:	53                   	push   %ebx
  8021f2:	89 f0                	mov    %esi,%eax
  8021f4:	03 45 0c             	add    0xc(%ebp),%eax
  8021f7:	50                   	push   %eax
  8021f8:	57                   	push   %edi
  8021f9:	e8 f5 e9 ff ff       	call   800bf3 <memmove>
		sys_cputs(buf, m);
  8021fe:	83 c4 08             	add    $0x8,%esp
  802201:	53                   	push   %ebx
  802202:	57                   	push   %edi
  802203:	e8 93 eb ff ff       	call   800d9b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802208:	01 de                	add    %ebx,%esi
  80220a:	83 c4 10             	add    $0x10,%esp
  80220d:	eb ca                	jmp    8021d9 <devcons_write+0x17>
}
  80220f:	89 f0                	mov    %esi,%eax
  802211:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802214:	5b                   	pop    %ebx
  802215:	5e                   	pop    %esi
  802216:	5f                   	pop    %edi
  802217:	5d                   	pop    %ebp
  802218:	c3                   	ret    

00802219 <devcons_read>:
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
  80221c:	83 ec 08             	sub    $0x8,%esp
  80221f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802224:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802228:	74 21                	je     80224b <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80222a:	e8 8a eb ff ff       	call   800db9 <sys_cgetc>
  80222f:	85 c0                	test   %eax,%eax
  802231:	75 07                	jne    80223a <devcons_read+0x21>
		sys_yield();
  802233:	e8 00 ec ff ff       	call   800e38 <sys_yield>
  802238:	eb f0                	jmp    80222a <devcons_read+0x11>
	if (c < 0)
  80223a:	78 0f                	js     80224b <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80223c:	83 f8 04             	cmp    $0x4,%eax
  80223f:	74 0c                	je     80224d <devcons_read+0x34>
	*(char*)vbuf = c;
  802241:	8b 55 0c             	mov    0xc(%ebp),%edx
  802244:	88 02                	mov    %al,(%edx)
	return 1;
  802246:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    
		return 0;
  80224d:	b8 00 00 00 00       	mov    $0x0,%eax
  802252:	eb f7                	jmp    80224b <devcons_read+0x32>

00802254 <cputchar>:
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
  802257:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80225a:	8b 45 08             	mov    0x8(%ebp),%eax
  80225d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802260:	6a 01                	push   $0x1
  802262:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802265:	50                   	push   %eax
  802266:	e8 30 eb ff ff       	call   800d9b <sys_cputs>
}
  80226b:	83 c4 10             	add    $0x10,%esp
  80226e:	c9                   	leave  
  80226f:	c3                   	ret    

00802270 <getchar>:
{
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
  802273:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802276:	6a 01                	push   $0x1
  802278:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80227b:	50                   	push   %eax
  80227c:	6a 00                	push   $0x0
  80227e:	e8 27 f2 ff ff       	call   8014aa <read>
	if (r < 0)
  802283:	83 c4 10             	add    $0x10,%esp
  802286:	85 c0                	test   %eax,%eax
  802288:	78 06                	js     802290 <getchar+0x20>
	if (r < 1)
  80228a:	74 06                	je     802292 <getchar+0x22>
	return c;
  80228c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802290:	c9                   	leave  
  802291:	c3                   	ret    
		return -E_EOF;
  802292:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802297:	eb f7                	jmp    802290 <getchar+0x20>

00802299 <iscons>:
{
  802299:	55                   	push   %ebp
  80229a:	89 e5                	mov    %esp,%ebp
  80229c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80229f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022a2:	50                   	push   %eax
  8022a3:	ff 75 08             	pushl  0x8(%ebp)
  8022a6:	e8 8f ef ff ff       	call   80123a <fd_lookup>
  8022ab:	83 c4 10             	add    $0x10,%esp
  8022ae:	85 c0                	test   %eax,%eax
  8022b0:	78 11                	js     8022c3 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8022b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b5:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022bb:	39 10                	cmp    %edx,(%eax)
  8022bd:	0f 94 c0             	sete   %al
  8022c0:	0f b6 c0             	movzbl %al,%eax
}
  8022c3:	c9                   	leave  
  8022c4:	c3                   	ret    

008022c5 <opencons>:
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
  8022c8:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8022cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022ce:	50                   	push   %eax
  8022cf:	e8 14 ef ff ff       	call   8011e8 <fd_alloc>
  8022d4:	83 c4 10             	add    $0x10,%esp
  8022d7:	85 c0                	test   %eax,%eax
  8022d9:	78 3a                	js     802315 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022db:	83 ec 04             	sub    $0x4,%esp
  8022de:	68 07 04 00 00       	push   $0x407
  8022e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8022e6:	6a 00                	push   $0x0
  8022e8:	e8 6a eb ff ff       	call   800e57 <sys_page_alloc>
  8022ed:	83 c4 10             	add    $0x10,%esp
  8022f0:	85 c0                	test   %eax,%eax
  8022f2:	78 21                	js     802315 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8022f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f7:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022fd:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802302:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802309:	83 ec 0c             	sub    $0xc,%esp
  80230c:	50                   	push   %eax
  80230d:	e8 af ee ff ff       	call   8011c1 <fd2num>
  802312:	83 c4 10             	add    $0x10,%esp
}
  802315:	c9                   	leave  
  802316:	c3                   	ret    

00802317 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802317:	55                   	push   %ebp
  802318:	89 e5                	mov    %esp,%ebp
  80231a:	56                   	push   %esi
  80231b:	53                   	push   %ebx
  80231c:	8b 75 08             	mov    0x8(%ebp),%esi
  80231f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802322:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  802325:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802327:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80232c:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80232f:	83 ec 0c             	sub    $0xc,%esp
  802332:	50                   	push   %eax
  802333:	e8 cf ec ff ff       	call   801007 <sys_ipc_recv>
	if(ret < 0){
  802338:	83 c4 10             	add    $0x10,%esp
  80233b:	85 c0                	test   %eax,%eax
  80233d:	78 2b                	js     80236a <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80233f:	85 f6                	test   %esi,%esi
  802341:	74 0a                	je     80234d <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  802343:	a1 08 40 80 00       	mov    0x804008,%eax
  802348:	8b 40 74             	mov    0x74(%eax),%eax
  80234b:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80234d:	85 db                	test   %ebx,%ebx
  80234f:	74 0a                	je     80235b <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802351:	a1 08 40 80 00       	mov    0x804008,%eax
  802356:	8b 40 78             	mov    0x78(%eax),%eax
  802359:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  80235b:	a1 08 40 80 00       	mov    0x804008,%eax
  802360:	8b 40 70             	mov    0x70(%eax),%eax
}
  802363:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802366:	5b                   	pop    %ebx
  802367:	5e                   	pop    %esi
  802368:	5d                   	pop    %ebp
  802369:	c3                   	ret    
		if(from_env_store)
  80236a:	85 f6                	test   %esi,%esi
  80236c:	74 06                	je     802374 <ipc_recv+0x5d>
			*from_env_store = 0;
  80236e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802374:	85 db                	test   %ebx,%ebx
  802376:	74 eb                	je     802363 <ipc_recv+0x4c>
			*perm_store = 0;
  802378:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80237e:	eb e3                	jmp    802363 <ipc_recv+0x4c>

00802380 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
  802383:	57                   	push   %edi
  802384:	56                   	push   %esi
  802385:	53                   	push   %ebx
  802386:	83 ec 0c             	sub    $0xc,%esp
  802389:	8b 7d 08             	mov    0x8(%ebp),%edi
  80238c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80238f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802392:	85 db                	test   %ebx,%ebx
  802394:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802399:	0f 44 d8             	cmove  %eax,%ebx
  80239c:	eb 05                	jmp    8023a3 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80239e:	e8 95 ea ff ff       	call   800e38 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8023a3:	ff 75 14             	pushl  0x14(%ebp)
  8023a6:	53                   	push   %ebx
  8023a7:	56                   	push   %esi
  8023a8:	57                   	push   %edi
  8023a9:	e8 36 ec ff ff       	call   800fe4 <sys_ipc_try_send>
  8023ae:	83 c4 10             	add    $0x10,%esp
  8023b1:	85 c0                	test   %eax,%eax
  8023b3:	74 1b                	je     8023d0 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8023b5:	79 e7                	jns    80239e <ipc_send+0x1e>
  8023b7:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8023ba:	74 e2                	je     80239e <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8023bc:	83 ec 04             	sub    $0x4,%esp
  8023bf:	68 b7 2d 80 00       	push   $0x802db7
  8023c4:	6a 4a                	push   $0x4a
  8023c6:	68 cc 2d 80 00       	push   $0x802dcc
  8023cb:	e8 40 de ff ff       	call   800210 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8023d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023d3:	5b                   	pop    %ebx
  8023d4:	5e                   	pop    %esi
  8023d5:	5f                   	pop    %edi
  8023d6:	5d                   	pop    %ebp
  8023d7:	c3                   	ret    

008023d8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023d8:	55                   	push   %ebp
  8023d9:	89 e5                	mov    %esp,%ebp
  8023db:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8023de:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8023e3:	89 c2                	mov    %eax,%edx
  8023e5:	c1 e2 07             	shl    $0x7,%edx
  8023e8:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8023ee:	8b 52 50             	mov    0x50(%edx),%edx
  8023f1:	39 ca                	cmp    %ecx,%edx
  8023f3:	74 11                	je     802406 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8023f5:	83 c0 01             	add    $0x1,%eax
  8023f8:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023fd:	75 e4                	jne    8023e3 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8023ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802404:	eb 0b                	jmp    802411 <ipc_find_env+0x39>
			return envs[i].env_id;
  802406:	c1 e0 07             	shl    $0x7,%eax
  802409:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80240e:	8b 40 48             	mov    0x48(%eax),%eax
}
  802411:	5d                   	pop    %ebp
  802412:	c3                   	ret    

00802413 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802413:	55                   	push   %ebp
  802414:	89 e5                	mov    %esp,%ebp
  802416:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802419:	89 d0                	mov    %edx,%eax
  80241b:	c1 e8 16             	shr    $0x16,%eax
  80241e:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802425:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80242a:	f6 c1 01             	test   $0x1,%cl
  80242d:	74 1d                	je     80244c <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80242f:	c1 ea 0c             	shr    $0xc,%edx
  802432:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802439:	f6 c2 01             	test   $0x1,%dl
  80243c:	74 0e                	je     80244c <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80243e:	c1 ea 0c             	shr    $0xc,%edx
  802441:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802448:	ef 
  802449:	0f b7 c0             	movzwl %ax,%eax
}
  80244c:	5d                   	pop    %ebp
  80244d:	c3                   	ret    
  80244e:	66 90                	xchg   %ax,%ax

00802450 <__udivdi3>:
  802450:	55                   	push   %ebp
  802451:	57                   	push   %edi
  802452:	56                   	push   %esi
  802453:	53                   	push   %ebx
  802454:	83 ec 1c             	sub    $0x1c,%esp
  802457:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80245b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80245f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802463:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802467:	85 d2                	test   %edx,%edx
  802469:	75 4d                	jne    8024b8 <__udivdi3+0x68>
  80246b:	39 f3                	cmp    %esi,%ebx
  80246d:	76 19                	jbe    802488 <__udivdi3+0x38>
  80246f:	31 ff                	xor    %edi,%edi
  802471:	89 e8                	mov    %ebp,%eax
  802473:	89 f2                	mov    %esi,%edx
  802475:	f7 f3                	div    %ebx
  802477:	89 fa                	mov    %edi,%edx
  802479:	83 c4 1c             	add    $0x1c,%esp
  80247c:	5b                   	pop    %ebx
  80247d:	5e                   	pop    %esi
  80247e:	5f                   	pop    %edi
  80247f:	5d                   	pop    %ebp
  802480:	c3                   	ret    
  802481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802488:	89 d9                	mov    %ebx,%ecx
  80248a:	85 db                	test   %ebx,%ebx
  80248c:	75 0b                	jne    802499 <__udivdi3+0x49>
  80248e:	b8 01 00 00 00       	mov    $0x1,%eax
  802493:	31 d2                	xor    %edx,%edx
  802495:	f7 f3                	div    %ebx
  802497:	89 c1                	mov    %eax,%ecx
  802499:	31 d2                	xor    %edx,%edx
  80249b:	89 f0                	mov    %esi,%eax
  80249d:	f7 f1                	div    %ecx
  80249f:	89 c6                	mov    %eax,%esi
  8024a1:	89 e8                	mov    %ebp,%eax
  8024a3:	89 f7                	mov    %esi,%edi
  8024a5:	f7 f1                	div    %ecx
  8024a7:	89 fa                	mov    %edi,%edx
  8024a9:	83 c4 1c             	add    $0x1c,%esp
  8024ac:	5b                   	pop    %ebx
  8024ad:	5e                   	pop    %esi
  8024ae:	5f                   	pop    %edi
  8024af:	5d                   	pop    %ebp
  8024b0:	c3                   	ret    
  8024b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024b8:	39 f2                	cmp    %esi,%edx
  8024ba:	77 1c                	ja     8024d8 <__udivdi3+0x88>
  8024bc:	0f bd fa             	bsr    %edx,%edi
  8024bf:	83 f7 1f             	xor    $0x1f,%edi
  8024c2:	75 2c                	jne    8024f0 <__udivdi3+0xa0>
  8024c4:	39 f2                	cmp    %esi,%edx
  8024c6:	72 06                	jb     8024ce <__udivdi3+0x7e>
  8024c8:	31 c0                	xor    %eax,%eax
  8024ca:	39 eb                	cmp    %ebp,%ebx
  8024cc:	77 a9                	ja     802477 <__udivdi3+0x27>
  8024ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8024d3:	eb a2                	jmp    802477 <__udivdi3+0x27>
  8024d5:	8d 76 00             	lea    0x0(%esi),%esi
  8024d8:	31 ff                	xor    %edi,%edi
  8024da:	31 c0                	xor    %eax,%eax
  8024dc:	89 fa                	mov    %edi,%edx
  8024de:	83 c4 1c             	add    $0x1c,%esp
  8024e1:	5b                   	pop    %ebx
  8024e2:	5e                   	pop    %esi
  8024e3:	5f                   	pop    %edi
  8024e4:	5d                   	pop    %ebp
  8024e5:	c3                   	ret    
  8024e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024ed:	8d 76 00             	lea    0x0(%esi),%esi
  8024f0:	89 f9                	mov    %edi,%ecx
  8024f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8024f7:	29 f8                	sub    %edi,%eax
  8024f9:	d3 e2                	shl    %cl,%edx
  8024fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024ff:	89 c1                	mov    %eax,%ecx
  802501:	89 da                	mov    %ebx,%edx
  802503:	d3 ea                	shr    %cl,%edx
  802505:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802509:	09 d1                	or     %edx,%ecx
  80250b:	89 f2                	mov    %esi,%edx
  80250d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802511:	89 f9                	mov    %edi,%ecx
  802513:	d3 e3                	shl    %cl,%ebx
  802515:	89 c1                	mov    %eax,%ecx
  802517:	d3 ea                	shr    %cl,%edx
  802519:	89 f9                	mov    %edi,%ecx
  80251b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80251f:	89 eb                	mov    %ebp,%ebx
  802521:	d3 e6                	shl    %cl,%esi
  802523:	89 c1                	mov    %eax,%ecx
  802525:	d3 eb                	shr    %cl,%ebx
  802527:	09 de                	or     %ebx,%esi
  802529:	89 f0                	mov    %esi,%eax
  80252b:	f7 74 24 08          	divl   0x8(%esp)
  80252f:	89 d6                	mov    %edx,%esi
  802531:	89 c3                	mov    %eax,%ebx
  802533:	f7 64 24 0c          	mull   0xc(%esp)
  802537:	39 d6                	cmp    %edx,%esi
  802539:	72 15                	jb     802550 <__udivdi3+0x100>
  80253b:	89 f9                	mov    %edi,%ecx
  80253d:	d3 e5                	shl    %cl,%ebp
  80253f:	39 c5                	cmp    %eax,%ebp
  802541:	73 04                	jae    802547 <__udivdi3+0xf7>
  802543:	39 d6                	cmp    %edx,%esi
  802545:	74 09                	je     802550 <__udivdi3+0x100>
  802547:	89 d8                	mov    %ebx,%eax
  802549:	31 ff                	xor    %edi,%edi
  80254b:	e9 27 ff ff ff       	jmp    802477 <__udivdi3+0x27>
  802550:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802553:	31 ff                	xor    %edi,%edi
  802555:	e9 1d ff ff ff       	jmp    802477 <__udivdi3+0x27>
  80255a:	66 90                	xchg   %ax,%ax
  80255c:	66 90                	xchg   %ax,%ax
  80255e:	66 90                	xchg   %ax,%ax

00802560 <__umoddi3>:
  802560:	55                   	push   %ebp
  802561:	57                   	push   %edi
  802562:	56                   	push   %esi
  802563:	53                   	push   %ebx
  802564:	83 ec 1c             	sub    $0x1c,%esp
  802567:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80256b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80256f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802573:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802577:	89 da                	mov    %ebx,%edx
  802579:	85 c0                	test   %eax,%eax
  80257b:	75 43                	jne    8025c0 <__umoddi3+0x60>
  80257d:	39 df                	cmp    %ebx,%edi
  80257f:	76 17                	jbe    802598 <__umoddi3+0x38>
  802581:	89 f0                	mov    %esi,%eax
  802583:	f7 f7                	div    %edi
  802585:	89 d0                	mov    %edx,%eax
  802587:	31 d2                	xor    %edx,%edx
  802589:	83 c4 1c             	add    $0x1c,%esp
  80258c:	5b                   	pop    %ebx
  80258d:	5e                   	pop    %esi
  80258e:	5f                   	pop    %edi
  80258f:	5d                   	pop    %ebp
  802590:	c3                   	ret    
  802591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802598:	89 fd                	mov    %edi,%ebp
  80259a:	85 ff                	test   %edi,%edi
  80259c:	75 0b                	jne    8025a9 <__umoddi3+0x49>
  80259e:	b8 01 00 00 00       	mov    $0x1,%eax
  8025a3:	31 d2                	xor    %edx,%edx
  8025a5:	f7 f7                	div    %edi
  8025a7:	89 c5                	mov    %eax,%ebp
  8025a9:	89 d8                	mov    %ebx,%eax
  8025ab:	31 d2                	xor    %edx,%edx
  8025ad:	f7 f5                	div    %ebp
  8025af:	89 f0                	mov    %esi,%eax
  8025b1:	f7 f5                	div    %ebp
  8025b3:	89 d0                	mov    %edx,%eax
  8025b5:	eb d0                	jmp    802587 <__umoddi3+0x27>
  8025b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025be:	66 90                	xchg   %ax,%ax
  8025c0:	89 f1                	mov    %esi,%ecx
  8025c2:	39 d8                	cmp    %ebx,%eax
  8025c4:	76 0a                	jbe    8025d0 <__umoddi3+0x70>
  8025c6:	89 f0                	mov    %esi,%eax
  8025c8:	83 c4 1c             	add    $0x1c,%esp
  8025cb:	5b                   	pop    %ebx
  8025cc:	5e                   	pop    %esi
  8025cd:	5f                   	pop    %edi
  8025ce:	5d                   	pop    %ebp
  8025cf:	c3                   	ret    
  8025d0:	0f bd e8             	bsr    %eax,%ebp
  8025d3:	83 f5 1f             	xor    $0x1f,%ebp
  8025d6:	75 20                	jne    8025f8 <__umoddi3+0x98>
  8025d8:	39 d8                	cmp    %ebx,%eax
  8025da:	0f 82 b0 00 00 00    	jb     802690 <__umoddi3+0x130>
  8025e0:	39 f7                	cmp    %esi,%edi
  8025e2:	0f 86 a8 00 00 00    	jbe    802690 <__umoddi3+0x130>
  8025e8:	89 c8                	mov    %ecx,%eax
  8025ea:	83 c4 1c             	add    $0x1c,%esp
  8025ed:	5b                   	pop    %ebx
  8025ee:	5e                   	pop    %esi
  8025ef:	5f                   	pop    %edi
  8025f0:	5d                   	pop    %ebp
  8025f1:	c3                   	ret    
  8025f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025f8:	89 e9                	mov    %ebp,%ecx
  8025fa:	ba 20 00 00 00       	mov    $0x20,%edx
  8025ff:	29 ea                	sub    %ebp,%edx
  802601:	d3 e0                	shl    %cl,%eax
  802603:	89 44 24 08          	mov    %eax,0x8(%esp)
  802607:	89 d1                	mov    %edx,%ecx
  802609:	89 f8                	mov    %edi,%eax
  80260b:	d3 e8                	shr    %cl,%eax
  80260d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802611:	89 54 24 04          	mov    %edx,0x4(%esp)
  802615:	8b 54 24 04          	mov    0x4(%esp),%edx
  802619:	09 c1                	or     %eax,%ecx
  80261b:	89 d8                	mov    %ebx,%eax
  80261d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802621:	89 e9                	mov    %ebp,%ecx
  802623:	d3 e7                	shl    %cl,%edi
  802625:	89 d1                	mov    %edx,%ecx
  802627:	d3 e8                	shr    %cl,%eax
  802629:	89 e9                	mov    %ebp,%ecx
  80262b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80262f:	d3 e3                	shl    %cl,%ebx
  802631:	89 c7                	mov    %eax,%edi
  802633:	89 d1                	mov    %edx,%ecx
  802635:	89 f0                	mov    %esi,%eax
  802637:	d3 e8                	shr    %cl,%eax
  802639:	89 e9                	mov    %ebp,%ecx
  80263b:	89 fa                	mov    %edi,%edx
  80263d:	d3 e6                	shl    %cl,%esi
  80263f:	09 d8                	or     %ebx,%eax
  802641:	f7 74 24 08          	divl   0x8(%esp)
  802645:	89 d1                	mov    %edx,%ecx
  802647:	89 f3                	mov    %esi,%ebx
  802649:	f7 64 24 0c          	mull   0xc(%esp)
  80264d:	89 c6                	mov    %eax,%esi
  80264f:	89 d7                	mov    %edx,%edi
  802651:	39 d1                	cmp    %edx,%ecx
  802653:	72 06                	jb     80265b <__umoddi3+0xfb>
  802655:	75 10                	jne    802667 <__umoddi3+0x107>
  802657:	39 c3                	cmp    %eax,%ebx
  802659:	73 0c                	jae    802667 <__umoddi3+0x107>
  80265b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80265f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802663:	89 d7                	mov    %edx,%edi
  802665:	89 c6                	mov    %eax,%esi
  802667:	89 ca                	mov    %ecx,%edx
  802669:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80266e:	29 f3                	sub    %esi,%ebx
  802670:	19 fa                	sbb    %edi,%edx
  802672:	89 d0                	mov    %edx,%eax
  802674:	d3 e0                	shl    %cl,%eax
  802676:	89 e9                	mov    %ebp,%ecx
  802678:	d3 eb                	shr    %cl,%ebx
  80267a:	d3 ea                	shr    %cl,%edx
  80267c:	09 d8                	or     %ebx,%eax
  80267e:	83 c4 1c             	add    $0x1c,%esp
  802681:	5b                   	pop    %ebx
  802682:	5e                   	pop    %esi
  802683:	5f                   	pop    %edi
  802684:	5d                   	pop    %ebp
  802685:	c3                   	ret    
  802686:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80268d:	8d 76 00             	lea    0x0(%esi),%esi
  802690:	89 da                	mov    %ebx,%edx
  802692:	29 fe                	sub    %edi,%esi
  802694:	19 c2                	sbb    %eax,%edx
  802696:	89 f1                	mov    %esi,%ecx
  802698:	89 c8                	mov    %ecx,%eax
  80269a:	e9 4b ff ff ff       	jmp    8025ea <__umoddi3+0x8a>
