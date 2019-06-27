
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
  800045:	e8 85 02 00 00       	call   8002cf <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004a:	83 c4 0c             	add    $0xc,%esp
  80004d:	6a 07                	push   $0x7
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	50                   	push   %eax
  800057:	6a 00                	push   $0x0
  800059:	e8 c2 0d 00 00       	call   800e20 <sys_page_alloc>
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
  80006e:	e8 68 09 00 00       	call   8009db <snprintf>
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
  80008c:	e8 48 01 00 00       	call   8001d9 <_panic>

00800091 <umain>:

void
umain(int argc, char **argv)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800097:	68 33 00 80 00       	push   $0x800033
  80009c:	e8 74 10 00 00       	call   801115 <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	68 ef be ad de       	push   $0xdeadbeef
  8000a9:	68 68 27 80 00       	push   $0x802768
  8000ae:	e8 1c 02 00 00       	call   8002cf <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000b3:	83 c4 08             	add    $0x8,%esp
  8000b6:	68 fe bf fe ca       	push   $0xcafebffe
  8000bb:	68 68 27 80 00       	push   $0x802768
  8000c0:	e8 0a 02 00 00       	call   8002cf <cprintf>
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
  8000dd:	e8 00 0d 00 00       	call   800de2 <sys_getenvid>
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
  800102:	74 23                	je     800127 <libmain+0x5d>
		if(envs[i].env_id == find)
  800104:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  80010a:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800110:	8b 49 48             	mov    0x48(%ecx),%ecx
  800113:	39 c1                	cmp    %eax,%ecx
  800115:	75 e2                	jne    8000f9 <libmain+0x2f>
  800117:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  80011d:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800123:	89 fe                	mov    %edi,%esi
  800125:	eb d2                	jmp    8000f9 <libmain+0x2f>
  800127:	89 f0                	mov    %esi,%eax
  800129:	84 c0                	test   %al,%al
  80012b:	74 06                	je     800133 <libmain+0x69>
  80012d:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800133:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800137:	7e 0a                	jle    800143 <libmain+0x79>
		binaryname = argv[0];
  800139:	8b 45 0c             	mov    0xc(%ebp),%eax
  80013c:	8b 00                	mov    (%eax),%eax
  80013e:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  800143:	a1 08 40 80 00       	mov    0x804008,%eax
  800148:	8b 40 48             	mov    0x48(%eax),%eax
  80014b:	83 ec 08             	sub    $0x8,%esp
  80014e:	50                   	push   %eax
  80014f:	68 09 27 80 00       	push   $0x802709
  800154:	e8 76 01 00 00       	call   8002cf <cprintf>
	cprintf("before umain\n");
  800159:	c7 04 24 27 27 80 00 	movl   $0x802727,(%esp)
  800160:	e8 6a 01 00 00       	call   8002cf <cprintf>
	// call user main routine
	umain(argc, argv);
  800165:	83 c4 08             	add    $0x8,%esp
  800168:	ff 75 0c             	pushl  0xc(%ebp)
  80016b:	ff 75 08             	pushl  0x8(%ebp)
  80016e:	e8 1e ff ff ff       	call   800091 <umain>
	cprintf("after umain\n");
  800173:	c7 04 24 35 27 80 00 	movl   $0x802735,(%esp)
  80017a:	e8 50 01 00 00       	call   8002cf <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80017f:	a1 08 40 80 00       	mov    0x804008,%eax
  800184:	8b 40 48             	mov    0x48(%eax),%eax
  800187:	83 c4 08             	add    $0x8,%esp
  80018a:	50                   	push   %eax
  80018b:	68 42 27 80 00       	push   $0x802742
  800190:	e8 3a 01 00 00       	call   8002cf <cprintf>
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
  8001a8:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001ab:	a1 08 40 80 00       	mov    0x804008,%eax
  8001b0:	8b 40 48             	mov    0x48(%eax),%eax
  8001b3:	68 6c 27 80 00       	push   $0x80276c
  8001b8:	50                   	push   %eax
  8001b9:	68 61 27 80 00       	push   $0x802761
  8001be:	e8 0c 01 00 00       	call   8002cf <cprintf>
	close_all();
  8001c3:	e8 ba 11 00 00       	call   801382 <close_all>
	sys_env_destroy(0);
  8001c8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001cf:	e8 cd 0b 00 00       	call   800da1 <sys_env_destroy>
}
  8001d4:	83 c4 10             	add    $0x10,%esp
  8001d7:	c9                   	leave  
  8001d8:	c3                   	ret    

008001d9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001d9:	55                   	push   %ebp
  8001da:	89 e5                	mov    %esp,%ebp
  8001dc:	56                   	push   %esi
  8001dd:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001de:	a1 08 40 80 00       	mov    0x804008,%eax
  8001e3:	8b 40 48             	mov    0x48(%eax),%eax
  8001e6:	83 ec 04             	sub    $0x4,%esp
  8001e9:	68 98 27 80 00       	push   $0x802798
  8001ee:	50                   	push   %eax
  8001ef:	68 61 27 80 00       	push   $0x802761
  8001f4:	e8 d6 00 00 00       	call   8002cf <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8001f9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001fc:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800202:	e8 db 0b 00 00       	call   800de2 <sys_getenvid>
  800207:	83 c4 04             	add    $0x4,%esp
  80020a:	ff 75 0c             	pushl  0xc(%ebp)
  80020d:	ff 75 08             	pushl  0x8(%ebp)
  800210:	56                   	push   %esi
  800211:	50                   	push   %eax
  800212:	68 74 27 80 00       	push   $0x802774
  800217:	e8 b3 00 00 00       	call   8002cf <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80021c:	83 c4 18             	add    $0x18,%esp
  80021f:	53                   	push   %ebx
  800220:	ff 75 10             	pushl  0x10(%ebp)
  800223:	e8 56 00 00 00       	call   80027e <vcprintf>
	cprintf("\n");
  800228:	c7 04 24 25 27 80 00 	movl   $0x802725,(%esp)
  80022f:	e8 9b 00 00 00       	call   8002cf <cprintf>
  800234:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800237:	cc                   	int3   
  800238:	eb fd                	jmp    800237 <_panic+0x5e>

0080023a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80023a:	55                   	push   %ebp
  80023b:	89 e5                	mov    %esp,%ebp
  80023d:	53                   	push   %ebx
  80023e:	83 ec 04             	sub    $0x4,%esp
  800241:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800244:	8b 13                	mov    (%ebx),%edx
  800246:	8d 42 01             	lea    0x1(%edx),%eax
  800249:	89 03                	mov    %eax,(%ebx)
  80024b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80024e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800252:	3d ff 00 00 00       	cmp    $0xff,%eax
  800257:	74 09                	je     800262 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800259:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80025d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800260:	c9                   	leave  
  800261:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800262:	83 ec 08             	sub    $0x8,%esp
  800265:	68 ff 00 00 00       	push   $0xff
  80026a:	8d 43 08             	lea    0x8(%ebx),%eax
  80026d:	50                   	push   %eax
  80026e:	e8 f1 0a 00 00       	call   800d64 <sys_cputs>
		b->idx = 0;
  800273:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800279:	83 c4 10             	add    $0x10,%esp
  80027c:	eb db                	jmp    800259 <putch+0x1f>

0080027e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80027e:	55                   	push   %ebp
  80027f:	89 e5                	mov    %esp,%ebp
  800281:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800287:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80028e:	00 00 00 
	b.cnt = 0;
  800291:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800298:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80029b:	ff 75 0c             	pushl  0xc(%ebp)
  80029e:	ff 75 08             	pushl  0x8(%ebp)
  8002a1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a7:	50                   	push   %eax
  8002a8:	68 3a 02 80 00       	push   $0x80023a
  8002ad:	e8 4a 01 00 00       	call   8003fc <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002b2:	83 c4 08             	add    $0x8,%esp
  8002b5:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002bb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002c1:	50                   	push   %eax
  8002c2:	e8 9d 0a 00 00       	call   800d64 <sys_cputs>

	return b.cnt;
}
  8002c7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002cd:	c9                   	leave  
  8002ce:	c3                   	ret    

008002cf <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002d5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002d8:	50                   	push   %eax
  8002d9:	ff 75 08             	pushl  0x8(%ebp)
  8002dc:	e8 9d ff ff ff       	call   80027e <vcprintf>
	va_end(ap);

	return cnt;
}
  8002e1:	c9                   	leave  
  8002e2:	c3                   	ret    

008002e3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	57                   	push   %edi
  8002e7:	56                   	push   %esi
  8002e8:	53                   	push   %ebx
  8002e9:	83 ec 1c             	sub    $0x1c,%esp
  8002ec:	89 c6                	mov    %eax,%esi
  8002ee:	89 d7                	mov    %edx,%edi
  8002f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002f9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ff:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800302:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800306:	74 2c                	je     800334 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800308:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80030b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800312:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800315:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800318:	39 c2                	cmp    %eax,%edx
  80031a:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80031d:	73 43                	jae    800362 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80031f:	83 eb 01             	sub    $0x1,%ebx
  800322:	85 db                	test   %ebx,%ebx
  800324:	7e 6c                	jle    800392 <printnum+0xaf>
				putch(padc, putdat);
  800326:	83 ec 08             	sub    $0x8,%esp
  800329:	57                   	push   %edi
  80032a:	ff 75 18             	pushl  0x18(%ebp)
  80032d:	ff d6                	call   *%esi
  80032f:	83 c4 10             	add    $0x10,%esp
  800332:	eb eb                	jmp    80031f <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800334:	83 ec 0c             	sub    $0xc,%esp
  800337:	6a 20                	push   $0x20
  800339:	6a 00                	push   $0x0
  80033b:	50                   	push   %eax
  80033c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80033f:	ff 75 e0             	pushl  -0x20(%ebp)
  800342:	89 fa                	mov    %edi,%edx
  800344:	89 f0                	mov    %esi,%eax
  800346:	e8 98 ff ff ff       	call   8002e3 <printnum>
		while (--width > 0)
  80034b:	83 c4 20             	add    $0x20,%esp
  80034e:	83 eb 01             	sub    $0x1,%ebx
  800351:	85 db                	test   %ebx,%ebx
  800353:	7e 65                	jle    8003ba <printnum+0xd7>
			putch(padc, putdat);
  800355:	83 ec 08             	sub    $0x8,%esp
  800358:	57                   	push   %edi
  800359:	6a 20                	push   $0x20
  80035b:	ff d6                	call   *%esi
  80035d:	83 c4 10             	add    $0x10,%esp
  800360:	eb ec                	jmp    80034e <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800362:	83 ec 0c             	sub    $0xc,%esp
  800365:	ff 75 18             	pushl  0x18(%ebp)
  800368:	83 eb 01             	sub    $0x1,%ebx
  80036b:	53                   	push   %ebx
  80036c:	50                   	push   %eax
  80036d:	83 ec 08             	sub    $0x8,%esp
  800370:	ff 75 dc             	pushl  -0x24(%ebp)
  800373:	ff 75 d8             	pushl  -0x28(%ebp)
  800376:	ff 75 e4             	pushl  -0x1c(%ebp)
  800379:	ff 75 e0             	pushl  -0x20(%ebp)
  80037c:	e8 bf 20 00 00       	call   802440 <__udivdi3>
  800381:	83 c4 18             	add    $0x18,%esp
  800384:	52                   	push   %edx
  800385:	50                   	push   %eax
  800386:	89 fa                	mov    %edi,%edx
  800388:	89 f0                	mov    %esi,%eax
  80038a:	e8 54 ff ff ff       	call   8002e3 <printnum>
  80038f:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800392:	83 ec 08             	sub    $0x8,%esp
  800395:	57                   	push   %edi
  800396:	83 ec 04             	sub    $0x4,%esp
  800399:	ff 75 dc             	pushl  -0x24(%ebp)
  80039c:	ff 75 d8             	pushl  -0x28(%ebp)
  80039f:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a2:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a5:	e8 a6 21 00 00       	call   802550 <__umoddi3>
  8003aa:	83 c4 14             	add    $0x14,%esp
  8003ad:	0f be 80 9f 27 80 00 	movsbl 0x80279f(%eax),%eax
  8003b4:	50                   	push   %eax
  8003b5:	ff d6                	call   *%esi
  8003b7:	83 c4 10             	add    $0x10,%esp
	}
}
  8003ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003bd:	5b                   	pop    %ebx
  8003be:	5e                   	pop    %esi
  8003bf:	5f                   	pop    %edi
  8003c0:	5d                   	pop    %ebp
  8003c1:	c3                   	ret    

008003c2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003c2:	55                   	push   %ebp
  8003c3:	89 e5                	mov    %esp,%ebp
  8003c5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003c8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003cc:	8b 10                	mov    (%eax),%edx
  8003ce:	3b 50 04             	cmp    0x4(%eax),%edx
  8003d1:	73 0a                	jae    8003dd <sprintputch+0x1b>
		*b->buf++ = ch;
  8003d3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003d6:	89 08                	mov    %ecx,(%eax)
  8003d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003db:	88 02                	mov    %al,(%edx)
}
  8003dd:	5d                   	pop    %ebp
  8003de:	c3                   	ret    

008003df <printfmt>:
{
  8003df:	55                   	push   %ebp
  8003e0:	89 e5                	mov    %esp,%ebp
  8003e2:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003e5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003e8:	50                   	push   %eax
  8003e9:	ff 75 10             	pushl  0x10(%ebp)
  8003ec:	ff 75 0c             	pushl  0xc(%ebp)
  8003ef:	ff 75 08             	pushl  0x8(%ebp)
  8003f2:	e8 05 00 00 00       	call   8003fc <vprintfmt>
}
  8003f7:	83 c4 10             	add    $0x10,%esp
  8003fa:	c9                   	leave  
  8003fb:	c3                   	ret    

