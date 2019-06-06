
obj/user/spawnfaultio.debug:     file format elf32-i386


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
  800042:	68 a0 2b 80 00       	push   $0x802ba0
  800047:	e8 32 02 00 00       	call   80027e <cprintf>
	if ((r = spawnl("faultio", "faultio", 0)) < 0)
  80004c:	83 c4 0c             	add    $0xc,%esp
  80004f:	6a 00                	push   $0x0
  800051:	68 be 2b 80 00       	push   $0x802bbe
  800056:	68 be 2b 80 00       	push   $0x802bbe
  80005b:	e8 fd 1d 00 00       	call   801e5d <spawnl>
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	85 c0                	test   %eax,%eax
  800065:	78 02                	js     800069 <umain+0x36>
		panic("spawn(faultio) failed: %e", r);
}
  800067:	c9                   	leave  
  800068:	c3                   	ret    
		panic("spawn(faultio) failed: %e", r);
  800069:	50                   	push   %eax
  80006a:	68 c6 2b 80 00       	push   $0x802bc6
  80006f:	6a 09                	push   $0x9
  800071:	68 e0 2b 80 00       	push   $0x802be0
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
  8000fe:	68 f4 2b 80 00       	push   $0x802bf4
  800103:	e8 76 01 00 00       	call   80027e <cprintf>
	cprintf("before umain\n");
  800108:	c7 04 24 12 2c 80 00 	movl   $0x802c12,(%esp)
  80010f:	e8 6a 01 00 00       	call   80027e <cprintf>
	// call user main routine
	umain(argc, argv);
  800114:	83 c4 08             	add    $0x8,%esp
  800117:	ff 75 0c             	pushl  0xc(%ebp)
  80011a:	ff 75 08             	pushl  0x8(%ebp)
  80011d:	e8 11 ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  800122:	c7 04 24 20 2c 80 00 	movl   $0x802c20,(%esp)
  800129:	e8 50 01 00 00       	call   80027e <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  80012e:	a1 08 50 80 00       	mov    0x805008,%eax
  800133:	8b 40 48             	mov    0x48(%eax),%eax
  800136:	83 c4 08             	add    $0x8,%esp
  800139:	50                   	push   %eax
  80013a:	68 2d 2c 80 00       	push   $0x802c2d
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
  800162:	68 58 2c 80 00       	push   $0x802c58
  800167:	50                   	push   %eax
  800168:	68 4c 2c 80 00       	push   $0x802c4c
  80016d:	e8 0c 01 00 00       	call   80027e <cprintf>
	close_all();
  800172:	e8 05 11 00 00       	call   80127c <close_all>
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
  800198:	68 84 2c 80 00       	push   $0x802c84
  80019d:	50                   	push   %eax
  80019e:	68 4c 2c 80 00       	push   $0x802c4c
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
  8001c1:	68 60 2c 80 00       	push   $0x802c60
  8001c6:	e8 b3 00 00 00       	call   80027e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001cb:	83 c4 18             	add    $0x18,%esp
  8001ce:	53                   	push   %ebx
  8001cf:	ff 75 10             	pushl  0x10(%ebp)
  8001d2:	e8 56 00 00 00       	call   80022d <vcprintf>
	cprintf("\n");
  8001d7:	c7 04 24 10 2c 80 00 	movl   $0x802c10,(%esp)
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
  80032b:	e8 20 26 00 00       	call   802950 <__udivdi3>
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
  800354:	e8 07 27 00 00       	call   802a60 <__umoddi3>
  800359:	83 c4 14             	add    $0x14,%esp
  80035c:	0f be 80 8b 2c 80 00 	movsbl 0x802c8b(%eax),%eax
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
  800405:	ff 24 85 60 2e 80 00 	jmp    *0x802e60(,%eax,4)
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
  8004d0:	8b 14 85 c0 2f 80 00 	mov    0x802fc0(,%eax,4),%edx
  8004d7:	85 d2                	test   %edx,%edx
  8004d9:	74 18                	je     8004f3 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004db:	52                   	push   %edx
  8004dc:	68 dd 30 80 00       	push   $0x8030dd
  8004e1:	53                   	push   %ebx
  8004e2:	56                   	push   %esi
  8004e3:	e8 a6 fe ff ff       	call   80038e <printfmt>
  8004e8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004eb:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004ee:	e9 fe 02 00 00       	jmp    8007f1 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004f3:	50                   	push   %eax
  8004f4:	68 a3 2c 80 00       	push   $0x802ca3
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
  80051b:	b8 9c 2c 80 00       	mov    $0x802c9c,%eax
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
  8008b3:	bf c1 2d 80 00       	mov    $0x802dc1,%edi
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
  8008df:	bf f9 2d 80 00       	mov    $0x802df9,%edi
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
  800d80:	68 08 30 80 00       	push   $0x803008
  800d85:	6a 43                	push   $0x43
  800d87:	68 25 30 80 00       	push   $0x803025
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
  800e01:	68 08 30 80 00       	push   $0x803008
  800e06:	6a 43                	push   $0x43
  800e08:	68 25 30 80 00       	push   $0x803025
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
  800e43:	68 08 30 80 00       	push   $0x803008
  800e48:	6a 43                	push   $0x43
  800e4a:	68 25 30 80 00       	push   $0x803025
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
  800e85:	68 08 30 80 00       	push   $0x803008
  800e8a:	6a 43                	push   $0x43
  800e8c:	68 25 30 80 00       	push   $0x803025
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
  800ec7:	68 08 30 80 00       	push   $0x803008
  800ecc:	6a 43                	push   $0x43
  800ece:	68 25 30 80 00       	push   $0x803025
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
  800f09:	68 08 30 80 00       	push   $0x803008
  800f0e:	6a 43                	push   $0x43
  800f10:	68 25 30 80 00       	push   $0x803025
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
  800f4b:	68 08 30 80 00       	push   $0x803008
  800f50:	6a 43                	push   $0x43
  800f52:	68 25 30 80 00       	push   $0x803025
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
  800faf:	68 08 30 80 00       	push   $0x803008
  800fb4:	6a 43                	push   $0x43
  800fb6:	68 25 30 80 00       	push   $0x803025
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
  801093:	68 08 30 80 00       	push   $0x803008
  801098:	6a 43                	push   $0x43
  80109a:	68 25 30 80 00       	push   $0x803025
  80109f:	e8 e4 f0 ff ff       	call   800188 <_panic>

008010a4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010a4:	55                   	push   %ebp
  8010a5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010aa:	05 00 00 00 30       	add    $0x30000000,%eax
  8010af:	c1 e8 0c             	shr    $0xc,%eax
}
  8010b2:	5d                   	pop    %ebp
  8010b3:	c3                   	ret    

008010b4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010b4:	55                   	push   %ebp
  8010b5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010c4:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010c9:	5d                   	pop    %ebp
  8010ca:	c3                   	ret    

008010cb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
  8010ce:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010d3:	89 c2                	mov    %eax,%edx
  8010d5:	c1 ea 16             	shr    $0x16,%edx
  8010d8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010df:	f6 c2 01             	test   $0x1,%dl
  8010e2:	74 2d                	je     801111 <fd_alloc+0x46>
  8010e4:	89 c2                	mov    %eax,%edx
  8010e6:	c1 ea 0c             	shr    $0xc,%edx
  8010e9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010f0:	f6 c2 01             	test   $0x1,%dl
  8010f3:	74 1c                	je     801111 <fd_alloc+0x46>
  8010f5:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010fa:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010ff:	75 d2                	jne    8010d3 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80110a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80110f:	eb 0a                	jmp    80111b <fd_alloc+0x50>
			*fd_store = fd;
  801111:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801114:	89 01                	mov    %eax,(%ecx)
			return 0;
  801116:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80111b:	5d                   	pop    %ebp
  80111c:	c3                   	ret    

0080111d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80111d:	55                   	push   %ebp
  80111e:	89 e5                	mov    %esp,%ebp
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801123:	83 f8 1f             	cmp    $0x1f,%eax
  801126:	77 30                	ja     801158 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801128:	c1 e0 0c             	shl    $0xc,%eax
  80112b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801130:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801136:	f6 c2 01             	test   $0x1,%dl
  801139:	74 24                	je     80115f <fd_lookup+0x42>
  80113b:	89 c2                	mov    %eax,%edx
  80113d:	c1 ea 0c             	shr    $0xc,%edx
  801140:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801147:	f6 c2 01             	test   $0x1,%dl
  80114a:	74 1a                	je     801166 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80114c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80114f:	89 02                	mov    %eax,(%edx)
	return 0;
  801151:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801156:	5d                   	pop    %ebp
  801157:	c3                   	ret    
		return -E_INVAL;
  801158:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80115d:	eb f7                	jmp    801156 <fd_lookup+0x39>
		return -E_INVAL;
  80115f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801164:	eb f0                	jmp    801156 <fd_lookup+0x39>
  801166:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80116b:	eb e9                	jmp    801156 <fd_lookup+0x39>

0080116d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80116d:	55                   	push   %ebp
  80116e:	89 e5                	mov    %esp,%ebp
  801170:	83 ec 08             	sub    $0x8,%esp
  801173:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801176:	ba 00 00 00 00       	mov    $0x0,%edx
  80117b:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801180:	39 08                	cmp    %ecx,(%eax)
  801182:	74 38                	je     8011bc <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801184:	83 c2 01             	add    $0x1,%edx
  801187:	8b 04 95 b0 30 80 00 	mov    0x8030b0(,%edx,4),%eax
  80118e:	85 c0                	test   %eax,%eax
  801190:	75 ee                	jne    801180 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801192:	a1 08 50 80 00       	mov    0x805008,%eax
  801197:	8b 40 48             	mov    0x48(%eax),%eax
  80119a:	83 ec 04             	sub    $0x4,%esp
  80119d:	51                   	push   %ecx
  80119e:	50                   	push   %eax
  80119f:	68 34 30 80 00       	push   $0x803034
  8011a4:	e8 d5 f0 ff ff       	call   80027e <cprintf>
	*dev = 0;
  8011a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011b2:	83 c4 10             	add    $0x10,%esp
  8011b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011ba:	c9                   	leave  
  8011bb:	c3                   	ret    
			*dev = devtab[i];
  8011bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011bf:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c6:	eb f2                	jmp    8011ba <dev_lookup+0x4d>

008011c8 <fd_close>:
{
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
  8011cb:	57                   	push   %edi
  8011cc:	56                   	push   %esi
  8011cd:	53                   	push   %ebx
  8011ce:	83 ec 24             	sub    $0x24,%esp
  8011d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8011d4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011d7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011da:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011db:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011e1:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011e4:	50                   	push   %eax
  8011e5:	e8 33 ff ff ff       	call   80111d <fd_lookup>
  8011ea:	89 c3                	mov    %eax,%ebx
  8011ec:	83 c4 10             	add    $0x10,%esp
  8011ef:	85 c0                	test   %eax,%eax
  8011f1:	78 05                	js     8011f8 <fd_close+0x30>
	    || fd != fd2)
  8011f3:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011f6:	74 16                	je     80120e <fd_close+0x46>
		return (must_exist ? r : 0);
  8011f8:	89 f8                	mov    %edi,%eax
  8011fa:	84 c0                	test   %al,%al
  8011fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801201:	0f 44 d8             	cmove  %eax,%ebx
}
  801204:	89 d8                	mov    %ebx,%eax
  801206:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801209:	5b                   	pop    %ebx
  80120a:	5e                   	pop    %esi
  80120b:	5f                   	pop    %edi
  80120c:	5d                   	pop    %ebp
  80120d:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80120e:	83 ec 08             	sub    $0x8,%esp
  801211:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801214:	50                   	push   %eax
  801215:	ff 36                	pushl  (%esi)
  801217:	e8 51 ff ff ff       	call   80116d <dev_lookup>
  80121c:	89 c3                	mov    %eax,%ebx
  80121e:	83 c4 10             	add    $0x10,%esp
  801221:	85 c0                	test   %eax,%eax
  801223:	78 1a                	js     80123f <fd_close+0x77>
		if (dev->dev_close)
  801225:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801228:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80122b:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801230:	85 c0                	test   %eax,%eax
  801232:	74 0b                	je     80123f <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801234:	83 ec 0c             	sub    $0xc,%esp
  801237:	56                   	push   %esi
  801238:	ff d0                	call   *%eax
  80123a:	89 c3                	mov    %eax,%ebx
  80123c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80123f:	83 ec 08             	sub    $0x8,%esp
  801242:	56                   	push   %esi
  801243:	6a 00                	push   $0x0
  801245:	e8 0a fc ff ff       	call   800e54 <sys_page_unmap>
	return r;
  80124a:	83 c4 10             	add    $0x10,%esp
  80124d:	eb b5                	jmp    801204 <fd_close+0x3c>

0080124f <close>:

