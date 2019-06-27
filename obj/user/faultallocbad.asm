
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
  80003a:	68 08 28 80 00       	push   $0x802808
  80003f:	68 e0 26 80 00       	push   $0x8026e0
  800044:	e8 bf 02 00 00       	call   800308 <cprintf>
	int r;
	void *addr = (void*)utf->utf_fault_va;
  800049:	8b 45 08             	mov    0x8(%ebp),%eax
  80004c:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  80004e:	83 c4 08             	add    $0x8,%esp
  800051:	53                   	push   %ebx
  800052:	68 c6 27 80 00       	push   $0x8027c6
  800057:	e8 ac 02 00 00       	call   800308 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80005c:	83 c4 0c             	add    $0xc,%esp
  80005f:	6a 07                	push   $0x7
  800061:	89 d8                	mov    %ebx,%eax
  800063:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800068:	50                   	push   %eax
  800069:	6a 00                	push   $0x0
  80006b:	e8 e9 0d 00 00       	call   800e59 <sys_page_alloc>
  800070:	83 c4 10             	add    $0x10,%esp
  800073:	85 c0                	test   %eax,%eax
  800075:	78 16                	js     80008d <handler+0x5a>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800077:	53                   	push   %ebx
  800078:	68 38 27 80 00       	push   $0x802738
  80007d:	6a 64                	push   $0x64
  80007f:	53                   	push   %ebx
  800080:	e8 8f 09 00 00       	call   800a14 <snprintf>
}
  800085:	83 c4 10             	add    $0x10,%esp
  800088:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80008b:	c9                   	leave  
  80008c:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80008d:	83 ec 0c             	sub    $0xc,%esp
  800090:	50                   	push   %eax
  800091:	53                   	push   %ebx
  800092:	68 0c 27 80 00       	push   $0x80270c
  800097:	6a 10                	push   $0x10
  800099:	68 d0 27 80 00       	push   $0x8027d0
  80009e:	e8 6f 01 00 00       	call   800212 <_panic>

008000a3 <umain>:

void
umain(int argc, char **argv)
{
  8000a3:	55                   	push   %ebp
  8000a4:	89 e5                	mov    %esp,%ebp
  8000a6:	83 ec 14             	sub    $0x14,%esp
	cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8000a9:	68 5c 27 80 00       	push   $0x80275c
  8000ae:	e8 55 02 00 00       	call   800308 <cprintf>
	cprintf("before set_pgfault_handler() in %s\n", __FUNCTION__);
  8000b3:	83 c4 08             	add    $0x8,%esp
  8000b6:	68 00 28 80 00       	push   $0x802800
  8000bb:	68 80 27 80 00       	push   $0x802780
  8000c0:	e8 43 02 00 00       	call   800308 <cprintf>
	set_pgfault_handler(handler);
  8000c5:	c7 04 24 33 00 80 00 	movl   $0x800033,(%esp)
  8000cc:	e8 7d 10 00 00       	call   80114e <set_pgfault_handler>
	cprintf(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
  8000d1:	c7 04 24 a4 27 80 00 	movl   $0x8027a4,(%esp)
  8000d8:	e8 2b 02 00 00       	call   800308 <cprintf>
	cprintf("before sys_cputs() in %s\n", __FUNCTION__);
  8000dd:	83 c4 08             	add    $0x8,%esp
  8000e0:	68 00 28 80 00       	push   $0x802800
  8000e5:	68 e5 27 80 00       	push   $0x8027e5
  8000ea:	e8 19 02 00 00       	call   800308 <cprintf>
	sys_cputs((char*)0xDEADBEEF, 4);
  8000ef:	83 c4 08             	add    $0x8,%esp
  8000f2:	6a 04                	push   $0x4
  8000f4:	68 ef be ad de       	push   $0xdeadbeef
  8000f9:	e8 9f 0c 00 00       	call   800d9d <sys_cputs>
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
  800116:	e8 00 0d 00 00       	call   800e1b <sys_getenvid>
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
  80013b:	74 23                	je     800160 <libmain+0x5d>
		if(envs[i].env_id == find)
  80013d:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  800143:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800149:	8b 49 48             	mov    0x48(%ecx),%ecx
  80014c:	39 c1                	cmp    %eax,%ecx
  80014e:	75 e2                	jne    800132 <libmain+0x2f>
  800150:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  800156:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80015c:	89 fe                	mov    %edi,%esi
  80015e:	eb d2                	jmp    800132 <libmain+0x2f>
  800160:	89 f0                	mov    %esi,%eax
  800162:	84 c0                	test   %al,%al
  800164:	74 06                	je     80016c <libmain+0x69>
  800166:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80016c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800170:	7e 0a                	jle    80017c <libmain+0x79>
		binaryname = argv[0];
  800172:	8b 45 0c             	mov    0xc(%ebp),%eax
  800175:	8b 00                	mov    (%eax),%eax
  800177:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80017c:	a1 08 40 80 00       	mov    0x804008,%eax
  800181:	8b 40 48             	mov    0x48(%eax),%eax
  800184:	83 ec 08             	sub    $0x8,%esp
  800187:	50                   	push   %eax
  800188:	68 10 28 80 00       	push   $0x802810
  80018d:	e8 76 01 00 00       	call   800308 <cprintf>
	cprintf("before umain\n");
  800192:	c7 04 24 2e 28 80 00 	movl   $0x80282e,(%esp)
  800199:	e8 6a 01 00 00       	call   800308 <cprintf>
	// call user main routine
	umain(argc, argv);
  80019e:	83 c4 08             	add    $0x8,%esp
  8001a1:	ff 75 0c             	pushl  0xc(%ebp)
  8001a4:	ff 75 08             	pushl  0x8(%ebp)
  8001a7:	e8 f7 fe ff ff       	call   8000a3 <umain>
	cprintf("after umain\n");
  8001ac:	c7 04 24 3c 28 80 00 	movl   $0x80283c,(%esp)
  8001b3:	e8 50 01 00 00       	call   800308 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8001b8:	a1 08 40 80 00       	mov    0x804008,%eax
  8001bd:	8b 40 48             	mov    0x48(%eax),%eax
  8001c0:	83 c4 08             	add    $0x8,%esp
  8001c3:	50                   	push   %eax
  8001c4:	68 49 28 80 00       	push   $0x802849
  8001c9:	e8 3a 01 00 00       	call   800308 <cprintf>
	// exit gracefully
	exit();
  8001ce:	e8 0b 00 00 00       	call   8001de <exit>
}
  8001d3:	83 c4 10             	add    $0x10,%esp
  8001d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d9:	5b                   	pop    %ebx
  8001da:	5e                   	pop    %esi
  8001db:	5f                   	pop    %edi
  8001dc:	5d                   	pop    %ebp
  8001dd:	c3                   	ret    

008001de <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001de:	55                   	push   %ebp
  8001df:	89 e5                	mov    %esp,%ebp
  8001e1:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001e4:	a1 08 40 80 00       	mov    0x804008,%eax
  8001e9:	8b 40 48             	mov    0x48(%eax),%eax
  8001ec:	68 74 28 80 00       	push   $0x802874
  8001f1:	50                   	push   %eax
  8001f2:	68 68 28 80 00       	push   $0x802868
  8001f7:	e8 0c 01 00 00       	call   800308 <cprintf>
	close_all();
  8001fc:	e8 ba 11 00 00       	call   8013bb <close_all>
	sys_env_destroy(0);
  800201:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800208:	e8 cd 0b 00 00       	call   800dda <sys_env_destroy>
}
  80020d:	83 c4 10             	add    $0x10,%esp
  800210:	c9                   	leave  
  800211:	c3                   	ret    

00800212 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	56                   	push   %esi
  800216:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800217:	a1 08 40 80 00       	mov    0x804008,%eax
  80021c:	8b 40 48             	mov    0x48(%eax),%eax
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	68 a0 28 80 00       	push   $0x8028a0
  800227:	50                   	push   %eax
  800228:	68 68 28 80 00       	push   $0x802868
  80022d:	e8 d6 00 00 00       	call   800308 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800232:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800235:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80023b:	e8 db 0b 00 00       	call   800e1b <sys_getenvid>
  800240:	83 c4 04             	add    $0x4,%esp
  800243:	ff 75 0c             	pushl  0xc(%ebp)
  800246:	ff 75 08             	pushl  0x8(%ebp)
  800249:	56                   	push   %esi
  80024a:	50                   	push   %eax
  80024b:	68 7c 28 80 00       	push   $0x80287c
  800250:	e8 b3 00 00 00       	call   800308 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800255:	83 c4 18             	add    $0x18,%esp
  800258:	53                   	push   %ebx
  800259:	ff 75 10             	pushl  0x10(%ebp)
  80025c:	e8 56 00 00 00       	call   8002b7 <vcprintf>
	cprintf("\n");
  800261:	c7 04 24 2c 28 80 00 	movl   $0x80282c,(%esp)
  800268:	e8 9b 00 00 00       	call   800308 <cprintf>
  80026d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800270:	cc                   	int3   
  800271:	eb fd                	jmp    800270 <_panic+0x5e>

00800273 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800273:	55                   	push   %ebp
  800274:	89 e5                	mov    %esp,%ebp
  800276:	53                   	push   %ebx
  800277:	83 ec 04             	sub    $0x4,%esp
  80027a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80027d:	8b 13                	mov    (%ebx),%edx
  80027f:	8d 42 01             	lea    0x1(%edx),%eax
  800282:	89 03                	mov    %eax,(%ebx)
  800284:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800287:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80028b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800290:	74 09                	je     80029b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800292:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800296:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800299:	c9                   	leave  
  80029a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80029b:	83 ec 08             	sub    $0x8,%esp
  80029e:	68 ff 00 00 00       	push   $0xff
  8002a3:	8d 43 08             	lea    0x8(%ebx),%eax
  8002a6:	50                   	push   %eax
  8002a7:	e8 f1 0a 00 00       	call   800d9d <sys_cputs>
		b->idx = 0;
  8002ac:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002b2:	83 c4 10             	add    $0x10,%esp
  8002b5:	eb db                	jmp    800292 <putch+0x1f>

008002b7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002b7:	55                   	push   %ebp
  8002b8:	89 e5                	mov    %esp,%ebp
  8002ba:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002c0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002c7:	00 00 00 
	b.cnt = 0;
  8002ca:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002d1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002d4:	ff 75 0c             	pushl  0xc(%ebp)
  8002d7:	ff 75 08             	pushl  0x8(%ebp)
  8002da:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002e0:	50                   	push   %eax
  8002e1:	68 73 02 80 00       	push   $0x800273
  8002e6:	e8 4a 01 00 00       	call   800435 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002eb:	83 c4 08             	add    $0x8,%esp
  8002ee:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002f4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002fa:	50                   	push   %eax
  8002fb:	e8 9d 0a 00 00       	call   800d9d <sys_cputs>

	return b.cnt;
}
  800300:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800306:	c9                   	leave  
  800307:	c3                   	ret    

00800308 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
  80030b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80030e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800311:	50                   	push   %eax
  800312:	ff 75 08             	pushl  0x8(%ebp)
  800315:	e8 9d ff ff ff       	call   8002b7 <vcprintf>
	va_end(ap);

	return cnt;
}
  80031a:	c9                   	leave  
  80031b:	c3                   	ret    

0080031c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80031c:	55                   	push   %ebp
  80031d:	89 e5                	mov    %esp,%ebp
  80031f:	57                   	push   %edi
  800320:	56                   	push   %esi
  800321:	53                   	push   %ebx
  800322:	83 ec 1c             	sub    $0x1c,%esp
  800325:	89 c6                	mov    %eax,%esi
  800327:	89 d7                	mov    %edx,%edi
  800329:	8b 45 08             	mov    0x8(%ebp),%eax
  80032c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80032f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800332:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800335:	8b 45 10             	mov    0x10(%ebp),%eax
  800338:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80033b:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80033f:	74 2c                	je     80036d <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800341:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800344:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80034b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80034e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800351:	39 c2                	cmp    %eax,%edx
  800353:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800356:	73 43                	jae    80039b <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800358:	83 eb 01             	sub    $0x1,%ebx
  80035b:	85 db                	test   %ebx,%ebx
  80035d:	7e 6c                	jle    8003cb <printnum+0xaf>
				putch(padc, putdat);
  80035f:	83 ec 08             	sub    $0x8,%esp
  800362:	57                   	push   %edi
  800363:	ff 75 18             	pushl  0x18(%ebp)
  800366:	ff d6                	call   *%esi
  800368:	83 c4 10             	add    $0x10,%esp
  80036b:	eb eb                	jmp    800358 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	6a 20                	push   $0x20
  800372:	6a 00                	push   $0x0
  800374:	50                   	push   %eax
  800375:	ff 75 e4             	pushl  -0x1c(%ebp)
  800378:	ff 75 e0             	pushl  -0x20(%ebp)
  80037b:	89 fa                	mov    %edi,%edx
  80037d:	89 f0                	mov    %esi,%eax
  80037f:	e8 98 ff ff ff       	call   80031c <printnum>
		while (--width > 0)
  800384:	83 c4 20             	add    $0x20,%esp
  800387:	83 eb 01             	sub    $0x1,%ebx
  80038a:	85 db                	test   %ebx,%ebx
  80038c:	7e 65                	jle    8003f3 <printnum+0xd7>
			putch(padc, putdat);
  80038e:	83 ec 08             	sub    $0x8,%esp
  800391:	57                   	push   %edi
  800392:	6a 20                	push   $0x20
  800394:	ff d6                	call   *%esi
  800396:	83 c4 10             	add    $0x10,%esp
  800399:	eb ec                	jmp    800387 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80039b:	83 ec 0c             	sub    $0xc,%esp
  80039e:	ff 75 18             	pushl  0x18(%ebp)
  8003a1:	83 eb 01             	sub    $0x1,%ebx
  8003a4:	53                   	push   %ebx
  8003a5:	50                   	push   %eax
  8003a6:	83 ec 08             	sub    $0x8,%esp
  8003a9:	ff 75 dc             	pushl  -0x24(%ebp)
  8003ac:	ff 75 d8             	pushl  -0x28(%ebp)
  8003af:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003b2:	ff 75 e0             	pushl  -0x20(%ebp)
  8003b5:	e8 c6 20 00 00       	call   802480 <__udivdi3>
  8003ba:	83 c4 18             	add    $0x18,%esp
  8003bd:	52                   	push   %edx
  8003be:	50                   	push   %eax
  8003bf:	89 fa                	mov    %edi,%edx
  8003c1:	89 f0                	mov    %esi,%eax
  8003c3:	e8 54 ff ff ff       	call   80031c <printnum>
  8003c8:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8003cb:	83 ec 08             	sub    $0x8,%esp
  8003ce:	57                   	push   %edi
  8003cf:	83 ec 04             	sub    $0x4,%esp
  8003d2:	ff 75 dc             	pushl  -0x24(%ebp)
  8003d5:	ff 75 d8             	pushl  -0x28(%ebp)
  8003d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003db:	ff 75 e0             	pushl  -0x20(%ebp)
  8003de:	e8 ad 21 00 00       	call   802590 <__umoddi3>
  8003e3:	83 c4 14             	add    $0x14,%esp
  8003e6:	0f be 80 a7 28 80 00 	movsbl 0x8028a7(%eax),%eax
  8003ed:	50                   	push   %eax
  8003ee:	ff d6                	call   *%esi
  8003f0:	83 c4 10             	add    $0x10,%esp
	}
}
  8003f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003f6:	5b                   	pop    %ebx
  8003f7:	5e                   	pop    %esi
  8003f8:	5f                   	pop    %edi
  8003f9:	5d                   	pop    %ebp
  8003fa:	c3                   	ret    

008003fb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003fb:	55                   	push   %ebp
  8003fc:	89 e5                	mov    %esp,%ebp
  8003fe:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800401:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800405:	8b 10                	mov    (%eax),%edx
  800407:	3b 50 04             	cmp    0x4(%eax),%edx
  80040a:	73 0a                	jae    800416 <sprintputch+0x1b>
		*b->buf++ = ch;
  80040c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80040f:	89 08                	mov    %ecx,(%eax)
  800411:	8b 45 08             	mov    0x8(%ebp),%eax
  800414:	88 02                	mov    %al,(%edx)
}
  800416:	5d                   	pop    %ebp
  800417:	c3                   	ret    

00800418 <printfmt>:
{
  800418:	55                   	push   %ebp
  800419:	89 e5                	mov    %esp,%ebp
  80041b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80041e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800421:	50                   	push   %eax
  800422:	ff 75 10             	pushl  0x10(%ebp)
  800425:	ff 75 0c             	pushl  0xc(%ebp)
  800428:	ff 75 08             	pushl  0x8(%ebp)
  80042b:	e8 05 00 00 00       	call   800435 <vprintfmt>
}
  800430:	83 c4 10             	add    $0x10,%esp
  800433:	c9                   	leave  
  800434:	c3                   	ret    