008003fc <vprintfmt>:
{
  8003fc:	55                   	push   %ebp
  8003fd:	89 e5                	mov    %esp,%ebp
  8003ff:	57                   	push   %edi
  800400:	56                   	push   %esi
  800401:	53                   	push   %ebx
  800402:	83 ec 3c             	sub    $0x3c,%esp
  800405:	8b 75 08             	mov    0x8(%ebp),%esi
  800408:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80040b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80040e:	e9 32 04 00 00       	jmp    800845 <vprintfmt+0x449>
		padc = ' ';
  800413:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800417:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80041e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800425:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80042c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800433:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80043a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80043f:	8d 47 01             	lea    0x1(%edi),%eax
  800442:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800445:	0f b6 17             	movzbl (%edi),%edx
  800448:	8d 42 dd             	lea    -0x23(%edx),%eax
  80044b:	3c 55                	cmp    $0x55,%al
  80044d:	0f 87 12 05 00 00    	ja     800965 <vprintfmt+0x569>
  800453:	0f b6 c0             	movzbl %al,%eax
  800456:	ff 24 85 80 29 80 00 	jmp    *0x802980(,%eax,4)
  80045d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800460:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800464:	eb d9                	jmp    80043f <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800466:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800469:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80046d:	eb d0                	jmp    80043f <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80046f:	0f b6 d2             	movzbl %dl,%edx
  800472:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800475:	b8 00 00 00 00       	mov    $0x0,%eax
  80047a:	89 75 08             	mov    %esi,0x8(%ebp)
  80047d:	eb 03                	jmp    800482 <vprintfmt+0x86>
  80047f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800482:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800485:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800489:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80048c:	8d 72 d0             	lea    -0x30(%edx),%esi
  80048f:	83 fe 09             	cmp    $0x9,%esi
  800492:	76 eb                	jbe    80047f <vprintfmt+0x83>
  800494:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800497:	8b 75 08             	mov    0x8(%ebp),%esi
  80049a:	eb 14                	jmp    8004b0 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80049c:	8b 45 14             	mov    0x14(%ebp),%eax
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a7:	8d 40 04             	lea    0x4(%eax),%eax
  8004aa:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004b4:	79 89                	jns    80043f <vprintfmt+0x43>
				width = precision, precision = -1;
  8004b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004bc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004c3:	e9 77 ff ff ff       	jmp    80043f <vprintfmt+0x43>
  8004c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004cb:	85 c0                	test   %eax,%eax
  8004cd:	0f 48 c1             	cmovs  %ecx,%eax
  8004d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004d6:	e9 64 ff ff ff       	jmp    80043f <vprintfmt+0x43>
  8004db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004de:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8004e5:	e9 55 ff ff ff       	jmp    80043f <vprintfmt+0x43>
			lflag++;
  8004ea:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004f1:	e9 49 ff ff ff       	jmp    80043f <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f9:	8d 78 04             	lea    0x4(%eax),%edi
  8004fc:	83 ec 08             	sub    $0x8,%esp
  8004ff:	53                   	push   %ebx
  800500:	ff 30                	pushl  (%eax)
  800502:	ff d6                	call   *%esi
			break;
  800504:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800507:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80050a:	e9 33 03 00 00       	jmp    800842 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80050f:	8b 45 14             	mov    0x14(%ebp),%eax
  800512:	8d 78 04             	lea    0x4(%eax),%edi
  800515:	8b 00                	mov    (%eax),%eax
  800517:	99                   	cltd   
  800518:	31 d0                	xor    %edx,%eax
  80051a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80051c:	83 f8 11             	cmp    $0x11,%eax
  80051f:	7f 23                	jg     800544 <vprintfmt+0x148>
  800521:	8b 14 85 e0 2a 80 00 	mov    0x802ae0(,%eax,4),%edx
  800528:	85 d2                	test   %edx,%edx
  80052a:	74 18                	je     800544 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80052c:	52                   	push   %edx
  80052d:	68 79 2c 80 00       	push   $0x802c79
  800532:	53                   	push   %ebx
  800533:	56                   	push   %esi
  800534:	e8 a6 fe ff ff       	call   8003df <printfmt>
  800539:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80053c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80053f:	e9 fe 02 00 00       	jmp    800842 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800544:	50                   	push   %eax
  800545:	68 b7 27 80 00       	push   $0x8027b7
  80054a:	53                   	push   %ebx
  80054b:	56                   	push   %esi
  80054c:	e8 8e fe ff ff       	call   8003df <printfmt>
  800551:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800554:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800557:	e9 e6 02 00 00       	jmp    800842 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80055c:	8b 45 14             	mov    0x14(%ebp),%eax
  80055f:	83 c0 04             	add    $0x4,%eax
  800562:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800565:	8b 45 14             	mov    0x14(%ebp),%eax
  800568:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80056a:	85 c9                	test   %ecx,%ecx
  80056c:	b8 b0 27 80 00       	mov    $0x8027b0,%eax
  800571:	0f 45 c1             	cmovne %ecx,%eax
  800574:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800577:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80057b:	7e 06                	jle    800583 <vprintfmt+0x187>
  80057d:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800581:	75 0d                	jne    800590 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800583:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800586:	89 c7                	mov    %eax,%edi
  800588:	03 45 e0             	add    -0x20(%ebp),%eax
  80058b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80058e:	eb 53                	jmp    8005e3 <vprintfmt+0x1e7>
  800590:	83 ec 08             	sub    $0x8,%esp
  800593:	ff 75 d8             	pushl  -0x28(%ebp)
  800596:	50                   	push   %eax
  800597:	e8 71 04 00 00       	call   800a0d <strnlen>
  80059c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80059f:	29 c1                	sub    %eax,%ecx
  8005a1:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8005a4:	83 c4 10             	add    $0x10,%esp
  8005a7:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8005a9:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8005ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b0:	eb 0f                	jmp    8005c1 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8005b2:	83 ec 08             	sub    $0x8,%esp
  8005b5:	53                   	push   %ebx
  8005b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8005b9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005bb:	83 ef 01             	sub    $0x1,%edi
  8005be:	83 c4 10             	add    $0x10,%esp
  8005c1:	85 ff                	test   %edi,%edi
  8005c3:	7f ed                	jg     8005b2 <vprintfmt+0x1b6>
  8005c5:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8005c8:	85 c9                	test   %ecx,%ecx
  8005ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8005cf:	0f 49 c1             	cmovns %ecx,%eax
  8005d2:	29 c1                	sub    %eax,%ecx
  8005d4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005d7:	eb aa                	jmp    800583 <vprintfmt+0x187>
					putch(ch, putdat);
  8005d9:	83 ec 08             	sub    $0x8,%esp
  8005dc:	53                   	push   %ebx
  8005dd:	52                   	push   %edx
  8005de:	ff d6                	call   *%esi
  8005e0:	83 c4 10             	add    $0x10,%esp
  8005e3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005e6:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005e8:	83 c7 01             	add    $0x1,%edi
  8005eb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005ef:	0f be d0             	movsbl %al,%edx
  8005f2:	85 d2                	test   %edx,%edx
  8005f4:	74 4b                	je     800641 <vprintfmt+0x245>
  8005f6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005fa:	78 06                	js     800602 <vprintfmt+0x206>
  8005fc:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800600:	78 1e                	js     800620 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800602:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800606:	74 d1                	je     8005d9 <vprintfmt+0x1dd>
  800608:	0f be c0             	movsbl %al,%eax
  80060b:	83 e8 20             	sub    $0x20,%eax
  80060e:	83 f8 5e             	cmp    $0x5e,%eax
  800611:	76 c6                	jbe    8005d9 <vprintfmt+0x1dd>
					putch('?', putdat);
  800613:	83 ec 08             	sub    $0x8,%esp
  800616:	53                   	push   %ebx
  800617:	6a 3f                	push   $0x3f
  800619:	ff d6                	call   *%esi
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	eb c3                	jmp    8005e3 <vprintfmt+0x1e7>
  800620:	89 cf                	mov    %ecx,%edi
  800622:	eb 0e                	jmp    800632 <vprintfmt+0x236>
				putch(' ', putdat);
  800624:	83 ec 08             	sub    $0x8,%esp
  800627:	53                   	push   %ebx
  800628:	6a 20                	push   $0x20
  80062a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80062c:	83 ef 01             	sub    $0x1,%edi
  80062f:	83 c4 10             	add    $0x10,%esp
  800632:	85 ff                	test   %edi,%edi
  800634:	7f ee                	jg     800624 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800636:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800639:	89 45 14             	mov    %eax,0x14(%ebp)
  80063c:	e9 01 02 00 00       	jmp    800842 <vprintfmt+0x446>
  800641:	89 cf                	mov    %ecx,%edi
  800643:	eb ed                	jmp    800632 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800645:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800648:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80064f:	e9 eb fd ff ff       	jmp    80043f <vprintfmt+0x43>
	if (lflag >= 2)
  800654:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800658:	7f 21                	jg     80067b <vprintfmt+0x27f>
	else if (lflag)
  80065a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80065e:	74 68                	je     8006c8 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800668:	89 c1                	mov    %eax,%ecx
  80066a:	c1 f9 1f             	sar    $0x1f,%ecx
  80066d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8d 40 04             	lea    0x4(%eax),%eax
  800676:	89 45 14             	mov    %eax,0x14(%ebp)
  800679:	eb 17                	jmp    800692 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	8b 50 04             	mov    0x4(%eax),%edx
  800681:	8b 00                	mov    (%eax),%eax
  800683:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800686:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	8d 40 08             	lea    0x8(%eax),%eax
  80068f:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800692:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800695:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800698:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069b:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80069e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8006a2:	78 3f                	js     8006e3 <vprintfmt+0x2e7>
			base = 10;
  8006a4:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8006a9:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8006ad:	0f 84 71 01 00 00    	je     800824 <vprintfmt+0x428>
				putch('+', putdat);
  8006b3:	83 ec 08             	sub    $0x8,%esp
  8006b6:	53                   	push   %ebx
  8006b7:	6a 2b                	push   $0x2b
  8006b9:	ff d6                	call   *%esi
  8006bb:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006be:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c3:	e9 5c 01 00 00       	jmp    800824 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006d0:	89 c1                	mov    %eax,%ecx
  8006d2:	c1 f9 1f             	sar    $0x1f,%ecx
  8006d5:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006db:	8d 40 04             	lea    0x4(%eax),%eax
  8006de:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e1:	eb af                	jmp    800692 <vprintfmt+0x296>
				putch('-', putdat);
  8006e3:	83 ec 08             	sub    $0x8,%esp
  8006e6:	53                   	push   %ebx
  8006e7:	6a 2d                	push   $0x2d
  8006e9:	ff d6                	call   *%esi
				num = -(long long) num;
  8006eb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006f1:	f7 d8                	neg    %eax
  8006f3:	83 d2 00             	adc    $0x0,%edx
  8006f6:	f7 da                	neg    %edx
  8006f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fe:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800701:	b8 0a 00 00 00       	mov    $0xa,%eax
  800706:	e9 19 01 00 00       	jmp    800824 <vprintfmt+0x428>
	if (lflag >= 2)
  80070b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80070f:	7f 29                	jg     80073a <vprintfmt+0x33e>
	else if (lflag)
  800711:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800715:	74 44                	je     80075b <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	ba 00 00 00 00       	mov    $0x0,%edx
  800721:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800724:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800727:	8b 45 14             	mov    0x14(%ebp),%eax
  80072a:	8d 40 04             	lea    0x4(%eax),%eax
  80072d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800730:	b8 0a 00 00 00       	mov    $0xa,%eax
  800735:	e9 ea 00 00 00       	jmp    800824 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80073a:	8b 45 14             	mov    0x14(%ebp),%eax
  80073d:	8b 50 04             	mov    0x4(%eax),%edx
  800740:	8b 00                	mov    (%eax),%eax
  800742:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800745:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800748:	8b 45 14             	mov    0x14(%ebp),%eax
  80074b:	8d 40 08             	lea    0x8(%eax),%eax
  80074e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800751:	b8 0a 00 00 00       	mov    $0xa,%eax
  800756:	e9 c9 00 00 00       	jmp    800824 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80075b:	8b 45 14             	mov    0x14(%ebp),%eax
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	ba 00 00 00 00       	mov    $0x0,%edx
  800765:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800768:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80076b:	8b 45 14             	mov    0x14(%ebp),%eax
  80076e:	8d 40 04             	lea    0x4(%eax),%eax
  800771:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800774:	b8 0a 00 00 00       	mov    $0xa,%eax
  800779:	e9 a6 00 00 00       	jmp    800824 <vprintfmt+0x428>
			putch('0', putdat);
  80077e:	83 ec 08             	sub    $0x8,%esp
  800781:	53                   	push   %ebx
  800782:	6a 30                	push   $0x30
  800784:	ff d6                	call   *%esi
	if (lflag >= 2)
  800786:	83 c4 10             	add    $0x10,%esp
  800789:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80078d:	7f 26                	jg     8007b5 <vprintfmt+0x3b9>
	else if (lflag)
  80078f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800793:	74 3e                	je     8007d3 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800795:	8b 45 14             	mov    0x14(%ebp),%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	ba 00 00 00 00       	mov    $0x0,%edx
  80079f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a8:	8d 40 04             	lea    0x4(%eax),%eax
  8007ab:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007ae:	b8 08 00 00 00       	mov    $0x8,%eax
  8007b3:	eb 6f                	jmp    800824 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b8:	8b 50 04             	mov    0x4(%eax),%edx
  8007bb:	8b 00                	mov    (%eax),%eax
  8007bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	8d 40 08             	lea    0x8(%eax),%eax
  8007c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007cc:	b8 08 00 00 00       	mov    $0x8,%eax
  8007d1:	eb 51                	jmp    800824 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	8b 00                	mov    (%eax),%eax
  8007d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e6:	8d 40 04             	lea    0x4(%eax),%eax
  8007e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007ec:	b8 08 00 00 00       	mov    $0x8,%eax
  8007f1:	eb 31                	jmp    800824 <vprintfmt+0x428>
			putch('0', putdat);
  8007f3:	83 ec 08             	sub    $0x8,%esp
  8007f6:	53                   	push   %ebx
  8007f7:	6a 30                	push   $0x30
  8007f9:	ff d6                	call   *%esi
			putch('x', putdat);
  8007fb:	83 c4 08             	add    $0x8,%esp
  8007fe:	53                   	push   %ebx
  8007ff:	6a 78                	push   $0x78
  800801:	ff d6                	call   *%esi
			num = (unsigned long long)
  800803:	8b 45 14             	mov    0x14(%ebp),%eax
  800806:	8b 00                	mov    (%eax),%eax
  800808:	ba 00 00 00 00       	mov    $0x0,%edx
  80080d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800810:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800813:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800816:	8b 45 14             	mov    0x14(%ebp),%eax
  800819:	8d 40 04             	lea    0x4(%eax),%eax
  80081c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081f:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800824:	83 ec 0c             	sub    $0xc,%esp
  800827:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80082b:	52                   	push   %edx
  80082c:	ff 75 e0             	pushl  -0x20(%ebp)
  80082f:	50                   	push   %eax
  800830:	ff 75 dc             	pushl  -0x24(%ebp)
  800833:	ff 75 d8             	pushl  -0x28(%ebp)
  800836:	89 da                	mov    %ebx,%edx
  800838:	89 f0                	mov    %esi,%eax
  80083a:	e8 a4 fa ff ff       	call   8002e3 <printnum>
			break;
  80083f:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800842:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800845:	83 c7 01             	add    $0x1,%edi
  800848:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80084c:	83 f8 25             	cmp    $0x25,%eax
  80084f:	0f 84 be fb ff ff    	je     800413 <vprintfmt+0x17>
			if (ch == '\0')
  800855:	85 c0                	test   %eax,%eax
  800857:	0f 84 28 01 00 00    	je     800985 <vprintfmt+0x589>
			putch(ch, putdat);
  80085d:	83 ec 08             	sub    $0x8,%esp
  800860:	53                   	push   %ebx
  800861:	50                   	push   %eax
  800862:	ff d6                	call   *%esi
  800864:	83 c4 10             	add    $0x10,%esp
  800867:	eb dc                	jmp    800845 <vprintfmt+0x449>
	if (lflag >= 2)
  800869:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80086d:	7f 26                	jg     800895 <vprintfmt+0x499>
	else if (lflag)
  80086f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800873:	74 41                	je     8008b6 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	ba 00 00 00 00       	mov    $0x0,%edx
  80087f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800882:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800885:	8b 45 14             	mov    0x14(%ebp),%eax
  800888:	8d 40 04             	lea    0x4(%eax),%eax
  80088b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80088e:	b8 10 00 00 00       	mov    $0x10,%eax
  800893:	eb 8f                	jmp    800824 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800895:	8b 45 14             	mov    0x14(%ebp),%eax
  800898:	8b 50 04             	mov    0x4(%eax),%edx
  80089b:	8b 00                	mov    (%eax),%eax
  80089d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a6:	8d 40 08             	lea    0x8(%eax),%eax
  8008a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008ac:	b8 10 00 00 00       	mov    $0x10,%eax
  8008b1:	e9 6e ff ff ff       	jmp    800824 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8008b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b9:	8b 00                	mov    (%eax),%eax
  8008bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8008c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c9:	8d 40 04             	lea    0x4(%eax),%eax
  8008cc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008cf:	b8 10 00 00 00       	mov    $0x10,%eax
  8008d4:	e9 4b ff ff ff       	jmp    800824 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8008d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dc:	83 c0 04             	add    $0x4,%eax
  8008df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e5:	8b 00                	mov    (%eax),%eax
  8008e7:	85 c0                	test   %eax,%eax
  8008e9:	74 14                	je     8008ff <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8008eb:	8b 13                	mov    (%ebx),%edx
  8008ed:	83 fa 7f             	cmp    $0x7f,%edx
  8008f0:	7f 37                	jg     800929 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8008f2:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8008f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008f7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008fa:	e9 43 ff ff ff       	jmp    800842 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8008ff:	b8 0a 00 00 00       	mov    $0xa,%eax
  800904:	bf d5 28 80 00       	mov    $0x8028d5,%edi
							putch(ch, putdat);
  800909:	83 ec 08             	sub    $0x8,%esp
  80090c:	53                   	push   %ebx
  80090d:	50                   	push   %eax
  80090e:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800910:	83 c7 01             	add    $0x1,%edi
  800913:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800917:	83 c4 10             	add    $0x10,%esp
  80091a:	85 c0                	test   %eax,%eax
  80091c:	75 eb                	jne    800909 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80091e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800921:	89 45 14             	mov    %eax,0x14(%ebp)
  800924:	e9 19 ff ff ff       	jmp    800842 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800929:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80092b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800930:	bf 0d 29 80 00       	mov    $0x80290d,%edi
							putch(ch, putdat);
  800935:	83 ec 08             	sub    $0x8,%esp
  800938:	53                   	push   %ebx
  800939:	50                   	push   %eax
  80093a:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80093c:	83 c7 01             	add    $0x1,%edi
  80093f:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800943:	83 c4 10             	add    $0x10,%esp
  800946:	85 c0                	test   %eax,%eax
  800948:	75 eb                	jne    800935 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80094a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80094d:	89 45 14             	mov    %eax,0x14(%ebp)
  800950:	e9 ed fe ff ff       	jmp    800842 <vprintfmt+0x446>
			putch(ch, putdat);
  800955:	83 ec 08             	sub    $0x8,%esp
  800958:	53                   	push   %ebx
  800959:	6a 25                	push   $0x25
  80095b:	ff d6                	call   *%esi
			break;
  80095d:	83 c4 10             	add    $0x10,%esp
  800960:	e9 dd fe ff ff       	jmp    800842 <vprintfmt+0x446>
			putch('%', putdat);
  800965:	83 ec 08             	sub    $0x8,%esp
  800968:	53                   	push   %ebx
  800969:	6a 25                	push   $0x25
  80096b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80096d:	83 c4 10             	add    $0x10,%esp
  800970:	89 f8                	mov    %edi,%eax
  800972:	eb 03                	jmp    800977 <vprintfmt+0x57b>
  800974:	83 e8 01             	sub    $0x1,%eax
  800977:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80097b:	75 f7                	jne    800974 <vprintfmt+0x578>
  80097d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800980:	e9 bd fe ff ff       	jmp    800842 <vprintfmt+0x446>
}
  800985:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800988:	5b                   	pop    %ebx
  800989:	5e                   	pop    %esi
  80098a:	5f                   	pop    %edi
  80098b:	5d                   	pop    %ebp
  80098c:	c3                   	ret    

0080098d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80098d:	55                   	push   %ebp
  80098e:	89 e5                	mov    %esp,%ebp
  800990:	83 ec 18             	sub    $0x18,%esp
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800999:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80099c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009a0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009aa:	85 c0                	test   %eax,%eax
  8009ac:	74 26                	je     8009d4 <vsnprintf+0x47>
  8009ae:	85 d2                	test   %edx,%edx
  8009b0:	7e 22                	jle    8009d4 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009b2:	ff 75 14             	pushl  0x14(%ebp)
  8009b5:	ff 75 10             	pushl  0x10(%ebp)
  8009b8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009bb:	50                   	push   %eax
  8009bc:	68 c2 03 80 00       	push   $0x8003c2
  8009c1:	e8 36 fa ff ff       	call   8003fc <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009cf:	83 c4 10             	add    $0x10,%esp
}
  8009d2:	c9                   	leave  
  8009d3:	c3                   	ret    
		return -E_INVAL;
  8009d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009d9:	eb f7                	jmp    8009d2 <vsnprintf+0x45>

008009db <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009e1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009e4:	50                   	push   %eax
  8009e5:	ff 75 10             	pushl  0x10(%ebp)
  8009e8:	ff 75 0c             	pushl  0xc(%ebp)
  8009eb:	ff 75 08             	pushl  0x8(%ebp)
  8009ee:	e8 9a ff ff ff       	call   80098d <vsnprintf>
	va_end(ap);

	return rc;
}
  8009f3:	c9                   	leave  
  8009f4:	c3                   	ret    

008009f5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009f5:	55                   	push   %ebp
  8009f6:	89 e5                	mov    %esp,%ebp
  8009f8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800a00:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a04:	74 05                	je     800a0b <strlen+0x16>
		n++;
  800a06:	83 c0 01             	add    $0x1,%eax
  800a09:	eb f5                	jmp    800a00 <strlen+0xb>
	return n;
}
  800a0b:	5d                   	pop    %ebp
  800a0c:	c3                   	ret    

00800a0d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a13:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a16:	ba 00 00 00 00       	mov    $0x0,%edx
  800a1b:	39 c2                	cmp    %eax,%edx
  800a1d:	74 0d                	je     800a2c <strnlen+0x1f>
  800a1f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800a23:	74 05                	je     800a2a <strnlen+0x1d>
		n++;
  800a25:	83 c2 01             	add    $0x1,%edx
  800a28:	eb f1                	jmp    800a1b <strnlen+0xe>
  800a2a:	89 d0                	mov    %edx,%eax
	return n;
}
  800a2c:	5d                   	pop    %ebp
  800a2d:	c3                   	ret    

00800a2e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a2e:	55                   	push   %ebp
  800a2f:	89 e5                	mov    %esp,%ebp
  800a31:	53                   	push   %ebx
  800a32:	8b 45 08             	mov    0x8(%ebp),%eax
  800a35:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a38:	ba 00 00 00 00       	mov    $0x0,%edx
  800a3d:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a41:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a44:	83 c2 01             	add    $0x1,%edx
  800a47:	84 c9                	test   %cl,%cl
  800a49:	75 f2                	jne    800a3d <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a4b:	5b                   	pop    %ebx
  800a4c:	5d                   	pop    %ebp
  800a4d:	c3                   	ret    

