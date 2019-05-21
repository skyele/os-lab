
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
  800040:	68 e0 12 80 00       	push   $0x8012e0
  800045:	e8 1d 02 00 00       	call   800267 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004a:	83 c4 0c             	add    $0xc,%esp
  80004d:	6a 07                	push   $0x7
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	50                   	push   %eax
  800057:	6a 00                	push   $0x0
  800059:	e8 5a 0d 00 00       	call   800db8 <sys_page_alloc>
  80005e:	83 c4 10             	add    $0x10,%esp
  800061:	85 c0                	test   %eax,%eax
  800063:	78 16                	js     80007b <handler+0x48>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800065:	53                   	push   %ebx
  800066:	68 28 13 80 00       	push   $0x801328
  80006b:	6a 64                	push   $0x64
  80006d:	53                   	push   %ebx
  80006e:	e8 00 09 00 00       	call   800973 <snprintf>
}
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800079:	c9                   	leave  
  80007a:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007b:	83 ec 0c             	sub    $0xc,%esp
  80007e:	50                   	push   %eax
  80007f:	53                   	push   %ebx
  800080:	68 fc 12 80 00       	push   $0x8012fc
  800085:	6a 0e                	push   $0xe
  800087:	68 ea 12 80 00       	push   $0x8012ea
  80008c:	e8 e0 00 00 00       	call   800171 <_panic>

00800091 <umain>:

void
umain(int argc, char **argv)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800097:	68 33 00 80 00       	push   $0x800033
  80009c:	e8 49 0f 00 00       	call   800fea <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	68 ef be ad de       	push   $0xdeadbeef
  8000a9:	68 5a 13 80 00       	push   $0x80135a
  8000ae:	e8 b4 01 00 00       	call   800267 <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000b3:	83 c4 08             	add    $0x8,%esp
  8000b6:	68 fe bf fe ca       	push   $0xcafebffe
  8000bb:	68 5a 13 80 00       	push   $0x80135a
  8000c0:	e8 a2 01 00 00       	call   800267 <cprintf>
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
  8000d3:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  8000da:	00 00 00 
	envid_t find = sys_getenvid();
  8000dd:	e8 98 0c 00 00       	call   800d7a <sys_getenvid>
  8000e2:	8b 1d 04 20 80 00    	mov    0x802004,%ebx
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
  80012b:	89 1d 04 20 80 00    	mov    %ebx,0x802004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800131:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800135:	7e 0a                	jle    800141 <libmain+0x77>
		binaryname = argv[0];
  800137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80013a:	8b 00                	mov    (%eax),%eax
  80013c:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800141:	83 ec 08             	sub    $0x8,%esp
  800144:	ff 75 0c             	pushl  0xc(%ebp)
  800147:	ff 75 08             	pushl  0x8(%ebp)
  80014a:	e8 42 ff ff ff       	call   800091 <umain>

	// exit gracefully
	exit();
  80014f:	e8 0b 00 00 00       	call   80015f <exit>
}
  800154:	83 c4 10             	add    $0x10,%esp
  800157:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80015a:	5b                   	pop    %ebx
  80015b:	5e                   	pop    %esi
  80015c:	5f                   	pop    %edi
  80015d:	5d                   	pop    %ebp
  80015e:	c3                   	ret    

0080015f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80015f:	55                   	push   %ebp
  800160:	89 e5                	mov    %esp,%ebp
  800162:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  800165:	6a 00                	push   $0x0
  800167:	e8 cd 0b 00 00       	call   800d39 <sys_env_destroy>
}
  80016c:	83 c4 10             	add    $0x10,%esp
  80016f:	c9                   	leave  
  800170:	c3                   	ret    

00800171 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800171:	55                   	push   %ebp
  800172:	89 e5                	mov    %esp,%ebp
  800174:	56                   	push   %esi
  800175:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800176:	a1 04 20 80 00       	mov    0x802004,%eax
  80017b:	8b 40 48             	mov    0x48(%eax),%eax
  80017e:	83 ec 04             	sub    $0x4,%esp
  800181:	68 84 13 80 00       	push   $0x801384
  800186:	50                   	push   %eax
  800187:	68 53 13 80 00       	push   $0x801353
  80018c:	e8 d6 00 00 00       	call   800267 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  800191:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800194:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80019a:	e8 db 0b 00 00       	call   800d7a <sys_getenvid>
  80019f:	83 c4 04             	add    $0x4,%esp
  8001a2:	ff 75 0c             	pushl  0xc(%ebp)
  8001a5:	ff 75 08             	pushl  0x8(%ebp)
  8001a8:	56                   	push   %esi
  8001a9:	50                   	push   %eax
  8001aa:	68 60 13 80 00       	push   $0x801360
  8001af:	e8 b3 00 00 00       	call   800267 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001b4:	83 c4 18             	add    $0x18,%esp
  8001b7:	53                   	push   %ebx
  8001b8:	ff 75 10             	pushl  0x10(%ebp)
  8001bb:	e8 56 00 00 00       	call   800216 <vcprintf>
	cprintf("\n");
  8001c0:	c7 04 24 5c 13 80 00 	movl   $0x80135c,(%esp)
  8001c7:	e8 9b 00 00 00       	call   800267 <cprintf>
  8001cc:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001cf:	cc                   	int3   
  8001d0:	eb fd                	jmp    8001cf <_panic+0x5e>

008001d2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	53                   	push   %ebx
  8001d6:	83 ec 04             	sub    $0x4,%esp
  8001d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001dc:	8b 13                	mov    (%ebx),%edx
  8001de:	8d 42 01             	lea    0x1(%edx),%eax
  8001e1:	89 03                	mov    %eax,(%ebx)
  8001e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001ea:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ef:	74 09                	je     8001fa <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001f1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001f8:	c9                   	leave  
  8001f9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001fa:	83 ec 08             	sub    $0x8,%esp
  8001fd:	68 ff 00 00 00       	push   $0xff
  800202:	8d 43 08             	lea    0x8(%ebx),%eax
  800205:	50                   	push   %eax
  800206:	e8 f1 0a 00 00       	call   800cfc <sys_cputs>
		b->idx = 0;
  80020b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800211:	83 c4 10             	add    $0x10,%esp
  800214:	eb db                	jmp    8001f1 <putch+0x1f>

00800216 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800216:	55                   	push   %ebp
  800217:	89 e5                	mov    %esp,%ebp
  800219:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80021f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800226:	00 00 00 
	b.cnt = 0;
  800229:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800230:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800233:	ff 75 0c             	pushl  0xc(%ebp)
  800236:	ff 75 08             	pushl  0x8(%ebp)
  800239:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80023f:	50                   	push   %eax
  800240:	68 d2 01 80 00       	push   $0x8001d2
  800245:	e8 4a 01 00 00       	call   800394 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80024a:	83 c4 08             	add    $0x8,%esp
  80024d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800253:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800259:	50                   	push   %eax
  80025a:	e8 9d 0a 00 00       	call   800cfc <sys_cputs>

	return b.cnt;
}
  80025f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800265:	c9                   	leave  
  800266:	c3                   	ret    

00800267 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80026d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800270:	50                   	push   %eax
  800271:	ff 75 08             	pushl  0x8(%ebp)
  800274:	e8 9d ff ff ff       	call   800216 <vcprintf>
	va_end(ap);

	return cnt;
}
  800279:	c9                   	leave  
  80027a:	c3                   	ret    

0080027b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80027b:	55                   	push   %ebp
  80027c:	89 e5                	mov    %esp,%ebp
  80027e:	57                   	push   %edi
  80027f:	56                   	push   %esi
  800280:	53                   	push   %ebx
  800281:	83 ec 1c             	sub    $0x1c,%esp
  800284:	89 c6                	mov    %eax,%esi
  800286:	89 d7                	mov    %edx,%edi
  800288:	8b 45 08             	mov    0x8(%ebp),%eax
  80028b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800291:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800294:	8b 45 10             	mov    0x10(%ebp),%eax
  800297:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80029a:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80029e:	74 2c                	je     8002cc <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8002a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002a3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002ad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002b0:	39 c2                	cmp    %eax,%edx
  8002b2:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002b5:	73 43                	jae    8002fa <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002b7:	83 eb 01             	sub    $0x1,%ebx
  8002ba:	85 db                	test   %ebx,%ebx
  8002bc:	7e 6c                	jle    80032a <printnum+0xaf>
				putch(padc, putdat);
  8002be:	83 ec 08             	sub    $0x8,%esp
  8002c1:	57                   	push   %edi
  8002c2:	ff 75 18             	pushl  0x18(%ebp)
  8002c5:	ff d6                	call   *%esi
  8002c7:	83 c4 10             	add    $0x10,%esp
  8002ca:	eb eb                	jmp    8002b7 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002cc:	83 ec 0c             	sub    $0xc,%esp
  8002cf:	6a 20                	push   $0x20
  8002d1:	6a 00                	push   $0x0
  8002d3:	50                   	push   %eax
  8002d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d7:	ff 75 e0             	pushl  -0x20(%ebp)
  8002da:	89 fa                	mov    %edi,%edx
  8002dc:	89 f0                	mov    %esi,%eax
  8002de:	e8 98 ff ff ff       	call   80027b <printnum>
		while (--width > 0)
  8002e3:	83 c4 20             	add    $0x20,%esp
  8002e6:	83 eb 01             	sub    $0x1,%ebx
  8002e9:	85 db                	test   %ebx,%ebx
  8002eb:	7e 65                	jle    800352 <printnum+0xd7>
			putch(padc, putdat);
  8002ed:	83 ec 08             	sub    $0x8,%esp
  8002f0:	57                   	push   %edi
  8002f1:	6a 20                	push   $0x20
  8002f3:	ff d6                	call   *%esi
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	eb ec                	jmp    8002e6 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002fa:	83 ec 0c             	sub    $0xc,%esp
  8002fd:	ff 75 18             	pushl  0x18(%ebp)
  800300:	83 eb 01             	sub    $0x1,%ebx
  800303:	53                   	push   %ebx
  800304:	50                   	push   %eax
  800305:	83 ec 08             	sub    $0x8,%esp
  800308:	ff 75 dc             	pushl  -0x24(%ebp)
  80030b:	ff 75 d8             	pushl  -0x28(%ebp)
  80030e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800311:	ff 75 e0             	pushl  -0x20(%ebp)
  800314:	e8 67 0d 00 00       	call   801080 <__udivdi3>
  800319:	83 c4 18             	add    $0x18,%esp
  80031c:	52                   	push   %edx
  80031d:	50                   	push   %eax
  80031e:	89 fa                	mov    %edi,%edx
  800320:	89 f0                	mov    %esi,%eax
  800322:	e8 54 ff ff ff       	call   80027b <printnum>
  800327:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80032a:	83 ec 08             	sub    $0x8,%esp
  80032d:	57                   	push   %edi
  80032e:	83 ec 04             	sub    $0x4,%esp
  800331:	ff 75 dc             	pushl  -0x24(%ebp)
  800334:	ff 75 d8             	pushl  -0x28(%ebp)
  800337:	ff 75 e4             	pushl  -0x1c(%ebp)
  80033a:	ff 75 e0             	pushl  -0x20(%ebp)
  80033d:	e8 4e 0e 00 00       	call   801190 <__umoddi3>
  800342:	83 c4 14             	add    $0x14,%esp
  800345:	0f be 80 8b 13 80 00 	movsbl 0x80138b(%eax),%eax
  80034c:	50                   	push   %eax
  80034d:	ff d6                	call   *%esi
  80034f:	83 c4 10             	add    $0x10,%esp
	}
}
  800352:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800355:	5b                   	pop    %ebx
  800356:	5e                   	pop    %esi
  800357:	5f                   	pop    %edi
  800358:	5d                   	pop    %ebp
  800359:	c3                   	ret    