00800435 <vprintfmt>:
{
  800435:	55                   	push   %ebp
  800436:	89 e5                	mov    %esp,%ebp
  800438:	57                   	push   %edi
  800439:	56                   	push   %esi
  80043a:	53                   	push   %ebx
  80043b:	83 ec 3c             	sub    $0x3c,%esp
  80043e:	8b 75 08             	mov    0x8(%ebp),%esi
  800441:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800444:	8b 7d 10             	mov    0x10(%ebp),%edi
  800447:	e9 32 04 00 00       	jmp    80087e <vprintfmt+0x449>
		padc = ' ';
  80044c:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800450:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800457:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80045e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800465:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80046c:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800473:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800478:	8d 47 01             	lea    0x1(%edi),%eax
  80047b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80047e:	0f b6 17             	movzbl (%edi),%edx
  800481:	8d 42 dd             	lea    -0x23(%edx),%eax
  800484:	3c 55                	cmp    $0x55,%al
  800486:	0f 87 12 05 00 00    	ja     80099e <vprintfmt+0x569>
  80048c:	0f b6 c0             	movzbl %al,%eax
  80048f:	ff 24 85 80 2a 80 00 	jmp    *0x802a80(,%eax,4)
  800496:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800499:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80049d:	eb d9                	jmp    800478 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80049f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004a2:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8004a6:	eb d0                	jmp    800478 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8004a8:	0f b6 d2             	movzbl %dl,%edx
  8004ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b3:	89 75 08             	mov    %esi,0x8(%ebp)
  8004b6:	eb 03                	jmp    8004bb <vprintfmt+0x86>
  8004b8:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004bb:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004be:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004c2:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004c5:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004c8:	83 fe 09             	cmp    $0x9,%esi
  8004cb:	76 eb                	jbe    8004b8 <vprintfmt+0x83>
  8004cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004d0:	8b 75 08             	mov    0x8(%ebp),%esi
  8004d3:	eb 14                	jmp    8004e9 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8004d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d8:	8b 00                	mov    (%eax),%eax
  8004da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e0:	8d 40 04             	lea    0x4(%eax),%eax
  8004e3:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004e9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004ed:	79 89                	jns    800478 <vprintfmt+0x43>
				width = precision, precision = -1;
  8004ef:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004fc:	e9 77 ff ff ff       	jmp    800478 <vprintfmt+0x43>
  800501:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800504:	85 c0                	test   %eax,%eax
  800506:	0f 48 c1             	cmovs  %ecx,%eax
  800509:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80050c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80050f:	e9 64 ff ff ff       	jmp    800478 <vprintfmt+0x43>
  800514:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800517:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80051e:	e9 55 ff ff ff       	jmp    800478 <vprintfmt+0x43>
			lflag++;
  800523:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800527:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80052a:	e9 49 ff ff ff       	jmp    800478 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80052f:	8b 45 14             	mov    0x14(%ebp),%eax
  800532:	8d 78 04             	lea    0x4(%eax),%edi
  800535:	83 ec 08             	sub    $0x8,%esp
  800538:	53                   	push   %ebx
  800539:	ff 30                	pushl  (%eax)
  80053b:	ff d6                	call   *%esi
			break;
  80053d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800540:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800543:	e9 33 03 00 00       	jmp    80087b <vprintfmt+0x446>
			err = va_arg(ap, int);
  800548:	8b 45 14             	mov    0x14(%ebp),%eax
  80054b:	8d 78 04             	lea    0x4(%eax),%edi
  80054e:	8b 00                	mov    (%eax),%eax
  800550:	99                   	cltd   
  800551:	31 d0                	xor    %edx,%eax
  800553:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800555:	83 f8 11             	cmp    $0x11,%eax
  800558:	7f 23                	jg     80057d <vprintfmt+0x148>
  80055a:	8b 14 85 e0 2b 80 00 	mov    0x802be0(,%eax,4),%edx
  800561:	85 d2                	test   %edx,%edx
  800563:	74 18                	je     80057d <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800565:	52                   	push   %edx
  800566:	68 79 2d 80 00       	push   $0x802d79
  80056b:	53                   	push   %ebx
  80056c:	56                   	push   %esi
  80056d:	e8 a6 fe ff ff       	call   800418 <printfmt>
  800572:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800575:	89 7d 14             	mov    %edi,0x14(%ebp)
  800578:	e9 fe 02 00 00       	jmp    80087b <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80057d:	50                   	push   %eax
  80057e:	68 bf 28 80 00       	push   $0x8028bf
  800583:	53                   	push   %ebx
  800584:	56                   	push   %esi
  800585:	e8 8e fe ff ff       	call   800418 <printfmt>
  80058a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80058d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800590:	e9 e6 02 00 00       	jmp    80087b <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	83 c0 04             	add    $0x4,%eax
  80059b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80059e:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a1:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8005a3:	85 c9                	test   %ecx,%ecx
  8005a5:	b8 b8 28 80 00       	mov    $0x8028b8,%eax
  8005aa:	0f 45 c1             	cmovne %ecx,%eax
  8005ad:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8005b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005b4:	7e 06                	jle    8005bc <vprintfmt+0x187>
  8005b6:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8005ba:	75 0d                	jne    8005c9 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005bc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005bf:	89 c7                	mov    %eax,%edi
  8005c1:	03 45 e0             	add    -0x20(%ebp),%eax
  8005c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005c7:	eb 53                	jmp    80061c <vprintfmt+0x1e7>
  8005c9:	83 ec 08             	sub    $0x8,%esp
  8005cc:	ff 75 d8             	pushl  -0x28(%ebp)
  8005cf:	50                   	push   %eax
  8005d0:	e8 71 04 00 00       	call   800a46 <strnlen>
  8005d5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005d8:	29 c1                	sub    %eax,%ecx
  8005da:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8005dd:	83 c4 10             	add    $0x10,%esp
  8005e0:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005e2:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e9:	eb 0f                	jmp    8005fa <vprintfmt+0x1c5>
					putch(padc, putdat);
  8005eb:	83 ec 08             	sub    $0x8,%esp
  8005ee:	53                   	push   %ebx
  8005ef:	ff 75 e0             	pushl  -0x20(%ebp)
  8005f2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f4:	83 ef 01             	sub    $0x1,%edi
  8005f7:	83 c4 10             	add    $0x10,%esp
  8005fa:	85 ff                	test   %edi,%edi
  8005fc:	7f ed                	jg     8005eb <vprintfmt+0x1b6>
  8005fe:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800601:	85 c9                	test   %ecx,%ecx
  800603:	b8 00 00 00 00       	mov    $0x0,%eax
  800608:	0f 49 c1             	cmovns %ecx,%eax
  80060b:	29 c1                	sub    %eax,%ecx
  80060d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800610:	eb aa                	jmp    8005bc <vprintfmt+0x187>
					putch(ch, putdat);
  800612:	83 ec 08             	sub    $0x8,%esp
  800615:	53                   	push   %ebx
  800616:	52                   	push   %edx
  800617:	ff d6                	call   *%esi
  800619:	83 c4 10             	add    $0x10,%esp
  80061c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80061f:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800621:	83 c7 01             	add    $0x1,%edi
  800624:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800628:	0f be d0             	movsbl %al,%edx
  80062b:	85 d2                	test   %edx,%edx
  80062d:	74 4b                	je     80067a <vprintfmt+0x245>
  80062f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800633:	78 06                	js     80063b <vprintfmt+0x206>
  800635:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800639:	78 1e                	js     800659 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80063b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80063f:	74 d1                	je     800612 <vprintfmt+0x1dd>
  800641:	0f be c0             	movsbl %al,%eax
  800644:	83 e8 20             	sub    $0x20,%eax
  800647:	83 f8 5e             	cmp    $0x5e,%eax
  80064a:	76 c6                	jbe    800612 <vprintfmt+0x1dd>
					putch('?', putdat);
  80064c:	83 ec 08             	sub    $0x8,%esp
  80064f:	53                   	push   %ebx
  800650:	6a 3f                	push   $0x3f
  800652:	ff d6                	call   *%esi
  800654:	83 c4 10             	add    $0x10,%esp
  800657:	eb c3                	jmp    80061c <vprintfmt+0x1e7>
  800659:	89 cf                	mov    %ecx,%edi
  80065b:	eb 0e                	jmp    80066b <vprintfmt+0x236>
				putch(' ', putdat);
  80065d:	83 ec 08             	sub    $0x8,%esp
  800660:	53                   	push   %ebx
  800661:	6a 20                	push   $0x20
  800663:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800665:	83 ef 01             	sub    $0x1,%edi
  800668:	83 c4 10             	add    $0x10,%esp
  80066b:	85 ff                	test   %edi,%edi
  80066d:	7f ee                	jg     80065d <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80066f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800672:	89 45 14             	mov    %eax,0x14(%ebp)
  800675:	e9 01 02 00 00       	jmp    80087b <vprintfmt+0x446>
  80067a:	89 cf                	mov    %ecx,%edi
  80067c:	eb ed                	jmp    80066b <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80067e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800681:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800688:	e9 eb fd ff ff       	jmp    800478 <vprintfmt+0x43>
	if (lflag >= 2)
  80068d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800691:	7f 21                	jg     8006b4 <vprintfmt+0x27f>
	else if (lflag)
  800693:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800697:	74 68                	je     800701 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800699:	8b 45 14             	mov    0x14(%ebp),%eax
  80069c:	8b 00                	mov    (%eax),%eax
  80069e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006a1:	89 c1                	mov    %eax,%ecx
  8006a3:	c1 f9 1f             	sar    $0x1f,%ecx
  8006a6:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	8d 40 04             	lea    0x4(%eax),%eax
  8006af:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b2:	eb 17                	jmp    8006cb <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8006b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b7:	8b 50 04             	mov    0x4(%eax),%edx
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006bf:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8006c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c5:	8d 40 08             	lea    0x8(%eax),%eax
  8006c8:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006cb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006ce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8006d7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006db:	78 3f                	js     80071c <vprintfmt+0x2e7>
			base = 10;
  8006dd:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8006e2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8006e6:	0f 84 71 01 00 00    	je     80085d <vprintfmt+0x428>
				putch('+', putdat);
  8006ec:	83 ec 08             	sub    $0x8,%esp
  8006ef:	53                   	push   %ebx
  8006f0:	6a 2b                	push   $0x2b
  8006f2:	ff d6                	call   *%esi
  8006f4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006f7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006fc:	e9 5c 01 00 00       	jmp    80085d <vprintfmt+0x428>
		return va_arg(*ap, int);
  800701:	8b 45 14             	mov    0x14(%ebp),%eax
  800704:	8b 00                	mov    (%eax),%eax
  800706:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800709:	89 c1                	mov    %eax,%ecx
  80070b:	c1 f9 1f             	sar    $0x1f,%ecx
  80070e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800711:	8b 45 14             	mov    0x14(%ebp),%eax
  800714:	8d 40 04             	lea    0x4(%eax),%eax
  800717:	89 45 14             	mov    %eax,0x14(%ebp)
  80071a:	eb af                	jmp    8006cb <vprintfmt+0x296>
				putch('-', putdat);
  80071c:	83 ec 08             	sub    $0x8,%esp
  80071f:	53                   	push   %ebx
  800720:	6a 2d                	push   $0x2d
  800722:	ff d6                	call   *%esi
				num = -(long long) num;
  800724:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800727:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80072a:	f7 d8                	neg    %eax
  80072c:	83 d2 00             	adc    $0x0,%edx
  80072f:	f7 da                	neg    %edx
  800731:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800734:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800737:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80073a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80073f:	e9 19 01 00 00       	jmp    80085d <vprintfmt+0x428>
	if (lflag >= 2)
  800744:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800748:	7f 29                	jg     800773 <vprintfmt+0x33e>
	else if (lflag)
  80074a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80074e:	74 44                	je     800794 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800750:	8b 45 14             	mov    0x14(%ebp),%eax
  800753:	8b 00                	mov    (%eax),%eax
  800755:	ba 00 00 00 00       	mov    $0x0,%edx
  80075a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800760:	8b 45 14             	mov    0x14(%ebp),%eax
  800763:	8d 40 04             	lea    0x4(%eax),%eax
  800766:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800769:	b8 0a 00 00 00       	mov    $0xa,%eax
  80076e:	e9 ea 00 00 00       	jmp    80085d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	8b 50 04             	mov    0x4(%eax),%edx
  800779:	8b 00                	mov    (%eax),%eax
  80077b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800781:	8b 45 14             	mov    0x14(%ebp),%eax
  800784:	8d 40 08             	lea    0x8(%eax),%eax
  800787:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80078a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80078f:	e9 c9 00 00 00       	jmp    80085d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800794:	8b 45 14             	mov    0x14(%ebp),%eax
  800797:	8b 00                	mov    (%eax),%eax
  800799:	ba 00 00 00 00       	mov    $0x0,%edx
  80079e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	8d 40 04             	lea    0x4(%eax),%eax
  8007aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007ad:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007b2:	e9 a6 00 00 00       	jmp    80085d <vprintfmt+0x428>
			putch('0', putdat);
  8007b7:	83 ec 08             	sub    $0x8,%esp
  8007ba:	53                   	push   %ebx
  8007bb:	6a 30                	push   $0x30
  8007bd:	ff d6                	call   *%esi
	if (lflag >= 2)
  8007bf:	83 c4 10             	add    $0x10,%esp
  8007c2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007c6:	7f 26                	jg     8007ee <vprintfmt+0x3b9>
	else if (lflag)
  8007c8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007cc:	74 3e                	je     80080c <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007db:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007de:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e1:	8d 40 04             	lea    0x4(%eax),%eax
  8007e4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007e7:	b8 08 00 00 00       	mov    $0x8,%eax
  8007ec:	eb 6f                	jmp    80085d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f1:	8b 50 04             	mov    0x4(%eax),%edx
  8007f4:	8b 00                	mov    (%eax),%eax
  8007f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ff:	8d 40 08             	lea    0x8(%eax),%eax
  800802:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800805:	b8 08 00 00 00       	mov    $0x8,%eax
  80080a:	eb 51                	jmp    80085d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80080c:	8b 45 14             	mov    0x14(%ebp),%eax
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	ba 00 00 00 00       	mov    $0x0,%edx
  800816:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800819:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	8d 40 04             	lea    0x4(%eax),%eax
  800822:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800825:	b8 08 00 00 00       	mov    $0x8,%eax
  80082a:	eb 31                	jmp    80085d <vprintfmt+0x428>
			putch('0', putdat);
  80082c:	83 ec 08             	sub    $0x8,%esp
  80082f:	53                   	push   %ebx
  800830:	6a 30                	push   $0x30
  800832:	ff d6                	call   *%esi
			putch('x', putdat);
  800834:	83 c4 08             	add    $0x8,%esp
  800837:	53                   	push   %ebx
  800838:	6a 78                	push   $0x78
  80083a:	ff d6                	call   *%esi
			num = (unsigned long long)
  80083c:	8b 45 14             	mov    0x14(%ebp),%eax
  80083f:	8b 00                	mov    (%eax),%eax
  800841:	ba 00 00 00 00       	mov    $0x0,%edx
  800846:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800849:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80084c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80084f:	8b 45 14             	mov    0x14(%ebp),%eax
  800852:	8d 40 04             	lea    0x4(%eax),%eax
  800855:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800858:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80085d:	83 ec 0c             	sub    $0xc,%esp
  800860:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800864:	52                   	push   %edx
  800865:	ff 75 e0             	pushl  -0x20(%ebp)
  800868:	50                   	push   %eax
  800869:	ff 75 dc             	pushl  -0x24(%ebp)
  80086c:	ff 75 d8             	pushl  -0x28(%ebp)
  80086f:	89 da                	mov    %ebx,%edx
  800871:	89 f0                	mov    %esi,%eax
  800873:	e8 a4 fa ff ff       	call   80031c <printnum>
			break;
  800878:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80087b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80087e:	83 c7 01             	add    $0x1,%edi
  800881:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800885:	83 f8 25             	cmp    $0x25,%eax
  800888:	0f 84 be fb ff ff    	je     80044c <vprintfmt+0x17>
			if (ch == '\0')
  80088e:	85 c0                	test   %eax,%eax
  800890:	0f 84 28 01 00 00    	je     8009be <vprintfmt+0x589>
			putch(ch, putdat);
  800896:	83 ec 08             	sub    $0x8,%esp
  800899:	53                   	push   %ebx
  80089a:	50                   	push   %eax
  80089b:	ff d6                	call   *%esi
  80089d:	83 c4 10             	add    $0x10,%esp
  8008a0:	eb dc                	jmp    80087e <vprintfmt+0x449>
	if (lflag >= 2)
  8008a2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8008a6:	7f 26                	jg     8008ce <vprintfmt+0x499>
	else if (lflag)
  8008a8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8008ac:	74 41                	je     8008ef <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8008ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b1:	8b 00                	mov    (%eax),%eax
  8008b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008bb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008be:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c1:	8d 40 04             	lea    0x4(%eax),%eax
  8008c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008c7:	b8 10 00 00 00       	mov    $0x10,%eax
  8008cc:	eb 8f                	jmp    80085d <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8008ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d1:	8b 50 04             	mov    0x4(%eax),%edx
  8008d4:	8b 00                	mov    (%eax),%eax
  8008d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008d9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008df:	8d 40 08             	lea    0x8(%eax),%eax
  8008e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008e5:	b8 10 00 00 00       	mov    $0x10,%eax
  8008ea:	e9 6e ff ff ff       	jmp    80085d <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f2:	8b 00                	mov    (%eax),%eax
  8008f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008fc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800902:	8d 40 04             	lea    0x4(%eax),%eax
  800905:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800908:	b8 10 00 00 00       	mov    $0x10,%eax
  80090d:	e9 4b ff ff ff       	jmp    80085d <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800912:	8b 45 14             	mov    0x14(%ebp),%eax
  800915:	83 c0 04             	add    $0x4,%eax
  800918:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80091b:	8b 45 14             	mov    0x14(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	85 c0                	test   %eax,%eax
  800922:	74 14                	je     800938 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800924:	8b 13                	mov    (%ebx),%edx
  800926:	83 fa 7f             	cmp    $0x7f,%edx
  800929:	7f 37                	jg     800962 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80092b:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80092d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800930:	89 45 14             	mov    %eax,0x14(%ebp)
  800933:	e9 43 ff ff ff       	jmp    80087b <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800938:	b8 0a 00 00 00       	mov    $0xa,%eax
  80093d:	bf dd 29 80 00       	mov    $0x8029dd,%edi
							putch(ch, putdat);
  800942:	83 ec 08             	sub    $0x8,%esp
  800945:	53                   	push   %ebx
  800946:	50                   	push   %eax
  800947:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800949:	83 c7 01             	add    $0x1,%edi
  80094c:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800950:	83 c4 10             	add    $0x10,%esp
  800953:	85 c0                	test   %eax,%eax
  800955:	75 eb                	jne    800942 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800957:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80095a:	89 45 14             	mov    %eax,0x14(%ebp)
  80095d:	e9 19 ff ff ff       	jmp    80087b <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800962:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800964:	b8 0a 00 00 00       	mov    $0xa,%eax
  800969:	bf 15 2a 80 00       	mov    $0x802a15,%edi
							putch(ch, putdat);
  80096e:	83 ec 08             	sub    $0x8,%esp
  800971:	53                   	push   %ebx
  800972:	50                   	push   %eax
  800973:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800975:	83 c7 01             	add    $0x1,%edi
  800978:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80097c:	83 c4 10             	add    $0x10,%esp
  80097f:	85 c0                	test   %eax,%eax
  800981:	75 eb                	jne    80096e <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800983:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800986:	89 45 14             	mov    %eax,0x14(%ebp)
  800989:	e9 ed fe ff ff       	jmp    80087b <vprintfmt+0x446>
			putch(ch, putdat);
  80098e:	83 ec 08             	sub    $0x8,%esp
  800991:	53                   	push   %ebx
  800992:	6a 25                	push   $0x25
  800994:	ff d6                	call   *%esi
			break;
  800996:	83 c4 10             	add    $0x10,%esp
  800999:	e9 dd fe ff ff       	jmp    80087b <vprintfmt+0x446>
			putch('%', putdat);
  80099e:	83 ec 08             	sub    $0x8,%esp
  8009a1:	53                   	push   %ebx
  8009a2:	6a 25                	push   $0x25
  8009a4:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009a6:	83 c4 10             	add    $0x10,%esp
  8009a9:	89 f8                	mov    %edi,%eax
  8009ab:	eb 03                	jmp    8009b0 <vprintfmt+0x57b>
  8009ad:	83 e8 01             	sub    $0x1,%eax
  8009b0:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8009b4:	75 f7                	jne    8009ad <vprintfmt+0x578>
  8009b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009b9:	e9 bd fe ff ff       	jmp    80087b <vprintfmt+0x446>
}
  8009be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8009c1:	5b                   	pop    %ebx
  8009c2:	5e                   	pop    %esi
  8009c3:	5f                   	pop    %edi
  8009c4:	5d                   	pop    %ebp
  8009c5:	c3                   	ret    

008009c6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009c6:	55                   	push   %ebp
  8009c7:	89 e5                	mov    %esp,%ebp
  8009c9:	83 ec 18             	sub    $0x18,%esp
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009d5:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009d9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009e3:	85 c0                	test   %eax,%eax
  8009e5:	74 26                	je     800a0d <vsnprintf+0x47>
  8009e7:	85 d2                	test   %edx,%edx
  8009e9:	7e 22                	jle    800a0d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009eb:	ff 75 14             	pushl  0x14(%ebp)
  8009ee:	ff 75 10             	pushl  0x10(%ebp)
  8009f1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009f4:	50                   	push   %eax
  8009f5:	68 fb 03 80 00       	push   $0x8003fb
  8009fa:	e8 36 fa ff ff       	call   800435 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a02:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a08:	83 c4 10             	add    $0x10,%esp
}
  800a0b:	c9                   	leave  
  800a0c:	c3                   	ret    
		return -E_INVAL;
  800a0d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a12:	eb f7                	jmp    800a0b <vsnprintf+0x45>

00800a14 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a1a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a1d:	50                   	push   %eax
  800a1e:	ff 75 10             	pushl  0x10(%ebp)
  800a21:	ff 75 0c             	pushl  0xc(%ebp)
  800a24:	ff 75 08             	pushl  0x8(%ebp)
  800a27:	e8 9a ff ff ff       	call   8009c6 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a2c:	c9                   	leave  
  800a2d:	c3                   	ret    

00800a2e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a2e:	55                   	push   %ebp
  800a2f:	89 e5                	mov    %esp,%ebp
  800a31:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a34:	b8 00 00 00 00       	mov    $0x0,%eax
  800a39:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a3d:	74 05                	je     800a44 <strlen+0x16>
		n++;
  800a3f:	83 c0 01             	add    $0x1,%eax
  800a42:	eb f5                	jmp    800a39 <strlen+0xb>
	return n;
}
  800a44:	5d                   	pop    %ebp
  800a45:	c3                   	ret    

00800a46 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a46:	55                   	push   %ebp
  800a47:	89 e5                	mov    %esp,%ebp
  800a49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a4c:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a4f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a54:	39 c2                	cmp    %eax,%edx
  800a56:	74 0d                	je     800a65 <strnlen+0x1f>
  800a58:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a5c:	74 05                	je     800a63 <strnlen+0x1d>
		n++;
  800a5e:	83 c2 01             	add    $0x1,%edx
  800a61:	eb f1                	jmp    800a54 <strnlen+0xe>
  800a63:	89 d0                	mov    %edx,%eax
	return n;
}
  800a65:	5d                   	pop    %ebp
  800a66:	c3                   	ret    

00800a67 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a67:	55                   	push   %ebp
  800a68:	89 e5                	mov    %esp,%ebp
  800a6a:	53                   	push   %ebx
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a71:	ba 00 00 00 00       	mov    $0x0,%edx
  800a76:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a7a:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a7d:	83 c2 01             	add    $0x1,%edx
  800a80:	84 c9                	test   %cl,%cl
  800a82:	75 f2                	jne    800a76 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a84:	5b                   	pop    %ebx
  800a85:	5d                   	pop    %ebp
  800a86:	c3                   	ret    

00800a87 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a87:	55                   	push   %ebp
  800a88:	89 e5                	mov    %esp,%ebp
  800a8a:	53                   	push   %ebx
  800a8b:	83 ec 10             	sub    $0x10,%esp
  800a8e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a91:	53                   	push   %ebx
  800a92:	e8 97 ff ff ff       	call   800a2e <strlen>
  800a97:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a9a:	ff 75 0c             	pushl  0xc(%ebp)
  800a9d:	01 d8                	add    %ebx,%eax
  800a9f:	50                   	push   %eax
  800aa0:	e8 c2 ff ff ff       	call   800a67 <strcpy>
	return dst;
}
  800aa5:	89 d8                	mov    %ebx,%eax
  800aa7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aaa:	c9                   	leave  
  800aab:	c3                   	ret    