00800a4e <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a4e:	55                   	push   %ebp
  800a4f:	89 e5                	mov    %esp,%ebp
  800a51:	53                   	push   %ebx
  800a52:	83 ec 10             	sub    $0x10,%esp
  800a55:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a58:	53                   	push   %ebx
  800a59:	e8 97 ff ff ff       	call   8009f5 <strlen>
  800a5e:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a61:	ff 75 0c             	pushl  0xc(%ebp)
  800a64:	01 d8                	add    %ebx,%eax
  800a66:	50                   	push   %eax
  800a67:	e8 c2 ff ff ff       	call   800a2e <strcpy>
	return dst;
}
  800a6c:	89 d8                	mov    %ebx,%eax
  800a6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a71:	c9                   	leave  
  800a72:	c3                   	ret    

00800a73 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a73:	55                   	push   %ebp
  800a74:	89 e5                	mov    %esp,%ebp
  800a76:	56                   	push   %esi
  800a77:	53                   	push   %ebx
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a7e:	89 c6                	mov    %eax,%esi
  800a80:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a83:	89 c2                	mov    %eax,%edx
  800a85:	39 f2                	cmp    %esi,%edx
  800a87:	74 11                	je     800a9a <strncpy+0x27>
		*dst++ = *src;
  800a89:	83 c2 01             	add    $0x1,%edx
  800a8c:	0f b6 19             	movzbl (%ecx),%ebx
  800a8f:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a92:	80 fb 01             	cmp    $0x1,%bl
  800a95:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a98:	eb eb                	jmp    800a85 <strncpy+0x12>
	}
	return ret;
}
  800a9a:	5b                   	pop    %ebx
  800a9b:	5e                   	pop    %esi
  800a9c:	5d                   	pop    %ebp
  800a9d:	c3                   	ret    

00800a9e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a9e:	55                   	push   %ebp
  800a9f:	89 e5                	mov    %esp,%ebp
  800aa1:	56                   	push   %esi
  800aa2:	53                   	push   %ebx
  800aa3:	8b 75 08             	mov    0x8(%ebp),%esi
  800aa6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aa9:	8b 55 10             	mov    0x10(%ebp),%edx
  800aac:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800aae:	85 d2                	test   %edx,%edx
  800ab0:	74 21                	je     800ad3 <strlcpy+0x35>
  800ab2:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800ab6:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800ab8:	39 c2                	cmp    %eax,%edx
  800aba:	74 14                	je     800ad0 <strlcpy+0x32>
  800abc:	0f b6 19             	movzbl (%ecx),%ebx
  800abf:	84 db                	test   %bl,%bl
  800ac1:	74 0b                	je     800ace <strlcpy+0x30>
			*dst++ = *src++;
  800ac3:	83 c1 01             	add    $0x1,%ecx
  800ac6:	83 c2 01             	add    $0x1,%edx
  800ac9:	88 5a ff             	mov    %bl,-0x1(%edx)
  800acc:	eb ea                	jmp    800ab8 <strlcpy+0x1a>
  800ace:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800ad0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ad3:	29 f0                	sub    %esi,%eax
}
  800ad5:	5b                   	pop    %ebx
  800ad6:	5e                   	pop    %esi
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    

00800ad9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800adf:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ae2:	0f b6 01             	movzbl (%ecx),%eax
  800ae5:	84 c0                	test   %al,%al
  800ae7:	74 0c                	je     800af5 <strcmp+0x1c>
  800ae9:	3a 02                	cmp    (%edx),%al
  800aeb:	75 08                	jne    800af5 <strcmp+0x1c>
		p++, q++;
  800aed:	83 c1 01             	add    $0x1,%ecx
  800af0:	83 c2 01             	add    $0x1,%edx
  800af3:	eb ed                	jmp    800ae2 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800af5:	0f b6 c0             	movzbl %al,%eax
  800af8:	0f b6 12             	movzbl (%edx),%edx
  800afb:	29 d0                	sub    %edx,%eax
}
  800afd:	5d                   	pop    %ebp
  800afe:	c3                   	ret    

00800aff <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	53                   	push   %ebx
  800b03:	8b 45 08             	mov    0x8(%ebp),%eax
  800b06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b09:	89 c3                	mov    %eax,%ebx
  800b0b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b0e:	eb 06                	jmp    800b16 <strncmp+0x17>
		n--, p++, q++;
  800b10:	83 c0 01             	add    $0x1,%eax
  800b13:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800b16:	39 d8                	cmp    %ebx,%eax
  800b18:	74 16                	je     800b30 <strncmp+0x31>
  800b1a:	0f b6 08             	movzbl (%eax),%ecx
  800b1d:	84 c9                	test   %cl,%cl
  800b1f:	74 04                	je     800b25 <strncmp+0x26>
  800b21:	3a 0a                	cmp    (%edx),%cl
  800b23:	74 eb                	je     800b10 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b25:	0f b6 00             	movzbl (%eax),%eax
  800b28:	0f b6 12             	movzbl (%edx),%edx
  800b2b:	29 d0                	sub    %edx,%eax
}
  800b2d:	5b                   	pop    %ebx
  800b2e:	5d                   	pop    %ebp
  800b2f:	c3                   	ret    
		return 0;
  800b30:	b8 00 00 00 00       	mov    $0x0,%eax
  800b35:	eb f6                	jmp    800b2d <strncmp+0x2e>

00800b37 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b41:	0f b6 10             	movzbl (%eax),%edx
  800b44:	84 d2                	test   %dl,%dl
  800b46:	74 09                	je     800b51 <strchr+0x1a>
		if (*s == c)
  800b48:	38 ca                	cmp    %cl,%dl
  800b4a:	74 0a                	je     800b56 <strchr+0x1f>
	for (; *s; s++)
  800b4c:	83 c0 01             	add    $0x1,%eax
  800b4f:	eb f0                	jmp    800b41 <strchr+0xa>
			return (char *) s;
	return 0;
  800b51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b56:	5d                   	pop    %ebp
  800b57:	c3                   	ret    

00800b58 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b62:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b65:	38 ca                	cmp    %cl,%dl
  800b67:	74 09                	je     800b72 <strfind+0x1a>
  800b69:	84 d2                	test   %dl,%dl
  800b6b:	74 05                	je     800b72 <strfind+0x1a>
	for (; *s; s++)
  800b6d:	83 c0 01             	add    $0x1,%eax
  800b70:	eb f0                	jmp    800b62 <strfind+0xa>
			break;
	return (char *) s;
}
  800b72:	5d                   	pop    %ebp
  800b73:	c3                   	ret    

00800b74 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	57                   	push   %edi
  800b78:	56                   	push   %esi
  800b79:	53                   	push   %ebx
  800b7a:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b7d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b80:	85 c9                	test   %ecx,%ecx
  800b82:	74 31                	je     800bb5 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b84:	89 f8                	mov    %edi,%eax
  800b86:	09 c8                	or     %ecx,%eax
  800b88:	a8 03                	test   $0x3,%al
  800b8a:	75 23                	jne    800baf <memset+0x3b>
		c &= 0xFF;
  800b8c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b90:	89 d3                	mov    %edx,%ebx
  800b92:	c1 e3 08             	shl    $0x8,%ebx
  800b95:	89 d0                	mov    %edx,%eax
  800b97:	c1 e0 18             	shl    $0x18,%eax
  800b9a:	89 d6                	mov    %edx,%esi
  800b9c:	c1 e6 10             	shl    $0x10,%esi
  800b9f:	09 f0                	or     %esi,%eax
  800ba1:	09 c2                	or     %eax,%edx
  800ba3:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ba5:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ba8:	89 d0                	mov    %edx,%eax
  800baa:	fc                   	cld    
  800bab:	f3 ab                	rep stos %eax,%es:(%edi)
  800bad:	eb 06                	jmp    800bb5 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800baf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb2:	fc                   	cld    
  800bb3:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bb5:	89 f8                	mov    %edi,%eax
  800bb7:	5b                   	pop    %ebx
  800bb8:	5e                   	pop    %esi
  800bb9:	5f                   	pop    %edi
  800bba:	5d                   	pop    %ebp
  800bbb:	c3                   	ret    

00800bbc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	57                   	push   %edi
  800bc0:	56                   	push   %esi
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bc7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bca:	39 c6                	cmp    %eax,%esi
  800bcc:	73 32                	jae    800c00 <memmove+0x44>
  800bce:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bd1:	39 c2                	cmp    %eax,%edx
  800bd3:	76 2b                	jbe    800c00 <memmove+0x44>
		s += n;
		d += n;
  800bd5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bd8:	89 fe                	mov    %edi,%esi
  800bda:	09 ce                	or     %ecx,%esi
  800bdc:	09 d6                	or     %edx,%esi
  800bde:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800be4:	75 0e                	jne    800bf4 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800be6:	83 ef 04             	sub    $0x4,%edi
  800be9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bec:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800bef:	fd                   	std    
  800bf0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bf2:	eb 09                	jmp    800bfd <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bf4:	83 ef 01             	sub    $0x1,%edi
  800bf7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bfa:	fd                   	std    
  800bfb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bfd:	fc                   	cld    
  800bfe:	eb 1a                	jmp    800c1a <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c00:	89 c2                	mov    %eax,%edx
  800c02:	09 ca                	or     %ecx,%edx
  800c04:	09 f2                	or     %esi,%edx
  800c06:	f6 c2 03             	test   $0x3,%dl
  800c09:	75 0a                	jne    800c15 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c0b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800c0e:	89 c7                	mov    %eax,%edi
  800c10:	fc                   	cld    
  800c11:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c13:	eb 05                	jmp    800c1a <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800c15:	89 c7                	mov    %eax,%edi
  800c17:	fc                   	cld    
  800c18:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c1a:	5e                   	pop    %esi
  800c1b:	5f                   	pop    %edi
  800c1c:	5d                   	pop    %ebp
  800c1d:	c3                   	ret    

00800c1e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c24:	ff 75 10             	pushl  0x10(%ebp)
  800c27:	ff 75 0c             	pushl  0xc(%ebp)
  800c2a:	ff 75 08             	pushl  0x8(%ebp)
  800c2d:	e8 8a ff ff ff       	call   800bbc <memmove>
}
  800c32:	c9                   	leave  
  800c33:	c3                   	ret    

00800c34 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	56                   	push   %esi
  800c38:	53                   	push   %ebx
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3f:	89 c6                	mov    %eax,%esi
  800c41:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c44:	39 f0                	cmp    %esi,%eax
  800c46:	74 1c                	je     800c64 <memcmp+0x30>
		if (*s1 != *s2)
  800c48:	0f b6 08             	movzbl (%eax),%ecx
  800c4b:	0f b6 1a             	movzbl (%edx),%ebx
  800c4e:	38 d9                	cmp    %bl,%cl
  800c50:	75 08                	jne    800c5a <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c52:	83 c0 01             	add    $0x1,%eax
  800c55:	83 c2 01             	add    $0x1,%edx
  800c58:	eb ea                	jmp    800c44 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c5a:	0f b6 c1             	movzbl %cl,%eax
  800c5d:	0f b6 db             	movzbl %bl,%ebx
  800c60:	29 d8                	sub    %ebx,%eax
  800c62:	eb 05                	jmp    800c69 <memcmp+0x35>
	}

	return 0;
  800c64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c69:	5b                   	pop    %ebx
  800c6a:	5e                   	pop    %esi
  800c6b:	5d                   	pop    %ebp
  800c6c:	c3                   	ret    

00800c6d <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	8b 45 08             	mov    0x8(%ebp),%eax
  800c73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c76:	89 c2                	mov    %eax,%edx
  800c78:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c7b:	39 d0                	cmp    %edx,%eax
  800c7d:	73 09                	jae    800c88 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c7f:	38 08                	cmp    %cl,(%eax)
  800c81:	74 05                	je     800c88 <memfind+0x1b>
	for (; s < ends; s++)
  800c83:	83 c0 01             	add    $0x1,%eax
  800c86:	eb f3                	jmp    800c7b <memfind+0xe>
			break;
	return (void *) s;
}
  800c88:	5d                   	pop    %ebp
  800c89:	c3                   	ret    

00800c8a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	57                   	push   %edi
  800c8e:	56                   	push   %esi
  800c8f:	53                   	push   %ebx
  800c90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c93:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c96:	eb 03                	jmp    800c9b <strtol+0x11>
		s++;
  800c98:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c9b:	0f b6 01             	movzbl (%ecx),%eax
  800c9e:	3c 20                	cmp    $0x20,%al
  800ca0:	74 f6                	je     800c98 <strtol+0xe>
  800ca2:	3c 09                	cmp    $0x9,%al
  800ca4:	74 f2                	je     800c98 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ca6:	3c 2b                	cmp    $0x2b,%al
  800ca8:	74 2a                	je     800cd4 <strtol+0x4a>
	int neg = 0;
  800caa:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800caf:	3c 2d                	cmp    $0x2d,%al
  800cb1:	74 2b                	je     800cde <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cb3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800cb9:	75 0f                	jne    800cca <strtol+0x40>
  800cbb:	80 39 30             	cmpb   $0x30,(%ecx)
  800cbe:	74 28                	je     800ce8 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cc0:	85 db                	test   %ebx,%ebx
  800cc2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cc7:	0f 44 d8             	cmove  %eax,%ebx
  800cca:	b8 00 00 00 00       	mov    $0x0,%eax
  800ccf:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cd2:	eb 50                	jmp    800d24 <strtol+0x9a>
		s++;
  800cd4:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800cd7:	bf 00 00 00 00       	mov    $0x0,%edi
  800cdc:	eb d5                	jmp    800cb3 <strtol+0x29>
		s++, neg = 1;
  800cde:	83 c1 01             	add    $0x1,%ecx
  800ce1:	bf 01 00 00 00       	mov    $0x1,%edi
  800ce6:	eb cb                	jmp    800cb3 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ce8:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800cec:	74 0e                	je     800cfc <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800cee:	85 db                	test   %ebx,%ebx
  800cf0:	75 d8                	jne    800cca <strtol+0x40>
		s++, base = 8;
  800cf2:	83 c1 01             	add    $0x1,%ecx
  800cf5:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cfa:	eb ce                	jmp    800cca <strtol+0x40>
		s += 2, base = 16;
  800cfc:	83 c1 02             	add    $0x2,%ecx
  800cff:	bb 10 00 00 00       	mov    $0x10,%ebx
  800d04:	eb c4                	jmp    800cca <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800d06:	8d 72 9f             	lea    -0x61(%edx),%esi
  800d09:	89 f3                	mov    %esi,%ebx
  800d0b:	80 fb 19             	cmp    $0x19,%bl
  800d0e:	77 29                	ja     800d39 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800d10:	0f be d2             	movsbl %dl,%edx
  800d13:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800d16:	3b 55 10             	cmp    0x10(%ebp),%edx
  800d19:	7d 30                	jge    800d4b <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800d1b:	83 c1 01             	add    $0x1,%ecx
  800d1e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d22:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800d24:	0f b6 11             	movzbl (%ecx),%edx
  800d27:	8d 72 d0             	lea    -0x30(%edx),%esi
  800d2a:	89 f3                	mov    %esi,%ebx
  800d2c:	80 fb 09             	cmp    $0x9,%bl
  800d2f:	77 d5                	ja     800d06 <strtol+0x7c>
			dig = *s - '0';
  800d31:	0f be d2             	movsbl %dl,%edx
  800d34:	83 ea 30             	sub    $0x30,%edx
  800d37:	eb dd                	jmp    800d16 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800d39:	8d 72 bf             	lea    -0x41(%edx),%esi
  800d3c:	89 f3                	mov    %esi,%ebx
  800d3e:	80 fb 19             	cmp    $0x19,%bl
  800d41:	77 08                	ja     800d4b <strtol+0xc1>
			dig = *s - 'A' + 10;
  800d43:	0f be d2             	movsbl %dl,%edx
  800d46:	83 ea 37             	sub    $0x37,%edx
  800d49:	eb cb                	jmp    800d16 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d4b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d4f:	74 05                	je     800d56 <strtol+0xcc>
		*endptr = (char *) s;
  800d51:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d54:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d56:	89 c2                	mov    %eax,%edx
  800d58:	f7 da                	neg    %edx
  800d5a:	85 ff                	test   %edi,%edi
  800d5c:	0f 45 c2             	cmovne %edx,%eax
}
  800d5f:	5b                   	pop    %ebx
  800d60:	5e                   	pop    %esi
  800d61:	5f                   	pop    %edi
  800d62:	5d                   	pop    %ebp
  800d63:	c3                   	ret    

00800d64 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	57                   	push   %edi
  800d68:	56                   	push   %esi
  800d69:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d6a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d75:	89 c3                	mov    %eax,%ebx
  800d77:	89 c7                	mov    %eax,%edi
  800d79:	89 c6                	mov    %eax,%esi
  800d7b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d7d:	5b                   	pop    %ebx
  800d7e:	5e                   	pop    %esi
  800d7f:	5f                   	pop    %edi
  800d80:	5d                   	pop    %ebp
  800d81:	c3                   	ret    

00800d82 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	57                   	push   %edi
  800d86:	56                   	push   %esi
  800d87:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d88:	ba 00 00 00 00       	mov    $0x0,%edx
  800d8d:	b8 01 00 00 00       	mov    $0x1,%eax
  800d92:	89 d1                	mov    %edx,%ecx
  800d94:	89 d3                	mov    %edx,%ebx
  800d96:	89 d7                	mov    %edx,%edi
  800d98:	89 d6                	mov    %edx,%esi
  800d9a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d9c:	5b                   	pop    %ebx
  800d9d:	5e                   	pop    %esi
  800d9e:	5f                   	pop    %edi
  800d9f:	5d                   	pop    %ebp
  800da0:	c3                   	ret    

00800da1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800da1:	55                   	push   %ebp
  800da2:	89 e5                	mov    %esp,%ebp
  800da4:	57                   	push   %edi
  800da5:	56                   	push   %esi
  800da6:	53                   	push   %ebx
  800da7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800daa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800daf:	8b 55 08             	mov    0x8(%ebp),%edx
  800db2:	b8 03 00 00 00       	mov    $0x3,%eax
  800db7:	89 cb                	mov    %ecx,%ebx
  800db9:	89 cf                	mov    %ecx,%edi
  800dbb:	89 ce                	mov    %ecx,%esi
  800dbd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dbf:	85 c0                	test   %eax,%eax
  800dc1:	7f 08                	jg     800dcb <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc6:	5b                   	pop    %ebx
  800dc7:	5e                   	pop    %esi
  800dc8:	5f                   	pop    %edi
  800dc9:	5d                   	pop    %ebp
  800dca:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dcb:	83 ec 0c             	sub    $0xc,%esp
  800dce:	50                   	push   %eax
  800dcf:	6a 03                	push   $0x3
  800dd1:	68 28 2b 80 00       	push   $0x802b28
  800dd6:	6a 43                	push   $0x43
  800dd8:	68 45 2b 80 00       	push   $0x802b45
  800ddd:	e8 f7 f3 ff ff       	call   8001d9 <_panic>

