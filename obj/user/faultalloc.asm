
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
  800040:	68 80 26 80 00       	push   $0x802680
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
  800066:	68 c8 26 80 00       	push   $0x8026c8
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
  800080:	68 9c 26 80 00       	push   $0x80269c
  800085:	6a 0e                	push   $0xe
  800087:	68 8a 26 80 00       	push   $0x80268a
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
  80009c:	e8 52 10 00 00       	call   8010f3 <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	68 ef be ad de       	push   $0xdeadbeef
  8000a9:	68 48 27 80 00       	push   $0x802748
  8000ae:	e8 1a 02 00 00       	call   8002cd <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000b3:	83 c4 08             	add    $0x8,%esp
  8000b6:	68 fe bf fe ca       	push   $0xcafebffe
  8000bb:	68 48 27 80 00       	push   $0x802748
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
  80014d:	68 e9 26 80 00       	push   $0x8026e9
  800152:	e8 76 01 00 00       	call   8002cd <cprintf>
	cprintf("before umain\n");
  800157:	c7 04 24 07 27 80 00 	movl   $0x802707,(%esp)
  80015e:	e8 6a 01 00 00       	call   8002cd <cprintf>
	// call user main routine
	umain(argc, argv);
  800163:	83 c4 08             	add    $0x8,%esp
  800166:	ff 75 0c             	pushl  0xc(%ebp)
  800169:	ff 75 08             	pushl  0x8(%ebp)
  80016c:	e8 20 ff ff ff       	call   800091 <umain>
	cprintf("after umain\n");
  800171:	c7 04 24 15 27 80 00 	movl   $0x802715,(%esp)
  800178:	e8 50 01 00 00       	call   8002cd <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80017d:	a1 08 40 80 00       	mov    0x804008,%eax
  800182:	8b 40 48             	mov    0x48(%eax),%eax
  800185:	83 c4 08             	add    $0x8,%esp
  800188:	50                   	push   %eax
  800189:	68 22 27 80 00       	push   $0x802722
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
  8001b1:	68 4c 27 80 00       	push   $0x80274c
  8001b6:	50                   	push   %eax
  8001b7:	68 41 27 80 00       	push   $0x802741
  8001bc:	e8 0c 01 00 00       	call   8002cd <cprintf>
	close_all();
  8001c1:	e8 9a 11 00 00       	call   801360 <close_all>
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
  8001e7:	68 78 27 80 00       	push   $0x802778
  8001ec:	50                   	push   %eax
  8001ed:	68 41 27 80 00       	push   $0x802741
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
  800210:	68 54 27 80 00       	push   $0x802754
  800215:	e8 b3 00 00 00       	call   8002cd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80021a:	83 c4 18             	add    $0x18,%esp
  80021d:	53                   	push   %ebx
  80021e:	ff 75 10             	pushl  0x10(%ebp)
  800221:	e8 56 00 00 00       	call   80027c <vcprintf>
	cprintf("\n");
  800226:	c7 04 24 05 27 80 00 	movl   $0x802705,(%esp)
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
  80037a:	e8 a1 20 00 00       	call   802420 <__udivdi3>
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
  8003a3:	e8 88 21 00 00       	call   802530 <__umoddi3>
  8003a8:	83 c4 14             	add    $0x14,%esp
  8003ab:	0f be 80 7f 27 80 00 	movsbl 0x80277f(%eax),%eax
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
  800454:	ff 24 85 60 29 80 00 	jmp    *0x802960(,%eax,4)
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
  80051f:	8b 14 85 c0 2a 80 00 	mov    0x802ac0(,%eax,4),%edx
  800526:	85 d2                	test   %edx,%edx
  800528:	74 18                	je     800542 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80052a:	52                   	push   %edx
  80052b:	68 59 2c 80 00       	push   $0x802c59
  800530:	53                   	push   %ebx
  800531:	56                   	push   %esi
  800532:	e8 a6 fe ff ff       	call   8003dd <printfmt>
  800537:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80053a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80053d:	e9 fe 02 00 00       	jmp    800840 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800542:	50                   	push   %eax
  800543:	68 97 27 80 00       	push   $0x802797
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
  80056a:	b8 90 27 80 00       	mov    $0x802790,%eax
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
  800902:	bf b5 28 80 00       	mov    $0x8028b5,%edi
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
  80092e:	bf ed 28 80 00       	mov    $0x8028ed,%edi
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
  800dcf:	68 08 2b 80 00       	push   $0x802b08
  800dd4:	6a 43                	push   $0x43
  800dd6:	68 25 2b 80 00       	push   $0x802b25
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
  800e50:	68 08 2b 80 00       	push   $0x802b08
  800e55:	6a 43                	push   $0x43
  800e57:	68 25 2b 80 00       	push   $0x802b25
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
  800e92:	68 08 2b 80 00       	push   $0x802b08
  800e97:	6a 43                	push   $0x43
  800e99:	68 25 2b 80 00       	push   $0x802b25
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
  800ed4:	68 08 2b 80 00       	push   $0x802b08
  800ed9:	6a 43                	push   $0x43
  800edb:	68 25 2b 80 00       	push   $0x802b25
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
  800f16:	68 08 2b 80 00       	push   $0x802b08
  800f1b:	6a 43                	push   $0x43
  800f1d:	68 25 2b 80 00       	push   $0x802b25
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
  800f58:	68 08 2b 80 00       	push   $0x802b08
  800f5d:	6a 43                	push   $0x43
  800f5f:	68 25 2b 80 00       	push   $0x802b25
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
  800f9a:	68 08 2b 80 00       	push   $0x802b08
  800f9f:	6a 43                	push   $0x43
  800fa1:	68 25 2b 80 00       	push   $0x802b25
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
  800ffe:	68 08 2b 80 00       	push   $0x802b08
  801003:	6a 43                	push   $0x43
  801005:	68 25 2b 80 00       	push   $0x802b25
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
  8010e2:	68 08 2b 80 00       	push   $0x802b08
  8010e7:	6a 43                	push   $0x43
  8010e9:	68 25 2b 80 00       	push   $0x802b25
  8010ee:	e8 e4 f0 ff ff       	call   8001d7 <_panic>

008010f3 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8010f3:	55                   	push   %ebp
  8010f4:	89 e5                	mov    %esp,%ebp
  8010f6:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8010f9:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  801100:	74 0a                	je     80110c <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801102:	8b 45 08             	mov    0x8(%ebp),%eax
  801105:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  80110a:	c9                   	leave  
  80110b:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80110c:	83 ec 04             	sub    $0x4,%esp
  80110f:	6a 07                	push   $0x7
  801111:	68 00 f0 bf ee       	push   $0xeebff000
  801116:	6a 00                	push   $0x0
  801118:	e8 01 fd ff ff       	call   800e1e <sys_page_alloc>
		if(r < 0)
  80111d:	83 c4 10             	add    $0x10,%esp
  801120:	85 c0                	test   %eax,%eax
  801122:	78 2a                	js     80114e <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  801124:	83 ec 08             	sub    $0x8,%esp
  801127:	68 62 11 80 00       	push   $0x801162
  80112c:	6a 00                	push   $0x0
  80112e:	e8 36 fe ff ff       	call   800f69 <sys_env_set_pgfault_upcall>
		if(r < 0)
  801133:	83 c4 10             	add    $0x10,%esp
  801136:	85 c0                	test   %eax,%eax
  801138:	79 c8                	jns    801102 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  80113a:	83 ec 04             	sub    $0x4,%esp
  80113d:	68 64 2b 80 00       	push   $0x802b64
  801142:	6a 25                	push   $0x25
  801144:	68 9d 2b 80 00       	push   $0x802b9d
  801149:	e8 89 f0 ff ff       	call   8001d7 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  80114e:	83 ec 04             	sub    $0x4,%esp
  801151:	68 34 2b 80 00       	push   $0x802b34
  801156:	6a 22                	push   $0x22
  801158:	68 9d 2b 80 00       	push   $0x802b9d
  80115d:	e8 75 f0 ff ff       	call   8001d7 <_panic>

00801162 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801162:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801163:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  801168:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80116a:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  80116d:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  801171:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  801175:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801178:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80117a:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  80117e:	83 c4 08             	add    $0x8,%esp
	popal
  801181:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801182:	83 c4 04             	add    $0x4,%esp
	popfl
  801185:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801186:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801187:	c3                   	ret    

00801188 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	05 00 00 00 30       	add    $0x30000000,%eax
  801193:	c1 e8 0c             	shr    $0xc,%eax
}
  801196:	5d                   	pop    %ebp
  801197:	c3                   	ret    

00801198 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011a8:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011ad:	5d                   	pop    %ebp
  8011ae:	c3                   	ret    

008011af <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011af:	55                   	push   %ebp
  8011b0:	89 e5                	mov    %esp,%ebp
  8011b2:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011b7:	89 c2                	mov    %eax,%edx
  8011b9:	c1 ea 16             	shr    $0x16,%edx
  8011bc:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011c3:	f6 c2 01             	test   $0x1,%dl
  8011c6:	74 2d                	je     8011f5 <fd_alloc+0x46>
  8011c8:	89 c2                	mov    %eax,%edx
  8011ca:	c1 ea 0c             	shr    $0xc,%edx
  8011cd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011d4:	f6 c2 01             	test   $0x1,%dl
  8011d7:	74 1c                	je     8011f5 <fd_alloc+0x46>
  8011d9:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011de:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011e3:	75 d2                	jne    8011b7 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8011ee:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011f3:	eb 0a                	jmp    8011ff <fd_alloc+0x50>
			*fd_store = fd;
  8011f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011f8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ff:	5d                   	pop    %ebp
  801200:	c3                   	ret    

00801201 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801201:	55                   	push   %ebp
  801202:	89 e5                	mov    %esp,%ebp
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801207:	83 f8 1f             	cmp    $0x1f,%eax
  80120a:	77 30                	ja     80123c <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80120c:	c1 e0 0c             	shl    $0xc,%eax
  80120f:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801214:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80121a:	f6 c2 01             	test   $0x1,%dl
  80121d:	74 24                	je     801243 <fd_lookup+0x42>
  80121f:	89 c2                	mov    %eax,%edx
  801221:	c1 ea 0c             	shr    $0xc,%edx
  801224:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80122b:	f6 c2 01             	test   $0x1,%dl
  80122e:	74 1a                	je     80124a <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801230:	8b 55 0c             	mov    0xc(%ebp),%edx
  801233:	89 02                	mov    %eax,(%edx)
	return 0;
  801235:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80123a:	5d                   	pop    %ebp
  80123b:	c3                   	ret    
		return -E_INVAL;
  80123c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801241:	eb f7                	jmp    80123a <fd_lookup+0x39>
		return -E_INVAL;
  801243:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801248:	eb f0                	jmp    80123a <fd_lookup+0x39>
  80124a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80124f:	eb e9                	jmp    80123a <fd_lookup+0x39>

00801251 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801251:	55                   	push   %ebp
  801252:	89 e5                	mov    %esp,%ebp
  801254:	83 ec 08             	sub    $0x8,%esp
  801257:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80125a:	ba 00 00 00 00       	mov    $0x0,%edx
  80125f:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801264:	39 08                	cmp    %ecx,(%eax)
  801266:	74 38                	je     8012a0 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801268:	83 c2 01             	add    $0x1,%edx
  80126b:	8b 04 95 2c 2c 80 00 	mov    0x802c2c(,%edx,4),%eax
  801272:	85 c0                	test   %eax,%eax
  801274:	75 ee                	jne    801264 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801276:	a1 08 40 80 00       	mov    0x804008,%eax
  80127b:	8b 40 48             	mov    0x48(%eax),%eax
  80127e:	83 ec 04             	sub    $0x4,%esp
  801281:	51                   	push   %ecx
  801282:	50                   	push   %eax
  801283:	68 ac 2b 80 00       	push   $0x802bac
  801288:	e8 40 f0 ff ff       	call   8002cd <cprintf>
	*dev = 0;
  80128d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801290:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801296:	83 c4 10             	add    $0x10,%esp
  801299:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80129e:	c9                   	leave  
  80129f:	c3                   	ret    
			*dev = devtab[i];
  8012a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012aa:	eb f2                	jmp    80129e <dev_lookup+0x4d>