0080035a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80035a:	55                   	push   %ebp
  80035b:	89 e5                	mov    %esp,%ebp
  80035d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800360:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800364:	8b 10                	mov    (%eax),%edx
  800366:	3b 50 04             	cmp    0x4(%eax),%edx
  800369:	73 0a                	jae    800375 <sprintputch+0x1b>
		*b->buf++ = ch;
  80036b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80036e:	89 08                	mov    %ecx,(%eax)
  800370:	8b 45 08             	mov    0x8(%ebp),%eax
  800373:	88 02                	mov    %al,(%edx)
}
  800375:	5d                   	pop    %ebp
  800376:	c3                   	ret    

00800377 <printfmt>:
{
  800377:	55                   	push   %ebp
  800378:	89 e5                	mov    %esp,%ebp
  80037a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80037d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800380:	50                   	push   %eax
  800381:	ff 75 10             	pushl  0x10(%ebp)
  800384:	ff 75 0c             	pushl  0xc(%ebp)
  800387:	ff 75 08             	pushl  0x8(%ebp)
  80038a:	e8 05 00 00 00       	call   800394 <vprintfmt>
}
  80038f:	83 c4 10             	add    $0x10,%esp
  800392:	c9                   	leave  
  800393:	c3                   	ret    

00800394 <vprintfmt>:
{
  800394:	55                   	push   %ebp
  800395:	89 e5                	mov    %esp,%ebp
  800397:	57                   	push   %edi
  800398:	56                   	push   %esi
  800399:	53                   	push   %ebx
  80039a:	83 ec 3c             	sub    $0x3c,%esp
  80039d:	8b 75 08             	mov    0x8(%ebp),%esi
  8003a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003a3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003a6:	e9 32 04 00 00       	jmp    8007dd <vprintfmt+0x449>
		padc = ' ';
  8003ab:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003af:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003b6:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003bd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003c4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003cb:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003d2:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003d7:	8d 47 01             	lea    0x1(%edi),%eax
  8003da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003dd:	0f b6 17             	movzbl (%edi),%edx
  8003e0:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003e3:	3c 55                	cmp    $0x55,%al
  8003e5:	0f 87 12 05 00 00    	ja     8008fd <vprintfmt+0x569>
  8003eb:	0f b6 c0             	movzbl %al,%eax
  8003ee:	ff 24 85 60 15 80 00 	jmp    *0x801560(,%eax,4)
  8003f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003f8:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003fc:	eb d9                	jmp    8003d7 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800401:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800405:	eb d0                	jmp    8003d7 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800407:	0f b6 d2             	movzbl %dl,%edx
  80040a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80040d:	b8 00 00 00 00       	mov    $0x0,%eax
  800412:	89 75 08             	mov    %esi,0x8(%ebp)
  800415:	eb 03                	jmp    80041a <vprintfmt+0x86>
  800417:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80041a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80041d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800421:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800424:	8d 72 d0             	lea    -0x30(%edx),%esi
  800427:	83 fe 09             	cmp    $0x9,%esi
  80042a:	76 eb                	jbe    800417 <vprintfmt+0x83>
  80042c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80042f:	8b 75 08             	mov    0x8(%ebp),%esi
  800432:	eb 14                	jmp    800448 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800434:	8b 45 14             	mov    0x14(%ebp),%eax
  800437:	8b 00                	mov    (%eax),%eax
  800439:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80043c:	8b 45 14             	mov    0x14(%ebp),%eax
  80043f:	8d 40 04             	lea    0x4(%eax),%eax
  800442:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800445:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800448:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80044c:	79 89                	jns    8003d7 <vprintfmt+0x43>
				width = precision, precision = -1;
  80044e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800451:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800454:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80045b:	e9 77 ff ff ff       	jmp    8003d7 <vprintfmt+0x43>
  800460:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800463:	85 c0                	test   %eax,%eax
  800465:	0f 48 c1             	cmovs  %ecx,%eax
  800468:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80046b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80046e:	e9 64 ff ff ff       	jmp    8003d7 <vprintfmt+0x43>
  800473:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800476:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80047d:	e9 55 ff ff ff       	jmp    8003d7 <vprintfmt+0x43>
			lflag++;
  800482:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800486:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800489:	e9 49 ff ff ff       	jmp    8003d7 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80048e:	8b 45 14             	mov    0x14(%ebp),%eax
  800491:	8d 78 04             	lea    0x4(%eax),%edi
  800494:	83 ec 08             	sub    $0x8,%esp
  800497:	53                   	push   %ebx
  800498:	ff 30                	pushl  (%eax)
  80049a:	ff d6                	call   *%esi
			break;
  80049c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80049f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004a2:	e9 33 03 00 00       	jmp    8007da <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004aa:	8d 78 04             	lea    0x4(%eax),%edi
  8004ad:	8b 00                	mov    (%eax),%eax
  8004af:	99                   	cltd   
  8004b0:	31 d0                	xor    %edx,%eax
  8004b2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004b4:	83 f8 0f             	cmp    $0xf,%eax
  8004b7:	7f 23                	jg     8004dc <vprintfmt+0x148>
  8004b9:	8b 14 85 c0 16 80 00 	mov    0x8016c0(,%eax,4),%edx
  8004c0:	85 d2                	test   %edx,%edx
  8004c2:	74 18                	je     8004dc <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004c4:	52                   	push   %edx
  8004c5:	68 ac 13 80 00       	push   $0x8013ac
  8004ca:	53                   	push   %ebx
  8004cb:	56                   	push   %esi
  8004cc:	e8 a6 fe ff ff       	call   800377 <printfmt>
  8004d1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004d4:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004d7:	e9 fe 02 00 00       	jmp    8007da <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004dc:	50                   	push   %eax
  8004dd:	68 a3 13 80 00       	push   $0x8013a3
  8004e2:	53                   	push   %ebx
  8004e3:	56                   	push   %esi
  8004e4:	e8 8e fe ff ff       	call   800377 <printfmt>
  8004e9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004ec:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004ef:	e9 e6 02 00 00       	jmp    8007da <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f7:	83 c0 04             	add    $0x4,%eax
  8004fa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800500:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800502:	85 c9                	test   %ecx,%ecx
  800504:	b8 9c 13 80 00       	mov    $0x80139c,%eax
  800509:	0f 45 c1             	cmovne %ecx,%eax
  80050c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80050f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800513:	7e 06                	jle    80051b <vprintfmt+0x187>
  800515:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800519:	75 0d                	jne    800528 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80051b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80051e:	89 c7                	mov    %eax,%edi
  800520:	03 45 e0             	add    -0x20(%ebp),%eax
  800523:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800526:	eb 53                	jmp    80057b <vprintfmt+0x1e7>
  800528:	83 ec 08             	sub    $0x8,%esp
  80052b:	ff 75 d8             	pushl  -0x28(%ebp)
  80052e:	50                   	push   %eax
  80052f:	e8 71 04 00 00       	call   8009a5 <strnlen>
  800534:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800537:	29 c1                	sub    %eax,%ecx
  800539:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80053c:	83 c4 10             	add    $0x10,%esp
  80053f:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800541:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800545:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800548:	eb 0f                	jmp    800559 <vprintfmt+0x1c5>
					putch(padc, putdat);
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	53                   	push   %ebx
  80054e:	ff 75 e0             	pushl  -0x20(%ebp)
  800551:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800553:	83 ef 01             	sub    $0x1,%edi
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	85 ff                	test   %edi,%edi
  80055b:	7f ed                	jg     80054a <vprintfmt+0x1b6>
  80055d:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800560:	85 c9                	test   %ecx,%ecx
  800562:	b8 00 00 00 00       	mov    $0x0,%eax
  800567:	0f 49 c1             	cmovns %ecx,%eax
  80056a:	29 c1                	sub    %eax,%ecx
  80056c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80056f:	eb aa                	jmp    80051b <vprintfmt+0x187>
					putch(ch, putdat);
  800571:	83 ec 08             	sub    $0x8,%esp
  800574:	53                   	push   %ebx
  800575:	52                   	push   %edx
  800576:	ff d6                	call   *%esi
  800578:	83 c4 10             	add    $0x10,%esp
  80057b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80057e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800580:	83 c7 01             	add    $0x1,%edi
  800583:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800587:	0f be d0             	movsbl %al,%edx
  80058a:	85 d2                	test   %edx,%edx
  80058c:	74 4b                	je     8005d9 <vprintfmt+0x245>
  80058e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800592:	78 06                	js     80059a <vprintfmt+0x206>
  800594:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800598:	78 1e                	js     8005b8 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80059a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80059e:	74 d1                	je     800571 <vprintfmt+0x1dd>
  8005a0:	0f be c0             	movsbl %al,%eax
  8005a3:	83 e8 20             	sub    $0x20,%eax
  8005a6:	83 f8 5e             	cmp    $0x5e,%eax
  8005a9:	76 c6                	jbe    800571 <vprintfmt+0x1dd>
					putch('?', putdat);
  8005ab:	83 ec 08             	sub    $0x8,%esp
  8005ae:	53                   	push   %ebx
  8005af:	6a 3f                	push   $0x3f
  8005b1:	ff d6                	call   *%esi
  8005b3:	83 c4 10             	add    $0x10,%esp
  8005b6:	eb c3                	jmp    80057b <vprintfmt+0x1e7>
  8005b8:	89 cf                	mov    %ecx,%edi
  8005ba:	eb 0e                	jmp    8005ca <vprintfmt+0x236>
				putch(' ', putdat);
  8005bc:	83 ec 08             	sub    $0x8,%esp
  8005bf:	53                   	push   %ebx
  8005c0:	6a 20                	push   $0x20
  8005c2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005c4:	83 ef 01             	sub    $0x1,%edi
  8005c7:	83 c4 10             	add    $0x10,%esp
  8005ca:	85 ff                	test   %edi,%edi
  8005cc:	7f ee                	jg     8005bc <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005ce:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005d1:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d4:	e9 01 02 00 00       	jmp    8007da <vprintfmt+0x446>
  8005d9:	89 cf                	mov    %ecx,%edi
  8005db:	eb ed                	jmp    8005ca <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005e0:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005e7:	e9 eb fd ff ff       	jmp    8003d7 <vprintfmt+0x43>
	if (lflag >= 2)
  8005ec:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005f0:	7f 21                	jg     800613 <vprintfmt+0x27f>
	else if (lflag)
  8005f2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005f6:	74 68                	je     800660 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	8b 00                	mov    (%eax),%eax
  8005fd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800600:	89 c1                	mov    %eax,%ecx
  800602:	c1 f9 1f             	sar    $0x1f,%ecx
  800605:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800608:	8b 45 14             	mov    0x14(%ebp),%eax
  80060b:	8d 40 04             	lea    0x4(%eax),%eax
  80060e:	89 45 14             	mov    %eax,0x14(%ebp)
  800611:	eb 17                	jmp    80062a <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	8b 50 04             	mov    0x4(%eax),%edx
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80061e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	8d 40 08             	lea    0x8(%eax),%eax
  800627:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80062a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80062d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800630:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800633:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800636:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80063a:	78 3f                	js     80067b <vprintfmt+0x2e7>
			base = 10;
  80063c:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800641:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800645:	0f 84 71 01 00 00    	je     8007bc <vprintfmt+0x428>
				putch('+', putdat);
  80064b:	83 ec 08             	sub    $0x8,%esp
  80064e:	53                   	push   %ebx
  80064f:	6a 2b                	push   $0x2b
  800651:	ff d6                	call   *%esi
  800653:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800656:	b8 0a 00 00 00       	mov    $0xa,%eax
  80065b:	e9 5c 01 00 00       	jmp    8007bc <vprintfmt+0x428>
		return va_arg(*ap, int);
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800668:	89 c1                	mov    %eax,%ecx
  80066a:	c1 f9 1f             	sar    $0x1f,%ecx
  80066d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8d 40 04             	lea    0x4(%eax),%eax
  800676:	89 45 14             	mov    %eax,0x14(%ebp)
  800679:	eb af                	jmp    80062a <vprintfmt+0x296>
				putch('-', putdat);
  80067b:	83 ec 08             	sub    $0x8,%esp
  80067e:	53                   	push   %ebx
  80067f:	6a 2d                	push   $0x2d
  800681:	ff d6                	call   *%esi
				num = -(long long) num;
  800683:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800686:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800689:	f7 d8                	neg    %eax
  80068b:	83 d2 00             	adc    $0x0,%edx
  80068e:	f7 da                	neg    %edx
  800690:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800693:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800696:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800699:	b8 0a 00 00 00       	mov    $0xa,%eax
  80069e:	e9 19 01 00 00       	jmp    8007bc <vprintfmt+0x428>
	if (lflag >= 2)
  8006a3:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006a7:	7f 29                	jg     8006d2 <vprintfmt+0x33e>
	else if (lflag)
  8006a9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006ad:	74 44                	je     8006f3 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c2:	8d 40 04             	lea    0x4(%eax),%eax
  8006c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006cd:	e9 ea 00 00 00       	jmp    8007bc <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d5:	8b 50 04             	mov    0x4(%eax),%edx
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006dd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e3:	8d 40 08             	lea    0x8(%eax),%eax
  8006e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ee:	e9 c9 00 00 00       	jmp    8007bc <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800700:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800703:	8b 45 14             	mov    0x14(%ebp),%eax
  800706:	8d 40 04             	lea    0x4(%eax),%eax
  800709:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80070c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800711:	e9 a6 00 00 00       	jmp    8007bc <vprintfmt+0x428>
			putch('0', putdat);
  800716:	83 ec 08             	sub    $0x8,%esp
  800719:	53                   	push   %ebx
  80071a:	6a 30                	push   $0x30
  80071c:	ff d6                	call   *%esi
	if (lflag >= 2)
  80071e:	83 c4 10             	add    $0x10,%esp
  800721:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800725:	7f 26                	jg     80074d <vprintfmt+0x3b9>
	else if (lflag)
  800727:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80072b:	74 3e                	je     80076b <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80072d:	8b 45 14             	mov    0x14(%ebp),%eax
  800730:	8b 00                	mov    (%eax),%eax
  800732:	ba 00 00 00 00       	mov    $0x0,%edx
  800737:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8d 40 04             	lea    0x4(%eax),%eax
  800743:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800746:	b8 08 00 00 00       	mov    $0x8,%eax
  80074b:	eb 6f                	jmp    8007bc <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80074d:	8b 45 14             	mov    0x14(%ebp),%eax
  800750:	8b 50 04             	mov    0x4(%eax),%edx
  800753:	8b 00                	mov    (%eax),%eax
  800755:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800758:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075b:	8b 45 14             	mov    0x14(%ebp),%eax
  80075e:	8d 40 08             	lea    0x8(%eax),%eax
  800761:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800764:	b8 08 00 00 00       	mov    $0x8,%eax
  800769:	eb 51                	jmp    8007bc <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80076b:	8b 45 14             	mov    0x14(%ebp),%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	ba 00 00 00 00       	mov    $0x0,%edx
  800775:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800778:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077b:	8b 45 14             	mov    0x14(%ebp),%eax
  80077e:	8d 40 04             	lea    0x4(%eax),%eax
  800781:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800784:	b8 08 00 00 00       	mov    $0x8,%eax
  800789:	eb 31                	jmp    8007bc <vprintfmt+0x428>
			putch('0', putdat);
  80078b:	83 ec 08             	sub    $0x8,%esp
  80078e:	53                   	push   %ebx
  80078f:	6a 30                	push   $0x30
  800791:	ff d6                	call   *%esi
			putch('x', putdat);
  800793:	83 c4 08             	add    $0x8,%esp
  800796:	53                   	push   %ebx
  800797:	6a 78                	push   $0x78
  800799:	ff d6                	call   *%esi
			num = (unsigned long long)
  80079b:	8b 45 14             	mov    0x14(%ebp),%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007ab:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b1:	8d 40 04             	lea    0x4(%eax),%eax
  8007b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b7:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007bc:	83 ec 0c             	sub    $0xc,%esp
  8007bf:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007c3:	52                   	push   %edx
  8007c4:	ff 75 e0             	pushl  -0x20(%ebp)
  8007c7:	50                   	push   %eax
  8007c8:	ff 75 dc             	pushl  -0x24(%ebp)
  8007cb:	ff 75 d8             	pushl  -0x28(%ebp)
  8007ce:	89 da                	mov    %ebx,%edx
  8007d0:	89 f0                	mov    %esi,%eax
  8007d2:	e8 a4 fa ff ff       	call   80027b <printnum>
			break;
  8007d7:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007dd:	83 c7 01             	add    $0x1,%edi
  8007e0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007e4:	83 f8 25             	cmp    $0x25,%eax
  8007e7:	0f 84 be fb ff ff    	je     8003ab <vprintfmt+0x17>
			if (ch == '\0')
  8007ed:	85 c0                	test   %eax,%eax
  8007ef:	0f 84 28 01 00 00    	je     80091d <vprintfmt+0x589>
			putch(ch, putdat);
  8007f5:	83 ec 08             	sub    $0x8,%esp
  8007f8:	53                   	push   %ebx
  8007f9:	50                   	push   %eax
  8007fa:	ff d6                	call   *%esi
  8007fc:	83 c4 10             	add    $0x10,%esp
  8007ff:	eb dc                	jmp    8007dd <vprintfmt+0x449>
	if (lflag >= 2)
  800801:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800805:	7f 26                	jg     80082d <vprintfmt+0x499>
	else if (lflag)
  800807:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80080b:	74 41                	je     80084e <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	8b 00                	mov    (%eax),%eax
  800812:	ba 00 00 00 00       	mov    $0x0,%edx
  800817:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80081a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	8d 40 04             	lea    0x4(%eax),%eax
  800823:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800826:	b8 10 00 00 00       	mov    $0x10,%eax
  80082b:	eb 8f                	jmp    8007bc <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80082d:	8b 45 14             	mov    0x14(%ebp),%eax
  800830:	8b 50 04             	mov    0x4(%eax),%edx
  800833:	8b 00                	mov    (%eax),%eax
  800835:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800838:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80083b:	8b 45 14             	mov    0x14(%ebp),%eax
  80083e:	8d 40 08             	lea    0x8(%eax),%eax
  800841:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800844:	b8 10 00 00 00       	mov    $0x10,%eax
  800849:	e9 6e ff ff ff       	jmp    8007bc <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80084e:	8b 45 14             	mov    0x14(%ebp),%eax
  800851:	8b 00                	mov    (%eax),%eax
  800853:	ba 00 00 00 00       	mov    $0x0,%edx
  800858:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80085b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80085e:	8b 45 14             	mov    0x14(%ebp),%eax
  800861:	8d 40 04             	lea    0x4(%eax),%eax
  800864:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800867:	b8 10 00 00 00       	mov    $0x10,%eax
  80086c:	e9 4b ff ff ff       	jmp    8007bc <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800871:	8b 45 14             	mov    0x14(%ebp),%eax
  800874:	83 c0 04             	add    $0x4,%eax
  800877:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80087a:	8b 45 14             	mov    0x14(%ebp),%eax
  80087d:	8b 00                	mov    (%eax),%eax
  80087f:	85 c0                	test   %eax,%eax
  800881:	74 14                	je     800897 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800883:	8b 13                	mov    (%ebx),%edx
  800885:	83 fa 7f             	cmp    $0x7f,%edx
  800888:	7f 37                	jg     8008c1 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80088a:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80088c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80088f:	89 45 14             	mov    %eax,0x14(%ebp)
  800892:	e9 43 ff ff ff       	jmp    8007da <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800897:	b8 0a 00 00 00       	mov    $0xa,%eax
  80089c:	bf c5 14 80 00       	mov    $0x8014c5,%edi
							putch(ch, putdat);
  8008a1:	83 ec 08             	sub    $0x8,%esp
  8008a4:	53                   	push   %ebx
  8008a5:	50                   	push   %eax
  8008a6:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008a8:	83 c7 01             	add    $0x1,%edi
  8008ab:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008af:	83 c4 10             	add    $0x10,%esp
  8008b2:	85 c0                	test   %eax,%eax
  8008b4:	75 eb                	jne    8008a1 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008b9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008bc:	e9 19 ff ff ff       	jmp    8007da <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008c1:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008c3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008c8:	bf fd 14 80 00       	mov    $0x8014fd,%edi
							putch(ch, putdat);
  8008cd:	83 ec 08             	sub    $0x8,%esp
  8008d0:	53                   	push   %ebx
  8008d1:	50                   	push   %eax
  8008d2:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008d4:	83 c7 01             	add    $0x1,%edi
  8008d7:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008db:	83 c4 10             	add    $0x10,%esp
  8008de:	85 c0                	test   %eax,%eax
  8008e0:	75 eb                	jne    8008cd <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e8:	e9 ed fe ff ff       	jmp    8007da <vprintfmt+0x446>
			putch(ch, putdat);
  8008ed:	83 ec 08             	sub    $0x8,%esp
  8008f0:	53                   	push   %ebx
  8008f1:	6a 25                	push   $0x25
  8008f3:	ff d6                	call   *%esi
			break;
  8008f5:	83 c4 10             	add    $0x10,%esp
  8008f8:	e9 dd fe ff ff       	jmp    8007da <vprintfmt+0x446>
			putch('%', putdat);
  8008fd:	83 ec 08             	sub    $0x8,%esp
  800900:	53                   	push   %ebx
  800901:	6a 25                	push   $0x25
  800903:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800905:	83 c4 10             	add    $0x10,%esp
  800908:	89 f8                	mov    %edi,%eax
  80090a:	eb 03                	jmp    80090f <vprintfmt+0x57b>
  80090c:	83 e8 01             	sub    $0x1,%eax
  80090f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800913:	75 f7                	jne    80090c <vprintfmt+0x578>
  800915:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800918:	e9 bd fe ff ff       	jmp    8007da <vprintfmt+0x446>
}
  80091d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800920:	5b                   	pop    %ebx
  800921:	5e                   	pop    %esi
  800922:	5f                   	pop    %edi
  800923:	5d                   	pop    %ebp
  800924:	c3                   	ret    