00800de2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800de2:	55                   	push   %ebp
  800de3:	89 e5                	mov    %esp,%ebp
  800de5:	57                   	push   %edi
  800de6:	56                   	push   %esi
  800de7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de8:	ba 00 00 00 00       	mov    $0x0,%edx
  800ded:	b8 02 00 00 00       	mov    $0x2,%eax
  800df2:	89 d1                	mov    %edx,%ecx
  800df4:	89 d3                	mov    %edx,%ebx
  800df6:	89 d7                	mov    %edx,%edi
  800df8:	89 d6                	mov    %edx,%esi
  800dfa:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dfc:	5b                   	pop    %ebx
  800dfd:	5e                   	pop    %esi
  800dfe:	5f                   	pop    %edi
  800dff:	5d                   	pop    %ebp
  800e00:	c3                   	ret    

00800e01 <sys_yield>:

void
sys_yield(void)
{
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	57                   	push   %edi
  800e05:	56                   	push   %esi
  800e06:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e07:	ba 00 00 00 00       	mov    $0x0,%edx
  800e0c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e11:	89 d1                	mov    %edx,%ecx
  800e13:	89 d3                	mov    %edx,%ebx
  800e15:	89 d7                	mov    %edx,%edi
  800e17:	89 d6                	mov    %edx,%esi
  800e19:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e1b:	5b                   	pop    %ebx
  800e1c:	5e                   	pop    %esi
  800e1d:	5f                   	pop    %edi
  800e1e:	5d                   	pop    %ebp
  800e1f:	c3                   	ret    

00800e20 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	57                   	push   %edi
  800e24:	56                   	push   %esi
  800e25:	53                   	push   %ebx
  800e26:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e29:	be 00 00 00 00       	mov    $0x0,%esi
  800e2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e34:	b8 04 00 00 00       	mov    $0x4,%eax
  800e39:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e3c:	89 f7                	mov    %esi,%edi
  800e3e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e40:	85 c0                	test   %eax,%eax
  800e42:	7f 08                	jg     800e4c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e47:	5b                   	pop    %ebx
  800e48:	5e                   	pop    %esi
  800e49:	5f                   	pop    %edi
  800e4a:	5d                   	pop    %ebp
  800e4b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4c:	83 ec 0c             	sub    $0xc,%esp
  800e4f:	50                   	push   %eax
  800e50:	6a 04                	push   $0x4
  800e52:	68 28 2b 80 00       	push   $0x802b28
  800e57:	6a 43                	push   $0x43
  800e59:	68 45 2b 80 00       	push   $0x802b45
  800e5e:	e8 76 f3 ff ff       	call   8001d9 <_panic>

00800e63 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	57                   	push   %edi
  800e67:	56                   	push   %esi
  800e68:	53                   	push   %ebx
  800e69:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e72:	b8 05 00 00 00       	mov    $0x5,%eax
  800e77:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e7a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e7d:	8b 75 18             	mov    0x18(%ebp),%esi
  800e80:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e82:	85 c0                	test   %eax,%eax
  800e84:	7f 08                	jg     800e8e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e86:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e89:	5b                   	pop    %ebx
  800e8a:	5e                   	pop    %esi
  800e8b:	5f                   	pop    %edi
  800e8c:	5d                   	pop    %ebp
  800e8d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8e:	83 ec 0c             	sub    $0xc,%esp
  800e91:	50                   	push   %eax
  800e92:	6a 05                	push   $0x5
  800e94:	68 28 2b 80 00       	push   $0x802b28
  800e99:	6a 43                	push   $0x43
  800e9b:	68 45 2b 80 00       	push   $0x802b45
  800ea0:	e8 34 f3 ff ff       	call   8001d9 <_panic>

00800ea5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	57                   	push   %edi
  800ea9:	56                   	push   %esi
  800eaa:	53                   	push   %ebx
  800eab:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eae:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb9:	b8 06 00 00 00       	mov    $0x6,%eax
  800ebe:	89 df                	mov    %ebx,%edi
  800ec0:	89 de                	mov    %ebx,%esi
  800ec2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	7f 08                	jg     800ed0 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ec8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ecb:	5b                   	pop    %ebx
  800ecc:	5e                   	pop    %esi
  800ecd:	5f                   	pop    %edi
  800ece:	5d                   	pop    %ebp
  800ecf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed0:	83 ec 0c             	sub    $0xc,%esp
  800ed3:	50                   	push   %eax
  800ed4:	6a 06                	push   $0x6
  800ed6:	68 28 2b 80 00       	push   $0x802b28
  800edb:	6a 43                	push   $0x43
  800edd:	68 45 2b 80 00       	push   $0x802b45
  800ee2:	e8 f2 f2 ff ff       	call   8001d9 <_panic>

00800ee7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ee7:	55                   	push   %ebp
  800ee8:	89 e5                	mov    %esp,%ebp
  800eea:	57                   	push   %edi
  800eeb:	56                   	push   %esi
  800eec:	53                   	push   %ebx
  800eed:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efb:	b8 08 00 00 00       	mov    $0x8,%eax
  800f00:	89 df                	mov    %ebx,%edi
  800f02:	89 de                	mov    %ebx,%esi
  800f04:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f06:	85 c0                	test   %eax,%eax
  800f08:	7f 08                	jg     800f12 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f0d:	5b                   	pop    %ebx
  800f0e:	5e                   	pop    %esi
  800f0f:	5f                   	pop    %edi
  800f10:	5d                   	pop    %ebp
  800f11:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f12:	83 ec 0c             	sub    $0xc,%esp
  800f15:	50                   	push   %eax
  800f16:	6a 08                	push   $0x8
  800f18:	68 28 2b 80 00       	push   $0x802b28
  800f1d:	6a 43                	push   $0x43
  800f1f:	68 45 2b 80 00       	push   $0x802b45
  800f24:	e8 b0 f2 ff ff       	call   8001d9 <_panic>

00800f29 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
  800f2c:	57                   	push   %edi
  800f2d:	56                   	push   %esi
  800f2e:	53                   	push   %ebx
  800f2f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f32:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f37:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3d:	b8 09 00 00 00       	mov    $0x9,%eax
  800f42:	89 df                	mov    %ebx,%edi
  800f44:	89 de                	mov    %ebx,%esi
  800f46:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f48:	85 c0                	test   %eax,%eax
  800f4a:	7f 08                	jg     800f54 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f4f:	5b                   	pop    %ebx
  800f50:	5e                   	pop    %esi
  800f51:	5f                   	pop    %edi
  800f52:	5d                   	pop    %ebp
  800f53:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f54:	83 ec 0c             	sub    $0xc,%esp
  800f57:	50                   	push   %eax
  800f58:	6a 09                	push   $0x9
  800f5a:	68 28 2b 80 00       	push   $0x802b28
  800f5f:	6a 43                	push   $0x43
  800f61:	68 45 2b 80 00       	push   $0x802b45
  800f66:	e8 6e f2 ff ff       	call   8001d9 <_panic>

00800f6b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
  800f6e:	57                   	push   %edi
  800f6f:	56                   	push   %esi
  800f70:	53                   	push   %ebx
  800f71:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f74:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f79:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f84:	89 df                	mov    %ebx,%edi
  800f86:	89 de                	mov    %ebx,%esi
  800f88:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f8a:	85 c0                	test   %eax,%eax
  800f8c:	7f 08                	jg     800f96 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f91:	5b                   	pop    %ebx
  800f92:	5e                   	pop    %esi
  800f93:	5f                   	pop    %edi
  800f94:	5d                   	pop    %ebp
  800f95:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f96:	83 ec 0c             	sub    $0xc,%esp
  800f99:	50                   	push   %eax
  800f9a:	6a 0a                	push   $0xa
  800f9c:	68 28 2b 80 00       	push   $0x802b28
  800fa1:	6a 43                	push   $0x43
  800fa3:	68 45 2b 80 00       	push   $0x802b45
  800fa8:	e8 2c f2 ff ff       	call   8001d9 <_panic>

00800fad <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	57                   	push   %edi
  800fb1:	56                   	push   %esi
  800fb2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb9:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fbe:	be 00 00 00 00       	mov    $0x0,%esi
  800fc3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fc6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fc9:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fcb:	5b                   	pop    %ebx
  800fcc:	5e                   	pop    %esi
  800fcd:	5f                   	pop    %edi
  800fce:	5d                   	pop    %ebp
  800fcf:	c3                   	ret    

00800fd0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	57                   	push   %edi
  800fd4:	56                   	push   %esi
  800fd5:	53                   	push   %ebx
  800fd6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fde:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe1:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fe6:	89 cb                	mov    %ecx,%ebx
  800fe8:	89 cf                	mov    %ecx,%edi
  800fea:	89 ce                	mov    %ecx,%esi
  800fec:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fee:	85 c0                	test   %eax,%eax
  800ff0:	7f 08                	jg     800ffa <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ff2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff5:	5b                   	pop    %ebx
  800ff6:	5e                   	pop    %esi
  800ff7:	5f                   	pop    %edi
  800ff8:	5d                   	pop    %ebp
  800ff9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ffa:	83 ec 0c             	sub    $0xc,%esp
  800ffd:	50                   	push   %eax
  800ffe:	6a 0d                	push   $0xd
  801000:	68 28 2b 80 00       	push   $0x802b28
  801005:	6a 43                	push   $0x43
  801007:	68 45 2b 80 00       	push   $0x802b45
  80100c:	e8 c8 f1 ff ff       	call   8001d9 <_panic>

00801011 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
  801014:	57                   	push   %edi
  801015:	56                   	push   %esi
  801016:	53                   	push   %ebx
	asm volatile("int %1\n"
  801017:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101c:	8b 55 08             	mov    0x8(%ebp),%edx
  80101f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801022:	b8 0e 00 00 00       	mov    $0xe,%eax
  801027:	89 df                	mov    %ebx,%edi
  801029:	89 de                	mov    %ebx,%esi
  80102b:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  80102d:	5b                   	pop    %ebx
  80102e:	5e                   	pop    %esi
  80102f:	5f                   	pop    %edi
  801030:	5d                   	pop    %ebp
  801031:	c3                   	ret    

00801032 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
  801035:	57                   	push   %edi
  801036:	56                   	push   %esi
  801037:	53                   	push   %ebx
	asm volatile("int %1\n"
  801038:	b9 00 00 00 00       	mov    $0x0,%ecx
  80103d:	8b 55 08             	mov    0x8(%ebp),%edx
  801040:	b8 0f 00 00 00       	mov    $0xf,%eax
  801045:	89 cb                	mov    %ecx,%ebx
  801047:	89 cf                	mov    %ecx,%edi
  801049:	89 ce                	mov    %ecx,%esi
  80104b:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  80104d:	5b                   	pop    %ebx
  80104e:	5e                   	pop    %esi
  80104f:	5f                   	pop    %edi
  801050:	5d                   	pop    %ebp
  801051:	c3                   	ret    

00801052 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	57                   	push   %edi
  801056:	56                   	push   %esi
  801057:	53                   	push   %ebx
	asm volatile("int %1\n"
  801058:	ba 00 00 00 00       	mov    $0x0,%edx
  80105d:	b8 10 00 00 00       	mov    $0x10,%eax
  801062:	89 d1                	mov    %edx,%ecx
  801064:	89 d3                	mov    %edx,%ebx
  801066:	89 d7                	mov    %edx,%edi
  801068:	89 d6                	mov    %edx,%esi
  80106a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80106c:	5b                   	pop    %ebx
  80106d:	5e                   	pop    %esi
  80106e:	5f                   	pop    %edi
  80106f:	5d                   	pop    %ebp
  801070:	c3                   	ret    

00801071 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801071:	55                   	push   %ebp
  801072:	89 e5                	mov    %esp,%ebp
  801074:	57                   	push   %edi
  801075:	56                   	push   %esi
  801076:	53                   	push   %ebx
	asm volatile("int %1\n"
  801077:	bb 00 00 00 00       	mov    $0x0,%ebx
  80107c:	8b 55 08             	mov    0x8(%ebp),%edx
  80107f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801082:	b8 11 00 00 00       	mov    $0x11,%eax
  801087:	89 df                	mov    %ebx,%edi
  801089:	89 de                	mov    %ebx,%esi
  80108b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80108d:	5b                   	pop    %ebx
  80108e:	5e                   	pop    %esi
  80108f:	5f                   	pop    %edi
  801090:	5d                   	pop    %ebp
  801091:	c3                   	ret    

00801092 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	57                   	push   %edi
  801096:	56                   	push   %esi
  801097:	53                   	push   %ebx
	asm volatile("int %1\n"
  801098:	bb 00 00 00 00       	mov    $0x0,%ebx
  80109d:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a3:	b8 12 00 00 00       	mov    $0x12,%eax
  8010a8:	89 df                	mov    %ebx,%edi
  8010aa:	89 de                	mov    %ebx,%esi
  8010ac:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  8010ae:	5b                   	pop    %ebx
  8010af:	5e                   	pop    %esi
  8010b0:	5f                   	pop    %edi
  8010b1:	5d                   	pop    %ebp
  8010b2:	c3                   	ret    

008010b3 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	57                   	push   %edi
  8010b7:	56                   	push   %esi
  8010b8:	53                   	push   %ebx
  8010b9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010bc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c7:	b8 13 00 00 00       	mov    $0x13,%eax
  8010cc:	89 df                	mov    %ebx,%edi
  8010ce:	89 de                	mov    %ebx,%esi
  8010d0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010d2:	85 c0                	test   %eax,%eax
  8010d4:	7f 08                	jg     8010de <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010d9:	5b                   	pop    %ebx
  8010da:	5e                   	pop    %esi
  8010db:	5f                   	pop    %edi
  8010dc:	5d                   	pop    %ebp
  8010dd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010de:	83 ec 0c             	sub    $0xc,%esp
  8010e1:	50                   	push   %eax
  8010e2:	6a 13                	push   $0x13
  8010e4:	68 28 2b 80 00       	push   $0x802b28
  8010e9:	6a 43                	push   $0x43
  8010eb:	68 45 2b 80 00       	push   $0x802b45
  8010f0:	e8 e4 f0 ff ff       	call   8001d9 <_panic>

008010f5 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
  8010f8:	57                   	push   %edi
  8010f9:	56                   	push   %esi
  8010fa:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010fb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801100:	8b 55 08             	mov    0x8(%ebp),%edx
  801103:	b8 14 00 00 00       	mov    $0x14,%eax
  801108:	89 cb                	mov    %ecx,%ebx
  80110a:	89 cf                	mov    %ecx,%edi
  80110c:	89 ce                	mov    %ecx,%esi
  80110e:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801110:	5b                   	pop    %ebx
  801111:	5e                   	pop    %esi
  801112:	5f                   	pop    %edi
  801113:	5d                   	pop    %ebp
  801114:	c3                   	ret    

00801115 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80111b:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  801122:	74 0a                	je     80112e <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801124:	8b 45 08             	mov    0x8(%ebp),%eax
  801127:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  80112c:	c9                   	leave  
  80112d:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  80112e:	83 ec 04             	sub    $0x4,%esp
  801131:	6a 07                	push   $0x7
  801133:	68 00 f0 bf ee       	push   $0xeebff000
  801138:	6a 00                	push   $0x0
  80113a:	e8 e1 fc ff ff       	call   800e20 <sys_page_alloc>
		if(r < 0)
  80113f:	83 c4 10             	add    $0x10,%esp
  801142:	85 c0                	test   %eax,%eax
  801144:	78 2a                	js     801170 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  801146:	83 ec 08             	sub    $0x8,%esp
  801149:	68 84 11 80 00       	push   $0x801184
  80114e:	6a 00                	push   $0x0
  801150:	e8 16 fe ff ff       	call   800f6b <sys_env_set_pgfault_upcall>
		if(r < 0)
  801155:	83 c4 10             	add    $0x10,%esp
  801158:	85 c0                	test   %eax,%eax
  80115a:	79 c8                	jns    801124 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  80115c:	83 ec 04             	sub    $0x4,%esp
  80115f:	68 84 2b 80 00       	push   $0x802b84
  801164:	6a 25                	push   $0x25
  801166:	68 bd 2b 80 00       	push   $0x802bbd
  80116b:	e8 69 f0 ff ff       	call   8001d9 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  801170:	83 ec 04             	sub    $0x4,%esp
  801173:	68 54 2b 80 00       	push   $0x802b54
  801178:	6a 22                	push   $0x22
  80117a:	68 bd 2b 80 00       	push   $0x802bbd
  80117f:	e8 55 f0 ff ff       	call   8001d9 <_panic>

00801184 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801184:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801185:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  80118a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80118c:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  80118f:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  801193:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  801197:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80119a:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  80119c:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  8011a0:	83 c4 08             	add    $0x8,%esp
	popal
  8011a3:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8011a4:	83 c4 04             	add    $0x4,%esp
	popfl
  8011a7:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8011a8:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8011a9:	c3                   	ret    

008011aa <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	05 00 00 00 30       	add    $0x30000000,%eax
  8011b5:	c1 e8 0c             	shr    $0xc,%eax
}
  8011b8:	5d                   	pop    %ebp
  8011b9:	c3                   	ret    

008011ba <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011ba:	55                   	push   %ebp
  8011bb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011ca:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011cf:	5d                   	pop    %ebp
  8011d0:	c3                   	ret    

008011d1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011d1:	55                   	push   %ebp
  8011d2:	89 e5                	mov    %esp,%ebp
  8011d4:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011d9:	89 c2                	mov    %eax,%edx
  8011db:	c1 ea 16             	shr    $0x16,%edx
  8011de:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011e5:	f6 c2 01             	test   $0x1,%dl
  8011e8:	74 2d                	je     801217 <fd_alloc+0x46>
  8011ea:	89 c2                	mov    %eax,%edx
  8011ec:	c1 ea 0c             	shr    $0xc,%edx
  8011ef:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011f6:	f6 c2 01             	test   $0x1,%dl
  8011f9:	74 1c                	je     801217 <fd_alloc+0x46>
  8011fb:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801200:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801205:	75 d2                	jne    8011d9 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801207:	8b 45 08             	mov    0x8(%ebp),%eax
  80120a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801210:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801215:	eb 0a                	jmp    801221 <fd_alloc+0x50>
			*fd_store = fd;
  801217:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80121a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80121c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801221:	5d                   	pop    %ebp
  801222:	c3                   	ret    

00801223 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801229:	83 f8 1f             	cmp    $0x1f,%eax
  80122c:	77 30                	ja     80125e <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80122e:	c1 e0 0c             	shl    $0xc,%eax
  801231:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801236:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80123c:	f6 c2 01             	test   $0x1,%dl
  80123f:	74 24                	je     801265 <fd_lookup+0x42>
  801241:	89 c2                	mov    %eax,%edx
  801243:	c1 ea 0c             	shr    $0xc,%edx
  801246:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80124d:	f6 c2 01             	test   $0x1,%dl
  801250:	74 1a                	je     80126c <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801252:	8b 55 0c             	mov    0xc(%ebp),%edx
  801255:	89 02                	mov    %eax,(%edx)
	return 0;
  801257:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80125c:	5d                   	pop    %ebp
  80125d:	c3                   	ret    
		return -E_INVAL;
  80125e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801263:	eb f7                	jmp    80125c <fd_lookup+0x39>
		return -E_INVAL;
  801265:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80126a:	eb f0                	jmp    80125c <fd_lookup+0x39>
  80126c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801271:	eb e9                	jmp    80125c <fd_lookup+0x39>

00801273 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801273:	55                   	push   %ebp
  801274:	89 e5                	mov    %esp,%ebp
  801276:	83 ec 08             	sub    $0x8,%esp
  801279:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80127c:	ba 00 00 00 00       	mov    $0x0,%edx
  801281:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801286:	39 08                	cmp    %ecx,(%eax)
  801288:	74 38                	je     8012c2 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80128a:	83 c2 01             	add    $0x1,%edx
  80128d:	8b 04 95 4c 2c 80 00 	mov    0x802c4c(,%edx,4),%eax
  801294:	85 c0                	test   %eax,%eax
  801296:	75 ee                	jne    801286 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801298:	a1 08 40 80 00       	mov    0x804008,%eax
  80129d:	8b 40 48             	mov    0x48(%eax),%eax
  8012a0:	83 ec 04             	sub    $0x4,%esp
  8012a3:	51                   	push   %ecx
  8012a4:	50                   	push   %eax
  8012a5:	68 cc 2b 80 00       	push   $0x802bcc
  8012aa:	e8 20 f0 ff ff       	call   8002cf <cprintf>
	*dev = 0;
  8012af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012b8:	83 c4 10             	add    $0x10,%esp
  8012bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012c0:	c9                   	leave  
  8012c1:	c3                   	ret    
			*dev = devtab[i];
  8012c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012c5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012cc:	eb f2                	jmp    8012c0 <dev_lookup+0x4d>

008012ce <fd_close>:
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	57                   	push   %edi
  8012d2:	56                   	push   %esi
  8012d3:	53                   	push   %ebx
  8012d4:	83 ec 24             	sub    $0x24,%esp
  8012d7:	8b 75 08             	mov    0x8(%ebp),%esi
  8012da:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012dd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012e0:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012e1:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012e7:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012ea:	50                   	push   %eax
  8012eb:	e8 33 ff ff ff       	call   801223 <fd_lookup>
  8012f0:	89 c3                	mov    %eax,%ebx
  8012f2:	83 c4 10             	add    $0x10,%esp
  8012f5:	85 c0                	test   %eax,%eax
  8012f7:	78 05                	js     8012fe <fd_close+0x30>
	    || fd != fd2)
  8012f9:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012fc:	74 16                	je     801314 <fd_close+0x46>
		return (must_exist ? r : 0);
  8012fe:	89 f8                	mov    %edi,%eax
  801300:	84 c0                	test   %al,%al
  801302:	b8 00 00 00 00       	mov    $0x0,%eax
  801307:	0f 44 d8             	cmove  %eax,%ebx
}
  80130a:	89 d8                	mov    %ebx,%eax
  80130c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80130f:	5b                   	pop    %ebx
  801310:	5e                   	pop    %esi
  801311:	5f                   	pop    %edi
  801312:	5d                   	pop    %ebp
  801313:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801314:	83 ec 08             	sub    $0x8,%esp
  801317:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80131a:	50                   	push   %eax
  80131b:	ff 36                	pushl  (%esi)
  80131d:	e8 51 ff ff ff       	call   801273 <dev_lookup>
  801322:	89 c3                	mov    %eax,%ebx
  801324:	83 c4 10             	add    $0x10,%esp
  801327:	85 c0                	test   %eax,%eax
  801329:	78 1a                	js     801345 <fd_close+0x77>
		if (dev->dev_close)
  80132b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80132e:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801331:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801336:	85 c0                	test   %eax,%eax
  801338:	74 0b                	je     801345 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80133a:	83 ec 0c             	sub    $0xc,%esp
  80133d:	56                   	push   %esi
  80133e:	ff d0                	call   *%eax
  801340:	89 c3                	mov    %eax,%ebx
  801342:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801345:	83 ec 08             	sub    $0x8,%esp
  801348:	56                   	push   %esi
  801349:	6a 00                	push   $0x0
  80134b:	e8 55 fb ff ff       	call   800ea5 <sys_page_unmap>
	return r;
  801350:	83 c4 10             	add    $0x10,%esp
  801353:	eb b5                	jmp    80130a <fd_close+0x3c>

00801355 <close>:

int
close(int fdnum)
{
  801355:	55                   	push   %ebp
  801356:	89 e5                	mov    %esp,%ebp
  801358:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80135b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80135e:	50                   	push   %eax
  80135f:	ff 75 08             	pushl  0x8(%ebp)
  801362:	e8 bc fe ff ff       	call   801223 <fd_lookup>
  801367:	83 c4 10             	add    $0x10,%esp
  80136a:	85 c0                	test   %eax,%eax
  80136c:	79 02                	jns    801370 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80136e:	c9                   	leave  
  80136f:	c3                   	ret    
		return fd_close(fd, 1);
  801370:	83 ec 08             	sub    $0x8,%esp
  801373:	6a 01                	push   $0x1
  801375:	ff 75 f4             	pushl  -0xc(%ebp)
  801378:	e8 51 ff ff ff       	call   8012ce <fd_close>
  80137d:	83 c4 10             	add    $0x10,%esp
  801380:	eb ec                	jmp    80136e <close+0x19>

00801382 <close_all>:

void
close_all(void)
{
  801382:	55                   	push   %ebp
  801383:	89 e5                	mov    %esp,%ebp
  801385:	53                   	push   %ebx
  801386:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801389:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80138e:	83 ec 0c             	sub    $0xc,%esp
  801391:	53                   	push   %ebx
  801392:	e8 be ff ff ff       	call   801355 <close>
	for (i = 0; i < MAXFD; i++)
  801397:	83 c3 01             	add    $0x1,%ebx
  80139a:	83 c4 10             	add    $0x10,%esp
  80139d:	83 fb 20             	cmp    $0x20,%ebx
  8013a0:	75 ec                	jne    80138e <close_all+0xc>
}
  8013a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013a5:	c9                   	leave  
  8013a6:	c3                   	ret    

008013a7 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	57                   	push   %edi
  8013ab:	56                   	push   %esi
  8013ac:	53                   	push   %ebx
  8013ad:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013b0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013b3:	50                   	push   %eax
  8013b4:	ff 75 08             	pushl  0x8(%ebp)
  8013b7:	e8 67 fe ff ff       	call   801223 <fd_lookup>
  8013bc:	89 c3                	mov    %eax,%ebx
  8013be:	83 c4 10             	add    $0x10,%esp
  8013c1:	85 c0                	test   %eax,%eax
  8013c3:	0f 88 81 00 00 00    	js     80144a <dup+0xa3>
		return r;
	close(newfdnum);
  8013c9:	83 ec 0c             	sub    $0xc,%esp
  8013cc:	ff 75 0c             	pushl  0xc(%ebp)
  8013cf:	e8 81 ff ff ff       	call   801355 <close>

	newfd = INDEX2FD(newfdnum);
  8013d4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013d7:	c1 e6 0c             	shl    $0xc,%esi
  8013da:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013e0:	83 c4 04             	add    $0x4,%esp
  8013e3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013e6:	e8 cf fd ff ff       	call   8011ba <fd2data>
  8013eb:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013ed:	89 34 24             	mov    %esi,(%esp)
  8013f0:	e8 c5 fd ff ff       	call   8011ba <fd2data>
  8013f5:	83 c4 10             	add    $0x10,%esp
  8013f8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013fa:	89 d8                	mov    %ebx,%eax
  8013fc:	c1 e8 16             	shr    $0x16,%eax
  8013ff:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801406:	a8 01                	test   $0x1,%al
  801408:	74 11                	je     80141b <dup+0x74>
  80140a:	89 d8                	mov    %ebx,%eax
  80140c:	c1 e8 0c             	shr    $0xc,%eax
  80140f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801416:	f6 c2 01             	test   $0x1,%dl
  801419:	75 39                	jne    801454 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80141b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80141e:	89 d0                	mov    %edx,%eax
  801420:	c1 e8 0c             	shr    $0xc,%eax
  801423:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80142a:	83 ec 0c             	sub    $0xc,%esp
  80142d:	25 07 0e 00 00       	and    $0xe07,%eax
  801432:	50                   	push   %eax
  801433:	56                   	push   %esi
  801434:	6a 00                	push   $0x0
  801436:	52                   	push   %edx
  801437:	6a 00                	push   $0x0
  801439:	e8 25 fa ff ff       	call   800e63 <sys_page_map>
  80143e:	89 c3                	mov    %eax,%ebx
  801440:	83 c4 20             	add    $0x20,%esp
  801443:	85 c0                	test   %eax,%eax
  801445:	78 31                	js     801478 <dup+0xd1>
		goto err;

	return newfdnum;
  801447:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80144a:	89 d8                	mov    %ebx,%eax
  80144c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80144f:	5b                   	pop    %ebx
  801450:	5e                   	pop    %esi
  801451:	5f                   	pop    %edi
  801452:	5d                   	pop    %ebp
  801453:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801454:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80145b:	83 ec 0c             	sub    $0xc,%esp
  80145e:	25 07 0e 00 00       	and    $0xe07,%eax
  801463:	50                   	push   %eax
  801464:	57                   	push   %edi
  801465:	6a 00                	push   $0x0
  801467:	53                   	push   %ebx
  801468:	6a 00                	push   $0x0
  80146a:	e8 f4 f9 ff ff       	call   800e63 <sys_page_map>
  80146f:	89 c3                	mov    %eax,%ebx
  801471:	83 c4 20             	add    $0x20,%esp
  801474:	85 c0                	test   %eax,%eax
  801476:	79 a3                	jns    80141b <dup+0x74>
	sys_page_unmap(0, newfd);
  801478:	83 ec 08             	sub    $0x8,%esp
  80147b:	56                   	push   %esi
  80147c:	6a 00                	push   $0x0
  80147e:	e8 22 fa ff ff       	call   800ea5 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801483:	83 c4 08             	add    $0x8,%esp
  801486:	57                   	push   %edi
  801487:	6a 00                	push   $0x0
  801489:	e8 17 fa ff ff       	call   800ea5 <sys_page_unmap>
	return r;
  80148e:	83 c4 10             	add    $0x10,%esp
  801491:	eb b7                	jmp    80144a <dup+0xa3>

00801493 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
  801496:	53                   	push   %ebx
  801497:	83 ec 1c             	sub    $0x1c,%esp
  80149a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80149d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a0:	50                   	push   %eax
  8014a1:	53                   	push   %ebx
  8014a2:	e8 7c fd ff ff       	call   801223 <fd_lookup>
  8014a7:	83 c4 10             	add    $0x10,%esp
  8014aa:	85 c0                	test   %eax,%eax
  8014ac:	78 3f                	js     8014ed <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ae:	83 ec 08             	sub    $0x8,%esp
  8014b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b4:	50                   	push   %eax
  8014b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b8:	ff 30                	pushl  (%eax)
  8014ba:	e8 b4 fd ff ff       	call   801273 <dev_lookup>
  8014bf:	83 c4 10             	add    $0x10,%esp
  8014c2:	85 c0                	test   %eax,%eax
  8014c4:	78 27                	js     8014ed <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014c9:	8b 42 08             	mov    0x8(%edx),%eax
  8014cc:	83 e0 03             	and    $0x3,%eax
  8014cf:	83 f8 01             	cmp    $0x1,%eax
  8014d2:	74 1e                	je     8014f2 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d7:	8b 40 08             	mov    0x8(%eax),%eax
  8014da:	85 c0                	test   %eax,%eax
  8014dc:	74 35                	je     801513 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014de:	83 ec 04             	sub    $0x4,%esp
  8014e1:	ff 75 10             	pushl  0x10(%ebp)
  8014e4:	ff 75 0c             	pushl  0xc(%ebp)
  8014e7:	52                   	push   %edx
  8014e8:	ff d0                	call   *%eax
  8014ea:	83 c4 10             	add    $0x10,%esp
}
  8014ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f0:	c9                   	leave  
  8014f1:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014f2:	a1 08 40 80 00       	mov    0x804008,%eax
  8014f7:	8b 40 48             	mov    0x48(%eax),%eax
  8014fa:	83 ec 04             	sub    $0x4,%esp
  8014fd:	53                   	push   %ebx
  8014fe:	50                   	push   %eax
  8014ff:	68 10 2c 80 00       	push   $0x802c10
  801504:	e8 c6 ed ff ff       	call   8002cf <cprintf>
		return -E_INVAL;
  801509:	83 c4 10             	add    $0x10,%esp
  80150c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801511:	eb da                	jmp    8014ed <read+0x5a>
		return -E_NOT_SUPP;
  801513:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801518:	eb d3                	jmp    8014ed <read+0x5a>

0080151a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
  80151d:	57                   	push   %edi
  80151e:	56                   	push   %esi
  80151f:	53                   	push   %ebx
  801520:	83 ec 0c             	sub    $0xc,%esp
  801523:	8b 7d 08             	mov    0x8(%ebp),%edi
  801526:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801529:	bb 00 00 00 00       	mov    $0x0,%ebx
  80152e:	39 f3                	cmp    %esi,%ebx
  801530:	73 23                	jae    801555 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801532:	83 ec 04             	sub    $0x4,%esp
  801535:	89 f0                	mov    %esi,%eax
  801537:	29 d8                	sub    %ebx,%eax
  801539:	50                   	push   %eax
  80153a:	89 d8                	mov    %ebx,%eax
  80153c:	03 45 0c             	add    0xc(%ebp),%eax
  80153f:	50                   	push   %eax
  801540:	57                   	push   %edi
  801541:	e8 4d ff ff ff       	call   801493 <read>
		if (m < 0)
  801546:	83 c4 10             	add    $0x10,%esp
  801549:	85 c0                	test   %eax,%eax
  80154b:	78 06                	js     801553 <readn+0x39>
			return m;
		if (m == 0)
  80154d:	74 06                	je     801555 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  80154f:	01 c3                	add    %eax,%ebx
  801551:	eb db                	jmp    80152e <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801553:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801555:	89 d8                	mov    %ebx,%eax
  801557:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80155a:	5b                   	pop    %ebx
  80155b:	5e                   	pop    %esi
  80155c:	5f                   	pop    %edi
  80155d:	5d                   	pop    %ebp
  80155e:	c3                   	ret    

0080155f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
  801562:	53                   	push   %ebx
  801563:	83 ec 1c             	sub    $0x1c,%esp
  801566:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801569:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80156c:	50                   	push   %eax
  80156d:	53                   	push   %ebx
  80156e:	e8 b0 fc ff ff       	call   801223 <fd_lookup>
  801573:	83 c4 10             	add    $0x10,%esp
  801576:	85 c0                	test   %eax,%eax
  801578:	78 3a                	js     8015b4 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80157a:	83 ec 08             	sub    $0x8,%esp
  80157d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801580:	50                   	push   %eax
  801581:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801584:	ff 30                	pushl  (%eax)
  801586:	e8 e8 fc ff ff       	call   801273 <dev_lookup>
  80158b:	83 c4 10             	add    $0x10,%esp
  80158e:	85 c0                	test   %eax,%eax
  801590:	78 22                	js     8015b4 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801592:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801595:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801599:	74 1e                	je     8015b9 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80159b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80159e:	8b 52 0c             	mov    0xc(%edx),%edx
  8015a1:	85 d2                	test   %edx,%edx
  8015a3:	74 35                	je     8015da <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015a5:	83 ec 04             	sub    $0x4,%esp
  8015a8:	ff 75 10             	pushl  0x10(%ebp)
  8015ab:	ff 75 0c             	pushl  0xc(%ebp)
  8015ae:	50                   	push   %eax
  8015af:	ff d2                	call   *%edx
  8015b1:	83 c4 10             	add    $0x10,%esp
}
  8015b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015b9:	a1 08 40 80 00       	mov    0x804008,%eax
  8015be:	8b 40 48             	mov    0x48(%eax),%eax
  8015c1:	83 ec 04             	sub    $0x4,%esp
  8015c4:	53                   	push   %ebx
  8015c5:	50                   	push   %eax
  8015c6:	68 2c 2c 80 00       	push   $0x802c2c
  8015cb:	e8 ff ec ff ff       	call   8002cf <cprintf>
		return -E_INVAL;
  8015d0:	83 c4 10             	add    $0x10,%esp
  8015d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015d8:	eb da                	jmp    8015b4 <write+0x55>
		return -E_NOT_SUPP;
  8015da:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015df:	eb d3                	jmp    8015b4 <write+0x55>

008015e1 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
  8015e4:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ea:	50                   	push   %eax
  8015eb:	ff 75 08             	pushl  0x8(%ebp)
  8015ee:	e8 30 fc ff ff       	call   801223 <fd_lookup>
  8015f3:	83 c4 10             	add    $0x10,%esp
  8015f6:	85 c0                	test   %eax,%eax
  8015f8:	78 0e                	js     801608 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801600:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801603:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801608:	c9                   	leave  
  801609:	c3                   	ret    

0080160a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	53                   	push   %ebx
  80160e:	83 ec 1c             	sub    $0x1c,%esp
  801611:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801614:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801617:	50                   	push   %eax
  801618:	53                   	push   %ebx
  801619:	e8 05 fc ff ff       	call   801223 <fd_lookup>
  80161e:	83 c4 10             	add    $0x10,%esp
  801621:	85 c0                	test   %eax,%eax
  801623:	78 37                	js     80165c <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801625:	83 ec 08             	sub    $0x8,%esp
  801628:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80162b:	50                   	push   %eax
  80162c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162f:	ff 30                	pushl  (%eax)
  801631:	e8 3d fc ff ff       	call   801273 <dev_lookup>
  801636:	83 c4 10             	add    $0x10,%esp
  801639:	85 c0                	test   %eax,%eax
  80163b:	78 1f                	js     80165c <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80163d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801640:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801644:	74 1b                	je     801661 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801646:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801649:	8b 52 18             	mov    0x18(%edx),%edx
  80164c:	85 d2                	test   %edx,%edx
  80164e:	74 32                	je     801682 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801650:	83 ec 08             	sub    $0x8,%esp
  801653:	ff 75 0c             	pushl  0xc(%ebp)
  801656:	50                   	push   %eax
  801657:	ff d2                	call   *%edx
  801659:	83 c4 10             	add    $0x10,%esp
}
  80165c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80165f:	c9                   	leave  
  801660:	c3                   	ret    
			thisenv->env_id, fdnum);
  801661:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801666:	8b 40 48             	mov    0x48(%eax),%eax
  801669:	83 ec 04             	sub    $0x4,%esp
  80166c:	53                   	push   %ebx
  80166d:	50                   	push   %eax
  80166e:	68 ec 2b 80 00       	push   $0x802bec
  801673:	e8 57 ec ff ff       	call   8002cf <cprintf>
		return -E_INVAL;
  801678:	83 c4 10             	add    $0x10,%esp
  80167b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801680:	eb da                	jmp    80165c <ftruncate+0x52>
		return -E_NOT_SUPP;
  801682:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801687:	eb d3                	jmp    80165c <ftruncate+0x52>

