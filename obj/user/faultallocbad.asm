
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
  80003a:	68 88 27 80 00       	push   $0x802788
  80003f:	68 60 26 80 00       	push   $0x802660
  800044:	e8 6c 02 00 00       	call   8002b5 <cprintf>
	int r;
	void *addr = (void*)utf->utf_fault_va;
  800049:	8b 45 08             	mov    0x8(%ebp),%eax
  80004c:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  80004e:	83 c4 08             	add    $0x8,%esp
  800051:	53                   	push   %ebx
  800052:	68 46 27 80 00       	push   $0x802746
  800057:	e8 59 02 00 00       	call   8002b5 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80005c:	83 c4 0c             	add    $0xc,%esp
  80005f:	6a 07                	push   $0x7
  800061:	89 d8                	mov    %ebx,%eax
  800063:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800068:	50                   	push   %eax
  800069:	6a 00                	push   $0x0
  80006b:	e8 96 0d 00 00       	call   800e06 <sys_page_alloc>
  800070:	83 c4 10             	add    $0x10,%esp
  800073:	85 c0                	test   %eax,%eax
  800075:	78 16                	js     80008d <handler+0x5a>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800077:	53                   	push   %ebx
  800078:	68 b8 26 80 00       	push   $0x8026b8
  80007d:	6a 64                	push   $0x64
  80007f:	53                   	push   %ebx
  800080:	e8 3c 09 00 00       	call   8009c1 <snprintf>
}
  800085:	83 c4 10             	add    $0x10,%esp
  800088:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80008b:	c9                   	leave  
  80008c:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80008d:	83 ec 0c             	sub    $0xc,%esp
  800090:	50                   	push   %eax
  800091:	53                   	push   %ebx
  800092:	68 8c 26 80 00       	push   $0x80268c
  800097:	6a 10                	push   $0x10
  800099:	68 50 27 80 00       	push   $0x802750
  80009e:	e8 1c 01 00 00       	call   8001bf <_panic>

008000a3 <umain>:

void
umain(int argc, char **argv)
{
  8000a3:	55                   	push   %ebp
  8000a4:	89 e5                	mov    %esp,%ebp
  8000a6:	83 ec 14             	sub    $0x14,%esp
	cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8000a9:	68 dc 26 80 00       	push   $0x8026dc
  8000ae:	e8 02 02 00 00       	call   8002b5 <cprintf>
	cprintf("before set_pgfault_handler() in %s\n", __FUNCTION__);
  8000b3:	83 c4 08             	add    $0x8,%esp
  8000b6:	68 80 27 80 00       	push   $0x802780
  8000bb:	68 00 27 80 00       	push   $0x802700
  8000c0:	e8 f0 01 00 00       	call   8002b5 <cprintf>
	set_pgfault_handler(handler);
  8000c5:	c7 04 24 33 00 80 00 	movl   $0x800033,(%esp)
  8000cc:	e8 0a 10 00 00       	call   8010db <set_pgfault_handler>
	cprintf(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
  8000d1:	c7 04 24 24 27 80 00 	movl   $0x802724,(%esp)
  8000d8:	e8 d8 01 00 00       	call   8002b5 <cprintf>
	cprintf("before sys_cputs() in %s\n", __FUNCTION__);
  8000dd:	83 c4 08             	add    $0x8,%esp
  8000e0:	68 80 27 80 00       	push   $0x802780
  8000e5:	68 65 27 80 00       	push   $0x802765
  8000ea:	e8 c6 01 00 00       	call   8002b5 <cprintf>
	sys_cputs((char*)0xDEADBEEF, 4);
  8000ef:	83 c4 08             	add    $0x8,%esp
  8000f2:	6a 04                	push   $0x4
  8000f4:	68 ef be ad de       	push   $0xdeadbeef
  8000f9:	e8 4c 0c 00 00       	call   800d4a <sys_cputs>
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
  800116:	e8 ad 0c 00 00       	call   800dc8 <sys_getenvid>
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

	cprintf("in libmain.c call umain!\n");
  80017a:	83 ec 0c             	sub    $0xc,%esp
  80017d:	68 90 27 80 00       	push   $0x802790
  800182:	e8 2e 01 00 00       	call   8002b5 <cprintf>
	// call user main routine
	umain(argc, argv);
  800187:	83 c4 08             	add    $0x8,%esp
  80018a:	ff 75 0c             	pushl  0xc(%ebp)
  80018d:	ff 75 08             	pushl  0x8(%ebp)
  800190:	e8 0e ff ff ff       	call   8000a3 <umain>

	// exit gracefully
	exit();
  800195:	e8 0b 00 00 00       	call   8001a5 <exit>
}
  80019a:	83 c4 10             	add    $0x10,%esp
  80019d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a0:	5b                   	pop    %ebx
  8001a1:	5e                   	pop    %esi
  8001a2:	5f                   	pop    %edi
  8001a3:	5d                   	pop    %ebp
  8001a4:	c3                   	ret    

008001a5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001a5:	55                   	push   %ebp
  8001a6:	89 e5                	mov    %esp,%ebp
  8001a8:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001ab:	e8 98 11 00 00       	call   801348 <close_all>
	sys_env_destroy(0);
  8001b0:	83 ec 0c             	sub    $0xc,%esp
  8001b3:	6a 00                	push   $0x0
  8001b5:	e8 cd 0b 00 00       	call   800d87 <sys_env_destroy>
}
  8001ba:	83 c4 10             	add    $0x10,%esp
  8001bd:	c9                   	leave  
  8001be:	c3                   	ret    

008001bf <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001bf:	55                   	push   %ebp
  8001c0:	89 e5                	mov    %esp,%ebp
  8001c2:	56                   	push   %esi
  8001c3:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001c4:	a1 08 40 80 00       	mov    0x804008,%eax
  8001c9:	8b 40 48             	mov    0x48(%eax),%eax
  8001cc:	83 ec 04             	sub    $0x4,%esp
  8001cf:	68 e4 27 80 00       	push   $0x8027e4
  8001d4:	50                   	push   %eax
  8001d5:	68 b4 27 80 00       	push   $0x8027b4
  8001da:	e8 d6 00 00 00       	call   8002b5 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8001df:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001e2:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8001e8:	e8 db 0b 00 00       	call   800dc8 <sys_getenvid>
  8001ed:	83 c4 04             	add    $0x4,%esp
  8001f0:	ff 75 0c             	pushl  0xc(%ebp)
  8001f3:	ff 75 08             	pushl  0x8(%ebp)
  8001f6:	56                   	push   %esi
  8001f7:	50                   	push   %eax
  8001f8:	68 c0 27 80 00       	push   $0x8027c0
  8001fd:	e8 b3 00 00 00       	call   8002b5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800202:	83 c4 18             	add    $0x18,%esp
  800205:	53                   	push   %ebx
  800206:	ff 75 10             	pushl  0x10(%ebp)
  800209:	e8 56 00 00 00       	call   800264 <vcprintf>
	cprintf("\n");
  80020e:	c7 04 24 a8 27 80 00 	movl   $0x8027a8,(%esp)
  800215:	e8 9b 00 00 00       	call   8002b5 <cprintf>
  80021a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80021d:	cc                   	int3   
  80021e:	eb fd                	jmp    80021d <_panic+0x5e>

00800220 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	53                   	push   %ebx
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80022a:	8b 13                	mov    (%ebx),%edx
  80022c:	8d 42 01             	lea    0x1(%edx),%eax
  80022f:	89 03                	mov    %eax,(%ebx)
  800231:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800234:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800238:	3d ff 00 00 00       	cmp    $0xff,%eax
  80023d:	74 09                	je     800248 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80023f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800243:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800246:	c9                   	leave  
  800247:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800248:	83 ec 08             	sub    $0x8,%esp
  80024b:	68 ff 00 00 00       	push   $0xff
  800250:	8d 43 08             	lea    0x8(%ebx),%eax
  800253:	50                   	push   %eax
  800254:	e8 f1 0a 00 00       	call   800d4a <sys_cputs>
		b->idx = 0;
  800259:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80025f:	83 c4 10             	add    $0x10,%esp
  800262:	eb db                	jmp    80023f <putch+0x1f>

00800264 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800264:	55                   	push   %ebp
  800265:	89 e5                	mov    %esp,%ebp
  800267:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80026d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800274:	00 00 00 
	b.cnt = 0;
  800277:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80027e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800281:	ff 75 0c             	pushl  0xc(%ebp)
  800284:	ff 75 08             	pushl  0x8(%ebp)
  800287:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80028d:	50                   	push   %eax
  80028e:	68 20 02 80 00       	push   $0x800220
  800293:	e8 4a 01 00 00       	call   8003e2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800298:	83 c4 08             	add    $0x8,%esp
  80029b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002a1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002a7:	50                   	push   %eax
  8002a8:	e8 9d 0a 00 00       	call   800d4a <sys_cputs>

	return b.cnt;
}
  8002ad:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002b3:	c9                   	leave  
  8002b4:	c3                   	ret    

008002b5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
  8002b8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002bb:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002be:	50                   	push   %eax
  8002bf:	ff 75 08             	pushl  0x8(%ebp)
  8002c2:	e8 9d ff ff ff       	call   800264 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002c7:	c9                   	leave  
  8002c8:	c3                   	ret    

008002c9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002c9:	55                   	push   %ebp
  8002ca:	89 e5                	mov    %esp,%ebp
  8002cc:	57                   	push   %edi
  8002cd:	56                   	push   %esi
  8002ce:	53                   	push   %ebx
  8002cf:	83 ec 1c             	sub    $0x1c,%esp
  8002d2:	89 c6                	mov    %eax,%esi
  8002d4:	89 d7                	mov    %edx,%edi
  8002d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002df:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e5:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8002e8:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002ec:	74 2c                	je     80031a <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8002ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002f1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002fb:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002fe:	39 c2                	cmp    %eax,%edx
  800300:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800303:	73 43                	jae    800348 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800305:	83 eb 01             	sub    $0x1,%ebx
  800308:	85 db                	test   %ebx,%ebx
  80030a:	7e 6c                	jle    800378 <printnum+0xaf>
				putch(padc, putdat);
  80030c:	83 ec 08             	sub    $0x8,%esp
  80030f:	57                   	push   %edi
  800310:	ff 75 18             	pushl  0x18(%ebp)
  800313:	ff d6                	call   *%esi
  800315:	83 c4 10             	add    $0x10,%esp
  800318:	eb eb                	jmp    800305 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80031a:	83 ec 0c             	sub    $0xc,%esp
  80031d:	6a 20                	push   $0x20
  80031f:	6a 00                	push   $0x0
  800321:	50                   	push   %eax
  800322:	ff 75 e4             	pushl  -0x1c(%ebp)
  800325:	ff 75 e0             	pushl  -0x20(%ebp)
  800328:	89 fa                	mov    %edi,%edx
  80032a:	89 f0                	mov    %esi,%eax
  80032c:	e8 98 ff ff ff       	call   8002c9 <printnum>
		while (--width > 0)
  800331:	83 c4 20             	add    $0x20,%esp
  800334:	83 eb 01             	sub    $0x1,%ebx
  800337:	85 db                	test   %ebx,%ebx
  800339:	7e 65                	jle    8003a0 <printnum+0xd7>
			putch(padc, putdat);
  80033b:	83 ec 08             	sub    $0x8,%esp
  80033e:	57                   	push   %edi
  80033f:	6a 20                	push   $0x20
  800341:	ff d6                	call   *%esi
  800343:	83 c4 10             	add    $0x10,%esp
  800346:	eb ec                	jmp    800334 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800348:	83 ec 0c             	sub    $0xc,%esp
  80034b:	ff 75 18             	pushl  0x18(%ebp)
  80034e:	83 eb 01             	sub    $0x1,%ebx
  800351:	53                   	push   %ebx
  800352:	50                   	push   %eax
  800353:	83 ec 08             	sub    $0x8,%esp
  800356:	ff 75 dc             	pushl  -0x24(%ebp)
  800359:	ff 75 d8             	pushl  -0x28(%ebp)
  80035c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80035f:	ff 75 e0             	pushl  -0x20(%ebp)
  800362:	e8 99 20 00 00       	call   802400 <__udivdi3>
  800367:	83 c4 18             	add    $0x18,%esp
  80036a:	52                   	push   %edx
  80036b:	50                   	push   %eax
  80036c:	89 fa                	mov    %edi,%edx
  80036e:	89 f0                	mov    %esi,%eax
  800370:	e8 54 ff ff ff       	call   8002c9 <printnum>
  800375:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800378:	83 ec 08             	sub    $0x8,%esp
  80037b:	57                   	push   %edi
  80037c:	83 ec 04             	sub    $0x4,%esp
  80037f:	ff 75 dc             	pushl  -0x24(%ebp)
  800382:	ff 75 d8             	pushl  -0x28(%ebp)
  800385:	ff 75 e4             	pushl  -0x1c(%ebp)
  800388:	ff 75 e0             	pushl  -0x20(%ebp)
  80038b:	e8 80 21 00 00       	call   802510 <__umoddi3>
  800390:	83 c4 14             	add    $0x14,%esp
  800393:	0f be 80 eb 27 80 00 	movsbl 0x8027eb(%eax),%eax
  80039a:	50                   	push   %eax
  80039b:	ff d6                	call   *%esi
  80039d:	83 c4 10             	add    $0x10,%esp
	}
}
  8003a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003a3:	5b                   	pop    %ebx
  8003a4:	5e                   	pop    %esi
  8003a5:	5f                   	pop    %edi
  8003a6:	5d                   	pop    %ebp
  8003a7:	c3                   	ret    

008003a8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003ae:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003b2:	8b 10                	mov    (%eax),%edx
  8003b4:	3b 50 04             	cmp    0x4(%eax),%edx
  8003b7:	73 0a                	jae    8003c3 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003b9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003bc:	89 08                	mov    %ecx,(%eax)
  8003be:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c1:	88 02                	mov    %al,(%edx)
}
  8003c3:	5d                   	pop    %ebp
  8003c4:	c3                   	ret    

008003c5 <printfmt>:
{
  8003c5:	55                   	push   %ebp
  8003c6:	89 e5                	mov    %esp,%ebp
  8003c8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003cb:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003ce:	50                   	push   %eax
  8003cf:	ff 75 10             	pushl  0x10(%ebp)
  8003d2:	ff 75 0c             	pushl  0xc(%ebp)
  8003d5:	ff 75 08             	pushl  0x8(%ebp)
  8003d8:	e8 05 00 00 00       	call   8003e2 <vprintfmt>
}
  8003dd:	83 c4 10             	add    $0x10,%esp
  8003e0:	c9                   	leave  
  8003e1:	c3                   	ret    