008012ac <fd_close>:
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	57                   	push   %edi
  8012b0:	56                   	push   %esi
  8012b1:	53                   	push   %ebx
  8012b2:	83 ec 24             	sub    $0x24,%esp
  8012b5:	8b 75 08             	mov    0x8(%ebp),%esi
  8012b8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012bb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012be:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012bf:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012c5:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012c8:	50                   	push   %eax
  8012c9:	e8 33 ff ff ff       	call   801201 <fd_lookup>
  8012ce:	89 c3                	mov    %eax,%ebx
  8012d0:	83 c4 10             	add    $0x10,%esp
  8012d3:	85 c0                	test   %eax,%eax
  8012d5:	78 05                	js     8012dc <fd_close+0x30>
	    || fd != fd2)
  8012d7:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012da:	74 16                	je     8012f2 <fd_close+0x46>
		return (must_exist ? r : 0);
  8012dc:	89 f8                	mov    %edi,%eax
  8012de:	84 c0                	test   %al,%al
  8012e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e5:	0f 44 d8             	cmove  %eax,%ebx
}
  8012e8:	89 d8                	mov    %ebx,%eax
  8012ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012ed:	5b                   	pop    %ebx
  8012ee:	5e                   	pop    %esi
  8012ef:	5f                   	pop    %edi
  8012f0:	5d                   	pop    %ebp
  8012f1:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012f2:	83 ec 08             	sub    $0x8,%esp
  8012f5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012f8:	50                   	push   %eax
  8012f9:	ff 36                	pushl  (%esi)
  8012fb:	e8 51 ff ff ff       	call   801251 <dev_lookup>
  801300:	89 c3                	mov    %eax,%ebx
  801302:	83 c4 10             	add    $0x10,%esp
  801305:	85 c0                	test   %eax,%eax
  801307:	78 1a                	js     801323 <fd_close+0x77>
		if (dev->dev_close)
  801309:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80130c:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80130f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801314:	85 c0                	test   %eax,%eax
  801316:	74 0b                	je     801323 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801318:	83 ec 0c             	sub    $0xc,%esp
  80131b:	56                   	push   %esi
  80131c:	ff d0                	call   *%eax
  80131e:	89 c3                	mov    %eax,%ebx
  801320:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801323:	83 ec 08             	sub    $0x8,%esp
  801326:	56                   	push   %esi
  801327:	6a 00                	push   $0x0
  801329:	e8 75 fb ff ff       	call   800ea3 <sys_page_unmap>
	return r;
  80132e:	83 c4 10             	add    $0x10,%esp
  801331:	eb b5                	jmp    8012e8 <fd_close+0x3c>

00801333 <close>:

int
close(int fdnum)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
  801336:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801339:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80133c:	50                   	push   %eax
  80133d:	ff 75 08             	pushl  0x8(%ebp)
  801340:	e8 bc fe ff ff       	call   801201 <fd_lookup>
  801345:	83 c4 10             	add    $0x10,%esp
  801348:	85 c0                	test   %eax,%eax
  80134a:	79 02                	jns    80134e <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    
		return fd_close(fd, 1);
  80134e:	83 ec 08             	sub    $0x8,%esp
  801351:	6a 01                	push   $0x1
  801353:	ff 75 f4             	pushl  -0xc(%ebp)
  801356:	e8 51 ff ff ff       	call   8012ac <fd_close>
  80135b:	83 c4 10             	add    $0x10,%esp
  80135e:	eb ec                	jmp    80134c <close+0x19>

00801360 <close_all>:

void
close_all(void)
{
  801360:	55                   	push   %ebp
  801361:	89 e5                	mov    %esp,%ebp
  801363:	53                   	push   %ebx
  801364:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801367:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80136c:	83 ec 0c             	sub    $0xc,%esp
  80136f:	53                   	push   %ebx
  801370:	e8 be ff ff ff       	call   801333 <close>
	for (i = 0; i < MAXFD; i++)
  801375:	83 c3 01             	add    $0x1,%ebx
  801378:	83 c4 10             	add    $0x10,%esp
  80137b:	83 fb 20             	cmp    $0x20,%ebx
  80137e:	75 ec                	jne    80136c <close_all+0xc>
}
  801380:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801383:	c9                   	leave  
  801384:	c3                   	ret    

00801385 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801385:	55                   	push   %ebp
  801386:	89 e5                	mov    %esp,%ebp
  801388:	57                   	push   %edi
  801389:	56                   	push   %esi
  80138a:	53                   	push   %ebx
  80138b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80138e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801391:	50                   	push   %eax
  801392:	ff 75 08             	pushl  0x8(%ebp)
  801395:	e8 67 fe ff ff       	call   801201 <fd_lookup>
  80139a:	89 c3                	mov    %eax,%ebx
  80139c:	83 c4 10             	add    $0x10,%esp
  80139f:	85 c0                	test   %eax,%eax
  8013a1:	0f 88 81 00 00 00    	js     801428 <dup+0xa3>
		return r;
	close(newfdnum);
  8013a7:	83 ec 0c             	sub    $0xc,%esp
  8013aa:	ff 75 0c             	pushl  0xc(%ebp)
  8013ad:	e8 81 ff ff ff       	call   801333 <close>

	newfd = INDEX2FD(newfdnum);
  8013b2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013b5:	c1 e6 0c             	shl    $0xc,%esi
  8013b8:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013be:	83 c4 04             	add    $0x4,%esp
  8013c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013c4:	e8 cf fd ff ff       	call   801198 <fd2data>
  8013c9:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013cb:	89 34 24             	mov    %esi,(%esp)
  8013ce:	e8 c5 fd ff ff       	call   801198 <fd2data>
  8013d3:	83 c4 10             	add    $0x10,%esp
  8013d6:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013d8:	89 d8                	mov    %ebx,%eax
  8013da:	c1 e8 16             	shr    $0x16,%eax
  8013dd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013e4:	a8 01                	test   $0x1,%al
  8013e6:	74 11                	je     8013f9 <dup+0x74>
  8013e8:	89 d8                	mov    %ebx,%eax
  8013ea:	c1 e8 0c             	shr    $0xc,%eax
  8013ed:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013f4:	f6 c2 01             	test   $0x1,%dl
  8013f7:	75 39                	jne    801432 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013fc:	89 d0                	mov    %edx,%eax
  8013fe:	c1 e8 0c             	shr    $0xc,%eax
  801401:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801408:	83 ec 0c             	sub    $0xc,%esp
  80140b:	25 07 0e 00 00       	and    $0xe07,%eax
  801410:	50                   	push   %eax
  801411:	56                   	push   %esi
  801412:	6a 00                	push   $0x0
  801414:	52                   	push   %edx
  801415:	6a 00                	push   $0x0
  801417:	e8 45 fa ff ff       	call   800e61 <sys_page_map>
  80141c:	89 c3                	mov    %eax,%ebx
  80141e:	83 c4 20             	add    $0x20,%esp
  801421:	85 c0                	test   %eax,%eax
  801423:	78 31                	js     801456 <dup+0xd1>
		goto err;

	return newfdnum;
  801425:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801428:	89 d8                	mov    %ebx,%eax
  80142a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80142d:	5b                   	pop    %ebx
  80142e:	5e                   	pop    %esi
  80142f:	5f                   	pop    %edi
  801430:	5d                   	pop    %ebp
  801431:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801432:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801439:	83 ec 0c             	sub    $0xc,%esp
  80143c:	25 07 0e 00 00       	and    $0xe07,%eax
  801441:	50                   	push   %eax
  801442:	57                   	push   %edi
  801443:	6a 00                	push   $0x0
  801445:	53                   	push   %ebx
  801446:	6a 00                	push   $0x0
  801448:	e8 14 fa ff ff       	call   800e61 <sys_page_map>
  80144d:	89 c3                	mov    %eax,%ebx
  80144f:	83 c4 20             	add    $0x20,%esp
  801452:	85 c0                	test   %eax,%eax
  801454:	79 a3                	jns    8013f9 <dup+0x74>
	sys_page_unmap(0, newfd);
  801456:	83 ec 08             	sub    $0x8,%esp
  801459:	56                   	push   %esi
  80145a:	6a 00                	push   $0x0
  80145c:	e8 42 fa ff ff       	call   800ea3 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801461:	83 c4 08             	add    $0x8,%esp
  801464:	57                   	push   %edi
  801465:	6a 00                	push   $0x0
  801467:	e8 37 fa ff ff       	call   800ea3 <sys_page_unmap>
	return r;
  80146c:	83 c4 10             	add    $0x10,%esp
  80146f:	eb b7                	jmp    801428 <dup+0xa3>

00801471 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	53                   	push   %ebx
  801475:	83 ec 1c             	sub    $0x1c,%esp
  801478:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80147b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80147e:	50                   	push   %eax
  80147f:	53                   	push   %ebx
  801480:	e8 7c fd ff ff       	call   801201 <fd_lookup>
  801485:	83 c4 10             	add    $0x10,%esp
  801488:	85 c0                	test   %eax,%eax
  80148a:	78 3f                	js     8014cb <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80148c:	83 ec 08             	sub    $0x8,%esp
  80148f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801492:	50                   	push   %eax
  801493:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801496:	ff 30                	pushl  (%eax)
  801498:	e8 b4 fd ff ff       	call   801251 <dev_lookup>
  80149d:	83 c4 10             	add    $0x10,%esp
  8014a0:	85 c0                	test   %eax,%eax
  8014a2:	78 27                	js     8014cb <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014a7:	8b 42 08             	mov    0x8(%edx),%eax
  8014aa:	83 e0 03             	and    $0x3,%eax
  8014ad:	83 f8 01             	cmp    $0x1,%eax
  8014b0:	74 1e                	je     8014d0 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b5:	8b 40 08             	mov    0x8(%eax),%eax
  8014b8:	85 c0                	test   %eax,%eax
  8014ba:	74 35                	je     8014f1 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014bc:	83 ec 04             	sub    $0x4,%esp
  8014bf:	ff 75 10             	pushl  0x10(%ebp)
  8014c2:	ff 75 0c             	pushl  0xc(%ebp)
  8014c5:	52                   	push   %edx
  8014c6:	ff d0                	call   *%eax
  8014c8:	83 c4 10             	add    $0x10,%esp
}
  8014cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ce:	c9                   	leave  
  8014cf:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014d0:	a1 08 40 80 00       	mov    0x804008,%eax
  8014d5:	8b 40 48             	mov    0x48(%eax),%eax
  8014d8:	83 ec 04             	sub    $0x4,%esp
  8014db:	53                   	push   %ebx
  8014dc:	50                   	push   %eax
  8014dd:	68 f0 2b 80 00       	push   $0x802bf0
  8014e2:	e8 e6 ed ff ff       	call   8002cd <cprintf>
		return -E_INVAL;
  8014e7:	83 c4 10             	add    $0x10,%esp
  8014ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014ef:	eb da                	jmp    8014cb <read+0x5a>
		return -E_NOT_SUPP;
  8014f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014f6:	eb d3                	jmp    8014cb <read+0x5a>

008014f8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	57                   	push   %edi
  8014fc:	56                   	push   %esi
  8014fd:	53                   	push   %ebx
  8014fe:	83 ec 0c             	sub    $0xc,%esp
  801501:	8b 7d 08             	mov    0x8(%ebp),%edi
  801504:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801507:	bb 00 00 00 00       	mov    $0x0,%ebx
  80150c:	39 f3                	cmp    %esi,%ebx
  80150e:	73 23                	jae    801533 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801510:	83 ec 04             	sub    $0x4,%esp
  801513:	89 f0                	mov    %esi,%eax
  801515:	29 d8                	sub    %ebx,%eax
  801517:	50                   	push   %eax
  801518:	89 d8                	mov    %ebx,%eax
  80151a:	03 45 0c             	add    0xc(%ebp),%eax
  80151d:	50                   	push   %eax
  80151e:	57                   	push   %edi
  80151f:	e8 4d ff ff ff       	call   801471 <read>
		if (m < 0)
  801524:	83 c4 10             	add    $0x10,%esp
  801527:	85 c0                	test   %eax,%eax
  801529:	78 06                	js     801531 <readn+0x39>
			return m;
		if (m == 0)
  80152b:	74 06                	je     801533 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80152d:	01 c3                	add    %eax,%ebx
  80152f:	eb db                	jmp    80150c <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801531:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801533:	89 d8                	mov    %ebx,%eax
  801535:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801538:	5b                   	pop    %ebx
  801539:	5e                   	pop    %esi
  80153a:	5f                   	pop    %edi
  80153b:	5d                   	pop    %ebp
  80153c:	c3                   	ret    