int
close(int fdnum)
{
  80124f:	55                   	push   %ebp
  801250:	89 e5                	mov    %esp,%ebp
  801252:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801255:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801258:	50                   	push   %eax
  801259:	ff 75 08             	pushl  0x8(%ebp)
  80125c:	e8 bc fe ff ff       	call   80111d <fd_lookup>
  801261:	83 c4 10             	add    $0x10,%esp
  801264:	85 c0                	test   %eax,%eax
  801266:	79 02                	jns    80126a <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801268:	c9                   	leave  
  801269:	c3                   	ret    
		return fd_close(fd, 1);
  80126a:	83 ec 08             	sub    $0x8,%esp
  80126d:	6a 01                	push   $0x1
  80126f:	ff 75 f4             	pushl  -0xc(%ebp)
  801272:	e8 51 ff ff ff       	call   8011c8 <fd_close>
  801277:	83 c4 10             	add    $0x10,%esp
  80127a:	eb ec                	jmp    801268 <close+0x19>

0080127c <close_all>:

void
close_all(void)
{
  80127c:	55                   	push   %ebp
  80127d:	89 e5                	mov    %esp,%ebp
  80127f:	53                   	push   %ebx
  801280:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801283:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801288:	83 ec 0c             	sub    $0xc,%esp
  80128b:	53                   	push   %ebx
  80128c:	e8 be ff ff ff       	call   80124f <close>
	for (i = 0; i < MAXFD; i++)
  801291:	83 c3 01             	add    $0x1,%ebx
  801294:	83 c4 10             	add    $0x10,%esp
  801297:	83 fb 20             	cmp    $0x20,%ebx
  80129a:	75 ec                	jne    801288 <close_all+0xc>
}
  80129c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80129f:	c9                   	leave  
  8012a0:	c3                   	ret    

008012a1 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012a1:	55                   	push   %ebp
  8012a2:	89 e5                	mov    %esp,%ebp
  8012a4:	57                   	push   %edi
  8012a5:	56                   	push   %esi
  8012a6:	53                   	push   %ebx
  8012a7:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012aa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012ad:	50                   	push   %eax
  8012ae:	ff 75 08             	pushl  0x8(%ebp)
  8012b1:	e8 67 fe ff ff       	call   80111d <fd_lookup>
  8012b6:	89 c3                	mov    %eax,%ebx
  8012b8:	83 c4 10             	add    $0x10,%esp
  8012bb:	85 c0                	test   %eax,%eax
  8012bd:	0f 88 81 00 00 00    	js     801344 <dup+0xa3>
		return r;
	close(newfdnum);
  8012c3:	83 ec 0c             	sub    $0xc,%esp
  8012c6:	ff 75 0c             	pushl  0xc(%ebp)
  8012c9:	e8 81 ff ff ff       	call   80124f <close>

	newfd = INDEX2FD(newfdnum);
  8012ce:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012d1:	c1 e6 0c             	shl    $0xc,%esi
  8012d4:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012da:	83 c4 04             	add    $0x4,%esp
  8012dd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012e0:	e8 cf fd ff ff       	call   8010b4 <fd2data>
  8012e5:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012e7:	89 34 24             	mov    %esi,(%esp)
  8012ea:	e8 c5 fd ff ff       	call   8010b4 <fd2data>
  8012ef:	83 c4 10             	add    $0x10,%esp
  8012f2:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012f4:	89 d8                	mov    %ebx,%eax
  8012f6:	c1 e8 16             	shr    $0x16,%eax
  8012f9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801300:	a8 01                	test   $0x1,%al
  801302:	74 11                	je     801315 <dup+0x74>
  801304:	89 d8                	mov    %ebx,%eax
  801306:	c1 e8 0c             	shr    $0xc,%eax
  801309:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801310:	f6 c2 01             	test   $0x1,%dl
  801313:	75 39                	jne    80134e <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801315:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801318:	89 d0                	mov    %edx,%eax
  80131a:	c1 e8 0c             	shr    $0xc,%eax
  80131d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801324:	83 ec 0c             	sub    $0xc,%esp
  801327:	25 07 0e 00 00       	and    $0xe07,%eax
  80132c:	50                   	push   %eax
  80132d:	56                   	push   %esi
  80132e:	6a 00                	push   $0x0
  801330:	52                   	push   %edx
  801331:	6a 00                	push   $0x0
  801333:	e8 da fa ff ff       	call   800e12 <sys_page_map>
  801338:	89 c3                	mov    %eax,%ebx
  80133a:	83 c4 20             	add    $0x20,%esp
  80133d:	85 c0                	test   %eax,%eax
  80133f:	78 31                	js     801372 <dup+0xd1>
		goto err;

	return newfdnum;
  801341:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801344:	89 d8                	mov    %ebx,%eax
  801346:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801349:	5b                   	pop    %ebx
  80134a:	5e                   	pop    %esi
  80134b:	5f                   	pop    %edi
  80134c:	5d                   	pop    %ebp
  80134d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80134e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801355:	83 ec 0c             	sub    $0xc,%esp
  801358:	25 07 0e 00 00       	and    $0xe07,%eax
  80135d:	50                   	push   %eax
  80135e:	57                   	push   %edi
  80135f:	6a 00                	push   $0x0
  801361:	53                   	push   %ebx
  801362:	6a 00                	push   $0x0
  801364:	e8 a9 fa ff ff       	call   800e12 <sys_page_map>
  801369:	89 c3                	mov    %eax,%ebx
  80136b:	83 c4 20             	add    $0x20,%esp
  80136e:	85 c0                	test   %eax,%eax
  801370:	79 a3                	jns    801315 <dup+0x74>
	sys_page_unmap(0, newfd);
  801372:	83 ec 08             	sub    $0x8,%esp
  801375:	56                   	push   %esi
  801376:	6a 00                	push   $0x0
  801378:	e8 d7 fa ff ff       	call   800e54 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80137d:	83 c4 08             	add    $0x8,%esp
  801380:	57                   	push   %edi
  801381:	6a 00                	push   $0x0
  801383:	e8 cc fa ff ff       	call   800e54 <sys_page_unmap>
	return r;
  801388:	83 c4 10             	add    $0x10,%esp
  80138b:	eb b7                	jmp    801344 <dup+0xa3>

0080138d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
  801390:	53                   	push   %ebx
  801391:	83 ec 1c             	sub    $0x1c,%esp
  801394:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801397:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80139a:	50                   	push   %eax
  80139b:	53                   	push   %ebx
  80139c:	e8 7c fd ff ff       	call   80111d <fd_lookup>
  8013a1:	83 c4 10             	add    $0x10,%esp
  8013a4:	85 c0                	test   %eax,%eax
  8013a6:	78 3f                	js     8013e7 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013a8:	83 ec 08             	sub    $0x8,%esp
  8013ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ae:	50                   	push   %eax
  8013af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b2:	ff 30                	pushl  (%eax)
  8013b4:	e8 b4 fd ff ff       	call   80116d <dev_lookup>
  8013b9:	83 c4 10             	add    $0x10,%esp
  8013bc:	85 c0                	test   %eax,%eax
  8013be:	78 27                	js     8013e7 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013c3:	8b 42 08             	mov    0x8(%edx),%eax
  8013c6:	83 e0 03             	and    $0x3,%eax
  8013c9:	83 f8 01             	cmp    $0x1,%eax
  8013cc:	74 1e                	je     8013ec <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d1:	8b 40 08             	mov    0x8(%eax),%eax
  8013d4:	85 c0                	test   %eax,%eax
  8013d6:	74 35                	je     80140d <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013d8:	83 ec 04             	sub    $0x4,%esp
  8013db:	ff 75 10             	pushl  0x10(%ebp)
  8013de:	ff 75 0c             	pushl  0xc(%ebp)
  8013e1:	52                   	push   %edx
  8013e2:	ff d0                	call   *%eax
  8013e4:	83 c4 10             	add    $0x10,%esp
}
  8013e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ea:	c9                   	leave  
  8013eb:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013ec:	a1 08 50 80 00       	mov    0x805008,%eax
  8013f1:	8b 40 48             	mov    0x48(%eax),%eax
  8013f4:	83 ec 04             	sub    $0x4,%esp
  8013f7:	53                   	push   %ebx
  8013f8:	50                   	push   %eax
  8013f9:	68 75 30 80 00       	push   $0x803075
  8013fe:	e8 7b ee ff ff       	call   80027e <cprintf>
		return -E_INVAL;
  801403:	83 c4 10             	add    $0x10,%esp
  801406:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80140b:	eb da                	jmp    8013e7 <read+0x5a>
		return -E_NOT_SUPP;
  80140d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801412:	eb d3                	jmp    8013e7 <read+0x5a>

00801414 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
  801417:	57                   	push   %edi
  801418:	56                   	push   %esi
  801419:	53                   	push   %ebx
  80141a:	83 ec 0c             	sub    $0xc,%esp
  80141d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801420:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801423:	bb 00 00 00 00       	mov    $0x0,%ebx
  801428:	39 f3                	cmp    %esi,%ebx
  80142a:	73 23                	jae    80144f <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80142c:	83 ec 04             	sub    $0x4,%esp
  80142f:	89 f0                	mov    %esi,%eax
  801431:	29 d8                	sub    %ebx,%eax
  801433:	50                   	push   %eax
  801434:	89 d8                	mov    %ebx,%eax
  801436:	03 45 0c             	add    0xc(%ebp),%eax
  801439:	50                   	push   %eax
  80143a:	57                   	push   %edi
  80143b:	e8 4d ff ff ff       	call   80138d <read>
		if (m < 0)
  801440:	83 c4 10             	add    $0x10,%esp
  801443:	85 c0                	test   %eax,%eax
  801445:	78 06                	js     80144d <readn+0x39>
			return m;
		if (m == 0)
  801447:	74 06                	je     80144f <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801449:	01 c3                	add    %eax,%ebx
  80144b:	eb db                	jmp    801428 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80144d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80144f:	89 d8                	mov    %ebx,%eax
  801451:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801454:	5b                   	pop    %ebx
  801455:	5e                   	pop    %esi
  801456:	5f                   	pop    %edi
  801457:	5d                   	pop    %ebp
  801458:	c3                   	ret    

00801459 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
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
  801468:	e8 b0 fc ff ff       	call   80111d <fd_lookup>
  80146d:	83 c4 10             	add    $0x10,%esp
  801470:	85 c0                	test   %eax,%eax
  801472:	78 3a                	js     8014ae <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801474:	83 ec 08             	sub    $0x8,%esp
  801477:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80147a:	50                   	push   %eax
  80147b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80147e:	ff 30                	pushl  (%eax)
  801480:	e8 e8 fc ff ff       	call   80116d <dev_lookup>
  801485:	83 c4 10             	add    $0x10,%esp
  801488:	85 c0                	test   %eax,%eax
  80148a:	78 22                	js     8014ae <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80148c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801493:	74 1e                	je     8014b3 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801495:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801498:	8b 52 0c             	mov    0xc(%edx),%edx
  80149b:	85 d2                	test   %edx,%edx
  80149d:	74 35                	je     8014d4 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80149f:	83 ec 04             	sub    $0x4,%esp
  8014a2:	ff 75 10             	pushl  0x10(%ebp)
  8014a5:	ff 75 0c             	pushl  0xc(%ebp)
  8014a8:	50                   	push   %eax
  8014a9:	ff d2                	call   *%edx
  8014ab:	83 c4 10             	add    $0x10,%esp
}
  8014ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014b1:	c9                   	leave  
  8014b2:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014b3:	a1 08 50 80 00       	mov    0x805008,%eax
  8014b8:	8b 40 48             	mov    0x48(%eax),%eax
  8014bb:	83 ec 04             	sub    $0x4,%esp
  8014be:	53                   	push   %ebx
  8014bf:	50                   	push   %eax
  8014c0:	68 91 30 80 00       	push   $0x803091
  8014c5:	e8 b4 ed ff ff       	call   80027e <cprintf>
		return -E_INVAL;
  8014ca:	83 c4 10             	add    $0x10,%esp
  8014cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014d2:	eb da                	jmp    8014ae <write+0x55>
		return -E_NOT_SUPP;
  8014d4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014d9:	eb d3                	jmp    8014ae <write+0x55>

008014db <seek>:

int
seek(int fdnum, off_t offset)
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
  8014de:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e4:	50                   	push   %eax
  8014e5:	ff 75 08             	pushl  0x8(%ebp)
  8014e8:	e8 30 fc ff ff       	call   80111d <fd_lookup>
  8014ed:	83 c4 10             	add    $0x10,%esp
  8014f0:	85 c0                	test   %eax,%eax
  8014f2:	78 0e                	js     801502 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014fa:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801502:	c9                   	leave  
  801503:	c3                   	ret    

00801504 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	53                   	push   %ebx
  801508:	83 ec 1c             	sub    $0x1c,%esp
  80150b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80150e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801511:	50                   	push   %eax
  801512:	53                   	push   %ebx
  801513:	e8 05 fc ff ff       	call   80111d <fd_lookup>
  801518:	83 c4 10             	add    $0x10,%esp
  80151b:	85 c0                	test   %eax,%eax
  80151d:	78 37                	js     801556 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80151f:	83 ec 08             	sub    $0x8,%esp
  801522:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801525:	50                   	push   %eax
  801526:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801529:	ff 30                	pushl  (%eax)
  80152b:	e8 3d fc ff ff       	call   80116d <dev_lookup>
  801530:	83 c4 10             	add    $0x10,%esp
  801533:	85 c0                	test   %eax,%eax
  801535:	78 1f                	js     801556 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801537:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80153e:	74 1b                	je     80155b <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801540:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801543:	8b 52 18             	mov    0x18(%edx),%edx
  801546:	85 d2                	test   %edx,%edx
  801548:	74 32                	je     80157c <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80154a:	83 ec 08             	sub    $0x8,%esp
  80154d:	ff 75 0c             	pushl  0xc(%ebp)
  801550:	50                   	push   %eax
  801551:	ff d2                	call   *%edx
  801553:	83 c4 10             	add    $0x10,%esp
}
  801556:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801559:	c9                   	leave  
  80155a:	c3                   	ret    
			thisenv->env_id, fdnum);
  80155b:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801560:	8b 40 48             	mov    0x48(%eax),%eax
  801563:	83 ec 04             	sub    $0x4,%esp
  801566:	53                   	push   %ebx
  801567:	50                   	push   %eax
  801568:	68 54 30 80 00       	push   $0x803054
  80156d:	e8 0c ed ff ff       	call   80027e <cprintf>
		return -E_INVAL;
  801572:	83 c4 10             	add    $0x10,%esp
  801575:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80157a:	eb da                	jmp    801556 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80157c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801581:	eb d3                	jmp    801556 <ftruncate+0x52>

00801583 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
  801586:	53                   	push   %ebx
  801587:	83 ec 1c             	sub    $0x1c,%esp
  80158a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80158d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801590:	50                   	push   %eax
  801591:	ff 75 08             	pushl  0x8(%ebp)
  801594:	e8 84 fb ff ff       	call   80111d <fd_lookup>
  801599:	83 c4 10             	add    $0x10,%esp
  80159c:	85 c0                	test   %eax,%eax
  80159e:	78 4b                	js     8015eb <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015a0:	83 ec 08             	sub    $0x8,%esp
  8015a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a6:	50                   	push   %eax
  8015a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015aa:	ff 30                	pushl  (%eax)
  8015ac:	e8 bc fb ff ff       	call   80116d <dev_lookup>
  8015b1:	83 c4 10             	add    $0x10,%esp
  8015b4:	85 c0                	test   %eax,%eax
  8015b6:	78 33                	js     8015eb <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015bb:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015bf:	74 2f                	je     8015f0 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015c1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015c4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015cb:	00 00 00 
	stat->st_isdir = 0;
  8015ce:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015d5:	00 00 00 
	stat->st_dev = dev;
  8015d8:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015de:	83 ec 08             	sub    $0x8,%esp
  8015e1:	53                   	push   %ebx
  8015e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8015e5:	ff 50 14             	call   *0x14(%eax)
  8015e8:	83 c4 10             	add    $0x10,%esp
}
  8015eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    
		return -E_NOT_SUPP;
  8015f0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015f5:	eb f4                	jmp    8015eb <fstat+0x68>

008015f7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	56                   	push   %esi
  8015fb:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015fc:	83 ec 08             	sub    $0x8,%esp
  8015ff:	6a 00                	push   $0x0
  801601:	ff 75 08             	pushl  0x8(%ebp)
  801604:	e8 22 02 00 00       	call   80182b <open>
  801609:	89 c3                	mov    %eax,%ebx
  80160b:	83 c4 10             	add    $0x10,%esp
  80160e:	85 c0                	test   %eax,%eax
  801610:	78 1b                	js     80162d <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801612:	83 ec 08             	sub    $0x8,%esp
  801615:	ff 75 0c             	pushl  0xc(%ebp)
  801618:	50                   	push   %eax
  801619:	e8 65 ff ff ff       	call   801583 <fstat>
  80161e:	89 c6                	mov    %eax,%esi
	close(fd);
  801620:	89 1c 24             	mov    %ebx,(%esp)
  801623:	e8 27 fc ff ff       	call   80124f <close>
	return r;
  801628:	83 c4 10             	add    $0x10,%esp
  80162b:	89 f3                	mov    %esi,%ebx
}
  80162d:	89 d8                	mov    %ebx,%eax
  80162f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801632:	5b                   	pop    %ebx
  801633:	5e                   	pop    %esi
  801634:	5d                   	pop    %ebp
  801635:	c3                   	ret    

