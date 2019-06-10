
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
  80003a:	68 e8 27 80 00       	push   $0x8027e8
  80003f:	68 c0 26 80 00       	push   $0x8026c0
  800044:	e8 bd 02 00 00       	call   800306 <cprintf>
	int r;
	void *addr = (void*)utf->utf_fault_va;
  800049:	8b 45 08             	mov    0x8(%ebp),%eax
  80004c:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  80004e:	83 c4 08             	add    $0x8,%esp
  800051:	53                   	push   %ebx
  800052:	68 a6 27 80 00       	push   $0x8027a6
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
  800078:	68 18 27 80 00       	push   $0x802718
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
  800092:	68 ec 26 80 00       	push   $0x8026ec
  800097:	6a 10                	push   $0x10
  800099:	68 b0 27 80 00       	push   $0x8027b0
  80009e:	e8 6d 01 00 00       	call   800210 <_panic>

008000a3 <umain>:

void
umain(int argc, char **argv)
{
  8000a3:	55                   	push   %ebp
  8000a4:	89 e5                	mov    %esp,%ebp
  8000a6:	83 ec 14             	sub    $0x14,%esp
	cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8000a9:	68 3c 27 80 00       	push   $0x80273c
  8000ae:	e8 53 02 00 00       	call   800306 <cprintf>
	cprintf("before set_pgfault_handler() in %s\n", __FUNCTION__);
  8000b3:	83 c4 08             	add    $0x8,%esp
  8000b6:	68 e0 27 80 00       	push   $0x8027e0
  8000bb:	68 60 27 80 00       	push   $0x802760
  8000c0:	e8 41 02 00 00       	call   800306 <cprintf>
	set_pgfault_handler(handler);
  8000c5:	c7 04 24 33 00 80 00 	movl   $0x800033,(%esp)
  8000cc:	e8 7b 10 00 00       	call   80114c <set_pgfault_handler>
	cprintf(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
  8000d1:	c7 04 24 84 27 80 00 	movl   $0x802784,(%esp)
  8000d8:	e8 29 02 00 00       	call   800306 <cprintf>
	cprintf("before sys_cputs() in %s\n", __FUNCTION__);
  8000dd:	83 c4 08             	add    $0x8,%esp
  8000e0:	68 e0 27 80 00       	push   $0x8027e0
  8000e5:	68 c5 27 80 00       	push   $0x8027c5
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
  800186:	68 f0 27 80 00       	push   $0x8027f0
  80018b:	e8 76 01 00 00       	call   800306 <cprintf>
	cprintf("before umain\n");
  800190:	c7 04 24 0e 28 80 00 	movl   $0x80280e,(%esp)
  800197:	e8 6a 01 00 00       	call   800306 <cprintf>
	// call user main routine
	umain(argc, argv);
  80019c:	83 c4 08             	add    $0x8,%esp
  80019f:	ff 75 0c             	pushl  0xc(%ebp)
  8001a2:	ff 75 08             	pushl  0x8(%ebp)
  8001a5:	e8 f9 fe ff ff       	call   8000a3 <umain>
	cprintf("after umain\n");
  8001aa:	c7 04 24 1c 28 80 00 	movl   $0x80281c,(%esp)
  8001b1:	e8 50 01 00 00       	call   800306 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8001b6:	a1 08 40 80 00       	mov    0x804008,%eax
  8001bb:	8b 40 48             	mov    0x48(%eax),%eax
  8001be:	83 c4 08             	add    $0x8,%esp
  8001c1:	50                   	push   %eax
  8001c2:	68 29 28 80 00       	push   $0x802829
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
  8001ea:	68 54 28 80 00       	push   $0x802854
  8001ef:	50                   	push   %eax
  8001f0:	68 48 28 80 00       	push   $0x802848
  8001f5:	e8 0c 01 00 00       	call   800306 <cprintf>
	close_all();
  8001fa:	e8 ba 11 00 00       	call   8013b9 <close_all>
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
  800220:	68 80 28 80 00       	push   $0x802880
  800225:	50                   	push   %eax
  800226:	68 48 28 80 00       	push   $0x802848
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
  800249:	68 5c 28 80 00       	push   $0x80285c
  80024e:	e8 b3 00 00 00       	call   800306 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800253:	83 c4 18             	add    $0x18,%esp
  800256:	53                   	push   %ebx
  800257:	ff 75 10             	pushl  0x10(%ebp)
  80025a:	e8 56 00 00 00       	call   8002b5 <vcprintf>
	cprintf("\n");
  80025f:	c7 04 24 0c 28 80 00 	movl   $0x80280c,(%esp)
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
  8003b3:	e8 b8 20 00 00       	call   802470 <__udivdi3>
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
  8003dc:	e8 9f 21 00 00       	call   802580 <__umoddi3>
  8003e1:	83 c4 14             	add    $0x14,%esp
  8003e4:	0f be 80 87 28 80 00 	movsbl 0x802887(%eax),%eax
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
  80048d:	ff 24 85 60 2a 80 00 	jmp    *0x802a60(,%eax,4)
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
  800558:	8b 14 85 c0 2b 80 00 	mov    0x802bc0(,%eax,4),%edx
  80055f:	85 d2                	test   %edx,%edx
  800561:	74 18                	je     80057b <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800563:	52                   	push   %edx
  800564:	68 59 2d 80 00       	push   $0x802d59
  800569:	53                   	push   %ebx
  80056a:	56                   	push   %esi
  80056b:	e8 a6 fe ff ff       	call   800416 <printfmt>
  800570:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800573:	89 7d 14             	mov    %edi,0x14(%ebp)
  800576:	e9 fe 02 00 00       	jmp    800879 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80057b:	50                   	push   %eax
  80057c:	68 9f 28 80 00       	push   $0x80289f
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
  8005a3:	b8 98 28 80 00       	mov    $0x802898,%eax
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
  80093b:	bf bd 29 80 00       	mov    $0x8029bd,%edi
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
  800967:	bf f5 29 80 00       	mov    $0x8029f5,%edi
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
  800e08:	68 08 2c 80 00       	push   $0x802c08
  800e0d:	6a 43                	push   $0x43
  800e0f:	68 25 2c 80 00       	push   $0x802c25
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
  800e89:	68 08 2c 80 00       	push   $0x802c08
  800e8e:	6a 43                	push   $0x43
  800e90:	68 25 2c 80 00       	push   $0x802c25
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
  800ecb:	68 08 2c 80 00       	push   $0x802c08
  800ed0:	6a 43                	push   $0x43
  800ed2:	68 25 2c 80 00       	push   $0x802c25
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
  800f0d:	68 08 2c 80 00       	push   $0x802c08
  800f12:	6a 43                	push   $0x43
  800f14:	68 25 2c 80 00       	push   $0x802c25
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
  800f4f:	68 08 2c 80 00       	push   $0x802c08
  800f54:	6a 43                	push   $0x43
  800f56:	68 25 2c 80 00       	push   $0x802c25
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
  800f91:	68 08 2c 80 00       	push   $0x802c08
  800f96:	6a 43                	push   $0x43
  800f98:	68 25 2c 80 00       	push   $0x802c25
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
  800fd3:	68 08 2c 80 00       	push   $0x802c08
  800fd8:	6a 43                	push   $0x43
  800fda:	68 25 2c 80 00       	push   $0x802c25
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
  801037:	68 08 2c 80 00       	push   $0x802c08
  80103c:	6a 43                	push   $0x43
  80103e:	68 25 2c 80 00       	push   $0x802c25
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
  80111b:	68 08 2c 80 00       	push   $0x802c08
  801120:	6a 43                	push   $0x43
  801122:	68 25 2c 80 00       	push   $0x802c25
  801127:	e8 e4 f0 ff ff       	call   800210 <_panic>

0080112c <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80112c:	55                   	push   %ebp
  80112d:	89 e5                	mov    %esp,%ebp
  80112f:	57                   	push   %edi
  801130:	56                   	push   %esi
  801131:	53                   	push   %ebx
	asm volatile("int %1\n"
  801132:	b9 00 00 00 00       	mov    $0x0,%ecx
  801137:	8b 55 08             	mov    0x8(%ebp),%edx
  80113a:	b8 14 00 00 00       	mov    $0x14,%eax
  80113f:	89 cb                	mov    %ecx,%ebx
  801141:	89 cf                	mov    %ecx,%edi
  801143:	89 ce                	mov    %ecx,%esi
  801145:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801147:	5b                   	pop    %ebx
  801148:	5e                   	pop    %esi
  801149:	5f                   	pop    %edi
  80114a:	5d                   	pop    %ebp
  80114b:	c3                   	ret    

0080114c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801152:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  801159:	74 0a                	je     801165 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  801163:	c9                   	leave  
  801164:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  801165:	83 ec 04             	sub    $0x4,%esp
  801168:	6a 07                	push   $0x7
  80116a:	68 00 f0 bf ee       	push   $0xeebff000
  80116f:	6a 00                	push   $0x0
  801171:	e8 e1 fc ff ff       	call   800e57 <sys_page_alloc>
		if(r < 0)
  801176:	83 c4 10             	add    $0x10,%esp
  801179:	85 c0                	test   %eax,%eax
  80117b:	78 2a                	js     8011a7 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80117d:	83 ec 08             	sub    $0x8,%esp
  801180:	68 bb 11 80 00       	push   $0x8011bb
  801185:	6a 00                	push   $0x0
  801187:	e8 16 fe ff ff       	call   800fa2 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80118c:	83 c4 10             	add    $0x10,%esp
  80118f:	85 c0                	test   %eax,%eax
  801191:	79 c8                	jns    80115b <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  801193:	83 ec 04             	sub    $0x4,%esp
  801196:	68 64 2c 80 00       	push   $0x802c64
  80119b:	6a 25                	push   $0x25
  80119d:	68 9d 2c 80 00       	push   $0x802c9d
  8011a2:	e8 69 f0 ff ff       	call   800210 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8011a7:	83 ec 04             	sub    $0x4,%esp
  8011aa:	68 34 2c 80 00       	push   $0x802c34
  8011af:	6a 22                	push   $0x22
  8011b1:	68 9d 2c 80 00       	push   $0x802c9d
  8011b6:	e8 55 f0 ff ff       	call   800210 <_panic>

008011bb <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8011bb:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8011bc:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  8011c1:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8011c3:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8011c6:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8011ca:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8011ce:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8011d1:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8011d3:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8011d7:	83 c4 08             	add    $0x8,%esp
	popal
  8011da:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8011db:	83 c4 04             	add    $0x4,%esp
	popfl
  8011de:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8011df:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8011e0:	c3                   	ret    

008011e1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	05 00 00 00 30       	add    $0x30000000,%eax
  8011ec:	c1 e8 0c             	shr    $0xc,%eax
}
  8011ef:	5d                   	pop    %ebp
  8011f0:	c3                   	ret    

008011f1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801201:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801206:	5d                   	pop    %ebp
  801207:	c3                   	ret    

00801208 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801208:	55                   	push   %ebp
  801209:	89 e5                	mov    %esp,%ebp
  80120b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801210:	89 c2                	mov    %eax,%edx
  801212:	c1 ea 16             	shr    $0x16,%edx
  801215:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80121c:	f6 c2 01             	test   $0x1,%dl
  80121f:	74 2d                	je     80124e <fd_alloc+0x46>
  801221:	89 c2                	mov    %eax,%edx
  801223:	c1 ea 0c             	shr    $0xc,%edx
  801226:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80122d:	f6 c2 01             	test   $0x1,%dl
  801230:	74 1c                	je     80124e <fd_alloc+0x46>
  801232:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801237:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80123c:	75 d2                	jne    801210 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801247:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80124c:	eb 0a                	jmp    801258 <fd_alloc+0x50>
			*fd_store = fd;
  80124e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801251:	89 01                	mov    %eax,(%ecx)
			return 0;
  801253:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801258:	5d                   	pop    %ebp
  801259:	c3                   	ret    

0080125a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801260:	83 f8 1f             	cmp    $0x1f,%eax
  801263:	77 30                	ja     801295 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801265:	c1 e0 0c             	shl    $0xc,%eax
  801268:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80126d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801273:	f6 c2 01             	test   $0x1,%dl
  801276:	74 24                	je     80129c <fd_lookup+0x42>
  801278:	89 c2                	mov    %eax,%edx
  80127a:	c1 ea 0c             	shr    $0xc,%edx
  80127d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801284:	f6 c2 01             	test   $0x1,%dl
  801287:	74 1a                	je     8012a3 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801289:	8b 55 0c             	mov    0xc(%ebp),%edx
  80128c:	89 02                	mov    %eax,(%edx)
	return 0;
  80128e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801293:	5d                   	pop    %ebp
  801294:	c3                   	ret    
		return -E_INVAL;
  801295:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80129a:	eb f7                	jmp    801293 <fd_lookup+0x39>
		return -E_INVAL;
  80129c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012a1:	eb f0                	jmp    801293 <fd_lookup+0x39>
  8012a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012a8:	eb e9                	jmp    801293 <fd_lookup+0x39>

008012aa <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	83 ec 08             	sub    $0x8,%esp
  8012b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8012b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8012b8:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012bd:	39 08                	cmp    %ecx,(%eax)
  8012bf:	74 38                	je     8012f9 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8012c1:	83 c2 01             	add    $0x1,%edx
  8012c4:	8b 04 95 2c 2d 80 00 	mov    0x802d2c(,%edx,4),%eax
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	75 ee                	jne    8012bd <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012cf:	a1 08 40 80 00       	mov    0x804008,%eax
  8012d4:	8b 40 48             	mov    0x48(%eax),%eax
  8012d7:	83 ec 04             	sub    $0x4,%esp
  8012da:	51                   	push   %ecx
  8012db:	50                   	push   %eax
  8012dc:	68 ac 2c 80 00       	push   $0x802cac
  8012e1:	e8 20 f0 ff ff       	call   800306 <cprintf>
	*dev = 0;
  8012e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012ef:	83 c4 10             	add    $0x10,%esp
  8012f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012f7:	c9                   	leave  
  8012f8:	c3                   	ret    
			*dev = devtab[i];
  8012f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012fc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801303:	eb f2                	jmp    8012f7 <dev_lookup+0x4d>

00801305 <fd_close>:
{
  801305:	55                   	push   %ebp
  801306:	89 e5                	mov    %esp,%ebp
  801308:	57                   	push   %edi
  801309:	56                   	push   %esi
  80130a:	53                   	push   %ebx
  80130b:	83 ec 24             	sub    $0x24,%esp
  80130e:	8b 75 08             	mov    0x8(%ebp),%esi
  801311:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801314:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801317:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801318:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80131e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801321:	50                   	push   %eax
  801322:	e8 33 ff ff ff       	call   80125a <fd_lookup>
  801327:	89 c3                	mov    %eax,%ebx
  801329:	83 c4 10             	add    $0x10,%esp
  80132c:	85 c0                	test   %eax,%eax
  80132e:	78 05                	js     801335 <fd_close+0x30>
	    || fd != fd2)
  801330:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801333:	74 16                	je     80134b <fd_close+0x46>
		return (must_exist ? r : 0);
  801335:	89 f8                	mov    %edi,%eax
  801337:	84 c0                	test   %al,%al
  801339:	b8 00 00 00 00       	mov    $0x0,%eax
  80133e:	0f 44 d8             	cmove  %eax,%ebx
}
  801341:	89 d8                	mov    %ebx,%eax
  801343:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801346:	5b                   	pop    %ebx
  801347:	5e                   	pop    %esi
  801348:	5f                   	pop    %edi
  801349:	5d                   	pop    %ebp
  80134a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80134b:	83 ec 08             	sub    $0x8,%esp
  80134e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801351:	50                   	push   %eax
  801352:	ff 36                	pushl  (%esi)
  801354:	e8 51 ff ff ff       	call   8012aa <dev_lookup>
  801359:	89 c3                	mov    %eax,%ebx
  80135b:	83 c4 10             	add    $0x10,%esp
  80135e:	85 c0                	test   %eax,%eax
  801360:	78 1a                	js     80137c <fd_close+0x77>
		if (dev->dev_close)
  801362:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801365:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801368:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80136d:	85 c0                	test   %eax,%eax
  80136f:	74 0b                	je     80137c <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801371:	83 ec 0c             	sub    $0xc,%esp
  801374:	56                   	push   %esi
  801375:	ff d0                	call   *%eax
  801377:	89 c3                	mov    %eax,%ebx
  801379:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80137c:	83 ec 08             	sub    $0x8,%esp
  80137f:	56                   	push   %esi
  801380:	6a 00                	push   $0x0
  801382:	e8 55 fb ff ff       	call   800edc <sys_page_unmap>
	return r;
  801387:	83 c4 10             	add    $0x10,%esp
  80138a:	eb b5                	jmp    801341 <fd_close+0x3c>

0080138c <close>:

int
close(int fdnum)
{
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
  80138f:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801392:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801395:	50                   	push   %eax
  801396:	ff 75 08             	pushl  0x8(%ebp)
  801399:	e8 bc fe ff ff       	call   80125a <fd_lookup>
  80139e:	83 c4 10             	add    $0x10,%esp
  8013a1:	85 c0                	test   %eax,%eax
  8013a3:	79 02                	jns    8013a7 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8013a5:	c9                   	leave  
  8013a6:	c3                   	ret    
		return fd_close(fd, 1);
  8013a7:	83 ec 08             	sub    $0x8,%esp
  8013aa:	6a 01                	push   $0x1
  8013ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8013af:	e8 51 ff ff ff       	call   801305 <fd_close>
  8013b4:	83 c4 10             	add    $0x10,%esp
  8013b7:	eb ec                	jmp    8013a5 <close+0x19>

008013b9 <close_all>:

void
close_all(void)
{
  8013b9:	55                   	push   %ebp
  8013ba:	89 e5                	mov    %esp,%ebp
  8013bc:	53                   	push   %ebx
  8013bd:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013c0:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013c5:	83 ec 0c             	sub    $0xc,%esp
  8013c8:	53                   	push   %ebx
  8013c9:	e8 be ff ff ff       	call   80138c <close>
	for (i = 0; i < MAXFD; i++)
  8013ce:	83 c3 01             	add    $0x1,%ebx
  8013d1:	83 c4 10             	add    $0x10,%esp
  8013d4:	83 fb 20             	cmp    $0x20,%ebx
  8013d7:	75 ec                	jne    8013c5 <close_all+0xc>
}
  8013d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013dc:	c9                   	leave  
  8013dd:	c3                   	ret    

008013de <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013de:	55                   	push   %ebp
  8013df:	89 e5                	mov    %esp,%ebp
  8013e1:	57                   	push   %edi
  8013e2:	56                   	push   %esi
  8013e3:	53                   	push   %ebx
  8013e4:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013e7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013ea:	50                   	push   %eax
  8013eb:	ff 75 08             	pushl  0x8(%ebp)
  8013ee:	e8 67 fe ff ff       	call   80125a <fd_lookup>
  8013f3:	89 c3                	mov    %eax,%ebx
  8013f5:	83 c4 10             	add    $0x10,%esp
  8013f8:	85 c0                	test   %eax,%eax
  8013fa:	0f 88 81 00 00 00    	js     801481 <dup+0xa3>
		return r;
	close(newfdnum);
  801400:	83 ec 0c             	sub    $0xc,%esp
  801403:	ff 75 0c             	pushl  0xc(%ebp)
  801406:	e8 81 ff ff ff       	call   80138c <close>

	newfd = INDEX2FD(newfdnum);
  80140b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80140e:	c1 e6 0c             	shl    $0xc,%esi
  801411:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801417:	83 c4 04             	add    $0x4,%esp
  80141a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80141d:	e8 cf fd ff ff       	call   8011f1 <fd2data>
  801422:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801424:	89 34 24             	mov    %esi,(%esp)
  801427:	e8 c5 fd ff ff       	call   8011f1 <fd2data>
  80142c:	83 c4 10             	add    $0x10,%esp
  80142f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801431:	89 d8                	mov    %ebx,%eax
  801433:	c1 e8 16             	shr    $0x16,%eax
  801436:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80143d:	a8 01                	test   $0x1,%al
  80143f:	74 11                	je     801452 <dup+0x74>
  801441:	89 d8                	mov    %ebx,%eax
  801443:	c1 e8 0c             	shr    $0xc,%eax
  801446:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80144d:	f6 c2 01             	test   $0x1,%dl
  801450:	75 39                	jne    80148b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801452:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801455:	89 d0                	mov    %edx,%eax
  801457:	c1 e8 0c             	shr    $0xc,%eax
  80145a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801461:	83 ec 0c             	sub    $0xc,%esp
  801464:	25 07 0e 00 00       	and    $0xe07,%eax
  801469:	50                   	push   %eax
  80146a:	56                   	push   %esi
  80146b:	6a 00                	push   $0x0
  80146d:	52                   	push   %edx
  80146e:	6a 00                	push   $0x0
  801470:	e8 25 fa ff ff       	call   800e9a <sys_page_map>
  801475:	89 c3                	mov    %eax,%ebx
  801477:	83 c4 20             	add    $0x20,%esp
  80147a:	85 c0                	test   %eax,%eax
  80147c:	78 31                	js     8014af <dup+0xd1>
		goto err;

	return newfdnum;
  80147e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801481:	89 d8                	mov    %ebx,%eax
  801483:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801486:	5b                   	pop    %ebx
  801487:	5e                   	pop    %esi
  801488:	5f                   	pop    %edi
  801489:	5d                   	pop    %ebp
  80148a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80148b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801492:	83 ec 0c             	sub    $0xc,%esp
  801495:	25 07 0e 00 00       	and    $0xe07,%eax
  80149a:	50                   	push   %eax
  80149b:	57                   	push   %edi
  80149c:	6a 00                	push   $0x0
  80149e:	53                   	push   %ebx
  80149f:	6a 00                	push   $0x0
  8014a1:	e8 f4 f9 ff ff       	call   800e9a <sys_page_map>
  8014a6:	89 c3                	mov    %eax,%ebx
  8014a8:	83 c4 20             	add    $0x20,%esp
  8014ab:	85 c0                	test   %eax,%eax
  8014ad:	79 a3                	jns    801452 <dup+0x74>
	sys_page_unmap(0, newfd);
  8014af:	83 ec 08             	sub    $0x8,%esp
  8014b2:	56                   	push   %esi
  8014b3:	6a 00                	push   $0x0
  8014b5:	e8 22 fa ff ff       	call   800edc <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014ba:	83 c4 08             	add    $0x8,%esp
  8014bd:	57                   	push   %edi
  8014be:	6a 00                	push   $0x0
  8014c0:	e8 17 fa ff ff       	call   800edc <sys_page_unmap>
	return r;
  8014c5:	83 c4 10             	add    $0x10,%esp
  8014c8:	eb b7                	jmp    801481 <dup+0xa3>

008014ca <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
  8014cd:	53                   	push   %ebx
  8014ce:	83 ec 1c             	sub    $0x1c,%esp
  8014d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014d7:	50                   	push   %eax
  8014d8:	53                   	push   %ebx
  8014d9:	e8 7c fd ff ff       	call   80125a <fd_lookup>
  8014de:	83 c4 10             	add    $0x10,%esp
  8014e1:	85 c0                	test   %eax,%eax
  8014e3:	78 3f                	js     801524 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014e5:	83 ec 08             	sub    $0x8,%esp
  8014e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014eb:	50                   	push   %eax
  8014ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ef:	ff 30                	pushl  (%eax)
  8014f1:	e8 b4 fd ff ff       	call   8012aa <dev_lookup>
  8014f6:	83 c4 10             	add    $0x10,%esp
  8014f9:	85 c0                	test   %eax,%eax
  8014fb:	78 27                	js     801524 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801500:	8b 42 08             	mov    0x8(%edx),%eax
  801503:	83 e0 03             	and    $0x3,%eax
  801506:	83 f8 01             	cmp    $0x1,%eax
  801509:	74 1e                	je     801529 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80150b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80150e:	8b 40 08             	mov    0x8(%eax),%eax
  801511:	85 c0                	test   %eax,%eax
  801513:	74 35                	je     80154a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801515:	83 ec 04             	sub    $0x4,%esp
  801518:	ff 75 10             	pushl  0x10(%ebp)
  80151b:	ff 75 0c             	pushl  0xc(%ebp)
  80151e:	52                   	push   %edx
  80151f:	ff d0                	call   *%eax
  801521:	83 c4 10             	add    $0x10,%esp
}
  801524:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801527:	c9                   	leave  
  801528:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801529:	a1 08 40 80 00       	mov    0x804008,%eax
  80152e:	8b 40 48             	mov    0x48(%eax),%eax
  801531:	83 ec 04             	sub    $0x4,%esp
  801534:	53                   	push   %ebx
  801535:	50                   	push   %eax
  801536:	68 f0 2c 80 00       	push   $0x802cf0
  80153b:	e8 c6 ed ff ff       	call   800306 <cprintf>
		return -E_INVAL;
  801540:	83 c4 10             	add    $0x10,%esp
  801543:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801548:	eb da                	jmp    801524 <read+0x5a>
		return -E_NOT_SUPP;
  80154a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80154f:	eb d3                	jmp    801524 <read+0x5a>

00801551 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801551:	55                   	push   %ebp
  801552:	89 e5                	mov    %esp,%ebp
  801554:	57                   	push   %edi
  801555:	56                   	push   %esi
  801556:	53                   	push   %ebx
  801557:	83 ec 0c             	sub    $0xc,%esp
  80155a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80155d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801560:	bb 00 00 00 00       	mov    $0x0,%ebx
  801565:	39 f3                	cmp    %esi,%ebx
  801567:	73 23                	jae    80158c <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801569:	83 ec 04             	sub    $0x4,%esp
  80156c:	89 f0                	mov    %esi,%eax
  80156e:	29 d8                	sub    %ebx,%eax
  801570:	50                   	push   %eax
  801571:	89 d8                	mov    %ebx,%eax
  801573:	03 45 0c             	add    0xc(%ebp),%eax
  801576:	50                   	push   %eax
  801577:	57                   	push   %edi
  801578:	e8 4d ff ff ff       	call   8014ca <read>
		if (m < 0)
  80157d:	83 c4 10             	add    $0x10,%esp
  801580:	85 c0                	test   %eax,%eax
  801582:	78 06                	js     80158a <readn+0x39>
			return m;
		if (m == 0)
  801584:	74 06                	je     80158c <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801586:	01 c3                	add    %eax,%ebx
  801588:	eb db                	jmp    801565 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80158a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80158c:	89 d8                	mov    %ebx,%eax
  80158e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801591:	5b                   	pop    %ebx
  801592:	5e                   	pop    %esi
  801593:	5f                   	pop    %edi
  801594:	5d                   	pop    %ebp
  801595:	c3                   	ret    

00801596 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	53                   	push   %ebx
  80159a:	83 ec 1c             	sub    $0x1c,%esp
  80159d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015a3:	50                   	push   %eax
  8015a4:	53                   	push   %ebx
  8015a5:	e8 b0 fc ff ff       	call   80125a <fd_lookup>
  8015aa:	83 c4 10             	add    $0x10,%esp
  8015ad:	85 c0                	test   %eax,%eax
  8015af:	78 3a                	js     8015eb <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015b1:	83 ec 08             	sub    $0x8,%esp
  8015b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b7:	50                   	push   %eax
  8015b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015bb:	ff 30                	pushl  (%eax)
  8015bd:	e8 e8 fc ff ff       	call   8012aa <dev_lookup>
  8015c2:	83 c4 10             	add    $0x10,%esp
  8015c5:	85 c0                	test   %eax,%eax
  8015c7:	78 22                	js     8015eb <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015d0:	74 1e                	je     8015f0 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d5:	8b 52 0c             	mov    0xc(%edx),%edx
  8015d8:	85 d2                	test   %edx,%edx
  8015da:	74 35                	je     801611 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015dc:	83 ec 04             	sub    $0x4,%esp
  8015df:	ff 75 10             	pushl  0x10(%ebp)
  8015e2:	ff 75 0c             	pushl  0xc(%ebp)
  8015e5:	50                   	push   %eax
  8015e6:	ff d2                	call   *%edx
  8015e8:	83 c4 10             	add    $0x10,%esp
}
  8015eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015f0:	a1 08 40 80 00       	mov    0x804008,%eax
  8015f5:	8b 40 48             	mov    0x48(%eax),%eax
  8015f8:	83 ec 04             	sub    $0x4,%esp
  8015fb:	53                   	push   %ebx
  8015fc:	50                   	push   %eax
  8015fd:	68 0c 2d 80 00       	push   $0x802d0c
  801602:	e8 ff ec ff ff       	call   800306 <cprintf>
		return -E_INVAL;
  801607:	83 c4 10             	add    $0x10,%esp
  80160a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80160f:	eb da                	jmp    8015eb <write+0x55>
		return -E_NOT_SUPP;
  801611:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801616:	eb d3                	jmp    8015eb <write+0x55>