008003e2 <vprintfmt>:
{
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	57                   	push   %edi
  8003e6:	56                   	push   %esi
  8003e7:	53                   	push   %ebx
  8003e8:	83 ec 3c             	sub    $0x3c,%esp
  8003eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8003ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003f1:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003f4:	e9 32 04 00 00       	jmp    80082b <vprintfmt+0x449>
		padc = ' ';
  8003f9:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003fd:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800404:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80040b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800412:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800419:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800420:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800425:	8d 47 01             	lea    0x1(%edi),%eax
  800428:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80042b:	0f b6 17             	movzbl (%edi),%edx
  80042e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800431:	3c 55                	cmp    $0x55,%al
  800433:	0f 87 12 05 00 00    	ja     80094b <vprintfmt+0x569>
  800439:	0f b6 c0             	movzbl %al,%eax
  80043c:	ff 24 85 c0 29 80 00 	jmp    *0x8029c0(,%eax,4)
  800443:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800446:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80044a:	eb d9                	jmp    800425 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80044c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80044f:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800453:	eb d0                	jmp    800425 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800455:	0f b6 d2             	movzbl %dl,%edx
  800458:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80045b:	b8 00 00 00 00       	mov    $0x0,%eax
  800460:	89 75 08             	mov    %esi,0x8(%ebp)
  800463:	eb 03                	jmp    800468 <vprintfmt+0x86>
  800465:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800468:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80046b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80046f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800472:	8d 72 d0             	lea    -0x30(%edx),%esi
  800475:	83 fe 09             	cmp    $0x9,%esi
  800478:	76 eb                	jbe    800465 <vprintfmt+0x83>
  80047a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80047d:	8b 75 08             	mov    0x8(%ebp),%esi
  800480:	eb 14                	jmp    800496 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800482:	8b 45 14             	mov    0x14(%ebp),%eax
  800485:	8b 00                	mov    (%eax),%eax
  800487:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80048a:	8b 45 14             	mov    0x14(%ebp),%eax
  80048d:	8d 40 04             	lea    0x4(%eax),%eax
  800490:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800493:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800496:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80049a:	79 89                	jns    800425 <vprintfmt+0x43>
				width = precision, precision = -1;
  80049c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80049f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004a9:	e9 77 ff ff ff       	jmp    800425 <vprintfmt+0x43>
  8004ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004b1:	85 c0                	test   %eax,%eax
  8004b3:	0f 48 c1             	cmovs  %ecx,%eax
  8004b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004b9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004bc:	e9 64 ff ff ff       	jmp    800425 <vprintfmt+0x43>
  8004c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004c4:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004cb:	e9 55 ff ff ff       	jmp    800425 <vprintfmt+0x43>
			lflag++;
  8004d0:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004d7:	e9 49 ff ff ff       	jmp    800425 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004df:	8d 78 04             	lea    0x4(%eax),%edi
  8004e2:	83 ec 08             	sub    $0x8,%esp
  8004e5:	53                   	push   %ebx
  8004e6:	ff 30                	pushl  (%eax)
  8004e8:	ff d6                	call   *%esi
			break;
  8004ea:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004ed:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004f0:	e9 33 03 00 00       	jmp    800828 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f8:	8d 78 04             	lea    0x4(%eax),%edi
  8004fb:	8b 00                	mov    (%eax),%eax
  8004fd:	99                   	cltd   
  8004fe:	31 d0                	xor    %edx,%eax
  800500:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800502:	83 f8 10             	cmp    $0x10,%eax
  800505:	7f 23                	jg     80052a <vprintfmt+0x148>
  800507:	8b 14 85 20 2b 80 00 	mov    0x802b20(,%eax,4),%edx
  80050e:	85 d2                	test   %edx,%edx
  800510:	74 18                	je     80052a <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800512:	52                   	push   %edx
  800513:	68 b5 2c 80 00       	push   $0x802cb5
  800518:	53                   	push   %ebx
  800519:	56                   	push   %esi
  80051a:	e8 a6 fe ff ff       	call   8003c5 <printfmt>
  80051f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800522:	89 7d 14             	mov    %edi,0x14(%ebp)
  800525:	e9 fe 02 00 00       	jmp    800828 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80052a:	50                   	push   %eax
  80052b:	68 03 28 80 00       	push   $0x802803
  800530:	53                   	push   %ebx
  800531:	56                   	push   %esi
  800532:	e8 8e fe ff ff       	call   8003c5 <printfmt>
  800537:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80053a:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80053d:	e9 e6 02 00 00       	jmp    800828 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800542:	8b 45 14             	mov    0x14(%ebp),%eax
  800545:	83 c0 04             	add    $0x4,%eax
  800548:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80054b:	8b 45 14             	mov    0x14(%ebp),%eax
  80054e:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800550:	85 c9                	test   %ecx,%ecx
  800552:	b8 fc 27 80 00       	mov    $0x8027fc,%eax
  800557:	0f 45 c1             	cmovne %ecx,%eax
  80055a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80055d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800561:	7e 06                	jle    800569 <vprintfmt+0x187>
  800563:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800567:	75 0d                	jne    800576 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800569:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80056c:	89 c7                	mov    %eax,%edi
  80056e:	03 45 e0             	add    -0x20(%ebp),%eax
  800571:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800574:	eb 53                	jmp    8005c9 <vprintfmt+0x1e7>
  800576:	83 ec 08             	sub    $0x8,%esp
  800579:	ff 75 d8             	pushl  -0x28(%ebp)
  80057c:	50                   	push   %eax
  80057d:	e8 71 04 00 00       	call   8009f3 <strnlen>
  800582:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800585:	29 c1                	sub    %eax,%ecx
  800587:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80058a:	83 c4 10             	add    $0x10,%esp
  80058d:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80058f:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800593:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800596:	eb 0f                	jmp    8005a7 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800598:	83 ec 08             	sub    $0x8,%esp
  80059b:	53                   	push   %ebx
  80059c:	ff 75 e0             	pushl  -0x20(%ebp)
  80059f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a1:	83 ef 01             	sub    $0x1,%edi
  8005a4:	83 c4 10             	add    $0x10,%esp
  8005a7:	85 ff                	test   %edi,%edi
  8005a9:	7f ed                	jg     800598 <vprintfmt+0x1b6>
  8005ab:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8005ae:	85 c9                	test   %ecx,%ecx
  8005b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b5:	0f 49 c1             	cmovns %ecx,%eax
  8005b8:	29 c1                	sub    %eax,%ecx
  8005ba:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005bd:	eb aa                	jmp    800569 <vprintfmt+0x187>
					putch(ch, putdat);
  8005bf:	83 ec 08             	sub    $0x8,%esp
  8005c2:	53                   	push   %ebx
  8005c3:	52                   	push   %edx
  8005c4:	ff d6                	call   *%esi
  8005c6:	83 c4 10             	add    $0x10,%esp
  8005c9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005cc:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005ce:	83 c7 01             	add    $0x1,%edi
  8005d1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005d5:	0f be d0             	movsbl %al,%edx
  8005d8:	85 d2                	test   %edx,%edx
  8005da:	74 4b                	je     800627 <vprintfmt+0x245>
  8005dc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005e0:	78 06                	js     8005e8 <vprintfmt+0x206>
  8005e2:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005e6:	78 1e                	js     800606 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8005e8:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005ec:	74 d1                	je     8005bf <vprintfmt+0x1dd>
  8005ee:	0f be c0             	movsbl %al,%eax
  8005f1:	83 e8 20             	sub    $0x20,%eax
  8005f4:	83 f8 5e             	cmp    $0x5e,%eax
  8005f7:	76 c6                	jbe    8005bf <vprintfmt+0x1dd>
					putch('?', putdat);
  8005f9:	83 ec 08             	sub    $0x8,%esp
  8005fc:	53                   	push   %ebx
  8005fd:	6a 3f                	push   $0x3f
  8005ff:	ff d6                	call   *%esi
  800601:	83 c4 10             	add    $0x10,%esp
  800604:	eb c3                	jmp    8005c9 <vprintfmt+0x1e7>
  800606:	89 cf                	mov    %ecx,%edi
  800608:	eb 0e                	jmp    800618 <vprintfmt+0x236>
				putch(' ', putdat);
  80060a:	83 ec 08             	sub    $0x8,%esp
  80060d:	53                   	push   %ebx
  80060e:	6a 20                	push   $0x20
  800610:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800612:	83 ef 01             	sub    $0x1,%edi
  800615:	83 c4 10             	add    $0x10,%esp
  800618:	85 ff                	test   %edi,%edi
  80061a:	7f ee                	jg     80060a <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80061c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80061f:	89 45 14             	mov    %eax,0x14(%ebp)
  800622:	e9 01 02 00 00       	jmp    800828 <vprintfmt+0x446>
  800627:	89 cf                	mov    %ecx,%edi
  800629:	eb ed                	jmp    800618 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80062b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80062e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800635:	e9 eb fd ff ff       	jmp    800425 <vprintfmt+0x43>
	if (lflag >= 2)
  80063a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80063e:	7f 21                	jg     800661 <vprintfmt+0x27f>
	else if (lflag)
  800640:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800644:	74 68                	je     8006ae <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8b 00                	mov    (%eax),%eax
  80064b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80064e:	89 c1                	mov    %eax,%ecx
  800650:	c1 f9 1f             	sar    $0x1f,%ecx
  800653:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800656:	8b 45 14             	mov    0x14(%ebp),%eax
  800659:	8d 40 04             	lea    0x4(%eax),%eax
  80065c:	89 45 14             	mov    %eax,0x14(%ebp)
  80065f:	eb 17                	jmp    800678 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	8b 50 04             	mov    0x4(%eax),%edx
  800667:	8b 00                	mov    (%eax),%eax
  800669:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80066c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  80066f:	8b 45 14             	mov    0x14(%ebp),%eax
  800672:	8d 40 08             	lea    0x8(%eax),%eax
  800675:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800678:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80067b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80067e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800681:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800684:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800688:	78 3f                	js     8006c9 <vprintfmt+0x2e7>
			base = 10;
  80068a:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80068f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800693:	0f 84 71 01 00 00    	je     80080a <vprintfmt+0x428>
				putch('+', putdat);
  800699:	83 ec 08             	sub    $0x8,%esp
  80069c:	53                   	push   %ebx
  80069d:	6a 2b                	push   $0x2b
  80069f:	ff d6                	call   *%esi
  8006a1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006a4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a9:	e9 5c 01 00 00       	jmp    80080a <vprintfmt+0x428>
		return va_arg(*ap, int);
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	8b 00                	mov    (%eax),%eax
  8006b3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006b6:	89 c1                	mov    %eax,%ecx
  8006b8:	c1 f9 1f             	sar    $0x1f,%ecx
  8006bb:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006be:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c1:	8d 40 04             	lea    0x4(%eax),%eax
  8006c4:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c7:	eb af                	jmp    800678 <vprintfmt+0x296>
				putch('-', putdat);
  8006c9:	83 ec 08             	sub    $0x8,%esp
  8006cc:	53                   	push   %ebx
  8006cd:	6a 2d                	push   $0x2d
  8006cf:	ff d6                	call   *%esi
				num = -(long long) num;
  8006d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006d7:	f7 d8                	neg    %eax
  8006d9:	83 d2 00             	adc    $0x0,%edx
  8006dc:	f7 da                	neg    %edx
  8006de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006e7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ec:	e9 19 01 00 00       	jmp    80080a <vprintfmt+0x428>
	if (lflag >= 2)
  8006f1:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006f5:	7f 29                	jg     800720 <vprintfmt+0x33e>
	else if (lflag)
  8006f7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006fb:	74 44                	je     800741 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	8b 00                	mov    (%eax),%eax
  800702:	ba 00 00 00 00       	mov    $0x0,%edx
  800707:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80070a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80070d:	8b 45 14             	mov    0x14(%ebp),%eax
  800710:	8d 40 04             	lea    0x4(%eax),%eax
  800713:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800716:	b8 0a 00 00 00       	mov    $0xa,%eax
  80071b:	e9 ea 00 00 00       	jmp    80080a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800720:	8b 45 14             	mov    0x14(%ebp),%eax
  800723:	8b 50 04             	mov    0x4(%eax),%edx
  800726:	8b 00                	mov    (%eax),%eax
  800728:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	8d 40 08             	lea    0x8(%eax),%eax
  800734:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800737:	b8 0a 00 00 00       	mov    $0xa,%eax
  80073c:	e9 c9 00 00 00       	jmp    80080a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	8b 00                	mov    (%eax),%eax
  800746:	ba 00 00 00 00       	mov    $0x0,%edx
  80074b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	8d 40 04             	lea    0x4(%eax),%eax
  800757:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80075a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80075f:	e9 a6 00 00 00       	jmp    80080a <vprintfmt+0x428>
			putch('0', putdat);
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	53                   	push   %ebx
  800768:	6a 30                	push   $0x30
  80076a:	ff d6                	call   *%esi
	if (lflag >= 2)
  80076c:	83 c4 10             	add    $0x10,%esp
  80076f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800773:	7f 26                	jg     80079b <vprintfmt+0x3b9>
	else if (lflag)
  800775:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800779:	74 3e                	je     8007b9 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80077b:	8b 45 14             	mov    0x14(%ebp),%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	ba 00 00 00 00       	mov    $0x0,%edx
  800785:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800788:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078b:	8b 45 14             	mov    0x14(%ebp),%eax
  80078e:	8d 40 04             	lea    0x4(%eax),%eax
  800791:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800794:	b8 08 00 00 00       	mov    $0x8,%eax
  800799:	eb 6f                	jmp    80080a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80079b:	8b 45 14             	mov    0x14(%ebp),%eax
  80079e:	8b 50 04             	mov    0x4(%eax),%edx
  8007a1:	8b 00                	mov    (%eax),%eax
  8007a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ac:	8d 40 08             	lea    0x8(%eax),%eax
  8007af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007b2:	b8 08 00 00 00       	mov    $0x8,%eax
  8007b7:	eb 51                	jmp    80080a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bc:	8b 00                	mov    (%eax),%eax
  8007be:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	8d 40 04             	lea    0x4(%eax),%eax
  8007cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007d2:	b8 08 00 00 00       	mov    $0x8,%eax
  8007d7:	eb 31                	jmp    80080a <vprintfmt+0x428>
			putch('0', putdat);
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	53                   	push   %ebx
  8007dd:	6a 30                	push   $0x30
  8007df:	ff d6                	call   *%esi
			putch('x', putdat);
  8007e1:	83 c4 08             	add    $0x8,%esp
  8007e4:	53                   	push   %ebx
  8007e5:	6a 78                	push   $0x78
  8007e7:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ec:	8b 00                	mov    (%eax),%eax
  8007ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f6:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007f9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ff:	8d 40 04             	lea    0x4(%eax),%eax
  800802:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800805:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80080a:	83 ec 0c             	sub    $0xc,%esp
  80080d:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800811:	52                   	push   %edx
  800812:	ff 75 e0             	pushl  -0x20(%ebp)
  800815:	50                   	push   %eax
  800816:	ff 75 dc             	pushl  -0x24(%ebp)
  800819:	ff 75 d8             	pushl  -0x28(%ebp)
  80081c:	89 da                	mov    %ebx,%edx
  80081e:	89 f0                	mov    %esi,%eax
  800820:	e8 a4 fa ff ff       	call   8002c9 <printnum>
			break;
  800825:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800828:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80082b:	83 c7 01             	add    $0x1,%edi
  80082e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800832:	83 f8 25             	cmp    $0x25,%eax
  800835:	0f 84 be fb ff ff    	je     8003f9 <vprintfmt+0x17>
			if (ch == '\0')
  80083b:	85 c0                	test   %eax,%eax
  80083d:	0f 84 28 01 00 00    	je     80096b <vprintfmt+0x589>
			putch(ch, putdat);
  800843:	83 ec 08             	sub    $0x8,%esp
  800846:	53                   	push   %ebx
  800847:	50                   	push   %eax
  800848:	ff d6                	call   *%esi
  80084a:	83 c4 10             	add    $0x10,%esp
  80084d:	eb dc                	jmp    80082b <vprintfmt+0x449>
	if (lflag >= 2)
  80084f:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800853:	7f 26                	jg     80087b <vprintfmt+0x499>
	else if (lflag)
  800855:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800859:	74 41                	je     80089c <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80085b:	8b 45 14             	mov    0x14(%ebp),%eax
  80085e:	8b 00                	mov    (%eax),%eax
  800860:	ba 00 00 00 00       	mov    $0x0,%edx
  800865:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800868:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80086b:	8b 45 14             	mov    0x14(%ebp),%eax
  80086e:	8d 40 04             	lea    0x4(%eax),%eax
  800871:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800874:	b8 10 00 00 00       	mov    $0x10,%eax
  800879:	eb 8f                	jmp    80080a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80087b:	8b 45 14             	mov    0x14(%ebp),%eax
  80087e:	8b 50 04             	mov    0x4(%eax),%edx
  800881:	8b 00                	mov    (%eax),%eax
  800883:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800886:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800889:	8b 45 14             	mov    0x14(%ebp),%eax
  80088c:	8d 40 08             	lea    0x8(%eax),%eax
  80088f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800892:	b8 10 00 00 00       	mov    $0x10,%eax
  800897:	e9 6e ff ff ff       	jmp    80080a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	8b 00                	mov    (%eax),%eax
  8008a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8008af:	8d 40 04             	lea    0x4(%eax),%eax
  8008b2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008b5:	b8 10 00 00 00       	mov    $0x10,%eax
  8008ba:	e9 4b ff ff ff       	jmp    80080a <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8008bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c2:	83 c0 04             	add    $0x4,%eax
  8008c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cb:	8b 00                	mov    (%eax),%eax
  8008cd:	85 c0                	test   %eax,%eax
  8008cf:	74 14                	je     8008e5 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8008d1:	8b 13                	mov    (%ebx),%edx
  8008d3:	83 fa 7f             	cmp    $0x7f,%edx
  8008d6:	7f 37                	jg     80090f <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8008d8:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8008da:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e0:	e9 43 ff ff ff       	jmp    800828 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8008e5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008ea:	bf 21 29 80 00       	mov    $0x802921,%edi
							putch(ch, putdat);
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	53                   	push   %ebx
  8008f3:	50                   	push   %eax
  8008f4:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008f6:	83 c7 01             	add    $0x1,%edi
  8008f9:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008fd:	83 c4 10             	add    $0x10,%esp
  800900:	85 c0                	test   %eax,%eax
  800902:	75 eb                	jne    8008ef <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800904:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800907:	89 45 14             	mov    %eax,0x14(%ebp)
  80090a:	e9 19 ff ff ff       	jmp    800828 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80090f:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800911:	b8 0a 00 00 00       	mov    $0xa,%eax
  800916:	bf 59 29 80 00       	mov    $0x802959,%edi
							putch(ch, putdat);
  80091b:	83 ec 08             	sub    $0x8,%esp
  80091e:	53                   	push   %ebx
  80091f:	50                   	push   %eax
  800920:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800922:	83 c7 01             	add    $0x1,%edi
  800925:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800929:	83 c4 10             	add    $0x10,%esp
  80092c:	85 c0                	test   %eax,%eax
  80092e:	75 eb                	jne    80091b <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800930:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800933:	89 45 14             	mov    %eax,0x14(%ebp)
  800936:	e9 ed fe ff ff       	jmp    800828 <vprintfmt+0x446>
			putch(ch, putdat);
  80093b:	83 ec 08             	sub    $0x8,%esp
  80093e:	53                   	push   %ebx
  80093f:	6a 25                	push   $0x25
  800941:	ff d6                	call   *%esi
			break;
  800943:	83 c4 10             	add    $0x10,%esp
  800946:	e9 dd fe ff ff       	jmp    800828 <vprintfmt+0x446>
			putch('%', putdat);
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	53                   	push   %ebx
  80094f:	6a 25                	push   $0x25
  800951:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800953:	83 c4 10             	add    $0x10,%esp
  800956:	89 f8                	mov    %edi,%eax
  800958:	eb 03                	jmp    80095d <vprintfmt+0x57b>
  80095a:	83 e8 01             	sub    $0x1,%eax
  80095d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800961:	75 f7                	jne    80095a <vprintfmt+0x578>
  800963:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800966:	e9 bd fe ff ff       	jmp    800828 <vprintfmt+0x446>
}
  80096b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80096e:	5b                   	pop    %ebx
  80096f:	5e                   	pop    %esi
  800970:	5f                   	pop    %edi
  800971:	5d                   	pop    %ebp
  800972:	c3                   	ret    

00800973 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	83 ec 18             	sub    $0x18,%esp
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80097f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800982:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800986:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800989:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800990:	85 c0                	test   %eax,%eax
  800992:	74 26                	je     8009ba <vsnprintf+0x47>
  800994:	85 d2                	test   %edx,%edx
  800996:	7e 22                	jle    8009ba <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800998:	ff 75 14             	pushl  0x14(%ebp)
  80099b:	ff 75 10             	pushl  0x10(%ebp)
  80099e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009a1:	50                   	push   %eax
  8009a2:	68 a8 03 80 00       	push   $0x8003a8
  8009a7:	e8 36 fa ff ff       	call   8003e2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009af:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009b5:	83 c4 10             	add    $0x10,%esp
}
  8009b8:	c9                   	leave  
  8009b9:	c3                   	ret    
		return -E_INVAL;
  8009ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009bf:	eb f7                	jmp    8009b8 <vsnprintf+0x45>

008009c1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009c1:	55                   	push   %ebp
  8009c2:	89 e5                	mov    %esp,%ebp
  8009c4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009c7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009ca:	50                   	push   %eax
  8009cb:	ff 75 10             	pushl  0x10(%ebp)
  8009ce:	ff 75 0c             	pushl  0xc(%ebp)
  8009d1:	ff 75 08             	pushl  0x8(%ebp)
  8009d4:	e8 9a ff ff ff       	call   800973 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009d9:	c9                   	leave  
  8009da:	c3                   	ret    

008009db <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009e6:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009ea:	74 05                	je     8009f1 <strlen+0x16>
		n++;
  8009ec:	83 c0 01             	add    $0x1,%eax
  8009ef:	eb f5                	jmp    8009e6 <strlen+0xb>
	return n;
}
  8009f1:	5d                   	pop    %ebp
  8009f2:	c3                   	ret    

008009f3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009f3:	55                   	push   %ebp
  8009f4:	89 e5                	mov    %esp,%ebp
  8009f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009f9:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800a01:	39 c2                	cmp    %eax,%edx
  800a03:	74 0d                	je     800a12 <strnlen+0x1f>
  800a05:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a09:	74 05                	je     800a10 <strnlen+0x1d>
		n++;
  800a0b:	83 c2 01             	add    $0x1,%edx
  800a0e:	eb f1                	jmp    800a01 <strnlen+0xe>
  800a10:	89 d0                	mov    %edx,%eax
	return n;
}
  800a12:	5d                   	pop    %ebp
  800a13:	c3                   	ret    

00800a14 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	53                   	push   %ebx
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a1e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a23:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a27:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a2a:	83 c2 01             	add    $0x1,%edx
  800a2d:	84 c9                	test   %cl,%cl
  800a2f:	75 f2                	jne    800a23 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a31:	5b                   	pop    %ebx
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    

00800a34 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	53                   	push   %ebx
  800a38:	83 ec 10             	sub    $0x10,%esp
  800a3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a3e:	53                   	push   %ebx
  800a3f:	e8 97 ff ff ff       	call   8009db <strlen>
  800a44:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	01 d8                	add    %ebx,%eax
  800a4c:	50                   	push   %eax
  800a4d:	e8 c2 ff ff ff       	call   800a14 <strcpy>
	return dst;
}
  800a52:	89 d8                	mov    %ebx,%eax
  800a54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a57:	c9                   	leave  
  800a58:	c3                   	ret    

00800a59 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	56                   	push   %esi
  800a5d:	53                   	push   %ebx
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a64:	89 c6                	mov    %eax,%esi
  800a66:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a69:	89 c2                	mov    %eax,%edx
  800a6b:	39 f2                	cmp    %esi,%edx
  800a6d:	74 11                	je     800a80 <strncpy+0x27>
		*dst++ = *src;
  800a6f:	83 c2 01             	add    $0x1,%edx
  800a72:	0f b6 19             	movzbl (%ecx),%ebx
  800a75:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a78:	80 fb 01             	cmp    $0x1,%bl
  800a7b:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a7e:	eb eb                	jmp    800a6b <strncpy+0x12>
	}
	return ret;
}
  800a80:	5b                   	pop    %ebx
  800a81:	5e                   	pop    %esi
  800a82:	5d                   	pop    %ebp
  800a83:	c3                   	ret    

00800a84 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	56                   	push   %esi
  800a88:	53                   	push   %ebx
  800a89:	8b 75 08             	mov    0x8(%ebp),%esi
  800a8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a8f:	8b 55 10             	mov    0x10(%ebp),%edx
  800a92:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a94:	85 d2                	test   %edx,%edx
  800a96:	74 21                	je     800ab9 <strlcpy+0x35>
  800a98:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a9c:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a9e:	39 c2                	cmp    %eax,%edx
  800aa0:	74 14                	je     800ab6 <strlcpy+0x32>
  800aa2:	0f b6 19             	movzbl (%ecx),%ebx
  800aa5:	84 db                	test   %bl,%bl
  800aa7:	74 0b                	je     800ab4 <strlcpy+0x30>
			*dst++ = *src++;
  800aa9:	83 c1 01             	add    $0x1,%ecx
  800aac:	83 c2 01             	add    $0x1,%edx
  800aaf:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ab2:	eb ea                	jmp    800a9e <strlcpy+0x1a>
  800ab4:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ab6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ab9:	29 f0                	sub    %esi,%eax
}
  800abb:	5b                   	pop    %ebx
  800abc:	5e                   	pop    %esi
  800abd:	5d                   	pop    %ebp
  800abe:	c3                   	ret    