00800925 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800925:	55                   	push   %ebp
  800926:	89 e5                	mov    %esp,%ebp
  800928:	83 ec 18             	sub    $0x18,%esp
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800931:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800934:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800938:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80093b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800942:	85 c0                	test   %eax,%eax
  800944:	74 26                	je     80096c <vsnprintf+0x47>
  800946:	85 d2                	test   %edx,%edx
  800948:	7e 22                	jle    80096c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80094a:	ff 75 14             	pushl  0x14(%ebp)
  80094d:	ff 75 10             	pushl  0x10(%ebp)
  800950:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800953:	50                   	push   %eax
  800954:	68 5a 03 80 00       	push   $0x80035a
  800959:	e8 36 fa ff ff       	call   800394 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80095e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800961:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800967:	83 c4 10             	add    $0x10,%esp
}
  80096a:	c9                   	leave  
  80096b:	c3                   	ret    
		return -E_INVAL;
  80096c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800971:	eb f7                	jmp    80096a <vsnprintf+0x45>

00800973 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800979:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80097c:	50                   	push   %eax
  80097d:	ff 75 10             	pushl  0x10(%ebp)
  800980:	ff 75 0c             	pushl  0xc(%ebp)
  800983:	ff 75 08             	pushl  0x8(%ebp)
  800986:	e8 9a ff ff ff       	call   800925 <vsnprintf>
	va_end(ap);

	return rc;
}
  80098b:	c9                   	leave  
  80098c:	c3                   	ret    

