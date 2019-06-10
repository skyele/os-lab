
obj/user/spawnhello.debug:     file format elf32-i386


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
  80002c:	e8 4a 00 00 00       	call   80007b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800039:	a1 08 50 80 00       	mov    0x805008,%eax
  80003e:	8b 40 48             	mov    0x48(%eax),%eax
  800041:	50                   	push   %eax
  800042:	68 c0 2b 80 00       	push   $0x802bc0
  800047:	e8 32 02 00 00       	call   80027e <cprintf>
	if ((r = spawnl("hello", "hello", 0)) < 0)
  80004c:	83 c4 0c             	add    $0xc,%esp
  80004f:	6a 00                	push   $0x0
  800051:	68 de 2b 80 00       	push   $0x802bde
  800056:	68 de 2b 80 00       	push   $0x802bde
  80005b:	e8 1d 1e 00 00       	call   801e7d <spawnl>
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	85 c0                	test   %eax,%eax
  800065:	78 02                	js     800069 <umain+0x36>
		panic("spawn(hello) failed: %e", r);
}
  800067:	c9                   	leave  
  800068:	c3                   	ret    
		panic("spawn(hello) failed: %e", r);
  800069:	50                   	push   %eax
  80006a:	68 e4 2b 80 00       	push   $0x802be4
  80006f:	6a 09                	push   $0x9
  800071:	68 fc 2b 80 00       	push   $0x802bfc
  800076:	e8 0d 01 00 00       	call   800188 <_panic>

0080007b <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80007b:	55                   	push   %ebp
  80007c:	89 e5                	mov    %esp,%ebp
  80007e:	57                   	push   %edi
  80007f:	56                   	push   %esi
  800080:	53                   	push   %ebx
  800081:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800084:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  80008b:	00 00 00 
	envid_t find = sys_getenvid();
  80008e:	e8 fe 0c 00 00       	call   800d91 <sys_getenvid>
  800093:	8b 1d 08 50 80 00    	mov    0x805008,%ebx
  800099:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  80009e:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8000a3:	bf 01 00 00 00       	mov    $0x1,%edi
  8000a8:	eb 0b                	jmp    8000b5 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8000aa:	83 c2 01             	add    $0x1,%edx
  8000ad:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000b3:	74 21                	je     8000d6 <libmain+0x5b>
		if(envs[i].env_id == find)
  8000b5:	89 d1                	mov    %edx,%ecx
  8000b7:	c1 e1 07             	shl    $0x7,%ecx
  8000ba:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000c0:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000c3:	39 c1                	cmp    %eax,%ecx
  8000c5:	75 e3                	jne    8000aa <libmain+0x2f>
  8000c7:	89 d3                	mov    %edx,%ebx
  8000c9:	c1 e3 07             	shl    $0x7,%ebx
  8000cc:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000d2:	89 fe                	mov    %edi,%esi
  8000d4:	eb d4                	jmp    8000aa <libmain+0x2f>
  8000d6:	89 f0                	mov    %esi,%eax
  8000d8:	84 c0                	test   %al,%al
  8000da:	74 06                	je     8000e2 <libmain+0x67>
  8000dc:	89 1d 08 50 80 00    	mov    %ebx,0x805008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000e6:	7e 0a                	jle    8000f2 <libmain+0x77>
		binaryname = argv[0];
  8000e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000eb:	8b 00                	mov    (%eax),%eax
  8000ed:	a3 00 40 80 00       	mov    %eax,0x804000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8000f2:	a1 08 50 80 00       	mov    0x805008,%eax
  8000f7:	8b 40 48             	mov    0x48(%eax),%eax
  8000fa:	83 ec 08             	sub    $0x8,%esp
  8000fd:	50                   	push   %eax
  8000fe:	68 0e 2c 80 00       	push   $0x802c0e
  800103:	e8 76 01 00 00       	call   80027e <cprintf>
	cprintf("before umain\n");
  800108:	c7 04 24 2c 2c 80 00 	movl   $0x802c2c,(%esp)
  80010f:	e8 6a 01 00 00       	call   80027e <cprintf>
	// call user main routine
	umain(argc, argv);
  800114:	83 c4 08             	add    $0x8,%esp
  800117:	ff 75 0c             	pushl  0xc(%ebp)
  80011a:	ff 75 08             	pushl  0x8(%ebp)
  80011d:	e8 11 ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800122:	c7 04 24 3a 2c 80 00 	movl   $0x802c3a,(%esp)
  800129:	e8 50 01 00 00       	call   80027e <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80012e:	a1 08 50 80 00       	mov    0x805008,%eax
  800133:	8b 40 48             	mov    0x48(%eax),%eax
  800136:	83 c4 08             	add    $0x8,%esp
  800139:	50                   	push   %eax
  80013a:	68 47 2c 80 00       	push   $0x802c47
  80013f:	e8 3a 01 00 00       	call   80027e <cprintf>
	// exit gracefully
	exit();
  800144:	e8 0b 00 00 00       	call   800154 <exit>
}
  800149:	83 c4 10             	add    $0x10,%esp
  80014c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80014f:	5b                   	pop    %ebx
  800150:	5e                   	pop    %esi
  800151:	5f                   	pop    %edi
  800152:	5d                   	pop    %ebp
  800153:	c3                   	ret    

00800154 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80015a:	a1 08 50 80 00       	mov    0x805008,%eax
  80015f:	8b 40 48             	mov    0x48(%eax),%eax
  800162:	68 74 2c 80 00       	push   $0x802c74
  800167:	50                   	push   %eax
  800168:	68 66 2c 80 00       	push   $0x802c66
  80016d:	e8 0c 01 00 00       	call   80027e <cprintf>
	close_all();
  800172:	e8 25 11 00 00       	call   80129c <close_all>
	sys_env_destroy(0);
  800177:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80017e:	e8 cd 0b 00 00       	call   800d50 <sys_env_destroy>
}
  800183:	83 c4 10             	add    $0x10,%esp
  800186:	c9                   	leave  
  800187:	c3                   	ret    

00800188 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800188:	55                   	push   %ebp
  800189:	89 e5                	mov    %esp,%ebp
  80018b:	56                   	push   %esi
  80018c:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80018d:	a1 08 50 80 00       	mov    0x805008,%eax
  800192:	8b 40 48             	mov    0x48(%eax),%eax
  800195:	83 ec 04             	sub    $0x4,%esp
  800198:	68 a0 2c 80 00       	push   $0x802ca0
  80019d:	50                   	push   %eax
  80019e:	68 66 2c 80 00       	push   $0x802c66
  8001a3:	e8 d6 00 00 00       	call   80027e <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8001a8:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001ab:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8001b1:	e8 db 0b 00 00       	call   800d91 <sys_getenvid>
  8001b6:	83 c4 04             	add    $0x4,%esp
  8001b9:	ff 75 0c             	pushl  0xc(%ebp)
  8001bc:	ff 75 08             	pushl  0x8(%ebp)
  8001bf:	56                   	push   %esi
  8001c0:	50                   	push   %eax
  8001c1:	68 7c 2c 80 00       	push   $0x802c7c
  8001c6:	e8 b3 00 00 00       	call   80027e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001cb:	83 c4 18             	add    $0x18,%esp
  8001ce:	53                   	push   %ebx
  8001cf:	ff 75 10             	pushl  0x10(%ebp)
  8001d2:	e8 56 00 00 00       	call   80022d <vcprintf>
	cprintf("\n");
  8001d7:	c7 04 24 2a 2c 80 00 	movl   $0x802c2a,(%esp)
  8001de:	e8 9b 00 00 00       	call   80027e <cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001e6:	cc                   	int3   
  8001e7:	eb fd                	jmp    8001e6 <_panic+0x5e>

008001e9 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001e9:	55                   	push   %ebp
  8001ea:	89 e5                	mov    %esp,%ebp
  8001ec:	53                   	push   %ebx
  8001ed:	83 ec 04             	sub    $0x4,%esp
  8001f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001f3:	8b 13                	mov    (%ebx),%edx
  8001f5:	8d 42 01             	lea    0x1(%edx),%eax
  8001f8:	89 03                	mov    %eax,(%ebx)
  8001fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001fd:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800201:	3d ff 00 00 00       	cmp    $0xff,%eax
  800206:	74 09                	je     800211 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800208:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80020c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80020f:	c9                   	leave  
  800210:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800211:	83 ec 08             	sub    $0x8,%esp
  800214:	68 ff 00 00 00       	push   $0xff
  800219:	8d 43 08             	lea    0x8(%ebx),%eax
  80021c:	50                   	push   %eax
  80021d:	e8 f1 0a 00 00       	call   800d13 <sys_cputs>
		b->idx = 0;
  800222:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	eb db                	jmp    800208 <putch+0x1f>

0080022d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80022d:	55                   	push   %ebp
  80022e:	89 e5                	mov    %esp,%ebp
  800230:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800236:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80023d:	00 00 00 
	b.cnt = 0;
  800240:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800247:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80024a:	ff 75 0c             	pushl  0xc(%ebp)
  80024d:	ff 75 08             	pushl  0x8(%ebp)
  800250:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800256:	50                   	push   %eax
  800257:	68 e9 01 80 00       	push   $0x8001e9
  80025c:	e8 4a 01 00 00       	call   8003ab <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800261:	83 c4 08             	add    $0x8,%esp
  800264:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80026a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800270:	50                   	push   %eax
  800271:	e8 9d 0a 00 00       	call   800d13 <sys_cputs>

	return b.cnt;
}
  800276:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80027c:	c9                   	leave  
  80027d:	c3                   	ret    

0080027e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80027e:	55                   	push   %ebp
  80027f:	89 e5                	mov    %esp,%ebp
  800281:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800284:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800287:	50                   	push   %eax
  800288:	ff 75 08             	pushl  0x8(%ebp)
  80028b:	e8 9d ff ff ff       	call   80022d <vcprintf>
	va_end(ap);

	return cnt;
}
  800290:	c9                   	leave  
  800291:	c3                   	ret    

00800292 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  800295:	57                   	push   %edi
  800296:	56                   	push   %esi
  800297:	53                   	push   %ebx
  800298:	83 ec 1c             	sub    $0x1c,%esp
  80029b:	89 c6                	mov    %eax,%esi
  80029d:	89 d7                	mov    %edx,%edi
  80029f:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002a8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ae:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8002b1:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002b5:	74 2c                	je     8002e3 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8002b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002ba:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002c4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002c7:	39 c2                	cmp    %eax,%edx
  8002c9:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002cc:	73 43                	jae    800311 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002ce:	83 eb 01             	sub    $0x1,%ebx
  8002d1:	85 db                	test   %ebx,%ebx
  8002d3:	7e 6c                	jle    800341 <printnum+0xaf>
				putch(padc, putdat);
  8002d5:	83 ec 08             	sub    $0x8,%esp
  8002d8:	57                   	push   %edi
  8002d9:	ff 75 18             	pushl  0x18(%ebp)
  8002dc:	ff d6                	call   *%esi
  8002de:	83 c4 10             	add    $0x10,%esp
  8002e1:	eb eb                	jmp    8002ce <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002e3:	83 ec 0c             	sub    $0xc,%esp
  8002e6:	6a 20                	push   $0x20
  8002e8:	6a 00                	push   $0x0
  8002ea:	50                   	push   %eax
  8002eb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ee:	ff 75 e0             	pushl  -0x20(%ebp)
  8002f1:	89 fa                	mov    %edi,%edx
  8002f3:	89 f0                	mov    %esi,%eax
  8002f5:	e8 98 ff ff ff       	call   800292 <printnum>
		while (--width > 0)
  8002fa:	83 c4 20             	add    $0x20,%esp
  8002fd:	83 eb 01             	sub    $0x1,%ebx
  800300:	85 db                	test   %ebx,%ebx
  800302:	7e 65                	jle    800369 <printnum+0xd7>
			putch(padc, putdat);
  800304:	83 ec 08             	sub    $0x8,%esp
  800307:	57                   	push   %edi
  800308:	6a 20                	push   $0x20
  80030a:	ff d6                	call   *%esi
  80030c:	83 c4 10             	add    $0x10,%esp
  80030f:	eb ec                	jmp    8002fd <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800311:	83 ec 0c             	sub    $0xc,%esp
  800314:	ff 75 18             	pushl  0x18(%ebp)
  800317:	83 eb 01             	sub    $0x1,%ebx
  80031a:	53                   	push   %ebx
  80031b:	50                   	push   %eax
  80031c:	83 ec 08             	sub    $0x8,%esp
  80031f:	ff 75 dc             	pushl  -0x24(%ebp)
  800322:	ff 75 d8             	pushl  -0x28(%ebp)
  800325:	ff 75 e4             	pushl  -0x1c(%ebp)
  800328:	ff 75 e0             	pushl  -0x20(%ebp)
  80032b:	e8 40 26 00 00       	call   802970 <__udivdi3>
  800330:	83 c4 18             	add    $0x18,%esp
  800333:	52                   	push   %edx
  800334:	50                   	push   %eax
  800335:	89 fa                	mov    %edi,%edx
  800337:	89 f0                	mov    %esi,%eax
  800339:	e8 54 ff ff ff       	call   800292 <printnum>
  80033e:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800341:	83 ec 08             	sub    $0x8,%esp
  800344:	57                   	push   %edi
  800345:	83 ec 04             	sub    $0x4,%esp
  800348:	ff 75 dc             	pushl  -0x24(%ebp)
  80034b:	ff 75 d8             	pushl  -0x28(%ebp)
  80034e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800351:	ff 75 e0             	pushl  -0x20(%ebp)
  800354:	e8 27 27 00 00       	call   802a80 <__umoddi3>
  800359:	83 c4 14             	add    $0x14,%esp
  80035c:	0f be 80 a7 2c 80 00 	movsbl 0x802ca7(%eax),%eax
  800363:	50                   	push   %eax
  800364:	ff d6                	call   *%esi
  800366:	83 c4 10             	add    $0x10,%esp
	}
}
  800369:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80036c:	5b                   	pop    %ebx
  80036d:	5e                   	pop    %esi
  80036e:	5f                   	pop    %edi
  80036f:	5d                   	pop    %ebp
  800370:	c3                   	ret    

00800371 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800371:	55                   	push   %ebp
  800372:	89 e5                	mov    %esp,%ebp
  800374:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800377:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80037b:	8b 10                	mov    (%eax),%edx
  80037d:	3b 50 04             	cmp    0x4(%eax),%edx
  800380:	73 0a                	jae    80038c <sprintputch+0x1b>
		*b->buf++ = ch;
  800382:	8d 4a 01             	lea    0x1(%edx),%ecx
  800385:	89 08                	mov    %ecx,(%eax)
  800387:	8b 45 08             	mov    0x8(%ebp),%eax
  80038a:	88 02                	mov    %al,(%edx)
}
  80038c:	5d                   	pop    %ebp
  80038d:	c3                   	ret    

0080038e <printfmt>:
{
  80038e:	55                   	push   %ebp
  80038f:	89 e5                	mov    %esp,%ebp
  800391:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800394:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800397:	50                   	push   %eax
  800398:	ff 75 10             	pushl  0x10(%ebp)
  80039b:	ff 75 0c             	pushl  0xc(%ebp)
  80039e:	ff 75 08             	pushl  0x8(%ebp)
  8003a1:	e8 05 00 00 00       	call   8003ab <vprintfmt>
}
  8003a6:	83 c4 10             	add    $0x10,%esp
  8003a9:	c9                   	leave  
  8003aa:	c3                   	ret    

