
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
  80003a:	68 48 14 80 00       	push   $0x801448
  80003f:	68 20 13 80 00       	push   $0x801320
  800044:	e8 57 02 00 00       	call   8002a0 <cprintf>
	int r;
	void *addr = (void*)utf->utf_fault_va;
  800049:	8b 45 08             	mov    0x8(%ebp),%eax
  80004c:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  80004e:	83 c4 08             	add    $0x8,%esp
  800051:	53                   	push   %ebx
  800052:	68 06 14 80 00       	push   $0x801406
  800057:	e8 44 02 00 00       	call   8002a0 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80005c:	83 c4 0c             	add    $0xc,%esp
  80005f:	6a 07                	push   $0x7
  800061:	89 d8                	mov    %ebx,%eax
  800063:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800068:	50                   	push   %eax
  800069:	6a 00                	push   $0x0
  80006b:	e8 81 0d 00 00       	call   800df1 <sys_page_alloc>
  800070:	83 c4 10             	add    $0x10,%esp
  800073:	85 c0                	test   %eax,%eax
  800075:	78 16                	js     80008d <handler+0x5a>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800077:	53                   	push   %ebx
  800078:	68 78 13 80 00       	push   $0x801378
  80007d:	6a 64                	push   $0x64
  80007f:	53                   	push   %ebx
  800080:	e8 27 09 00 00       	call   8009ac <snprintf>
}
  800085:	83 c4 10             	add    $0x10,%esp
  800088:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80008b:	c9                   	leave  
  80008c:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80008d:	83 ec 0c             	sub    $0xc,%esp
  800090:	50                   	push   %eax
  800091:	53                   	push   %ebx
  800092:	68 4c 13 80 00       	push   $0x80134c
  800097:	6a 10                	push   $0x10
  800099:	68 10 14 80 00       	push   $0x801410
  80009e:	e8 07 01 00 00       	call   8001aa <_panic>

008000a3 <umain>:

void
umain(int argc, char **argv)
{
  8000a3:	55                   	push   %ebp
  8000a4:	89 e5                	mov    %esp,%ebp
  8000a6:	83 ec 14             	sub    $0x14,%esp
	cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8000a9:	68 9c 13 80 00       	push   $0x80139c
  8000ae:	e8 ed 01 00 00       	call   8002a0 <cprintf>
	cprintf("before set_pgfault_handler() in %s\n", __FUNCTION__);
  8000b3:	83 c4 08             	add    $0x8,%esp
  8000b6:	68 40 14 80 00       	push   $0x801440
  8000bb:	68 c0 13 80 00       	push   $0x8013c0
  8000c0:	e8 db 01 00 00       	call   8002a0 <cprintf>
	set_pgfault_handler(handler);
  8000c5:	c7 04 24 33 00 80 00 	movl   $0x800033,(%esp)
  8000cc:	e8 52 0f 00 00       	call   801023 <set_pgfault_handler>
	cprintf(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
  8000d1:	c7 04 24 e4 13 80 00 	movl   $0x8013e4,(%esp)
  8000d8:	e8 c3 01 00 00       	call   8002a0 <cprintf>
	cprintf("before sys_cputs() in %s\n", __FUNCTION__);
  8000dd:	83 c4 08             	add    $0x8,%esp
  8000e0:	68 40 14 80 00       	push   $0x801440
  8000e5:	68 25 14 80 00       	push   $0x801425
  8000ea:	e8 b1 01 00 00       	call   8002a0 <cprintf>
	sys_cputs((char*)0xDEADBEEF, 4);
  8000ef:	83 c4 08             	add    $0x8,%esp
  8000f2:	6a 04                	push   $0x4
  8000f4:	68 ef be ad de       	push   $0xdeadbeef
  8000f9:	e8 37 0c 00 00       	call   800d35 <sys_cputs>
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
  80010c:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  800113:	00 00 00 
	envid_t find = sys_getenvid();
  800116:	e8 98 0c 00 00       	call   800db3 <sys_getenvid>
  80011b:	8b 1d 04 20 80 00    	mov    0x802004,%ebx
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
  800164:	89 1d 04 20 80 00    	mov    %ebx,0x802004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80016a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80016e:	7e 0a                	jle    80017a <libmain+0x77>
		binaryname = argv[0];
  800170:	8b 45 0c             	mov    0xc(%ebp),%eax
  800173:	8b 00                	mov    (%eax),%eax
  800175:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  80017a:	83 ec 08             	sub    $0x8,%esp
  80017d:	ff 75 0c             	pushl  0xc(%ebp)
  800180:	ff 75 08             	pushl  0x8(%ebp)
  800183:	e8 1b ff ff ff       	call   8000a3 <umain>

	// exit gracefully
	exit();
  800188:	e8 0b 00 00 00       	call   800198 <exit>
}
  80018d:	83 c4 10             	add    $0x10,%esp
  800190:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800193:	5b                   	pop    %ebx
  800194:	5e                   	pop    %esi
  800195:	5f                   	pop    %edi
  800196:	5d                   	pop    %ebp
  800197:	c3                   	ret    

00800198 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800198:	55                   	push   %ebp
  800199:	89 e5                	mov    %esp,%ebp
  80019b:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80019e:	6a 00                	push   $0x0
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
  8001af:	a1 04 20 80 00       	mov    0x802004,%eax
  8001b4:	8b 40 48             	mov    0x48(%eax),%eax
  8001b7:	83 ec 04             	sub    $0x4,%esp
  8001ba:	68 8c 14 80 00       	push   $0x80148c
  8001bf:	50                   	push   %eax
  8001c0:	68 5a 14 80 00       	push   $0x80145a
  8001c5:	e8 d6 00 00 00       	call   8002a0 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8001ca:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001cd:	8b 35 00 20 80 00    	mov    0x802000,%esi
  8001d3:	e8 db 0b 00 00       	call   800db3 <sys_getenvid>
  8001d8:	83 c4 04             	add    $0x4,%esp
  8001db:	ff 75 0c             	pushl  0xc(%ebp)
  8001de:	ff 75 08             	pushl  0x8(%ebp)
  8001e1:	56                   	push   %esi
  8001e2:	50                   	push   %eax
  8001e3:	68 68 14 80 00       	push   $0x801468
  8001e8:	e8 b3 00 00 00       	call   8002a0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001ed:	83 c4 18             	add    $0x18,%esp
  8001f0:	53                   	push   %ebx
  8001f1:	ff 75 10             	pushl  0x10(%ebp)
  8001f4:	e8 56 00 00 00       	call   80024f <vcprintf>
	cprintf("\n");
  8001f9:	c7 04 24 3d 14 80 00 	movl   $0x80143d,(%esp)
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
  80034d:	e8 6e 0d 00 00       	call   8010c0 <__udivdi3>
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
  800376:	e8 55 0e 00 00       	call   8011d0 <__umoddi3>
  80037b:	83 c4 14             	add    $0x14,%esp
  80037e:	0f be 80 93 14 80 00 	movsbl 0x801493(%eax),%eax
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
  800427:	ff 24 85 80 16 80 00 	jmp    *0x801680(,%eax,4)
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
  8004ed:	83 f8 0f             	cmp    $0xf,%eax
  8004f0:	7f 23                	jg     800515 <vprintfmt+0x148>
  8004f2:	8b 14 85 e0 17 80 00 	mov    0x8017e0(,%eax,4),%edx
  8004f9:	85 d2                	test   %edx,%edx
  8004fb:	74 18                	je     800515 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004fd:	52                   	push   %edx
  8004fe:	68 b4 14 80 00       	push   $0x8014b4
  800503:	53                   	push   %ebx
  800504:	56                   	push   %esi
  800505:	e8 a6 fe ff ff       	call   8003b0 <printfmt>
  80050a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80050d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800510:	e9 fe 02 00 00       	jmp    800813 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800515:	50                   	push   %eax
  800516:	68 ab 14 80 00       	push   $0x8014ab
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
  80053d:	b8 a4 14 80 00       	mov    $0x8014a4,%eax
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
  8008d5:	bf cd 15 80 00       	mov    $0x8015cd,%edi
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
  800901:	bf 05 16 80 00       	mov    $0x801605,%edi
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
  800da2:	68 20 18 80 00       	push   $0x801820
  800da7:	6a 43                	push   $0x43
  800da9:	68 3d 18 80 00       	push   $0x80183d
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
  800e23:	68 20 18 80 00       	push   $0x801820
  800e28:	6a 43                	push   $0x43
  800e2a:	68 3d 18 80 00       	push   $0x80183d
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
  800e65:	68 20 18 80 00       	push   $0x801820
  800e6a:	6a 43                	push   $0x43
  800e6c:	68 3d 18 80 00       	push   $0x80183d
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
  800ea7:	68 20 18 80 00       	push   $0x801820
  800eac:	6a 43                	push   $0x43
  800eae:	68 3d 18 80 00       	push   $0x80183d
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
  800ee9:	68 20 18 80 00       	push   $0x801820
  800eee:	6a 43                	push   $0x43
  800ef0:	68 3d 18 80 00       	push   $0x80183d
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
  800f2b:	68 20 18 80 00       	push   $0x801820
  800f30:	6a 43                	push   $0x43
  800f32:	68 3d 18 80 00       	push   $0x80183d
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
  800f6d:	68 20 18 80 00       	push   $0x801820
  800f72:	6a 43                	push   $0x43
  800f74:	68 3d 18 80 00       	push   $0x80183d
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
  800fd1:	68 20 18 80 00       	push   $0x801820
  800fd6:	6a 43                	push   $0x43
  800fd8:	68 3d 18 80 00       	push   $0x80183d
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

00801023 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801023:	55                   	push   %ebp
  801024:	89 e5                	mov    %esp,%ebp
  801026:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801029:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  801030:	74 0a                	je     80103c <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	a3 08 20 80 00       	mov    %eax,0x802008
}
  80103a:	c9                   	leave  
  80103b:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80103c:	83 ec 04             	sub    $0x4,%esp
  80103f:	6a 07                	push   $0x7
  801041:	68 00 f0 bf ee       	push   $0xeebff000
  801046:	6a 00                	push   $0x0
  801048:	e8 a4 fd ff ff       	call   800df1 <sys_page_alloc>
		if(r < 0)
  80104d:	83 c4 10             	add    $0x10,%esp
  801050:	85 c0                	test   %eax,%eax
  801052:	78 2a                	js     80107e <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  801054:	83 ec 08             	sub    $0x8,%esp
  801057:	68 92 10 80 00       	push   $0x801092
  80105c:	6a 00                	push   $0x0
  80105e:	e8 d9 fe ff ff       	call   800f3c <sys_env_set_pgfault_upcall>
		if(r < 0)
  801063:	83 c4 10             	add    $0x10,%esp
  801066:	85 c0                	test   %eax,%eax
  801068:	79 c8                	jns    801032 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  80106a:	83 ec 04             	sub    $0x4,%esp
  80106d:	68 7c 18 80 00       	push   $0x80187c
  801072:	6a 25                	push   $0x25
  801074:	68 b8 18 80 00       	push   $0x8018b8
  801079:	e8 2c f1 ff ff       	call   8001aa <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  80107e:	83 ec 04             	sub    $0x4,%esp
  801081:	68 4c 18 80 00       	push   $0x80184c
  801086:	6a 22                	push   $0x22
  801088:	68 b8 18 80 00       	push   $0x8018b8
  80108d:	e8 18 f1 ff ff       	call   8001aa <_panic>