0080098d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80098d:	55                   	push   %ebp
  80098e:	89 e5                	mov    %esp,%ebp
  800990:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800993:	b8 00 00 00 00       	mov    $0x0,%eax
  800998:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80099c:	74 05                	je     8009a3 <strlen+0x16>
		n++;
  80099e:	83 c0 01             	add    $0x1,%eax
  8009a1:	eb f5                	jmp    800998 <strlen+0xb>
	return n;
}
  8009a3:	5d                   	pop    %ebp
  8009a4:	c3                   	ret    

008009a5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ab:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b3:	39 c2                	cmp    %eax,%edx
  8009b5:	74 0d                	je     8009c4 <strnlen+0x1f>
  8009b7:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009bb:	74 05                	je     8009c2 <strnlen+0x1d>
		n++;
  8009bd:	83 c2 01             	add    $0x1,%edx
  8009c0:	eb f1                	jmp    8009b3 <strnlen+0xe>
  8009c2:	89 d0                	mov    %edx,%eax
	return n;
}
  8009c4:	5d                   	pop    %ebp
  8009c5:	c3                   	ret    

008009c6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009c6:	55                   	push   %ebp
  8009c7:	89 e5                	mov    %esp,%ebp
  8009c9:	53                   	push   %ebx
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d5:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009d9:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009dc:	83 c2 01             	add    $0x1,%edx
  8009df:	84 c9                	test   %cl,%cl
  8009e1:	75 f2                	jne    8009d5 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009e3:	5b                   	pop    %ebx
  8009e4:	5d                   	pop    %ebp
  8009e5:	c3                   	ret    

008009e6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	53                   	push   %ebx
  8009ea:	83 ec 10             	sub    $0x10,%esp
  8009ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009f0:	53                   	push   %ebx
  8009f1:	e8 97 ff ff ff       	call   80098d <strlen>
  8009f6:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009f9:	ff 75 0c             	pushl  0xc(%ebp)
  8009fc:	01 d8                	add    %ebx,%eax
  8009fe:	50                   	push   %eax
  8009ff:	e8 c2 ff ff ff       	call   8009c6 <strcpy>
	return dst;
}
  800a04:	89 d8                	mov    %ebx,%eax
  800a06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a09:	c9                   	leave  
  800a0a:	c3                   	ret    

00800a0b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	56                   	push   %esi
  800a0f:	53                   	push   %ebx
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a16:	89 c6                	mov    %eax,%esi
  800a18:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a1b:	89 c2                	mov    %eax,%edx
  800a1d:	39 f2                	cmp    %esi,%edx
  800a1f:	74 11                	je     800a32 <strncpy+0x27>
		*dst++ = *src;
  800a21:	83 c2 01             	add    $0x1,%edx
  800a24:	0f b6 19             	movzbl (%ecx),%ebx
  800a27:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a2a:	80 fb 01             	cmp    $0x1,%bl
  800a2d:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a30:	eb eb                	jmp    800a1d <strncpy+0x12>
	}
	return ret;
}
  800a32:	5b                   	pop    %ebx
  800a33:	5e                   	pop    %esi
  800a34:	5d                   	pop    %ebp
  800a35:	c3                   	ret    

00800a36 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a36:	55                   	push   %ebp
  800a37:	89 e5                	mov    %esp,%ebp
  800a39:	56                   	push   %esi
  800a3a:	53                   	push   %ebx
  800a3b:	8b 75 08             	mov    0x8(%ebp),%esi
  800a3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a41:	8b 55 10             	mov    0x10(%ebp),%edx
  800a44:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a46:	85 d2                	test   %edx,%edx
  800a48:	74 21                	je     800a6b <strlcpy+0x35>
  800a4a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a4e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a50:	39 c2                	cmp    %eax,%edx
  800a52:	74 14                	je     800a68 <strlcpy+0x32>
  800a54:	0f b6 19             	movzbl (%ecx),%ebx
  800a57:	84 db                	test   %bl,%bl
  800a59:	74 0b                	je     800a66 <strlcpy+0x30>
			*dst++ = *src++;
  800a5b:	83 c1 01             	add    $0x1,%ecx
  800a5e:	83 c2 01             	add    $0x1,%edx
  800a61:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a64:	eb ea                	jmp    800a50 <strlcpy+0x1a>
  800a66:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a68:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a6b:	29 f0                	sub    %esi,%eax
}
  800a6d:	5b                   	pop    %ebx
  800a6e:	5e                   	pop    %esi
  800a6f:	5d                   	pop    %ebp
  800a70:	c3                   	ret    

00800a71 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a71:	55                   	push   %ebp
  800a72:	89 e5                	mov    %esp,%ebp
  800a74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a77:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a7a:	0f b6 01             	movzbl (%ecx),%eax
  800a7d:	84 c0                	test   %al,%al
  800a7f:	74 0c                	je     800a8d <strcmp+0x1c>
  800a81:	3a 02                	cmp    (%edx),%al
  800a83:	75 08                	jne    800a8d <strcmp+0x1c>
		p++, q++;
  800a85:	83 c1 01             	add    $0x1,%ecx
  800a88:	83 c2 01             	add    $0x1,%edx
  800a8b:	eb ed                	jmp    800a7a <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a8d:	0f b6 c0             	movzbl %al,%eax
  800a90:	0f b6 12             	movzbl (%edx),%edx
  800a93:	29 d0                	sub    %edx,%eax
}
  800a95:	5d                   	pop    %ebp
  800a96:	c3                   	ret    