008003ab <vprintfmt>:
{
  8003ab:	55                   	push   %ebp
  8003ac:	89 e5                	mov    %esp,%ebp
  8003ae:	57                   	push   %edi
  8003af:	56                   	push   %esi
  8003b0:	53                   	push   %ebx
  8003b1:	83 ec 3c             	sub    $0x3c,%esp
  8003b4:	8b 75 08             	mov    0x8(%ebp),%esi
  8003b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003ba:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003bd:	e9 32 04 00 00       	jmp    8007f4 <vprintfmt+0x449>
		padc = ' ';
  8003c2:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003c6:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003cd:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003d4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003db:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003e2:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003e9:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003ee:	8d 47 01             	lea    0x1(%edi),%eax
  8003f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003f4:	0f b6 17             	movzbl (%edi),%edx
  8003f7:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003fa:	3c 55                	cmp    $0x55,%al
  8003fc:	0f 87 12 05 00 00    	ja     800914 <vprintfmt+0x569>
  800402:	0f b6 c0             	movzbl %al,%eax
  800405:	ff 24 85 80 2e 80 00 	jmp    *0x802e80(,%eax,4)
  80040c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80040f:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800413:	eb d9                	jmp    8003ee <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800415:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800418:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80041c:	eb d0                	jmp    8003ee <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80041e:	0f b6 d2             	movzbl %dl,%edx
  800421:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800424:	b8 00 00 00 00       	mov    $0x0,%eax
  800429:	89 75 08             	mov    %esi,0x8(%ebp)
  80042c:	eb 03                	jmp    800431 <vprintfmt+0x86>
  80042e:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800431:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800434:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800438:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80043b:	8d 72 d0             	lea    -0x30(%edx),%esi
  80043e:	83 fe 09             	cmp    $0x9,%esi
  800441:	76 eb                	jbe    80042e <vprintfmt+0x83>
  800443:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800446:	8b 75 08             	mov    0x8(%ebp),%esi
  800449:	eb 14                	jmp    80045f <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  80044b:	8b 45 14             	mov    0x14(%ebp),%eax
  80044e:	8b 00                	mov    (%eax),%eax
  800450:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800453:	8b 45 14             	mov    0x14(%ebp),%eax
  800456:	8d 40 04             	lea    0x4(%eax),%eax
  800459:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80045c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80045f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800463:	79 89                	jns    8003ee <vprintfmt+0x43>
				width = precision, precision = -1;
  800465:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800468:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80046b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800472:	e9 77 ff ff ff       	jmp    8003ee <vprintfmt+0x43>
  800477:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80047a:	85 c0                	test   %eax,%eax
  80047c:	0f 48 c1             	cmovs  %ecx,%eax
  80047f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800482:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800485:	e9 64 ff ff ff       	jmp    8003ee <vprintfmt+0x43>
  80048a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80048d:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800494:	e9 55 ff ff ff       	jmp    8003ee <vprintfmt+0x43>
			lflag++;
  800499:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80049d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004a0:	e9 49 ff ff ff       	jmp    8003ee <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a8:	8d 78 04             	lea    0x4(%eax),%edi
  8004ab:	83 ec 08             	sub    $0x8,%esp
  8004ae:	53                   	push   %ebx
  8004af:	ff 30                	pushl  (%eax)
  8004b1:	ff d6                	call   *%esi
			break;
  8004b3:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004b6:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004b9:	e9 33 03 00 00       	jmp    8007f1 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004be:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c1:	8d 78 04             	lea    0x4(%eax),%edi
  8004c4:	8b 00                	mov    (%eax),%eax
  8004c6:	99                   	cltd   
  8004c7:	31 d0                	xor    %edx,%eax
  8004c9:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004cb:	83 f8 11             	cmp    $0x11,%eax
  8004ce:	7f 23                	jg     8004f3 <vprintfmt+0x148>
  8004d0:	8b 14 85 e0 2f 80 00 	mov    0x802fe0(,%eax,4),%edx
  8004d7:	85 d2                	test   %edx,%edx
  8004d9:	74 18                	je     8004f3 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004db:	52                   	push   %edx
  8004dc:	68 fd 30 80 00       	push   $0x8030fd
  8004e1:	53                   	push   %ebx
  8004e2:	56                   	push   %esi
  8004e3:	e8 a6 fe ff ff       	call   80038e <printfmt>
  8004e8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004eb:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004ee:	e9 fe 02 00 00       	jmp    8007f1 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004f3:	50                   	push   %eax
  8004f4:	68 bf 2c 80 00       	push   $0x802cbf
  8004f9:	53                   	push   %ebx
  8004fa:	56                   	push   %esi
  8004fb:	e8 8e fe ff ff       	call   80038e <printfmt>
  800500:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800503:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800506:	e9 e6 02 00 00       	jmp    8007f1 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80050b:	8b 45 14             	mov    0x14(%ebp),%eax
  80050e:	83 c0 04             	add    $0x4,%eax
  800511:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800514:	8b 45 14             	mov    0x14(%ebp),%eax
  800517:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800519:	85 c9                	test   %ecx,%ecx
  80051b:	b8 b8 2c 80 00       	mov    $0x802cb8,%eax
  800520:	0f 45 c1             	cmovne %ecx,%eax
  800523:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800526:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80052a:	7e 06                	jle    800532 <vprintfmt+0x187>
  80052c:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800530:	75 0d                	jne    80053f <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800532:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800535:	89 c7                	mov    %eax,%edi
  800537:	03 45 e0             	add    -0x20(%ebp),%eax
  80053a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80053d:	eb 53                	jmp    800592 <vprintfmt+0x1e7>
  80053f:	83 ec 08             	sub    $0x8,%esp
  800542:	ff 75 d8             	pushl  -0x28(%ebp)
  800545:	50                   	push   %eax
  800546:	e8 71 04 00 00       	call   8009bc <strnlen>
  80054b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80054e:	29 c1                	sub    %eax,%ecx
  800550:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800553:	83 c4 10             	add    $0x10,%esp
  800556:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800558:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  80055c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80055f:	eb 0f                	jmp    800570 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800561:	83 ec 08             	sub    $0x8,%esp
  800564:	53                   	push   %ebx
  800565:	ff 75 e0             	pushl  -0x20(%ebp)
  800568:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80056a:	83 ef 01             	sub    $0x1,%edi
  80056d:	83 c4 10             	add    $0x10,%esp
  800570:	85 ff                	test   %edi,%edi
  800572:	7f ed                	jg     800561 <vprintfmt+0x1b6>
  800574:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800577:	85 c9                	test   %ecx,%ecx
  800579:	b8 00 00 00 00       	mov    $0x0,%eax
  80057e:	0f 49 c1             	cmovns %ecx,%eax
  800581:	29 c1                	sub    %eax,%ecx
  800583:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800586:	eb aa                	jmp    800532 <vprintfmt+0x187>
					putch(ch, putdat);
  800588:	83 ec 08             	sub    $0x8,%esp
  80058b:	53                   	push   %ebx
  80058c:	52                   	push   %edx
  80058d:	ff d6                	call   *%esi
  80058f:	83 c4 10             	add    $0x10,%esp
  800592:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800595:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800597:	83 c7 01             	add    $0x1,%edi
  80059a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80059e:	0f be d0             	movsbl %al,%edx
  8005a1:	85 d2                	test   %edx,%edx
  8005a3:	74 4b                	je     8005f0 <vprintfmt+0x245>
  8005a5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005a9:	78 06                	js     8005b1 <vprintfmt+0x206>
  8005ab:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005af:	78 1e                	js     8005cf <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8005b1:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005b5:	74 d1                	je     800588 <vprintfmt+0x1dd>
  8005b7:	0f be c0             	movsbl %al,%eax
  8005ba:	83 e8 20             	sub    $0x20,%eax
  8005bd:	83 f8 5e             	cmp    $0x5e,%eax
  8005c0:	76 c6                	jbe    800588 <vprintfmt+0x1dd>
					putch('?', putdat);
  8005c2:	83 ec 08             	sub    $0x8,%esp
  8005c5:	53                   	push   %ebx
  8005c6:	6a 3f                	push   $0x3f
  8005c8:	ff d6                	call   *%esi
  8005ca:	83 c4 10             	add    $0x10,%esp
  8005cd:	eb c3                	jmp    800592 <vprintfmt+0x1e7>
  8005cf:	89 cf                	mov    %ecx,%edi
  8005d1:	eb 0e                	jmp    8005e1 <vprintfmt+0x236>
				putch(' ', putdat);
  8005d3:	83 ec 08             	sub    $0x8,%esp
  8005d6:	53                   	push   %ebx
  8005d7:	6a 20                	push   $0x20
  8005d9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005db:	83 ef 01             	sub    $0x1,%edi
  8005de:	83 c4 10             	add    $0x10,%esp
  8005e1:	85 ff                	test   %edi,%edi
  8005e3:	7f ee                	jg     8005d3 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005e5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005eb:	e9 01 02 00 00       	jmp    8007f1 <vprintfmt+0x446>
  8005f0:	89 cf                	mov    %ecx,%edi
  8005f2:	eb ed                	jmp    8005e1 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005f7:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005fe:	e9 eb fd ff ff       	jmp    8003ee <vprintfmt+0x43>
	if (lflag >= 2)
  800603:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800607:	7f 21                	jg     80062a <vprintfmt+0x27f>
	else if (lflag)
  800609:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80060d:	74 68                	je     800677 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80060f:	8b 45 14             	mov    0x14(%ebp),%eax
  800612:	8b 00                	mov    (%eax),%eax
  800614:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800617:	89 c1                	mov    %eax,%ecx
  800619:	c1 f9 1f             	sar    $0x1f,%ecx
  80061c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80061f:	8b 45 14             	mov    0x14(%ebp),%eax
  800622:	8d 40 04             	lea    0x4(%eax),%eax
  800625:	89 45 14             	mov    %eax,0x14(%ebp)
  800628:	eb 17                	jmp    800641 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80062a:	8b 45 14             	mov    0x14(%ebp),%eax
  80062d:	8b 50 04             	mov    0x4(%eax),%edx
  800630:	8b 00                	mov    (%eax),%eax
  800632:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800635:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	8d 40 08             	lea    0x8(%eax),%eax
  80063e:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800641:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800644:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800647:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  80064d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800651:	78 3f                	js     800692 <vprintfmt+0x2e7>
			base = 10;
  800653:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800658:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  80065c:	0f 84 71 01 00 00    	je     8007d3 <vprintfmt+0x428>
				putch('+', putdat);
  800662:	83 ec 08             	sub    $0x8,%esp
  800665:	53                   	push   %ebx
  800666:	6a 2b                	push   $0x2b
  800668:	ff d6                	call   *%esi
  80066a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80066d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800672:	e9 5c 01 00 00       	jmp    8007d3 <vprintfmt+0x428>
		return va_arg(*ap, int);
  800677:	8b 45 14             	mov    0x14(%ebp),%eax
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80067f:	89 c1                	mov    %eax,%ecx
  800681:	c1 f9 1f             	sar    $0x1f,%ecx
  800684:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800687:	8b 45 14             	mov    0x14(%ebp),%eax
  80068a:	8d 40 04             	lea    0x4(%eax),%eax
  80068d:	89 45 14             	mov    %eax,0x14(%ebp)
  800690:	eb af                	jmp    800641 <vprintfmt+0x296>
				putch('-', putdat);
  800692:	83 ec 08             	sub    $0x8,%esp
  800695:	53                   	push   %ebx
  800696:	6a 2d                	push   $0x2d
  800698:	ff d6                	call   *%esi
				num = -(long long) num;
  80069a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80069d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006a0:	f7 d8                	neg    %eax
  8006a2:	83 d2 00             	adc    $0x0,%edx
  8006a5:	f7 da                	neg    %edx
  8006a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ad:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006b0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b5:	e9 19 01 00 00       	jmp    8007d3 <vprintfmt+0x428>
	if (lflag >= 2)
  8006ba:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006be:	7f 29                	jg     8006e9 <vprintfmt+0x33e>
	else if (lflag)
  8006c0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006c4:	74 44                	je     80070a <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c9:	8b 00                	mov    (%eax),%eax
  8006cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	8d 40 04             	lea    0x4(%eax),%eax
  8006dc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006df:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006e4:	e9 ea 00 00 00       	jmp    8007d3 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ec:	8b 50 04             	mov    0x4(%eax),%edx
  8006ef:	8b 00                	mov    (%eax),%eax
  8006f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fa:	8d 40 08             	lea    0x8(%eax),%eax
  8006fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800700:	b8 0a 00 00 00       	mov    $0xa,%eax
  800705:	e9 c9 00 00 00       	jmp    8007d3 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80070a:	8b 45 14             	mov    0x14(%ebp),%eax
  80070d:	8b 00                	mov    (%eax),%eax
  80070f:	ba 00 00 00 00       	mov    $0x0,%edx
  800714:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800717:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80071a:	8b 45 14             	mov    0x14(%ebp),%eax
  80071d:	8d 40 04             	lea    0x4(%eax),%eax
  800720:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800723:	b8 0a 00 00 00       	mov    $0xa,%eax
  800728:	e9 a6 00 00 00       	jmp    8007d3 <vprintfmt+0x428>
			putch('0', putdat);
  80072d:	83 ec 08             	sub    $0x8,%esp
  800730:	53                   	push   %ebx
  800731:	6a 30                	push   $0x30
  800733:	ff d6                	call   *%esi
	if (lflag >= 2)
  800735:	83 c4 10             	add    $0x10,%esp
  800738:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80073c:	7f 26                	jg     800764 <vprintfmt+0x3b9>
	else if (lflag)
  80073e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800742:	74 3e                	je     800782 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  800744:	8b 45 14             	mov    0x14(%ebp),%eax
  800747:	8b 00                	mov    (%eax),%eax
  800749:	ba 00 00 00 00       	mov    $0x0,%edx
  80074e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800751:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800754:	8b 45 14             	mov    0x14(%ebp),%eax
  800757:	8d 40 04             	lea    0x4(%eax),%eax
  80075a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80075d:	b8 08 00 00 00       	mov    $0x8,%eax
  800762:	eb 6f                	jmp    8007d3 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	8b 50 04             	mov    0x4(%eax),%edx
  80076a:	8b 00                	mov    (%eax),%eax
  80076c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800772:	8b 45 14             	mov    0x14(%ebp),%eax
  800775:	8d 40 08             	lea    0x8(%eax),%eax
  800778:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80077b:	b8 08 00 00 00       	mov    $0x8,%eax
  800780:	eb 51                	jmp    8007d3 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800782:	8b 45 14             	mov    0x14(%ebp),%eax
  800785:	8b 00                	mov    (%eax),%eax
  800787:	ba 00 00 00 00       	mov    $0x0,%edx
  80078c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800792:	8b 45 14             	mov    0x14(%ebp),%eax
  800795:	8d 40 04             	lea    0x4(%eax),%eax
  800798:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80079b:	b8 08 00 00 00       	mov    $0x8,%eax
  8007a0:	eb 31                	jmp    8007d3 <vprintfmt+0x428>
			putch('0', putdat);
  8007a2:	83 ec 08             	sub    $0x8,%esp
  8007a5:	53                   	push   %ebx
  8007a6:	6a 30                	push   $0x30
  8007a8:	ff d6                	call   *%esi
			putch('x', putdat);
  8007aa:	83 c4 08             	add    $0x8,%esp
  8007ad:	53                   	push   %ebx
  8007ae:	6a 78                	push   $0x78
  8007b0:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	8b 00                	mov    (%eax),%eax
  8007b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007c2:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	8d 40 04             	lea    0x4(%eax),%eax
  8007cb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ce:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007d3:	83 ec 0c             	sub    $0xc,%esp
  8007d6:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007da:	52                   	push   %edx
  8007db:	ff 75 e0             	pushl  -0x20(%ebp)
  8007de:	50                   	push   %eax
  8007df:	ff 75 dc             	pushl  -0x24(%ebp)
  8007e2:	ff 75 d8             	pushl  -0x28(%ebp)
  8007e5:	89 da                	mov    %ebx,%edx
  8007e7:	89 f0                	mov    %esi,%eax
  8007e9:	e8 a4 fa ff ff       	call   800292 <printnum>
			break;
  8007ee:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007f4:	83 c7 01             	add    $0x1,%edi
  8007f7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007fb:	83 f8 25             	cmp    $0x25,%eax
  8007fe:	0f 84 be fb ff ff    	je     8003c2 <vprintfmt+0x17>
			if (ch == '\0')
  800804:	85 c0                	test   %eax,%eax
  800806:	0f 84 28 01 00 00    	je     800934 <vprintfmt+0x589>
			putch(ch, putdat);
  80080c:	83 ec 08             	sub    $0x8,%esp
  80080f:	53                   	push   %ebx
  800810:	50                   	push   %eax
  800811:	ff d6                	call   *%esi
  800813:	83 c4 10             	add    $0x10,%esp
  800816:	eb dc                	jmp    8007f4 <vprintfmt+0x449>
	if (lflag >= 2)
  800818:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80081c:	7f 26                	jg     800844 <vprintfmt+0x499>
	else if (lflag)
  80081e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800822:	74 41                	je     800865 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	8b 00                	mov    (%eax),%eax
  800829:	ba 00 00 00 00       	mov    $0x0,%edx
  80082e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800831:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800834:	8b 45 14             	mov    0x14(%ebp),%eax
  800837:	8d 40 04             	lea    0x4(%eax),%eax
  80083a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80083d:	b8 10 00 00 00       	mov    $0x10,%eax
  800842:	eb 8f                	jmp    8007d3 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800844:	8b 45 14             	mov    0x14(%ebp),%eax
  800847:	8b 50 04             	mov    0x4(%eax),%edx
  80084a:	8b 00                	mov    (%eax),%eax
  80084c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80084f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	8d 40 08             	lea    0x8(%eax),%eax
  800858:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80085b:	b8 10 00 00 00       	mov    $0x10,%eax
  800860:	e9 6e ff ff ff       	jmp    8007d3 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800865:	8b 45 14             	mov    0x14(%ebp),%eax
  800868:	8b 00                	mov    (%eax),%eax
  80086a:	ba 00 00 00 00       	mov    $0x0,%edx
  80086f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800872:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	8d 40 04             	lea    0x4(%eax),%eax
  80087b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80087e:	b8 10 00 00 00       	mov    $0x10,%eax
  800883:	e9 4b ff ff ff       	jmp    8007d3 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800888:	8b 45 14             	mov    0x14(%ebp),%eax
  80088b:	83 c0 04             	add    $0x4,%eax
  80088e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	85 c0                	test   %eax,%eax
  800898:	74 14                	je     8008ae <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80089a:	8b 13                	mov    (%ebx),%edx
  80089c:	83 fa 7f             	cmp    $0x7f,%edx
  80089f:	7f 37                	jg     8008d8 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8008a1:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8008a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008a6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a9:	e9 43 ff ff ff       	jmp    8007f1 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8008ae:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008b3:	bf dd 2d 80 00       	mov    $0x802ddd,%edi
							putch(ch, putdat);
  8008b8:	83 ec 08             	sub    $0x8,%esp
  8008bb:	53                   	push   %ebx
  8008bc:	50                   	push   %eax
  8008bd:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008bf:	83 c7 01             	add    $0x1,%edi
  8008c2:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008c6:	83 c4 10             	add    $0x10,%esp
  8008c9:	85 c0                	test   %eax,%eax
  8008cb:	75 eb                	jne    8008b8 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d3:	e9 19 ff ff ff       	jmp    8007f1 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008d8:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008da:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008df:	bf 15 2e 80 00       	mov    $0x802e15,%edi
							putch(ch, putdat);
  8008e4:	83 ec 08             	sub    $0x8,%esp
  8008e7:	53                   	push   %ebx
  8008e8:	50                   	push   %eax
  8008e9:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008eb:	83 c7 01             	add    $0x1,%edi
  8008ee:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008f2:	83 c4 10             	add    $0x10,%esp
  8008f5:	85 c0                	test   %eax,%eax
  8008f7:	75 eb                	jne    8008e4 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ff:	e9 ed fe ff ff       	jmp    8007f1 <vprintfmt+0x446>
			putch(ch, putdat);
  800904:	83 ec 08             	sub    $0x8,%esp
  800907:	53                   	push   %ebx
  800908:	6a 25                	push   $0x25
  80090a:	ff d6                	call   *%esi
			break;
  80090c:	83 c4 10             	add    $0x10,%esp
  80090f:	e9 dd fe ff ff       	jmp    8007f1 <vprintfmt+0x446>
			putch('%', putdat);
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	53                   	push   %ebx
  800918:	6a 25                	push   $0x25
  80091a:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80091c:	83 c4 10             	add    $0x10,%esp
  80091f:	89 f8                	mov    %edi,%eax
  800921:	eb 03                	jmp    800926 <vprintfmt+0x57b>
  800923:	83 e8 01             	sub    $0x1,%eax
  800926:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80092a:	75 f7                	jne    800923 <vprintfmt+0x578>
  80092c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80092f:	e9 bd fe ff ff       	jmp    8007f1 <vprintfmt+0x446>
}
  800934:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800937:	5b                   	pop    %ebx
  800938:	5e                   	pop    %esi
  800939:	5f                   	pop    %edi
  80093a:	5d                   	pop    %ebp
  80093b:	c3                   	ret    

0080093c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
  80093f:	83 ec 18             	sub    $0x18,%esp
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800948:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80094b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80094f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800952:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800959:	85 c0                	test   %eax,%eax
  80095b:	74 26                	je     800983 <vsnprintf+0x47>
  80095d:	85 d2                	test   %edx,%edx
  80095f:	7e 22                	jle    800983 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800961:	ff 75 14             	pushl  0x14(%ebp)
  800964:	ff 75 10             	pushl  0x10(%ebp)
  800967:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80096a:	50                   	push   %eax
  80096b:	68 71 03 80 00       	push   $0x800371
  800970:	e8 36 fa ff ff       	call   8003ab <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800975:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800978:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80097b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80097e:	83 c4 10             	add    $0x10,%esp
}
  800981:	c9                   	leave  
  800982:	c3                   	ret    
		return -E_INVAL;
  800983:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800988:	eb f7                	jmp    800981 <vsnprintf+0x45>

0080098a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800990:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800993:	50                   	push   %eax
  800994:	ff 75 10             	pushl  0x10(%ebp)
  800997:	ff 75 0c             	pushl  0xc(%ebp)
  80099a:	ff 75 08             	pushl  0x8(%ebp)
  80099d:	e8 9a ff ff ff       	call   80093c <vsnprintf>
	va_end(ap);

	return rc;
}
  8009a2:	c9                   	leave  
  8009a3:	c3                   	ret    

008009a4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
  8009a7:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8009af:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009b3:	74 05                	je     8009ba <strlen+0x16>
		n++;
  8009b5:	83 c0 01             	add    $0x1,%eax
  8009b8:	eb f5                	jmp    8009af <strlen+0xb>
	return n;
}
  8009ba:	5d                   	pop    %ebp
  8009bb:	c3                   	ret    

008009bc <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009c2:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ca:	39 c2                	cmp    %eax,%edx
  8009cc:	74 0d                	je     8009db <strnlen+0x1f>
  8009ce:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009d2:	74 05                	je     8009d9 <strnlen+0x1d>
		n++;
  8009d4:	83 c2 01             	add    $0x1,%edx
  8009d7:	eb f1                	jmp    8009ca <strnlen+0xe>
  8009d9:	89 d0                	mov    %edx,%eax
	return n;
}
  8009db:	5d                   	pop    %ebp
  8009dc:	c3                   	ret    

008009dd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009dd:	55                   	push   %ebp
  8009de:	89 e5                	mov    %esp,%ebp
  8009e0:	53                   	push   %ebx
  8009e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ec:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009f0:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009f3:	83 c2 01             	add    $0x1,%edx
  8009f6:	84 c9                	test   %cl,%cl
  8009f8:	75 f2                	jne    8009ec <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009fa:	5b                   	pop    %ebx
  8009fb:	5d                   	pop    %ebp
  8009fc:	c3                   	ret    

008009fd <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	53                   	push   %ebx
  800a01:	83 ec 10             	sub    $0x10,%esp
  800a04:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a07:	53                   	push   %ebx
  800a08:	e8 97 ff ff ff       	call   8009a4 <strlen>
  800a0d:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	01 d8                	add    %ebx,%eax
  800a15:	50                   	push   %eax
  800a16:	e8 c2 ff ff ff       	call   8009dd <strcpy>
	return dst;
}
  800a1b:	89 d8                	mov    %ebx,%eax
  800a1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a20:	c9                   	leave  
  800a21:	c3                   	ret    

00800a22 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
  800a25:	56                   	push   %esi
  800a26:	53                   	push   %ebx
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a2d:	89 c6                	mov    %eax,%esi
  800a2f:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a32:	89 c2                	mov    %eax,%edx
  800a34:	39 f2                	cmp    %esi,%edx
  800a36:	74 11                	je     800a49 <strncpy+0x27>
		*dst++ = *src;
  800a38:	83 c2 01             	add    $0x1,%edx
  800a3b:	0f b6 19             	movzbl (%ecx),%ebx
  800a3e:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a41:	80 fb 01             	cmp    $0x1,%bl
  800a44:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a47:	eb eb                	jmp    800a34 <strncpy+0x12>
	}
	return ret;
}
  800a49:	5b                   	pop    %ebx
  800a4a:	5e                   	pop    %esi
  800a4b:	5d                   	pop    %ebp
  800a4c:	c3                   	ret    

00800a4d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	56                   	push   %esi
  800a51:	53                   	push   %ebx
  800a52:	8b 75 08             	mov    0x8(%ebp),%esi
  800a55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a58:	8b 55 10             	mov    0x10(%ebp),%edx
  800a5b:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a5d:	85 d2                	test   %edx,%edx
  800a5f:	74 21                	je     800a82 <strlcpy+0x35>
  800a61:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a65:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a67:	39 c2                	cmp    %eax,%edx
  800a69:	74 14                	je     800a7f <strlcpy+0x32>
  800a6b:	0f b6 19             	movzbl (%ecx),%ebx
  800a6e:	84 db                	test   %bl,%bl
  800a70:	74 0b                	je     800a7d <strlcpy+0x30>
			*dst++ = *src++;
  800a72:	83 c1 01             	add    $0x1,%ecx
  800a75:	83 c2 01             	add    $0x1,%edx
  800a78:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a7b:	eb ea                	jmp    800a67 <strlcpy+0x1a>
  800a7d:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a7f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a82:	29 f0                	sub    %esi,%eax
}
  800a84:	5b                   	pop    %ebx
  800a85:	5e                   	pop    %esi
  800a86:	5d                   	pop    %ebp
  800a87:	c3                   	ret    

00800a88 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a8e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a91:	0f b6 01             	movzbl (%ecx),%eax
  800a94:	84 c0                	test   %al,%al
  800a96:	74 0c                	je     800aa4 <strcmp+0x1c>
  800a98:	3a 02                	cmp    (%edx),%al
  800a9a:	75 08                	jne    800aa4 <strcmp+0x1c>
		p++, q++;
  800a9c:	83 c1 01             	add    $0x1,%ecx
  800a9f:	83 c2 01             	add    $0x1,%edx
  800aa2:	eb ed                	jmp    800a91 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aa4:	0f b6 c0             	movzbl %al,%eax
  800aa7:	0f b6 12             	movzbl (%edx),%edx
  800aaa:	29 d0                	sub    %edx,%eax
}
  800aac:	5d                   	pop    %ebp
  800aad:	c3                   	ret    

00800aae <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	53                   	push   %ebx
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab8:	89 c3                	mov    %eax,%ebx
  800aba:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800abd:	eb 06                	jmp    800ac5 <strncmp+0x17>
		n--, p++, q++;
  800abf:	83 c0 01             	add    $0x1,%eax
  800ac2:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800ac5:	39 d8                	cmp    %ebx,%eax
  800ac7:	74 16                	je     800adf <strncmp+0x31>
  800ac9:	0f b6 08             	movzbl (%eax),%ecx
  800acc:	84 c9                	test   %cl,%cl
  800ace:	74 04                	je     800ad4 <strncmp+0x26>
  800ad0:	3a 0a                	cmp    (%edx),%cl
  800ad2:	74 eb                	je     800abf <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ad4:	0f b6 00             	movzbl (%eax),%eax
  800ad7:	0f b6 12             	movzbl (%edx),%edx
  800ada:	29 d0                	sub    %edx,%eax
}
  800adc:	5b                   	pop    %ebx
  800add:	5d                   	pop    %ebp
  800ade:	c3                   	ret    
		return 0;
  800adf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae4:	eb f6                	jmp    800adc <strncmp+0x2e>

00800ae6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800af0:	0f b6 10             	movzbl (%eax),%edx
  800af3:	84 d2                	test   %dl,%dl
  800af5:	74 09                	je     800b00 <strchr+0x1a>
		if (*s == c)
  800af7:	38 ca                	cmp    %cl,%dl
  800af9:	74 0a                	je     800b05 <strchr+0x1f>
	for (; *s; s++)
  800afb:	83 c0 01             	add    $0x1,%eax
  800afe:	eb f0                	jmp    800af0 <strchr+0xa>
			return (char *) s;
	return 0;
  800b00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b05:	5d                   	pop    %ebp
  800b06:	c3                   	ret    

00800b07 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b11:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b14:	38 ca                	cmp    %cl,%dl
  800b16:	74 09                	je     800b21 <strfind+0x1a>
  800b18:	84 d2                	test   %dl,%dl
  800b1a:	74 05                	je     800b21 <strfind+0x1a>
	for (; *s; s++)
  800b1c:	83 c0 01             	add    $0x1,%eax
  800b1f:	eb f0                	jmp    800b11 <strfind+0xa>
			break;
	return (char *) s;
}
  800b21:	5d                   	pop    %ebp
  800b22:	c3                   	ret    

00800b23 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b23:	55                   	push   %ebp
  800b24:	89 e5                	mov    %esp,%ebp
  800b26:	57                   	push   %edi
  800b27:	56                   	push   %esi
  800b28:	53                   	push   %ebx
  800b29:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b2c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b2f:	85 c9                	test   %ecx,%ecx
  800b31:	74 31                	je     800b64 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b33:	89 f8                	mov    %edi,%eax
  800b35:	09 c8                	or     %ecx,%eax
  800b37:	a8 03                	test   $0x3,%al
  800b39:	75 23                	jne    800b5e <memset+0x3b>
		c &= 0xFF;
  800b3b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b3f:	89 d3                	mov    %edx,%ebx
  800b41:	c1 e3 08             	shl    $0x8,%ebx
  800b44:	89 d0                	mov    %edx,%eax
  800b46:	c1 e0 18             	shl    $0x18,%eax
  800b49:	89 d6                	mov    %edx,%esi
  800b4b:	c1 e6 10             	shl    $0x10,%esi
  800b4e:	09 f0                	or     %esi,%eax
  800b50:	09 c2                	or     %eax,%edx
  800b52:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b54:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b57:	89 d0                	mov    %edx,%eax
  800b59:	fc                   	cld    
  800b5a:	f3 ab                	rep stos %eax,%es:(%edi)
  800b5c:	eb 06                	jmp    800b64 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b61:	fc                   	cld    
  800b62:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b64:	89 f8                	mov    %edi,%eax
  800b66:	5b                   	pop    %ebx
  800b67:	5e                   	pop    %esi
  800b68:	5f                   	pop    %edi
  800b69:	5d                   	pop    %ebp
  800b6a:	c3                   	ret    