00800abf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800abf:	55                   	push   %ebp
  800ac0:	89 e5                	mov    %esp,%ebp
  800ac2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ac5:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ac8:	0f b6 01             	movzbl (%ecx),%eax
  800acb:	84 c0                	test   %al,%al
  800acd:	74 0c                	je     800adb <strcmp+0x1c>
  800acf:	3a 02                	cmp    (%edx),%al
  800ad1:	75 08                	jne    800adb <strcmp+0x1c>
		p++, q++;
  800ad3:	83 c1 01             	add    $0x1,%ecx
  800ad6:	83 c2 01             	add    $0x1,%edx
  800ad9:	eb ed                	jmp    800ac8 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800adb:	0f b6 c0             	movzbl %al,%eax
  800ade:	0f b6 12             	movzbl (%edx),%edx
  800ae1:	29 d0                	sub    %edx,%eax
}
  800ae3:	5d                   	pop    %ebp
  800ae4:	c3                   	ret    

00800ae5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ae5:	55                   	push   %ebp
  800ae6:	89 e5                	mov    %esp,%ebp
  800ae8:	53                   	push   %ebx
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aef:	89 c3                	mov    %eax,%ebx
  800af1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800af4:	eb 06                	jmp    800afc <strncmp+0x17>
		n--, p++, q++;
  800af6:	83 c0 01             	add    $0x1,%eax
  800af9:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800afc:	39 d8                	cmp    %ebx,%eax
  800afe:	74 16                	je     800b16 <strncmp+0x31>
  800b00:	0f b6 08             	movzbl (%eax),%ecx
  800b03:	84 c9                	test   %cl,%cl
  800b05:	74 04                	je     800b0b <strncmp+0x26>
  800b07:	3a 0a                	cmp    (%edx),%cl
  800b09:	74 eb                	je     800af6 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b0b:	0f b6 00             	movzbl (%eax),%eax
  800b0e:	0f b6 12             	movzbl (%edx),%edx
  800b11:	29 d0                	sub    %edx,%eax
}
  800b13:	5b                   	pop    %ebx
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    
		return 0;
  800b16:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1b:	eb f6                	jmp    800b13 <strncmp+0x2e>

00800b1d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b27:	0f b6 10             	movzbl (%eax),%edx
  800b2a:	84 d2                	test   %dl,%dl
  800b2c:	74 09                	je     800b37 <strchr+0x1a>
		if (*s == c)
  800b2e:	38 ca                	cmp    %cl,%dl
  800b30:	74 0a                	je     800b3c <strchr+0x1f>
	for (; *s; s++)
  800b32:	83 c0 01             	add    $0x1,%eax
  800b35:	eb f0                	jmp    800b27 <strchr+0xa>
			return (char *) s;
	return 0;
  800b37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b3c:	5d                   	pop    %ebp
  800b3d:	c3                   	ret    

00800b3e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b48:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b4b:	38 ca                	cmp    %cl,%dl
  800b4d:	74 09                	je     800b58 <strfind+0x1a>
  800b4f:	84 d2                	test   %dl,%dl
  800b51:	74 05                	je     800b58 <strfind+0x1a>
	for (; *s; s++)
  800b53:	83 c0 01             	add    $0x1,%eax
  800b56:	eb f0                	jmp    800b48 <strfind+0xa>
			break;
	return (char *) s;
}
  800b58:	5d                   	pop    %ebp
  800b59:	c3                   	ret    

00800b5a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
  800b5d:	57                   	push   %edi
  800b5e:	56                   	push   %esi
  800b5f:	53                   	push   %ebx
  800b60:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b63:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b66:	85 c9                	test   %ecx,%ecx
  800b68:	74 31                	je     800b9b <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b6a:	89 f8                	mov    %edi,%eax
  800b6c:	09 c8                	or     %ecx,%eax
  800b6e:	a8 03                	test   $0x3,%al
  800b70:	75 23                	jne    800b95 <memset+0x3b>
		c &= 0xFF;
  800b72:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b76:	89 d3                	mov    %edx,%ebx
  800b78:	c1 e3 08             	shl    $0x8,%ebx
  800b7b:	89 d0                	mov    %edx,%eax
  800b7d:	c1 e0 18             	shl    $0x18,%eax
  800b80:	89 d6                	mov    %edx,%esi
  800b82:	c1 e6 10             	shl    $0x10,%esi
  800b85:	09 f0                	or     %esi,%eax
  800b87:	09 c2                	or     %eax,%edx
  800b89:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b8b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b8e:	89 d0                	mov    %edx,%eax
  800b90:	fc                   	cld    
  800b91:	f3 ab                	rep stos %eax,%es:(%edi)
  800b93:	eb 06                	jmp    800b9b <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b98:	fc                   	cld    
  800b99:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b9b:	89 f8                	mov    %edi,%eax
  800b9d:	5b                   	pop    %ebx
  800b9e:	5e                   	pop    %esi
  800b9f:	5f                   	pop    %edi
  800ba0:	5d                   	pop    %ebp
  800ba1:	c3                   	ret    

00800ba2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ba2:	55                   	push   %ebp
  800ba3:	89 e5                	mov    %esp,%ebp
  800ba5:	57                   	push   %edi
  800ba6:	56                   	push   %esi
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bad:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bb0:	39 c6                	cmp    %eax,%esi
  800bb2:	73 32                	jae    800be6 <memmove+0x44>
  800bb4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bb7:	39 c2                	cmp    %eax,%edx
  800bb9:	76 2b                	jbe    800be6 <memmove+0x44>
		s += n;
		d += n;
  800bbb:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bbe:	89 fe                	mov    %edi,%esi
  800bc0:	09 ce                	or     %ecx,%esi
  800bc2:	09 d6                	or     %edx,%esi
  800bc4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bca:	75 0e                	jne    800bda <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bcc:	83 ef 04             	sub    $0x4,%edi
  800bcf:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bd2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bd5:	fd                   	std    
  800bd6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bd8:	eb 09                	jmp    800be3 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bda:	83 ef 01             	sub    $0x1,%edi
  800bdd:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800be0:	fd                   	std    
  800be1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800be3:	fc                   	cld    
  800be4:	eb 1a                	jmp    800c00 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800be6:	89 c2                	mov    %eax,%edx
  800be8:	09 ca                	or     %ecx,%edx
  800bea:	09 f2                	or     %esi,%edx
  800bec:	f6 c2 03             	test   $0x3,%dl
  800bef:	75 0a                	jne    800bfb <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bf1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bf4:	89 c7                	mov    %eax,%edi
  800bf6:	fc                   	cld    
  800bf7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bf9:	eb 05                	jmp    800c00 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bfb:	89 c7                	mov    %eax,%edi
  800bfd:	fc                   	cld    
  800bfe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c00:	5e                   	pop    %esi
  800c01:	5f                   	pop    %edi
  800c02:	5d                   	pop    %ebp
  800c03:	c3                   	ret    

00800c04 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c0a:	ff 75 10             	pushl  0x10(%ebp)
  800c0d:	ff 75 0c             	pushl  0xc(%ebp)
  800c10:	ff 75 08             	pushl  0x8(%ebp)
  800c13:	e8 8a ff ff ff       	call   800ba2 <memmove>
}
  800c18:	c9                   	leave  
  800c19:	c3                   	ret    

00800c1a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c1a:	55                   	push   %ebp
  800c1b:	89 e5                	mov    %esp,%ebp
  800c1d:	56                   	push   %esi
  800c1e:	53                   	push   %ebx
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c25:	89 c6                	mov    %eax,%esi
  800c27:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c2a:	39 f0                	cmp    %esi,%eax
  800c2c:	74 1c                	je     800c4a <memcmp+0x30>
		if (*s1 != *s2)
  800c2e:	0f b6 08             	movzbl (%eax),%ecx
  800c31:	0f b6 1a             	movzbl (%edx),%ebx
  800c34:	38 d9                	cmp    %bl,%cl
  800c36:	75 08                	jne    800c40 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c38:	83 c0 01             	add    $0x1,%eax
  800c3b:	83 c2 01             	add    $0x1,%edx
  800c3e:	eb ea                	jmp    800c2a <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c40:	0f b6 c1             	movzbl %cl,%eax
  800c43:	0f b6 db             	movzbl %bl,%ebx
  800c46:	29 d8                	sub    %ebx,%eax
  800c48:	eb 05                	jmp    800c4f <memcmp+0x35>
	}

	return 0;
  800c4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5d                   	pop    %ebp
  800c52:	c3                   	ret    

00800c53 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c5c:	89 c2                	mov    %eax,%edx
  800c5e:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c61:	39 d0                	cmp    %edx,%eax
  800c63:	73 09                	jae    800c6e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c65:	38 08                	cmp    %cl,(%eax)
  800c67:	74 05                	je     800c6e <memfind+0x1b>
	for (; s < ends; s++)
  800c69:	83 c0 01             	add    $0x1,%eax
  800c6c:	eb f3                	jmp    800c61 <memfind+0xe>
			break;
	return (void *) s;
}
  800c6e:	5d                   	pop    %ebp
  800c6f:	c3                   	ret    

00800c70 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	57                   	push   %edi
  800c74:	56                   	push   %esi
  800c75:	53                   	push   %ebx
  800c76:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c79:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c7c:	eb 03                	jmp    800c81 <strtol+0x11>
		s++;
  800c7e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c81:	0f b6 01             	movzbl (%ecx),%eax
  800c84:	3c 20                	cmp    $0x20,%al
  800c86:	74 f6                	je     800c7e <strtol+0xe>
  800c88:	3c 09                	cmp    $0x9,%al
  800c8a:	74 f2                	je     800c7e <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c8c:	3c 2b                	cmp    $0x2b,%al
  800c8e:	74 2a                	je     800cba <strtol+0x4a>
	int neg = 0;
  800c90:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c95:	3c 2d                	cmp    $0x2d,%al
  800c97:	74 2b                	je     800cc4 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c99:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c9f:	75 0f                	jne    800cb0 <strtol+0x40>
  800ca1:	80 39 30             	cmpb   $0x30,(%ecx)
  800ca4:	74 28                	je     800cce <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ca6:	85 db                	test   %ebx,%ebx
  800ca8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cad:	0f 44 d8             	cmove  %eax,%ebx
  800cb0:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cb8:	eb 50                	jmp    800d0a <strtol+0x9a>
		s++;
  800cba:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cbd:	bf 00 00 00 00       	mov    $0x0,%edi
  800cc2:	eb d5                	jmp    800c99 <strtol+0x29>
		s++, neg = 1;
  800cc4:	83 c1 01             	add    $0x1,%ecx
  800cc7:	bf 01 00 00 00       	mov    $0x1,%edi
  800ccc:	eb cb                	jmp    800c99 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cce:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cd2:	74 0e                	je     800ce2 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800cd4:	85 db                	test   %ebx,%ebx
  800cd6:	75 d8                	jne    800cb0 <strtol+0x40>
		s++, base = 8;
  800cd8:	83 c1 01             	add    $0x1,%ecx
  800cdb:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ce0:	eb ce                	jmp    800cb0 <strtol+0x40>
		s += 2, base = 16;
  800ce2:	83 c1 02             	add    $0x2,%ecx
  800ce5:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cea:	eb c4                	jmp    800cb0 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cec:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cef:	89 f3                	mov    %esi,%ebx
  800cf1:	80 fb 19             	cmp    $0x19,%bl
  800cf4:	77 29                	ja     800d1f <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cf6:	0f be d2             	movsbl %dl,%edx
  800cf9:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cfc:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cff:	7d 30                	jge    800d31 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d01:	83 c1 01             	add    $0x1,%ecx
  800d04:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d08:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d0a:	0f b6 11             	movzbl (%ecx),%edx
  800d0d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d10:	89 f3                	mov    %esi,%ebx
  800d12:	80 fb 09             	cmp    $0x9,%bl
  800d15:	77 d5                	ja     800cec <strtol+0x7c>
			dig = *s - '0';
  800d17:	0f be d2             	movsbl %dl,%edx
  800d1a:	83 ea 30             	sub    $0x30,%edx
  800d1d:	eb dd                	jmp    800cfc <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d1f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d22:	89 f3                	mov    %esi,%ebx
  800d24:	80 fb 19             	cmp    $0x19,%bl
  800d27:	77 08                	ja     800d31 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d29:	0f be d2             	movsbl %dl,%edx
  800d2c:	83 ea 37             	sub    $0x37,%edx
  800d2f:	eb cb                	jmp    800cfc <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d31:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d35:	74 05                	je     800d3c <strtol+0xcc>
		*endptr = (char *) s;
  800d37:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d3a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d3c:	89 c2                	mov    %eax,%edx
  800d3e:	f7 da                	neg    %edx
  800d40:	85 ff                	test   %edi,%edi
  800d42:	0f 45 c2             	cmovne %edx,%eax
}
  800d45:	5b                   	pop    %ebx
  800d46:	5e                   	pop    %esi
  800d47:	5f                   	pop    %edi
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	57                   	push   %edi
  800d4e:	56                   	push   %esi
  800d4f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d50:	b8 00 00 00 00       	mov    $0x0,%eax
  800d55:	8b 55 08             	mov    0x8(%ebp),%edx
  800d58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5b:	89 c3                	mov    %eax,%ebx
  800d5d:	89 c7                	mov    %eax,%edi
  800d5f:	89 c6                	mov    %eax,%esi
  800d61:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d63:	5b                   	pop    %ebx
  800d64:	5e                   	pop    %esi
  800d65:	5f                   	pop    %edi
  800d66:	5d                   	pop    %ebp
  800d67:	c3                   	ret    

00800d68 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
  800d6b:	57                   	push   %edi
  800d6c:	56                   	push   %esi
  800d6d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d6e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d73:	b8 01 00 00 00       	mov    $0x1,%eax
  800d78:	89 d1                	mov    %edx,%ecx
  800d7a:	89 d3                	mov    %edx,%ebx
  800d7c:	89 d7                	mov    %edx,%edi
  800d7e:	89 d6                	mov    %edx,%esi
  800d80:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d82:	5b                   	pop    %ebx
  800d83:	5e                   	pop    %esi
  800d84:	5f                   	pop    %edi
  800d85:	5d                   	pop    %ebp
  800d86:	c3                   	ret    

00800d87 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	57                   	push   %edi
  800d8b:	56                   	push   %esi
  800d8c:	53                   	push   %ebx
  800d8d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d90:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d95:	8b 55 08             	mov    0x8(%ebp),%edx
  800d98:	b8 03 00 00 00       	mov    $0x3,%eax
  800d9d:	89 cb                	mov    %ecx,%ebx
  800d9f:	89 cf                	mov    %ecx,%edi
  800da1:	89 ce                	mov    %ecx,%esi
  800da3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da5:	85 c0                	test   %eax,%eax
  800da7:	7f 08                	jg     800db1 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800da9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dac:	5b                   	pop    %ebx
  800dad:	5e                   	pop    %esi
  800dae:	5f                   	pop    %edi
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db1:	83 ec 0c             	sub    $0xc,%esp
  800db4:	50                   	push   %eax
  800db5:	6a 03                	push   $0x3
  800db7:	68 64 2b 80 00       	push   $0x802b64
  800dbc:	6a 43                	push   $0x43
  800dbe:	68 81 2b 80 00       	push   $0x802b81
  800dc3:	e8 f7 f3 ff ff       	call   8001bf <_panic>

00800dc8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	57                   	push   %edi
  800dcc:	56                   	push   %esi
  800dcd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dce:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd3:	b8 02 00 00 00       	mov    $0x2,%eax
  800dd8:	89 d1                	mov    %edx,%ecx
  800dda:	89 d3                	mov    %edx,%ebx
  800ddc:	89 d7                	mov    %edx,%edi
  800dde:	89 d6                	mov    %edx,%esi
  800de0:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800de2:	5b                   	pop    %ebx
  800de3:	5e                   	pop    %esi
  800de4:	5f                   	pop    %edi
  800de5:	5d                   	pop    %ebp
  800de6:	c3                   	ret    

00800de7 <sys_yield>:

void
sys_yield(void)
{
  800de7:	55                   	push   %ebp
  800de8:	89 e5                	mov    %esp,%ebp
  800dea:	57                   	push   %edi
  800deb:	56                   	push   %esi
  800dec:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ded:	ba 00 00 00 00       	mov    $0x0,%edx
  800df2:	b8 0b 00 00 00       	mov    $0xb,%eax
  800df7:	89 d1                	mov    %edx,%ecx
  800df9:	89 d3                	mov    %edx,%ebx
  800dfb:	89 d7                	mov    %edx,%edi
  800dfd:	89 d6                	mov    %edx,%esi
  800dff:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e01:	5b                   	pop    %ebx
  800e02:	5e                   	pop    %esi
  800e03:	5f                   	pop    %edi
  800e04:	5d                   	pop    %ebp
  800e05:	c3                   	ret    

00800e06 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	57                   	push   %edi
  800e0a:	56                   	push   %esi
  800e0b:	53                   	push   %ebx
  800e0c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0f:	be 00 00 00 00       	mov    $0x0,%esi
  800e14:	8b 55 08             	mov    0x8(%ebp),%edx
  800e17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1a:	b8 04 00 00 00       	mov    $0x4,%eax
  800e1f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e22:	89 f7                	mov    %esi,%edi
  800e24:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e26:	85 c0                	test   %eax,%eax
  800e28:	7f 08                	jg     800e32 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2d:	5b                   	pop    %ebx
  800e2e:	5e                   	pop    %esi
  800e2f:	5f                   	pop    %edi
  800e30:	5d                   	pop    %ebp
  800e31:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e32:	83 ec 0c             	sub    $0xc,%esp
  800e35:	50                   	push   %eax
  800e36:	6a 04                	push   $0x4
  800e38:	68 64 2b 80 00       	push   $0x802b64
  800e3d:	6a 43                	push   $0x43
  800e3f:	68 81 2b 80 00       	push   $0x802b81
  800e44:	e8 76 f3 ff ff       	call   8001bf <_panic>

00800e49 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	57                   	push   %edi
  800e4d:	56                   	push   %esi
  800e4e:	53                   	push   %ebx
  800e4f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e52:	8b 55 08             	mov    0x8(%ebp),%edx
  800e55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e58:	b8 05 00 00 00       	mov    $0x5,%eax
  800e5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e60:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e63:	8b 75 18             	mov    0x18(%ebp),%esi
  800e66:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e68:	85 c0                	test   %eax,%eax
  800e6a:	7f 08                	jg     800e74 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6f:	5b                   	pop    %ebx
  800e70:	5e                   	pop    %esi
  800e71:	5f                   	pop    %edi
  800e72:	5d                   	pop    %ebp
  800e73:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e74:	83 ec 0c             	sub    $0xc,%esp
  800e77:	50                   	push   %eax
  800e78:	6a 05                	push   $0x5
  800e7a:	68 64 2b 80 00       	push   $0x802b64
  800e7f:	6a 43                	push   $0x43
  800e81:	68 81 2b 80 00       	push   $0x802b81
  800e86:	e8 34 f3 ff ff       	call   8001bf <_panic>

00800e8b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	57                   	push   %edi
  800e8f:	56                   	push   %esi
  800e90:	53                   	push   %ebx
  800e91:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e94:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e99:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9f:	b8 06 00 00 00       	mov    $0x6,%eax
  800ea4:	89 df                	mov    %ebx,%edi
  800ea6:	89 de                	mov    %ebx,%esi
  800ea8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eaa:	85 c0                	test   %eax,%eax
  800eac:	7f 08                	jg     800eb6 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800eae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb1:	5b                   	pop    %ebx
  800eb2:	5e                   	pop    %esi
  800eb3:	5f                   	pop    %edi
  800eb4:	5d                   	pop    %ebp
  800eb5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb6:	83 ec 0c             	sub    $0xc,%esp
  800eb9:	50                   	push   %eax
  800eba:	6a 06                	push   $0x6
  800ebc:	68 64 2b 80 00       	push   $0x802b64
  800ec1:	6a 43                	push   $0x43
  800ec3:	68 81 2b 80 00       	push   $0x802b81
  800ec8:	e8 f2 f2 ff ff       	call   8001bf <_panic>

00800ecd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	57                   	push   %edi
  800ed1:	56                   	push   %esi
  800ed2:	53                   	push   %ebx
  800ed3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800edb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ede:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee1:	b8 08 00 00 00       	mov    $0x8,%eax
  800ee6:	89 df                	mov    %ebx,%edi
  800ee8:	89 de                	mov    %ebx,%esi
  800eea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eec:	85 c0                	test   %eax,%eax
  800eee:	7f 08                	jg     800ef8 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef3:	5b                   	pop    %ebx
  800ef4:	5e                   	pop    %esi
  800ef5:	5f                   	pop    %edi
  800ef6:	5d                   	pop    %ebp
  800ef7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef8:	83 ec 0c             	sub    $0xc,%esp
  800efb:	50                   	push   %eax
  800efc:	6a 08                	push   $0x8
  800efe:	68 64 2b 80 00       	push   $0x802b64
  800f03:	6a 43                	push   $0x43
  800f05:	68 81 2b 80 00       	push   $0x802b81
  800f0a:	e8 b0 f2 ff ff       	call   8001bf <_panic>

00800f0f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f0f:	55                   	push   %ebp
  800f10:	89 e5                	mov    %esp,%ebp
  800f12:	57                   	push   %edi
  800f13:	56                   	push   %esi
  800f14:	53                   	push   %ebx
  800f15:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f18:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f23:	b8 09 00 00 00       	mov    $0x9,%eax
  800f28:	89 df                	mov    %ebx,%edi
  800f2a:	89 de                	mov    %ebx,%esi
  800f2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f2e:	85 c0                	test   %eax,%eax
  800f30:	7f 08                	jg     800f3a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f35:	5b                   	pop    %ebx
  800f36:	5e                   	pop    %esi
  800f37:	5f                   	pop    %edi
  800f38:	5d                   	pop    %ebp
  800f39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3a:	83 ec 0c             	sub    $0xc,%esp
  800f3d:	50                   	push   %eax
  800f3e:	6a 09                	push   $0x9
  800f40:	68 64 2b 80 00       	push   $0x802b64
  800f45:	6a 43                	push   $0x43
  800f47:	68 81 2b 80 00       	push   $0x802b81
  800f4c:	e8 6e f2 ff ff       	call   8001bf <_panic>

00800f51 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	57                   	push   %edi
  800f55:	56                   	push   %esi
  800f56:	53                   	push   %ebx
  800f57:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f5a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f65:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f6a:	89 df                	mov    %ebx,%edi
  800f6c:	89 de                	mov    %ebx,%esi
  800f6e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f70:	85 c0                	test   %eax,%eax
  800f72:	7f 08                	jg     800f7c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f77:	5b                   	pop    %ebx
  800f78:	5e                   	pop    %esi
  800f79:	5f                   	pop    %edi
  800f7a:	5d                   	pop    %ebp
  800f7b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7c:	83 ec 0c             	sub    $0xc,%esp
  800f7f:	50                   	push   %eax
  800f80:	6a 0a                	push   $0xa
  800f82:	68 64 2b 80 00       	push   $0x802b64
  800f87:	6a 43                	push   $0x43
  800f89:	68 81 2b 80 00       	push   $0x802b81
  800f8e:	e8 2c f2 ff ff       	call   8001bf <_panic>

00800f93 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	57                   	push   %edi
  800f97:	56                   	push   %esi
  800f98:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f99:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fa4:	be 00 00 00 00       	mov    $0x0,%esi
  800fa9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fac:	8b 7d 14             	mov    0x14(%ebp),%edi
  800faf:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5f                   	pop    %edi
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    

00800fb6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	57                   	push   %edi
  800fba:	56                   	push   %esi
  800fbb:	53                   	push   %ebx
  800fbc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fbf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fcc:	89 cb                	mov    %ecx,%ebx
  800fce:	89 cf                	mov    %ecx,%edi
  800fd0:	89 ce                	mov    %ecx,%esi
  800fd2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fd4:	85 c0                	test   %eax,%eax
  800fd6:	7f 08                	jg     800fe0 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fdb:	5b                   	pop    %ebx
  800fdc:	5e                   	pop    %esi
  800fdd:	5f                   	pop    %edi
  800fde:	5d                   	pop    %ebp
  800fdf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe0:	83 ec 0c             	sub    $0xc,%esp
  800fe3:	50                   	push   %eax
  800fe4:	6a 0d                	push   $0xd
  800fe6:	68 64 2b 80 00       	push   $0x802b64
  800feb:	6a 43                	push   $0x43
  800fed:	68 81 2b 80 00       	push   $0x802b81
  800ff2:	e8 c8 f1 ff ff       	call   8001bf <_panic>

00800ff7 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800ff7:	55                   	push   %ebp
  800ff8:	89 e5                	mov    %esp,%ebp
  800ffa:	57                   	push   %edi
  800ffb:	56                   	push   %esi
  800ffc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ffd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801002:	8b 55 08             	mov    0x8(%ebp),%edx
  801005:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801008:	b8 0e 00 00 00       	mov    $0xe,%eax
  80100d:	89 df                	mov    %ebx,%edi
  80100f:	89 de                	mov    %ebx,%esi
  801011:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  801013:	5b                   	pop    %ebx
  801014:	5e                   	pop    %esi
  801015:	5f                   	pop    %edi
  801016:	5d                   	pop    %ebp
  801017:	c3                   	ret    

00801018 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	57                   	push   %edi
  80101c:	56                   	push   %esi
  80101d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80101e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801023:	8b 55 08             	mov    0x8(%ebp),%edx
  801026:	b8 0f 00 00 00       	mov    $0xf,%eax
  80102b:	89 cb                	mov    %ecx,%ebx
  80102d:	89 cf                	mov    %ecx,%edi
  80102f:	89 ce                	mov    %ecx,%esi
  801031:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801033:	5b                   	pop    %ebx
  801034:	5e                   	pop    %esi
  801035:	5f                   	pop    %edi
  801036:	5d                   	pop    %ebp
  801037:	c3                   	ret    

00801038 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	57                   	push   %edi
  80103c:	56                   	push   %esi
  80103d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80103e:	ba 00 00 00 00       	mov    $0x0,%edx
  801043:	b8 10 00 00 00       	mov    $0x10,%eax
  801048:	89 d1                	mov    %edx,%ecx
  80104a:	89 d3                	mov    %edx,%ebx
  80104c:	89 d7                	mov    %edx,%edi
  80104e:	89 d6                	mov    %edx,%esi
  801050:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801052:	5b                   	pop    %ebx
  801053:	5e                   	pop    %esi
  801054:	5f                   	pop    %edi
  801055:	5d                   	pop    %ebp
  801056:	c3                   	ret    

00801057 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	57                   	push   %edi
  80105b:	56                   	push   %esi
  80105c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80105d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801062:	8b 55 08             	mov    0x8(%ebp),%edx
  801065:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801068:	b8 11 00 00 00       	mov    $0x11,%eax
  80106d:	89 df                	mov    %ebx,%edi
  80106f:	89 de                	mov    %ebx,%esi
  801071:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801073:	5b                   	pop    %ebx
  801074:	5e                   	pop    %esi
  801075:	5f                   	pop    %edi
  801076:	5d                   	pop    %ebp
  801077:	c3                   	ret    

00801078 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801078:	55                   	push   %ebp
  801079:	89 e5                	mov    %esp,%ebp
  80107b:	57                   	push   %edi
  80107c:	56                   	push   %esi
  80107d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80107e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801083:	8b 55 08             	mov    0x8(%ebp),%edx
  801086:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801089:	b8 12 00 00 00       	mov    $0x12,%eax
  80108e:	89 df                	mov    %ebx,%edi
  801090:	89 de                	mov    %ebx,%esi
  801092:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801094:	5b                   	pop    %ebx
  801095:	5e                   	pop    %esi
  801096:	5f                   	pop    %edi
  801097:	5d                   	pop    %ebp
  801098:	c3                   	ret    

00801099 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	57                   	push   %edi
  80109d:	56                   	push   %esi
  80109e:	53                   	push   %ebx
  80109f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ad:	b8 13 00 00 00       	mov    $0x13,%eax
  8010b2:	89 df                	mov    %ebx,%edi
  8010b4:	89 de                	mov    %ebx,%esi
  8010b6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010b8:	85 c0                	test   %eax,%eax
  8010ba:	7f 08                	jg     8010c4 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010bf:	5b                   	pop    %ebx
  8010c0:	5e                   	pop    %esi
  8010c1:	5f                   	pop    %edi
  8010c2:	5d                   	pop    %ebp
  8010c3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c4:	83 ec 0c             	sub    $0xc,%esp
  8010c7:	50                   	push   %eax
  8010c8:	6a 13                	push   $0x13
  8010ca:	68 64 2b 80 00       	push   $0x802b64
  8010cf:	6a 43                	push   $0x43
  8010d1:	68 81 2b 80 00       	push   $0x802b81
  8010d6:	e8 e4 f0 ff ff       	call   8001bf <_panic>

008010db <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8010e1:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  8010e8:	74 0a                	je     8010f4 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  8010f2:	c9                   	leave  
  8010f3:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  8010f4:	83 ec 04             	sub    $0x4,%esp
  8010f7:	6a 07                	push   $0x7
  8010f9:	68 00 f0 bf ee       	push   $0xeebff000
  8010fe:	6a 00                	push   $0x0
  801100:	e8 01 fd ff ff       	call   800e06 <sys_page_alloc>
		if(r < 0)
  801105:	83 c4 10             	add    $0x10,%esp
  801108:	85 c0                	test   %eax,%eax
  80110a:	78 2a                	js     801136 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80110c:	83 ec 08             	sub    $0x8,%esp
  80110f:	68 4a 11 80 00       	push   $0x80114a
  801114:	6a 00                	push   $0x0
  801116:	e8 36 fe ff ff       	call   800f51 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80111b:	83 c4 10             	add    $0x10,%esp
  80111e:	85 c0                	test   %eax,%eax
  801120:	79 c8                	jns    8010ea <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  801122:	83 ec 04             	sub    $0x4,%esp
  801125:	68 c0 2b 80 00       	push   $0x802bc0
  80112a:	6a 25                	push   $0x25
  80112c:	68 f9 2b 80 00       	push   $0x802bf9
  801131:	e8 89 f0 ff ff       	call   8001bf <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  801136:	83 ec 04             	sub    $0x4,%esp
  801139:	68 90 2b 80 00       	push   $0x802b90
  80113e:	6a 22                	push   $0x22
  801140:	68 f9 2b 80 00       	push   $0x802bf9
  801145:	e8 75 f0 ff ff       	call   8001bf <_panic>

0080114a <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80114a:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80114b:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  801150:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801152:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  801155:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  801159:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80115d:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801160:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  801162:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  801166:	83 c4 08             	add    $0x8,%esp
	popal
  801169:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80116a:	83 c4 04             	add    $0x4,%esp
	popfl
  80116d:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80116e:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80116f:	c3                   	ret    

00801170 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	05 00 00 00 30       	add    $0x30000000,%eax
  80117b:	c1 e8 0c             	shr    $0xc,%eax
}
  80117e:	5d                   	pop    %ebp
  80117f:	c3                   	ret    

00801180 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801180:	55                   	push   %ebp
  801181:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80118b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801190:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801195:	5d                   	pop    %ebp
  801196:	c3                   	ret    

00801197 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80119f:	89 c2                	mov    %eax,%edx
  8011a1:	c1 ea 16             	shr    $0x16,%edx
  8011a4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011ab:	f6 c2 01             	test   $0x1,%dl
  8011ae:	74 2d                	je     8011dd <fd_alloc+0x46>
  8011b0:	89 c2                	mov    %eax,%edx
  8011b2:	c1 ea 0c             	shr    $0xc,%edx
  8011b5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011bc:	f6 c2 01             	test   $0x1,%dl
  8011bf:	74 1c                	je     8011dd <fd_alloc+0x46>
  8011c1:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011c6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011cb:	75 d2                	jne    80119f <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8011d6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011db:	eb 0a                	jmp    8011e7 <fd_alloc+0x50>
			*fd_store = fd;
  8011dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011e0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011e7:	5d                   	pop    %ebp
  8011e8:	c3                   	ret    

008011e9 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
  8011ec:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011ef:	83 f8 1f             	cmp    $0x1f,%eax
  8011f2:	77 30                	ja     801224 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011f4:	c1 e0 0c             	shl    $0xc,%eax
  8011f7:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011fc:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801202:	f6 c2 01             	test   $0x1,%dl
  801205:	74 24                	je     80122b <fd_lookup+0x42>
  801207:	89 c2                	mov    %eax,%edx
  801209:	c1 ea 0c             	shr    $0xc,%edx
  80120c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801213:	f6 c2 01             	test   $0x1,%dl
  801216:	74 1a                	je     801232 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801218:	8b 55 0c             	mov    0xc(%ebp),%edx
  80121b:	89 02                	mov    %eax,(%edx)
	return 0;
  80121d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801222:	5d                   	pop    %ebp
  801223:	c3                   	ret    
		return -E_INVAL;
  801224:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801229:	eb f7                	jmp    801222 <fd_lookup+0x39>
		return -E_INVAL;
  80122b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801230:	eb f0                	jmp    801222 <fd_lookup+0x39>
  801232:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801237:	eb e9                	jmp    801222 <fd_lookup+0x39>

00801239 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801239:	55                   	push   %ebp
  80123a:	89 e5                	mov    %esp,%ebp
  80123c:	83 ec 08             	sub    $0x8,%esp
  80123f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801242:	ba 00 00 00 00       	mov    $0x0,%edx
  801247:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80124c:	39 08                	cmp    %ecx,(%eax)
  80124e:	74 38                	je     801288 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801250:	83 c2 01             	add    $0x1,%edx
  801253:	8b 04 95 88 2c 80 00 	mov    0x802c88(,%edx,4),%eax
  80125a:	85 c0                	test   %eax,%eax
  80125c:	75 ee                	jne    80124c <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80125e:	a1 08 40 80 00       	mov    0x804008,%eax
  801263:	8b 40 48             	mov    0x48(%eax),%eax
  801266:	83 ec 04             	sub    $0x4,%esp
  801269:	51                   	push   %ecx
  80126a:	50                   	push   %eax
  80126b:	68 08 2c 80 00       	push   $0x802c08
  801270:	e8 40 f0 ff ff       	call   8002b5 <cprintf>
	*dev = 0;
  801275:	8b 45 0c             	mov    0xc(%ebp),%eax
  801278:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80127e:	83 c4 10             	add    $0x10,%esp
  801281:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801286:	c9                   	leave  
  801287:	c3                   	ret    
			*dev = devtab[i];
  801288:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80128b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80128d:	b8 00 00 00 00       	mov    $0x0,%eax
  801292:	eb f2                	jmp    801286 <dev_lookup+0x4d>

00801294 <fd_close>:
{
  801294:	55                   	push   %ebp
  801295:	89 e5                	mov    %esp,%ebp
  801297:	57                   	push   %edi
  801298:	56                   	push   %esi
  801299:	53                   	push   %ebx
  80129a:	83 ec 24             	sub    $0x24,%esp
  80129d:	8b 75 08             	mov    0x8(%ebp),%esi
  8012a0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012a3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012a6:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012a7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012ad:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012b0:	50                   	push   %eax
  8012b1:	e8 33 ff ff ff       	call   8011e9 <fd_lookup>
  8012b6:	89 c3                	mov    %eax,%ebx
  8012b8:	83 c4 10             	add    $0x10,%esp
  8012bb:	85 c0                	test   %eax,%eax
  8012bd:	78 05                	js     8012c4 <fd_close+0x30>
	    || fd != fd2)
  8012bf:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012c2:	74 16                	je     8012da <fd_close+0x46>
		return (must_exist ? r : 0);
  8012c4:	89 f8                	mov    %edi,%eax
  8012c6:	84 c0                	test   %al,%al
  8012c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012cd:	0f 44 d8             	cmove  %eax,%ebx
}
  8012d0:	89 d8                	mov    %ebx,%eax
  8012d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012d5:	5b                   	pop    %ebx
  8012d6:	5e                   	pop    %esi
  8012d7:	5f                   	pop    %edi
  8012d8:	5d                   	pop    %ebp
  8012d9:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012da:	83 ec 08             	sub    $0x8,%esp
  8012dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012e0:	50                   	push   %eax
  8012e1:	ff 36                	pushl  (%esi)
  8012e3:	e8 51 ff ff ff       	call   801239 <dev_lookup>
  8012e8:	89 c3                	mov    %eax,%ebx
  8012ea:	83 c4 10             	add    $0x10,%esp
  8012ed:	85 c0                	test   %eax,%eax
  8012ef:	78 1a                	js     80130b <fd_close+0x77>
		if (dev->dev_close)
  8012f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012f4:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8012f7:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8012fc:	85 c0                	test   %eax,%eax
  8012fe:	74 0b                	je     80130b <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801300:	83 ec 0c             	sub    $0xc,%esp
  801303:	56                   	push   %esi
  801304:	ff d0                	call   *%eax
  801306:	89 c3                	mov    %eax,%ebx
  801308:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80130b:	83 ec 08             	sub    $0x8,%esp
  80130e:	56                   	push   %esi
  80130f:	6a 00                	push   $0x0
  801311:	e8 75 fb ff ff       	call   800e8b <sys_page_unmap>
	return r;
  801316:	83 c4 10             	add    $0x10,%esp
  801319:	eb b5                	jmp    8012d0 <fd_close+0x3c>

0080131b <close>:

int
close(int fdnum)
{
  80131b:	55                   	push   %ebp
  80131c:	89 e5                	mov    %esp,%ebp
  80131e:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801321:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801324:	50                   	push   %eax
  801325:	ff 75 08             	pushl  0x8(%ebp)
  801328:	e8 bc fe ff ff       	call   8011e9 <fd_lookup>
  80132d:	83 c4 10             	add    $0x10,%esp
  801330:	85 c0                	test   %eax,%eax
  801332:	79 02                	jns    801336 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801334:	c9                   	leave  
  801335:	c3                   	ret    
		return fd_close(fd, 1);
  801336:	83 ec 08             	sub    $0x8,%esp
  801339:	6a 01                	push   $0x1
  80133b:	ff 75 f4             	pushl  -0xc(%ebp)
  80133e:	e8 51 ff ff ff       	call   801294 <fd_close>
  801343:	83 c4 10             	add    $0x10,%esp
  801346:	eb ec                	jmp    801334 <close+0x19>

00801348 <close_all>:

void
close_all(void)
{
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
  80134b:	53                   	push   %ebx
  80134c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80134f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801354:	83 ec 0c             	sub    $0xc,%esp
  801357:	53                   	push   %ebx
  801358:	e8 be ff ff ff       	call   80131b <close>
	for (i = 0; i < MAXFD; i++)
  80135d:	83 c3 01             	add    $0x1,%ebx
  801360:	83 c4 10             	add    $0x10,%esp
  801363:	83 fb 20             	cmp    $0x20,%ebx
  801366:	75 ec                	jne    801354 <close_all+0xc>
}
  801368:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    

0080136d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	57                   	push   %edi
  801371:	56                   	push   %esi
  801372:	53                   	push   %ebx
  801373:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801376:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801379:	50                   	push   %eax
  80137a:	ff 75 08             	pushl  0x8(%ebp)
  80137d:	e8 67 fe ff ff       	call   8011e9 <fd_lookup>
  801382:	89 c3                	mov    %eax,%ebx
  801384:	83 c4 10             	add    $0x10,%esp
  801387:	85 c0                	test   %eax,%eax
  801389:	0f 88 81 00 00 00    	js     801410 <dup+0xa3>
		return r;
	close(newfdnum);
  80138f:	83 ec 0c             	sub    $0xc,%esp
  801392:	ff 75 0c             	pushl  0xc(%ebp)
  801395:	e8 81 ff ff ff       	call   80131b <close>

	newfd = INDEX2FD(newfdnum);
  80139a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80139d:	c1 e6 0c             	shl    $0xc,%esi
  8013a0:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013a6:	83 c4 04             	add    $0x4,%esp
  8013a9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013ac:	e8 cf fd ff ff       	call   801180 <fd2data>
  8013b1:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013b3:	89 34 24             	mov    %esi,(%esp)
  8013b6:	e8 c5 fd ff ff       	call   801180 <fd2data>
  8013bb:	83 c4 10             	add    $0x10,%esp
  8013be:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013c0:	89 d8                	mov    %ebx,%eax
  8013c2:	c1 e8 16             	shr    $0x16,%eax
  8013c5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013cc:	a8 01                	test   $0x1,%al
  8013ce:	74 11                	je     8013e1 <dup+0x74>
  8013d0:	89 d8                	mov    %ebx,%eax
  8013d2:	c1 e8 0c             	shr    $0xc,%eax
  8013d5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013dc:	f6 c2 01             	test   $0x1,%dl
  8013df:	75 39                	jne    80141a <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013e4:	89 d0                	mov    %edx,%eax
  8013e6:	c1 e8 0c             	shr    $0xc,%eax
  8013e9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013f0:	83 ec 0c             	sub    $0xc,%esp
  8013f3:	25 07 0e 00 00       	and    $0xe07,%eax
  8013f8:	50                   	push   %eax
  8013f9:	56                   	push   %esi
  8013fa:	6a 00                	push   $0x0
  8013fc:	52                   	push   %edx
  8013fd:	6a 00                	push   $0x0
  8013ff:	e8 45 fa ff ff       	call   800e49 <sys_page_map>
  801404:	89 c3                	mov    %eax,%ebx
  801406:	83 c4 20             	add    $0x20,%esp
  801409:	85 c0                	test   %eax,%eax
  80140b:	78 31                	js     80143e <dup+0xd1>
		goto err;

	return newfdnum;
  80140d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801410:	89 d8                	mov    %ebx,%eax
  801412:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801415:	5b                   	pop    %ebx
  801416:	5e                   	pop    %esi
  801417:	5f                   	pop    %edi
  801418:	5d                   	pop    %ebp
  801419:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80141a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801421:	83 ec 0c             	sub    $0xc,%esp
  801424:	25 07 0e 00 00       	and    $0xe07,%eax
  801429:	50                   	push   %eax
  80142a:	57                   	push   %edi
  80142b:	6a 00                	push   $0x0
  80142d:	53                   	push   %ebx
  80142e:	6a 00                	push   $0x0
  801430:	e8 14 fa ff ff       	call   800e49 <sys_page_map>
  801435:	89 c3                	mov    %eax,%ebx
  801437:	83 c4 20             	add    $0x20,%esp
  80143a:	85 c0                	test   %eax,%eax
  80143c:	79 a3                	jns    8013e1 <dup+0x74>
	sys_page_unmap(0, newfd);
  80143e:	83 ec 08             	sub    $0x8,%esp
  801441:	56                   	push   %esi
  801442:	6a 00                	push   $0x0
  801444:	e8 42 fa ff ff       	call   800e8b <sys_page_unmap>
	sys_page_unmap(0, nva);
  801449:	83 c4 08             	add    $0x8,%esp
  80144c:	57                   	push   %edi
  80144d:	6a 00                	push   $0x0
  80144f:	e8 37 fa ff ff       	call   800e8b <sys_page_unmap>
	return r;
  801454:	83 c4 10             	add    $0x10,%esp
  801457:	eb b7                	jmp    801410 <dup+0xa3>

00801459 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801459:	55                   	push   %ebp
  80145a:	89 e5                	mov    %esp,%ebp
  80145c:	53                   	push   %ebx
  80145d:	83 ec 1c             	sub    $0x1c,%esp
  801460:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801463:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801466:	50                   	push   %eax
  801467:	53                   	push   %ebx
  801468:	e8 7c fd ff ff       	call   8011e9 <fd_lookup>
  80146d:	83 c4 10             	add    $0x10,%esp
  801470:	85 c0                	test   %eax,%eax
  801472:	78 3f                	js     8014b3 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801474:	83 ec 08             	sub    $0x8,%esp
  801477:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80147a:	50                   	push   %eax
  80147b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80147e:	ff 30                	pushl  (%eax)
  801480:	e8 b4 fd ff ff       	call   801239 <dev_lookup>
  801485:	83 c4 10             	add    $0x10,%esp
  801488:	85 c0                	test   %eax,%eax
  80148a:	78 27                	js     8014b3 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80148c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80148f:	8b 42 08             	mov    0x8(%edx),%eax
  801492:	83 e0 03             	and    $0x3,%eax
  801495:	83 f8 01             	cmp    $0x1,%eax
  801498:	74 1e                	je     8014b8 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80149a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80149d:	8b 40 08             	mov    0x8(%eax),%eax
  8014a0:	85 c0                	test   %eax,%eax
  8014a2:	74 35                	je     8014d9 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014a4:	83 ec 04             	sub    $0x4,%esp
  8014a7:	ff 75 10             	pushl  0x10(%ebp)
  8014aa:	ff 75 0c             	pushl  0xc(%ebp)
  8014ad:	52                   	push   %edx
  8014ae:	ff d0                	call   *%eax
  8014b0:	83 c4 10             	add    $0x10,%esp
}
  8014b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014b6:	c9                   	leave  
  8014b7:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014b8:	a1 08 40 80 00       	mov    0x804008,%eax
  8014bd:	8b 40 48             	mov    0x48(%eax),%eax
  8014c0:	83 ec 04             	sub    $0x4,%esp
  8014c3:	53                   	push   %ebx
  8014c4:	50                   	push   %eax
  8014c5:	68 4c 2c 80 00       	push   $0x802c4c
  8014ca:	e8 e6 ed ff ff       	call   8002b5 <cprintf>
		return -E_INVAL;
  8014cf:	83 c4 10             	add    $0x10,%esp
  8014d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014d7:	eb da                	jmp    8014b3 <read+0x5a>
		return -E_NOT_SUPP;
  8014d9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014de:	eb d3                	jmp    8014b3 <read+0x5a>

008014e0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	57                   	push   %edi
  8014e4:	56                   	push   %esi
  8014e5:	53                   	push   %ebx
  8014e6:	83 ec 0c             	sub    $0xc,%esp
  8014e9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014ec:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014ef:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014f4:	39 f3                	cmp    %esi,%ebx
  8014f6:	73 23                	jae    80151b <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014f8:	83 ec 04             	sub    $0x4,%esp
  8014fb:	89 f0                	mov    %esi,%eax
  8014fd:	29 d8                	sub    %ebx,%eax
  8014ff:	50                   	push   %eax
  801500:	89 d8                	mov    %ebx,%eax
  801502:	03 45 0c             	add    0xc(%ebp),%eax
  801505:	50                   	push   %eax
  801506:	57                   	push   %edi
  801507:	e8 4d ff ff ff       	call   801459 <read>
		if (m < 0)
  80150c:	83 c4 10             	add    $0x10,%esp
  80150f:	85 c0                	test   %eax,%eax
  801511:	78 06                	js     801519 <readn+0x39>
			return m;
		if (m == 0)
  801513:	74 06                	je     80151b <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801515:	01 c3                	add    %eax,%ebx
  801517:	eb db                	jmp    8014f4 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801519:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80151b:	89 d8                	mov    %ebx,%eax
  80151d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801520:	5b                   	pop    %ebx
  801521:	5e                   	pop    %esi
  801522:	5f                   	pop    %edi
  801523:	5d                   	pop    %ebp
  801524:	c3                   	ret    

00801525 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
  801528:	53                   	push   %ebx
  801529:	83 ec 1c             	sub    $0x1c,%esp
  80152c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80152f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801532:	50                   	push   %eax
  801533:	53                   	push   %ebx
  801534:	e8 b0 fc ff ff       	call   8011e9 <fd_lookup>
  801539:	83 c4 10             	add    $0x10,%esp
  80153c:	85 c0                	test   %eax,%eax
  80153e:	78 3a                	js     80157a <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801540:	83 ec 08             	sub    $0x8,%esp
  801543:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801546:	50                   	push   %eax
  801547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154a:	ff 30                	pushl  (%eax)
  80154c:	e8 e8 fc ff ff       	call   801239 <dev_lookup>
  801551:	83 c4 10             	add    $0x10,%esp
  801554:	85 c0                	test   %eax,%eax
  801556:	78 22                	js     80157a <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801558:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80155f:	74 1e                	je     80157f <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801561:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801564:	8b 52 0c             	mov    0xc(%edx),%edx
  801567:	85 d2                	test   %edx,%edx
  801569:	74 35                	je     8015a0 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80156b:	83 ec 04             	sub    $0x4,%esp
  80156e:	ff 75 10             	pushl  0x10(%ebp)
  801571:	ff 75 0c             	pushl  0xc(%ebp)
  801574:	50                   	push   %eax
  801575:	ff d2                	call   *%edx
  801577:	83 c4 10             	add    $0x10,%esp
}
  80157a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80157d:	c9                   	leave  
  80157e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80157f:	a1 08 40 80 00       	mov    0x804008,%eax
  801584:	8b 40 48             	mov    0x48(%eax),%eax
  801587:	83 ec 04             	sub    $0x4,%esp
  80158a:	53                   	push   %ebx
  80158b:	50                   	push   %eax
  80158c:	68 68 2c 80 00       	push   $0x802c68
  801591:	e8 1f ed ff ff       	call   8002b5 <cprintf>
		return -E_INVAL;
  801596:	83 c4 10             	add    $0x10,%esp
  801599:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80159e:	eb da                	jmp    80157a <write+0x55>
		return -E_NOT_SUPP;
  8015a0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015a5:	eb d3                	jmp    80157a <write+0x55>

008015a7 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015a7:	55                   	push   %ebp
  8015a8:	89 e5                	mov    %esp,%ebp
  8015aa:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b0:	50                   	push   %eax
  8015b1:	ff 75 08             	pushl  0x8(%ebp)
  8015b4:	e8 30 fc ff ff       	call   8011e9 <fd_lookup>
  8015b9:	83 c4 10             	add    $0x10,%esp
  8015bc:	85 c0                	test   %eax,%eax
  8015be:	78 0e                	js     8015ce <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ce:	c9                   	leave  
  8015cf:	c3                   	ret    

008015d0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
  8015d3:	53                   	push   %ebx
  8015d4:	83 ec 1c             	sub    $0x1c,%esp
  8015d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015da:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015dd:	50                   	push   %eax
  8015de:	53                   	push   %ebx
  8015df:	e8 05 fc ff ff       	call   8011e9 <fd_lookup>
  8015e4:	83 c4 10             	add    $0x10,%esp
  8015e7:	85 c0                	test   %eax,%eax
  8015e9:	78 37                	js     801622 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015eb:	83 ec 08             	sub    $0x8,%esp
  8015ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015f1:	50                   	push   %eax
  8015f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f5:	ff 30                	pushl  (%eax)
  8015f7:	e8 3d fc ff ff       	call   801239 <dev_lookup>
  8015fc:	83 c4 10             	add    $0x10,%esp
  8015ff:	85 c0                	test   %eax,%eax
  801601:	78 1f                	js     801622 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801603:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801606:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80160a:	74 1b                	je     801627 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80160c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80160f:	8b 52 18             	mov    0x18(%edx),%edx
  801612:	85 d2                	test   %edx,%edx
  801614:	74 32                	je     801648 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801616:	83 ec 08             	sub    $0x8,%esp
  801619:	ff 75 0c             	pushl  0xc(%ebp)
  80161c:	50                   	push   %eax
  80161d:	ff d2                	call   *%edx
  80161f:	83 c4 10             	add    $0x10,%esp
}
  801622:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801625:	c9                   	leave  
  801626:	c3                   	ret    
			thisenv->env_id, fdnum);
  801627:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80162c:	8b 40 48             	mov    0x48(%eax),%eax
  80162f:	83 ec 04             	sub    $0x4,%esp
  801632:	53                   	push   %ebx
  801633:	50                   	push   %eax
  801634:	68 28 2c 80 00       	push   $0x802c28
  801639:	e8 77 ec ff ff       	call   8002b5 <cprintf>
		return -E_INVAL;
  80163e:	83 c4 10             	add    $0x10,%esp
  801641:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801646:	eb da                	jmp    801622 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801648:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80164d:	eb d3                	jmp    801622 <ftruncate+0x52>

0080164f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	53                   	push   %ebx
  801653:	83 ec 1c             	sub    $0x1c,%esp
  801656:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801659:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80165c:	50                   	push   %eax
  80165d:	ff 75 08             	pushl  0x8(%ebp)
  801660:	e8 84 fb ff ff       	call   8011e9 <fd_lookup>
  801665:	83 c4 10             	add    $0x10,%esp
  801668:	85 c0                	test   %eax,%eax
  80166a:	78 4b                	js     8016b7 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80166c:	83 ec 08             	sub    $0x8,%esp
  80166f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801672:	50                   	push   %eax
  801673:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801676:	ff 30                	pushl  (%eax)
  801678:	e8 bc fb ff ff       	call   801239 <dev_lookup>
  80167d:	83 c4 10             	add    $0x10,%esp
  801680:	85 c0                	test   %eax,%eax
  801682:	78 33                	js     8016b7 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801687:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80168b:	74 2f                	je     8016bc <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80168d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801690:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801697:	00 00 00 
	stat->st_isdir = 0;
  80169a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016a1:	00 00 00 
	stat->st_dev = dev;
  8016a4:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016aa:	83 ec 08             	sub    $0x8,%esp
  8016ad:	53                   	push   %ebx
  8016ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8016b1:	ff 50 14             	call   *0x14(%eax)
  8016b4:	83 c4 10             	add    $0x10,%esp
}
  8016b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ba:	c9                   	leave  
  8016bb:	c3                   	ret    
		return -E_NOT_SUPP;
  8016bc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016c1:	eb f4                	jmp    8016b7 <fstat+0x68>

008016c3 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
  8016c6:	56                   	push   %esi
  8016c7:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016c8:	83 ec 08             	sub    $0x8,%esp
  8016cb:	6a 00                	push   $0x0
  8016cd:	ff 75 08             	pushl  0x8(%ebp)
  8016d0:	e8 22 02 00 00       	call   8018f7 <open>
  8016d5:	89 c3                	mov    %eax,%ebx
  8016d7:	83 c4 10             	add    $0x10,%esp
  8016da:	85 c0                	test   %eax,%eax
  8016dc:	78 1b                	js     8016f9 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016de:	83 ec 08             	sub    $0x8,%esp
  8016e1:	ff 75 0c             	pushl  0xc(%ebp)
  8016e4:	50                   	push   %eax
  8016e5:	e8 65 ff ff ff       	call   80164f <fstat>
  8016ea:	89 c6                	mov    %eax,%esi
	close(fd);
  8016ec:	89 1c 24             	mov    %ebx,(%esp)
  8016ef:	e8 27 fc ff ff       	call   80131b <close>
	return r;
  8016f4:	83 c4 10             	add    $0x10,%esp
  8016f7:	89 f3                	mov    %esi,%ebx
}
  8016f9:	89 d8                	mov    %ebx,%eax
  8016fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016fe:	5b                   	pop    %ebx
  8016ff:	5e                   	pop    %esi
  801700:	5d                   	pop    %ebp
  801701:	c3                   	ret    

00801702 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
  801705:	56                   	push   %esi
  801706:	53                   	push   %ebx
  801707:	89 c6                	mov    %eax,%esi
  801709:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80170b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801712:	74 27                	je     80173b <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801714:	6a 07                	push   $0x7
  801716:	68 00 50 80 00       	push   $0x805000
  80171b:	56                   	push   %esi
  80171c:	ff 35 00 40 80 00    	pushl  0x804000
  801722:	e8 08 0c 00 00       	call   80232f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801727:	83 c4 0c             	add    $0xc,%esp
  80172a:	6a 00                	push   $0x0
  80172c:	53                   	push   %ebx
  80172d:	6a 00                	push   $0x0
  80172f:	e8 92 0b 00 00       	call   8022c6 <ipc_recv>
}
  801734:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801737:	5b                   	pop    %ebx
  801738:	5e                   	pop    %esi
  801739:	5d                   	pop    %ebp
  80173a:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80173b:	83 ec 0c             	sub    $0xc,%esp
  80173e:	6a 01                	push   $0x1
  801740:	e8 42 0c 00 00       	call   802387 <ipc_find_env>
  801745:	a3 00 40 80 00       	mov    %eax,0x804000
  80174a:	83 c4 10             	add    $0x10,%esp
  80174d:	eb c5                	jmp    801714 <fsipc+0x12>

0080174f <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
  801752:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801755:	8b 45 08             	mov    0x8(%ebp),%eax
  801758:	8b 40 0c             	mov    0xc(%eax),%eax
  80175b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801760:	8b 45 0c             	mov    0xc(%ebp),%eax
  801763:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801768:	ba 00 00 00 00       	mov    $0x0,%edx
  80176d:	b8 02 00 00 00       	mov    $0x2,%eax
  801772:	e8 8b ff ff ff       	call   801702 <fsipc>
}
  801777:	c9                   	leave  
  801778:	c3                   	ret    

00801779 <devfile_flush>:
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
  80177c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	8b 40 0c             	mov    0xc(%eax),%eax
  801785:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80178a:	ba 00 00 00 00       	mov    $0x0,%edx
  80178f:	b8 06 00 00 00       	mov    $0x6,%eax
  801794:	e8 69 ff ff ff       	call   801702 <fsipc>
}
  801799:	c9                   	leave  
  80179a:	c3                   	ret    

0080179b <devfile_stat>:
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
  80179e:	53                   	push   %ebx
  80179f:	83 ec 04             	sub    $0x4,%esp
  8017a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ab:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b5:	b8 05 00 00 00       	mov    $0x5,%eax
  8017ba:	e8 43 ff ff ff       	call   801702 <fsipc>
  8017bf:	85 c0                	test   %eax,%eax
  8017c1:	78 2c                	js     8017ef <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017c3:	83 ec 08             	sub    $0x8,%esp
  8017c6:	68 00 50 80 00       	push   $0x805000
  8017cb:	53                   	push   %ebx
  8017cc:	e8 43 f2 ff ff       	call   800a14 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017d1:	a1 80 50 80 00       	mov    0x805080,%eax
  8017d6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017dc:	a1 84 50 80 00       	mov    0x805084,%eax
  8017e1:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017e7:	83 c4 10             	add    $0x10,%esp
  8017ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    

008017f4 <devfile_write>:
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
  8017f7:	53                   	push   %ebx
  8017f8:	83 ec 08             	sub    $0x8,%esp
  8017fb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	8b 40 0c             	mov    0xc(%eax),%eax
  801804:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801809:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80180f:	53                   	push   %ebx
  801810:	ff 75 0c             	pushl  0xc(%ebp)
  801813:	68 08 50 80 00       	push   $0x805008
  801818:	e8 e7 f3 ff ff       	call   800c04 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80181d:	ba 00 00 00 00       	mov    $0x0,%edx
  801822:	b8 04 00 00 00       	mov    $0x4,%eax
  801827:	e8 d6 fe ff ff       	call   801702 <fsipc>
  80182c:	83 c4 10             	add    $0x10,%esp
  80182f:	85 c0                	test   %eax,%eax
  801831:	78 0b                	js     80183e <devfile_write+0x4a>
	assert(r <= n);
  801833:	39 d8                	cmp    %ebx,%eax
  801835:	77 0c                	ja     801843 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801837:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80183c:	7f 1e                	jg     80185c <devfile_write+0x68>
}
  80183e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801841:	c9                   	leave  
  801842:	c3                   	ret    
	assert(r <= n);
  801843:	68 9c 2c 80 00       	push   $0x802c9c
  801848:	68 a3 2c 80 00       	push   $0x802ca3
  80184d:	68 98 00 00 00       	push   $0x98
  801852:	68 b8 2c 80 00       	push   $0x802cb8
  801857:	e8 63 e9 ff ff       	call   8001bf <_panic>
	assert(r <= PGSIZE);
  80185c:	68 c3 2c 80 00       	push   $0x802cc3
  801861:	68 a3 2c 80 00       	push   $0x802ca3
  801866:	68 99 00 00 00       	push   $0x99
  80186b:	68 b8 2c 80 00       	push   $0x802cb8
  801870:	e8 4a e9 ff ff       	call   8001bf <_panic>