00801636 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
  801639:	56                   	push   %esi
  80163a:	53                   	push   %ebx
  80163b:	89 c6                	mov    %eax,%esi
  80163d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80163f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801646:	74 27                	je     80166f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801648:	6a 07                	push   $0x7
  80164a:	68 00 60 80 00       	push   $0x806000
  80164f:	56                   	push   %esi
  801650:	ff 35 00 50 80 00    	pushl  0x805000
  801656:	e8 24 12 00 00       	call   80287f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80165b:	83 c4 0c             	add    $0xc,%esp
  80165e:	6a 00                	push   $0x0
  801660:	53                   	push   %ebx
  801661:	6a 00                	push   $0x0
  801663:	e8 ae 11 00 00       	call   802816 <ipc_recv>
}
  801668:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80166b:	5b                   	pop    %ebx
  80166c:	5e                   	pop    %esi
  80166d:	5d                   	pop    %ebp
  80166e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80166f:	83 ec 0c             	sub    $0xc,%esp
  801672:	6a 01                	push   $0x1
  801674:	e8 5e 12 00 00       	call   8028d7 <ipc_find_env>
  801679:	a3 00 50 80 00       	mov    %eax,0x805000
  80167e:	83 c4 10             	add    $0x10,%esp
  801681:	eb c5                	jmp    801648 <fsipc+0x12>

00801683 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
  801686:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
  80168c:	8b 40 0c             	mov    0xc(%eax),%eax
  80168f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801694:	8b 45 0c             	mov    0xc(%ebp),%eax
  801697:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80169c:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a1:	b8 02 00 00 00       	mov    $0x2,%eax
  8016a6:	e8 8b ff ff ff       	call   801636 <fsipc>
}
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <devfile_flush>:
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8016b9:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8016be:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c3:	b8 06 00 00 00       	mov    $0x6,%eax
  8016c8:	e8 69 ff ff ff       	call   801636 <fsipc>
}
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <devfile_stat>:
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	53                   	push   %ebx
  8016d3:	83 ec 04             	sub    $0x4,%esp
  8016d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8016df:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e9:	b8 05 00 00 00       	mov    $0x5,%eax
  8016ee:	e8 43 ff ff ff       	call   801636 <fsipc>
  8016f3:	85 c0                	test   %eax,%eax
  8016f5:	78 2c                	js     801723 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016f7:	83 ec 08             	sub    $0x8,%esp
  8016fa:	68 00 60 80 00       	push   $0x806000
  8016ff:	53                   	push   %ebx
  801700:	e8 d8 f2 ff ff       	call   8009dd <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801705:	a1 80 60 80 00       	mov    0x806080,%eax
  80170a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801710:	a1 84 60 80 00       	mov    0x806084,%eax
  801715:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80171b:	83 c4 10             	add    $0x10,%esp
  80171e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801723:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801726:	c9                   	leave  
  801727:	c3                   	ret    

00801728 <devfile_write>:
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
  80172b:	53                   	push   %ebx
  80172c:	83 ec 08             	sub    $0x8,%esp
  80172f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801732:	8b 45 08             	mov    0x8(%ebp),%eax
  801735:	8b 40 0c             	mov    0xc(%eax),%eax
  801738:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n;
  80173d:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801743:	53                   	push   %ebx
  801744:	ff 75 0c             	pushl  0xc(%ebp)
  801747:	68 08 60 80 00       	push   $0x806008
  80174c:	e8 7c f4 ff ff       	call   800bcd <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801751:	ba 00 00 00 00       	mov    $0x0,%edx
  801756:	b8 04 00 00 00       	mov    $0x4,%eax
  80175b:	e8 d6 fe ff ff       	call   801636 <fsipc>
  801760:	83 c4 10             	add    $0x10,%esp
  801763:	85 c0                	test   %eax,%eax
  801765:	78 0b                	js     801772 <devfile_write+0x4a>
	assert(r <= n);
  801767:	39 d8                	cmp    %ebx,%eax
  801769:	77 0c                	ja     801777 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  80176b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801770:	7f 1e                	jg     801790 <devfile_write+0x68>
}
  801772:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801775:	c9                   	leave  
  801776:	c3                   	ret    
	assert(r <= n);
  801777:	68 c4 30 80 00       	push   $0x8030c4
  80177c:	68 cb 30 80 00       	push   $0x8030cb
  801781:	68 98 00 00 00       	push   $0x98
  801786:	68 e0 30 80 00       	push   $0x8030e0
  80178b:	e8 f8 e9 ff ff       	call   800188 <_panic>
	assert(r <= PGSIZE);
  801790:	68 eb 30 80 00       	push   $0x8030eb
  801795:	68 cb 30 80 00       	push   $0x8030cb
  80179a:	68 99 00 00 00       	push   $0x99
  80179f:	68 e0 30 80 00       	push   $0x8030e0
  8017a4:	e8 df e9 ff ff       	call   800188 <_panic>

008017a9 <devfile_read>:
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
  8017ac:	56                   	push   %esi
  8017ad:	53                   	push   %ebx
  8017ae:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b7:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  8017bc:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c7:	b8 03 00 00 00       	mov    $0x3,%eax
  8017cc:	e8 65 fe ff ff       	call   801636 <fsipc>
  8017d1:	89 c3                	mov    %eax,%ebx
  8017d3:	85 c0                	test   %eax,%eax
  8017d5:	78 1f                	js     8017f6 <devfile_read+0x4d>
	assert(r <= n);
  8017d7:	39 f0                	cmp    %esi,%eax
  8017d9:	77 24                	ja     8017ff <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017db:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017e0:	7f 33                	jg     801815 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017e2:	83 ec 04             	sub    $0x4,%esp
  8017e5:	50                   	push   %eax
  8017e6:	68 00 60 80 00       	push   $0x806000
  8017eb:	ff 75 0c             	pushl  0xc(%ebp)
  8017ee:	e8 78 f3 ff ff       	call   800b6b <memmove>
	return r;
  8017f3:	83 c4 10             	add    $0x10,%esp
}
  8017f6:	89 d8                	mov    %ebx,%eax
  8017f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017fb:	5b                   	pop    %ebx
  8017fc:	5e                   	pop    %esi
  8017fd:	5d                   	pop    %ebp
  8017fe:	c3                   	ret    
	assert(r <= n);
  8017ff:	68 c4 30 80 00       	push   $0x8030c4
  801804:	68 cb 30 80 00       	push   $0x8030cb
  801809:	6a 7c                	push   $0x7c
  80180b:	68 e0 30 80 00       	push   $0x8030e0
  801810:	e8 73 e9 ff ff       	call   800188 <_panic>
	assert(r <= PGSIZE);
  801815:	68 eb 30 80 00       	push   $0x8030eb
  80181a:	68 cb 30 80 00       	push   $0x8030cb
  80181f:	6a 7d                	push   $0x7d
  801821:	68 e0 30 80 00       	push   $0x8030e0
  801826:	e8 5d e9 ff ff       	call   800188 <_panic>

0080182b <open>:
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	56                   	push   %esi
  80182f:	53                   	push   %ebx
  801830:	83 ec 1c             	sub    $0x1c,%esp
  801833:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801836:	56                   	push   %esi
  801837:	e8 68 f1 ff ff       	call   8009a4 <strlen>
  80183c:	83 c4 10             	add    $0x10,%esp
  80183f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801844:	7f 6c                	jg     8018b2 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801846:	83 ec 0c             	sub    $0xc,%esp
  801849:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80184c:	50                   	push   %eax
  80184d:	e8 79 f8 ff ff       	call   8010cb <fd_alloc>
  801852:	89 c3                	mov    %eax,%ebx
  801854:	83 c4 10             	add    $0x10,%esp
  801857:	85 c0                	test   %eax,%eax
  801859:	78 3c                	js     801897 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80185b:	83 ec 08             	sub    $0x8,%esp
  80185e:	56                   	push   %esi
  80185f:	68 00 60 80 00       	push   $0x806000
  801864:	e8 74 f1 ff ff       	call   8009dd <strcpy>
	fsipcbuf.open.req_omode = mode;
  801869:	8b 45 0c             	mov    0xc(%ebp),%eax
  80186c:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801871:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801874:	b8 01 00 00 00       	mov    $0x1,%eax
  801879:	e8 b8 fd ff ff       	call   801636 <fsipc>
  80187e:	89 c3                	mov    %eax,%ebx
  801880:	83 c4 10             	add    $0x10,%esp
  801883:	85 c0                	test   %eax,%eax
  801885:	78 19                	js     8018a0 <open+0x75>
	return fd2num(fd);
  801887:	83 ec 0c             	sub    $0xc,%esp
  80188a:	ff 75 f4             	pushl  -0xc(%ebp)
  80188d:	e8 12 f8 ff ff       	call   8010a4 <fd2num>
  801892:	89 c3                	mov    %eax,%ebx
  801894:	83 c4 10             	add    $0x10,%esp
}
  801897:	89 d8                	mov    %ebx,%eax
  801899:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80189c:	5b                   	pop    %ebx
  80189d:	5e                   	pop    %esi
  80189e:	5d                   	pop    %ebp
  80189f:	c3                   	ret    
		fd_close(fd, 0);
  8018a0:	83 ec 08             	sub    $0x8,%esp
  8018a3:	6a 00                	push   $0x0
  8018a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8018a8:	e8 1b f9 ff ff       	call   8011c8 <fd_close>
		return r;
  8018ad:	83 c4 10             	add    $0x10,%esp
  8018b0:	eb e5                	jmp    801897 <open+0x6c>
		return -E_BAD_PATH;
  8018b2:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018b7:	eb de                	jmp    801897 <open+0x6c>