00800aac <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	56                   	push   %esi
  800ab0:	53                   	push   %ebx
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ab7:	89 c6                	mov    %eax,%esi
  800ab9:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800abc:	89 c2                	mov    %eax,%edx
  800abe:	39 f2                	cmp    %esi,%edx
  800ac0:	74 11                	je     800ad3 <strncpy+0x27>
		*dst++ = *src;
  800ac2:	83 c2 01             	add    $0x1,%edx
  800ac5:	0f b6 19             	movzbl (%ecx),%ebx
  800ac8:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800acb:	80 fb 01             	cmp    $0x1,%bl
  800ace:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800ad1:	eb eb                	jmp    800abe <strncpy+0x12>
	}
	return ret;
}
  800ad3:	5b                   	pop    %ebx
  800ad4:	5e                   	pop    %esi
  800ad5:	5d                   	pop    %ebp
  800ad6:	c3                   	ret    

00800ad7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	56                   	push   %esi
  800adb:	53                   	push   %ebx
  800adc:	8b 75 08             	mov    0x8(%ebp),%esi
  800adf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ae2:	8b 55 10             	mov    0x10(%ebp),%edx
  800ae5:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ae7:	85 d2                	test   %edx,%edx
  800ae9:	74 21                	je     800b0c <strlcpy+0x35>
  800aeb:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800aef:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800af1:	39 c2                	cmp    %eax,%edx
  800af3:	74 14                	je     800b09 <strlcpy+0x32>
  800af5:	0f b6 19             	movzbl (%ecx),%ebx
  800af8:	84 db                	test   %bl,%bl
  800afa:	74 0b                	je     800b07 <strlcpy+0x30>
			*dst++ = *src++;
  800afc:	83 c1 01             	add    $0x1,%ecx
  800aff:	83 c2 01             	add    $0x1,%edx
  800b02:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b05:	eb ea                	jmp    800af1 <strlcpy+0x1a>
  800b07:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800b09:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b0c:	29 f0                	sub    %esi,%eax
}
  800b0e:	5b                   	pop    %ebx
  800b0f:	5e                   	pop    %esi
  800b10:	5d                   	pop    %ebp
  800b11:	c3                   	ret    

00800b12 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
  800b15:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b18:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b1b:	0f b6 01             	movzbl (%ecx),%eax
  800b1e:	84 c0                	test   %al,%al
  800b20:	74 0c                	je     800b2e <strcmp+0x1c>
  800b22:	3a 02                	cmp    (%edx),%al
  800b24:	75 08                	jne    800b2e <strcmp+0x1c>
		p++, q++;
  800b26:	83 c1 01             	add    $0x1,%ecx
  800b29:	83 c2 01             	add    $0x1,%edx
  800b2c:	eb ed                	jmp    800b1b <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b2e:	0f b6 c0             	movzbl %al,%eax
  800b31:	0f b6 12             	movzbl (%edx),%edx
  800b34:	29 d0                	sub    %edx,%eax
}
  800b36:	5d                   	pop    %ebp
  800b37:	c3                   	ret    

00800b38 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	53                   	push   %ebx
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b42:	89 c3                	mov    %eax,%ebx
  800b44:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b47:	eb 06                	jmp    800b4f <strncmp+0x17>
		n--, p++, q++;
  800b49:	83 c0 01             	add    $0x1,%eax
  800b4c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b4f:	39 d8                	cmp    %ebx,%eax
  800b51:	74 16                	je     800b69 <strncmp+0x31>
  800b53:	0f b6 08             	movzbl (%eax),%ecx
  800b56:	84 c9                	test   %cl,%cl
  800b58:	74 04                	je     800b5e <strncmp+0x26>
  800b5a:	3a 0a                	cmp    (%edx),%cl
  800b5c:	74 eb                	je     800b49 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b5e:	0f b6 00             	movzbl (%eax),%eax
  800b61:	0f b6 12             	movzbl (%edx),%edx
  800b64:	29 d0                	sub    %edx,%eax
}
  800b66:	5b                   	pop    %ebx
  800b67:	5d                   	pop    %ebp
  800b68:	c3                   	ret    
		return 0;
  800b69:	b8 00 00 00 00       	mov    $0x0,%eax
  800b6e:	eb f6                	jmp    800b66 <strncmp+0x2e>

00800b70 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b7a:	0f b6 10             	movzbl (%eax),%edx
  800b7d:	84 d2                	test   %dl,%dl
  800b7f:	74 09                	je     800b8a <strchr+0x1a>
		if (*s == c)
  800b81:	38 ca                	cmp    %cl,%dl
  800b83:	74 0a                	je     800b8f <strchr+0x1f>
	for (; *s; s++)
  800b85:	83 c0 01             	add    $0x1,%eax
  800b88:	eb f0                	jmp    800b7a <strchr+0xa>
			return (char *) s;
	return 0;
  800b8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b8f:	5d                   	pop    %ebp
  800b90:	c3                   	ret    

00800b91 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b9b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b9e:	38 ca                	cmp    %cl,%dl
  800ba0:	74 09                	je     800bab <strfind+0x1a>
  800ba2:	84 d2                	test   %dl,%dl
  800ba4:	74 05                	je     800bab <strfind+0x1a>
	for (; *s; s++)
  800ba6:	83 c0 01             	add    $0x1,%eax
  800ba9:	eb f0                	jmp    800b9b <strfind+0xa>
			break;
	return (char *) s;
}
  800bab:	5d                   	pop    %ebp
  800bac:	c3                   	ret    

00800bad <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	57                   	push   %edi
  800bb1:	56                   	push   %esi
  800bb2:	53                   	push   %ebx
  800bb3:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bb6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bb9:	85 c9                	test   %ecx,%ecx
  800bbb:	74 31                	je     800bee <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bbd:	89 f8                	mov    %edi,%eax
  800bbf:	09 c8                	or     %ecx,%eax
  800bc1:	a8 03                	test   $0x3,%al
  800bc3:	75 23                	jne    800be8 <memset+0x3b>
		c &= 0xFF;
  800bc5:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bc9:	89 d3                	mov    %edx,%ebx
  800bcb:	c1 e3 08             	shl    $0x8,%ebx
  800bce:	89 d0                	mov    %edx,%eax
  800bd0:	c1 e0 18             	shl    $0x18,%eax
  800bd3:	89 d6                	mov    %edx,%esi
  800bd5:	c1 e6 10             	shl    $0x10,%esi
  800bd8:	09 f0                	or     %esi,%eax
  800bda:	09 c2                	or     %eax,%edx
  800bdc:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bde:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800be1:	89 d0                	mov    %edx,%eax
  800be3:	fc                   	cld    
  800be4:	f3 ab                	rep stos %eax,%es:(%edi)
  800be6:	eb 06                	jmp    800bee <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800be8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800beb:	fc                   	cld    
  800bec:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bee:	89 f8                	mov    %edi,%eax
  800bf0:	5b                   	pop    %ebx
  800bf1:	5e                   	pop    %esi
  800bf2:	5f                   	pop    %edi
  800bf3:	5d                   	pop    %ebp
  800bf4:	c3                   	ret    

00800bf5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
  800bf8:	57                   	push   %edi
  800bf9:	56                   	push   %esi
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c00:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c03:	39 c6                	cmp    %eax,%esi
  800c05:	73 32                	jae    800c39 <memmove+0x44>
  800c07:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c0a:	39 c2                	cmp    %eax,%edx
  800c0c:	76 2b                	jbe    800c39 <memmove+0x44>
		s += n;
		d += n;
  800c0e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c11:	89 fe                	mov    %edi,%esi
  800c13:	09 ce                	or     %ecx,%esi
  800c15:	09 d6                	or     %edx,%esi
  800c17:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c1d:	75 0e                	jne    800c2d <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c1f:	83 ef 04             	sub    $0x4,%edi
  800c22:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c25:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800c28:	fd                   	std    
  800c29:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c2b:	eb 09                	jmp    800c36 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c2d:	83 ef 01             	sub    $0x1,%edi
  800c30:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800c33:	fd                   	std    
  800c34:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c36:	fc                   	cld    
  800c37:	eb 1a                	jmp    800c53 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c39:	89 c2                	mov    %eax,%edx
  800c3b:	09 ca                	or     %ecx,%edx
  800c3d:	09 f2                	or     %esi,%edx
  800c3f:	f6 c2 03             	test   $0x3,%dl
  800c42:	75 0a                	jne    800c4e <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c44:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c47:	89 c7                	mov    %eax,%edi
  800c49:	fc                   	cld    
  800c4a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c4c:	eb 05                	jmp    800c53 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c4e:	89 c7                	mov    %eax,%edi
  800c50:	fc                   	cld    
  800c51:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c53:	5e                   	pop    %esi
  800c54:	5f                   	pop    %edi
  800c55:	5d                   	pop    %ebp
  800c56:	c3                   	ret    

00800c57 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c5d:	ff 75 10             	pushl  0x10(%ebp)
  800c60:	ff 75 0c             	pushl  0xc(%ebp)
  800c63:	ff 75 08             	pushl  0x8(%ebp)
  800c66:	e8 8a ff ff ff       	call   800bf5 <memmove>
}
  800c6b:	c9                   	leave  
  800c6c:	c3                   	ret    

00800c6d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	56                   	push   %esi
  800c71:	53                   	push   %ebx
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c78:	89 c6                	mov    %eax,%esi
  800c7a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c7d:	39 f0                	cmp    %esi,%eax
  800c7f:	74 1c                	je     800c9d <memcmp+0x30>
		if (*s1 != *s2)
  800c81:	0f b6 08             	movzbl (%eax),%ecx
  800c84:	0f b6 1a             	movzbl (%edx),%ebx
  800c87:	38 d9                	cmp    %bl,%cl
  800c89:	75 08                	jne    800c93 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c8b:	83 c0 01             	add    $0x1,%eax
  800c8e:	83 c2 01             	add    $0x1,%edx
  800c91:	eb ea                	jmp    800c7d <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c93:	0f b6 c1             	movzbl %cl,%eax
  800c96:	0f b6 db             	movzbl %bl,%ebx
  800c99:	29 d8                	sub    %ebx,%eax
  800c9b:	eb 05                	jmp    800ca2 <memcmp+0x35>
	}

	return 0;
  800c9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ca2:	5b                   	pop    %ebx
  800ca3:	5e                   	pop    %esi
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    

00800ca6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800caf:	89 c2                	mov    %eax,%edx
  800cb1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cb4:	39 d0                	cmp    %edx,%eax
  800cb6:	73 09                	jae    800cc1 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cb8:	38 08                	cmp    %cl,(%eax)
  800cba:	74 05                	je     800cc1 <memfind+0x1b>
	for (; s < ends; s++)
  800cbc:	83 c0 01             	add    $0x1,%eax
  800cbf:	eb f3                	jmp    800cb4 <memfind+0xe>
			break;
	return (void *) s;
}
  800cc1:	5d                   	pop    %ebp
  800cc2:	c3                   	ret    

00800cc3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	57                   	push   %edi
  800cc7:	56                   	push   %esi
  800cc8:	53                   	push   %ebx
  800cc9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ccc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ccf:	eb 03                	jmp    800cd4 <strtol+0x11>
		s++;
  800cd1:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800cd4:	0f b6 01             	movzbl (%ecx),%eax
  800cd7:	3c 20                	cmp    $0x20,%al
  800cd9:	74 f6                	je     800cd1 <strtol+0xe>
  800cdb:	3c 09                	cmp    $0x9,%al
  800cdd:	74 f2                	je     800cd1 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800cdf:	3c 2b                	cmp    $0x2b,%al
  800ce1:	74 2a                	je     800d0d <strtol+0x4a>
	int neg = 0;
  800ce3:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ce8:	3c 2d                	cmp    $0x2d,%al
  800cea:	74 2b                	je     800d17 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cec:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cf2:	75 0f                	jne    800d03 <strtol+0x40>
  800cf4:	80 39 30             	cmpb   $0x30,(%ecx)
  800cf7:	74 28                	je     800d21 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cf9:	85 db                	test   %ebx,%ebx
  800cfb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d00:	0f 44 d8             	cmove  %eax,%ebx
  800d03:	b8 00 00 00 00       	mov    $0x0,%eax
  800d08:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d0b:	eb 50                	jmp    800d5d <strtol+0x9a>
		s++;
  800d0d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800d10:	bf 00 00 00 00       	mov    $0x0,%edi
  800d15:	eb d5                	jmp    800cec <strtol+0x29>
		s++, neg = 1;
  800d17:	83 c1 01             	add    $0x1,%ecx
  800d1a:	bf 01 00 00 00       	mov    $0x1,%edi
  800d1f:	eb cb                	jmp    800cec <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d21:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800d25:	74 0e                	je     800d35 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800d27:	85 db                	test   %ebx,%ebx
  800d29:	75 d8                	jne    800d03 <strtol+0x40>
		s++, base = 8;
  800d2b:	83 c1 01             	add    $0x1,%ecx
  800d2e:	bb 08 00 00 00       	mov    $0x8,%ebx
  800d33:	eb ce                	jmp    800d03 <strtol+0x40>
		s += 2, base = 16;
  800d35:	83 c1 02             	add    $0x2,%ecx
  800d38:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d3d:	eb c4                	jmp    800d03 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d3f:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d42:	89 f3                	mov    %esi,%ebx
  800d44:	80 fb 19             	cmp    $0x19,%bl
  800d47:	77 29                	ja     800d72 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d49:	0f be d2             	movsbl %dl,%edx
  800d4c:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d4f:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d52:	7d 30                	jge    800d84 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d54:	83 c1 01             	add    $0x1,%ecx
  800d57:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d5b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d5d:	0f b6 11             	movzbl (%ecx),%edx
  800d60:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d63:	89 f3                	mov    %esi,%ebx
  800d65:	80 fb 09             	cmp    $0x9,%bl
  800d68:	77 d5                	ja     800d3f <strtol+0x7c>
			dig = *s - '0';
  800d6a:	0f be d2             	movsbl %dl,%edx
  800d6d:	83 ea 30             	sub    $0x30,%edx
  800d70:	eb dd                	jmp    800d4f <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d72:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d75:	89 f3                	mov    %esi,%ebx
  800d77:	80 fb 19             	cmp    $0x19,%bl
  800d7a:	77 08                	ja     800d84 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d7c:	0f be d2             	movsbl %dl,%edx
  800d7f:	83 ea 37             	sub    $0x37,%edx
  800d82:	eb cb                	jmp    800d4f <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d88:	74 05                	je     800d8f <strtol+0xcc>
		*endptr = (char *) s;
  800d8a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d8d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d8f:	89 c2                	mov    %eax,%edx
  800d91:	f7 da                	neg    %edx
  800d93:	85 ff                	test   %edi,%edi
  800d95:	0f 45 c2             	cmovne %edx,%eax
}
  800d98:	5b                   	pop    %ebx
  800d99:	5e                   	pop    %esi
  800d9a:	5f                   	pop    %edi
  800d9b:	5d                   	pop    %ebp
  800d9c:	c3                   	ret    

00800d9d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	57                   	push   %edi
  800da1:	56                   	push   %esi
  800da2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da3:	b8 00 00 00 00       	mov    $0x0,%eax
  800da8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dae:	89 c3                	mov    %eax,%ebx
  800db0:	89 c7                	mov    %eax,%edi
  800db2:	89 c6                	mov    %eax,%esi
  800db4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800db6:	5b                   	pop    %ebx
  800db7:	5e                   	pop    %esi
  800db8:	5f                   	pop    %edi
  800db9:	5d                   	pop    %ebp
  800dba:	c3                   	ret    

00800dbb <sys_cgetc>:

int
sys_cgetc(void)
{
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
  800dbe:	57                   	push   %edi
  800dbf:	56                   	push   %esi
  800dc0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dc1:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc6:	b8 01 00 00 00       	mov    $0x1,%eax
  800dcb:	89 d1                	mov    %edx,%ecx
  800dcd:	89 d3                	mov    %edx,%ebx
  800dcf:	89 d7                	mov    %edx,%edi
  800dd1:	89 d6                	mov    %edx,%esi
  800dd3:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dd5:	5b                   	pop    %ebx
  800dd6:	5e                   	pop    %esi
  800dd7:	5f                   	pop    %edi
  800dd8:	5d                   	pop    %ebp
  800dd9:	c3                   	ret    

00800dda <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	57                   	push   %edi
  800dde:	56                   	push   %esi
  800ddf:	53                   	push   %ebx
  800de0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800de8:	8b 55 08             	mov    0x8(%ebp),%edx
  800deb:	b8 03 00 00 00       	mov    $0x3,%eax
  800df0:	89 cb                	mov    %ecx,%ebx
  800df2:	89 cf                	mov    %ecx,%edi
  800df4:	89 ce                	mov    %ecx,%esi
  800df6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	7f 08                	jg     800e04 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dff:	5b                   	pop    %ebx
  800e00:	5e                   	pop    %esi
  800e01:	5f                   	pop    %edi
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e04:	83 ec 0c             	sub    $0xc,%esp
  800e07:	50                   	push   %eax
  800e08:	6a 03                	push   $0x3
  800e0a:	68 28 2c 80 00       	push   $0x802c28
  800e0f:	6a 43                	push   $0x43
  800e11:	68 45 2c 80 00       	push   $0x802c45
  800e16:	e8 f7 f3 ff ff       	call   800212 <_panic>

00800e1b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	57                   	push   %edi
  800e1f:	56                   	push   %esi
  800e20:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e21:	ba 00 00 00 00       	mov    $0x0,%edx
  800e26:	b8 02 00 00 00       	mov    $0x2,%eax
  800e2b:	89 d1                	mov    %edx,%ecx
  800e2d:	89 d3                	mov    %edx,%ebx
  800e2f:	89 d7                	mov    %edx,%edi
  800e31:	89 d6                	mov    %edx,%esi
  800e33:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e35:	5b                   	pop    %ebx
  800e36:	5e                   	pop    %esi
  800e37:	5f                   	pop    %edi
  800e38:	5d                   	pop    %ebp
  800e39:	c3                   	ret    

00800e3a <sys_yield>:

void
sys_yield(void)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	57                   	push   %edi
  800e3e:	56                   	push   %esi
  800e3f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e40:	ba 00 00 00 00       	mov    $0x0,%edx
  800e45:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e4a:	89 d1                	mov    %edx,%ecx
  800e4c:	89 d3                	mov    %edx,%ebx
  800e4e:	89 d7                	mov    %edx,%edi
  800e50:	89 d6                	mov    %edx,%esi
  800e52:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e54:	5b                   	pop    %ebx
  800e55:	5e                   	pop    %esi
  800e56:	5f                   	pop    %edi
  800e57:	5d                   	pop    %ebp
  800e58:	c3                   	ret    

00800e59 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	57                   	push   %edi
  800e5d:	56                   	push   %esi
  800e5e:	53                   	push   %ebx
  800e5f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e62:	be 00 00 00 00       	mov    $0x0,%esi
  800e67:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6d:	b8 04 00 00 00       	mov    $0x4,%eax
  800e72:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e75:	89 f7                	mov    %esi,%edi
  800e77:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e79:	85 c0                	test   %eax,%eax
  800e7b:	7f 08                	jg     800e85 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e80:	5b                   	pop    %ebx
  800e81:	5e                   	pop    %esi
  800e82:	5f                   	pop    %edi
  800e83:	5d                   	pop    %ebp
  800e84:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e85:	83 ec 0c             	sub    $0xc,%esp
  800e88:	50                   	push   %eax
  800e89:	6a 04                	push   $0x4
  800e8b:	68 28 2c 80 00       	push   $0x802c28
  800e90:	6a 43                	push   $0x43
  800e92:	68 45 2c 80 00       	push   $0x802c45
  800e97:	e8 76 f3 ff ff       	call   800212 <_panic>

00800e9c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	57                   	push   %edi
  800ea0:	56                   	push   %esi
  800ea1:	53                   	push   %ebx
  800ea2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eab:	b8 05 00 00 00       	mov    $0x5,%eax
  800eb0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eb3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eb6:	8b 75 18             	mov    0x18(%ebp),%esi
  800eb9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebb:	85 c0                	test   %eax,%eax
  800ebd:	7f 08                	jg     800ec7 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ebf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec2:	5b                   	pop    %ebx
  800ec3:	5e                   	pop    %esi
  800ec4:	5f                   	pop    %edi
  800ec5:	5d                   	pop    %ebp
  800ec6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec7:	83 ec 0c             	sub    $0xc,%esp
  800eca:	50                   	push   %eax
  800ecb:	6a 05                	push   $0x5
  800ecd:	68 28 2c 80 00       	push   $0x802c28
  800ed2:	6a 43                	push   $0x43
  800ed4:	68 45 2c 80 00       	push   $0x802c45
  800ed9:	e8 34 f3 ff ff       	call   800212 <_panic>

00800ede <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ede:	55                   	push   %ebp
  800edf:	89 e5                	mov    %esp,%ebp
  800ee1:	57                   	push   %edi
  800ee2:	56                   	push   %esi
  800ee3:	53                   	push   %ebx
  800ee4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eec:	8b 55 08             	mov    0x8(%ebp),%edx
  800eef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef2:	b8 06 00 00 00       	mov    $0x6,%eax
  800ef7:	89 df                	mov    %ebx,%edi
  800ef9:	89 de                	mov    %ebx,%esi
  800efb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800efd:	85 c0                	test   %eax,%eax
  800eff:	7f 08                	jg     800f09 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f01:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f04:	5b                   	pop    %ebx
  800f05:	5e                   	pop    %esi
  800f06:	5f                   	pop    %edi
  800f07:	5d                   	pop    %ebp
  800f08:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f09:	83 ec 0c             	sub    $0xc,%esp
  800f0c:	50                   	push   %eax
  800f0d:	6a 06                	push   $0x6
  800f0f:	68 28 2c 80 00       	push   $0x802c28
  800f14:	6a 43                	push   $0x43
  800f16:	68 45 2c 80 00       	push   $0x802c45
  800f1b:	e8 f2 f2 ff ff       	call   800212 <_panic>

00800f20 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	57                   	push   %edi
  800f24:	56                   	push   %esi
  800f25:	53                   	push   %ebx
  800f26:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f29:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f34:	b8 08 00 00 00       	mov    $0x8,%eax
  800f39:	89 df                	mov    %ebx,%edi
  800f3b:	89 de                	mov    %ebx,%esi
  800f3d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f3f:	85 c0                	test   %eax,%eax
  800f41:	7f 08                	jg     800f4b <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f43:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f46:	5b                   	pop    %ebx
  800f47:	5e                   	pop    %esi
  800f48:	5f                   	pop    %edi
  800f49:	5d                   	pop    %ebp
  800f4a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4b:	83 ec 0c             	sub    $0xc,%esp
  800f4e:	50                   	push   %eax
  800f4f:	6a 08                	push   $0x8
  800f51:	68 28 2c 80 00       	push   $0x802c28
  800f56:	6a 43                	push   $0x43
  800f58:	68 45 2c 80 00       	push   $0x802c45
  800f5d:	e8 b0 f2 ff ff       	call   800212 <_panic>

00800f62 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	57                   	push   %edi
  800f66:	56                   	push   %esi
  800f67:	53                   	push   %ebx
  800f68:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f6b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f70:	8b 55 08             	mov    0x8(%ebp),%edx
  800f73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f76:	b8 09 00 00 00       	mov    $0x9,%eax
  800f7b:	89 df                	mov    %ebx,%edi
  800f7d:	89 de                	mov    %ebx,%esi
  800f7f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f81:	85 c0                	test   %eax,%eax
  800f83:	7f 08                	jg     800f8d <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f85:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f88:	5b                   	pop    %ebx
  800f89:	5e                   	pop    %esi
  800f8a:	5f                   	pop    %edi
  800f8b:	5d                   	pop    %ebp
  800f8c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8d:	83 ec 0c             	sub    $0xc,%esp
  800f90:	50                   	push   %eax
  800f91:	6a 09                	push   $0x9
  800f93:	68 28 2c 80 00       	push   $0x802c28
  800f98:	6a 43                	push   $0x43
  800f9a:	68 45 2c 80 00       	push   $0x802c45
  800f9f:	e8 6e f2 ff ff       	call   800212 <_panic>

00800fa4 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	57                   	push   %edi
  800fa8:	56                   	push   %esi
  800fa9:	53                   	push   %ebx
  800faa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fad:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fbd:	89 df                	mov    %ebx,%edi
  800fbf:	89 de                	mov    %ebx,%esi
  800fc1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fc3:	85 c0                	test   %eax,%eax
  800fc5:	7f 08                	jg     800fcf <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fca:	5b                   	pop    %ebx
  800fcb:	5e                   	pop    %esi
  800fcc:	5f                   	pop    %edi
  800fcd:	5d                   	pop    %ebp
  800fce:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fcf:	83 ec 0c             	sub    $0xc,%esp
  800fd2:	50                   	push   %eax
  800fd3:	6a 0a                	push   $0xa
  800fd5:	68 28 2c 80 00       	push   $0x802c28
  800fda:	6a 43                	push   $0x43
  800fdc:	68 45 2c 80 00       	push   $0x802c45
  800fe1:	e8 2c f2 ff ff       	call   800212 <_panic>

00800fe6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fe6:	55                   	push   %ebp
  800fe7:	89 e5                	mov    %esp,%ebp
  800fe9:	57                   	push   %edi
  800fea:	56                   	push   %esi
  800feb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fec:	8b 55 08             	mov    0x8(%ebp),%edx
  800fef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff2:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ff7:	be 00 00 00 00       	mov    $0x0,%esi
  800ffc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fff:	8b 7d 14             	mov    0x14(%ebp),%edi
  801002:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801004:	5b                   	pop    %ebx
  801005:	5e                   	pop    %esi
  801006:	5f                   	pop    %edi
  801007:	5d                   	pop    %ebp
  801008:	c3                   	ret    

00801009 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	57                   	push   %edi
  80100d:	56                   	push   %esi
  80100e:	53                   	push   %ebx
  80100f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801012:	b9 00 00 00 00       	mov    $0x0,%ecx
  801017:	8b 55 08             	mov    0x8(%ebp),%edx
  80101a:	b8 0d 00 00 00       	mov    $0xd,%eax
  80101f:	89 cb                	mov    %ecx,%ebx
  801021:	89 cf                	mov    %ecx,%edi
  801023:	89 ce                	mov    %ecx,%esi
  801025:	cd 30                	int    $0x30
	if(check && ret > 0)
  801027:	85 c0                	test   %eax,%eax
  801029:	7f 08                	jg     801033 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80102b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80102e:	5b                   	pop    %ebx
  80102f:	5e                   	pop    %esi
  801030:	5f                   	pop    %edi
  801031:	5d                   	pop    %ebp
  801032:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801033:	83 ec 0c             	sub    $0xc,%esp
  801036:	50                   	push   %eax
  801037:	6a 0d                	push   $0xd
  801039:	68 28 2c 80 00       	push   $0x802c28
  80103e:	6a 43                	push   $0x43
  801040:	68 45 2c 80 00       	push   $0x802c45
  801045:	e8 c8 f1 ff ff       	call   800212 <_panic>

0080104a <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
  80104d:	57                   	push   %edi
  80104e:	56                   	push   %esi
  80104f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801050:	bb 00 00 00 00       	mov    $0x0,%ebx
  801055:	8b 55 08             	mov    0x8(%ebp),%edx
  801058:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105b:	b8 0e 00 00 00       	mov    $0xe,%eax
  801060:	89 df                	mov    %ebx,%edi
  801062:	89 de                	mov    %ebx,%esi
  801064:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801066:	5b                   	pop    %ebx
  801067:	5e                   	pop    %esi
  801068:	5f                   	pop    %edi
  801069:	5d                   	pop    %ebp
  80106a:	c3                   	ret    

0080106b <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	57                   	push   %edi
  80106f:	56                   	push   %esi
  801070:	53                   	push   %ebx
	asm volatile("int %1\n"
  801071:	b9 00 00 00 00       	mov    $0x0,%ecx
  801076:	8b 55 08             	mov    0x8(%ebp),%edx
  801079:	b8 0f 00 00 00       	mov    $0xf,%eax
  80107e:	89 cb                	mov    %ecx,%ebx
  801080:	89 cf                	mov    %ecx,%edi
  801082:	89 ce                	mov    %ecx,%esi
  801084:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801086:	5b                   	pop    %ebx
  801087:	5e                   	pop    %esi
  801088:	5f                   	pop    %edi
  801089:	5d                   	pop    %ebp
  80108a:	c3                   	ret    

0080108b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80108b:	55                   	push   %ebp
  80108c:	89 e5                	mov    %esp,%ebp
  80108e:	57                   	push   %edi
  80108f:	56                   	push   %esi
  801090:	53                   	push   %ebx
	asm volatile("int %1\n"
  801091:	ba 00 00 00 00       	mov    $0x0,%edx
  801096:	b8 10 00 00 00       	mov    $0x10,%eax
  80109b:	89 d1                	mov    %edx,%ecx
  80109d:	89 d3                	mov    %edx,%ebx
  80109f:	89 d7                	mov    %edx,%edi
  8010a1:	89 d6                	mov    %edx,%esi
  8010a3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010a5:	5b                   	pop    %ebx
  8010a6:	5e                   	pop    %esi
  8010a7:	5f                   	pop    %edi
  8010a8:	5d                   	pop    %ebp
  8010a9:	c3                   	ret    

008010aa <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	57                   	push   %edi
  8010ae:	56                   	push   %esi
  8010af:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010bb:	b8 11 00 00 00       	mov    $0x11,%eax
  8010c0:	89 df                	mov    %ebx,%edi
  8010c2:	89 de                	mov    %ebx,%esi
  8010c4:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010c6:	5b                   	pop    %ebx
  8010c7:	5e                   	pop    %esi
  8010c8:	5f                   	pop    %edi
  8010c9:	5d                   	pop    %ebp
  8010ca:	c3                   	ret    

008010cb <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
  8010ce:	57                   	push   %edi
  8010cf:	56                   	push   %esi
  8010d0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010d1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010dc:	b8 12 00 00 00       	mov    $0x12,%eax
  8010e1:	89 df                	mov    %ebx,%edi
  8010e3:	89 de                	mov    %ebx,%esi
  8010e5:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010e7:	5b                   	pop    %ebx
  8010e8:	5e                   	pop    %esi
  8010e9:	5f                   	pop    %edi
  8010ea:	5d                   	pop    %ebp
  8010eb:	c3                   	ret    

008010ec <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8010ec:	55                   	push   %ebp
  8010ed:	89 e5                	mov    %esp,%ebp
  8010ef:	57                   	push   %edi
  8010f0:	56                   	push   %esi
  8010f1:	53                   	push   %ebx
  8010f2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010f5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801100:	b8 13 00 00 00       	mov    $0x13,%eax
  801105:	89 df                	mov    %ebx,%edi
  801107:	89 de                	mov    %ebx,%esi
  801109:	cd 30                	int    $0x30
	if(check && ret > 0)
  80110b:	85 c0                	test   %eax,%eax
  80110d:	7f 08                	jg     801117 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80110f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801112:	5b                   	pop    %ebx
  801113:	5e                   	pop    %esi
  801114:	5f                   	pop    %edi
  801115:	5d                   	pop    %ebp
  801116:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801117:	83 ec 0c             	sub    $0xc,%esp
  80111a:	50                   	push   %eax
  80111b:	6a 13                	push   $0x13
  80111d:	68 28 2c 80 00       	push   $0x802c28
  801122:	6a 43                	push   $0x43
  801124:	68 45 2c 80 00       	push   $0x802c45
  801129:	e8 e4 f0 ff ff       	call   800212 <_panic>

0080112e <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80112e:	55                   	push   %ebp
  80112f:	89 e5                	mov    %esp,%ebp
  801131:	57                   	push   %edi
  801132:	56                   	push   %esi
  801133:	53                   	push   %ebx
	asm volatile("int %1\n"
  801134:	b9 00 00 00 00       	mov    $0x0,%ecx
  801139:	8b 55 08             	mov    0x8(%ebp),%edx
  80113c:	b8 14 00 00 00       	mov    $0x14,%eax
  801141:	89 cb                	mov    %ecx,%ebx
  801143:	89 cf                	mov    %ecx,%edi
  801145:	89 ce                	mov    %ecx,%esi
  801147:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801149:	5b                   	pop    %ebx
  80114a:	5e                   	pop    %esi
  80114b:	5f                   	pop    %edi
  80114c:	5d                   	pop    %ebp
  80114d:	c3                   	ret    

0080114e <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
  801151:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801154:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  80115b:	74 0a                	je     801167 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  801165:	c9                   	leave  
  801166:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  801167:	83 ec 04             	sub    $0x4,%esp
  80116a:	6a 07                	push   $0x7
  80116c:	68 00 f0 bf ee       	push   $0xeebff000
  801171:	6a 00                	push   $0x0
  801173:	e8 e1 fc ff ff       	call   800e59 <sys_page_alloc>
		if(r < 0)
  801178:	83 c4 10             	add    $0x10,%esp
  80117b:	85 c0                	test   %eax,%eax
  80117d:	78 2a                	js     8011a9 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80117f:	83 ec 08             	sub    $0x8,%esp
  801182:	68 bd 11 80 00       	push   $0x8011bd
  801187:	6a 00                	push   $0x0
  801189:	e8 16 fe ff ff       	call   800fa4 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80118e:	83 c4 10             	add    $0x10,%esp
  801191:	85 c0                	test   %eax,%eax
  801193:	79 c8                	jns    80115d <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  801195:	83 ec 04             	sub    $0x4,%esp
  801198:	68 84 2c 80 00       	push   $0x802c84
  80119d:	6a 25                	push   $0x25
  80119f:	68 bd 2c 80 00       	push   $0x802cbd
  8011a4:	e8 69 f0 ff ff       	call   800212 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  8011a9:	83 ec 04             	sub    $0x4,%esp
  8011ac:	68 54 2c 80 00       	push   $0x802c54
  8011b1:	6a 22                	push   $0x22
  8011b3:	68 bd 2c 80 00       	push   $0x802cbd
  8011b8:	e8 55 f0 ff ff       	call   800212 <_panic>

008011bd <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8011bd:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8011be:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  8011c3:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8011c5:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  8011c8:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  8011cc:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  8011d0:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8011d3:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  8011d5:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8011d9:	83 c4 08             	add    $0x8,%esp
	popal
  8011dc:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8011dd:	83 c4 04             	add    $0x4,%esp
	popfl
  8011e0:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8011e1:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8011e2:	c3                   	ret    

008011e3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011e3:	55                   	push   %ebp
  8011e4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	05 00 00 00 30       	add    $0x30000000,%eax
  8011ee:	c1 e8 0c             	shr    $0xc,%eax
}
  8011f1:	5d                   	pop    %ebp
  8011f2:	c3                   	ret    

008011f3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f9:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801203:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801208:	5d                   	pop    %ebp
  801209:	c3                   	ret    

0080120a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80120a:	55                   	push   %ebp
  80120b:	89 e5                	mov    %esp,%ebp
  80120d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801212:	89 c2                	mov    %eax,%edx
  801214:	c1 ea 16             	shr    $0x16,%edx
  801217:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80121e:	f6 c2 01             	test   $0x1,%dl
  801221:	74 2d                	je     801250 <fd_alloc+0x46>
  801223:	89 c2                	mov    %eax,%edx
  801225:	c1 ea 0c             	shr    $0xc,%edx
  801228:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80122f:	f6 c2 01             	test   $0x1,%dl
  801232:	74 1c                	je     801250 <fd_alloc+0x46>
  801234:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801239:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80123e:	75 d2                	jne    801212 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801249:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80124e:	eb 0a                	jmp    80125a <fd_alloc+0x50>
			*fd_store = fd;
  801250:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801253:	89 01                	mov    %eax,(%ecx)
			return 0;
  801255:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80125a:	5d                   	pop    %ebp
  80125b:	c3                   	ret    

0080125c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80125c:	55                   	push   %ebp
  80125d:	89 e5                	mov    %esp,%ebp
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801262:	83 f8 1f             	cmp    $0x1f,%eax
  801265:	77 30                	ja     801297 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801267:	c1 e0 0c             	shl    $0xc,%eax
  80126a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80126f:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801275:	f6 c2 01             	test   $0x1,%dl
  801278:	74 24                	je     80129e <fd_lookup+0x42>
  80127a:	89 c2                	mov    %eax,%edx
  80127c:	c1 ea 0c             	shr    $0xc,%edx
  80127f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801286:	f6 c2 01             	test   $0x1,%dl
  801289:	74 1a                	je     8012a5 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80128b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80128e:	89 02                	mov    %eax,(%edx)
	return 0;
  801290:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801295:	5d                   	pop    %ebp
  801296:	c3                   	ret    
		return -E_INVAL;
  801297:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80129c:	eb f7                	jmp    801295 <fd_lookup+0x39>
		return -E_INVAL;
  80129e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012a3:	eb f0                	jmp    801295 <fd_lookup+0x39>
  8012a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012aa:	eb e9                	jmp    801295 <fd_lookup+0x39>

008012ac <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	83 ec 08             	sub    $0x8,%esp
  8012b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8012b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8012ba:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012bf:	39 08                	cmp    %ecx,(%eax)
  8012c1:	74 38                	je     8012fb <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8012c3:	83 c2 01             	add    $0x1,%edx
  8012c6:	8b 04 95 4c 2d 80 00 	mov    0x802d4c(,%edx,4),%eax
  8012cd:	85 c0                	test   %eax,%eax
  8012cf:	75 ee                	jne    8012bf <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012d1:	a1 08 40 80 00       	mov    0x804008,%eax
  8012d6:	8b 40 48             	mov    0x48(%eax),%eax
  8012d9:	83 ec 04             	sub    $0x4,%esp
  8012dc:	51                   	push   %ecx
  8012dd:	50                   	push   %eax
  8012de:	68 cc 2c 80 00       	push   $0x802ccc
  8012e3:	e8 20 f0 ff ff       	call   800308 <cprintf>
	*dev = 0;
  8012e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012f1:	83 c4 10             	add    $0x10,%esp
  8012f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    
			*dev = devtab[i];
  8012fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012fe:	89 01                	mov    %eax,(%ecx)
			return 0;
  801300:	b8 00 00 00 00       	mov    $0x0,%eax
  801305:	eb f2                	jmp    8012f9 <dev_lookup+0x4d>

00801307 <fd_close>:
{
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
  80130a:	57                   	push   %edi
  80130b:	56                   	push   %esi
  80130c:	53                   	push   %ebx
  80130d:	83 ec 24             	sub    $0x24,%esp
  801310:	8b 75 08             	mov    0x8(%ebp),%esi
  801313:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801316:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801319:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80131a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801320:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801323:	50                   	push   %eax
  801324:	e8 33 ff ff ff       	call   80125c <fd_lookup>
  801329:	89 c3                	mov    %eax,%ebx
  80132b:	83 c4 10             	add    $0x10,%esp
  80132e:	85 c0                	test   %eax,%eax
  801330:	78 05                	js     801337 <fd_close+0x30>
	    || fd != fd2)
  801332:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801335:	74 16                	je     80134d <fd_close+0x46>
		return (must_exist ? r : 0);
  801337:	89 f8                	mov    %edi,%eax
  801339:	84 c0                	test   %al,%al
  80133b:	b8 00 00 00 00       	mov    $0x0,%eax
  801340:	0f 44 d8             	cmove  %eax,%ebx
}
  801343:	89 d8                	mov    %ebx,%eax
  801345:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801348:	5b                   	pop    %ebx
  801349:	5e                   	pop    %esi
  80134a:	5f                   	pop    %edi
  80134b:	5d                   	pop    %ebp
  80134c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80134d:	83 ec 08             	sub    $0x8,%esp
  801350:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801353:	50                   	push   %eax
  801354:	ff 36                	pushl  (%esi)
  801356:	e8 51 ff ff ff       	call   8012ac <dev_lookup>
  80135b:	89 c3                	mov    %eax,%ebx
  80135d:	83 c4 10             	add    $0x10,%esp
  801360:	85 c0                	test   %eax,%eax
  801362:	78 1a                	js     80137e <fd_close+0x77>
		if (dev->dev_close)
  801364:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801367:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80136a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80136f:	85 c0                	test   %eax,%eax
  801371:	74 0b                	je     80137e <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801373:	83 ec 0c             	sub    $0xc,%esp
  801376:	56                   	push   %esi
  801377:	ff d0                	call   *%eax
  801379:	89 c3                	mov    %eax,%ebx
  80137b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80137e:	83 ec 08             	sub    $0x8,%esp
  801381:	56                   	push   %esi
  801382:	6a 00                	push   $0x0
  801384:	e8 55 fb ff ff       	call   800ede <sys_page_unmap>
	return r;
  801389:	83 c4 10             	add    $0x10,%esp
  80138c:	eb b5                	jmp    801343 <fd_close+0x3c>

0080138e <close>:

int
close(int fdnum)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
  801391:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801394:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801397:	50                   	push   %eax
  801398:	ff 75 08             	pushl  0x8(%ebp)
  80139b:	e8 bc fe ff ff       	call   80125c <fd_lookup>
  8013a0:	83 c4 10             	add    $0x10,%esp
  8013a3:	85 c0                	test   %eax,%eax
  8013a5:	79 02                	jns    8013a9 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8013a7:	c9                   	leave  
  8013a8:	c3                   	ret    
		return fd_close(fd, 1);
  8013a9:	83 ec 08             	sub    $0x8,%esp
  8013ac:	6a 01                	push   $0x1
  8013ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8013b1:	e8 51 ff ff ff       	call   801307 <fd_close>
  8013b6:	83 c4 10             	add    $0x10,%esp
  8013b9:	eb ec                	jmp    8013a7 <close+0x19>

008013bb <close_all>:

void
close_all(void)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	53                   	push   %ebx
  8013bf:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013c2:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013c7:	83 ec 0c             	sub    $0xc,%esp
  8013ca:	53                   	push   %ebx
  8013cb:	e8 be ff ff ff       	call   80138e <close>
	for (i = 0; i < MAXFD; i++)
  8013d0:	83 c3 01             	add    $0x1,%ebx
  8013d3:	83 c4 10             	add    $0x10,%esp
  8013d6:	83 fb 20             	cmp    $0x20,%ebx
  8013d9:	75 ec                	jne    8013c7 <close_all+0xc>
}
  8013db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013de:	c9                   	leave  
  8013df:	c3                   	ret    

008013e0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
  8013e3:	57                   	push   %edi
  8013e4:	56                   	push   %esi
  8013e5:	53                   	push   %ebx
  8013e6:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013e9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013ec:	50                   	push   %eax
  8013ed:	ff 75 08             	pushl  0x8(%ebp)
  8013f0:	e8 67 fe ff ff       	call   80125c <fd_lookup>
  8013f5:	89 c3                	mov    %eax,%ebx
  8013f7:	83 c4 10             	add    $0x10,%esp
  8013fa:	85 c0                	test   %eax,%eax
  8013fc:	0f 88 81 00 00 00    	js     801483 <dup+0xa3>
		return r;
	close(newfdnum);
  801402:	83 ec 0c             	sub    $0xc,%esp
  801405:	ff 75 0c             	pushl  0xc(%ebp)
  801408:	e8 81 ff ff ff       	call   80138e <close>

	newfd = INDEX2FD(newfdnum);
  80140d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801410:	c1 e6 0c             	shl    $0xc,%esi
  801413:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801419:	83 c4 04             	add    $0x4,%esp
  80141c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80141f:	e8 cf fd ff ff       	call   8011f3 <fd2data>
  801424:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801426:	89 34 24             	mov    %esi,(%esp)
  801429:	e8 c5 fd ff ff       	call   8011f3 <fd2data>
  80142e:	83 c4 10             	add    $0x10,%esp
  801431:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801433:	89 d8                	mov    %ebx,%eax
  801435:	c1 e8 16             	shr    $0x16,%eax
  801438:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80143f:	a8 01                	test   $0x1,%al
  801441:	74 11                	je     801454 <dup+0x74>
  801443:	89 d8                	mov    %ebx,%eax
  801445:	c1 e8 0c             	shr    $0xc,%eax
  801448:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80144f:	f6 c2 01             	test   $0x1,%dl
  801452:	75 39                	jne    80148d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801454:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801457:	89 d0                	mov    %edx,%eax
  801459:	c1 e8 0c             	shr    $0xc,%eax
  80145c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801463:	83 ec 0c             	sub    $0xc,%esp
  801466:	25 07 0e 00 00       	and    $0xe07,%eax
  80146b:	50                   	push   %eax
  80146c:	56                   	push   %esi
  80146d:	6a 00                	push   $0x0
  80146f:	52                   	push   %edx
  801470:	6a 00                	push   $0x0
  801472:	e8 25 fa ff ff       	call   800e9c <sys_page_map>
  801477:	89 c3                	mov    %eax,%ebx
  801479:	83 c4 20             	add    $0x20,%esp
  80147c:	85 c0                	test   %eax,%eax
  80147e:	78 31                	js     8014b1 <dup+0xd1>
		goto err;

	return newfdnum;
  801480:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801483:	89 d8                	mov    %ebx,%eax
  801485:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801488:	5b                   	pop    %ebx
  801489:	5e                   	pop    %esi
  80148a:	5f                   	pop    %edi
  80148b:	5d                   	pop    %ebp
  80148c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80148d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801494:	83 ec 0c             	sub    $0xc,%esp
  801497:	25 07 0e 00 00       	and    $0xe07,%eax
  80149c:	50                   	push   %eax
  80149d:	57                   	push   %edi
  80149e:	6a 00                	push   $0x0
  8014a0:	53                   	push   %ebx
  8014a1:	6a 00                	push   $0x0
  8014a3:	e8 f4 f9 ff ff       	call   800e9c <sys_page_map>
  8014a8:	89 c3                	mov    %eax,%ebx
  8014aa:	83 c4 20             	add    $0x20,%esp
  8014ad:	85 c0                	test   %eax,%eax
  8014af:	79 a3                	jns    801454 <dup+0x74>
	sys_page_unmap(0, newfd);
  8014b1:	83 ec 08             	sub    $0x8,%esp
  8014b4:	56                   	push   %esi
  8014b5:	6a 00                	push   $0x0
  8014b7:	e8 22 fa ff ff       	call   800ede <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014bc:	83 c4 08             	add    $0x8,%esp
  8014bf:	57                   	push   %edi
  8014c0:	6a 00                	push   $0x0
  8014c2:	e8 17 fa ff ff       	call   800ede <sys_page_unmap>
	return r;
  8014c7:	83 c4 10             	add    $0x10,%esp
  8014ca:	eb b7                	jmp    801483 <dup+0xa3>

008014cc <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	53                   	push   %ebx
  8014d0:	83 ec 1c             	sub    $0x1c,%esp
  8014d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014d9:	50                   	push   %eax
  8014da:	53                   	push   %ebx
  8014db:	e8 7c fd ff ff       	call   80125c <fd_lookup>
  8014e0:	83 c4 10             	add    $0x10,%esp
  8014e3:	85 c0                	test   %eax,%eax
  8014e5:	78 3f                	js     801526 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014e7:	83 ec 08             	sub    $0x8,%esp
  8014ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ed:	50                   	push   %eax
  8014ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f1:	ff 30                	pushl  (%eax)
  8014f3:	e8 b4 fd ff ff       	call   8012ac <dev_lookup>
  8014f8:	83 c4 10             	add    $0x10,%esp
  8014fb:	85 c0                	test   %eax,%eax
  8014fd:	78 27                	js     801526 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801502:	8b 42 08             	mov    0x8(%edx),%eax
  801505:	83 e0 03             	and    $0x3,%eax
  801508:	83 f8 01             	cmp    $0x1,%eax
  80150b:	74 1e                	je     80152b <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80150d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801510:	8b 40 08             	mov    0x8(%eax),%eax
  801513:	85 c0                	test   %eax,%eax
  801515:	74 35                	je     80154c <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801517:	83 ec 04             	sub    $0x4,%esp
  80151a:	ff 75 10             	pushl  0x10(%ebp)
  80151d:	ff 75 0c             	pushl  0xc(%ebp)
  801520:	52                   	push   %edx
  801521:	ff d0                	call   *%eax
  801523:	83 c4 10             	add    $0x10,%esp
}
  801526:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801529:	c9                   	leave  
  80152a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80152b:	a1 08 40 80 00       	mov    0x804008,%eax
  801530:	8b 40 48             	mov    0x48(%eax),%eax
  801533:	83 ec 04             	sub    $0x4,%esp
  801536:	53                   	push   %ebx
  801537:	50                   	push   %eax
  801538:	68 10 2d 80 00       	push   $0x802d10
  80153d:	e8 c6 ed ff ff       	call   800308 <cprintf>
		return -E_INVAL;
  801542:	83 c4 10             	add    $0x10,%esp
  801545:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80154a:	eb da                	jmp    801526 <read+0x5a>
		return -E_NOT_SUPP;
  80154c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801551:	eb d3                	jmp    801526 <read+0x5a>