00800b6b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	57                   	push   %edi
  800b6f:	56                   	push   %esi
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b76:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b79:	39 c6                	cmp    %eax,%esi
  800b7b:	73 32                	jae    800baf <memmove+0x44>
  800b7d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b80:	39 c2                	cmp    %eax,%edx
  800b82:	76 2b                	jbe    800baf <memmove+0x44>
		s += n;
		d += n;
  800b84:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b87:	89 fe                	mov    %edi,%esi
  800b89:	09 ce                	or     %ecx,%esi
  800b8b:	09 d6                	or     %edx,%esi
  800b8d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b93:	75 0e                	jne    800ba3 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b95:	83 ef 04             	sub    $0x4,%edi
  800b98:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b9b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b9e:	fd                   	std    
  800b9f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ba1:	eb 09                	jmp    800bac <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ba3:	83 ef 01             	sub    $0x1,%edi
  800ba6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ba9:	fd                   	std    
  800baa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bac:	fc                   	cld    
  800bad:	eb 1a                	jmp    800bc9 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800baf:	89 c2                	mov    %eax,%edx
  800bb1:	09 ca                	or     %ecx,%edx
  800bb3:	09 f2                	or     %esi,%edx
  800bb5:	f6 c2 03             	test   $0x3,%dl
  800bb8:	75 0a                	jne    800bc4 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bba:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bbd:	89 c7                	mov    %eax,%edi
  800bbf:	fc                   	cld    
  800bc0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bc2:	eb 05                	jmp    800bc9 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bc4:	89 c7                	mov    %eax,%edi
  800bc6:	fc                   	cld    
  800bc7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bc9:	5e                   	pop    %esi
  800bca:	5f                   	pop    %edi
  800bcb:	5d                   	pop    %ebp
  800bcc:	c3                   	ret    

00800bcd <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bd3:	ff 75 10             	pushl  0x10(%ebp)
  800bd6:	ff 75 0c             	pushl  0xc(%ebp)
  800bd9:	ff 75 08             	pushl  0x8(%ebp)
  800bdc:	e8 8a ff ff ff       	call   800b6b <memmove>
}
  800be1:	c9                   	leave  
  800be2:	c3                   	ret    

00800be3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	56                   	push   %esi
  800be7:	53                   	push   %ebx
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bee:	89 c6                	mov    %eax,%esi
  800bf0:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bf3:	39 f0                	cmp    %esi,%eax
  800bf5:	74 1c                	je     800c13 <memcmp+0x30>
		if (*s1 != *s2)
  800bf7:	0f b6 08             	movzbl (%eax),%ecx
  800bfa:	0f b6 1a             	movzbl (%edx),%ebx
  800bfd:	38 d9                	cmp    %bl,%cl
  800bff:	75 08                	jne    800c09 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c01:	83 c0 01             	add    $0x1,%eax
  800c04:	83 c2 01             	add    $0x1,%edx
  800c07:	eb ea                	jmp    800bf3 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c09:	0f b6 c1             	movzbl %cl,%eax
  800c0c:	0f b6 db             	movzbl %bl,%ebx
  800c0f:	29 d8                	sub    %ebx,%eax
  800c11:	eb 05                	jmp    800c18 <memcmp+0x35>
	}

	return 0;
  800c13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c18:	5b                   	pop    %ebx
  800c19:	5e                   	pop    %esi
  800c1a:	5d                   	pop    %ebp
  800c1b:	c3                   	ret    

00800c1c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c25:	89 c2                	mov    %eax,%edx
  800c27:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c2a:	39 d0                	cmp    %edx,%eax
  800c2c:	73 09                	jae    800c37 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c2e:	38 08                	cmp    %cl,(%eax)
  800c30:	74 05                	je     800c37 <memfind+0x1b>
	for (; s < ends; s++)
  800c32:	83 c0 01             	add    $0x1,%eax
  800c35:	eb f3                	jmp    800c2a <memfind+0xe>
			break;
	return (void *) s;
}
  800c37:	5d                   	pop    %ebp
  800c38:	c3                   	ret    

00800c39 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	57                   	push   %edi
  800c3d:	56                   	push   %esi
  800c3e:	53                   	push   %ebx
  800c3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c42:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c45:	eb 03                	jmp    800c4a <strtol+0x11>
		s++;
  800c47:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c4a:	0f b6 01             	movzbl (%ecx),%eax
  800c4d:	3c 20                	cmp    $0x20,%al
  800c4f:	74 f6                	je     800c47 <strtol+0xe>
  800c51:	3c 09                	cmp    $0x9,%al
  800c53:	74 f2                	je     800c47 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c55:	3c 2b                	cmp    $0x2b,%al
  800c57:	74 2a                	je     800c83 <strtol+0x4a>
	int neg = 0;
  800c59:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c5e:	3c 2d                	cmp    $0x2d,%al
  800c60:	74 2b                	je     800c8d <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c62:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c68:	75 0f                	jne    800c79 <strtol+0x40>
  800c6a:	80 39 30             	cmpb   $0x30,(%ecx)
  800c6d:	74 28                	je     800c97 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c6f:	85 db                	test   %ebx,%ebx
  800c71:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c76:	0f 44 d8             	cmove  %eax,%ebx
  800c79:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c81:	eb 50                	jmp    800cd3 <strtol+0x9a>
		s++;
  800c83:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c86:	bf 00 00 00 00       	mov    $0x0,%edi
  800c8b:	eb d5                	jmp    800c62 <strtol+0x29>
		s++, neg = 1;
  800c8d:	83 c1 01             	add    $0x1,%ecx
  800c90:	bf 01 00 00 00       	mov    $0x1,%edi
  800c95:	eb cb                	jmp    800c62 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c97:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c9b:	74 0e                	je     800cab <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c9d:	85 db                	test   %ebx,%ebx
  800c9f:	75 d8                	jne    800c79 <strtol+0x40>
		s++, base = 8;
  800ca1:	83 c1 01             	add    $0x1,%ecx
  800ca4:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ca9:	eb ce                	jmp    800c79 <strtol+0x40>
		s += 2, base = 16;
  800cab:	83 c1 02             	add    $0x2,%ecx
  800cae:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cb3:	eb c4                	jmp    800c79 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cb5:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cb8:	89 f3                	mov    %esi,%ebx
  800cba:	80 fb 19             	cmp    $0x19,%bl
  800cbd:	77 29                	ja     800ce8 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cbf:	0f be d2             	movsbl %dl,%edx
  800cc2:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800cc5:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cc8:	7d 30                	jge    800cfa <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cca:	83 c1 01             	add    $0x1,%ecx
  800ccd:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cd1:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cd3:	0f b6 11             	movzbl (%ecx),%edx
  800cd6:	8d 72 d0             	lea    -0x30(%edx),%esi
  800cd9:	89 f3                	mov    %esi,%ebx
  800cdb:	80 fb 09             	cmp    $0x9,%bl
  800cde:	77 d5                	ja     800cb5 <strtol+0x7c>
			dig = *s - '0';
  800ce0:	0f be d2             	movsbl %dl,%edx
  800ce3:	83 ea 30             	sub    $0x30,%edx
  800ce6:	eb dd                	jmp    800cc5 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800ce8:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ceb:	89 f3                	mov    %esi,%ebx
  800ced:	80 fb 19             	cmp    $0x19,%bl
  800cf0:	77 08                	ja     800cfa <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cf2:	0f be d2             	movsbl %dl,%edx
  800cf5:	83 ea 37             	sub    $0x37,%edx
  800cf8:	eb cb                	jmp    800cc5 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cfa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cfe:	74 05                	je     800d05 <strtol+0xcc>
		*endptr = (char *) s;
  800d00:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d03:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d05:	89 c2                	mov    %eax,%edx
  800d07:	f7 da                	neg    %edx
  800d09:	85 ff                	test   %edi,%edi
  800d0b:	0f 45 c2             	cmovne %edx,%eax
}
  800d0e:	5b                   	pop    %ebx
  800d0f:	5e                   	pop    %esi
  800d10:	5f                   	pop    %edi
  800d11:	5d                   	pop    %ebp
  800d12:	c3                   	ret    

00800d13 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
  800d16:	57                   	push   %edi
  800d17:	56                   	push   %esi
  800d18:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d19:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d24:	89 c3                	mov    %eax,%ebx
  800d26:	89 c7                	mov    %eax,%edi
  800d28:	89 c6                	mov    %eax,%esi
  800d2a:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d2c:	5b                   	pop    %ebx
  800d2d:	5e                   	pop    %esi
  800d2e:	5f                   	pop    %edi
  800d2f:	5d                   	pop    %ebp
  800d30:	c3                   	ret    

00800d31 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	57                   	push   %edi
  800d35:	56                   	push   %esi
  800d36:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d37:	ba 00 00 00 00       	mov    $0x0,%edx
  800d3c:	b8 01 00 00 00       	mov    $0x1,%eax
  800d41:	89 d1                	mov    %edx,%ecx
  800d43:	89 d3                	mov    %edx,%ebx
  800d45:	89 d7                	mov    %edx,%edi
  800d47:	89 d6                	mov    %edx,%esi
  800d49:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d4b:	5b                   	pop    %ebx
  800d4c:	5e                   	pop    %esi
  800d4d:	5f                   	pop    %edi
  800d4e:	5d                   	pop    %ebp
  800d4f:	c3                   	ret    

00800d50 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	57                   	push   %edi
  800d54:	56                   	push   %esi
  800d55:	53                   	push   %ebx
  800d56:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d59:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d61:	b8 03 00 00 00       	mov    $0x3,%eax
  800d66:	89 cb                	mov    %ecx,%ebx
  800d68:	89 cf                	mov    %ecx,%edi
  800d6a:	89 ce                	mov    %ecx,%esi
  800d6c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d6e:	85 c0                	test   %eax,%eax
  800d70:	7f 08                	jg     800d7a <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d75:	5b                   	pop    %ebx
  800d76:	5e                   	pop    %esi
  800d77:	5f                   	pop    %edi
  800d78:	5d                   	pop    %ebp
  800d79:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7a:	83 ec 0c             	sub    $0xc,%esp
  800d7d:	50                   	push   %eax
  800d7e:	6a 03                	push   $0x3
  800d80:	68 28 30 80 00       	push   $0x803028
  800d85:	6a 43                	push   $0x43
  800d87:	68 45 30 80 00       	push   $0x803045
  800d8c:	e8 f7 f3 ff ff       	call   800188 <_panic>

00800d91 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	57                   	push   %edi
  800d95:	56                   	push   %esi
  800d96:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d97:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9c:	b8 02 00 00 00       	mov    $0x2,%eax
  800da1:	89 d1                	mov    %edx,%ecx
  800da3:	89 d3                	mov    %edx,%ebx
  800da5:	89 d7                	mov    %edx,%edi
  800da7:	89 d6                	mov    %edx,%esi
  800da9:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dab:	5b                   	pop    %ebx
  800dac:	5e                   	pop    %esi
  800dad:	5f                   	pop    %edi
  800dae:	5d                   	pop    %ebp
  800daf:	c3                   	ret    

00800db0 <sys_yield>:

void
sys_yield(void)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
  800db3:	57                   	push   %edi
  800db4:	56                   	push   %esi
  800db5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db6:	ba 00 00 00 00       	mov    $0x0,%edx
  800dbb:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dc0:	89 d1                	mov    %edx,%ecx
  800dc2:	89 d3                	mov    %edx,%ebx
  800dc4:	89 d7                	mov    %edx,%edi
  800dc6:	89 d6                	mov    %edx,%esi
  800dc8:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dca:	5b                   	pop    %ebx
  800dcb:	5e                   	pop    %esi
  800dcc:	5f                   	pop    %edi
  800dcd:	5d                   	pop    %ebp
  800dce:	c3                   	ret    

00800dcf <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	57                   	push   %edi
  800dd3:	56                   	push   %esi
  800dd4:	53                   	push   %ebx
  800dd5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd8:	be 00 00 00 00       	mov    $0x0,%esi
  800ddd:	8b 55 08             	mov    0x8(%ebp),%edx
  800de0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de3:	b8 04 00 00 00       	mov    $0x4,%eax
  800de8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800deb:	89 f7                	mov    %esi,%edi
  800ded:	cd 30                	int    $0x30
	if(check && ret > 0)
  800def:	85 c0                	test   %eax,%eax
  800df1:	7f 08                	jg     800dfb <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800df3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df6:	5b                   	pop    %ebx
  800df7:	5e                   	pop    %esi
  800df8:	5f                   	pop    %edi
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfb:	83 ec 0c             	sub    $0xc,%esp
  800dfe:	50                   	push   %eax
  800dff:	6a 04                	push   $0x4
  800e01:	68 28 30 80 00       	push   $0x803028
  800e06:	6a 43                	push   $0x43
  800e08:	68 45 30 80 00       	push   $0x803045
  800e0d:	e8 76 f3 ff ff       	call   800188 <_panic>

00800e12 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	57                   	push   %edi
  800e16:	56                   	push   %esi
  800e17:	53                   	push   %ebx
  800e18:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e21:	b8 05 00 00 00       	mov    $0x5,%eax
  800e26:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e29:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e2c:	8b 75 18             	mov    0x18(%ebp),%esi
  800e2f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e31:	85 c0                	test   %eax,%eax
  800e33:	7f 08                	jg     800e3d <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e38:	5b                   	pop    %ebx
  800e39:	5e                   	pop    %esi
  800e3a:	5f                   	pop    %edi
  800e3b:	5d                   	pop    %ebp
  800e3c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3d:	83 ec 0c             	sub    $0xc,%esp
  800e40:	50                   	push   %eax
  800e41:	6a 05                	push   $0x5
  800e43:	68 28 30 80 00       	push   $0x803028
  800e48:	6a 43                	push   $0x43
  800e4a:	68 45 30 80 00       	push   $0x803045
  800e4f:	e8 34 f3 ff ff       	call   800188 <_panic>

00800e54 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	57                   	push   %edi
  800e58:	56                   	push   %esi
  800e59:	53                   	push   %ebx
  800e5a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e62:	8b 55 08             	mov    0x8(%ebp),%edx
  800e65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e68:	b8 06 00 00 00       	mov    $0x6,%eax
  800e6d:	89 df                	mov    %ebx,%edi
  800e6f:	89 de                	mov    %ebx,%esi
  800e71:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e73:	85 c0                	test   %eax,%eax
  800e75:	7f 08                	jg     800e7f <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7a:	5b                   	pop    %ebx
  800e7b:	5e                   	pop    %esi
  800e7c:	5f                   	pop    %edi
  800e7d:	5d                   	pop    %ebp
  800e7e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7f:	83 ec 0c             	sub    $0xc,%esp
  800e82:	50                   	push   %eax
  800e83:	6a 06                	push   $0x6
  800e85:	68 28 30 80 00       	push   $0x803028
  800e8a:	6a 43                	push   $0x43
  800e8c:	68 45 30 80 00       	push   $0x803045
  800e91:	e8 f2 f2 ff ff       	call   800188 <_panic>

00800e96 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	57                   	push   %edi
  800e9a:	56                   	push   %esi
  800e9b:	53                   	push   %ebx
  800e9c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e9f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eaa:	b8 08 00 00 00       	mov    $0x8,%eax
  800eaf:	89 df                	mov    %ebx,%edi
  800eb1:	89 de                	mov    %ebx,%esi
  800eb3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb5:	85 c0                	test   %eax,%eax
  800eb7:	7f 08                	jg     800ec1 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800eb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ebc:	5b                   	pop    %ebx
  800ebd:	5e                   	pop    %esi
  800ebe:	5f                   	pop    %edi
  800ebf:	5d                   	pop    %ebp
  800ec0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec1:	83 ec 0c             	sub    $0xc,%esp
  800ec4:	50                   	push   %eax
  800ec5:	6a 08                	push   $0x8
  800ec7:	68 28 30 80 00       	push   $0x803028
  800ecc:	6a 43                	push   $0x43
  800ece:	68 45 30 80 00       	push   $0x803045
  800ed3:	e8 b0 f2 ff ff       	call   800188 <_panic>

00800ed8 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ed8:	55                   	push   %ebp
  800ed9:	89 e5                	mov    %esp,%ebp
  800edb:	57                   	push   %edi
  800edc:	56                   	push   %esi
  800edd:	53                   	push   %ebx
  800ede:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eec:	b8 09 00 00 00       	mov    $0x9,%eax
  800ef1:	89 df                	mov    %ebx,%edi
  800ef3:	89 de                	mov    %ebx,%esi
  800ef5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef7:	85 c0                	test   %eax,%eax
  800ef9:	7f 08                	jg     800f03 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800efe:	5b                   	pop    %ebx
  800eff:	5e                   	pop    %esi
  800f00:	5f                   	pop    %edi
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f03:	83 ec 0c             	sub    $0xc,%esp
  800f06:	50                   	push   %eax
  800f07:	6a 09                	push   $0x9
  800f09:	68 28 30 80 00       	push   $0x803028
  800f0e:	6a 43                	push   $0x43
  800f10:	68 45 30 80 00       	push   $0x803045
  800f15:	e8 6e f2 ff ff       	call   800188 <_panic>

00800f1a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f1a:	55                   	push   %ebp
  800f1b:	89 e5                	mov    %esp,%ebp
  800f1d:	57                   	push   %edi
  800f1e:	56                   	push   %esi
  800f1f:	53                   	push   %ebx
  800f20:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f28:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f33:	89 df                	mov    %ebx,%edi
  800f35:	89 de                	mov    %ebx,%esi
  800f37:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f39:	85 c0                	test   %eax,%eax
  800f3b:	7f 08                	jg     800f45 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f40:	5b                   	pop    %ebx
  800f41:	5e                   	pop    %esi
  800f42:	5f                   	pop    %edi
  800f43:	5d                   	pop    %ebp
  800f44:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f45:	83 ec 0c             	sub    $0xc,%esp
  800f48:	50                   	push   %eax
  800f49:	6a 0a                	push   $0xa
  800f4b:	68 28 30 80 00       	push   $0x803028
  800f50:	6a 43                	push   $0x43
  800f52:	68 45 30 80 00       	push   $0x803045
  800f57:	e8 2c f2 ff ff       	call   800188 <_panic>

00800f5c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	57                   	push   %edi
  800f60:	56                   	push   %esi
  800f61:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f62:	8b 55 08             	mov    0x8(%ebp),%edx
  800f65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f68:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f6d:	be 00 00 00 00       	mov    $0x0,%esi
  800f72:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f75:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f78:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f7a:	5b                   	pop    %ebx
  800f7b:	5e                   	pop    %esi
  800f7c:	5f                   	pop    %edi
  800f7d:	5d                   	pop    %ebp
  800f7e:	c3                   	ret    

00800f7f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	57                   	push   %edi
  800f83:	56                   	push   %esi
  800f84:	53                   	push   %ebx
  800f85:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f88:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f90:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f95:	89 cb                	mov    %ecx,%ebx
  800f97:	89 cf                	mov    %ecx,%edi
  800f99:	89 ce                	mov    %ecx,%esi
  800f9b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f9d:	85 c0                	test   %eax,%eax
  800f9f:	7f 08                	jg     800fa9 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fa1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa4:	5b                   	pop    %ebx
  800fa5:	5e                   	pop    %esi
  800fa6:	5f                   	pop    %edi
  800fa7:	5d                   	pop    %ebp
  800fa8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa9:	83 ec 0c             	sub    $0xc,%esp
  800fac:	50                   	push   %eax
  800fad:	6a 0d                	push   $0xd
  800faf:	68 28 30 80 00       	push   $0x803028
  800fb4:	6a 43                	push   $0x43
  800fb6:	68 45 30 80 00       	push   $0x803045
  800fbb:	e8 c8 f1 ff ff       	call   800188 <_panic>

00800fc0 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	57                   	push   %edi
  800fc4:	56                   	push   %esi
  800fc5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fcb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd1:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fd6:	89 df                	mov    %ebx,%edi
  800fd8:	89 de                	mov    %ebx,%esi
  800fda:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fdc:	5b                   	pop    %ebx
  800fdd:	5e                   	pop    %esi
  800fde:	5f                   	pop    %edi
  800fdf:	5d                   	pop    %ebp
  800fe0:	c3                   	ret    

00800fe1 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	57                   	push   %edi
  800fe5:	56                   	push   %esi
  800fe6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fe7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fec:	8b 55 08             	mov    0x8(%ebp),%edx
  800fef:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ff4:	89 cb                	mov    %ecx,%ebx
  800ff6:	89 cf                	mov    %ecx,%edi
  800ff8:	89 ce                	mov    %ecx,%esi
  800ffa:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800ffc:	5b                   	pop    %ebx
  800ffd:	5e                   	pop    %esi
  800ffe:	5f                   	pop    %edi
  800fff:	5d                   	pop    %ebp
  801000:	c3                   	ret    