0080153d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80153d:	55                   	push   %ebp
  80153e:	89 e5                	mov    %esp,%ebp
  801540:	53                   	push   %ebx
  801541:	83 ec 1c             	sub    $0x1c,%esp
  801544:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801547:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80154a:	50                   	push   %eax
  80154b:	53                   	push   %ebx
  80154c:	e8 b0 fc ff ff       	call   801201 <fd_lookup>
  801551:	83 c4 10             	add    $0x10,%esp
  801554:	85 c0                	test   %eax,%eax
  801556:	78 3a                	js     801592 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801558:	83 ec 08             	sub    $0x8,%esp
  80155b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80155e:	50                   	push   %eax
  80155f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801562:	ff 30                	pushl  (%eax)
  801564:	e8 e8 fc ff ff       	call   801251 <dev_lookup>
  801569:	83 c4 10             	add    $0x10,%esp
  80156c:	85 c0                	test   %eax,%eax
  80156e:	78 22                	js     801592 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801570:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801573:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801577:	74 1e                	je     801597 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801579:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80157c:	8b 52 0c             	mov    0xc(%edx),%edx
  80157f:	85 d2                	test   %edx,%edx
  801581:	74 35                	je     8015b8 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801583:	83 ec 04             	sub    $0x4,%esp
  801586:	ff 75 10             	pushl  0x10(%ebp)
  801589:	ff 75 0c             	pushl  0xc(%ebp)
  80158c:	50                   	push   %eax
  80158d:	ff d2                	call   *%edx
  80158f:	83 c4 10             	add    $0x10,%esp
}
  801592:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801595:	c9                   	leave  
  801596:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801597:	a1 08 40 80 00       	mov    0x804008,%eax
  80159c:	8b 40 48             	mov    0x48(%eax),%eax
  80159f:	83 ec 04             	sub    $0x4,%esp
  8015a2:	53                   	push   %ebx
  8015a3:	50                   	push   %eax
  8015a4:	68 0c 2c 80 00       	push   $0x802c0c
  8015a9:	e8 1f ed ff ff       	call   8002cd <cprintf>
		return -E_INVAL;
  8015ae:	83 c4 10             	add    $0x10,%esp
  8015b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015b6:	eb da                	jmp    801592 <write+0x55>
		return -E_NOT_SUPP;
  8015b8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015bd:	eb d3                	jmp    801592 <write+0x55>

008015bf <seek>:

int
seek(int fdnum, off_t offset)
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
  8015c2:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c8:	50                   	push   %eax
  8015c9:	ff 75 08             	pushl  0x8(%ebp)
  8015cc:	e8 30 fc ff ff       	call   801201 <fd_lookup>
  8015d1:	83 c4 10             	add    $0x10,%esp
  8015d4:	85 c0                	test   %eax,%eax
  8015d6:	78 0e                	js     8015e6 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015de:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e6:	c9                   	leave  
  8015e7:	c3                   	ret    

008015e8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015e8:	55                   	push   %ebp
  8015e9:	89 e5                	mov    %esp,%ebp
  8015eb:	53                   	push   %ebx
  8015ec:	83 ec 1c             	sub    $0x1c,%esp
  8015ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015f2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015f5:	50                   	push   %eax
  8015f6:	53                   	push   %ebx
  8015f7:	e8 05 fc ff ff       	call   801201 <fd_lookup>
  8015fc:	83 c4 10             	add    $0x10,%esp
  8015ff:	85 c0                	test   %eax,%eax
  801601:	78 37                	js     80163a <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801603:	83 ec 08             	sub    $0x8,%esp
  801606:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801609:	50                   	push   %eax
  80160a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160d:	ff 30                	pushl  (%eax)
  80160f:	e8 3d fc ff ff       	call   801251 <dev_lookup>
  801614:	83 c4 10             	add    $0x10,%esp
  801617:	85 c0                	test   %eax,%eax
  801619:	78 1f                	js     80163a <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80161b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801622:	74 1b                	je     80163f <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801624:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801627:	8b 52 18             	mov    0x18(%edx),%edx
  80162a:	85 d2                	test   %edx,%edx
  80162c:	74 32                	je     801660 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80162e:	83 ec 08             	sub    $0x8,%esp
  801631:	ff 75 0c             	pushl  0xc(%ebp)
  801634:	50                   	push   %eax
  801635:	ff d2                	call   *%edx
  801637:	83 c4 10             	add    $0x10,%esp
}
  80163a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80163d:	c9                   	leave  
  80163e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80163f:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801644:	8b 40 48             	mov    0x48(%eax),%eax
  801647:	83 ec 04             	sub    $0x4,%esp
  80164a:	53                   	push   %ebx
  80164b:	50                   	push   %eax
  80164c:	68 cc 2b 80 00       	push   $0x802bcc
  801651:	e8 77 ec ff ff       	call   8002cd <cprintf>
		return -E_INVAL;
  801656:	83 c4 10             	add    $0x10,%esp
  801659:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80165e:	eb da                	jmp    80163a <ftruncate+0x52>
		return -E_NOT_SUPP;
  801660:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801665:	eb d3                	jmp    80163a <ftruncate+0x52>

00801667 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
  80166a:	53                   	push   %ebx
  80166b:	83 ec 1c             	sub    $0x1c,%esp
  80166e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801671:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801674:	50                   	push   %eax
  801675:	ff 75 08             	pushl  0x8(%ebp)
  801678:	e8 84 fb ff ff       	call   801201 <fd_lookup>
  80167d:	83 c4 10             	add    $0x10,%esp
  801680:	85 c0                	test   %eax,%eax
  801682:	78 4b                	js     8016cf <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801684:	83 ec 08             	sub    $0x8,%esp
  801687:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80168a:	50                   	push   %eax
  80168b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168e:	ff 30                	pushl  (%eax)
  801690:	e8 bc fb ff ff       	call   801251 <dev_lookup>
  801695:	83 c4 10             	add    $0x10,%esp
  801698:	85 c0                	test   %eax,%eax
  80169a:	78 33                	js     8016cf <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80169c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016a3:	74 2f                	je     8016d4 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016a5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016a8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016af:	00 00 00 
	stat->st_isdir = 0;
  8016b2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016b9:	00 00 00 
	stat->st_dev = dev;
  8016bc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016c2:	83 ec 08             	sub    $0x8,%esp
  8016c5:	53                   	push   %ebx
  8016c6:	ff 75 f0             	pushl  -0x10(%ebp)
  8016c9:	ff 50 14             	call   *0x14(%eax)
  8016cc:	83 c4 10             	add    $0x10,%esp
}
  8016cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    
		return -E_NOT_SUPP;
  8016d4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016d9:	eb f4                	jmp    8016cf <fstat+0x68>

008016db <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	56                   	push   %esi
  8016df:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016e0:	83 ec 08             	sub    $0x8,%esp
  8016e3:	6a 00                	push   $0x0
  8016e5:	ff 75 08             	pushl  0x8(%ebp)
  8016e8:	e8 22 02 00 00       	call   80190f <open>
  8016ed:	89 c3                	mov    %eax,%ebx
  8016ef:	83 c4 10             	add    $0x10,%esp
  8016f2:	85 c0                	test   %eax,%eax
  8016f4:	78 1b                	js     801711 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016f6:	83 ec 08             	sub    $0x8,%esp
  8016f9:	ff 75 0c             	pushl  0xc(%ebp)
  8016fc:	50                   	push   %eax
  8016fd:	e8 65 ff ff ff       	call   801667 <fstat>
  801702:	89 c6                	mov    %eax,%esi
	close(fd);
  801704:	89 1c 24             	mov    %ebx,(%esp)
  801707:	e8 27 fc ff ff       	call   801333 <close>
	return r;
  80170c:	83 c4 10             	add    $0x10,%esp
  80170f:	89 f3                	mov    %esi,%ebx
}
  801711:	89 d8                	mov    %ebx,%eax
  801713:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801716:	5b                   	pop    %ebx
  801717:	5e                   	pop    %esi
  801718:	5d                   	pop    %ebp
  801719:	c3                   	ret    

0080171a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80171a:	55                   	push   %ebp
  80171b:	89 e5                	mov    %esp,%ebp
  80171d:	56                   	push   %esi
  80171e:	53                   	push   %ebx
  80171f:	89 c6                	mov    %eax,%esi
  801721:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801723:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80172a:	74 27                	je     801753 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80172c:	6a 07                	push   $0x7
  80172e:	68 00 50 80 00       	push   $0x805000
  801733:	56                   	push   %esi
  801734:	ff 35 00 40 80 00    	pushl  0x804000
  80173a:	e8 08 0c 00 00       	call   802347 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80173f:	83 c4 0c             	add    $0xc,%esp
  801742:	6a 00                	push   $0x0
  801744:	53                   	push   %ebx
  801745:	6a 00                	push   $0x0
  801747:	e8 92 0b 00 00       	call   8022de <ipc_recv>
}
  80174c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80174f:	5b                   	pop    %ebx
  801750:	5e                   	pop    %esi
  801751:	5d                   	pop    %ebp
  801752:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801753:	83 ec 0c             	sub    $0xc,%esp
  801756:	6a 01                	push   $0x1
  801758:	e8 42 0c 00 00       	call   80239f <ipc_find_env>
  80175d:	a3 00 40 80 00       	mov    %eax,0x804000
  801762:	83 c4 10             	add    $0x10,%esp
  801765:	eb c5                	jmp    80172c <fsipc+0x12>

00801767 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	8b 40 0c             	mov    0xc(%eax),%eax
  801773:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177b:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801780:	ba 00 00 00 00       	mov    $0x0,%edx
  801785:	b8 02 00 00 00       	mov    $0x2,%eax
  80178a:	e8 8b ff ff ff       	call   80171a <fsipc>
}
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <devfile_flush>:
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
  801794:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	8b 40 0c             	mov    0xc(%eax),%eax
  80179d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a7:	b8 06 00 00 00       	mov    $0x6,%eax
  8017ac:	e8 69 ff ff ff       	call   80171a <fsipc>
}
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <devfile_stat>:
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	53                   	push   %ebx
  8017b7:	83 ec 04             	sub    $0x4,%esp
  8017ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8017c3:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017cd:	b8 05 00 00 00       	mov    $0x5,%eax
  8017d2:	e8 43 ff ff ff       	call   80171a <fsipc>
  8017d7:	85 c0                	test   %eax,%eax
  8017d9:	78 2c                	js     801807 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017db:	83 ec 08             	sub    $0x8,%esp
  8017de:	68 00 50 80 00       	push   $0x805000
  8017e3:	53                   	push   %ebx
  8017e4:	e8 43 f2 ff ff       	call   800a2c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017e9:	a1 80 50 80 00       	mov    0x805080,%eax
  8017ee:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017f4:	a1 84 50 80 00       	mov    0x805084,%eax
  8017f9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017ff:	83 c4 10             	add    $0x10,%esp
  801802:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801807:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <devfile_write>:
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
  80180f:	53                   	push   %ebx
  801810:	83 ec 08             	sub    $0x8,%esp
  801813:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	8b 40 0c             	mov    0xc(%eax),%eax
  80181c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801821:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801827:	53                   	push   %ebx
  801828:	ff 75 0c             	pushl  0xc(%ebp)
  80182b:	68 08 50 80 00       	push   $0x805008
  801830:	e8 e7 f3 ff ff       	call   800c1c <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801835:	ba 00 00 00 00       	mov    $0x0,%edx
  80183a:	b8 04 00 00 00       	mov    $0x4,%eax
  80183f:	e8 d6 fe ff ff       	call   80171a <fsipc>
  801844:	83 c4 10             	add    $0x10,%esp
  801847:	85 c0                	test   %eax,%eax
  801849:	78 0b                	js     801856 <devfile_write+0x4a>
	assert(r <= n);
  80184b:	39 d8                	cmp    %ebx,%eax
  80184d:	77 0c                	ja     80185b <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80184f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801854:	7f 1e                	jg     801874 <devfile_write+0x68>
}
  801856:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801859:	c9                   	leave  
  80185a:	c3                   	ret    
	assert(r <= n);
  80185b:	68 40 2c 80 00       	push   $0x802c40
  801860:	68 47 2c 80 00       	push   $0x802c47
  801865:	68 98 00 00 00       	push   $0x98
  80186a:	68 5c 2c 80 00       	push   $0x802c5c
  80186f:	e8 63 e9 ff ff       	call   8001d7 <_panic>
	assert(r <= PGSIZE);
  801874:	68 67 2c 80 00       	push   $0x802c67
  801879:	68 47 2c 80 00       	push   $0x802c47
  80187e:	68 99 00 00 00       	push   $0x99
  801883:	68 5c 2c 80 00       	push   $0x802c5c
  801888:	e8 4a e9 ff ff       	call   8001d7 <_panic>