00801618 <seek>:

int
seek(int fdnum, off_t offset)
{
  801618:	55                   	push   %ebp
  801619:	89 e5                	mov    %esp,%ebp
  80161b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80161e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801621:	50                   	push   %eax
  801622:	ff 75 08             	pushl  0x8(%ebp)
  801625:	e8 30 fc ff ff       	call   80125a <fd_lookup>
  80162a:	83 c4 10             	add    $0x10,%esp
  80162d:	85 c0                	test   %eax,%eax
  80162f:	78 0e                	js     80163f <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801631:	8b 55 0c             	mov    0xc(%ebp),%edx
  801634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801637:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80163a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80163f:	c9                   	leave  
  801640:	c3                   	ret    

00801641 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
  801644:	53                   	push   %ebx
  801645:	83 ec 1c             	sub    $0x1c,%esp
  801648:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80164b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80164e:	50                   	push   %eax
  80164f:	53                   	push   %ebx
  801650:	e8 05 fc ff ff       	call   80125a <fd_lookup>
  801655:	83 c4 10             	add    $0x10,%esp
  801658:	85 c0                	test   %eax,%eax
  80165a:	78 37                	js     801693 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80165c:	83 ec 08             	sub    $0x8,%esp
  80165f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801662:	50                   	push   %eax
  801663:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801666:	ff 30                	pushl  (%eax)
  801668:	e8 3d fc ff ff       	call   8012aa <dev_lookup>
  80166d:	83 c4 10             	add    $0x10,%esp
  801670:	85 c0                	test   %eax,%eax
  801672:	78 1f                	js     801693 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801674:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801677:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80167b:	74 1b                	je     801698 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80167d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801680:	8b 52 18             	mov    0x18(%edx),%edx
  801683:	85 d2                	test   %edx,%edx
  801685:	74 32                	je     8016b9 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801687:	83 ec 08             	sub    $0x8,%esp
  80168a:	ff 75 0c             	pushl  0xc(%ebp)
  80168d:	50                   	push   %eax
  80168e:	ff d2                	call   *%edx
  801690:	83 c4 10             	add    $0x10,%esp
}
  801693:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801696:	c9                   	leave  
  801697:	c3                   	ret    
			thisenv->env_id, fdnum);
  801698:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80169d:	8b 40 48             	mov    0x48(%eax),%eax
  8016a0:	83 ec 04             	sub    $0x4,%esp
  8016a3:	53                   	push   %ebx
  8016a4:	50                   	push   %eax
  8016a5:	68 cc 2c 80 00       	push   $0x802ccc
  8016aa:	e8 57 ec ff ff       	call   800306 <cprintf>
		return -E_INVAL;
  8016af:	83 c4 10             	add    $0x10,%esp
  8016b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016b7:	eb da                	jmp    801693 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8016b9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016be:	eb d3                	jmp    801693 <ftruncate+0x52>