008018b9 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c4:	b8 08 00 00 00       	mov    $0x8,%eax
  8018c9:	e8 68 fd ff ff       	call   801636 <fsipc>
}
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
  8018d3:	57                   	push   %edi
  8018d4:	56                   	push   %esi
  8018d5:	53                   	push   %ebx
  8018d6:	81 ec 94 02 00 00    	sub    $0x294,%esp
	cprintf("in %s\n", __FUNCTION__);
  8018dc:	68 d0 31 80 00       	push   $0x8031d0
  8018e1:	68 50 2c 80 00       	push   $0x802c50
  8018e6:	e8 93 e9 ff ff       	call   80027e <cprintf>
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8018eb:	83 c4 08             	add    $0x8,%esp
  8018ee:	6a 00                	push   $0x0
  8018f0:	ff 75 08             	pushl  0x8(%ebp)
  8018f3:	e8 33 ff ff ff       	call   80182b <open>
  8018f8:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8018fe:	83 c4 10             	add    $0x10,%esp
  801901:	85 c0                	test   %eax,%eax
  801903:	0f 88 0a 05 00 00    	js     801e13 <spawn+0x543>
  801909:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80190b:	83 ec 04             	sub    $0x4,%esp
  80190e:	68 00 02 00 00       	push   $0x200
  801913:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801919:	50                   	push   %eax
  80191a:	51                   	push   %ecx
  80191b:	e8 f4 fa ff ff       	call   801414 <readn>
  801920:	83 c4 10             	add    $0x10,%esp
  801923:	3d 00 02 00 00       	cmp    $0x200,%eax
  801928:	75 74                	jne    80199e <spawn+0xce>
	    || elf->e_magic != ELF_MAGIC) {
  80192a:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801931:	45 4c 46 
  801934:	75 68                	jne    80199e <spawn+0xce>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801936:	b8 07 00 00 00       	mov    $0x7,%eax
  80193b:	cd 30                	int    $0x30
  80193d:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801943:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801949:	85 c0                	test   %eax,%eax
  80194b:	0f 88 b6 04 00 00    	js     801e07 <spawn+0x537>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801951:	25 ff 03 00 00       	and    $0x3ff,%eax
  801956:	89 c6                	mov    %eax,%esi
  801958:	c1 e6 07             	shl    $0x7,%esi
  80195b:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801961:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801967:	b9 11 00 00 00       	mov    $0x11,%ecx
  80196c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  80196e:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801974:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
	cprintf("in %s\n", __FUNCTION__);
  80197a:	83 ec 08             	sub    $0x8,%esp
  80197d:	68 c4 31 80 00       	push   $0x8031c4
  801982:	68 50 2c 80 00       	push   $0x802c50
  801987:	e8 f2 e8 ff ff       	call   80027e <cprintf>
  80198c:	83 c4 10             	add    $0x10,%esp
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80198f:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801994:	be 00 00 00 00       	mov    $0x0,%esi
  801999:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80199c:	eb 4b                	jmp    8019e9 <spawn+0x119>
		close(fd);
  80199e:	83 ec 0c             	sub    $0xc,%esp
  8019a1:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  8019a7:	e8 a3 f8 ff ff       	call   80124f <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8019ac:	83 c4 0c             	add    $0xc,%esp
  8019af:	68 7f 45 4c 46       	push   $0x464c457f
  8019b4:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  8019ba:	68 f7 30 80 00       	push   $0x8030f7
  8019bf:	e8 ba e8 ff ff       	call   80027e <cprintf>
		return -E_NOT_EXEC;
  8019c4:	83 c4 10             	add    $0x10,%esp
  8019c7:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  8019ce:	ff ff ff 
  8019d1:	e9 3d 04 00 00       	jmp    801e13 <spawn+0x543>
		string_size += strlen(argv[argc]) + 1;
  8019d6:	83 ec 0c             	sub    $0xc,%esp
  8019d9:	50                   	push   %eax
  8019da:	e8 c5 ef ff ff       	call   8009a4 <strlen>
  8019df:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  8019e3:	83 c3 01             	add    $0x1,%ebx
  8019e6:	83 c4 10             	add    $0x10,%esp
  8019e9:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8019f0:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8019f3:	85 c0                	test   %eax,%eax
  8019f5:	75 df                	jne    8019d6 <spawn+0x106>
  8019f7:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  8019fd:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801a03:	bf 00 10 40 00       	mov    $0x401000,%edi
  801a08:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801a0a:	89 fa                	mov    %edi,%edx
  801a0c:	83 e2 fc             	and    $0xfffffffc,%edx
  801a0f:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801a16:	29 c2                	sub    %eax,%edx
  801a18:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801a1e:	8d 42 f8             	lea    -0x8(%edx),%eax
  801a21:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801a26:	0f 86 0a 04 00 00    	jbe    801e36 <spawn+0x566>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801a2c:	83 ec 04             	sub    $0x4,%esp
  801a2f:	6a 07                	push   $0x7
  801a31:	68 00 00 40 00       	push   $0x400000
  801a36:	6a 00                	push   $0x0
  801a38:	e8 92 f3 ff ff       	call   800dcf <sys_page_alloc>
  801a3d:	83 c4 10             	add    $0x10,%esp
  801a40:	85 c0                	test   %eax,%eax
  801a42:	0f 88 f3 03 00 00    	js     801e3b <spawn+0x56b>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801a48:	be 00 00 00 00       	mov    $0x0,%esi
  801a4d:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801a53:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a56:	eb 30                	jmp    801a88 <spawn+0x1b8>
		argv_store[i] = UTEMP2USTACK(string_store);
  801a58:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801a5e:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801a64:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801a67:	83 ec 08             	sub    $0x8,%esp
  801a6a:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801a6d:	57                   	push   %edi
  801a6e:	e8 6a ef ff ff       	call   8009dd <strcpy>
		string_store += strlen(argv[i]) + 1;
  801a73:	83 c4 04             	add    $0x4,%esp
  801a76:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801a79:	e8 26 ef ff ff       	call   8009a4 <strlen>
  801a7e:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801a82:	83 c6 01             	add    $0x1,%esi
  801a85:	83 c4 10             	add    $0x10,%esp
  801a88:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801a8e:	7f c8                	jg     801a58 <spawn+0x188>
	}
	argv_store[argc] = 0;
  801a90:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801a96:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801a9c:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801aa3:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801aa9:	0f 85 86 00 00 00    	jne    801b35 <spawn+0x265>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801aaf:	8b 95 90 fd ff ff    	mov    -0x270(%ebp),%edx
  801ab5:	8d 82 00 d0 7f ee    	lea    -0x11803000(%edx),%eax
  801abb:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801abe:	89 d0                	mov    %edx,%eax
  801ac0:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801ac6:	89 4a f8             	mov    %ecx,-0x8(%edx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801ac9:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801ace:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801ad4:	83 ec 0c             	sub    $0xc,%esp
  801ad7:	6a 07                	push   $0x7
  801ad9:	68 00 d0 bf ee       	push   $0xeebfd000
  801ade:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801ae4:	68 00 00 40 00       	push   $0x400000
  801ae9:	6a 00                	push   $0x0
  801aeb:	e8 22 f3 ff ff       	call   800e12 <sys_page_map>
  801af0:	89 c3                	mov    %eax,%ebx
  801af2:	83 c4 20             	add    $0x20,%esp
  801af5:	85 c0                	test   %eax,%eax
  801af7:	0f 88 46 03 00 00    	js     801e43 <spawn+0x573>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801afd:	83 ec 08             	sub    $0x8,%esp
  801b00:	68 00 00 40 00       	push   $0x400000
  801b05:	6a 00                	push   $0x0
  801b07:	e8 48 f3 ff ff       	call   800e54 <sys_page_unmap>
  801b0c:	89 c3                	mov    %eax,%ebx
  801b0e:	83 c4 10             	add    $0x10,%esp
  801b11:	85 c0                	test   %eax,%eax
  801b13:	0f 88 2a 03 00 00    	js     801e43 <spawn+0x573>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801b19:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801b1f:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801b26:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801b2d:	00 00 00 
  801b30:	e9 4f 01 00 00       	jmp    801c84 <spawn+0x3b4>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801b35:	68 80 31 80 00       	push   $0x803180
  801b3a:	68 cb 30 80 00       	push   $0x8030cb
  801b3f:	68 f8 00 00 00       	push   $0xf8
  801b44:	68 11 31 80 00       	push   $0x803111
  801b49:	e8 3a e6 ff ff       	call   800188 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801b4e:	83 ec 04             	sub    $0x4,%esp
  801b51:	6a 07                	push   $0x7
  801b53:	68 00 00 40 00       	push   $0x400000
  801b58:	6a 00                	push   $0x0
  801b5a:	e8 70 f2 ff ff       	call   800dcf <sys_page_alloc>
  801b5f:	83 c4 10             	add    $0x10,%esp
  801b62:	85 c0                	test   %eax,%eax
  801b64:	0f 88 b7 02 00 00    	js     801e21 <spawn+0x551>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801b6a:	83 ec 08             	sub    $0x8,%esp
  801b6d:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801b73:	01 f0                	add    %esi,%eax
  801b75:	50                   	push   %eax
  801b76:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801b7c:	e8 5a f9 ff ff       	call   8014db <seek>
  801b81:	83 c4 10             	add    $0x10,%esp
  801b84:	85 c0                	test   %eax,%eax
  801b86:	0f 88 9c 02 00 00    	js     801e28 <spawn+0x558>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801b8c:	83 ec 04             	sub    $0x4,%esp
  801b8f:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801b95:	29 f0                	sub    %esi,%eax
  801b97:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b9c:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801ba1:	0f 47 c1             	cmova  %ecx,%eax
  801ba4:	50                   	push   %eax
  801ba5:	68 00 00 40 00       	push   $0x400000
  801baa:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801bb0:	e8 5f f8 ff ff       	call   801414 <readn>
  801bb5:	83 c4 10             	add    $0x10,%esp
  801bb8:	85 c0                	test   %eax,%eax
  801bba:	0f 88 6f 02 00 00    	js     801e2f <spawn+0x55f>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801bc0:	83 ec 0c             	sub    $0xc,%esp
  801bc3:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801bc9:	53                   	push   %ebx
  801bca:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801bd0:	68 00 00 40 00       	push   $0x400000
  801bd5:	6a 00                	push   $0x0
  801bd7:	e8 36 f2 ff ff       	call   800e12 <sys_page_map>
  801bdc:	83 c4 20             	add    $0x20,%esp
  801bdf:	85 c0                	test   %eax,%eax
  801be1:	78 7c                	js     801c5f <spawn+0x38f>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801be3:	83 ec 08             	sub    $0x8,%esp
  801be6:	68 00 00 40 00       	push   $0x400000
  801beb:	6a 00                	push   $0x0
  801bed:	e8 62 f2 ff ff       	call   800e54 <sys_page_unmap>
  801bf2:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801bf5:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801bfb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c01:	89 fe                	mov    %edi,%esi
  801c03:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801c09:	76 69                	jbe    801c74 <spawn+0x3a4>
		if (i >= filesz) {
  801c0b:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801c11:	0f 87 37 ff ff ff    	ja     801b4e <spawn+0x27e>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801c17:	83 ec 04             	sub    $0x4,%esp
  801c1a:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801c20:	53                   	push   %ebx
  801c21:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801c27:	e8 a3 f1 ff ff       	call   800dcf <sys_page_alloc>
  801c2c:	83 c4 10             	add    $0x10,%esp
  801c2f:	85 c0                	test   %eax,%eax
  801c31:	79 c2                	jns    801bf5 <spawn+0x325>
  801c33:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801c35:	83 ec 0c             	sub    $0xc,%esp
  801c38:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801c3e:	e8 0d f1 ff ff       	call   800d50 <sys_env_destroy>
	close(fd);
  801c43:	83 c4 04             	add    $0x4,%esp
  801c46:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801c4c:	e8 fe f5 ff ff       	call   80124f <close>
	return r;
  801c51:	83 c4 10             	add    $0x10,%esp
  801c54:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801c5a:	e9 b4 01 00 00       	jmp    801e13 <spawn+0x543>
				panic("spawn: sys_page_map data: %e", r);
  801c5f:	50                   	push   %eax
  801c60:	68 1d 31 80 00       	push   $0x80311d
  801c65:	68 2b 01 00 00       	push   $0x12b
  801c6a:	68 11 31 80 00       	push   $0x803111
  801c6f:	e8 14 e5 ff ff       	call   800188 <_panic>
  801c74:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801c7a:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801c81:	83 c6 20             	add    $0x20,%esi
  801c84:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801c8b:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801c91:	7e 6d                	jle    801d00 <spawn+0x430>
		if (ph->p_type != ELF_PROG_LOAD)
  801c93:	83 3e 01             	cmpl   $0x1,(%esi)
  801c96:	75 e2                	jne    801c7a <spawn+0x3aa>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801c98:	8b 46 18             	mov    0x18(%esi),%eax
  801c9b:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801c9e:	83 f8 01             	cmp    $0x1,%eax
  801ca1:	19 c0                	sbb    %eax,%eax
  801ca3:	83 e0 fe             	and    $0xfffffffe,%eax
  801ca6:	83 c0 07             	add    $0x7,%eax
  801ca9:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801caf:	8b 4e 04             	mov    0x4(%esi),%ecx
  801cb2:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801cb8:	8b 56 10             	mov    0x10(%esi),%edx
  801cbb:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801cc1:	8b 7e 14             	mov    0x14(%esi),%edi
  801cc4:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801cca:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801ccd:	89 d8                	mov    %ebx,%eax
  801ccf:	25 ff 0f 00 00       	and    $0xfff,%eax
  801cd4:	74 1a                	je     801cf0 <spawn+0x420>
		va -= i;
  801cd6:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801cd8:	01 c7                	add    %eax,%edi
  801cda:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801ce0:	01 c2                	add    %eax,%edx
  801ce2:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801ce8:	29 c1                	sub    %eax,%ecx
  801cea:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801cf0:	bf 00 00 00 00       	mov    $0x0,%edi
  801cf5:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801cfb:	e9 01 ff ff ff       	jmp    801c01 <spawn+0x331>
	close(fd);
  801d00:	83 ec 0c             	sub    $0xc,%esp
  801d03:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801d09:	e8 41 f5 ff ff       	call   80124f <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	cprintf("in %s\n", __FUNCTION__);
  801d0e:	83 c4 08             	add    $0x8,%esp
  801d11:	68 b0 31 80 00       	push   $0x8031b0
  801d16:	68 50 2c 80 00       	push   $0x802c50
  801d1b:	e8 5e e5 ff ff       	call   80027e <cprintf>
  801d20:	83 c4 10             	add    $0x10,%esp
	int r;
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  801d23:	bb 00 00 80 00       	mov    $0x800000,%ebx
  801d28:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801d2e:	eb 0e                	jmp    801d3e <spawn+0x46e>
  801d30:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801d36:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801d3c:	74 5e                	je     801d9c <spawn+0x4cc>
		if((uvpd[PDX(i)] & PTE_P) && ((uvpt[PGNUM(i)] & (PTE_P | PTE_U | PTE_SHARE)) == (PTE_P | PTE_U | PTE_SHARE)))
  801d3e:	89 d8                	mov    %ebx,%eax
  801d40:	c1 e8 16             	shr    $0x16,%eax
  801d43:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d4a:	a8 01                	test   $0x1,%al
  801d4c:	74 e2                	je     801d30 <spawn+0x460>
  801d4e:	89 da                	mov    %ebx,%edx
  801d50:	c1 ea 0c             	shr    $0xc,%edx
  801d53:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801d5a:	25 05 04 00 00       	and    $0x405,%eax
  801d5f:	3d 05 04 00 00       	cmp    $0x405,%eax
  801d64:	75 ca                	jne    801d30 <spawn+0x460>
			if((r = sys_page_map((envid_t)0, (void *)i, child, (void *)i, uvpt[PGNUM(i)] & PTE_SYSCALL)) < 0)
  801d66:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801d6d:	83 ec 0c             	sub    $0xc,%esp
  801d70:	25 07 0e 00 00       	and    $0xe07,%eax
  801d75:	50                   	push   %eax
  801d76:	53                   	push   %ebx
  801d77:	56                   	push   %esi
  801d78:	53                   	push   %ebx
  801d79:	6a 00                	push   $0x0
  801d7b:	e8 92 f0 ff ff       	call   800e12 <sys_page_map>
  801d80:	83 c4 20             	add    $0x20,%esp
  801d83:	85 c0                	test   %eax,%eax
  801d85:	79 a9                	jns    801d30 <spawn+0x460>
        		panic("sys_page_map: %e\n", r);
  801d87:	50                   	push   %eax
  801d88:	68 3a 31 80 00       	push   $0x80313a
  801d8d:	68 3b 01 00 00       	push   $0x13b
  801d92:	68 11 31 80 00       	push   $0x803111
  801d97:	e8 ec e3 ff ff       	call   800188 <_panic>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801d9c:	83 ec 08             	sub    $0x8,%esp
  801d9f:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801da5:	50                   	push   %eax
  801da6:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801dac:	e8 27 f1 ff ff       	call   800ed8 <sys_env_set_trapframe>
  801db1:	83 c4 10             	add    $0x10,%esp
  801db4:	85 c0                	test   %eax,%eax
  801db6:	78 25                	js     801ddd <spawn+0x50d>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801db8:	83 ec 08             	sub    $0x8,%esp
  801dbb:	6a 02                	push   $0x2
  801dbd:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801dc3:	e8 ce f0 ff ff       	call   800e96 <sys_env_set_status>
  801dc8:	83 c4 10             	add    $0x10,%esp
  801dcb:	85 c0                	test   %eax,%eax
  801dcd:	78 23                	js     801df2 <spawn+0x522>
	return child;
  801dcf:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801dd5:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801ddb:	eb 36                	jmp    801e13 <spawn+0x543>
		panic("sys_env_set_trapframe: %e", r);
  801ddd:	50                   	push   %eax
  801dde:	68 4c 31 80 00       	push   $0x80314c
  801de3:	68 8a 00 00 00       	push   $0x8a
  801de8:	68 11 31 80 00       	push   $0x803111
  801ded:	e8 96 e3 ff ff       	call   800188 <_panic>
		panic("sys_env_set_status: %e", r);
  801df2:	50                   	push   %eax
  801df3:	68 66 31 80 00       	push   $0x803166
  801df8:	68 8d 00 00 00       	push   $0x8d
  801dfd:	68 11 31 80 00       	push   $0x803111
  801e02:	e8 81 e3 ff ff       	call   800188 <_panic>
		return r;
  801e07:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e0d:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801e13:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801e19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e1c:	5b                   	pop    %ebx
  801e1d:	5e                   	pop    %esi
  801e1e:	5f                   	pop    %edi
  801e1f:	5d                   	pop    %ebp
  801e20:	c3                   	ret    
  801e21:	89 c7                	mov    %eax,%edi
  801e23:	e9 0d fe ff ff       	jmp    801c35 <spawn+0x365>
  801e28:	89 c7                	mov    %eax,%edi
  801e2a:	e9 06 fe ff ff       	jmp    801c35 <spawn+0x365>
  801e2f:	89 c7                	mov    %eax,%edi
  801e31:	e9 ff fd ff ff       	jmp    801c35 <spawn+0x365>
		return -E_NO_MEM;
  801e36:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	for(uintptr_t i = UTEXT; i < USTACKTOP; i+=PGSIZE){
  801e3b:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801e41:	eb d0                	jmp    801e13 <spawn+0x543>
	sys_page_unmap(0, UTEMP);
  801e43:	83 ec 08             	sub    $0x8,%esp
  801e46:	68 00 00 40 00       	push   $0x400000
  801e4b:	6a 00                	push   $0x0
  801e4d:	e8 02 f0 ff ff       	call   800e54 <sys_page_unmap>
  801e52:	83 c4 10             	add    $0x10,%esp
  801e55:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801e5b:	eb b6                	jmp    801e13 <spawn+0x543>

00801e5d <spawnl>:
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
  801e60:	57                   	push   %edi
  801e61:	56                   	push   %esi
  801e62:	53                   	push   %ebx
  801e63:	83 ec 14             	sub    $0x14,%esp
	cprintf("in %s\n", __FUNCTION__);
  801e66:	68 a8 31 80 00       	push   $0x8031a8
  801e6b:	68 50 2c 80 00       	push   $0x802c50
  801e70:	e8 09 e4 ff ff       	call   80027e <cprintf>
	va_start(vl, arg0);
  801e75:	8d 55 10             	lea    0x10(%ebp),%edx
	while(va_arg(vl, void *) != NULL)
  801e78:	83 c4 10             	add    $0x10,%esp
	int argc=0;
  801e7b:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801e80:	8d 4a 04             	lea    0x4(%edx),%ecx
  801e83:	83 3a 00             	cmpl   $0x0,(%edx)
  801e86:	74 07                	je     801e8f <spawnl+0x32>
		argc++;
  801e88:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801e8b:	89 ca                	mov    %ecx,%edx
  801e8d:	eb f1                	jmp    801e80 <spawnl+0x23>
	const char *argv[argc+2];
  801e8f:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801e96:	83 e2 f0             	and    $0xfffffff0,%edx
  801e99:	29 d4                	sub    %edx,%esp
  801e9b:	8d 54 24 03          	lea    0x3(%esp),%edx
  801e9f:	c1 ea 02             	shr    $0x2,%edx
  801ea2:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801ea9:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801eab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801eae:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801eb5:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801ebc:	00 
	va_start(vl, arg0);
  801ebd:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801ec0:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801ec2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec7:	eb 0b                	jmp    801ed4 <spawnl+0x77>
		argv[i+1] = va_arg(vl, const char *);
  801ec9:	83 c0 01             	add    $0x1,%eax
  801ecc:	8b 39                	mov    (%ecx),%edi
  801ece:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801ed1:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801ed4:	39 d0                	cmp    %edx,%eax
  801ed6:	75 f1                	jne    801ec9 <spawnl+0x6c>
	return spawn(prog, argv);
  801ed8:	83 ec 08             	sub    $0x8,%esp
  801edb:	56                   	push   %esi
  801edc:	ff 75 08             	pushl  0x8(%ebp)
  801edf:	e8 ec f9 ff ff       	call   8018d0 <spawn>
}
  801ee4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ee7:	5b                   	pop    %ebx
  801ee8:	5e                   	pop    %esi
  801ee9:	5f                   	pop    %edi
  801eea:	5d                   	pop    %ebp
  801eeb:	c3                   	ret    

00801eec <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
  801eef:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ef2:	68 d6 31 80 00       	push   $0x8031d6
  801ef7:	ff 75 0c             	pushl  0xc(%ebp)
  801efa:	e8 de ea ff ff       	call   8009dd <strcpy>
	return 0;
}
  801eff:	b8 00 00 00 00       	mov    $0x0,%eax
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <devsock_close>:
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
  801f09:	53                   	push   %ebx
  801f0a:	83 ec 10             	sub    $0x10,%esp
  801f0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f10:	53                   	push   %ebx
  801f11:	e8 fc 09 00 00       	call   802912 <pageref>
  801f16:	83 c4 10             	add    $0x10,%esp
		return 0;
  801f19:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801f1e:	83 f8 01             	cmp    $0x1,%eax
  801f21:	74 07                	je     801f2a <devsock_close+0x24>
}
  801f23:	89 d0                	mov    %edx,%eax
  801f25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801f2a:	83 ec 0c             	sub    $0xc,%esp
  801f2d:	ff 73 0c             	pushl  0xc(%ebx)
  801f30:	e8 b9 02 00 00       	call   8021ee <nsipc_close>
  801f35:	89 c2                	mov    %eax,%edx
  801f37:	83 c4 10             	add    $0x10,%esp
  801f3a:	eb e7                	jmp    801f23 <devsock_close+0x1d>