00801689 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
  80168c:	53                   	push   %ebx
  80168d:	83 ec 1c             	sub    $0x1c,%esp
  801690:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801693:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801696:	50                   	push   %eax
  801697:	ff 75 08             	pushl  0x8(%ebp)
  80169a:	e8 84 fb ff ff       	call   801223 <fd_lookup>
  80169f:	83 c4 10             	add    $0x10,%esp
  8016a2:	85 c0                	test   %eax,%eax
  8016a4:	78 4b                	js     8016f1 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016a6:	83 ec 08             	sub    $0x8,%esp
  8016a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ac:	50                   	push   %eax
  8016ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b0:	ff 30                	pushl  (%eax)
  8016b2:	e8 bc fb ff ff       	call   801273 <dev_lookup>
  8016b7:	83 c4 10             	add    $0x10,%esp
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	78 33                	js     8016f1 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8016be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c1:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016c5:	74 2f                	je     8016f6 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016c7:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016ca:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016d1:	00 00 00 
	stat->st_isdir = 0;
  8016d4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016db:	00 00 00 
	stat->st_dev = dev;
  8016de:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016e4:	83 ec 08             	sub    $0x8,%esp
  8016e7:	53                   	push   %ebx
  8016e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8016eb:	ff 50 14             	call   *0x14(%eax)
  8016ee:	83 c4 10             	add    $0x10,%esp
}
  8016f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016f4:	c9                   	leave  
  8016f5:	c3                   	ret    
		return -E_NOT_SUPP;
  8016f6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016fb:	eb f4                	jmp    8016f1 <fstat+0x68>