008016c0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	53                   	push   %ebx
  8016c4:	83 ec 1c             	sub    $0x1c,%esp
  8016c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016cd:	50                   	push   %eax
  8016ce:	ff 75 08             	pushl  0x8(%ebp)
  8016d1:	e8 84 fb ff ff       	call   80125a <fd_lookup>
  8016d6:	83 c4 10             	add    $0x10,%esp
  8016d9:	85 c0                	test   %eax,%eax
  8016db:	78 4b                	js     801728 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016dd:	83 ec 08             	sub    $0x8,%esp
  8016e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016e3:	50                   	push   %eax
  8016e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e7:	ff 30                	pushl  (%eax)
  8016e9:	e8 bc fb ff ff       	call   8012aa <dev_lookup>
  8016ee:	83 c4 10             	add    $0x10,%esp
  8016f1:	85 c0                	test   %eax,%eax
  8016f3:	78 33                	js     801728 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8016f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f8:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016fc:	74 2f                	je     80172d <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016fe:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801701:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801708:	00 00 00 
	stat->st_isdir = 0;
  80170b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801712:	00 00 00 
	stat->st_dev = dev;
  801715:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80171b:	83 ec 08             	sub    $0x8,%esp
  80171e:	53                   	push   %ebx
  80171f:	ff 75 f0             	pushl  -0x10(%ebp)
  801722:	ff 50 14             	call   *0x14(%eax)
  801725:	83 c4 10             	add    $0x10,%esp
}
  801728:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    
		return -E_NOT_SUPP;
  80172d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801732:	eb f4                	jmp    801728 <fstat+0x68>

00801734 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
  801737:	56                   	push   %esi
  801738:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801739:	83 ec 08             	sub    $0x8,%esp
  80173c:	6a 00                	push   $0x0
  80173e:	ff 75 08             	pushl  0x8(%ebp)
  801741:	e8 22 02 00 00       	call   801968 <open>
  801746:	89 c3                	mov    %eax,%ebx
  801748:	83 c4 10             	add    $0x10,%esp
  80174b:	85 c0                	test   %eax,%eax
  80174d:	78 1b                	js     80176a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80174f:	83 ec 08             	sub    $0x8,%esp
  801752:	ff 75 0c             	pushl  0xc(%ebp)
  801755:	50                   	push   %eax
  801756:	e8 65 ff ff ff       	call   8016c0 <fstat>
  80175b:	89 c6                	mov    %eax,%esi
	close(fd);
  80175d:	89 1c 24             	mov    %ebx,(%esp)
  801760:	e8 27 fc ff ff       	call   80138c <close>
	return r;
  801765:	83 c4 10             	add    $0x10,%esp
  801768:	89 f3                	mov    %esi,%ebx
}
  80176a:	89 d8                	mov    %ebx,%eax
  80176c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80176f:	5b                   	pop    %ebx
  801770:	5e                   	pop    %esi
  801771:	5d                   	pop    %ebp
  801772:	c3                   	ret    

00801773 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	56                   	push   %esi
  801777:	53                   	push   %ebx
  801778:	89 c6                	mov    %eax,%esi
  80177a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80177c:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801783:	74 27                	je     8017ac <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801785:	6a 07                	push   $0x7
  801787:	68 00 50 80 00       	push   $0x805000
  80178c:	56                   	push   %esi
  80178d:	ff 35 00 40 80 00    	pushl  0x804000
  801793:	e8 08 0c 00 00       	call   8023a0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801798:	83 c4 0c             	add    $0xc,%esp
  80179b:	6a 00                	push   $0x0
  80179d:	53                   	push   %ebx
  80179e:	6a 00                	push   $0x0
  8017a0:	e8 92 0b 00 00       	call   802337 <ipc_recv>
}
  8017a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017a8:	5b                   	pop    %ebx
  8017a9:	5e                   	pop    %esi
  8017aa:	5d                   	pop    %ebp
  8017ab:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017ac:	83 ec 0c             	sub    $0xc,%esp
  8017af:	6a 01                	push   $0x1
  8017b1:	e8 42 0c 00 00       	call   8023f8 <ipc_find_env>
  8017b6:	a3 00 40 80 00       	mov    %eax,0x804000
  8017bb:	83 c4 10             	add    $0x10,%esp
  8017be:	eb c5                	jmp    801785 <fsipc+0x12>

008017c0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8017cc:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d4:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8017de:	b8 02 00 00 00       	mov    $0x2,%eax
  8017e3:	e8 8b ff ff ff       	call   801773 <fsipc>
}
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <devfile_flush>:
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8017f6:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801800:	b8 06 00 00 00       	mov    $0x6,%eax
  801805:	e8 69 ff ff ff       	call   801773 <fsipc>
}
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <devfile_stat>:
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
  80180f:	53                   	push   %ebx
  801810:	83 ec 04             	sub    $0x4,%esp
  801813:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	8b 40 0c             	mov    0xc(%eax),%eax
  80181c:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801821:	ba 00 00 00 00       	mov    $0x0,%edx
  801826:	b8 05 00 00 00       	mov    $0x5,%eax
  80182b:	e8 43 ff ff ff       	call   801773 <fsipc>
  801830:	85 c0                	test   %eax,%eax
  801832:	78 2c                	js     801860 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801834:	83 ec 08             	sub    $0x8,%esp
  801837:	68 00 50 80 00       	push   $0x805000
  80183c:	53                   	push   %ebx
  80183d:	e8 23 f2 ff ff       	call   800a65 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801842:	a1 80 50 80 00       	mov    0x805080,%eax
  801847:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80184d:	a1 84 50 80 00       	mov    0x805084,%eax
  801852:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801858:	83 c4 10             	add    $0x10,%esp
  80185b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801860:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801863:	c9                   	leave  
  801864:	c3                   	ret    