00800a97 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
  800a9a:	53                   	push   %ebx
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa1:	89 c3                	mov    %eax,%ebx
  800aa3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800aa6:	eb 06                	jmp    800aae <strncmp+0x17>
		n--, p++, q++;
  800aa8:	83 c0 01             	add    $0x1,%eax
  800aab:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800aae:	39 d8                	cmp    %ebx,%eax
  800ab0:	74 16                	je     800ac8 <strncmp+0x31>
  800ab2:	0f b6 08             	movzbl (%eax),%ecx
  800ab5:	84 c9                	test   %cl,%cl
  800ab7:	74 04                	je     800abd <strncmp+0x26>
  800ab9:	3a 0a                	cmp    (%edx),%cl
  800abb:	74 eb                	je     800aa8 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800abd:	0f b6 00             	movzbl (%eax),%eax
  800ac0:	0f b6 12             	movzbl (%edx),%edx
  800ac3:	29 d0                	sub    %edx,%eax
}
  800ac5:	5b                   	pop    %ebx
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    
		return 0;
  800ac8:	b8 00 00 00 00       	mov    $0x0,%eax
  800acd:	eb f6                	jmp    800ac5 <strncmp+0x2e>

00800acf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800acf:	55                   	push   %ebp
  800ad0:	89 e5                	mov    %esp,%ebp
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ad9:	0f b6 10             	movzbl (%eax),%edx
  800adc:	84 d2                	test   %dl,%dl
  800ade:	74 09                	je     800ae9 <strchr+0x1a>
		if (*s == c)
  800ae0:	38 ca                	cmp    %cl,%dl
  800ae2:	74 0a                	je     800aee <strchr+0x1f>
	for (; *s; s++)
  800ae4:	83 c0 01             	add    $0x1,%eax
  800ae7:	eb f0                	jmp    800ad9 <strchr+0xa>
			return (char *) s;
	return 0;
  800ae9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aee:	5d                   	pop    %ebp
  800aef:	c3                   	ret    

00800af0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800afa:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800afd:	38 ca                	cmp    %cl,%dl
  800aff:	74 09                	je     800b0a <strfind+0x1a>
  800b01:	84 d2                	test   %dl,%dl
  800b03:	74 05                	je     800b0a <strfind+0x1a>
	for (; *s; s++)
  800b05:	83 c0 01             	add    $0x1,%eax
  800b08:	eb f0                	jmp    800afa <strfind+0xa>
			break;
	return (char *) s;
}
  800b0a:	5d                   	pop    %ebp
  800b0b:	c3                   	ret    

00800b0c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b0c:	55                   	push   %ebp
  800b0d:	89 e5                	mov    %esp,%ebp
  800b0f:	57                   	push   %edi
  800b10:	56                   	push   %esi
  800b11:	53                   	push   %ebx
  800b12:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b15:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b18:	85 c9                	test   %ecx,%ecx
  800b1a:	74 31                	je     800b4d <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b1c:	89 f8                	mov    %edi,%eax
  800b1e:	09 c8                	or     %ecx,%eax
  800b20:	a8 03                	test   $0x3,%al
  800b22:	75 23                	jne    800b47 <memset+0x3b>
		c &= 0xFF;
  800b24:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b28:	89 d3                	mov    %edx,%ebx
  800b2a:	c1 e3 08             	shl    $0x8,%ebx
  800b2d:	89 d0                	mov    %edx,%eax
  800b2f:	c1 e0 18             	shl    $0x18,%eax
  800b32:	89 d6                	mov    %edx,%esi
  800b34:	c1 e6 10             	shl    $0x10,%esi
  800b37:	09 f0                	or     %esi,%eax
  800b39:	09 c2                	or     %eax,%edx
  800b3b:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b3d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b40:	89 d0                	mov    %edx,%eax
  800b42:	fc                   	cld    
  800b43:	f3 ab                	rep stos %eax,%es:(%edi)
  800b45:	eb 06                	jmp    800b4d <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	fc                   	cld    
  800b4b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b4d:	89 f8                	mov    %edi,%eax
  800b4f:	5b                   	pop    %ebx
  800b50:	5e                   	pop    %esi
  800b51:	5f                   	pop    %edi
  800b52:	5d                   	pop    %ebp
  800b53:	c3                   	ret    

00800b54 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b54:	55                   	push   %ebp
  800b55:	89 e5                	mov    %esp,%ebp
  800b57:	57                   	push   %edi
  800b58:	56                   	push   %esi
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b5f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b62:	39 c6                	cmp    %eax,%esi
  800b64:	73 32                	jae    800b98 <memmove+0x44>
  800b66:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b69:	39 c2                	cmp    %eax,%edx
  800b6b:	76 2b                	jbe    800b98 <memmove+0x44>
		s += n;
		d += n;
  800b6d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b70:	89 fe                	mov    %edi,%esi
  800b72:	09 ce                	or     %ecx,%esi
  800b74:	09 d6                	or     %edx,%esi
  800b76:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b7c:	75 0e                	jne    800b8c <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b7e:	83 ef 04             	sub    $0x4,%edi
  800b81:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b84:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b87:	fd                   	std    
  800b88:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b8a:	eb 09                	jmp    800b95 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b8c:	83 ef 01             	sub    $0x1,%edi
  800b8f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b92:	fd                   	std    
  800b93:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b95:	fc                   	cld    
  800b96:	eb 1a                	jmp    800bb2 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b98:	89 c2                	mov    %eax,%edx
  800b9a:	09 ca                	or     %ecx,%edx
  800b9c:	09 f2                	or     %esi,%edx
  800b9e:	f6 c2 03             	test   $0x3,%dl
  800ba1:	75 0a                	jne    800bad <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ba3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ba6:	89 c7                	mov    %eax,%edi
  800ba8:	fc                   	cld    
  800ba9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bab:	eb 05                	jmp    800bb2 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bad:	89 c7                	mov    %eax,%edi
  800baf:	fc                   	cld    
  800bb0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bb2:	5e                   	pop    %esi
  800bb3:	5f                   	pop    %edi
  800bb4:	5d                   	pop    %ebp
  800bb5:	c3                   	ret    

00800bb6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bbc:	ff 75 10             	pushl  0x10(%ebp)
  800bbf:	ff 75 0c             	pushl  0xc(%ebp)
  800bc2:	ff 75 08             	pushl  0x8(%ebp)
  800bc5:	e8 8a ff ff ff       	call   800b54 <memmove>
}
  800bca:	c9                   	leave  
  800bcb:	c3                   	ret    

00800bcc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	56                   	push   %esi
  800bd0:	53                   	push   %ebx
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd7:	89 c6                	mov    %eax,%esi
  800bd9:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bdc:	39 f0                	cmp    %esi,%eax
  800bde:	74 1c                	je     800bfc <memcmp+0x30>
		if (*s1 != *s2)
  800be0:	0f b6 08             	movzbl (%eax),%ecx
  800be3:	0f b6 1a             	movzbl (%edx),%ebx
  800be6:	38 d9                	cmp    %bl,%cl
  800be8:	75 08                	jne    800bf2 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bea:	83 c0 01             	add    $0x1,%eax
  800bed:	83 c2 01             	add    $0x1,%edx
  800bf0:	eb ea                	jmp    800bdc <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bf2:	0f b6 c1             	movzbl %cl,%eax
  800bf5:	0f b6 db             	movzbl %bl,%ebx
  800bf8:	29 d8                	sub    %ebx,%eax
  800bfa:	eb 05                	jmp    800c01 <memcmp+0x35>
	}

	return 0;
  800bfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c01:	5b                   	pop    %ebx
  800c02:	5e                   	pop    %esi
  800c03:	5d                   	pop    %ebp
  800c04:	c3                   	ret    

00800c05 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c0e:	89 c2                	mov    %eax,%edx
  800c10:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c13:	39 d0                	cmp    %edx,%eax
  800c15:	73 09                	jae    800c20 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c17:	38 08                	cmp    %cl,(%eax)
  800c19:	74 05                	je     800c20 <memfind+0x1b>
	for (; s < ends; s++)
  800c1b:	83 c0 01             	add    $0x1,%eax
  800c1e:	eb f3                	jmp    800c13 <memfind+0xe>
			break;
	return (void *) s;
}
  800c20:	5d                   	pop    %ebp
  800c21:	c3                   	ret    

00800c22 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	57                   	push   %edi
  800c26:	56                   	push   %esi
  800c27:	53                   	push   %ebx
  800c28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c2b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c2e:	eb 03                	jmp    800c33 <strtol+0x11>
		s++;
  800c30:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c33:	0f b6 01             	movzbl (%ecx),%eax
  800c36:	3c 20                	cmp    $0x20,%al
  800c38:	74 f6                	je     800c30 <strtol+0xe>
  800c3a:	3c 09                	cmp    $0x9,%al
  800c3c:	74 f2                	je     800c30 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c3e:	3c 2b                	cmp    $0x2b,%al
  800c40:	74 2a                	je     800c6c <strtol+0x4a>
	int neg = 0;
  800c42:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c47:	3c 2d                	cmp    $0x2d,%al
  800c49:	74 2b                	je     800c76 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c4b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c51:	75 0f                	jne    800c62 <strtol+0x40>
  800c53:	80 39 30             	cmpb   $0x30,(%ecx)
  800c56:	74 28                	je     800c80 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c58:	85 db                	test   %ebx,%ebx
  800c5a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c5f:	0f 44 d8             	cmove  %eax,%ebx
  800c62:	b8 00 00 00 00       	mov    $0x0,%eax
  800c67:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c6a:	eb 50                	jmp    800cbc <strtol+0x9a>
		s++;
  800c6c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c6f:	bf 00 00 00 00       	mov    $0x0,%edi
  800c74:	eb d5                	jmp    800c4b <strtol+0x29>
		s++, neg = 1;
  800c76:	83 c1 01             	add    $0x1,%ecx
  800c79:	bf 01 00 00 00       	mov    $0x1,%edi
  800c7e:	eb cb                	jmp    800c4b <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c80:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c84:	74 0e                	je     800c94 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c86:	85 db                	test   %ebx,%ebx
  800c88:	75 d8                	jne    800c62 <strtol+0x40>
		s++, base = 8;
  800c8a:	83 c1 01             	add    $0x1,%ecx
  800c8d:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c92:	eb ce                	jmp    800c62 <strtol+0x40>
		s += 2, base = 16;
  800c94:	83 c1 02             	add    $0x2,%ecx
  800c97:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c9c:	eb c4                	jmp    800c62 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c9e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ca1:	89 f3                	mov    %esi,%ebx
  800ca3:	80 fb 19             	cmp    $0x19,%bl
  800ca6:	77 29                	ja     800cd1 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800ca8:	0f be d2             	movsbl %dl,%edx
  800cab:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cae:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cb1:	7d 30                	jge    800ce3 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cb3:	83 c1 01             	add    $0x1,%ecx
  800cb6:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cba:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cbc:	0f b6 11             	movzbl (%ecx),%edx
  800cbf:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cc2:	89 f3                	mov    %esi,%ebx
  800cc4:	80 fb 09             	cmp    $0x9,%bl
  800cc7:	77 d5                	ja     800c9e <strtol+0x7c>
			dig = *s - '0';
  800cc9:	0f be d2             	movsbl %dl,%edx
  800ccc:	83 ea 30             	sub    $0x30,%edx
  800ccf:	eb dd                	jmp    800cae <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800cd1:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cd4:	89 f3                	mov    %esi,%ebx
  800cd6:	80 fb 19             	cmp    $0x19,%bl
  800cd9:	77 08                	ja     800ce3 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cdb:	0f be d2             	movsbl %dl,%edx
  800cde:	83 ea 37             	sub    $0x37,%edx
  800ce1:	eb cb                	jmp    800cae <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ce3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce7:	74 05                	je     800cee <strtol+0xcc>
		*endptr = (char *) s;
  800ce9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cec:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cee:	89 c2                	mov    %eax,%edx
  800cf0:	f7 da                	neg    %edx
  800cf2:	85 ff                	test   %edi,%edi
  800cf4:	0f 45 c2             	cmovne %edx,%eax
}
  800cf7:	5b                   	pop    %ebx
  800cf8:	5e                   	pop    %esi
  800cf9:	5f                   	pop    %edi
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    