00801875 <devfile_read>:
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	56                   	push   %esi
  801879:	53                   	push   %ebx
  80187a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80187d:	8b 45 08             	mov    0x8(%ebp),%eax
  801880:	8b 40 0c             	mov    0xc(%eax),%eax
  801883:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801888:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80188e:	ba 00 00 00 00       	mov    $0x0,%edx
  801893:	b8 03 00 00 00       	mov    $0x3,%eax
  801898:	e8 65 fe ff ff       	call   801702 <fsipc>
  80189d:	89 c3                	mov    %eax,%ebx
  80189f:	85 c0                	test   %eax,%eax
  8018a1:	78 1f                	js     8018c2 <devfile_read+0x4d>
	assert(r <= n);
  8018a3:	39 f0                	cmp    %esi,%eax
  8018a5:	77 24                	ja     8018cb <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018a7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018ac:	7f 33                	jg     8018e1 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018ae:	83 ec 04             	sub    $0x4,%esp
  8018b1:	50                   	push   %eax
  8018b2:	68 00 50 80 00       	push   $0x805000
  8018b7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ba:	e8 e3 f2 ff ff       	call   800ba2 <memmove>
	return r;
  8018bf:	83 c4 10             	add    $0x10,%esp
}
  8018c2:	89 d8                	mov    %ebx,%eax
  8018c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018c7:	5b                   	pop    %ebx
  8018c8:	5e                   	pop    %esi
  8018c9:	5d                   	pop    %ebp
  8018ca:	c3                   	ret    
	assert(r <= n);
  8018cb:	68 9c 2c 80 00       	push   $0x802c9c
  8018d0:	68 a3 2c 80 00       	push   $0x802ca3
  8018d5:	6a 7c                	push   $0x7c
  8018d7:	68 b8 2c 80 00       	push   $0x802cb8
  8018dc:	e8 de e8 ff ff       	call   8001bf <_panic>
	assert(r <= PGSIZE);
  8018e1:	68 c3 2c 80 00       	push   $0x802cc3
  8018e6:	68 a3 2c 80 00       	push   $0x802ca3
  8018eb:	6a 7d                	push   $0x7d
  8018ed:	68 b8 2c 80 00       	push   $0x802cb8
  8018f2:	e8 c8 e8 ff ff       	call   8001bf <_panic>

008018f7 <open>:
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
  8018fa:	56                   	push   %esi
  8018fb:	53                   	push   %ebx
  8018fc:	83 ec 1c             	sub    $0x1c,%esp
  8018ff:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801902:	56                   	push   %esi
  801903:	e8 d3 f0 ff ff       	call   8009db <strlen>
  801908:	83 c4 10             	add    $0x10,%esp
  80190b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801910:	7f 6c                	jg     80197e <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801912:	83 ec 0c             	sub    $0xc,%esp
  801915:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801918:	50                   	push   %eax
  801919:	e8 79 f8 ff ff       	call   801197 <fd_alloc>
  80191e:	89 c3                	mov    %eax,%ebx
  801920:	83 c4 10             	add    $0x10,%esp
  801923:	85 c0                	test   %eax,%eax
  801925:	78 3c                	js     801963 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801927:	83 ec 08             	sub    $0x8,%esp
  80192a:	56                   	push   %esi
  80192b:	68 00 50 80 00       	push   $0x805000
  801930:	e8 df f0 ff ff       	call   800a14 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801935:	8b 45 0c             	mov    0xc(%ebp),%eax
  801938:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80193d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801940:	b8 01 00 00 00       	mov    $0x1,%eax
  801945:	e8 b8 fd ff ff       	call   801702 <fsipc>
  80194a:	89 c3                	mov    %eax,%ebx
  80194c:	83 c4 10             	add    $0x10,%esp
  80194f:	85 c0                	test   %eax,%eax
  801951:	78 19                	js     80196c <open+0x75>
	return fd2num(fd);
  801953:	83 ec 0c             	sub    $0xc,%esp
  801956:	ff 75 f4             	pushl  -0xc(%ebp)
  801959:	e8 12 f8 ff ff       	call   801170 <fd2num>
  80195e:	89 c3                	mov    %eax,%ebx
  801960:	83 c4 10             	add    $0x10,%esp
}
  801963:	89 d8                	mov    %ebx,%eax
  801965:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801968:	5b                   	pop    %ebx
  801969:	5e                   	pop    %esi
  80196a:	5d                   	pop    %ebp
  80196b:	c3                   	ret    
		fd_close(fd, 0);
  80196c:	83 ec 08             	sub    $0x8,%esp
  80196f:	6a 00                	push   $0x0
  801971:	ff 75 f4             	pushl  -0xc(%ebp)
  801974:	e8 1b f9 ff ff       	call   801294 <fd_close>
		return r;
  801979:	83 c4 10             	add    $0x10,%esp
  80197c:	eb e5                	jmp    801963 <open+0x6c>
		return -E_BAD_PATH;
  80197e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801983:	eb de                	jmp    801963 <open+0x6c>

00801985 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
  801988:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80198b:	ba 00 00 00 00       	mov    $0x0,%edx
  801990:	b8 08 00 00 00       	mov    $0x8,%eax
  801995:	e8 68 fd ff ff       	call   801702 <fsipc>
}
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8019a2:	68 cf 2c 80 00       	push   $0x802ccf
  8019a7:	ff 75 0c             	pushl  0xc(%ebp)
  8019aa:	e8 65 f0 ff ff       	call   800a14 <strcpy>
	return 0;
}
  8019af:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <devsock_close>:
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
  8019b9:	53                   	push   %ebx
  8019ba:	83 ec 10             	sub    $0x10,%esp
  8019bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8019c0:	53                   	push   %ebx
  8019c1:	e8 fc 09 00 00       	call   8023c2 <pageref>
  8019c6:	83 c4 10             	add    $0x10,%esp
		return 0;
  8019c9:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8019ce:	83 f8 01             	cmp    $0x1,%eax
  8019d1:	74 07                	je     8019da <devsock_close+0x24>
}
  8019d3:	89 d0                	mov    %edx,%eax
  8019d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8019da:	83 ec 0c             	sub    $0xc,%esp
  8019dd:	ff 73 0c             	pushl  0xc(%ebx)
  8019e0:	e8 b9 02 00 00       	call   801c9e <nsipc_close>
  8019e5:	89 c2                	mov    %eax,%edx
  8019e7:	83 c4 10             	add    $0x10,%esp
  8019ea:	eb e7                	jmp    8019d3 <devsock_close+0x1d>

008019ec <devsock_write>:
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
  8019ef:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019f2:	6a 00                	push   $0x0
  8019f4:	ff 75 10             	pushl  0x10(%ebp)
  8019f7:	ff 75 0c             	pushl  0xc(%ebp)
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fd:	ff 70 0c             	pushl  0xc(%eax)
  801a00:	e8 76 03 00 00       	call   801d7b <nsipc_send>
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <devsock_read>:
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a0d:	6a 00                	push   $0x0
  801a0f:	ff 75 10             	pushl  0x10(%ebp)
  801a12:	ff 75 0c             	pushl  0xc(%ebp)
  801a15:	8b 45 08             	mov    0x8(%ebp),%eax
  801a18:	ff 70 0c             	pushl  0xc(%eax)
  801a1b:	e8 ef 02 00 00       	call   801d0f <nsipc_recv>
}
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <fd2sockid>:
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
  801a25:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a28:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a2b:	52                   	push   %edx
  801a2c:	50                   	push   %eax
  801a2d:	e8 b7 f7 ff ff       	call   8011e9 <fd_lookup>
  801a32:	83 c4 10             	add    $0x10,%esp
  801a35:	85 c0                	test   %eax,%eax
  801a37:	78 10                	js     801a49 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a3c:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a42:	39 08                	cmp    %ecx,(%eax)
  801a44:	75 05                	jne    801a4b <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a46:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    
		return -E_NOT_SUPP;
  801a4b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a50:	eb f7                	jmp    801a49 <fd2sockid+0x27>

00801a52 <alloc_sockfd>:
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	56                   	push   %esi
  801a56:	53                   	push   %ebx
  801a57:	83 ec 1c             	sub    $0x1c,%esp
  801a5a:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a5c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a5f:	50                   	push   %eax
  801a60:	e8 32 f7 ff ff       	call   801197 <fd_alloc>
  801a65:	89 c3                	mov    %eax,%ebx
  801a67:	83 c4 10             	add    $0x10,%esp
  801a6a:	85 c0                	test   %eax,%eax
  801a6c:	78 43                	js     801ab1 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a6e:	83 ec 04             	sub    $0x4,%esp
  801a71:	68 07 04 00 00       	push   $0x407
  801a76:	ff 75 f4             	pushl  -0xc(%ebp)
  801a79:	6a 00                	push   $0x0
  801a7b:	e8 86 f3 ff ff       	call   800e06 <sys_page_alloc>
  801a80:	89 c3                	mov    %eax,%ebx
  801a82:	83 c4 10             	add    $0x10,%esp
  801a85:	85 c0                	test   %eax,%eax
  801a87:	78 28                	js     801ab1 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8c:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a92:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a97:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a9e:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801aa1:	83 ec 0c             	sub    $0xc,%esp
  801aa4:	50                   	push   %eax
  801aa5:	e8 c6 f6 ff ff       	call   801170 <fd2num>
  801aaa:	89 c3                	mov    %eax,%ebx
  801aac:	83 c4 10             	add    $0x10,%esp
  801aaf:	eb 0c                	jmp    801abd <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801ab1:	83 ec 0c             	sub    $0xc,%esp
  801ab4:	56                   	push   %esi
  801ab5:	e8 e4 01 00 00       	call   801c9e <nsipc_close>
		return r;
  801aba:	83 c4 10             	add    $0x10,%esp
}
  801abd:	89 d8                	mov    %ebx,%eax
  801abf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ac2:	5b                   	pop    %ebx
  801ac3:	5e                   	pop    %esi
  801ac4:	5d                   	pop    %ebp
  801ac5:	c3                   	ret    

00801ac6 <accept>:
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
  801ac9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801acc:	8b 45 08             	mov    0x8(%ebp),%eax
  801acf:	e8 4e ff ff ff       	call   801a22 <fd2sockid>
  801ad4:	85 c0                	test   %eax,%eax
  801ad6:	78 1b                	js     801af3 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ad8:	83 ec 04             	sub    $0x4,%esp
  801adb:	ff 75 10             	pushl  0x10(%ebp)
  801ade:	ff 75 0c             	pushl  0xc(%ebp)
  801ae1:	50                   	push   %eax
  801ae2:	e8 0e 01 00 00       	call   801bf5 <nsipc_accept>
  801ae7:	83 c4 10             	add    $0x10,%esp
  801aea:	85 c0                	test   %eax,%eax
  801aec:	78 05                	js     801af3 <accept+0x2d>
	return alloc_sockfd(r);
  801aee:	e8 5f ff ff ff       	call   801a52 <alloc_sockfd>
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <bind>:
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
  801af8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	e8 1f ff ff ff       	call   801a22 <fd2sockid>
  801b03:	85 c0                	test   %eax,%eax
  801b05:	78 12                	js     801b19 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801b07:	83 ec 04             	sub    $0x4,%esp
  801b0a:	ff 75 10             	pushl  0x10(%ebp)
  801b0d:	ff 75 0c             	pushl  0xc(%ebp)
  801b10:	50                   	push   %eax
  801b11:	e8 31 01 00 00       	call   801c47 <nsipc_bind>
  801b16:	83 c4 10             	add    $0x10,%esp
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <shutdown>:
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
  801b1e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b21:	8b 45 08             	mov    0x8(%ebp),%eax
  801b24:	e8 f9 fe ff ff       	call   801a22 <fd2sockid>
  801b29:	85 c0                	test   %eax,%eax
  801b2b:	78 0f                	js     801b3c <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801b2d:	83 ec 08             	sub    $0x8,%esp
  801b30:	ff 75 0c             	pushl  0xc(%ebp)
  801b33:	50                   	push   %eax
  801b34:	e8 43 01 00 00       	call   801c7c <nsipc_shutdown>
  801b39:	83 c4 10             	add    $0x10,%esp
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <connect>:
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
  801b41:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	e8 d6 fe ff ff       	call   801a22 <fd2sockid>
  801b4c:	85 c0                	test   %eax,%eax
  801b4e:	78 12                	js     801b62 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b50:	83 ec 04             	sub    $0x4,%esp
  801b53:	ff 75 10             	pushl  0x10(%ebp)
  801b56:	ff 75 0c             	pushl  0xc(%ebp)
  801b59:	50                   	push   %eax
  801b5a:	e8 59 01 00 00       	call   801cb8 <nsipc_connect>
  801b5f:	83 c4 10             	add    $0x10,%esp
}
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <listen>:
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
  801b67:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	e8 b0 fe ff ff       	call   801a22 <fd2sockid>
  801b72:	85 c0                	test   %eax,%eax
  801b74:	78 0f                	js     801b85 <listen+0x21>
	return nsipc_listen(r, backlog);
  801b76:	83 ec 08             	sub    $0x8,%esp
  801b79:	ff 75 0c             	pushl  0xc(%ebp)
  801b7c:	50                   	push   %eax
  801b7d:	e8 6b 01 00 00       	call   801ced <nsipc_listen>
  801b82:	83 c4 10             	add    $0x10,%esp
}
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <socket>:

int
socket(int domain, int type, int protocol)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
  801b8a:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b8d:	ff 75 10             	pushl  0x10(%ebp)
  801b90:	ff 75 0c             	pushl  0xc(%ebp)
  801b93:	ff 75 08             	pushl  0x8(%ebp)
  801b96:	e8 3e 02 00 00       	call   801dd9 <nsipc_socket>
  801b9b:	83 c4 10             	add    $0x10,%esp
  801b9e:	85 c0                	test   %eax,%eax
  801ba0:	78 05                	js     801ba7 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801ba2:	e8 ab fe ff ff       	call   801a52 <alloc_sockfd>
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
  801bac:	53                   	push   %ebx
  801bad:	83 ec 04             	sub    $0x4,%esp
  801bb0:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801bb2:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801bb9:	74 26                	je     801be1 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801bbb:	6a 07                	push   $0x7
  801bbd:	68 00 60 80 00       	push   $0x806000
  801bc2:	53                   	push   %ebx
  801bc3:	ff 35 04 40 80 00    	pushl  0x804004
  801bc9:	e8 61 07 00 00       	call   80232f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801bce:	83 c4 0c             	add    $0xc,%esp
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	e8 ea 06 00 00       	call   8022c6 <ipc_recv>
}
  801bdc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801be1:	83 ec 0c             	sub    $0xc,%esp
  801be4:	6a 02                	push   $0x2
  801be6:	e8 9c 07 00 00       	call   802387 <ipc_find_env>
  801beb:	a3 04 40 80 00       	mov    %eax,0x804004
  801bf0:	83 c4 10             	add    $0x10,%esp
  801bf3:	eb c6                	jmp    801bbb <nsipc+0x12>

00801bf5 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
  801bf8:	56                   	push   %esi
  801bf9:	53                   	push   %ebx
  801bfa:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801c00:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c05:	8b 06                	mov    (%esi),%eax
  801c07:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c0c:	b8 01 00 00 00       	mov    $0x1,%eax
  801c11:	e8 93 ff ff ff       	call   801ba9 <nsipc>
  801c16:	89 c3                	mov    %eax,%ebx
  801c18:	85 c0                	test   %eax,%eax
  801c1a:	79 09                	jns    801c25 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801c1c:	89 d8                	mov    %ebx,%eax
  801c1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c21:	5b                   	pop    %ebx
  801c22:	5e                   	pop    %esi
  801c23:	5d                   	pop    %ebp
  801c24:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c25:	83 ec 04             	sub    $0x4,%esp
  801c28:	ff 35 10 60 80 00    	pushl  0x806010
  801c2e:	68 00 60 80 00       	push   $0x806000
  801c33:	ff 75 0c             	pushl  0xc(%ebp)
  801c36:	e8 67 ef ff ff       	call   800ba2 <memmove>
		*addrlen = ret->ret_addrlen;
  801c3b:	a1 10 60 80 00       	mov    0x806010,%eax
  801c40:	89 06                	mov    %eax,(%esi)
  801c42:	83 c4 10             	add    $0x10,%esp
	return r;
  801c45:	eb d5                	jmp    801c1c <nsipc_accept+0x27>

00801c47 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
  801c4a:	53                   	push   %ebx
  801c4b:	83 ec 08             	sub    $0x8,%esp
  801c4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c51:	8b 45 08             	mov    0x8(%ebp),%eax
  801c54:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c59:	53                   	push   %ebx
  801c5a:	ff 75 0c             	pushl  0xc(%ebp)
  801c5d:	68 04 60 80 00       	push   $0x806004
  801c62:	e8 3b ef ff ff       	call   800ba2 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c67:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c6d:	b8 02 00 00 00       	mov    $0x2,%eax
  801c72:	e8 32 ff ff ff       	call   801ba9 <nsipc>
}
  801c77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c7a:	c9                   	leave  
  801c7b:	c3                   	ret    

00801c7c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
  801c7f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c82:	8b 45 08             	mov    0x8(%ebp),%eax
  801c85:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c8d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801c92:	b8 03 00 00 00       	mov    $0x3,%eax
  801c97:	e8 0d ff ff ff       	call   801ba9 <nsipc>
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <nsipc_close>:

int
nsipc_close(int s)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca7:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801cac:	b8 04 00 00 00       	mov    $0x4,%eax
  801cb1:	e8 f3 fe ff ff       	call   801ba9 <nsipc>
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	53                   	push   %ebx
  801cbc:	83 ec 08             	sub    $0x8,%esp
  801cbf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc5:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801cca:	53                   	push   %ebx
  801ccb:	ff 75 0c             	pushl  0xc(%ebp)
  801cce:	68 04 60 80 00       	push   $0x806004
  801cd3:	e8 ca ee ff ff       	call   800ba2 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801cd8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801cde:	b8 05 00 00 00       	mov    $0x5,%eax
  801ce3:	e8 c1 fe ff ff       	call   801ba9 <nsipc>
}
  801ce8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
  801cf0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cfe:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d03:	b8 06 00 00 00       	mov    $0x6,%eax
  801d08:	e8 9c fe ff ff       	call   801ba9 <nsipc>
}
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
  801d12:	56                   	push   %esi
  801d13:	53                   	push   %ebx
  801d14:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d1f:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d25:	8b 45 14             	mov    0x14(%ebp),%eax
  801d28:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d2d:	b8 07 00 00 00       	mov    $0x7,%eax
  801d32:	e8 72 fe ff ff       	call   801ba9 <nsipc>
  801d37:	89 c3                	mov    %eax,%ebx
  801d39:	85 c0                	test   %eax,%eax
  801d3b:	78 1f                	js     801d5c <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d3d:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d42:	7f 21                	jg     801d65 <nsipc_recv+0x56>
  801d44:	39 c6                	cmp    %eax,%esi
  801d46:	7c 1d                	jl     801d65 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d48:	83 ec 04             	sub    $0x4,%esp
  801d4b:	50                   	push   %eax
  801d4c:	68 00 60 80 00       	push   $0x806000
  801d51:	ff 75 0c             	pushl  0xc(%ebp)
  801d54:	e8 49 ee ff ff       	call   800ba2 <memmove>
  801d59:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d5c:	89 d8                	mov    %ebx,%eax
  801d5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d61:	5b                   	pop    %ebx
  801d62:	5e                   	pop    %esi
  801d63:	5d                   	pop    %ebp
  801d64:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d65:	68 db 2c 80 00       	push   $0x802cdb
  801d6a:	68 a3 2c 80 00       	push   $0x802ca3
  801d6f:	6a 62                	push   $0x62
  801d71:	68 f0 2c 80 00       	push   $0x802cf0
  801d76:	e8 44 e4 ff ff       	call   8001bf <_panic>