00801553 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	57                   	push   %edi
  801557:	56                   	push   %esi
  801558:	53                   	push   %ebx
  801559:	83 ec 0c             	sub    $0xc,%esp
  80155c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80155f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801562:	bb 00 00 00 00       	mov    $0x0,%ebx
  801567:	39 f3                	cmp    %esi,%ebx
  801569:	73 23                	jae    80158e <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80156b:	83 ec 04             	sub    $0x4,%esp
  80156e:	89 f0                	mov    %esi,%eax
  801570:	29 d8                	sub    %ebx,%eax
  801572:	50                   	push   %eax
  801573:	89 d8                	mov    %ebx,%eax
  801575:	03 45 0c             	add    0xc(%ebp),%eax
  801578:	50                   	push   %eax
  801579:	57                   	push   %edi
  80157a:	e8 4d ff ff ff       	call   8014cc <read>
		if (m < 0)
  80157f:	83 c4 10             	add    $0x10,%esp
  801582:	85 c0                	test   %eax,%eax
  801584:	78 06                	js     80158c <readn+0x39>
			return m;
		if (m == 0)
  801586:	74 06                	je     80158e <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801588:	01 c3                	add    %eax,%ebx
  80158a:	eb db                	jmp    801567 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80158c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80158e:	89 d8                	mov    %ebx,%eax
  801590:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801593:	5b                   	pop    %ebx
  801594:	5e                   	pop    %esi
  801595:	5f                   	pop    %edi
  801596:	5d                   	pop    %ebp
  801597:	c3                   	ret    

00801598 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	53                   	push   %ebx
  80159c:	83 ec 1c             	sub    $0x1c,%esp
  80159f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015a2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015a5:	50                   	push   %eax
  8015a6:	53                   	push   %ebx
  8015a7:	e8 b0 fc ff ff       	call   80125c <fd_lookup>
  8015ac:	83 c4 10             	add    $0x10,%esp
  8015af:	85 c0                	test   %eax,%eax
  8015b1:	78 3a                	js     8015ed <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015b3:	83 ec 08             	sub    $0x8,%esp
  8015b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b9:	50                   	push   %eax
  8015ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015bd:	ff 30                	pushl  (%eax)
  8015bf:	e8 e8 fc ff ff       	call   8012ac <dev_lookup>
  8015c4:	83 c4 10             	add    $0x10,%esp
  8015c7:	85 c0                	test   %eax,%eax
  8015c9:	78 22                	js     8015ed <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ce:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015d2:	74 1e                	je     8015f2 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d7:	8b 52 0c             	mov    0xc(%edx),%edx
  8015da:	85 d2                	test   %edx,%edx
  8015dc:	74 35                	je     801613 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015de:	83 ec 04             	sub    $0x4,%esp
  8015e1:	ff 75 10             	pushl  0x10(%ebp)
  8015e4:	ff 75 0c             	pushl  0xc(%ebp)
  8015e7:	50                   	push   %eax
  8015e8:	ff d2                	call   *%edx
  8015ea:	83 c4 10             	add    $0x10,%esp
}
  8015ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015f2:	a1 08 40 80 00       	mov    0x804008,%eax
  8015f7:	8b 40 48             	mov    0x48(%eax),%eax
  8015fa:	83 ec 04             	sub    $0x4,%esp
  8015fd:	53                   	push   %ebx
  8015fe:	50                   	push   %eax
  8015ff:	68 2c 2d 80 00       	push   $0x802d2c
  801604:	e8 ff ec ff ff       	call   800308 <cprintf>
		return -E_INVAL;
  801609:	83 c4 10             	add    $0x10,%esp
  80160c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801611:	eb da                	jmp    8015ed <write+0x55>
		return -E_NOT_SUPP;
  801613:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801618:	eb d3                	jmp    8015ed <write+0x55>

0080161a <seek>:

int
seek(int fdnum, off_t offset)
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
  80161d:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801620:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801623:	50                   	push   %eax
  801624:	ff 75 08             	pushl  0x8(%ebp)
  801627:	e8 30 fc ff ff       	call   80125c <fd_lookup>
  80162c:	83 c4 10             	add    $0x10,%esp
  80162f:	85 c0                	test   %eax,%eax
  801631:	78 0e                	js     801641 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801633:	8b 55 0c             	mov    0xc(%ebp),%edx
  801636:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801639:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80163c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801641:	c9                   	leave  
  801642:	c3                   	ret    

00801643 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
  801646:	53                   	push   %ebx
  801647:	83 ec 1c             	sub    $0x1c,%esp
  80164a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80164d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801650:	50                   	push   %eax
  801651:	53                   	push   %ebx
  801652:	e8 05 fc ff ff       	call   80125c <fd_lookup>
  801657:	83 c4 10             	add    $0x10,%esp
  80165a:	85 c0                	test   %eax,%eax
  80165c:	78 37                	js     801695 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80165e:	83 ec 08             	sub    $0x8,%esp
  801661:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801664:	50                   	push   %eax
  801665:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801668:	ff 30                	pushl  (%eax)
  80166a:	e8 3d fc ff ff       	call   8012ac <dev_lookup>
  80166f:	83 c4 10             	add    $0x10,%esp
  801672:	85 c0                	test   %eax,%eax
  801674:	78 1f                	js     801695 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801676:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801679:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80167d:	74 1b                	je     80169a <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80167f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801682:	8b 52 18             	mov    0x18(%edx),%edx
  801685:	85 d2                	test   %edx,%edx
  801687:	74 32                	je     8016bb <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801689:	83 ec 08             	sub    $0x8,%esp
  80168c:	ff 75 0c             	pushl  0xc(%ebp)
  80168f:	50                   	push   %eax
  801690:	ff d2                	call   *%edx
  801692:	83 c4 10             	add    $0x10,%esp
}
  801695:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801698:	c9                   	leave  
  801699:	c3                   	ret    
			thisenv->env_id, fdnum);
  80169a:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80169f:	8b 40 48             	mov    0x48(%eax),%eax
  8016a2:	83 ec 04             	sub    $0x4,%esp
  8016a5:	53                   	push   %ebx
  8016a6:	50                   	push   %eax
  8016a7:	68 ec 2c 80 00       	push   $0x802cec
  8016ac:	e8 57 ec ff ff       	call   800308 <cprintf>
		return -E_INVAL;
  8016b1:	83 c4 10             	add    $0x10,%esp
  8016b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016b9:	eb da                	jmp    801695 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8016bb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016c0:	eb d3                	jmp    801695 <ftruncate+0x52>

008016c2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
  8016c5:	53                   	push   %ebx
  8016c6:	83 ec 1c             	sub    $0x1c,%esp
  8016c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016cc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016cf:	50                   	push   %eax
  8016d0:	ff 75 08             	pushl  0x8(%ebp)
  8016d3:	e8 84 fb ff ff       	call   80125c <fd_lookup>
  8016d8:	83 c4 10             	add    $0x10,%esp
  8016db:	85 c0                	test   %eax,%eax
  8016dd:	78 4b                	js     80172a <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016df:	83 ec 08             	sub    $0x8,%esp
  8016e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016e5:	50                   	push   %eax
  8016e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e9:	ff 30                	pushl  (%eax)
  8016eb:	e8 bc fb ff ff       	call   8012ac <dev_lookup>
  8016f0:	83 c4 10             	add    $0x10,%esp
  8016f3:	85 c0                	test   %eax,%eax
  8016f5:	78 33                	js     80172a <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8016f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016fa:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016fe:	74 2f                	je     80172f <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801700:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801703:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80170a:	00 00 00 
	stat->st_isdir = 0;
  80170d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801714:	00 00 00 
	stat->st_dev = dev;
  801717:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80171d:	83 ec 08             	sub    $0x8,%esp
  801720:	53                   	push   %ebx
  801721:	ff 75 f0             	pushl  -0x10(%ebp)
  801724:	ff 50 14             	call   *0x14(%eax)
  801727:	83 c4 10             	add    $0x10,%esp
}
  80172a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    
		return -E_NOT_SUPP;
  80172f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801734:	eb f4                	jmp    80172a <fstat+0x68>

00801736 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	56                   	push   %esi
  80173a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80173b:	83 ec 08             	sub    $0x8,%esp
  80173e:	6a 00                	push   $0x0
  801740:	ff 75 08             	pushl  0x8(%ebp)
  801743:	e8 22 02 00 00       	call   80196a <open>
  801748:	89 c3                	mov    %eax,%ebx
  80174a:	83 c4 10             	add    $0x10,%esp
  80174d:	85 c0                	test   %eax,%eax
  80174f:	78 1b                	js     80176c <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801751:	83 ec 08             	sub    $0x8,%esp
  801754:	ff 75 0c             	pushl  0xc(%ebp)
  801757:	50                   	push   %eax
  801758:	e8 65 ff ff ff       	call   8016c2 <fstat>
  80175d:	89 c6                	mov    %eax,%esi
	close(fd);
  80175f:	89 1c 24             	mov    %ebx,(%esp)
  801762:	e8 27 fc ff ff       	call   80138e <close>
	return r;
  801767:	83 c4 10             	add    $0x10,%esp
  80176a:	89 f3                	mov    %esi,%ebx
}
  80176c:	89 d8                	mov    %ebx,%eax
  80176e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801771:	5b                   	pop    %ebx
  801772:	5e                   	pop    %esi
  801773:	5d                   	pop    %ebp
  801774:	c3                   	ret    

00801775 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	56                   	push   %esi
  801779:	53                   	push   %ebx
  80177a:	89 c6                	mov    %eax,%esi
  80177c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80177e:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801785:	74 27                	je     8017ae <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801787:	6a 07                	push   $0x7
  801789:	68 00 50 80 00       	push   $0x805000
  80178e:	56                   	push   %esi
  80178f:	ff 35 00 40 80 00    	pushl  0x804000
  801795:	e8 08 0c 00 00       	call   8023a2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80179a:	83 c4 0c             	add    $0xc,%esp
  80179d:	6a 00                	push   $0x0
  80179f:	53                   	push   %ebx
  8017a0:	6a 00                	push   $0x0
  8017a2:	e8 92 0b 00 00       	call   802339 <ipc_recv>
}
  8017a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017aa:	5b                   	pop    %ebx
  8017ab:	5e                   	pop    %esi
  8017ac:	5d                   	pop    %ebp
  8017ad:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017ae:	83 ec 0c             	sub    $0xc,%esp
  8017b1:	6a 01                	push   $0x1
  8017b3:	e8 42 0c 00 00       	call   8023fa <ipc_find_env>
  8017b8:	a3 00 40 80 00       	mov    %eax,0x804000
  8017bd:	83 c4 10             	add    $0x10,%esp
  8017c0:	eb c5                	jmp    801787 <fsipc+0x12>

008017c2 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
  8017c5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ce:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d6:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017db:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e0:	b8 02 00 00 00       	mov    $0x2,%eax
  8017e5:	e8 8b ff ff ff       	call   801775 <fsipc>
}
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <devfile_flush>:
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8017f8:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801802:	b8 06 00 00 00       	mov    $0x6,%eax
  801807:	e8 69 ff ff ff       	call   801775 <fsipc>
}
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <devfile_stat>:
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	53                   	push   %ebx
  801812:	83 ec 04             	sub    $0x4,%esp
  801815:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801818:	8b 45 08             	mov    0x8(%ebp),%eax
  80181b:	8b 40 0c             	mov    0xc(%eax),%eax
  80181e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801823:	ba 00 00 00 00       	mov    $0x0,%edx
  801828:	b8 05 00 00 00       	mov    $0x5,%eax
  80182d:	e8 43 ff ff ff       	call   801775 <fsipc>
  801832:	85 c0                	test   %eax,%eax
  801834:	78 2c                	js     801862 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801836:	83 ec 08             	sub    $0x8,%esp
  801839:	68 00 50 80 00       	push   $0x805000
  80183e:	53                   	push   %ebx
  80183f:	e8 23 f2 ff ff       	call   800a67 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801844:	a1 80 50 80 00       	mov    0x805080,%eax
  801849:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80184f:	a1 84 50 80 00       	mov    0x805084,%eax
  801854:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80185a:	83 c4 10             	add    $0x10,%esp
  80185d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801862:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <devfile_write>:
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	53                   	push   %ebx
  80186b:	83 ec 08             	sub    $0x8,%esp
  80186e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	8b 40 0c             	mov    0xc(%eax),%eax
  801877:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80187c:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801882:	53                   	push   %ebx
  801883:	ff 75 0c             	pushl  0xc(%ebp)
  801886:	68 08 50 80 00       	push   $0x805008
  80188b:	e8 c7 f3 ff ff       	call   800c57 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801890:	ba 00 00 00 00       	mov    $0x0,%edx
  801895:	b8 04 00 00 00       	mov    $0x4,%eax
  80189a:	e8 d6 fe ff ff       	call   801775 <fsipc>
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	85 c0                	test   %eax,%eax
  8018a4:	78 0b                	js     8018b1 <devfile_write+0x4a>
	assert(r <= n);
  8018a6:	39 d8                	cmp    %ebx,%eax
  8018a8:	77 0c                	ja     8018b6 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8018aa:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018af:	7f 1e                	jg     8018cf <devfile_write+0x68>
}
  8018b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    
	assert(r <= n);
  8018b6:	68 60 2d 80 00       	push   $0x802d60
  8018bb:	68 67 2d 80 00       	push   $0x802d67
  8018c0:	68 98 00 00 00       	push   $0x98
  8018c5:	68 7c 2d 80 00       	push   $0x802d7c
  8018ca:	e8 43 e9 ff ff       	call   800212 <_panic>
	assert(r <= PGSIZE);
  8018cf:	68 87 2d 80 00       	push   $0x802d87
  8018d4:	68 67 2d 80 00       	push   $0x802d67
  8018d9:	68 99 00 00 00       	push   $0x99
  8018de:	68 7c 2d 80 00       	push   $0x802d7c
  8018e3:	e8 2a e9 ff ff       	call   800212 <_panic>