008016fd <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	56                   	push   %esi
  801701:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801702:	83 ec 08             	sub    $0x8,%esp
  801705:	6a 00                	push   $0x0
  801707:	ff 75 08             	pushl  0x8(%ebp)
  80170a:	e8 22 02 00 00       	call   801931 <open>
  80170f:	89 c3                	mov    %eax,%ebx
  801711:	83 c4 10             	add    $0x10,%esp
  801714:	85 c0                	test   %eax,%eax
  801716:	78 1b                	js     801733 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801718:	83 ec 08             	sub    $0x8,%esp
  80171b:	ff 75 0c             	pushl  0xc(%ebp)
  80171e:	50                   	push   %eax
  80171f:	e8 65 ff ff ff       	call   801689 <fstat>
  801724:	89 c6                	mov    %eax,%esi
	close(fd);
  801726:	89 1c 24             	mov    %ebx,(%esp)
  801729:	e8 27 fc ff ff       	call   801355 <close>
	return r;
  80172e:	83 c4 10             	add    $0x10,%esp
  801731:	89 f3                	mov    %esi,%ebx
}
  801733:	89 d8                	mov    %ebx,%eax
  801735:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801738:	5b                   	pop    %ebx
  801739:	5e                   	pop    %esi
  80173a:	5d                   	pop    %ebp
  80173b:	c3                   	ret    

0080173c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	56                   	push   %esi
  801740:	53                   	push   %ebx
  801741:	89 c6                	mov    %eax,%esi
  801743:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801745:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80174c:	74 27                	je     801775 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80174e:	6a 07                	push   $0x7
  801750:	68 00 50 80 00       	push   $0x805000
  801755:	56                   	push   %esi
  801756:	ff 35 00 40 80 00    	pushl  0x804000
  80175c:	e8 08 0c 00 00       	call   802369 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801761:	83 c4 0c             	add    $0xc,%esp
  801764:	6a 00                	push   $0x0
  801766:	53                   	push   %ebx
  801767:	6a 00                	push   $0x0
  801769:	e8 92 0b 00 00       	call   802300 <ipc_recv>
}
  80176e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801771:	5b                   	pop    %ebx
  801772:	5e                   	pop    %esi
  801773:	5d                   	pop    %ebp
  801774:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801775:	83 ec 0c             	sub    $0xc,%esp
  801778:	6a 01                	push   $0x1
  80177a:	e8 42 0c 00 00       	call   8023c1 <ipc_find_env>
  80177f:	a3 00 40 80 00       	mov    %eax,0x804000
  801784:	83 c4 10             	add    $0x10,%esp
  801787:	eb c5                	jmp    80174e <fsipc+0x12>

00801789 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
  80178c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	8b 40 0c             	mov    0xc(%eax),%eax
  801795:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80179a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a7:	b8 02 00 00 00       	mov    $0x2,%eax
  8017ac:	e8 8b ff ff ff       	call   80173c <fsipc>
}
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <devfile_flush>:
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8017bf:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c9:	b8 06 00 00 00       	mov    $0x6,%eax
  8017ce:	e8 69 ff ff ff       	call   80173c <fsipc>
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <devfile_stat>:
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	53                   	push   %ebx
  8017d9:	83 ec 04             	sub    $0x4,%esp
  8017dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ef:	b8 05 00 00 00       	mov    $0x5,%eax
  8017f4:	e8 43 ff ff ff       	call   80173c <fsipc>
  8017f9:	85 c0                	test   %eax,%eax
  8017fb:	78 2c                	js     801829 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017fd:	83 ec 08             	sub    $0x8,%esp
  801800:	68 00 50 80 00       	push   $0x805000
  801805:	53                   	push   %ebx
  801806:	e8 23 f2 ff ff       	call   800a2e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80180b:	a1 80 50 80 00       	mov    0x805080,%eax
  801810:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801816:	a1 84 50 80 00       	mov    0x805084,%eax
  80181b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801821:	83 c4 10             	add    $0x10,%esp
  801824:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801829:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <devfile_write>:
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
  801831:	53                   	push   %ebx
  801832:	83 ec 08             	sub    $0x8,%esp
  801835:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	8b 40 0c             	mov    0xc(%eax),%eax
  80183e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801843:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801849:	53                   	push   %ebx
  80184a:	ff 75 0c             	pushl  0xc(%ebp)
  80184d:	68 08 50 80 00       	push   $0x805008
  801852:	e8 c7 f3 ff ff       	call   800c1e <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801857:	ba 00 00 00 00       	mov    $0x0,%edx
  80185c:	b8 04 00 00 00       	mov    $0x4,%eax
  801861:	e8 d6 fe ff ff       	call   80173c <fsipc>
  801866:	83 c4 10             	add    $0x10,%esp
  801869:	85 c0                	test   %eax,%eax
  80186b:	78 0b                	js     801878 <devfile_write+0x4a>
	assert(r <= n);
  80186d:	39 d8                	cmp    %ebx,%eax
  80186f:	77 0c                	ja     80187d <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801871:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801876:	7f 1e                	jg     801896 <devfile_write+0x68>
}
  801878:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    
	assert(r <= n);
  80187d:	68 60 2c 80 00       	push   $0x802c60
  801882:	68 67 2c 80 00       	push   $0x802c67
  801887:	68 98 00 00 00       	push   $0x98
  80188c:	68 7c 2c 80 00       	push   $0x802c7c
  801891:	e8 43 e9 ff ff       	call   8001d9 <_panic>
	assert(r <= PGSIZE);
  801896:	68 87 2c 80 00       	push   $0x802c87
  80189b:	68 67 2c 80 00       	push   $0x802c67
  8018a0:	68 99 00 00 00       	push   $0x99
  8018a5:	68 7c 2c 80 00       	push   $0x802c7c
  8018aa:	e8 2a e9 ff ff       	call   8001d9 <_panic>

008018af <devfile_read>:
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
  8018b2:	56                   	push   %esi
  8018b3:	53                   	push   %ebx
  8018b4:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8018bd:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018c2:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018cd:	b8 03 00 00 00       	mov    $0x3,%eax
  8018d2:	e8 65 fe ff ff       	call   80173c <fsipc>
  8018d7:	89 c3                	mov    %eax,%ebx
  8018d9:	85 c0                	test   %eax,%eax
  8018db:	78 1f                	js     8018fc <devfile_read+0x4d>
	assert(r <= n);
  8018dd:	39 f0                	cmp    %esi,%eax
  8018df:	77 24                	ja     801905 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018e1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018e6:	7f 33                	jg     80191b <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018e8:	83 ec 04             	sub    $0x4,%esp
  8018eb:	50                   	push   %eax
  8018ec:	68 00 50 80 00       	push   $0x805000
  8018f1:	ff 75 0c             	pushl  0xc(%ebp)
  8018f4:	e8 c3 f2 ff ff       	call   800bbc <memmove>
	return r;
  8018f9:	83 c4 10             	add    $0x10,%esp
}
  8018fc:	89 d8                	mov    %ebx,%eax
  8018fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801901:	5b                   	pop    %ebx
  801902:	5e                   	pop    %esi
  801903:	5d                   	pop    %ebp
  801904:	c3                   	ret    
	assert(r <= n);
  801905:	68 60 2c 80 00       	push   $0x802c60
  80190a:	68 67 2c 80 00       	push   $0x802c67
  80190f:	6a 7c                	push   $0x7c
  801911:	68 7c 2c 80 00       	push   $0x802c7c
  801916:	e8 be e8 ff ff       	call   8001d9 <_panic>
	assert(r <= PGSIZE);
  80191b:	68 87 2c 80 00       	push   $0x802c87
  801920:	68 67 2c 80 00       	push   $0x802c67
  801925:	6a 7d                	push   $0x7d
  801927:	68 7c 2c 80 00       	push   $0x802c7c
  80192c:	e8 a8 e8 ff ff       	call   8001d9 <_panic>

00801931 <open>:
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	56                   	push   %esi
  801935:	53                   	push   %ebx
  801936:	83 ec 1c             	sub    $0x1c,%esp
  801939:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80193c:	56                   	push   %esi
  80193d:	e8 b3 f0 ff ff       	call   8009f5 <strlen>
  801942:	83 c4 10             	add    $0x10,%esp
  801945:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80194a:	7f 6c                	jg     8019b8 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80194c:	83 ec 0c             	sub    $0xc,%esp
  80194f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801952:	50                   	push   %eax
  801953:	e8 79 f8 ff ff       	call   8011d1 <fd_alloc>
  801958:	89 c3                	mov    %eax,%ebx
  80195a:	83 c4 10             	add    $0x10,%esp
  80195d:	85 c0                	test   %eax,%eax
  80195f:	78 3c                	js     80199d <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801961:	83 ec 08             	sub    $0x8,%esp
  801964:	56                   	push   %esi
  801965:	68 00 50 80 00       	push   $0x805000
  80196a:	e8 bf f0 ff ff       	call   800a2e <strcpy>
	fsipcbuf.open.req_omode = mode;
  80196f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801972:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801977:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80197a:	b8 01 00 00 00       	mov    $0x1,%eax
  80197f:	e8 b8 fd ff ff       	call   80173c <fsipc>
  801984:	89 c3                	mov    %eax,%ebx
  801986:	83 c4 10             	add    $0x10,%esp
  801989:	85 c0                	test   %eax,%eax
  80198b:	78 19                	js     8019a6 <open+0x75>
	return fd2num(fd);
  80198d:	83 ec 0c             	sub    $0xc,%esp
  801990:	ff 75 f4             	pushl  -0xc(%ebp)
  801993:	e8 12 f8 ff ff       	call   8011aa <fd2num>
  801998:	89 c3                	mov    %eax,%ebx
  80199a:	83 c4 10             	add    $0x10,%esp
}
  80199d:	89 d8                	mov    %ebx,%eax
  80199f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019a2:	5b                   	pop    %ebx
  8019a3:	5e                   	pop    %esi
  8019a4:	5d                   	pop    %ebp
  8019a5:	c3                   	ret    
		fd_close(fd, 0);
  8019a6:	83 ec 08             	sub    $0x8,%esp
  8019a9:	6a 00                	push   $0x0
  8019ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ae:	e8 1b f9 ff ff       	call   8012ce <fd_close>
		return r;
  8019b3:	83 c4 10             	add    $0x10,%esp
  8019b6:	eb e5                	jmp    80199d <open+0x6c>
		return -E_BAD_PATH;
  8019b8:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019bd:	eb de                	jmp    80199d <open+0x6c>

008019bf <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
  8019c2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ca:	b8 08 00 00 00       	mov    $0x8,%eax
  8019cf:	e8 68 fd ff ff       	call   80173c <fsipc>
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
  8019d9:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8019dc:	68 93 2c 80 00       	push   $0x802c93
  8019e1:	ff 75 0c             	pushl  0xc(%ebp)
  8019e4:	e8 45 f0 ff ff       	call   800a2e <strcpy>
	return 0;
}
  8019e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <devsock_close>:
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
  8019f3:	53                   	push   %ebx
  8019f4:	83 ec 10             	sub    $0x10,%esp
  8019f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8019fa:	53                   	push   %ebx
  8019fb:	e8 00 0a 00 00       	call   802400 <pageref>
  801a00:	83 c4 10             	add    $0x10,%esp
		return 0;
  801a03:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801a08:	83 f8 01             	cmp    $0x1,%eax
  801a0b:	74 07                	je     801a14 <devsock_close+0x24>
}
  801a0d:	89 d0                	mov    %edx,%eax
  801a0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801a14:	83 ec 0c             	sub    $0xc,%esp
  801a17:	ff 73 0c             	pushl  0xc(%ebx)
  801a1a:	e8 b9 02 00 00       	call   801cd8 <nsipc_close>
  801a1f:	89 c2                	mov    %eax,%edx
  801a21:	83 c4 10             	add    $0x10,%esp
  801a24:	eb e7                	jmp    801a0d <devsock_close+0x1d>

00801a26 <devsock_write>:
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
  801a29:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a2c:	6a 00                	push   $0x0
  801a2e:	ff 75 10             	pushl  0x10(%ebp)
  801a31:	ff 75 0c             	pushl  0xc(%ebp)
  801a34:	8b 45 08             	mov    0x8(%ebp),%eax
  801a37:	ff 70 0c             	pushl  0xc(%eax)
  801a3a:	e8 76 03 00 00       	call   801db5 <nsipc_send>
}
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <devsock_read>:
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
  801a44:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a47:	6a 00                	push   $0x0
  801a49:	ff 75 10             	pushl  0x10(%ebp)
  801a4c:	ff 75 0c             	pushl  0xc(%ebp)
  801a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a52:	ff 70 0c             	pushl  0xc(%eax)
  801a55:	e8 ef 02 00 00       	call   801d49 <nsipc_recv>
}
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <fd2sockid>:
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
  801a5f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a62:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a65:	52                   	push   %edx
  801a66:	50                   	push   %eax
  801a67:	e8 b7 f7 ff ff       	call   801223 <fd_lookup>
  801a6c:	83 c4 10             	add    $0x10,%esp
  801a6f:	85 c0                	test   %eax,%eax
  801a71:	78 10                	js     801a83 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a76:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a7c:	39 08                	cmp    %ecx,(%eax)
  801a7e:	75 05                	jne    801a85 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a80:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    
		return -E_NOT_SUPP;
  801a85:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a8a:	eb f7                	jmp    801a83 <fd2sockid+0x27>

00801a8c <alloc_sockfd>:
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	56                   	push   %esi
  801a90:	53                   	push   %ebx
  801a91:	83 ec 1c             	sub    $0x1c,%esp
  801a94:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a96:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a99:	50                   	push   %eax
  801a9a:	e8 32 f7 ff ff       	call   8011d1 <fd_alloc>
  801a9f:	89 c3                	mov    %eax,%ebx
  801aa1:	83 c4 10             	add    $0x10,%esp
  801aa4:	85 c0                	test   %eax,%eax
  801aa6:	78 43                	js     801aeb <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801aa8:	83 ec 04             	sub    $0x4,%esp
  801aab:	68 07 04 00 00       	push   $0x407
  801ab0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ab3:	6a 00                	push   $0x0
  801ab5:	e8 66 f3 ff ff       	call   800e20 <sys_page_alloc>
  801aba:	89 c3                	mov    %eax,%ebx
  801abc:	83 c4 10             	add    $0x10,%esp
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	78 28                	js     801aeb <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac6:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801acc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ad8:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801adb:	83 ec 0c             	sub    $0xc,%esp
  801ade:	50                   	push   %eax
  801adf:	e8 c6 f6 ff ff       	call   8011aa <fd2num>
  801ae4:	89 c3                	mov    %eax,%ebx
  801ae6:	83 c4 10             	add    $0x10,%esp
  801ae9:	eb 0c                	jmp    801af7 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801aeb:	83 ec 0c             	sub    $0xc,%esp
  801aee:	56                   	push   %esi
  801aef:	e8 e4 01 00 00       	call   801cd8 <nsipc_close>
		return r;
  801af4:	83 c4 10             	add    $0x10,%esp
}
  801af7:	89 d8                	mov    %ebx,%eax
  801af9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801afc:	5b                   	pop    %ebx
  801afd:	5e                   	pop    %esi
  801afe:	5d                   	pop    %ebp
  801aff:	c3                   	ret    