00801865 <devfile_write>:
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
  801868:	53                   	push   %ebx
  801869:	83 ec 08             	sub    $0x8,%esp
  80186c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80186f:	8b 45 08             	mov    0x8(%ebp),%eax
  801872:	8b 40 0c             	mov    0xc(%eax),%eax
  801875:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80187a:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801880:	53                   	push   %ebx
  801881:	ff 75 0c             	pushl  0xc(%ebp)
  801884:	68 08 50 80 00       	push   $0x805008
  801889:	e8 c7 f3 ff ff       	call   800c55 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80188e:	ba 00 00 00 00       	mov    $0x0,%edx
  801893:	b8 04 00 00 00       	mov    $0x4,%eax
  801898:	e8 d6 fe ff ff       	call   801773 <fsipc>
  80189d:	83 c4 10             	add    $0x10,%esp
  8018a0:	85 c0                	test   %eax,%eax
  8018a2:	78 0b                	js     8018af <devfile_write+0x4a>
	assert(r <= n);
  8018a4:	39 d8                	cmp    %ebx,%eax
  8018a6:	77 0c                	ja     8018b4 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8018a8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018ad:	7f 1e                	jg     8018cd <devfile_write+0x68>
}
  8018af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    
	assert(r <= n);
  8018b4:	68 40 2d 80 00       	push   $0x802d40
  8018b9:	68 47 2d 80 00       	push   $0x802d47
  8018be:	68 98 00 00 00       	push   $0x98
  8018c3:	68 5c 2d 80 00       	push   $0x802d5c
  8018c8:	e8 43 e9 ff ff       	call   800210 <_panic>
	assert(r <= PGSIZE);
  8018cd:	68 67 2d 80 00       	push   $0x802d67
  8018d2:	68 47 2d 80 00       	push   $0x802d47
  8018d7:	68 99 00 00 00       	push   $0x99
  8018dc:	68 5c 2d 80 00       	push   $0x802d5c
  8018e1:	e8 2a e9 ff ff       	call   800210 <_panic>

008018e6 <devfile_read>:
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	56                   	push   %esi
  8018ea:	53                   	push   %ebx
  8018eb:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8018f4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018f9:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801904:	b8 03 00 00 00       	mov    $0x3,%eax
  801909:	e8 65 fe ff ff       	call   801773 <fsipc>
  80190e:	89 c3                	mov    %eax,%ebx
  801910:	85 c0                	test   %eax,%eax
  801912:	78 1f                	js     801933 <devfile_read+0x4d>
	assert(r <= n);
  801914:	39 f0                	cmp    %esi,%eax
  801916:	77 24                	ja     80193c <devfile_read+0x56>
	assert(r <= PGSIZE);
  801918:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80191d:	7f 33                	jg     801952 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80191f:	83 ec 04             	sub    $0x4,%esp
  801922:	50                   	push   %eax
  801923:	68 00 50 80 00       	push   $0x805000
  801928:	ff 75 0c             	pushl  0xc(%ebp)
  80192b:	e8 c3 f2 ff ff       	call   800bf3 <memmove>
	return r;
  801930:	83 c4 10             	add    $0x10,%esp
}
  801933:	89 d8                	mov    %ebx,%eax
  801935:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801938:	5b                   	pop    %ebx
  801939:	5e                   	pop    %esi
  80193a:	5d                   	pop    %ebp
  80193b:	c3                   	ret    
	assert(r <= n);
  80193c:	68 40 2d 80 00       	push   $0x802d40
  801941:	68 47 2d 80 00       	push   $0x802d47
  801946:	6a 7c                	push   $0x7c
  801948:	68 5c 2d 80 00       	push   $0x802d5c
  80194d:	e8 be e8 ff ff       	call   800210 <_panic>
	assert(r <= PGSIZE);
  801952:	68 67 2d 80 00       	push   $0x802d67
  801957:	68 47 2d 80 00       	push   $0x802d47
  80195c:	6a 7d                	push   $0x7d
  80195e:	68 5c 2d 80 00       	push   $0x802d5c
  801963:	e8 a8 e8 ff ff       	call   800210 <_panic>

00801968 <open>:
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
  80196b:	56                   	push   %esi
  80196c:	53                   	push   %ebx
  80196d:	83 ec 1c             	sub    $0x1c,%esp
  801970:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801973:	56                   	push   %esi
  801974:	e8 b3 f0 ff ff       	call   800a2c <strlen>
  801979:	83 c4 10             	add    $0x10,%esp
  80197c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801981:	7f 6c                	jg     8019ef <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801983:	83 ec 0c             	sub    $0xc,%esp
  801986:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801989:	50                   	push   %eax
  80198a:	e8 79 f8 ff ff       	call   801208 <fd_alloc>
  80198f:	89 c3                	mov    %eax,%ebx
  801991:	83 c4 10             	add    $0x10,%esp
  801994:	85 c0                	test   %eax,%eax
  801996:	78 3c                	js     8019d4 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801998:	83 ec 08             	sub    $0x8,%esp
  80199b:	56                   	push   %esi
  80199c:	68 00 50 80 00       	push   $0x805000
  8019a1:	e8 bf f0 ff ff       	call   800a65 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a9:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8019b6:	e8 b8 fd ff ff       	call   801773 <fsipc>
  8019bb:	89 c3                	mov    %eax,%ebx
  8019bd:	83 c4 10             	add    $0x10,%esp
  8019c0:	85 c0                	test   %eax,%eax
  8019c2:	78 19                	js     8019dd <open+0x75>
	return fd2num(fd);
  8019c4:	83 ec 0c             	sub    $0xc,%esp
  8019c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ca:	e8 12 f8 ff ff       	call   8011e1 <fd2num>
  8019cf:	89 c3                	mov    %eax,%ebx
  8019d1:	83 c4 10             	add    $0x10,%esp
}
  8019d4:	89 d8                	mov    %ebx,%eax
  8019d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019d9:	5b                   	pop    %ebx
  8019da:	5e                   	pop    %esi
  8019db:	5d                   	pop    %ebp
  8019dc:	c3                   	ret    
		fd_close(fd, 0);
  8019dd:	83 ec 08             	sub    $0x8,%esp
  8019e0:	6a 00                	push   $0x0
  8019e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8019e5:	e8 1b f9 ff ff       	call   801305 <fd_close>
		return r;
  8019ea:	83 c4 10             	add    $0x10,%esp
  8019ed:	eb e5                	jmp    8019d4 <open+0x6c>
		return -E_BAD_PATH;
  8019ef:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019f4:	eb de                	jmp    8019d4 <open+0x6c>

008019f6 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
  8019f9:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019fc:	ba 00 00 00 00       	mov    $0x0,%edx
  801a01:	b8 08 00 00 00       	mov    $0x8,%eax
  801a06:	e8 68 fd ff ff       	call   801773 <fsipc>
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
  801a10:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801a13:	68 73 2d 80 00       	push   $0x802d73
  801a18:	ff 75 0c             	pushl  0xc(%ebp)
  801a1b:	e8 45 f0 ff ff       	call   800a65 <strcpy>
	return 0;
}
  801a20:	b8 00 00 00 00       	mov    $0x0,%eax
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <devsock_close>:
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
  801a2a:	53                   	push   %ebx
  801a2b:	83 ec 10             	sub    $0x10,%esp
  801a2e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a31:	53                   	push   %ebx
  801a32:	e8 fc 09 00 00       	call   802433 <pageref>
  801a37:	83 c4 10             	add    $0x10,%esp
		return 0;
  801a3a:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801a3f:	83 f8 01             	cmp    $0x1,%eax
  801a42:	74 07                	je     801a4b <devsock_close+0x24>
}
  801a44:	89 d0                	mov    %edx,%eax
  801a46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801a4b:	83 ec 0c             	sub    $0xc,%esp
  801a4e:	ff 73 0c             	pushl  0xc(%ebx)
  801a51:	e8 b9 02 00 00       	call   801d0f <nsipc_close>
  801a56:	89 c2                	mov    %eax,%edx
  801a58:	83 c4 10             	add    $0x10,%esp
  801a5b:	eb e7                	jmp    801a44 <devsock_close+0x1d>

00801a5d <devsock_write>:
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
  801a60:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a63:	6a 00                	push   $0x0
  801a65:	ff 75 10             	pushl  0x10(%ebp)
  801a68:	ff 75 0c             	pushl  0xc(%ebp)
  801a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6e:	ff 70 0c             	pushl  0xc(%eax)
  801a71:	e8 76 03 00 00       	call   801dec <nsipc_send>
}
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <devsock_read>:
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
  801a7b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a7e:	6a 00                	push   $0x0
  801a80:	ff 75 10             	pushl  0x10(%ebp)
  801a83:	ff 75 0c             	pushl  0xc(%ebp)
  801a86:	8b 45 08             	mov    0x8(%ebp),%eax
  801a89:	ff 70 0c             	pushl  0xc(%eax)
  801a8c:	e8 ef 02 00 00       	call   801d80 <nsipc_recv>
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <fd2sockid>:
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
  801a96:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a99:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a9c:	52                   	push   %edx
  801a9d:	50                   	push   %eax
  801a9e:	e8 b7 f7 ff ff       	call   80125a <fd_lookup>
  801aa3:	83 c4 10             	add    $0x10,%esp
  801aa6:	85 c0                	test   %eax,%eax
  801aa8:	78 10                	js     801aba <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aad:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801ab3:	39 08                	cmp    %ecx,(%eax)
  801ab5:	75 05                	jne    801abc <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801ab7:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    
		return -E_NOT_SUPP;
  801abc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ac1:	eb f7                	jmp    801aba <fd2sockid+0x27>

00801ac3 <alloc_sockfd>:
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
  801ac6:	56                   	push   %esi
  801ac7:	53                   	push   %ebx
  801ac8:	83 ec 1c             	sub    $0x1c,%esp
  801acb:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801acd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad0:	50                   	push   %eax
  801ad1:	e8 32 f7 ff ff       	call   801208 <fd_alloc>
  801ad6:	89 c3                	mov    %eax,%ebx
  801ad8:	83 c4 10             	add    $0x10,%esp
  801adb:	85 c0                	test   %eax,%eax
  801add:	78 43                	js     801b22 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801adf:	83 ec 04             	sub    $0x4,%esp
  801ae2:	68 07 04 00 00       	push   $0x407
  801ae7:	ff 75 f4             	pushl  -0xc(%ebp)
  801aea:	6a 00                	push   $0x0
  801aec:	e8 66 f3 ff ff       	call   800e57 <sys_page_alloc>
  801af1:	89 c3                	mov    %eax,%ebx
  801af3:	83 c4 10             	add    $0x10,%esp
  801af6:	85 c0                	test   %eax,%eax
  801af8:	78 28                	js     801b22 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afd:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b03:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b08:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801b0f:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801b12:	83 ec 0c             	sub    $0xc,%esp
  801b15:	50                   	push   %eax
  801b16:	e8 c6 f6 ff ff       	call   8011e1 <fd2num>
  801b1b:	89 c3                	mov    %eax,%ebx
  801b1d:	83 c4 10             	add    $0x10,%esp
  801b20:	eb 0c                	jmp    801b2e <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801b22:	83 ec 0c             	sub    $0xc,%esp
  801b25:	56                   	push   %esi
  801b26:	e8 e4 01 00 00       	call   801d0f <nsipc_close>
		return r;
  801b2b:	83 c4 10             	add    $0x10,%esp
}
  801b2e:	89 d8                	mov    %ebx,%eax
  801b30:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b33:	5b                   	pop    %ebx
  801b34:	5e                   	pop    %esi
  801b35:	5d                   	pop    %ebp
  801b36:	c3                   	ret    