00801f3c <devsock_write>:
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
  801f3f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f42:	6a 00                	push   $0x0
  801f44:	ff 75 10             	pushl  0x10(%ebp)
  801f47:	ff 75 0c             	pushl  0xc(%ebp)
  801f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4d:	ff 70 0c             	pushl  0xc(%eax)
  801f50:	e8 76 03 00 00       	call   8022cb <nsipc_send>
}
  801f55:	c9                   	leave  
  801f56:	c3                   	ret    

00801f57 <devsock_read>:
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
  801f5a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f5d:	6a 00                	push   $0x0
  801f5f:	ff 75 10             	pushl  0x10(%ebp)
  801f62:	ff 75 0c             	pushl  0xc(%ebp)
  801f65:	8b 45 08             	mov    0x8(%ebp),%eax
  801f68:	ff 70 0c             	pushl  0xc(%eax)
  801f6b:	e8 ef 02 00 00       	call   80225f <nsipc_recv>
}
  801f70:	c9                   	leave  
  801f71:	c3                   	ret    

00801f72 <fd2sockid>:
{
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
  801f75:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f78:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f7b:	52                   	push   %edx
  801f7c:	50                   	push   %eax
  801f7d:	e8 9b f1 ff ff       	call   80111d <fd_lookup>
  801f82:	83 c4 10             	add    $0x10,%esp
  801f85:	85 c0                	test   %eax,%eax
  801f87:	78 10                	js     801f99 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8c:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f92:	39 08                	cmp    %ecx,(%eax)
  801f94:	75 05                	jne    801f9b <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801f96:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801f99:	c9                   	leave  
  801f9a:	c3                   	ret    
		return -E_NOT_SUPP;
  801f9b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fa0:	eb f7                	jmp    801f99 <fd2sockid+0x27>

00801fa2 <alloc_sockfd>:
{
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
  801fa5:	56                   	push   %esi
  801fa6:	53                   	push   %ebx
  801fa7:	83 ec 1c             	sub    $0x1c,%esp
  801faa:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801fac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801faf:	50                   	push   %eax
  801fb0:	e8 16 f1 ff ff       	call   8010cb <fd_alloc>
  801fb5:	89 c3                	mov    %eax,%ebx
  801fb7:	83 c4 10             	add    $0x10,%esp
  801fba:	85 c0                	test   %eax,%eax
  801fbc:	78 43                	js     802001 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801fbe:	83 ec 04             	sub    $0x4,%esp
  801fc1:	68 07 04 00 00       	push   $0x407
  801fc6:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc9:	6a 00                	push   $0x0
  801fcb:	e8 ff ed ff ff       	call   800dcf <sys_page_alloc>
  801fd0:	89 c3                	mov    %eax,%ebx
  801fd2:	83 c4 10             	add    $0x10,%esp
  801fd5:	85 c0                	test   %eax,%eax
  801fd7:	78 28                	js     802001 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdc:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801fe2:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801fee:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ff1:	83 ec 0c             	sub    $0xc,%esp
  801ff4:	50                   	push   %eax
  801ff5:	e8 aa f0 ff ff       	call   8010a4 <fd2num>
  801ffa:	89 c3                	mov    %eax,%ebx
  801ffc:	83 c4 10             	add    $0x10,%esp
  801fff:	eb 0c                	jmp    80200d <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802001:	83 ec 0c             	sub    $0xc,%esp
  802004:	56                   	push   %esi
  802005:	e8 e4 01 00 00       	call   8021ee <nsipc_close>
		return r;
  80200a:	83 c4 10             	add    $0x10,%esp
}
  80200d:	89 d8                	mov    %ebx,%eax
  80200f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802012:	5b                   	pop    %ebx
  802013:	5e                   	pop    %esi
  802014:	5d                   	pop    %ebp
  802015:	c3                   	ret    

00802016 <accept>:
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
  802019:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80201c:	8b 45 08             	mov    0x8(%ebp),%eax
  80201f:	e8 4e ff ff ff       	call   801f72 <fd2sockid>
  802024:	85 c0                	test   %eax,%eax
  802026:	78 1b                	js     802043 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802028:	83 ec 04             	sub    $0x4,%esp
  80202b:	ff 75 10             	pushl  0x10(%ebp)
  80202e:	ff 75 0c             	pushl  0xc(%ebp)
  802031:	50                   	push   %eax
  802032:	e8 0e 01 00 00       	call   802145 <nsipc_accept>
  802037:	83 c4 10             	add    $0x10,%esp
  80203a:	85 c0                	test   %eax,%eax
  80203c:	78 05                	js     802043 <accept+0x2d>
	return alloc_sockfd(r);
  80203e:	e8 5f ff ff ff       	call   801fa2 <alloc_sockfd>
}
  802043:	c9                   	leave  
  802044:	c3                   	ret    

00802045 <bind>:
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
  802048:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80204b:	8b 45 08             	mov    0x8(%ebp),%eax
  80204e:	e8 1f ff ff ff       	call   801f72 <fd2sockid>
  802053:	85 c0                	test   %eax,%eax
  802055:	78 12                	js     802069 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  802057:	83 ec 04             	sub    $0x4,%esp
  80205a:	ff 75 10             	pushl  0x10(%ebp)
  80205d:	ff 75 0c             	pushl  0xc(%ebp)
  802060:	50                   	push   %eax
  802061:	e8 31 01 00 00       	call   802197 <nsipc_bind>
  802066:	83 c4 10             	add    $0x10,%esp
}
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <shutdown>:
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802071:	8b 45 08             	mov    0x8(%ebp),%eax
  802074:	e8 f9 fe ff ff       	call   801f72 <fd2sockid>
  802079:	85 c0                	test   %eax,%eax
  80207b:	78 0f                	js     80208c <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80207d:	83 ec 08             	sub    $0x8,%esp
  802080:	ff 75 0c             	pushl  0xc(%ebp)
  802083:	50                   	push   %eax
  802084:	e8 43 01 00 00       	call   8021cc <nsipc_shutdown>
  802089:	83 c4 10             	add    $0x10,%esp
}
  80208c:	c9                   	leave  
  80208d:	c3                   	ret    

0080208e <connect>:
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
  802091:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802094:	8b 45 08             	mov    0x8(%ebp),%eax
  802097:	e8 d6 fe ff ff       	call   801f72 <fd2sockid>
  80209c:	85 c0                	test   %eax,%eax
  80209e:	78 12                	js     8020b2 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8020a0:	83 ec 04             	sub    $0x4,%esp
  8020a3:	ff 75 10             	pushl  0x10(%ebp)
  8020a6:	ff 75 0c             	pushl  0xc(%ebp)
  8020a9:	50                   	push   %eax
  8020aa:	e8 59 01 00 00       	call   802208 <nsipc_connect>
  8020af:	83 c4 10             	add    $0x10,%esp
}
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    

008020b4 <listen>:
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
  8020b7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	e8 b0 fe ff ff       	call   801f72 <fd2sockid>
  8020c2:	85 c0                	test   %eax,%eax
  8020c4:	78 0f                	js     8020d5 <listen+0x21>
	return nsipc_listen(r, backlog);
  8020c6:	83 ec 08             	sub    $0x8,%esp
  8020c9:	ff 75 0c             	pushl  0xc(%ebp)
  8020cc:	50                   	push   %eax
  8020cd:	e8 6b 01 00 00       	call   80223d <nsipc_listen>
  8020d2:	83 c4 10             	add    $0x10,%esp
}
  8020d5:	c9                   	leave  
  8020d6:	c3                   	ret    

008020d7 <socket>:

int
socket(int domain, int type, int protocol)
{
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
  8020da:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020dd:	ff 75 10             	pushl  0x10(%ebp)
  8020e0:	ff 75 0c             	pushl  0xc(%ebp)
  8020e3:	ff 75 08             	pushl  0x8(%ebp)
  8020e6:	e8 3e 02 00 00       	call   802329 <nsipc_socket>
  8020eb:	83 c4 10             	add    $0x10,%esp
  8020ee:	85 c0                	test   %eax,%eax
  8020f0:	78 05                	js     8020f7 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8020f2:	e8 ab fe ff ff       	call   801fa2 <alloc_sockfd>
}
  8020f7:	c9                   	leave  
  8020f8:	c3                   	ret    

008020f9 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
  8020fc:	53                   	push   %ebx
  8020fd:	83 ec 04             	sub    $0x4,%esp
  802100:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802102:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802109:	74 26                	je     802131 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80210b:	6a 07                	push   $0x7
  80210d:	68 00 70 80 00       	push   $0x807000
  802112:	53                   	push   %ebx
  802113:	ff 35 04 50 80 00    	pushl  0x805004
  802119:	e8 61 07 00 00       	call   80287f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80211e:	83 c4 0c             	add    $0xc,%esp
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	e8 ea 06 00 00       	call   802816 <ipc_recv>
}
  80212c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80212f:	c9                   	leave  
  802130:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802131:	83 ec 0c             	sub    $0xc,%esp
  802134:	6a 02                	push   $0x2
  802136:	e8 9c 07 00 00       	call   8028d7 <ipc_find_env>
  80213b:	a3 04 50 80 00       	mov    %eax,0x805004
  802140:	83 c4 10             	add    $0x10,%esp
  802143:	eb c6                	jmp    80210b <nsipc+0x12>

00802145 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
  802148:	56                   	push   %esi
  802149:	53                   	push   %ebx
  80214a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80214d:	8b 45 08             	mov    0x8(%ebp),%eax
  802150:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802155:	8b 06                	mov    (%esi),%eax
  802157:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80215c:	b8 01 00 00 00       	mov    $0x1,%eax
  802161:	e8 93 ff ff ff       	call   8020f9 <nsipc>
  802166:	89 c3                	mov    %eax,%ebx
  802168:	85 c0                	test   %eax,%eax
  80216a:	79 09                	jns    802175 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80216c:	89 d8                	mov    %ebx,%eax
  80216e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802171:	5b                   	pop    %ebx
  802172:	5e                   	pop    %esi
  802173:	5d                   	pop    %ebp
  802174:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802175:	83 ec 04             	sub    $0x4,%esp
  802178:	ff 35 10 70 80 00    	pushl  0x807010
  80217e:	68 00 70 80 00       	push   $0x807000
  802183:	ff 75 0c             	pushl  0xc(%ebp)
  802186:	e8 e0 e9 ff ff       	call   800b6b <memmove>
		*addrlen = ret->ret_addrlen;
  80218b:	a1 10 70 80 00       	mov    0x807010,%eax
  802190:	89 06                	mov    %eax,(%esi)
  802192:	83 c4 10             	add    $0x10,%esp
	return r;
  802195:	eb d5                	jmp    80216c <nsipc_accept+0x27>

00802197 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802197:	55                   	push   %ebp
  802198:	89 e5                	mov    %esp,%ebp
  80219a:	53                   	push   %ebx
  80219b:	83 ec 08             	sub    $0x8,%esp
  80219e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021a9:	53                   	push   %ebx
  8021aa:	ff 75 0c             	pushl  0xc(%ebp)
  8021ad:	68 04 70 80 00       	push   $0x807004
  8021b2:	e8 b4 e9 ff ff       	call   800b6b <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021b7:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021bd:	b8 02 00 00 00       	mov    $0x2,%eax
  8021c2:	e8 32 ff ff ff       	call   8020f9 <nsipc>
}
  8021c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021ca:	c9                   	leave  
  8021cb:	c3                   	ret    

008021cc <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021cc:	55                   	push   %ebp
  8021cd:	89 e5                	mov    %esp,%ebp
  8021cf:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8021da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021dd:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8021e2:	b8 03 00 00 00       	mov    $0x3,%eax
  8021e7:	e8 0d ff ff ff       	call   8020f9 <nsipc>
}
  8021ec:	c9                   	leave  
  8021ed:	c3                   	ret    

008021ee <nsipc_close>:

int
nsipc_close(int s)
{
  8021ee:	55                   	push   %ebp
  8021ef:	89 e5                	mov    %esp,%ebp
  8021f1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f7:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8021fc:	b8 04 00 00 00       	mov    $0x4,%eax
  802201:	e8 f3 fe ff ff       	call   8020f9 <nsipc>
}
  802206:	c9                   	leave  
  802207:	c3                   	ret    