00801001 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	57                   	push   %edi
  801005:	56                   	push   %esi
  801006:	53                   	push   %ebx
	asm volatile("int %1\n"
  801007:	ba 00 00 00 00       	mov    $0x0,%edx
  80100c:	b8 10 00 00 00       	mov    $0x10,%eax
  801011:	89 d1                	mov    %edx,%ecx
  801013:	89 d3                	mov    %edx,%ebx
  801015:	89 d7                	mov    %edx,%edi
  801017:	89 d6                	mov    %edx,%esi
  801019:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80101b:	5b                   	pop    %ebx
  80101c:	5e                   	pop    %esi
  80101d:	5f                   	pop    %edi
  80101e:	5d                   	pop    %ebp
  80101f:	c3                   	ret    

00801020 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	57                   	push   %edi
  801024:	56                   	push   %esi
  801025:	53                   	push   %ebx
	asm volatile("int %1\n"
  801026:	bb 00 00 00 00       	mov    $0x0,%ebx
  80102b:	8b 55 08             	mov    0x8(%ebp),%edx
  80102e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801031:	b8 11 00 00 00       	mov    $0x11,%eax
  801036:	89 df                	mov    %ebx,%edi
  801038:	89 de                	mov    %ebx,%esi
  80103a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80103c:	5b                   	pop    %ebx
  80103d:	5e                   	pop    %esi
  80103e:	5f                   	pop    %edi
  80103f:	5d                   	pop    %ebp
  801040:	c3                   	ret    

00801041 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	57                   	push   %edi
  801045:	56                   	push   %esi
  801046:	53                   	push   %ebx
	asm volatile("int %1\n"
  801047:	bb 00 00 00 00       	mov    $0x0,%ebx
  80104c:	8b 55 08             	mov    0x8(%ebp),%edx
  80104f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801052:	b8 12 00 00 00       	mov    $0x12,%eax
  801057:	89 df                	mov    %ebx,%edi
  801059:	89 de                	mov    %ebx,%esi
  80105b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  80105d:	5b                   	pop    %ebx
  80105e:	5e                   	pop    %esi
  80105f:	5f                   	pop    %edi
  801060:	5d                   	pop    %ebp
  801061:	c3                   	ret    

00801062 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
  801065:	57                   	push   %edi
  801066:	56                   	push   %esi
  801067:	53                   	push   %ebx
  801068:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80106b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801070:	8b 55 08             	mov    0x8(%ebp),%edx
  801073:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801076:	b8 13 00 00 00       	mov    $0x13,%eax
  80107b:	89 df                	mov    %ebx,%edi
  80107d:	89 de                	mov    %ebx,%esi
  80107f:	cd 30                	int    $0x30
	if(check && ret > 0)
  801081:	85 c0                	test   %eax,%eax
  801083:	7f 08                	jg     80108d <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801085:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801088:	5b                   	pop    %ebx
  801089:	5e                   	pop    %esi
  80108a:	5f                   	pop    %edi
  80108b:	5d                   	pop    %ebp
  80108c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80108d:	83 ec 0c             	sub    $0xc,%esp
  801090:	50                   	push   %eax
  801091:	6a 13                	push   $0x13
  801093:	68 28 30 80 00       	push   $0x803028
  801098:	6a 43                	push   $0x43
  80109a:	68 45 30 80 00       	push   $0x803045
  80109f:	e8 e4 f0 ff ff       	call   800188 <_panic>

008010a4 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8010a4:	55                   	push   %ebp
  8010a5:	89 e5                	mov    %esp,%ebp
  8010a7:	57                   	push   %edi
  8010a8:	56                   	push   %esi
  8010a9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010aa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010af:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b2:	b8 14 00 00 00       	mov    $0x14,%eax
  8010b7:	89 cb                	mov    %ecx,%ebx
  8010b9:	89 cf                	mov    %ecx,%edi
  8010bb:	89 ce                	mov    %ecx,%esi
  8010bd:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8010bf:	5b                   	pop    %ebx
  8010c0:	5e                   	pop    %esi
  8010c1:	5f                   	pop    %edi
  8010c2:	5d                   	pop    %ebp
  8010c3:	c3                   	ret    

008010c4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	05 00 00 00 30       	add    $0x30000000,%eax
  8010cf:	c1 e8 0c             	shr    $0xc,%eax
}
  8010d2:	5d                   	pop    %ebp
  8010d3:	c3                   	ret    

008010d4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010df:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010e4:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010e9:	5d                   	pop    %ebp
  8010ea:	c3                   	ret    

008010eb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010eb:	55                   	push   %ebp
  8010ec:	89 e5                	mov    %esp,%ebp
  8010ee:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010f3:	89 c2                	mov    %eax,%edx
  8010f5:	c1 ea 16             	shr    $0x16,%edx
  8010f8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010ff:	f6 c2 01             	test   $0x1,%dl
  801102:	74 2d                	je     801131 <fd_alloc+0x46>
  801104:	89 c2                	mov    %eax,%edx
  801106:	c1 ea 0c             	shr    $0xc,%edx
  801109:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801110:	f6 c2 01             	test   $0x1,%dl
  801113:	74 1c                	je     801131 <fd_alloc+0x46>
  801115:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80111a:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80111f:	75 d2                	jne    8010f3 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80112a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80112f:	eb 0a                	jmp    80113b <fd_alloc+0x50>
			*fd_store = fd;
  801131:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801134:	89 01                	mov    %eax,(%ecx)
			return 0;
  801136:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80113b:	5d                   	pop    %ebp
  80113c:	c3                   	ret    

0080113d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801143:	83 f8 1f             	cmp    $0x1f,%eax
  801146:	77 30                	ja     801178 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801148:	c1 e0 0c             	shl    $0xc,%eax
  80114b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801150:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801156:	f6 c2 01             	test   $0x1,%dl
  801159:	74 24                	je     80117f <fd_lookup+0x42>
  80115b:	89 c2                	mov    %eax,%edx
  80115d:	c1 ea 0c             	shr    $0xc,%edx
  801160:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801167:	f6 c2 01             	test   $0x1,%dl
  80116a:	74 1a                	je     801186 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80116c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80116f:	89 02                	mov    %eax,(%edx)
	return 0;
  801171:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801176:	5d                   	pop    %ebp
  801177:	c3                   	ret    
		return -E_INVAL;
  801178:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80117d:	eb f7                	jmp    801176 <fd_lookup+0x39>
		return -E_INVAL;
  80117f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801184:	eb f0                	jmp    801176 <fd_lookup+0x39>
  801186:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80118b:	eb e9                	jmp    801176 <fd_lookup+0x39>

0080118d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	83 ec 08             	sub    $0x8,%esp
  801193:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801196:	ba 00 00 00 00       	mov    $0x0,%edx
  80119b:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011a0:	39 08                	cmp    %ecx,(%eax)
  8011a2:	74 38                	je     8011dc <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8011a4:	83 c2 01             	add    $0x1,%edx
  8011a7:	8b 04 95 d0 30 80 00 	mov    0x8030d0(,%edx,4),%eax
  8011ae:	85 c0                	test   %eax,%eax
  8011b0:	75 ee                	jne    8011a0 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011b2:	a1 08 50 80 00       	mov    0x805008,%eax
  8011b7:	8b 40 48             	mov    0x48(%eax),%eax
  8011ba:	83 ec 04             	sub    $0x4,%esp
  8011bd:	51                   	push   %ecx
  8011be:	50                   	push   %eax
  8011bf:	68 54 30 80 00       	push   $0x803054
  8011c4:	e8 b5 f0 ff ff       	call   80027e <cprintf>
	*dev = 0;
  8011c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011d2:	83 c4 10             	add    $0x10,%esp
  8011d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011da:	c9                   	leave  
  8011db:	c3                   	ret    
			*dev = devtab[i];
  8011dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011df:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e6:	eb f2                	jmp    8011da <dev_lookup+0x4d>

008011e8 <fd_close>:
{
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
  8011eb:	57                   	push   %edi
  8011ec:	56                   	push   %esi
  8011ed:	53                   	push   %ebx
  8011ee:	83 ec 24             	sub    $0x24,%esp
  8011f1:	8b 75 08             	mov    0x8(%ebp),%esi
  8011f4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011f7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011fa:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011fb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801201:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801204:	50                   	push   %eax
  801205:	e8 33 ff ff ff       	call   80113d <fd_lookup>
  80120a:	89 c3                	mov    %eax,%ebx
  80120c:	83 c4 10             	add    $0x10,%esp
  80120f:	85 c0                	test   %eax,%eax
  801211:	78 05                	js     801218 <fd_close+0x30>
	    || fd != fd2)
  801213:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801216:	74 16                	je     80122e <fd_close+0x46>
		return (must_exist ? r : 0);
  801218:	89 f8                	mov    %edi,%eax
  80121a:	84 c0                	test   %al,%al
  80121c:	b8 00 00 00 00       	mov    $0x0,%eax
  801221:	0f 44 d8             	cmove  %eax,%ebx
}
  801224:	89 d8                	mov    %ebx,%eax
  801226:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801229:	5b                   	pop    %ebx
  80122a:	5e                   	pop    %esi
  80122b:	5f                   	pop    %edi
  80122c:	5d                   	pop    %ebp
  80122d:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80122e:	83 ec 08             	sub    $0x8,%esp
  801231:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801234:	50                   	push   %eax
  801235:	ff 36                	pushl  (%esi)
  801237:	e8 51 ff ff ff       	call   80118d <dev_lookup>
  80123c:	89 c3                	mov    %eax,%ebx
  80123e:	83 c4 10             	add    $0x10,%esp
  801241:	85 c0                	test   %eax,%eax
  801243:	78 1a                	js     80125f <fd_close+0x77>
		if (dev->dev_close)
  801245:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801248:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80124b:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801250:	85 c0                	test   %eax,%eax
  801252:	74 0b                	je     80125f <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801254:	83 ec 0c             	sub    $0xc,%esp
  801257:	56                   	push   %esi
  801258:	ff d0                	call   *%eax
  80125a:	89 c3                	mov    %eax,%ebx
  80125c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80125f:	83 ec 08             	sub    $0x8,%esp
  801262:	56                   	push   %esi
  801263:	6a 00                	push   $0x0
  801265:	e8 ea fb ff ff       	call   800e54 <sys_page_unmap>
	return r;
  80126a:	83 c4 10             	add    $0x10,%esp
  80126d:	eb b5                	jmp    801224 <fd_close+0x3c>

0080126f <close>:

int
close(int fdnum)
{
  80126f:	55                   	push   %ebp
  801270:	89 e5                	mov    %esp,%ebp
  801272:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801275:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801278:	50                   	push   %eax
  801279:	ff 75 08             	pushl  0x8(%ebp)
  80127c:	e8 bc fe ff ff       	call   80113d <fd_lookup>
  801281:	83 c4 10             	add    $0x10,%esp
  801284:	85 c0                	test   %eax,%eax
  801286:	79 02                	jns    80128a <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801288:	c9                   	leave  
  801289:	c3                   	ret    
		return fd_close(fd, 1);
  80128a:	83 ec 08             	sub    $0x8,%esp
  80128d:	6a 01                	push   $0x1
  80128f:	ff 75 f4             	pushl  -0xc(%ebp)
  801292:	e8 51 ff ff ff       	call   8011e8 <fd_close>
  801297:	83 c4 10             	add    $0x10,%esp
  80129a:	eb ec                	jmp    801288 <close+0x19>

0080129c <close_all>:

void
close_all(void)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	53                   	push   %ebx
  8012a0:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012a3:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012a8:	83 ec 0c             	sub    $0xc,%esp
  8012ab:	53                   	push   %ebx
  8012ac:	e8 be ff ff ff       	call   80126f <close>
	for (i = 0; i < MAXFD; i++)
  8012b1:	83 c3 01             	add    $0x1,%ebx
  8012b4:	83 c4 10             	add    $0x10,%esp
  8012b7:	83 fb 20             	cmp    $0x20,%ebx
  8012ba:	75 ec                	jne    8012a8 <close_all+0xc>
}
  8012bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012bf:	c9                   	leave  
  8012c0:	c3                   	ret    

008012c1 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
  8012c4:	57                   	push   %edi
  8012c5:	56                   	push   %esi
  8012c6:	53                   	push   %ebx
  8012c7:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012ca:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012cd:	50                   	push   %eax
  8012ce:	ff 75 08             	pushl  0x8(%ebp)
  8012d1:	e8 67 fe ff ff       	call   80113d <fd_lookup>
  8012d6:	89 c3                	mov    %eax,%ebx
  8012d8:	83 c4 10             	add    $0x10,%esp
  8012db:	85 c0                	test   %eax,%eax
  8012dd:	0f 88 81 00 00 00    	js     801364 <dup+0xa3>
		return r;
	close(newfdnum);
  8012e3:	83 ec 0c             	sub    $0xc,%esp
  8012e6:	ff 75 0c             	pushl  0xc(%ebp)
  8012e9:	e8 81 ff ff ff       	call   80126f <close>

	newfd = INDEX2FD(newfdnum);
  8012ee:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012f1:	c1 e6 0c             	shl    $0xc,%esi
  8012f4:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012fa:	83 c4 04             	add    $0x4,%esp
  8012fd:	ff 75 e4             	pushl  -0x1c(%ebp)
  801300:	e8 cf fd ff ff       	call   8010d4 <fd2data>
  801305:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801307:	89 34 24             	mov    %esi,(%esp)
  80130a:	e8 c5 fd ff ff       	call   8010d4 <fd2data>
  80130f:	83 c4 10             	add    $0x10,%esp
  801312:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801314:	89 d8                	mov    %ebx,%eax
  801316:	c1 e8 16             	shr    $0x16,%eax
  801319:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801320:	a8 01                	test   $0x1,%al
  801322:	74 11                	je     801335 <dup+0x74>
  801324:	89 d8                	mov    %ebx,%eax
  801326:	c1 e8 0c             	shr    $0xc,%eax
  801329:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801330:	f6 c2 01             	test   $0x1,%dl
  801333:	75 39                	jne    80136e <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801335:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801338:	89 d0                	mov    %edx,%eax
  80133a:	c1 e8 0c             	shr    $0xc,%eax
  80133d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801344:	83 ec 0c             	sub    $0xc,%esp
  801347:	25 07 0e 00 00       	and    $0xe07,%eax
  80134c:	50                   	push   %eax
  80134d:	56                   	push   %esi
  80134e:	6a 00                	push   $0x0
  801350:	52                   	push   %edx
  801351:	6a 00                	push   $0x0
  801353:	e8 ba fa ff ff       	call   800e12 <sys_page_map>
  801358:	89 c3                	mov    %eax,%ebx
  80135a:	83 c4 20             	add    $0x20,%esp
  80135d:	85 c0                	test   %eax,%eax
  80135f:	78 31                	js     801392 <dup+0xd1>
		goto err;

	return newfdnum;
  801361:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801364:	89 d8                	mov    %ebx,%eax
  801366:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801369:	5b                   	pop    %ebx
  80136a:	5e                   	pop    %esi
  80136b:	5f                   	pop    %edi
  80136c:	5d                   	pop    %ebp
  80136d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80136e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801375:	83 ec 0c             	sub    $0xc,%esp
  801378:	25 07 0e 00 00       	and    $0xe07,%eax
  80137d:	50                   	push   %eax
  80137e:	57                   	push   %edi
  80137f:	6a 00                	push   $0x0
  801381:	53                   	push   %ebx
  801382:	6a 00                	push   $0x0
  801384:	e8 89 fa ff ff       	call   800e12 <sys_page_map>
  801389:	89 c3                	mov    %eax,%ebx
  80138b:	83 c4 20             	add    $0x20,%esp
  80138e:	85 c0                	test   %eax,%eax
  801390:	79 a3                	jns    801335 <dup+0x74>
	sys_page_unmap(0, newfd);
  801392:	83 ec 08             	sub    $0x8,%esp
  801395:	56                   	push   %esi
  801396:	6a 00                	push   $0x0
  801398:	e8 b7 fa ff ff       	call   800e54 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80139d:	83 c4 08             	add    $0x8,%esp
  8013a0:	57                   	push   %edi
  8013a1:	6a 00                	push   $0x0
  8013a3:	e8 ac fa ff ff       	call   800e54 <sys_page_unmap>
	return r;
  8013a8:	83 c4 10             	add    $0x10,%esp
  8013ab:	eb b7                	jmp    801364 <dup+0xa3>

008013ad <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013ad:	55                   	push   %ebp
  8013ae:	89 e5                	mov    %esp,%ebp
  8013b0:	53                   	push   %ebx
  8013b1:	83 ec 1c             	sub    $0x1c,%esp
  8013b4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013ba:	50                   	push   %eax
  8013bb:	53                   	push   %ebx
  8013bc:	e8 7c fd ff ff       	call   80113d <fd_lookup>
  8013c1:	83 c4 10             	add    $0x10,%esp
  8013c4:	85 c0                	test   %eax,%eax
  8013c6:	78 3f                	js     801407 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013c8:	83 ec 08             	sub    $0x8,%esp
  8013cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ce:	50                   	push   %eax
  8013cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d2:	ff 30                	pushl  (%eax)
  8013d4:	e8 b4 fd ff ff       	call   80118d <dev_lookup>
  8013d9:	83 c4 10             	add    $0x10,%esp
  8013dc:	85 c0                	test   %eax,%eax
  8013de:	78 27                	js     801407 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013e3:	8b 42 08             	mov    0x8(%edx),%eax
  8013e6:	83 e0 03             	and    $0x3,%eax
  8013e9:	83 f8 01             	cmp    $0x1,%eax
  8013ec:	74 1e                	je     80140c <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f1:	8b 40 08             	mov    0x8(%eax),%eax
  8013f4:	85 c0                	test   %eax,%eax
  8013f6:	74 35                	je     80142d <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013f8:	83 ec 04             	sub    $0x4,%esp
  8013fb:	ff 75 10             	pushl  0x10(%ebp)
  8013fe:	ff 75 0c             	pushl  0xc(%ebp)
  801401:	52                   	push   %edx
  801402:	ff d0                	call   *%eax
  801404:	83 c4 10             	add    $0x10,%esp
}
  801407:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80140a:	c9                   	leave  
  80140b:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80140c:	a1 08 50 80 00       	mov    0x805008,%eax
  801411:	8b 40 48             	mov    0x48(%eax),%eax
  801414:	83 ec 04             	sub    $0x4,%esp
  801417:	53                   	push   %ebx
  801418:	50                   	push   %eax
  801419:	68 95 30 80 00       	push   $0x803095
  80141e:	e8 5b ee ff ff       	call   80027e <cprintf>
		return -E_INVAL;
  801423:	83 c4 10             	add    $0x10,%esp
  801426:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80142b:	eb da                	jmp    801407 <read+0x5a>
		return -E_NOT_SUPP;
  80142d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801432:	eb d3                	jmp    801407 <read+0x5a>

00801434 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
  801437:	57                   	push   %edi
  801438:	56                   	push   %esi
  801439:	53                   	push   %ebx
  80143a:	83 ec 0c             	sub    $0xc,%esp
  80143d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801440:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801443:	bb 00 00 00 00       	mov    $0x0,%ebx
  801448:	39 f3                	cmp    %esi,%ebx
  80144a:	73 23                	jae    80146f <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80144c:	83 ec 04             	sub    $0x4,%esp
  80144f:	89 f0                	mov    %esi,%eax
  801451:	29 d8                	sub    %ebx,%eax
  801453:	50                   	push   %eax
  801454:	89 d8                	mov    %ebx,%eax
  801456:	03 45 0c             	add    0xc(%ebp),%eax
  801459:	50                   	push   %eax
  80145a:	57                   	push   %edi
  80145b:	e8 4d ff ff ff       	call   8013ad <read>
		if (m < 0)
  801460:	83 c4 10             	add    $0x10,%esp
  801463:	85 c0                	test   %eax,%eax
  801465:	78 06                	js     80146d <readn+0x39>
			return m;
		if (m == 0)
  801467:	74 06                	je     80146f <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801469:	01 c3                	add    %eax,%ebx
  80146b:	eb db                	jmp    801448 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80146d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80146f:	89 d8                	mov    %ebx,%eax
  801471:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801474:	5b                   	pop    %ebx
  801475:	5e                   	pop    %esi
  801476:	5f                   	pop    %edi
  801477:	5d                   	pop    %ebp
  801478:	c3                   	ret    

00801479 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
  80147c:	53                   	push   %ebx
  80147d:	83 ec 1c             	sub    $0x1c,%esp
  801480:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801483:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801486:	50                   	push   %eax
  801487:	53                   	push   %ebx
  801488:	e8 b0 fc ff ff       	call   80113d <fd_lookup>
  80148d:	83 c4 10             	add    $0x10,%esp
  801490:	85 c0                	test   %eax,%eax
  801492:	78 3a                	js     8014ce <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801494:	83 ec 08             	sub    $0x8,%esp
  801497:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80149a:	50                   	push   %eax
  80149b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149e:	ff 30                	pushl  (%eax)
  8014a0:	e8 e8 fc ff ff       	call   80118d <dev_lookup>
  8014a5:	83 c4 10             	add    $0x10,%esp
  8014a8:	85 c0                	test   %eax,%eax
  8014aa:	78 22                	js     8014ce <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014af:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014b3:	74 1e                	je     8014d3 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014b8:	8b 52 0c             	mov    0xc(%edx),%edx
  8014bb:	85 d2                	test   %edx,%edx
  8014bd:	74 35                	je     8014f4 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014bf:	83 ec 04             	sub    $0x4,%esp
  8014c2:	ff 75 10             	pushl  0x10(%ebp)
  8014c5:	ff 75 0c             	pushl  0xc(%ebp)
  8014c8:	50                   	push   %eax
  8014c9:	ff d2                	call   *%edx
  8014cb:	83 c4 10             	add    $0x10,%esp
}
  8014ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d1:	c9                   	leave  
  8014d2:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014d3:	a1 08 50 80 00       	mov    0x805008,%eax
  8014d8:	8b 40 48             	mov    0x48(%eax),%eax
  8014db:	83 ec 04             	sub    $0x4,%esp
  8014de:	53                   	push   %ebx
  8014df:	50                   	push   %eax
  8014e0:	68 b1 30 80 00       	push   $0x8030b1
  8014e5:	e8 94 ed ff ff       	call   80027e <cprintf>
		return -E_INVAL;
  8014ea:	83 c4 10             	add    $0x10,%esp
  8014ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f2:	eb da                	jmp    8014ce <write+0x55>
		return -E_NOT_SUPP;
  8014f4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014f9:	eb d3                	jmp    8014ce <write+0x55>

008014fb <seek>:

int
seek(int fdnum, off_t offset)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801501:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801504:	50                   	push   %eax
  801505:	ff 75 08             	pushl  0x8(%ebp)
  801508:	e8 30 fc ff ff       	call   80113d <fd_lookup>
  80150d:	83 c4 10             	add    $0x10,%esp
  801510:	85 c0                	test   %eax,%eax
  801512:	78 0e                	js     801522 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801514:	8b 55 0c             	mov    0xc(%ebp),%edx
  801517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80151a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80151d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	53                   	push   %ebx
  801528:	83 ec 1c             	sub    $0x1c,%esp
  80152b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80152e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801531:	50                   	push   %eax
  801532:	53                   	push   %ebx
  801533:	e8 05 fc ff ff       	call   80113d <fd_lookup>
  801538:	83 c4 10             	add    $0x10,%esp
  80153b:	85 c0                	test   %eax,%eax
  80153d:	78 37                	js     801576 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80153f:	83 ec 08             	sub    $0x8,%esp
  801542:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801545:	50                   	push   %eax
  801546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801549:	ff 30                	pushl  (%eax)
  80154b:	e8 3d fc ff ff       	call   80118d <dev_lookup>
  801550:	83 c4 10             	add    $0x10,%esp
  801553:	85 c0                	test   %eax,%eax
  801555:	78 1f                	js     801576 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80155e:	74 1b                	je     80157b <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801560:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801563:	8b 52 18             	mov    0x18(%edx),%edx
  801566:	85 d2                	test   %edx,%edx
  801568:	74 32                	je     80159c <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80156a:	83 ec 08             	sub    $0x8,%esp
  80156d:	ff 75 0c             	pushl  0xc(%ebp)
  801570:	50                   	push   %eax
  801571:	ff d2                	call   *%edx
  801573:	83 c4 10             	add    $0x10,%esp
}
  801576:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801579:	c9                   	leave  
  80157a:	c3                   	ret    
			thisenv->env_id, fdnum);
  80157b:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801580:	8b 40 48             	mov    0x48(%eax),%eax
  801583:	83 ec 04             	sub    $0x4,%esp
  801586:	53                   	push   %ebx
  801587:	50                   	push   %eax
  801588:	68 74 30 80 00       	push   $0x803074
  80158d:	e8 ec ec ff ff       	call   80027e <cprintf>
		return -E_INVAL;
  801592:	83 c4 10             	add    $0x10,%esp
  801595:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80159a:	eb da                	jmp    801576 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80159c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015a1:	eb d3                	jmp    801576 <ftruncate+0x52>