00801b37 <accept>:
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
  801b3a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b40:	e8 4e ff ff ff       	call   801a93 <fd2sockid>
  801b45:	85 c0                	test   %eax,%eax
  801b47:	78 1b                	js     801b64 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b49:	83 ec 04             	sub    $0x4,%esp
  801b4c:	ff 75 10             	pushl  0x10(%ebp)
  801b4f:	ff 75 0c             	pushl  0xc(%ebp)
  801b52:	50                   	push   %eax
  801b53:	e8 0e 01 00 00       	call   801c66 <nsipc_accept>
  801b58:	83 c4 10             	add    $0x10,%esp
  801b5b:	85 c0                	test   %eax,%eax
  801b5d:	78 05                	js     801b64 <accept+0x2d>
	return alloc_sockfd(r);
  801b5f:	e8 5f ff ff ff       	call   801ac3 <alloc_sockfd>
}
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <bind>:
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
  801b69:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	e8 1f ff ff ff       	call   801a93 <fd2sockid>
  801b74:	85 c0                	test   %eax,%eax
  801b76:	78 12                	js     801b8a <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801b78:	83 ec 04             	sub    $0x4,%esp
  801b7b:	ff 75 10             	pushl  0x10(%ebp)
  801b7e:	ff 75 0c             	pushl  0xc(%ebp)
  801b81:	50                   	push   %eax
  801b82:	e8 31 01 00 00       	call   801cb8 <nsipc_bind>
  801b87:	83 c4 10             	add    $0x10,%esp
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <shutdown>:
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
  801b8f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b92:	8b 45 08             	mov    0x8(%ebp),%eax
  801b95:	e8 f9 fe ff ff       	call   801a93 <fd2sockid>
  801b9a:	85 c0                	test   %eax,%eax
  801b9c:	78 0f                	js     801bad <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801b9e:	83 ec 08             	sub    $0x8,%esp
  801ba1:	ff 75 0c             	pushl  0xc(%ebp)
  801ba4:	50                   	push   %eax
  801ba5:	e8 43 01 00 00       	call   801ced <nsipc_shutdown>
  801baa:	83 c4 10             	add    $0x10,%esp
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <connect>:
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
  801bb2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb8:	e8 d6 fe ff ff       	call   801a93 <fd2sockid>
  801bbd:	85 c0                	test   %eax,%eax
  801bbf:	78 12                	js     801bd3 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801bc1:	83 ec 04             	sub    $0x4,%esp
  801bc4:	ff 75 10             	pushl  0x10(%ebp)
  801bc7:	ff 75 0c             	pushl  0xc(%ebp)
  801bca:	50                   	push   %eax
  801bcb:	e8 59 01 00 00       	call   801d29 <nsipc_connect>
  801bd0:	83 c4 10             	add    $0x10,%esp
}
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <listen>:
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
  801bd8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bde:	e8 b0 fe ff ff       	call   801a93 <fd2sockid>
  801be3:	85 c0                	test   %eax,%eax
  801be5:	78 0f                	js     801bf6 <listen+0x21>
	return nsipc_listen(r, backlog);
  801be7:	83 ec 08             	sub    $0x8,%esp
  801bea:	ff 75 0c             	pushl  0xc(%ebp)
  801bed:	50                   	push   %eax
  801bee:	e8 6b 01 00 00       	call   801d5e <nsipc_listen>
  801bf3:	83 c4 10             	add    $0x10,%esp
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <socket>:

int
socket(int domain, int type, int protocol)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
  801bfb:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801bfe:	ff 75 10             	pushl  0x10(%ebp)
  801c01:	ff 75 0c             	pushl  0xc(%ebp)
  801c04:	ff 75 08             	pushl  0x8(%ebp)
  801c07:	e8 3e 02 00 00       	call   801e4a <nsipc_socket>
  801c0c:	83 c4 10             	add    $0x10,%esp
  801c0f:	85 c0                	test   %eax,%eax
  801c11:	78 05                	js     801c18 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801c13:	e8 ab fe ff ff       	call   801ac3 <alloc_sockfd>
}
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
  801c1d:	53                   	push   %ebx
  801c1e:	83 ec 04             	sub    $0x4,%esp
  801c21:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c23:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c2a:	74 26                	je     801c52 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c2c:	6a 07                	push   $0x7
  801c2e:	68 00 60 80 00       	push   $0x806000
  801c33:	53                   	push   %ebx
  801c34:	ff 35 04 40 80 00    	pushl  0x804004
  801c3a:	e8 61 07 00 00       	call   8023a0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c3f:	83 c4 0c             	add    $0xc,%esp
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	e8 ea 06 00 00       	call   802337 <ipc_recv>
}
  801c4d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c52:	83 ec 0c             	sub    $0xc,%esp
  801c55:	6a 02                	push   $0x2
  801c57:	e8 9c 07 00 00       	call   8023f8 <ipc_find_env>
  801c5c:	a3 04 40 80 00       	mov    %eax,0x804004
  801c61:	83 c4 10             	add    $0x10,%esp
  801c64:	eb c6                	jmp    801c2c <nsipc+0x12>

00801c66 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
  801c69:	56                   	push   %esi
  801c6a:	53                   	push   %ebx
  801c6b:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c71:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c76:	8b 06                	mov    (%esi),%eax
  801c78:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c7d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c82:	e8 93 ff ff ff       	call   801c1a <nsipc>
  801c87:	89 c3                	mov    %eax,%ebx
  801c89:	85 c0                	test   %eax,%eax
  801c8b:	79 09                	jns    801c96 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801c8d:	89 d8                	mov    %ebx,%eax
  801c8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c92:	5b                   	pop    %ebx
  801c93:	5e                   	pop    %esi
  801c94:	5d                   	pop    %ebp
  801c95:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c96:	83 ec 04             	sub    $0x4,%esp
  801c99:	ff 35 10 60 80 00    	pushl  0x806010
  801c9f:	68 00 60 80 00       	push   $0x806000
  801ca4:	ff 75 0c             	pushl  0xc(%ebp)
  801ca7:	e8 47 ef ff ff       	call   800bf3 <memmove>
		*addrlen = ret->ret_addrlen;
  801cac:	a1 10 60 80 00       	mov    0x806010,%eax
  801cb1:	89 06                	mov    %eax,(%esi)
  801cb3:	83 c4 10             	add    $0x10,%esp
	return r;
  801cb6:	eb d5                	jmp    801c8d <nsipc_accept+0x27>

00801cb8 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	53                   	push   %ebx
  801cbc:	83 ec 08             	sub    $0x8,%esp
  801cbf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc5:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801cca:	53                   	push   %ebx
  801ccb:	ff 75 0c             	pushl  0xc(%ebp)
  801cce:	68 04 60 80 00       	push   $0x806004
  801cd3:	e8 1b ef ff ff       	call   800bf3 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801cd8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801cde:	b8 02 00 00 00       	mov    $0x2,%eax
  801ce3:	e8 32 ff ff ff       	call   801c1a <nsipc>
}
  801ce8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
  801cf0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cfe:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801d03:	b8 03 00 00 00       	mov    $0x3,%eax
  801d08:	e8 0d ff ff ff       	call   801c1a <nsipc>
}
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <nsipc_close>:

int
nsipc_close(int s)
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
  801d12:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d15:	8b 45 08             	mov    0x8(%ebp),%eax
  801d18:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d1d:	b8 04 00 00 00       	mov    $0x4,%eax
  801d22:	e8 f3 fe ff ff       	call   801c1a <nsipc>
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
  801d2c:	53                   	push   %ebx
  801d2d:	83 ec 08             	sub    $0x8,%esp
  801d30:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d33:	8b 45 08             	mov    0x8(%ebp),%eax
  801d36:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d3b:	53                   	push   %ebx
  801d3c:	ff 75 0c             	pushl  0xc(%ebp)
  801d3f:	68 04 60 80 00       	push   $0x806004
  801d44:	e8 aa ee ff ff       	call   800bf3 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d49:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d4f:	b8 05 00 00 00       	mov    $0x5,%eax
  801d54:	e8 c1 fe ff ff       	call   801c1a <nsipc>
}
  801d59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d64:	8b 45 08             	mov    0x8(%ebp),%eax
  801d67:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d6f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d74:	b8 06 00 00 00       	mov    $0x6,%eax
  801d79:	e8 9c fe ff ff       	call   801c1a <nsipc>
}
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    

00801d80 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	56                   	push   %esi
  801d84:	53                   	push   %ebx
  801d85:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d88:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d90:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d96:	8b 45 14             	mov    0x14(%ebp),%eax
  801d99:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d9e:	b8 07 00 00 00       	mov    $0x7,%eax
  801da3:	e8 72 fe ff ff       	call   801c1a <nsipc>
  801da8:	89 c3                	mov    %eax,%ebx
  801daa:	85 c0                	test   %eax,%eax
  801dac:	78 1f                	js     801dcd <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801dae:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801db3:	7f 21                	jg     801dd6 <nsipc_recv+0x56>
  801db5:	39 c6                	cmp    %eax,%esi
  801db7:	7c 1d                	jl     801dd6 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801db9:	83 ec 04             	sub    $0x4,%esp
  801dbc:	50                   	push   %eax
  801dbd:	68 00 60 80 00       	push   $0x806000
  801dc2:	ff 75 0c             	pushl  0xc(%ebp)
  801dc5:	e8 29 ee ff ff       	call   800bf3 <memmove>
  801dca:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801dcd:	89 d8                	mov    %ebx,%eax
  801dcf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dd2:	5b                   	pop    %ebx
  801dd3:	5e                   	pop    %esi
  801dd4:	5d                   	pop    %ebp
  801dd5:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801dd6:	68 7f 2d 80 00       	push   $0x802d7f
  801ddb:	68 47 2d 80 00       	push   $0x802d47
  801de0:	6a 62                	push   $0x62
  801de2:	68 94 2d 80 00       	push   $0x802d94
  801de7:	e8 24 e4 ff ff       	call   800210 <_panic>

00801dec <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	53                   	push   %ebx
  801df0:	83 ec 04             	sub    $0x4,%esp
  801df3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801df6:	8b 45 08             	mov    0x8(%ebp),%eax
  801df9:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801dfe:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e04:	7f 2e                	jg     801e34 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e06:	83 ec 04             	sub    $0x4,%esp
  801e09:	53                   	push   %ebx
  801e0a:	ff 75 0c             	pushl  0xc(%ebp)
  801e0d:	68 0c 60 80 00       	push   $0x80600c
  801e12:	e8 dc ed ff ff       	call   800bf3 <memmove>
	nsipcbuf.send.req_size = size;
  801e17:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801e1d:	8b 45 14             	mov    0x14(%ebp),%eax
  801e20:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e25:	b8 08 00 00 00       	mov    $0x8,%eax
  801e2a:	e8 eb fd ff ff       	call   801c1a <nsipc>
}
  801e2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    
	assert(size < 1600);
  801e34:	68 a0 2d 80 00       	push   $0x802da0
  801e39:	68 47 2d 80 00       	push   $0x802d47
  801e3e:	6a 6d                	push   $0x6d
  801e40:	68 94 2d 80 00       	push   $0x802d94
  801e45:	e8 c6 e3 ff ff       	call   800210 <_panic>

00801e4a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
  801e4d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e50:	8b 45 08             	mov    0x8(%ebp),%eax
  801e53:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e5b:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e60:	8b 45 10             	mov    0x10(%ebp),%eax
  801e63:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e68:	b8 09 00 00 00       	mov    $0x9,%eax
  801e6d:	e8 a8 fd ff ff       	call   801c1a <nsipc>
}
  801e72:	c9                   	leave  
  801e73:	c3                   	ret    

00801e74 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
  801e77:	56                   	push   %esi
  801e78:	53                   	push   %ebx
  801e79:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e7c:	83 ec 0c             	sub    $0xc,%esp
  801e7f:	ff 75 08             	pushl  0x8(%ebp)
  801e82:	e8 6a f3 ff ff       	call   8011f1 <fd2data>
  801e87:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e89:	83 c4 08             	add    $0x8,%esp
  801e8c:	68 ac 2d 80 00       	push   $0x802dac
  801e91:	53                   	push   %ebx
  801e92:	e8 ce eb ff ff       	call   800a65 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e97:	8b 46 04             	mov    0x4(%esi),%eax
  801e9a:	2b 06                	sub    (%esi),%eax
  801e9c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ea2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ea9:	00 00 00 
	stat->st_dev = &devpipe;
  801eac:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801eb3:	30 80 00 
	return 0;
}
  801eb6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ebb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ebe:	5b                   	pop    %ebx
  801ebf:	5e                   	pop    %esi
  801ec0:	5d                   	pop    %ebp
  801ec1:	c3                   	ret    

00801ec2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
  801ec5:	53                   	push   %ebx
  801ec6:	83 ec 0c             	sub    $0xc,%esp
  801ec9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ecc:	53                   	push   %ebx
  801ecd:	6a 00                	push   $0x0
  801ecf:	e8 08 f0 ff ff       	call   800edc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ed4:	89 1c 24             	mov    %ebx,(%esp)
  801ed7:	e8 15 f3 ff ff       	call   8011f1 <fd2data>
  801edc:	83 c4 08             	add    $0x8,%esp
  801edf:	50                   	push   %eax
  801ee0:	6a 00                	push   $0x0
  801ee2:	e8 f5 ef ff ff       	call   800edc <sys_page_unmap>
}
  801ee7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eea:	c9                   	leave  
  801eeb:	c3                   	ret    