00801b00 <accept>:
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b06:	8b 45 08             	mov    0x8(%ebp),%eax
  801b09:	e8 4e ff ff ff       	call   801a5c <fd2sockid>
  801b0e:	85 c0                	test   %eax,%eax
  801b10:	78 1b                	js     801b2d <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b12:	83 ec 04             	sub    $0x4,%esp
  801b15:	ff 75 10             	pushl  0x10(%ebp)
  801b18:	ff 75 0c             	pushl  0xc(%ebp)
  801b1b:	50                   	push   %eax
  801b1c:	e8 0e 01 00 00       	call   801c2f <nsipc_accept>
  801b21:	83 c4 10             	add    $0x10,%esp
  801b24:	85 c0                	test   %eax,%eax
  801b26:	78 05                	js     801b2d <accept+0x2d>
	return alloc_sockfd(r);
  801b28:	e8 5f ff ff ff       	call   801a8c <alloc_sockfd>
}
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <bind>:
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
  801b32:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b35:	8b 45 08             	mov    0x8(%ebp),%eax
  801b38:	e8 1f ff ff ff       	call   801a5c <fd2sockid>
  801b3d:	85 c0                	test   %eax,%eax
  801b3f:	78 12                	js     801b53 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801b41:	83 ec 04             	sub    $0x4,%esp
  801b44:	ff 75 10             	pushl  0x10(%ebp)
  801b47:	ff 75 0c             	pushl  0xc(%ebp)
  801b4a:	50                   	push   %eax
  801b4b:	e8 31 01 00 00       	call   801c81 <nsipc_bind>
  801b50:	83 c4 10             	add    $0x10,%esp
}
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <shutdown>:
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
  801b58:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5e:	e8 f9 fe ff ff       	call   801a5c <fd2sockid>
  801b63:	85 c0                	test   %eax,%eax
  801b65:	78 0f                	js     801b76 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801b67:	83 ec 08             	sub    $0x8,%esp
  801b6a:	ff 75 0c             	pushl  0xc(%ebp)
  801b6d:	50                   	push   %eax
  801b6e:	e8 43 01 00 00       	call   801cb6 <nsipc_shutdown>
  801b73:	83 c4 10             	add    $0x10,%esp
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <connect>:
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
  801b7b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b81:	e8 d6 fe ff ff       	call   801a5c <fd2sockid>
  801b86:	85 c0                	test   %eax,%eax
  801b88:	78 12                	js     801b9c <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b8a:	83 ec 04             	sub    $0x4,%esp
  801b8d:	ff 75 10             	pushl  0x10(%ebp)
  801b90:	ff 75 0c             	pushl  0xc(%ebp)
  801b93:	50                   	push   %eax
  801b94:	e8 59 01 00 00       	call   801cf2 <nsipc_connect>
  801b99:	83 c4 10             	add    $0x10,%esp
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <listen>:
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
  801ba1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba7:	e8 b0 fe ff ff       	call   801a5c <fd2sockid>
  801bac:	85 c0                	test   %eax,%eax
  801bae:	78 0f                	js     801bbf <listen+0x21>
	return nsipc_listen(r, backlog);
  801bb0:	83 ec 08             	sub    $0x8,%esp
  801bb3:	ff 75 0c             	pushl  0xc(%ebp)
  801bb6:	50                   	push   %eax
  801bb7:	e8 6b 01 00 00       	call   801d27 <nsipc_listen>
  801bbc:	83 c4 10             	add    $0x10,%esp
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <socket>:

int
socket(int domain, int type, int protocol)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801bc7:	ff 75 10             	pushl  0x10(%ebp)
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	ff 75 08             	pushl  0x8(%ebp)
  801bd0:	e8 3e 02 00 00       	call   801e13 <nsipc_socket>
  801bd5:	83 c4 10             	add    $0x10,%esp
  801bd8:	85 c0                	test   %eax,%eax
  801bda:	78 05                	js     801be1 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801bdc:	e8 ab fe ff ff       	call   801a8c <alloc_sockfd>
}
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
  801be6:	53                   	push   %ebx
  801be7:	83 ec 04             	sub    $0x4,%esp
  801bea:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801bec:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801bf3:	74 26                	je     801c1b <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801bf5:	6a 07                	push   $0x7
  801bf7:	68 00 60 80 00       	push   $0x806000
  801bfc:	53                   	push   %ebx
  801bfd:	ff 35 04 40 80 00    	pushl  0x804004
  801c03:	e8 61 07 00 00       	call   802369 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c08:	83 c4 0c             	add    $0xc,%esp
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	e8 ea 06 00 00       	call   802300 <ipc_recv>
}
  801c16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c1b:	83 ec 0c             	sub    $0xc,%esp
  801c1e:	6a 02                	push   $0x2
  801c20:	e8 9c 07 00 00       	call   8023c1 <ipc_find_env>
  801c25:	a3 04 40 80 00       	mov    %eax,0x804004
  801c2a:	83 c4 10             	add    $0x10,%esp
  801c2d:	eb c6                	jmp    801bf5 <nsipc+0x12>

00801c2f <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	56                   	push   %esi
  801c33:	53                   	push   %ebx
  801c34:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c3f:	8b 06                	mov    (%esi),%eax
  801c41:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c46:	b8 01 00 00 00       	mov    $0x1,%eax
  801c4b:	e8 93 ff ff ff       	call   801be3 <nsipc>
  801c50:	89 c3                	mov    %eax,%ebx
  801c52:	85 c0                	test   %eax,%eax
  801c54:	79 09                	jns    801c5f <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801c56:	89 d8                	mov    %ebx,%eax
  801c58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c5b:	5b                   	pop    %ebx
  801c5c:	5e                   	pop    %esi
  801c5d:	5d                   	pop    %ebp
  801c5e:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c5f:	83 ec 04             	sub    $0x4,%esp
  801c62:	ff 35 10 60 80 00    	pushl  0x806010
  801c68:	68 00 60 80 00       	push   $0x806000
  801c6d:	ff 75 0c             	pushl  0xc(%ebp)
  801c70:	e8 47 ef ff ff       	call   800bbc <memmove>
		*addrlen = ret->ret_addrlen;
  801c75:	a1 10 60 80 00       	mov    0x806010,%eax
  801c7a:	89 06                	mov    %eax,(%esi)
  801c7c:	83 c4 10             	add    $0x10,%esp
	return r;
  801c7f:	eb d5                	jmp    801c56 <nsipc_accept+0x27>

00801c81 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	53                   	push   %ebx
  801c85:	83 ec 08             	sub    $0x8,%esp
  801c88:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c93:	53                   	push   %ebx
  801c94:	ff 75 0c             	pushl  0xc(%ebp)
  801c97:	68 04 60 80 00       	push   $0x806004
  801c9c:	e8 1b ef ff ff       	call   800bbc <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ca1:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801ca7:	b8 02 00 00 00       	mov    $0x2,%eax
  801cac:	e8 32 ff ff ff       	call   801be3 <nsipc>
}
  801cb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc7:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ccc:	b8 03 00 00 00       	mov    $0x3,%eax
  801cd1:	e8 0d ff ff ff       	call   801be3 <nsipc>
}
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <nsipc_close>:

int
nsipc_close(int s)
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
  801cdb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801cde:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce1:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ce6:	b8 04 00 00 00       	mov    $0x4,%eax
  801ceb:	e8 f3 fe ff ff       	call   801be3 <nsipc>
}
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
  801cf5:	53                   	push   %ebx
  801cf6:	83 ec 08             	sub    $0x8,%esp
  801cf9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cff:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d04:	53                   	push   %ebx
  801d05:	ff 75 0c             	pushl  0xc(%ebp)
  801d08:	68 04 60 80 00       	push   $0x806004
  801d0d:	e8 aa ee ff ff       	call   800bbc <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d12:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d18:	b8 05 00 00 00       	mov    $0x5,%eax
  801d1d:	e8 c1 fe ff ff       	call   801be3 <nsipc>
}
  801d22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
  801d2a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d30:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d38:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d3d:	b8 06 00 00 00       	mov    $0x6,%eax
  801d42:	e8 9c fe ff ff       	call   801be3 <nsipc>
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
  801d4c:	56                   	push   %esi
  801d4d:	53                   	push   %ebx
  801d4e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d51:	8b 45 08             	mov    0x8(%ebp),%eax
  801d54:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d59:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d5f:	8b 45 14             	mov    0x14(%ebp),%eax
  801d62:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d67:	b8 07 00 00 00       	mov    $0x7,%eax
  801d6c:	e8 72 fe ff ff       	call   801be3 <nsipc>
  801d71:	89 c3                	mov    %eax,%ebx
  801d73:	85 c0                	test   %eax,%eax
  801d75:	78 1f                	js     801d96 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d77:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d7c:	7f 21                	jg     801d9f <nsipc_recv+0x56>
  801d7e:	39 c6                	cmp    %eax,%esi
  801d80:	7c 1d                	jl     801d9f <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d82:	83 ec 04             	sub    $0x4,%esp
  801d85:	50                   	push   %eax
  801d86:	68 00 60 80 00       	push   $0x806000
  801d8b:	ff 75 0c             	pushl  0xc(%ebp)
  801d8e:	e8 29 ee ff ff       	call   800bbc <memmove>
  801d93:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d96:	89 d8                	mov    %ebx,%eax
  801d98:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d9b:	5b                   	pop    %ebx
  801d9c:	5e                   	pop    %esi
  801d9d:	5d                   	pop    %ebp
  801d9e:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d9f:	68 9f 2c 80 00       	push   $0x802c9f
  801da4:	68 67 2c 80 00       	push   $0x802c67
  801da9:	6a 62                	push   $0x62
  801dab:	68 b4 2c 80 00       	push   $0x802cb4
  801db0:	e8 24 e4 ff ff       	call   8001d9 <_panic>

00801db5 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
  801db8:	53                   	push   %ebx
  801db9:	83 ec 04             	sub    $0x4,%esp
  801dbc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc2:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801dc7:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801dcd:	7f 2e                	jg     801dfd <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801dcf:	83 ec 04             	sub    $0x4,%esp
  801dd2:	53                   	push   %ebx
  801dd3:	ff 75 0c             	pushl  0xc(%ebp)
  801dd6:	68 0c 60 80 00       	push   $0x80600c
  801ddb:	e8 dc ed ff ff       	call   800bbc <memmove>
	nsipcbuf.send.req_size = size;
  801de0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801de6:	8b 45 14             	mov    0x14(%ebp),%eax
  801de9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801dee:	b8 08 00 00 00       	mov    $0x8,%eax
  801df3:	e8 eb fd ff ff       	call   801be3 <nsipc>
}
  801df8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dfb:	c9                   	leave  
  801dfc:	c3                   	ret    
	assert(size < 1600);
  801dfd:	68 c0 2c 80 00       	push   $0x802cc0
  801e02:	68 67 2c 80 00       	push   $0x802c67
  801e07:	6a 6d                	push   $0x6d
  801e09:	68 b4 2c 80 00       	push   $0x802cb4
  801e0e:	e8 c6 e3 ff ff       	call   8001d9 <_panic>

00801e13 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
  801e16:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e19:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e24:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e29:	8b 45 10             	mov    0x10(%ebp),%eax
  801e2c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e31:	b8 09 00 00 00       	mov    $0x9,%eax
  801e36:	e8 a8 fd ff ff       	call   801be3 <nsipc>
}
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    

00801e3d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
  801e40:	56                   	push   %esi
  801e41:	53                   	push   %ebx
  801e42:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e45:	83 ec 0c             	sub    $0xc,%esp
  801e48:	ff 75 08             	pushl  0x8(%ebp)
  801e4b:	e8 6a f3 ff ff       	call   8011ba <fd2data>
  801e50:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e52:	83 c4 08             	add    $0x8,%esp
  801e55:	68 cc 2c 80 00       	push   $0x802ccc
  801e5a:	53                   	push   %ebx
  801e5b:	e8 ce eb ff ff       	call   800a2e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e60:	8b 46 04             	mov    0x4(%esi),%eax
  801e63:	2b 06                	sub    (%esi),%eax
  801e65:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e6b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e72:	00 00 00 
	stat->st_dev = &devpipe;
  801e75:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801e7c:	30 80 00 
	return 0;
}
  801e7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e84:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e87:	5b                   	pop    %ebx
  801e88:	5e                   	pop    %esi
  801e89:	5d                   	pop    %ebp
  801e8a:	c3                   	ret    

00801e8b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	53                   	push   %ebx
  801e8f:	83 ec 0c             	sub    $0xc,%esp
  801e92:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e95:	53                   	push   %ebx
  801e96:	6a 00                	push   $0x0
  801e98:	e8 08 f0 ff ff       	call   800ea5 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e9d:	89 1c 24             	mov    %ebx,(%esp)
  801ea0:	e8 15 f3 ff ff       	call   8011ba <fd2data>
  801ea5:	83 c4 08             	add    $0x8,%esp
  801ea8:	50                   	push   %eax
  801ea9:	6a 00                	push   $0x0
  801eab:	e8 f5 ef ff ff       	call   800ea5 <sys_page_unmap>
}
  801eb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <_pipeisclosed>:
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	57                   	push   %edi
  801eb9:	56                   	push   %esi
  801eba:	53                   	push   %ebx
  801ebb:	83 ec 1c             	sub    $0x1c,%esp
  801ebe:	89 c7                	mov    %eax,%edi
  801ec0:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ec2:	a1 08 40 80 00       	mov    0x804008,%eax
  801ec7:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801eca:	83 ec 0c             	sub    $0xc,%esp
  801ecd:	57                   	push   %edi
  801ece:	e8 2d 05 00 00       	call   802400 <pageref>
  801ed3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ed6:	89 34 24             	mov    %esi,(%esp)
  801ed9:	e8 22 05 00 00       	call   802400 <pageref>
		nn = thisenv->env_runs;
  801ede:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ee4:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ee7:	83 c4 10             	add    $0x10,%esp
  801eea:	39 cb                	cmp    %ecx,%ebx
  801eec:	74 1b                	je     801f09 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801eee:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ef1:	75 cf                	jne    801ec2 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ef3:	8b 42 58             	mov    0x58(%edx),%eax
  801ef6:	6a 01                	push   $0x1
  801ef8:	50                   	push   %eax
  801ef9:	53                   	push   %ebx
  801efa:	68 d3 2c 80 00       	push   $0x802cd3
  801eff:	e8 cb e3 ff ff       	call   8002cf <cprintf>
  801f04:	83 c4 10             	add    $0x10,%esp
  801f07:	eb b9                	jmp    801ec2 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801f09:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f0c:	0f 94 c0             	sete   %al
  801f0f:	0f b6 c0             	movzbl %al,%eax
}
  801f12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f15:	5b                   	pop    %ebx
  801f16:	5e                   	pop    %esi
  801f17:	5f                   	pop    %edi
  801f18:	5d                   	pop    %ebp
  801f19:	c3                   	ret    

00801f1a <devpipe_write>:
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	57                   	push   %edi
  801f1e:	56                   	push   %esi
  801f1f:	53                   	push   %ebx
  801f20:	83 ec 28             	sub    $0x28,%esp
  801f23:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f26:	56                   	push   %esi
  801f27:	e8 8e f2 ff ff       	call   8011ba <fd2data>
  801f2c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f2e:	83 c4 10             	add    $0x10,%esp
  801f31:	bf 00 00 00 00       	mov    $0x0,%edi
  801f36:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f39:	74 4f                	je     801f8a <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f3b:	8b 43 04             	mov    0x4(%ebx),%eax
  801f3e:	8b 0b                	mov    (%ebx),%ecx
  801f40:	8d 51 20             	lea    0x20(%ecx),%edx
  801f43:	39 d0                	cmp    %edx,%eax
  801f45:	72 14                	jb     801f5b <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801f47:	89 da                	mov    %ebx,%edx
  801f49:	89 f0                	mov    %esi,%eax
  801f4b:	e8 65 ff ff ff       	call   801eb5 <_pipeisclosed>
  801f50:	85 c0                	test   %eax,%eax
  801f52:	75 3b                	jne    801f8f <devpipe_write+0x75>
			sys_yield();
  801f54:	e8 a8 ee ff ff       	call   800e01 <sys_yield>
  801f59:	eb e0                	jmp    801f3b <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f5e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f62:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f65:	89 c2                	mov    %eax,%edx
  801f67:	c1 fa 1f             	sar    $0x1f,%edx
  801f6a:	89 d1                	mov    %edx,%ecx
  801f6c:	c1 e9 1b             	shr    $0x1b,%ecx
  801f6f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801f72:	83 e2 1f             	and    $0x1f,%edx
  801f75:	29 ca                	sub    %ecx,%edx
  801f77:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f7b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f7f:	83 c0 01             	add    $0x1,%eax
  801f82:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f85:	83 c7 01             	add    $0x1,%edi
  801f88:	eb ac                	jmp    801f36 <devpipe_write+0x1c>
	return i;
  801f8a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f8d:	eb 05                	jmp    801f94 <devpipe_write+0x7a>
				return 0;
  801f8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f97:	5b                   	pop    %ebx
  801f98:	5e                   	pop    %esi
  801f99:	5f                   	pop    %edi
  801f9a:	5d                   	pop    %ebp
  801f9b:	c3                   	ret    

00801f9c <devpipe_read>:
{
  801f9c:	55                   	push   %ebp
  801f9d:	89 e5                	mov    %esp,%ebp
  801f9f:	57                   	push   %edi
  801fa0:	56                   	push   %esi
  801fa1:	53                   	push   %ebx
  801fa2:	83 ec 18             	sub    $0x18,%esp
  801fa5:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801fa8:	57                   	push   %edi
  801fa9:	e8 0c f2 ff ff       	call   8011ba <fd2data>
  801fae:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801fb0:	83 c4 10             	add    $0x10,%esp
  801fb3:	be 00 00 00 00       	mov    $0x0,%esi
  801fb8:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fbb:	75 14                	jne    801fd1 <devpipe_read+0x35>
	return i;
  801fbd:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc0:	eb 02                	jmp    801fc4 <devpipe_read+0x28>
				return i;
  801fc2:	89 f0                	mov    %esi,%eax
}
  801fc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fc7:	5b                   	pop    %ebx
  801fc8:	5e                   	pop    %esi
  801fc9:	5f                   	pop    %edi
  801fca:	5d                   	pop    %ebp
  801fcb:	c3                   	ret    
			sys_yield();
  801fcc:	e8 30 ee ff ff       	call   800e01 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801fd1:	8b 03                	mov    (%ebx),%eax
  801fd3:	3b 43 04             	cmp    0x4(%ebx),%eax
  801fd6:	75 18                	jne    801ff0 <devpipe_read+0x54>
			if (i > 0)
  801fd8:	85 f6                	test   %esi,%esi
  801fda:	75 e6                	jne    801fc2 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801fdc:	89 da                	mov    %ebx,%edx
  801fde:	89 f8                	mov    %edi,%eax
  801fe0:	e8 d0 fe ff ff       	call   801eb5 <_pipeisclosed>
  801fe5:	85 c0                	test   %eax,%eax
  801fe7:	74 e3                	je     801fcc <devpipe_read+0x30>
				return 0;
  801fe9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fee:	eb d4                	jmp    801fc4 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ff0:	99                   	cltd   
  801ff1:	c1 ea 1b             	shr    $0x1b,%edx
  801ff4:	01 d0                	add    %edx,%eax
  801ff6:	83 e0 1f             	and    $0x1f,%eax
  801ff9:	29 d0                	sub    %edx,%eax
  801ffb:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802000:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802003:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802006:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802009:	83 c6 01             	add    $0x1,%esi
  80200c:	eb aa                	jmp    801fb8 <devpipe_read+0x1c>