00801d7b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
  801d7e:	53                   	push   %ebx
  801d7f:	83 ec 04             	sub    $0x4,%esp
  801d82:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d85:	8b 45 08             	mov    0x8(%ebp),%eax
  801d88:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d8d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d93:	7f 2e                	jg     801dc3 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d95:	83 ec 04             	sub    $0x4,%esp
  801d98:	53                   	push   %ebx
  801d99:	ff 75 0c             	pushl  0xc(%ebp)
  801d9c:	68 0c 60 80 00       	push   $0x80600c
  801da1:	e8 fc ed ff ff       	call   800ba2 <memmove>
	nsipcbuf.send.req_size = size;
  801da6:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801dac:	8b 45 14             	mov    0x14(%ebp),%eax
  801daf:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801db4:	b8 08 00 00 00       	mov    $0x8,%eax
  801db9:	e8 eb fd ff ff       	call   801ba9 <nsipc>
}
  801dbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    
	assert(size < 1600);
  801dc3:	68 fc 2c 80 00       	push   $0x802cfc
  801dc8:	68 a3 2c 80 00       	push   $0x802ca3
  801dcd:	6a 6d                	push   $0x6d
  801dcf:	68 f0 2c 80 00       	push   $0x802cf0
  801dd4:	e8 e6 e3 ff ff       	call   8001bf <_panic>

00801dd9 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
  801ddc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  801de2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dea:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801def:	8b 45 10             	mov    0x10(%ebp),%eax
  801df2:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801df7:	b8 09 00 00 00       	mov    $0x9,%eax
  801dfc:	e8 a8 fd ff ff       	call   801ba9 <nsipc>
}
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	56                   	push   %esi
  801e07:	53                   	push   %ebx
  801e08:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e0b:	83 ec 0c             	sub    $0xc,%esp
  801e0e:	ff 75 08             	pushl  0x8(%ebp)
  801e11:	e8 6a f3 ff ff       	call   801180 <fd2data>
  801e16:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e18:	83 c4 08             	add    $0x8,%esp
  801e1b:	68 08 2d 80 00       	push   $0x802d08
  801e20:	53                   	push   %ebx
  801e21:	e8 ee eb ff ff       	call   800a14 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e26:	8b 46 04             	mov    0x4(%esi),%eax
  801e29:	2b 06                	sub    (%esi),%eax
  801e2b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e31:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e38:	00 00 00 
	stat->st_dev = &devpipe;
  801e3b:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801e42:	30 80 00 
	return 0;
}
  801e45:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e4d:	5b                   	pop    %ebx
  801e4e:	5e                   	pop    %esi
  801e4f:	5d                   	pop    %ebp
  801e50:	c3                   	ret    

00801e51 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	53                   	push   %ebx
  801e55:	83 ec 0c             	sub    $0xc,%esp
  801e58:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e5b:	53                   	push   %ebx
  801e5c:	6a 00                	push   $0x0
  801e5e:	e8 28 f0 ff ff       	call   800e8b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e63:	89 1c 24             	mov    %ebx,(%esp)
  801e66:	e8 15 f3 ff ff       	call   801180 <fd2data>
  801e6b:	83 c4 08             	add    $0x8,%esp
  801e6e:	50                   	push   %eax
  801e6f:	6a 00                	push   $0x0
  801e71:	e8 15 f0 ff ff       	call   800e8b <sys_page_unmap>
}
  801e76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e79:	c9                   	leave  
  801e7a:	c3                   	ret    

00801e7b <_pipeisclosed>:
{
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
  801e7e:	57                   	push   %edi
  801e7f:	56                   	push   %esi
  801e80:	53                   	push   %ebx
  801e81:	83 ec 1c             	sub    $0x1c,%esp
  801e84:	89 c7                	mov    %eax,%edi
  801e86:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e88:	a1 08 40 80 00       	mov    0x804008,%eax
  801e8d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e90:	83 ec 0c             	sub    $0xc,%esp
  801e93:	57                   	push   %edi
  801e94:	e8 29 05 00 00       	call   8023c2 <pageref>
  801e99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e9c:	89 34 24             	mov    %esi,(%esp)
  801e9f:	e8 1e 05 00 00       	call   8023c2 <pageref>
		nn = thisenv->env_runs;
  801ea4:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801eaa:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ead:	83 c4 10             	add    $0x10,%esp
  801eb0:	39 cb                	cmp    %ecx,%ebx
  801eb2:	74 1b                	je     801ecf <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801eb4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801eb7:	75 cf                	jne    801e88 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801eb9:	8b 42 58             	mov    0x58(%edx),%eax
  801ebc:	6a 01                	push   $0x1
  801ebe:	50                   	push   %eax
  801ebf:	53                   	push   %ebx
  801ec0:	68 0f 2d 80 00       	push   $0x802d0f
  801ec5:	e8 eb e3 ff ff       	call   8002b5 <cprintf>
  801eca:	83 c4 10             	add    $0x10,%esp
  801ecd:	eb b9                	jmp    801e88 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801ecf:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ed2:	0f 94 c0             	sete   %al
  801ed5:	0f b6 c0             	movzbl %al,%eax
}
  801ed8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801edb:	5b                   	pop    %ebx
  801edc:	5e                   	pop    %esi
  801edd:	5f                   	pop    %edi
  801ede:	5d                   	pop    %ebp
  801edf:	c3                   	ret    

00801ee0 <devpipe_write>:
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	57                   	push   %edi
  801ee4:	56                   	push   %esi
  801ee5:	53                   	push   %ebx
  801ee6:	83 ec 28             	sub    $0x28,%esp
  801ee9:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801eec:	56                   	push   %esi
  801eed:	e8 8e f2 ff ff       	call   801180 <fd2data>
  801ef2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ef4:	83 c4 10             	add    $0x10,%esp
  801ef7:	bf 00 00 00 00       	mov    $0x0,%edi
  801efc:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801eff:	74 4f                	je     801f50 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f01:	8b 43 04             	mov    0x4(%ebx),%eax
  801f04:	8b 0b                	mov    (%ebx),%ecx
  801f06:	8d 51 20             	lea    0x20(%ecx),%edx
  801f09:	39 d0                	cmp    %edx,%eax
  801f0b:	72 14                	jb     801f21 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801f0d:	89 da                	mov    %ebx,%edx
  801f0f:	89 f0                	mov    %esi,%eax
  801f11:	e8 65 ff ff ff       	call   801e7b <_pipeisclosed>
  801f16:	85 c0                	test   %eax,%eax
  801f18:	75 3b                	jne    801f55 <devpipe_write+0x75>
			sys_yield();
  801f1a:	e8 c8 ee ff ff       	call   800de7 <sys_yield>
  801f1f:	eb e0                	jmp    801f01 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f24:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f28:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f2b:	89 c2                	mov    %eax,%edx
  801f2d:	c1 fa 1f             	sar    $0x1f,%edx
  801f30:	89 d1                	mov    %edx,%ecx
  801f32:	c1 e9 1b             	shr    $0x1b,%ecx
  801f35:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801f38:	83 e2 1f             	and    $0x1f,%edx
  801f3b:	29 ca                	sub    %ecx,%edx
  801f3d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f41:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f45:	83 c0 01             	add    $0x1,%eax
  801f48:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f4b:	83 c7 01             	add    $0x1,%edi
  801f4e:	eb ac                	jmp    801efc <devpipe_write+0x1c>
	return i;
  801f50:	8b 45 10             	mov    0x10(%ebp),%eax
  801f53:	eb 05                	jmp    801f5a <devpipe_write+0x7a>
				return 0;
  801f55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f5d:	5b                   	pop    %ebx
  801f5e:	5e                   	pop    %esi
  801f5f:	5f                   	pop    %edi
  801f60:	5d                   	pop    %ebp
  801f61:	c3                   	ret    

00801f62 <devpipe_read>:
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
  801f65:	57                   	push   %edi
  801f66:	56                   	push   %esi
  801f67:	53                   	push   %ebx
  801f68:	83 ec 18             	sub    $0x18,%esp
  801f6b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f6e:	57                   	push   %edi
  801f6f:	e8 0c f2 ff ff       	call   801180 <fd2data>
  801f74:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f76:	83 c4 10             	add    $0x10,%esp
  801f79:	be 00 00 00 00       	mov    $0x0,%esi
  801f7e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f81:	75 14                	jne    801f97 <devpipe_read+0x35>
	return i;
  801f83:	8b 45 10             	mov    0x10(%ebp),%eax
  801f86:	eb 02                	jmp    801f8a <devpipe_read+0x28>
				return i;
  801f88:	89 f0                	mov    %esi,%eax
}
  801f8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f8d:	5b                   	pop    %ebx
  801f8e:	5e                   	pop    %esi
  801f8f:	5f                   	pop    %edi
  801f90:	5d                   	pop    %ebp
  801f91:	c3                   	ret    
			sys_yield();
  801f92:	e8 50 ee ff ff       	call   800de7 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801f97:	8b 03                	mov    (%ebx),%eax
  801f99:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f9c:	75 18                	jne    801fb6 <devpipe_read+0x54>
			if (i > 0)
  801f9e:	85 f6                	test   %esi,%esi
  801fa0:	75 e6                	jne    801f88 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801fa2:	89 da                	mov    %ebx,%edx
  801fa4:	89 f8                	mov    %edi,%eax
  801fa6:	e8 d0 fe ff ff       	call   801e7b <_pipeisclosed>
  801fab:	85 c0                	test   %eax,%eax
  801fad:	74 e3                	je     801f92 <devpipe_read+0x30>
				return 0;
  801faf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb4:	eb d4                	jmp    801f8a <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801fb6:	99                   	cltd   
  801fb7:	c1 ea 1b             	shr    $0x1b,%edx
  801fba:	01 d0                	add    %edx,%eax
  801fbc:	83 e0 1f             	and    $0x1f,%eax
  801fbf:	29 d0                	sub    %edx,%eax
  801fc1:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801fc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fc9:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801fcc:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801fcf:	83 c6 01             	add    $0x1,%esi
  801fd2:	eb aa                	jmp    801f7e <devpipe_read+0x1c>

00801fd4 <pipe>:
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
  801fd7:	56                   	push   %esi
  801fd8:	53                   	push   %ebx
  801fd9:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801fdc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fdf:	50                   	push   %eax
  801fe0:	e8 b2 f1 ff ff       	call   801197 <fd_alloc>
  801fe5:	89 c3                	mov    %eax,%ebx
  801fe7:	83 c4 10             	add    $0x10,%esp
  801fea:	85 c0                	test   %eax,%eax
  801fec:	0f 88 23 01 00 00    	js     802115 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ff2:	83 ec 04             	sub    $0x4,%esp
  801ff5:	68 07 04 00 00       	push   $0x407
  801ffa:	ff 75 f4             	pushl  -0xc(%ebp)
  801ffd:	6a 00                	push   $0x0
  801fff:	e8 02 ee ff ff       	call   800e06 <sys_page_alloc>
  802004:	89 c3                	mov    %eax,%ebx
  802006:	83 c4 10             	add    $0x10,%esp
  802009:	85 c0                	test   %eax,%eax
  80200b:	0f 88 04 01 00 00    	js     802115 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802011:	83 ec 0c             	sub    $0xc,%esp
  802014:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802017:	50                   	push   %eax
  802018:	e8 7a f1 ff ff       	call   801197 <fd_alloc>
  80201d:	89 c3                	mov    %eax,%ebx
  80201f:	83 c4 10             	add    $0x10,%esp
  802022:	85 c0                	test   %eax,%eax
  802024:	0f 88 db 00 00 00    	js     802105 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80202a:	83 ec 04             	sub    $0x4,%esp
  80202d:	68 07 04 00 00       	push   $0x407
  802032:	ff 75 f0             	pushl  -0x10(%ebp)
  802035:	6a 00                	push   $0x0
  802037:	e8 ca ed ff ff       	call   800e06 <sys_page_alloc>
  80203c:	89 c3                	mov    %eax,%ebx
  80203e:	83 c4 10             	add    $0x10,%esp
  802041:	85 c0                	test   %eax,%eax
  802043:	0f 88 bc 00 00 00    	js     802105 <pipe+0x131>
	va = fd2data(fd0);
  802049:	83 ec 0c             	sub    $0xc,%esp
  80204c:	ff 75 f4             	pushl  -0xc(%ebp)
  80204f:	e8 2c f1 ff ff       	call   801180 <fd2data>
  802054:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802056:	83 c4 0c             	add    $0xc,%esp
  802059:	68 07 04 00 00       	push   $0x407
  80205e:	50                   	push   %eax
  80205f:	6a 00                	push   $0x0
  802061:	e8 a0 ed ff ff       	call   800e06 <sys_page_alloc>
  802066:	89 c3                	mov    %eax,%ebx
  802068:	83 c4 10             	add    $0x10,%esp
  80206b:	85 c0                	test   %eax,%eax
  80206d:	0f 88 82 00 00 00    	js     8020f5 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802073:	83 ec 0c             	sub    $0xc,%esp
  802076:	ff 75 f0             	pushl  -0x10(%ebp)
  802079:	e8 02 f1 ff ff       	call   801180 <fd2data>
  80207e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802085:	50                   	push   %eax
  802086:	6a 00                	push   $0x0
  802088:	56                   	push   %esi
  802089:	6a 00                	push   $0x0
  80208b:	e8 b9 ed ff ff       	call   800e49 <sys_page_map>
  802090:	89 c3                	mov    %eax,%ebx
  802092:	83 c4 20             	add    $0x20,%esp
  802095:	85 c0                	test   %eax,%eax
  802097:	78 4e                	js     8020e7 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802099:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80209e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a1:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8020a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a6:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8020ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020b0:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8020b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8020bc:	83 ec 0c             	sub    $0xc,%esp
  8020bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8020c2:	e8 a9 f0 ff ff       	call   801170 <fd2num>
  8020c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020ca:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8020cc:	83 c4 04             	add    $0x4,%esp
  8020cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8020d2:	e8 99 f0 ff ff       	call   801170 <fd2num>
  8020d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020da:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8020dd:	83 c4 10             	add    $0x10,%esp
  8020e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020e5:	eb 2e                	jmp    802115 <pipe+0x141>
	sys_page_unmap(0, va);
  8020e7:	83 ec 08             	sub    $0x8,%esp
  8020ea:	56                   	push   %esi
  8020eb:	6a 00                	push   $0x0
  8020ed:	e8 99 ed ff ff       	call   800e8b <sys_page_unmap>
  8020f2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8020f5:	83 ec 08             	sub    $0x8,%esp
  8020f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8020fb:	6a 00                	push   $0x0
  8020fd:	e8 89 ed ff ff       	call   800e8b <sys_page_unmap>
  802102:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802105:	83 ec 08             	sub    $0x8,%esp
  802108:	ff 75 f4             	pushl  -0xc(%ebp)
  80210b:	6a 00                	push   $0x0
  80210d:	e8 79 ed ff ff       	call   800e8b <sys_page_unmap>
  802112:	83 c4 10             	add    $0x10,%esp
}
  802115:	89 d8                	mov    %ebx,%eax
  802117:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80211a:	5b                   	pop    %ebx
  80211b:	5e                   	pop    %esi
  80211c:	5d                   	pop    %ebp
  80211d:	c3                   	ret    

0080211e <pipeisclosed>:
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
  802121:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802124:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802127:	50                   	push   %eax
  802128:	ff 75 08             	pushl  0x8(%ebp)
  80212b:	e8 b9 f0 ff ff       	call   8011e9 <fd_lookup>
  802130:	83 c4 10             	add    $0x10,%esp
  802133:	85 c0                	test   %eax,%eax
  802135:	78 18                	js     80214f <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802137:	83 ec 0c             	sub    $0xc,%esp
  80213a:	ff 75 f4             	pushl  -0xc(%ebp)
  80213d:	e8 3e f0 ff ff       	call   801180 <fd2data>
	return _pipeisclosed(fd, p);
  802142:	89 c2                	mov    %eax,%edx
  802144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802147:	e8 2f fd ff ff       	call   801e7b <_pipeisclosed>
  80214c:	83 c4 10             	add    $0x10,%esp
}
  80214f:	c9                   	leave  
  802150:	c3                   	ret    

00802151 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802151:	b8 00 00 00 00       	mov    $0x0,%eax
  802156:	c3                   	ret    

00802157 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
  80215a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80215d:	68 27 2d 80 00       	push   $0x802d27
  802162:	ff 75 0c             	pushl  0xc(%ebp)
  802165:	e8 aa e8 ff ff       	call   800a14 <strcpy>
	return 0;
}
  80216a:	b8 00 00 00 00       	mov    $0x0,%eax
  80216f:	c9                   	leave  
  802170:	c3                   	ret    

00802171 <devcons_write>:
{
  802171:	55                   	push   %ebp
  802172:	89 e5                	mov    %esp,%ebp
  802174:	57                   	push   %edi
  802175:	56                   	push   %esi
  802176:	53                   	push   %ebx
  802177:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80217d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802182:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802188:	3b 75 10             	cmp    0x10(%ebp),%esi
  80218b:	73 31                	jae    8021be <devcons_write+0x4d>
		m = n - tot;
  80218d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802190:	29 f3                	sub    %esi,%ebx
  802192:	83 fb 7f             	cmp    $0x7f,%ebx
  802195:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80219a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80219d:	83 ec 04             	sub    $0x4,%esp
  8021a0:	53                   	push   %ebx
  8021a1:	89 f0                	mov    %esi,%eax
  8021a3:	03 45 0c             	add    0xc(%ebp),%eax
  8021a6:	50                   	push   %eax
  8021a7:	57                   	push   %edi
  8021a8:	e8 f5 e9 ff ff       	call   800ba2 <memmove>
		sys_cputs(buf, m);
  8021ad:	83 c4 08             	add    $0x8,%esp
  8021b0:	53                   	push   %ebx
  8021b1:	57                   	push   %edi
  8021b2:	e8 93 eb ff ff       	call   800d4a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8021b7:	01 de                	add    %ebx,%esi
  8021b9:	83 c4 10             	add    $0x10,%esp
  8021bc:	eb ca                	jmp    802188 <devcons_write+0x17>
}
  8021be:	89 f0                	mov    %esi,%eax
  8021c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021c3:	5b                   	pop    %ebx
  8021c4:	5e                   	pop    %esi
  8021c5:	5f                   	pop    %edi
  8021c6:	5d                   	pop    %ebp
  8021c7:	c3                   	ret    

008021c8 <devcons_read>:
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
  8021cb:	83 ec 08             	sub    $0x8,%esp
  8021ce:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8021d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021d7:	74 21                	je     8021fa <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8021d9:	e8 8a eb ff ff       	call   800d68 <sys_cgetc>
  8021de:	85 c0                	test   %eax,%eax
  8021e0:	75 07                	jne    8021e9 <devcons_read+0x21>
		sys_yield();
  8021e2:	e8 00 ec ff ff       	call   800de7 <sys_yield>
  8021e7:	eb f0                	jmp    8021d9 <devcons_read+0x11>
	if (c < 0)
  8021e9:	78 0f                	js     8021fa <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8021eb:	83 f8 04             	cmp    $0x4,%eax
  8021ee:	74 0c                	je     8021fc <devcons_read+0x34>
	*(char*)vbuf = c;
  8021f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f3:	88 02                	mov    %al,(%edx)
	return 1;
  8021f5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8021fa:	c9                   	leave  
  8021fb:	c3                   	ret    
		return 0;
  8021fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802201:	eb f7                	jmp    8021fa <devcons_read+0x32>

00802203 <cputchar>:
{
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
  802206:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802209:	8b 45 08             	mov    0x8(%ebp),%eax
  80220c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80220f:	6a 01                	push   $0x1
  802211:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802214:	50                   	push   %eax
  802215:	e8 30 eb ff ff       	call   800d4a <sys_cputs>
}
  80221a:	83 c4 10             	add    $0x10,%esp
  80221d:	c9                   	leave  
  80221e:	c3                   	ret    