008015a3 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	53                   	push   %ebx
  8015a7:	83 ec 1c             	sub    $0x1c,%esp
  8015aa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015b0:	50                   	push   %eax
  8015b1:	ff 75 08             	pushl  0x8(%ebp)
  8015b4:	e8 84 fb ff ff       	call   80113d <fd_lookup>
  8015b9:	83 c4 10             	add    $0x10,%esp
  8015bc:	85 c0                	test   %eax,%eax
  8015be:	78 4b                	js     80160b <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015c0:	83 ec 08             	sub    $0x8,%esp
  8015c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c6:	50                   	push   %eax
  8015c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ca:	ff 30                	pushl  (%eax)
  8015cc:	e8 bc fb ff ff       	call   80118d <dev_lookup>
  8015d1:	83 c4 10             	add    $0x10,%esp
  8015d4:	85 c0                	test   %eax,%eax
  8015d6:	78 33                	js     80160b <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015db:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015df:	74 2f                	je     801610 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015e1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015e4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015eb:	00 00 00 
	stat->st_isdir = 0;
  8015ee:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015f5:	00 00 00 
	stat->st_dev = dev;
  8015f8:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015fe:	83 ec 08             	sub    $0x8,%esp
  801601:	53                   	push   %ebx
  801602:	ff 75 f0             	pushl  -0x10(%ebp)
  801605:	ff 50 14             	call   *0x14(%eax)
  801608:	83 c4 10             	add    $0x10,%esp
}
  80160b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    
		return -E_NOT_SUPP;
  801610:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801615:	eb f4                	jmp    80160b <fstat+0x68>

00801617 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
  80161a:	56                   	push   %esi
  80161b:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80161c:	83 ec 08             	sub    $0x8,%esp
  80161f:	6a 00                	push   $0x0
  801621:	ff 75 08             	pushl  0x8(%ebp)
  801624:	e8 22 02 00 00       	call   80184b <open>
  801629:	89 c3                	mov    %eax,%ebx
  80162b:	83 c4 10             	add    $0x10,%esp
  80162e:	85 c0                	test   %eax,%eax
  801630:	78 1b                	js     80164d <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801632:	83 ec 08             	sub    $0x8,%esp
  801635:	ff 75 0c             	pushl  0xc(%ebp)
  801638:	50                   	push   %eax
  801639:	e8 65 ff ff ff       	call   8015a3 <fstat>
  80163e:	89 c6                	mov    %eax,%esi
	close(fd);
  801640:	89 1c 24             	mov    %ebx,(%esp)
  801643:	e8 27 fc ff ff       	call   80126f <close>
	return r;
  801648:	83 c4 10             	add    $0x10,%esp
  80164b:	89 f3                	mov    %esi,%ebx
}
  80164d:	89 d8                	mov    %ebx,%eax
  80164f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801652:	5b                   	pop    %ebx
  801653:	5e                   	pop    %esi
  801654:	5d                   	pop    %ebp
  801655:	c3                   	ret    

00801656 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
  801659:	56                   	push   %esi
  80165a:	53                   	push   %ebx
  80165b:	89 c6                	mov    %eax,%esi
  80165d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80165f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801666:	74 27                	je     80168f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801668:	6a 07                	push   $0x7
  80166a:	68 00 60 80 00       	push   $0x806000
  80166f:	56                   	push   %esi
  801670:	ff 35 00 50 80 00    	pushl  0x805000
  801676:	e8 24 12 00 00       	call   80289f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80167b:	83 c4 0c             	add    $0xc,%esp
  80167e:	6a 00                	push   $0x0
  801680:	53                   	push   %ebx
  801681:	6a 00                	push   $0x0
  801683:	e8 ae 11 00 00       	call   802836 <ipc_recv>
}
  801688:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80168b:	5b                   	pop    %ebx
  80168c:	5e                   	pop    %esi
  80168d:	5d                   	pop    %ebp
  80168e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80168f:	83 ec 0c             	sub    $0xc,%esp
  801692:	6a 01                	push   $0x1
  801694:	e8 5e 12 00 00       	call   8028f7 <ipc_find_env>
  801699:	a3 00 50 80 00       	mov    %eax,0x805000
  80169e:	83 c4 10             	add    $0x10,%esp
  8016a1:	eb c5                	jmp    801668 <fsipc+0x12>

008016a3 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8016af:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8016b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b7:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c1:	b8 02 00 00 00       	mov    $0x2,%eax
  8016c6:	e8 8b ff ff ff       	call   801656 <fsipc>
}
  8016cb:	c9                   	leave  
  8016cc:	c3                   	ret    

008016cd <devfile_flush>:
{
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
  8016d0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8016d9:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8016de:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e3:	b8 06 00 00 00       	mov    $0x6,%eax
  8016e8:	e8 69 ff ff ff       	call   801656 <fsipc>
}
  8016ed:	c9                   	leave  
  8016ee:	c3                   	ret    

008016ef <devfile_stat>:
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
  8016f2:	53                   	push   %ebx
  8016f3:	83 ec 04             	sub    $0x4,%esp
  8016f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ff:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801704:	ba 00 00 00 00       	mov    $0x0,%edx
  801709:	b8 05 00 00 00       	mov    $0x5,%eax
  80170e:	e8 43 ff ff ff       	call   801656 <fsipc>
  801713:	85 c0                	test   %eax,%eax
  801715:	78 2c                	js     801743 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801717:	83 ec 08             	sub    $0x8,%esp
  80171a:	68 00 60 80 00       	push   $0x806000
  80171f:	53                   	push   %ebx
  801720:	e8 b8 f2 ff ff       	call   8009dd <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801725:	a1 80 60 80 00       	mov    0x806080,%eax
  80172a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801730:	a1 84 60 80 00       	mov    0x806084,%eax
  801735:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80173b:	83 c4 10             	add    $0x10,%esp
  80173e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801743:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801746:	c9                   	leave  
  801747:	c3                   	ret    

00801748 <devfile_write>:
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
  80174b:	53                   	push   %ebx
  80174c:	83 ec 08             	sub    $0x8,%esp
  80174f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	8b 40 0c             	mov    0xc(%eax),%eax
  801758:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  80175d:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801763:	53                   	push   %ebx
  801764:	ff 75 0c             	pushl  0xc(%ebp)
  801767:	68 08 60 80 00       	push   $0x806008
  80176c:	e8 5c f4 ff ff       	call   800bcd <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801771:	ba 00 00 00 00       	mov    $0x0,%edx
  801776:	b8 04 00 00 00       	mov    $0x4,%eax
  80177b:	e8 d6 fe ff ff       	call   801656 <fsipc>
  801780:	83 c4 10             	add    $0x10,%esp
  801783:	85 c0                	test   %eax,%eax
  801785:	78 0b                	js     801792 <devfile_write+0x4a>
	assert(r <= n);
  801787:	39 d8                	cmp    %ebx,%eax
  801789:	77 0c                	ja     801797 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80178b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801790:	7f 1e                	jg     8017b0 <devfile_write+0x68>
}
  801792:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801795:	c9                   	leave  
  801796:	c3                   	ret    
	assert(r <= n);
  801797:	68 e4 30 80 00       	push   $0x8030e4
  80179c:	68 eb 30 80 00       	push   $0x8030eb
  8017a1:	68 98 00 00 00       	push   $0x98
  8017a6:	68 00 31 80 00       	push   $0x803100
  8017ab:	e8 d8 e9 ff ff       	call   800188 <_panic>
	assert(r <= PGSIZE);
  8017b0:	68 0b 31 80 00       	push   $0x80310b
  8017b5:	68 eb 30 80 00       	push   $0x8030eb
  8017ba:	68 99 00 00 00       	push   $0x99
  8017bf:	68 00 31 80 00       	push   $0x803100
  8017c4:	e8 bf e9 ff ff       	call   800188 <_panic>

008017c9 <devfile_read>:
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
  8017cc:	56                   	push   %esi
  8017cd:	53                   	push   %ebx
  8017ce:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8017d7:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  8017dc:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e7:	b8 03 00 00 00       	mov    $0x3,%eax
  8017ec:	e8 65 fe ff ff       	call   801656 <fsipc>
  8017f1:	89 c3                	mov    %eax,%ebx
  8017f3:	85 c0                	test   %eax,%eax
  8017f5:	78 1f                	js     801816 <devfile_read+0x4d>
	assert(r <= n);
  8017f7:	39 f0                	cmp    %esi,%eax
  8017f9:	77 24                	ja     80181f <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017fb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801800:	7f 33                	jg     801835 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801802:	83 ec 04             	sub    $0x4,%esp
  801805:	50                   	push   %eax
  801806:	68 00 60 80 00       	push   $0x806000
  80180b:	ff 75 0c             	pushl  0xc(%ebp)
  80180e:	e8 58 f3 ff ff       	call   800b6b <memmove>
	return r;
  801813:	83 c4 10             	add    $0x10,%esp
}
  801816:	89 d8                	mov    %ebx,%eax
  801818:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80181b:	5b                   	pop    %ebx
  80181c:	5e                   	pop    %esi
  80181d:	5d                   	pop    %ebp
  80181e:	c3                   	ret    
	assert(r <= n);
  80181f:	68 e4 30 80 00       	push   $0x8030e4
  801824:	68 eb 30 80 00       	push   $0x8030eb
  801829:	6a 7c                	push   $0x7c
  80182b:	68 00 31 80 00       	push   $0x803100
  801830:	e8 53 e9 ff ff       	call   800188 <_panic>
	assert(r <= PGSIZE);
  801835:	68 0b 31 80 00       	push   $0x80310b
  80183a:	68 eb 30 80 00       	push   $0x8030eb
  80183f:	6a 7d                	push   $0x7d
  801841:	68 00 31 80 00       	push   $0x803100
  801846:	e8 3d e9 ff ff       	call   800188 <_panic>

0080184b <open>:
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	56                   	push   %esi
  80184f:	53                   	push   %ebx
  801850:	83 ec 1c             	sub    $0x1c,%esp
  801853:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801856:	56                   	push   %esi
  801857:	e8 48 f1 ff ff       	call   8009a4 <strlen>
  80185c:	83 c4 10             	add    $0x10,%esp
  80185f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801864:	7f 6c                	jg     8018d2 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801866:	83 ec 0c             	sub    $0xc,%esp
  801869:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80186c:	50                   	push   %eax
  80186d:	e8 79 f8 ff ff       	call   8010eb <fd_alloc>
  801872:	89 c3                	mov    %eax,%ebx
  801874:	83 c4 10             	add    $0x10,%esp
  801877:	85 c0                	test   %eax,%eax
  801879:	78 3c                	js     8018b7 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80187b:	83 ec 08             	sub    $0x8,%esp
  80187e:	56                   	push   %esi
  80187f:	68 00 60 80 00       	push   $0x806000
  801884:	e8 54 f1 ff ff       	call   8009dd <strcpy>
	fsipcbuf.open.req_omode = mode;
  801889:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188c:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801891:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801894:	b8 01 00 00 00       	mov    $0x1,%eax
  801899:	e8 b8 fd ff ff       	call   801656 <fsipc>
  80189e:	89 c3                	mov    %eax,%ebx
  8018a0:	83 c4 10             	add    $0x10,%esp
  8018a3:	85 c0                	test   %eax,%eax
  8018a5:	78 19                	js     8018c0 <open+0x75>
	return fd2num(fd);
  8018a7:	83 ec 0c             	sub    $0xc,%esp
  8018aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ad:	e8 12 f8 ff ff       	call   8010c4 <fd2num>
  8018b2:	89 c3                	mov    %eax,%ebx
  8018b4:	83 c4 10             	add    $0x10,%esp
}
  8018b7:	89 d8                	mov    %ebx,%eax
  8018b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018bc:	5b                   	pop    %ebx
  8018bd:	5e                   	pop    %esi
  8018be:	5d                   	pop    %ebp
  8018bf:	c3                   	ret    
		fd_close(fd, 0);
  8018c0:	83 ec 08             	sub    $0x8,%esp
  8018c3:	6a 00                	push   $0x0
  8018c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c8:	e8 1b f9 ff ff       	call   8011e8 <fd_close>
		return r;
  8018cd:	83 c4 10             	add    $0x10,%esp
  8018d0:	eb e5                	jmp    8018b7 <open+0x6c>
		return -E_BAD_PATH;
  8018d2:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018d7:	eb de                	jmp    8018b7 <open+0x6c>