0080200e <pipe>:
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
  802011:	56                   	push   %esi
  802012:	53                   	push   %ebx
  802013:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802016:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802019:	50                   	push   %eax
  80201a:	e8 b2 f1 ff ff       	call   8011d1 <fd_alloc>
  80201f:	89 c3                	mov    %eax,%ebx
  802021:	83 c4 10             	add    $0x10,%esp
  802024:	85 c0                	test   %eax,%eax
  802026:	0f 88 23 01 00 00    	js     80214f <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80202c:	83 ec 04             	sub    $0x4,%esp
  80202f:	68 07 04 00 00       	push   $0x407
  802034:	ff 75 f4             	pushl  -0xc(%ebp)
  802037:	6a 00                	push   $0x0
  802039:	e8 e2 ed ff ff       	call   800e20 <sys_page_alloc>
  80203e:	89 c3                	mov    %eax,%ebx
  802040:	83 c4 10             	add    $0x10,%esp
  802043:	85 c0                	test   %eax,%eax
  802045:	0f 88 04 01 00 00    	js     80214f <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  80204b:	83 ec 0c             	sub    $0xc,%esp
  80204e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802051:	50                   	push   %eax
  802052:	e8 7a f1 ff ff       	call   8011d1 <fd_alloc>
  802057:	89 c3                	mov    %eax,%ebx
  802059:	83 c4 10             	add    $0x10,%esp
  80205c:	85 c0                	test   %eax,%eax
  80205e:	0f 88 db 00 00 00    	js     80213f <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802064:	83 ec 04             	sub    $0x4,%esp
  802067:	68 07 04 00 00       	push   $0x407
  80206c:	ff 75 f0             	pushl  -0x10(%ebp)
  80206f:	6a 00                	push   $0x0
  802071:	e8 aa ed ff ff       	call   800e20 <sys_page_alloc>
  802076:	89 c3                	mov    %eax,%ebx
  802078:	83 c4 10             	add    $0x10,%esp
  80207b:	85 c0                	test   %eax,%eax
  80207d:	0f 88 bc 00 00 00    	js     80213f <pipe+0x131>
	va = fd2data(fd0);
  802083:	83 ec 0c             	sub    $0xc,%esp
  802086:	ff 75 f4             	pushl  -0xc(%ebp)
  802089:	e8 2c f1 ff ff       	call   8011ba <fd2data>
  80208e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802090:	83 c4 0c             	add    $0xc,%esp
  802093:	68 07 04 00 00       	push   $0x407
  802098:	50                   	push   %eax
  802099:	6a 00                	push   $0x0
  80209b:	e8 80 ed ff ff       	call   800e20 <sys_page_alloc>
  8020a0:	89 c3                	mov    %eax,%ebx
  8020a2:	83 c4 10             	add    $0x10,%esp
  8020a5:	85 c0                	test   %eax,%eax
  8020a7:	0f 88 82 00 00 00    	js     80212f <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020ad:	83 ec 0c             	sub    $0xc,%esp
  8020b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8020b3:	e8 02 f1 ff ff       	call   8011ba <fd2data>
  8020b8:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8020bf:	50                   	push   %eax
  8020c0:	6a 00                	push   $0x0
  8020c2:	56                   	push   %esi
  8020c3:	6a 00                	push   $0x0
  8020c5:	e8 99 ed ff ff       	call   800e63 <sys_page_map>
  8020ca:	89 c3                	mov    %eax,%ebx
  8020cc:	83 c4 20             	add    $0x20,%esp
  8020cf:	85 c0                	test   %eax,%eax
  8020d1:	78 4e                	js     802121 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8020d3:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8020d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020db:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8020dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e0:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8020e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020ea:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8020ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ef:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8020f6:	83 ec 0c             	sub    $0xc,%esp
  8020f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8020fc:	e8 a9 f0 ff ff       	call   8011aa <fd2num>
  802101:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802104:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802106:	83 c4 04             	add    $0x4,%esp
  802109:	ff 75 f0             	pushl  -0x10(%ebp)
  80210c:	e8 99 f0 ff ff       	call   8011aa <fd2num>
  802111:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802114:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802117:	83 c4 10             	add    $0x10,%esp
  80211a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80211f:	eb 2e                	jmp    80214f <pipe+0x141>
	sys_page_unmap(0, va);
  802121:	83 ec 08             	sub    $0x8,%esp
  802124:	56                   	push   %esi
  802125:	6a 00                	push   $0x0
  802127:	e8 79 ed ff ff       	call   800ea5 <sys_page_unmap>
  80212c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80212f:	83 ec 08             	sub    $0x8,%esp
  802132:	ff 75 f0             	pushl  -0x10(%ebp)
  802135:	6a 00                	push   $0x0
  802137:	e8 69 ed ff ff       	call   800ea5 <sys_page_unmap>
  80213c:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80213f:	83 ec 08             	sub    $0x8,%esp
  802142:	ff 75 f4             	pushl  -0xc(%ebp)
  802145:	6a 00                	push   $0x0
  802147:	e8 59 ed ff ff       	call   800ea5 <sys_page_unmap>
  80214c:	83 c4 10             	add    $0x10,%esp
}
  80214f:	89 d8                	mov    %ebx,%eax
  802151:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802154:	5b                   	pop    %ebx
  802155:	5e                   	pop    %esi
  802156:	5d                   	pop    %ebp
  802157:	c3                   	ret    

00802158 <pipeisclosed>:
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
  80215b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80215e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802161:	50                   	push   %eax
  802162:	ff 75 08             	pushl  0x8(%ebp)
  802165:	e8 b9 f0 ff ff       	call   801223 <fd_lookup>
  80216a:	83 c4 10             	add    $0x10,%esp
  80216d:	85 c0                	test   %eax,%eax
  80216f:	78 18                	js     802189 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802171:	83 ec 0c             	sub    $0xc,%esp
  802174:	ff 75 f4             	pushl  -0xc(%ebp)
  802177:	e8 3e f0 ff ff       	call   8011ba <fd2data>
	return _pipeisclosed(fd, p);
  80217c:	89 c2                	mov    %eax,%edx
  80217e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802181:	e8 2f fd ff ff       	call   801eb5 <_pipeisclosed>
  802186:	83 c4 10             	add    $0x10,%esp
}
  802189:	c9                   	leave  
  80218a:	c3                   	ret    

0080218b <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80218b:	b8 00 00 00 00       	mov    $0x0,%eax
  802190:	c3                   	ret    

00802191 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802191:	55                   	push   %ebp
  802192:	89 e5                	mov    %esp,%ebp
  802194:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802197:	68 eb 2c 80 00       	push   $0x802ceb
  80219c:	ff 75 0c             	pushl  0xc(%ebp)
  80219f:	e8 8a e8 ff ff       	call   800a2e <strcpy>
	return 0;
}
  8021a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <devcons_write>:
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
  8021ae:	57                   	push   %edi
  8021af:	56                   	push   %esi
  8021b0:	53                   	push   %ebx
  8021b1:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8021b7:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8021bc:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8021c2:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021c5:	73 31                	jae    8021f8 <devcons_write+0x4d>
		m = n - tot;
  8021c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8021ca:	29 f3                	sub    %esi,%ebx
  8021cc:	83 fb 7f             	cmp    $0x7f,%ebx
  8021cf:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8021d4:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8021d7:	83 ec 04             	sub    $0x4,%esp
  8021da:	53                   	push   %ebx
  8021db:	89 f0                	mov    %esi,%eax
  8021dd:	03 45 0c             	add    0xc(%ebp),%eax
  8021e0:	50                   	push   %eax
  8021e1:	57                   	push   %edi
  8021e2:	e8 d5 e9 ff ff       	call   800bbc <memmove>
		sys_cputs(buf, m);
  8021e7:	83 c4 08             	add    $0x8,%esp
  8021ea:	53                   	push   %ebx
  8021eb:	57                   	push   %edi
  8021ec:	e8 73 eb ff ff       	call   800d64 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8021f1:	01 de                	add    %ebx,%esi
  8021f3:	83 c4 10             	add    $0x10,%esp
  8021f6:	eb ca                	jmp    8021c2 <devcons_write+0x17>
}
  8021f8:	89 f0                	mov    %esi,%eax
  8021fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021fd:	5b                   	pop    %ebx
  8021fe:	5e                   	pop    %esi
  8021ff:	5f                   	pop    %edi
  802200:	5d                   	pop    %ebp
  802201:	c3                   	ret    

00802202 <devcons_read>:
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
  802205:	83 ec 08             	sub    $0x8,%esp
  802208:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80220d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802211:	74 21                	je     802234 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802213:	e8 6a eb ff ff       	call   800d82 <sys_cgetc>
  802218:	85 c0                	test   %eax,%eax
  80221a:	75 07                	jne    802223 <devcons_read+0x21>
		sys_yield();
  80221c:	e8 e0 eb ff ff       	call   800e01 <sys_yield>
  802221:	eb f0                	jmp    802213 <devcons_read+0x11>
	if (c < 0)
  802223:	78 0f                	js     802234 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802225:	83 f8 04             	cmp    $0x4,%eax
  802228:	74 0c                	je     802236 <devcons_read+0x34>
	*(char*)vbuf = c;
  80222a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80222d:	88 02                	mov    %al,(%edx)
	return 1;
  80222f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802234:	c9                   	leave  
  802235:	c3                   	ret    
		return 0;
  802236:	b8 00 00 00 00       	mov    $0x0,%eax
  80223b:	eb f7                	jmp    802234 <devcons_read+0x32>

0080223d <cputchar>:
{
  80223d:	55                   	push   %ebp
  80223e:	89 e5                	mov    %esp,%ebp
  802240:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802243:	8b 45 08             	mov    0x8(%ebp),%eax
  802246:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802249:	6a 01                	push   $0x1
  80224b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80224e:	50                   	push   %eax
  80224f:	e8 10 eb ff ff       	call   800d64 <sys_cputs>
}
  802254:	83 c4 10             	add    $0x10,%esp
  802257:	c9                   	leave  
  802258:	c3                   	ret    

00802259 <getchar>:
{
  802259:	55                   	push   %ebp
  80225a:	89 e5                	mov    %esp,%ebp
  80225c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80225f:	6a 01                	push   $0x1
  802261:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802264:	50                   	push   %eax
  802265:	6a 00                	push   $0x0
  802267:	e8 27 f2 ff ff       	call   801493 <read>
	if (r < 0)
  80226c:	83 c4 10             	add    $0x10,%esp
  80226f:	85 c0                	test   %eax,%eax
  802271:	78 06                	js     802279 <getchar+0x20>
	if (r < 1)
  802273:	74 06                	je     80227b <getchar+0x22>
	return c;
  802275:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802279:	c9                   	leave  
  80227a:	c3                   	ret    
		return -E_EOF;
  80227b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802280:	eb f7                	jmp    802279 <getchar+0x20>

00802282 <iscons>:
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
  802285:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802288:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80228b:	50                   	push   %eax
  80228c:	ff 75 08             	pushl  0x8(%ebp)
  80228f:	e8 8f ef ff ff       	call   801223 <fd_lookup>
  802294:	83 c4 10             	add    $0x10,%esp
  802297:	85 c0                	test   %eax,%eax
  802299:	78 11                	js     8022ac <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022a4:	39 10                	cmp    %edx,(%eax)
  8022a6:	0f 94 c0             	sete   %al
  8022a9:	0f b6 c0             	movzbl %al,%eax
}
  8022ac:	c9                   	leave  
  8022ad:	c3                   	ret    

008022ae <opencons>:
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
  8022b1:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8022b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022b7:	50                   	push   %eax
  8022b8:	e8 14 ef ff ff       	call   8011d1 <fd_alloc>
  8022bd:	83 c4 10             	add    $0x10,%esp
  8022c0:	85 c0                	test   %eax,%eax
  8022c2:	78 3a                	js     8022fe <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022c4:	83 ec 04             	sub    $0x4,%esp
  8022c7:	68 07 04 00 00       	push   $0x407
  8022cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8022cf:	6a 00                	push   $0x0
  8022d1:	e8 4a eb ff ff       	call   800e20 <sys_page_alloc>
  8022d6:	83 c4 10             	add    $0x10,%esp
  8022d9:	85 c0                	test   %eax,%eax
  8022db:	78 21                	js     8022fe <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8022dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e0:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022e6:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022eb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022f2:	83 ec 0c             	sub    $0xc,%esp
  8022f5:	50                   	push   %eax
  8022f6:	e8 af ee ff ff       	call   8011aa <fd2num>
  8022fb:	83 c4 10             	add    $0x10,%esp
}
  8022fe:	c9                   	leave  
  8022ff:	c3                   	ret    

00802300 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	56                   	push   %esi
  802304:	53                   	push   %ebx
  802305:	8b 75 08             	mov    0x8(%ebp),%esi
  802308:	8b 45 0c             	mov    0xc(%ebp),%eax
  80230b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  80230e:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802310:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802315:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802318:	83 ec 0c             	sub    $0xc,%esp
  80231b:	50                   	push   %eax
  80231c:	e8 af ec ff ff       	call   800fd0 <sys_ipc_recv>
	if(ret < 0){
  802321:	83 c4 10             	add    $0x10,%esp
  802324:	85 c0                	test   %eax,%eax
  802326:	78 2b                	js     802353 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802328:	85 f6                	test   %esi,%esi
  80232a:	74 0a                	je     802336 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80232c:	a1 08 40 80 00       	mov    0x804008,%eax
  802331:	8b 40 78             	mov    0x78(%eax),%eax
  802334:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802336:	85 db                	test   %ebx,%ebx
  802338:	74 0a                	je     802344 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80233a:	a1 08 40 80 00       	mov    0x804008,%eax
  80233f:	8b 40 7c             	mov    0x7c(%eax),%eax
  802342:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802344:	a1 08 40 80 00       	mov    0x804008,%eax
  802349:	8b 40 74             	mov    0x74(%eax),%eax
}
  80234c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80234f:	5b                   	pop    %ebx
  802350:	5e                   	pop    %esi
  802351:	5d                   	pop    %ebp
  802352:	c3                   	ret    
		if(from_env_store)
  802353:	85 f6                	test   %esi,%esi
  802355:	74 06                	je     80235d <ipc_recv+0x5d>
			*from_env_store = 0;
  802357:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80235d:	85 db                	test   %ebx,%ebx
  80235f:	74 eb                	je     80234c <ipc_recv+0x4c>
			*perm_store = 0;
  802361:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802367:	eb e3                	jmp    80234c <ipc_recv+0x4c>

00802369 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802369:	55                   	push   %ebp
  80236a:	89 e5                	mov    %esp,%ebp
  80236c:	57                   	push   %edi
  80236d:	56                   	push   %esi
  80236e:	53                   	push   %ebx
  80236f:	83 ec 0c             	sub    $0xc,%esp
  802372:	8b 7d 08             	mov    0x8(%ebp),%edi
  802375:	8b 75 0c             	mov    0xc(%ebp),%esi
  802378:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80237b:	85 db                	test   %ebx,%ebx
  80237d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802382:	0f 44 d8             	cmove  %eax,%ebx
  802385:	eb 05                	jmp    80238c <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802387:	e8 75 ea ff ff       	call   800e01 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80238c:	ff 75 14             	pushl  0x14(%ebp)
  80238f:	53                   	push   %ebx
  802390:	56                   	push   %esi
  802391:	57                   	push   %edi
  802392:	e8 16 ec ff ff       	call   800fad <sys_ipc_try_send>
  802397:	83 c4 10             	add    $0x10,%esp
  80239a:	85 c0                	test   %eax,%eax
  80239c:	74 1b                	je     8023b9 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80239e:	79 e7                	jns    802387 <ipc_send+0x1e>
  8023a0:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8023a3:	74 e2                	je     802387 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8023a5:	83 ec 04             	sub    $0x4,%esp
  8023a8:	68 f7 2c 80 00       	push   $0x802cf7
  8023ad:	6a 46                	push   $0x46
  8023af:	68 0c 2d 80 00       	push   $0x802d0c
  8023b4:	e8 20 de ff ff       	call   8001d9 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8023b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023bc:	5b                   	pop    %ebx
  8023bd:	5e                   	pop    %esi
  8023be:	5f                   	pop    %edi
  8023bf:	5d                   	pop    %ebp
  8023c0:	c3                   	ret    

008023c1 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023c1:	55                   	push   %ebp
  8023c2:	89 e5                	mov    %esp,%ebp
  8023c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8023c7:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8023cc:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8023d2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8023d8:	8b 52 50             	mov    0x50(%edx),%edx
  8023db:	39 ca                	cmp    %ecx,%edx
  8023dd:	74 11                	je     8023f0 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8023df:	83 c0 01             	add    $0x1,%eax
  8023e2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023e7:	75 e3                	jne    8023cc <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8023e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ee:	eb 0e                	jmp    8023fe <ipc_find_env+0x3d>
			return envs[i].env_id;
  8023f0:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8023f6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8023fb:	8b 40 48             	mov    0x48(%eax),%eax
}
  8023fe:	5d                   	pop    %ebp
  8023ff:	c3                   	ret    

00802400 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802400:	55                   	push   %ebp
  802401:	89 e5                	mov    %esp,%ebp
  802403:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802406:	89 d0                	mov    %edx,%eax
  802408:	c1 e8 16             	shr    $0x16,%eax
  80240b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802412:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802417:	f6 c1 01             	test   $0x1,%cl
  80241a:	74 1d                	je     802439 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80241c:	c1 ea 0c             	shr    $0xc,%edx
  80241f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802426:	f6 c2 01             	test   $0x1,%dl
  802429:	74 0e                	je     802439 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80242b:	c1 ea 0c             	shr    $0xc,%edx
  80242e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802435:	ef 
  802436:	0f b7 c0             	movzwl %ax,%eax
}
  802439:	5d                   	pop    %ebp
  80243a:	c3                   	ret    
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