00801eec <_pipeisclosed>:
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
  801eef:	57                   	push   %edi
  801ef0:	56                   	push   %esi
  801ef1:	53                   	push   %ebx
  801ef2:	83 ec 1c             	sub    $0x1c,%esp
  801ef5:	89 c7                	mov    %eax,%edi
  801ef7:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ef9:	a1 08 40 80 00       	mov    0x804008,%eax
  801efe:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f01:	83 ec 0c             	sub    $0xc,%esp
  801f04:	57                   	push   %edi
  801f05:	e8 29 05 00 00       	call   802433 <pageref>
  801f0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f0d:	89 34 24             	mov    %esi,(%esp)
  801f10:	e8 1e 05 00 00       	call   802433 <pageref>
		nn = thisenv->env_runs;
  801f15:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f1b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801f1e:	83 c4 10             	add    $0x10,%esp
  801f21:	39 cb                	cmp    %ecx,%ebx
  801f23:	74 1b                	je     801f40 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801f25:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f28:	75 cf                	jne    801ef9 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f2a:	8b 42 58             	mov    0x58(%edx),%eax
  801f2d:	6a 01                	push   $0x1
  801f2f:	50                   	push   %eax
  801f30:	53                   	push   %ebx
  801f31:	68 b3 2d 80 00       	push   $0x802db3
  801f36:	e8 cb e3 ff ff       	call   800306 <cprintf>
  801f3b:	83 c4 10             	add    $0x10,%esp
  801f3e:	eb b9                	jmp    801ef9 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801f40:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f43:	0f 94 c0             	sete   %al
  801f46:	0f b6 c0             	movzbl %al,%eax
}
  801f49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f4c:	5b                   	pop    %ebx
  801f4d:	5e                   	pop    %esi
  801f4e:	5f                   	pop    %edi
  801f4f:	5d                   	pop    %ebp
  801f50:	c3                   	ret    

00801f51 <devpipe_write>:
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
  801f54:	57                   	push   %edi
  801f55:	56                   	push   %esi
  801f56:	53                   	push   %ebx
  801f57:	83 ec 28             	sub    $0x28,%esp
  801f5a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f5d:	56                   	push   %esi
  801f5e:	e8 8e f2 ff ff       	call   8011f1 <fd2data>
  801f63:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f65:	83 c4 10             	add    $0x10,%esp
  801f68:	bf 00 00 00 00       	mov    $0x0,%edi
  801f6d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f70:	74 4f                	je     801fc1 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f72:	8b 43 04             	mov    0x4(%ebx),%eax
  801f75:	8b 0b                	mov    (%ebx),%ecx
  801f77:	8d 51 20             	lea    0x20(%ecx),%edx
  801f7a:	39 d0                	cmp    %edx,%eax
  801f7c:	72 14                	jb     801f92 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801f7e:	89 da                	mov    %ebx,%edx
  801f80:	89 f0                	mov    %esi,%eax
  801f82:	e8 65 ff ff ff       	call   801eec <_pipeisclosed>
  801f87:	85 c0                	test   %eax,%eax
  801f89:	75 3b                	jne    801fc6 <devpipe_write+0x75>
			sys_yield();
  801f8b:	e8 a8 ee ff ff       	call   800e38 <sys_yield>
  801f90:	eb e0                	jmp    801f72 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f95:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f99:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f9c:	89 c2                	mov    %eax,%edx
  801f9e:	c1 fa 1f             	sar    $0x1f,%edx
  801fa1:	89 d1                	mov    %edx,%ecx
  801fa3:	c1 e9 1b             	shr    $0x1b,%ecx
  801fa6:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801fa9:	83 e2 1f             	and    $0x1f,%edx
  801fac:	29 ca                	sub    %ecx,%edx
  801fae:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801fb2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801fb6:	83 c0 01             	add    $0x1,%eax
  801fb9:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801fbc:	83 c7 01             	add    $0x1,%edi
  801fbf:	eb ac                	jmp    801f6d <devpipe_write+0x1c>
	return i;
  801fc1:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc4:	eb 05                	jmp    801fcb <devpipe_write+0x7a>
				return 0;
  801fc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fce:	5b                   	pop    %ebx
  801fcf:	5e                   	pop    %esi
  801fd0:	5f                   	pop    %edi
  801fd1:	5d                   	pop    %ebp
  801fd2:	c3                   	ret    

00801fd3 <devpipe_read>:
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
  801fd6:	57                   	push   %edi
  801fd7:	56                   	push   %esi
  801fd8:	53                   	push   %ebx
  801fd9:	83 ec 18             	sub    $0x18,%esp
  801fdc:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801fdf:	57                   	push   %edi
  801fe0:	e8 0c f2 ff ff       	call   8011f1 <fd2data>
  801fe5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801fe7:	83 c4 10             	add    $0x10,%esp
  801fea:	be 00 00 00 00       	mov    $0x0,%esi
  801fef:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ff2:	75 14                	jne    802008 <devpipe_read+0x35>
	return i;
  801ff4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ff7:	eb 02                	jmp    801ffb <devpipe_read+0x28>
				return i;
  801ff9:	89 f0                	mov    %esi,%eax
}
  801ffb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ffe:	5b                   	pop    %ebx
  801fff:	5e                   	pop    %esi
  802000:	5f                   	pop    %edi
  802001:	5d                   	pop    %ebp
  802002:	c3                   	ret    
			sys_yield();
  802003:	e8 30 ee ff ff       	call   800e38 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802008:	8b 03                	mov    (%ebx),%eax
  80200a:	3b 43 04             	cmp    0x4(%ebx),%eax
  80200d:	75 18                	jne    802027 <devpipe_read+0x54>
			if (i > 0)
  80200f:	85 f6                	test   %esi,%esi
  802011:	75 e6                	jne    801ff9 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802013:	89 da                	mov    %ebx,%edx
  802015:	89 f8                	mov    %edi,%eax
  802017:	e8 d0 fe ff ff       	call   801eec <_pipeisclosed>
  80201c:	85 c0                	test   %eax,%eax
  80201e:	74 e3                	je     802003 <devpipe_read+0x30>
				return 0;
  802020:	b8 00 00 00 00       	mov    $0x0,%eax
  802025:	eb d4                	jmp    801ffb <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802027:	99                   	cltd   
  802028:	c1 ea 1b             	shr    $0x1b,%edx
  80202b:	01 d0                	add    %edx,%eax
  80202d:	83 e0 1f             	and    $0x1f,%eax
  802030:	29 d0                	sub    %edx,%eax
  802032:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802037:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80203a:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80203d:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802040:	83 c6 01             	add    $0x1,%esi
  802043:	eb aa                	jmp    801fef <devpipe_read+0x1c>

00802045 <pipe>:
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
  802048:	56                   	push   %esi
  802049:	53                   	push   %ebx
  80204a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80204d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802050:	50                   	push   %eax
  802051:	e8 b2 f1 ff ff       	call   801208 <fd_alloc>
  802056:	89 c3                	mov    %eax,%ebx
  802058:	83 c4 10             	add    $0x10,%esp
  80205b:	85 c0                	test   %eax,%eax
  80205d:	0f 88 23 01 00 00    	js     802186 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802063:	83 ec 04             	sub    $0x4,%esp
  802066:	68 07 04 00 00       	push   $0x407
  80206b:	ff 75 f4             	pushl  -0xc(%ebp)
  80206e:	6a 00                	push   $0x0
  802070:	e8 e2 ed ff ff       	call   800e57 <sys_page_alloc>
  802075:	89 c3                	mov    %eax,%ebx
  802077:	83 c4 10             	add    $0x10,%esp
  80207a:	85 c0                	test   %eax,%eax
  80207c:	0f 88 04 01 00 00    	js     802186 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802082:	83 ec 0c             	sub    $0xc,%esp
  802085:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802088:	50                   	push   %eax
  802089:	e8 7a f1 ff ff       	call   801208 <fd_alloc>
  80208e:	89 c3                	mov    %eax,%ebx
  802090:	83 c4 10             	add    $0x10,%esp
  802093:	85 c0                	test   %eax,%eax
  802095:	0f 88 db 00 00 00    	js     802176 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80209b:	83 ec 04             	sub    $0x4,%esp
  80209e:	68 07 04 00 00       	push   $0x407
  8020a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8020a6:	6a 00                	push   $0x0
  8020a8:	e8 aa ed ff ff       	call   800e57 <sys_page_alloc>
  8020ad:	89 c3                	mov    %eax,%ebx
  8020af:	83 c4 10             	add    $0x10,%esp
  8020b2:	85 c0                	test   %eax,%eax
  8020b4:	0f 88 bc 00 00 00    	js     802176 <pipe+0x131>
	va = fd2data(fd0);
  8020ba:	83 ec 0c             	sub    $0xc,%esp
  8020bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8020c0:	e8 2c f1 ff ff       	call   8011f1 <fd2data>
  8020c5:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020c7:	83 c4 0c             	add    $0xc,%esp
  8020ca:	68 07 04 00 00       	push   $0x407
  8020cf:	50                   	push   %eax
  8020d0:	6a 00                	push   $0x0
  8020d2:	e8 80 ed ff ff       	call   800e57 <sys_page_alloc>
  8020d7:	89 c3                	mov    %eax,%ebx
  8020d9:	83 c4 10             	add    $0x10,%esp
  8020dc:	85 c0                	test   %eax,%eax
  8020de:	0f 88 82 00 00 00    	js     802166 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020e4:	83 ec 0c             	sub    $0xc,%esp
  8020e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8020ea:	e8 02 f1 ff ff       	call   8011f1 <fd2data>
  8020ef:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8020f6:	50                   	push   %eax
  8020f7:	6a 00                	push   $0x0
  8020f9:	56                   	push   %esi
  8020fa:	6a 00                	push   $0x0
  8020fc:	e8 99 ed ff ff       	call   800e9a <sys_page_map>
  802101:	89 c3                	mov    %eax,%ebx
  802103:	83 c4 20             	add    $0x20,%esp
  802106:	85 c0                	test   %eax,%eax
  802108:	78 4e                	js     802158 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80210a:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80210f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802112:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802114:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802117:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80211e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802121:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802123:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802126:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80212d:	83 ec 0c             	sub    $0xc,%esp
  802130:	ff 75 f4             	pushl  -0xc(%ebp)
  802133:	e8 a9 f0 ff ff       	call   8011e1 <fd2num>
  802138:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80213b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80213d:	83 c4 04             	add    $0x4,%esp
  802140:	ff 75 f0             	pushl  -0x10(%ebp)
  802143:	e8 99 f0 ff ff       	call   8011e1 <fd2num>
  802148:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80214b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80214e:	83 c4 10             	add    $0x10,%esp
  802151:	bb 00 00 00 00       	mov    $0x0,%ebx
  802156:	eb 2e                	jmp    802186 <pipe+0x141>
	sys_page_unmap(0, va);
  802158:	83 ec 08             	sub    $0x8,%esp
  80215b:	56                   	push   %esi
  80215c:	6a 00                	push   $0x0
  80215e:	e8 79 ed ff ff       	call   800edc <sys_page_unmap>
  802163:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802166:	83 ec 08             	sub    $0x8,%esp
  802169:	ff 75 f0             	pushl  -0x10(%ebp)
  80216c:	6a 00                	push   $0x0
  80216e:	e8 69 ed ff ff       	call   800edc <sys_page_unmap>
  802173:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802176:	83 ec 08             	sub    $0x8,%esp
  802179:	ff 75 f4             	pushl  -0xc(%ebp)
  80217c:	6a 00                	push   $0x0
  80217e:	e8 59 ed ff ff       	call   800edc <sys_page_unmap>
  802183:	83 c4 10             	add    $0x10,%esp
}
  802186:	89 d8                	mov    %ebx,%eax
  802188:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80218b:	5b                   	pop    %ebx
  80218c:	5e                   	pop    %esi
  80218d:	5d                   	pop    %ebp
  80218e:	c3                   	ret    

0080218f <pipeisclosed>:
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
  802192:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802195:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802198:	50                   	push   %eax
  802199:	ff 75 08             	pushl  0x8(%ebp)
  80219c:	e8 b9 f0 ff ff       	call   80125a <fd_lookup>
  8021a1:	83 c4 10             	add    $0x10,%esp
  8021a4:	85 c0                	test   %eax,%eax
  8021a6:	78 18                	js     8021c0 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8021a8:	83 ec 0c             	sub    $0xc,%esp
  8021ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8021ae:	e8 3e f0 ff ff       	call   8011f1 <fd2data>
	return _pipeisclosed(fd, p);
  8021b3:	89 c2                	mov    %eax,%edx
  8021b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b8:	e8 2f fd ff ff       	call   801eec <_pipeisclosed>
  8021bd:	83 c4 10             	add    $0x10,%esp
}
  8021c0:	c9                   	leave  
  8021c1:	c3                   	ret    