00801092 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801092:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801093:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  801098:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80109a:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  80109d:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8010a1:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8010a5:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8010a8:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8010aa:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8010ae:	83 c4 08             	add    $0x8,%esp
	popal
  8010b1:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8010b2:	83 c4 04             	add    $0x4,%esp
	popfl
  8010b5:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8010b6:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8010b7:	c3                   	ret    
  8010b8:	66 90                	xchg   %ax,%ax
  8010ba:	66 90                	xchg   %ax,%ax
  8010bc:	66 90                	xchg   %ax,%ax
  8010be:	66 90                	xchg   %ax,%ax

008010c0 <__udivdi3>:
  8010c0:	55                   	push   %ebp
  8010c1:	57                   	push   %edi
  8010c2:	56                   	push   %esi
  8010c3:	53                   	push   %ebx
  8010c4:	83 ec 1c             	sub    $0x1c,%esp
  8010c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8010cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8010cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8010d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8010d7:	85 d2                	test   %edx,%edx
  8010d9:	75 4d                	jne    801128 <__udivdi3+0x68>
  8010db:	39 f3                	cmp    %esi,%ebx
  8010dd:	76 19                	jbe    8010f8 <__udivdi3+0x38>
  8010df:	31 ff                	xor    %edi,%edi
  8010e1:	89 e8                	mov    %ebp,%eax
  8010e3:	89 f2                	mov    %esi,%edx
  8010e5:	f7 f3                	div    %ebx
  8010e7:	89 fa                	mov    %edi,%edx
  8010e9:	83 c4 1c             	add    $0x1c,%esp
  8010ec:	5b                   	pop    %ebx
  8010ed:	5e                   	pop    %esi
  8010ee:	5f                   	pop    %edi
  8010ef:	5d                   	pop    %ebp
  8010f0:	c3                   	ret    
  8010f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010f8:	89 d9                	mov    %ebx,%ecx
  8010fa:	85 db                	test   %ebx,%ebx
  8010fc:	75 0b                	jne    801109 <__udivdi3+0x49>
  8010fe:	b8 01 00 00 00       	mov    $0x1,%eax
  801103:	31 d2                	xor    %edx,%edx
  801105:	f7 f3                	div    %ebx
  801107:	89 c1                	mov    %eax,%ecx
  801109:	31 d2                	xor    %edx,%edx
  80110b:	89 f0                	mov    %esi,%eax
  80110d:	f7 f1                	div    %ecx
  80110f:	89 c6                	mov    %eax,%esi
  801111:	89 e8                	mov    %ebp,%eax
  801113:	89 f7                	mov    %esi,%edi
  801115:	f7 f1                	div    %ecx
  801117:	89 fa                	mov    %edi,%edx
  801119:	83 c4 1c             	add    $0x1c,%esp
  80111c:	5b                   	pop    %ebx
  80111d:	5e                   	pop    %esi
  80111e:	5f                   	pop    %edi
  80111f:	5d                   	pop    %ebp
  801120:	c3                   	ret    
  801121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801128:	39 f2                	cmp    %esi,%edx
  80112a:	77 1c                	ja     801148 <__udivdi3+0x88>
  80112c:	0f bd fa             	bsr    %edx,%edi
  80112f:	83 f7 1f             	xor    $0x1f,%edi
  801132:	75 2c                	jne    801160 <__udivdi3+0xa0>
  801134:	39 f2                	cmp    %esi,%edx
  801136:	72 06                	jb     80113e <__udivdi3+0x7e>
  801138:	31 c0                	xor    %eax,%eax
  80113a:	39 eb                	cmp    %ebp,%ebx
  80113c:	77 a9                	ja     8010e7 <__udivdi3+0x27>
  80113e:	b8 01 00 00 00       	mov    $0x1,%eax
  801143:	eb a2                	jmp    8010e7 <__udivdi3+0x27>
  801145:	8d 76 00             	lea    0x0(%esi),%esi
  801148:	31 ff                	xor    %edi,%edi
  80114a:	31 c0                	xor    %eax,%eax
  80114c:	89 fa                	mov    %edi,%edx
  80114e:	83 c4 1c             	add    $0x1c,%esp
  801151:	5b                   	pop    %ebx
  801152:	5e                   	pop    %esi
  801153:	5f                   	pop    %edi
  801154:	5d                   	pop    %ebp
  801155:	c3                   	ret    
  801156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80115d:	8d 76 00             	lea    0x0(%esi),%esi
  801160:	89 f9                	mov    %edi,%ecx
  801162:	b8 20 00 00 00       	mov    $0x20,%eax
  801167:	29 f8                	sub    %edi,%eax
  801169:	d3 e2                	shl    %cl,%edx
  80116b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80116f:	89 c1                	mov    %eax,%ecx
  801171:	89 da                	mov    %ebx,%edx
  801173:	d3 ea                	shr    %cl,%edx
  801175:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801179:	09 d1                	or     %edx,%ecx
  80117b:	89 f2                	mov    %esi,%edx
  80117d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801181:	89 f9                	mov    %edi,%ecx
  801183:	d3 e3                	shl    %cl,%ebx
  801185:	89 c1                	mov    %eax,%ecx
  801187:	d3 ea                	shr    %cl,%edx
  801189:	89 f9                	mov    %edi,%ecx
  80118b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80118f:	89 eb                	mov    %ebp,%ebx
  801191:	d3 e6                	shl    %cl,%esi
  801193:	89 c1                	mov    %eax,%ecx
  801195:	d3 eb                	shr    %cl,%ebx
  801197:	09 de                	or     %ebx,%esi
  801199:	89 f0                	mov    %esi,%eax
  80119b:	f7 74 24 08          	divl   0x8(%esp)
  80119f:	89 d6                	mov    %edx,%esi
  8011a1:	89 c3                	mov    %eax,%ebx
  8011a3:	f7 64 24 0c          	mull   0xc(%esp)
  8011a7:	39 d6                	cmp    %edx,%esi
  8011a9:	72 15                	jb     8011c0 <__udivdi3+0x100>
  8011ab:	89 f9                	mov    %edi,%ecx
  8011ad:	d3 e5                	shl    %cl,%ebp
  8011af:	39 c5                	cmp    %eax,%ebp
  8011b1:	73 04                	jae    8011b7 <__udivdi3+0xf7>
  8011b3:	39 d6                	cmp    %edx,%esi
  8011b5:	74 09                	je     8011c0 <__udivdi3+0x100>
  8011b7:	89 d8                	mov    %ebx,%eax
  8011b9:	31 ff                	xor    %edi,%edi
  8011bb:	e9 27 ff ff ff       	jmp    8010e7 <__udivdi3+0x27>
  8011c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8011c3:	31 ff                	xor    %edi,%edi
  8011c5:	e9 1d ff ff ff       	jmp    8010e7 <__udivdi3+0x27>
  8011ca:	66 90                	xchg   %ax,%ax
  8011cc:	66 90                	xchg   %ax,%ax
  8011ce:	66 90                	xchg   %ax,%ax