00802208 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802208:	55                   	push   %ebp
  802209:	89 e5                	mov    %esp,%ebp
  80220b:	53                   	push   %ebx
  80220c:	83 ec 08             	sub    $0x8,%esp
  80220f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802212:	8b 45 08             	mov    0x8(%ebp),%eax
  802215:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80221a:	53                   	push   %ebx
  80221b:	ff 75 0c             	pushl  0xc(%ebp)
  80221e:	68 04 70 80 00       	push   $0x807004
  802223:	e8 43 e9 ff ff       	call   800b6b <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802228:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  80222e:	b8 05 00 00 00       	mov    $0x5,%eax
  802233:	e8 c1 fe ff ff       	call   8020f9 <nsipc>
}
  802238:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80223b:	c9                   	leave  
  80223c:	c3                   	ret    

0080223d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80223d:	55                   	push   %ebp
  80223e:	89 e5                	mov    %esp,%ebp
  802240:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802243:	8b 45 08             	mov    0x8(%ebp),%eax
  802246:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80224b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224e:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802253:	b8 06 00 00 00       	mov    $0x6,%eax
  802258:	e8 9c fe ff ff       	call   8020f9 <nsipc>
}
  80225d:	c9                   	leave  
  80225e:	c3                   	ret    

0080225f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80225f:	55                   	push   %ebp
  802260:	89 e5                	mov    %esp,%ebp
  802262:	56                   	push   %esi
  802263:	53                   	push   %ebx
  802264:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80226f:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802275:	8b 45 14             	mov    0x14(%ebp),%eax
  802278:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80227d:	b8 07 00 00 00       	mov    $0x7,%eax
  802282:	e8 72 fe ff ff       	call   8020f9 <nsipc>
  802287:	89 c3                	mov    %eax,%ebx
  802289:	85 c0                	test   %eax,%eax
  80228b:	78 1f                	js     8022ac <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80228d:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802292:	7f 21                	jg     8022b5 <nsipc_recv+0x56>
  802294:	39 c6                	cmp    %eax,%esi
  802296:	7c 1d                	jl     8022b5 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802298:	83 ec 04             	sub    $0x4,%esp
  80229b:	50                   	push   %eax
  80229c:	68 00 70 80 00       	push   $0x807000
  8022a1:	ff 75 0c             	pushl  0xc(%ebp)
  8022a4:	e8 c2 e8 ff ff       	call   800b6b <memmove>
  8022a9:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8022ac:	89 d8                	mov    %ebx,%eax
  8022ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022b1:	5b                   	pop    %ebx
  8022b2:	5e                   	pop    %esi
  8022b3:	5d                   	pop    %ebp
  8022b4:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8022b5:	68 e2 31 80 00       	push   $0x8031e2
  8022ba:	68 cb 30 80 00       	push   $0x8030cb
  8022bf:	6a 62                	push   $0x62
  8022c1:	68 f7 31 80 00       	push   $0x8031f7
  8022c6:	e8 bd de ff ff       	call   800188 <_panic>

008022cb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
  8022ce:	53                   	push   %ebx
  8022cf:	83 ec 04             	sub    $0x4,%esp
  8022d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8022dd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8022e3:	7f 2e                	jg     802313 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022e5:	83 ec 04             	sub    $0x4,%esp
  8022e8:	53                   	push   %ebx
  8022e9:	ff 75 0c             	pushl  0xc(%ebp)
  8022ec:	68 0c 70 80 00       	push   $0x80700c
  8022f1:	e8 75 e8 ff ff       	call   800b6b <memmove>
	nsipcbuf.send.req_size = size;
  8022f6:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8022fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8022ff:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802304:	b8 08 00 00 00       	mov    $0x8,%eax
  802309:	e8 eb fd ff ff       	call   8020f9 <nsipc>
}
  80230e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802311:	c9                   	leave  
  802312:	c3                   	ret    
	assert(size < 1600);
  802313:	68 03 32 80 00       	push   $0x803203
  802318:	68 cb 30 80 00       	push   $0x8030cb
  80231d:	6a 6d                	push   $0x6d
  80231f:	68 f7 31 80 00       	push   $0x8031f7
  802324:	e8 5f de ff ff       	call   800188 <_panic>

00802329 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802329:	55                   	push   %ebp
  80232a:	89 e5                	mov    %esp,%ebp
  80232c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80232f:	8b 45 08             	mov    0x8(%ebp),%eax
  802332:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80233a:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80233f:	8b 45 10             	mov    0x10(%ebp),%eax
  802342:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802347:	b8 09 00 00 00       	mov    $0x9,%eax
  80234c:	e8 a8 fd ff ff       	call   8020f9 <nsipc>
}
  802351:	c9                   	leave  
  802352:	c3                   	ret    

00802353 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802353:	55                   	push   %ebp
  802354:	89 e5                	mov    %esp,%ebp
  802356:	56                   	push   %esi
  802357:	53                   	push   %ebx
  802358:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80235b:	83 ec 0c             	sub    $0xc,%esp
  80235e:	ff 75 08             	pushl  0x8(%ebp)
  802361:	e8 4e ed ff ff       	call   8010b4 <fd2data>
  802366:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802368:	83 c4 08             	add    $0x8,%esp
  80236b:	68 0f 32 80 00       	push   $0x80320f
  802370:	53                   	push   %ebx
  802371:	e8 67 e6 ff ff       	call   8009dd <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802376:	8b 46 04             	mov    0x4(%esi),%eax
  802379:	2b 06                	sub    (%esi),%eax
  80237b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802381:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802388:	00 00 00 
	stat->st_dev = &devpipe;
  80238b:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802392:	40 80 00 
	return 0;
}
  802395:	b8 00 00 00 00       	mov    $0x0,%eax
  80239a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80239d:	5b                   	pop    %ebx
  80239e:	5e                   	pop    %esi
  80239f:	5d                   	pop    %ebp
  8023a0:	c3                   	ret    

008023a1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023a1:	55                   	push   %ebp
  8023a2:	89 e5                	mov    %esp,%ebp
  8023a4:	53                   	push   %ebx
  8023a5:	83 ec 0c             	sub    $0xc,%esp
  8023a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023ab:	53                   	push   %ebx
  8023ac:	6a 00                	push   $0x0
  8023ae:	e8 a1 ea ff ff       	call   800e54 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023b3:	89 1c 24             	mov    %ebx,(%esp)
  8023b6:	e8 f9 ec ff ff       	call   8010b4 <fd2data>
  8023bb:	83 c4 08             	add    $0x8,%esp
  8023be:	50                   	push   %eax
  8023bf:	6a 00                	push   $0x0
  8023c1:	e8 8e ea ff ff       	call   800e54 <sys_page_unmap>
}
  8023c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023c9:	c9                   	leave  
  8023ca:	c3                   	ret    

008023cb <_pipeisclosed>:
{
  8023cb:	55                   	push   %ebp
  8023cc:	89 e5                	mov    %esp,%ebp
  8023ce:	57                   	push   %edi
  8023cf:	56                   	push   %esi
  8023d0:	53                   	push   %ebx
  8023d1:	83 ec 1c             	sub    $0x1c,%esp
  8023d4:	89 c7                	mov    %eax,%edi
  8023d6:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8023d8:	a1 08 50 80 00       	mov    0x805008,%eax
  8023dd:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023e0:	83 ec 0c             	sub    $0xc,%esp
  8023e3:	57                   	push   %edi
  8023e4:	e8 29 05 00 00       	call   802912 <pageref>
  8023e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8023ec:	89 34 24             	mov    %esi,(%esp)
  8023ef:	e8 1e 05 00 00       	call   802912 <pageref>
		nn = thisenv->env_runs;
  8023f4:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8023fa:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8023fd:	83 c4 10             	add    $0x10,%esp
  802400:	39 cb                	cmp    %ecx,%ebx
  802402:	74 1b                	je     80241f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802404:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802407:	75 cf                	jne    8023d8 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802409:	8b 42 58             	mov    0x58(%edx),%eax
  80240c:	6a 01                	push   $0x1
  80240e:	50                   	push   %eax
  80240f:	53                   	push   %ebx
  802410:	68 16 32 80 00       	push   $0x803216
  802415:	e8 64 de ff ff       	call   80027e <cprintf>
  80241a:	83 c4 10             	add    $0x10,%esp
  80241d:	eb b9                	jmp    8023d8 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80241f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802422:	0f 94 c0             	sete   %al
  802425:	0f b6 c0             	movzbl %al,%eax
}
  802428:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80242b:	5b                   	pop    %ebx
  80242c:	5e                   	pop    %esi
  80242d:	5f                   	pop    %edi
  80242e:	5d                   	pop    %ebp
  80242f:	c3                   	ret    

00802430 <devpipe_write>:
{
  802430:	55                   	push   %ebp
  802431:	89 e5                	mov    %esp,%ebp
  802433:	57                   	push   %edi
  802434:	56                   	push   %esi
  802435:	53                   	push   %ebx
  802436:	83 ec 28             	sub    $0x28,%esp
  802439:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80243c:	56                   	push   %esi
  80243d:	e8 72 ec ff ff       	call   8010b4 <fd2data>
  802442:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802444:	83 c4 10             	add    $0x10,%esp
  802447:	bf 00 00 00 00       	mov    $0x0,%edi
  80244c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80244f:	74 4f                	je     8024a0 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802451:	8b 43 04             	mov    0x4(%ebx),%eax
  802454:	8b 0b                	mov    (%ebx),%ecx
  802456:	8d 51 20             	lea    0x20(%ecx),%edx
  802459:	39 d0                	cmp    %edx,%eax
  80245b:	72 14                	jb     802471 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80245d:	89 da                	mov    %ebx,%edx
  80245f:	89 f0                	mov    %esi,%eax
  802461:	e8 65 ff ff ff       	call   8023cb <_pipeisclosed>
  802466:	85 c0                	test   %eax,%eax
  802468:	75 3b                	jne    8024a5 <devpipe_write+0x75>
			sys_yield();
  80246a:	e8 41 e9 ff ff       	call   800db0 <sys_yield>
  80246f:	eb e0                	jmp    802451 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802471:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802474:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802478:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80247b:	89 c2                	mov    %eax,%edx
  80247d:	c1 fa 1f             	sar    $0x1f,%edx
  802480:	89 d1                	mov    %edx,%ecx
  802482:	c1 e9 1b             	shr    $0x1b,%ecx
  802485:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802488:	83 e2 1f             	and    $0x1f,%edx
  80248b:	29 ca                	sub    %ecx,%edx
  80248d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802491:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802495:	83 c0 01             	add    $0x1,%eax
  802498:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80249b:	83 c7 01             	add    $0x1,%edi
  80249e:	eb ac                	jmp    80244c <devpipe_write+0x1c>
	return i;
  8024a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8024a3:	eb 05                	jmp    8024aa <devpipe_write+0x7a>
				return 0;
  8024a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024ad:	5b                   	pop    %ebx
  8024ae:	5e                   	pop    %esi
  8024af:	5f                   	pop    %edi
  8024b0:	5d                   	pop    %ebp
  8024b1:	c3                   	ret    

008024b2 <devpipe_read>:
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
  8024b5:	57                   	push   %edi
  8024b6:	56                   	push   %esi
  8024b7:	53                   	push   %ebx
  8024b8:	83 ec 18             	sub    $0x18,%esp
  8024bb:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8024be:	57                   	push   %edi
  8024bf:	e8 f0 eb ff ff       	call   8010b4 <fd2data>
  8024c4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024c6:	83 c4 10             	add    $0x10,%esp
  8024c9:	be 00 00 00 00       	mov    $0x0,%esi
  8024ce:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024d1:	75 14                	jne    8024e7 <devpipe_read+0x35>
	return i;
  8024d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8024d6:	eb 02                	jmp    8024da <devpipe_read+0x28>
				return i;
  8024d8:	89 f0                	mov    %esi,%eax
}
  8024da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024dd:	5b                   	pop    %ebx
  8024de:	5e                   	pop    %esi
  8024df:	5f                   	pop    %edi
  8024e0:	5d                   	pop    %ebp
  8024e1:	c3                   	ret    
			sys_yield();
  8024e2:	e8 c9 e8 ff ff       	call   800db0 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8024e7:	8b 03                	mov    (%ebx),%eax
  8024e9:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024ec:	75 18                	jne    802506 <devpipe_read+0x54>
			if (i > 0)
  8024ee:	85 f6                	test   %esi,%esi
  8024f0:	75 e6                	jne    8024d8 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  8024f2:	89 da                	mov    %ebx,%edx
  8024f4:	89 f8                	mov    %edi,%eax
  8024f6:	e8 d0 fe ff ff       	call   8023cb <_pipeisclosed>
  8024fb:	85 c0                	test   %eax,%eax
  8024fd:	74 e3                	je     8024e2 <devpipe_read+0x30>
				return 0;
  8024ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802504:	eb d4                	jmp    8024da <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802506:	99                   	cltd   
  802507:	c1 ea 1b             	shr    $0x1b,%edx
  80250a:	01 d0                	add    %edx,%eax
  80250c:	83 e0 1f             	and    $0x1f,%eax
  80250f:	29 d0                	sub    %edx,%eax
  802511:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802516:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802519:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80251c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80251f:	83 c6 01             	add    $0x1,%esi
  802522:	eb aa                	jmp    8024ce <devpipe_read+0x1c>