00800cfc <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	57                   	push   %edi
  800d00:	56                   	push   %esi
  800d01:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d02:	b8 00 00 00 00       	mov    $0x0,%eax
  800d07:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0d:	89 c3                	mov    %eax,%ebx
  800d0f:	89 c7                	mov    %eax,%edi
  800d11:	89 c6                	mov    %eax,%esi
  800d13:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d15:	5b                   	pop    %ebx
  800d16:	5e                   	pop    %esi
  800d17:	5f                   	pop    %edi
  800d18:	5d                   	pop    %ebp
  800d19:	c3                   	ret    

00800d1a <sys_cgetc>:

int
sys_cgetc(void)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	57                   	push   %edi
  800d1e:	56                   	push   %esi
  800d1f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d20:	ba 00 00 00 00       	mov    $0x0,%edx
  800d25:	b8 01 00 00 00       	mov    $0x1,%eax
  800d2a:	89 d1                	mov    %edx,%ecx
  800d2c:	89 d3                	mov    %edx,%ebx
  800d2e:	89 d7                	mov    %edx,%edi
  800d30:	89 d6                	mov    %edx,%esi
  800d32:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d34:	5b                   	pop    %ebx
  800d35:	5e                   	pop    %esi
  800d36:	5f                   	pop    %edi
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    

00800d39 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	57                   	push   %edi
  800d3d:	56                   	push   %esi
  800d3e:	53                   	push   %ebx
  800d3f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d42:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d47:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4a:	b8 03 00 00 00       	mov    $0x3,%eax
  800d4f:	89 cb                	mov    %ecx,%ebx
  800d51:	89 cf                	mov    %ecx,%edi
  800d53:	89 ce                	mov    %ecx,%esi
  800d55:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d57:	85 c0                	test   %eax,%eax
  800d59:	7f 08                	jg     800d63 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5e:	5b                   	pop    %ebx
  800d5f:	5e                   	pop    %esi
  800d60:	5f                   	pop    %edi
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d63:	83 ec 0c             	sub    $0xc,%esp
  800d66:	50                   	push   %eax
  800d67:	6a 03                	push   $0x3
  800d69:	68 00 17 80 00       	push   $0x801700
  800d6e:	6a 43                	push   $0x43
  800d70:	68 1d 17 80 00       	push   $0x80171d
  800d75:	e8 f7 f3 ff ff       	call   800171 <_panic>

00800d7a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	57                   	push   %edi
  800d7e:	56                   	push   %esi
  800d7f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d80:	ba 00 00 00 00       	mov    $0x0,%edx
  800d85:	b8 02 00 00 00       	mov    $0x2,%eax
  800d8a:	89 d1                	mov    %edx,%ecx
  800d8c:	89 d3                	mov    %edx,%ebx
  800d8e:	89 d7                	mov    %edx,%edi
  800d90:	89 d6                	mov    %edx,%esi
  800d92:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d94:	5b                   	pop    %ebx
  800d95:	5e                   	pop    %esi
  800d96:	5f                   	pop    %edi
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    

00800d99 <sys_yield>:

void
sys_yield(void)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	57                   	push   %edi
  800d9d:	56                   	push   %esi
  800d9e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d9f:	ba 00 00 00 00       	mov    $0x0,%edx
  800da4:	b8 0b 00 00 00       	mov    $0xb,%eax
  800da9:	89 d1                	mov    %edx,%ecx
  800dab:	89 d3                	mov    %edx,%ebx
  800dad:	89 d7                	mov    %edx,%edi
  800daf:	89 d6                	mov    %edx,%esi
  800db1:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800db3:	5b                   	pop    %ebx
  800db4:	5e                   	pop    %esi
  800db5:	5f                   	pop    %edi
  800db6:	5d                   	pop    %ebp
  800db7:	c3                   	ret    

00800db8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
  800dbb:	57                   	push   %edi
  800dbc:	56                   	push   %esi
  800dbd:	53                   	push   %ebx
  800dbe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc1:	be 00 00 00 00       	mov    $0x0,%esi
  800dc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcc:	b8 04 00 00 00       	mov    $0x4,%eax
  800dd1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd4:	89 f7                	mov    %esi,%edi
  800dd6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd8:	85 c0                	test   %eax,%eax
  800dda:	7f 08                	jg     800de4 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ddc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddf:	5b                   	pop    %ebx
  800de0:	5e                   	pop    %esi
  800de1:	5f                   	pop    %edi
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de4:	83 ec 0c             	sub    $0xc,%esp
  800de7:	50                   	push   %eax
  800de8:	6a 04                	push   $0x4
  800dea:	68 00 17 80 00       	push   $0x801700
  800def:	6a 43                	push   $0x43
  800df1:	68 1d 17 80 00       	push   $0x80171d
  800df6:	e8 76 f3 ff ff       	call   800171 <_panic>

00800dfb <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	57                   	push   %edi
  800dff:	56                   	push   %esi
  800e00:	53                   	push   %ebx
  800e01:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e04:	8b 55 08             	mov    0x8(%ebp),%edx
  800e07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0a:	b8 05 00 00 00       	mov    $0x5,%eax
  800e0f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e12:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e15:	8b 75 18             	mov    0x18(%ebp),%esi
  800e18:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e1a:	85 c0                	test   %eax,%eax
  800e1c:	7f 08                	jg     800e26 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e21:	5b                   	pop    %ebx
  800e22:	5e                   	pop    %esi
  800e23:	5f                   	pop    %edi
  800e24:	5d                   	pop    %ebp
  800e25:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e26:	83 ec 0c             	sub    $0xc,%esp
  800e29:	50                   	push   %eax
  800e2a:	6a 05                	push   $0x5
  800e2c:	68 00 17 80 00       	push   $0x801700
  800e31:	6a 43                	push   $0x43
  800e33:	68 1d 17 80 00       	push   $0x80171d
  800e38:	e8 34 f3 ff ff       	call   800171 <_panic>

00800e3d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	57                   	push   %edi
  800e41:	56                   	push   %esi
  800e42:	53                   	push   %ebx
  800e43:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e46:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e51:	b8 06 00 00 00       	mov    $0x6,%eax
  800e56:	89 df                	mov    %ebx,%edi
  800e58:	89 de                	mov    %ebx,%esi
  800e5a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5c:	85 c0                	test   %eax,%eax
  800e5e:	7f 08                	jg     800e68 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e63:	5b                   	pop    %ebx
  800e64:	5e                   	pop    %esi
  800e65:	5f                   	pop    %edi
  800e66:	5d                   	pop    %ebp
  800e67:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e68:	83 ec 0c             	sub    $0xc,%esp
  800e6b:	50                   	push   %eax
  800e6c:	6a 06                	push   $0x6
  800e6e:	68 00 17 80 00       	push   $0x801700
  800e73:	6a 43                	push   $0x43
  800e75:	68 1d 17 80 00       	push   $0x80171d
  800e7a:	e8 f2 f2 ff ff       	call   800171 <_panic>

00800e7f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	57                   	push   %edi
  800e83:	56                   	push   %esi
  800e84:	53                   	push   %ebx
  800e85:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e88:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e93:	b8 08 00 00 00       	mov    $0x8,%eax
  800e98:	89 df                	mov    %ebx,%edi
  800e9a:	89 de                	mov    %ebx,%esi
  800e9c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e9e:	85 c0                	test   %eax,%eax
  800ea0:	7f 08                	jg     800eaa <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ea2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ea5:	5b                   	pop    %ebx
  800ea6:	5e                   	pop    %esi
  800ea7:	5f                   	pop    %edi
  800ea8:	5d                   	pop    %ebp
  800ea9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eaa:	83 ec 0c             	sub    $0xc,%esp
  800ead:	50                   	push   %eax
  800eae:	6a 08                	push   $0x8
  800eb0:	68 00 17 80 00       	push   $0x801700
  800eb5:	6a 43                	push   $0x43
  800eb7:	68 1d 17 80 00       	push   $0x80171d
  800ebc:	e8 b0 f2 ff ff       	call   800171 <_panic>