008018e8 <devfile_read>:
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	56                   	push   %esi
  8018ec:	53                   	push   %ebx
  8018ed:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8018f6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018fb:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801901:	ba 00 00 00 00       	mov    $0x0,%edx
  801906:	b8 03 00 00 00       	mov    $0x3,%eax
  80190b:	e8 65 fe ff ff       	call   801775 <fsipc>
  801910:	89 c3                	mov    %eax,%ebx
  801912:	85 c0                	test   %eax,%eax
  801914:	78 1f                	js     801935 <devfile_read+0x4d>
	assert(r <= n);
  801916:	39 f0                	cmp    %esi,%eax
  801918:	77 24                	ja     80193e <devfile_read+0x56>
	assert(r <= PGSIZE);
  80191a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80191f:	7f 33                	jg     801954 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801921:	83 ec 04             	sub    $0x4,%esp
  801924:	50                   	push   %eax
  801925:	68 00 50 80 00       	push   $0x805000
  80192a:	ff 75 0c             	pushl  0xc(%ebp)
  80192d:	e8 c3 f2 ff ff       	call   800bf5 <memmove>
	return r;
  801932:	83 c4 10             	add    $0x10,%esp
}
  801935:	89 d8                	mov    %ebx,%eax
  801937:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80193a:	5b                   	pop    %ebx
  80193b:	5e                   	pop    %esi
  80193c:	5d                   	pop    %ebp
  80193d:	c3                   	ret    
	assert(r <= n);
  80193e:	68 60 2d 80 00       	push   $0x802d60
  801943:	68 67 2d 80 00       	push   $0x802d67
  801948:	6a 7c                	push   $0x7c
  80194a:	68 7c 2d 80 00       	push   $0x802d7c
  80194f:	e8 be e8 ff ff       	call   800212 <_panic>
	assert(r <= PGSIZE);
  801954:	68 87 2d 80 00       	push   $0x802d87
  801959:	68 67 2d 80 00       	push   $0x802d67
  80195e:	6a 7d                	push   $0x7d
  801960:	68 7c 2d 80 00       	push   $0x802d7c
  801965:	e8 a8 e8 ff ff       	call   800212 <_panic>

0080196a <open>:
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	56                   	push   %esi
  80196e:	53                   	push   %ebx
  80196f:	83 ec 1c             	sub    $0x1c,%esp
  801972:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801975:	56                   	push   %esi
  801976:	e8 b3 f0 ff ff       	call   800a2e <strlen>
  80197b:	83 c4 10             	add    $0x10,%esp
  80197e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801983:	7f 6c                	jg     8019f1 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801985:	83 ec 0c             	sub    $0xc,%esp
  801988:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80198b:	50                   	push   %eax
  80198c:	e8 79 f8 ff ff       	call   80120a <fd_alloc>
  801991:	89 c3                	mov    %eax,%ebx
  801993:	83 c4 10             	add    $0x10,%esp
  801996:	85 c0                	test   %eax,%eax
  801998:	78 3c                	js     8019d6 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80199a:	83 ec 08             	sub    $0x8,%esp
  80199d:	56                   	push   %esi
  80199e:	68 00 50 80 00       	push   $0x805000
  8019a3:	e8 bf f0 ff ff       	call   800a67 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ab:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8019b8:	e8 b8 fd ff ff       	call   801775 <fsipc>
  8019bd:	89 c3                	mov    %eax,%ebx
  8019bf:	83 c4 10             	add    $0x10,%esp
  8019c2:	85 c0                	test   %eax,%eax
  8019c4:	78 19                	js     8019df <open+0x75>
	return fd2num(fd);
  8019c6:	83 ec 0c             	sub    $0xc,%esp
  8019c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8019cc:	e8 12 f8 ff ff       	call   8011e3 <fd2num>
  8019d1:	89 c3                	mov    %eax,%ebx
  8019d3:	83 c4 10             	add    $0x10,%esp
}
  8019d6:	89 d8                	mov    %ebx,%eax
  8019d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019db:	5b                   	pop    %ebx
  8019dc:	5e                   	pop    %esi
  8019dd:	5d                   	pop    %ebp
  8019de:	c3                   	ret    
		fd_close(fd, 0);
  8019df:	83 ec 08             	sub    $0x8,%esp
  8019e2:	6a 00                	push   $0x0
  8019e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8019e7:	e8 1b f9 ff ff       	call   801307 <fd_close>
		return r;
  8019ec:	83 c4 10             	add    $0x10,%esp
  8019ef:	eb e5                	jmp    8019d6 <open+0x6c>
		return -E_BAD_PATH;
  8019f1:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019f6:	eb de                	jmp    8019d6 <open+0x6c>

008019f8 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
  8019fb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801a03:	b8 08 00 00 00       	mov    $0x8,%eax
  801a08:	e8 68 fd ff ff       	call   801775 <fsipc>
}
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801a15:	68 93 2d 80 00       	push   $0x802d93
  801a1a:	ff 75 0c             	pushl  0xc(%ebp)
  801a1d:	e8 45 f0 ff ff       	call   800a67 <strcpy>
	return 0;
}
  801a22:	b8 00 00 00 00       	mov    $0x0,%eax
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <devsock_close>:
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
  801a2c:	53                   	push   %ebx
  801a2d:	83 ec 10             	sub    $0x10,%esp
  801a30:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a33:	53                   	push   %ebx
  801a34:	e8 00 0a 00 00       	call   802439 <pageref>
  801a39:	83 c4 10             	add    $0x10,%esp
		return 0;
  801a3c:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801a41:	83 f8 01             	cmp    $0x1,%eax
  801a44:	74 07                	je     801a4d <devsock_close+0x24>
}
  801a46:	89 d0                	mov    %edx,%eax
  801a48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801a4d:	83 ec 0c             	sub    $0xc,%esp
  801a50:	ff 73 0c             	pushl  0xc(%ebx)
  801a53:	e8 b9 02 00 00       	call   801d11 <nsipc_close>
  801a58:	89 c2                	mov    %eax,%edx
  801a5a:	83 c4 10             	add    $0x10,%esp
  801a5d:	eb e7                	jmp    801a46 <devsock_close+0x1d>

00801a5f <devsock_write>:
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a65:	6a 00                	push   $0x0
  801a67:	ff 75 10             	pushl  0x10(%ebp)
  801a6a:	ff 75 0c             	pushl  0xc(%ebp)
  801a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a70:	ff 70 0c             	pushl  0xc(%eax)
  801a73:	e8 76 03 00 00       	call   801dee <nsipc_send>
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <devsock_read>:
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
  801a7d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a80:	6a 00                	push   $0x0
  801a82:	ff 75 10             	pushl  0x10(%ebp)
  801a85:	ff 75 0c             	pushl  0xc(%ebp)
  801a88:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8b:	ff 70 0c             	pushl  0xc(%eax)
  801a8e:	e8 ef 02 00 00       	call   801d82 <nsipc_recv>
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <fd2sockid>:
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a9b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a9e:	52                   	push   %edx
  801a9f:	50                   	push   %eax
  801aa0:	e8 b7 f7 ff ff       	call   80125c <fd_lookup>
  801aa5:	83 c4 10             	add    $0x10,%esp
  801aa8:	85 c0                	test   %eax,%eax
  801aaa:	78 10                	js     801abc <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aaf:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801ab5:	39 08                	cmp    %ecx,(%eax)
  801ab7:	75 05                	jne    801abe <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801ab9:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    
		return -E_NOT_SUPP;
  801abe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ac3:	eb f7                	jmp    801abc <fd2sockid+0x27>

00801ac5 <alloc_sockfd>:
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
  801ac8:	56                   	push   %esi
  801ac9:	53                   	push   %ebx
  801aca:	83 ec 1c             	sub    $0x1c,%esp
  801acd:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801acf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad2:	50                   	push   %eax
  801ad3:	e8 32 f7 ff ff       	call   80120a <fd_alloc>
  801ad8:	89 c3                	mov    %eax,%ebx
  801ada:	83 c4 10             	add    $0x10,%esp
  801add:	85 c0                	test   %eax,%eax
  801adf:	78 43                	js     801b24 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ae1:	83 ec 04             	sub    $0x4,%esp
  801ae4:	68 07 04 00 00       	push   $0x407
  801ae9:	ff 75 f4             	pushl  -0xc(%ebp)
  801aec:	6a 00                	push   $0x0
  801aee:	e8 66 f3 ff ff       	call   800e59 <sys_page_alloc>
  801af3:	89 c3                	mov    %eax,%ebx
  801af5:	83 c4 10             	add    $0x10,%esp
  801af8:	85 c0                	test   %eax,%eax
  801afa:	78 28                	js     801b24 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aff:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b05:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b0a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801b11:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801b14:	83 ec 0c             	sub    $0xc,%esp
  801b17:	50                   	push   %eax
  801b18:	e8 c6 f6 ff ff       	call   8011e3 <fd2num>
  801b1d:	89 c3                	mov    %eax,%ebx
  801b1f:	83 c4 10             	add    $0x10,%esp
  801b22:	eb 0c                	jmp    801b30 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801b24:	83 ec 0c             	sub    $0xc,%esp
  801b27:	56                   	push   %esi
  801b28:	e8 e4 01 00 00       	call   801d11 <nsipc_close>
		return r;
  801b2d:	83 c4 10             	add    $0x10,%esp
}
  801b30:	89 d8                	mov    %ebx,%eax
  801b32:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b35:	5b                   	pop    %ebx
  801b36:	5e                   	pop    %esi
  801b37:	5d                   	pop    %ebp
  801b38:	c3                   	ret    

00801b39 <accept>:
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	e8 4e ff ff ff       	call   801a95 <fd2sockid>
  801b47:	85 c0                	test   %eax,%eax
  801b49:	78 1b                	js     801b66 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b4b:	83 ec 04             	sub    $0x4,%esp
  801b4e:	ff 75 10             	pushl  0x10(%ebp)
  801b51:	ff 75 0c             	pushl  0xc(%ebp)
  801b54:	50                   	push   %eax
  801b55:	e8 0e 01 00 00       	call   801c68 <nsipc_accept>
  801b5a:	83 c4 10             	add    $0x10,%esp
  801b5d:	85 c0                	test   %eax,%eax
  801b5f:	78 05                	js     801b66 <accept+0x2d>
	return alloc_sockfd(r);
  801b61:	e8 5f ff ff ff       	call   801ac5 <alloc_sockfd>
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <bind>:
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
  801b6b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b71:	e8 1f ff ff ff       	call   801a95 <fd2sockid>
  801b76:	85 c0                	test   %eax,%eax
  801b78:	78 12                	js     801b8c <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801b7a:	83 ec 04             	sub    $0x4,%esp
  801b7d:	ff 75 10             	pushl  0x10(%ebp)
  801b80:	ff 75 0c             	pushl  0xc(%ebp)
  801b83:	50                   	push   %eax
  801b84:	e8 31 01 00 00       	call   801cba <nsipc_bind>
  801b89:	83 c4 10             	add    $0x10,%esp
}
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <shutdown>:
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
  801b91:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	e8 f9 fe ff ff       	call   801a95 <fd2sockid>
  801b9c:	85 c0                	test   %eax,%eax
  801b9e:	78 0f                	js     801baf <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801ba0:	83 ec 08             	sub    $0x8,%esp
  801ba3:	ff 75 0c             	pushl  0xc(%ebp)
  801ba6:	50                   	push   %eax
  801ba7:	e8 43 01 00 00       	call   801cef <nsipc_shutdown>
  801bac:	83 c4 10             	add    $0x10,%esp
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <connect>:
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
  801bb4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	e8 d6 fe ff ff       	call   801a95 <fd2sockid>
  801bbf:	85 c0                	test   %eax,%eax
  801bc1:	78 12                	js     801bd5 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801bc3:	83 ec 04             	sub    $0x4,%esp
  801bc6:	ff 75 10             	pushl  0x10(%ebp)
  801bc9:	ff 75 0c             	pushl  0xc(%ebp)
  801bcc:	50                   	push   %eax
  801bcd:	e8 59 01 00 00       	call   801d2b <nsipc_connect>
  801bd2:	83 c4 10             	add    $0x10,%esp
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <listen>:
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
  801bda:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801be0:	e8 b0 fe ff ff       	call   801a95 <fd2sockid>
  801be5:	85 c0                	test   %eax,%eax
  801be7:	78 0f                	js     801bf8 <listen+0x21>
	return nsipc_listen(r, backlog);
  801be9:	83 ec 08             	sub    $0x8,%esp
  801bec:	ff 75 0c             	pushl  0xc(%ebp)
  801bef:	50                   	push   %eax
  801bf0:	e8 6b 01 00 00       	call   801d60 <nsipc_listen>
  801bf5:	83 c4 10             	add    $0x10,%esp
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <socket>:

int
socket(int domain, int type, int protocol)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
  801bfd:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c00:	ff 75 10             	pushl  0x10(%ebp)
  801c03:	ff 75 0c             	pushl  0xc(%ebp)
  801c06:	ff 75 08             	pushl  0x8(%ebp)
  801c09:	e8 3e 02 00 00       	call   801e4c <nsipc_socket>
  801c0e:	83 c4 10             	add    $0x10,%esp
  801c11:	85 c0                	test   %eax,%eax
  801c13:	78 05                	js     801c1a <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801c15:	e8 ab fe ff ff       	call   801ac5 <alloc_sockfd>
}
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
  801c1f:	53                   	push   %ebx
  801c20:	83 ec 04             	sub    $0x4,%esp
  801c23:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c25:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c2c:	74 26                	je     801c54 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c2e:	6a 07                	push   $0x7
  801c30:	68 00 60 80 00       	push   $0x806000
  801c35:	53                   	push   %ebx
  801c36:	ff 35 04 40 80 00    	pushl  0x804004
  801c3c:	e8 61 07 00 00       	call   8023a2 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c41:	83 c4 0c             	add    $0xc,%esp
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	e8 ea 06 00 00       	call   802339 <ipc_recv>
}
  801c4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c54:	83 ec 0c             	sub    $0xc,%esp
  801c57:	6a 02                	push   $0x2
  801c59:	e8 9c 07 00 00       	call   8023fa <ipc_find_env>
  801c5e:	a3 04 40 80 00       	mov    %eax,0x804004
  801c63:	83 c4 10             	add    $0x10,%esp
  801c66:	eb c6                	jmp    801c2e <nsipc+0x12>

00801c68 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
  801c6b:	56                   	push   %esi
  801c6c:	53                   	push   %ebx
  801c6d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c70:	8b 45 08             	mov    0x8(%ebp),%eax
  801c73:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c78:	8b 06                	mov    (%esi),%eax
  801c7a:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c7f:	b8 01 00 00 00       	mov    $0x1,%eax
  801c84:	e8 93 ff ff ff       	call   801c1c <nsipc>
  801c89:	89 c3                	mov    %eax,%ebx
  801c8b:	85 c0                	test   %eax,%eax
  801c8d:	79 09                	jns    801c98 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801c8f:	89 d8                	mov    %ebx,%eax
  801c91:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c94:	5b                   	pop    %ebx
  801c95:	5e                   	pop    %esi
  801c96:	5d                   	pop    %ebp
  801c97:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c98:	83 ec 04             	sub    $0x4,%esp
  801c9b:	ff 35 10 60 80 00    	pushl  0x806010
  801ca1:	68 00 60 80 00       	push   $0x806000
  801ca6:	ff 75 0c             	pushl  0xc(%ebp)
  801ca9:	e8 47 ef ff ff       	call   800bf5 <memmove>
		*addrlen = ret->ret_addrlen;
  801cae:	a1 10 60 80 00       	mov    0x806010,%eax
  801cb3:	89 06                	mov    %eax,(%esi)
  801cb5:	83 c4 10             	add    $0x10,%esp
	return r;
  801cb8:	eb d5                	jmp    801c8f <nsipc_accept+0x27>

00801cba <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	53                   	push   %ebx
  801cbe:	83 ec 08             	sub    $0x8,%esp
  801cc1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ccc:	53                   	push   %ebx
  801ccd:	ff 75 0c             	pushl  0xc(%ebp)
  801cd0:	68 04 60 80 00       	push   $0x806004
  801cd5:	e8 1b ef ff ff       	call   800bf5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801cda:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801ce0:	b8 02 00 00 00       	mov    $0x2,%eax
  801ce5:	e8 32 ff ff ff       	call   801c1c <nsipc>
}
  801cea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d00:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801d05:	b8 03 00 00 00       	mov    $0x3,%eax
  801d0a:	e8 0d ff ff ff       	call   801c1c <nsipc>
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <nsipc_close>:

int
nsipc_close(int s)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d1f:	b8 04 00 00 00       	mov    $0x4,%eax
  801d24:	e8 f3 fe ff ff       	call   801c1c <nsipc>
}
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
  801d2e:	53                   	push   %ebx
  801d2f:	83 ec 08             	sub    $0x8,%esp
  801d32:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d3d:	53                   	push   %ebx
  801d3e:	ff 75 0c             	pushl  0xc(%ebp)
  801d41:	68 04 60 80 00       	push   $0x806004
  801d46:	e8 aa ee ff ff       	call   800bf5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d4b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d51:	b8 05 00 00 00       	mov    $0x5,%eax
  801d56:	e8 c1 fe ff ff       	call   801c1c <nsipc>
}
  801d5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d5e:	c9                   	leave  
  801d5f:	c3                   	ret    

00801d60 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
  801d63:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d66:	8b 45 08             	mov    0x8(%ebp),%eax
  801d69:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d71:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d76:	b8 06 00 00 00       	mov    $0x6,%eax
  801d7b:	e8 9c fe ff ff       	call   801c1c <nsipc>
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	56                   	push   %esi
  801d86:	53                   	push   %ebx
  801d87:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d92:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d98:	8b 45 14             	mov    0x14(%ebp),%eax
  801d9b:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801da0:	b8 07 00 00 00       	mov    $0x7,%eax
  801da5:	e8 72 fe ff ff       	call   801c1c <nsipc>
  801daa:	89 c3                	mov    %eax,%ebx
  801dac:	85 c0                	test   %eax,%eax
  801dae:	78 1f                	js     801dcf <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801db0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801db5:	7f 21                	jg     801dd8 <nsipc_recv+0x56>
  801db7:	39 c6                	cmp    %eax,%esi
  801db9:	7c 1d                	jl     801dd8 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801dbb:	83 ec 04             	sub    $0x4,%esp
  801dbe:	50                   	push   %eax
  801dbf:	68 00 60 80 00       	push   $0x806000
  801dc4:	ff 75 0c             	pushl  0xc(%ebp)
  801dc7:	e8 29 ee ff ff       	call   800bf5 <memmove>
  801dcc:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801dcf:	89 d8                	mov    %ebx,%eax
  801dd1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dd4:	5b                   	pop    %ebx
  801dd5:	5e                   	pop    %esi
  801dd6:	5d                   	pop    %ebp
  801dd7:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801dd8:	68 9f 2d 80 00       	push   $0x802d9f
  801ddd:	68 67 2d 80 00       	push   $0x802d67
  801de2:	6a 62                	push   $0x62
  801de4:	68 b4 2d 80 00       	push   $0x802db4
  801de9:	e8 24 e4 ff ff       	call   800212 <_panic>