008021c2 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8021c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c7:	c3                   	ret    

008021c8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
  8021cb:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8021ce:	68 cb 2d 80 00       	push   $0x802dcb
  8021d3:	ff 75 0c             	pushl  0xc(%ebp)
  8021d6:	e8 8a e8 ff ff       	call   800a65 <strcpy>
	return 0;
}
  8021db:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e0:	c9                   	leave  
  8021e1:	c3                   	ret    

008021e2 <devcons_write>:
{
  8021e2:	55                   	push   %ebp
  8021e3:	89 e5                	mov    %esp,%ebp
  8021e5:	57                   	push   %edi
  8021e6:	56                   	push   %esi
  8021e7:	53                   	push   %ebx
  8021e8:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8021ee:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8021f3:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8021f9:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021fc:	73 31                	jae    80222f <devcons_write+0x4d>
		m = n - tot;
  8021fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802201:	29 f3                	sub    %esi,%ebx
  802203:	83 fb 7f             	cmp    $0x7f,%ebx
  802206:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80220b:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80220e:	83 ec 04             	sub    $0x4,%esp
  802211:	53                   	push   %ebx
  802212:	89 f0                	mov    %esi,%eax
  802214:	03 45 0c             	add    0xc(%ebp),%eax
  802217:	50                   	push   %eax
  802218:	57                   	push   %edi
  802219:	e8 d5 e9 ff ff       	call   800bf3 <memmove>
		sys_cputs(buf, m);
  80221e:	83 c4 08             	add    $0x8,%esp
  802221:	53                   	push   %ebx
  802222:	57                   	push   %edi
  802223:	e8 73 eb ff ff       	call   800d9b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802228:	01 de                	add    %ebx,%esi
  80222a:	83 c4 10             	add    $0x10,%esp
  80222d:	eb ca                	jmp    8021f9 <devcons_write+0x17>
}
  80222f:	89 f0                	mov    %esi,%eax
  802231:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802234:	5b                   	pop    %ebx
  802235:	5e                   	pop    %esi
  802236:	5f                   	pop    %edi
  802237:	5d                   	pop    %ebp
  802238:	c3                   	ret    

00802239 <devcons_read>:
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
  80223c:	83 ec 08             	sub    $0x8,%esp
  80223f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802244:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802248:	74 21                	je     80226b <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80224a:	e8 6a eb ff ff       	call   800db9 <sys_cgetc>
  80224f:	85 c0                	test   %eax,%eax
  802251:	75 07                	jne    80225a <devcons_read+0x21>
		sys_yield();
  802253:	e8 e0 eb ff ff       	call   800e38 <sys_yield>
  802258:	eb f0                	jmp    80224a <devcons_read+0x11>
	if (c < 0)
  80225a:	78 0f                	js     80226b <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80225c:	83 f8 04             	cmp    $0x4,%eax
  80225f:	74 0c                	je     80226d <devcons_read+0x34>
	*(char*)vbuf = c;
  802261:	8b 55 0c             	mov    0xc(%ebp),%edx
  802264:	88 02                	mov    %al,(%edx)
	return 1;
  802266:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80226b:	c9                   	leave  
  80226c:	c3                   	ret    
		return 0;
  80226d:	b8 00 00 00 00       	mov    $0x0,%eax
  802272:	eb f7                	jmp    80226b <devcons_read+0x32>

00802274 <cputchar>:
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
  802277:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80227a:	8b 45 08             	mov    0x8(%ebp),%eax
  80227d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802280:	6a 01                	push   $0x1
  802282:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802285:	50                   	push   %eax
  802286:	e8 10 eb ff ff       	call   800d9b <sys_cputs>
}
  80228b:	83 c4 10             	add    $0x10,%esp
  80228e:	c9                   	leave  
  80228f:	c3                   	ret    

00802290 <getchar>:
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
  802293:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802296:	6a 01                	push   $0x1
  802298:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80229b:	50                   	push   %eax
  80229c:	6a 00                	push   $0x0
  80229e:	e8 27 f2 ff ff       	call   8014ca <read>
	if (r < 0)
  8022a3:	83 c4 10             	add    $0x10,%esp
  8022a6:	85 c0                	test   %eax,%eax
  8022a8:	78 06                	js     8022b0 <getchar+0x20>
	if (r < 1)
  8022aa:	74 06                	je     8022b2 <getchar+0x22>
	return c;
  8022ac:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8022b0:	c9                   	leave  
  8022b1:	c3                   	ret    
		return -E_EOF;
  8022b2:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8022b7:	eb f7                	jmp    8022b0 <getchar+0x20>

008022b9 <iscons>:
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
  8022bc:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022c2:	50                   	push   %eax
  8022c3:	ff 75 08             	pushl  0x8(%ebp)
  8022c6:	e8 8f ef ff ff       	call   80125a <fd_lookup>
  8022cb:	83 c4 10             	add    $0x10,%esp
  8022ce:	85 c0                	test   %eax,%eax
  8022d0:	78 11                	js     8022e3 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8022d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d5:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022db:	39 10                	cmp    %edx,(%eax)
  8022dd:	0f 94 c0             	sete   %al
  8022e0:	0f b6 c0             	movzbl %al,%eax
}
  8022e3:	c9                   	leave  
  8022e4:	c3                   	ret    

008022e5 <opencons>:
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
  8022e8:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8022eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022ee:	50                   	push   %eax
  8022ef:	e8 14 ef ff ff       	call   801208 <fd_alloc>
  8022f4:	83 c4 10             	add    $0x10,%esp
  8022f7:	85 c0                	test   %eax,%eax
  8022f9:	78 3a                	js     802335 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022fb:	83 ec 04             	sub    $0x4,%esp
  8022fe:	68 07 04 00 00       	push   $0x407
  802303:	ff 75 f4             	pushl  -0xc(%ebp)
  802306:	6a 00                	push   $0x0
  802308:	e8 4a eb ff ff       	call   800e57 <sys_page_alloc>
  80230d:	83 c4 10             	add    $0x10,%esp
  802310:	85 c0                	test   %eax,%eax
  802312:	78 21                	js     802335 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802317:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80231d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80231f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802322:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802329:	83 ec 0c             	sub    $0xc,%esp
  80232c:	50                   	push   %eax
  80232d:	e8 af ee ff ff       	call   8011e1 <fd2num>
  802332:	83 c4 10             	add    $0x10,%esp
}
  802335:	c9                   	leave  
  802336:	c3                   	ret    

00802337 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802337:	55                   	push   %ebp
  802338:	89 e5                	mov    %esp,%ebp
  80233a:	56                   	push   %esi
  80233b:	53                   	push   %ebx
  80233c:	8b 75 08             	mov    0x8(%ebp),%esi
  80233f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802342:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802345:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802347:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80234c:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80234f:	83 ec 0c             	sub    $0xc,%esp
  802352:	50                   	push   %eax
  802353:	e8 af ec ff ff       	call   801007 <sys_ipc_recv>
	if(ret < 0){
  802358:	83 c4 10             	add    $0x10,%esp
  80235b:	85 c0                	test   %eax,%eax
  80235d:	78 2b                	js     80238a <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80235f:	85 f6                	test   %esi,%esi
  802361:	74 0a                	je     80236d <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802363:	a1 08 40 80 00       	mov    0x804008,%eax
  802368:	8b 40 74             	mov    0x74(%eax),%eax
  80236b:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80236d:	85 db                	test   %ebx,%ebx
  80236f:	74 0a                	je     80237b <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802371:	a1 08 40 80 00       	mov    0x804008,%eax
  802376:	8b 40 78             	mov    0x78(%eax),%eax
  802379:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80237b:	a1 08 40 80 00       	mov    0x804008,%eax
  802380:	8b 40 70             	mov    0x70(%eax),%eax
}
  802383:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802386:	5b                   	pop    %ebx
  802387:	5e                   	pop    %esi
  802388:	5d                   	pop    %ebp
  802389:	c3                   	ret    
		if(from_env_store)
  80238a:	85 f6                	test   %esi,%esi
  80238c:	74 06                	je     802394 <ipc_recv+0x5d>
			*from_env_store = 0;
  80238e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802394:	85 db                	test   %ebx,%ebx
  802396:	74 eb                	je     802383 <ipc_recv+0x4c>
			*perm_store = 0;
  802398:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80239e:	eb e3                	jmp    802383 <ipc_recv+0x4c>

008023a0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8023a0:	55                   	push   %ebp
  8023a1:	89 e5                	mov    %esp,%ebp
  8023a3:	57                   	push   %edi
  8023a4:	56                   	push   %esi
  8023a5:	53                   	push   %ebx
  8023a6:	83 ec 0c             	sub    $0xc,%esp
  8023a9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8023ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023af:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8023b2:	85 db                	test   %ebx,%ebx
  8023b4:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8023b9:	0f 44 d8             	cmove  %eax,%ebx
  8023bc:	eb 05                	jmp    8023c3 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8023be:	e8 75 ea ff ff       	call   800e38 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8023c3:	ff 75 14             	pushl  0x14(%ebp)
  8023c6:	53                   	push   %ebx
  8023c7:	56                   	push   %esi
  8023c8:	57                   	push   %edi
  8023c9:	e8 16 ec ff ff       	call   800fe4 <sys_ipc_try_send>
  8023ce:	83 c4 10             	add    $0x10,%esp
  8023d1:	85 c0                	test   %eax,%eax
  8023d3:	74 1b                	je     8023f0 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8023d5:	79 e7                	jns    8023be <ipc_send+0x1e>
  8023d7:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8023da:	74 e2                	je     8023be <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8023dc:	83 ec 04             	sub    $0x4,%esp
  8023df:	68 d7 2d 80 00       	push   $0x802dd7
  8023e4:	6a 46                	push   $0x46
  8023e6:	68 ec 2d 80 00       	push   $0x802dec
  8023eb:	e8 20 de ff ff       	call   800210 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8023f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023f3:	5b                   	pop    %ebx
  8023f4:	5e                   	pop    %esi
  8023f5:	5f                   	pop    %edi
  8023f6:	5d                   	pop    %ebp
  8023f7:	c3                   	ret    

008023f8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8023fe:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802403:	89 c2                	mov    %eax,%edx
  802405:	c1 e2 07             	shl    $0x7,%edx
  802408:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80240e:	8b 52 50             	mov    0x50(%edx),%edx
  802411:	39 ca                	cmp    %ecx,%edx
  802413:	74 11                	je     802426 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802415:	83 c0 01             	add    $0x1,%eax
  802418:	3d 00 04 00 00       	cmp    $0x400,%eax
  80241d:	75 e4                	jne    802403 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80241f:	b8 00 00 00 00       	mov    $0x0,%eax
  802424:	eb 0b                	jmp    802431 <ipc_find_env+0x39>
			return envs[i].env_id;
  802426:	c1 e0 07             	shl    $0x7,%eax
  802429:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80242e:	8b 40 48             	mov    0x48(%eax),%eax
}
  802431:	5d                   	pop    %ebp
  802432:	c3                   	ret    

00802433 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802433:	55                   	push   %ebp
  802434:	89 e5                	mov    %esp,%ebp
  802436:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802439:	89 d0                	mov    %edx,%eax
  80243b:	c1 e8 16             	shr    $0x16,%eax
  80243e:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802445:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80244a:	f6 c1 01             	test   $0x1,%cl
  80244d:	74 1d                	je     80246c <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80244f:	c1 ea 0c             	shr    $0xc,%edx
  802452:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802459:	f6 c2 01             	test   $0x1,%dl
  80245c:	74 0e                	je     80246c <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80245e:	c1 ea 0c             	shr    $0xc,%edx
  802461:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802468:	ef 
  802469:	0f b7 c0             	movzwl %ax,%eax
}
  80246c:	5d                   	pop    %ebp
  80246d:	c3                   	ret    
  80246e:	66 90                	xchg   %ax,%ax