00802524 <pipe>:
{
  802524:	55                   	push   %ebp
  802525:	89 e5                	mov    %esp,%ebp
  802527:	56                   	push   %esi
  802528:	53                   	push   %ebx
  802529:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80252c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80252f:	50                   	push   %eax
  802530:	e8 96 eb ff ff       	call   8010cb <fd_alloc>
  802535:	89 c3                	mov    %eax,%ebx
  802537:	83 c4 10             	add    $0x10,%esp
  80253a:	85 c0                	test   %eax,%eax
  80253c:	0f 88 23 01 00 00    	js     802665 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802542:	83 ec 04             	sub    $0x4,%esp
  802545:	68 07 04 00 00       	push   $0x407
  80254a:	ff 75 f4             	pushl  -0xc(%ebp)
  80254d:	6a 00                	push   $0x0
  80254f:	e8 7b e8 ff ff       	call   800dcf <sys_page_alloc>
  802554:	89 c3                	mov    %eax,%ebx
  802556:	83 c4 10             	add    $0x10,%esp
  802559:	85 c0                	test   %eax,%eax
  80255b:	0f 88 04 01 00 00    	js     802665 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  802561:	83 ec 0c             	sub    $0xc,%esp
  802564:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802567:	50                   	push   %eax
  802568:	e8 5e eb ff ff       	call   8010cb <fd_alloc>
  80256d:	89 c3                	mov    %eax,%ebx
  80256f:	83 c4 10             	add    $0x10,%esp
  802572:	85 c0                	test   %eax,%eax
  802574:	0f 88 db 00 00 00    	js     802655 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80257a:	83 ec 04             	sub    $0x4,%esp
  80257d:	68 07 04 00 00       	push   $0x407
  802582:	ff 75 f0             	pushl  -0x10(%ebp)
  802585:	6a 00                	push   $0x0
  802587:	e8 43 e8 ff ff       	call   800dcf <sys_page_alloc>
  80258c:	89 c3                	mov    %eax,%ebx
  80258e:	83 c4 10             	add    $0x10,%esp
  802591:	85 c0                	test   %eax,%eax
  802593:	0f 88 bc 00 00 00    	js     802655 <pipe+0x131>
	va = fd2data(fd0);
  802599:	83 ec 0c             	sub    $0xc,%esp
  80259c:	ff 75 f4             	pushl  -0xc(%ebp)
  80259f:	e8 10 eb ff ff       	call   8010b4 <fd2data>
  8025a4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025a6:	83 c4 0c             	add    $0xc,%esp
  8025a9:	68 07 04 00 00       	push   $0x407
  8025ae:	50                   	push   %eax
  8025af:	6a 00                	push   $0x0
  8025b1:	e8 19 e8 ff ff       	call   800dcf <sys_page_alloc>
  8025b6:	89 c3                	mov    %eax,%ebx
  8025b8:	83 c4 10             	add    $0x10,%esp
  8025bb:	85 c0                	test   %eax,%eax
  8025bd:	0f 88 82 00 00 00    	js     802645 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025c3:	83 ec 0c             	sub    $0xc,%esp
  8025c6:	ff 75 f0             	pushl  -0x10(%ebp)
  8025c9:	e8 e6 ea ff ff       	call   8010b4 <fd2data>
  8025ce:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8025d5:	50                   	push   %eax
  8025d6:	6a 00                	push   $0x0
  8025d8:	56                   	push   %esi
  8025d9:	6a 00                	push   $0x0
  8025db:	e8 32 e8 ff ff       	call   800e12 <sys_page_map>
  8025e0:	89 c3                	mov    %eax,%ebx
  8025e2:	83 c4 20             	add    $0x20,%esp
  8025e5:	85 c0                	test   %eax,%eax
  8025e7:	78 4e                	js     802637 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  8025e9:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8025ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f1:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8025f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f6:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8025fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802600:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802602:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802605:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80260c:	83 ec 0c             	sub    $0xc,%esp
  80260f:	ff 75 f4             	pushl  -0xc(%ebp)
  802612:	e8 8d ea ff ff       	call   8010a4 <fd2num>
  802617:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80261a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80261c:	83 c4 04             	add    $0x4,%esp
  80261f:	ff 75 f0             	pushl  -0x10(%ebp)
  802622:	e8 7d ea ff ff       	call   8010a4 <fd2num>
  802627:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80262a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80262d:	83 c4 10             	add    $0x10,%esp
  802630:	bb 00 00 00 00       	mov    $0x0,%ebx
  802635:	eb 2e                	jmp    802665 <pipe+0x141>
	sys_page_unmap(0, va);
  802637:	83 ec 08             	sub    $0x8,%esp
  80263a:	56                   	push   %esi
  80263b:	6a 00                	push   $0x0
  80263d:	e8 12 e8 ff ff       	call   800e54 <sys_page_unmap>
  802642:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802645:	83 ec 08             	sub    $0x8,%esp
  802648:	ff 75 f0             	pushl  -0x10(%ebp)
  80264b:	6a 00                	push   $0x0
  80264d:	e8 02 e8 ff ff       	call   800e54 <sys_page_unmap>
  802652:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802655:	83 ec 08             	sub    $0x8,%esp
  802658:	ff 75 f4             	pushl  -0xc(%ebp)
  80265b:	6a 00                	push   $0x0
  80265d:	e8 f2 e7 ff ff       	call   800e54 <sys_page_unmap>
  802662:	83 c4 10             	add    $0x10,%esp
}
  802665:	89 d8                	mov    %ebx,%eax
  802667:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80266a:	5b                   	pop    %ebx
  80266b:	5e                   	pop    %esi
  80266c:	5d                   	pop    %ebp
  80266d:	c3                   	ret    

0080266e <pipeisclosed>:
{
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
  802671:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802674:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802677:	50                   	push   %eax
  802678:	ff 75 08             	pushl  0x8(%ebp)
  80267b:	e8 9d ea ff ff       	call   80111d <fd_lookup>
  802680:	83 c4 10             	add    $0x10,%esp
  802683:	85 c0                	test   %eax,%eax
  802685:	78 18                	js     80269f <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802687:	83 ec 0c             	sub    $0xc,%esp
  80268a:	ff 75 f4             	pushl  -0xc(%ebp)
  80268d:	e8 22 ea ff ff       	call   8010b4 <fd2data>
	return _pipeisclosed(fd, p);
  802692:	89 c2                	mov    %eax,%edx
  802694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802697:	e8 2f fd ff ff       	call   8023cb <_pipeisclosed>
  80269c:	83 c4 10             	add    $0x10,%esp
}
  80269f:	c9                   	leave  
  8026a0:	c3                   	ret    

008026a1 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8026a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a6:	c3                   	ret    

008026a7 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026a7:	55                   	push   %ebp
  8026a8:	89 e5                	mov    %esp,%ebp
  8026aa:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8026ad:	68 2e 32 80 00       	push   $0x80322e
  8026b2:	ff 75 0c             	pushl  0xc(%ebp)
  8026b5:	e8 23 e3 ff ff       	call   8009dd <strcpy>
	return 0;
}
  8026ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8026bf:	c9                   	leave  
  8026c0:	c3                   	ret    

008026c1 <devcons_write>:
{
  8026c1:	55                   	push   %ebp
  8026c2:	89 e5                	mov    %esp,%ebp
  8026c4:	57                   	push   %edi
  8026c5:	56                   	push   %esi
  8026c6:	53                   	push   %ebx
  8026c7:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8026cd:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8026d2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8026d8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8026db:	73 31                	jae    80270e <devcons_write+0x4d>
		m = n - tot;
  8026dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026e0:	29 f3                	sub    %esi,%ebx
  8026e2:	83 fb 7f             	cmp    $0x7f,%ebx
  8026e5:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8026ea:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8026ed:	83 ec 04             	sub    $0x4,%esp
  8026f0:	53                   	push   %ebx
  8026f1:	89 f0                	mov    %esi,%eax
  8026f3:	03 45 0c             	add    0xc(%ebp),%eax
  8026f6:	50                   	push   %eax
  8026f7:	57                   	push   %edi
  8026f8:	e8 6e e4 ff ff       	call   800b6b <memmove>
		sys_cputs(buf, m);
  8026fd:	83 c4 08             	add    $0x8,%esp
  802700:	53                   	push   %ebx
  802701:	57                   	push   %edi
  802702:	e8 0c e6 ff ff       	call   800d13 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802707:	01 de                	add    %ebx,%esi
  802709:	83 c4 10             	add    $0x10,%esp
  80270c:	eb ca                	jmp    8026d8 <devcons_write+0x17>
}
  80270e:	89 f0                	mov    %esi,%eax
  802710:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802713:	5b                   	pop    %ebx
  802714:	5e                   	pop    %esi
  802715:	5f                   	pop    %edi
  802716:	5d                   	pop    %ebp
  802717:	c3                   	ret    

00802718 <devcons_read>:
{
  802718:	55                   	push   %ebp
  802719:	89 e5                	mov    %esp,%ebp
  80271b:	83 ec 08             	sub    $0x8,%esp
  80271e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802723:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802727:	74 21                	je     80274a <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802729:	e8 03 e6 ff ff       	call   800d31 <sys_cgetc>
  80272e:	85 c0                	test   %eax,%eax
  802730:	75 07                	jne    802739 <devcons_read+0x21>
		sys_yield();
  802732:	e8 79 e6 ff ff       	call   800db0 <sys_yield>
  802737:	eb f0                	jmp    802729 <devcons_read+0x11>
	if (c < 0)
  802739:	78 0f                	js     80274a <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80273b:	83 f8 04             	cmp    $0x4,%eax
  80273e:	74 0c                	je     80274c <devcons_read+0x34>
	*(char*)vbuf = c;
  802740:	8b 55 0c             	mov    0xc(%ebp),%edx
  802743:	88 02                	mov    %al,(%edx)
	return 1;
  802745:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80274a:	c9                   	leave  
  80274b:	c3                   	ret    
		return 0;
  80274c:	b8 00 00 00 00       	mov    $0x0,%eax
  802751:	eb f7                	jmp    80274a <devcons_read+0x32>

00802753 <cputchar>:
{
  802753:	55                   	push   %ebp
  802754:	89 e5                	mov    %esp,%ebp
  802756:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802759:	8b 45 08             	mov    0x8(%ebp),%eax
  80275c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80275f:	6a 01                	push   $0x1
  802761:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802764:	50                   	push   %eax
  802765:	e8 a9 e5 ff ff       	call   800d13 <sys_cputs>
}
  80276a:	83 c4 10             	add    $0x10,%esp
  80276d:	c9                   	leave  
  80276e:	c3                   	ret    

0080276f <getchar>:
{
  80276f:	55                   	push   %ebp
  802770:	89 e5                	mov    %esp,%ebp
  802772:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802775:	6a 01                	push   $0x1
  802777:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80277a:	50                   	push   %eax
  80277b:	6a 00                	push   $0x0
  80277d:	e8 0b ec ff ff       	call   80138d <read>
	if (r < 0)
  802782:	83 c4 10             	add    $0x10,%esp
  802785:	85 c0                	test   %eax,%eax
  802787:	78 06                	js     80278f <getchar+0x20>
	if (r < 1)
  802789:	74 06                	je     802791 <getchar+0x22>
	return c;
  80278b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80278f:	c9                   	leave  
  802790:	c3                   	ret    
		return -E_EOF;
  802791:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802796:	eb f7                	jmp    80278f <getchar+0x20>

00802798 <iscons>:
{
  802798:	55                   	push   %ebp
  802799:	89 e5                	mov    %esp,%ebp
  80279b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80279e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027a1:	50                   	push   %eax
  8027a2:	ff 75 08             	pushl  0x8(%ebp)
  8027a5:	e8 73 e9 ff ff       	call   80111d <fd_lookup>
  8027aa:	83 c4 10             	add    $0x10,%esp
  8027ad:	85 c0                	test   %eax,%eax
  8027af:	78 11                	js     8027c2 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8027b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b4:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027ba:	39 10                	cmp    %edx,(%eax)
  8027bc:	0f 94 c0             	sete   %al
  8027bf:	0f b6 c0             	movzbl %al,%eax
}
  8027c2:	c9                   	leave  
  8027c3:	c3                   	ret    

008027c4 <opencons>:
{
  8027c4:	55                   	push   %ebp
  8027c5:	89 e5                	mov    %esp,%ebp
  8027c7:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8027ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027cd:	50                   	push   %eax
  8027ce:	e8 f8 e8 ff ff       	call   8010cb <fd_alloc>
  8027d3:	83 c4 10             	add    $0x10,%esp
  8027d6:	85 c0                	test   %eax,%eax
  8027d8:	78 3a                	js     802814 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8027da:	83 ec 04             	sub    $0x4,%esp
  8027dd:	68 07 04 00 00       	push   $0x407
  8027e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8027e5:	6a 00                	push   $0x0
  8027e7:	e8 e3 e5 ff ff       	call   800dcf <sys_page_alloc>
  8027ec:	83 c4 10             	add    $0x10,%esp
  8027ef:	85 c0                	test   %eax,%eax
  8027f1:	78 21                	js     802814 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027fc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8027fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802801:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802808:	83 ec 0c             	sub    $0xc,%esp
  80280b:	50                   	push   %eax
  80280c:	e8 93 e8 ff ff       	call   8010a4 <fd2num>
  802811:	83 c4 10             	add    $0x10,%esp
}
  802814:	c9                   	leave  
  802815:	c3                   	ret    

00802816 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802816:	55                   	push   %ebp
  802817:	89 e5                	mov    %esp,%ebp
  802819:	56                   	push   %esi
  80281a:	53                   	push   %ebx
  80281b:	8b 75 08             	mov    0x8(%ebp),%esi
  80281e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802821:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802824:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802826:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80282b:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80282e:	83 ec 0c             	sub    $0xc,%esp
  802831:	50                   	push   %eax
  802832:	e8 48 e7 ff ff       	call   800f7f <sys_ipc_recv>
	if(ret < 0){
  802837:	83 c4 10             	add    $0x10,%esp
  80283a:	85 c0                	test   %eax,%eax
  80283c:	78 2b                	js     802869 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80283e:	85 f6                	test   %esi,%esi
  802840:	74 0a                	je     80284c <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802842:	a1 08 50 80 00       	mov    0x805008,%eax
  802847:	8b 40 74             	mov    0x74(%eax),%eax
  80284a:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80284c:	85 db                	test   %ebx,%ebx
  80284e:	74 0a                	je     80285a <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802850:	a1 08 50 80 00       	mov    0x805008,%eax
  802855:	8b 40 78             	mov    0x78(%eax),%eax
  802858:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80285a:	a1 08 50 80 00       	mov    0x805008,%eax
  80285f:	8b 40 70             	mov    0x70(%eax),%eax
}
  802862:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802865:	5b                   	pop    %ebx
  802866:	5e                   	pop    %esi
  802867:	5d                   	pop    %ebp
  802868:	c3                   	ret    
		if(from_env_store)
  802869:	85 f6                	test   %esi,%esi
  80286b:	74 06                	je     802873 <ipc_recv+0x5d>
			*from_env_store = 0;
  80286d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802873:	85 db                	test   %ebx,%ebx
  802875:	74 eb                	je     802862 <ipc_recv+0x4c>
			*perm_store = 0;
  802877:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80287d:	eb e3                	jmp    802862 <ipc_recv+0x4c>

0080287f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80287f:	55                   	push   %ebp
  802880:	89 e5                	mov    %esp,%ebp
  802882:	57                   	push   %edi
  802883:	56                   	push   %esi
  802884:	53                   	push   %ebx
  802885:	83 ec 0c             	sub    $0xc,%esp
  802888:	8b 7d 08             	mov    0x8(%ebp),%edi
  80288b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80288e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802891:	85 db                	test   %ebx,%ebx
  802893:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802898:	0f 44 d8             	cmove  %eax,%ebx
  80289b:	eb 05                	jmp    8028a2 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80289d:	e8 0e e5 ff ff       	call   800db0 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8028a2:	ff 75 14             	pushl  0x14(%ebp)
  8028a5:	53                   	push   %ebx
  8028a6:	56                   	push   %esi
  8028a7:	57                   	push   %edi
  8028a8:	e8 af e6 ff ff       	call   800f5c <sys_ipc_try_send>
  8028ad:	83 c4 10             	add    $0x10,%esp
  8028b0:	85 c0                	test   %eax,%eax
  8028b2:	74 1b                	je     8028cf <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8028b4:	79 e7                	jns    80289d <ipc_send+0x1e>
  8028b6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8028b9:	74 e2                	je     80289d <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8028bb:	83 ec 04             	sub    $0x4,%esp
  8028be:	68 3a 32 80 00       	push   $0x80323a
  8028c3:	6a 46                	push   $0x46
  8028c5:	68 4f 32 80 00       	push   $0x80324f
  8028ca:	e8 b9 d8 ff ff       	call   800188 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8028cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028d2:	5b                   	pop    %ebx
  8028d3:	5e                   	pop    %esi
  8028d4:	5f                   	pop    %edi
  8028d5:	5d                   	pop    %ebp
  8028d6:	c3                   	ret    

008028d7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8028d7:	55                   	push   %ebp
  8028d8:	89 e5                	mov    %esp,%ebp
  8028da:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8028dd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8028e2:	89 c2                	mov    %eax,%edx
  8028e4:	c1 e2 07             	shl    $0x7,%edx
  8028e7:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8028ed:	8b 52 50             	mov    0x50(%edx),%edx
  8028f0:	39 ca                	cmp    %ecx,%edx
  8028f2:	74 11                	je     802905 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8028f4:	83 c0 01             	add    $0x1,%eax
  8028f7:	3d 00 04 00 00       	cmp    $0x400,%eax
  8028fc:	75 e4                	jne    8028e2 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8028fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802903:	eb 0b                	jmp    802910 <ipc_find_env+0x39>
			return envs[i].env_id;
  802905:	c1 e0 07             	shl    $0x7,%eax
  802908:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80290d:	8b 40 48             	mov    0x48(%eax),%eax
}
  802910:	5d                   	pop    %ebp
  802911:	c3                   	ret    

00802912 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802912:	55                   	push   %ebp
  802913:	89 e5                	mov    %esp,%ebp
  802915:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802918:	89 d0                	mov    %edx,%eax
  80291a:	c1 e8 16             	shr    $0x16,%eax
  80291d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802924:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802929:	f6 c1 01             	test   $0x1,%cl
  80292c:	74 1d                	je     80294b <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80292e:	c1 ea 0c             	shr    $0xc,%edx
  802931:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802938:	f6 c2 01             	test   $0x1,%dl
  80293b:	74 0e                	je     80294b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80293d:	c1 ea 0c             	shr    $0xc,%edx
  802940:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802947:	ef 
  802948:	0f b7 c0             	movzwl %ax,%eax
}
  80294b:	5d                   	pop    %ebp
  80294c:	c3                   	ret    
  80294d:	66 90                	xchg   %ax,%ax
  80294f:	90                   	nop