0080221f <getchar>:
{
  80221f:	55                   	push   %ebp
  802220:	89 e5                	mov    %esp,%ebp
  802222:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802225:	6a 01                	push   $0x1
  802227:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80222a:	50                   	push   %eax
  80222b:	6a 00                	push   $0x0
  80222d:	e8 27 f2 ff ff       	call   801459 <read>
	if (r < 0)
  802232:	83 c4 10             	add    $0x10,%esp
  802235:	85 c0                	test   %eax,%eax
  802237:	78 06                	js     80223f <getchar+0x20>
	if (r < 1)
  802239:	74 06                	je     802241 <getchar+0x22>
	return c;
  80223b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80223f:	c9                   	leave  
  802240:	c3                   	ret    
		return -E_EOF;
  802241:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802246:	eb f7                	jmp    80223f <getchar+0x20>

00802248 <iscons>:
{
  802248:	55                   	push   %ebp
  802249:	89 e5                	mov    %esp,%ebp
  80224b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80224e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802251:	50                   	push   %eax
  802252:	ff 75 08             	pushl  0x8(%ebp)
  802255:	e8 8f ef ff ff       	call   8011e9 <fd_lookup>
  80225a:	83 c4 10             	add    $0x10,%esp
  80225d:	85 c0                	test   %eax,%eax
  80225f:	78 11                	js     802272 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802264:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80226a:	39 10                	cmp    %edx,(%eax)
  80226c:	0f 94 c0             	sete   %al
  80226f:	0f b6 c0             	movzbl %al,%eax
}
  802272:	c9                   	leave  
  802273:	c3                   	ret    

00802274 <opencons>:
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
  802277:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80227a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80227d:	50                   	push   %eax
  80227e:	e8 14 ef ff ff       	call   801197 <fd_alloc>
  802283:	83 c4 10             	add    $0x10,%esp
  802286:	85 c0                	test   %eax,%eax
  802288:	78 3a                	js     8022c4 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80228a:	83 ec 04             	sub    $0x4,%esp
  80228d:	68 07 04 00 00       	push   $0x407
  802292:	ff 75 f4             	pushl  -0xc(%ebp)
  802295:	6a 00                	push   $0x0
  802297:	e8 6a eb ff ff       	call   800e06 <sys_page_alloc>
  80229c:	83 c4 10             	add    $0x10,%esp
  80229f:	85 c0                	test   %eax,%eax
  8022a1:	78 21                	js     8022c4 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8022a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a6:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022ac:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022b8:	83 ec 0c             	sub    $0xc,%esp
  8022bb:	50                   	push   %eax
  8022bc:	e8 af ee ff ff       	call   801170 <fd2num>
  8022c1:	83 c4 10             	add    $0x10,%esp
}
  8022c4:	c9                   	leave  
  8022c5:	c3                   	ret    

008022c6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022c6:	55                   	push   %ebp
  8022c7:	89 e5                	mov    %esp,%ebp
  8022c9:	56                   	push   %esi
  8022ca:	53                   	push   %ebx
  8022cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8022ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8022d4:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8022d6:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022db:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8022de:	83 ec 0c             	sub    $0xc,%esp
  8022e1:	50                   	push   %eax
  8022e2:	e8 cf ec ff ff       	call   800fb6 <sys_ipc_recv>
	if(ret < 0){
  8022e7:	83 c4 10             	add    $0x10,%esp
  8022ea:	85 c0                	test   %eax,%eax
  8022ec:	78 2b                	js     802319 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8022ee:	85 f6                	test   %esi,%esi
  8022f0:	74 0a                	je     8022fc <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8022f2:	a1 08 40 80 00       	mov    0x804008,%eax
  8022f7:	8b 40 74             	mov    0x74(%eax),%eax
  8022fa:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8022fc:	85 db                	test   %ebx,%ebx
  8022fe:	74 0a                	je     80230a <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  802300:	a1 08 40 80 00       	mov    0x804008,%eax
  802305:	8b 40 78             	mov    0x78(%eax),%eax
  802308:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  80230a:	a1 08 40 80 00       	mov    0x804008,%eax
  80230f:	8b 40 70             	mov    0x70(%eax),%eax
}
  802312:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802315:	5b                   	pop    %ebx
  802316:	5e                   	pop    %esi
  802317:	5d                   	pop    %ebp
  802318:	c3                   	ret    
		if(from_env_store)
  802319:	85 f6                	test   %esi,%esi
  80231b:	74 06                	je     802323 <ipc_recv+0x5d>
			*from_env_store = 0;
  80231d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802323:	85 db                	test   %ebx,%ebx
  802325:	74 eb                	je     802312 <ipc_recv+0x4c>
			*perm_store = 0;
  802327:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80232d:	eb e3                	jmp    802312 <ipc_recv+0x4c>

0080232f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
  802332:	57                   	push   %edi
  802333:	56                   	push   %esi
  802334:	53                   	push   %ebx
  802335:	83 ec 0c             	sub    $0xc,%esp
  802338:	8b 7d 08             	mov    0x8(%ebp),%edi
  80233b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80233e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802341:	85 db                	test   %ebx,%ebx
  802343:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802348:	0f 44 d8             	cmove  %eax,%ebx
  80234b:	eb 05                	jmp    802352 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80234d:	e8 95 ea ff ff       	call   800de7 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802352:	ff 75 14             	pushl  0x14(%ebp)
  802355:	53                   	push   %ebx
  802356:	56                   	push   %esi
  802357:	57                   	push   %edi
  802358:	e8 36 ec ff ff       	call   800f93 <sys_ipc_try_send>
  80235d:	83 c4 10             	add    $0x10,%esp
  802360:	85 c0                	test   %eax,%eax
  802362:	74 1b                	je     80237f <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802364:	79 e7                	jns    80234d <ipc_send+0x1e>
  802366:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802369:	74 e2                	je     80234d <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80236b:	83 ec 04             	sub    $0x4,%esp
  80236e:	68 33 2d 80 00       	push   $0x802d33
  802373:	6a 48                	push   $0x48
  802375:	68 48 2d 80 00       	push   $0x802d48
  80237a:	e8 40 de ff ff       	call   8001bf <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80237f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802382:	5b                   	pop    %ebx
  802383:	5e                   	pop    %esi
  802384:	5f                   	pop    %edi
  802385:	5d                   	pop    %ebp
  802386:	c3                   	ret    

00802387 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802387:	55                   	push   %ebp
  802388:	89 e5                	mov    %esp,%ebp
  80238a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80238d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802392:	89 c2                	mov    %eax,%edx
  802394:	c1 e2 07             	shl    $0x7,%edx
  802397:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80239d:	8b 52 50             	mov    0x50(%edx),%edx
  8023a0:	39 ca                	cmp    %ecx,%edx
  8023a2:	74 11                	je     8023b5 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8023a4:	83 c0 01             	add    $0x1,%eax
  8023a7:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023ac:	75 e4                	jne    802392 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8023ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b3:	eb 0b                	jmp    8023c0 <ipc_find_env+0x39>
			return envs[i].env_id;
  8023b5:	c1 e0 07             	shl    $0x7,%eax
  8023b8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8023bd:	8b 40 48             	mov    0x48(%eax),%eax
}
  8023c0:	5d                   	pop    %ebp
  8023c1:	c3                   	ret    

008023c2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023c2:	55                   	push   %ebp
  8023c3:	89 e5                	mov    %esp,%ebp
  8023c5:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023c8:	89 d0                	mov    %edx,%eax
  8023ca:	c1 e8 16             	shr    $0x16,%eax
  8023cd:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023d4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8023d9:	f6 c1 01             	test   $0x1,%cl
  8023dc:	74 1d                	je     8023fb <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8023de:	c1 ea 0c             	shr    $0xc,%edx
  8023e1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023e8:	f6 c2 01             	test   $0x1,%dl
  8023eb:	74 0e                	je     8023fb <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023ed:	c1 ea 0c             	shr    $0xc,%edx
  8023f0:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023f7:	ef 
  8023f8:	0f b7 c0             	movzwl %ax,%eax
}
  8023fb:	5d                   	pop    %ebp
  8023fc:	c3                   	ret    
  8023fd:	66 90                	xchg   %ax,%ax
  8023ff:	90                   	nop

00802400 <__udivdi3>:
  802400:	55                   	push   %ebp
  802401:	57                   	push   %edi
  802402:	56                   	push   %esi
  802403:	53                   	push   %ebx
  802404:	83 ec 1c             	sub    $0x1c,%esp
  802407:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80240b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80240f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802413:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802417:	85 d2                	test   %edx,%edx
  802419:	75 4d                	jne    802468 <__udivdi3+0x68>
  80241b:	39 f3                	cmp    %esi,%ebx
  80241d:	76 19                	jbe    802438 <__udivdi3+0x38>
  80241f:	31 ff                	xor    %edi,%edi
  802421:	89 e8                	mov    %ebp,%eax
  802423:	89 f2                	mov    %esi,%edx
  802425:	f7 f3                	div    %ebx
  802427:	89 fa                	mov    %edi,%edx
  802429:	83 c4 1c             	add    $0x1c,%esp
  80242c:	5b                   	pop    %ebx
  80242d:	5e                   	pop    %esi
  80242e:	5f                   	pop    %edi
  80242f:	5d                   	pop    %ebp
  802430:	c3                   	ret    
  802431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802438:	89 d9                	mov    %ebx,%ecx
  80243a:	85 db                	test   %ebx,%ebx
  80243c:	75 0b                	jne    802449 <__udivdi3+0x49>
  80243e:	b8 01 00 00 00       	mov    $0x1,%eax
  802443:	31 d2                	xor    %edx,%edx
  802445:	f7 f3                	div    %ebx
  802447:	89 c1                	mov    %eax,%ecx
  802449:	31 d2                	xor    %edx,%edx
  80244b:	89 f0                	mov    %esi,%eax
  80244d:	f7 f1                	div    %ecx
  80244f:	89 c6                	mov    %eax,%esi
  802451:	89 e8                	mov    %ebp,%eax
  802453:	89 f7                	mov    %esi,%edi
  802455:	f7 f1                	div    %ecx
  802457:	89 fa                	mov    %edi,%edx
  802459:	83 c4 1c             	add    $0x1c,%esp
  80245c:	5b                   	pop    %ebx
  80245d:	5e                   	pop    %esi
  80245e:	5f                   	pop    %edi
  80245f:	5d                   	pop    %ebp
  802460:	c3                   	ret    
  802461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802468:	39 f2                	cmp    %esi,%edx
  80246a:	77 1c                	ja     802488 <__udivdi3+0x88>
  80246c:	0f bd fa             	bsr    %edx,%edi
  80246f:	83 f7 1f             	xor    $0x1f,%edi
  802472:	75 2c                	jne    8024a0 <__udivdi3+0xa0>
  802474:	39 f2                	cmp    %esi,%edx
  802476:	72 06                	jb     80247e <__udivdi3+0x7e>
  802478:	31 c0                	xor    %eax,%eax
  80247a:	39 eb                	cmp    %ebp,%ebx
  80247c:	77 a9                	ja     802427 <__udivdi3+0x27>
  80247e:	b8 01 00 00 00       	mov    $0x1,%eax
  802483:	eb a2                	jmp    802427 <__udivdi3+0x27>
  802485:	8d 76 00             	lea    0x0(%esi),%esi
  802488:	31 ff                	xor    %edi,%edi
  80248a:	31 c0                	xor    %eax,%eax
  80248c:	89 fa                	mov    %edi,%edx
  80248e:	83 c4 1c             	add    $0x1c,%esp
  802491:	5b                   	pop    %ebx
  802492:	5e                   	pop    %esi
  802493:	5f                   	pop    %edi
  802494:	5d                   	pop    %ebp
  802495:	c3                   	ret    
  802496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80249d:	8d 76 00             	lea    0x0(%esi),%esi
  8024a0:	89 f9                	mov    %edi,%ecx
  8024a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8024a7:	29 f8                	sub    %edi,%eax
  8024a9:	d3 e2                	shl    %cl,%edx
  8024ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024af:	89 c1                	mov    %eax,%ecx
  8024b1:	89 da                	mov    %ebx,%edx
  8024b3:	d3 ea                	shr    %cl,%edx
  8024b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024b9:	09 d1                	or     %edx,%ecx
  8024bb:	89 f2                	mov    %esi,%edx
  8024bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024c1:	89 f9                	mov    %edi,%ecx
  8024c3:	d3 e3                	shl    %cl,%ebx
  8024c5:	89 c1                	mov    %eax,%ecx
  8024c7:	d3 ea                	shr    %cl,%edx
  8024c9:	89 f9                	mov    %edi,%ecx
  8024cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8024cf:	89 eb                	mov    %ebp,%ebx
  8024d1:	d3 e6                	shl    %cl,%esi
  8024d3:	89 c1                	mov    %eax,%ecx
  8024d5:	d3 eb                	shr    %cl,%ebx
  8024d7:	09 de                	or     %ebx,%esi
  8024d9:	89 f0                	mov    %esi,%eax
  8024db:	f7 74 24 08          	divl   0x8(%esp)
  8024df:	89 d6                	mov    %edx,%esi
  8024e1:	89 c3                	mov    %eax,%ebx
  8024e3:	f7 64 24 0c          	mull   0xc(%esp)
  8024e7:	39 d6                	cmp    %edx,%esi
  8024e9:	72 15                	jb     802500 <__udivdi3+0x100>
  8024eb:	89 f9                	mov    %edi,%ecx
  8024ed:	d3 e5                	shl    %cl,%ebp
  8024ef:	39 c5                	cmp    %eax,%ebp
  8024f1:	73 04                	jae    8024f7 <__udivdi3+0xf7>
  8024f3:	39 d6                	cmp    %edx,%esi
  8024f5:	74 09                	je     802500 <__udivdi3+0x100>
  8024f7:	89 d8                	mov    %ebx,%eax
  8024f9:	31 ff                	xor    %edi,%edi
  8024fb:	e9 27 ff ff ff       	jmp    802427 <__udivdi3+0x27>
  802500:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802503:	31 ff                	xor    %edi,%edi
  802505:	e9 1d ff ff ff       	jmp    802427 <__udivdi3+0x27>
  80250a:	66 90                	xchg   %ax,%ax
  80250c:	66 90                	xchg   %ax,%ax
  80250e:	66 90                	xchg   %ax,%ax

00802510 <__umoddi3>:
  802510:	55                   	push   %ebp
  802511:	57                   	push   %edi
  802512:	56                   	push   %esi
  802513:	53                   	push   %ebx
  802514:	83 ec 1c             	sub    $0x1c,%esp
  802517:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80251b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80251f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802523:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802527:	89 da                	mov    %ebx,%edx
  802529:	85 c0                	test   %eax,%eax
  80252b:	75 43                	jne    802570 <__umoddi3+0x60>
  80252d:	39 df                	cmp    %ebx,%edi
  80252f:	76 17                	jbe    802548 <__umoddi3+0x38>
  802531:	89 f0                	mov    %esi,%eax
  802533:	f7 f7                	div    %edi
  802535:	89 d0                	mov    %edx,%eax
  802537:	31 d2                	xor    %edx,%edx
  802539:	83 c4 1c             	add    $0x1c,%esp
  80253c:	5b                   	pop    %ebx
  80253d:	5e                   	pop    %esi
  80253e:	5f                   	pop    %edi
  80253f:	5d                   	pop    %ebp
  802540:	c3                   	ret    
  802541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802548:	89 fd                	mov    %edi,%ebp
  80254a:	85 ff                	test   %edi,%edi
  80254c:	75 0b                	jne    802559 <__umoddi3+0x49>
  80254e:	b8 01 00 00 00       	mov    $0x1,%eax
  802553:	31 d2                	xor    %edx,%edx
  802555:	f7 f7                	div    %edi
  802557:	89 c5                	mov    %eax,%ebp
  802559:	89 d8                	mov    %ebx,%eax
  80255b:	31 d2                	xor    %edx,%edx
  80255d:	f7 f5                	div    %ebp
  80255f:	89 f0                	mov    %esi,%eax
  802561:	f7 f5                	div    %ebp
  802563:	89 d0                	mov    %edx,%eax
  802565:	eb d0                	jmp    802537 <__umoddi3+0x27>
  802567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80256e:	66 90                	xchg   %ax,%ax
  802570:	89 f1                	mov    %esi,%ecx
  802572:	39 d8                	cmp    %ebx,%eax
  802574:	76 0a                	jbe    802580 <__umoddi3+0x70>
  802576:	89 f0                	mov    %esi,%eax
  802578:	83 c4 1c             	add    $0x1c,%esp
  80257b:	5b                   	pop    %ebx
  80257c:	5e                   	pop    %esi
  80257d:	5f                   	pop    %edi
  80257e:	5d                   	pop    %ebp
  80257f:	c3                   	ret    
  802580:	0f bd e8             	bsr    %eax,%ebp
  802583:	83 f5 1f             	xor    $0x1f,%ebp
  802586:	75 20                	jne    8025a8 <__umoddi3+0x98>
  802588:	39 d8                	cmp    %ebx,%eax
  80258a:	0f 82 b0 00 00 00    	jb     802640 <__umoddi3+0x130>
  802590:	39 f7                	cmp    %esi,%edi
  802592:	0f 86 a8 00 00 00    	jbe    802640 <__umoddi3+0x130>
  802598:	89 c8                	mov    %ecx,%eax
  80259a:	83 c4 1c             	add    $0x1c,%esp
  80259d:	5b                   	pop    %ebx
  80259e:	5e                   	pop    %esi
  80259f:	5f                   	pop    %edi
  8025a0:	5d                   	pop    %ebp
  8025a1:	c3                   	ret    
  8025a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025a8:	89 e9                	mov    %ebp,%ecx
  8025aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8025af:	29 ea                	sub    %ebp,%edx
  8025b1:	d3 e0                	shl    %cl,%eax
  8025b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025b7:	89 d1                	mov    %edx,%ecx
  8025b9:	89 f8                	mov    %edi,%eax
  8025bb:	d3 e8                	shr    %cl,%eax
  8025bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025c9:	09 c1                	or     %eax,%ecx
  8025cb:	89 d8                	mov    %ebx,%eax
  8025cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025d1:	89 e9                	mov    %ebp,%ecx
  8025d3:	d3 e7                	shl    %cl,%edi
  8025d5:	89 d1                	mov    %edx,%ecx
  8025d7:	d3 e8                	shr    %cl,%eax
  8025d9:	89 e9                	mov    %ebp,%ecx
  8025db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025df:	d3 e3                	shl    %cl,%ebx
  8025e1:	89 c7                	mov    %eax,%edi
  8025e3:	89 d1                	mov    %edx,%ecx
  8025e5:	89 f0                	mov    %esi,%eax
  8025e7:	d3 e8                	shr    %cl,%eax
  8025e9:	89 e9                	mov    %ebp,%ecx
  8025eb:	89 fa                	mov    %edi,%edx
  8025ed:	d3 e6                	shl    %cl,%esi
  8025ef:	09 d8                	or     %ebx,%eax
  8025f1:	f7 74 24 08          	divl   0x8(%esp)
  8025f5:	89 d1                	mov    %edx,%ecx
  8025f7:	89 f3                	mov    %esi,%ebx
  8025f9:	f7 64 24 0c          	mull   0xc(%esp)
  8025fd:	89 c6                	mov    %eax,%esi
  8025ff:	89 d7                	mov    %edx,%edi
  802601:	39 d1                	cmp    %edx,%ecx
  802603:	72 06                	jb     80260b <__umoddi3+0xfb>
  802605:	75 10                	jne    802617 <__umoddi3+0x107>
  802607:	39 c3                	cmp    %eax,%ebx
  802609:	73 0c                	jae    802617 <__umoddi3+0x107>
  80260b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80260f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802613:	89 d7                	mov    %edx,%edi
  802615:	89 c6                	mov    %eax,%esi
  802617:	89 ca                	mov    %ecx,%edx
  802619:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80261e:	29 f3                	sub    %esi,%ebx
  802620:	19 fa                	sbb    %edi,%edx
  802622:	89 d0                	mov    %edx,%eax
  802624:	d3 e0                	shl    %cl,%eax
  802626:	89 e9                	mov    %ebp,%ecx
  802628:	d3 eb                	shr    %cl,%ebx
  80262a:	d3 ea                	shr    %cl,%edx
  80262c:	09 d8                	or     %ebx,%eax
  80262e:	83 c4 1c             	add    $0x1c,%esp
  802631:	5b                   	pop    %ebx
  802632:	5e                   	pop    %esi
  802633:	5f                   	pop    %edi
  802634:	5d                   	pop    %ebp
  802635:	c3                   	ret    
  802636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80263d:	8d 76 00             	lea    0x0(%esi),%esi
  802640:	89 da                	mov    %ebx,%edx
  802642:	29 fe                	sub    %edi,%esi
  802644:	19 c2                	sbb    %eax,%edx
  802646:	89 f1                	mov    %esi,%ecx
  802648:	89 c8                	mov    %ecx,%eax
  80264a:	e9 4b ff ff ff       	jmp    80259a <__umoddi3+0x8a>