00801dee <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
  801df1:	53                   	push   %ebx
  801df2:	83 ec 04             	sub    $0x4,%esp
  801df5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801df8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfb:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801e00:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e06:	7f 2e                	jg     801e36 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e08:	83 ec 04             	sub    $0x4,%esp
  801e0b:	53                   	push   %ebx
  801e0c:	ff 75 0c             	pushl  0xc(%ebp)
  801e0f:	68 0c 60 80 00       	push   $0x80600c
  801e14:	e8 dc ed ff ff       	call   800bf5 <memmove>
	nsipcbuf.send.req_size = size;
  801e19:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801e1f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e22:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e27:	b8 08 00 00 00       	mov    $0x8,%eax
  801e2c:	e8 eb fd ff ff       	call   801c1c <nsipc>
}
  801e31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    
	assert(size < 1600);
  801e36:	68 c0 2d 80 00       	push   $0x802dc0
  801e3b:	68 67 2d 80 00       	push   $0x802d67
  801e40:	6a 6d                	push   $0x6d
  801e42:	68 b4 2d 80 00       	push   $0x802db4
  801e47:	e8 c6 e3 ff ff       	call   800212 <_panic>

00801e4c <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
  801e4f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e52:	8b 45 08             	mov    0x8(%ebp),%eax
  801e55:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e5d:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e62:	8b 45 10             	mov    0x10(%ebp),%eax
  801e65:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e6a:	b8 09 00 00 00       	mov    $0x9,%eax
  801e6f:	e8 a8 fd ff ff       	call   801c1c <nsipc>
}
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    

00801e76 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
  801e79:	56                   	push   %esi
  801e7a:	53                   	push   %ebx
  801e7b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e7e:	83 ec 0c             	sub    $0xc,%esp
  801e81:	ff 75 08             	pushl  0x8(%ebp)
  801e84:	e8 6a f3 ff ff       	call   8011f3 <fd2data>
  801e89:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e8b:	83 c4 08             	add    $0x8,%esp
  801e8e:	68 cc 2d 80 00       	push   $0x802dcc
  801e93:	53                   	push   %ebx
  801e94:	e8 ce eb ff ff       	call   800a67 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e99:	8b 46 04             	mov    0x4(%esi),%eax
  801e9c:	2b 06                	sub    (%esi),%eax
  801e9e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ea4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801eab:	00 00 00 
	stat->st_dev = &devpipe;
  801eae:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801eb5:	30 80 00 
	return 0;
}
  801eb8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ebd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ec0:	5b                   	pop    %ebx
  801ec1:	5e                   	pop    %esi
  801ec2:	5d                   	pop    %ebp
  801ec3:	c3                   	ret    

00801ec4 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
  801ec7:	53                   	push   %ebx
  801ec8:	83 ec 0c             	sub    $0xc,%esp
  801ecb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ece:	53                   	push   %ebx
  801ecf:	6a 00                	push   $0x0
  801ed1:	e8 08 f0 ff ff       	call   800ede <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ed6:	89 1c 24             	mov    %ebx,(%esp)
  801ed9:	e8 15 f3 ff ff       	call   8011f3 <fd2data>
  801ede:	83 c4 08             	add    $0x8,%esp
  801ee1:	50                   	push   %eax
  801ee2:	6a 00                	push   $0x0
  801ee4:	e8 f5 ef ff ff       	call   800ede <sys_page_unmap>
}
  801ee9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eec:	c9                   	leave  
  801eed:	c3                   	ret    

00801eee <_pipeisclosed>:
{
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
  801ef1:	57                   	push   %edi
  801ef2:	56                   	push   %esi
  801ef3:	53                   	push   %ebx
  801ef4:	83 ec 1c             	sub    $0x1c,%esp
  801ef7:	89 c7                	mov    %eax,%edi
  801ef9:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801efb:	a1 08 40 80 00       	mov    0x804008,%eax
  801f00:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f03:	83 ec 0c             	sub    $0xc,%esp
  801f06:	57                   	push   %edi
  801f07:	e8 2d 05 00 00       	call   802439 <pageref>
  801f0c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f0f:	89 34 24             	mov    %esi,(%esp)
  801f12:	e8 22 05 00 00       	call   802439 <pageref>
		nn = thisenv->env_runs;
  801f17:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f1d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801f20:	83 c4 10             	add    $0x10,%esp
  801f23:	39 cb                	cmp    %ecx,%ebx
  801f25:	74 1b                	je     801f42 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801f27:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f2a:	75 cf                	jne    801efb <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f2c:	8b 42 58             	mov    0x58(%edx),%eax
  801f2f:	6a 01                	push   $0x1
  801f31:	50                   	push   %eax
  801f32:	53                   	push   %ebx
  801f33:	68 d3 2d 80 00       	push   $0x802dd3
  801f38:	e8 cb e3 ff ff       	call   800308 <cprintf>
  801f3d:	83 c4 10             	add    $0x10,%esp
  801f40:	eb b9                	jmp    801efb <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801f42:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f45:	0f 94 c0             	sete   %al
  801f48:	0f b6 c0             	movzbl %al,%eax
}
  801f4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f4e:	5b                   	pop    %ebx
  801f4f:	5e                   	pop    %esi
  801f50:	5f                   	pop    %edi
  801f51:	5d                   	pop    %ebp
  801f52:	c3                   	ret    

00801f53 <devpipe_write>:
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
  801f56:	57                   	push   %edi
  801f57:	56                   	push   %esi
  801f58:	53                   	push   %ebx
  801f59:	83 ec 28             	sub    $0x28,%esp
  801f5c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f5f:	56                   	push   %esi
  801f60:	e8 8e f2 ff ff       	call   8011f3 <fd2data>
  801f65:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f67:	83 c4 10             	add    $0x10,%esp
  801f6a:	bf 00 00 00 00       	mov    $0x0,%edi
  801f6f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f72:	74 4f                	je     801fc3 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f74:	8b 43 04             	mov    0x4(%ebx),%eax
  801f77:	8b 0b                	mov    (%ebx),%ecx
  801f79:	8d 51 20             	lea    0x20(%ecx),%edx
  801f7c:	39 d0                	cmp    %edx,%eax
  801f7e:	72 14                	jb     801f94 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801f80:	89 da                	mov    %ebx,%edx
  801f82:	89 f0                	mov    %esi,%eax
  801f84:	e8 65 ff ff ff       	call   801eee <_pipeisclosed>
  801f89:	85 c0                	test   %eax,%eax
  801f8b:	75 3b                	jne    801fc8 <devpipe_write+0x75>
			sys_yield();
  801f8d:	e8 a8 ee ff ff       	call   800e3a <sys_yield>
  801f92:	eb e0                	jmp    801f74 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f97:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f9b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f9e:	89 c2                	mov    %eax,%edx
  801fa0:	c1 fa 1f             	sar    $0x1f,%edx
  801fa3:	89 d1                	mov    %edx,%ecx
  801fa5:	c1 e9 1b             	shr    $0x1b,%ecx
  801fa8:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801fab:	83 e2 1f             	and    $0x1f,%edx
  801fae:	29 ca                	sub    %ecx,%edx
  801fb0:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801fb4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801fb8:	83 c0 01             	add    $0x1,%eax
  801fbb:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801fbe:	83 c7 01             	add    $0x1,%edi
  801fc1:	eb ac                	jmp    801f6f <devpipe_write+0x1c>
	return i;
  801fc3:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc6:	eb 05                	jmp    801fcd <devpipe_write+0x7a>
				return 0;
  801fc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fd0:	5b                   	pop    %ebx
  801fd1:	5e                   	pop    %esi
  801fd2:	5f                   	pop    %edi
  801fd3:	5d                   	pop    %ebp
  801fd4:	c3                   	ret    

00801fd5 <devpipe_read>:
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
  801fd8:	57                   	push   %edi
  801fd9:	56                   	push   %esi
  801fda:	53                   	push   %ebx
  801fdb:	83 ec 18             	sub    $0x18,%esp
  801fde:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801fe1:	57                   	push   %edi
  801fe2:	e8 0c f2 ff ff       	call   8011f3 <fd2data>
  801fe7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801fe9:	83 c4 10             	add    $0x10,%esp
  801fec:	be 00 00 00 00       	mov    $0x0,%esi
  801ff1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ff4:	75 14                	jne    80200a <devpipe_read+0x35>
	return i;
  801ff6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ff9:	eb 02                	jmp    801ffd <devpipe_read+0x28>
				return i;
  801ffb:	89 f0                	mov    %esi,%eax
}
  801ffd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802000:	5b                   	pop    %ebx
  802001:	5e                   	pop    %esi
  802002:	5f                   	pop    %edi
  802003:	5d                   	pop    %ebp
  802004:	c3                   	ret    
			sys_yield();
  802005:	e8 30 ee ff ff       	call   800e3a <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80200a:	8b 03                	mov    (%ebx),%eax
  80200c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80200f:	75 18                	jne    802029 <devpipe_read+0x54>
			if (i > 0)
  802011:	85 f6                	test   %esi,%esi
  802013:	75 e6                	jne    801ffb <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802015:	89 da                	mov    %ebx,%edx
  802017:	89 f8                	mov    %edi,%eax
  802019:	e8 d0 fe ff ff       	call   801eee <_pipeisclosed>
  80201e:	85 c0                	test   %eax,%eax
  802020:	74 e3                	je     802005 <devpipe_read+0x30>
				return 0;
  802022:	b8 00 00 00 00       	mov    $0x0,%eax
  802027:	eb d4                	jmp    801ffd <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802029:	99                   	cltd   
  80202a:	c1 ea 1b             	shr    $0x1b,%edx
  80202d:	01 d0                	add    %edx,%eax
  80202f:	83 e0 1f             	and    $0x1f,%eax
  802032:	29 d0                	sub    %edx,%eax
  802034:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802039:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80203c:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80203f:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802042:	83 c6 01             	add    $0x1,%esi
  802045:	eb aa                	jmp    801ff1 <devpipe_read+0x1c>

00802047 <pipe>:
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
  80204a:	56                   	push   %esi
  80204b:	53                   	push   %ebx
  80204c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80204f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802052:	50                   	push   %eax
  802053:	e8 b2 f1 ff ff       	call   80120a <fd_alloc>
  802058:	89 c3                	mov    %eax,%ebx
  80205a:	83 c4 10             	add    $0x10,%esp
  80205d:	85 c0                	test   %eax,%eax
  80205f:	0f 88 23 01 00 00    	js     802188 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802065:	83 ec 04             	sub    $0x4,%esp
  802068:	68 07 04 00 00       	push   $0x407
  80206d:	ff 75 f4             	pushl  -0xc(%ebp)
  802070:	6a 00                	push   $0x0
  802072:	e8 e2 ed ff ff       	call   800e59 <sys_page_alloc>
  802077:	89 c3                	mov    %eax,%ebx
  802079:	83 c4 10             	add    $0x10,%esp
  80207c:	85 c0                	test   %eax,%eax
  80207e:	0f 88 04 01 00 00    	js     802188 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802084:	83 ec 0c             	sub    $0xc,%esp
  802087:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80208a:	50                   	push   %eax
  80208b:	e8 7a f1 ff ff       	call   80120a <fd_alloc>
  802090:	89 c3                	mov    %eax,%ebx
  802092:	83 c4 10             	add    $0x10,%esp
  802095:	85 c0                	test   %eax,%eax
  802097:	0f 88 db 00 00 00    	js     802178 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80209d:	83 ec 04             	sub    $0x4,%esp
  8020a0:	68 07 04 00 00       	push   $0x407
  8020a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8020a8:	6a 00                	push   $0x0
  8020aa:	e8 aa ed ff ff       	call   800e59 <sys_page_alloc>
  8020af:	89 c3                	mov    %eax,%ebx
  8020b1:	83 c4 10             	add    $0x10,%esp
  8020b4:	85 c0                	test   %eax,%eax
  8020b6:	0f 88 bc 00 00 00    	js     802178 <pipe+0x131>
	va = fd2data(fd0);
  8020bc:	83 ec 0c             	sub    $0xc,%esp
  8020bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8020c2:	e8 2c f1 ff ff       	call   8011f3 <fd2data>
  8020c7:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020c9:	83 c4 0c             	add    $0xc,%esp
  8020cc:	68 07 04 00 00       	push   $0x407
  8020d1:	50                   	push   %eax
  8020d2:	6a 00                	push   $0x0
  8020d4:	e8 80 ed ff ff       	call   800e59 <sys_page_alloc>
  8020d9:	89 c3                	mov    %eax,%ebx
  8020db:	83 c4 10             	add    $0x10,%esp
  8020de:	85 c0                	test   %eax,%eax
  8020e0:	0f 88 82 00 00 00    	js     802168 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020e6:	83 ec 0c             	sub    $0xc,%esp
  8020e9:	ff 75 f0             	pushl  -0x10(%ebp)
  8020ec:	e8 02 f1 ff ff       	call   8011f3 <fd2data>
  8020f1:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8020f8:	50                   	push   %eax
  8020f9:	6a 00                	push   $0x0
  8020fb:	56                   	push   %esi
  8020fc:	6a 00                	push   $0x0
  8020fe:	e8 99 ed ff ff       	call   800e9c <sys_page_map>
  802103:	89 c3                	mov    %eax,%ebx
  802105:	83 c4 20             	add    $0x20,%esp
  802108:	85 c0                	test   %eax,%eax
  80210a:	78 4e                	js     80215a <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  80210c:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802111:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802114:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802116:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802119:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802120:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802123:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802125:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802128:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80212f:	83 ec 0c             	sub    $0xc,%esp
  802132:	ff 75 f4             	pushl  -0xc(%ebp)
  802135:	e8 a9 f0 ff ff       	call   8011e3 <fd2num>
  80213a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80213d:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80213f:	83 c4 04             	add    $0x4,%esp
  802142:	ff 75 f0             	pushl  -0x10(%ebp)
  802145:	e8 99 f0 ff ff       	call   8011e3 <fd2num>
  80214a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80214d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802150:	83 c4 10             	add    $0x10,%esp
  802153:	bb 00 00 00 00       	mov    $0x0,%ebx
  802158:	eb 2e                	jmp    802188 <pipe+0x141>
	sys_page_unmap(0, va);
  80215a:	83 ec 08             	sub    $0x8,%esp
  80215d:	56                   	push   %esi
  80215e:	6a 00                	push   $0x0
  802160:	e8 79 ed ff ff       	call   800ede <sys_page_unmap>
  802165:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802168:	83 ec 08             	sub    $0x8,%esp
  80216b:	ff 75 f0             	pushl  -0x10(%ebp)
  80216e:	6a 00                	push   $0x0
  802170:	e8 69 ed ff ff       	call   800ede <sys_page_unmap>
  802175:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802178:	83 ec 08             	sub    $0x8,%esp
  80217b:	ff 75 f4             	pushl  -0xc(%ebp)
  80217e:	6a 00                	push   $0x0
  802180:	e8 59 ed ff ff       	call   800ede <sys_page_unmap>
  802185:	83 c4 10             	add    $0x10,%esp
}
  802188:	89 d8                	mov    %ebx,%eax
  80218a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80218d:	5b                   	pop    %ebx
  80218e:	5e                   	pop    %esi
  80218f:	5d                   	pop    %ebp
  802190:	c3                   	ret    

00802191 <pipeisclosed>:
{
  802191:	55                   	push   %ebp
  802192:	89 e5                	mov    %esp,%ebp
  802194:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802197:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80219a:	50                   	push   %eax
  80219b:	ff 75 08             	pushl  0x8(%ebp)
  80219e:	e8 b9 f0 ff ff       	call   80125c <fd_lookup>
  8021a3:	83 c4 10             	add    $0x10,%esp
  8021a6:	85 c0                	test   %eax,%eax
  8021a8:	78 18                	js     8021c2 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8021aa:	83 ec 0c             	sub    $0xc,%esp
  8021ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8021b0:	e8 3e f0 ff ff       	call   8011f3 <fd2data>
	return _pipeisclosed(fd, p);
  8021b5:	89 c2                	mov    %eax,%edx
  8021b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ba:	e8 2f fd ff ff       	call   801eee <_pipeisclosed>
  8021bf:	83 c4 10             	add    $0x10,%esp
}
  8021c2:	c9                   	leave  
  8021c3:	c3                   	ret    

008021c4 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8021c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c9:	c3                   	ret    

008021ca <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
  8021cd:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8021d0:	68 eb 2d 80 00       	push   $0x802deb
  8021d5:	ff 75 0c             	pushl  0xc(%ebp)
  8021d8:	e8 8a e8 ff ff       	call   800a67 <strcpy>
	return 0;
}
  8021dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e2:	c9                   	leave  
  8021e3:	c3                   	ret    

008021e4 <devcons_write>:
{
  8021e4:	55                   	push   %ebp
  8021e5:	89 e5                	mov    %esp,%ebp
  8021e7:	57                   	push   %edi
  8021e8:	56                   	push   %esi
  8021e9:	53                   	push   %ebx
  8021ea:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8021f0:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8021f5:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8021fb:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021fe:	73 31                	jae    802231 <devcons_write+0x4d>
		m = n - tot;
  802200:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802203:	29 f3                	sub    %esi,%ebx
  802205:	83 fb 7f             	cmp    $0x7f,%ebx
  802208:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80220d:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802210:	83 ec 04             	sub    $0x4,%esp
  802213:	53                   	push   %ebx
  802214:	89 f0                	mov    %esi,%eax
  802216:	03 45 0c             	add    0xc(%ebp),%eax
  802219:	50                   	push   %eax
  80221a:	57                   	push   %edi
  80221b:	e8 d5 e9 ff ff       	call   800bf5 <memmove>
		sys_cputs(buf, m);
  802220:	83 c4 08             	add    $0x8,%esp
  802223:	53                   	push   %ebx
  802224:	57                   	push   %edi
  802225:	e8 73 eb ff ff       	call   800d9d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80222a:	01 de                	add    %ebx,%esi
  80222c:	83 c4 10             	add    $0x10,%esp
  80222f:	eb ca                	jmp    8021fb <devcons_write+0x17>
}
  802231:	89 f0                	mov    %esi,%eax
  802233:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802236:	5b                   	pop    %ebx
  802237:	5e                   	pop    %esi
  802238:	5f                   	pop    %edi
  802239:	5d                   	pop    %ebp
  80223a:	c3                   	ret    

0080223b <devcons_read>:
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
  80223e:	83 ec 08             	sub    $0x8,%esp
  802241:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802246:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80224a:	74 21                	je     80226d <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80224c:	e8 6a eb ff ff       	call   800dbb <sys_cgetc>
  802251:	85 c0                	test   %eax,%eax
  802253:	75 07                	jne    80225c <devcons_read+0x21>
		sys_yield();
  802255:	e8 e0 eb ff ff       	call   800e3a <sys_yield>
  80225a:	eb f0                	jmp    80224c <devcons_read+0x11>
	if (c < 0)
  80225c:	78 0f                	js     80226d <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80225e:	83 f8 04             	cmp    $0x4,%eax
  802261:	74 0c                	je     80226f <devcons_read+0x34>
	*(char*)vbuf = c;
  802263:	8b 55 0c             	mov    0xc(%ebp),%edx
  802266:	88 02                	mov    %al,(%edx)
	return 1;
  802268:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80226d:	c9                   	leave  
  80226e:	c3                   	ret    
		return 0;
  80226f:	b8 00 00 00 00       	mov    $0x0,%eax
  802274:	eb f7                	jmp    80226d <devcons_read+0x32>

00802276 <cputchar>:
{
  802276:	55                   	push   %ebp
  802277:	89 e5                	mov    %esp,%ebp
  802279:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80227c:	8b 45 08             	mov    0x8(%ebp),%eax
  80227f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802282:	6a 01                	push   $0x1
  802284:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802287:	50                   	push   %eax
  802288:	e8 10 eb ff ff       	call   800d9d <sys_cputs>
}
  80228d:	83 c4 10             	add    $0x10,%esp
  802290:	c9                   	leave  
  802291:	c3                   	ret    