008018d9 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
  8018dc:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018df:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e4:	b8 08 00 00 00       	mov    $0x8,%eax
  8018e9:	e8 68 fd ff ff       	call   801656 <fsipc>
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	57                   	push   %edi
  8018f4:	56                   	push   %esi
  8018f5:	53                   	push   %ebx
  8018f6:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  8018fc:	68 f0 31 80 00       	push   $0x8031f0
  801901:	68 6a 2c 80 00       	push   $0x802c6a
  801906:	e8 73 e9 ff ff       	call   80027e <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  80190b:	83 c4 08             	add    $0x8,%esp
  80190e:	6a 00                	push   $0x0
  801910:	ff 75 08             	pushl  0x8(%ebp)
  801913:	e8 33 ff ff ff       	call   80184b <open>
  801918:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  80191e:	83 c4 10             	add    $0x10,%esp
  801921:	85 c0                	test   %eax,%eax
  801923:	0f 88 0a 05 00 00    	js     801e33 <spawn+0x543>
  801929:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80192b:	83 ec 04             	sub    $0x4,%esp
  80192e:	68 00 02 00 00       	push   $0x200
  801933:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801939:	50                   	push   %eax
  80193a:	51                   	push   %ecx
  80193b:	e8 f4 fa ff ff       	call   801434 <readn>
  801940:	83 c4 10             	add    $0x10,%esp
  801943:	3d 00 02 00 00       	cmp    $0x200,%eax
  801948:	75 74                	jne    8019be <spawn+0xce>
	    || elf->e_magic != ELF_MAGIC) {
  80194a:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801951:	45 4c 46 
  801954:	75 68                	jne    8019be <spawn+0xce>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801956:	b8 07 00 00 00       	mov    $0x7,%eax
  80195b:	cd 30                	int    $0x30
  80195d:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801963:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801969:	85 c0                	test   %eax,%eax
  80196b:	0f 88 b6 04 00 00    	js     801e27 <spawn+0x537>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801971:	25 ff 03 00 00       	and    $0x3ff,%eax
  801976:	89 c6                	mov    %eax,%esi
  801978:	c1 e6 07             	shl    $0x7,%esi
  80197b:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801981:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801987:	b9 11 00 00 00       	mov    $0x11,%ecx
  80198c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  80198e:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801994:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  80199a:	83 ec 08             	sub    $0x8,%esp
  80199d:	68 e4 31 80 00       	push   $0x8031e4
  8019a2:	68 6a 2c 80 00       	push   $0x802c6a
  8019a7:	e8 d2 e8 ff ff       	call   80027e <cprintf>
  8019ac:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8019af:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  8019b4:	be 00 00 00 00       	mov    $0x0,%esi
  8019b9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8019bc:	eb 4b                	jmp    801a09 <spawn+0x119>
		close(fd);
  8019be:	83 ec 0c             	sub    $0xc,%esp
  8019c1:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8019c7:	e8 a3 f8 ff ff       	call   80126f <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8019cc:	83 c4 0c             	add    $0xc,%esp
  8019cf:	68 7f 45 4c 46       	push   $0x464c457f
  8019d4:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  8019da:	68 17 31 80 00       	push   $0x803117
  8019df:	e8 9a e8 ff ff       	call   80027e <cprintf>
		return -E_NOT_EXEC;
  8019e4:	83 c4 10             	add    $0x10,%esp
  8019e7:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  8019ee:	ff ff ff 
  8019f1:	e9 3d 04 00 00       	jmp    801e33 <spawn+0x543>
		string_size += strlen(argv[argc]) + 1;
  8019f6:	83 ec 0c             	sub    $0xc,%esp
  8019f9:	50                   	push   %eax
  8019fa:	e8 a5 ef ff ff       	call   8009a4 <strlen>
  8019ff:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801a03:	83 c3 01             	add    $0x1,%ebx
  801a06:	83 c4 10             	add    $0x10,%esp
  801a09:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801a10:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801a13:	85 c0                	test   %eax,%eax
  801a15:	75 df                	jne    8019f6 <spawn+0x106>
  801a17:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801a1d:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801a23:	bf 00 10 40 00       	mov    $0x401000,%edi
  801a28:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801a2a:	89 fa                	mov    %edi,%edx
  801a2c:	83 e2 fc             	and    $0xfffffffc,%edx
  801a2f:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801a36:	29 c2                	sub    %eax,%edx
  801a38:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801a3e:	8d 42 f8             	lea    -0x8(%edx),%eax
  801a41:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801a46:	0f 86 0a 04 00 00    	jbe    801e56 <spawn+0x566>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801a4c:	83 ec 04             	sub    $0x4,%esp
  801a4f:	6a 07                	push   $0x7
  801a51:	68 00 00 40 00       	push   $0x400000
  801a56:	6a 00                	push   $0x0
  801a58:	e8 72 f3 ff ff       	call   800dcf <sys_page_alloc>
  801a5d:	83 c4 10             	add    $0x10,%esp
  801a60:	85 c0                	test   %eax,%eax
  801a62:	0f 88 f3 03 00 00    	js     801e5b <spawn+0x56b>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801a68:	be 00 00 00 00       	mov    $0x0,%esi
  801a6d:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801a73:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a76:	eb 30                	jmp    801aa8 <spawn+0x1b8>
		argv_store[i] = UTEMP2USTACK(string_store);
  801a78:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801a7e:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801a84:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801a87:	83 ec 08             	sub    $0x8,%esp
  801a8a:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801a8d:	57                   	push   %edi
  801a8e:	e8 4a ef ff ff       	call   8009dd <strcpy>
		string_store += strlen(argv[i]) + 1;
  801a93:	83 c4 04             	add    $0x4,%esp
  801a96:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801a99:	e8 06 ef ff ff       	call   8009a4 <strlen>
  801a9e:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801aa2:	83 c6 01             	add    $0x1,%esi
  801aa5:	83 c4 10             	add    $0x10,%esp
  801aa8:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801aae:	7f c8                	jg     801a78 <spawn+0x188>
	}
	argv_store[argc] = 0;
  801ab0:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801ab6:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801abc:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801ac3:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801ac9:	0f 85 86 00 00 00    	jne    801b55 <spawn+0x265>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801acf:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  801ad5:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  801adb:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801ade:	89 d0                	mov    %edx,%eax
  801ae0:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801ae6:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801ae9:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801aee:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801af4:	83 ec 0c             	sub    $0xc,%esp
  801af7:	6a 07                	push   $0x7
  801af9:	68 00 d0 bf ee       	push   $0xeebfd000
  801afe:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801b04:	68 00 00 40 00       	push   $0x400000
  801b09:	6a 00                	push   $0x0
  801b0b:	e8 02 f3 ff ff       	call   800e12 <sys_page_map>
  801b10:	89 c3                	mov    %eax,%ebx
  801b12:	83 c4 20             	add    $0x20,%esp
  801b15:	85 c0                	test   %eax,%eax
  801b17:	0f 88 46 03 00 00    	js     801e63 <spawn+0x573>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801b1d:	83 ec 08             	sub    $0x8,%esp
  801b20:	68 00 00 40 00       	push   $0x400000
  801b25:	6a 00                	push   $0x0
  801b27:	e8 28 f3 ff ff       	call   800e54 <sys_page_unmap>
  801b2c:	89 c3                	mov    %eax,%ebx
  801b2e:	83 c4 10             	add    $0x10,%esp
  801b31:	85 c0                	test   %eax,%eax
  801b33:	0f 88 2a 03 00 00    	js     801e63 <spawn+0x573>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801b39:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801b3f:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801b46:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801b4d:	00 00 00 
  801b50:	e9 4f 01 00 00       	jmp    801ca4 <spawn+0x3b4>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801b55:	68 a0 31 80 00       	push   $0x8031a0
  801b5a:	68 eb 30 80 00       	push   $0x8030eb
  801b5f:	68 f8 00 00 00       	push   $0xf8
  801b64:	68 31 31 80 00       	push   $0x803131
  801b69:	e8 1a e6 ff ff       	call   800188 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801b6e:	83 ec 04             	sub    $0x4,%esp
  801b71:	6a 07                	push   $0x7
  801b73:	68 00 00 40 00       	push   $0x400000
  801b78:	6a 00                	push   $0x0
  801b7a:	e8 50 f2 ff ff       	call   800dcf <sys_page_alloc>
  801b7f:	83 c4 10             	add    $0x10,%esp
  801b82:	85 c0                	test   %eax,%eax
  801b84:	0f 88 b7 02 00 00    	js     801e41 <spawn+0x551>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801b8a:	83 ec 08             	sub    $0x8,%esp
  801b8d:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801b93:	01 f0                	add    %esi,%eax
  801b95:	50                   	push   %eax
  801b96:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801b9c:	e8 5a f9 ff ff       	call   8014fb <seek>
  801ba1:	83 c4 10             	add    $0x10,%esp
  801ba4:	85 c0                	test   %eax,%eax
  801ba6:	0f 88 9c 02 00 00    	js     801e48 <spawn+0x558>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801bac:	83 ec 04             	sub    $0x4,%esp
  801baf:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801bb5:	29 f0                	sub    %esi,%eax
  801bb7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bbc:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801bc1:	0f 47 c1             	cmova  %ecx,%eax
  801bc4:	50                   	push   %eax
  801bc5:	68 00 00 40 00       	push   $0x400000
  801bca:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801bd0:	e8 5f f8 ff ff       	call   801434 <readn>
  801bd5:	83 c4 10             	add    $0x10,%esp
  801bd8:	85 c0                	test   %eax,%eax
  801bda:	0f 88 6f 02 00 00    	js     801e4f <spawn+0x55f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801be0:	83 ec 0c             	sub    $0xc,%esp
  801be3:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801be9:	53                   	push   %ebx
  801bea:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801bf0:	68 00 00 40 00       	push   $0x400000
  801bf5:	6a 00                	push   $0x0
  801bf7:	e8 16 f2 ff ff       	call   800e12 <sys_page_map>
  801bfc:	83 c4 20             	add    $0x20,%esp
  801bff:	85 c0                	test   %eax,%eax
  801c01:	78 7c                	js     801c7f <spawn+0x38f>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801c03:	83 ec 08             	sub    $0x8,%esp
  801c06:	68 00 00 40 00       	push   $0x400000
  801c0b:	6a 00                	push   $0x0
  801c0d:	e8 42 f2 ff ff       	call   800e54 <sys_page_unmap>
  801c12:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801c15:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801c1b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c21:	89 fe                	mov    %edi,%esi
  801c23:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801c29:	76 69                	jbe    801c94 <spawn+0x3a4>
		if (i >= filesz) {
  801c2b:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801c31:	0f 87 37 ff ff ff    	ja     801b6e <spawn+0x27e>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801c37:	83 ec 04             	sub    $0x4,%esp
  801c3a:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801c40:	53                   	push   %ebx
  801c41:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801c47:	e8 83 f1 ff ff       	call   800dcf <sys_page_alloc>
  801c4c:	83 c4 10             	add    $0x10,%esp
  801c4f:	85 c0                	test   %eax,%eax
  801c51:	79 c2                	jns    801c15 <spawn+0x325>
  801c53:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801c55:	83 ec 0c             	sub    $0xc,%esp
  801c58:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801c5e:	e8 ed f0 ff ff       	call   800d50 <sys_env_destroy>
	close(fd);
  801c63:	83 c4 04             	add    $0x4,%esp
  801c66:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801c6c:	e8 fe f5 ff ff       	call   80126f <close>
	return r;
  801c71:	83 c4 10             	add    $0x10,%esp
  801c74:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801c7a:	e9 b4 01 00 00       	jmp    801e33 <spawn+0x543>
				panic("spawn: sys_page_map data: %e", r);
  801c7f:	50                   	push   %eax
  801c80:	68 3d 31 80 00       	push   $0x80313d
  801c85:	68 2b 01 00 00       	push   $0x12b
  801c8a:	68 31 31 80 00       	push   $0x803131
  801c8f:	e8 f4 e4 ff ff       	call   800188 <_panic>
  801c94:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801c9a:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801ca1:	83 c6 20             	add    $0x20,%esi
  801ca4:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801cab:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801cb1:	7e 6d                	jle    801d20 <spawn+0x430>
		if (ph->p_type != ELF_PROG_LOAD)
  801cb3:	83 3e 01             	cmpl   $0x1,(%esi)
  801cb6:	75 e2                	jne    801c9a <spawn+0x3aa>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801cb8:	8b 46 18             	mov    0x18(%esi),%eax
  801cbb:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801cbe:	83 f8 01             	cmp    $0x1,%eax
  801cc1:	19 c0                	sbb    %eax,%eax
  801cc3:	83 e0 fe             	and    $0xfffffffe,%eax
  801cc6:	83 c0 07             	add    $0x7,%eax
  801cc9:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801ccf:	8b 4e 04             	mov    0x4(%esi),%ecx
  801cd2:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801cd8:	8b 56 10             	mov    0x10(%esi),%edx
  801cdb:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801ce1:	8b 7e 14             	mov    0x14(%esi),%edi
  801ce4:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801cea:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801ced:	89 d8                	mov    %ebx,%eax
  801cef:	25 ff 0f 00 00       	and    $0xfff,%eax
  801cf4:	74 1a                	je     801d10 <spawn+0x420>
		va -= i;
  801cf6:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801cf8:	01 c7                	add    %eax,%edi
  801cfa:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801d00:	01 c2                	add    %eax,%edx
  801d02:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801d08:	29 c1                	sub    %eax,%ecx
  801d0a:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801d10:	bf 00 00 00 00       	mov    $0x0,%edi
  801d15:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801d1b:	e9 01 ff ff ff       	jmp    801c21 <spawn+0x331>
	close(fd);
  801d20:	83 ec 0c             	sub    $0xc,%esp
  801d23:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801d29:	e8 41 f5 ff ff       	call   80126f <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  801d2e:	83 c4 08             	add    $0x8,%esp
  801d31:	68 d0 31 80 00       	push   $0x8031d0
  801d36:	68 6a 2c 80 00       	push   $0x802c6a
  801d3b:	e8 3e e5 ff ff       	call   80027e <cprintf>
  801d40:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  801d43:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801d48:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801d4e:	eb 0e                	jmp    801d5e <spawn+0x46e>
  801d50:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801d56:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801d5c:	74 5e                	je     801dbc <spawn+0x4cc>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  801d5e:	89 d8                	mov    %ebx,%eax
  801d60:	c1 e8 16             	shr    $0x16,%eax
  801d63:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d6a:	a8 01                	test   $0x1,%al
  801d6c:	74 e2                	je     801d50 <spawn+0x460>
  801d6e:	89 da                	mov    %ebx,%edx
  801d70:	c1 ea 0c             	shr    $0xc,%edx
  801d73:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801d7a:	25 05 04 00 00       	and    $0x405,%eax
  801d7f:	3d 05 04 00 00       	cmp    $0x405,%eax
  801d84:	75 ca                	jne    801d50 <spawn+0x460>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  801d86:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801d8d:	83 ec 0c             	sub    $0xc,%esp
  801d90:	25 07 0e 00 00       	and    $0xe07,%eax
  801d95:	50                   	push   %eax
  801d96:	53                   	push   %ebx
  801d97:	56                   	push   %esi
  801d98:	53                   	push   %ebx
  801d99:	6a 00                	push   $0x0
  801d9b:	e8 72 f0 ff ff       	call   800e12 <sys_page_map>
  801da0:	83 c4 20             	add    $0x20,%esp
  801da3:	85 c0                	test   %eax,%eax
  801da5:	79 a9                	jns    801d50 <spawn+0x460>
        		panic("sys_page_map: %e\n", r);
  801da7:	50                   	push   %eax
  801da8:	68 5a 31 80 00       	push   $0x80315a
  801dad:	68 3b 01 00 00       	push   $0x13b
  801db2:	68 31 31 80 00       	push   $0x803131
  801db7:	e8 cc e3 ff ff       	call   800188 <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801dbc:	83 ec 08             	sub    $0x8,%esp
  801dbf:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801dc5:	50                   	push   %eax
  801dc6:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801dcc:	e8 07 f1 ff ff       	call   800ed8 <sys_env_set_trapframe>
  801dd1:	83 c4 10             	add    $0x10,%esp
  801dd4:	85 c0                	test   %eax,%eax
  801dd6:	78 25                	js     801dfd <spawn+0x50d>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801dd8:	83 ec 08             	sub    $0x8,%esp
  801ddb:	6a 02                	push   $0x2
  801ddd:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801de3:	e8 ae f0 ff ff       	call   800e96 <sys_env_set_status>
  801de8:	83 c4 10             	add    $0x10,%esp
  801deb:	85 c0                	test   %eax,%eax
  801ded:	78 23                	js     801e12 <spawn+0x522>
	return child;
  801def:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801df5:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801dfb:	eb 36                	jmp    801e33 <spawn+0x543>
		panic("sys_env_set_trapframe: %e", r);
  801dfd:	50                   	push   %eax
  801dfe:	68 6c 31 80 00       	push   $0x80316c
  801e03:	68 8a 00 00 00       	push   $0x8a
  801e08:	68 31 31 80 00       	push   $0x803131
  801e0d:	e8 76 e3 ff ff       	call   800188 <_panic>
		panic("sys_env_set_status: %e", r);
  801e12:	50                   	push   %eax
  801e13:	68 86 31 80 00       	push   $0x803186
  801e18:	68 8d 00 00 00       	push   $0x8d
  801e1d:	68 31 31 80 00       	push   $0x803131
  801e22:	e8 61 e3 ff ff       	call   800188 <_panic>
		return r;
  801e27:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e2d:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801e33:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801e39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e3c:	5b                   	pop    %ebx
  801e3d:	5e                   	pop    %esi
  801e3e:	5f                   	pop    %edi
  801e3f:	5d                   	pop    %ebp
  801e40:	c3                   	ret    
  801e41:	89 c7                	mov    %eax,%edi
  801e43:	e9 0d fe ff ff       	jmp    801c55 <spawn+0x365>
  801e48:	89 c7                	mov    %eax,%edi
  801e4a:	e9 06 fe ff ff       	jmp    801c55 <spawn+0x365>
  801e4f:	89 c7                	mov    %eax,%edi
  801e51:	e9 ff fd ff ff       	jmp    801c55 <spawn+0x365>
		return -E_NO_MEM;
  801e56:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  801e5b:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801e61:	eb d0                	jmp    801e33 <spawn+0x543>
	sys_page_unmap(0, UTEMP);
  801e63:	83 ec 08             	sub    $0x8,%esp
  801e66:	68 00 00 40 00       	push   $0x400000
  801e6b:	6a 00                	push   $0x0
  801e6d:	e8 e2 ef ff ff       	call   800e54 <sys_page_unmap>
  801e72:	83 c4 10             	add    $0x10,%esp
  801e75:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801e7b:	eb b6                	jmp    801e33 <spawn+0x543>

00801e7d <spawnl>:
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
  801e80:	57                   	push   %edi
  801e81:	56                   	push   %esi
  801e82:	53                   	push   %ebx
  801e83:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  801e86:	68 c8 31 80 00       	push   $0x8031c8
  801e8b:	68 6a 2c 80 00       	push   $0x802c6a
  801e90:	e8 e9 e3 ff ff       	call   80027e <cprintf>
	va_start(vl, arg0);
  801e95:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  801e98:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  801e9b:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801ea0:	8d 4a 04             	lea    0x4(%edx),%ecx
  801ea3:	83 3a 00             	cmpl   $0x0,(%edx)
  801ea6:	74 07                	je     801eaf <spawnl+0x32>
		argc++;
  801ea8:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801eab:	89 ca                	mov    %ecx,%edx
  801ead:	eb f1                	jmp    801ea0 <spawnl+0x23>
	const char *argv[argc+2];
  801eaf:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801eb6:	83 e2 f0             	and    $0xfffffff0,%edx
  801eb9:	29 d4                	sub    %edx,%esp
  801ebb:	8d 54 24 03          	lea    0x3(%esp),%edx
  801ebf:	c1 ea 02             	shr    $0x2,%edx
  801ec2:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801ec9:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801ecb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ece:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801ed5:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801edc:	00 
	va_start(vl, arg0);
  801edd:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801ee0:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801ee2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee7:	eb 0b                	jmp    801ef4 <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  801ee9:	83 c0 01             	add    $0x1,%eax
  801eec:	8b 39                	mov    (%ecx),%edi
  801eee:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801ef1:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801ef4:	39 d0                	cmp    %edx,%eax
  801ef6:	75 f1                	jne    801ee9 <spawnl+0x6c>
	return spawn(prog, argv);
  801ef8:	83 ec 08             	sub    $0x8,%esp
  801efb:	56                   	push   %esi
  801efc:	ff 75 08             	pushl  0x8(%ebp)
  801eff:	e8 ec f9 ff ff       	call   8018f0 <spawn>
}
  801f04:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f07:	5b                   	pop    %ebx
  801f08:	5e                   	pop    %esi
  801f09:	5f                   	pop    %edi
  801f0a:	5d                   	pop    %ebp
  801f0b:	c3                   	ret    

00801f0c <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f0c:	55                   	push   %ebp
  801f0d:	89 e5                	mov    %esp,%ebp
  801f0f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f12:	68 f6 31 80 00       	push   $0x8031f6
  801f17:	ff 75 0c             	pushl  0xc(%ebp)
  801f1a:	e8 be ea ff ff       	call   8009dd <strcpy>
	return 0;
}
  801f1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <devsock_close>:
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	53                   	push   %ebx
  801f2a:	83 ec 10             	sub    $0x10,%esp
  801f2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f30:	53                   	push   %ebx
  801f31:	e8 fc 09 00 00       	call   802932 <pageref>
  801f36:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f39:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f3e:	83 f8 01             	cmp    $0x1,%eax
  801f41:	74 07                	je     801f4a <devsock_close+0x24>
}
  801f43:	89 d0                	mov    %edx,%eax
  801f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f4a:	83 ec 0c             	sub    $0xc,%esp
  801f4d:	ff 73 0c             	pushl  0xc(%ebx)
  801f50:	e8 b9 02 00 00       	call   80220e <nsipc_close>
  801f55:	89 c2                	mov    %eax,%edx
  801f57:	83 c4 10             	add    $0x10,%esp
  801f5a:	eb e7                	jmp    801f43 <devsock_close+0x1d>

00801f5c <devsock_write>:
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f62:	6a 00                	push   $0x0
  801f64:	ff 75 10             	pushl  0x10(%ebp)
  801f67:	ff 75 0c             	pushl  0xc(%ebp)
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	ff 70 0c             	pushl  0xc(%eax)
  801f70:	e8 76 03 00 00       	call   8022eb <nsipc_send>
}
  801f75:	c9                   	leave  
  801f76:	c3                   	ret    

00801f77 <devsock_read>:
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
  801f7a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f7d:	6a 00                	push   $0x0
  801f7f:	ff 75 10             	pushl  0x10(%ebp)
  801f82:	ff 75 0c             	pushl  0xc(%ebp)
  801f85:	8b 45 08             	mov    0x8(%ebp),%eax
  801f88:	ff 70 0c             	pushl  0xc(%eax)
  801f8b:	e8 ef 02 00 00       	call   80227f <nsipc_recv>
}
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <fd2sockid>:
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
  801f95:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f98:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f9b:	52                   	push   %edx
  801f9c:	50                   	push   %eax
  801f9d:	e8 9b f1 ff ff       	call   80113d <fd_lookup>
  801fa2:	83 c4 10             	add    $0x10,%esp
  801fa5:	85 c0                	test   %eax,%eax
  801fa7:	78 10                	js     801fb9 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fac:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801fb2:	39 08                	cmp    %ecx,(%eax)
  801fb4:	75 05                	jne    801fbb <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801fb6:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801fb9:	c9                   	leave  
  801fba:	c3                   	ret    
		return -E_NOT_SUPP;
  801fbb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fc0:	eb f7                	jmp    801fb9 <fd2sockid+0x27>

00801fc2 <alloc_sockfd>:
{
  801fc2:	55                   	push   %ebp
  801fc3:	89 e5                	mov    %esp,%ebp
  801fc5:	56                   	push   %esi
  801fc6:	53                   	push   %ebx
  801fc7:	83 ec 1c             	sub    $0x1c,%esp
  801fca:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801fcc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fcf:	50                   	push   %eax
  801fd0:	e8 16 f1 ff ff       	call   8010eb <fd_alloc>
  801fd5:	89 c3                	mov    %eax,%ebx
  801fd7:	83 c4 10             	add    $0x10,%esp
  801fda:	85 c0                	test   %eax,%eax
  801fdc:	78 43                	js     802021 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801fde:	83 ec 04             	sub    $0x4,%esp
  801fe1:	68 07 04 00 00       	push   $0x407
  801fe6:	ff 75 f4             	pushl  -0xc(%ebp)
  801fe9:	6a 00                	push   $0x0
  801feb:	e8 df ed ff ff       	call   800dcf <sys_page_alloc>
  801ff0:	89 c3                	mov    %eax,%ebx
  801ff2:	83 c4 10             	add    $0x10,%esp
  801ff5:	85 c0                	test   %eax,%eax
  801ff7:	78 28                	js     802021 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffc:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802002:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802007:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80200e:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802011:	83 ec 0c             	sub    $0xc,%esp
  802014:	50                   	push   %eax
  802015:	e8 aa f0 ff ff       	call   8010c4 <fd2num>
  80201a:	89 c3                	mov    %eax,%ebx
  80201c:	83 c4 10             	add    $0x10,%esp
  80201f:	eb 0c                	jmp    80202d <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802021:	83 ec 0c             	sub    $0xc,%esp
  802024:	56                   	push   %esi
  802025:	e8 e4 01 00 00       	call   80220e <nsipc_close>
		return r;
  80202a:	83 c4 10             	add    $0x10,%esp
}
  80202d:	89 d8                	mov    %ebx,%eax
  80202f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802032:	5b                   	pop    %ebx
  802033:	5e                   	pop    %esi
  802034:	5d                   	pop    %ebp
  802035:	c3                   	ret    

00802036 <accept>:
{
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
  802039:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80203c:	8b 45 08             	mov    0x8(%ebp),%eax
  80203f:	e8 4e ff ff ff       	call   801f92 <fd2sockid>
  802044:	85 c0                	test   %eax,%eax
  802046:	78 1b                	js     802063 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802048:	83 ec 04             	sub    $0x4,%esp
  80204b:	ff 75 10             	pushl  0x10(%ebp)
  80204e:	ff 75 0c             	pushl  0xc(%ebp)
  802051:	50                   	push   %eax
  802052:	e8 0e 01 00 00       	call   802165 <nsipc_accept>
  802057:	83 c4 10             	add    $0x10,%esp
  80205a:	85 c0                	test   %eax,%eax
  80205c:	78 05                	js     802063 <accept+0x2d>
	return alloc_sockfd(r);
  80205e:	e8 5f ff ff ff       	call   801fc2 <alloc_sockfd>
}
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <bind>:
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80206b:	8b 45 08             	mov    0x8(%ebp),%eax
  80206e:	e8 1f ff ff ff       	call   801f92 <fd2sockid>
  802073:	85 c0                	test   %eax,%eax
  802075:	78 12                	js     802089 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802077:	83 ec 04             	sub    $0x4,%esp
  80207a:	ff 75 10             	pushl  0x10(%ebp)
  80207d:	ff 75 0c             	pushl  0xc(%ebp)
  802080:	50                   	push   %eax
  802081:	e8 31 01 00 00       	call   8021b7 <nsipc_bind>
  802086:	83 c4 10             	add    $0x10,%esp
}
  802089:	c9                   	leave  
  80208a:	c3                   	ret    

0080208b <shutdown>:
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
  80208e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802091:	8b 45 08             	mov    0x8(%ebp),%eax
  802094:	e8 f9 fe ff ff       	call   801f92 <fd2sockid>
  802099:	85 c0                	test   %eax,%eax
  80209b:	78 0f                	js     8020ac <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80209d:	83 ec 08             	sub    $0x8,%esp
  8020a0:	ff 75 0c             	pushl  0xc(%ebp)
  8020a3:	50                   	push   %eax
  8020a4:	e8 43 01 00 00       	call   8021ec <nsipc_shutdown>
  8020a9:	83 c4 10             	add    $0x10,%esp
}
  8020ac:	c9                   	leave  
  8020ad:	c3                   	ret    

008020ae <connect>:
{
  8020ae:	55                   	push   %ebp
  8020af:	89 e5                	mov    %esp,%ebp
  8020b1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	e8 d6 fe ff ff       	call   801f92 <fd2sockid>
  8020bc:	85 c0                	test   %eax,%eax
  8020be:	78 12                	js     8020d2 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8020c0:	83 ec 04             	sub    $0x4,%esp
  8020c3:	ff 75 10             	pushl  0x10(%ebp)
  8020c6:	ff 75 0c             	pushl  0xc(%ebp)
  8020c9:	50                   	push   %eax
  8020ca:	e8 59 01 00 00       	call   802228 <nsipc_connect>
  8020cf:	83 c4 10             	add    $0x10,%esp
}
  8020d2:	c9                   	leave  
  8020d3:	c3                   	ret    

008020d4 <listen>:
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
  8020d7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020da:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dd:	e8 b0 fe ff ff       	call   801f92 <fd2sockid>
  8020e2:	85 c0                	test   %eax,%eax
  8020e4:	78 0f                	js     8020f5 <listen+0x21>
	return nsipc_listen(r, backlog);
  8020e6:	83 ec 08             	sub    $0x8,%esp
  8020e9:	ff 75 0c             	pushl  0xc(%ebp)
  8020ec:	50                   	push   %eax
  8020ed:	e8 6b 01 00 00       	call   80225d <nsipc_listen>
  8020f2:	83 c4 10             	add    $0x10,%esp
}
  8020f5:	c9                   	leave  
  8020f6:	c3                   	ret    

008020f7 <socket>:

int
socket(int domain, int type, int protocol)
{
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
  8020fa:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020fd:	ff 75 10             	pushl  0x10(%ebp)
  802100:	ff 75 0c             	pushl  0xc(%ebp)
  802103:	ff 75 08             	pushl  0x8(%ebp)
  802106:	e8 3e 02 00 00       	call   802349 <nsipc_socket>
  80210b:	83 c4 10             	add    $0x10,%esp
  80210e:	85 c0                	test   %eax,%eax
  802110:	78 05                	js     802117 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802112:	e8 ab fe ff ff       	call   801fc2 <alloc_sockfd>
}
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
  80211c:	53                   	push   %ebx
  80211d:	83 ec 04             	sub    $0x4,%esp
  802120:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802122:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802129:	74 26                	je     802151 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80212b:	6a 07                	push   $0x7
  80212d:	68 00 70 80 00       	push   $0x807000
  802132:	53                   	push   %ebx
  802133:	ff 35 04 50 80 00    	pushl  0x805004
  802139:	e8 61 07 00 00       	call   80289f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80213e:	83 c4 0c             	add    $0xc,%esp
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	e8 ea 06 00 00       	call   802836 <ipc_recv>
}
  80214c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80214f:	c9                   	leave  
  802150:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802151:	83 ec 0c             	sub    $0xc,%esp
  802154:	6a 02                	push   $0x2
  802156:	e8 9c 07 00 00       	call   8028f7 <ipc_find_env>
  80215b:	a3 04 50 80 00       	mov    %eax,0x805004
  802160:	83 c4 10             	add    $0x10,%esp
  802163:	eb c6                	jmp    80212b <nsipc+0x12>

00802165 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
  802168:	56                   	push   %esi
  802169:	53                   	push   %ebx
  80216a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802175:	8b 06                	mov    (%esi),%eax
  802177:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80217c:	b8 01 00 00 00       	mov    $0x1,%eax
  802181:	e8 93 ff ff ff       	call   802119 <nsipc>
  802186:	89 c3                	mov    %eax,%ebx
  802188:	85 c0                	test   %eax,%eax
  80218a:	79 09                	jns    802195 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80218c:	89 d8                	mov    %ebx,%eax
  80218e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802191:	5b                   	pop    %ebx
  802192:	5e                   	pop    %esi
  802193:	5d                   	pop    %ebp
  802194:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802195:	83 ec 04             	sub    $0x4,%esp
  802198:	ff 35 10 70 80 00    	pushl  0x807010
  80219e:	68 00 70 80 00       	push   $0x807000
  8021a3:	ff 75 0c             	pushl  0xc(%ebp)
  8021a6:	e8 c0 e9 ff ff       	call   800b6b <memmove>
		*addrlen = ret->ret_addrlen;
  8021ab:	a1 10 70 80 00       	mov    0x807010,%eax
  8021b0:	89 06                	mov    %eax,(%esi)
  8021b2:	83 c4 10             	add    $0x10,%esp
	return r;
  8021b5:	eb d5                	jmp    80218c <nsipc_accept+0x27>

008021b7 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
  8021ba:	53                   	push   %ebx
  8021bb:	83 ec 08             	sub    $0x8,%esp
  8021be:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c4:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021c9:	53                   	push   %ebx
  8021ca:	ff 75 0c             	pushl  0xc(%ebp)
  8021cd:	68 04 70 80 00       	push   $0x807004
  8021d2:	e8 94 e9 ff ff       	call   800b6b <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021d7:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021dd:	b8 02 00 00 00       	mov    $0x2,%eax
  8021e2:	e8 32 ff ff ff       	call   802119 <nsipc>
}
  8021e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    

008021ec <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
  8021ef:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8021fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021fd:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802202:	b8 03 00 00 00       	mov    $0x3,%eax
  802207:	e8 0d ff ff ff       	call   802119 <nsipc>
}
  80220c:	c9                   	leave  
  80220d:	c3                   	ret    