008011d0 <__umoddi3>:
  8011d0:	55                   	push   %ebp
  8011d1:	57                   	push   %edi
  8011d2:	56                   	push   %esi
  8011d3:	53                   	push   %ebx
  8011d4:	83 ec 1c             	sub    $0x1c,%esp
  8011d7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8011db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8011df:	8b 74 24 30          	mov    0x30(%esp),%esi
  8011e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8011e7:	89 da                	mov    %ebx,%edx
  8011e9:	85 c0                	test   %eax,%eax
  8011eb:	75 43                	jne    801230 <__umoddi3+0x60>
  8011ed:	39 df                	cmp    %ebx,%edi
  8011ef:	76 17                	jbe    801208 <__umoddi3+0x38>
  8011f1:	89 f0                	mov    %esi,%eax
  8011f3:	f7 f7                	div    %edi
  8011f5:	89 d0                	mov    %edx,%eax
  8011f7:	31 d2                	xor    %edx,%edx
  8011f9:	83 c4 1c             	add    $0x1c,%esp
  8011fc:	5b                   	pop    %ebx
  8011fd:	5e                   	pop    %esi
  8011fe:	5f                   	pop    %edi
  8011ff:	5d                   	pop    %ebp
  801200:	c3                   	ret    
  801201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801208:	89 fd                	mov    %edi,%ebp
  80120a:	85 ff                	test   %edi,%edi
  80120c:	75 0b                	jne    801219 <__umoddi3+0x49>
  80120e:	b8 01 00 00 00       	mov    $0x1,%eax
  801213:	31 d2                	xor    %edx,%edx
  801215:	f7 f7                	div    %edi
  801217:	89 c5                	mov    %eax,%ebp
  801219:	89 d8                	mov    %ebx,%eax
  80121b:	31 d2                	xor    %edx,%edx
  80121d:	f7 f5                	div    %ebp
  80121f:	89 f0                	mov    %esi,%eax
  801221:	f7 f5                	div    %ebp
  801223:	89 d0                	mov    %edx,%eax
  801225:	eb d0                	jmp    8011f7 <__umoddi3+0x27>
  801227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80122e:	66 90                	xchg   %ax,%ax
  801230:	89 f1                	mov    %esi,%ecx
  801232:	39 d8                	cmp    %ebx,%eax
  801234:	76 0a                	jbe    801240 <__umoddi3+0x70>
  801236:	89 f0                	mov    %esi,%eax
  801238:	83 c4 1c             	add    $0x1c,%esp
  80123b:	5b                   	pop    %ebx
  80123c:	5e                   	pop    %esi
  80123d:	5f                   	pop    %edi
  80123e:	5d                   	pop    %ebp
  80123f:	c3                   	ret    
  801240:	0f bd e8             	bsr    %eax,%ebp
  801243:	83 f5 1f             	xor    $0x1f,%ebp
  801246:	75 20                	jne    801268 <__umoddi3+0x98>
  801248:	39 d8                	cmp    %ebx,%eax
  80124a:	0f 82 b0 00 00 00    	jb     801300 <__umoddi3+0x130>
  801250:	39 f7                	cmp    %esi,%edi
  801252:	0f 86 a8 00 00 00    	jbe    801300 <__umoddi3+0x130>
  801258:	89 c8                	mov    %ecx,%eax
  80125a:	83 c4 1c             	add    $0x1c,%esp
  80125d:	5b                   	pop    %ebx
  80125e:	5e                   	pop    %esi
  80125f:	5f                   	pop    %edi
  801260:	5d                   	pop    %ebp
  801261:	c3                   	ret    
  801262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801268:	89 e9                	mov    %ebp,%ecx
  80126a:	ba 20 00 00 00       	mov    $0x20,%edx
  80126f:	29 ea                	sub    %ebp,%edx
  801271:	d3 e0                	shl    %cl,%eax
  801273:	89 44 24 08          	mov    %eax,0x8(%esp)
  801277:	89 d1                	mov    %edx,%ecx
  801279:	89 f8                	mov    %edi,%eax
  80127b:	d3 e8                	shr    %cl,%eax
  80127d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801281:	89 54 24 04          	mov    %edx,0x4(%esp)
  801285:	8b 54 24 04          	mov    0x4(%esp),%edx
  801289:	09 c1                	or     %eax,%ecx
  80128b:	89 d8                	mov    %ebx,%eax
  80128d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801291:	89 e9                	mov    %ebp,%ecx
  801293:	d3 e7                	shl    %cl,%edi
  801295:	89 d1                	mov    %edx,%ecx
  801297:	d3 e8                	shr    %cl,%eax
  801299:	89 e9                	mov    %ebp,%ecx
  80129b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80129f:	d3 e3                	shl    %cl,%ebx
  8012a1:	89 c7                	mov    %eax,%edi
  8012a3:	89 d1                	mov    %edx,%ecx
  8012a5:	89 f0                	mov    %esi,%eax
  8012a7:	d3 e8                	shr    %cl,%eax
  8012a9:	89 e9                	mov    %ebp,%ecx
  8012ab:	89 fa                	mov    %edi,%edx
  8012ad:	d3 e6                	shl    %cl,%esi
  8012af:	09 d8                	or     %ebx,%eax
  8012b1:	f7 74 24 08          	divl   0x8(%esp)
  8012b5:	89 d1                	mov    %edx,%ecx
  8012b7:	89 f3                	mov    %esi,%ebx
  8012b9:	f7 64 24 0c          	mull   0xc(%esp)
  8012bd:	89 c6                	mov    %eax,%esi
  8012bf:	89 d7                	mov    %edx,%edi
  8012c1:	39 d1                	cmp    %edx,%ecx
  8012c3:	72 06                	jb     8012cb <__umoddi3+0xfb>
  8012c5:	75 10                	jne    8012d7 <__umoddi3+0x107>
  8012c7:	39 c3                	cmp    %eax,%ebx
  8012c9:	73 0c                	jae    8012d7 <__umoddi3+0x107>
  8012cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8012cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8012d3:	89 d7                	mov    %edx,%edi
  8012d5:	89 c6                	mov    %eax,%esi
  8012d7:	89 ca                	mov    %ecx,%edx
  8012d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8012de:	29 f3                	sub    %esi,%ebx
  8012e0:	19 fa                	sbb    %edi,%edx
  8012e2:	89 d0                	mov    %edx,%eax
  8012e4:	d3 e0                	shl    %cl,%eax
  8012e6:	89 e9                	mov    %ebp,%ecx
  8012e8:	d3 eb                	shr    %cl,%ebx
  8012ea:	d3 ea                	shr    %cl,%edx
  8012ec:	09 d8                	or     %ebx,%eax
  8012ee:	83 c4 1c             	add    $0x1c,%esp
  8012f1:	5b                   	pop    %ebx
  8012f2:	5e                   	pop    %esi
  8012f3:	5f                   	pop    %edi
  8012f4:	5d                   	pop    %ebp
  8012f5:	c3                   	ret    
  8012f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8012fd:	8d 76 00             	lea    0x0(%esi),%esi
  801300:	89 da                	mov    %ebx,%edx
  801302:	29 fe                	sub    %edi,%esi
  801304:	19 c2                	sbb    %eax,%edx
  801306:	89 f1                	mov    %esi,%ecx
  801308:	89 c8                	mov    %ecx,%eax
  80130a:	e9 4b ff ff ff       	jmp    80125a <__umoddi3+0x8a>