0080188d <devfile_read>:
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
  801890:	56                   	push   %esi
  801891:	53                   	push   %ebx
  801892:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801895:	8b 45 08             	mov    0x8(%ebp),%eax
  801898:	8b 40 0c             	mov    0xc(%eax),%eax
  80189b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018a0:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ab:	b8 03 00 00 00       	mov    $0x3,%eax
  8018b0:	e8 65 fe ff ff       	call   80171a <fsipc>
  8018b5:	89 c3                	mov    %eax,%ebx
  8018b7:	85 c0                	test   %eax,%eax
  8018b9:	78 1f                	js     8018da <devfile_read+0x4d>
	assert(r <= n);
  8018bb:	39 f0                	cmp    %esi,%eax
  8018bd:	77 24                	ja     8018e3 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018bf:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018c4:	7f 33                	jg     8018f9 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018c6:	83 ec 04             	sub    $0x4,%esp
  8018c9:	50                   	push   %eax
  8018ca:	68 00 50 80 00       	push   $0x805000
  8018cf:	ff 75 0c             	pushl  0xc(%ebp)
  8018d2:	e8 e3 f2 ff ff       	call   800bba <memmove>
	return r;
  8018d7:	83 c4 10             	add    $0x10,%esp
}
  8018da:	89 d8                	mov    %ebx,%eax
  8018dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018df:	5b                   	pop    %ebx
  8018e0:	5e                   	pop    %esi
  8018e1:	5d                   	pop    %ebp
  8018e2:	c3                   	ret    
	assert(r <= n);
  8018e3:	68 40 2c 80 00       	push   $0x802c40
  8018e8:	68 47 2c 80 00       	push   $0x802c47
  8018ed:	6a 7c                	push   $0x7c
  8018ef:	68 5c 2c 80 00       	push   $0x802c5c
  8018f4:	e8 de e8 ff ff       	call   8001d7 <_panic>
	assert(r <= PGSIZE);
  8018f9:	68 67 2c 80 00       	push   $0x802c67
  8018fe:	68 47 2c 80 00       	push   $0x802c47
  801903:	6a 7d                	push   $0x7d
  801905:	68 5c 2c 80 00       	push   $0x802c5c
  80190a:	e8 c8 e8 ff ff       	call   8001d7 <_panic>

0080190f <open>:
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
  801912:	56                   	push   %esi
  801913:	53                   	push   %ebx
  801914:	83 ec 1c             	sub    $0x1c,%esp
  801917:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80191a:	56                   	push   %esi
  80191b:	e8 d3 f0 ff ff       	call   8009f3 <strlen>
  801920:	83 c4 10             	add    $0x10,%esp
  801923:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801928:	7f 6c                	jg     801996 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80192a:	83 ec 0c             	sub    $0xc,%esp
  80192d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801930:	50                   	push   %eax
  801931:	e8 79 f8 ff ff       	call   8011af <fd_alloc>
  801936:	89 c3                	mov    %eax,%ebx
  801938:	83 c4 10             	add    $0x10,%esp
  80193b:	85 c0                	test   %eax,%eax
  80193d:	78 3c                	js     80197b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80193f:	83 ec 08             	sub    $0x8,%esp
  801942:	56                   	push   %esi
  801943:	68 00 50 80 00       	push   $0x805000
  801948:	e8 df f0 ff ff       	call   800a2c <strcpy>
	fsipcbuf.open.req_omode = mode;
  80194d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801950:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801955:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801958:	b8 01 00 00 00       	mov    $0x1,%eax
  80195d:	e8 b8 fd ff ff       	call   80171a <fsipc>
  801962:	89 c3                	mov    %eax,%ebx
  801964:	83 c4 10             	add    $0x10,%esp
  801967:	85 c0                	test   %eax,%eax
  801969:	78 19                	js     801984 <open+0x75>
	return fd2num(fd);
  80196b:	83 ec 0c             	sub    $0xc,%esp
  80196e:	ff 75 f4             	pushl  -0xc(%ebp)
  801971:	e8 12 f8 ff ff       	call   801188 <fd2num>
  801976:	89 c3                	mov    %eax,%ebx
  801978:	83 c4 10             	add    $0x10,%esp
}
  80197b:	89 d8                	mov    %ebx,%eax
  80197d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801980:	5b                   	pop    %ebx
  801981:	5e                   	pop    %esi
  801982:	5d                   	pop    %ebp
  801983:	c3                   	ret    
		fd_close(fd, 0);
  801984:	83 ec 08             	sub    $0x8,%esp
  801987:	6a 00                	push   $0x0
  801989:	ff 75 f4             	pushl  -0xc(%ebp)
  80198c:	e8 1b f9 ff ff       	call   8012ac <fd_close>
		return r;
  801991:	83 c4 10             	add    $0x10,%esp
  801994:	eb e5                	jmp    80197b <open+0x6c>
		return -E_BAD_PATH;
  801996:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80199b:	eb de                	jmp    80197b <open+0x6c>

0080199d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
  8019a0:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a8:	b8 08 00 00 00       	mov    $0x8,%eax
  8019ad:	e8 68 fd ff ff       	call   80171a <fsipc>
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
  8019b7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8019ba:	68 73 2c 80 00       	push   $0x802c73
  8019bf:	ff 75 0c             	pushl  0xc(%ebp)
  8019c2:	e8 65 f0 ff ff       	call   800a2c <strcpy>
	return 0;
}
  8019c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <devsock_close>:
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
  8019d1:	53                   	push   %ebx
  8019d2:	83 ec 10             	sub    $0x10,%esp
  8019d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8019d8:	53                   	push   %ebx
  8019d9:	e8 fc 09 00 00       	call   8023da <pageref>
  8019de:	83 c4 10             	add    $0x10,%esp
		return 0;
  8019e1:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8019e6:	83 f8 01             	cmp    $0x1,%eax
  8019e9:	74 07                	je     8019f2 <devsock_close+0x24>
}
  8019eb:	89 d0                	mov    %edx,%eax
  8019ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8019f2:	83 ec 0c             	sub    $0xc,%esp
  8019f5:	ff 73 0c             	pushl  0xc(%ebx)
  8019f8:	e8 b9 02 00 00       	call   801cb6 <nsipc_close>
  8019fd:	89 c2                	mov    %eax,%edx
  8019ff:	83 c4 10             	add    $0x10,%esp
  801a02:	eb e7                	jmp    8019eb <devsock_close+0x1d>

00801a04 <devsock_write>:
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
  801a07:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a0a:	6a 00                	push   $0x0
  801a0c:	ff 75 10             	pushl  0x10(%ebp)
  801a0f:	ff 75 0c             	pushl  0xc(%ebp)
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	ff 70 0c             	pushl  0xc(%eax)
  801a18:	e8 76 03 00 00       	call   801d93 <nsipc_send>
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <devsock_read>:
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
  801a22:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a25:	6a 00                	push   $0x0
  801a27:	ff 75 10             	pushl  0x10(%ebp)
  801a2a:	ff 75 0c             	pushl  0xc(%ebp)
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	ff 70 0c             	pushl  0xc(%eax)
  801a33:	e8 ef 02 00 00       	call   801d27 <nsipc_recv>
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <fd2sockid>:
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
  801a3d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a40:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a43:	52                   	push   %edx
  801a44:	50                   	push   %eax
  801a45:	e8 b7 f7 ff ff       	call   801201 <fd_lookup>
  801a4a:	83 c4 10             	add    $0x10,%esp
  801a4d:	85 c0                	test   %eax,%eax
  801a4f:	78 10                	js     801a61 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a54:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a5a:	39 08                	cmp    %ecx,(%eax)
  801a5c:	75 05                	jne    801a63 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a5e:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    
		return -E_NOT_SUPP;
  801a63:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a68:	eb f7                	jmp    801a61 <fd2sockid+0x27>

00801a6a <alloc_sockfd>:
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
  801a6d:	56                   	push   %esi
  801a6e:	53                   	push   %ebx
  801a6f:	83 ec 1c             	sub    $0x1c,%esp
  801a72:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a74:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a77:	50                   	push   %eax
  801a78:	e8 32 f7 ff ff       	call   8011af <fd_alloc>
  801a7d:	89 c3                	mov    %eax,%ebx
  801a7f:	83 c4 10             	add    $0x10,%esp
  801a82:	85 c0                	test   %eax,%eax
  801a84:	78 43                	js     801ac9 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a86:	83 ec 04             	sub    $0x4,%esp
  801a89:	68 07 04 00 00       	push   $0x407
  801a8e:	ff 75 f4             	pushl  -0xc(%ebp)
  801a91:	6a 00                	push   $0x0
  801a93:	e8 86 f3 ff ff       	call   800e1e <sys_page_alloc>
  801a98:	89 c3                	mov    %eax,%ebx
  801a9a:	83 c4 10             	add    $0x10,%esp
  801a9d:	85 c0                	test   %eax,%eax
  801a9f:	78 28                	js     801ac9 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa4:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801aaa:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aaf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ab6:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ab9:	83 ec 0c             	sub    $0xc,%esp
  801abc:	50                   	push   %eax
  801abd:	e8 c6 f6 ff ff       	call   801188 <fd2num>
  801ac2:	89 c3                	mov    %eax,%ebx
  801ac4:	83 c4 10             	add    $0x10,%esp
  801ac7:	eb 0c                	jmp    801ad5 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801ac9:	83 ec 0c             	sub    $0xc,%esp
  801acc:	56                   	push   %esi
  801acd:	e8 e4 01 00 00       	call   801cb6 <nsipc_close>
		return r;
  801ad2:	83 c4 10             	add    $0x10,%esp
}
  801ad5:	89 d8                	mov    %ebx,%eax
  801ad7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ada:	5b                   	pop    %ebx
  801adb:	5e                   	pop    %esi
  801adc:	5d                   	pop    %ebp
  801add:	c3                   	ret    

00801ade <accept>:
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
  801ae1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae7:	e8 4e ff ff ff       	call   801a3a <fd2sockid>
  801aec:	85 c0                	test   %eax,%eax
  801aee:	78 1b                	js     801b0b <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801af0:	83 ec 04             	sub    $0x4,%esp
  801af3:	ff 75 10             	pushl  0x10(%ebp)
  801af6:	ff 75 0c             	pushl  0xc(%ebp)
  801af9:	50                   	push   %eax
  801afa:	e8 0e 01 00 00       	call   801c0d <nsipc_accept>
  801aff:	83 c4 10             	add    $0x10,%esp
  801b02:	85 c0                	test   %eax,%eax
  801b04:	78 05                	js     801b0b <accept+0x2d>
	return alloc_sockfd(r);
  801b06:	e8 5f ff ff ff       	call   801a6a <alloc_sockfd>
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <bind>:
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b13:	8b 45 08             	mov    0x8(%ebp),%eax
  801b16:	e8 1f ff ff ff       	call   801a3a <fd2sockid>
  801b1b:	85 c0                	test   %eax,%eax
  801b1d:	78 12                	js     801b31 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801b1f:	83 ec 04             	sub    $0x4,%esp
  801b22:	ff 75 10             	pushl  0x10(%ebp)
  801b25:	ff 75 0c             	pushl  0xc(%ebp)
  801b28:	50                   	push   %eax
  801b29:	e8 31 01 00 00       	call   801c5f <nsipc_bind>
  801b2e:	83 c4 10             	add    $0x10,%esp
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <shutdown>:
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
  801b36:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b39:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3c:	e8 f9 fe ff ff       	call   801a3a <fd2sockid>
  801b41:	85 c0                	test   %eax,%eax
  801b43:	78 0f                	js     801b54 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801b45:	83 ec 08             	sub    $0x8,%esp
  801b48:	ff 75 0c             	pushl  0xc(%ebp)
  801b4b:	50                   	push   %eax
  801b4c:	e8 43 01 00 00       	call   801c94 <nsipc_shutdown>
  801b51:	83 c4 10             	add    $0x10,%esp
}
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <connect>:
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
  801b59:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	e8 d6 fe ff ff       	call   801a3a <fd2sockid>
  801b64:	85 c0                	test   %eax,%eax
  801b66:	78 12                	js     801b7a <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b68:	83 ec 04             	sub    $0x4,%esp
  801b6b:	ff 75 10             	pushl  0x10(%ebp)
  801b6e:	ff 75 0c             	pushl  0xc(%ebp)
  801b71:	50                   	push   %eax
  801b72:	e8 59 01 00 00       	call   801cd0 <nsipc_connect>
  801b77:	83 c4 10             	add    $0x10,%esp
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <listen>:
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	e8 b0 fe ff ff       	call   801a3a <fd2sockid>
  801b8a:	85 c0                	test   %eax,%eax
  801b8c:	78 0f                	js     801b9d <listen+0x21>
	return nsipc_listen(r, backlog);
  801b8e:	83 ec 08             	sub    $0x8,%esp
  801b91:	ff 75 0c             	pushl  0xc(%ebp)
  801b94:	50                   	push   %eax
  801b95:	e8 6b 01 00 00       	call   801d05 <nsipc_listen>
  801b9a:	83 c4 10             	add    $0x10,%esp
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <socket>:

int
socket(int domain, int type, int protocol)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
  801ba2:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ba5:	ff 75 10             	pushl  0x10(%ebp)
  801ba8:	ff 75 0c             	pushl  0xc(%ebp)
  801bab:	ff 75 08             	pushl  0x8(%ebp)
  801bae:	e8 3e 02 00 00       	call   801df1 <nsipc_socket>
  801bb3:	83 c4 10             	add    $0x10,%esp
  801bb6:	85 c0                	test   %eax,%eax
  801bb8:	78 05                	js     801bbf <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801bba:	e8 ab fe ff ff       	call   801a6a <alloc_sockfd>
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	53                   	push   %ebx
  801bc5:	83 ec 04             	sub    $0x4,%esp
  801bc8:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801bca:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801bd1:	74 26                	je     801bf9 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801bd3:	6a 07                	push   $0x7
  801bd5:	68 00 60 80 00       	push   $0x806000
  801bda:	53                   	push   %ebx
  801bdb:	ff 35 04 40 80 00    	pushl  0x804004
  801be1:	e8 61 07 00 00       	call   802347 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801be6:	83 c4 0c             	add    $0xc,%esp
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	e8 ea 06 00 00       	call   8022de <ipc_recv>
}
  801bf4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801bf9:	83 ec 0c             	sub    $0xc,%esp
  801bfc:	6a 02                	push   $0x2
  801bfe:	e8 9c 07 00 00       	call   80239f <ipc_find_env>
  801c03:	a3 04 40 80 00       	mov    %eax,0x804004
  801c08:	83 c4 10             	add    $0x10,%esp
  801c0b:	eb c6                	jmp    801bd3 <nsipc+0x12>

00801c0d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
  801c10:	56                   	push   %esi
  801c11:	53                   	push   %ebx
  801c12:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c15:	8b 45 08             	mov    0x8(%ebp),%eax
  801c18:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c1d:	8b 06                	mov    (%esi),%eax
  801c1f:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c24:	b8 01 00 00 00       	mov    $0x1,%eax
  801c29:	e8 93 ff ff ff       	call   801bc1 <nsipc>
  801c2e:	89 c3                	mov    %eax,%ebx
  801c30:	85 c0                	test   %eax,%eax
  801c32:	79 09                	jns    801c3d <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801c34:	89 d8                	mov    %ebx,%eax
  801c36:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c39:	5b                   	pop    %ebx
  801c3a:	5e                   	pop    %esi
  801c3b:	5d                   	pop    %ebp
  801c3c:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c3d:	83 ec 04             	sub    $0x4,%esp
  801c40:	ff 35 10 60 80 00    	pushl  0x806010
  801c46:	68 00 60 80 00       	push   $0x806000
  801c4b:	ff 75 0c             	pushl  0xc(%ebp)
  801c4e:	e8 67 ef ff ff       	call   800bba <memmove>
		*addrlen = ret->ret_addrlen;
  801c53:	a1 10 60 80 00       	mov    0x806010,%eax
  801c58:	89 06                	mov    %eax,(%esi)
  801c5a:	83 c4 10             	add    $0x10,%esp
	return r;
  801c5d:	eb d5                	jmp    801c34 <nsipc_accept+0x27>

00801c5f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
  801c62:	53                   	push   %ebx
  801c63:	83 ec 08             	sub    $0x8,%esp
  801c66:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c71:	53                   	push   %ebx
  801c72:	ff 75 0c             	pushl  0xc(%ebp)
  801c75:	68 04 60 80 00       	push   $0x806004
  801c7a:	e8 3b ef ff ff       	call   800bba <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c7f:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c85:	b8 02 00 00 00       	mov    $0x2,%eax
  801c8a:	e8 32 ff ff ff       	call   801bc1 <nsipc>
}
  801c8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c92:	c9                   	leave  
  801c93:	c3                   	ret    

00801c94 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
  801c97:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca5:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801caa:	b8 03 00 00 00       	mov    $0x3,%eax
  801caf:	e8 0d ff ff ff       	call   801bc1 <nsipc>
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <nsipc_close>:

int
nsipc_close(int s)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbf:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801cc4:	b8 04 00 00 00       	mov    $0x4,%eax
  801cc9:	e8 f3 fe ff ff       	call   801bc1 <nsipc>
}
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	53                   	push   %ebx
  801cd4:	83 ec 08             	sub    $0x8,%esp
  801cd7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ce2:	53                   	push   %ebx
  801ce3:	ff 75 0c             	pushl  0xc(%ebp)
  801ce6:	68 04 60 80 00       	push   $0x806004
  801ceb:	e8 ca ee ff ff       	call   800bba <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801cf0:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801cf6:	b8 05 00 00 00       	mov    $0x5,%eax
  801cfb:	e8 c1 fe ff ff       	call   801bc1 <nsipc>
}
  801d00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    

00801d05 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
  801d08:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d16:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d1b:	b8 06 00 00 00       	mov    $0x6,%eax
  801d20:	e8 9c fe ff ff       	call   801bc1 <nsipc>
}
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
  801d2a:	56                   	push   %esi
  801d2b:	53                   	push   %ebx
  801d2c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d32:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d37:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d3d:	8b 45 14             	mov    0x14(%ebp),%eax
  801d40:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d45:	b8 07 00 00 00       	mov    $0x7,%eax
  801d4a:	e8 72 fe ff ff       	call   801bc1 <nsipc>
  801d4f:	89 c3                	mov    %eax,%ebx
  801d51:	85 c0                	test   %eax,%eax
  801d53:	78 1f                	js     801d74 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d55:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d5a:	7f 21                	jg     801d7d <nsipc_recv+0x56>
  801d5c:	39 c6                	cmp    %eax,%esi
  801d5e:	7c 1d                	jl     801d7d <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d60:	83 ec 04             	sub    $0x4,%esp
  801d63:	50                   	push   %eax
  801d64:	68 00 60 80 00       	push   $0x806000
  801d69:	ff 75 0c             	pushl  0xc(%ebp)
  801d6c:	e8 49 ee ff ff       	call   800bba <memmove>
  801d71:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d74:	89 d8                	mov    %ebx,%eax
  801d76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d79:	5b                   	pop    %ebx
  801d7a:	5e                   	pop    %esi
  801d7b:	5d                   	pop    %ebp
  801d7c:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d7d:	68 7f 2c 80 00       	push   $0x802c7f
  801d82:	68 47 2c 80 00       	push   $0x802c47
  801d87:	6a 62                	push   $0x62
  801d89:	68 94 2c 80 00       	push   $0x802c94
  801d8e:	e8 44 e4 ff ff       	call   8001d7 <_panic>

00801d93 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
  801d96:	53                   	push   %ebx
  801d97:	83 ec 04             	sub    $0x4,%esp
  801d9a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801da0:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801da5:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801dab:	7f 2e                	jg     801ddb <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801dad:	83 ec 04             	sub    $0x4,%esp
  801db0:	53                   	push   %ebx
  801db1:	ff 75 0c             	pushl  0xc(%ebp)
  801db4:	68 0c 60 80 00       	push   $0x80600c
  801db9:	e8 fc ed ff ff       	call   800bba <memmove>
	nsipcbuf.send.req_size = size;
  801dbe:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801dc4:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801dcc:	b8 08 00 00 00       	mov    $0x8,%eax
  801dd1:	e8 eb fd ff ff       	call   801bc1 <nsipc>
}
  801dd6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    
	assert(size < 1600);
  801ddb:	68 a0 2c 80 00       	push   $0x802ca0
  801de0:	68 47 2c 80 00       	push   $0x802c47
  801de5:	6a 6d                	push   $0x6d
  801de7:	68 94 2c 80 00       	push   $0x802c94
  801dec:	e8 e6 e3 ff ff       	call   8001d7 <_panic>

00801df1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
  801df4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801df7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfa:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801dff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e02:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e07:	8b 45 10             	mov    0x10(%ebp),%eax
  801e0a:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e0f:	b8 09 00 00 00       	mov    $0x9,%eax
  801e14:	e8 a8 fd ff ff       	call   801bc1 <nsipc>
}
  801e19:	c9                   	leave  
  801e1a:	c3                   	ret    

00801e1b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
  801e1e:	56                   	push   %esi
  801e1f:	53                   	push   %ebx
  801e20:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e23:	83 ec 0c             	sub    $0xc,%esp
  801e26:	ff 75 08             	pushl  0x8(%ebp)
  801e29:	e8 6a f3 ff ff       	call   801198 <fd2data>
  801e2e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e30:	83 c4 08             	add    $0x8,%esp
  801e33:	68 ac 2c 80 00       	push   $0x802cac
  801e38:	53                   	push   %ebx
  801e39:	e8 ee eb ff ff       	call   800a2c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e3e:	8b 46 04             	mov    0x4(%esi),%eax
  801e41:	2b 06                	sub    (%esi),%eax
  801e43:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e49:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e50:	00 00 00 
	stat->st_dev = &devpipe;
  801e53:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801e5a:	30 80 00 
	return 0;
}
  801e5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e65:	5b                   	pop    %ebx
  801e66:	5e                   	pop    %esi
  801e67:	5d                   	pop    %ebp
  801e68:	c3                   	ret    

00801e69 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
  801e6c:	53                   	push   %ebx
  801e6d:	83 ec 0c             	sub    $0xc,%esp
  801e70:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e73:	53                   	push   %ebx
  801e74:	6a 00                	push   $0x0
  801e76:	e8 28 f0 ff ff       	call   800ea3 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e7b:	89 1c 24             	mov    %ebx,(%esp)
  801e7e:	e8 15 f3 ff ff       	call   801198 <fd2data>
  801e83:	83 c4 08             	add    $0x8,%esp
  801e86:	50                   	push   %eax
  801e87:	6a 00                	push   $0x0
  801e89:	e8 15 f0 ff ff       	call   800ea3 <sys_page_unmap>
}
  801e8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e91:	c9                   	leave  
  801e92:	c3                   	ret    

00801e93 <_pipeisclosed>:
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
  801e96:	57                   	push   %edi
  801e97:	56                   	push   %esi
  801e98:	53                   	push   %ebx
  801e99:	83 ec 1c             	sub    $0x1c,%esp
  801e9c:	89 c7                	mov    %eax,%edi
  801e9e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ea0:	a1 08 40 80 00       	mov    0x804008,%eax
  801ea5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ea8:	83 ec 0c             	sub    $0xc,%esp
  801eab:	57                   	push   %edi
  801eac:	e8 29 05 00 00       	call   8023da <pageref>
  801eb1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801eb4:	89 34 24             	mov    %esi,(%esp)
  801eb7:	e8 1e 05 00 00       	call   8023da <pageref>
		nn = thisenv->env_runs;
  801ebc:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ec2:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ec5:	83 c4 10             	add    $0x10,%esp
  801ec8:	39 cb                	cmp    %ecx,%ebx
  801eca:	74 1b                	je     801ee7 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ecc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ecf:	75 cf                	jne    801ea0 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ed1:	8b 42 58             	mov    0x58(%edx),%eax
  801ed4:	6a 01                	push   $0x1
  801ed6:	50                   	push   %eax
  801ed7:	53                   	push   %ebx
  801ed8:	68 b3 2c 80 00       	push   $0x802cb3
  801edd:	e8 eb e3 ff ff       	call   8002cd <cprintf>
  801ee2:	83 c4 10             	add    $0x10,%esp
  801ee5:	eb b9                	jmp    801ea0 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801ee7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801eea:	0f 94 c0             	sete   %al
  801eed:	0f b6 c0             	movzbl %al,%eax
}
  801ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ef3:	5b                   	pop    %ebx
  801ef4:	5e                   	pop    %esi
  801ef5:	5f                   	pop    %edi
  801ef6:	5d                   	pop    %ebp
  801ef7:	c3                   	ret    