00802470 <__udivdi3>:
  802470:	55                   	push   %ebp
  802471:	57                   	push   %edi
  802472:	56                   	push   %esi
  802473:	53                   	push   %ebx
  802474:	83 ec 1c             	sub    $0x1c,%esp
  802477:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80247b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80247f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802483:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802487:	85 d2                	test   %edx,%edx
  802489:	75 4d                	jne    8024d8 <__udivdi3+0x68>
  80248b:	39 f3                	cmp    %esi,%ebx
  80248d:	76 19                	jbe    8024a8 <__udivdi3+0x38>
  80248f:	31 ff                	xor    %edi,%edi
  802491:	89 e8                	mov    %ebp,%eax
  802493:	89 f2                	mov    %esi,%edx
  802495:	f7 f3                	div    %ebx
  802497:	89 fa                	mov    %edi,%edx
  802499:	83 c4 1c             	add    $0x1c,%esp
  80249c:	5b                   	pop    %ebx
  80249d:	5e                   	pop    %esi
  80249e:	5f                   	pop    %edi
  80249f:	5d                   	pop    %ebp
  8024a0:	c3                   	ret    
  8024a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024a8:	89 d9                	mov    %ebx,%ecx
  8024aa:	85 db                	test   %ebx,%ebx
  8024ac:	75 0b                	jne    8024b9 <__udivdi3+0x49>
  8024ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8024b3:	31 d2                	xor    %edx,%edx
  8024b5:	f7 f3                	div    %ebx
  8024b7:	89 c1                	mov    %eax,%ecx
  8024b9:	31 d2                	xor    %edx,%edx
  8024bb:	89 f0                	mov    %esi,%eax
  8024bd:	f7 f1                	div    %ecx
  8024bf:	89 c6                	mov    %eax,%esi
  8024c1:	89 e8                	mov    %ebp,%eax
  8024c3:	89 f7                	mov    %esi,%edi
  8024c5:	f7 f1                	div    %ecx
  8024c7:	89 fa                	mov    %edi,%edx
  8024c9:	83 c4 1c             	add    $0x1c,%esp
  8024cc:	5b                   	pop    %ebx
  8024cd:	5e                   	pop    %esi
  8024ce:	5f                   	pop    %edi
  8024cf:	5d                   	pop    %ebp
  8024d0:	c3                   	ret    
  8024d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024d8:	39 f2                	cmp    %esi,%edx
  8024da:	77 1c                	ja     8024f8 <__udivdi3+0x88>
  8024dc:	0f bd fa             	bsr    %edx,%edi
  8024df:	83 f7 1f             	xor    $0x1f,%edi
  8024e2:	75 2c                	jne    802510 <__udivdi3+0xa0>
  8024e4:	39 f2                	cmp    %esi,%edx
  8024e6:	72 06                	jb     8024ee <__udivdi3+0x7e>
  8024e8:	31 c0                	xor    %eax,%eax
  8024ea:	39 eb                	cmp    %ebp,%ebx
  8024ec:	77 a9                	ja     802497 <__udivdi3+0x27>
  8024ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8024f3:	eb a2                	jmp    802497 <__udivdi3+0x27>
  8024f5:	8d 76 00             	lea    0x0(%esi),%esi
  8024f8:	31 ff                	xor    %edi,%edi
  8024fa:	31 c0                	xor    %eax,%eax
  8024fc:	89 fa                	mov    %edi,%edx
  8024fe:	83 c4 1c             	add    $0x1c,%esp
  802501:	5b                   	pop    %ebx
  802502:	5e                   	pop    %esi
  802503:	5f                   	pop    %edi
  802504:	5d                   	pop    %ebp
  802505:	c3                   	ret    
  802506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80250d:	8d 76 00             	lea    0x0(%esi),%esi
  802510:	89 f9                	mov    %edi,%ecx
  802512:	b8 20 00 00 00       	mov    $0x20,%eax
  802517:	29 f8                	sub    %edi,%eax
  802519:	d3 e2                	shl    %cl,%edx
  80251b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80251f:	89 c1                	mov    %eax,%ecx
  802521:	89 da                	mov    %ebx,%edx
  802523:	d3 ea                	shr    %cl,%edx
  802525:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802529:	09 d1                	or     %edx,%ecx
  80252b:	89 f2                	mov    %esi,%edx
  80252d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802531:	89 f9                	mov    %edi,%ecx
  802533:	d3 e3                	shl    %cl,%ebx
  802535:	89 c1                	mov    %eax,%ecx
  802537:	d3 ea                	shr    %cl,%edx
  802539:	89 f9                	mov    %edi,%ecx
  80253b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80253f:	89 eb                	mov    %ebp,%ebx
  802541:	d3 e6                	shl    %cl,%esi
  802543:	89 c1                	mov    %eax,%ecx
  802545:	d3 eb                	shr    %cl,%ebx
  802547:	09 de                	or     %ebx,%esi
  802549:	89 f0                	mov    %esi,%eax
  80254b:	f7 74 24 08          	divl   0x8(%esp)
  80254f:	89 d6                	mov    %edx,%esi
  802551:	89 c3                	mov    %eax,%ebx
  802553:	f7 64 24 0c          	mull   0xc(%esp)
  802557:	39 d6                	cmp    %edx,%esi
  802559:	72 15                	jb     802570 <__udivdi3+0x100>
  80255b:	89 f9                	mov    %edi,%ecx
  80255d:	d3 e5                	shl    %cl,%ebp
  80255f:	39 c5                	cmp    %eax,%ebp
  802561:	73 04                	jae    802567 <__udivdi3+0xf7>
  802563:	39 d6                	cmp    %edx,%esi
  802565:	74 09                	je     802570 <__udivdi3+0x100>
  802567:	89 d8                	mov    %ebx,%eax
  802569:	31 ff                	xor    %edi,%edi
  80256b:	e9 27 ff ff ff       	jmp    802497 <__udivdi3+0x27>
  802570:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802573:	31 ff                	xor    %edi,%edi
  802575:	e9 1d ff ff ff       	jmp    802497 <__udivdi3+0x27>
  80257a:	66 90                	xchg   %ax,%ax
  80257c:	66 90                	xchg   %ax,%ax
  80257e:	66 90                	xchg   %ax,%ax

00802580 <__umoddi3>:
  802580:	55                   	push   %ebp
  802581:	57                   	push   %edi
  802582:	56                   	push   %esi
  802583:	53                   	push   %ebx
  802584:	83 ec 1c             	sub    $0x1c,%esp
  802587:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80258b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80258f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802593:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802597:	89 da                	mov    %ebx,%edx
  802599:	85 c0                	test   %eax,%eax
  80259b:	75 43                	jne    8025e0 <__umoddi3+0x60>
  80259d:	39 df                	cmp    %ebx,%edi
  80259f:	76 17                	jbe    8025b8 <__umoddi3+0x38>
  8025a1:	89 f0                	mov    %esi,%eax
  8025a3:	f7 f7                	div    %edi
  8025a5:	89 d0                	mov    %edx,%eax
  8025a7:	31 d2                	xor    %edx,%edx
  8025a9:	83 c4 1c             	add    $0x1c,%esp
  8025ac:	5b                   	pop    %ebx
  8025ad:	5e                   	pop    %esi
  8025ae:	5f                   	pop    %edi
  8025af:	5d                   	pop    %ebp
  8025b0:	c3                   	ret    
  8025b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025b8:	89 fd                	mov    %edi,%ebp
  8025ba:	85 ff                	test   %edi,%edi
  8025bc:	75 0b                	jne    8025c9 <__umoddi3+0x49>
  8025be:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c3:	31 d2                	xor    %edx,%edx
  8025c5:	f7 f7                	div    %edi
  8025c7:	89 c5                	mov    %eax,%ebp
  8025c9:	89 d8                	mov    %ebx,%eax
  8025cb:	31 d2                	xor    %edx,%edx
  8025cd:	f7 f5                	div    %ebp
  8025cf:	89 f0                	mov    %esi,%eax
  8025d1:	f7 f5                	div    %ebp
  8025d3:	89 d0                	mov    %edx,%eax
  8025d5:	eb d0                	jmp    8025a7 <__umoddi3+0x27>
  8025d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025de:	66 90                	xchg   %ax,%ax
  8025e0:	89 f1                	mov    %esi,%ecx
  8025e2:	39 d8                	cmp    %ebx,%eax
  8025e4:	76 0a                	jbe    8025f0 <__umoddi3+0x70>
  8025e6:	89 f0                	mov    %esi,%eax
  8025e8:	83 c4 1c             	add    $0x1c,%esp
  8025eb:	5b                   	pop    %ebx
  8025ec:	5e                   	pop    %esi
  8025ed:	5f                   	pop    %edi
  8025ee:	5d                   	pop    %ebp
  8025ef:	c3                   	ret    
  8025f0:	0f bd e8             	bsr    %eax,%ebp
  8025f3:	83 f5 1f             	xor    $0x1f,%ebp
  8025f6:	75 20                	jne    802618 <__umoddi3+0x98>
  8025f8:	39 d8                	cmp    %ebx,%eax
  8025fa:	0f 82 b0 00 00 00    	jb     8026b0 <__umoddi3+0x130>
  802600:	39 f7                	cmp    %esi,%edi
  802602:	0f 86 a8 00 00 00    	jbe    8026b0 <__umoddi3+0x130>
  802608:	89 c8                	mov    %ecx,%eax
  80260a:	83 c4 1c             	add    $0x1c,%esp
  80260d:	5b                   	pop    %ebx
  80260e:	5e                   	pop    %esi
  80260f:	5f                   	pop    %edi
  802610:	5d                   	pop    %ebp
  802611:	c3                   	ret    
  802612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802618:	89 e9                	mov    %ebp,%ecx
  80261a:	ba 20 00 00 00       	mov    $0x20,%edx
  80261f:	29 ea                	sub    %ebp,%edx
  802621:	d3 e0                	shl    %cl,%eax
  802623:	89 44 24 08          	mov    %eax,0x8(%esp)
  802627:	89 d1                	mov    %edx,%ecx
  802629:	89 f8                	mov    %edi,%eax
  80262b:	d3 e8                	shr    %cl,%eax
  80262d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802631:	89 54 24 04          	mov    %edx,0x4(%esp)
  802635:	8b 54 24 04          	mov    0x4(%esp),%edx
  802639:	09 c1                	or     %eax,%ecx
  80263b:	89 d8                	mov    %ebx,%eax
  80263d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802641:	89 e9                	mov    %ebp,%ecx
  802643:	d3 e7                	shl    %cl,%edi
  802645:	89 d1                	mov    %edx,%ecx
  802647:	d3 e8                	shr    %cl,%eax
  802649:	89 e9                	mov    %ebp,%ecx
  80264b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80264f:	d3 e3                	shl    %cl,%ebx
  802651:	89 c7                	mov    %eax,%edi
  802653:	89 d1                	mov    %edx,%ecx
  802655:	89 f0                	mov    %esi,%eax
  802657:	d3 e8                	shr    %cl,%eax
  802659:	89 e9                	mov    %ebp,%ecx
  80265b:	89 fa                	mov    %edi,%edx
  80265d:	d3 e6                	shl    %cl,%esi
  80265f:	09 d8                	or     %ebx,%eax
  802661:	f7 74 24 08          	divl   0x8(%esp)
  802665:	89 d1                	mov    %edx,%ecx
  802667:	89 f3                	mov    %esi,%ebx
  802669:	f7 64 24 0c          	mull   0xc(%esp)
  80266d:	89 c6                	mov    %eax,%esi
  80266f:	89 d7                	mov    %edx,%edi
  802671:	39 d1                	cmp    %edx,%ecx
  802673:	72 06                	jb     80267b <__umoddi3+0xfb>
  802675:	75 10                	jne    802687 <__umoddi3+0x107>
  802677:	39 c3                	cmp    %eax,%ebx
  802679:	73 0c                	jae    802687 <__umoddi3+0x107>
  80267b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80267f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802683:	89 d7                	mov    %edx,%edi
  802685:	89 c6                	mov    %eax,%esi
  802687:	89 ca                	mov    %ecx,%edx
  802689:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80268e:	29 f3                	sub    %esi,%ebx
  802690:	19 fa                	sbb    %edi,%edx
  802692:	89 d0                	mov    %edx,%eax
  802694:	d3 e0                	shl    %cl,%eax
  802696:	89 e9                	mov    %ebp,%ecx
  802698:	d3 eb                	shr    %cl,%ebx
  80269a:	d3 ea                	shr    %cl,%edx
  80269c:	09 d8                	or     %ebx,%eax
  80269e:	83 c4 1c             	add    $0x1c,%esp
  8026a1:	5b                   	pop    %ebx
  8026a2:	5e                   	pop    %esi
  8026a3:	5f                   	pop    %edi
  8026a4:	5d                   	pop    %ebp
  8026a5:	c3                   	ret    
  8026a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026ad:	8d 76 00             	lea    0x0(%esi),%esi
  8026b0:	89 da                	mov    %ebx,%edx
  8026b2:	29 fe                	sub    %edi,%esi
  8026b4:	19 c2                	sbb    %eax,%edx
  8026b6:	89 f1                	mov    %esi,%ecx
  8026b8:	89 c8                	mov    %ecx,%eax
  8026ba:	e9 4b ff ff ff       	jmp    80260a <__umoddi3+0x8a>