0080220e <nsipc_close>:

int
nsipc_close(int s)
{
  80220e:	55                   	push   %ebp
  80220f:	89 e5                	mov    %esp,%ebp
  802211:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80221c:	b8 04 00 00 00       	mov    $0x4,%eax
  802221:	e8 f3 fe ff ff       	call   802119 <nsipc>
}
  802226:	c9                   	leave  
  802227:	c3                   	ret    

00802228 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
  80222b:	53                   	push   %ebx
  80222c:	83 ec 08             	sub    $0x8,%esp
  80222f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80223a:	53                   	push   %ebx
  80223b:	ff 75 0c             	pushl  0xc(%ebp)
  80223e:	68 04 70 80 00       	push   $0x807004
  802243:	e8 23 e9 ff ff       	call   800b6b <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802248:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80224e:	b8 05 00 00 00       	mov    $0x5,%eax
  802253:	e8 c1 fe ff ff       	call   802119 <nsipc>
}
  802258:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80225b:	c9                   	leave  
  80225c:	c3                   	ret    

0080225d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80225d:	55                   	push   %ebp
  80225e:	89 e5                	mov    %esp,%ebp
  802260:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80226b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226e:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802273:	b8 06 00 00 00       	mov    $0x6,%eax
  802278:	e8 9c fe ff ff       	call   802119 <nsipc>
}
  80227d:	c9                   	leave  
  80227e:	c3                   	ret    

0080227f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80227f:	55                   	push   %ebp
  802280:	89 e5                	mov    %esp,%ebp
  802282:	56                   	push   %esi
  802283:	53                   	push   %ebx
  802284:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802287:	8b 45 08             	mov    0x8(%ebp),%eax
  80228a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80228f:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802295:	8b 45 14             	mov    0x14(%ebp),%eax
  802298:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80229d:	b8 07 00 00 00       	mov    $0x7,%eax
  8022a2:	e8 72 fe ff ff       	call   802119 <nsipc>
  8022a7:	89 c3                	mov    %eax,%ebx
  8022a9:	85 c0                	test   %eax,%eax
  8022ab:	78 1f                	js     8022cc <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8022ad:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022b2:	7f 21                	jg     8022d5 <nsipc_recv+0x56>
  8022b4:	39 c6                	cmp    %eax,%esi
  8022b6:	7c 1d                	jl     8022d5 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022b8:	83 ec 04             	sub    $0x4,%esp
  8022bb:	50                   	push   %eax
  8022bc:	68 00 70 80 00       	push   $0x807000
  8022c1:	ff 75 0c             	pushl  0xc(%ebp)
  8022c4:	e8 a2 e8 ff ff       	call   800b6b <memmove>
  8022c9:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8022cc:	89 d8                	mov    %ebx,%eax
  8022ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022d1:	5b                   	pop    %ebx
  8022d2:	5e                   	pop    %esi
  8022d3:	5d                   	pop    %ebp
  8022d4:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8022d5:	68 02 32 80 00       	push   $0x803202
  8022da:	68 eb 30 80 00       	push   $0x8030eb
  8022df:	6a 62                	push   $0x62
  8022e1:	68 17 32 80 00       	push   $0x803217
  8022e6:	e8 9d de ff ff       	call   800188 <_panic>

008022eb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022eb:	55                   	push   %ebp
  8022ec:	89 e5                	mov    %esp,%ebp
  8022ee:	53                   	push   %ebx
  8022ef:	83 ec 04             	sub    $0x4,%esp
  8022f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8022fd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802303:	7f 2e                	jg     802333 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802305:	83 ec 04             	sub    $0x4,%esp
  802308:	53                   	push   %ebx
  802309:	ff 75 0c             	pushl  0xc(%ebp)
  80230c:	68 0c 70 80 00       	push   $0x80700c
  802311:	e8 55 e8 ff ff       	call   800b6b <memmove>
	nsipcbuf.send.req_size = size;
  802316:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80231c:	8b 45 14             	mov    0x14(%ebp),%eax
  80231f:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802324:	b8 08 00 00 00       	mov    $0x8,%eax
  802329:	e8 eb fd ff ff       	call   802119 <nsipc>
}
  80232e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802331:	c9                   	leave  
  802332:	c3                   	ret    
	assert(size < 1600);
  802333:	68 23 32 80 00       	push   $0x803223
  802338:	68 eb 30 80 00       	push   $0x8030eb
  80233d:	6a 6d                	push   $0x6d
  80233f:	68 17 32 80 00       	push   $0x803217
  802344:	e8 3f de ff ff       	call   800188 <_panic>

00802349 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802349:	55                   	push   %ebp
  80234a:	89 e5                	mov    %esp,%ebp
  80234c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80234f:	8b 45 08             	mov    0x8(%ebp),%eax
  802352:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802357:	8b 45 0c             	mov    0xc(%ebp),%eax
  80235a:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80235f:	8b 45 10             	mov    0x10(%ebp),%eax
  802362:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802367:	b8 09 00 00 00       	mov    $0x9,%eax
  80236c:	e8 a8 fd ff ff       	call   802119 <nsipc>
}
  802371:	c9                   	leave  
  802372:	c3                   	ret    

00802373 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802373:	55                   	push   %ebp
  802374:	89 e5                	mov    %esp,%ebp
  802376:	56                   	push   %esi
  802377:	53                   	push   %ebx
  802378:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80237b:	83 ec 0c             	sub    $0xc,%esp
  80237e:	ff 75 08             	pushl  0x8(%ebp)
  802381:	e8 4e ed ff ff       	call   8010d4 <fd2data>
  802386:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802388:	83 c4 08             	add    $0x8,%esp
  80238b:	68 2f 32 80 00       	push   $0x80322f
  802390:	53                   	push   %ebx
  802391:	e8 47 e6 ff ff       	call   8009dd <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802396:	8b 46 04             	mov    0x4(%esi),%eax
  802399:	2b 06                	sub    (%esi),%eax
  80239b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8023a1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023a8:	00 00 00 
	stat->st_dev = &devpipe;
  8023ab:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8023b2:	40 80 00 
	return 0;
}
  8023b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023bd:	5b                   	pop    %ebx
  8023be:	5e                   	pop    %esi
  8023bf:	5d                   	pop    %ebp
  8023c0:	c3                   	ret    

008023c1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023c1:	55                   	push   %ebp
  8023c2:	89 e5                	mov    %esp,%ebp
  8023c4:	53                   	push   %ebx
  8023c5:	83 ec 0c             	sub    $0xc,%esp
  8023c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023cb:	53                   	push   %ebx
  8023cc:	6a 00                	push   $0x0
  8023ce:	e8 81 ea ff ff       	call   800e54 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023d3:	89 1c 24             	mov    %ebx,(%esp)
  8023d6:	e8 f9 ec ff ff       	call   8010d4 <fd2data>
  8023db:	83 c4 08             	add    $0x8,%esp
  8023de:	50                   	push   %eax
  8023df:	6a 00                	push   $0x0
  8023e1:	e8 6e ea ff ff       	call   800e54 <sys_page_unmap>
}
  8023e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023e9:	c9                   	leave  
  8023ea:	c3                   	ret    

008023eb <_pipeisclosed>:
{
  8023eb:	55                   	push   %ebp
  8023ec:	89 e5                	mov    %esp,%ebp
  8023ee:	57                   	push   %edi
  8023ef:	56                   	push   %esi
  8023f0:	53                   	push   %ebx
  8023f1:	83 ec 1c             	sub    $0x1c,%esp
  8023f4:	89 c7                	mov    %eax,%edi
  8023f6:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8023f8:	a1 08 50 80 00       	mov    0x805008,%eax
  8023fd:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802400:	83 ec 0c             	sub    $0xc,%esp
  802403:	57                   	push   %edi
  802404:	e8 29 05 00 00       	call   802932 <pageref>
  802409:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80240c:	89 34 24             	mov    %esi,(%esp)
  80240f:	e8 1e 05 00 00       	call   802932 <pageref>
		nn = thisenv->env_runs;
  802414:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80241a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80241d:	83 c4 10             	add    $0x10,%esp
  802420:	39 cb                	cmp    %ecx,%ebx
  802422:	74 1b                	je     80243f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802424:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802427:	75 cf                	jne    8023f8 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802429:	8b 42 58             	mov    0x58(%edx),%eax
  80242c:	6a 01                	push   $0x1
  80242e:	50                   	push   %eax
  80242f:	53                   	push   %ebx
  802430:	68 36 32 80 00       	push   $0x803236
  802435:	e8 44 de ff ff       	call   80027e <cprintf>
  80243a:	83 c4 10             	add    $0x10,%esp
  80243d:	eb b9                	jmp    8023f8 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80243f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802442:	0f 94 c0             	sete   %al
  802445:	0f b6 c0             	movzbl %al,%eax
}
  802448:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80244b:	5b                   	pop    %ebx
  80244c:	5e                   	pop    %esi
  80244d:	5f                   	pop    %edi
  80244e:	5d                   	pop    %ebp
  80244f:	c3                   	ret    

00802450 <devpipe_write>:
{
  802450:	55                   	push   %ebp
  802451:	89 e5                	mov    %esp,%ebp
  802453:	57                   	push   %edi
  802454:	56                   	push   %esi
  802455:	53                   	push   %ebx
  802456:	83 ec 28             	sub    $0x28,%esp
  802459:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80245c:	56                   	push   %esi
  80245d:	e8 72 ec ff ff       	call   8010d4 <fd2data>
  802462:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802464:	83 c4 10             	add    $0x10,%esp
  802467:	bf 00 00 00 00       	mov    $0x0,%edi
  80246c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80246f:	74 4f                	je     8024c0 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802471:	8b 43 04             	mov    0x4(%ebx),%eax
  802474:	8b 0b                	mov    (%ebx),%ecx
  802476:	8d 51 20             	lea    0x20(%ecx),%edx
  802479:	39 d0                	cmp    %edx,%eax
  80247b:	72 14                	jb     802491 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80247d:	89 da                	mov    %ebx,%edx
  80247f:	89 f0                	mov    %esi,%eax
  802481:	e8 65 ff ff ff       	call   8023eb <_pipeisclosed>
  802486:	85 c0                	test   %eax,%eax
  802488:	75 3b                	jne    8024c5 <devpipe_write+0x75>
			sys_yield();
  80248a:	e8 21 e9 ff ff       	call   800db0 <sys_yield>
  80248f:	eb e0                	jmp    802471 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802491:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802494:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802498:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80249b:	89 c2                	mov    %eax,%edx
  80249d:	c1 fa 1f             	sar    $0x1f,%edx
  8024a0:	89 d1                	mov    %edx,%ecx
  8024a2:	c1 e9 1b             	shr    $0x1b,%ecx
  8024a5:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8024a8:	83 e2 1f             	and    $0x1f,%edx
  8024ab:	29 ca                	sub    %ecx,%edx
  8024ad:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8024b1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8024b5:	83 c0 01             	add    $0x1,%eax
  8024b8:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8024bb:	83 c7 01             	add    $0x1,%edi
  8024be:	eb ac                	jmp    80246c <devpipe_write+0x1c>
	return i;
  8024c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8024c3:	eb 05                	jmp    8024ca <devpipe_write+0x7a>
				return 0;
  8024c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024cd:	5b                   	pop    %ebx
  8024ce:	5e                   	pop    %esi
  8024cf:	5f                   	pop    %edi
  8024d0:	5d                   	pop    %ebp
  8024d1:	c3                   	ret    

008024d2 <devpipe_read>:
{
  8024d2:	55                   	push   %ebp
  8024d3:	89 e5                	mov    %esp,%ebp
  8024d5:	57                   	push   %edi
  8024d6:	56                   	push   %esi
  8024d7:	53                   	push   %ebx
  8024d8:	83 ec 18             	sub    $0x18,%esp
  8024db:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8024de:	57                   	push   %edi
  8024df:	e8 f0 eb ff ff       	call   8010d4 <fd2data>
  8024e4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024e6:	83 c4 10             	add    $0x10,%esp
  8024e9:	be 00 00 00 00       	mov    $0x0,%esi
  8024ee:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024f1:	75 14                	jne    802507 <devpipe_read+0x35>
	return i;
  8024f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f6:	eb 02                	jmp    8024fa <devpipe_read+0x28>
				return i;
  8024f8:	89 f0                	mov    %esi,%eax
}
  8024fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024fd:	5b                   	pop    %ebx
  8024fe:	5e                   	pop    %esi
  8024ff:	5f                   	pop    %edi
  802500:	5d                   	pop    %ebp
  802501:	c3                   	ret    
			sys_yield();
  802502:	e8 a9 e8 ff ff       	call   800db0 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802507:	8b 03                	mov    (%ebx),%eax
  802509:	3b 43 04             	cmp    0x4(%ebx),%eax
  80250c:	75 18                	jne    802526 <devpipe_read+0x54>
			if (i > 0)
  80250e:	85 f6                	test   %esi,%esi
  802510:	75 e6                	jne    8024f8 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  802512:	89 da                	mov    %ebx,%edx
  802514:	89 f8                	mov    %edi,%eax
  802516:	e8 d0 fe ff ff       	call   8023eb <_pipeisclosed>
  80251b:	85 c0                	test   %eax,%eax
  80251d:	74 e3                	je     802502 <devpipe_read+0x30>
				return 0;
  80251f:	b8 00 00 00 00       	mov    $0x0,%eax
  802524:	eb d4                	jmp    8024fa <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802526:	99                   	cltd   
  802527:	c1 ea 1b             	shr    $0x1b,%edx
  80252a:	01 d0                	add    %edx,%eax
  80252c:	83 e0 1f             	and    $0x1f,%eax
  80252f:	29 d0                	sub    %edx,%eax
  802531:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802536:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802539:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80253c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80253f:	83 c6 01             	add    $0x1,%esi
  802542:	eb aa                	jmp    8024ee <devpipe_read+0x1c>

00802544 <pipe>:
{
  802544:	55                   	push   %ebp
  802545:	89 e5                	mov    %esp,%ebp
  802547:	56                   	push   %esi
  802548:	53                   	push   %ebx
  802549:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80254c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80254f:	50                   	push   %eax
  802550:	e8 96 eb ff ff       	call   8010eb <fd_alloc>
  802555:	89 c3                	mov    %eax,%ebx
  802557:	83 c4 10             	add    $0x10,%esp
  80255a:	85 c0                	test   %eax,%eax
  80255c:	0f 88 23 01 00 00    	js     802685 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802562:	83 ec 04             	sub    $0x4,%esp
  802565:	68 07 04 00 00       	push   $0x407
  80256a:	ff 75 f4             	pushl  -0xc(%ebp)
  80256d:	6a 00                	push   $0x0
  80256f:	e8 5b e8 ff ff       	call   800dcf <sys_page_alloc>
  802574:	89 c3                	mov    %eax,%ebx
  802576:	83 c4 10             	add    $0x10,%esp
  802579:	85 c0                	test   %eax,%eax
  80257b:	0f 88 04 01 00 00    	js     802685 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802581:	83 ec 0c             	sub    $0xc,%esp
  802584:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802587:	50                   	push   %eax
  802588:	e8 5e eb ff ff       	call   8010eb <fd_alloc>
  80258d:	89 c3                	mov    %eax,%ebx
  80258f:	83 c4 10             	add    $0x10,%esp
  802592:	85 c0                	test   %eax,%eax
  802594:	0f 88 db 00 00 00    	js     802675 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80259a:	83 ec 04             	sub    $0x4,%esp
  80259d:	68 07 04 00 00       	push   $0x407
  8025a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8025a5:	6a 00                	push   $0x0
  8025a7:	e8 23 e8 ff ff       	call   800dcf <sys_page_alloc>
  8025ac:	89 c3                	mov    %eax,%ebx
  8025ae:	83 c4 10             	add    $0x10,%esp
  8025b1:	85 c0                	test   %eax,%eax
  8025b3:	0f 88 bc 00 00 00    	js     802675 <pipe+0x131>
	va = fd2data(fd0);
  8025b9:	83 ec 0c             	sub    $0xc,%esp
  8025bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8025bf:	e8 10 eb ff ff       	call   8010d4 <fd2data>
  8025c4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025c6:	83 c4 0c             	add    $0xc,%esp
  8025c9:	68 07 04 00 00       	push   $0x407
  8025ce:	50                   	push   %eax
  8025cf:	6a 00                	push   $0x0
  8025d1:	e8 f9 e7 ff ff       	call   800dcf <sys_page_alloc>
  8025d6:	89 c3                	mov    %eax,%ebx
  8025d8:	83 c4 10             	add    $0x10,%esp
  8025db:	85 c0                	test   %eax,%eax
  8025dd:	0f 88 82 00 00 00    	js     802665 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025e3:	83 ec 0c             	sub    $0xc,%esp
  8025e6:	ff 75 f0             	pushl  -0x10(%ebp)
  8025e9:	e8 e6 ea ff ff       	call   8010d4 <fd2data>
  8025ee:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8025f5:	50                   	push   %eax
  8025f6:	6a 00                	push   $0x0
  8025f8:	56                   	push   %esi
  8025f9:	6a 00                	push   $0x0
  8025fb:	e8 12 e8 ff ff       	call   800e12 <sys_page_map>
  802600:	89 c3                	mov    %eax,%ebx
  802602:	83 c4 20             	add    $0x20,%esp
  802605:	85 c0                	test   %eax,%eax
  802607:	78 4e                	js     802657 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  802609:	a1 3c 40 80 00       	mov    0x80403c,%eax
  80260e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802611:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802613:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802616:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80261d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802620:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802622:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802625:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80262c:	83 ec 0c             	sub    $0xc,%esp
  80262f:	ff 75 f4             	pushl  -0xc(%ebp)
  802632:	e8 8d ea ff ff       	call   8010c4 <fd2num>
  802637:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80263a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80263c:	83 c4 04             	add    $0x4,%esp
  80263f:	ff 75 f0             	pushl  -0x10(%ebp)
  802642:	e8 7d ea ff ff       	call   8010c4 <fd2num>
  802647:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80264a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80264d:	83 c4 10             	add    $0x10,%esp
  802650:	bb 00 00 00 00       	mov    $0x0,%ebx
  802655:	eb 2e                	jmp    802685 <pipe+0x141>
	sys_page_unmap(0, va);
  802657:	83 ec 08             	sub    $0x8,%esp
  80265a:	56                   	push   %esi
  80265b:	6a 00                	push   $0x0
  80265d:	e8 f2 e7 ff ff       	call   800e54 <sys_page_unmap>
  802662:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802665:	83 ec 08             	sub    $0x8,%esp
  802668:	ff 75 f0             	pushl  -0x10(%ebp)
  80266b:	6a 00                	push   $0x0
  80266d:	e8 e2 e7 ff ff       	call   800e54 <sys_page_unmap>
  802672:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802675:	83 ec 08             	sub    $0x8,%esp
  802678:	ff 75 f4             	pushl  -0xc(%ebp)
  80267b:	6a 00                	push   $0x0
  80267d:	e8 d2 e7 ff ff       	call   800e54 <sys_page_unmap>
  802682:	83 c4 10             	add    $0x10,%esp
}
  802685:	89 d8                	mov    %ebx,%eax
  802687:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80268a:	5b                   	pop    %ebx
  80268b:	5e                   	pop    %esi
  80268c:	5d                   	pop    %ebp
  80268d:	c3                   	ret    

0080268e <pipeisclosed>:
{
  80268e:	55                   	push   %ebp
  80268f:	89 e5                	mov    %esp,%ebp
  802691:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802694:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802697:	50                   	push   %eax
  802698:	ff 75 08             	pushl  0x8(%ebp)
  80269b:	e8 9d ea ff ff       	call   80113d <fd_lookup>
  8026a0:	83 c4 10             	add    $0x10,%esp
  8026a3:	85 c0                	test   %eax,%eax
  8026a5:	78 18                	js     8026bf <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8026a7:	83 ec 0c             	sub    $0xc,%esp
  8026aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8026ad:	e8 22 ea ff ff       	call   8010d4 <fd2data>
	return _pipeisclosed(fd, p);
  8026b2:	89 c2                	mov    %eax,%edx
  8026b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b7:	e8 2f fd ff ff       	call   8023eb <_pipeisclosed>
  8026bc:	83 c4 10             	add    $0x10,%esp
}
  8026bf:	c9                   	leave  
  8026c0:	c3                   	ret    

008026c1 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8026c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c6:	c3                   	ret    

008026c7 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026c7:	55                   	push   %ebp
  8026c8:	89 e5                	mov    %esp,%ebp
  8026ca:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8026cd:	68 4e 32 80 00       	push   $0x80324e
  8026d2:	ff 75 0c             	pushl  0xc(%ebp)
  8026d5:	e8 03 e3 ff ff       	call   8009dd <strcpy>
	return 0;
}
  8026da:	b8 00 00 00 00       	mov    $0x0,%eax
  8026df:	c9                   	leave  
  8026e0:	c3                   	ret    

008026e1 <devcons_write>:
{
  8026e1:	55                   	push   %ebp
  8026e2:	89 e5                	mov    %esp,%ebp
  8026e4:	57                   	push   %edi
  8026e5:	56                   	push   %esi
  8026e6:	53                   	push   %ebx
  8026e7:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8026ed:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8026f2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8026f8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026fb:	73 31                	jae    80272e <devcons_write+0x4d>
		m = n - tot;
  8026fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802700:	29 f3                	sub    %esi,%ebx
  802702:	83 fb 7f             	cmp    $0x7f,%ebx
  802705:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80270a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80270d:	83 ec 04             	sub    $0x4,%esp
  802710:	53                   	push   %ebx
  802711:	89 f0                	mov    %esi,%eax
  802713:	03 45 0c             	add    0xc(%ebp),%eax
  802716:	50                   	push   %eax
  802717:	57                   	push   %edi
  802718:	e8 4e e4 ff ff       	call   800b6b <memmove>
		sys_cputs(buf, m);
  80271d:	83 c4 08             	add    $0x8,%esp
  802720:	53                   	push   %ebx
  802721:	57                   	push   %edi
  802722:	e8 ec e5 ff ff       	call   800d13 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802727:	01 de                	add    %ebx,%esi
  802729:	83 c4 10             	add    $0x10,%esp
  80272c:	eb ca                	jmp    8026f8 <devcons_write+0x17>
}
  80272e:	89 f0                	mov    %esi,%eax
  802730:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802733:	5b                   	pop    %ebx
  802734:	5e                   	pop    %esi
  802735:	5f                   	pop    %edi
  802736:	5d                   	pop    %ebp
  802737:	c3                   	ret    