00802950 <__udivdi3>:
  802950:	55                   	push   %ebp
  802951:	57                   	push   %edi
  802952:	56                   	push   %esi
  802953:	53                   	push   %ebx
  802954:	83 ec 1c             	sub    $0x1c,%esp
  802957:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80295b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80295f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802963:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802967:	85 d2                	test   %edx,%edx
  802969:	75 4d                	jne    8029b8 <__udivdi3+0x68>
  80296b:	39 f3                	cmp    %esi,%ebx
  80296d:	76 19                	jbe    802988 <__udivdi3+0x38>
  80296f:	31 ff                	xor    %edi,%edi
  802971:	89 e8                	mov    %ebp,%eax
  802973:	89 f2                	mov    %esi,%edx
  802975:	f7 f3                	div    %ebx
  802977:	89 fa                	mov    %edi,%edx
  802979:	83 c4 1c             	add    $0x1c,%esp
  80297c:	5b                   	pop    %ebx
  80297d:	5e                   	pop    %esi
  80297e:	5f                   	pop    %edi
  80297f:	5d                   	pop    %ebp
  802980:	c3                   	ret    
  802981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802988:	89 d9                	mov    %ebx,%ecx
  80298a:	85 db                	test   %ebx,%ebx
  80298c:	75 0b                	jne    802999 <__udivdi3+0x49>
  80298e:	b8 01 00 00 00       	mov    $0x1,%eax
  802993:	31 d2                	xor    %edx,%edx
  802995:	f7 f3                	div    %ebx
  802997:	89 c1                	mov    %eax,%ecx
  802999:	31 d2                	xor    %edx,%edx
  80299b:	89 f0                	mov    %esi,%eax
  80299d:	f7 f1                	div    %ecx
  80299f:	89 c6                	mov    %eax,%esi
  8029a1:	89 e8                	mov    %ebp,%eax
  8029a3:	89 f7                	mov    %esi,%edi
  8029a5:	f7 f1                	div    %ecx
  8029a7:	89 fa                	mov    %edi,%edx
  8029a9:	83 c4 1c             	add    $0x1c,%esp
  8029ac:	5b                   	pop    %ebx
  8029ad:	5e                   	pop    %esi
  8029ae:	5f                   	pop    %edi
  8029af:	5d                   	pop    %ebp
  8029b0:	c3                   	ret    
  8029b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029b8:	39 f2                	cmp    %esi,%edx
  8029ba:	77 1c                	ja     8029d8 <__udivdi3+0x88>
  8029bc:	0f bd fa             	bsr    %edx,%edi
  8029bf:	83 f7 1f             	xor    $0x1f,%edi
  8029c2:	75 2c                	jne    8029f0 <__udivdi3+0xa0>
  8029c4:	39 f2                	cmp    %esi,%edx
  8029c6:	72 06                	jb     8029ce <__udivdi3+0x7e>
  8029c8:	31 c0                	xor    %eax,%eax
  8029ca:	39 eb                	cmp    %ebp,%ebx
  8029cc:	77 a9                	ja     802977 <__udivdi3+0x27>
  8029ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8029d3:	eb a2                	jmp    802977 <__udivdi3+0x27>
  8029d5:	8d 76 00             	lea    0x0(%esi),%esi
  8029d8:	31 ff                	xor    %edi,%edi
  8029da:	31 c0                	xor    %eax,%eax
  8029dc:	89 fa                	mov    %edi,%edx
  8029de:	83 c4 1c             	add    $0x1c,%esp
  8029e1:	5b                   	pop    %ebx
  8029e2:	5e                   	pop    %esi
  8029e3:	5f                   	pop    %edi
  8029e4:	5d                   	pop    %ebp
  8029e5:	c3                   	ret    
  8029e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029ed:	8d 76 00             	lea    0x0(%esi),%esi
  8029f0:	89 f9                	mov    %edi,%ecx
  8029f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8029f7:	29 f8                	sub    %edi,%eax
  8029f9:	d3 e2                	shl    %cl,%edx
  8029fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8029ff:	89 c1                	mov    %eax,%ecx
  802a01:	89 da                	mov    %ebx,%edx
  802a03:	d3 ea                	shr    %cl,%edx
  802a05:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a09:	09 d1                	or     %edx,%ecx
  802a0b:	89 f2                	mov    %esi,%edx
  802a0d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a11:	89 f9                	mov    %edi,%ecx
  802a13:	d3 e3                	shl    %cl,%ebx
  802a15:	89 c1                	mov    %eax,%ecx
  802a17:	d3 ea                	shr    %cl,%edx
  802a19:	89 f9                	mov    %edi,%ecx
  802a1b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802a1f:	89 eb                	mov    %ebp,%ebx
  802a21:	d3 e6                	shl    %cl,%esi
  802a23:	89 c1                	mov    %eax,%ecx
  802a25:	d3 eb                	shr    %cl,%ebx
  802a27:	09 de                	or     %ebx,%esi
  802a29:	89 f0                	mov    %esi,%eax
  802a2b:	f7 74 24 08          	divl   0x8(%esp)
  802a2f:	89 d6                	mov    %edx,%esi
  802a31:	89 c3                	mov    %eax,%ebx
  802a33:	f7 64 24 0c          	mull   0xc(%esp)
  802a37:	39 d6                	cmp    %edx,%esi
  802a39:	72 15                	jb     802a50 <__udivdi3+0x100>
  802a3b:	89 f9                	mov    %edi,%ecx
  802a3d:	d3 e5                	shl    %cl,%ebp
  802a3f:	39 c5                	cmp    %eax,%ebp
  802a41:	73 04                	jae    802a47 <__udivdi3+0xf7>
  802a43:	39 d6                	cmp    %edx,%esi
  802a45:	74 09                	je     802a50 <__udivdi3+0x100>
  802a47:	89 d8                	mov    %ebx,%eax
  802a49:	31 ff                	xor    %edi,%edi
  802a4b:	e9 27 ff ff ff       	jmp    802977 <__udivdi3+0x27>
  802a50:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a53:	31 ff                	xor    %edi,%edi
  802a55:	e9 1d ff ff ff       	jmp    802977 <__udivdi3+0x27>
  802a5a:	66 90                	xchg   %ax,%ax
  802a5c:	66 90                	xchg   %ax,%ax
  802a5e:	66 90                	xchg   %ax,%ax

00802a60 <__umoddi3>:
  802a60:	55                   	push   %ebp
  802a61:	57                   	push   %edi
  802a62:	56                   	push   %esi
  802a63:	53                   	push   %ebx
  802a64:	83 ec 1c             	sub    $0x1c,%esp
  802a67:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802a6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a6f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802a73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a77:	89 da                	mov    %ebx,%edx
  802a79:	85 c0                	test   %eax,%eax
  802a7b:	75 43                	jne    802ac0 <__umoddi3+0x60>
  802a7d:	39 df                	cmp    %ebx,%edi
  802a7f:	76 17                	jbe    802a98 <__umoddi3+0x38>
  802a81:	89 f0                	mov    %esi,%eax
  802a83:	f7 f7                	div    %edi
  802a85:	89 d0                	mov    %edx,%eax
  802a87:	31 d2                	xor    %edx,%edx
  802a89:	83 c4 1c             	add    $0x1c,%esp
  802a8c:	5b                   	pop    %ebx
  802a8d:	5e                   	pop    %esi
  802a8e:	5f                   	pop    %edi
  802a8f:	5d                   	pop    %ebp
  802a90:	c3                   	ret    
  802a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a98:	89 fd                	mov    %edi,%ebp
  802a9a:	85 ff                	test   %edi,%edi
  802a9c:	75 0b                	jne    802aa9 <__umoddi3+0x49>
  802a9e:	b8 01 00 00 00       	mov    $0x1,%eax
  802aa3:	31 d2                	xor    %edx,%edx
  802aa5:	f7 f7                	div    %edi
  802aa7:	89 c5                	mov    %eax,%ebp
  802aa9:	89 d8                	mov    %ebx,%eax
  802aab:	31 d2                	xor    %edx,%edx
  802aad:	f7 f5                	div    %ebp
  802aaf:	89 f0                	mov    %esi,%eax
  802ab1:	f7 f5                	div    %ebp
  802ab3:	89 d0                	mov    %edx,%eax
  802ab5:	eb d0                	jmp    802a87 <__umoddi3+0x27>
  802ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802abe:	66 90                	xchg   %ax,%ax
  802ac0:	89 f1                	mov    %esi,%ecx
  802ac2:	39 d8                	cmp    %ebx,%eax
  802ac4:	76 0a                	jbe    802ad0 <__umoddi3+0x70>
  802ac6:	89 f0                	mov    %esi,%eax
  802ac8:	83 c4 1c             	add    $0x1c,%esp
  802acb:	5b                   	pop    %ebx
  802acc:	5e                   	pop    %esi
  802acd:	5f                   	pop    %edi
  802ace:	5d                   	pop    %ebp
  802acf:	c3                   	ret    
  802ad0:	0f bd e8             	bsr    %eax,%ebp
  802ad3:	83 f5 1f             	xor    $0x1f,%ebp
  802ad6:	75 20                	jne    802af8 <__umoddi3+0x98>
  802ad8:	39 d8                	cmp    %ebx,%eax
  802ada:	0f 82 b0 00 00 00    	jb     802b90 <__umoddi3+0x130>
  802ae0:	39 f7                	cmp    %esi,%edi
  802ae2:	0f 86 a8 00 00 00    	jbe    802b90 <__umoddi3+0x130>
  802ae8:	89 c8                	mov    %ecx,%eax
  802aea:	83 c4 1c             	add    $0x1c,%esp
  802aed:	5b                   	pop    %ebx
  802aee:	5e                   	pop    %esi
  802aef:	5f                   	pop    %edi
  802af0:	5d                   	pop    %ebp
  802af1:	c3                   	ret    
  802af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802af8:	89 e9                	mov    %ebp,%ecx
  802afa:	ba 20 00 00 00       	mov    $0x20,%edx
  802aff:	29 ea                	sub    %ebp,%edx
  802b01:	d3 e0                	shl    %cl,%eax
  802b03:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b07:	89 d1                	mov    %edx,%ecx
  802b09:	89 f8                	mov    %edi,%eax
  802b0b:	d3 e8                	shr    %cl,%eax
  802b0d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b11:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b15:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b19:	09 c1                	or     %eax,%ecx
  802b1b:	89 d8                	mov    %ebx,%eax
  802b1d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b21:	89 e9                	mov    %ebp,%ecx
  802b23:	d3 e7                	shl    %cl,%edi
  802b25:	89 d1                	mov    %edx,%ecx
  802b27:	d3 e8                	shr    %cl,%eax
  802b29:	89 e9                	mov    %ebp,%ecx
  802b2b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b2f:	d3 e3                	shl    %cl,%ebx
  802b31:	89 c7                	mov    %eax,%edi
  802b33:	89 d1                	mov    %edx,%ecx
  802b35:	89 f0                	mov    %esi,%eax
  802b37:	d3 e8                	shr    %cl,%eax
  802b39:	89 e9                	mov    %ebp,%ecx
  802b3b:	89 fa                	mov    %edi,%edx
  802b3d:	d3 e6                	shl    %cl,%esi
  802b3f:	09 d8                	or     %ebx,%eax
  802b41:	f7 74 24 08          	divl   0x8(%esp)
  802b45:	89 d1                	mov    %edx,%ecx
  802b47:	89 f3                	mov    %esi,%ebx
  802b49:	f7 64 24 0c          	mull   0xc(%esp)
  802b4d:	89 c6                	mov    %eax,%esi
  802b4f:	89 d7                	mov    %edx,%edi
  802b51:	39 d1                	cmp    %edx,%ecx
  802b53:	72 06                	jb     802b5b <__umoddi3+0xfb>
  802b55:	75 10                	jne    802b67 <__umoddi3+0x107>
  802b57:	39 c3                	cmp    %eax,%ebx
  802b59:	73 0c                	jae    802b67 <__umoddi3+0x107>
  802b5b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802b5f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802b63:	89 d7                	mov    %edx,%edi
  802b65:	89 c6                	mov    %eax,%esi
  802b67:	89 ca                	mov    %ecx,%edx
  802b69:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802b6e:	29 f3                	sub    %esi,%ebx
  802b70:	19 fa                	sbb    %edi,%edx
  802b72:	89 d0                	mov    %edx,%eax
  802b74:	d3 e0                	shl    %cl,%eax
  802b76:	89 e9                	mov    %ebp,%ecx
  802b78:	d3 eb                	shr    %cl,%ebx
  802b7a:	d3 ea                	shr    %cl,%edx
  802b7c:	09 d8                	or     %ebx,%eax
  802b7e:	83 c4 1c             	add    $0x1c,%esp
  802b81:	5b                   	pop    %ebx
  802b82:	5e                   	pop    %esi
  802b83:	5f                   	pop    %edi
  802b84:	5d                   	pop    %ebp
  802b85:	c3                   	ret    
  802b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b8d:	8d 76 00             	lea    0x0(%esi),%esi
  802b90:	89 da                	mov    %ebx,%edx
  802b92:	29 fe                	sub    %edi,%esi
  802b94:	19 c2                	sbb    %eax,%edx
  802b96:	89 f1                	mov    %esi,%ecx
  802b98:	89 c8                	mov    %ecx,%eax
  802b9a:	e9 4b ff ff ff       	jmp    802aea <__umoddi3+0x8a>