00802292 <getchar>:
{
  802292:	55                   	push   %ebp
  802293:	89 e5                	mov    %esp,%ebp
  802295:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802298:	6a 01                	push   $0x1
  80229a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80229d:	50                   	push   %eax
  80229e:	6a 00                	push   $0x0
  8022a0:	e8 27 f2 ff ff       	call   8014cc <read>
	if (r < 0)
  8022a5:	83 c4 10             	add    $0x10,%esp
  8022a8:	85 c0                	test   %eax,%eax
  8022aa:	78 06                	js     8022b2 <getchar+0x20>
	if (r < 1)
  8022ac:	74 06                	je     8022b4 <getchar+0x22>
	return c;
  8022ae:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8022b2:	c9                   	leave  
  8022b3:	c3                   	ret    
		return -E_EOF;
  8022b4:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8022b9:	eb f7                	jmp    8022b2 <getchar+0x20>

008022bb <iscons>:
{
  8022bb:	55                   	push   %ebp
  8022bc:	89 e5                	mov    %esp,%ebp
  8022be:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022c4:	50                   	push   %eax
  8022c5:	ff 75 08             	pushl  0x8(%ebp)
  8022c8:	e8 8f ef ff ff       	call   80125c <fd_lookup>
  8022cd:	83 c4 10             	add    $0x10,%esp
  8022d0:	85 c0                	test   %eax,%eax
  8022d2:	78 11                	js     8022e5 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8022d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d7:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022dd:	39 10                	cmp    %edx,(%eax)
  8022df:	0f 94 c0             	sete   %al
  8022e2:	0f b6 c0             	movzbl %al,%eax
}
  8022e5:	c9                   	leave  
  8022e6:	c3                   	ret    

008022e7 <opencons>:
{
  8022e7:	55                   	push   %ebp
  8022e8:	89 e5                	mov    %esp,%ebp
  8022ea:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8022ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022f0:	50                   	push   %eax
  8022f1:	e8 14 ef ff ff       	call   80120a <fd_alloc>
  8022f6:	83 c4 10             	add    $0x10,%esp
  8022f9:	85 c0                	test   %eax,%eax
  8022fb:	78 3a                	js     802337 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022fd:	83 ec 04             	sub    $0x4,%esp
  802300:	68 07 04 00 00       	push   $0x407
  802305:	ff 75 f4             	pushl  -0xc(%ebp)
  802308:	6a 00                	push   $0x0
  80230a:	e8 4a eb ff ff       	call   800e59 <sys_page_alloc>
  80230f:	83 c4 10             	add    $0x10,%esp
  802312:	85 c0                	test   %eax,%eax
  802314:	78 21                	js     802337 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802319:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80231f:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802324:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80232b:	83 ec 0c             	sub    $0xc,%esp
  80232e:	50                   	push   %eax
  80232f:	e8 af ee ff ff       	call   8011e3 <fd2num>
  802334:	83 c4 10             	add    $0x10,%esp
}
  802337:	c9                   	leave  
  802338:	c3                   	ret    

00802339 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802339:	55                   	push   %ebp
  80233a:	89 e5                	mov    %esp,%ebp
  80233c:	56                   	push   %esi
  80233d:	53                   	push   %ebx
  80233e:	8b 75 08             	mov    0x8(%ebp),%esi
  802341:	8b 45 0c             	mov    0xc(%ebp),%eax
  802344:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802347:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802349:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80234e:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802351:	83 ec 0c             	sub    $0xc,%esp
  802354:	50                   	push   %eax
  802355:	e8 af ec ff ff       	call   801009 <sys_ipc_recv>
	if(ret < 0){
  80235a:	83 c4 10             	add    $0x10,%esp
  80235d:	85 c0                	test   %eax,%eax
  80235f:	78 2b                	js     80238c <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802361:	85 f6                	test   %esi,%esi
  802363:	74 0a                	je     80236f <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802365:	a1 08 40 80 00       	mov    0x804008,%eax
  80236a:	8b 40 78             	mov    0x78(%eax),%eax
  80236d:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80236f:	85 db                	test   %ebx,%ebx
  802371:	74 0a                	je     80237d <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802373:	a1 08 40 80 00       	mov    0x804008,%eax
  802378:	8b 40 7c             	mov    0x7c(%eax),%eax
  80237b:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80237d:	a1 08 40 80 00       	mov    0x804008,%eax
  802382:	8b 40 74             	mov    0x74(%eax),%eax
}
  802385:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802388:	5b                   	pop    %ebx
  802389:	5e                   	pop    %esi
  80238a:	5d                   	pop    %ebp
  80238b:	c3                   	ret    
		if(from_env_store)
  80238c:	85 f6                	test   %esi,%esi
  80238e:	74 06                	je     802396 <ipc_recv+0x5d>
			*from_env_store = 0;
  802390:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802396:	85 db                	test   %ebx,%ebx
  802398:	74 eb                	je     802385 <ipc_recv+0x4c>
			*perm_store = 0;
  80239a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8023a0:	eb e3                	jmp    802385 <ipc_recv+0x4c>

008023a2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8023a2:	55                   	push   %ebp
  8023a3:	89 e5                	mov    %esp,%ebp
  8023a5:	57                   	push   %edi
  8023a6:	56                   	push   %esi
  8023a7:	53                   	push   %ebx
  8023a8:	83 ec 0c             	sub    $0xc,%esp
  8023ab:	8b 7d 08             	mov    0x8(%ebp),%edi
  8023ae:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8023b4:	85 db                	test   %ebx,%ebx
  8023b6:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8023bb:	0f 44 d8             	cmove  %eax,%ebx
  8023be:	eb 05                	jmp    8023c5 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8023c0:	e8 75 ea ff ff       	call   800e3a <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8023c5:	ff 75 14             	pushl  0x14(%ebp)
  8023c8:	53                   	push   %ebx
  8023c9:	56                   	push   %esi
  8023ca:	57                   	push   %edi
  8023cb:	e8 16 ec ff ff       	call   800fe6 <sys_ipc_try_send>
  8023d0:	83 c4 10             	add    $0x10,%esp
  8023d3:	85 c0                	test   %eax,%eax
  8023d5:	74 1b                	je     8023f2 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8023d7:	79 e7                	jns    8023c0 <ipc_send+0x1e>
  8023d9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8023dc:	74 e2                	je     8023c0 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8023de:	83 ec 04             	sub    $0x4,%esp
  8023e1:	68 f7 2d 80 00       	push   $0x802df7
  8023e6:	6a 46                	push   $0x46
  8023e8:	68 0c 2e 80 00       	push   $0x802e0c
  8023ed:	e8 20 de ff ff       	call   800212 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8023f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023f5:	5b                   	pop    %ebx
  8023f6:	5e                   	pop    %esi
  8023f7:	5f                   	pop    %edi
  8023f8:	5d                   	pop    %ebp
  8023f9:	c3                   	ret    

008023fa <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
  8023fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802400:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802405:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  80240b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802411:	8b 52 50             	mov    0x50(%edx),%edx
  802414:	39 ca                	cmp    %ecx,%edx
  802416:	74 11                	je     802429 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802418:	83 c0 01             	add    $0x1,%eax
  80241b:	3d 00 04 00 00       	cmp    $0x400,%eax
  802420:	75 e3                	jne    802405 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802422:	b8 00 00 00 00       	mov    $0x0,%eax
  802427:	eb 0e                	jmp    802437 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802429:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80242f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802434:	8b 40 48             	mov    0x48(%eax),%eax
}
  802437:	5d                   	pop    %ebp
  802438:	c3                   	ret    

00802439 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802439:	55                   	push   %ebp
  80243a:	89 e5                	mov    %esp,%ebp
  80243c:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80243f:	89 d0                	mov    %edx,%eax
  802441:	c1 e8 16             	shr    $0x16,%eax
  802444:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80244b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802450:	f6 c1 01             	test   $0x1,%cl
  802453:	74 1d                	je     802472 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802455:	c1 ea 0c             	shr    $0xc,%edx
  802458:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80245f:	f6 c2 01             	test   $0x1,%dl
  802462:	74 0e                	je     802472 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802464:	c1 ea 0c             	shr    $0xc,%edx
  802467:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80246e:	ef 
  80246f:	0f b7 c0             	movzwl %ax,%eax
}
  802472:	5d                   	pop    %ebp
  802473:	c3                   	ret    
  802474:	66 90                	xchg   %ax,%ax
  802476:	66 90                	xchg   %ax,%ax
  802478:	66 90                	xchg   %ax,%ax
  80247a:	66 90                	xchg   %ax,%ax
  80247c:	66 90                	xchg   %ax,%ax
  80247e:	66 90                	xchg   %ax,%ax

00802480 <__udivdi3>:
  802480:	55                   	push   %ebp
  802481:	57                   	push   %edi
  802482:	56                   	push   %esi
  802483:	53                   	push   %ebx
  802484:	83 ec 1c             	sub    $0x1c,%esp
  802487:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80248b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80248f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802493:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802497:	85 d2                	test   %edx,%edx
  802499:	75 4d                	jne    8024e8 <__udivdi3+0x68>
  80249b:	39 f3                	cmp    %esi,%ebx
  80249d:	76 19                	jbe    8024b8 <__udivdi3+0x38>
  80249f:	31 ff                	xor    %edi,%edi
  8024a1:	89 e8                	mov    %ebp,%eax
  8024a3:	89 f2                	mov    %esi,%edx
  8024a5:	f7 f3                	div    %ebx
  8024a7:	89 fa                	mov    %edi,%edx
  8024a9:	83 c4 1c             	add    $0x1c,%esp
  8024ac:	5b                   	pop    %ebx
  8024ad:	5e                   	pop    %esi
  8024ae:	5f                   	pop    %edi
  8024af:	5d                   	pop    %ebp
  8024b0:	c3                   	ret    
  8024b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024b8:	89 d9                	mov    %ebx,%ecx
  8024ba:	85 db                	test   %ebx,%ebx
  8024bc:	75 0b                	jne    8024c9 <__udivdi3+0x49>
  8024be:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c3:	31 d2                	xor    %edx,%edx
  8024c5:	f7 f3                	div    %ebx
  8024c7:	89 c1                	mov    %eax,%ecx
  8024c9:	31 d2                	xor    %edx,%edx
  8024cb:	89 f0                	mov    %esi,%eax
  8024cd:	f7 f1                	div    %ecx
  8024cf:	89 c6                	mov    %eax,%esi
  8024d1:	89 e8                	mov    %ebp,%eax
  8024d3:	89 f7                	mov    %esi,%edi
  8024d5:	f7 f1                	div    %ecx
  8024d7:	89 fa                	mov    %edi,%edx
  8024d9:	83 c4 1c             	add    $0x1c,%esp
  8024dc:	5b                   	pop    %ebx
  8024dd:	5e                   	pop    %esi
  8024de:	5f                   	pop    %edi
  8024df:	5d                   	pop    %ebp
  8024e0:	c3                   	ret    
  8024e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024e8:	39 f2                	cmp    %esi,%edx
  8024ea:	77 1c                	ja     802508 <__udivdi3+0x88>
  8024ec:	0f bd fa             	bsr    %edx,%edi
  8024ef:	83 f7 1f             	xor    $0x1f,%edi
  8024f2:	75 2c                	jne    802520 <__udivdi3+0xa0>
  8024f4:	39 f2                	cmp    %esi,%edx
  8024f6:	72 06                	jb     8024fe <__udivdi3+0x7e>
  8024f8:	31 c0                	xor    %eax,%eax
  8024fa:	39 eb                	cmp    %ebp,%ebx
  8024fc:	77 a9                	ja     8024a7 <__udivdi3+0x27>
  8024fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802503:	eb a2                	jmp    8024a7 <__udivdi3+0x27>
  802505:	8d 76 00             	lea    0x0(%esi),%esi
  802508:	31 ff                	xor    %edi,%edi
  80250a:	31 c0                	xor    %eax,%eax
  80250c:	89 fa                	mov    %edi,%edx
  80250e:	83 c4 1c             	add    $0x1c,%esp
  802511:	5b                   	pop    %ebx
  802512:	5e                   	pop    %esi
  802513:	5f                   	pop    %edi
  802514:	5d                   	pop    %ebp
  802515:	c3                   	ret    
  802516:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80251d:	8d 76 00             	lea    0x0(%esi),%esi
  802520:	89 f9                	mov    %edi,%ecx
  802522:	b8 20 00 00 00       	mov    $0x20,%eax
  802527:	29 f8                	sub    %edi,%eax
  802529:	d3 e2                	shl    %cl,%edx
  80252b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80252f:	89 c1                	mov    %eax,%ecx
  802531:	89 da                	mov    %ebx,%edx
  802533:	d3 ea                	shr    %cl,%edx
  802535:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802539:	09 d1                	or     %edx,%ecx
  80253b:	89 f2                	mov    %esi,%edx
  80253d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802541:	89 f9                	mov    %edi,%ecx
  802543:	d3 e3                	shl    %cl,%ebx
  802545:	89 c1                	mov    %eax,%ecx
  802547:	d3 ea                	shr    %cl,%edx
  802549:	89 f9                	mov    %edi,%ecx
  80254b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80254f:	89 eb                	mov    %ebp,%ebx
  802551:	d3 e6                	shl    %cl,%esi
  802553:	89 c1                	mov    %eax,%ecx
  802555:	d3 eb                	shr    %cl,%ebx
  802557:	09 de                	or     %ebx,%esi
  802559:	89 f0                	mov    %esi,%eax
  80255b:	f7 74 24 08          	divl   0x8(%esp)
  80255f:	89 d6                	mov    %edx,%esi
  802561:	89 c3                	mov    %eax,%ebx
  802563:	f7 64 24 0c          	mull   0xc(%esp)
  802567:	39 d6                	cmp    %edx,%esi
  802569:	72 15                	jb     802580 <__udivdi3+0x100>
  80256b:	89 f9                	mov    %edi,%ecx
  80256d:	d3 e5                	shl    %cl,%ebp
  80256f:	39 c5                	cmp    %eax,%ebp
  802571:	73 04                	jae    802577 <__udivdi3+0xf7>
  802573:	39 d6                	cmp    %edx,%esi
  802575:	74 09                	je     802580 <__udivdi3+0x100>
  802577:	89 d8                	mov    %ebx,%eax
  802579:	31 ff                	xor    %edi,%edi
  80257b:	e9 27 ff ff ff       	jmp    8024a7 <__udivdi3+0x27>
  802580:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802583:	31 ff                	xor    %edi,%edi
  802585:	e9 1d ff ff ff       	jmp    8024a7 <__udivdi3+0x27>
  80258a:	66 90                	xchg   %ax,%ax
  80258c:	66 90                	xchg   %ax,%ax
  80258e:	66 90                	xchg   %ax,%ax

00802590 <__umoddi3>:
  802590:	55                   	push   %ebp
  802591:	57                   	push   %edi
  802592:	56                   	push   %esi
  802593:	53                   	push   %ebx
  802594:	83 ec 1c             	sub    $0x1c,%esp
  802597:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80259b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80259f:	8b 74 24 30          	mov    0x30(%esp),%esi
  8025a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8025a7:	89 da                	mov    %ebx,%edx
  8025a9:	85 c0                	test   %eax,%eax
  8025ab:	75 43                	jne    8025f0 <__umoddi3+0x60>
  8025ad:	39 df                	cmp    %ebx,%edi
  8025af:	76 17                	jbe    8025c8 <__umoddi3+0x38>
  8025b1:	89 f0                	mov    %esi,%eax
  8025b3:	f7 f7                	div    %edi
  8025b5:	89 d0                	mov    %edx,%eax
  8025b7:	31 d2                	xor    %edx,%edx
  8025b9:	83 c4 1c             	add    $0x1c,%esp
  8025bc:	5b                   	pop    %ebx
  8025bd:	5e                   	pop    %esi
  8025be:	5f                   	pop    %edi
  8025bf:	5d                   	pop    %ebp
  8025c0:	c3                   	ret    
  8025c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025c8:	89 fd                	mov    %edi,%ebp
  8025ca:	85 ff                	test   %edi,%edi
  8025cc:	75 0b                	jne    8025d9 <__umoddi3+0x49>
  8025ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8025d3:	31 d2                	xor    %edx,%edx
  8025d5:	f7 f7                	div    %edi
  8025d7:	89 c5                	mov    %eax,%ebp
  8025d9:	89 d8                	mov    %ebx,%eax
  8025db:	31 d2                	xor    %edx,%edx
  8025dd:	f7 f5                	div    %ebp
  8025df:	89 f0                	mov    %esi,%eax
  8025e1:	f7 f5                	div    %ebp
  8025e3:	89 d0                	mov    %edx,%eax
  8025e5:	eb d0                	jmp    8025b7 <__umoddi3+0x27>
  8025e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025ee:	66 90                	xchg   %ax,%ax
  8025f0:	89 f1                	mov    %esi,%ecx
  8025f2:	39 d8                	cmp    %ebx,%eax
  8025f4:	76 0a                	jbe    802600 <__umoddi3+0x70>
  8025f6:	89 f0                	mov    %esi,%eax
  8025f8:	83 c4 1c             	add    $0x1c,%esp
  8025fb:	5b                   	pop    %ebx
  8025fc:	5e                   	pop    %esi
  8025fd:	5f                   	pop    %edi
  8025fe:	5d                   	pop    %ebp
  8025ff:	c3                   	ret    
  802600:	0f bd e8             	bsr    %eax,%ebp
  802603:	83 f5 1f             	xor    $0x1f,%ebp
  802606:	75 20                	jne    802628 <__umoddi3+0x98>
  802608:	39 d8                	cmp    %ebx,%eax
  80260a:	0f 82 b0 00 00 00    	jb     8026c0 <__umoddi3+0x130>
  802610:	39 f7                	cmp    %esi,%edi
  802612:	0f 86 a8 00 00 00    	jbe    8026c0 <__umoddi3+0x130>
  802618:	89 c8                	mov    %ecx,%eax
  80261a:	83 c4 1c             	add    $0x1c,%esp
  80261d:	5b                   	pop    %ebx
  80261e:	5e                   	pop    %esi
  80261f:	5f                   	pop    %edi
  802620:	5d                   	pop    %ebp
  802621:	c3                   	ret    
  802622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802628:	89 e9                	mov    %ebp,%ecx
  80262a:	ba 20 00 00 00       	mov    $0x20,%edx
  80262f:	29 ea                	sub    %ebp,%edx
  802631:	d3 e0                	shl    %cl,%eax
  802633:	89 44 24 08          	mov    %eax,0x8(%esp)
  802637:	89 d1                	mov    %edx,%ecx
  802639:	89 f8                	mov    %edi,%eax
  80263b:	d3 e8                	shr    %cl,%eax
  80263d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802641:	89 54 24 04          	mov    %edx,0x4(%esp)
  802645:	8b 54 24 04          	mov    0x4(%esp),%edx
  802649:	09 c1                	or     %eax,%ecx
  80264b:	89 d8                	mov    %ebx,%eax
  80264d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802651:	89 e9                	mov    %ebp,%ecx
  802653:	d3 e7                	shl    %cl,%edi
  802655:	89 d1                	mov    %edx,%ecx
  802657:	d3 e8                	shr    %cl,%eax
  802659:	89 e9                	mov    %ebp,%ecx
  80265b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80265f:	d3 e3                	shl    %cl,%ebx
  802661:	89 c7                	mov    %eax,%edi
  802663:	89 d1                	mov    %edx,%ecx
  802665:	89 f0                	mov    %esi,%eax
  802667:	d3 e8                	shr    %cl,%eax
  802669:	89 e9                	mov    %ebp,%ecx
  80266b:	89 fa                	mov    %edi,%edx
  80266d:	d3 e6                	shl    %cl,%esi
  80266f:	09 d8                	or     %ebx,%eax
  802671:	f7 74 24 08          	divl   0x8(%esp)
  802675:	89 d1                	mov    %edx,%ecx
  802677:	89 f3                	mov    %esi,%ebx
  802679:	f7 64 24 0c          	mull   0xc(%esp)
  80267d:	89 c6                	mov    %eax,%esi
  80267f:	89 d7                	mov    %edx,%edi
  802681:	39 d1                	cmp    %edx,%ecx
  802683:	72 06                	jb     80268b <__umoddi3+0xfb>
  802685:	75 10                	jne    802697 <__umoddi3+0x107>
  802687:	39 c3                	cmp    %eax,%ebx
  802689:	73 0c                	jae    802697 <__umoddi3+0x107>
  80268b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80268f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802693:	89 d7                	mov    %edx,%edi
  802695:	89 c6                	mov    %eax,%esi
  802697:	89 ca                	mov    %ecx,%edx
  802699:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80269e:	29 f3                	sub    %esi,%ebx
  8026a0:	19 fa                	sbb    %edi,%edx
  8026a2:	89 d0                	mov    %edx,%eax
  8026a4:	d3 e0                	shl    %cl,%eax
  8026a6:	89 e9                	mov    %ebp,%ecx
  8026a8:	d3 eb                	shr    %cl,%ebx
  8026aa:	d3 ea                	shr    %cl,%edx
  8026ac:	09 d8                	or     %ebx,%eax
  8026ae:	83 c4 1c             	add    $0x1c,%esp
  8026b1:	5b                   	pop    %ebx
  8026b2:	5e                   	pop    %esi
  8026b3:	5f                   	pop    %edi
  8026b4:	5d                   	pop    %ebp
  8026b5:	c3                   	ret    
  8026b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026bd:	8d 76 00             	lea    0x0(%esi),%esi
  8026c0:	89 da                	mov    %ebx,%edx
  8026c2:	29 fe                	sub    %edi,%esi
  8026c4:	19 c2                	sbb    %eax,%edx
  8026c6:	89 f1                	mov    %esi,%ecx
  8026c8:	89 c8                	mov    %ecx,%eax
  8026ca:	e9 4b ff ff ff       	jmp    80261a <__umoddi3+0x8a>