00800ec1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ec1:	55                   	push   %ebp
  800ec2:	89 e5                	mov    %esp,%ebp
  800ec4:	57                   	push   %edi
  800ec5:	56                   	push   %esi
  800ec6:	53                   	push   %ebx
  800ec7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eca:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ecf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed5:	b8 09 00 00 00       	mov    $0x9,%eax
  800eda:	89 df                	mov    %ebx,%edi
  800edc:	89 de                	mov    %ebx,%esi
  800ede:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ee0:	85 c0                	test   %eax,%eax
  800ee2:	7f 08                	jg     800eec <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ee4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee7:	5b                   	pop    %ebx
  800ee8:	5e                   	pop    %esi
  800ee9:	5f                   	pop    %edi
  800eea:	5d                   	pop    %ebp
  800eeb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eec:	83 ec 0c             	sub    $0xc,%esp
  800eef:	50                   	push   %eax
  800ef0:	6a 09                	push   $0x9
  800ef2:	68 00 17 80 00       	push   $0x801700
  800ef7:	6a 43                	push   $0x43
  800ef9:	68 1d 17 80 00       	push   $0x80171d
  800efe:	e8 6e f2 ff ff       	call   800171 <_panic>

00800f03 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	57                   	push   %edi
  800f07:	56                   	push   %esi
  800f08:	53                   	push   %ebx
  800f09:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f0c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f11:	8b 55 08             	mov    0x8(%ebp),%edx
  800f14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f17:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f1c:	89 df                	mov    %ebx,%edi
  800f1e:	89 de                	mov    %ebx,%esi
  800f20:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f22:	85 c0                	test   %eax,%eax
  800f24:	7f 08                	jg     800f2e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f29:	5b                   	pop    %ebx
  800f2a:	5e                   	pop    %esi
  800f2b:	5f                   	pop    %edi
  800f2c:	5d                   	pop    %ebp
  800f2d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2e:	83 ec 0c             	sub    $0xc,%esp
  800f31:	50                   	push   %eax
  800f32:	6a 0a                	push   $0xa
  800f34:	68 00 17 80 00       	push   $0x801700
  800f39:	6a 43                	push   $0x43
  800f3b:	68 1d 17 80 00       	push   $0x80171d
  800f40:	e8 2c f2 ff ff       	call   800171 <_panic>

00800f45 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f45:	55                   	push   %ebp
  800f46:	89 e5                	mov    %esp,%ebp
  800f48:	57                   	push   %edi
  800f49:	56                   	push   %esi
  800f4a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f51:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f56:	be 00 00 00 00       	mov    $0x0,%esi
  800f5b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f5e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f61:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f63:	5b                   	pop    %ebx
  800f64:	5e                   	pop    %esi
  800f65:	5f                   	pop    %edi
  800f66:	5d                   	pop    %ebp
  800f67:	c3                   	ret    

00800f68 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	57                   	push   %edi
  800f6c:	56                   	push   %esi
  800f6d:	53                   	push   %ebx
  800f6e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f71:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f76:	8b 55 08             	mov    0x8(%ebp),%edx
  800f79:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f7e:	89 cb                	mov    %ecx,%ebx
  800f80:	89 cf                	mov    %ecx,%edi
  800f82:	89 ce                	mov    %ecx,%esi
  800f84:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f86:	85 c0                	test   %eax,%eax
  800f88:	7f 08                	jg     800f92 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f8d:	5b                   	pop    %ebx
  800f8e:	5e                   	pop    %esi
  800f8f:	5f                   	pop    %edi
  800f90:	5d                   	pop    %ebp
  800f91:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f92:	83 ec 0c             	sub    $0xc,%esp
  800f95:	50                   	push   %eax
  800f96:	6a 0d                	push   $0xd
  800f98:	68 00 17 80 00       	push   $0x801700
  800f9d:	6a 43                	push   $0x43
  800f9f:	68 1d 17 80 00       	push   $0x80171d
  800fa4:	e8 c8 f1 ff ff       	call   800171 <_panic>

00800fa9 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fa9:	55                   	push   %ebp
  800faa:	89 e5                	mov    %esp,%ebp
  800fac:	57                   	push   %edi
  800fad:	56                   	push   %esi
  800fae:	53                   	push   %ebx
	asm volatile("int %1\n"
  800faf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fba:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fbf:	89 df                	mov    %ebx,%edi
  800fc1:	89 de                	mov    %ebx,%esi
  800fc3:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fc5:	5b                   	pop    %ebx
  800fc6:	5e                   	pop    %esi
  800fc7:	5f                   	pop    %edi
  800fc8:	5d                   	pop    %ebp
  800fc9:	c3                   	ret    

00800fca <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fca:	55                   	push   %ebp
  800fcb:	89 e5                	mov    %esp,%ebp
  800fcd:	57                   	push   %edi
  800fce:	56                   	push   %esi
  800fcf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fd0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fdd:	89 cb                	mov    %ecx,%ebx
  800fdf:	89 cf                	mov    %ecx,%edi
  800fe1:	89 ce                	mov    %ecx,%esi
  800fe3:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fe5:	5b                   	pop    %ebx
  800fe6:	5e                   	pop    %esi
  800fe7:	5f                   	pop    %edi
  800fe8:	5d                   	pop    %ebp
  800fe9:	c3                   	ret    

00800fea <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800ff0:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  800ff7:	74 0a                	je     801003 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	a3 08 20 80 00       	mov    %eax,0x802008
}
  801001:	c9                   	leave  
  801002:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  801003:	83 ec 04             	sub    $0x4,%esp
  801006:	6a 07                	push   $0x7
  801008:	68 00 f0 bf ee       	push   $0xeebff000
  80100d:	6a 00                	push   $0x0
  80100f:	e8 a4 fd ff ff       	call   800db8 <sys_page_alloc>
		if(r < 0)
  801014:	83 c4 10             	add    $0x10,%esp
  801017:	85 c0                	test   %eax,%eax
  801019:	78 2a                	js     801045 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80101b:	83 ec 08             	sub    $0x8,%esp
  80101e:	68 59 10 80 00       	push   $0x801059
  801023:	6a 00                	push   $0x0
  801025:	e8 d9 fe ff ff       	call   800f03 <sys_env_set_pgfault_upcall>
		if(r < 0)
  80102a:	83 c4 10             	add    $0x10,%esp
  80102d:	85 c0                	test   %eax,%eax
  80102f:	79 c8                	jns    800ff9 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  801031:	83 ec 04             	sub    $0x4,%esp
  801034:	68 5c 17 80 00       	push   $0x80175c
  801039:	6a 25                	push   $0x25
  80103b:	68 98 17 80 00       	push   $0x801798
  801040:	e8 2c f1 ff ff       	call   800171 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  801045:	83 ec 04             	sub    $0x4,%esp
  801048:	68 2c 17 80 00       	push   $0x80172c
  80104d:	6a 22                	push   $0x22
  80104f:	68 98 17 80 00       	push   $0x801798
  801054:	e8 18 f1 ff ff       	call   800171 <_panic>

00801059 <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801059:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80105a:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  80105f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801061:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  801064:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  801068:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80106c:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  80106f:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  801071:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  801075:	83 c4 08             	add    $0x8,%esp
	popal
  801078:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801079:	83 c4 04             	add    $0x4,%esp
	popfl
  80107c:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80107d:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80107e:	c3                   	ret    
  80107f:	90                   	nop

00801080 <__udivdi3>:
  801080:	55                   	push   %ebp
  801081:	57                   	push   %edi
  801082:	56                   	push   %esi
  801083:	53                   	push   %ebx
  801084:	83 ec 1c             	sub    $0x1c,%esp
  801087:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80108b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80108f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801093:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  801097:	85 d2                	test   %edx,%edx
  801099:	75 4d                	jne    8010e8 <__udivdi3+0x68>
  80109b:	39 f3                	cmp    %esi,%ebx
  80109d:	76 19                	jbe    8010b8 <__udivdi3+0x38>
  80109f:	31 ff                	xor    %edi,%edi
  8010a1:	89 e8                	mov    %ebp,%eax
  8010a3:	89 f2                	mov    %esi,%edx
  8010a5:	f7 f3                	div    %ebx
  8010a7:	89 fa                	mov    %edi,%edx
  8010a9:	83 c4 1c             	add    $0x1c,%esp
  8010ac:	5b                   	pop    %ebx
  8010ad:	5e                   	pop    %esi
  8010ae:	5f                   	pop    %edi
  8010af:	5d                   	pop    %ebp
  8010b0:	c3                   	ret    
  8010b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010b8:	89 d9                	mov    %ebx,%ecx
  8010ba:	85 db                	test   %ebx,%ebx
  8010bc:	75 0b                	jne    8010c9 <__udivdi3+0x49>
  8010be:	b8 01 00 00 00       	mov    $0x1,%eax
  8010c3:	31 d2                	xor    %edx,%edx
  8010c5:	f7 f3                	div    %ebx
  8010c7:	89 c1                	mov    %eax,%ecx
  8010c9:	31 d2                	xor    %edx,%edx
  8010cb:	89 f0                	mov    %esi,%eax
  8010cd:	f7 f1                	div    %ecx
  8010cf:	89 c6                	mov    %eax,%esi
  8010d1:	89 e8                	mov    %ebp,%eax
  8010d3:	89 f7                	mov    %esi,%edi
  8010d5:	f7 f1                	div    %ecx
  8010d7:	89 fa                	mov    %edi,%edx
  8010d9:	83 c4 1c             	add    $0x1c,%esp
  8010dc:	5b                   	pop    %ebx
  8010dd:	5e                   	pop    %esi
  8010de:	5f                   	pop    %edi
  8010df:	5d                   	pop    %ebp
  8010e0:	c3                   	ret    
  8010e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010e8:	39 f2                	cmp    %esi,%edx
  8010ea:	77 1c                	ja     801108 <__udivdi3+0x88>
  8010ec:	0f bd fa             	bsr    %edx,%edi
  8010ef:	83 f7 1f             	xor    $0x1f,%edi
  8010f2:	75 2c                	jne    801120 <__udivdi3+0xa0>
  8010f4:	39 f2                	cmp    %esi,%edx
  8010f6:	72 06                	jb     8010fe <__udivdi3+0x7e>
  8010f8:	31 c0                	xor    %eax,%eax
  8010fa:	39 eb                	cmp    %ebp,%ebx
  8010fc:	77 a9                	ja     8010a7 <__udivdi3+0x27>
  8010fe:	b8 01 00 00 00       	mov    $0x1,%eax
  801103:	eb a2                	jmp    8010a7 <__udivdi3+0x27>
  801105:	8d 76 00             	lea    0x0(%esi),%esi
  801108:	31 ff                	xor    %edi,%edi
  80110a:	31 c0                	xor    %eax,%eax
  80110c:	89 fa                	mov    %edi,%edx
  80110e:	83 c4 1c             	add    $0x1c,%esp
  801111:	5b                   	pop    %ebx
  801112:	5e                   	pop    %esi
  801113:	5f                   	pop    %edi
  801114:	5d                   	pop    %ebp
  801115:	c3                   	ret    
  801116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80111d:	8d 76 00             	lea    0x0(%esi),%esi
  801120:	89 f9                	mov    %edi,%ecx
  801122:	b8 20 00 00 00       	mov    $0x20,%eax
  801127:	29 f8                	sub    %edi,%eax
  801129:	d3 e2                	shl    %cl,%edx
  80112b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80112f:	89 c1                	mov    %eax,%ecx
  801131:	89 da                	mov    %ebx,%edx
  801133:	d3 ea                	shr    %cl,%edx
  801135:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801139:	09 d1                	or     %edx,%ecx
  80113b:	89 f2                	mov    %esi,%edx
  80113d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801141:	89 f9                	mov    %edi,%ecx
  801143:	d3 e3                	shl    %cl,%ebx
  801145:	89 c1                	mov    %eax,%ecx
  801147:	d3 ea                	shr    %cl,%edx
  801149:	89 f9                	mov    %edi,%ecx
  80114b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80114f:	89 eb                	mov    %ebp,%ebx
  801151:	d3 e6                	shl    %cl,%esi
  801153:	89 c1                	mov    %eax,%ecx
  801155:	d3 eb                	shr    %cl,%ebx
  801157:	09 de                	or     %ebx,%esi
  801159:	89 f0                	mov    %esi,%eax
  80115b:	f7 74 24 08          	divl   0x8(%esp)
  80115f:	89 d6                	mov    %edx,%esi
  801161:	89 c3                	mov    %eax,%ebx
  801163:	f7 64 24 0c          	mull   0xc(%esp)
  801167:	39 d6                	cmp    %edx,%esi
  801169:	72 15                	jb     801180 <__udivdi3+0x100>
  80116b:	89 f9                	mov    %edi,%ecx
  80116d:	d3 e5                	shl    %cl,%ebp
  80116f:	39 c5                	cmp    %eax,%ebp
  801171:	73 04                	jae    801177 <__udivdi3+0xf7>
  801173:	39 d6                	cmp    %edx,%esi
  801175:	74 09                	je     801180 <__udivdi3+0x100>
  801177:	89 d8                	mov    %ebx,%eax
  801179:	31 ff                	xor    %edi,%edi
  80117b:	e9 27 ff ff ff       	jmp    8010a7 <__udivdi3+0x27>
  801180:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801183:	31 ff                	xor    %edi,%edi
  801185:	e9 1d ff ff ff       	jmp    8010a7 <__udivdi3+0x27>
  80118a:	66 90                	xchg   %ax,%ax
  80118c:	66 90                	xchg   %ax,%ax
  80118e:	66 90                	xchg   %ax,%ax