00801ef8 <devpipe_write>:
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
  801efb:	57                   	push   %edi
  801efc:	56                   	push   %esi
  801efd:	53                   	push   %ebx
  801efe:	83 ec 28             	sub    $0x28,%esp
  801f01:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f04:	56                   	push   %esi
  801f05:	e8 8e f2 ff ff       	call   801198 <fd2data>
  801f0a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f0c:	83 c4 10             	add    $0x10,%esp
  801f0f:	bf 00 00 00 00       	mov    $0x0,%edi
  801f14:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f17:	74 4f                	je     801f68 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f19:	8b 43 04             	mov    0x4(%ebx),%eax
  801f1c:	8b 0b                	mov    (%ebx),%ecx
  801f1e:	8d 51 20             	lea    0x20(%ecx),%edx
  801f21:	39 d0                	cmp    %edx,%eax
  801f23:	72 14                	jb     801f39 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801f25:	89 da                	mov    %ebx,%edx
  801f27:	89 f0                	mov    %esi,%eax
  801f29:	e8 65 ff ff ff       	call   801e93 <_pipeisclosed>
  801f2e:	85 c0                	test   %eax,%eax
  801f30:	75 3b                	jne    801f6d <devpipe_write+0x75>
			sys_yield();
  801f32:	e8 c8 ee ff ff       	call   800dff <sys_yield>
  801f37:	eb e0                	jmp    801f19 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f3c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f40:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f43:	89 c2                	mov    %eax,%edx
  801f45:	c1 fa 1f             	sar    $0x1f,%edx
  801f48:	89 d1                	mov    %edx,%ecx
  801f4a:	c1 e9 1b             	shr    $0x1b,%ecx
  801f4d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801f50:	83 e2 1f             	and    $0x1f,%edx
  801f53:	29 ca                	sub    %ecx,%edx
  801f55:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f59:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f5d:	83 c0 01             	add    $0x1,%eax
  801f60:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f63:	83 c7 01             	add    $0x1,%edi
  801f66:	eb ac                	jmp    801f14 <devpipe_write+0x1c>
	return i;
  801f68:	8b 45 10             	mov    0x10(%ebp),%eax
  801f6b:	eb 05                	jmp    801f72 <devpipe_write+0x7a>
				return 0;
  801f6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f75:	5b                   	pop    %ebx
  801f76:	5e                   	pop    %esi
  801f77:	5f                   	pop    %edi
  801f78:	5d                   	pop    %ebp
  801f79:	c3                   	ret    

00801f7a <devpipe_read>:
{
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
  801f7d:	57                   	push   %edi
  801f7e:	56                   	push   %esi
  801f7f:	53                   	push   %ebx
  801f80:	83 ec 18             	sub    $0x18,%esp
  801f83:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f86:	57                   	push   %edi
  801f87:	e8 0c f2 ff ff       	call   801198 <fd2data>
  801f8c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f8e:	83 c4 10             	add    $0x10,%esp
  801f91:	be 00 00 00 00       	mov    $0x0,%esi
  801f96:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f99:	75 14                	jne    801faf <devpipe_read+0x35>
	return i;
  801f9b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f9e:	eb 02                	jmp    801fa2 <devpipe_read+0x28>
				return i;
  801fa0:	89 f0                	mov    %esi,%eax
}
  801fa2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fa5:	5b                   	pop    %ebx
  801fa6:	5e                   	pop    %esi
  801fa7:	5f                   	pop    %edi
  801fa8:	5d                   	pop    %ebp
  801fa9:	c3                   	ret    
			sys_yield();
  801faa:	e8 50 ee ff ff       	call   800dff <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801faf:	8b 03                	mov    (%ebx),%eax
  801fb1:	3b 43 04             	cmp    0x4(%ebx),%eax
  801fb4:	75 18                	jne    801fce <devpipe_read+0x54>
			if (i > 0)
  801fb6:	85 f6                	test   %esi,%esi
  801fb8:	75 e6                	jne    801fa0 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801fba:	89 da                	mov    %ebx,%edx
  801fbc:	89 f8                	mov    %edi,%eax
  801fbe:	e8 d0 fe ff ff       	call   801e93 <_pipeisclosed>
  801fc3:	85 c0                	test   %eax,%eax
  801fc5:	74 e3                	je     801faa <devpipe_read+0x30>
				return 0;
  801fc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcc:	eb d4                	jmp    801fa2 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801fce:	99                   	cltd   
  801fcf:	c1 ea 1b             	shr    $0x1b,%edx
  801fd2:	01 d0                	add    %edx,%eax
  801fd4:	83 e0 1f             	and    $0x1f,%eax
  801fd7:	29 d0                	sub    %edx,%eax
  801fd9:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801fde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fe1:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801fe4:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801fe7:	83 c6 01             	add    $0x1,%esi
  801fea:	eb aa                	jmp    801f96 <devpipe_read+0x1c>

00801fec <pipe>:
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	56                   	push   %esi
  801ff0:	53                   	push   %ebx
  801ff1:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ff4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ff7:	50                   	push   %eax
  801ff8:	e8 b2 f1 ff ff       	call   8011af <fd_alloc>
  801ffd:	89 c3                	mov    %eax,%ebx
  801fff:	83 c4 10             	add    $0x10,%esp
  802002:	85 c0                	test   %eax,%eax
  802004:	0f 88 23 01 00 00    	js     80212d <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80200a:	83 ec 04             	sub    $0x4,%esp
  80200d:	68 07 04 00 00       	push   $0x407
  802012:	ff 75 f4             	pushl  -0xc(%ebp)
  802015:	6a 00                	push   $0x0
  802017:	e8 02 ee ff ff       	call   800e1e <sys_page_alloc>
  80201c:	89 c3                	mov    %eax,%ebx
  80201e:	83 c4 10             	add    $0x10,%esp
  802021:	85 c0                	test   %eax,%eax
  802023:	0f 88 04 01 00 00    	js     80212d <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802029:	83 ec 0c             	sub    $0xc,%esp
  80202c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80202f:	50                   	push   %eax
  802030:	e8 7a f1 ff ff       	call   8011af <fd_alloc>
  802035:	89 c3                	mov    %eax,%ebx
  802037:	83 c4 10             	add    $0x10,%esp
  80203a:	85 c0                	test   %eax,%eax
  80203c:	0f 88 db 00 00 00    	js     80211d <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802042:	83 ec 04             	sub    $0x4,%esp
  802045:	68 07 04 00 00       	push   $0x407
  80204a:	ff 75 f0             	pushl  -0x10(%ebp)
  80204d:	6a 00                	push   $0x0
  80204f:	e8 ca ed ff ff       	call   800e1e <sys_page_alloc>
  802054:	89 c3                	mov    %eax,%ebx
  802056:	83 c4 10             	add    $0x10,%esp
  802059:	85 c0                	test   %eax,%eax
  80205b:	0f 88 bc 00 00 00    	js     80211d <pipe+0x131>
	va = fd2data(fd0);
  802061:	83 ec 0c             	sub    $0xc,%esp
  802064:	ff 75 f4             	pushl  -0xc(%ebp)
  802067:	e8 2c f1 ff ff       	call   801198 <fd2data>
  80206c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80206e:	83 c4 0c             	add    $0xc,%esp
  802071:	68 07 04 00 00       	push   $0x407
  802076:	50                   	push   %eax
  802077:	6a 00                	push   $0x0
  802079:	e8 a0 ed ff ff       	call   800e1e <sys_page_alloc>
  80207e:	89 c3                	mov    %eax,%ebx
  802080:	83 c4 10             	add    $0x10,%esp
  802083:	85 c0                	test   %eax,%eax
  802085:	0f 88 82 00 00 00    	js     80210d <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80208b:	83 ec 0c             	sub    $0xc,%esp
  80208e:	ff 75 f0             	pushl  -0x10(%ebp)
  802091:	e8 02 f1 ff ff       	call   801198 <fd2data>
  802096:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80209d:	50                   	push   %eax
  80209e:	6a 00                	push   $0x0
  8020a0:	56                   	push   %esi
  8020a1:	6a 00                	push   $0x0
  8020a3:	e8 b9 ed ff ff       	call   800e61 <sys_page_map>
  8020a8:	89 c3                	mov    %eax,%ebx
  8020aa:	83 c4 20             	add    $0x20,%esp
  8020ad:	85 c0                	test   %eax,%eax
  8020af:	78 4e                	js     8020ff <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8020b1:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8020b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b9:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8020bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020be:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8020c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020c8:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8020ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020cd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8020d4:	83 ec 0c             	sub    $0xc,%esp
  8020d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8020da:	e8 a9 f0 ff ff       	call   801188 <fd2num>
  8020df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020e2:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8020e4:	83 c4 04             	add    $0x4,%esp
  8020e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8020ea:	e8 99 f0 ff ff       	call   801188 <fd2num>
  8020ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020f2:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8020f5:	83 c4 10             	add    $0x10,%esp
  8020f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020fd:	eb 2e                	jmp    80212d <pipe+0x141>
	sys_page_unmap(0, va);
  8020ff:	83 ec 08             	sub    $0x8,%esp
  802102:	56                   	push   %esi
  802103:	6a 00                	push   $0x0
  802105:	e8 99 ed ff ff       	call   800ea3 <sys_page_unmap>
  80210a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80210d:	83 ec 08             	sub    $0x8,%esp
  802110:	ff 75 f0             	pushl  -0x10(%ebp)
  802113:	6a 00                	push   $0x0
  802115:	e8 89 ed ff ff       	call   800ea3 <sys_page_unmap>
  80211a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80211d:	83 ec 08             	sub    $0x8,%esp
  802120:	ff 75 f4             	pushl  -0xc(%ebp)
  802123:	6a 00                	push   $0x0
  802125:	e8 79 ed ff ff       	call   800ea3 <sys_page_unmap>
  80212a:	83 c4 10             	add    $0x10,%esp
}
  80212d:	89 d8                	mov    %ebx,%eax
  80212f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802132:	5b                   	pop    %ebx
  802133:	5e                   	pop    %esi
  802134:	5d                   	pop    %ebp
  802135:	c3                   	ret    

00802136 <pipeisclosed>:
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
  802139:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80213c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80213f:	50                   	push   %eax
  802140:	ff 75 08             	pushl  0x8(%ebp)
  802143:	e8 b9 f0 ff ff       	call   801201 <fd_lookup>
  802148:	83 c4 10             	add    $0x10,%esp
  80214b:	85 c0                	test   %eax,%eax
  80214d:	78 18                	js     802167 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80214f:	83 ec 0c             	sub    $0xc,%esp
  802152:	ff 75 f4             	pushl  -0xc(%ebp)
  802155:	e8 3e f0 ff ff       	call   801198 <fd2data>
	return _pipeisclosed(fd, p);
  80215a:	89 c2                	mov    %eax,%edx
  80215c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215f:	e8 2f fd ff ff       	call   801e93 <_pipeisclosed>
  802164:	83 c4 10             	add    $0x10,%esp
}
  802167:	c9                   	leave  
  802168:	c3                   	ret    

00802169 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802169:	b8 00 00 00 00       	mov    $0x0,%eax
  80216e:	c3                   	ret    

0080216f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80216f:	55                   	push   %ebp
  802170:	89 e5                	mov    %esp,%ebp
  802172:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802175:	68 cb 2c 80 00       	push   $0x802ccb
  80217a:	ff 75 0c             	pushl  0xc(%ebp)
  80217d:	e8 aa e8 ff ff       	call   800a2c <strcpy>
	return 0;
}
  802182:	b8 00 00 00 00       	mov    $0x0,%eax
  802187:	c9                   	leave  
  802188:	c3                   	ret    