00802738 <devcons_read>:
{
  802738:	55                   	push   %ebp
  802739:	89 e5                	mov    %esp,%ebp
  80273b:	83 ec 08             	sub    $0x8,%esp
  80273e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802743:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802747:	74 21                	je     80276a <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802749:	e8 e3 e5 ff ff       	call   800d31 <sys_cgetc>
  80274e:	85 c0                	test   %eax,%eax
  802750:	75 07                	jne    802759 <devcons_read+0x21>
		sys_yield();
  802752:	e8 59 e6 ff ff       	call   800db0 <sys_yield>
  802757:	eb f0                	jmp    802749 <devcons_read+0x11>
	if (c < 0)
  802759:	78 0f                	js     80276a <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80275b:	83 f8 04             	cmp    $0x4,%eax
  80275e:	74 0c                	je     80276c <devcons_read+0x34>
	*(char*)vbuf = c;
  802760:	8b 55 0c             	mov    0xc(%ebp),%edx
  802763:	88 02                	mov    %al,(%edx)
	return 1;
  802765:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80276a:	c9                   	leave  
  80276b:	c3                   	ret    
		return 0;
  80276c:	b8 00 00 00 00       	mov    $0x0,%eax
  802771:	eb f7                	jmp    80276a <devcons_read+0x32>

00802773 <cputchar>:
{
  802773:	55                   	push   %ebp
  802774:	89 e5                	mov    %esp,%ebp
  802776:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802779:	8b 45 08             	mov    0x8(%ebp),%eax
  80277c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80277f:	6a 01                	push   $0x1
  802781:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802784:	50                   	push   %eax
  802785:	e8 89 e5 ff ff       	call   800d13 <sys_cputs>
}
  80278a:	83 c4 10             	add    $0x10,%esp
  80278d:	c9                   	leave  
  80278e:	c3                   	ret    

0080278f <getchar>:
{
  80278f:	55                   	push   %ebp
  802790:	89 e5                	mov    %esp,%ebp
  802792:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802795:	6a 01                	push   $0x1
  802797:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80279a:	50                   	push   %eax
  80279b:	6a 00                	push   $0x0
  80279d:	e8 0b ec ff ff       	call   8013ad <read>
	if (r < 0)
  8027a2:	83 c4 10             	add    $0x10,%esp
  8027a5:	85 c0                	test   %eax,%eax
  8027a7:	78 06                	js     8027af <getchar+0x20>
	if (r < 1)
  8027a9:	74 06                	je     8027b1 <getchar+0x22>
	return c;
  8027ab:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8027af:	c9                   	leave  
  8027b0:	c3                   	ret    
		return -E_EOF;
  8027b1:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8027b6:	eb f7                	jmp    8027af <getchar+0x20>

008027b8 <iscons>:
{
  8027b8:	55                   	push   %ebp
  8027b9:	89 e5                	mov    %esp,%ebp
  8027bb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027c1:	50                   	push   %eax
  8027c2:	ff 75 08             	pushl  0x8(%ebp)
  8027c5:	e8 73 e9 ff ff       	call   80113d <fd_lookup>
  8027ca:	83 c4 10             	add    $0x10,%esp
  8027cd:	85 c0                	test   %eax,%eax
  8027cf:	78 11                	js     8027e2 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027da:	39 10                	cmp    %edx,(%eax)
  8027dc:	0f 94 c0             	sete   %al
  8027df:	0f b6 c0             	movzbl %al,%eax
}
  8027e2:	c9                   	leave  
  8027e3:	c3                   	ret    

008027e4 <opencons>:
{
  8027e4:	55                   	push   %ebp
  8027e5:	89 e5                	mov    %esp,%ebp
  8027e7:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8027ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027ed:	50                   	push   %eax
  8027ee:	e8 f8 e8 ff ff       	call   8010eb <fd_alloc>
  8027f3:	83 c4 10             	add    $0x10,%esp
  8027f6:	85 c0                	test   %eax,%eax
  8027f8:	78 3a                	js     802834 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8027fa:	83 ec 04             	sub    $0x4,%esp
  8027fd:	68 07 04 00 00       	push   $0x407
  802802:	ff 75 f4             	pushl  -0xc(%ebp)
  802805:	6a 00                	push   $0x0
  802807:	e8 c3 e5 ff ff       	call   800dcf <sys_page_alloc>
  80280c:	83 c4 10             	add    $0x10,%esp
  80280f:	85 c0                	test   %eax,%eax
  802811:	78 21                	js     802834 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802816:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80281c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802828:	83 ec 0c             	sub    $0xc,%esp
  80282b:	50                   	push   %eax
  80282c:	e8 93 e8 ff ff       	call   8010c4 <fd2num>
  802831:	83 c4 10             	add    $0x10,%esp
}
  802834:	c9                   	leave  
  802835:	c3                   	ret    

00802836 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802836:	55                   	push   %ebp
  802837:	89 e5                	mov    %esp,%ebp
  802839:	56                   	push   %esi
  80283a:	53                   	push   %ebx
  80283b:	8b 75 08             	mov    0x8(%ebp),%esi
  80283e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802841:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802844:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802846:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80284b:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80284e:	83 ec 0c             	sub    $0xc,%esp
  802851:	50                   	push   %eax
  802852:	e8 28 e7 ff ff       	call   800f7f <sys_ipc_recv>
	if(ret < 0){
  802857:	83 c4 10             	add    $0x10,%esp
  80285a:	85 c0                	test   %eax,%eax
  80285c:	78 2b                	js     802889 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80285e:	85 f6                	test   %esi,%esi
  802860:	74 0a                	je     80286c <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802862:	a1 08 50 80 00       	mov    0x805008,%eax
  802867:	8b 40 74             	mov    0x74(%eax),%eax
  80286a:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80286c:	85 db                	test   %ebx,%ebx
  80286e:	74 0a                	je     80287a <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802870:	a1 08 50 80 00       	mov    0x805008,%eax
  802875:	8b 40 78             	mov    0x78(%eax),%eax
  802878:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80287a:	a1 08 50 80 00       	mov    0x805008,%eax
  80287f:	8b 40 70             	mov    0x70(%eax),%eax
}
  802882:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802885:	5b                   	pop    %ebx
  802886:	5e                   	pop    %esi
  802887:	5d                   	pop    %ebp
  802888:	c3                   	ret    
		if(from_env_store)
  802889:	85 f6                	test   %esi,%esi
  80288b:	74 06                	je     802893 <ipc_recv+0x5d>
			*from_env_store = 0;
  80288d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802893:	85 db                	test   %ebx,%ebx
  802895:	74 eb                	je     802882 <ipc_recv+0x4c>
			*perm_store = 0;
  802897:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80289d:	eb e3                	jmp    802882 <ipc_recv+0x4c>

0080289f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80289f:	55                   	push   %ebp
  8028a0:	89 e5                	mov    %esp,%ebp
  8028a2:	57                   	push   %edi
  8028a3:	56                   	push   %esi
  8028a4:	53                   	push   %ebx
  8028a5:	83 ec 0c             	sub    $0xc,%esp
  8028a8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8028ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  8028ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8028b1:	85 db                	test   %ebx,%ebx
  8028b3:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8028b8:	0f 44 d8             	cmove  %eax,%ebx
  8028bb:	eb 05                	jmp    8028c2 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8028bd:	e8 ee e4 ff ff       	call   800db0 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8028c2:	ff 75 14             	pushl  0x14(%ebp)
  8028c5:	53                   	push   %ebx
  8028c6:	56                   	push   %esi
  8028c7:	57                   	push   %edi
  8028c8:	e8 8f e6 ff ff       	call   800f5c <sys_ipc_try_send>
  8028cd:	83 c4 10             	add    $0x10,%esp
  8028d0:	85 c0                	test   %eax,%eax
  8028d2:	74 1b                	je     8028ef <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8028d4:	79 e7                	jns    8028bd <ipc_send+0x1e>
  8028d6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8028d9:	74 e2                	je     8028bd <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8028db:	83 ec 04             	sub    $0x4,%esp
  8028de:	68 5a 32 80 00       	push   $0x80325a
  8028e3:	6a 46                	push   $0x46
  8028e5:	68 6f 32 80 00       	push   $0x80326f
  8028ea:	e8 99 d8 ff ff       	call   800188 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8028ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028f2:	5b                   	pop    %ebx
  8028f3:	5e                   	pop    %esi
  8028f4:	5f                   	pop    %edi
  8028f5:	5d                   	pop    %ebp
  8028f6:	c3                   	ret    

008028f7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8028f7:	55                   	push   %ebp
  8028f8:	89 e5                	mov    %esp,%ebp
  8028fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8028fd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802902:	89 c2                	mov    %eax,%edx
  802904:	c1 e2 07             	shl    $0x7,%edx
  802907:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80290d:	8b 52 50             	mov    0x50(%edx),%edx
  802910:	39 ca                	cmp    %ecx,%edx
  802912:	74 11                	je     802925 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802914:	83 c0 01             	add    $0x1,%eax
  802917:	3d 00 04 00 00       	cmp    $0x400,%eax
  80291c:	75 e4                	jne    802902 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80291e:	b8 00 00 00 00       	mov    $0x0,%eax
  802923:	eb 0b                	jmp    802930 <ipc_find_env+0x39>
			return envs[i].env_id;
  802925:	c1 e0 07             	shl    $0x7,%eax
  802928:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80292d:	8b 40 48             	mov    0x48(%eax),%eax
}
  802930:	5d                   	pop    %ebp
  802931:	c3                   	ret    

00802932 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802932:	55                   	push   %ebp
  802933:	89 e5                	mov    %esp,%ebp
  802935:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802938:	89 d0                	mov    %edx,%eax
  80293a:	c1 e8 16             	shr    $0x16,%eax
  80293d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802944:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802949:	f6 c1 01             	test   $0x1,%cl
  80294c:	74 1d                	je     80296b <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80294e:	c1 ea 0c             	shr    $0xc,%edx
  802951:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802958:	f6 c2 01             	test   $0x1,%dl
  80295b:	74 0e                	je     80296b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80295d:	c1 ea 0c             	shr    $0xc,%edx
  802960:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802967:	ef 
  802968:	0f b7 c0             	movzwl %ax,%eax
}
  80296b:	5d                   	pop    %ebp
  80296c:	c3                   	ret    
  80296d:	66 90                	xchg   %ax,%ax
  80296f:	90                   	nop

00802970 <__udivdi3>:
  802970:	55                   	push   %ebp
  802971:	57                   	push   %edi
  802972:	56                   	push   %esi
  802973:	53                   	push   %ebx
  802974:	83 ec 1c             	sub    $0x1c,%esp
  802977:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80297b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80297f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802983:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802987:	85 d2                	test   %edx,%edx
  802989:	75 4d                	jne    8029d8 <__udivdi3+0x68>
  80298b:	39 f3                	cmp    %esi,%ebx
  80298d:	76 19                	jbe    8029a8 <__udivdi3+0x38>
  80298f:	31 ff                	xor    %edi,%edi
  802991:	89 e8                	mov    %ebp,%eax
  802993:	89 f2                	mov    %esi,%edx
  802995:	f7 f3                	div    %ebx
  802997:	89 fa                	mov    %edi,%edx
  802999:	83 c4 1c             	add    $0x1c,%esp
  80299c:	5b                   	pop    %ebx
  80299d:	5e                   	pop    %esi
  80299e:	5f                   	pop    %edi
  80299f:	5d                   	pop    %ebp
  8029a0:	c3                   	ret    
  8029a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029a8:	89 d9                	mov    %ebx,%ecx
  8029aa:	85 db                	test   %ebx,%ebx
  8029ac:	75 0b                	jne    8029b9 <__udivdi3+0x49>
  8029ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8029b3:	31 d2                	xor    %edx,%edx
  8029b5:	f7 f3                	div    %ebx
  8029b7:	89 c1                	mov    %eax,%ecx
  8029b9:	31 d2                	xor    %edx,%edx
  8029bb:	89 f0                	mov    %esi,%eax
  8029bd:	f7 f1                	div    %ecx
  8029bf:	89 c6                	mov    %eax,%esi
  8029c1:	89 e8                	mov    %ebp,%eax
  8029c3:	89 f7                	mov    %esi,%edi
  8029c5:	f7 f1                	div    %ecx
  8029c7:	89 fa                	mov    %edi,%edx
  8029c9:	83 c4 1c             	add    $0x1c,%esp
  8029cc:	5b                   	pop    %ebx
  8029cd:	5e                   	pop    %esi
  8029ce:	5f                   	pop    %edi
  8029cf:	5d                   	pop    %ebp
  8029d0:	c3                   	ret    
  8029d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029d8:	39 f2                	cmp    %esi,%edx
  8029da:	77 1c                	ja     8029f8 <__udivdi3+0x88>
  8029dc:	0f bd fa             	bsr    %edx,%edi
  8029df:	83 f7 1f             	xor    $0x1f,%edi
  8029e2:	75 2c                	jne    802a10 <__udivdi3+0xa0>
  8029e4:	39 f2                	cmp    %esi,%edx
  8029e6:	72 06                	jb     8029ee <__udivdi3+0x7e>
  8029e8:	31 c0                	xor    %eax,%eax
  8029ea:	39 eb                	cmp    %ebp,%ebx
  8029ec:	77 a9                	ja     802997 <__udivdi3+0x27>
  8029ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8029f3:	eb a2                	jmp    802997 <__udivdi3+0x27>
  8029f5:	8d 76 00             	lea    0x0(%esi),%esi
  8029f8:	31 ff                	xor    %edi,%edi
  8029fa:	31 c0                	xor    %eax,%eax
  8029fc:	89 fa                	mov    %edi,%edx
  8029fe:	83 c4 1c             	add    $0x1c,%esp
  802a01:	5b                   	pop    %ebx
  802a02:	5e                   	pop    %esi
  802a03:	5f                   	pop    %edi
  802a04:	5d                   	pop    %ebp
  802a05:	c3                   	ret    
  802a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a0d:	8d 76 00             	lea    0x0(%esi),%esi
  802a10:	89 f9                	mov    %edi,%ecx
  802a12:	b8 20 00 00 00       	mov    $0x20,%eax
  802a17:	29 f8                	sub    %edi,%eax
  802a19:	d3 e2                	shl    %cl,%edx
  802a1b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a1f:	89 c1                	mov    %eax,%ecx
  802a21:	89 da                	mov    %ebx,%edx
  802a23:	d3 ea                	shr    %cl,%edx
  802a25:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a29:	09 d1                	or     %edx,%ecx
  802a2b:	89 f2                	mov    %esi,%edx
  802a2d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a31:	89 f9                	mov    %edi,%ecx
  802a33:	d3 e3                	shl    %cl,%ebx
  802a35:	89 c1                	mov    %eax,%ecx
  802a37:	d3 ea                	shr    %cl,%edx
  802a39:	89 f9                	mov    %edi,%ecx
  802a3b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a3f:	89 eb                	mov    %ebp,%ebx
  802a41:	d3 e6                	shl    %cl,%esi
  802a43:	89 c1                	mov    %eax,%ecx
  802a45:	d3 eb                	shr    %cl,%ebx
  802a47:	09 de                	or     %ebx,%esi
  802a49:	89 f0                	mov    %esi,%eax
  802a4b:	f7 74 24 08          	divl   0x8(%esp)
  802a4f:	89 d6                	mov    %edx,%esi
  802a51:	89 c3                	mov    %eax,%ebx
  802a53:	f7 64 24 0c          	mull   0xc(%esp)
  802a57:	39 d6                	cmp    %edx,%esi
  802a59:	72 15                	jb     802a70 <__udivdi3+0x100>
  802a5b:	89 f9                	mov    %edi,%ecx
  802a5d:	d3 e5                	shl    %cl,%ebp
  802a5f:	39 c5                	cmp    %eax,%ebp
  802a61:	73 04                	jae    802a67 <__udivdi3+0xf7>
  802a63:	39 d6                	cmp    %edx,%esi
  802a65:	74 09                	je     802a70 <__udivdi3+0x100>
  802a67:	89 d8                	mov    %ebx,%eax
  802a69:	31 ff                	xor    %edi,%edi
  802a6b:	e9 27 ff ff ff       	jmp    802997 <__udivdi3+0x27>
  802a70:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a73:	31 ff                	xor    %edi,%edi
  802a75:	e9 1d ff ff ff       	jmp    802997 <__udivdi3+0x27>
  802a7a:	66 90                	xchg   %ax,%ax
  802a7c:	66 90                	xchg   %ax,%ax
  802a7e:	66 90                	xchg   %ax,%ax

00802a80 <__umoddi3>:
  802a80:	55                   	push   %ebp
  802a81:	57                   	push   %edi
  802a82:	56                   	push   %esi
  802a83:	53                   	push   %ebx
  802a84:	83 ec 1c             	sub    $0x1c,%esp
  802a87:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802a8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a8f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a97:	89 da                	mov    %ebx,%edx
  802a99:	85 c0                	test   %eax,%eax
  802a9b:	75 43                	jne    802ae0 <__umoddi3+0x60>
  802a9d:	39 df                	cmp    %ebx,%edi
  802a9f:	76 17                	jbe    802ab8 <__umoddi3+0x38>
  802aa1:	89 f0                	mov    %esi,%eax
  802aa3:	f7 f7                	div    %edi
  802aa5:	89 d0                	mov    %edx,%eax
  802aa7:	31 d2                	xor    %edx,%edx
  802aa9:	83 c4 1c             	add    $0x1c,%esp
  802aac:	5b                   	pop    %ebx
  802aad:	5e                   	pop    %esi
  802aae:	5f                   	pop    %edi
  802aaf:	5d                   	pop    %ebp
  802ab0:	c3                   	ret    
  802ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ab8:	89 fd                	mov    %edi,%ebp
  802aba:	85 ff                	test   %edi,%edi
  802abc:	75 0b                	jne    802ac9 <__umoddi3+0x49>
  802abe:	b8 01 00 00 00       	mov    $0x1,%eax
  802ac3:	31 d2                	xor    %edx,%edx
  802ac5:	f7 f7                	div    %edi
  802ac7:	89 c5                	mov    %eax,%ebp
  802ac9:	89 d8                	mov    %ebx,%eax
  802acb:	31 d2                	xor    %edx,%edx
  802acd:	f7 f5                	div    %ebp
  802acf:	89 f0                	mov    %esi,%eax
  802ad1:	f7 f5                	div    %ebp
  802ad3:	89 d0                	mov    %edx,%eax
  802ad5:	eb d0                	jmp    802aa7 <__umoddi3+0x27>
  802ad7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ade:	66 90                	xchg   %ax,%ax
  802ae0:	89 f1                	mov    %esi,%ecx
  802ae2:	39 d8                	cmp    %ebx,%eax
  802ae4:	76 0a                	jbe    802af0 <__umoddi3+0x70>
  802ae6:	89 f0                	mov    %esi,%eax
  802ae8:	83 c4 1c             	add    $0x1c,%esp
  802aeb:	5b                   	pop    %ebx
  802aec:	5e                   	pop    %esi
  802aed:	5f                   	pop    %edi
  802aee:	5d                   	pop    %ebp
  802aef:	c3                   	ret    
  802af0:	0f bd e8             	bsr    %eax,%ebp
  802af3:	83 f5 1f             	xor    $0x1f,%ebp
  802af6:	75 20                	jne    802b18 <__umoddi3+0x98>
  802af8:	39 d8                	cmp    %ebx,%eax
  802afa:	0f 82 b0 00 00 00    	jb     802bb0 <__umoddi3+0x130>
  802b00:	39 f7                	cmp    %esi,%edi
  802b02:	0f 86 a8 00 00 00    	jbe    802bb0 <__umoddi3+0x130>
  802b08:	89 c8                	mov    %ecx,%eax
  802b0a:	83 c4 1c             	add    $0x1c,%esp
  802b0d:	5b                   	pop    %ebx
  802b0e:	5e                   	pop    %esi
  802b0f:	5f                   	pop    %edi
  802b10:	5d                   	pop    %ebp
  802b11:	c3                   	ret    
  802b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b18:	89 e9                	mov    %ebp,%ecx
  802b1a:	ba 20 00 00 00       	mov    $0x20,%edx
  802b1f:	29 ea                	sub    %ebp,%edx
  802b21:	d3 e0                	shl    %cl,%eax
  802b23:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b27:	89 d1                	mov    %edx,%ecx
  802b29:	89 f8                	mov    %edi,%eax
  802b2b:	d3 e8                	shr    %cl,%eax
  802b2d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b31:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b35:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b39:	09 c1                	or     %eax,%ecx
  802b3b:	89 d8                	mov    %ebx,%eax
  802b3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b41:	89 e9                	mov    %ebp,%ecx
  802b43:	d3 e7                	shl    %cl,%edi
  802b45:	89 d1                	mov    %edx,%ecx
  802b47:	d3 e8                	shr    %cl,%eax
  802b49:	89 e9                	mov    %ebp,%ecx
  802b4b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b4f:	d3 e3                	shl    %cl,%ebx
  802b51:	89 c7                	mov    %eax,%edi
  802b53:	89 d1                	mov    %edx,%ecx
  802b55:	89 f0                	mov    %esi,%eax
  802b57:	d3 e8                	shr    %cl,%eax
  802b59:	89 e9                	mov    %ebp,%ecx
  802b5b:	89 fa                	mov    %edi,%edx
  802b5d:	d3 e6                	shl    %cl,%esi
  802b5f:	09 d8                	or     %ebx,%eax
  802b61:	f7 74 24 08          	divl   0x8(%esp)
  802b65:	89 d1                	mov    %edx,%ecx
  802b67:	89 f3                	mov    %esi,%ebx
  802b69:	f7 64 24 0c          	mull   0xc(%esp)
  802b6d:	89 c6                	mov    %eax,%esi
  802b6f:	89 d7                	mov    %edx,%edi
  802b71:	39 d1                	cmp    %edx,%ecx
  802b73:	72 06                	jb     802b7b <__umoddi3+0xfb>
  802b75:	75 10                	jne    802b87 <__umoddi3+0x107>
  802b77:	39 c3                	cmp    %eax,%ebx
  802b79:	73 0c                	jae    802b87 <__umoddi3+0x107>
  802b7b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802b7f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802b83:	89 d7                	mov    %edx,%edi
  802b85:	89 c6                	mov    %eax,%esi
  802b87:	89 ca                	mov    %ecx,%edx
  802b89:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b8e:	29 f3                	sub    %esi,%ebx
  802b90:	19 fa                	sbb    %edi,%edx
  802b92:	89 d0                	mov    %edx,%eax
  802b94:	d3 e0                	shl    %cl,%eax
  802b96:	89 e9                	mov    %ebp,%ecx
  802b98:	d3 eb                	shr    %cl,%ebx
  802b9a:	d3 ea                	shr    %cl,%edx
  802b9c:	09 d8                	or     %ebx,%eax
  802b9e:	83 c4 1c             	add    $0x1c,%esp
  802ba1:	5b                   	pop    %ebx
  802ba2:	5e                   	pop    %esi
  802ba3:	5f                   	pop    %edi
  802ba4:	5d                   	pop    %ebp
  802ba5:	c3                   	ret    
  802ba6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bad:	8d 76 00             	lea    0x0(%esi),%esi
  802bb0:	89 da                	mov    %ebx,%edx
  802bb2:	29 fe                	sub    %edi,%esi
  802bb4:	19 c2                	sbb    %eax,%edx
  802bb6:	89 f1                	mov    %esi,%ecx
  802bb8:	89 c8                	mov    %ecx,%eax
  802bba:	e9 4b ff ff ff       	jmp    802b0a <__umoddi3+0x8a>