00801190 <__umoddi3>:
  801190:	55                   	push   %ebp
  801191:	57                   	push   %edi
  801192:	56                   	push   %esi
  801193:	53                   	push   %ebx
  801194:	83 ec 1c             	sub    $0x1c,%esp
  801197:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80119b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80119f:	8b 74 24 30          	mov    0x30(%esp),%esi
  8011a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8011a7:	89 da                	mov    %ebx,%edx
  8011a9:	85 c0                	test   %eax,%eax
  8011ab:	75 43                	jne    8011f0 <__umoddi3+0x60>
  8011ad:	39 df                	cmp    %ebx,%edi
  8011af:	76 17                	jbe    8011c8 <__umoddi3+0x38>
  8011b1:	89 f0                	mov    %esi,%eax
  8011b3:	f7 f7                	div    %edi
  8011b5:	89 d0                	mov    %edx,%eax
  8011b7:	31 d2                	xor    %edx,%edx
  8011b9:	83 c4 1c             	add    $0x1c,%esp
  8011bc:	5b                   	pop    %ebx
  8011bd:	5e                   	pop    %esi
  8011be:	5f                   	pop    %edi
  8011bf:	5d                   	pop    %ebp
  8011c0:	c3                   	ret    
  8011c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011c8:	89 fd                	mov    %edi,%ebp
  8011ca:	85 ff                	test   %edi,%edi
  8011cc:	75 0b                	jne    8011d9 <__umoddi3+0x49>
  8011ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8011d3:	31 d2                	xor    %edx,%edx
  8011d5:	f7 f7                	div    %edi
  8011d7:	89 c5                	mov    %eax,%ebp
  8011d9:	89 d8                	mov    %ebx,%eax
  8011db:	31 d2                	xor    %edx,%edx
  8011dd:	f7 f5                	div    %ebp
  8011df:	89 f0                	mov    %esi,%eax
  8011e1:	f7 f5                	div    %ebp
  8011e3:	89 d0                	mov    %edx,%eax
  8011e5:	eb d0                	jmp    8011b7 <__umoddi3+0x27>
  8011e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8011ee:	66 90                	xchg   %ax,%ax
  8011f0:	89 f1                	mov    %esi,%ecx
  8011f2:	39 d8                	cmp    %ebx,%eax
  8011f4:	76 0a                	jbe    801200 <__umoddi3+0x70>
  8011f6:	89 f0                	mov    %esi,%eax
  8011f8:	83 c4 1c             	add    $0x1c,%esp
  8011fb:	5b                   	pop    %ebx
  8011fc:	5e                   	pop    %esi
  8011fd:	5f                   	pop    %edi
  8011fe:	5d                   	pop    %ebp
  8011ff:	c3                   	ret    
  801200:	0f bd e8             	bsr    %eax,%ebp
  801203:	83 f5 1f             	xor    $0x1f,%ebp
  801206:	75 20                	jne    801228 <__umoddi3+0x98>
  801208:	39 d8                	cmp    %ebx,%eax
  80120a:	0f 82 b0 00 00 00    	jb     8012c0 <__umoddi3+0x130>
  801210:	39 f7                	cmp    %esi,%edi
  801212:	0f 86 a8 00 00 00    	jbe    8012c0 <__umoddi3+0x130>
  801218:	89 c8                	mov    %ecx,%eax
  80121a:	83 c4 1c             	add    $0x1c,%esp
  80121d:	5b                   	pop    %ebx
  80121e:	5e                   	pop    %esi
  80121f:	5f                   	pop    %edi
  801220:	5d                   	pop    %ebp
  801221:	c3                   	ret    
  801222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801228:	89 e9                	mov    %ebp,%ecx
  80122a:	ba 20 00 00 00       	mov    $0x20,%edx
  80122f:	29 ea                	sub    %ebp,%edx
  801231:	d3 e0                	shl    %cl,%eax
  801233:	89 44 24 08          	mov    %eax,0x8(%esp)
  801237:	89 d1                	mov    %edx,%ecx
  801239:	89 f8                	mov    %edi,%eax
  80123b:	d3 e8                	shr    %cl,%eax
  80123d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801241:	89 54 24 04          	mov    %edx,0x4(%esp)
  801245:	8b 54 24 04          	mov    0x4(%esp),%edx
  801249:	09 c1                	or     %eax,%ecx
  80124b:	89 d8                	mov    %ebx,%eax
  80124d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801251:	89 e9                	mov    %ebp,%ecx
  801253:	d3 e7                	shl    %cl,%edi
  801255:	89 d1                	mov    %edx,%ecx
  801257:	d3 e8                	shr    %cl,%eax
  801259:	89 e9                	mov    %ebp,%ecx
  80125b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80125f:	d3 e3                	shl    %cl,%ebx
  801261:	89 c7                	mov    %eax,%edi
  801263:	89 d1                	mov    %edx,%ecx
  801265:	89 f0                	mov    %esi,%eax
  801267:	d3 e8                	shr    %cl,%eax
  801269:	89 e9                	mov    %ebp,%ecx
  80126b:	89 fa                	mov    %edi,%edx
  80126d:	d3 e6                	shl    %cl,%esi
  80126f:	09 d8                	or     %ebx,%eax
  801271:	f7 74 24 08          	divl   0x8(%esp)
  801275:	89 d1                	mov    %edx,%ecx
  801277:	89 f3                	mov    %esi,%ebx
  801279:	f7 64 24 0c          	mull   0xc(%esp)
  80127d:	89 c6                	mov    %eax,%esi
  80127f:	89 d7                	mov    %edx,%edi
  801281:	39 d1                	cmp    %edx,%ecx
  801283:	72 06                	jb     80128b <__umoddi3+0xfb>
  801285:	75 10                	jne    801297 <__umoddi3+0x107>
  801287:	39 c3                	cmp    %eax,%ebx
  801289:	73 0c                	jae    801297 <__umoddi3+0x107>
  80128b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80128f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  801293:	89 d7                	mov    %edx,%edi
  801295:	89 c6                	mov    %eax,%esi
  801297:	89 ca                	mov    %ecx,%edx
  801299:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80129e:	29 f3                	sub    %esi,%ebx
  8012a0:	19 fa                	sbb    %edi,%edx
  8012a2:	89 d0                	mov    %edx,%eax
  8012a4:	d3 e0                	shl    %cl,%eax
  8012a6:	89 e9                	mov    %ebp,%ecx
  8012a8:	d3 eb                	shr    %cl,%ebx
  8012aa:	d3 ea                	shr    %cl,%edx
  8012ac:	09 d8                	or     %ebx,%eax
  8012ae:	83 c4 1c             	add    $0x1c,%esp
  8012b1:	5b                   	pop    %ebx
  8012b2:	5e                   	pop    %esi
  8012b3:	5f                   	pop    %edi
  8012b4:	5d                   	pop    %ebp
  8012b5:	c3                   	ret    
  8012b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8012bd:	8d 76 00             	lea    0x0(%esi),%esi
  8012c0:	89 da                	mov    %ebx,%edx
  8012c2:	29 fe                	sub    %edi,%esi
  8012c4:	19 c2                	sbb    %eax,%edx
  8012c6:	89 f1                	mov    %esi,%ecx
  8012c8:	89 c8                	mov    %ecx,%eax
  8012ca:	e9 4b ff ff ff       	jmp    80121a <__umoddi3+0x8a>