00802189 <devcons_write>:
{
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
  80218c:	57                   	push   %edi
  80218d:	56                   	push   %esi
  80218e:	53                   	push   %ebx
  80218f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802195:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80219a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8021a0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021a3:	73 31                	jae    8021d6 <devcons_write+0x4d>
		m = n - tot;
  8021a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8021a8:	29 f3                	sub    %esi,%ebx
  8021aa:	83 fb 7f             	cmp    $0x7f,%ebx
  8021ad:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8021b2:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8021b5:	83 ec 04             	sub    $0x4,%esp
  8021b8:	53                   	push   %ebx
  8021b9:	89 f0                	mov    %esi,%eax
  8021bb:	03 45 0c             	add    0xc(%ebp),%eax
  8021be:	50                   	push   %eax
  8021bf:	57                   	push   %edi
  8021c0:	e8 f5 e9 ff ff       	call   800bba <memmove>
		sys_cputs(buf, m);
  8021c5:	83 c4 08             	add    $0x8,%esp
  8021c8:	53                   	push   %ebx
  8021c9:	57                   	push   %edi
  8021ca:	e8 93 eb ff ff       	call   800d62 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8021cf:	01 de                	add    %ebx,%esi
  8021d1:	83 c4 10             	add    $0x10,%esp
  8021d4:	eb ca                	jmp    8021a0 <devcons_write+0x17>
}
  8021d6:	89 f0                	mov    %esi,%eax
  8021d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021db:	5b                   	pop    %ebx
  8021dc:	5e                   	pop    %esi
  8021dd:	5f                   	pop    %edi
  8021de:	5d                   	pop    %ebp
  8021df:	c3                   	ret    

008021e0 <devcons_read>:
{
  8021e0:	55                   	push   %ebp
  8021e1:	89 e5                	mov    %esp,%ebp
  8021e3:	83 ec 08             	sub    $0x8,%esp
  8021e6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8021eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021ef:	74 21                	je     802212 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8021f1:	e8 8a eb ff ff       	call   800d80 <sys_cgetc>
  8021f6:	85 c0                	test   %eax,%eax
  8021f8:	75 07                	jne    802201 <devcons_read+0x21>
		sys_yield();
  8021fa:	e8 00 ec ff ff       	call   800dff <sys_yield>
  8021ff:	eb f0                	jmp    8021f1 <devcons_read+0x11>
	if (c < 0)
  802201:	78 0f                	js     802212 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802203:	83 f8 04             	cmp    $0x4,%eax
  802206:	74 0c                	je     802214 <devcons_read+0x34>
	*(char*)vbuf = c;
  802208:	8b 55 0c             	mov    0xc(%ebp),%edx
  80220b:	88 02                	mov    %al,(%edx)
	return 1;
  80220d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802212:	c9                   	leave  
  802213:	c3                   	ret    
		return 0;
  802214:	b8 00 00 00 00       	mov    $0x0,%eax
  802219:	eb f7                	jmp    802212 <devcons_read+0x32>

0080221b <cputchar>:
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
  80221e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802221:	8b 45 08             	mov    0x8(%ebp),%eax
  802224:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802227:	6a 01                	push   $0x1
  802229:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80222c:	50                   	push   %eax
  80222d:	e8 30 eb ff ff       	call   800d62 <sys_cputs>
}
  802232:	83 c4 10             	add    $0x10,%esp
  802235:	c9                   	leave  
  802236:	c3                   	ret    

00802237 <getchar>:
{
  802237:	55                   	push   %ebp
  802238:	89 e5                	mov    %esp,%ebp
  80223a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80223d:	6a 01                	push   $0x1
  80223f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802242:	50                   	push   %eax
  802243:	6a 00                	push   $0x0
  802245:	e8 27 f2 ff ff       	call   801471 <read>
	if (r < 0)
  80224a:	83 c4 10             	add    $0x10,%esp
  80224d:	85 c0                	test   %eax,%eax
  80224f:	78 06                	js     802257 <getchar+0x20>
	if (r < 1)
  802251:	74 06                	je     802259 <getchar+0x22>
	return c;
  802253:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802257:	c9                   	leave  
  802258:	c3                   	ret    
		return -E_EOF;
  802259:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80225e:	eb f7                	jmp    802257 <getchar+0x20>

00802260 <iscons>:
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802266:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802269:	50                   	push   %eax
  80226a:	ff 75 08             	pushl  0x8(%ebp)
  80226d:	e8 8f ef ff ff       	call   801201 <fd_lookup>
  802272:	83 c4 10             	add    $0x10,%esp
  802275:	85 c0                	test   %eax,%eax
  802277:	78 11                	js     80228a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227c:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802282:	39 10                	cmp    %edx,(%eax)
  802284:	0f 94 c0             	sete   %al
  802287:	0f b6 c0             	movzbl %al,%eax
}
  80228a:	c9                   	leave  
  80228b:	c3                   	ret    

0080228c <opencons>:
{
  80228c:	55                   	push   %ebp
  80228d:	89 e5                	mov    %esp,%ebp
  80228f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802292:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802295:	50                   	push   %eax
  802296:	e8 14 ef ff ff       	call   8011af <fd_alloc>
  80229b:	83 c4 10             	add    $0x10,%esp
  80229e:	85 c0                	test   %eax,%eax
  8022a0:	78 3a                	js     8022dc <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022a2:	83 ec 04             	sub    $0x4,%esp
  8022a5:	68 07 04 00 00       	push   $0x407
  8022aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8022ad:	6a 00                	push   $0x0
  8022af:	e8 6a eb ff ff       	call   800e1e <sys_page_alloc>
  8022b4:	83 c4 10             	add    $0x10,%esp
  8022b7:	85 c0                	test   %eax,%eax
  8022b9:	78 21                	js     8022dc <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8022bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022be:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022c4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022d0:	83 ec 0c             	sub    $0xc,%esp
  8022d3:	50                   	push   %eax
  8022d4:	e8 af ee ff ff       	call   801188 <fd2num>
  8022d9:	83 c4 10             	add    $0x10,%esp
}
  8022dc:	c9                   	leave  
  8022dd:	c3                   	ret    

008022de <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022de:	55                   	push   %ebp
  8022df:	89 e5                	mov    %esp,%ebp
  8022e1:	56                   	push   %esi
  8022e2:	53                   	push   %ebx
  8022e3:	8b 75 08             	mov    0x8(%ebp),%esi
  8022e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  8022ec:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8022ee:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022f3:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8022f6:	83 ec 0c             	sub    $0xc,%esp
  8022f9:	50                   	push   %eax
  8022fa:	e8 cf ec ff ff       	call   800fce <sys_ipc_recv>
	if(ret < 0){
  8022ff:	83 c4 10             	add    $0x10,%esp
  802302:	85 c0                	test   %eax,%eax
  802304:	78 2b                	js     802331 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802306:	85 f6                	test   %esi,%esi
  802308:	74 0a                	je     802314 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  80230a:	a1 08 40 80 00       	mov    0x804008,%eax
  80230f:	8b 40 74             	mov    0x74(%eax),%eax
  802312:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802314:	85 db                	test   %ebx,%ebx
  802316:	74 0a                	je     802322 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802318:	a1 08 40 80 00       	mov    0x804008,%eax
  80231d:	8b 40 78             	mov    0x78(%eax),%eax
  802320:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  802322:	a1 08 40 80 00       	mov    0x804008,%eax
  802327:	8b 40 70             	mov    0x70(%eax),%eax
}
  80232a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80232d:	5b                   	pop    %ebx
  80232e:	5e                   	pop    %esi
  80232f:	5d                   	pop    %ebp
  802330:	c3                   	ret    
		if(from_env_store)
  802331:	85 f6                	test   %esi,%esi
  802333:	74 06                	je     80233b <ipc_recv+0x5d>
			*from_env_store = 0;
  802335:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80233b:	85 db                	test   %ebx,%ebx
  80233d:	74 eb                	je     80232a <ipc_recv+0x4c>
			*perm_store = 0;
  80233f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802345:	eb e3                	jmp    80232a <ipc_recv+0x4c>

00802347 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802347:	55                   	push   %ebp
  802348:	89 e5                	mov    %esp,%ebp
  80234a:	57                   	push   %edi
  80234b:	56                   	push   %esi
  80234c:	53                   	push   %ebx
  80234d:	83 ec 0c             	sub    $0xc,%esp
  802350:	8b 7d 08             	mov    0x8(%ebp),%edi
  802353:	8b 75 0c             	mov    0xc(%ebp),%esi
  802356:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802359:	85 db                	test   %ebx,%ebx
  80235b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802360:	0f 44 d8             	cmove  %eax,%ebx
  802363:	eb 05                	jmp    80236a <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802365:	e8 95 ea ff ff       	call   800dff <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80236a:	ff 75 14             	pushl  0x14(%ebp)
  80236d:	53                   	push   %ebx
  80236e:	56                   	push   %esi
  80236f:	57                   	push   %edi
  802370:	e8 36 ec ff ff       	call   800fab <sys_ipc_try_send>
  802375:	83 c4 10             	add    $0x10,%esp
  802378:	85 c0                	test   %eax,%eax
  80237a:	74 1b                	je     802397 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80237c:	79 e7                	jns    802365 <ipc_send+0x1e>
  80237e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802381:	74 e2                	je     802365 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802383:	83 ec 04             	sub    $0x4,%esp
  802386:	68 d7 2c 80 00       	push   $0x802cd7
  80238b:	6a 4a                	push   $0x4a
  80238d:	68 ec 2c 80 00       	push   $0x802cec
  802392:	e8 40 de ff ff       	call   8001d7 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802397:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80239a:	5b                   	pop    %ebx
  80239b:	5e                   	pop    %esi
  80239c:	5f                   	pop    %edi
  80239d:	5d                   	pop    %ebp
  80239e:	c3                   	ret    

0080239f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80239f:	55                   	push   %ebp
  8023a0:	89 e5                	mov    %esp,%ebp
  8023a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8023a5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8023aa:	89 c2                	mov    %eax,%edx
  8023ac:	c1 e2 07             	shl    $0x7,%edx
  8023af:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8023b5:	8b 52 50             	mov    0x50(%edx),%edx
  8023b8:	39 ca                	cmp    %ecx,%edx
  8023ba:	74 11                	je     8023cd <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8023bc:	83 c0 01             	add    $0x1,%eax
  8023bf:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023c4:	75 e4                	jne    8023aa <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8023c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023cb:	eb 0b                	jmp    8023d8 <ipc_find_env+0x39>
			return envs[i].env_id;
  8023cd:	c1 e0 07             	shl    $0x7,%eax
  8023d0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8023d5:	8b 40 48             	mov    0x48(%eax),%eax
}
  8023d8:	5d                   	pop    %ebp
  8023d9:	c3                   	ret    

008023da <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023da:	55                   	push   %ebp
  8023db:	89 e5                	mov    %esp,%ebp
  8023dd:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023e0:	89 d0                	mov    %edx,%eax
  8023e2:	c1 e8 16             	shr    $0x16,%eax
  8023e5:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023ec:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8023f1:	f6 c1 01             	test   $0x1,%cl
  8023f4:	74 1d                	je     802413 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8023f6:	c1 ea 0c             	shr    $0xc,%edx
  8023f9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802400:	f6 c2 01             	test   $0x1,%dl
  802403:	74 0e                	je     802413 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802405:	c1 ea 0c             	shr    $0xc,%edx
  802408:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80240f:	ef 
  802410:	0f b7 c0             	movzwl %ax,%eax
}
  802413:	5d                   	pop    %ebp
  802414:	c3                   	ret    
  802415:	66 90                	xchg   %ax,%ax
  802417:	66 90                	xchg   %ax,%ax
  802419:	66 90                	xchg   %ax,%ax
  80241b:	66 90                	xchg   %ax,%ax
  80241d:	66 90                	xchg   %ax,%ax
  80241f:	90                   	nop

00802420 <__udivdi3>:
  802420:	55                   	push   %ebp
  802421:	57                   	push   %edi
  802422:	56                   	push   %esi
  802423:	53                   	push   %ebx
  802424:	83 ec 1c             	sub    $0x1c,%esp
  802427:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80242b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80242f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802433:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802437:	85 d2                	test   %edx,%edx
  802439:	75 4d                	jne    802488 <__udivdi3+0x68>
  80243b:	39 f3                	cmp    %esi,%ebx
  80243d:	76 19                	jbe    802458 <__udivdi3+0x38>
  80243f:	31 ff                	xor    %edi,%edi
  802441:	89 e8                	mov    %ebp,%eax
  802443:	89 f2                	mov    %esi,%edx
  802445:	f7 f3                	div    %ebx
  802447:	89 fa                	mov    %edi,%edx
  802449:	83 c4 1c             	add    $0x1c,%esp
  80244c:	5b                   	pop    %ebx
  80244d:	5e                   	pop    %esi
  80244e:	5f                   	pop    %edi
  80244f:	5d                   	pop    %ebp
  802450:	c3                   	ret    
  802451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802458:	89 d9                	mov    %ebx,%ecx
  80245a:	85 db                	test   %ebx,%ebx
  80245c:	75 0b                	jne    802469 <__udivdi3+0x49>
  80245e:	b8 01 00 00 00       	mov    $0x1,%eax
  802463:	31 d2                	xor    %edx,%edx
  802465:	f7 f3                	div    %ebx
  802467:	89 c1                	mov    %eax,%ecx
  802469:	31 d2                	xor    %edx,%edx
  80246b:	89 f0                	mov    %esi,%eax
  80246d:	f7 f1                	div    %ecx
  80246f:	89 c6                	mov    %eax,%esi
  802471:	89 e8                	mov    %ebp,%eax
  802473:	89 f7                	mov    %esi,%edi
  802475:	f7 f1                	div    %ecx
  802477:	89 fa                	mov    %edi,%edx
  802479:	83 c4 1c             	add    $0x1c,%esp
  80247c:	5b                   	pop    %ebx
  80247d:	5e                   	pop    %esi
  80247e:	5f                   	pop    %edi
  80247f:	5d                   	pop    %ebp
  802480:	c3                   	ret    
  802481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802488:	39 f2                	cmp    %esi,%edx
  80248a:	77 1c                	ja     8024a8 <__udivdi3+0x88>
  80248c:	0f bd fa             	bsr    %edx,%edi
  80248f:	83 f7 1f             	xor    $0x1f,%edi
  802492:	75 2c                	jne    8024c0 <__udivdi3+0xa0>
  802494:	39 f2                	cmp    %esi,%edx
  802496:	72 06                	jb     80249e <__udivdi3+0x7e>
  802498:	31 c0                	xor    %eax,%eax
  80249a:	39 eb                	cmp    %ebp,%ebx
  80249c:	77 a9                	ja     802447 <__udivdi3+0x27>
  80249e:	b8 01 00 00 00       	mov    $0x1,%eax
  8024a3:	eb a2                	jmp    802447 <__udivdi3+0x27>
  8024a5:	8d 76 00             	lea    0x0(%esi),%esi
  8024a8:	31 ff                	xor    %edi,%edi
  8024aa:	31 c0                	xor    %eax,%eax
  8024ac:	89 fa                	mov    %edi,%edx
  8024ae:	83 c4 1c             	add    $0x1c,%esp
  8024b1:	5b                   	pop    %ebx
  8024b2:	5e                   	pop    %esi
  8024b3:	5f                   	pop    %edi
  8024b4:	5d                   	pop    %ebp
  8024b5:	c3                   	ret    
  8024b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024bd:	8d 76 00             	lea    0x0(%esi),%esi
  8024c0:	89 f9                	mov    %edi,%ecx
  8024c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8024c7:	29 f8                	sub    %edi,%eax
  8024c9:	d3 e2                	shl    %cl,%edx
  8024cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024cf:	89 c1                	mov    %eax,%ecx
  8024d1:	89 da                	mov    %ebx,%edx
  8024d3:	d3 ea                	shr    %cl,%edx
  8024d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024d9:	09 d1                	or     %edx,%ecx
  8024db:	89 f2                	mov    %esi,%edx
  8024dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024e1:	89 f9                	mov    %edi,%ecx
  8024e3:	d3 e3                	shl    %cl,%ebx
  8024e5:	89 c1                	mov    %eax,%ecx
  8024e7:	d3 ea                	shr    %cl,%edx
  8024e9:	89 f9                	mov    %edi,%ecx
  8024eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8024ef:	89 eb                	mov    %ebp,%ebx
  8024f1:	d3 e6                	shl    %cl,%esi
  8024f3:	89 c1                	mov    %eax,%ecx
  8024f5:	d3 eb                	shr    %cl,%ebx
  8024f7:	09 de                	or     %ebx,%esi
  8024f9:	89 f0                	mov    %esi,%eax
  8024fb:	f7 74 24 08          	divl   0x8(%esp)
  8024ff:	89 d6                	mov    %edx,%esi
  802501:	89 c3                	mov    %eax,%ebx
  802503:	f7 64 24 0c          	mull   0xc(%esp)
  802507:	39 d6                	cmp    %edx,%esi
  802509:	72 15                	jb     802520 <__udivdi3+0x100>
  80250b:	89 f9                	mov    %edi,%ecx
  80250d:	d3 e5                	shl    %cl,%ebp
  80250f:	39 c5                	cmp    %eax,%ebp
  802511:	73 04                	jae    802517 <__udivdi3+0xf7>
  802513:	39 d6                	cmp    %edx,%esi
  802515:	74 09                	je     802520 <__udivdi3+0x100>
  802517:	89 d8                	mov    %ebx,%eax
  802519:	31 ff                	xor    %edi,%edi
  80251b:	e9 27 ff ff ff       	jmp    802447 <__udivdi3+0x27>
  802520:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802523:	31 ff                	xor    %edi,%edi
  802525:	e9 1d ff ff ff       	jmp    802447 <__udivdi3+0x27>
  80252a:	66 90                	xchg   %ax,%ax
  80252c:	66 90                	xchg   %ax,%ax
  80252e:	66 90                	xchg   %ax,%ax

00802530 <__umoddi3>:
  802530:	55                   	push   %ebp
  802531:	57                   	push   %edi
  802532:	56                   	push   %esi
  802533:	53                   	push   %ebx
  802534:	83 ec 1c             	sub    $0x1c,%esp
  802537:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80253b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80253f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802543:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802547:	89 da                	mov    %ebx,%edx
  802549:	85 c0                	test   %eax,%eax
  80254b:	75 43                	jne    802590 <__umoddi3+0x60>
  80254d:	39 df                	cmp    %ebx,%edi
  80254f:	76 17                	jbe    802568 <__umoddi3+0x38>
  802551:	89 f0                	mov    %esi,%eax
  802553:	f7 f7                	div    %edi
  802555:	89 d0                	mov    %edx,%eax
  802557:	31 d2                	xor    %edx,%edx
  802559:	83 c4 1c             	add    $0x1c,%esp
  80255c:	5b                   	pop    %ebx
  80255d:	5e                   	pop    %esi
  80255e:	5f                   	pop    %edi
  80255f:	5d                   	pop    %ebp
  802560:	c3                   	ret    
  802561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802568:	89 fd                	mov    %edi,%ebp
  80256a:	85 ff                	test   %edi,%edi
  80256c:	75 0b                	jne    802579 <__umoddi3+0x49>
  80256e:	b8 01 00 00 00       	mov    $0x1,%eax
  802573:	31 d2                	xor    %edx,%edx
  802575:	f7 f7                	div    %edi
  802577:	89 c5                	mov    %eax,%ebp
  802579:	89 d8                	mov    %ebx,%eax
  80257b:	31 d2                	xor    %edx,%edx
  80257d:	f7 f5                	div    %ebp
  80257f:	89 f0                	mov    %esi,%eax
  802581:	f7 f5                	div    %ebp
  802583:	89 d0                	mov    %edx,%eax
  802585:	eb d0                	jmp    802557 <__umoddi3+0x27>
  802587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80258e:	66 90                	xchg   %ax,%ax
  802590:	89 f1                	mov    %esi,%ecx
  802592:	39 d8                	cmp    %ebx,%eax
  802594:	76 0a                	jbe    8025a0 <__umoddi3+0x70>
  802596:	89 f0                	mov    %esi,%eax
  802598:	83 c4 1c             	add    $0x1c,%esp
  80259b:	5b                   	pop    %ebx
  80259c:	5e                   	pop    %esi
  80259d:	5f                   	pop    %edi
  80259e:	5d                   	pop    %ebp
  80259f:	c3                   	ret    
  8025a0:	0f bd e8             	bsr    %eax,%ebp
  8025a3:	83 f5 1f             	xor    $0x1f,%ebp
  8025a6:	75 20                	jne    8025c8 <__umoddi3+0x98>
  8025a8:	39 d8                	cmp    %ebx,%eax
  8025aa:	0f 82 b0 00 00 00    	jb     802660 <__umoddi3+0x130>
  8025b0:	39 f7                	cmp    %esi,%edi
  8025b2:	0f 86 a8 00 00 00    	jbe    802660 <__umoddi3+0x130>
  8025b8:	89 c8                	mov    %ecx,%eax
  8025ba:	83 c4 1c             	add    $0x1c,%esp
  8025bd:	5b                   	pop    %ebx
  8025be:	5e                   	pop    %esi
  8025bf:	5f                   	pop    %edi
  8025c0:	5d                   	pop    %ebp
  8025c1:	c3                   	ret    
  8025c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025c8:	89 e9                	mov    %ebp,%ecx
  8025ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8025cf:	29 ea                	sub    %ebp,%edx
  8025d1:	d3 e0                	shl    %cl,%eax
  8025d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025d7:	89 d1                	mov    %edx,%ecx
  8025d9:	89 f8                	mov    %edi,%eax
  8025db:	d3 e8                	shr    %cl,%eax
  8025dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025e9:	09 c1                	or     %eax,%ecx
  8025eb:	89 d8                	mov    %ebx,%eax
  8025ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025f1:	89 e9                	mov    %ebp,%ecx
  8025f3:	d3 e7                	shl    %cl,%edi
  8025f5:	89 d1                	mov    %edx,%ecx
  8025f7:	d3 e8                	shr    %cl,%eax
  8025f9:	89 e9                	mov    %ebp,%ecx
  8025fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025ff:	d3 e3                	shl    %cl,%ebx
  802601:	89 c7                	mov    %eax,%edi
  802603:	89 d1                	mov    %edx,%ecx
  802605:	89 f0                	mov    %esi,%eax
  802607:	d3 e8                	shr    %cl,%eax
  802609:	89 e9                	mov    %ebp,%ecx
  80260b:	89 fa                	mov    %edi,%edx
  80260d:	d3 e6                	shl    %cl,%esi
  80260f:	09 d8                	or     %ebx,%eax
  802611:	f7 74 24 08          	divl   0x8(%esp)
  802615:	89 d1                	mov    %edx,%ecx
  802617:	89 f3                	mov    %esi,%ebx
  802619:	f7 64 24 0c          	mull   0xc(%esp)
  80261d:	89 c6                	mov    %eax,%esi
  80261f:	89 d7                	mov    %edx,%edi
  802621:	39 d1                	cmp    %edx,%ecx
  802623:	72 06                	jb     80262b <__umoddi3+0xfb>
  802625:	75 10                	jne    802637 <__umoddi3+0x107>
  802627:	39 c3                	cmp    %eax,%ebx
  802629:	73 0c                	jae    802637 <__umoddi3+0x107>
  80262b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80262f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802633:	89 d7                	mov    %edx,%edi
  802635:	89 c6                	mov    %eax,%esi
  802637:	89 ca                	mov    %ecx,%edx
  802639:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80263e:	29 f3                	sub    %esi,%ebx
  802640:	19 fa                	sbb    %edi,%edx
  802642:	89 d0                	mov    %edx,%eax
  802644:	d3 e0                	shl    %cl,%eax
  802646:	89 e9                	mov    %ebp,%ecx
  802648:	d3 eb                	shr    %cl,%ebx
  80264a:	d3 ea                	shr    %cl,%edx
  80264c:	09 d8                	or     %ebx,%eax
  80264e:	83 c4 1c             	add    $0x1c,%esp
  802651:	5b                   	pop    %ebx
  802652:	5e                   	pop    %esi
  802653:	5f                   	pop    %edi
  802654:	5d                   	pop    %ebp
  802655:	c3                   	ret    
  802656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80265d:	8d 76 00             	lea    0x0(%esi),%esi
  802660:	89 da                	mov    %ebx,%edx
  802662:	29 fe                	sub    %edi,%esi
  802664:	19 c2                	sbb    %eax,%edx
  802666:	89 f1                	mov    %esi,%ecx
  802668:	89 c8                	mov    %ecx,%eax
  80266a:	e9 4b ff ff ff       	jmp    8025ba <__umoddi3+0x8a>
